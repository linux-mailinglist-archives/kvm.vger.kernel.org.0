Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427CC457B86
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbhKTEzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbhKTEyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:46 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E51C0613B7
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:23 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id o8-20020a170902d4c800b001424abc88f3so5712320plg.2
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ns9rCLQADt8t2SBx4TYj+H6BayFqNp4LZMTzef4JTLc=;
        b=OgGPsjH0/oiQPhqX5Mu/d8/pWtlX76RFYvNj7sFeWH8kBwbv0i4bvoUKHalBKew5Hx
         gEnijam+Od7DJ70adFMrXX+MtKsluctUwc7zJWIMmQZtIjLHxxM8LWCag8FZ1egIEPQ8
         TXabxgC6pvND10vqpehZOM1QW+tcZZlBYsJN72ShvPqe5aVE/ShTBu4hgTjkx7bpb44x
         upMMzDVWoxMyD7JDg8DctXksLEYZXxE3sjfKpecbjZXCRMzkBbLfiEzfXXKyOZB8DHr1
         dvQ1Z23AZMZxzT8aj2VRvQ9ETui06i2BI4rla6emoaBPq3nxayZqr1uRTT8cdGv7izbX
         r+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ns9rCLQADt8t2SBx4TYj+H6BayFqNp4LZMTzef4JTLc=;
        b=1+VAeVQL0bjgDbP8tGa3w3EDwunE3663gRyT1bU+kqmea2ijNBHtFKVQapMBuoT90y
         +u+JEoAFeGTMFOVMPoRiujrcRJXGKE62oGThxlrePCRf3U9i9nQbiCv7O3HXQfZE+Iwk
         RuVmbnonPcwHbb4CIBC/qYMD/Q4xNApLpbrIbrMCIVDaFRroK2pvc/Tdvvf8eFpmiZtF
         Iwj75A/LzVDMGuQXatfzlFKbYVzp++QWMS84rLtzzNqaRlCM5BuBUjrBk0T9Y8VDymXn
         xPtYgS21CQQWYNlCZQ2kNAnpfTXTw2iz02zpSkJZdfx8BS+iwp2IuE/V/auj6ICOUCjx
         QB8Q==
X-Gm-Message-State: AOAM533g6qTFP8F0wBbyv+pZ6ic6odrqQOOR2W901uDqBnesNZrlZihG
        Lna6pZUYE2zh9jPDn4UJ5blCt/TvXuI=
X-Google-Smtp-Source: ABdhPJzH2l1COCtvrQiJ+bIKt6iHKV+bVpo42IrGeh89e7VjiFoNQohNbGCJJ0PXXFe+e29YnDw05zTqQ7E=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:96ba:0:b0:49f:c35f:83f8 with SMTP id
 g26-20020aa796ba000000b0049fc35f83f8mr28267300pfk.47.1637383882535; Fri, 19
 Nov 2021 20:51:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:36 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-19-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 18/28] KVM: x86/mmu: Refactor low-level TDP MMU set SPTE
 helper to take raw vals
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor __tdp_mmu_set_spte() to work with raw values instead of a
tdp_iter objects so that a future patch can modify SPTEs without doing a
walk, and without having to synthesize a tdp_iter.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 47 +++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cc8d021a1ba5..7d354344924d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -622,9 +622,13 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 
 /*
  * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
- * @kvm: kvm instance
- * @iter: a tdp_iter instance currently on the SPTE that should be set
- * @new_spte: The value the SPTE should be set to
+ * @kvm:	      KVM instance
+ * @as_id:	      Address space ID, i.e. regular vs. SMM
+ * @sptep:	      Pointer to the SPTE
+ * @old_spte:	      The current value of the SPTE
+ * @new_spte:	      The new value that will be set for the SPTE
+ * @gfn:	      The base GFN that was (or will be) mapped by the SPTE
+ * @level:	      The level _containing_ the SPTE (its parent PT's level)
  * @record_acc_track: Notify the MM subsystem of changes to the accessed state
  *		      of the page. Should be set unless handling an MMU
  *		      notifier for access tracking. Leaving record_acc_track
@@ -636,9 +640,9 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  *		      Leaving record_dirty_log unset in that case prevents page
  *		      writes from being double counted.
  */
-static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				      u64 new_spte, bool record_acc_track,
-				      bool record_dirty_log)
+static void __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+			       u64 old_spte, u64 new_spte, gfn_t gfn, int level,
+			       bool record_acc_track, bool record_dirty_log)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -649,39 +653,46 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	 * should be used. If operating under the MMU lock in write mode, the
 	 * use of the removed SPTE should not be necessary.
 	 */
-	WARN_ON(is_removed_spte(iter->old_spte) || is_removed_spte(new_spte));
+	WARN_ON(is_removed_spte(old_spte) || is_removed_spte(new_spte));
 
-	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+	kvm_tdp_mmu_write_spte(sptep, new_spte);
+
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, false);
 	if (record_acc_track)
-		handle_changed_spte_acc_track(iter->old_spte, new_spte,
-					      iter->level);
+		handle_changed_spte_acc_track(old_spte, new_spte, level);
 	if (record_dirty_log)
-		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
-					      iter->old_spte, new_spte,
-					      iter->level);
+		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
+					      new_spte, level);
+}
+
+static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				     u64 new_spte, bool record_acc_track,
+				     bool record_dirty_log)
+{
+	__tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep, iter->old_spte,
+			   new_spte, iter->gfn, iter->level,
+			   record_acc_track, record_dirty_log);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				    u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
 }
 
 static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
 }
 
 static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-- 
2.34.0.rc2.393.gf8c9666880-goog

