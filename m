Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5448CB157
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389046AbfJCVjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:39:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:52651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730739AbfJCVi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:38:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051620"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: [RFC PATCH 03/13] kvm: Add XO memslot type
Date:   Thu,  3 Oct 2019 14:23:50 -0700
Message-Id: <20191003212400.31130-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add XO memslot type to create execute-only guest physical memory based on
the RO memslot. Like the RO memslot, disallow changing the memslot type
to/from XO.

In the EPT case ACC_USER_MASK represents the readable bit, so add the
ability for set_spte() to unset this.

This is based in part on a patch by Yu Zhang.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kvm/mmu.c             |  9 ++++++++-
 include/uapi/linux/kvm.h       |  1 +
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/kvm_main.c            | 15 ++++++++++++++-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e44a8053af78..338cc64cc821 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2981,6 +2981,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
+	else
+		spte &= ~shadow_user_mask;
 
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
@@ -3203,6 +3205,11 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	int ret;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	gfn_t base_gfn = gfn;
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	unsigned int pte_access = ACC_ALL;
+
+	if (slot && slot->flags & KVM_MEM_EXECONLY)
+		pte_access = ACC_EXEC_MASK;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
 		return RET_PF_RETRY;
@@ -3222,7 +3229,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 		}
 	}
 
-	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
+	ret = mmu_set_spte(vcpu, it.sptep, pte_access,
 			   write, level, base_gfn, pfn, prefault,
 			   map_writable);
 	direct_pte_prefetch(vcpu, it.sptep);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d5359e..ede487b7b216 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -109,6 +109,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_EXECONLY	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 5e3f12d5359e..ede487b7b216 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -109,6 +109,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_EXECONLY	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c6a91b044d8d..65087c1d67be 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -865,6 +865,8 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+	valid_flags |= KVM_MEM_EXECONLY;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -969,9 +971,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if (!old.npages)
 			change = KVM_MR_CREATE;
 		else { /* Modify an existing slot. */
+			const __u8 changeable = KVM_MEM_READONLY
+					       | KVM_MEM_EXECONLY;
+
 			if ((mem->userspace_addr != old.userspace_addr) ||
 			    (npages != old.npages) ||
-			    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
+			    ((new.flags ^ old.flags) & changeable))
 				goto out;
 
 			if (base_gfn != old.base_gfn)
@@ -1356,6 +1361,11 @@ static bool memslot_is_readonly(struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEM_READONLY;
 }
 
+static bool memslot_is_execonly(struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_EXECONLY;
+}
+
 static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 				       gfn_t *nr_pages, bool write)
 {
@@ -1365,6 +1375,9 @@ static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 	if (memslot_is_readonly(slot) && write)
 		return KVM_HVA_ERR_RO_BAD;
 
+	if (memslot_is_execonly(slot) && write)
+		return KVM_HVA_ERR_RO_BAD;
+
 	if (nr_pages)
 		*nr_pages = slot->npages - (gfn - slot->base_gfn);
 
-- 
2.17.1

