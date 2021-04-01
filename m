Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12B6351D0C
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbhDASXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:23:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238044AbhDASUG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:20:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLFvHdiWXYNIULMTtBTguNmg4GrUY9dxrXLJtHJbyA8=;
        b=CmzNbAkTjfpCm7SP6+aOhdAAlJi/7BisLrEAr76aNPyjFsUWujjW4qVP8FltXhYc7eGFvg
        vaeoAYWi05F1iR2nOWIAG4UTuoJs4v+P7/NOyuMBDYOLypLOHW9D0nrvF1QevUM5+KWDef
        GJn8RKXNFLcoTt6YW6wjiZwM6Vp9dBE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-5Ca9FvffN7GJBbPTHyBuiA-1; Thu, 01 Apr 2021 10:19:01 -0400
X-MC-Unique: 5Ca9FvffN7GJBbPTHyBuiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74C59881E1A;
        Thu,  1 Apr 2021 14:18:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBA885945C;
        Thu,  1 Apr 2021 14:18:32 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/6] KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2
Date:   Thu,  1 Apr 2021 17:18:12 +0300
Message-Id: <20210401141814.1029036-5-mlevitsk@redhat.com>
In-Reply-To: <20210401141814.1029036-1-mlevitsk@redhat.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a new version of KVM_GET_SREGS / KVM_SET_SREGS ioctls,
aiming to replace them.

It has the following changes:
   * Has flags for future extensions
   * Has vcpu's PDPTS, which allows to save/restore them on migration.
   * Lacks obsolete interrupt bitmap (done now via KVM_SET_VCPU_EVENTS)

New capability, KVM_CAP_SREGS2 is added to signal
userspace of this ioctl.

Currently only implemented on x86.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 Documentation/virt/kvm/api.rst  |  43 ++++++++++
 arch/x86/include/asm/kvm_host.h |   7 ++
 arch/x86/include/uapi/asm/kvm.h |  13 +++
 arch/x86/kvm/kvm_cache_regs.h   |   5 ++
 arch/x86/kvm/x86.c              | 136 ++++++++++++++++++++++++++------
 include/uapi/linux/kvm.h        |   5 ++
 6 files changed, 185 insertions(+), 24 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 38e327d4b479..b006d5b5f554 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4941,6 +4941,49 @@ see KVM_XEN_VCPU_SET_ATTR above.
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
+This ioctl is preferred over KVM_GET_SREGS when available.
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
+	__u64 flags; /* must be zero*/
+	__u64 pdptrs[4];
+	__u64 padding;
+};
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
+This ioctl is preferred over the KVM_SET_SREGS when available.
+
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a52f973bdff6..87b680d111f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -838,6 +838,13 @@ struct kvm_vcpu_arch {
 
 	/* Protected Guests */
 	bool guest_state_protected;
+
+	/*
+	 * Do we need to reload the pdptrs when entering nested state?
+	 * Set after nested migration if userspace didn't use the
+	 * newer KVM_SET_SREGS2 ioctl to load pdptrs from the migration state.
+	 */
+	bool reload_pdptrs_on_nested_entry;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5a3022c8af82..201a85884c81 100644
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
+	__u64 flags; /* must be zero*/
+	__u64 pdptrs[4];
+	__u64 padding;
+};
+
 /* for KVM_GET_FPU and KVM_SET_FPU */
 struct kvm_fpu {
 	__u8  fpr[8][16];
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 07d607947805..1a6e2de4248a 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -120,6 +120,11 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
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
index a9d95f90a048..f10a37f88c30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -112,6 +112,9 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
 
+static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
+static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
@@ -3796,6 +3799,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+	case KVM_CAP_SREGS2:
 		r = 1;
 		break;
 #ifdef CONFIG_KVM_XEN
@@ -4713,6 +4717,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 	union {
+		struct kvm_sregs2 *sregs2;
 		struct kvm_lapic_state *lapic;
 		struct kvm_xsave *xsave;
 		struct kvm_xcrs *xcrs;
@@ -5085,6 +5090,28 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 #endif
+	case KVM_GET_SREGS2: {
+		u.sregs2 = kzalloc(sizeof(struct kvm_sregs2), GFP_KERNEL_ACCOUNT);
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
@@ -9647,7 +9674,7 @@ void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 }
 EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
 
-static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct desc_ptr dt;
 
@@ -9680,14 +9707,30 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
+	if (is_pae_paging(vcpu))
+		for (i = 0 ; i < 4 ; i++)
+			sregs2->pdptrs[i] = kvm_pdptr_read(vcpu, i);
+}
+
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
@@ -9799,11 +9842,9 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
 
@@ -9815,8 +9856,9 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		goto out;
 
+	ret = 0;
 	if (vcpu->arch.guest_state_protected)
-		goto skip_protected_regs;
+		goto out;
 
 	dt.size = sregs->idt.limit;
 	dt.address = sregs->idt.base;
@@ -9826,32 +9868,22 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
@@ -9869,8 +9901,39 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
+		vcpu->arch.reload_pdptrs_on_nested_entry = true;
+	}
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (mmu_reset_needed)
+		kvm_mmu_reset_context(vcpu);
 
-skip_protected_regs:
 	max_bits = KVM_NR_INTERRUPTS;
 	pending_vec = find_first_bit(
 		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
@@ -9880,12 +9943,37 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
+	int i, ret, idx;
+
+	if (sregs2->flags || sregs2->padding)
+		return -EINVAL;
+
+	ret = __set_sregs_common(vcpu, (struct kvm_sregs *)sregs2, &mmu_reset_needed);
+	if (ret || vcpu->arch.guest_state_protected)
+		return ret;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	if (is_pae_paging(vcpu)) {
+		for (i = 0 ; i < 4 ; i++)
+			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
+		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+		mmu_reset_needed = 1;
+	}
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (mmu_reset_needed)
+		kvm_mmu_reset_context(vcpu);
+
+	return 0;
 }
 
+
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6afee209620..212a98082c36 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1078,6 +1078,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_SREGS2 196
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1616,6 +1617,10 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
 #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
 
+
+#define KVM_GET_SREGS2             _IOR(KVMIO,  0xca, struct kvm_sregs2)
+#define KVM_SET_SREGS2             _IOW(KVMIO,  0xcb, struct kvm_sregs2)
+
 struct kvm_xen_vcpu_attr {
 	__u16 type;
 	__u16 pad[3];
-- 
2.26.2

