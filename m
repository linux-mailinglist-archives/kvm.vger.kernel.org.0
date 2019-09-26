Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001FEBFBCB
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfIZXSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:48 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:37256 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfIZXSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:47 -0400
Received: by mail-pg1-f202.google.com with SMTP id h189so2348410pgc.4
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k2Dc/bYQQNYo+zhNw9+XsgIjDidPtlvntzaPZkQuDU8=;
        b=dv/hu5RS3U8yfyOn8gQ5HEIZx9BjA4IB7i370xSi6K0Of0jKZZfX9w1s03R3y00X9x
         qv60GgMvxfLsF+B+QVrQCBsG+un0NhMFEVjgjR7T6SZkk6Co+mMcDUHSlNdamW90kRRu
         hjbvNZDYDSiuCfhU2FsUIdW4L63zCvDYF/z/6pHziKsqvFT1p2T4ouKOrxHKsXBbE1Ny
         pPJgxdLUdfhaQjclSvynS+HASXQmsXFX2mqaV0PRMEOl2kevxuvXzlfeAa9lwiAKZZqA
         DOYXRTqTxFUubW5o8dgNDr0P+GJvIXalwFliishx/tXBDEc+ph30nnprURg5ZrF26a8E
         qaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k2Dc/bYQQNYo+zhNw9+XsgIjDidPtlvntzaPZkQuDU8=;
        b=Qy8CZ1fShkX3TEIpN5V5y0Lg4VHll9AwJXOyyiiQvj4kKKQbQmdqmLsUY6Owq9GvWC
         bMJvbll18ofU4hpN7DxBtdy1nRJpSOBJMTDQuW8l6txoz6WpHRrJh1yVdnjleEf1nKwh
         s45VngJylQMmJE0/zSHjU8bnOqGMqz/d9MsSXozuRvaCTdeHCyL/QGrbSX8FthwYAtKf
         Js+ooq6KMa72VF4ZgnIXHzCnmsy6NTpF3ogBvEixRFIGO7Mk7xPOoADySXBzYPqHA/wT
         VIppP2xDISl43eEh5sVkZN8/ghq+3b3IqNgL5zqwY7+25jD/vrf52Of2eE6etrFJnxHx
         MF8w==
X-Gm-Message-State: APjAAAWI27Hqj6ECe6Ducc3m2mP9hhhDrPkhcDl8e2+VQYQHmhWWQkiN
        n/L92IfgNYUigJxAQufZmm7Lf94YuRID2wBhgOMG29zUEFpkuc4Soco14Z43IXeJDfICGXGCr4W
        oZBdFRspdAXB9PFWwR8hGMUybjIKQ57ICPWuFMlQ0pkMrAARmTEksOpp2iJtC
