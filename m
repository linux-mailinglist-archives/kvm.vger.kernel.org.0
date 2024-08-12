Return-Path: <kvm+bounces-23829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A14594E816
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 09:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8F7FB22448
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 07:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164A115C154;
	Mon, 12 Aug 2024 07:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDJlpqF1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8E313E40F;
	Mon, 12 Aug 2024 07:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723449087; cv=none; b=BlaBAM5l+K6Ff+EJUVzeaTMO/MoLE2ADoYiQDgenGoBoc/D34f27HiBQXQLBNYR7F+sP2ycA7dDiDpBsp58KuuVsQYWKxff0tEwxCoMa4S5BUbi/4IV+d5cMvXSd6Q3FdZJftQU6bE0zc7QQvGqyO/V1e21jTelpDnR6/fNrovA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723449087; c=relaxed/simple;
	bh=ROUL+tcwVdI8Nxxa9S18LN7O+XGXQCvdy68gp6/Ukg8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QDZouPtJWCjjj1z+kH23nPGP382v5QUu8+1G3oV873ajOqD1LjXWvlGOlce0b3DuKayysQkIkSIOw9mBJm6AaLQvkxOLkVBzBrvSEz+fuOeaftYINykj88kgXt0K8L5WQ4yBXSqV3HkrcqulEMWG6AbWPMg4ZIb3UCxWjhPTkRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDJlpqF1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42E3C4AF0C;
	Mon, 12 Aug 2024 07:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723449086;
	bh=ROUL+tcwVdI8Nxxa9S18LN7O+XGXQCvdy68gp6/Ukg8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mDJlpqF1Sv02SfX0k0D2wl2KjtMAS3s/56zIkKV3K1oirRnl1tlJPP8UuC/oEhqT2
	 0Lu5nUbRA8+XNkt93tiOKiTAEQ5G/1CakiJxM5GNxX6Q02Z8KjgjeKIIaLIG2+57Zn
	 6e3Yz0RzAVkJFcaIVRz0Kx4UuWmMdSV6O5V5aHVn/oTOKsAZoYNBbsOZBheGK8YoKl
	 wcUcbjak5vtD8yOtEyBzHs/NcC+B3vJwBbml4cw6TJWM5VMrgF2GSx4BkjYQrtN+S1
	 H3b2cttpOd9bS2piUrRprWZFahEDM9qIEKqD8u45S4VFsmrcJQVztF6n1+cXuK/hs0
	 ATp+jujZk0vSw==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Anish Moorthy <amoorthy@google.com>, seanjc@google.com,
	oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: jthoughton@google.com, amoorthy@google.com, rananta@google.com
Subject: Re: [PATCH v2 3/3] KVM: arm64: Perform memory fault exits when
 stage-2 handler EFAULTs
In-Reply-To: <20240809205158.1340255-4-amoorthy@google.com>
References: <20240809205158.1340255-1-amoorthy@google.com>
 <20240809205158.1340255-4-amoorthy@google.com>
Date: Mon, 12 Aug 2024 13:21:19 +0530
Message-ID: <yq5aikw6ji14.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Anish Moorthy <amoorthy@google.com> writes:

> Right now userspace just gets a bare EFAULT when the stage-2 fault
> handler fails to fault in the relevant page. Set up a
> KVM_EXIT_MEMORY_FAULT whenever this happens, which at the very least
> eases debugging and might also let userspace decide on/take some
> specific action other than crashing the VM.
>
> In some cases, user_mem_abort() EFAULTs before the size of the fault is
> calculated: return 0 in these cases to indicate that the fault is of
> unknown size.
>

VMMs are now converting private memory to shared or vice-versa on vcpu
exit due to memory fault. This change will require VMM track each page's
private/shared state so that they can now handle an exit fault on a
shared memory where the fault happened due to reasons other than
conversion. Should we make it easy by adding additional flag bits to
indicate the fault was due to attribute and access type mismatch?


> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst |  2 +-
>  arch/arm64/kvm/arm.c           |  1 +
>  arch/arm64/kvm/mmu.c           | 11 ++++++++++-
>  3 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c5ce7944005c..7b321fefcb3e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8129,7 +8129,7 @@ unavailable to host or other VMs.
>  7.34 KVM_CAP_MEMORY_FAULT_INFO
>  ------------------------------
>  
> -:Architectures: x86
> +:Architectures: arm64, x86
>  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
>  
>  The presence of this capability indicates that KVM_RUN *may* fill
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a7ca776b51ec..4121b5a43b9c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -335,6 +335,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_SYSTEM_SUSPEND:
>  	case KVM_CAP_IRQFD_RESAMPLE:
>  	case KVM_CAP_COUNTER_OFFSET:
> +	case KVM_CAP_MEMORY_FAULT_INFO:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6981b1bc0946..c97199d1feac 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1448,6 +1448,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	if (fault_is_perm && !write_fault && !exec_fault) {
>  		kvm_err("Unexpected L2 read permission error\n");
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,
> +					      write_fault, exec_fault, false);
>  		return -EFAULT;
>  	}
>  
> @@ -1473,6 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (unlikely(!vma)) {
>  		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
>  		mmap_read_unlock(current->mm);
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,
> +					      write_fault, exec_fault, false);
>  		return -EFAULT;
>  	}
>  
> @@ -1568,8 +1572,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		kvm_send_hwpoison_signal(hva, vma_shift);
>  		return 0;
>  	}
> -	if (is_error_noslot_pfn(pfn))
> +	if (is_error_noslot_pfn(pfn)) {
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
> +					      write_fault, exec_fault, false);
>  		return -EFAULT;
> +	}
>  
>  	if (kvm_is_device_pfn(pfn)) {
>  		/*
> @@ -1643,6 +1650,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		if (mte_allowed) {
>  			sanitise_mte_tags(kvm, pfn, vma_pagesize);
>  		} else {
> +			kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
> +						      write_fault, exec_fault, false);
>  			ret = -EFAULT;
>  			goto out_unlock;
>  		}
> -- 
> 2.46.0.76.ge559c4bf1a-goog

