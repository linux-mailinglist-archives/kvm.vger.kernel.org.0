Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F8C44CCC3
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhKJWda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbhKJWdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:25 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C8DC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:37 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id t7-20020a17090a5d8700b001a7604b85f5so1763146pji.8
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HxuPuqGkbTjSIg2Su8P7hCQVY2FZaCOTe+WC7xPaI7c=;
        b=nYv5Z9KofpdEzDPn8k6Dj3N3h4bGmdGBZSObIUm5pHTaj8GTpoM67DnJHAd17YOjSD
         S35CPXcrZXckEjm1mfZHXhTRkR0G6NuvdspFlthNlpEhNTubVhN6oK4ldmQkebEBnbkz
         gfZz3ei6yhgmd/BRb0Zojc0lIP+9Lnl43zs6Q3j6cIaNgCCSUZGO9mKrPP8sMlqB443X
         EP27exc5uIjp0as5AoSktWMHiEVQwmHSBjSrCCraUZkl1A2L0m74ICzb0xL4jAdbdGEV
         HXE+/F1b61tSCGhPD1UIWxO8KsX5c26c1BsSlntNdndzNNHm9S/szCyKvGnNGPPBA3DW
         CZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HxuPuqGkbTjSIg2Su8P7hCQVY2FZaCOTe+WC7xPaI7c=;
        b=0/R75OnygqYz7oFlD7LdJNHsE1R+KB8kS508rNQhyvDV7ug516DY9yd2XdQ3S9dUpN
         5csSUR5JaS3jYhugepY9ec0CAQjW/FAV3UCAjVTYXwxYk6rs/afUnazHNJbrPy9pmdMO
         e8xKW5/BIiDs6uIUjiBz586At8WyAR/KLqiY5cwSouHax7oK76ulVMe/NTMTAusDOQxn
         JabFZUl9PEWSImFcfgmTVm37XXBdHedF+M4CPq/aYqN4FFg42ZPnZ/e6N+kpZrs7HMl1
         e80u/t45POJMZJ/pS5JYH5hMDfdlzT2W8bZ0aZtIdLhnuj7EKkBexGMA6QFEd8TH2TDY
         qqCQ==
X-Gm-Message-State: AOAM531tIzo93eQSiUDNLbxOHKx2VXPNDt07/Mc96mj17XTyzg8M+9Ug
        ouq6ISAxFz6qhujDRuXUV8TfeCV/YiHP
X-Google-Smtp-Source: ABdhPJyo8uAV/k8H7CE2MqwmQTT8qNVtaTXISNS2gn9aK+hCVK8iTqvWvCYXG02UbdAOde0Tyl+J7KMn/Fj6
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr48426pjf.1.1636583436858; Wed, 10 Nov 2021 14:30:36 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:29:56 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-6-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 05/19] KVM: x86/mmu: Remove redundant flushes when disabling
 dirty logging
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tdp_mmu_zap_spte_atomic flushes on every zap already, so no need to
flush again after it's done.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 +---
 arch/x86/kvm/mmu/tdp_mmu.c | 21 ++++++---------------
 arch/x86/kvm/mmu/tdp_mmu.h |  5 ++---
 3 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 354d2ca92df4..baa94acab516 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5870,9 +5870,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
-		if (flush)
-			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
 	}
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c2a9f7acf8ef..1ece645e737f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1438,10 +1438,9 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
  */
-static bool zap_collapsible_spte_range(struct kvm *kvm,
+static void zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+				       const struct kvm_memory_slot *slot)
 {
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
@@ -1452,10 +1451,8 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 
 	tdp_root_for_each_pte(iter, root, start, end) {
 retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
-			flush = false;
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
-		}
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1475,30 +1472,24 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
 			goto retry;
 		}
-		flush = true;
 	}
 
 	rcu_read_unlock();
-
-	return flush;
 }
 
 /*
  * Clear non-leaf entries (and free associated page tables) which could
  * be replaced by large mappings, for GFNs within the slot.
  */
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
-		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
-
-	return flush;
+		zap_collapsible_spte_range(kvm, root, slot);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 476b133544dd..3899004a5d91 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -64,9 +64,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush);
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-- 
2.34.0.rc0.344.g81b53c2807-goog

