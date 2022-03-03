Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46AF4CC626
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbiCCTj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiCCTjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36CA216EA84
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HlWI2gxDfG+lEXz4JBMe32A6hxayqCElIVvbsz5M/C0=;
        b=jEB/rjJgqQD3o+Qv/sCrn2rCrP5Pa1XpAAcd5Gxul+pejk2fJC4aDpzxAOYe/IUu1AeEnR
        BTHhR0gOYcENbXVDDAg/65BbfAlm+Tyybbe6uaDhL6SXuimBfLDuEi5c+M5hfxIruduF3a
        fJ8KT2UVgKgewCZEKKCrAjam+fz6C6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-PpHYc9oONUiK1Oji1aTipQ-1; Thu, 03 Mar 2022 14:38:56 -0500
X-MC-Unique: PpHYc9oONUiK1Oji1aTipQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CBF5801AB2;
        Thu,  3 Mar 2022 19:38:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 791255DF2E;
        Thu,  3 Mar 2022 19:38:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 11/30] KVM: x86/mmu: Add helpers to read/write TDP MMU SPTEs and document RCU
Date:   Thu,  3 Mar 2022 14:38:23 -0500
Message-Id: <20220303193842.370645-12-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add helpers to read and write TDP MMU SPTEs instead of open coding
rcu_dereference() all over the place, and to provide a convenient
location to document why KVM doesn't exempt holding mmu_lock for write
from having to hold RCU (and any future changes to the rules).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-11-seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_iter.c |  6 +++---
 arch/x86/kvm/mmu/tdp_iter.h | 16 ++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  |  6 +++---
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index be3f096db2eb..6d3b3e5a5533 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -12,7 +12,7 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
 	iter->sptep = iter->pt_path[iter->level - 1] +
 		SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
-	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 }
 
 static gfn_t round_gfn_for_level(gfn_t gfn, int level)
@@ -89,7 +89,7 @@ static bool try_step_down(struct tdp_iter *iter)
 	 * Reread the SPTE before stepping down to avoid traversing into page
 	 * tables that are no longer linked from this entry.
 	 */
-	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 
 	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
 	if (!child_pt)
@@ -123,7 +123,7 @@ static bool try_step_side(struct tdp_iter *iter)
 	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
 	iter->next_last_level_gfn = iter->gfn;
 	iter->sptep++;
-	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 216ebbe76ddd..bb9b581f1ee4 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -9,6 +9,22 @@
 
 typedef u64 __rcu *tdp_ptep_t;
 
+/*
+ * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
+ * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
+ * correctness if mmu_lock is held for write, but plumbing "struct kvm" down to
+ * the lower depths of the TDP MMU just to make lockdep happy is a nightmare, so
+ * all accesses to SPTEs are done under RCU protection.
+ */
+static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)
+{
+	return READ_ONCE(*rcu_dereference(sptep));
+}
+static inline void kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 val)
+{
+	WRITE_ONCE(*rcu_dereference(sptep), val);
+}
+
 /*
  * A TDP iterator performs a pre-order walk over a TDP paging structure.
  */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 22b0c03b673b..371b6a108736 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -595,7 +595,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * here since the SPTE is going from non-present
 	 * to non-present.
 	 */
-	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
+	kvm_tdp_mmu_write_spte(iter->sptep, 0);
 
 	return 0;
 }
@@ -634,7 +634,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	 */
 	WARN_ON(is_removed_spte(iter->old_spte));
 
-	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
+	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			      new_spte, iter->level, false);
@@ -1069,7 +1069,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			 * because the new value informs the !present
 			 * path below.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
-- 
2.31.1


