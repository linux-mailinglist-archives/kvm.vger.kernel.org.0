Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0731D3399F8
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 00:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhCLXTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 18:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhCLXTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 18:19:23 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA9CC061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 15:19:23 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id n17so9073121plc.7
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 15:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0xZz6ndvRvZY3mnMDpcSKy6kRPpkiZ/7RJBHONszaBw=;
        b=f6sPScv2MRw7kafUhTep5DWychReF+dx60boJo2xmxONcFQRD9kzA+sTG3X8ebasVO
         5elDf5kDOVtXb5ZvL9zus4a1cnOkZaNeL8WTLuXj26xTp/qsrsWXyeDNJclHkqqM17sN
         hjBM5dqlg3ZcHGeJ+II8eKk7SRlxu7Y8SLTqY1y2ns1TbxgDR7MU7qfRV2nGBVskPMHf
         qHRNhST8KdKjobo0eKxa3T+97zceIDaaG9S78s3PNqBj36Iv74NoP9A9Gcts9w2siqKR
         YCK2QAWpPH4v5U+MWWhBfv01D2+jE8RqnsXcB4qZ2JKGR0Odfz/h52MsojoMQ4baV809
         hgmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0xZz6ndvRvZY3mnMDpcSKy6kRPpkiZ/7RJBHONszaBw=;
        b=RWtHREjYXRztTp3qk9cp9s4kOxrui8wPrv7cKiNYySLtOieML2lZWkPGhtKYWl+buR
         r8kLkJzwHsgvtYwVjYo74ITTWBFFv57LAt/HhXhBOpoo2yDYb/ROd9oTbUPownWaoZDB
         Thl8fikBD55BKUF5Gq+YyGvXfyszZzN9xue4uddU3m3P+pzbEvqir1RnzJw0FHU3Rhhv
         gRISODowBKic27pvSHjAC1o6W3wxsDB4r+TaHNDYCxPvXudgYBaQnqDn0NaRx6/1qcmT
         uTpXbKNLU+3W43UJKiUDWfkdPQ6U5Nwp3uztyXK86+jylRfvVzPzf5P5TYd/Xn5I2FZL
         PH/g==
X-Gm-Message-State: AOAM530SXV7MdOPoNEKtKQLtC0Ej73AMTQhzE68C4Ksf8CfgtEDYNrae
        sQTWUubdcfG+1gpQsjecQ5rzDLwwEZnnGA==
X-Google-Smtp-Source: ABdhPJz6Er40iDrsMKzBvozOvFZBBJY/XWucZZwukcQuMUTAA0R5/0bSzHwuBdVm0JL/QmqeVC+FUg==
X-Received: by 2002:a17:90a:ec15:: with SMTP id l21mr626277pjy.164.1615591162784;
        Fri, 12 Mar 2021 15:19:22 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id 3sm6470135pfh.13.2021.03.12.15.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 15:19:22 -0800 (PST)
Date:   Fri, 12 Mar 2021 15:19:15 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yaoyuan0329os@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix potential bitmap corruption in ksm_msr_allowed()
Message-ID: <YEv2815IrVElkClK@google.com>
References: <20210312083157.25403-1-yaoyuan0329os@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312083157.25403-1-yaoyuan0329os@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021, Yuan Yao wrote:
> ---
>  arch/x86/kvm/x86.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 46b0e52671bb..d6bc1b858167 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1528,18 +1528,22 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
> -	u32 count = kvm->arch.msr_filter.count;
> +	u32 count;
>  	u32 i;
>  	bool r = kvm->arch.msr_filter.default_allow;
>  	int idx;
>  
>  	/* MSR filtering not set up or x2APIC enabled, allow everything */
> -	if (!count || (index >= 0x800 && index <= 0x8ff))
> +	if (index >= 0x800 && index <= 0x8ff)
>  		return true;
>  
>  	/* Prevent collision with set_msr_filter */
>  	idx = srcu_read_lock(&kvm->srcu);
>  
> +	count = kvm->arch.msr_filter.count;

There really should be be a srcu_dereference_check if we're relying on SRCU for
protection.  But that's just the tip of the iceberg...

  - Nothing is __rcu annotated, at all.
  - kvm_add_msr_filter() has an unpaired smp_wmb(), which is likely "fixed" by
    getting the count while holding srcu, but still...
  - kvm_clear_msr_filter() has a double free TOCTOU bug, as it grabs
    count before taking the lock.
  - kvm_clear_msr_filter() also has memory leak due to the same TOCTOU bug.

