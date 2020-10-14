Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D2428E653
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388661AbgJNS17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389404AbgJNS1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:47 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3F9C0613E4
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id r16so58536pls.19
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=OcS1EoJ2FiK+HayZIKclc/lLgHYhtZFFT/BEnIUqPtw=;
        b=gqrdTZZbZaq/iyuZCewS1i3wq0fFAH+YCBe+xm4GuJhyWNRLH7mIUO6ZXSAI3wTQtH
         X9OtBcm0pQBwuily72zEf8uLqSwvwqgKsXjevutNMjEumteq7vdF9MnbTfywihzv2XcB
         R/NgpsvXSqmdKPF5bemwwijWm7R4ivQHNjhhQt8SPsuQ0ijC81bCgd3J7B6ZubdKKl76
         asFOECVh4dcXsfeOIk/SzZcvzts8AKnn84gTa5RM7CNxw6NO16B2wIBgNbb4F8FZHl47
         mZLaTP6dzehwLPTl+JNX/GJ9i81oBJKyn+JHhyr+KSuFxwpX2se0grNjyYSGOoaMOd3q
         lavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OcS1EoJ2FiK+HayZIKclc/lLgHYhtZFFT/BEnIUqPtw=;
        b=tWagGiXLTtEeB1y0skbN0eiluB12PZ2/LHHHA2i4+RI7PGBKjqcu5zlMQu5CfqTzr8
         SXxL1FliY+ztVZRA6nD6N+sK1f8oFUAtt+mVLZBwR0ECH9h1zZyrpcTksARrrwnzmk8T
         0yuSaY2wGYfGfnwUBN84RC/4BDxLpuUAcmh/kMWGfBgMAZj1gYTe0kZwp3Psk/GVosWz
         KPNGHEoIZst3LEdff8uYLOOEBg47yuLQpMe9nnc0/xemBjR088wd0NDybEhU3C7xNNiV
         a8q9GcY35bSiT4MEuiFvxPYIq8d4EEvB93UtVN3IkdQ7iBWT7FDLdcEttAfcGItMmnnb
         tkxQ==
X-Gm-Message-State: AOAM533VuTx5QKiSEzZLGAR7omu1lX4N+t0uEgtsMHsnxTHwBpz9Zm0q
        SkZPh5OcD1T1P6YiFxvg0WI4/8Nqovjg
X-Google-Smtp-Source: ABdhPJwbIUToJOUkI5LeHYo/HRh0q1F3xz2yZtpM9T4o/hxwf2ISyxtWJvFoOEvLo+A8KLAUpaxEZpK8gdgo
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90b:1496:: with SMTP id
 js22mr522321pjb.20.1602700060562; Wed, 14 Oct 2020 11:27:40 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:27:00 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-21-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 20/20] kvm: x86/mmu: NX largepage recovery for TDP MMU
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

When KVM maps a largepage backed region at a lower level in order to
make it executable (i.e. NX large page shattering), it reduces the TLB
performance of that region. In order to avoid making this degradation
permanent, KVM must periodically reclaim shattered NX largepages by
zapping them and allowing them to be rebuilt in the page fault handler.

With this patch, the TDP MMU does not respect KVM's rate limiting on
reclaim. It traverses the entire TDP structure every time. This will be
addressed in a future patch.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 13 +++++++++----
 arch/x86/kvm/mmu/mmu_internal.h |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3935c10278736..5c8a35e4c872b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1030,7 +1030,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 }
 
-static void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	if (sp->lpage_disallowed)
 		return;
@@ -1058,7 +1058,7 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
-static void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	--kvm->stat.nx_lpage_splits;
 	sp->lpage_disallowed = false;
@@ -6362,8 +6362,13 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      struct kvm_mmu_page,
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
-		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-		WARN_ON_ONCE(sp->lpage_disallowed);
+		if (sp->tdp_mmu_page)
+			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
+				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
+		else {
+			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+			WARN_ON_ONCE(sp->lpage_disallowed);
+		}
 
 		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
 			kvm_mmu_commit_zap_page(kvm, &invalid_list);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index a7230532bb845..88899a2666d86 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -299,4 +299,7 @@ static inline u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte,
 }
 
 
+void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b1515b89606e1..2949759c6aa84 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -289,6 +289,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 		list_del(&sp->link);
 
+		if (sp->lpage_disallowed)
+			unaccount_huge_nx_page(kvm, sp);
+
 		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 			old_child_spte = *(pt + i);
 			*(pt + i) = 0;
@@ -567,6 +570,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
+			if (huge_page_disallowed && req_level >= iter.level)
+				account_huge_nx_page(vcpu->kvm, sp);
+
 			tdp_mmu_set_spte(vcpu->kvm, &iter, new_spte);
 		}
 	}
-- 
2.28.0.1011.ga647a8990f-goog

