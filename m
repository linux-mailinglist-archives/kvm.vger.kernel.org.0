Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DBD705C6
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbfGVQwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 12:52:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730740AbfGVQwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 12:52:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C14495D674;
        Mon, 22 Jul 2019 16:52:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB80E60600;
        Mon, 22 Jul 2019 16:52:39 +0000 (UTC)
Date:   Mon, 22 Jul 2019 18:52:37 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2] x86: Support environments without
 test-devices
Message-ID: <20190722165237.76ozqbt3gngnoka6@kamzik.brq.redhat.com>
References: <20190721122841.21416-1-nadav.amit@gmail.com>
 <20190722082702.rsjb3hick6524yoc@kamzik.brq.redhat.com>
 <B09DB17E-1B25-4C77-8B75-CE98A2288B42@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B09DB17E-1B25-4C77-8B75-CE98A2288B42@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 22 Jul 2019 16:52:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 22, 2019 at 09:48:13AM -0700, Nadav Amit wrote:
> > On Jul 22, 2019, at 1:27 AM, Andrew Jones <drjones@redhat.com> wrote:
> > 
> > On Sun, Jul 21, 2019 at 05:28:41AM -0700, Nadav Amit wrote:
> >> Enable to run the tests when test-device is not present (e.g.,
> >> bare-metal). Users can provide the number of CPUs and ram size through
> >> kernel parameters.
> >> 
> >> On Ubuntu, for example, the tests can be run by copying a test to the
> >> boot directory (/boot) and adding a menuentry to grub (editing
> >> /etc/grub.d/40_custom):
> >> 
> >>  menuentry 'idt_test' {
> >> 	set root='ROOT'
> >> 	multiboot BOOT_RELATIVE/idt_test.flat
> >> 	module params.initrd
> >>  }
> >> 
> >> Replace ROOT with `grub-probe --target=bios_hints /boot` and
> >> BOOT_RELATIVE with `grub-mkrelpath /boot`, and run update-grub.
> >> 
> >> params.initrd, which would be located on the boot directory should
> >> describe the machine. For example for a 4 core machines with 4GB of
> >> memory:
> >> 
> >>  NR_CPUS=4
> >>  MEMSIZE=4096
> >>  TEST_DEVICE=0
> >>  BOOTLOADER=1
> >> 
> >> Since we do not really use E820, using more than 4GB is likely to fail
> >> due to holes.
> >> 
> >> Remember that the output goes to the serial port.
> >> 
> >> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> >> 
> >> ---
> >> 
> >> v1->v2:
> >> * Using initrd to hold configuration override [Andrew]
> >> * Adapting vmx, tscdeadline_latency not to ignore the first argument
> >>   on native
> >> ---
> >> lib/x86/fwcfg.c           | 32 ++++++++++++++++++++++++++++++++
> >> lib/x86/fwcfg.h           | 16 ++++++++++++++++
> >> x86/apic.c                |  4 +++-
> >> x86/cstart64.S            |  8 ++++++--
> >> x86/eventinj.c            | 20 ++++++++++++++++----
> >> x86/tscdeadline_latency.c |  8 +++++---
> >> x86/vmx.c                 |  7 +++++--
> >> x86/vmx_tests.c           |  5 +++++
> >> 8 files changed, 88 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
> >> index c52b445..5f85acf 100644
> >> --- a/lib/x86/fwcfg.c
> >> +++ b/lib/x86/fwcfg.c
> >> @@ -1,14 +1,46 @@
> >> #include "fwcfg.h"
> >> #include "smp.h"
> >> +#include "libcflat.h"
> >> 
> >> static struct spinlock lock;
> >> 
> >> +static long fw_override[FW_CFG_MAX_ENTRY];
> >> +
> >> +bool no_test_device;
> >> +bool bootloader;
> >> +
> >> +void read_cfg_override(void)
> >> +{
> >> +	const char *str;
> >> +	int i;
> >> +
> >> +	/* Initialize to negative value that would be considered as invalid */
> >> +	for (i = 0; i < FW_CFG_MAX_ENTRY; i++)
> >> +		fw_override[i] = -1;
> >> +
> >> +	if ((str = getenv("NR_CPUS")))
> >> +		fw_override[FW_CFG_NB_CPUS] = atol(str);
> >> +
> >> +	/* MEMSIZE is in megabytes */
> >> +	if ((str = getenv("MEMSIZE")))
> >> +		fw_override[FW_CFG_RAM_SIZE] = atol(str) * 1024 * 1024;
> >> +
> >> +	if ((str = getenv("TEST_DEVICE")))
> >> +		no_test_device = !atol(str);
> >> +
> >> +	if ((str = getenv("BOOTLOADER")))
> >> +		bootloader = !!atol(str);
> >> +}
> >> +
> >> static uint64_t fwcfg_get_u(uint16_t index, int bytes)
> >> {
> >>     uint64_t r = 0;
> >>     uint8_t b;
> >>     int i;
> >> 
> >> +    if (fw_override[index] >= 0)
> >> +	    return fw_override[index];
> >> +
> >>     spin_lock(&lock);
> >>     asm volatile ("out %0, %1" : : "a"(index), "d"((uint16_t)BIOS_CFG_IOPORT));
> >>     for (i = 0; i < bytes; ++i) {
> >> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
> >> index e0836ca..587aa95 100644
> >> --- a/lib/x86/fwcfg.h
> >> +++ b/lib/x86/fwcfg.h
> >> @@ -2,6 +2,7 @@
> >> #define FWCFG_H
> >> 
> >> #include <stdint.h>
> >> +#include <stdbool.h>
> >> 
> >> #define FW_CFG_SIGNATURE        0x00
> >> #define FW_CFG_ID               0x01
> >> @@ -33,6 +34,21 @@
> >> #define FW_CFG_SMBIOS_ENTRIES (FW_CFG_ARCH_LOCAL + 1)
> >> #define FW_CFG_IRQ0_OVERRIDE (FW_CFG_ARCH_LOCAL + 2)
> >> 
> >> +extern bool no_test_device;
> >> +extern bool bootloader;
> >> +
> >> +void read_cfg_override(void);
> >> +
> >> +static inline bool test_device_enabled(void)
> >> +{
> >> +	return !no_test_device;
> >> +}
> >> +
> >> +static inline bool using_bootloader(void)
> >> +{
> >> +	return bootloader;
> >> +}
> >> +
> >> uint8_t fwcfg_get_u8(unsigned index);
> >> uint16_t fwcfg_get_u16(unsigned index);
> >> uint32_t fwcfg_get_u32(unsigned index);
> >> diff --git a/x86/apic.c b/x86/apic.c
> >> index 7617351..f01a5e7 100644
> >> --- a/x86/apic.c
> >> +++ b/x86/apic.c
> >> @@ -6,6 +6,7 @@
> >> #include "isr.h"
> >> #include "msr.h"
> >> #include "atomic.h"
> >> +#include "fwcfg.h"
> >> 
> >> #define MAX_TPR			0xf
> >> 
> >> @@ -655,7 +656,8 @@ int main(void)
> >> 
> >>     test_self_ipi();
> >>     test_physical_broadcast();
> >> -    test_pv_ipi();
> >> +    if (test_device_enabled())
> >> +        test_pv_ipi();
> >> 
> >>     test_sti_nmi();
> >>     test_multiple_nmi();
> >> diff --git a/x86/cstart64.S b/x86/cstart64.S
> >> index 1889c6b..23c1bd4 100644
> >> --- a/x86/cstart64.S
> >> +++ b/x86/cstart64.S
> >> @@ -246,8 +246,6 @@ start64:
> >> 	call mask_pic_interrupts
> >> 	call enable_apic
> >> 	call save_id
> >> -	call smp_init
> >> -	call enable_x2apic
> >> 	mov mb_boot_info(%rip), %rbx
> >> 	mov %rbx, %rdi
> >> 	call setup_multiboot
> >> @@ -255,6 +253,12 @@ start64:
> >> 	mov mb_cmdline(%rbx), %eax
> >> 	mov %rax, __args(%rip)
> >> 	call __setup_args
> > 
> > [Marking this place to reference below]
> > 
> >> +
> >> +	/* Read the configuration before running smp_init */
> >> +	call read_cfg_override
> >> +	call smp_init
> >> +	call enable_x2apic
> >> +
> >> 	mov __argc(%rip), %edi
> >> 	lea __argv(%rip), %rsi
> >> 	lea __environ(%rip), %rdx
> >> diff --git a/x86/eventinj.c b/x86/eventinj.c
> >> index 901b9db..9e4dbec 100644
> >> --- a/x86/eventinj.c
> >> +++ b/x86/eventinj.c
> >> @@ -8,6 +8,7 @@
> >> #include "vmalloc.h"
> >> #include "alloc_page.h"
> >> #include "delay.h"
> >> +#include "fwcfg.h"
> >> 
> >> #ifdef __x86_64__
> >> #  define R "r"
> >> @@ -28,10 +29,15 @@ static void apic_self_nmi(void)
> >> 	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
> >> }
> >> 
> >> -#define flush_phys_addr(__s) outl(__s, 0xe4)
> >> +#define flush_phys_addr(__s) do {					\
> >> +		if (test_device_enabled())				\
> >> +			outl(__s, 0xe4);				\
> >> +	} while (0)
> >> +
> >> #define flush_stack() do {						\
> >> 		int __l;						\
> >> -		flush_phys_addr(virt_to_phys(&__l));			\
> >> +		if (test_device_enabled())				\
> >> +			flush_phys_addr(virt_to_phys(&__l));		\
> > 
> > nit: This shouldn't be necessary as the condition is already embedded.
> 
> Indeed. Will fix.
> 
> > 
> >> } while (0)
> >> 
> >> extern char isr_iret_ip[];
> >> @@ -136,6 +142,8 @@ extern void do_iret(ulong phys_stack, void *virt_stack);
> >> // Return to same privilege level won't pop SS or SP, so
> >> // save it in RDX while we run on the nested stack
> >> 
> >> +extern bool no_test_device;
> >> +
> >> asm("do_iret:"
> >> #ifdef __x86_64__
> >> 	"mov %rdi, %rax \n\t"		// phys_stack
> >> @@ -148,10 +156,14 @@ asm("do_iret:"
> >> 	"pushf"W" \n\t"
> >> 	"mov %cs, %ecx \n\t"
> >> 	"push"W" %"R "cx \n\t"
> >> -	"push"W" $1f \n\t"
> >> +	"push"W" $2f \n\t"
> >> +
> >> +	"cmpb $0, no_test_device\n\t"	// see if need to flush
> >> +	"jnz 1f\n\t"
> >> 	"outl %eax, $0xe4 \n\t"		// flush page
> >> +	"1: \n\t"
> >> 	"iret"W" \n\t"
> >> -	"1: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
> >> +	"2: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
> >> 	"ret\n\t"
> >>    );
> >> 
> >> diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
> >> index 4ee5917..4a9889a 100644
> >> --- a/x86/tscdeadline_latency.c
> >> +++ b/x86/tscdeadline_latency.c
> >> @@ -21,6 +21,7 @@
> >>  */
> >> 
> >> #include "libcflat.h"
> >> +#include "fwcfg.h"
> >> #include "apic.h"
> >> #include "vm.h"
> >> #include "smp.h"
> >> @@ -103,6 +104,7 @@ static void test_tsc_deadline_timer(void)
> >> int main(int argc, char **argv)
> >> {
> >>     int i, size;
> >> +    int first_arg = using_bootloader() ? 0 : 1;
> >> 
> >>     setup_vm();
> >>     smp_init();
> >> @@ -111,9 +113,9 @@ int main(int argc, char **argv)
> >> 
> >>     mask_pic_interrupts();
> >> 
> >> -    delta = argc <= 1 ? 200000 : atol(argv[1]);
> >> -    size = argc <= 2 ? TABLE_SIZE : atol(argv[2]);
> >> -    breakmax = argc <= 3 ? 0 : atol(argv[3]);
> >> +    delta = argc <= first_arg + 1 ? 200000 : atol(argv[first_arg + 1]);
> >> +    size = argc <= first_arg + 2 ? TABLE_SIZE : atol(argv[first_arg + 2]);
> >> +    breakmax = argc <= first_arg + 3 ? 0 : atol(argv[first_arg + 3]);
> >>     printf("breakmax=%d\n", breakmax);
> >>     test_tsc_deadline_timer();
> >>     irq_enable();
> >> diff --git a/x86/vmx.c b/x86/vmx.c
> >> index 872ba11..a10b0fb 100644
> >> --- a/x86/vmx.c
> >> +++ b/x86/vmx.c
> >> @@ -29,6 +29,7 @@
> >>  */
> >> 
> >> #include "libcflat.h"
> >> +#include "fwcfg.h"
> >> #include "processor.h"
> >> #include "alloc_page.h"
> >> #include "vm.h"
> >> @@ -1919,8 +1920,10 @@ int main(int argc, const char *argv[])
> >> 	/* We want xAPIC mode to test MMIO passthrough from L1 (us) to L2.  */
> >> 	reset_apic();
> >> 
> >> -	argv++;
> >> -	argc--;
> >> +	if (!using_bootloader()) {
> >> +		argv++;
> >> +		argc--;
> >> +	}
> > 
> > If you read the cfg overrides before calling __setup_args (marked above),
> > then you could conditionally call __setup_args, as is done now, when
> > using_booloader() is true, but when it's false, you could create a fake
> > auxinfo.progname, and then call setup_args_progname instead. That would
> > provide you a first arg, of whatever the fake auxinfo.progname is, and
> > then you can avoid shuffling args in the unit tests.
> 
> It is the other way around - when running with a bootloader, I would need to 
> call setup_args_progname().
> 
> Anyhow, I can try doing something along the lines you suggested. I would
> like to do one thing differently - are you ok with moving the bootloader
> check into setup_args() instead? It is only used by x86 setup_env() at the
> moment and I think it should make sense in general, and it would simplify
> the code.
>

That sounds good to me.

Thanks,
drew