And all of _that_ is somewhat of a moot point, because the entire approach is
fubar.  By clearing the filter in a separate operation before setting the new
filters, vCPUs may not exit on MSR accesses, even if an MSR was filtered in both
the old and new list.  That may or may not be problematic for people's use cases,
but it's a horrible ABI, e.g. adding an MSR to the list effectively requires
stopping all vCPUs to avoid non-deterministic behavior, and to guarnatee that
MSRs (in both lists) continue to get filtered.

Similarly, if kvm_add_msr_filter() fails, it will leaves the filter list in
a half-set state.

It's ok that there's a delay in updating the VMCS/VMCB bitmaps, since we just
need to guarantee the bitmaps are updated before returning, but updating the
filters themselves on the fly breaks the existing filter, and leaving the filter
in an unknown state is no good.

The easiest solution I can think of is to mimic memslots, i.e. make
arch.msr_filter a SRCU-protected pointer, do all the work configuring the new
filter outside of the lock, and then acquire kvm->lock only when the new filter
has been vetted and created.  That way vCPU readers either see the old filter or
the new filter in their entirety, not some half-baked state.

Compile tested only.  I'll test and post next week, assuming no one objects to
the idea.

---
 arch/x86/include/asm/kvm_host.h |  17 ++---
 arch/x86/kvm/x86.c              | 109 +++++++++++++++++++-------------
 2 files changed, 74 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e43e34eb990d..f2ebafe288df 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -931,6 +931,12 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };

+struct kvm_x86_msr_filter {
+	u8 count;
+	bool default_allow:1;
+	struct msr_bitmap_range ranges[16];
+};
+
 #define APICV_INHIBIT_REASON_DISABLE    0
 #define APICV_INHIBIT_REASON_HYPERV     1
 #define APICV_INHIBIT_REASON_NESTED     2
@@ -1025,16 +1031,11 @@ struct kvm_arch {
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;

+	bool bus_lock_detection_enabled;
+
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	u32 user_space_msr_mask;
-
-	struct {
-		u8 count;
-		bool default_allow:1;
-		struct msr_bitmap_range ranges[16];
-	} msr_filter;
-
-	bool bus_lock_detection_enabled;
+	struct kvm_x86_msr_filter __rcu *msr_filter;

 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 012d5dff7d44..fe9143549ee1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1528,35 +1528,44 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);

 bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 {
+	struct kvm_x86_msr_filter *msr_filter;
+	struct msr_bitmap_range *ranges;
 	struct kvm *kvm = vcpu->kvm;
-	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
-	u32 count = kvm->arch.msr_filter.count;
-	u32 i;
-	bool r = kvm->arch.msr_filter.default_allow;
+	bool allowed;
 	int idx;
+	u32 i;

-	/* MSR filtering not set up or x2APIC enabled, allow everything */
-	if (!count || (index >= 0x800 && index <= 0x8ff))
+	/* x2APIC MSRs do not support filtering. */
+	if (index >= 0x800 && index <= 0x8ff)
 		return true;

-	/* Prevent collision with set_msr_filter */
 	idx = srcu_read_lock(&kvm->srcu);

-	for (i = 0; i < count; i++) {
+	msr_filter = srcu_dereference(kvm->arch.msr_filter, &kvm->srcu);
+	if (!msr_filter) {
+		allowed = true;
+		goto out;
+	}
+
+	allowed = msr_filter->default_allow;
+	ranges = msr_filter->ranges;
+
+	for (i = 0; i < msr_filter->count; i++) {
 		u32 start = ranges[i].base;
 		u32 end = start + ranges[i].nmsrs;
 		u32 flags = ranges[i].flags;
 		unsigned long *bitmap = ranges[i].bitmap;

 		if ((index >= start) && (index < end) && (flags & type)) {
-			r = !!test_bit(index - start, bitmap);
+			allowed = !!test_bit(index - start, bitmap);
 			break;
 		}
 	}

+out:
 	srcu_read_unlock(&kvm->srcu, idx);

-	return r;
+	return allowed;
 }
 EXPORT_SYMBOL_GPL(kvm_msr_allowed);

@@ -5387,25 +5396,34 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }

-static void kvm_clear_msr_filter(struct kvm *kvm)
+static struct kvm_x86_msr_filter *kvm_alloc_msr_filter(bool default_allow)
+{
+	struct kvm_x86_msr_filter *msr_filter;
+
+	msr_filter = kzalloc(sizeof(*msr_filter), GFP_KERNEL_ACCOUNT);
+	if (!msr_filter)
+		return NULL;
+
+	msr_filter->default_allow = default_allow;
+	return msr_filter;
+}
+
+static void kvm_free_msr_filter(struct kvm_x86_msr_filter *msr_filter)
 {
 	u32 i;
-	u32 count = kvm->arch.msr_filter.count;
-	struct msr_bitmap_range ranges[16];

-	mutex_lock(&kvm->lock);
-	kvm->arch.msr_filter.count = 0;
-	memcpy(ranges, kvm->arch.msr_filter.ranges, count * sizeof(ranges[0]));
-	mutex_unlock(&kvm->lock);
-	synchronize_srcu(&kvm->srcu);
+	if (!msr_filter)
+		return;

-	for (i = 0; i < count; i++)
-		kfree(ranges[i].bitmap);
+	for (i = 0; i < msr_filter->count; i++)
+		kfree(msr_filter->ranges[i].bitmap);
+
+	kfree(msr_filter);
 }

-static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user_range)
+static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
+			      struct kvm_msr_filter_range *user_range)
 {
-	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
 	struct msr_bitmap_range range;
 	unsigned long *bitmap = NULL;
 	size_t bitmap_size;
@@ -5439,11 +5457,9 @@ static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user
 		goto err;
 	}

-	/* Everything ok, add this range identifier to our global pool */
-	ranges[kvm->arch.msr_filter.count] = range;
-	/* Make sure we filled the array before we tell anyone to walk it */
-	smp_wmb();
-	kvm->arch.msr_filter.count++;
+	/* Everything ok, add this range identifier. */
+	msr_filter->ranges[msr_filter->count] = range;
+	msr_filter->count++;

 	return 0;
 err:
@@ -5454,10 +5470,11 @@ static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user
 static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_msr_filter __user *user_msr_filter = argp;
+	struct kvm_x86_msr_filter *new_filter, *old_filter;
 	struct kvm_msr_filter filter;
 	bool default_allow;
-	int r = 0;
 	bool empty = true;
+	int r = 0;
 	u32 i;

 	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
@@ -5470,25 +5487,32 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (empty && !default_allow)
 		return -EINVAL;

-	kvm_clear_msr_filter(kvm);
+	new_filter = kvm_alloc_msr_filter(default_allow);
+	if (!new_filter)
+		return -ENOMEM;

-	kvm->arch.msr_filter.default_allow = default_allow;
-
-	/*
-	 * Protect from concurrent calls to this function that could trigger
-	 * a TOCTOU violation on kvm->arch.msr_filter.count.
-	 */
-	mutex_lock(&kvm->lock);
 	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
-		r = kvm_add_msr_filter(kvm, &filter.ranges[i]);
-		if (r)
-			break;
+		r = kvm_add_msr_filter(new_filter, &filter.ranges[i]);
+		if (r) {
+			kvm_free_msr_filter(new_filter);
+			return r;
+		}
 	}

+	mutex_lock(&kvm->lock);
+
+	/* The per-VM filter is protected by kvm->lock... */
+	old_filter = srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1);
+
+	rcu_assign_pointer(kvm->arch.msr_filter, new_filter);
+	synchronize_srcu(&kvm->srcu);
+
+	kvm_free_msr_filter(old_filter);
+
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MSR_FILTER_CHANGED);
 	mutex_unlock(&kvm->lock);

-	return r;
+	return 0;
 }

 long kvm_arch_vm_ioctl(struct file *filp,
@@ -10691,8 +10715,6 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)

 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	u32 i;
-
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
@@ -10708,8 +10730,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		mutex_unlock(&kvm->slots_lock);
 	}
 	static_call_cond(kvm_x86_vm_destroy)(kvm);
-	for (i = 0; i < kvm->arch.msr_filter.count; i++)
-		kfree(kvm->arch.msr_filter.ranges[i].bitmap);
+	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);
--
