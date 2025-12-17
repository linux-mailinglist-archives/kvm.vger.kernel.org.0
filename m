Return-Path: <kvm+bounces-66169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5FBCC7E61
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 14:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F29E43005501
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 13:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F75B36C586;
	Wed, 17 Dec 2025 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpTGQEAs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A31358D29
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765978797; cv=none; b=bA37wBc17hL+lT//XmQo6MMncWVTKnWfupzBJW/1ply/XLcbgP5GbPVRxBKJ7JWtfBkKOz8d9GVbBk5LUuFLuHhcPIzHtQsuu2tQJ1kWtlx5kDR/NkFXENDj4U2R7+QmCLLnuyvQY/KHUT76Svjo0MWCsPehFn+Xp2s8RBDdiT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765978797; c=relaxed/simple;
	bh=Y8HwpCJLp5JuXwZzLKV+3HBK3WSOBZDnT2hxF952di4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sRQM/AMkQLkR3Z+GF8GnrHFKOFHIQe92ZWnsKRbCM0EEWDZi1s6zKa84C67cV4OlQ8FVAxT6+3i9O9GRqlVvfYxBzYIUV4kWw1y57IBmvyGg9Dkqch8uQrjjt3ac1KWc25RgXeRLNTFCUjf8r+VAc2NTuTOnQtGlORvIts4U6C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cpTGQEAs; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-34aa62f9e74so7248748a91.1
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 05:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765978794; x=1766583594; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6pIj46nVvtUq+4eec5aThnrTEmEGNk5gVfAEDmgIrpg=;
        b=cpTGQEAs+MbjtnSc1P7z9XQx590NDBC3jqO55epJUksXi7Lk3VvHMG65d9+7P5N8X8
         cMhSjOqxgvFcYPSYe04Iix9FH2Rh0eD2mwd56ZY1UAqZA5o4TNYZIOoBJwizsmD8KtNQ
         37deqL/gv1+nRuLSUlacjYmE3RtvdcqugtDcXWOCtn+yBtIbxJl2KzH1jrNZzPlsu4uF
         i7fEDI1VBjaBghltESg0pjT9NkXPkppNjEXYu44KzENZUJEKUj3ZGNFJs3sa1DNLmwk3
         qllVcBuVbUOjnNlYUDNLHNki3M09/98GQDLMZtG7tAypXS7eRp8LvIVAe299vMHkRgxe
         EcQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765978794; x=1766583594;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6pIj46nVvtUq+4eec5aThnrTEmEGNk5gVfAEDmgIrpg=;
        b=GLcXzonsp3MtzN3lHvh9bxtSvhFgA95iZ1OtO7TInwvVwOA9MhL8kpG0iw0P/pbao2
         I2BwlVQCT8gBDFnp4JzFCFys7KcA2rCFVNojUZ2YlTUZsqy8zW6WAX/A+yo15Zv38W9O
         PekHGHXpwD0oRKllTrmhIEO4vK51NTS37xMCiFDX9wTJVI+l5PfmEepHayjggKX04JEe
         zJpzRm6LRbLNYMeu0rdW1b7mfKmErvMVHJmocyr1kSzsJAf0gI85HoJCV3gZmHtuBR1J
         AE8zdy71uVaqT6XSt6QR4EABej0cH4OhaT1dBAT/jMo74pI8Ow8iH2WHfgClLs5UUXPd
         Nvaw==
X-Forwarded-Encrypted: i=1; AJvYcCX20k11YJaAFYTSe5I//tOUh1r/Wl6PC7AoRY1JNGwbrP+lxTFFSUFA4SiWM7gh1ceP6AE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUGmpe6QVsEXz3JrrfK9Zjfc9fJdCPHwGk6tkyNP9BhaYdT0nI
	t+zp9bngw7u7tPVvmX5dlqwPGQteede2bCQEVAUEv61jdkm+fHkhL4zY
