Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CA022F730
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 19:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgG0R64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 13:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729681AbgG0R64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 13:58:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8302920775;
        Mon, 27 Jul 2020 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595872735;
        bh=wsUQsKrS4r2XL5rYOvlDyIXuxnq1RQPIsbrOgDyx0vE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1t5ZrQvDJra1I3FvBS5rx9FUMNktG0piqcjuZ4ckbVKc5CNGhxH5p6qPNxhCL8j53
         +aavIL9jfycRaJrIePLBzpBfT/hayfPlianQGgHSGHjyvSU8FTkAAYIz4e/QwXWmUO
         +urlskp6B8oX33Pk5Ao9AdRLQ/R0Ay3+W3E+D0bg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k07Oo-00FO4e-5Z; Mon, 27 Jul 2020 18:58:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 27 Jul 2020 18:58:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 5/5] arm64/x86: KVM: Introduce steal-time cap
In-Reply-To: <20200711100434.46660-6-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-6-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <446e22a04b5f1a63d8fad7ffa35a1314@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-11 11:04, Andrew Jones wrote:
> arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
> support for steal-time. However this is unnecessary, as only a KVM
> fd is required, and it complicates userspace (userspace may prefer
> delaying vcpu creation until after feature probing). Introduce a cap
> that can be checked instead. While x86 can already probe steal-time
> support with a kvm fd (KVM_GET_SUPPORTED_CPUID), we add the cap there
> too for consistency.
> 
> Reviewed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst    | 11 +++++++++++
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/arm.c              |  3 +++
>  arch/arm64/kvm/pvtime.c           |  2 +-
>  arch/x86/kvm/x86.c                |  3 +++
>  include/uapi/linux/kvm.h          |  1 +
>  6 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst 
> b/Documentation/virt/kvm/api.rst
> index 3bd96c1a3962..3716d1e29771 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6152,3 +6152,14 @@ KVM can therefore start protected VMs.
>  This capability governs the KVM_S390_PV_COMMAND ioctl and the
>  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
>  guests when the state change is invalid.
> +
> +8.24 KVM_CAP_STEAL_TIME
> +-----------------------
> +
> +:Architectures: arm64, x86
> +
> +This capability indicates that KVM supports steal time accounting.
> +When steal time accounting is supported it may be enabled with
> +architecture-specific interfaces.  For x86 see
> +Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".  For arm64 see
> +Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".

Maybe add something that indicates that KVM_CAP_STEAL_TIME
and the architecture specific ioctl aren't allowed to disagree
about the support?

> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index b01f52b61572..8909c840ea91 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -500,6 +500,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu 
> *vcpu);
>  gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
>  void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
> 
> +bool kvm_arm_pvtime_supported(void);
>  int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>  			    struct kvm_device_attr *attr);
>  int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 90cb90561446..0f7f8cd2f341 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -222,6 +222,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
> long ext)
>  		 */
>  		r = 1;
>  		break;
> +	case KVM_CAP_STEAL_TIME:
> +		r = kvm_arm_pvtime_supported();
> +		break;
>  	default:
>  		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
>  		break;
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index 025b5f3a97ef..468bd1ef9c7e 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -73,7 +73,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>  	return base;
>  }
> 
> -static bool kvm_arm_pvtime_supported(void)
> +bool kvm_arm_pvtime_supported(void)
>  {
>  	return !!sched_info_on();
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..27fc86bb28c4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3538,6 +3538,9 @@ int kvm_vm_ioctl_check_extension(struct kvm
> *kvm, long ext)
>  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>  		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
>  		break;
> +	case KVM_CAP_STEAL_TIME:
> +		r = sched_info_on();
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4fdf30316582..121fb29ac004 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_SECURE_GUEST 181
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
> +#define KVM_CAP_STEAL_TIME 184
> 
>  #ifdef KVM_CAP_IRQ_ROUTING

Otherwise looks ok.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
