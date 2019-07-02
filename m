Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1F25D3E2
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfGBQIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:08:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44356 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGBQIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:08:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id e3so8951116wrs.11
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lbH8SLu7qXtWW5VPpj+DHkUFWwjyY2aB8KNdg8QOdmo=;
        b=nS45cgjHGORmA7qennOgghAvO6a1bW2XArFSi0jGWdW9bqPFRPhGRfqRUMsn/LoVcQ
         XWOqw+2VmQl/V6plSaT0QEP7mhxQwsHIIXWvrZUSzt8Aa441svoU7z5GihD9UKj2gDyF
         Z889TTKOp8cd4VdjU3BglLwlDCwusZlxeon0YKwrV276ZNeEa0CZyvVOU6rcuLqJxiOD
         u3aH6r6Iv0HeWkLFlFl8Y/a0Ss7FknDzysTPSMktuL/m4MmzNDB8DnK/x+HsEKDyl02K
         7OfaEoTwGKHZnXS1N2LpXqqigqOs3DbN6SNRl8hpcVDKEI5pWFDVtVmkJQ9BHr/xV+H9
         n87g==
X-Gm-Message-State: APjAAAXt3pEg4u8JJ2TeSgCzbtLiEBDmIelC4FLRe0sG/hXFcqHAEQb5
        06uJeUg28uYBLytJU7xYdCWB3iBIq3M=
X-Google-Smtp-Source: APXvYqy4U8gM0/9mDsR8cRgM2/6NM4o4AdHVwlkG4i5xreY3423U7CzKH5vAd8dXVyu5dz23CsKX+w==
X-Received: by 2002:a5d:63cb:: with SMTP id c11mr24269637wrw.65.1562083713751;
        Tue, 02 Jul 2019 09:08:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id v67sm4434206wme.24.2019.07.02.09.08.32
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:08:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
Date:   Tue, 2 Jul 2019 18:08:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628203019.3220-4-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/06/19 22:30, Nadav Amit wrote:
> Enable to run the tests when test-device is not present (e.g.,
> bare-metal). Users can provide the number of CPUs and ram size through
> kernel parameters.
> 
> On Ubuntu, for example, the tests can be run by copying a test to the
> boot directory (/boot) and adding a menuentry to grub (editing
> /etc/grub.d/40_custom):
> 
>   menuentry 'idt_test' {
> 	set root='ROOT'
> 	multiboot BOOT_RELATIVE/idt_test.flat ignore nb_cpus=48 \
> 		ram_size=4294967296 no-test-device
>   }
> 
> Replace ROOT with `grub-probe --target=bios_hints /boot` and
> BOOT_RELATIVE with `grub-mkrelpath /boot`, and run update-grub.
> 
> Note that the first kernel parameter is ignored for compatibility with
> test executions through QEMU.
> 
> Remember that the output goes to the serial port.

RAM size can use the multiboot info (see lib/x86/setup.c).

For the # of CPUs I'm not sure what you're supposed to do on bare metal
though. :)

Paolo

> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/x86/fwcfg.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/x86/fwcfg.h |  4 ++++
>  x86/apic.c      |  4 +++-
>  x86/cstart64.S  | 13 ++++++++---
>  x86/eventinj.c  | 20 ++++++++++++----
>  x86/vmx_tests.c |  7 ++++++
>  6 files changed, 102 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
> index c52b445..8d320e2 100644
> --- a/lib/x86/fwcfg.c
> +++ b/lib/x86/fwcfg.c
> @@ -1,14 +1,76 @@
>  #include "fwcfg.h"
>  #include "smp.h"
> +#include "libcflat.h"
>  
>  static struct spinlock lock;
>  
> +struct fw_override_val {
> +	bool initialized;
> +	uint64_t val;
> +};
> +
> +static struct fw_override_val fw_override[FW_CFG_MAX_ENTRY];
> +
> +static const char *cfg_names[FW_CFG_MAX_ENTRY] = {
> +	[FW_CFG_NB_CPUS] = "nb_cpus",
> +	[FW_CFG_RAM_SIZE] = "ram_size",
> +};
> +
> +bool no_test_device;
> +
> +void read_cfg_override(int argc, const char *argv[])
> +{
> +	int i, j;
> +
> +	/* Check if there is no test device */
> +	for (j = 0; j < argc; j++) {
> +		const char *arg = argv[j];
> +
> +		if (!strcmp("no-test-device", arg)) {
> +			no_test_device = true;
> +			continue;
> +		}
> +
> +		for (i = 0; i < FW_CFG_MAX_ENTRY; i++) {
> +			const char *cfg_name = cfg_names[i];
> +			size_t name_len;
> +
> +			name_len = strlen(cfg_name);
> +
> +			if (cfg_name == NULL)
> +				continue;
> +
> +			name_len = strlen(cfg_name);
> +
> +			if (strncmp(cfg_name, arg, name_len))
> +				continue;
> +			if (arg[name_len] != '=')
> +				continue;
> +			if (strlen(arg) <= name_len + 1)
> +				continue;
> +
> +			fw_override[i].val = atol(arg + name_len + 1);
> +			fw_override[i].initialized = true;
> +
> +			printf("cfg-override: %s = 0x%lx\n", cfg_name, fw_override[i].val);
> +		}
> +	}
> +}
> +
> +bool test_device_enabled(void)
> +{
> +	return !no_test_device;
> +}
> +
>  static uint64_t fwcfg_get_u(uint16_t index, int bytes)
>  {
>      uint64_t r = 0;
>      uint8_t b;
>      int i;
>  
> +    if (fw_override[index].initialized)
> +	    return fw_override[index].val;
> +
>      spin_lock(&lock);
>      asm volatile ("out %0, %1" : : "a"(index), "d"((uint16_t)BIOS_CFG_IOPORT));
>      for (i = 0; i < bytes; ++i) {
> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
> index e0836ca..14801d7 100644
> --- a/lib/x86/fwcfg.h
> +++ b/lib/x86/fwcfg.h
> @@ -2,6 +2,7 @@
>  #define FWCFG_H
>  
>  #include <stdint.h>
> +#include <stdbool.h>
>  
>  #define FW_CFG_SIGNATURE        0x00
>  #define FW_CFG_ID               0x01
> @@ -33,6 +34,9 @@
>  #define FW_CFG_SMBIOS_ENTRIES (FW_CFG_ARCH_LOCAL + 1)
>  #define FW_CFG_IRQ0_OVERRIDE (FW_CFG_ARCH_LOCAL + 2)
>  
> +void read_cfg_override(int argc, const char *argv[]);
> +bool test_device_enabled(void);
> +
>  uint8_t fwcfg_get_u8(unsigned index);
>  uint16_t fwcfg_get_u16(unsigned index);
>  uint32_t fwcfg_get_u32(unsigned index);
> diff --git a/x86/apic.c b/x86/apic.c
> index 7617351..f01a5e7 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -6,6 +6,7 @@
>  #include "isr.h"
>  #include "msr.h"
>  #include "atomic.h"
> +#include "fwcfg.h"
>  
>  #define MAX_TPR			0xf
>  
> @@ -655,7 +656,8 @@ int main(void)
>  
>      test_self_ipi();
>      test_physical_broadcast();
> -    test_pv_ipi();
> +    if (test_device_enabled())
> +        test_pv_ipi();
>  
>      test_sti_nmi();
>      test_multiple_nmi();
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 9d89887..cc7926a 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -244,9 +244,6 @@ start64:
>  	call load_tss
>  	call mask_pic_interrupts
>  	call enable_apic
> -	call save_id
> -	call smp_init
> -	call enable_x2apic
>  	mov mb_boot_info(%rip), %rbx
>  	mov %rbx, %rdi
>  	call setup_multiboot
> @@ -254,6 +251,16 @@ start64:
>  	mov mb_cmdline(%rbx), %eax
>  	mov %rax, __args(%rip)
>  	call __setup_args
> +
> +	/* read configuration override */
> +	mov __argc(%rip), %edi
> +	lea __argv(%rip), %rsi
> +	call read_cfg_override
> +
> +	call save_id
> +	call smp_init
> +	call enable_x2apic
> +
>  	mov __argc(%rip), %edi
>  	lea __argv(%rip), %rsi
>  	lea __environ(%rip), %rdx
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index 901b9db..9e4dbec 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -8,6 +8,7 @@
>  #include "vmalloc.h"
>  #include "alloc_page.h"
>  #include "delay.h"
> +#include "fwcfg.h"
>  
>  #ifdef __x86_64__
>  #  define R "r"
> @@ -28,10 +29,15 @@ static void apic_self_nmi(void)
>  	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
>  }
>  
> -#define flush_phys_addr(__s) outl(__s, 0xe4)
> +#define flush_phys_addr(__s) do {					\
> +		if (test_device_enabled())				\
> +			outl(__s, 0xe4);				\
> +	} while (0)
> +
>  #define flush_stack() do {						\
>  		int __l;						\
> -		flush_phys_addr(virt_to_phys(&__l));			\
> +		if (test_device_enabled())				\
> +			flush_phys_addr(virt_to_phys(&__l));		\
>  	} while (0)
>  
>  extern char isr_iret_ip[];
> @@ -136,6 +142,8 @@ extern void do_iret(ulong phys_stack, void *virt_stack);
>  // Return to same privilege level won't pop SS or SP, so
>  // save it in RDX while we run on the nested stack
>  
> +extern bool no_test_device;
> +
>  asm("do_iret:"
>  #ifdef __x86_64__
>  	"mov %rdi, %rax \n\t"		// phys_stack
> @@ -148,10 +156,14 @@ asm("do_iret:"
>  	"pushf"W" \n\t"
>  	"mov %cs, %ecx \n\t"
>  	"push"W" %"R "cx \n\t"
> -	"push"W" $1f \n\t"
> +	"push"W" $2f \n\t"
> +
> +	"cmpb $0, no_test_device\n\t"	// see if need to flush
> +	"jnz 1f\n\t"
>  	"outl %eax, $0xe4 \n\t"		// flush page
> +	"1: \n\t"
>  	"iret"W" \n\t"
> -	"1: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
> +	"2: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
>  	"ret\n\t"
>     );
>  
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index c51de1c..5709fa8 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8017,6 +8017,13 @@ static void vmx_apic_passthrough(bool set_irq_line_from_thread)
>  		return;
>  	}
>  
> +	/*
> +	 * Test device required for generating IRQs
> +	 */
> +	if (!test_device_enabled()) {
> +		report_skip(__func__);
> +		return;
> +	}
>  	u64 cpu_ctrl_0 = CPU_SECONDARY;
>  	u64 cpu_ctrl_1 = 0;
>  
> 

