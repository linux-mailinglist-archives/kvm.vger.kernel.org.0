Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF54143E28
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAUNlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:41:01 -0500
Received: from foss.arm.com ([217.140.110.172]:43352 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgAUNlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 08:41:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF7EB30E;
        Tue, 21 Jan 2020 05:41:00 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FCA83F52E;
        Tue, 21 Jan 2020 05:41:00 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests 3/3] arm/arm64: selftest: Add prefetch
 abort test
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
References: <20200121131745.7199-1-drjones@redhat.com>
 <20200121131745.7199-4-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <afceda4b-e610-a92c-9b4c-5c4a8142a269@arm.com>
Date:   Tue, 21 Jan 2020 13:40:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200121131745.7199-4-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/21/20 1:17 PM, Andrew Jones wrote:
> When a guest tries to execute code from an invalid physical address
> KVM should inject an external abort. This test is based on a test
> originally posted by Alexandru Elisei. This version avoids hard
> coding the invalid physical address used.
>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/selftest.c      | 94 +++++++++++++++++++++++++++++++++++++++++++++
>  lib/arm64/asm/esr.h |  3 ++
>  2 files changed, 97 insertions(+)
>
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 6d74fa1fa4c4..4495b161cdd5 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -8,6 +8,7 @@
>  #include <libcflat.h>
>  #include <util.h>
>  #include <devicetree.h>
> +#include <vmalloc.h>
>  #include <asm/setup.h>
>  #include <asm/ptrace.h>
>  #include <asm/asm-offsets.h>
> @@ -15,6 +16,7 @@
>  #include <asm/thread_info.h>
>  #include <asm/psci.h>
>  #include <asm/smp.h>
> +#include <asm/mmu.h>
>  #include <asm/barrier.h>
>  
>  static cpumask_t ready, valid;
> @@ -65,9 +67,43 @@ static void check_setup(int argc, char **argv)
>  		report_abort("missing input");
>  }
>  
> +unsigned long check_pabt_invalid_paddr;
> +static bool check_pabt_init(void)
> +{
> +	phys_addr_t highest_end = 0;
> +	unsigned long vaddr;
> +	struct mem_region *r;
> +
> +	/*
> +	 * We need a physical address that isn't backed by anything. Without
> +	 * fully parsing the device tree there's no way to be certain of any
> +	 * address, but an unknown address immediately following the highest
> +	 * memory region has a reasonable chance. This is because we can
> +	 * assume that that memory region could have been larger, if the user
> +	 * had configured more RAM, and therefore no MMIO region should be
> +	 * there.
> +	 */
> +	for (r = mem_regions; r->end; ++r) {
> +		if (r->flags & MR_F_IO)
> +			continue;
> +		if (r->end > highest_end)
> +			highest_end = PAGE_ALIGN(r->end);
> +	}
> +
> +	if (mem_region_get_flags(highest_end) != MR_F_UNKNOWN)
> +		return false;
> +
> +	vaddr = (unsigned long)vmap(highest_end, PAGE_SIZE);
> +	mmu_clear_user(current_thread_info()->pgtable, vaddr);
> +	check_pabt_invalid_paddr = vaddr;
> +
> +	return true;
> +}
> +
>  static struct pt_regs expected_regs;
>  static bool und_works;
>  static bool svc_works;
> +static bool pabt_works;
>  #if defined(__arm__)
>  /*
>   * Capture the current register state and execute an instruction
> @@ -166,6 +202,30 @@ static bool check_svc(void)
>  	return svc_works;
>  }
>  
> +static void pabt_handler(struct pt_regs *regs)
> +{
> +	expected_regs.ARM_lr = expected_regs.ARM_pc;
> +	expected_regs.ARM_pc = expected_regs.ARM_r9;
> +
> +	pabt_works = check_regs(regs);
> +
> +	regs->ARM_pc = regs->ARM_lr;
> +}
> +
> +static bool check_pabt(void)
> +{
> +	install_exception_handler(EXCPTN_PABT, pabt_handler);
> +
> +	test_exception("ldr	r9, =check_pabt_invalid_paddr\n"
> +		       "ldr	r9, [r9]\n",
> +		       "blx	r9\n",
> +		       "", "r9", "lr");
> +
> +	install_exception_handler(EXCPTN_PABT, NULL);
> +
> +	return pabt_works;
> +}
> +
>  static void user_psci_system_off(struct pt_regs *regs)
>  {
>  	__user_psci_system_off();
> @@ -285,6 +345,35 @@ static bool check_svc(void)
>  	return svc_works;
>  }
>  
> +static void pabt_handler(struct pt_regs *regs, unsigned int esr)
> +{
> +	bool is_extabt = (esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT;
> +
> +	expected_regs.regs[30] = expected_regs.pc + 4;
> +	expected_regs.pc = expected_regs.regs[9];
> +
> +	pabt_works = check_regs(regs) && is_extabt;
> +
> +	regs->pc = regs->regs[30];
> +}
> +
> +static bool check_pabt(void)
> +{
> +	enum vector v = check_vector_prep();
> +
> +	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
> +
> +	test_exception("adrp	x9, check_pabt_invalid_paddr\n"
> +		       "add	x9, x9, :lo12:check_pabt_invalid_paddr\n"
> +		       "ldr	x9, [x9]\n",
> +		       "blr	x9\n",
> +		       "", "x9", "x30");
> +
> +	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, NULL);
> +
> +	return pabt_works;
> +}
> +
>  static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
>  {
>  	__user_psci_system_off();
> @@ -302,6 +391,11 @@ static void check_vectors(void *arg __unused)
>  		install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN,
>  					  user_psci_system_off);
>  #endif
> +	} else {
> +		if (!check_pabt_init())
> +			report_skip("Couldn't guess an invalid physical address");
> +		else
> +			report(check_pabt(), "pabt");
>  	}
>  	exit(report_summary());
>  }
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

Sorry, this series has been on my TODO list since you posted it, but something
else came up. The patches look fine, I like how you return back to the function
that triggered the PABT, it looks much better than my version. I also ran a quick
test, so:

Acked-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
