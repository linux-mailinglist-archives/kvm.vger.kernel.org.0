Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3F057EB12
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiGWBXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbiGWBXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:23:45 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562FD8E6D5
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 134-20020a63018c000000b0040cf04213a1so3027175pgb.6
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nQKeW6axBiNTorfU6kCmIReteyQCmGSbc+JLKNeWNik=;
        b=nU9F+aCOBOSMo2ZwGcatDy6Cq0wCptVl7b+nBzUXasrosg/zWwLZZFsgGzRh7bj7bq
         LeB+KsvqDStH/7VUPGlSKA5wxQnC8aNQBCbqsCNa0U81xG0YpTYaK4Kw8huH2524RQrw
         V/jRYX3vs70vvWOPtFcLHTQfHsMGIxiis9NF2WdHl125Z8sS/KhzlyRPGlwEvJC9x1eu
         w+nWarXekor4zRUPl4+xDnnFEUJ9qofJ38crMHcmHGlw7YiEF2QcVe2RfGloxZemfotA
         iKuGebN/8jgCVi4fmDdRKT69vi4ebTV4y3X6XumSEvBGQWCWGpE9oBdS2tQi8BQr8qfk
         ORaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nQKeW6axBiNTorfU6kCmIReteyQCmGSbc+JLKNeWNik=;
        b=t04rEZEWB0K5c0F/7pD62CECADzqTBo6GVNRohIQqiP1+mErqhxL+S1K0oqBUqP7mb
         0m5yF/HsX3YqUnPFNZDTK87TCgJMZstVKyV/AUA6oWnvPRn+6vaNLuQNVisj/8hoXYxA
         IlmYhGaeDw+f7QcZIeHoED9UNOE7GEhEVGKobEvnx5UjUILN+vXHTV+pfltEF0lMmwtp
         9eI/FOeX0vD+nNRBBYaJjMt7QDE/UA/nyYFybI4Io0IOJs9YfEkszvnAOWPwiLv9OA4T
         evx/uGZGdkvqAqMDxsj/WY2aYbZQs6+bCGyPMbySgxLOud+ZoblDbt+fwCI+rN85M92A
         4/ew==
X-Gm-Message-State: AJIora95VzXGnchCJd5+sV155BhJqAEy8aQFkVkkcqK68KtUfvLw8cOp
        0EuwCxCBTN2GtYmQmxDGD9W/Bt8qAR4=
X-Google-Smtp-Source: AGRyM1uIjLky6nxm3wdf8Vy1wamATcVle1EV+97cmbtMFNKosMoRaODXbCJTaEJGKaf4Iz5G1bvZmbBQ8Cw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2d0:b0:16c:39bc:876 with SMTP id
 s16-20020a17090302d000b0016c39bc0876mr2448699plk.42.1658539418092; Fri, 22
 Jul 2022 18:23:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 01:23:23 +0000
In-Reply-To: <20220723012325.1715714-1-seanjc@google.com>
Message-Id: <20220723012325.1715714-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220723012325.1715714-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 4/6] KVM: x86/mmu: Track the number of TDP MMU pages, but
 not the actual pages
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the number of TDP MMU "shadow" pages instead of tracking the pages
themselves. With the NX huge page list manipulation moved out of the common
linking flow, elminating the list-based tracking means the happy path of
adding a shadow page doesn't need to acquire a spinlock and can instead
inc/dec an atomic.

Keep the tracking as the WARN during TDP MMU teardown on leaked shadow
pages is very, very useful for detecting KVM bugs.

Tracking the number of pages will also make it trivial to expose the
counter to userspace as a stat in the future, which may or may not be
desirable.

Note, the TDP MMU needs to use a separate counter (and stat if that ever
comes to be) from the existing n_used_mmu_pages. The TDP MMU doesn't bother
supporting the shrinker nor does it honor KVM_SET_NR_MMU_PAGES (because the
TDP MMU consumes so few pages relative to shadow paging), and including TDP
MMU pages in that counter would break both the shrinker and shadow MMUs,
e.g. if a VM is using nested TDP.

Cc: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++--------
 arch/x86/kvm/mmu/tdp_mmu.c      | 19 +++++++++----------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 246b69262b93..5c269b2556d6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1271,6 +1271,9 @@ struct kvm_arch {
 	 */
 	bool tdp_mmu_enabled;
 
+	/* The number of TDP MMU pages across all roots. */
+	atomic64_t tdp_mmu_pages;
+
 	/*
 	 * List of struct kvm_mmu_pages being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
@@ -1291,18 +1294,10 @@ struct kvm_arch {
 	 */
 	struct list_head tdp_mmu_roots;
 
-	/*
-	 * List of struct kvmp_mmu_pages not being used as roots.
-	 * All struct kvm_mmu_pages in the list should have
-	 * tdp_mmu_page set and a tdp_mmu_root_count of 0.
-	 */
-	struct list_head tdp_mmu_pages;
-
 	/*
 	 * Protects accesses to the following fields when the MMU lock
 	 * is held in read mode:
 	 *  - tdp_mmu_roots (above)
-	 *  - tdp_mmu_pages (above)
 	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
 	 *  - possible_nx_huge_pages;
 	 *  - the possible_nx_huge_page_link field of struct kvm_mmu_pages used
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 626c40ec2af9..fea22dc481a0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -29,7 +29,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
-	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 	kvm->arch.tdp_mmu_zap_wq = wq;
 	return 1;
 }
@@ -54,7 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	/* Also waits for any queued work items.  */
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
-	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
+	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -386,16 +385,18 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      bool shared)
 {
+	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+
+	if (!sp->nx_huge_page_disallowed)
+		return;
+
 	if (shared)
 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	else
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
-	list_del(&sp->link);
-	if (sp->nx_huge_page_disallowed) {
-		sp->nx_huge_page_disallowed = false;
-		untrack_possible_nx_huge_page(kvm, sp);
-	}
+	sp->nx_huge_page_disallowed = false;
+	untrack_possible_nx_huge_page(kvm, sp);
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1132,9 +1133,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 		tdp_mmu_set_spte(kvm, iter, spte);
 	}
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	atomic64_inc(&kvm->arch.tdp_mmu_pages);
 
 	return 0;
 }
-- 
2.37.1.359.gd136c6c3e2-goog

