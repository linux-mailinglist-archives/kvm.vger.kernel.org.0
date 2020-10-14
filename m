Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FA628E65A
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbgJNS10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388669AbgJNS1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:25 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9ACC0613E5
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:24 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id r4so294563qta.9
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=XE3TlFzPB074DCulw3ZKAATgb2BIibEai56f3kal+II=;
        b=oWJ8N4+og/FhbMEIhzH50l+ThvY+HucabBowIojdpkR3aSqw6s5d2lAhtkzAunqP25
         NtUwx36AprsPytZcLL7fhxigSF/lBPNTAhKeQDX43LzJ4MjLv8iU1V3XYnuKfY8nSL91
         DXKs078mOYbgurWZEvzuf0WMM2Vj5Hoe43xnVjW6sprBIwrRzUmudwoHwRJMZ1mcmgo4
         ya7RApj4mZD6uSQxyb+sIz2gp78C5mXuhKUnnPnvSGWdo8F2kxwX1aA+Wgr7YYQKyZym
         BOtxB9AhLsBC4V0AhyJM0Tzt/augj4K1yLQgYo1smetdiDqbnH/iBh8cBk/tivBycfLs
         cMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XE3TlFzPB074DCulw3ZKAATgb2BIibEai56f3kal+II=;
        b=MTfZboGfMNMzoArKAXN9bt3l0IbPZ/2ErVeJ0h9ih1u3IZNYUH785ugwdVpEsDsJh5
         CH+xP805pk3nb873m07Ou8hN0QFBpeQELvnFxr4trAk9E+TwJHZvYgu3SQKP4rkdwsr5
         ywFvekwXT3JsZS68f4QKr5fJViSX/PgpeLqC6Qpz+Z4uu0i7lkvE2uJd+wYVvCYlPzpP
         XmCgmUgUUZ4QsVZ4PUCq+3idjhO7tNcZwCV7UHkaHicTc7khBdVQy+nO1zfNlZDq+zN8
         7eHRDkSeUVxjdcd9cVOmHCHG1OPef3LapWT6WyFVeDTtNZ6dIRwQbkNs62Dj0SY0NSRN
         mmyA==
X-Gm-Message-State: AOAM53385XNshISEVyblHAlDjew5TWRTMOGCjbi6y55llILUTie9vBFy
        krwQtfumN4CNrB6aeHVEc8e3p+UqC0Qu
X-Google-Smtp-Source: ABdhPJwNRTYpSplJuslVIsVTEt8/hpXbKi+Gqbly0DAYKHpB7qLSlzVjx3Ww+s/kJWlFlupZGsL+FFrGM8xC
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a0c:bb83:: with SMTP id
 i3mr824901qvg.15.1602700043714; Wed, 14 Oct 2020 11:27:23 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:51 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-12-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 11/20] kvm: x86/mmu: Allocate struct kvm_mmu_pages for all
 pages in TDP MMU
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
index e0ec1dd271a32..2568dcd134156 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -989,7 +989,11 @@ struct kvm_arch {
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
index f92c12c4ce31a..78d41a1949651 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -34,6 +34,7 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
+	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 }
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
@@ -188,6 +189,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
 	u64 *pt;
+	struct kvm_mmu_page *sp;
 	u64 old_child_spte;
 	int i;
 
@@ -253,6 +255,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
 		pt = spte_to_child_pt(old_spte, level);
+		sp = sptep_to_sp(pt);
+
+		list_del(&sp->link);
 
 		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 			old_child_spte = *(pt + i);
@@ -266,6 +271,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 						   KVM_PAGES_PER_HPAGE(level));
 
 		free_page((unsigned long)pt);
+		kmem_cache_free(mmu_page_header_cache, sp);
 	}
 }
 
@@ -434,8 +440,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
-	struct kvm_mmu_memory_cache *pf_pt_cache =
-			&vcpu->arch.mmu_shadow_page_cache;
+	struct kvm_mmu_page *sp;
 	u64 *child_pt;
 	u64 new_spte;
 	int ret;
@@ -479,7 +484,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
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
2.28.0.1011.ga647a8990f-goog

