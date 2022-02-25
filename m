Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B8A4C46D5
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 14:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbiBYNp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 08:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiBYNp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 08:45:56 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96FF0210D74
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:45:24 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B8D6106F;
        Fri, 25 Feb 2022 05:45:24 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EBA73F5A1;
        Fri, 25 Feb 2022 05:45:20 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:45:45 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 42/64] KVM: arm64: nv: Fold guest's HCR_EL2
 configuration into the host's
Message-ID: <YhjdiTiHNApGkRuc@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-43-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-43-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jan 28, 2022 at 12:18:50PM +0000, Marc Zyngier wrote:
> When entering a L2 guest (nested virt enabled, but not in hypervisor
> context), we need to honor the traps the L1 guest has asked enabled.
> 
> For now, just OR the guest's HCR_EL2 into the host's. We may have to do
> some filtering in the future though.

Hmm... looks to me like the filtering is already implemented via the
HCR_GUEST_NV_FILTER_FLAGS. Or am I misunderstanding something?

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 0e164cc8e913..5e8eafac27c6 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -78,6 +78,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  			if (!vcpu_el2_tge_is_set(vcpu))
>  				hcr |= HCR_AT | HCR_TTLB;
>  		}
> +	} else if (vcpu_has_nv(vcpu)) {
> +		u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
> +
> +		vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;


> +		hcr |= vhcr_el2;

This makes sense, we only the guest to add extra traps on top of what KVM
already traps, not remove traps from what KVM has configured.

However, HCR_EL2.FIEN (bit 47) disables traps when the bit is 1. Shouldn't
it be part of the HCR_GUEST_NV_FILTER_FLAGS?

Thanks,
Alex

>  	}
>  
>  	___activate_traps(vcpu, hcr);
> -- 
> 2.30.2
> 
