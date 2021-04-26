Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D462436B231
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 13:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhDZLPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 07:15:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233136AbhDZLPE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 07:15:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619435662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZYg8Crkswh89VN+DFuzaHYcgCCK2qIHNkdGv8Ve+zOk=;
        b=dpDDRxnfBRp6BNRf/F4VRqGJKGk5jGwES5OVjrFKLckRcM2ycyOXmhC2UkL8VcTrFbxJ0a
        EoxKzBxoqVqjLxgS1PHXGzZYmnxRlGOf0qFVOndXR09aJ5uxiC0XGO0y7PlM6xqTNf2dmJ
        wDdUiHblA2zQcKNB1A5C5hHDPE5NRqo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-S3ndQEJbP8OvJyZJ38N2zg-1; Mon, 26 Apr 2021 07:14:18 -0400
X-MC-Unique: S3ndQEJbP8OvJyZJ38N2zg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62A9783DBF4;
        Mon, 26 Apr 2021 11:14:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B41A45D9D0;
        Mon, 26 Apr 2021 11:13:56 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 4/6] KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2
Date:   Mon, 26 Apr 2021 14:13:31 +0300
Message-Id: <20210426111333.967729-5-mlevitsk@redhat.com>
In-Reply-To: <20210426111333.967729-1-mlevitsk@redhat.com>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a new version of KVM_GET_SREGS / KVM_SET_SREGS.

It has the following changes:
   * Has flags for future extensions
   * Has vcpu's PDPTS, which allows to save/restore them on migration.
   * Lacks obsolete interrupt bitmap (done now via KVM_SET_VCPU_EVENTS)

New capability, KVM_CAP_SREGS2 is added to signal
the userspace of this ioctl.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 Documentation/virt/kvm/api.rst  |  48 +++++++++++
 arch/x86/include/asm/kvm_host.h |   7 ++
 arch/x86/include/uapi/asm/kvm.h |  13 +++
 arch/x86/kvm/kvm_cache_regs.h   |   5 ++
 arch/x86/kvm/x86.c              | 139 ++++++++++++++++++++++++++------
 include/uapi/linux/kvm.h        |   4 +
 6 files changed, 192 insertions(+), 24 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8d614a577e43..6781e0a4bfa5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5021,6 +5021,54 @@ see KVM_XEN_VCPU_SET_ATTR above.
 The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
 with the KVM_XEN_VCPU_GET_ATTR ioctl.
 
