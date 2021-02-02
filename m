Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA8230CB3A
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239243AbhBBTR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239294AbhBBTAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:00:16 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B4EC061222
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:04 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id e5so18185595qkn.2
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=D/IHf2NWbkBu2/dnLT5S1455F/NSQH7Bez/0/zsY4ns=;
        b=kqy9t70KqYBTQoFXYLtydJxlgpe/KOQmV+GFvXqKC4syTSP2zegsnljJty/ZSZjbKF
         hC6HDrYaOBKMYYn5y9j7TW8QcOcs3Y+RX1i0b57aS1i6P8ZDGKKdWfrAQzyZq4KGb0Uj
         cX3hxHQPifN7RwXkVCfdnUSVGZH4fu+r8ukip92w6KgZfwHNdzxyEIZzxU47TptN7+If
         JKYieZhqF3ZRRxDuZjTMIoAoGiMKMl2WqhpjNiNctOGdMmovVR3LTV7TL+/uivZn6KcK
         klfj0MzH91YgBL3XCneEfdP0UjAch7XgqlrHeJFx7XcLuxj/fw5iJITl/Tg1v7JnYTMj
         lEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=D/IHf2NWbkBu2/dnLT5S1455F/NSQH7Bez/0/zsY4ns=;
        b=qkLXpS77h1KkMvEn9ymVynVrNzbheciXo+DcXnc0kv+EC+i+AiGfSATNqG4m2WYf7C
         RLGY8dUcx7fblR+82nslM5vxFuAw1ZA30+dm/KwR6AFSaF6ko0NcCkhl4/cJTbd833K7
         X3dH5QRCDq7KpoH0XGGkcAbJc1B47w/Q0qvwemhzuPaV3VpqKBLnHF3tlDRxUT7VY+QS
         HWcp2o37rYt5IeU/nzHJcwCPsd/CZA5o0vmke+zyHVEqZgP7BN6LCx3z7rEQ0oPLqBba
         FtlPYoDLxfOm0rMVT3S4FRJl7m1fnqaUJTnxVcTBqjoksbMazFzC3afbKVoMAU2OJ2wF
         ZHcA==
X-Gm-Message-State: AOAM530uKIEs58Bx5KGRYUsH9uzpKnqdyqbCAy14L3UNEkRaHTPwPOMv
        rNPl5ZIHfXJIGs2h4Zzt5p3S+PzToVjb
X-Google-Smtp-Source: ABdhPJxR58WTTtS8AKXqF8trL+Tq7n5Af2kg5RhvQyrSPnU4lJrad5XcrhDLdqTGryVNTb31qr53mNC6nH4t
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a05:6214:108d:: with SMTP id
 o13mr21210649qvr.16.1612292283198; Tue, 02 Feb 2021 10:58:03 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:20 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-15-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 14/28] KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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

Given certain conditions, some TDP MMU functions may not yield
reliably / frequently enough. For example, if a paging structure was
very large but had few, if any writable entries, wrprot_gfn_range
could traverse many entries before finding a writable entry and yielding
because the check for yielding only happens after an SPTE is modified.

Fix this issue by moving the yield to the beginning of the loop.

Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

---

v1 -> v2
- Split patch into three

 arch/x86/kvm/mmu/tdp_mmu.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7cfc0639b1ef..c8a1149cb229 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -501,6 +501,12 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool flush_needed = false;
 
 	tdp_root_for_each_pte(iter, root, start, end) {
+		if (can_yield &&
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed)) {
+			flush_needed = false;
+			continue;
+		}
+
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
@@ -515,9 +521,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
-
-		flush_needed = !(can_yield &&
-				 tdp_mmu_iter_cond_resched(kvm, &iter, true));
+		flush_needed = true;
 	}
 	return flush_needed;
 }
@@ -880,6 +884,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+			continue;
+
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -888,8 +895,6 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
-
-		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -933,6 +938,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool spte_set = false;
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+			continue;
+
 		if (spte_ad_need_write_protect(iter.old_spte)) {
 			if (is_writable_pte(iter.old_spte))
 				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
@@ -947,8 +955,6 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
-
-		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -1056,6 +1062,9 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool spte_set = false;
 
 	tdp_root_for_each_pte(iter, root, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+			continue;
+
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
@@ -1063,8 +1072,6 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
 		spte_set = true;
-
-		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 
 	return spte_set;
@@ -1105,6 +1112,11 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	bool spte_set = false;
 
 	tdp_root_for_each_pte(iter, root, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set)) {
+			spte_set = false;
+			continue;
+		}
+
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -1116,7 +1128,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		spte_set = !tdp_mmu_iter_cond_resched(kvm, &iter, true);
+		spte_set = true;
 	}
 
 	if (spte_set)
-- 
2.30.0.365.g02bc693789-goog

