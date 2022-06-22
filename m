Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E04355548A
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 21:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358916AbiFVT2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 15:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357889AbiFVT13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 15:27:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A86E403C5
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655926043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kNVgldTyS3PJ4ZE/gPt64ZM9nAJ1HaJiWQT9cl6zZ/E=;
        b=H6YGAVDqSGeE2Mt11e62N1GgCe8351xDhQ7wBsPN/HDRm98VDVl578e+BePqjnTtcTodbv
        ySYQxiTLGYDmXOa4E9Yv4E1NXzbPr0i270QQ/7Jsqm20NgafIlKYtmR2uZO2TjPn6FB6KJ
        A+yOa2CTf11tUwv18j4iKld1ZM2MlWk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-L5sKVtqpMq2Y7SR5QPPQDw-1; Wed, 22 Jun 2022 15:27:20 -0400
X-MC-Unique: L5sKVtqpMq2Y7SR5QPPQDw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 304EE811E75;
        Wed, 22 Jun 2022 19:27:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCD551121314;
        Wed, 22 Jun 2022 19:27:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     maz@kernel.org, anup@brainfault.org, seanjc@google.com,
        bgardon@google.com, peterx@redhat.com, maciej.szmigiero@oracle.com,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, pfeiner@google.com,
        jiangshanlai@gmail.com, dmatlack@google.com
Subject: [PATCH v7 20/23] KVM: x86/mmu: pull call to drop_large_spte() into __link_shadow_page()
Date:   Wed, 22 Jun 2022 15:27:07 -0400
Message-Id: <20220622192710.2547152-21-pbonzini@redhat.com>
In-Reply-To: <20220622192710.2547152-1-pbonzini@redhat.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before allocating a child shadow page table, all callers check
whether the parent already points to a huge page and, if so, they
drop that SPTE.  This is done by drop_large_spte().

However, the act that requires dropping the large SPTE is the
installation of the sp that is returned by kvm_mmu_get_child_sp(),
which happens in __link_shadow_page().  Move the call there
instead of having it in each and every caller.

To ensure that the shadow page is not linked twice if it was
present, do _not_ opportunistically make kvm_mmu_get_child_sp()
idempotent: instead, return an error value if the shadow page
already existed.  This is a bit more verbose, but clearer than
NULL.

Now that the drop_large_spte() name is not taken anymore,
remove the two underscores in front of __drop_large_spte().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 43 +++++++++++++++++-----------------
 arch/x86/kvm/mmu/paging_tmpl.h | 31 +++++++++++-------------
 2 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 36bc49f08d60..bf1ae5ebf41b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1135,26 +1135,16 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void drop_large_spte(struct kvm *kvm, u64 *sptep)
 {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
-
-	return false;
-}
+	struct kvm_mmu_page *sp;
 
-static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
 
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+	drop_spte(kvm, sptep);
+	kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
-	}
 }
 
 /*
@@ -2221,6 +2211,9 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 {
 	union kvm_mmu_page_role role;
 
+	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
+		return ERR_PTR(-EEXIST);
+
 	role = kvm_mmu_child_role(sptep, direct, access);
 	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
 }
@@ -2288,13 +2281,21 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
-static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
+static void __link_shadow_page(struct kvm *kvm,
+			       struct kvm_mmu_memory_cache *cache, u64 *sptep,
 			       struct kvm_mmu_page *sp)
 {
 	u64 spte;
 
 	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
 
+	/*
+	 * If an SPTE is present already, it must be a leaf and therefore
+	 * a large one.  Drop it and flush the TLB before installing sp.
+	 */
+	if (is_shadow_present_pte(*sptep))
+		drop_large_spte(kvm, sptep);
+
 	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
 
 	mmu_spte_set(sptep, spte);
@@ -2308,7 +2309,7 @@ static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
 static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 			     struct kvm_mmu_page *sp)
 {
-	__link_shadow_page(&vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
+	__link_shadow_page(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
 }
 
 static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
@@ -3080,11 +3081,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (it.level == fault->goal_level)
 			break;
 
-		drop_large_spte(vcpu, it.sptep);
-		if (is_shadow_present_pte(*it.sptep))
-			continue;
-
 		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_ALL);
+		if (sp == ERR_PTR(-EEXIST))
+			continue;
 
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (fault->is_tdp && fault->huge_page_disallowed &&
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 24f292f3f93f..2448fa8d8438 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -648,15 +648,13 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		gfn_t table_gfn;
 
 		clear_sp_write_flooding_count(it.sptep);
-		drop_large_spte(vcpu, it.sptep);
 
-		sp = NULL;
-		if (!is_shadow_present_pte(*it.sptep)) {
-			table_gfn = gw->table_gfn[it.level - 2];
-			access = gw->pt_access[it.level - 2];
-			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
-						  false, access);
+		table_gfn = gw->table_gfn[it.level - 2];
+		access = gw->pt_access[it.level - 2];
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
+					  false, access);
 
+		if (sp != ERR_PTR(-EEXIST)) {
 			/*
 			 * We must synchronize the pagetable before linking it
 			 * because the guest doesn't need to flush tlb when
@@ -685,7 +683,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
 			goto out_gpte_changed;
 
-		if (sp)
+		if (sp != ERR_PTR(-EEXIST))
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
@@ -709,16 +707,15 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 
 		validate_direct_spte(vcpu, it.sptep, direct_access);
 
-		drop_large_spte(vcpu, it.sptep);
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
+					  true, direct_access);
+		if (sp == ERR_PTR(-EEXIST))
+			continue;
 
-		if (!is_shadow_present_pte(*it.sptep)) {
-			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
-						  true, direct_access);
-			link_shadow_page(vcpu, it.sptep, sp);
-			if (fault->huge_page_disallowed &&
-			    fault->req_level >= it.level)
-				account_huge_nx_page(vcpu->kvm, sp);
-		}
+		link_shadow_page(vcpu, it.sptep, sp);
+		if (fault->huge_page_disallowed &&
+		    fault->req_level >= it.level)
+			account_huge_nx_page(vcpu->kvm, sp);
 	}
 
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
-- 
2.31.1


