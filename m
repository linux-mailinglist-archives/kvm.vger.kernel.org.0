Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB7E11EA90
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 19:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfLMSnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:43:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25214 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728800AbfLMSnH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 13:43:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576262585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i4Tktu9j+2d5Z6nug+l1ZsjAFJfjFRuHyVKsObPZ3P4=;
        b=RsF5J9INiYwUjzT2FIdoU8XFF2P8l9BdurDthQW+1I4B30iPdDBBfgSphYDbZqmc/B0jJR
        OY7iTp8yIZmuO0IM3NgnnqEn8WZDzcbSHZBEXTmYdWum2CE/wLidaOHEd7SseAv5DHFRYD
        FsMqHQfrnV8Zy7VKPEpdyeOmUPgtgNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-GdTTAXZCMrGhFF69x4JJaw-1; Fri, 13 Dec 2019 13:43:03 -0500
X-MC-Unique: GdTTAXZCMrGhFF69x4JJaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3BBB107ACC7;
        Fri, 13 Dec 2019 18:43:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-115.brq.redhat.com [10.40.204.115])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 812FB60BC2;
        Fri, 13 Dec 2019 18:42:55 +0000 (UTC)
Date:   Fri, 13 Dec 2019 19:42:47 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 15/18] arm/arm64: Perform dcache clean
 + invalidate after turning MMU off
Message-ID: <20191213184247.2j4s3llwp6zvkeuj@kamzik.brq.redhat.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
 <20191128180418.6938-16-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128180418.6938-16-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 06:04:15PM +0000, Alexandru Elisei wrote:
