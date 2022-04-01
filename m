Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5024EE852
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 08:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245452AbiDAGie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 02:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245442AbiDAGid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 02:38:33 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DA918C0FC
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d7-20020a17090ad98700b001c6834c71ffso1033426pjv.1
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ENE9zx/RQL0mygOY8ggwW7MkJ6Wz+nE6nyB1FT/1jsI=;
        b=g/PXhHA9mEdDh3slFWre1e8TY+VvyivH7kjt/GwKq6ffkDtuX8VopYGCymUtyb6RhB
         ewGF1UtAPU9Sa4dDc2iZ/Vy4PCNdUU1oab2oehFVqdpd50H5GyiHav8G1r3hK+dGQCEd
         2M03mMQ3XT30DZuUkxXGbS8wIldDzpmGyJbXpYUzJ+B0h0Vq5/FZqP5GXso0g7lZAPDa
         Z9wniQhVdLTYYSQpK2p/N6gEsY02XpfE5LgltNjUxFVZwNvPXeoTjlGQpvck6zw5v86S
         GSJgvXA2Y+rWm0Zj/zC6O02GcPTDMoUv5jdOBqHc2jB9el+gIeA2f0LV9z9IhvWcNZ+u
         Z4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ENE9zx/RQL0mygOY8ggwW7MkJ6Wz+nE6nyB1FT/1jsI=;
        b=hIuVhreTE7rr6smS0YxhQ0Q0MLlv/lYwctVmsy3xR3+R6wJjgDnVS8CFqjP8zANgQ3
         EQIVu25X558U7VAIhZ+yXYMuTXGiEm1fKIn5jnwKLuoeB+jHi0xyELP/CYghf11tgXkL
         XXK5buMcsZwzGLn/jJHZf8sW+K2PldXXG/fEl9neBo+qS6JbP26JVnBjhWSJTvF1pTT1
         pGdLIduW0YP6M+FSL2lhoXxug41m2IGJ79ye6p//7aA952YDsJ7l7pPwbXg96LGUabir
         x0DAe4nOTd18wBICq0m0Cj8Z7hfqdkGu50iYjEmdpButJSKtQcJmi8MvIjnEk2cPy9mS
         k5zQ==
X-Gm-Message-State: AOAM532DAAnmReP9K0Kvv9NX4/CLZsdYRnr0Its1HrCgCTfUSoDY5fiz
        oPwo26P0ZRYgMikJdttLb9GJBwW20ZFw
X-Google-Smtp-Source: ABdhPJzv9YI6PtocdAi7hN0IW4mYt7gmW+cmzFUcODAijax0zAODiJkHDyITC84noPld2tbNypH2tj2bhqUm
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a63:f54b:0:b0:384:64d1:fa45 with SMTP id
 e11-20020a63f54b000000b0038464d1fa45mr13816423pgk.95.1648795003619; Thu, 31
 Mar 2022 23:36:43 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri,  1 Apr 2022 06:36:31 +0000
In-Reply-To: <20220401063636.2414200-1-mizhang@google.com>
Message-Id: <20220401063636.2414200-2-mizhang@google.com>
Mime-Version: 1.0
References: <20220401063636.2414200-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 1/6] KVM: x86/mmu: Set lpage_disallowed in TDP MMU before
 setting SPTE
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
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

From: Sean Christopherson <seanjc@google.com>

Set lpage_disallowed in TDP MMU shadow pages before making the SP visible
to other readers, i.e. before setting its SPTE.  This will allow KVM to
query lpage_disallowed when determining if a shadow page can be replaced
by a NX huge page without violating the rules of the mitigation.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++----
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 20 ++++++++++++--------
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1361eb4599b4..5cb845fae56e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -812,14 +812,20 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 }
 
-void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void __account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	if (sp->lpage_disallowed)
-		return;
-
 	++kvm->stat.nx_lpage_splits;
 	list_add_tail(&sp->lpage_disallowed_link,
 		      &kvm->arch.lpage_disallowed_mmu_pages);
+}
+
+static void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	if (sp->lpage_disallowed)
+		return;
+
+	__account_huge_nx_page(kvm, sp);
+
 	sp->lpage_disallowed = true;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1bff453f7cbe..4a0087efa1e3 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -168,7 +168,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
-void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void __account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b3b6426725d4..f05423545e6d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1122,16 +1122,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
  * @kvm: kvm instance
  * @iter: a tdp_iter instance currently on the SPTE that should be set
  * @sp: The new TDP page table to install.
- * @account_nx: True if this page table is being installed to split a
- *              non-executable huge page.
  * @shared: This operation is running under the MMU lock in read mode.
  *
  * Returns: 0 if the new page table was installed. Non-0 if the page table
  *          could not be installed (e.g. the atomic compare-exchange failed).
  */
 static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
-			   struct kvm_mmu_page *sp, bool account_nx,
-			   bool shared)
+			   struct kvm_mmu_page *sp, bool shared)
 {
 	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
 	int ret = 0;
@@ -1146,8 +1143,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	if (account_nx)
-		account_huge_nx_page(kvm, sp);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 	return 0;
@@ -1160,6 +1155,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret;
@@ -1210,10 +1206,18 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			sp = tdp_mmu_alloc_sp(vcpu);
 			tdp_mmu_init_child_sp(sp, &iter);
 
-			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
+			sp->lpage_disallowed = account_nx;
+
+			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
 				tdp_mmu_free_sp(sp);
 				break;
 			}
+
+			if (account_nx) {
+				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+				__account_huge_nx_page(kvm, sp);
+				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+			}
 		}
 	}
 
@@ -1501,7 +1505,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * correctness standpoint since the translation will be the same either
 	 * way.
 	 */
-	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
+	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
 	if (ret)
 		goto out;
 
-- 
2.35.1.1094.g7c7d902a7c-goog

