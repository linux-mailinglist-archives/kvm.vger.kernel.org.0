Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3D628E65D
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389189AbgJNS2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389147AbgJNS1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48703C061755
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:30 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id r4so94528pgl.20
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IF7O9+8t5pNEsHOvCgk0rMRWZOkswBOXctC0HBVzeOE=;
        b=fPtj58miaz6nE/u62aMG3z0LNt5YebUvTIP2FbVpmo8tAaAGIrKOA+GUGAojLqEqKo
         HH47bZ87fPNiSLDGw+qtn1YX+R3fihYXEG1SE4IfHhRK4QYvKbAkIEmllAwKZk12kqL8
         841pfizOXqQ1PBGu1Pzk3sZrc2vF1hpTUCY11Pa9UBRVBr0+HYphFUUsjBzINxUTV5OA
         wmiINs9LNTbeH6oIxv0rYj2gdnbpZDMcGCynEkgb88lhhHbXSRupYKdR55XGAjodUfJ6
         G4yjyBLiMtkUfmAEWzFl0fvBdxow/vQ4ptBF+xRGEfzYdXGUx+UrDcaolGGFUZTMqdBT
         Bbig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IF7O9+8t5pNEsHOvCgk0rMRWZOkswBOXctC0HBVzeOE=;
        b=efE/7COFwFqDlgkHCIrpj+YJCOLsowaGrxK2dc1WPpauJ3+zSJmi7tDto1zSNohF/v
         3ZwDUCZZG6CTX8Iean3PGZFejMmeqV9a6uoyC7nlV9FkMBXordFtCJNr4UkzIcp4x4t8
         G9FJBbfN7G+/ihSqPn/WjsMCyDS3GuO8zvV45+0DU0AIlyn5UFVFrUaAHb0YDSBOupZh
         jkAUXORuSX5cIQLRD1pjAwWLlMAW36YuNlnx1lvr9whrn82Yt0ui6IgLJdd6dhOP5V0m
         RN2X5sm9mc425KhoV4w4ZAOC3Nux/vvgTlR2Fzu5Z6B9ndxzynRt1U67Q9lrILOV5eJj
         RHCA==
X-Gm-Message-State: AOAM532tA1Ni/wZq0VGDpHdiIVFiBPrK+pO1oTOLBz/5leehpnEPHOfr
        3hd2clTgladFCKkDSKtGAgyC7wY1QY4A
X-Google-Smtp-Source: ABdhPJx8PXc/N5pCc+Bm9+YEAfoIbIsqvl0LfxTiWu8fwYteKgqSU4fMtIYHQ/Ld9a8iNrFRVuA/YbM8O5Kw
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:b7c3:b029:d4:bc6e:8aae with SMTP
 id v3-20020a170902b7c3b02900d4bc6e8aaemr408683plz.12.1602700049618; Wed, 14
 Oct 2020 11:27:29 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:54 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-15-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 14/20] kvm: x86/mmu: Support changed pte notifier in tdp MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to interoperate correctly with the rest of KVM and other Linux
subsystems, the TDP MMU must correctly handle various MMU notifiers. Add
a hook and handle the change_pte MMU notifier.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 21 ++++++-------
 arch/x86/kvm/mmu/mmu_internal.h | 29 +++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 56 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |  3 ++
 4 files changed, 98 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e6ab79d8f215f..ef9ea3f45241b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -135,9 +135,6 @@ enum {
 
 #include <trace/events/kvm.h>
 
-#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
-#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
-
 /* make pte_list_desc fit well in cache line */
 #define PTE_LIST_EXT 3
 
@@ -1615,13 +1612,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			pte_list_remove(rmap_head, sptep);
 			goto restart;
 		} else {
-			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
-			new_spte |= (u64)new_pfn << PAGE_SHIFT;
-
-			new_spte &= ~PT_WRITABLE_MASK;
-			new_spte &= ~SPTE_HOST_WRITEABLE;
-
-			new_spte = mark_spte_for_access_track(new_spte);
+			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
+					*sptep, new_pfn);
 
 			mmu_spte_clear_track_bits(sptep);
 			mmu_spte_set(sptep, new_spte);
@@ -1777,7 +1769,14 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
-	return kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
+	int r;
+
+	r = kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		r |= kvm_tdp_mmu_set_spte_hva(kvm, hva, &pte);
+
+	return r;
 }
 
 static int kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d886fe750be38..49c3a04d2b894 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -115,6 +115,12 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
 						* PT64_LEVEL_BITS))) - 1))
 
+#ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
+#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
+#else
+#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#endif
+
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
 #define ACC_USER_MASK    PT_USER_MASK
@@ -132,6 +138,12 @@ static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
  */
 static u64 __read_mostly shadow_acc_track_mask;
 
+#define PT_FIRST_AVAIL_BITS_SHIFT 10
+#define PT64_SECOND_AVAIL_BITS_SHIFT 54
+
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
+
 /* Functions for interpreting SPTEs */
 static inline bool is_mmio_spte(u64 spte)
 {
@@ -264,4 +276,21 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
 u64 mark_spte_for_access_track(u64 spte);
 
+static inline u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte,
+							 kvm_pfn_t new_pfn)
+{
+	u64 new_spte;
+
+	new_spte = old_spte & ~PT64_BASE_ADDR_MASK;
+	new_spte |= (u64)new_pfn << PAGE_SHIFT;
+
+	new_spte &= ~PT_WRITABLE_MASK;
+	new_spte &= ~SPTE_HOST_WRITEABLE;
+
+	new_spte = mark_spte_for_access_track(new_spte);
+
+	return new_spte;
+}
+
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 575970d8805a4..90abd55c89375 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -677,3 +677,59 @@ int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
 	return kvm_tdp_mmu_handle_hva_range(kvm, hva, hva + 1, 0,
 					    test_age_gfn);
 }
+
+/*
+ * Handle the changed_pte MMU notifier for the TDP MMU.
+ * data is a pointer to the new pte_t mapping the HVA specified by the MMU
+ * notifier.
+ * Returns non-zero if a flush is needed before releasing the MMU lock.
+ */
+static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
+			struct kvm_mmu_page *root, gfn_t gfn, gfn_t unused,
+			unsigned long data)
+{
+	struct tdp_iter iter;
+	pte_t *ptep = (pte_t *)data;
+	kvm_pfn_t new_pfn;
+	u64 new_spte;
+	int need_flush = 0;
+
+	WARN_ON(pte_huge(*ptep));
+
+	new_pfn = pte_pfn(*ptep);
+
+	tdp_root_for_each_pte(iter, root, gfn, gfn + 1) {
+		if (iter.level != PG_LEVEL_4K)
+			continue;
+
+		if (!is_shadow_present_pte(iter.old_spte))
+			break;
+
+		tdp_mmu_set_spte(kvm, &iter, 0);
+
+		kvm_flush_remote_tlbs_with_address(kvm, iter.gfn, 1);
+
+		if (!pte_write(*ptep)) {
+			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
+					iter.old_spte, new_pfn);
+
+			tdp_mmu_set_spte(kvm, &iter, new_spte);
+		}
+
+		need_flush = 1;
+	}
+
+	if (need_flush)
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+
+	return 0;
+}
+
+int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
+			     pte_t *host_ptep)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, address, address + 1,
+					    (unsigned long)host_ptep,
+					    set_tdp_spte);
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index bdb86f61e75eb..6569792f40d4f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -25,4 +25,7 @@ int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
 int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
 			      unsigned long end);
 int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
+
+int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
+			     pte_t *host_ptep);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.1011.ga647a8990f-goog

