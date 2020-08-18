Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E06C248FF6
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgHRVQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgHRVQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:21 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57494C061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e2so133968pjm.3
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ug0YG9WZLCRRLkKsFyd/5Zy/2eV0CmUmGD25RpFa9Lk=;
        b=c4A+Eh3zQRg8o0KCORz6wenlIeo6Lo/J7gvgi3xwx5+D51SEgAANFkuCXrzVMrGflU
         +JGU1GODZLDGPEHSzGvqsKfhQKztlkF/aUh1g5Oj8h5zbpaXWJMwc5BRLm/kvUGoagyw
         +twXN054xAv0P/vhpzZ24T9rGXOsO7a84QmqIVBpTm3N9bft0DpZUPQk46wPfPBLoik2
         3jccJawPvPtHslSz5g3E6Rt+hGzLM+w57edl6IhereDYYneEo/r/24hOnEl9+OoDlWti
         i8yDJJn4hiPzSpQK0vsesltEwfkFaAJKc2/sK2RETind8a1lWKK+cQrfwhQSNXPnNZxB
         6rsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ug0YG9WZLCRRLkKsFyd/5Zy/2eV0CmUmGD25RpFa9Lk=;
        b=BNGIaUO+G9460eNnkte7/cEQ+h51SmnbaAjnQKbiWkunU+I6+ccoA/tXwMl2nQJ8n5
         gI/ZOpKdRt3G7lFtym44p37YCkDmX5z/NHiRvOPSasTPQmep8Yh8Jiw4GBh//bcKM2GF
         bcBbiOscmY9qeGrR3C2KCgAJ2fvbomXefCNZJdUC4TiSLvs+Y68Aq9U3tPb/lZmKB+9A
         arfZhuUeaKgNHJVHe4p6viTtvg60RgEmbmwhw3X7kVYC2ux7bCSGfxkxKq2iQ0BoRgwF
         MKNUhNajmrqfbEB9H/4fXmg6gagwdB7/OvivIB3wCvKumzS790+3aG3hA0P28l/ItltP
         42Mg==
X-Gm-Message-State: AOAM5306BxxJeE1myU442OhpfFGc+HgOGAcBSOujBKFr8GwEsyAIoGs6
        ZnKJl5TWbj7aaiFXcnNkZeIeYoDFldJay//o
X-Google-Smtp-Source: ABdhPJyKnxMmjoRYBmJOyFEanHrgpW1p/dK0YkpQY89Ytn5kk9t2t1xdCKtqGU4z20CZM0pBuw8cOXjrugEkUuEU
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:ee8d:: with SMTP id
 i13mr1468856pjz.19.1597785380796; Tue, 18 Aug 2020 14:16:20 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:24 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 02/12] KVM: x86: Introduce allow list for MSR emulation
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
Content-Type: text/plain; charset="UTF-8"
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

v3 -> v4:
  - lock allow check and clearing
  - free bitmaps on clear

v4 -> v5:

  - use srcu

---
 Documentation/virt/kvm/api.rst  |  91 ++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  10 ++
 arch/x86/include/uapi/asm/kvm.h |  15 +++
 arch/x86/kvm/x86.c              | 160 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |   5 +
 5 files changed, 281 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aad51c33fcae..91ce3e4b5b2e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4704,6 +4704,82 @@ KVM_PV_VM_VERIFY
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
@@ -6221,3 +6297,18 @@ writes to user space. It can be enabled on a VM level. If enabled, MSR
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
index 02a102c60dff..1ee8468c913c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -860,6 +860,13 @@ struct kvm_hv {
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
@@ -964,6 +971,9 @@ struct kvm_arch {
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
index 5d94a95fb66b..c46a709be532 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1486,6 +1486,39 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
+static bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
+	u32 count = kvm->arch.msr_allowlist_ranges_count;
+	u32 i;
+	bool r = false;
+	int idx;
+
+	/* MSR allowlist not set up, allow everything */
+	if (!count)
+		return true;
+
+	/* Prevent collision with clear_msr_allowlist */
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
+}
+
 /*
  * Write @data into the MSR specified by @index.  Select MSR specific fault
  * checks are bypassed if @host_initiated is %true.
@@ -1497,6 +1530,9 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 {
 	struct msr_data msr;
 
+	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW_WRITE))
+		return -ENOENT;
+
 	switch (index) {
 	case MSR_FS_BASE:
 	case MSR_GS_BASE:
@@ -1553,6 +1589,9 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	struct msr_data msr;
 	int ret;
 
+	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW_READ))
+		return -ENOENT;
+
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
@@ -3590,6 +3629,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
 	case KVM_CAP_X86_USER_SPACE_MSR:
+	case KVM_CAP_X86_MSR_ALLOWLIST:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5118,6 +5158,116 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }
 
+static bool msr_range_overlaps(struct kvm *kvm, struct msr_bitmap_range *range)
+{
+	struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
+	u32 i, count = kvm->arch.msr_allowlist_ranges_count;
+	bool r = false;
+
+	for (i = 0; i < count; i++) {
+		u32 start = max(range->base, ranges[i].base);
+		u32 end = min(range->base + range->nmsrs,
+			      ranges[i].base + ranges[i].nmsrs);
+
+		if ((start < end) && (range->flags & ranges[i].flags)) {
+			r = true;
+			break;
+		}
+	}
+
+	return r;
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
+	ranges[kvm->arch.msr_allowlist_ranges_count] = range;
+	/* Make sure we filled the array before we tell anyone to walk it */
+	smp_wmb();
+	kvm->arch.msr_allowlist_ranges_count++;
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
+	int i;
+	u32 count = kvm->arch.msr_allowlist_ranges_count;
+	struct msr_bitmap_range ranges[10];
+
+	mutex_lock(&kvm->lock);
+	kvm->arch.msr_allowlist_ranges_count = 0;
+	memcpy(ranges, kvm->arch.msr_allowlist_ranges, count * sizeof(ranges[0]));
+	mutex_unlock(&kvm->lock);
+	synchronize_srcu(&kvm->srcu);
+
+	for (i = 0; i < count; i++)
+		kfree(ranges[i].bitmap);
+
+	return 0;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -5424,6 +5574,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
@@ -10123,6 +10279,8 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	int i;
+
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
@@ -10139,6 +10297,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	}
 	if (kvm_x86_ops.vm_destroy)
 		kvm_x86_ops.vm_destroy(kvm);
+	for (i = 0; i < kvm->arch.msr_allowlist_ranges_count; i++)
+		kfree(kvm->arch.msr_allowlist_ranges[i].bitmap);
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6470c0c1e77a..374021dc4e61 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1045,6 +1045,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
 #define KVM_CAP_X86_USER_SPACE_MSR 187
+#define KVM_CAP_X86_MSR_ALLOWLIST 188
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1546,6 +1547,10 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+/* Available with KVM_CAP_X86_MSR_ALLOWLIST */
+#define KVM_X86_ADD_MSR_ALLOWLIST      _IOW(KVMIO,  0xc6, struct kvm_msr_allowlist)
+#define KVM_X86_CLEAR_MSR_ALLOWLIST    _IO(KVMIO,  0xc7)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.28.0.220.ged08abb693-goog

