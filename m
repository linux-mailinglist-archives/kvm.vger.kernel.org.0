Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C6C4D5696
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345136AbiCKA0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiCKA0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:26:40 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43C91A1C71
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:38 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id r11-20020a63440b000000b0038068f34b0cso3813094pga.0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=preyZmoxeWV7bpSqcaT1D2ICPD7/5D40rW8RXyddS98=;
        b=LgWaICfxIBaJDsFBkUTdBOob1Y2k3/FFvQsolbqLhuk8ZrTeTkJdlWwjlTc00oGLEe
         LBi95aRVL4ltQZa1ZoBqImyXhIE6KCt5BKv4apSd5/TOgPmKoi9AKXn5JzAOW8qfkaFV
         lZPfstcYqk94YJDubOqRH4/FF9knojxzys4+ZWckaWnU9yCfGXEnP/dJMk0PlsKerJEz
         RFtEO4H2uxJnJcfrKsAd8SgRK/Z+vZHqCgqBMoQjTSjUQPefL7dqPZMkO0BphwLCxzPg
         WXAwwCmQdYAe2L1ybmPKCSs84V9vIKdpb9I5nboekQUX1+Mq9bO8ySuBjnvDZm/f7Gzo
         TQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=preyZmoxeWV7bpSqcaT1D2ICPD7/5D40rW8RXyddS98=;
        b=PhDOXwUgRE0cFmJXcRQew+i7o+PtYg9JMG3n/YeMbYePTy42kykxHUyQSOwPUVNsVV
         kl1AQAlfmFey2SUt+PjPh8iWTMT0B7JpbgNo3HHEPEGQe6hPIiWsPhd6OGBBcBkdmSGP
         JfIHHFR5PDfMtLG/11+St7bRNQRCpSaTLD1C4zQYFLbuzTTnDtIkSxu0d/ifkC03Y3G6
         3lhVor+WJjt7meW+QZ5wyW09Bm/2VTSvDtpG/GdwdWa+oNl/cZ9/e+V5kexYHZjLHCRc
         EOQdumWKsi9oz4kGJdsmskdpQvvthsx5jtgzK/nZOI9EquS4UdQqMyuIpWb3Vq/cVKTY
         20lw==
X-Gm-Message-State: AOAM532jrQuwLgYJI6xDEWaplBc5CDkvwheX99jChp+cc/ritEMjPlDU
        oyrUCbtQxZTH2krp4+bd/jDKvV5ELHVR/Q==
X-Google-Smtp-Source: ABdhPJw4zPv1Jtev5tqhHtyUpqsXBloi5wAf9YuGxFv3zUHJ0lLUE9syCfw79D+xC+vv/19YPx/1nSCKvLkKDQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1e10:b0:1bf:6c78:54a9 with SMTP
 id pg16-20020a17090b1e1000b001bf6c7854a9mr321576pjb.1.1646958337790; Thu, 10
 Mar 2022 16:25:37 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:06 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 04/26] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Decompose kvm_mmu_get_page() into separate helper functions to increase
readability and prepare for allocating shadow pages without a vcpu
pointer.

Specifically, pull the guts of kvm_mmu_get_page() into 3 helper
functions:

__kvm_mmu_find_shadow_page() -
  Walks the page hash checking for any existing mmu pages that match the
  given gfn and role. Does not attempt to synchronize the page if it is
  unsync.

kvm_mmu_find_shadow_page() -
  Wraps __kvm_mmu_find_shadow_page() and handles syncing if necessary.

kvm_mmu_new_shadow_page()
  Allocates and initializes an entirely new kvm_mmu_page. This currently
  requries a vcpu pointer for allocation and looking up the memslot but
  that will be removed in a future commit.

  Note, kvm_mmu_new_shadow_page() is temporary and will be removed in a
  subsequent commit. The name uses "new" rather than the more typical
  "alloc" to avoid clashing with the existing kvm_mmu_alloc_page().

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 132 ++++++++++++++++++++++++---------
 arch/x86/kvm/mmu/paging_tmpl.h |   5 +-
 arch/x86/kvm/mmu/spte.c        |   5 +-
 3 files changed, 101 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 23c2004c6435..80dbfe07c87b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2027,16 +2027,25 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+/*
+ * Searches for an existing SP for the given gfn and role. Makes no attempt to
+ * sync the SP if it is marked unsync.
+ *
+ * If creating an upper-level page table, zaps unsynced pages for the same
+ * gfn and adds them to the invalid_list. It's the callers responsibility
+ * to call kvm_mmu_commit_zap_page() on invalid_list.
+ */
+static struct kvm_mmu_page *__kvm_mmu_find_shadow_page(struct kvm *kvm,
+						       gfn_t gfn,
+						       union kvm_mmu_page_role role,
+						       struct list_head *invalid_list)
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
@@ -2053,60 +2062,109 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
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
+static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
+						     gfn_t gfn,
+						     union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp;
+	LIST_HEAD(invalid_list);
+
+	sp = __kvm_mmu_find_shadow_page(vcpu->kvm, gfn, role, &invalid_list);
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
+static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
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
+	sp = kvm_mmu_find_shadow_page(vcpu, gfn, role);
+	if (sp)
+		goto out;
+
+	created = true;
+	sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
+
+out:
+	trace_kvm_mmu_get_page(sp, created);
 	return sp;
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c3909a07e938..55cac59b9c9b 100644
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
index 4739b53c9734..d10189d9c877 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -150,8 +150,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
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
2.35.1.723.g4982287a31-goog

