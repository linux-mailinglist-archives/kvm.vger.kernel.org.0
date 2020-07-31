Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF87234D52
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgGaVuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:50:16 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:9351 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgGaVuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596232211; x=1627768211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3nsTeY10VVwEpWTG5gBkqKUlk6Gpo+4wcM1iI6Sw0kk=;
  b=d2Z9fCznCntMYM8GBEFS3X1PJVBMbDC1i2kkOOez4NS8vKZV/FNJLZXk
   2GDxy/6dp21CDd3PNWqhJoNOv5hSaIBv2S/DHSKRP/Jgq/IJsQSIGECTz
   UY+OXFlMQZSjC2rnAM9uEjd1l8htboIaOTvfng3deeo82qX6pkF2sLTvH
   s=;
IronPort-SDR: rKRaItau6H/f8OxP/PHg+5WaPEwgPA3tMjwWSHQqZTn4vdz0uPbXb5ElhWd8c4RPTrnKIm7l+K
 1DZf1BuFhwpA==
X-IronPort-AV: E=Sophos;i="5.75,419,1589241600"; 
   d="scan'208";a="45449425"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 31 Jul 2020 21:50:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 90C2FA2040;
        Fri, 31 Jul 2020 21:50:05 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 31 Jul 2020 21:50:04 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.160.100) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 31 Jul 2020 21:50:01 +0000
From:   Alexander Graf <graf@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/3] KVM: x86: Introduce allow list for MSR emulation
Date:   Fri, 31 Jul 2020 23:49:46 +0200
Message-ID: <20200731214947.16885-3-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731214947.16885-1-graf@amazon.com>
References: <20200731214947.16885-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D48UWA001.ant.amazon.com (10.43.163.52) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's not desireable to have all MSRs always handled by KVM kernel space. Some
MSRs would be useful to handle in user space to either emulate behavior (like
uCode updates) or differentiate whether they are valid based on the CPU model.

To allow user space to specify which MSRs it wants to see handled by KVM,
this patch introduces a new ioctl to push allow lists of bitmaps into
KVM. Based on these bitmaps, KVM can then decide whether to reject MSR access.
With the addition of KVM_CAP_X86_USER_SPACE_MSR it can also deflect the
denied MSR events to user space to operate on.

If no allowlist is populated, MSR handling stays identical to before.

Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
Signed-off-by: Alexander Graf <graf@amazon.com>

---

v2 -> v3:

  - document flags for KVM_X86_ADD_MSR_ALLOWLIST
  - generalize exit path, always unlock when returning
  - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
  - Add KVM_X86_CLEAR_MSR_ALLOWLIST
---
 Documentation/virt/kvm/api.rst  |  91 +++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  10 +++
 arch/x86/include/uapi/asm/kvm.h |  15 ++++
 arch/x86/kvm/x86.c              | 135 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |   5 ++
 5 files changed, 256 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 79c3e2fdfae4..d611ddd326fc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4697,6 +4697,82 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+4.126 KVM_X86_ADD_MSR_ALLOWLIST
+-------------------------------
+
+:Capability: KVM_CAP_X86_MSR_ALLOWLIST
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_msr_allowlist
+:Returns: 0 on success, < 0 on error
+
+::
+
+  struct kvm_msr_allowlist {
+         __u32 flags;
+         __u32 nmsrs; /* number of msrs in bitmap */
+         __u32 base;  /* base address for the MSRs bitmap */
+         __u32 pad;
+
+         __u8 bitmap[0]; /* a set bit allows that the operation set in flags */
+  };
+
+flags values:
+
+KVM_MSR_ALLOW_READ
+
+  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a read should immediately fail, while a 1 indicates that
+  a read should be handled by the normal KVM MSR emulation logic.
+
+KVM_MSR_ALLOW_WRITE
+
+  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a write should immediately fail, while a 1 indicates that
+  a write should be handled by the normal KVM MSR emulation logic.
+
+KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE
+
+  Filter booth read and write accesses to MSRs using the given bitmap. A 0
+  in the bitmap indicates that both reads and writes should immediately fail,
+  while a 1 indicates that reads and writes should be handled by the normal
+  KVM MSR emulation logic.
+
+This ioctl allows user space to define a set of bitmaps of MSR ranges to
+specify whether a certain MSR access is allowed or not.
+
+If this ioctl has never been invoked, MSR accesses are not guarded and the
+old KVM in-kernel emulation behavior is fully preserved.
+
+As soon as the first allow list was specified, only allowed MSR accesses
+are permitted inside of KVM's MSR code.
+
+Each allowlist specifies a range of MSRs to potentially allow access on.
+The range goes from MSR index [base .. base+nmsrs]. The flags field
+indicates whether reads, writes or both reads and writes are permitted
+by setting a 1 bit in the bitmap for the corresponding MSR index.
+
+If an MSR access is not permitted through the allow list, it generates a
+#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
+allows user space to deflect and potentially handle various MSR accesses
+into user space.
+
+4.124 KVM_X86_CLEAR_MSR_ALLOWLIST
+---------------------------------
+
+:Capability: KVM_CAP_X86_MSR_ALLOWLIST
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: none
+:Returns: 0
+
+This ioctl resets all internal MSR allow lists. After this call, no allow
+list is present and the guest would execute as if no allow lists were set,
+so all MSRs are considered allowed and thus handled by the in-kernel MSR
+emulation logic.
+
+No vCPU may be in running state when calling this ioctl.
+
 
 5. The kvm_run structure
 ========================
