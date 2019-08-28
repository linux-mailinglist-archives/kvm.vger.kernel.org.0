Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64160A0443
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 16:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfH1OJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 10:09:30 -0400
Received: from foss.arm.com ([217.140.110.172]:60276 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbfH1OJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 10:09:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7B1B28;
        Wed, 28 Aug 2019 07:09:28 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF91F3F246;
        Wed, 28 Aug 2019 07:09:27 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:09:25 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        andre.przywara@arm.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests RFC PATCH 04/16] arm/arm64: selftest: Add
 prefetch abort test
Message-ID: <20190828140925.GC41023@lakrids.cambridge.arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-5-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566999511-24916-5-git-send-email-alexandru.elisei@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 02:38:19PM +0100, Alexandru Elisei wrote:
> When a guest tries to execute code from MMIO memory, KVM injects an
> external abort into that guest. We have now fixed the psci test to not
> fetch instructions from the I/O region, and it's not that often that a
> guest misbehaves in such a way. Let's expand our coverage by adding a
> proper test targetting this corner case.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> The fault injection path is broken for nested guests [1]. You can use the
> last patch from the thread [2] to successfully run the test at EL2.
> 
> [1] https://www.spinics.net/lists/arm-kernel/msg745391.html
> [2] https://www.spinics.net/lists/arm-kernel/msg750310.html
> 
>  lib/arm64/asm/esr.h |  3 ++
>  arm/selftest.c      | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 96 insertions(+), 3 deletions(-)
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
> index 176231f32ee1..18cc0ad8f729 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -16,6 +16,8 @@
>  #include <asm/psci.h>
>  #include <asm/smp.h>
>  #include <asm/barrier.h>
> +#include <asm/mmu.h>
> +#include <asm/pgtable.h>
>  
>  static void __user_psci_system_off(void)
>  {
> @@ -60,9 +62,38 @@ static void check_setup(int argc, char **argv)
>  		report_abort("missing input");
>  }
>  
> +extern pgd_t *mmu_idmap;
> +static void prep_io_exec(void)
> +{
> +	pgd_t *pgd = pgd_offset(mmu_idmap, 0);
> +	unsigned long sctlr;
> +
> +	/*
> +	 * AArch64 treats all regions writable at EL0 as PXN.

I didn't think that was the case, and I can't find wording to that
effect in the ARM ARM (looking at ARM DDI 0487E.a). Where is that
stated?

> Clear the user bit
> +	 * so we can execute code from the bottom I/O space (0G-1G) to simulate
> +	 * a misbehaved guest.
> +	 */
> +	pgd_val(*pgd) &= ~PMD_SECT_USER;
> +	flush_dcache_addr((unsigned long)pgd);

The virtualization extensions imply coherent page table walks, so I
don't think the cache maintenance is necessary (provided
TCR_EL1.{SH*,ORGN*,IRGN*} are configured appropriately.

> +	flush_tlb_page(0);
> +
> +	/* Make sure we can actually execute from a writable region */
> +#ifdef __arm__
> +	asm volatile("mrc p15, 0, %0, c1, c0, 0": "=r" (sctlr));
> +	sctlr &= ~CR_ST;
> +	asm volatile("mcr p15, 0, %0, c1, c0, 0" :: "r" (sctlr));
> +#else
> +	sctlr = read_sysreg(sctlr_el1);
> +	sctlr &= ~SCTLR_EL1_WXN;
> +	write_sysreg(sctlr, sctlr_el1);
> +#endif
> +	isb();
> +}

Thanks,
Mark.