X-Google-Smtp-Source: APXvYqyXMt9mVj8RdDe6RNZpP6A9qiv5gcO7SqK8vKWcn6m346ItE0pHlZeqIbkKTpnf9Z/7gwzFW5hJM12M
X-Received: by 2002:a63:5f09:: with SMTP id t9mr5994025pgb.51.1569539926203;
 Thu, 26 Sep 2019 16:18:46 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:04 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-9-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 08/28] kvm: mmu: Init / Uninit the direct MMU
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The direct MMU introduces several new fields that need to be initialized
and torn down. Add functions to do that initialization / cleanup.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  51 ++++++++----
 arch/x86/kvm/mmu.c              | 132 +++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c              |  16 +++-
 3 files changed, 169 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 23edf56cf577c..1f8164c577d50 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -236,6 +236,22 @@ enum {
  */
 #define KVM_APIC_PV_EOI_PENDING	1
 
+#define HF_GIF_MASK		(1 << 0)
+#define HF_HIF_MASK		(1 << 1)
+#define HF_VINTR_MASK		(1 << 2)
+#define HF_NMI_MASK		(1 << 3)
+#define HF_IRET_MASK		(1 << 4)
+#define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
+#define HF_SMM_MASK		(1 << 6)
+#define HF_SMM_INSIDE_NMI_MASK	(1 << 7)
+
+#define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
+#define KVM_ADDRESS_SPACE_NUM 2
+
+#define kvm_arch_vcpu_memslots_id(vcpu) \
+		((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
+#define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
+
 struct kvm_kernel_irq_routing_entry;
 
 /*
@@ -940,6 +956,24 @@ struct kvm_arch {
 	bool exception_payload_enabled;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
+
+	/*
+	 * Whether the direct MMU is enabled for this VM. This contains a
+	 * snapshot of the direct MMU module parameter from when the VM was
+	 * created and remains unchanged for the life of the VM. If this is
+	 * true, direct MMU handler functions will run for various MMU
+	 * operations.
+	 */
+	bool direct_mmu_enabled;
+	/*
+	 * Indicates that the paging structure built by the direct MMU is
+	 * currently the only one in use. If nesting is used, prompting the
+	 * creation of shadow page tables for L2, this will be set to false.
+	 * While this is true, only direct MMU handlers will be run for many
+	 * MMU functions. Ignored if !direct_mmu_enabled.
+	 */
+	bool pure_direct_mmu;
+	hpa_t direct_root_hpa[KVM_ADDRESS_SPACE_NUM];
 };
 
 struct kvm_vm_stat {
@@ -1255,7 +1289,7 @@ void kvm_mmu_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
-void kvm_mmu_init_vm(struct kvm *kvm);
+int kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 p_mask,
@@ -1519,21 +1553,6 @@ enum {
 	TASK_SWITCH_GATE = 3,
 };
 
-#define HF_GIF_MASK		(1 << 0)
-#define HF_HIF_MASK		(1 << 1)
-#define HF_VINTR_MASK		(1 << 2)
-#define HF_NMI_MASK		(1 << 3)
-#define HF_IRET_MASK		(1 << 4)
-#define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
-#define HF_SMM_MASK		(1 << 6)
-#define HF_SMM_INSIDE_NMI_MASK	(1 << 7)
-
-#define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
-#define KVM_ADDRESS_SPACE_NUM 2
-
-#define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
-#define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
-
 asmlinkage void kvm_spurious_fault(void);
 
 /*
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 50413f17c7cd0..788edbda02f69 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -47,6 +47,10 @@
 #include <asm/kvm_page_track.h>
 #include "trace.h"
 
+static bool __read_mostly direct_mmu_enabled;
+module_param_named(enable_direct_mmu, direct_mmu_enabled, bool,
+		   S_IRUGO | S_IWUSR);
+
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
  * where the hardware walks 2 page tables:
@@ -3754,27 +3758,56 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	*root_hpa = INVALID_PAGE;
 }
 
+static bool is_direct_mmu_root(struct kvm *kvm, hpa_t root)
+{
+	int as_id;
+
+	for (as_id = 0; as_id < KVM_ADDRESS_SPACE_NUM; as_id++)
+		if (root == kvm->arch.direct_root_hpa[as_id])
+			return true;
+
+	return false;
+}
+
 /* roots_to_free must be some combination of the KVM_MMU_ROOT_* flags */
 void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			ulong roots_to_free)
 {
 	int i;
 	LIST_HEAD(invalid_list);
-	bool free_active_root = roots_to_free & KVM_MMU_ROOT_CURRENT;
 
 	BUILD_BUG_ON(KVM_MMU_NUM_PREV_ROOTS >= BITS_PER_LONG);
 
-	/* Before acquiring the MMU lock, see if we need to do any real work. */
-	if (!(free_active_root && VALID_PAGE(mmu->root_hpa))) {
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-			if ((roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) &&
-			    VALID_PAGE(mmu->prev_roots[i].hpa))
-				break;
+	/*
+	 * Direct MMU paging structures follow the life of the VM, so instead of
+	 * destroying direct MMU paging structure root, simply mark the root
+	 * HPA pointing to it as invalid.
+	 */
+	if (vcpu->kvm->arch.direct_mmu_enabled &&
+	    roots_to_free & KVM_MMU_ROOT_CURRENT &&
+	    is_direct_mmu_root(vcpu->kvm, mmu->root_hpa))
+		mmu->root_hpa = INVALID_PAGE;
 
-		if (i == KVM_MMU_NUM_PREV_ROOTS)
-			return;
+	if (!VALID_PAGE(mmu->root_hpa))
+		roots_to_free &= ~KVM_MMU_ROOT_CURRENT;
+
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+		if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) {
+			if (is_direct_mmu_root(vcpu->kvm,
+					       mmu->prev_roots[i].hpa))
+				mmu->prev_roots[i].hpa = INVALID_PAGE;
+			if (!VALID_PAGE(mmu->prev_roots[i].hpa))
+				roots_to_free &= ~KVM_MMU_ROOT_PREVIOUS(i);
+		}
 	}
 
+	/*
+	 * If there are no valid roots that need freeing at this point, avoid
+	 * acquiring the MMU lock and return.
+	 */
+	if (!roots_to_free)
+		return;
+
 	write_lock(&vcpu->kvm->mmu_lock);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
@@ -3782,7 +3815,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			mmu_free_root_page(vcpu->kvm, &mmu->prev_roots[i].hpa,
 					   &invalid_list);
 
-	if (free_active_root) {
+	if (roots_to_free & KVM_MMU_ROOT_CURRENT) {
 		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
@@ -3820,7 +3853,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_page *sp;
 	unsigned i;
 
-	if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+	if (vcpu->kvm->arch.direct_mmu_enabled) {
+		// TODO: Support 5 level paging in the direct MMU
+		BUG_ON(vcpu->arch.mmu->shadow_root_level > PT64_ROOT_4LEVEL);
+		vcpu->arch.mmu->root_hpa = vcpu->kvm->arch.direct_root_hpa[
+			kvm_arch_vcpu_memslots_id(vcpu)];
+	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
 		write_lock(&vcpu->kvm->mmu_lock);
 		if(make_mmu_pages_available(vcpu) < 0) {
 			write_unlock(&vcpu->kvm->mmu_lock);
@@ -3863,6 +3901,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	gfn_t root_gfn, root_cr3;
 	int i;
 
+	write_lock(&vcpu->kvm->mmu_lock);
+	vcpu->kvm->arch.pure_direct_mmu = false;
+	write_unlock(&vcpu->kvm->mmu_lock);
+
 	root_cr3 = vcpu->arch.mmu->get_cr3(vcpu);
 	root_gfn = root_cr3 >> PAGE_SHIFT;
 
@@ -5710,6 +5752,64 @@ void kvm_disable_tdp(void)
 }
 EXPORT_SYMBOL_GPL(kvm_disable_tdp);
 
+static bool is_direct_mmu_enabled(void)
+{
+	if (!READ_ONCE(direct_mmu_enabled))
+		return false;
+
+	if (WARN_ONCE(!tdp_enabled,
+		      "Creating a VM with direct MMU enabled requires TDP."))
+		return false;
+
+	return true;
+}
+
+static int kvm_mmu_init_direct_mmu(struct kvm *kvm)
+{
+	struct page *page;
+	int i;
+
+	if (!is_direct_mmu_enabled())
+		return 0;
+
+	/*
+	 * Allocate the direct MMU root pages. These pages follow the life of
+	 * the VM.
+	 */
+	for (i = 0; i < ARRAY_SIZE(kvm->arch.direct_root_hpa); i++) {
+		page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!page)
+			goto err;
+		kvm->arch.direct_root_hpa[i] = page_to_phys(page);
+	}
+
+	/* This should not be changed for the lifetime of the VM. */
+	kvm->arch.direct_mmu_enabled = true;
+
+	kvm->arch.pure_direct_mmu = true;
+	return 0;
+err:
+	for (i = 0; i < ARRAY_SIZE(kvm->arch.direct_root_hpa); i++) {
+		if (kvm->arch.direct_root_hpa[i] &&
+		    VALID_PAGE(kvm->arch.direct_root_hpa[i]))
+			free_page((unsigned long)kvm->arch.direct_root_hpa[i]);
+		kvm->arch.direct_root_hpa[i] = INVALID_PAGE;
+	}
+	return -ENOMEM;
+}
+
+static void kvm_mmu_uninit_direct_mmu(struct kvm *kvm)
+{
+	int i;
+
+	if (!kvm->arch.direct_mmu_enabled)
+		return;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
+		handle_disconnected_pt(kvm, i, 0,
+			(kvm_pfn_t)(kvm->arch.direct_root_hpa[i] >> PAGE_SHIFT),
+			PT64_ROOT_4LEVEL);
+}
 
 /* The return value indicates if tlb flush on all vcpus is needed. */
 typedef bool (*slot_level_handler) (struct kvm *kvm, struct kvm_rmap_head *rmap_head);
@@ -5956,13 +6056,19 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 	kvm_mmu_zap_all_fast(kvm);
 }
 
-void kvm_mmu_init_vm(struct kvm *kvm)
+int kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
+	int r;
+
+	r = kvm_mmu_init_direct_mmu(kvm);
+	if (r)
+		return r;
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
+	return 0;
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
@@ -5970,6 +6076,8 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
 	kvm_page_track_unregister_notifier(kvm, node);
+
+	kvm_mmu_uninit_direct_mmu(kvm);
 }
 
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9ecf83da396c9..2972b6c6029fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9421,6 +9421,8 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
+	int err;
+
 	if (type)
 		return -EINVAL;
 
@@ -9450,9 +9452,19 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_hv_init_vm(kvm);
 	kvm_page_track_init(kvm);
-	kvm_mmu_init_vm(kvm);
+	err = kvm_mmu_init_vm(kvm);
+	if (err)
+		return err;
+
+	err = kvm_x86_ops->vm_init(kvm);
+	if (err)
+		goto error;
+
+	return 0;
 
-	return kvm_x86_ops->vm_init(kvm);
+error:
+	kvm_mmu_uninit_vm(kvm);
+	return err;
 }
 
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
-- 
2.23.0.444.g18eeb5a265-goog

