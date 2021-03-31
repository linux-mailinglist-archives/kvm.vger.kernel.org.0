Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783DB3508F1
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbhCaVKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhCaVJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:30 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29FFC061761
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:29 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y10so1735448plt.21
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rflZjTREsJ/gYfIbS3+5us9ybJwv9yTRsjWAKMCJ5Y4=;
        b=oob7KpmemiWewo+Ci8QQhYn901DVVDpmFfmk2PhtTZNXo8tdI6jt3YAIhheWN4y/a/
         NjUWpruPwj6lc0IEr9hrDP6eFSZepprjHVb3e8sP+t+zMOHnE/I9vKOkyzzwzZjIjZy3
         mVeKkPALWk8XtaO8huIX/XvvOvJLwiK5qmdvwPSpFkoznXPL7PHj3QIfEuzxDP4fKsvG
         7OFquoGYhQPjY8zs4Swlmy/sZTNnydpGw1cTshXhfmLyp6pCtMGLVd48F+D+B/fbYEjX
         0KxJjSeOzeEX9g/68/zwsIe6OpJbbmSOtQyRgKbQ92SwDaZEkUUc82P0Bn3vsyfsvDR4
         slJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rflZjTREsJ/gYfIbS3+5us9ybJwv9yTRsjWAKMCJ5Y4=;
        b=fB+yyNaJ7/nEX6B73joOzddaJoK0+X/3LuhsV0vRV5eblVqeUCY/J3qEEBh8xf0rNf
         hNADjw04DfyRjim/pxPz1d3xq8e9AJOQvYwMKd7nuQLF9dLa/ngJpC6EyXWeAqdlcBDi
         TkfBtTMKBBAayQz6J6NazdAvFGs5WenkLX2OaVu//H7S+TbPPq598cG83LGR1v/QXNJi
         aYd4VXPuTbEwn6IuFDJluNeWMFA5QjVbFJ73P7aIuIH8HqFw5pmZrURgTsTCGvcRpLr2
         7FtwDBO+zC9wO39QHNn0m5CJLYO3j3S01jBcJPf89FhGy0byYLTgswdxp01r5+LlR4Jd
         0FLw==
X-Gm-Message-State: AOAM531nulVzIkYMPH4/937S8d696Ioj3PUWbvnDMQNdmvR+bgEERc09
        aiuXywuO8TFD0vVE+JBljYsCk83pH3vn
X-Google-Smtp-Source: ABdhPJwnq8zO7FqwGFOoGocE4klDVpKwN7Hey65gI/W+fuTsGzvz/nAsWGBZ+Es+tBL9ISU0/BdhrvwYi8jq
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:a17:90a:8b97:: with SMTP id
 z23mr39673pjn.1.1617224968753; Wed, 31 Mar 2021 14:09:28 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:38 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-11-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 10/13] KVM: x86/mmu: Allow zapping collapsible SPTEs to use
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
 arch/x86/kvm/mmu/mmu.c     |  9 ++++++---
 arch/x86/kvm/mmu/tdp_mmu.c | 17 +++++++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dcbfc784cf2f..81967b4e7d76 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5610,10 +5610,13 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
-
-	if (is_tdp_mmu_enabled(kvm))
-		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 	write_unlock(&kvm->mmu_lock);
+
+	if (is_tdp_mmu_enabled(kvm)) {
+		read_lock(&kvm->mmu_lock);
+		kvm_tdp_mmu_zap_collapsible_sptes(kvm, memslot);
+		read_unlock(&kvm->mmu_lock);
+	}
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0e99e4675dd4..862acb868abd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1335,7 +1335,8 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set, false)) {
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set, true)) {
 			spte_set = false;
 			continue;
 		}
@@ -1350,8 +1351,14 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 							    pfn, PG_LEVEL_NUM))
 			continue;
 
-		tdp_mmu_set_spte(kvm, &iter, 0);
-
+		if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
+			/*
+			 * The iter must explicitly re-read the SPTE because
+			 * the atomic cmpxchg failed.
+			 */
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			goto retry;
+		}
 		spte_set = true;
 	}
 
@@ -1370,7 +1377,9 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 	int root_as_id;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
-- 
2.31.0.291.g576ba9dcdaf-goog

