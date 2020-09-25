Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53F2278AF0
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 16:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgIYOfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 10:35:18 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:7975 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgIYOfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 10:35:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1601044515; x=1632580515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vx33IvnwIWHpWez4q/PfcI4Vb7FtHBTsXCyuAewpu2Q=;
  b=LIvlNWUaRoTASp71Bm1YJEInNMAieTgVnSqMSEUoptguXtOSqmGHfbLx
   1l6onmMBrnPu1ZuNOtyR1b23PfYK38MvnDjhYn0OfDbnRihEBqq0X2DXF
   Rm0+ngV0xn/9n3Lg/x0kNmvwhSmZ2JtA1bg19OYDm8z8whHYD/9iCWPUt
   o=;
X-IronPort-AV: E=Sophos;i="5.77,302,1596499200"; 
   d="scan'208";a="56330765"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 25 Sep 2020 14:35:12 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id B7AABA27C0;
        Fri, 25 Sep 2020 14:35:07 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 25 Sep 2020 14:35:07 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.71) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 25 Sep 2020 14:35:03 +0000
From:   Alexander Graf <graf@amazon.com>
To:     kvm list <kvm@vger.kernel.org>
CC:     Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 7/8] KVM: x86: Introduce MSR filtering
Date:   Fri, 25 Sep 2020 16:34:21 +0200
Message-ID: <20200925143422.21718-8-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
In-Reply-To: <20200925143422.21718-1-graf@amazon.com>
References: <20200925143422.21718-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D02UWC004.ant.amazon.com (10.43.162.236) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

v7 -> v8:

  - adapt KVM_MSR_EXIT_REASON_FILTER value
  - introduce KVM_MSR_FILTER_MAX_RANGES
  - fix language in documentation
---
 Documentation/virt/kvm/api.rst  | 108 ++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  14 +++
 arch/x86/include/uapi/asm/kvm.h |  18 ++++
 arch/x86/kvm/x86.c              | 145 +++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h        |   5 ++
 5 files changed, 289 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5e6c6a429562..51725c5a5f51 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4704,6 +4704,99 @@ KVM_PV_VM_VERIFY
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
+  #define KVM_MSR_FILTER_MAX_RANGES 16
+  struct kvm_msr_filter {
+  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+	__u32 flags;
+	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
+  };
+
+flags values for struct kvm_msr_filter_range:
+
+KVM_MSR_FILTER_READ
+
+  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a read should immediately fail, while a 1 indicates that
+  a read for a particular MSR should be handled regardless of the default
+  filter action.
+
+KVM_MSR_FILTER_WRITE
+
+  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a write should immediately fail, while a 1 indicates that
+  a write for a particular MSR should be handled regardless of the default
+  filter action.
+
+KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE
+
+  Filter both read and write accesses to MSRs using the given bitmap. A 0
+  in the bitmap indicates that both reads and writes should immediately fail,
+  while a 1 indicates that reads and writes for a particular MSR are not
+  filtered by this range.
+
+flags values for struct kvm_msr_filter:
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
+This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
+specify whether a certain MSR access should be explicitly filtered for or not.
+
+If this ioctl has never been invoked, MSR accesses are not guarded and the
+old KVM in-kernel emulation behavior is fully preserved.
+
+As soon as the filtering is in place, every MSR access is processed through
+the filtering. If a bit is within one of the defined ranges, read and write
+accesses are guarded by the bitmap's value for the MSR index. If it is not
+defined in any range, whether MSR access is rejected is determined by the flags
+field in the kvm_msr_filter struct: KVM_MSR_FILTER_DEFAULT_ALLOW and
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
@@ -5185,6 +5278,7 @@ ENABLE_CAP. Currently valid exit reasons are:
 
 	KVM_MSR_EXIT_REASON_UNKNOWN - access to MSR that is unknown to KVM
 	KVM_MSR_EXIT_REASON_INVAL - access to invalid MSRs or reserved bits
+	KVM_MSR_EXIT_REASON_FILTER - access blocked by KVM_X86_SET_MSR_FILTER
 
 For KVM_EXIT_X86_RDMSR, the "index" field tells user space which MSR the guest
 wants to read. To respond to this request with a successful read, user space
@@ -6243,3 +6337,17 @@ writes to user space. It can be enabled on a VM level. If enabled, MSR
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
index c2fd0aa2f587..89e5f3d1bba8 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -192,8 +192,26 @@ struct kvm_msr_list {
 	__u32 indices[0];
 };
 
+/* Maximum size of any access bitmap in bytes */
+#define KVM_MSR_FILTER_MAX_BITMAP_SIZE 0x600
+
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range {
 #define KVM_MSR_FILTER_READ  (1 << 0)
 #define KVM_MSR_FILTER_WRITE (1 << 1)
+	__u32 flags;
+	__u32 nmsrs; /* number of msrs in bitmap */
+	__u32 base;  /* MSR index the bitmap starts at */
+	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+};
+
+#define KVM_MSR_FILTER_MAX_RANGES 16
+struct kvm_msr_filter {
+#define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+#define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+	__u32 flags;
+	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
+};
 
 struct kvm_cpuid_entry {
 	__u32 function;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8fe7d9730182..94c65086cba3 100644
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
 
@@ -1623,6 +1657,8 @@ static u64 kvm_msr_reason(int r)
 	switch (r) {
 	case -ENOENT:
 		return KVM_MSR_EXIT_REASON_UNKNOWN;
+	case -EPERM:
+		return KVM_MSR_EXIT_REASON_FILTER;
 	default:
 		return KVM_MSR_EXIT_REASON_INVAL;
 	}
@@ -3605,6 +3641,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
 	case KVM_CAP_X86_USER_SPACE_MSR:
+	case KVM_CAP_X86_MSR_FILTER:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5136,6 +5173,103 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
@@ -5442,6 +5576,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
+	case KVM_X86_SET_MSR_FILTER:
+		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
+		break;
 	default:
 		r = -ENOTTY;
 	}
@@ -8589,6 +8726,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_update_apicv(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
+		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
+			kvm_x86_ops.msr_filter_changed(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
@@ -10141,6 +10280,8 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	u32 i;
+
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
@@ -10157,6 +10298,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	}
 	if (kvm_x86_ops.vm_destroy)
 		kvm_x86_ops.vm_destroy(kvm);
+	for (i = 0; i < kvm->arch.msr_filter.count; i++)
+		kfree(kvm->arch.msr_filter.ranges[i].bitmap);
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 31292a3cdfc2..58f43aa1fc21 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -421,6 +421,7 @@ struct kvm_run {
 			__u8 pad[7];
 #define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
 #define KVM_MSR_EXIT_REASON_UNKNOWN	(1 << 1)
+#define KVM_MSR_EXIT_REASON_FILTER	(1 << 2)
 			__u32 reason; /* kernel -> user */
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
@@ -1050,6 +1051,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_DIAG318 186
 #define KVM_CAP_STEAL_TIME 187
 #define KVM_CAP_X86_USER_SPACE_MSR 188
+#define KVM_CAP_X86_MSR_FILTER 189
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1551,6 +1553,9 @@ struct kvm_pv_cmd {
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



