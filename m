Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD71692C9B
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 02:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjBKBqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 20:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjBKBqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 20:46:36 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DD77E8F1
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:35 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u6-20020a170903124600b00188cd4769bcso3796851plh.0
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ylQ3Rvj2lB+88rdqpws35hu/21Y36j4VWX2N801NtKE=;
        b=C5Kk4fsWBf9kv5U1Qpa+U0cRxkXaRvZkMCQcwSbzIWmaJ+hHmiprlZeqdKj2u+eYxA
         fAGqWnQXXpPqhjIRRFJ0011pgAMHb+sMwNM5eAm8C4adyGpalV5McmX4s75Iqs+PHmAj
         5Y/c3WfgxzXMriP4aoE3FO4LAtuVVpqEAy78xXV9q6uAsV+0WslQoyXOpQIaINDz6BYC
         /47DxtT2suW/zMdIuyrcGsvKYv5iQVj2161i8iCLYnoqm3KwMzkw+Qwyt7wLZDnH3M0B
         t16nDYRqLoiQ1N3KLASolNpwFD18YbaKeu+NF0S3NWPpbJ9jboy/7yHV3LtNoFSAqt9I
         PwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ylQ3Rvj2lB+88rdqpws35hu/21Y36j4VWX2N801NtKE=;
        b=V+DeHgxtmoPnvzh/E2o+s6u+NRKOpyotN+VCNUrlGyoFiH/U5oCQV0hWyv+DiRgxpW
         yG4lRI0f2wun27iokvzIU8/kfgekaE+UJP0eweGKfuOCyU9j3/pBoU5sY6wuJd0cA91+
         0pZvj67oxyjXEBJPwvtQzSKvpk6RJssy8YJBhxIG1JnsbT2dBDR0HYSbOr7gvRedlTkQ
         TPARLWWaly/isxFUG6Jq4Bpqf3fstALff/HEkpteaWfCsThiTDjxPOYiPUfZMBeq32Hz
         4OoBIBLriMxYsri6Ymc7eFuykyTGu494OukFUm4zqU3DIkZrVnWkpYxvyGTkx2d6wARK
         /KoA==
X-Gm-Message-State: AO0yUKUYKXIPwL7qAzCYGK7iwdV1VrGEFKiwAwcX9MMI1lgjhMx/oyKN
        PIraRObedDkr+oZBZ0C94v2lCh4Qp3x7
X-Google-Smtp-Source: AK7set/E73OchTTBFaySUO9KPeYHWBzgKB9X+c//+xmmRYkSgD0kBZIqT1GdHv9Z4Yoc6TvtA9nWmbJaNcyP
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90b:312:b0:233:bf8f:82a4 with SMTP id
 ay18-20020a17090b031200b00233bf8f82a4mr329176pjb.72.1676079995322; Fri, 10
 Feb 2023 17:46:35 -0800 (PST)
Date:   Fri, 10 Feb 2023 17:46:21 -0800
In-Reply-To: <20230211014626.3659152-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211014626.3659152-3-vipinsh@google.com>
Subject: [Patch v3 2/7] KVM: x86/mmu: Atomically clear SPTE dirty state in the
 clear-dirty-log flow
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

Do atomic-AND to clear the dirty state of SPTEs. Optimize clear-dirty-log
flow by avoiding to go through __handle_changed_spte() and directly call
kvm_set_pfn_dirty() instead.

Atomic-AND allows to fetch the latest value in SPTE, clear only its
dirty state and set the new SPTE value.  This optimization avoids
executing unnecessary checks by not calling __handle_changed_spte().

With the removal of tdp_mmu_set_spte_no_dirty_log(), "record_dirty_log"
parameter in __tdp_mmu_set_spte() is now obsolete. It will always be set
to true by its caller. This dead code will be cleaned up in future
commits.

Tested on a VM (160 vCPUs, 160 GB memory) and found that performance of clear
dirty log stage improved by ~40% in dirty_log_perf_test

Before optimization:
--------------------
Iteration 1 clear dirty log time: 3.638543593s
Iteration 2 clear dirty log time: 3.145032742s
Iteration 3 clear dirty log time: 3.142340358s
Clear dirty log over 3 iterations took 9.925916693s. (Avg 3.308638897s/iteration)

After optimization:
-------------------
Iteration 1 clear dirty log time: 2.318988110s
Iteration 2 clear dirty log time: 1.794470164s
Iteration 3 clear dirty log time: 1.791668628s
Clear dirty log over 3 iterations took 5.905126902s. (Avg 1.968375634s/iteration)

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.h | 14 ++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  | 35 +++++++++++++++--------------------
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index c11c5d00b2c1..fae559559a80 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -58,6 +58,20 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
 	return old_spte;
 }
 
+static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_spte,
+					  u64 mask, int level)
+{
+	atomic64_t *sptep_atomic;
+
+	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level)) {
+		sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
+		return (u64)atomic64_fetch_and(~mask, sptep_atomic);
+	}
+
+	__kvm_tdp_mmu_write_spte(sptep, old_spte & ~mask);
+	return old_spte;
+}
+
 /*
  * A TDP iterator performs a pre-order walk over a TDP paging structure.
  */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bba33aea0fb0..66ccbeb9d845 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -771,13 +771,6 @@ static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
 	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
 }
 
-static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
-						 struct tdp_iter *iter,
-						 u64 new_spte)
-{
-	_tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
-}
-
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
 	for_each_tdp_pte(_iter, _root, _start, _end)
 
@@ -1677,8 +1670,13 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t gfn, unsigned long mask, bool wrprot)
 {
+	/*
+	 * Either all SPTEs in TDP MMU will need write protection or none. This
+	 * contract will not be modified for TDP MMU pages.
+	 */
+	u64 clear_bit = (wrprot || !kvm_ad_enabled()) ? PT_WRITABLE_MASK :
+							shadow_dirty_mask;
 	struct tdp_iter iter;
-	u64 new_spte;
 
 	rcu_read_lock();
 
@@ -1693,19 +1691,16 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		mask &= ~(1UL << (iter.gfn - gfn));
 
-		if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
-			if (is_writable_pte(iter.old_spte))
-				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
-			else
-				continue;
-		} else {
-			if (iter.old_spte & shadow_dirty_mask)
-				new_spte = iter.old_spte & ~shadow_dirty_mask;
-			else
-				continue;
-		}
+		if (!(iter.old_spte & clear_bit))
+			continue;
 
-		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
+		iter.old_spte = tdp_mmu_clear_spte_bits(iter.sptep,
+							iter.old_spte,
+							clear_bit, iter.level);
+		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
+					       iter.old_spte,
+					       iter.old_spte & ~clear_bit);
+		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
 	}
 
 	rcu_read_unlock();
-- 
2.39.1.581.gbfd45094c4-goog

