Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20F611E9B6
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 19:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfLMSEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:04:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55027 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726404AbfLMSEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 13:04:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576260287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j8AKIspC9a6yPD8CZcAhFN+NK3j6yTlRhYzd2nd7cQw=;
        b=Jic1gbreBqQFe4JEhcNb8i8gujuQLi85MVq3CTt+X/rf0z9X59DE+fiKTUxIRhTuoVNKhT
        he3bTbU2A1Ru+nTL+w/hS/WktDpCCCs3rA92VLO9omnPDJ1IBnWTX8vaq6/rk2CN7f9Rar
        NeJ6t16xeE1MqVPKf+2umEG85qaK8O4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-vAkyOD8GN2qyVDJymDwEsQ-1; Fri, 13 Dec 2019 13:04:46 -0500
X-MC-Unique: vAkyOD8GN2qyVDJymDwEsQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAA831005502;
        Fri, 13 Dec 2019 18:04:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-115.brq.redhat.com [10.40.204.115])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D80A660BB3;
        Fri, 13 Dec 2019 18:04:26 +0000 (UTC)
Date:   Fri, 13 Dec 2019 19:04:19 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 10/18] arm/arm64: selftest: Add
 prefetch abort test
Message-ID: <20191213180419.vk6rd42hpexh6cow@kamzik.brq.redhat.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
 <20191128180418.6938-11-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128180418.6938-11-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 06:04:10PM +0000, Alexandru Elisei wrote:
