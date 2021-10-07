Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889AA425548
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 16:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242060AbhJGOYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 10:24:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242020AbhJGOYj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 10:24:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633616565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NwNhkSSQVfpndEjPuTcMmPnedcfNAU7hCSOfVfmZyQw=;
        b=esYsEikkXKzqjy0BB8SxKHpLnOSFF7AIF8iGUXolNeGCfpg7lVD/mNnpv5ZczsphVaEcAI
        prlHTFqSIam5cHbX0JC7sY9LUFqmWuxANx/h5DpIzhdZhDW8FFB0/ZY/imK4fIs3GTq4l1
        2NRIBqju94rh33upEmDCcVFJgHlsVTY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-ryuy4rR3NUudNlM0rIVgbQ-1; Thu, 07 Oct 2021 10:22:44 -0400
X-MC-Unique: ryuy4rR3NUudNlM0rIVgbQ-1
Received: by mail-qt1-f198.google.com with SMTP id 90-20020aed3163000000b002a6bd958077so5280691qtg.6
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 07:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NwNhkSSQVfpndEjPuTcMmPnedcfNAU7hCSOfVfmZyQw=;
        b=xXZcw6oIkONEHmxOpD/RjYnx/Elfld2oE0Hlka+XulOLfuaJMzV5Wws660MxNfbsYZ
         765XDhL0BHXCSEY3DkFpqO7Fq7PBwd5Hdk69Bcuf9S+il+CYSXLL3jWy6RVnQd1SpLh0
         0W8AeigsGyOXmgisxQD0zkuE7SBhbCYGPFvb0eEfBnC6K15EbC+7wvZReiEFnlyfCdkU
         png4rD999R9y3tNyn5jfesKHsSsZ3zPSZBnYWbwYPm+kbwsKWLtw35kkAXWt+tpCKoXp
         YWpoqBImluCzcTA/088fA7j6px3fHJn+atYzmwQV+mLvrvBzILMmHOkmSUoMzm9goejq
         bi4g==
X-Gm-Message-State: AOAM530Uy+7sn8utNsi9HXoYc22MYuPDQRqAmUWibdsha4faGNmMfSY4
        7KkcCUcStGHDPQNTlzwDrzSBpU1Na4tHsk1d+pHoGd1tDAgLjm7KjmBFBnI/Mv8ihrKaVTD62vu
        d7mFQlnB5LnYV
X-Received: by 2002:ac8:42da:: with SMTP id g26mr5084726qtm.368.1633616564372;
        Thu, 07 Oct 2021 07:22:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznlZpzS7BocFG+jBouZSO4VwuwGiZhZ+UBcXSThzQVFxaLLFDyXzL3bSYYFQIwgrEoqpSV7g==
X-Received: by 2002:ac8:42da:: with SMTP id g26mr5084691qtm.368.1633616564116;
        Thu, 07 Oct 2021 07:22:44 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b20sm521782qtx.89.2021.10.07.07.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 07:22:43 -0700 (PDT)
Date:   Thu, 7 Oct 2021 16:22:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 09/16] KVM: arm64: Advertise a capability for MMIO
 guard
Message-ID: <20211007142239.4ryz4thzgpilphya@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-10-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004174849.2831548-10-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:48:42PM +0100, Marc Zyngier wrote:
> In order for userspace to find out whether the MMIO guard is
> exposed to a guest, expose a capability that says so.
> 
> We take this opportunity to make it incompatible with the NISV
> option, as that would be rather counter-productive!
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c        | 29 ++++++++++++++++++-----------
>  arch/arm64/kvm/hypercalls.c | 14 ++++++++++++--
>  include/uapi/linux/kvm.h    |  1 +
>  3 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ed9c89ec0b4f..1c9a7abe2728 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -81,32 +81,33 @@ int kvm_arch_check_processor_compat(void *opaque)
>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			    struct kvm_enable_cap *cap)
>  {
> -	int r;
> +	int r = -EINVAL;
>  
>  	if (cap->flags)
>  		return -EINVAL;
>  
> +	mutex_lock(&kvm->lock);
> +
>  	switch (cap->cap) {
>  	case KVM_CAP_ARM_NISV_TO_USER:
> -		r = 0;
> -		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> -			&kvm->arch.flags);
> +		/* This is incompatible with MMIO guard */
> +		if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &kvm->arch.flags)) {

But KVM_ARCH_FLAG_MMIO_GUARD will never be set at VM creation time, which
is the traditional time to probe and enable capabilities, because the
guest hasn't run yet, so it hasn't had a chance to issue the hypercall to
enable the mmio guard yet.

> +			r = 0;
> +			set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> +				&kvm->arch.flags);
> +		}
>  		break;
>  	case KVM_CAP_ARM_MTE:
> -		mutex_lock(&kvm->lock);
> -		if (!system_supports_mte() || kvm->created_vcpus) {
> -			r = -EINVAL;
> -		} else {
> +		if (system_supports_mte() && !kvm->created_vcpus) {
>  			r = 0;
>  			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
>  		}
> -		mutex_unlock(&kvm->lock);
>  		break;
>  	default:
> -		r = -EINVAL;
>  		break;
>  	}
>  
> +	mutex_unlock(&kvm->lock);
>  	return r;
>  }
>  
> @@ -211,13 +212,19 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_IMMEDIATE_EXIT:
>  	case KVM_CAP_VCPU_EVENTS:
>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
> -	case KVM_CAP_ARM_NISV_TO_USER:
>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  	case KVM_CAP_PTP_KVM:
>  		r = 1;
>  		break;
> +	case KVM_CAP_ARM_NISV_TO_USER:
> +		r = !test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &kvm->arch.flags);
> +		break;
> +	case KVM_CAP_ARM_MMIO_GUARD:
> +		r = !test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> +			      &kvm->arch.flags);
> +		break;
>  	case KVM_CAP_SET_GUEST_DEBUG2:
>  		return KVM_GUESTDBG_VALID_MASK;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index c39aab55ecae..e4fade6a96f6 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -59,6 +59,14 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>  	val[3] = lower_32_bits(cycles);
>  }
>  
> +static bool mmio_guard_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return (!test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> +			  &vcpu->kvm->arch.flags) &&
> +		!vcpu_mode_is_32bit(vcpu));
> +
> +}
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
>  	u32 func_id = smccc_get_function(vcpu);
> @@ -131,7 +139,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
>  		/* Only advertise MMIO guard to 64bit guests */
> -		if (!vcpu_mode_is_32bit(vcpu)) {
> +		if (mmio_guard_allowed(vcpu)) {
>  			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO);
>  			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL);
>  			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP);
> @@ -146,10 +154,12 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  			val[0] = PAGE_SIZE;
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID:
> -		if (!vcpu_mode_is_32bit(vcpu)) {
> +		mutex_lock(&vcpu->kvm->lock);
> +		if (mmio_guard_allowed(vcpu)) {
>  			set_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);
>  			val[0] = SMCCC_RET_SUCCESS;
>  		}
> +		mutex_unlock(&vcpu->kvm->lock);
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID:
>  		if (!vcpu_mode_is_32bit(vcpu) &&
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a067410ebea5..ef171186e7be 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_BINARY_STATS_FD 203
>  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>  #define KVM_CAP_ARM_MTE 205
> +#define KVM_CAP_ARM_MMIO_GUARD 206
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.30.2
>

Thanks,
drew

