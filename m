Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A965839BA6B
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 16:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhFDODP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 10:03:15 -0400
Received: from foss.arm.com ([217.140.110.172]:39748 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhFDODP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 10:03:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 706D82B;
        Fri,  4 Jun 2021 07:01:28 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.6.137])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27BBE3F774;
        Fri,  4 Jun 2021 07:01:24 -0700 (PDT)
Date:   Fri, 4 Jun 2021 15:01:17 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] KVM: arm64: Ignore 'kvm-arm.mode=protected' when
 using VHE
Message-ID: <20210604140117.GA69333@C02TD0UTHF1T.local>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-2-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603183347.1695-2-will@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 07:33:44PM +0100, Will Deacon wrote:
> Ignore 'kvm-arm.mode=protected' when using VHE so that kvm_get_mode()
> only returns KVM_MODE_PROTECTED on systems where the feature is available.

IIUC, since the introduction of the idreg-override code, and the
mutate_to_vhe stuff, passing 'kvm-arm.mode=protected' should make the
kernel stick to EL1, right? So this should only affect M1 (or other HW
with a similar impediment).

One minor comment below; otherwise:

Acked-by: Mark Rutland <mark.rutland@arm.com>

> 
> Cc: David Brazdil <dbrazdil@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  1 -
>  arch/arm64/kernel/cpufeature.c                  | 10 +---------
>  arch/arm64/kvm/arm.c                            |  6 +++++-
>  3 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index cb89dbdedc46..e85dbdf1ee8e 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2300,7 +2300,6 @@
>  
>  			protected: nVHE-based mode with support for guests whose
>  				   state is kept private from the host.
> -				   Not valid if the kernel is running in EL2.
>  
>  			Defaults to VHE/nVHE based on hardware support.
>  
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index efed2830d141..dc1f2e747828 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1773,15 +1773,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
>  #ifdef CONFIG_KVM
>  static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
>  {
> -	if (kvm_get_mode() != KVM_MODE_PROTECTED)
> -		return false;
> -
> -	if (is_kernel_in_hyp_mode()) {
> -		pr_warn("Protected KVM not available with VHE\n");
> -		return false;
> -	}
> -
> -	return true;
> +	return kvm_get_mode() == KVM_MODE_PROTECTED;
>  }
>  #endif /* CONFIG_KVM */
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1cb39c0803a4..8d5e23198dfd 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2121,7 +2121,11 @@ static int __init early_kvm_mode_cfg(char *arg)
>  		return -EINVAL;
>  
>  	if (strcmp(arg, "protected") == 0) {
> -		kvm_mode = KVM_MODE_PROTECTED;
> +		if (!is_kernel_in_hyp_mode())
> +			kvm_mode = KVM_MODE_PROTECTED;
> +		else
> +			pr_warn_once("Protected KVM not available with VHE\n");

... assuming this is only for M1, it might be better to say:

	Protected KVM not available on this hardware

... since that doesn't suggest that other VHE-capable HW is also not
PKVM-capable.

Thanks,
Mark.
