Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4FF33F0F6
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 14:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCQNQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 09:16:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhCQNPp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 09:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615986945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aQpAGIOZCMr6zrvsbjgOgyUw3PapdDNaxrsZT0anQzg=;
        b=LlLM7ijaKWz8Ow7zW6bQLY5xTraOkjc1A/mZBiXS+KFJJIezx7GmM8OWOk2XZ68RUSIJak
        DJDXlFU9M3l+oZjODkbcFOaQuBgPii45Q6J9t6uNbsFfUIxz3J/zF8hcn24jGdcCulpl2e
        BoQFCxFb4TZgOtTv5muX2zMSiD9cAi4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-fWHCeK9MOeebyxIfKM3Onw-1; Wed, 17 Mar 2021 09:15:42 -0400
X-MC-Unique: fWHCeK9MOeebyxIfKM3Onw-1
Received: by mail-wr1-f71.google.com with SMTP id p12so15809357wrn.18
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 06:15:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aQpAGIOZCMr6zrvsbjgOgyUw3PapdDNaxrsZT0anQzg=;
        b=BqAFoRSCSKlSKLyUmlYc84xL90X6BdTGsid0Ucb/Xbp3fQxe5IuhICTvG7Cnh9dVUG
         OWgHfU+97G+z3yIkmDE/IF5OwVpvq4LdqIHtyj2kCl8JMVobiAhoOweOKlHueIZtuU5n
         tQjFkdTd4ZHGnKNWPG3jcySQfrIBiylA0Ly6g0SBQy8b60A3KwxEJyuHgHcF9Hr/YiiR
         eMtxJ1UxRb5HcNFGwTk/kfxgpI1COXIvJ3O7BL2+UdbszPnEc7eghebDuCvAUwwzlqe4
         wjC3rLz5deAKSyPgC6EzW0Mc0OApCfmDfKd9mOx25tAZaD7sGFCy9FzTJ45fnw555UNy
         MH8g==
X-Gm-Message-State: AOAM530NsE2yBM0zk7m2SJRXLFKRiwGfVxAIOdmr4vzF1xOeyRfWnRjw
        GMP5j4/4lYasWiI/HarB02YH4F9qiyLRD7hLFwq9w+lKbGLvU/CVlwrQ2kLMARbqbu5F9cA613t
        prim7mn1Btu2F
X-Received: by 2002:adf:f303:: with SMTP id i3mr4306593wro.67.1615986940755;
        Wed, 17 Mar 2021 06:15:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9PHSdun3TFAYRY50AzF6uibM0PIjRHbT2qtWhgFAEDlR+SZ9X0pUPC7H1ESHRU38j6UbWwg==
X-Received: by 2002:adf:f303:: with SMTP id i3mr4306563wro.67.1615986940484;
        Wed, 17 Mar 2021 06:15:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e1sm26781395wrd.44.2021.03.17.06.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 06:15:39 -0700 (PDT)
Subject: Re: [PATCH 1/4] KVM: x86: Protect userspace MSR filter with SRCU, and
 set atomically-ish
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
References: <20210316184436.2544875-1-seanjc@google.com>
 <20210316184436.2544875-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cdf00201-b24c-0337-a49f-01df61a45fd1@redhat.com>