> When the MMU is off, data accesses are to Device nGnRnE memory on arm64 [1]
> or to Strongly-Ordered memory on arm [2]. This means that the accesses are
> non-cacheable.
> 
> Perform a dcache clean to PoC so we can read the newer values from the
> cache, instead of the stale values from memory.
> 
> Perform an invalidation so when we re-enable the MMU, we can access the
> data written to memory while the MMU was off, instead of potentially
> stale values from the cache.
> 
> Data caches are PIPT and the VAs are translated using the current
> translation tables, or an identity mapping (what Arm calls a "flat
> mapping") when the MMU is off [1], [2]. Do the clean + invalidate when the
> MMU is off so we don't depend on the current translation tables and we can
> make sure that the operation applies to the entire physical memory.
> 
> [1] ARM DDI 0487E.a, section D5.2.9
> [2] ARM DDI 0406C.d, section B3.2.1
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> 
> Tested with the following hack:
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index e9dc5c0cab28..7f29548bc468 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -350,10 +350,21 @@ static void cpu_report(void *data __unused)
>  	report_info("CPU%3d: MPIDR=%010" PRIx64, cpu, mpidr);
>  }
>  
> +#include <alloc_page.h>
> +#include <asm/mmu.h>
>  int main(int argc, char **argv)
>  {
> +	int *x = alloc_page();
> +
>  	report_prefix_push("selftest");
>  
> +	*x = 0x42;
> +	mmu_disable();
> +	report("read back value written with MMU on", *x == 0x42);
> +	*x = 0x50;
> +	mmu_enable(current_thread_info()->pgtable);
> +	report("read back value written with MMU off", *x == 0x50);
> +
>  	if (argc < 2)
>  		report_abort("no test specified");

When applying this patch the above hack also gets applied, and I'm
guessing that wasn't the intent. It can go above the ---, as it's useful
information.

Thanks,
drew

>  
> Without the fix, the first report fails, and the test usually hangs because
> mmu_enable pushes the LR register on the stack before asm_mmu_enable, which
> goes to memory, then pops it after asm_mmu_enable, and reads back garbage
> from the dcache.
> 
> With the fix, the two reports pass.
> 
>  lib/arm/asm/processor.h   |  6 ++++++
>  lib/arm64/asm/processor.h |  6 ++++++
>  lib/arm/processor.c       | 10 ++++++++++
>  lib/arm/setup.c           |  2 ++
>  lib/arm64/processor.c     | 11 +++++++++++
>  arm/cstart.S              | 22 ++++++++++++++++++++++
>  arm/cstart64.S            | 23 +++++++++++++++++++++++
>  7 files changed, 80 insertions(+)
> 
> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> index a8c4628da818..4684fb4755b3 100644
> --- a/lib/arm/asm/processor.h
> +++ b/lib/arm/asm/processor.h
> @@ -9,6 +9,11 @@
>  #include <asm/sysreg.h>
>  #include <asm/barrier.h>
>  
> +#define CTR_DMINLINE_SHIFT	16
> +#define CTR_DMINLINE_MASK	(0xf << 16)
> +#define CTR_DMINLINE(x)	\
> +	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
> +
>  enum vector {
>  	EXCPTN_RST,
>  	EXCPTN_UND,
> @@ -25,6 +30,7 @@ typedef void (*exception_fn)(struct pt_regs *);
>  extern void install_exception_handler(enum vector v, exception_fn fn);
>  
>  extern void show_regs(struct pt_regs *regs);
> +extern void init_dcache_line_size(void);
>  
>  static inline unsigned long current_cpsr(void)
>  {
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 1d9223f728a5..fd508c02f30d 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -16,6 +16,11 @@
>  #define SCTLR_EL1_A	(1 << 1)
>  #define SCTLR_EL1_M	(1 << 0)
>  
> +#define CTR_EL0_DMINLINE_SHIFT	16
> +#define CTR_EL0_DMINLINE_MASK	(0xf << 16)
> +#define CTR_EL0_DMINLINE(x)	\
> +	(((x) & CTR_EL0_DMINLINE_MASK) >> CTR_EL0_DMINLINE_SHIFT)
> +
>  #ifndef __ASSEMBLY__
>  #include <asm/ptrace.h>
>  #include <asm/esr.h>
> @@ -60,6 +65,7 @@ extern void vector_handlers_default_init(vector_fn *handlers);
>  
>  extern void show_regs(struct pt_regs *regs);
>  extern bool get_far(unsigned int esr, unsigned long *far);
> +extern void init_dcache_line_size(void);
>  
>  static inline unsigned long current_level(void)
>  {
> diff --git a/lib/arm/processor.c b/lib/arm/processor.c
> index 773337e6d3b7..c57657c5ea53 100644
> --- a/lib/arm/processor.c
> +++ b/lib/arm/processor.c
> @@ -25,6 +25,8 @@ static const char *vector_names[] = {
>  	"rst", "und", "svc", "pabt", "dabt", "addrexcptn", "irq", "fiq"
>  };
>  
> +unsigned int dcache_line_size;
> +
>  void show_regs(struct pt_regs *regs)
>  {
>  	unsigned long flags;
> @@ -145,3 +147,11 @@ bool is_user(void)
>  {
>  	return current_thread_info()->flags & TIF_USER_MODE;
>  }
> +void init_dcache_line_size(void)
> +{
> +	u32 ctr;
> +
> +	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
> +	/* DminLine is log2 of the number of words in the smallest cache line */
> +	dcache_line_size = 1 << (CTR_DMINLINE(ctr) + 2);
> +}
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 4f02fca85607..54fc19a20942 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -20,6 +20,7 @@
>  #include <asm/thread_info.h>
>  #include <asm/setup.h>
>  #include <asm/page.h>
> +#include <asm/processor.h>
>  #include <asm/smp.h>
>  
>  #include "io.h"
> @@ -63,6 +64,7 @@ static void cpu_init(void)
>  	ret = dt_for_each_cpu_node(cpu_set, NULL);
>  	assert(ret == 0);
>  	set_cpu_online(0, true);
> +	init_dcache_line_size();
>  }
>  
>  static void mem_init(phys_addr_t freemem_start)
> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> index 2a024e3f4e9d..f28066d40145 100644
> --- a/lib/arm64/processor.c
> +++ b/lib/arm64/processor.c
> @@ -62,6 +62,8 @@ static const char *ec_names[EC_MAX] = {
>  	[ESR_EL1_EC_BRK64]		= "BRK64",
>  };
>  
> +unsigned int dcache_line_size;
> +
>  void show_regs(struct pt_regs *regs)
>  {
>  	int i;
> @@ -257,3 +259,12 @@ bool is_user(void)
>  {
>  	return current_thread_info()->flags & TIF_USER_MODE;
>  }
> +
> +void init_dcache_line_size(void)
> +{
> +	u64 ctr;
> +
> +	ctr = read_sysreg(ctr_el0);
> +	/* DminLine is log2 of the number of words in the smallest cache line */
> +	dcache_line_size = 1 << (CTR_EL0_DMINLINE(ctr) + 2);
> +}
> diff --git a/arm/cstart.S b/arm/cstart.S
> index dfef48e4dbb2..3c2a3bcde61a 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -188,6 +188,20 @@ asm_mmu_enable:
>  
>  	mov     pc, lr
>  
> +.macro dcache_clean_inval domain, start, end, tmp1, tmp2
> +	ldr	\tmp1, =dcache_line_size
> +	ldr	\tmp1, [\tmp1]
> +	sub	\tmp2, \tmp1, #1
> +	bic	\start, \start, \tmp2
> +9998:
> +	/* DCCIMVAC */
> +	mcr	p15, 0, \start, c7, c14, 1
> +	add	\start, \start, \tmp1
> +	cmp	\start, \end
> +	blo	9998b
> +	dsb	\domain
> +.endm
> +
>  .globl asm_mmu_disable
>  asm_mmu_disable:
>  	/* SCTLR */
> @@ -195,6 +209,14 @@ asm_mmu_disable:
>  	bic	r0, #CR_M
>  	mcr	p15, 0, r0, c1, c0, 0
>  	isb
> +
> +	ldr	r0, =__phys_offset
> +	ldr	r0, [r0]
> +	ldr	r1, =__phys_end
> +	ldr	r1, [r1]
> +	dcache_clean_inval sy, r0, r1, r2, r3
> +	isb
> +
>  	mov     pc, lr
>  
>  /*
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index c98842f11e90..f41ffa3bc6c2 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -201,12 +201,35 @@ asm_mmu_enable:
>  
>  	ret
>  
> +/* Taken with small changes from arch/arm64/incluse/asm/assembler.h */
> +.macro dcache_by_line_op op, domain, start, end, tmp1, tmp2
> +	adrp	\tmp1, dcache_line_size
> +	ldr	\tmp1, [\tmp1, :lo12:dcache_line_size]
> +	sub	\tmp2, \tmp1, #1
> +	bic	\start, \start, \tmp2
> +9998:
> +	dc	\op , \start
> +	add	\start, \start, \tmp1
> +	cmp	\start, \end
> +	b.lo	9998b
> +	dsb	\domain
> +.endm
> +
>  .globl asm_mmu_disable
>  asm_mmu_disable:
>  	mrs	x0, sctlr_el1
>  	bic	x0, x0, SCTLR_EL1_M
>  	msr	sctlr_el1, x0
>  	isb
> +
> +	/* Clean + invalidate the entire memory */
> +	adrp	x0, __phys_offset
> +	ldr	x0, [x0, :lo12:__phys_offset]
> +	adrp	x1, __phys_end
> +	ldr	x1, [x1, :lo12:__phys_end]
> +	dcache_by_line_op civac, sy, x0, x1, x2, x3
> +	isb
> +
>  	ret
>  
>  /*
> -- 
> 2.20.1
> 

