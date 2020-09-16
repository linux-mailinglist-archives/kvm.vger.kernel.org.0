Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0480126CB9E
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgIPUak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:30:40 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:55430 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgIPUah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 16:30:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600288235; x=1631824235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=46f+JIrLmxBQEn7ClLYRwNmnoA+iQjXV9bkZXocHn2A=;
  b=PziupjaoEkC+hOiYM3d01Xqb6V9/dDWcYXdn2SMtG7Uw48seOVTPkJZ7
   r3s1Gvju06YrVEN6lYpe4mDzTaJqmz0/MWw4kTbuoGNwqZSCRBlSZuThU
   e/kY2Jp7hVuC/E93pSfnD3+eXCUO+MxdoVzsMZqcYhtXV43jU6x7Hu1JD
   I=;
X-IronPort-AV: E=Sophos;i="5.76,434,1592870400"; 
   d="scan'208";a="75597577"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 16 Sep 2020 20:30:33 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 5DB44A1E9B;
        Wed, 16 Sep 2020 20:30:31 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:30:30 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.85) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:30:27 +0000
From:   Alexander Graf <graf@amazon.com>
To:     kvm list <kvm@vger.kernel.org>
CC:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 6/7] KVM: x86: Introduce MSR filtering
Date:   Wed, 16 Sep 2020 22:29:50 +0200
Message-ID: <20200916202951.23760-7-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
In-Reply-To: <20200916202951.23760-1-graf@amazon.com>
References: <20200916202951.23760-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D01UWA004.ant.amazon.com (10.43.160.99) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's not desireable to have all MSRs always handled by KVM kernel space. Some
MSRs would be useful to handle in user space to either emulate behavior (like
uCode updates) or differentiate whether they are valid based on the CPU model.

To allow user space to specify which MSRs it wants to see handled by KVM,
this patch introduces a new ioctl to push filter rules with bitmaps into
KVM. Based on these bitmaps, KVM can then decide whether to reject MSR access.
With the addition of KVM_CAP_X86_USER_SPACE_MSR it can also deflect the
denied MSR events to user space to operate on.

If no filter is populated, MSR handling stays identical to before.

Signed-off-by: Alexander Graf <graf@amazon.com>

---

v2 -> v3:

  - document flags for KVM_X86_ADD_MSR_ALLOWLIST
  - generalize exit path, always unlock when returning
  - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
  - Add KVM_X86_CLEAR_MSR_ALLOWLIST

v3 -> v4:
  - lock allow check and clearing
  - free bitmaps on clear

v4 -> v5:

  - use srcu

v5 -> v6:

  - send filter change notification
  - change to atomic set_msr_filter ioctl with fallback flag
  - use EPERM for filter blocks
  - add bit for MSR user space deflection
  - check for overflow of BITS_TO_LONGS (thanks Dan Carpenter!)
  - s/int i;/u32 i;/
  - remove overlap check
---
 Documentation/virt/kvm/api.rst  | 103 +++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  14 +++
 arch/x86/include/uapi/asm/kvm.h |  21 ++++-
 arch/x86/kvm/svm/svm.c          |   4 +-
 arch/x86/kvm/x86.c              | 145 +++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h        |   5 ++
 6 files changed, 287 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index cb998af8b4d9..5d27542667db 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4704,6 +4704,94 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+4.126 KVM_X86_SET_MSR_FILTER
