Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFBAC9CDF
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 13:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfJCLK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 07:10:27 -0400
Received: from foss.arm.com ([217.140.110.172]:41688 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfJCLK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 07:10:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 649C31000;
        Thu,  3 Oct 2019 04:10:26 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4658B3F706;
        Thu,  3 Oct 2019 04:10:25 -0700 (PDT)
Subject: Re: [PATCH 3/5] arm64: KVM: Disable EL1 PTW when invalidating S2 TLBs
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20190925111941.88103-1-maz@kernel.org>
 <20190925111941.88103-4-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <030bbc8c-2304-5941-afc0-53f5a66fb143@arm.com>
Date:   Thu, 3 Oct 2019 12:10:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190925111941.88103-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 25/09/2019 12:19, Marc Zyngier wrote:
> When erratum 1319367 is being worked around, special care must
> be taken not to allow the page table walker to populate TLBs
> while we have the stage-2 translation enabled (which would otherwise
> result in a bizare mix of the host S1 and the guest S2).
> 
> We enforce this by setting TCR_EL1.EPD{0,1} before restoring the S2
> configuration, and clear the same bits after having disabled S2.


Some comment Nits...

> diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
> index eb0efc5557f3..4ef0bf0d76a6 100644
> --- a/arch/arm64/kvm/hyp/tlb.c
> +++ b/arch/arm64/kvm/hyp/tlb.c
> @@ -63,6 +63,22 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
>  static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
>  						  struct tlb_inv_context *cxt)
>  {
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
> +		u64 val;
> +
> +		/*
> +		 * For CPUs that are affected by ARM 1319367, we need to
> +		 * avoid a host Stage-1 walk while we have the guest's

> +		 * Stage-2 set in the VTTBR in order to invalidate TLBs.

Isn't HCR_EL2.VM==0 for all this? I think its the VMID that matters here:
| ... have the guest's VMID set in VTTBR ...

?


> +		 * We're guaranteed that the S1 MMU is enabled, so we can
> +		 * simply set the EPD bits to avoid any further TLB fill.
> +		 */
> +		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
> +		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
> +		write_sysreg_el1(val, SYS_TCR);
> +		isb();
> +	}
> +
>  	__load_guest_stage2(kvm);
>  	isb();
>  }
> @@ -100,6 +116,13 @@ static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
>  						 struct tlb_inv_context *cxt)
>  {
>  	write_sysreg(0, vttbr_el2);
> +
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
> +		/* Ensure stage-2 is actually disabled */

| Ensure the host's VMID has been written

?


> +		isb();
> +		/* Restore the host's TCR_EL1 */
> +		write_sysreg_el1(cxt->tcr, SYS_TCR);
> +	}
>  }


Thanks,

James
