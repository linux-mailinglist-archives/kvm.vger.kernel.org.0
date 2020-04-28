Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802B71BC02C
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 15:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgD1Nus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 09:50:48 -0400
Received: from foss.arm.com ([217.140.110.172]:52144 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgD1Nur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 09:50:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A573231B;
        Tue, 28 Apr 2020 06:50:46 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 984B83F68F;
        Tue, 28 Apr 2020 06:50:45 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Make KVM_CAP_MAX_VCPUS compatible with the
 selected GIC version
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
References: <20200427141507.284985-1-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5ac78e8b-4776-70c7-c05c-8ffe536e175d@arm.com>
Date:   Tue, 28 Apr 2020 14:51:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427141507.284985-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/27/20 3:15 PM, Marc Zyngier wrote:
> KVM_CAP_MAX_VCPUS always return the maximum possible number of

s/return/returns?

> VCPUs, irrespective of the selected interrupt controller. This
> is pretty misleading for userspace that selects a GICv2 on a GICv3
> system that supports v2 compat: It always gets a maximum of 512
> VCPUs, even if the effective limit is 8. The 9th VCPU will fail
> to be created, which is unexpected as far as userspace is concerned.
>
> Fortunately, we already have the right information stashed in the
> kvm structure, and we can return it as requested.
>
> Reported-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/arm.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 48d0ec44ad77..f9b0528f7305 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -95,6 +95,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  	return r;
>  }
>  
> +static int kvm_arm_default_max_vcpus(void)
> +{
> +	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
> +}
> +
>  /**
>   * kvm_arch_init_vm - initializes a VM data structure
>   * @kvm:	pointer to the KVM struct
> @@ -128,8 +133,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.vmid.vmid_gen = 0;
>  
>  	/* The maximum number of VCPUs is limited by the host's GIC model */
> -	kvm->arch.max_vcpus = vgic_present ?
> -				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
> +	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();

Nitpicking, but the comment is not 100% true because the maximum number of vcpus
is limited based on the requested vgic type, even before this patch.

>  
>  	return ret;
>  out_free_stage2_pgd:
> @@ -204,10 +208,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = num_online_cpus();

Not relevant to this patch. If the host has a GICv3, and userspace requests a
GICv2, it is possible that KVM_CAP_NR_VCPUS > KVM_CAP_MAX_VCPUS. I am curious, I
don't see anything in the KVM API documentation about this case, so I suppose it's
perfectly legal, right?

>  		break;
>  	case KVM_CAP_MAX_VCPUS:
> -		r = KVM_MAX_VCPUS;
> -		break;
>  	case KVM_CAP_MAX_VCPU_ID:
> -		r = KVM_MAX_VCPU_ID;
> +		if (kvm)
> +			r = kvm->arch.max_vcpus;
> +		else
> +			r = kvm_arm_default_max_vcpus();

This works as expected - when KVM_CHECK_EXTENSION is called on the kvm fd, struct
kvm is NULL.

>  		break;
>  	case KVM_CAP_MSI_DEVID:
>  		if (!kvm)

The patch looks fine to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Tested it on a rockpro64, which has a GICv3 that can also emulate a GICv2. When
the vgic is a GICv3, before and after instantiating the device, the ioctl returns
512 on both /dev/kvm and the vm fd, as you would expect. When the vgic is a GICv2,
the ioctl return 512 on /dev/kvm and the vm fd before instantiating the vgic;
afterward it returns 512 on /dev/kvm and 8 on the vm fd:

Tested-by: Alexandru Elisei

