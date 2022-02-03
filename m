Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9474A7D17
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348656AbiBCBBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348652AbiBCBBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:06 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9C3C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:06 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u24-20020a656718000000b0035e911d79edso585872pgf.1
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=itZVBKuazSWkWwWVxGCsy5muThrtWmA2MD1DMqG3pH4=;
        b=gIEaIO/XDx4xg0FArGsobbA6CP+YVku+jaa33TdXE8o2N+q2nJf99eu7RfqZathebQ
         Q5Tk7urNCjfVkrBmltUFQ3/7e36BJPNpdhKmZt6LGhvCmwNXNNVZWst94jtrhszY1+ap
         ckYfUwAVkq7TWZm4+tpsb3S0u9qQ/o3nLVH8Iwo07JHxHF5Kw9Dv/8pPRitWBsl3mKKd
         3TPhmz3NybMZKwvTPQ5zNJMzgLl0fgRzfGznmfPwxzXjXKPZ5W5I2gKRepmUtSgTJ/0M
         XWUPhhL9CKVLDIYjyV7M9PzWN/5r7lDll+HbHkrnUAzYX9e5ynY58H58jtSKO7ij4N0B
         bINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=itZVBKuazSWkWwWVxGCsy5muThrtWmA2MD1DMqG3pH4=;
        b=orf4AOFhg4lcdyxxl30XhUFY1ce1VOetpdgN0F5FXBU+582V3eo4WHBIL45eKeOXGh
         GNmKf9PisHnwOBGFJsgaLUg/po4weWj5RuH95Q2qc+5jQ1zReYXbVBY4Oa3q3yD1W706
         XehszvcnYac4etTvpGC/9segrEARP3dkCOpH5AD4gh9HfJDbdlpS5UF83VZn2Fp/QzLf
         HOO+VDfU6H/esYAc6sDTiLy4S/m8PKSmaSNoRtH4xRBwv2+6srhTvSzwXRXNVcMivcWe
         GdbNHyf8IXQpcrfxr981iDzcMOZcmb4YuuVeYFbi9T0k20GsAXeQvDND566/PDuHFeBx
         KMBQ==
X-Gm-Message-State: AOAM5302O33Ir9+37tR95SS4GEcqGhqetRhuyfdpqNubF6F/irx3y/Bh
        7mv/E5VP9OWBBUS6ZDgrtkl/eBC8ba71lw==
X-Google-Smtp-Source: ABdhPJwIxLlfD9+H/R6rP0BwsYpIWzf6azN55ADZxPwWwM4cBaWhZT7yM4mJPrVvlDPXV8uZXQzEveN8MdFwhw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:181f:: with SMTP id
 y31mr31955129pfa.35.1643850065842; Wed, 02 Feb 2022 17:01:05 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:31 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 03/23] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Decompose kvm_mmu_get_page() into separate helper functions to increase
readability and prepare for allocating shadow pages without a vcpu
pointer.

Specifically, pull the guts of kvm_mmu_get_page() into 3 helper
functions:

kvm_mmu_get_existing_sp_mabye_unsync() -
  Walks the page hash checking for any existing mmu pages that match the
  given gfn and role. Does not attempt to synchronize the page if it is
  unsync.

kvm_mmu_get_existing_sp() -
  Gets an existing page from the page hash if it exists and guarantees
  the page, if one is returned, is synced.  Implemented as a thin wrapper
  around kvm_mmu_get_existing_page_mabye_unsync. Requres access to a vcpu
  pointer in order to sync the page.

kvm_mmu_create_sp()
  Allocates an entirely new kvm_mmu_page. This currently requries a
  vcpu pointer for allocation and looking up the memslot but that will
  be removed in a future commit.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 132 ++++++++++++++++++++++++---------
 arch/x86/kvm/mmu/paging_tmpl.h |   5 +-
 arch/x86/kvm/mmu/spte.c        |   5 +-
 3 files changed, 101 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fc9a4d9c0ddd..24b3cf53aa12 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2045,16 +2045,25 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+/*
+ * Looks up an existing SP for the given gfn and role. Makes no attempt to
+ * sync the SP if it is marked unsync.
+ *
+ * If creating an upper-level page table, zaps unsynced pages for the same
+ * gfn and adds them to the invalid_list. It's the callers responsibility
+ * to call kvm_mmu_commit_zap_page() on invalid_list.
+ */
+static struct kvm_mmu_page *kvm_mmu_get_existing_sp_maybe_unsync(struct kvm *kvm,
+								 gfn_t gfn,
+								 union kvm_mmu_page_role role,
+								 struct list_head *invalid_list)
 {
 	struct hlist_head *sp_list;
 	struct kvm_mmu_page *sp;
 	int collisions = 0;
-	LIST_HEAD(invalid_list);
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
-	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
+	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	for_each_valid_sp(kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
 			collisions++;
 			continue;
@@ -2071,60 +2080,109 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 			 * upper-level page will be write-protected.
 			 */
 			if (role.level > PG_LEVEL_4K && sp->unsync)
-				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
-							 &invalid_list);
+				kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+
 			continue;
 		}
 
