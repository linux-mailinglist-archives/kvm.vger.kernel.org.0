Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75D3279349
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgIYVXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbgIYVXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:35 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF503C0613D8
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:30 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id y2so2648445qvs.14
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=pNPbyzdy4uZV3DP217Bt0WHUXD3oX1/wytImNmZHn8U=;
        b=aRYjgaixoPJBp/KStmOjkU+cTijMIae2uSaZvbtEcGrrJXOnqFY8LtgjbIYmvcm1GI
         a2lak5FEqo2KPG/1mb+F0p0QHduPz3PSm9tiGg9v8rs4I2vGoZC3TpXzgFk0LdpKbtQC
         sonw79QOkuGwHUC9oxeCXTWqlGT50Uwys8Pt5AZqGT0iH1wxF90SOOjXAre2NPKfivqo
         l9R/zEOJhUb/qibl5hidseTqQvjaIKQKiEXLBNj3E9qNjXngyvmLbomZyB1nQz9VCnhn
         I4LNeRWxDDxgIZWvY6udyvSgd5QOrh9g6bL1N2cd81jH4oXN/Io1S7DO+iV9IvPe4Qni
         2ylQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pNPbyzdy4uZV3DP217Bt0WHUXD3oX1/wytImNmZHn8U=;
        b=gjYl5g3uWzybwpfQHJJKAbNIR/22WWwEicsYSf5lvoSKimEaIQ55Q6KHEU1iB+OoAB
         19pufNhk17zrLm8DKGIELgFbTJC5U6OaFZMgtTzsYFRsr4pjMzvXsnLeSXFpHum+nAOa
         lACLpyB6el7sTNKosZ9tXldjbu3DclPVrYzGmIYIw/bDzQYy9yDXe8o9TYPiQ9TPs4ur
         Tgh4hwq8DDFutn+mjzSY3pj8T9QrK7arLee0mnKAPPr2w6uo7pqFptdorPf97fuZKDo6
         oE2iSIqi2A+XX/ClCQkzNOegac/xXrjDOmc5IxLOlaLCZXut/KKRezEfMjc8VuMfTPCA
         59Yw==
X-Gm-Message-State: AOAM533Gfbi12JIoyHtGvHMBqZABSPqoUjBo/7ZNY8I+10mgj8DQBnKb
        TaQYz1w+QRizKXLFtDHr4+K2SOAqAsoE
X-Google-Smtp-Source: ABdhPJzVOIKkGH44/sMKpQKYViiKvkjAodLvduGiZr6OkdYZn9iwyH8auNMyEptbtjPKMoxXrXzgoxfnarxT
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a05:6214:292:: with SMTP id
 l18mr639868qvv.5.1601069010017; Fri, 25 Sep 2020 14:23:30 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:52 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-13-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 12/22] kvm: mmu: Allocate struct kvm_mmu_pages for all pages
 in TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Attach struct kvm_mmu_pages to every page in the TDP MMU to track
metadata, facilitate NX reclaim, and enable inproved parallelism of MMU
operations in future patches.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 13 ++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9ce6b35ecb33a..a76bcb51d43d8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -972,7 +972,11 @@ struct kvm_arch {
 	 * operations.
 	 */
 	bool tdp_mmu_enabled;
+
+	/* List of struct tdp_mmu_pages being used as roots */
 	struct list_head tdp_mmu_roots;
+	/* List of struct tdp_mmu_pages not being used as roots */
+	struct list_head tdp_mmu_pages;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a3bcee6bf30e8..557e780bdf9f9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -30,6 +30,7 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
+	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 }
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
@@ -244,6 +245,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
 	u64 *pt;
+	struct kvm_mmu_page *sp;
 	u64 old_child_spte;
 	int i;
 
@@ -309,6 +311,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
 		pt = spte_to_child_pt(old_spte, level);
+		sp = sptep_to_sp(pt);
+
+		list_del(&sp->link);
 
 		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 			old_child_spte = *(pt + i);
@@ -322,6 +327,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 						   KVM_PAGES_PER_HPAGE(level));
 
 		free_page((unsigned long)pt);
+		kmem_cache_free(mmu_page_header_cache, sp);
 	}
 }
 
@@ -474,8 +480,7 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
 			   bool prefault, bool account_disallowed_nx_lpage)
 {
 	struct tdp_iter iter;
-	struct kvm_mmu_memory_cache *pf_pt_cache =
-			&vcpu->arch.mmu_shadow_page_cache;
+	struct kvm_mmu_page *sp;
 	u64 *child_pt;
 	u64 new_spte;
 	int ret;
@@ -520,7 +525,9 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
-			child_pt = kvm_mmu_memory_cache_alloc(pf_pt_cache);
+			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
+			list_add(&sp->link, &vcpu->kvm->arch.tdp_mmu_pages);
+			child_pt = sp->spt;
 			clear_page(child_pt);
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
-- 
2.28.0.709.gb0816b6eb0-goog