+
+4.131 KVM_GET_SREGS2
+------------------
+
+:Capability: KVM_CAP_SREGS2
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_sregs2 (out)
+:Returns: 0 on success, -1 on error
+
+Reads special registers from the vcpu.
+This ioctl (when supported) replaces the KVM_GET_SREGS.
+
+::
+
+struct kvm_sregs2 {
+	/* out (KVM_GET_SREGS2) / in (KVM_SET_SREGS2) */
+	struct kvm_segment cs, ds, es, fs, gs, ss;
+	struct kvm_segment tr, ldt;
+	struct kvm_dtable gdt, idt;
+	__u64 cr0, cr2, cr3, cr4, cr8;
+	__u64 efer;
+	__u64 apic_base;
+	__u64 flags;
+	__u64 pdptrs[4];
+};
+
+flags values for ``kvm_sregs2``:
+
+``KVM_SREGS2_FLAGS_PDPTRS_VALID``
+
+  Indicates thats the struct contain valid PDPTR values.
+
+
+4.132 KVM_SET_SREGS2
+------------------
+
+:Capability: KVM_CAP_SREGS2
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_sregs2 (in)
+:Returns: 0 on success, -1 on error
+
+Writes special registers into the vcpu.
+See KVM_GET_SREGS2 for the data structures.
+This ioctl (when supported) replaces the KVM_SET_SREGS.
+
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e5fc80a35c8..943e19831e32 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -849,6 +849,13 @@ struct kvm_vcpu_arch {
 
 	/* Protected Guests */
 	bool guest_state_protected;
+
+	/*
+	 * Do we need to reload the PDPTRs when entering the nested state?
+	 * Set if the userspace used the KVM_SET_SREGS to set CR3
+	 * and thus didn't load the PDPTRs from the migration state.
+	 */
+	bool pdptr_reload_on_nesting_needed;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5a3022c8af82..46aef200b168 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -159,6 +159,19 @@ struct kvm_sregs {
 	__u64 interrupt_bitmap[(KVM_NR_INTERRUPTS + 63) / 64];
 };
 
+struct kvm_sregs2 {
+	/* out (KVM_GET_SREGS2) / in (KVM_SET_SREGS2) */
+	struct kvm_segment cs, ds, es, fs, gs, ss;
+	struct kvm_segment tr, ldt;
+	struct kvm_dtable gdt, idt;
+	__u64 cr0, cr2, cr3, cr4, cr8;
+	__u64 efer;
+	__u64 apic_base;
+	__u64 flags;
+	__u64 pdptrs[4];
+};
+#define KVM_SREGS2_FLAGS_PDPTRS_VALID 1
+
 /* for KVM_GET_FPU and KVM_SET_FPU */
 struct kvm_fpu {
 	__u8  fpr[8][16];
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index b8559b83c4ca..842a09711b80 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -125,6 +125,11 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 	return vcpu->arch.walk_mmu->pdptrs[index];
 }
 
+static inline void kvm_pdptr_write(struct kvm_vcpu *vcpu, int index, u64 value)
+{
+	vcpu->arch.walk_mmu->pdptrs[index] = value;
+}
+
 static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
 	ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bf52ba5f2bb..967022b983a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -113,6 +113,9 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
 
+static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
+static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
@@ -3841,6 +3844,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 #endif
 	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
 	case KVM_CAP_EXIT_HYPERCALL:
+	case KVM_CAP_SREGS2:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -4759,6 +4763,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 	union {
+		struct kvm_sregs2 *sregs2;
 		struct kvm_lapic_state *lapic;
 		struct kvm_xsave *xsave;
 		struct kvm_xcrs *xcrs;
@@ -5131,6 +5136,28 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 #endif
+	case KVM_GET_SREGS2: {
+		u.sregs2 = kzalloc(sizeof(struct kvm_sregs2), GFP_KERNEL);
+		r = -ENOMEM;
+		if (!u.sregs2)
+			goto out;
+		__get_sregs2(vcpu, u.sregs2);
+		r = -EFAULT;
+		if (copy_to_user(argp, u.sregs2, sizeof(struct kvm_sregs2)))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_SREGS2: {
+		u.sregs2 = memdup_user(argp, sizeof(struct kvm_sregs2));
+		if (IS_ERR(u.sregs2)) {
+			r = PTR_ERR(u.sregs2);
+			u.sregs2 = NULL;
+			goto out;
+		}
+		r = __set_sregs2(vcpu, u.sregs2);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -9795,7 +9822,7 @@ void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 }
 EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
 
-static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct desc_ptr dt;
 
@@ -9828,14 +9855,32 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	sregs->cr8 = kvm_get_cr8(vcpu);
 	sregs->efer = vcpu->arch.efer;
 	sregs->apic_base = kvm_get_apic_base(vcpu);
+}
 
-	memset(sregs->interrupt_bitmap, 0, sizeof(sregs->interrupt_bitmap));
+static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+{
+	__get_sregs_common(vcpu, sregs);
+
+	if (vcpu->arch.guest_state_protected)
+		return;
 
 	if (vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft)
 		set_bit(vcpu->arch.interrupt.nr,
 			(unsigned long *)sregs->interrupt_bitmap);
 }
 
+static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
+{
+	int i;
+
+	__get_sregs_common(vcpu, (struct kvm_sregs *)sregs2);
+	if (is_pae_paging(vcpu)) {
+		for (i = 0 ; i < 4 ; i++)
+			sregs2->pdptrs[i] = kvm_pdptr_read(vcpu, i);
+		sregs2->flags |= KVM_SREGS2_FLAGS_PDPTRS_VALID;
+	}
+}
+
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
@@ -9947,11 +9992,9 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	return kvm_is_valid_cr4(vcpu, sregs->cr4);
 }
 
-static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs, int *mmu_reset_needed)
 {
 	struct msr_data apic_base_msr;
-	int mmu_reset_needed = 0;
-	int pending_vec, max_bits, idx;
 	struct desc_ptr dt;
 	int ret = -EINVAL;
 
@@ -9963,8 +10006,9 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		goto out;
 
+	ret = 0;
 	if (vcpu->arch.guest_state_protected)
-		goto skip_protected_regs;
+		goto out;
 
 	dt.size = sregs->idt.limit;
 	dt.address = sregs->idt.base;
@@ -9974,32 +10018,22 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	static_call(kvm_x86_set_gdt)(vcpu, &dt);
 
 	vcpu->arch.cr2 = sregs->cr2;
-	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
+	*mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
 	vcpu->arch.cr3 = sregs->cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 
-	mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
+	*mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
 	static_call(kvm_x86_set_efer)(vcpu, sregs->efer);
 
-	mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
+	*mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
 	static_call(kvm_x86_set_cr0)(vcpu, sregs->cr0);
 	vcpu->arch.cr0 = sregs->cr0;
 
-	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
+	*mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
 	static_call(kvm_x86_set_cr4)(vcpu, sregs->cr4);
 
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (is_pae_paging(vcpu)) {
-		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
-		mmu_reset_needed = 1;
-	}
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-
-	if (mmu_reset_needed)
-		kvm_mmu_reset_context(vcpu);
-
 	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
 	kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
@@ -10017,8 +10051,39 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
 	    !is_protmode(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+out:
+	return ret;
+}
+
+static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+{
+	int idx, pending_vec, max_bits;
+	int mmu_reset_needed = 0;
+	int ret = __set_sregs_common(vcpu, sregs, &mmu_reset_needed);
+
+	if (ret)
+		return ret;
+
+	if (vcpu->arch.guest_state_protected)
+		return 0;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	if (is_pae_paging(vcpu)) {
+		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
+		mmu_reset_needed = 1;
+
+		/* If we are going to enter a nested guest, we had just
+		 * loaded wrong PDPTRs, thus we need to reload them
+		 * on guest mode entry
+		 */
+
+		vcpu->arch.pdptr_reload_on_nesting_needed = true;
+	}
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (mmu_reset_needed)
+		kvm_mmu_reset_context(vcpu);
 
-skip_protected_regs:
 	max_bits = KVM_NR_INTERRUPTS;
 	pending_vec = find_first_bit(
 		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
@@ -10028,10 +10093,36 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	}
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
+	return 0;
+}
 
-	ret = 0;
-out:
-	return ret;
+static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
+{
+	int mmu_reset_needed = 0;
+	int i, ret;
+
+	if (sregs2->flags & ~KVM_SREGS2_FLAGS_PDPTRS_VALID)
+		return -EINVAL;
+
+	ret = __set_sregs_common(vcpu, (struct kvm_sregs *)sregs2, &mmu_reset_needed);
+	if (ret || vcpu->arch.guest_state_protected)
+		return ret;
+
+	if (sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID) {
+
+		if (!is_pae_paging(vcpu))
+			return -EINVAL;
+
+		for (i = 0 ; i < 4 ; i++)
+			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
+
+		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+		mmu_reset_needed = 1;
+	}
+
+	if (mmu_reset_needed)
+		kvm_mmu_reset_context(vcpu);
+	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7dc1c217704f..156f2f751893 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SGX_ATTRIBUTE 196
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
 #define KVM_CAP_EXIT_HYPERCALL 198
+#define KVM_CAP_SREGS2 199
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1620,6 +1621,9 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
 #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
 
+#define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
+#define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
+
 struct kvm_xen_vcpu_attr {
 	__u16 type;
 	__u16 pad[3];
-- 
2.26.2