+----------------------------
+
+:Capability: KVM_X86_SET_MSR_FILTER
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_msr_filter
+:Returns: 0 on success, < 0 on error
+
+::
+
+  struct kvm_msr_filter_range {
+  #define KVM_MSR_FILTER_READ  (1 << 0)
+  #define KVM_MSR_FILTER_WRITE (1 << 1)
+	__u32 flags;
+	__u32 nmsrs; /* number of msrs in bitmap */
+	__u32 base;  /* MSR index the bitmap starts at */
+	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+  };
+  
+  struct kvm_msr_filter {
+  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+	__u32 flags;
+	struct kvm_msr_filter_range ranges[16];
+  };
+
+flags values:
+
+KVM_MSR_FILTER_READ
+
+  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a read should immediately fail, while a 1 indicates that
+  a read should be handled like without the filter.
+
+KVM_MSR_FILTER_WRITE
+
+  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a write should immediately fail, while a 1 indicates that
+  a write should be handled like without the filter.
+
+KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE
+
+  Filter booth read and write accesses to MSRs using the given bitmap. A 0
+  in the bitmap indicates that both reads and writes should immediately fail,
+  while a 1 indicates that reads and writes should be handled like without
+  the filter.
+
+KVM_MSR_FILTER_DEFAULT_ALLOW
+
+  If no filter range matches an MSR index that is getting accessed, KVM will
+  fall back to allowing access to the MSR.
+
+KVM_MSR_FILTER_DEFAULT_DENY
+
+  If no filter range matches an MSR index that is getting accessed, KVM will
+  fall back to rejecting access to the MSR. In this mode, all MSRs that should
+  be processed by KVM need to explicitly be marked as allowed in the bitmaps.
+
+This ioctl allows user space to define a up to 16 bitmaps of MSR ranges to
+specify whether a certain MSR access should be explicitly rejected or not.
+
+If this ioctl has never been invoked, MSR accesses are not guarded and the
+old KVM in-kernel emulation behavior is fully preserved.
+
+As soon as the filtering is in place, every MSR access is precessed through
+the filtering. If a bit is within one of the defined ranges, read and write
+accesses are guarded by the bitmap's value for the MSR index. If it is not
+defined in any range, whether MSR access is rejected is determined by the flags
+field of in the kvm_msr_filter struct: KVM_MSR_FILTER_DEFAULT_ALLOW and
+KVM_MSR_FILTER_DEFAULT_DENY.
+
+Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
+filtering. In that mode, KVM_MSR_FILTER_DEFAULT_DENY no longer has any effect.
+
+Each bitmap range specifies a range of MSRs to potentially allow access on.
+The range goes from MSR index [base .. base+nmsrs]. The flags field
+indicates whether reads, writes or both reads and writes are filtered
+by setting a 1 bit in the bitmap for the corresponding MSR index.
+
+If an MSR access is not permitted through the filtering, it generates a
+#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
+allows user space to deflect and potentially handle various MSR accesses
+into user space.
+
+If a vCPU is in running state while this ioctl is invoked, the vCPU may
+experience inconsistent filtering behavior on MSR accesses.
+
 
 5. The kvm_run structure
 ========================
@@ -5184,6 +5272,7 @@ receive MSR exit traps when a particular reason was requested during through
 ENABLE_CAP. Currently valid exit reasons are:
 
 	KVM_MSR_EXIT_REASON_INVAL - access to invalid MSRs or reserved bits
+	KVM_MSR_EXIT_REASON_FILTER - access blocked by KVM_X86_SET_MSR_FILTER
 
 For KVM_EXIT_X86_RDMSR, the "index" field tells user space which MSR the guest
 wants to read. To respond to this request with a successful read, user space
@@ -6242,3 +6331,17 @@ writes to user space. It can be enabled on a VM level. If enabled, MSR
 accesses that would usually trigger a #GP by KVM into the guest will
 instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
 KVM_EXIT_X86_WRMSR exit notifications.
+
+8.25 KVM_X86_SET_MSR_FILTER
+---------------------------
+
+:Architectures: x86
+
+This capability indicates that KVM supports that accesses to user defined MSRs
+may be rejected. With this capability exposed, KVM exports new VM ioctl
+KVM_X86_SET_MSR_FILTER which user space can call to specify bitmaps of MSR
+ranges that KVM should reject access to.
+
+In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
+trap and emulate MSRs that are outside of the scope of KVM as well as
+limit the attack surface on KVM's MSR emulation code.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bc4fa34c90b..4cfca1111dc0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -87,6 +87,7 @@
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
+#define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -860,6 +861,13 @@ struct kvm_hv {
 	struct kvm_hv_syndbg hv_syndbg;
 };
 
