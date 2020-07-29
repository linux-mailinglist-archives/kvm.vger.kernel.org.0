Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EEA232875
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 02:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgG2X7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 19:59:55 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:12506 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgG2X7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 19:59:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596067189; x=1627603189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=+ef1YbxanUoog0QUmXvwNsZ60Jf/sIc+UvaCH78WQjQ=;
  b=Wge9IfI8258SfLEhFVeTNZM6uPaqLD1c4MDyEi2KyEaHyxKLWqglFDRo
   Iu0/+oGjYkfx2T8OcpdKL+wimO991MkOR0MVh4NTbJa9eU5LpLKYAB4b4
   3ZIJlhb+s0WNzqYBgSH9I1uvvxQqGKz72q7tHLdRCelv0CXVVWFMRrQbQ
   c=;
IronPort-SDR: 1cI6/KCDe4zQrFTpxX/JZiCE1o/iQKfbJ8yrEbIxZLhrw6mOxMHT1c7VgE097Hsb6f2WxKaMOt
 OJXV9+MWULcg==
X-IronPort-AV: E=Sophos;i="5.75,412,1589241600"; 
   d="scan'208";a="44936519"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 29 Jul 2020 23:59:48 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 8B154A2537;
        Wed, 29 Jul 2020 23:59:46 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 23:59:46 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.109) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 23:59:43 +0000
From:   Alexander Graf <graf@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] KVM: x86: Introduce allow list for MSR emulation
Date:   Thu, 30 Jul 2020 01:59:28 +0200
Message-ID: <20200729235929.379-3-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200729235929.379-1-graf@amazon.com>
References: <20200729235929.379-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.109]
X-ClientProxiedBy: EX13D04UWA002.ant.amazon.com (10.43.160.31) To
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
 Documentation/virt/kvm/api.rst  |  53 ++++++++++++++
 arch/x86/include/asm/kvm_host.h |  10 +++
 arch/x86/include/uapi/asm/kvm.h |  15 ++++
 arch/x86/kvm/x86.c              | 123 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |   4 ++
 5 files changed, 205 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c1f991c1ffa6..ca92b9e2cded 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4697,6 +4697,45 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+4.126 KVM_ADD_MSR_ALLOWLIST
+-------------------------
+
+:Capability: KVM_CAP_ADD_MSR_ALLOWLIST
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
 
 5. The kvm_run structure
 ========================
@@ -6213,3 +6252,17 @@ writes to user space. It can be enabled on a VM level. If enabled, MSR
 accesses that would usually trigger a #GP by KVM into the guest will
 instead get bounced to user space through the KVM_EXIT_RDMSR and
 KVM_EXIT_WRMSR exit notifications.
+
+8.25 KVM_CAP_ADD_MSR_ALLOWLIST
+------------------------------
+
+:Architectures: x86
+
+This capability indicates that KVM supports emulation of only select MSR
+registers. With this capability exposed, KVM exports a new VM ioctl
+KVM_ADD_MSR_ALLOWLIST which allows user space to specify bitmaps of MSR
+ranges that KVM should emulate in kernel space.
+
+In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
+trap and emulate MSRs that are outside of the scope of KVM as well as
+limit the attack surface on KVM's MSR emulation code.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2f2307e71342..4b1ff7cb848f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -901,6 +901,13 @@ struct kvm_hv {
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
@@ -1005,6 +1012,9 @@ struct kvm_arch {
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	bool user_space_msr_enabled;
 
+	struct msr_bitmap_range msr_allowlist_ranges[10];
+	int msr_allowlist_ranges_count;
+
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 };
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0780f97c1850..bd640a43cad6 100644
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
+/* for KVM_ADD_MSR_ALLOWLIST */
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
index 11e94a780656..924baec58d87 100644
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
 
@@ -3549,6 +3578,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_X86_USER_SPACE_MSR:
+	case KVM_CAP_ADD_MSR_ALLOWLIST:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5074,6 +5104,92 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
+	int r;
+
+	if (copy_from_user(&kernel_msr_allowlist, user_msr_allowlist,
+			   sizeof(kernel_msr_allowlist))) {
+		r = -EFAULT;
+		goto out_err;
+	}
+
+	bitmap_size = BITS_TO_LONGS(kernel_msr_allowlist.nmsrs) * sizeof(long);
+	if (bitmap_size > KVM_MSR_ALLOWLIST_MAX_LEN) {
+		r = -EINVAL;
+		goto out_err;
+	}
+
+	bitmap = memdup_user(user_msr_allowlist->bitmap, bitmap_size);
+	if (IS_ERR(bitmap)) {
+		r = PTR_ERR(bitmap);
+		goto out_err;
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
+		goto out_err;
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
+		goto out_err;
+	}
+
+	if (msr_range_overlaps(kvm, &range)) {
+		r = -EINVAL;
+		goto out_err;
+	}
+
+	/* Everything ok, add this range identifier to our global pool */
+	ranges[kvm->arch.msr_allowlist_ranges_count++] = range;
+
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+
+out_err:
+	kfree(bitmap);
+	return r;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -5380,6 +5496,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
+	case KVM_ADD_MSR_ALLOWLIST:
+		r = kvm_vm_ioctl_add_msr_allowlist(kvm, argp);
+		break;
 	default:
 		r = -ENOTTY;
 	}
@@ -10091,6 +10210,8 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	int i;
+
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
@@ -10107,6 +10228,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	}
 	if (kvm_x86_ops.vm_destroy)
 		kvm_x86_ops.vm_destroy(kvm);
+	for (i = 0; i < kvm->arch.msr_allowlist_ranges_count; i++)
+		kfree(kvm->arch.msr_allowlist_ranges[i].bitmap);
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index df237bf2bdc2..44ee9df8007f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1042,6 +1042,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
 #define KVM_CAP_X86_USER_SPACE_MSR 184
+#define KVM_CAP_ADD_MSR_ALLOWLIST 185
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1543,6 +1544,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+/* Available with KVM_CAP_ADD_MSR_ALLOWLIST */
+#define KVM_ADD_MSR_ALLOWLIST     _IOW(KVMIO,  0xc6, struct kvm_msr_allowlist)
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