X-Gm-Gg: AY/fxX4ay20uMQTcMKoVzKT9I+3Sgn5gNAo3Ru/+aaMqtF6G1lwTStcZ5KPGjBuPpPk
	b8gCDO6RNvPk9/9mkDVvf7RoaBPk6XcHDK10m9/2gh0Mpztgulu1+t+Lbt9YR85aKsAM9KUNQQW
	x88E99QPkMnSrQRqW7DGjlEWCfRXzmO3wsiR5Site/bYyg+/L4GTWEPalk0NMvTRENGjGII5zuc
	pQFLS6W++8lcX7I/48hjVwOcRJf3RRKBK3vOSGORoiggl6WGPJI70Zwpj6JckntDtXJ2PEt7ph9
	mRGD1U7mC5prusLWrS4yKKmgCl6705eHqFgfu0RY/9NkK96/tKmqU7MVVC+olHpi6stpsKLxMdw
	EKoSe5b+qL8bg21WR+Mpfg1pnX1sD4/Z6y51rVMxmc+6mhZSOs5fGyCQTnuhCRFSNOEnS03jQjb
	pjbxIeIeHRqRncVOQiiVFYkOqDmZJjVv99YDVu1Nu3fMrzW9cKcb60cFKfJ9vmv+BNFQr71o+ax
	MD+V+EugME9sV+7JBHhG+7fQcg=
X-Google-Smtp-Source: AGHT+IG3LzjynQX7X4H7S9Io3Ynamjd2a9PPbU+36SGNDnZcAgiWppcnGVLBSdjNiAVnsvjUFOBbeQ==
X-Received: by 2002:a17:90b:2ccf:b0:340:cb18:922 with SMTP id 98e67ed59e1d1-34abd71f7e6mr16889624a91.14.1765978794294;
        Wed, 17 Dec 2025 05:39:54 -0800 (PST)
