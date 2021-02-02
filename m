Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14DC30CAF6
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbhBBTHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239420AbhBBTDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:03:38 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34717C0610D6
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:25 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id g80so15019500qke.17
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=dSL9YAt4PaftCcOpv1mtWutPCMjGb6A4qY7KXrR77Zs=;
        b=HVFtFk8XQEi/jo2mOt8kTLivy+jMrjzX6ilURGID8u6SifizNdR9NeLzsF/Yky3E83
         E9aC3FEqreGwuWr5UzWztygFojnG3nMggEsSDQbgl2qEuEqwpekxFy8zqcYa1LkkrQj6
         297PX126fqD6HBRq+hnjj5KKW1LZXpNDcCFDJLCaIMk74CcKYNRNo8DOpXBJZp5i6Xf2
         mb0Z6aYnXBPmumaMTAQoIDLY+o5q2wMmNtSUTdgBRqBSoXmQjV7G/axKA08Ku6OEo7px
         qSNcdSi/K8jDDn8mCGi5RsMmuMOy46XRjGz6zM8qAck7cGmG9jTa+aNw07W83a9L4Jpf
         zJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dSL9YAt4PaftCcOpv1mtWutPCMjGb6A4qY7KXrR77Zs=;
        b=V7VuQumgS49Zvd6VGXKishLYye0E9Ihhzl+LG1+RJUUUjdY2AHlpDbtbmtWMmPju/u
         3HUHNjP1376iE/4Vjx2+20D5DeRYT1TjmBAtXfHClqjvTb2BSo/1fiQ3QvokcUqLQ/Tj
         OhKov0QQupyO/lY9bgFTc3c9u8oZrHnRxJUMFuuh1X1rLw+ov+qIKhe1QIBOPvLOtRin
         VnvMDtxw0SEXrSc/JWoUuA/FX8/c9qd2ECPNfvryOz7bb0SPIx5Ki5zk2vZEEZA7R64j
         FYdJvUa5YlqlcD4y56XinFCqdm29SYhEcoW3R1419z6U3eI88Sfp1T7+lPRpoj/wA5dv
         nNpw==
X-Gm-Message-State: AOAM530y9247LCjgDE7FSIuLWPdW0laRnrKFUDtwqiiWOCldL/YEmZdb
        lVXMlv0dRonQm/g4KbykgiFjlJ2jDsyn
X-Google-Smtp-Source: ABdhPJzLHex+zt5wNPunEWO9byWg68HeubOeBmvoz/w1E1lA2GAwzBgmByUNVCg3p1uvGpPh4Wp573NYlolF
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a05:6214:1703:: with SMTP id
 db3mr21420509qvb.43.1612292304407; Tue, 02 Feb 2021 10:58:24 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:31 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-26-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 25/28] KVM: x86/mmu: Allow zapping collapsible SPTEs to use
 MMU read lock
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

To speed the process of disabling dirty logging, change the TDP MMU
function which zaps collapsible SPTEs to run under the MMU read lock.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  5 ++---
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++++++++++-------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 254ff87d2a61..e3cf868be6bd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5517,8 +5517,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 						start, end - 1, true);
 		}
 	}
-
-	kvm_mmu_unlock(kvm);
+	write_unlock(&kvm->mmu_lock);
 
 	if (kvm->arch.tdp_mmu_enabled) {
 		read_lock(&kvm->mmu_lock);
@@ -5611,10 +5610,10 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	write_lock(&kvm->mmu_lock);
 	slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
 			 kvm_mmu_zap_collapsible_spte, true);
+	write_unlock(&kvm->mmu_lock);
 
 	if (kvm->arch.tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, memslot);
-	write_unlock(&kvm->mmu_lock);
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index de26762433ea..cfe66b8d39fa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1451,10 +1451,9 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false)) {
-			spte_set = false;
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
-		}
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1465,9 +1464,14 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		    !PageTransCompoundMap(pfn_to_page(pfn)))
 			continue;
 
-		tdp_mmu_set_spte(kvm, &iter, 0);
-
-		spte_set = true;
+		if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
+			/*
+			 * The iter must explicitly re-read the SPTE because
+			 * the atomic cmpxchg failed.
+			 */
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			goto retry;
+		}
 	}
 
 	rcu_read_unlock();
@@ -1485,7 +1489,9 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 	int root_as_id;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
+	read_lock(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
@@ -1493,6 +1499,8 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		zap_collapsible_spte_range(kvm, root, slot->base_gfn,
 					   slot->base_gfn + slot->npages);
 	}
+
+	read_unlock(&kvm->mmu_lock);
 }
 
 /*
-- 
2.30.0.365.g02bc693789-goog

