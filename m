Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3460F4EF93E
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350652AbiDAR6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350549AbiDAR56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:57:58 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A4D1834D4
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:08 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i4-20020a170902eb4400b001561d3be0f3so1798792pli.15
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HFmOXjdTm4bKuwpXyqPSjeWAmueQ2kp+gRfD4Io5xrA=;
        b=edC1kXvmiD1wHyEz0bAXG+Ro2vWFCm3Xn7InOKhIPfA34B9sPuHUUqYVs/SHdGxRrw
         jWRQHl6FTYIj9MAHwbfTfJfnOBAmUcnuyqglp1+wPvHjg9s6/WOLPPe09WZ8Eyh01DcM
         gvB64jDytmncJALI33os10qcutUKbgkFhWrCBMBqwDSgvw6GF5HbqCToSIPgWhm32NNM
         KA2znvla3jUqsM3RrasAMUXRR2tojM7hHQLJFQWV8yiDmAFUxh+FMrv/uRlk3Lt4UFLn
         ENw4Kf5Z/B8afJGDUB5jQiToxQiYbhTHRsK1j5+F3tIbZoSvKS2YRyOJs+0gSTue2Um3
         Jnzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HFmOXjdTm4bKuwpXyqPSjeWAmueQ2kp+gRfD4Io5xrA=;
        b=fcErUXg6plDcE5THiIJ8cRqLSnhDw+bhQhQZfLm5zp8ytgrmgJ7j65m3IACNZBgRYk
         /WbrVnqXpaViv8iYBWShmxzKeFteLxgonzIb6vo+KwiXNMOtSO17nVsoHCTWt9iKd0Qq
         qqrCe0nFWrOvGYgjTw3eVqaHxfr7MZcA59AnGYeYv95qQRyjiLGxMbwYK4y4mjtryxaJ
         kk8xhqIz8H6Mm7m9HKeLLERQRaOzqwgRL7Vgn2H/wRxaGdhcSkLAcrJRB77CBy4wjzD6
         3rZ0B3XrNj9/QfkIKDfHyGzuiQiOK9jlXyvPOxfVinsausUU1Zuuc/YB8yZI80bL8Z1y
         ILQQ==
X-Gm-Message-State: AOAM530sMYXR2Wt364IsYZxU0zrn3kHAxU7q9Vt5AleLjw5/N/ApSGdQ
        vkYl36Ko0jY8pb5mKjHXyu4dLqfkiDua6Q==
X-Google-Smtp-Source: ABdhPJwnqJBzfLm+Ds6V5OWREXOmRK/sUx5t1bSmdng1ilg+Qj+FOqvYH+aW09+0A8FDoL/oz9ikffec7I0g1g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP
 id m11-20020a17090a858b00b001c65bc8781amr588186pjn.0.1648835767641; Fri, 01
 Apr 2022 10:56:07 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:35 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 04/23] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c         | 124 +++++++++++++++++++++++----------
 arch/x86/kvm/mmu/paging_tmpl.h |   5 +-
 arch/x86/kvm/mmu/spte.c        |   5 +-
 3 files changed, 94 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8253d68cc30b..8fdddd25029d 100644
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
@@ -2053,60 +2062,103 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
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
 
+	sp = NULL;
+
+out:
+	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
+		kvm->stat.max_mmu_page_hash_collisions = collisions;
+
+	return sp;
+}
+
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
+
+	if (sp && sp->unsync) {
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
+		if (kvm_sync_page(vcpu, sp, &invalid_list)) {
 			WARN_ON(!list_empty(&invalid_list));
 			kvm_flush_remote_tlbs(vcpu->kvm);
+		} else {
+			sp = NULL;
 		}
+	}
 
-		__clear_sp_write_flooding_count(sp);
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+	return sp;
+}
 
-trace_get_page:
-		trace_kvm_mmu_get_page(sp, false);
-		goto out;
-	}
+static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp;
+	struct hlist_head *sp_list;
 
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
+	if (!sp) {
+		created = true;
+		sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
+	}
+
+	trace_kvm_mmu_get_page(sp, created);
 	return sp;
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 729394de2658..db63b5377465 100644
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
2.35.1.1094.g7c7d902a7c-goog

