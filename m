Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2488E33DCC5
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 19:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbhCPSpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 14:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240094AbhCPSou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 14:44:50 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4C9C061762
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:44:48 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id p133so3776432qka.17
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GOg8aEutRplmgR/4P/VzxUp6Yi8jfdN0FR519oaYWrc=;
        b=Iy72Y99kOz5uKye1akbdGo6zr4Gnee7C6OlDNU7Cw9It0wztc7FisaN1686t+1ZqJ0
         VBx3s6LjfEkRBhWQTshWvKvkt5uwGRE0x5UgH03AaR/v+si0sMoJX9tuwqhwGqaYgUsS
         lBoXct8kipIr5YSPA93aSWScN8sUfmZFcAV7GwQ99XU/jrulQq2xKUvh4jn22CGf1HsX
         scffnoFTN3An3b0ToSy9auJyJscOJLPzm40ZAC8SMgCvLNogZ7yaasTqqNJVkrGS+PDJ
         VYaUzKhbJEgeRSp0s+bCo9ye9fH1S9Rff9qyuN7ytdsX+k6/AOrf4FQ28QPdiwqTwWWp
         ndww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GOg8aEutRplmgR/4P/VzxUp6Yi8jfdN0FR519oaYWrc=;
        b=I+/OdrbC4jzrTfpnBDo9aVmH+XyBL1tBCyTQUmFkFVCLKqd4Mp5lonrSqcXDFg8dIx
         rAzED2AcSoLv0OPCNiBHCTzFCD9Xkt5xfWXCRoi5WzAv6av7LzQue38wLzAHfqd/04zs
         N4jzv7vI+d91WNB5lcQVBeCbAYTbg2Sgyb1XqYzv+dOAzQyPvQEozYviYEN5gfdn6ozU
         kMW6WjjwNnYkRfNzOXDExDUKzS5EDDEIeEToykOMpXTU4vzPnWCfhfUwjiC7xRonV+1r
         Nw6VOFblMoOOnYFncdMeOFp/5cNeMI5wY7VE9CH2tC2ZUWZtwm01ZH0C8mr6yNU1yI+0
         6w+A==
X-Gm-Message-State: AOAM533TzF5XjQqdrHDttNTsH9LY/MkKMV+LyOIz6kOAID07mEJXN9op
        YrnBzwZhnltg4NKFfVVNmqWbWyq7WVs=
X-Google-Smtp-Source: ABdhPJxBlkuFU89c8G0sun/hbzG5+J/NDhCEAGF/cUpeVhBUZUnHmEQmi/Xz9ljf6tHnMp1SUcDksj0mNrM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
 (user=seanjc job=sendgmr) by 2002:ad4:5d46:: with SMTP id jk6mr870821qvb.22.1615920287805;
 Tue, 16 Mar 2021 11:44:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 16 Mar 2021 11:44:33 -0700
In-Reply-To: <20210316184436.2544875-1-seanjc@google.com>
Message-Id: <20210316184436.2544875-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210316184436.2544875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 1/4] KVM: x86: Protect userspace MSR filter with SRCU, and set atomically-ish
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a plethora of issues with MSR filtering by installing the resulting
filter as an atomic bundle instead of updating the live filter one range
at a time.  The KVM_X86_SET_MSR_FILTER ioctl() isn't truly atomic, as
the hardware MSR bitmaps won't be updated until the next VM-Enter, but
the relevant software struct is atomically updated, which is what KVM
really needs.

Similar to the approach used for modifying memslots, make arch.msr_filter
a SRCU-protected pointer, do all the work configuring the new filter
outside of kvm->lock, and then acquire kvm->lock only when the new filter
has been vetted and created.  That way vCPU readers either see the old
filter or the new filter in their entirety, not some half-baked state.

Yuan Yao pointed out a use-after-free in ksm_msr_allowed() due to a
TOCTOU bug, but that's just the tip of the iceberg...

  - Nothing is __rcu annotated, making it nigh impossible to audit the
    code for correctness.
  - kvm_add_msr_filter() has an unpaired smp_wmb().  Violation of kernel
    coding style aside, the lack of a smb_rmb() anywhere casts all code
    into doubt.
  - kvm_clear_msr_filter() has a double free TOCTOU bug, as it grabs
    count before taking the lock.
  - kvm_clear_msr_filter() also has memory leak due to the same TOCTOU bug.

The entire approach of updating the live filter is also flawed.  While
installing a new filter is inherently racy if vCPUs are running, fixing
the above issues also makes it trivial to ensure certain behavior is
deterministic, e.g. KVM can provide deterministic behavior for MSRs with
identical settings in the old and new filters.  An atomic update of the
filter also prevents KVM from getting into a half-baked state, e.g. if
installing a filter fails, the existing approach would leave the filter
in a half-baked state, having already committed whatever bits of the
filter were already processed.

[*] https://lkml.kernel.org/r/20210312083157.25403-1-yaoyuan0329os@gmail.com

Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
Cc: stable@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>
Reported-by: Yuan Yao <yaoyuan0329os@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  |   6 +-
 arch/x86/include/asm/kvm_host.h |  17 ++---
 arch/x86/kvm/x86.c              | 109 +++++++++++++++++++-------------
 3 files changed, 78 insertions(+), 54 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 38e327d4b479..2898d3e86b08 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4806,8 +4806,10 @@ If an MSR access is not permitted through the filtering, it generates a
 allows user space to deflect and potentially handle various MSR accesses
 into user space.
 
-If a vCPU is in running state while this ioctl is invoked, the vCPU may
-experience inconsistent filtering behavior on MSR accesses.
+Note, invoking this ioctl with a vCPU is running is inherently racy.  However,
+KVM does guarantee that vCPUs will see either the previous filter or the new
+filter, e.g. MSRs with identical settings in both the old and new filter will
+have deterministic behavior.
 
 4.127 KVM_XEN_HVM_SET_ATTR
 --------------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a52f973bdff6..84198c403a48 100644
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
 
 	struct kvm_pmu_event_filter __rcu *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d95f90a048..c55769620b9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1529,35 +1529,44 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
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
 
@@ -5389,25 +5398,34 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
@@ -5441,11 +5459,9 @@ static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user
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
@@ -5456,10 +5472,11 @@ static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user
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
@@ -5472,25 +5489,32 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
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
@@ -10693,8 +10717,6 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	u32 i;
-
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
@@ -10710,8 +10732,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
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
2.31.0.rc2.261.g7f71774620-goog