@@ -6213,3 +6289,18 @@ writes to user space. It can be enabled on a VM level. If enabled, MSR
 accesses that would usually trigger a #GP by KVM into the guest will
 instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
 KVM_EXIT_X86_WRMSR exit notifications.
+
+8.25 KVM_CAP_X86_MSR_ALLOWLIST
+------------------------------
+
+:Architectures: x86
+
+This capability indicates that KVM supports emulation of only select MSR
+registers. With this capability exposed, KVM exports two new VM ioctls:
+KVM_X86_ADD_MSR_ALLOWLIST which user space can call to specify bitmaps of MSR
+ranges that KVM should emulate in kernel space and KVM_X86_CLEAR_MSR_ALLOWLIST
+which user space can call to remove all MSR allow lists from the VM context.
+
+In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
+trap and emulate MSRs that are outside of the scope of KVM as well as
+limit the attack surface on KVM's MSR emulation code.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 809eed0dbdea..21358ed4e590 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -904,6 +904,13 @@ struct kvm_hv {
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
@@ -1008,6 +1015,9 @@ struct kvm_arch {
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	bool user_space_msr_enabled;
 
+	struct msr_bitmap_range msr_allowlist_ranges[10];
+	int msr_allowlist_ranges_count;
+
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 };
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0780f97c1850..c33fb1d72d52 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -192,6 +192,21 @@ struct kvm_msr_list {
 	__u32 indices[0];
 };
 