-		/* unsync and write-flooding only apply to indirect SPs. */
-		if (sp->role.direct)
-			goto trace_get_page;
+		/* Write-flooding is only tracked for indirect SPs. */
+		if (!sp->role.direct)
+			__clear_sp_write_flooding_count(sp);
 
-		if (sp->unsync) {
-			/*
-			 * The page is good, but is stale.  kvm_sync_page does
-			 * get the latest guest state, but (unlike mmu_unsync_children)
-			 * it doesn't write-protect the page or mark it synchronized!
-			 * This way the validity of the mapping is ensured, but the
-			 * overhead of write protection is not incurred until the
-			 * guest invalidates the TLB mapping.  This allows multiple
-			 * SPs for a single gfn to be unsync.
-			 *
-			 * If the sync fails, the page is zapped.  If so, break
-			 * in order to rebuild it.
-			 */
-			if (!kvm_sync_page(vcpu, sp, &invalid_list))
-				break;
+		goto out;
+	}
 
-			WARN_ON(!list_empty(&invalid_list));
-			kvm_flush_remote_tlbs(vcpu->kvm);
-		}
+	sp = NULL;
 
-		__clear_sp_write_flooding_count(sp);
+out:
+	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
+		kvm->stat.max_mmu_page_hash_collisions = collisions;
+
+	return sp;
+}
 
-trace_get_page:
-		trace_kvm_mmu_get_page(sp, false);
+/*
+ * Looks up an existing SP for the given gfn and role if one exists. The
+ * return SP is guaranteed to be synced.
+ */
+static struct kvm_mmu_page *kvm_mmu_get_existing_sp(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp;
+	LIST_HEAD(invalid_list);
+
+	sp = kvm_mmu_get_existing_sp_maybe_unsync(vcpu->kvm, gfn, role, &invalid_list);
+	if (!sp)
 		goto out;
+
+	if (sp->unsync) {
+		/*
+		 * The page is good, but is stale.  kvm_sync_page does
+		 * get the latest guest state, but (unlike mmu_unsync_children)
+		 * it doesn't write-protect the page or mark it synchronized!
+		 * This way the validity of the mapping is ensured, but the
+		 * overhead of write protection is not incurred until the
+		 * guest invalidates the TLB mapping.  This allows multiple
+		 * SPs for a single gfn to be unsync.
+		 *
+		 * If the sync fails, the page is zapped and added to the
+		 * invalid_list.
+		 */
+		if (!kvm_sync_page(vcpu, sp, &invalid_list)) {
+			sp = NULL;
+			goto out;
+		}
+
+		WARN_ON(!list_empty(&invalid_list));
+		kvm_flush_remote_tlbs(vcpu->kvm);
 	}
 
+out:
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+	return sp;
+}
+
+static struct kvm_mmu_page *kvm_mmu_create_sp(struct kvm_vcpu *vcpu,
+					      gfn_t gfn,
+					      union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp;
+	struct hlist_head *sp_list;
+
 	++vcpu->kvm->stat.mmu_cache_miss;
 
 	sp = kvm_mmu_alloc_page(vcpu, role.direct);
-
 	sp->gfn = gfn;
 	sp->role = role;
+
+	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	hlist_add_head(&sp->hash_link, sp_list);
+
 	if (!role.direct) {
 		account_shadowed(vcpu->kvm, sp);
 		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 	}
-	trace_kvm_mmu_get_page(sp, true);
-out:
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 
-	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
-		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
+	return sp;
+}
+
+static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					     union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp;
+	bool created = false;
+
+	sp = kvm_mmu_get_existing_sp(vcpu, gfn, role);
+	if (sp)
+		goto out;
+
+	created = true;
+	sp = kvm_mmu_create_sp(vcpu, gfn, role);
+
+out:
+	trace_kvm_mmu_get_page(sp, created);
 	return sp;
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f93d4423a067..c533c191925e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -692,8 +692,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			 * the gpte is changed from non-present to present.
 			 * Otherwise, the guest may use the wrong mapping.
 			 *
-			 * For PG_LEVEL_4K, kvm_mmu_get_page() has already
-			 * synchronized it transiently via kvm_sync_page().
+			 * For PG_LEVEL_4K, kvm_mmu_get_existing_sp() has
+			 * already synchronized it transiently via
+			 * kvm_sync_page().
 			 *
 			 * For higher level pagetable, we synchronize it via
 			 * the slower mmu_sync_children().  If it needs to
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 8b5309faf5b9..20cf9e0d45dd 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -149,8 +149,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		/*
 		 * Optimization: for pte sync, if spte was writable the hash
 		 * lookup is unnecessary (and expensive). Write protection
-		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
-		 * Same reasoning can be applied to dirty page accounting.
+		 * is responsibility of kvm_mmu_create_sp() and
+		 * kvm_mmu_sync_roots(). Same reasoning can be applied to dirty
+		 * page accounting.
 		 */
 		if (is_writable_pte(old_spte))
 			goto out;
-- 
2.35.0.rc2.247.g8bbb082509-goog

