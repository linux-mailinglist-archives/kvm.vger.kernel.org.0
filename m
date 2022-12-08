Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EB2647691
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLHTkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiLHTj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:39:56 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFB41AA3C
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:39 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3b4eb124be5so24655407b3.19
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IqmyM2QEYva7JW7axwbl4xIkL86pAwW/H4sjSNNkIgM=;
        b=dlUm8IzbDvKb7N133pMZbM/DFF2KBU+Uj9aLv9J4HYtcIkmIb26+E+NQc6WW5lGWbL
         gRjhF2Xtb1+eYvjvVNPz1fbza7FzGrlR1Lu4PkwObVflvo1HWtD/PdV/GtwH/OYCGqmW
         unzqYTbSQw2kEfHvH067uKfBCEte20dfejQENL3zjpmLPkBmJgJlntv4NgZXLQazrFdX
         xuOUsmX6ghWNWZUkpgBa0nNKdgiEWdVdSAmfBWBxgOuca3Crx0ITb6PP4ZfWYj0CDybH
         3DDCzi9SmVtrCH3Ln+bCV9cJJ5HGVNrG9C8r5e5Ny4xwAEq3sPHh7YTtyJKFJzf22O7k
         p2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IqmyM2QEYva7JW7axwbl4xIkL86pAwW/H4sjSNNkIgM=;
        b=q7fjCMNDAyoimk28qi+3sq4onx1Cxm04cylr50TBhP4jhOj2GoizGRRmfy8oAPKeO6
         DJqw+M9RlM0MParal8dsji5YCIcHqk9B5iAFFbjJF8vHUNzsxwLKT1iYexbwsLGck28o
         BYulYUs3sPN8AMvso+DSmhGZVRbd3QunEdiqZ/LpjI00GT/qaG5QkyUicz8qXfGm1WBt
         Hh7Xng1FrIdGVROf/WW/oNVVb1BYMH80MIDn0dZLhpoUUs0Ya3n7sJN+2SxzDd07epgT
         ZEKRYDbnoeT+joj7K5Pv2bqoEoUjS9FfLVPW33alKWlXJ12sOK9gPVXJH7VpvgEkT6ia
         VXqg==
X-Gm-Message-State: ANoB5pn2x9bYJL+UlYN9XfdiuIZqgo0XWpGVK6T0dzcFazhN18saBGrz
        GIcNYIqGizl6BOwfzpuSYzlmcF09DTINuw==
X-Google-Smtp-Source: AA0mqf7z1vyD3rdlMeoQGriM43dtIzP7Gztt83Sfud7zIuPh1YZpIi0HN2kxDCnBaSlw5o2SzSSWGj7vYJ4cig==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:7851:0:b0:3b6:e1ed:4185 with SMTP id
 t78-20020a817851000000b003b6e1ed4185mr57305022ywc.330.1670528376810; Thu, 08
 Dec 2022 11:39:36 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:38 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-19-dmatlack@google.com>
Subject: [RFC PATCH 18/37] KVM: x86/mmu: Add common API for creating TDP PTEs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce an API for construction of TDP PTEs.

- tdp_mmu_make_leaf_pte()
- tdp_mmu_make_nonleaf_pte()
- tdp_mmu_make_huge_page_split_pte()
- tdp_mmu_make_changed_pte_notifier_pte()

This will be used in a future commit to move the TDP MMU to common code,
while PTE construction will stay in the architecture-specific code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm/tdp_pgtable.h | 10 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c             | 18 +++++--------
 arch/x86/kvm/mmu/tdp_pgtable.c         | 36 ++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm/tdp_pgtable.h b/arch/x86/include/asm/kvm/tdp_pgtable.h
index c5c4e4cab24a..ff2691ced38b 100644
--- a/arch/x86/include/asm/kvm/tdp_pgtable.h
+++ b/arch/x86/include/asm/kvm/tdp_pgtable.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/kvm_types.h>
+#include <kvm/mmu_types.h>
 
 struct kvm_mmu_page *tdp_mmu_root(struct kvm_vcpu *vcpu);
 