Date:   Wed, 17 Mar 2021 14:15:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210316184436.2544875-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/21 19:44, Sean Christopherson wrote:
> Fix a plethora of issues with MSR filtering by installing the resulting
> filter as an atomic bundle instead of updating the live filter one range
> at a time.  The KVM_X86_SET_MSR_FILTER ioctl() isn't truly atomic, as
> the hardware MSR bitmaps won't be updated until the next VM-Enter, but
> the relevant software struct is atomically updated, which is what KVM
> really needs.
> 
> Similar to the approach used for modifying memslots, make arch.msr_filter
> a SRCU-protected pointer, do all the work configuring the new filter
> outside of kvm->lock, and then acquire kvm->lock only when the new filter
> has been vetted and created.  That way vCPU readers either see the old
> filter or the new filter in their entirety, not some half-baked state.
> 
> Yuan Yao pointed out a use-after-free in ksm_msr_allowed() due to a
> TOCTOU bug, but that's just the tip of the iceberg...
> 
>    - Nothing is __rcu annotated, making it nigh impossible to audit the
>      code for correctness.
>    - kvm_add_msr_filter() has an unpaired smp_wmb().  Violation of kernel
>      coding style aside, the lack of a smb_rmb() anywhere casts all code
>      into doubt.
>    - kvm_clear_msr_filter() has a double free TOCTOU bug, as it grabs
>      count before taking the lock.
>    - kvm_clear_msr_filter() also has memory leak due to the same TOCTOU bug.
> 
> The entire approach of updating the live filter is also flawed.  While
> installing a new filter is inherently racy if vCPUs are running, fixing
> the above issues also makes it trivial to ensure certain behavior is
> deterministic, e.g. KVM can provide deterministic behavior for MSRs with
> identical settings in the old and new filters.  An atomic update of the
> filter also prevents KVM from getting into a half-baked state, e.g. if
> installing a filter fails, the existing approach would leave the filter
> in a half-baked state, having already committed whatever bits of the
> filter were already processed.
> 
> [*] https://lkml.kernel.org/r/20210312083157.25403-1-yaoyuan0329os@gmail.com
> 
> Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
> Cc: stable@vger.kernel.org
> Cc: Alexander Graf <graf@amazon.com>
> Reported-by: Yuan Yao <yaoyuan0329os@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   Documentation/virt/kvm/api.rst  |   6 +-
>   arch/x86/include/asm/kvm_host.h |  17 ++---
>   arch/x86/kvm/x86.c              | 109 +++++++++++++++++++-------------
>   3 files changed, 78 insertions(+), 54 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 38e327d4b479..2898d3e86b08 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4806,8 +4806,10 @@ If an MSR access is not permitted through the filtering, it generates a
>   allows user space to deflect and potentially handle various MSR accesses
>   into user space.
>   
> -If a vCPU is in running state while this ioctl is invoked, the vCPU may
> -experience inconsistent filtering behavior on MSR accesses.
> +Note, invoking this ioctl with a vCPU is running is inherently racy.  However,
> +KVM does guarantee that vCPUs will see either the previous filter or the new
> +filter, e.g. MSRs with identical settings in both the old and new filter will
> +have deterministic behavior.
>   
>   4.127 KVM_XEN_HVM_SET_ATTR
>   --------------------------
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a52f973bdff6..84198c403a48 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -931,6 +931,12 @@ enum kvm_irqchip_mode {
>   	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
>   };
>   
> +struct kvm_x86_msr_filter {
> +	u8 count;
> +	bool default_allow:1;
> +	struct msr_bitmap_range ranges[16];
> +};
> +
>   #define APICV_INHIBIT_REASON_DISABLE    0
>   #define APICV_INHIBIT_REASON_HYPERV     1
>   #define APICV_INHIBIT_REASON_NESTED     2
> @@ -1025,16 +1031,11 @@ struct kvm_arch {
>   	bool guest_can_read_msr_platform_info;
>   	bool exception_payload_enabled;
>   
> +	bool bus_lock_detection_enabled;
> +
>   	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
>   	u32 user_space_msr_mask;
> -
> -	struct {
> -		u8 count;
> -		bool default_allow:1;
> -		struct msr_bitmap_range ranges[16];
> -	} msr_filter;
> -
> -	bool bus_lock_detection_enabled;
> +	struct kvm_x86_msr_filter __rcu *msr_filter;
>   
>   	struct kvm_pmu_event_filter __rcu *pmu_event_filter;
>   	struct task_struct *nx_lpage_recovery_thread;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a9d95f90a048..c55769620b9a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1529,35 +1529,44 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
>   
>   bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>   {
> +	struct kvm_x86_msr_filter *msr_filter;
> +	struct msr_bitmap_range *ranges;
>   	struct kvm *kvm = vcpu->kvm;
> -	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
> -	u32 count = kvm->arch.msr_filter.count;
> -	u32 i;
> -	bool r = kvm->arch.msr_filter.default_allow;
> +	bool allowed;
>   	int idx;
> +	u32 i;
>   
> -	/* MSR filtering not set up or x2APIC enabled, allow everything */
> -	if (!count || (index >= 0x800 && index <= 0x8ff))
> +	/* x2APIC MSRs do not support filtering. */
> +	if (index >= 0x800 && index <= 0x8ff)
>   		return true;
>   
> -	/* Prevent collision with set_msr_filter */
>   	idx = srcu_read_lock(&kvm->srcu);
>   
> -	for (i = 0; i < count; i++) {
> +	msr_filter = srcu_dereference(kvm->arch.msr_filter, &kvm->srcu);
> +	if (!msr_filter) {
> +		allowed = true;
> +		goto out;
> +	}
> +
> +	allowed = msr_filter->default_allow;
> +	ranges = msr_filter->ranges;
> +
> +	for (i = 0; i < msr_filter->count; i++) {
>   		u32 start = ranges[i].base;
>   		u32 end = start + ranges[i].nmsrs;
>   		u32 flags = ranges[i].flags;
>   		unsigned long *bitmap = ranges[i].bitmap;
>   
>   		if ((index >= start) && (index < end) && (flags & type)) {
> -			r = !!test_bit(index - start, bitmap);
> +			allowed = !!test_bit(index - start, bitmap);
>   			break;
>   		}
>   	}
>   
> +out:
>   	srcu_read_unlock(&kvm->srcu, idx);
>   
> -	return r;
> +	return allowed;
>   }
>   EXPORT_SYMBOL_GPL(kvm_msr_allowed);
>   
> @@ -5389,25 +5398,34 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   	return r;
>   }
>   
> -static void kvm_clear_msr_filter(struct kvm *kvm)
> +static struct kvm_x86_msr_filter *kvm_alloc_msr_filter(bool default_allow)
> +{
> +	struct kvm_x86_msr_filter *msr_filter;
> +
> +	msr_filter = kzalloc(sizeof(*msr_filter), GFP_KERNEL_ACCOUNT);
> +	if (!msr_filter)
> +		return NULL;
> +
> +	msr_filter->default_allow = default_allow;
> +	return msr_filter;
> +}
> +
> +static void kvm_free_msr_filter(struct kvm_x86_msr_filter *msr_filter)
>   {
>   	u32 i;
> -	u32 count = kvm->arch.msr_filter.count;
> -	struct msr_bitmap_range ranges[16];
>   
> -	mutex_lock(&kvm->lock);
> -	kvm->arch.msr_filter.count = 0;
> -	memcpy(ranges, kvm->arch.msr_filter.ranges, count * sizeof(ranges[0]));
> -	mutex_unlock(&kvm->lock);
> -	synchronize_srcu(&kvm->srcu);
> +	if (!msr_filter)
> +		return;
>   
> -	for (i = 0; i < count; i++)
> -		kfree(ranges[i].bitmap);
> +	for (i = 0; i < msr_filter->count; i++)
> +		kfree(msr_filter->ranges[i].bitmap);
> +
> +	kfree(msr_filter);
>   }
>   
> -static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user_range)
> +static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
> +			      struct kvm_msr_filter_range *user_range)
>   {
> -	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
>   	struct msr_bitmap_range range;
>   	unsigned long *bitmap = NULL;
>   	size_t bitmap_size;
> @@ -5441,11 +5459,9 @@ static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user
>   		goto err;
>   	}
>   
> -	/* Everything ok, add this range identifier to our global pool */
> -	ranges[kvm->arch.msr_filter.count] = range;
> -	/* Make sure we filled the array before we tell anyone to walk it */
> -	smp_wmb();
> -	kvm->arch.msr_filter.count++;
> +	/* Everything ok, add this range identifier. */
> +	msr_filter->ranges[msr_filter->count] = range;
> +	msr_filter->count++;
>   
>   	return 0;
>   err:
> @@ -5456,10 +5472,11 @@ static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user
>   static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_msr_filter __user *user_msr_filter = argp;
> +	struct kvm_x86_msr_filter *new_filter, *old_filter;
>   	struct kvm_msr_filter filter;
>   	bool default_allow;
> -	int r = 0;
>   	bool empty = true;
> +	int r = 0;
>   	u32 i;
>   
>   	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
> @@ -5472,25 +5489,32 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
>   	if (empty && !default_allow)
>   		return -EINVAL;
>   
> -	kvm_clear_msr_filter(kvm);
> +	new_filter = kvm_alloc_msr_filter(default_allow);
> +	if (!new_filter)
> +		return -ENOMEM;
>   
> -	kvm->arch.msr_filter.default_allow = default_allow;
> -
> -	/*
> -	 * Protect from concurrent calls to this function that could trigger
> -	 * a TOCTOU violation on kvm->arch.msr_filter.count.
> -	 */
> -	mutex_lock(&kvm->lock);
>   	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
> -		r = kvm_add_msr_filter(kvm, &filter.ranges[i]);
> -		if (r)
> -			break;
> +		r = kvm_add_msr_filter(new_filter, &filter.ranges[i]);
> +		if (r) {
> +			kvm_free_msr_filter(new_filter);
> +			return r;
> +		}
>   	}
>   
> +	mutex_lock(&kvm->lock);
> +
> +	/* The per-VM filter is protected by kvm->lock... */
> +	old_filter = srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1);
> +
> +	rcu_assign_pointer(kvm->arch.msr_filter, new_filter);
> +	synchronize_srcu(&kvm->srcu);
> +
> +	kvm_free_msr_filter(old_filter);
> +
>   	kvm_make_all_cpus_request(kvm, KVM_REQ_MSR_FILTER_CHANGED);
>   	mutex_unlock(&kvm->lock);
>   
> -	return r;
> +	return 0;
>   }
>   
>   long kvm_arch_vm_ioctl(struct file *filp,
> @@ -10693,8 +10717,6 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
>   
>   void kvm_arch_destroy_vm(struct kvm *kvm)
>   {
> -	u32 i;
> -
>   	if (current->mm == kvm->mm) {
>   		/*
>   		 * Free memory regions allocated on behalf of userspace,
> @@ -10710,8 +10732,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   		mutex_unlock(&kvm->slots_lock);
>   	}
>   	static_call_cond(kvm_x86_vm_destroy)(kvm);
> -	for (i = 0; i < kvm->arch.msr_filter.count; i++)
> -		kfree(kvm->arch.msr_filter.ranges[i].bitmap);
> +	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
>   	kvm_pic_destroy(kvm);
>   	kvm_ioapic_destroy(kvm);
>   	kvm_free_vcpus(kvm);
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

