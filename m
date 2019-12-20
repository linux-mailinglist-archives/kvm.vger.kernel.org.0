Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E841281EA
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 19:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfLTSIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 13:08:19 -0500
Received: from foss.arm.com ([217.140.110.172]:53888 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727390AbfLTSIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 13:08:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1D5D1FB;
        Fri, 20 Dec 2019 10:08:18 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DC363F67D;
        Fri, 20 Dec 2019 10:08:17 -0800 (PST)
Date:   Fri, 20 Dec 2019 18:08:15 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/18] KVM: arm64: don't trap Statistical Profiling
 controls to EL2
Message-ID: <20191220180815.GE25258@lakrids.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-12-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220143025.33853-12-andrew.murray@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 02:30:18PM +0000, Andrew Murray wrote:
> As we now save/restore the profiler state there is no need to trap
> accesses to the statistical profiling controls. Let's unset the
> _TPMS bit.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/kvm/debug.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 43487f035385..07ca783e7d9e 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -88,7 +88,6 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
>   *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
>   *  - Debug ROM Address (MDCR_EL2_TDRA)
>   *  - OS related registers (MDCR_EL2_TDOSA)
> - *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
>   *
>   * Additionally, KVM only traps guest accesses to the debug registers if
>   * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
> @@ -111,7 +110,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  	 */
>  	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
>  	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
> -				MDCR_EL2_TPMS |
>  				MDCR_EL2_TPMCR |
>  				MDCR_EL2_TDRA |
>  				MDCR_EL2_TDOSA);

I think that this should be conditional on some vcpu feature flag.

If nothing else, this could break existing migration cases otherwise.

Thanks,
Mark.