+#define KVM_MSR_ALLOW_READ  (1 << 0)
+#define KVM_MSR_ALLOW_WRITE (1 << 1)
+
+/* Maximum size of the of the bitmap in bytes */
+#define KVM_MSR_ALLOWLIST_MAX_LEN 0x600
+
+/* for KVM_X86_ADD_MSR_ALLOWLIST */
+struct kvm_msr_allowlist {
+	__u32 flags;
+	__u32 nmsrs; /* number of msrs in bitmap */
+	__u32 base;  /* base address for the MSRs bitmap */
+	__u32 pad;
+
+	__u8 bitmap[0]; /* a set bit allows that the operation set in flags */
+};
 
 struct kvm_cpuid_entry {
 	__u32 function;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 24c72250f6df..7a2be00a3512 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1472,6 +1472,29 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
+static bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
+{
+	struct msr_bitmap_range *ranges = vcpu->kvm->arch.msr_allowlist_ranges;
+	u32 count = vcpu->kvm->arch.msr_allowlist_ranges_count;
+	u32 i;
+
+	/* MSR allowlist not set up, allow everything */
+	if (!count)
+		return true;
+
+	for (i = 0; i < count; i++) {
+		u32 start = ranges[i].base;
+		u32 end = start + ranges[i].nmsrs;
+		int flags = ranges[i].flags;
+		unsigned long *bitmap = ranges[i].bitmap;
+
+		if ((index >= start) && (index < end) && (flags & type))
+			return !!test_bit(index - start, bitmap);
+	}
+
+	return false;
+}
+
 /*
  * Write @data into the MSR specified by @index.  Select MSR specific fault
  * checks are bypassed if @host_initiated is %true.
@@ -1483,6 +1506,9 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 {
 	struct msr_data msr;
 
+	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW_WRITE))
+		return -ENOENT;
+
 	switch (index) {
 	case MSR_FS_BASE:
 	case MSR_GS_BASE:
@@ -1528,6 +1554,9 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	struct msr_data msr;
 	int ret;
 
+	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW_READ))
+		return -ENOENT;
+
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
@@ -3550,6 +3579,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_X86_USER_SPACE_MSR:
+	case KVM_CAP_X86_MSR_ALLOWLIST:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5075,6 +5105,101 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }
 
+static bool msr_range_overlaps(struct kvm *kvm, struct msr_bitmap_range *range)
+{
+	struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
+	u32 i, count = kvm->arch.msr_allowlist_ranges_count;
+
+	for (i = 0; i < count; i++) {
+		u32 start = max(range->base, ranges[i].base);
+		u32 end = min(range->base + range->nmsrs,
+			      ranges[i].base + ranges[i].nmsrs);
+
+		if ((start < end) && (range->flags & ranges[i].flags))
+			return true;
+	}
+
+	return false;
+}
+
+static int kvm_vm_ioctl_add_msr_allowlist(struct kvm *kvm, void __user *argp)
+{
+	struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
+	struct kvm_msr_allowlist __user *user_msr_allowlist = argp;
+	struct msr_bitmap_range range;
+	struct kvm_msr_allowlist kernel_msr_allowlist;
+	unsigned long *bitmap = NULL;
+	size_t bitmap_size;
+	int r = 0;
+
+	if (copy_from_user(&kernel_msr_allowlist, user_msr_allowlist,
+			   sizeof(kernel_msr_allowlist))) {
+		r = -EFAULT;
+		goto out;
+	}
+
+	bitmap_size = BITS_TO_LONGS(kernel_msr_allowlist.nmsrs) * sizeof(long);
+	if (bitmap_size > KVM_MSR_ALLOWLIST_MAX_LEN) {
+		r = -EINVAL;
+		goto out;
+	}
+
+	bitmap = memdup_user(user_msr_allowlist->bitmap, bitmap_size);
+	if (IS_ERR(bitmap)) {
+		r = PTR_ERR(bitmap);
+		goto out;
+	}
+
+	range = (struct msr_bitmap_range) {
+		.flags = kernel_msr_allowlist.flags,
+		.base = kernel_msr_allowlist.base,
+		.nmsrs = kernel_msr_allowlist.nmsrs,
+		.bitmap = bitmap,
+	};
+
+	if (range.flags & ~(KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE)) {
+		r = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Protect from concurrent calls to this function that could trigger
+	 * a TOCTOU violation on kvm->arch.msr_allowlist_ranges_count.
+	 */
+	mutex_lock(&kvm->lock);
+
+	if (kvm->arch.msr_allowlist_ranges_count >=
+	    ARRAY_SIZE(kvm->arch.msr_allowlist_ranges)) {
+		r = -E2BIG;
+		goto out_locked;
+	}
+
+	if (msr_range_overlaps(kvm, &range)) {
+		r = -EINVAL;
+		goto out_locked;
+	}
+
+	/* Everything ok, add this range identifier to our global pool */
+	ranges[kvm->arch.msr_allowlist_ranges_count++] = range;
+
+out_locked:
+	mutex_unlock(&kvm->lock);
+out:
+	if (r)
+		kfree(bitmap);
+
+	return r;
+}
+
+static int kvm_vm_ioctl_clear_msr_allowlist(struct kvm *kvm)
+{
+	mutex_lock(&kvm->lock);
+	kvm->arch.msr_allowlist_ranges_count = 0;
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -5381,6 +5506,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
+	case KVM_X86_ADD_MSR_ALLOWLIST:
+		r = kvm_vm_ioctl_add_msr_allowlist(kvm, argp);
+		break;
+	case KVM_X86_CLEAR_MSR_ALLOWLIST:
+		r = kvm_vm_ioctl_clear_msr_allowlist(kvm);
+		break;
 	default:
 		r = -ENOTTY;
 	}
@@ -10086,6 +10217,8 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	int i;
+
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
@@ -10102,6 +10235,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	}
 	if (kvm_x86_ops.vm_destroy)
 		kvm_x86_ops.vm_destroy(kvm);
+	for (i = 0; i < kvm->arch.msr_allowlist_ranges_count; i++)
+		kfree(kvm->arch.msr_allowlist_ranges[i].bitmap);
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 13fc7de1eb50..4d6bb06e0fb1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1041,6 +1041,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
 #define KVM_CAP_X86_USER_SPACE_MSR 184
+#define KVM_CAP_X86_MSR_ALLOWLIST 185
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1542,6 +1543,10 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+/* Available with KVM_CAP_X86_MSR_ALLOWLIST */
+#define KVM_X86_ADD_MSR_ALLOWLIST	_IOW(KVMIO,  0xc6, struct kvm_msr_allowlist)
+#define KVM_X86_CLEAR_MSR_ALLOWLIST	_IO(KVMIO,  0xc7)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



