Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AAB1F946B
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 12:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgFOKQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 06:16:09 -0400
Received: from foss.arm.com ([217.140.110.172]:44328 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgFOKQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 06:16:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 860D71F1;
        Mon, 15 Jun 2020 03:16:08 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.7.221])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A7FA3F71F;
        Mon, 15 Jun 2020 03:16:07 -0700 (PDT)
Date:   Mon, 15 Jun 2020 11:16:05 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Subject: Re: [PATCH 3/4] KVM: arm64: Allow PtrAuth to be enabled from
 userspace on non-VHE systems
Message-ID: <20200615101605.GC773@C02TD0UTHF1T.local>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-4-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 09:19:53AM +0100, Marc Zyngier wrote:
> Now that the scene is set for enabling PtrAuth on non-VHE, drop
> the restrictions preventing userspace from enabling it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Other than dropping the `has_vhe()` check this appears to be
functionally equivalent and easier to follow, so:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kvm/reset.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index d3b209023727..2a929789fe2e 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -42,6 +42,11 @@ static u32 kvm_ipa_limit;
>  #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
>  				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
>  
> +static bool system_has_full_ptr_auth(void)
> +{
> +	return system_supports_address_auth() && system_supports_generic_auth();
> +}
> +
>  /**
>   * kvm_arch_vm_ioctl_check_extension
>   *
> @@ -80,8 +85,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		break;
>  	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> -		r = has_vhe() && system_supports_address_auth() &&
> -				 system_supports_generic_auth();
> +		r = system_has_full_ptr_auth();
>  		break;
>  	default:
>  		r = 0;
> @@ -205,19 +209,14 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>  
>  static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>  {
> -	/* Support ptrauth only if the system supports these capabilities. */
> -	if (!has_vhe())
> -		return -EINVAL;
> -
> -	if (!system_supports_address_auth() ||
> -	    !system_supports_generic_auth())
> -		return -EINVAL;
>  	/*
>  	 * For now make sure that both address/generic pointer authentication
> -	 * features are requested by the userspace together.
> +	 * features are requested by the userspace together and the system
> +	 * supports these capabilities.
>  	 */
>  	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
> -	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
> +	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
> +	    !system_has_full_ptr_auth())
>  		return -EINVAL;
>  
>  	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
> -- 
> 2.27.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