@@ -57,4 +58,13 @@ kvm_pfn_t tdp_pte_to_pfn(u64 pte);
 
 void tdp_pte_check_leaf_invariants(u64 pte);
 
+struct tdp_iter;
+
+u64 tdp_mmu_make_leaf_pte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			  struct tdp_iter *iter, bool *wrprot);
+u64 tdp_mmu_make_nonleaf_pte(struct kvm_mmu_page *sp);
+u64 tdp_mmu_make_changed_pte_notifier_pte(struct tdp_iter *iter,
+					  struct kvm_gfn_range *range);
+u64 tdp_mmu_make_huge_page_split_pte(struct kvm *kvm, u64 huge_spte,
+				     struct kvm_mmu_page *sp, int index);
 #endif /* !__ASM_KVM_TDP_PGTABLE_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8155a9e79203..0172b0e44817 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1057,17 +1057,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 					  struct tdp_iter *iter)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(iter->sptep));
-	u64 new_spte;
 	int ret = RET_PF_FIXED;
 	bool wrprot = false;
+	u64 new_spte;
 
 	WARN_ON(sp->role.level != fault->goal_level);
-	if (unlikely(!fault->slot))
-		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+
+	new_spte = tdp_mmu_make_leaf_pte(vcpu, fault, iter, &wrprot);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1117,7 +1113,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 			   struct kvm_mmu_page *sp, bool shared)
 {
-	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled());
+	u64 spte = tdp_mmu_make_nonleaf_pte(sp);
 	int ret = 0;
 
 	if (shared) {
@@ -1312,9 +1308,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	tdp_mmu_set_spte(kvm, iter, 0);
 
 	if (!pte_write(range->pte)) {
-		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
-								  pte_pfn(range->pte));
-
+		new_spte = tdp_mmu_make_changed_pte_notifier_pte(iter, range);
 		tdp_mmu_set_spte(kvm, iter, new_spte);
 	}
 
@@ -1466,7 +1460,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < TDP_PTES_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte, sp->role, i);
+		sp->spt[i] = tdp_mmu_make_huge_page_split_pte(kvm, huge_spte, sp, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index 97cc900e8818..e036ba0c6bee 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -5,6 +5,7 @@
 
 #include "mmu.h"
 #include "spte.h"
+#include "tdp_iter.h"
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(REMOVED_TDP_PTE & SPTE_MMU_PRESENT_MASK));
@@ -75,3 +76,38 @@ void tdp_pte_check_leaf_invariants(u64 pte)
 	check_spte_writable_invariants(pte);
 }
 
+u64 tdp_mmu_make_leaf_pte(struct kvm_vcpu *vcpu,
+			  struct kvm_page_fault *fault,
+			  struct tdp_iter *iter,
+			  bool *wrprot)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(iter->sptep));
+	u64 new_spte;
+
+	if (unlikely(!fault->slot))
+		return make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
+
+	*wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
+			    fault->pfn, iter->old_spte, fault->prefetch, true,
+			    fault->map_writable, &new_spte);
+
+	return new_spte;
+}
+
+u64 tdp_mmu_make_nonleaf_pte(struct kvm_mmu_page *sp)
+{
+	return make_nonleaf_spte(sp->spt, !kvm_ad_enabled());
+}
+
+u64 tdp_mmu_make_changed_pte_notifier_pte(struct tdp_iter *iter,
+					  struct kvm_gfn_range *range)
+{
+	return kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
+						      pte_pfn(range->pte));
+}
+
+u64 tdp_mmu_make_huge_page_split_pte(struct kvm *kvm, u64 huge_spte,
+				     struct kvm_mmu_page *sp, int index)
+{
+	return make_huge_page_split_spte(kvm, huge_spte, sp->role, index);
+}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