+struct msr_bitmap_range {
+	u32 flags;
+	u32 nmsrs;
+	u32 base;
+	unsigned long *bitmap;
+};
+
 enum kvm_irqchip_mode {
 	KVM_IRQCHIP_NONE,
 	KVM_IRQCHIP_KERNEL,       /* created with KVM_CREATE_IRQCHIP */
@@ -964,6 +972,12 @@ struct kvm_arch {
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	u32 user_space_msr_mask;
 
+	struct {
+		u8 count;
+		bool default_allow:1;
+		struct msr_bitmap_range ranges[16];
+	} msr_filter;
+
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 };
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 50650cfd235a..66bba91e1bb8 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -192,8 +192,25 @@ struct kvm_msr_list {
 	__u32 indices[0];
 };
 
-#define KVM_MSR_ALLOW_READ  (1 << 0)
-#define KVM_MSR_ALLOW_WRITE (1 << 1)
+/* Maximum size of any access bitmap in bytes */
+#define KVM_MSR_FILTER_MAX_BITMAP_SIZE 0x600
+
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range {
+#define KVM_MSR_FILTER_READ  (1 << 0)
+#define KVM_MSR_FILTER_WRITE (1 << 1)
+	__u32 flags;
+	__u32 nmsrs; /* number of msrs in bitmap */
+	__u32 base;  /* MSR index the bitmap starts at */
+	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+};
+
+struct kvm_msr_filter {
+#define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+#define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+	__u32 flags;
+	struct kvm_msr_filter_range ranges[16];
+};
 
 struct kvm_cpuid_entry {
 	__u32 function;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fd2875932189..45b0c180f42c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -623,10 +623,10 @@ static void set_msr_interception_nosync(struct kvm_vcpu *vcpu, u32 *msrpm,
 	WARN_ON(!valid_msr_intercept(msr));
 
 	/* Enforce non allowed MSRs to trap */
-	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_ALLOW_READ))
+	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
 		read = 0;
 
-	if (write && !kvm_msr_allowed(vcpu, msr, KVM_MSR_ALLOW_WRITE))
+	if (write && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
 		write = 0;
 
 	offset    = svm_msrpm_offset(msr);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99234244d97b..8e3f064b15c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1489,7 +1489,35 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
 bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 {
-	return true;
+	struct kvm *kvm = vcpu->kvm;
+	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
+	u32 count = kvm->arch.msr_filter.count;
+	u32 i;
+	bool r = kvm->arch.msr_filter.default_allow;
+	int idx;
+
+	/* MSR filtering not set up, allow everything */
+	if (!count)
+		return true;
+
+	/* Prevent collision with set_msr_filter */
+	idx = srcu_read_lock(&kvm->srcu);
+
+	for (i = 0; i < count; i++) {
+		u32 start = ranges[i].base;
+		u32 end = start + ranges[i].nmsrs;
+		u32 flags = ranges[i].flags;
+		unsigned long *bitmap = ranges[i].bitmap;
+
+		if ((index >= start) && (index < end) && (flags & type)) {
+			r = !!test_bit(index - start, bitmap);
+			break;
+		}
+	}
+
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_msr_allowed);
 
@@ -1504,6 +1532,9 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 {
 	struct msr_data msr;
 
+	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
+		return -EPERM;
+
 	switch (index) {
 	case MSR_FS_BASE:
 	case MSR_GS_BASE:
@@ -1560,6 +1591,9 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	struct msr_data msr;
 	int ret;
 
+	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
+		return -EPERM;
+
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
@@ -1621,6 +1655,8 @@ static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
 static u64 kvm_msr_reason(int r)
 {
 	switch (r) {
+	case -EPERM:
+		return KVM_MSR_EXIT_REASON_FILTER;
 	default:
 		return KVM_MSR_EXIT_REASON_INVAL;
 	}
@@ -3603,6 +3639,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
 	case KVM_CAP_X86_USER_SPACE_MSR:
+	case KVM_CAP_X86_MSR_FILTER:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5134,6 +5171,103 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }
 
+static void kvm_clear_msr_filter(struct kvm *kvm)
+{
+	u32 i;
+	u32 count = kvm->arch.msr_filter.count;
+	struct msr_bitmap_range ranges[16];
+
+	mutex_lock(&kvm->lock);
+	kvm->arch.msr_filter.count = 0;
+	memcpy(ranges, kvm->arch.msr_filter.ranges, count * sizeof(ranges[0]));
+	mutex_unlock(&kvm->lock);
+	synchronize_srcu(&kvm->srcu);
+
+	for (i = 0; i < count; i++)
+		kfree(ranges[i].bitmap);
+}
+
+static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user_range)
+{
+	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
+	struct msr_bitmap_range range;
+	unsigned long *bitmap = NULL;
+	size_t bitmap_size;
+	int r;
+
+	if (!user_range->nmsrs)
+		return 0;
+
+	bitmap_size = BITS_TO_LONGS(user_range->nmsrs) * sizeof(long);
+	if (!bitmap_size || bitmap_size > KVM_MSR_FILTER_MAX_BITMAP_SIZE)
+		return -EINVAL;
+
+	bitmap = memdup_user((__user u8*)user_range->bitmap, bitmap_size);
+	if (IS_ERR(bitmap))
+		return PTR_ERR(bitmap);
+
+	range = (struct msr_bitmap_range) {
+		.flags = user_range->flags,
+		.base = user_range->base,
+		.nmsrs = user_range->nmsrs,
+		.bitmap = bitmap,
+	};
+
+	if (range.flags & ~(KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE)) {
+		r = -EINVAL;
+		goto err;
+	}
+
+	if (!range.flags) {
+		r = -EINVAL;
+		goto err;
+	}
+
+	/* Everything ok, add this range identifier to our global pool */
+	ranges[kvm->arch.msr_filter.count] = range;
+	/* Make sure we filled the array before we tell anyone to walk it */
+	smp_wmb();
+	kvm->arch.msr_filter.count++;
+
+	return 0;
+err:
+	kfree(bitmap);
+	return r;
+}
+
+static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_msr_filter __user *user_msr_filter = argp;
+	struct kvm_msr_filter filter;
+	bool default_allow;
+	int r = 0;
+	u32 i;
+
+	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
+		return -EFAULT;
+
+	kvm_clear_msr_filter(kvm);
+
+	default_allow = !(filter.flags & KVM_MSR_FILTER_DEFAULT_DENY);
+	kvm->arch.msr_filter.default_allow = default_allow;
+
+	/*
+	 * Protect from concurrent calls to this function that could trigger
+	 * a TOCTOU violation on kvm->arch.msr_filter.count.
+	 */
+	mutex_lock(&kvm->lock);
+	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
+		r = kvm_add_msr_filter(kvm, &filter.ranges[i]);
+		if (r)
+			break;
+	}
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MSR_FILTER_CHANGED);
+	mutex_unlock(&kvm->lock);
+
+	return r;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -5440,6 +5574,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
+	case KVM_X86_SET_MSR_FILTER:
+		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
+		break;
 	default:
 		r = -ENOTTY;
 	}
@@ -8587,6 +8724,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_update_apicv(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
+		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
+			kvm_x86_ops.msr_filter_changed(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
@@ -10139,6 +10278,8 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	u32 i;
+
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
@@ -10155,6 +10296,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	}
 	if (kvm_x86_ops.vm_destroy)
 		kvm_x86_ops.vm_destroy(kvm);
+	for (i = 0; i < kvm->arch.msr_filter.count; i++)
+		kfree(kvm->arch.msr_filter.ranges[i].bitmap);
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8bd9baaa9eb3..be2014379329 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -420,6 +420,7 @@ struct kvm_run {
 			__u8 error; /* user -> kernel */
 			__u8 pad[7];
 #define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
+#define KVM_MSR_EXIT_REASON_FILTER	(1 << 1)
 			__u32 reason; /* kernel -> user */
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
@@ -1049,6 +1050,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_DIAG318 186
 #define KVM_CAP_STEAL_TIME 187
 #define KVM_CAP_X86_USER_SPACE_MSR 188
+#define KVM_CAP_X86_MSR_FILTER 189
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1550,6 +1552,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+/* Available with KVM_CAP_X86_MSR_FILTER */
+#define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.28.0.394.ge197136389




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