Received: from [172.27.236.53] (ec2-13-250-3-147.ap-southeast-1.compute.amazonaws.com. [13.250.3.147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c25b7d59dsm18602604a12.6.2025.12.17.05.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 05:39:53 -0800 (PST)
Message-ID: <87df4cba-b191-49cf-9486-fc379470a6eb@gmail.com>
Date: Wed, 17 Dec 2025 21:39:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF
 events
To: Tian Zheng <zhengtian10@huawei.com>, maz@kernel.org,
 oliver.upton@linux.dev, catalin.marinas@arm.com, corbet@lwn.net,
 pbonzini@redhat.com, will@kernel.org
Cc: linux-kernel@vger.kernel.org, yuzenghui@huawei.com,
 wangzhou1@hisilicon.com, yezhenyu2@huawei.com, xiexiangyou@huawei.com,
 zhengchuan@huawei.com, linuxarm@huawei.com, joey.gouly@arm.com,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 suzuki.poulose@arm.com
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-5-zhengtian10@huawei.com>
Content-Language: en-US
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20251121092342.3393318-5-zhengtian10@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/2025 5:23 PM, Tian Zheng wrote:
> From: eillon <yezhenyu2@huawei.com>
> 
> Implement the HDBSS enable/disable functionality using the
> KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl.
> 
> Userspace (e.g., QEMU) can enable HDBSS by invoking the ioctl
> at the start of live migration, configuring the buffer size.
> The feature is disabled by invoking the ioctl again with size
> set to 0 once migration completes.
> 
> Add support for updating the dirty bitmap based on the HDBSS
> buffer. Similar to the x86 PML implementation, KVM flushes the
> buffer on all VM-Exits, so running vCPUs only need to be kicked
> to force a VM-Exit.
> 
> Signed-off-by: eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  10 +++
>   arch/arm64/include/asm/kvm_mmu.h  |  17 +++++
>   arch/arm64/kvm/arm.c              | 107 ++++++++++++++++++++++++++++++
>   arch/arm64/kvm/handle_exit.c      |  45 +++++++++++++
>   arch/arm64/kvm/hyp/vhe/switch.c   |   1 +
>   arch/arm64/kvm/mmu.c              |  10 +++
>   arch/arm64/kvm/reset.c            |   3 +
>   include/linux/kvm_host.h          |   1 +
>   8 files changed, 194 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d962932f0e5f..408e4c2b3d1a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -87,6 +87,7 @@ int __init kvm_arm_init_sve(void);
>   u32 __attribute_const__ kvm_target_cpu(void);
>   void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>   void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> 
>   struct kvm_hyp_memcache {
>   	phys_addr_t head;
> @@ -793,6 +794,12 @@ struct vcpu_reset_state {
>   	bool		reset;
>   };
> 
> +struct vcpu_hdbss_state {
> +	phys_addr_t base_phys;
> +	u32 size;
> +	u32 next_index;
> +};
> +
>   struct vncr_tlb;
> 
>   struct kvm_vcpu_arch {
> @@ -897,6 +904,9 @@ struct kvm_vcpu_arch {
> 
>   	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>   	struct vncr_tlb	*vncr_tlb;
> +
> +	/* HDBSS registers info */
> +	struct vcpu_hdbss_state hdbss;
>   };
> 
>   /*
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index e4069f2ce642..6ace1080aed5 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -331,6 +331,23 @@ static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu,
>   	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
>   }
> 
> +static __always_inline void __load_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 br_el2, prod_el2;
> +
> +	if (!kvm->enable_hdbss)
> +		return;
> +
> +	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
> +	prod_el2 = vcpu->arch.hdbss.next_index;
> +
> +	write_sysreg_s(br_el2, SYS_HDBSSBR_EL2);
> +	write_sysreg_s(prod_el2, SYS_HDBSSPROD_EL2);
> +
> +	isb();
> +}
> +
>   static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>   {
>   	return container_of(mmu->arch, struct kvm, arch);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 870953b4a8a7..64f65e3c2a89 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -79,6 +79,92 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>   	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>   }
> 
> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct page *hdbss_pg = NULL;
> +
> +	hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
> +	if (hdbss_pg)
> +		__free_pages(hdbss_pg, vcpu->arch.hdbss.size);
> +
> +	vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
> +		.base_phys = 0,
> +		.size = 0,
> +		.next_index = 0,
> +	};
> +}
> +
> +static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
> +				    struct kvm_enable_cap *cap)
> +{
> +	unsigned long i;
> +	struct kvm_vcpu *vcpu;
> +	struct page *hdbss_pg = NULL;
> +	int size = cap->args[0];
> +	int ret = 0;
> +
> +	if (!system_supports_hdbss()) {
> +		kvm_err("This system does not support HDBSS!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (size < 0 || size > HDBSS_MAX_SIZE) {
> +		kvm_err("Invalid HDBSS buffer size: %d!\n", size);
> +		return -EINVAL;
> +	}
> +

I think you should check if it's already enabled here. What if user space calls 
this twice?

> +	/* Enable the HDBSS feature if size > 0, otherwise disable it. */
> +	if (size) {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, size);
> +			if (!hdbss_pg) {
> +				kvm_err("Alloc HDBSS buffer failed!\n");
> +				ret = -ENOMEM;
> +				goto error_alloc;
> +			}
> +
> +			vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
> +				.base_phys = page_to_phys(hdbss_pg),
> +				.size = size,
> +				.next_index = 0,
> +			};
> +		}
> +
> +		kvm->enable_hdbss = true;
> +		kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS;

VTCR_EL2_HA is also a necessity for VTCR_EL2_HDBSS to take effect.

> +
> +		/*
> +		 * We should kick vcpus out of guest mode here to load new
> +		 * vtcr value to vtcr_el2 register when re-enter guest mode.
> +		 */
> +		kvm_for_each_vcpu(i, vcpu, kvm)
> +			kvm_vcpu_kick(vcpu);
> +	} else if (kvm->enable_hdbss) {
> +		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS);
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			/* Kick vcpus to flush hdbss buffer. */
> +			kvm_vcpu_kick(vcpu);
> +
> +			kvm_arm_vcpu_free_hdbss(vcpu);
> +		}
> +
> +		kvm->enable_hdbss = false;
> +	}
> +
> +	return ret;
> +
> +error_alloc:
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!vcpu->arch.hdbss.base_phys && !vcpu->arch.hdbss.size)
> +			continue;
> +
> +		kvm_arm_vcpu_free_hdbss(vcpu);
> +	}
> +
> +	return ret;
> +}
> +
>   int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   			    struct kvm_enable_cap *cap)
>   {
> @@ -132,6 +218,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		}
>   		mutex_unlock(&kvm->lock);
>   		break;
> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> +		mutex_lock(&kvm->lock);
> +		r = kvm_cap_arm_enable_hdbss(kvm, cap);
> +		mutex_unlock(&kvm->lock);
> +		break;
>   	default:
>   		break;
>   	}
> @@ -420,6 +511,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   			r = kvm_supports_cacheable_pfnmap();
>   		break;
> 
> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> +		r = system_supports_hdbss();
> +		break;
>   	default:
>   		r = 0;
>   	}
> @@ -1837,7 +1931,20 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> 
>   void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   {
> +	/*
> +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
> +	 * before reporting dirty_bitmap to userspace.  KVM flushes the buffers
> +	 * on all VM-Exits, thus we only need to kick running vCPUs to force a
> +	 * VM-Exit.
> +	 */
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> 
> +	if (!kvm->enable_hdbss)
> +		return;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_vcpu_kick(vcpu);
>   }
> 
>   static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index cc7d5d1709cb..9ba0ea6305ef 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -412,6 +412,49 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
>   	return arm_exit_handlers[esr_ec];
>   }
> 
> +static void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
> +{
> +	int idx, curr_idx;
> +	u64 *hdbss_buf;
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 br_el2;
> +
> +	if (!kvm->enable_hdbss)
> +		return;
> +
> +	dsb(sy);
> +	isb();
> +	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
> +	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
> +
> +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
> +	if (curr_idx == 0 || br_el2 == 0)
> +		return;
> +
> +	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
> +	if (!hdbss_buf) {
> +		kvm_err("Enter flush hdbss buffer with buffer == NULL!");
> +		return;
> +	}
> +
> +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
> +	for (idx = 0; idx < curr_idx; idx++) {
> +		u64 gpa;
> +
> +		gpa = hdbss_buf[idx];
> +		if (!(gpa & HDBSS_ENTRY_VALID))
> +			continue;
> +
> +		gpa &= HDBSS_ENTRY_IPA;
> +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> +	}
> +
> +	/* reset HDBSS index */
> +	write_sysreg_s(0, SYS_HDBSSPROD_EL2);
> +	vcpu->arch.hdbss.next_index = 0;
> +	isb();
> +}
> +
>   /*
>    * We may be single-stepping an emulated instruction. If the emulation
>    * has been completed in the kernel, we can return to userspace with a
> @@ -447,6 +490,8 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
>   {
>   	struct kvm_run *run = vcpu->run;
> 
> +	kvm_flush_hdbss_buffer(vcpu);
> +
>   	if (ARM_SERROR_PENDING(exception_index)) {
>   		/*
>   		 * The SError is handled by handle_exit_early(). If the guest
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 9984c492305a..3787c9c5810d 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -220,6 +220,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>   	__vcpu_load_switch_sysregs(vcpu);
>   	__vcpu_load_activate_traps(vcpu);
>   	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
> +	__load_hdbss(vcpu);
>   }
> 
>   void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7cc964af8d30..91a2f9dbb406 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1843,6 +1843,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (writable)
>   		prot |= KVM_PGTABLE_PROT_W;
> 
> +	if (writable && kvm->enable_hdbss && logging_active)
> +		prot |= KVM_PGTABLE_PROT_DBM;
> +
>   	if (exec_fault)
>   		prot |= KVM_PGTABLE_PROT_X;
> 
> @@ -1950,6 +1953,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> 
>   	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> 
> +	/*
> +	 * HDBSS buffer already flushed when enter handle_trap_exceptions().
> +	 * Nothing to do here.
> +	 */
> +	if (ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF)
> +		return 1;
> +
>   	if (esr_fsc_is_translation_fault(esr)) {
>   		/* Beyond sanitised PARange (which is the IPA limit) */
>   		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 959532422d3a..65e8f890f863 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -161,6 +161,9 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>   	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>   	kfree(vcpu->arch.vncr_tlb);
>   	kfree(vcpu->arch.ccsidr);
> +
> +	if (vcpu->arch.hdbss.base_phys || vcpu->arch.hdbss.size)
> +		kvm_arm_vcpu_free_hdbss(vcpu);
>   }
> 
>   static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5bd76cf394fa..aa8138604b1e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -876,6 +876,7 @@ struct kvm {
>   	struct xarray mem_attr_array;
>   #endif
>   	char stats_id[KVM_STATS_NAME_SIZE];
> +	bool enable_hdbss;
>   };
> 
>   #define kvm_err(fmt, ...) \
> --
> 2.33.0
> 
> 