> When a guest tries to execute code from MMIO memory, KVM injects an
> external abort into that guest. We have now fixed the psci test to not
> fetch instructions from the I/O region, and it's not that often that a
> guest misbehaves in such a way. Let's expand our coverage by adding a
> proper test targetting this corner case.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm64/asm/esr.h |   3 ++
>  arm/selftest.c      | 112 ++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 112 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
> index 8e5af4d90767..8c351631b0a0 100644
> --- a/lib/arm64/asm/esr.h
> +++ b/lib/arm64/asm/esr.h
> @@ -44,4 +44,7 @@
>  #define ESR_EL1_EC_BKPT32	(0x38)
>  #define ESR_EL1_EC_BRK64	(0x3C)
>  
> +#define ESR_EL1_FSC_MASK	(0x3F)
> +#define ESR_EL1_FSC_EXTABT	(0x10)
> +
>  #endif /* _ASMARM64_ESR_H_ */
> diff --git a/arm/selftest.c b/arm/selftest.c
> index e9dc5c0cab28..2512e011034f 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -16,6 +16,8 @@
>  #include <asm/psci.h>
>  #include <asm/smp.h>
>  #include <asm/barrier.h>
> +#include <asm/mmu.h>
> +#include <asm/pgtable.h>
>  
>  static cpumask_t ready, valid;
>  
> @@ -68,6 +70,7 @@ static void check_setup(int argc, char **argv)
>  static struct pt_regs expected_regs;
>  static bool und_works;
>  static bool svc_works;
> +static bool pabt_works;
>  #if defined(__arm__)
>  /*
>   * Capture the current register state and execute an instruction
> @@ -91,7 +94,7 @@ static bool svc_works;
>  		"str	r1, [r0, #" xstr(S_PC) "]\n"		\
>  		excptn_insn "\n"				\
>  		post_insns "\n"					\
> -	:: "r" (&expected_regs) : "r0", "r1")
> +	:: "r" (&expected_regs) : "r0", "r1", "r2")
>  
>  static bool check_regs(struct pt_regs *regs)
>  {
> @@ -171,6 +174,54 @@ static void user_psci_system_off(struct pt_regs *regs)
>  {
>  	__user_psci_system_off();
>  }
> +
> +static void check_pabt_exit(void)
> +{
> +	install_exception_handler(EXCPTN_PABT, NULL);
> +
> +	report("pabt", pabt_works);
> +	exit(report_summary());
> +}
> +
> +#define PABT_ADDR	((3ul << 30) - PAGE_SIZE)
> +static void pabt_handler(struct pt_regs *regs)
> +{
> +	expected_regs.ARM_pc = PABT_ADDR;
> +	pabt_works = check_regs(regs);
> +
> +	regs->ARM_pc = (unsigned long)&check_pabt_exit;
> +}
> +
> +static void check_pabt(void)
> +{
> +	unsigned long sctlr;
> +
> +	if (PABT_ADDR < __phys_end) {
> +		report_skip("pabt: physical memory overlap");
> +		return;
> +	}
> +
> +	mmu_set_range_ptes(current_thread_info()->pgtable, PABT_ADDR,
> +			PABT_ADDR, PABT_ADDR + PAGE_SIZE, __pgprot(PTE_WBWA));
> +
> +	/* Make sure we can actually execute from a writable region */
> +	asm volatile("mrc p15, 0, %0, c1, c0, 0": "=r" (sctlr));
> +	if (sctlr & CR_ST) {
> +		sctlr &= ~CR_ST;
> +		asm volatile("mcr p15, 0, %0, c1, c0, 0" :: "r" (sctlr));
> +		isb();
> +		/*
> +		 * Required according to the sequence in ARM DDI 0406C.d, page
> +		 * B3-1358.
> +		 */
> +		flush_tlb_all();
> +	}
> +
> +	install_exception_handler(EXCPTN_PABT, pabt_handler);
> +
> +	test_exception("ldr r2, =" xstr(PABT_ADDR), "bx r2", "");
> +	__builtin_unreachable();
> +}
>  #elif defined(__aarch64__)
>  
>  /*
> @@ -212,7 +263,7 @@ static void user_psci_system_off(struct pt_regs *regs)
>  		"stp	 x0,  x1, [x1]\n"			\
>  	"1:"	excptn_insn "\n"				\
>  		post_insns "\n"					\
> -	:: "r" (&expected_regs) : "x0", "x1")
> +	:: "r" (&expected_regs) : "x0", "x1", "x2")
>  
>  static bool check_regs(struct pt_regs *regs)
>  {
> @@ -288,6 +339,59 @@ static bool check_svc(void)
>  	return svc_works;
>  }
>  
> +static void check_pabt_exit(void)
> +{
> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
> +
> +	report("pabt", pabt_works);
> +	exit(report_summary());
> +}
> +
> +#define PABT_ADDR	((1ul << 38) - PAGE_SIZE)
> +static void pabt_handler(struct pt_regs *regs, unsigned int esr)
> +{
> +	bool is_extabt;
> +
> +	expected_regs.pc = PABT_ADDR;
> +	is_extabt = (esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT;
> +	pabt_works = check_regs(regs) && is_extabt;
> +
> +	regs->pc = (u64)&check_pabt_exit;
> +}
> +
> +static void check_pabt(void)
> +{
> +	enum vector v = check_vector_prep();
> +	unsigned long sctlr;
> +
> +	if (PABT_ADDR < __phys_end) {
> +		report_skip("pabt: physical memory overlap");
> +		return;
> +	}
> +
> +	/*
> +	 * According to ARM DDI 0487E.a, table D5-33, footnote c, all regions
> +	 * writable at EL0 are treated as PXN. Map the page without the user bit
> +	 * set.
> +	 */
> +	mmu_set_range_ptes(current_thread_info()->pgtable, PABT_ADDR,
> +			PABT_ADDR, PABT_ADDR + PAGE_SIZE, __pgprot(PTE_WBWA));
> +
> +	/* Make sure we can actually execute from a writable region */
> +	sctlr = read_sysreg(sctlr_el1);
> +	if (sctlr & SCTLR_EL1_WXN) {
> +		write_sysreg(sctlr & ~SCTLR_EL1_WXN, sctlr_el1);
> +		isb();
> +		/* SCTLR_EL1.WXN is permitted to be cached in a TLB. */
> +		flush_tlb_all();
> +	}
> +
> +	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
> +
> +	test_exception("ldr x2, =" xstr(PABT_ADDR), "br x2", "");

This line fails to compile with gcc 4.8.5[*]. I get

Error: unexpected characters following instruction at operand 2 -- `ldr x2,=((1ul<<38)-((1UL)<<16))'

But setting PABT_ADDR to 0x3fffff0000 (and arm's PABT_ADDR to 0xbfff0000) works.

[*] gcc version 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC)

Thanks,
drew


> +	__builtin_unreachable();
> +}
> +
>  static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
>  {
>  	__user_psci_system_off();
> @@ -298,7 +402,9 @@ static void check_vectors(void *arg __unused)
>  {
>  	report("und", check_und());
>  	report("svc", check_svc());
> -	if (is_user()) {
> +	if (!is_user()) {
> +		check_pabt();
> +	} else {
>  #ifdef __arm__
>  		install_exception_handler(EXCPTN_UND, user_psci_system_off);
>  #else
> -- 
> 2.20.1
> 

