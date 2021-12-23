Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DD647E94D
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350479AbhLWWXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350423AbhLWWXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:23:47 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376EAC06175A
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:47 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b4-20020a17090a6e0400b001b179d36a57so6390128pjk.6
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=r5AFn4RCMgqUfgGu1hVllvQY0Qnai8Du0jee32fy2GE=;
        b=JnGNaEUL5DaNDIAqcnqFUV9gJzkXIPHdne6msuarIDeRsdzVe9j5BZhYTgWPAc3kb2
         YqigPSe0qYop80rjrutzrRQGfh1rPoopUu4u9rNRPJlfrEZnSwJl27MvGF5cvJ8gPs6h
         HBIxYsDfqTTuCiEe4Bq+c9m+27x5cU0RuofNyUp29gEWCAi38RhdXRg/F3q6EFyNA6Yc
         ZeoKqcLUYGpwopeTRsaQgKCjEhSvqf22qbLnqgsLQW1jqqna1Z+wDLrsZeVFxSXCIi+X
         0Yd0H7u/joCRL6cSEI1hat2U6dbd06rZHBUawWfq0NGuXTBcczlnMSeVdIPnSXLx/O0f
         V9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=r5AFn4RCMgqUfgGu1hVllvQY0Qnai8Du0jee32fy2GE=;
        b=1LypbuaT+1glb0j8uRFPNfc6+sa7mwsIZlPfzBvkbVZ10cc74pH/izYuT+8y9O+sya
         Dbz71Ms5/TdLGiOqtr7v1Opsxr+HU63Tt+5tUOAL5YSiy2ekdaHLbLGuMXOU5Mzq0Uut
         z91ohViiHt/K6ocapFtkCXCQ/m4WlI5MARlyal2+e/ttf1L2bAyGDsNesB6f1tP40Ixn
         dXnEg8AU/NMFSg+DBO4uJQlb4jIjW8fOlcFLUv2MrrQfDzy8wZ8R5IMDAPWA27eHJQBY
         DTmsIjQoZv6bK27/5Cxnt00f5QrwlkImYQ9+vXxKS70P+FOUwmUr2sAzzQ0JKeCx6K0P
         HZ+A==
X-Gm-Message-State: AOAM530O2JJd59oNi5qqNvpqxgbCTAkp2bAhxDgBnQBBpc2LM8eZwpa0
        3vaCCybAYEdyydyJjYNsncHuNeJtO2o=
X-Google-Smtp-Source: ABdhPJwBWPjs350K7xbsdKCjZNMI5z/bHmRVnyyOermRQrAcMNQmE8Qc+ApcdvilpdVim7ddlMHaLN/StUc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:114d:b0:4a2:87bd:37f with SMTP id
 b13-20020a056a00114d00b004a287bd037fmr4357612pfm.82.1640298226732; Thu, 23
 Dec 2021 14:23:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:22:51 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 03/30] KVM: x86/mmu: Zap _all_ roots when unmapping gfn
 range in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zap both valid and invalid roots when zapping/unmapping a gfn range, as
KVM must ensure it holds no references to the freed page after returning
from the unmap operation.  Most notably, thee TDP MMU doesn't zap invalid
roots in mmu_notifier callbacks.  This leads to use-after-free and other
issues if the mmu_notifier runs to completion while an invalid root
zapper yields as KVM fails to honor the requirement that there must be
_no_ references to the page after the mmu_notifier returns.

The bug is most easily reproduced by hacking KVM to cause a collision
between set_nx_huge_pages() + kvm_mmu_notifier_release(), but the bug
exists between kvm_mmu_notifier_invalidate_range_start() and memslot
updates as well.  Invalidating a root ensure pages aren't accessible by
the guest, and KVM won't read or write page data itself, but KVM will
trigger e.g. kvm_set_pfn_dirty() when zapping SPTEs, and thus completing
a zap _after_ the mmu_notifier returns is fatal.

  WARNING: CPU: 24 PID: 1496 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:173 [kvm]
  RIP: 0010:kvm_is_zone_device_pfn+0x96/0xa0 [kvm]
  Call Trace:
   <TASK>
   kvm_set_pfn_dirty+0xa8/0xe0 [kvm]
   __handle_changed_spte+0x2ab/0x5e0 [kvm]
   __handle_changed_spte+0x2ab/0x5e0 [kvm]
   __handle_changed_spte+0x2ab/0x5e0 [kvm]
   zap_gfn_range+0x1f3/0x310 [kvm]
   kvm_tdp_mmu_zap_invalidated_roots+0x50/0x90 [kvm]
   kvm_mmu_zap_all_fast+0x177/0x1a0 [kvm]
   set_nx_huge_pages+0xb4/0x190 [kvm]
   param_attr_store+0x70/0x100
   module_attr_store+0x19/0x30
   kernfs_fop_write_iter+0x119/0x1b0
   new_sync_write+0x11c/0x1b0
   vfs_write+0x1cc/0x270
   ksys_write+0x5f/0xe0
   do_syscall_64+0x38/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 39 +++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 200001190fcf..577985fa001d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -99,15 +99,18 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 }
 
 /*
- * Finds the next valid root after root (or the first valid root if root
- * is NULL), takes a reference on it, and returns that next root. If root
- * is not NULL, this thread should have already taken a reference on it, and
- * that reference will be dropped. If no valid root is found, this
- * function will return NULL.
+ * Returns the next root after @prev_root (or the first root if @prev_root is
+ * NULL).  A reference to the returned root is acquired, and the reference to
+ * @prev_root is released (the caller obviously must hold a reference to
+ * @prev_root if it's non-NULL).
+ *
+ * If @only_valid is true, invalid roots are skipped.
+ *
+ * Returns NULL if the end of tdp_mmu_roots was reached.
  */
 static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 					      struct kvm_mmu_page *prev_root,
-					      bool shared)
+					      bool shared, bool only_valid)
 {
 	struct kvm_mmu_page *next_root;
 
@@ -122,7 +125,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 						   typeof(*next_root), link);
 
 	while (next_root) {
-		if (!next_root->role.invalid &&
+		if ((!only_valid || !next_root->role.invalid) &&
 		    kvm_tdp_mmu_get_root(kvm, next_root))
 			break;
 
@@ -148,13 +151,19 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * mode. In the unlikely event that this thread must free a root, the lock
  * will be temporarily dropped and reacquired in write mode.
  */
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared);		\
-	     _root;							\
-	     _root = tdp_mmu_next_root(_kvm, _root, _shared))		\
-		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
+#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _only_valid)\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _only_valid);	\
+	     _root;								\
+	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _only_valid))	\
+		if (kvm_mmu_page_as_id(_root) != _as_id) {			\
 		} else
 
+#define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
+
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)		\
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, false)
+
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
 	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,		\
 				lockdep_is_held_type(&kvm->mmu_lock, 0) ||	\
@@ -1224,7 +1233,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
 
@@ -1294,7 +1303,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
 
@@ -1419,7 +1428,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		zap_collapsible_spte_range(kvm, root, slot);
 }
 
-- 
2.34.1.448.ga2b2bfdf31-goog

