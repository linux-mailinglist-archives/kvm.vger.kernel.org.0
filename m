Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598234CC638
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiCCTkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiCCTj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76C401965CD
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9UKLJh7uqurGcKh1ziUITBIO4DBP4Uy0WGquCwhfKCE=;
        b=Dw8EZv7D18DQ5eFnDUURtM1S4ZtM6dwf4epQgMC0W0yhnsAQAQr43HFEZWxVdEkb+FH9sE
        uTjaPWWEyaLIEnaFAlzibGaiFVtMND5P8eqHBbS+kJ59hIn5lUQpFmyMedFuqpDJSeekDU
        kxUUNuX0t+G8p2VvJ0n4WHNU5YmktHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-nhXMOG35NEaooav-LKGRwA-1; Thu, 03 Mar 2022 14:38:59 -0500
X-MC-Unique: nhXMOG35NEaooav-LKGRwA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55184824FAA;
        Thu,  3 Mar 2022 19:38:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 819425DF2E;
        Thu,  3 Mar 2022 19:38:57 +0000 (UTC)
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
Subject: [PATCH v4 14/30] KVM: x86/mmu: Zap only the target TDP MMU shadow page in NX recovery
Date:   Thu,  3 Mar 2022 14:38:26 -0500
Message-Id: <20220303193842.370645-15-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

When recovering a potential hugepage that was shattered for the iTLB
multihit workaround, precisely zap only the target page instead of
iterating over the TDP MMU to find the SP that was passed in.  This will
allow future simplification of zap_gfn_range() by having it zap only
leaf SPTEs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220226001546.360188-14-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu_internal.h |  7 ++++++-
 arch/x86/kvm/mmu/tdp_iter.h     |  2 --
 arch/x86/kvm/mmu/tdp_mmu.c      | 36 +++++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h      | 18 +----------------
 4 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index da6166b5c377..be063b6c91b7 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -30,6 +30,8 @@ extern bool dbg;
 #define INVALID_PAE_ROOT	0
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
+typedef u64 __rcu *tdp_ptep_t;
+
 struct kvm_mmu_page {
 	/*
 	 * Note, "link" through "spt" fit in a single 64 byte cache line on
@@ -59,7 +61,10 @@ struct kvm_mmu_page {
 		refcount_t tdp_mmu_root_count;
 	};
 	unsigned int unsync_children;
-	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+	union {
+		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+		tdp_ptep_t ptep;
+	};
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 	struct list_head lpage_disallowed_link;
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index bb9b581f1ee4..e2a7e267a77d 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -7,8 +7,6 @@
 
 #include "mmu.h"
 
-typedef u64 __rcu *tdp_ptep_t;
-
 /*
  * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
  * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0ffa62abde2d..dc9db5057f3b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -199,13 +199,14 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 	return sp;
 }
 
-static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, gfn_t gfn,
-			      union kvm_mmu_page_role role)
+static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
+			    gfn_t gfn, union kvm_mmu_page_role role)
 {
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	sp->role = role;
 	sp->gfn = gfn;
+	sp->ptep = sptep;
 	sp->tdp_mmu_page = true;
 
 	trace_kvm_mmu_get_page(sp, true);
@@ -222,7 +223,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	role = parent_sp->role;
 	role.level--;
 
-	tdp_mmu_init_sp(child_sp, iter->gfn, role);
+	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
@@ -244,7 +245,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	}
 
 	root = tdp_mmu_alloc_sp(vcpu);
-	tdp_mmu_init_sp(root, 0, role);
+	tdp_mmu_init_sp(root, NULL, 0, role);
 
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
@@ -736,6 +737,33 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
 }
 
+bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	u64 old_spte;
+
+	/*
+	 * This helper intentionally doesn't allow zapping a root shadow page,
+	 * which doesn't have a parent page table and thus no associated entry.
+	 */
+	if (WARN_ON_ONCE(!sp->ptep))
+		return false;
+
+	rcu_read_lock();
+
+	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
+	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte))) {
+		rcu_read_unlock();
+		return false;
+	}
+
+	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
+			   sp->gfn, sp->role.level + 1, true, true);
+
+	rcu_read_unlock();
+
+	return true;
+}
+
 /*
  * Tears down the mappings for the range of gfns, [start, end), and frees the
  * non-root pages mapping GFNs strictly within that range. Returns true if
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 57c73d8f76ce..5e5ef2576c81 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -22,24 +22,8 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
 {
 	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
 }
-static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1);
-
-	/*
-	 * Don't allow yielding, as the caller may have a flush pending.  Note,
-	 * if mmu_lock is held for write, zapping will never yield in this case,
-	 * but explicitly disallow it for safety.  The TDP MMU does not yield
-	 * until it has made forward progress (steps sideways), and when zapping
-	 * a single shadow page that it's guaranteed to see (thus the mmu_lock
-	 * requirement), its "step sideways" will always step beyond the bounds
-	 * of the shadow page's gfn range and stop iterating before yielding.
-	 */
-	lockdep_assert_held_write(&kvm->mmu_lock);
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
-					   sp->gfn, end, false, false);
-}
 
+bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
-- 
2.31.1


