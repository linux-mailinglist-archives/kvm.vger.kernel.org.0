Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EE34C52A9
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240488AbiBZATt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241200AbiBZARw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:52 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E03322D663
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:45 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d7b96d74f8so46356667b3.16
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8vGylyelB/7s2Iu/cezFfDz4H+G0SXAJDoFtwhKJJ28=;
        b=dlXNILOL0RcgYaj/SOWVb/B+cFvaL+/RGu/bd2ecjAYaKJn1zHuPEJbHsfwU502SK2
         +FPPiaiOVMxsUIrbOJ+sFuFZQplYzNHew/+TexiqluBvFAtJm5BOdpx6Dyf6PLamreU+
         hNU6CzIJO6mRakhEXLnBbgxZvH297CHWiYPQxLFgrjRHVwdn3KMGXQbJE9fY5v2rlaPS
         xCQ3NSaXqx4Lj0B3QRVeXDEfNXLnUlDVvWk7kzFqOVIAbjhdCXNeMCJrNwKFT6My9RFG
         v+b9azLwXSHba017DB8cTjbwtzh12saWyoLZoBJXmekNmr6CKoNAi8Z/xXgdovpR015D
         alzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8vGylyelB/7s2Iu/cezFfDz4H+G0SXAJDoFtwhKJJ28=;
        b=dm8sNCxKpwdSFgLhZekXhdNW/jT/JpT57FMMRTjUM1hQnkMqUFPrM8WywBk7kFBTYh
         fIiki/vESDKl0VSDTVJMnbP6c5r5EFLTdq0NBLznJde+xiozlyGVrlFiiMw7mYyxnwBz
         +VsX8g0GlF8tI6w5DxHbx7CR4NJA8cQaYOIBd3/IH5u7FBq3624IeMzLhvBpIbDTQSWV
         AAQlffOHB60s+RHn75t3s4hKKqTIgjGvnAnysK94fV6Orbwftbh8/Y4Elz32O9cmmxN5
         De00UOGsWbitiZI5W4di3L0aXXZN4+BBFK4CtMM3hTpR7BfUA0O3drjg51t/zKGPZRyb
         Gs6Q==
X-Gm-Message-State: AOAM5310J17cXWEUrDGBaH1TwZh/IiGIRr6Wd64bVNzZ1GtMFlse11P+
        rn6Tp3mGHSOkVOP/zl5v0c4BPfxw26U=
X-Google-Smtp-Source: ABdhPJwwopT5Z1DLLtP8f3p7Bz63Hhro6EnAkKtt/I4Q68E+irs1imu/xJTXCCS7diEoreI04+8r4bs7KM4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:e014:0:b0:619:a368:c3b5 with SMTP id
 x20-20020a25e014000000b00619a368c3b5mr9542866ybg.383.1645834596968; Fri, 25
 Feb 2022 16:16:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:39 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 21/28] KVM: x86/mmu: Zap roots in two passes to avoid
 inducing RCU stalls
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When zapping a TDP MMU root, perform the zap in two passes to avoid
zapping an entire top-level SPTE while holding RCU, which can induce RCU
stalls.  In the first pass, zap SPTEs at PG_LEVEL_1G, and then
zap top-level entries in the second pass.

With 4-level paging, zapping a PGD that is fully populated with 4kb leaf
SPTEs take up to ~7 or so seconds (time varies based on kernel config,
number of (v)CPUs, etc...).  With 5-level paging, that time can balloon
well into hundreds of seconds.

Before remote TLB flushes were omitted, the problem was even worse as
waiting for all active vCPUs to respond to the IPI introduced significant
overhead for VMs with large numbers of vCPUs.

By zapping 1gb SPTEs (both shadow pages and hugepages) in the first pass,
the amount of work that is done without dropping RCU protection is
strictly bounded, with the worst case latency for a single operation
being less than 100ms.

Zapping at 1gb in the first pass is not arbitrary.  First and foremost,
KVM relies on being able to zap 1gb shadow pages in a single shot when
when repacing a shadow page with a hugepage.  Zapping a 1gb shadow page
that is fully populated with 4kb dirty SPTEs also triggers the worst case
latency due writing back the struct page accessed/dirty bits for each 4kb
page, i.e. the two-pass approach is guaranteed to work so long as KVM can
cleany zap a 1gb shadow page.

  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu:     52-....: (20999 ticks this GP) idle=7be/1/0x4000000000000000
                                          softirq=15759/15759 fqs=5058
   (t=21016 jiffies g=66453 q=238577)
  NMI backtrace for cpu 52
  Call Trace:
   ...
   mark_page_accessed+0x266/0x2f0
   kvm_set_pfn_accessed+0x31/0x40
   handle_removed_tdp_mmu_page+0x259/0x2e0
   __handle_changed_spte+0x223/0x2c0
   handle_removed_tdp_mmu_page+0x1c1/0x2e0
   __handle_changed_spte+0x223/0x2c0
   handle_removed_tdp_mmu_page+0x1c1/0x2e0
   __handle_changed_spte+0x223/0x2c0
   zap_gfn_range+0x141/0x3b0
   kvm_tdp_mmu_zap_invalidated_roots+0xc8/0x130
   kvm_mmu_zap_all_fast+0x121/0x190
   kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
   kvm_page_track_flush_slot+0x5c/0x80
   kvm_arch_flush_shadow_memslot+0xe/0x10
   kvm_set_memslot+0x172/0x4e0
   __kvm_set_memory_region+0x337/0x590
   kvm_vm_ioctl+0x49c/0xf80

Reported-by: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 51 +++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b838cfa984ad..ec28a88c6376 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -802,14 +802,36 @@ static inline gfn_t tdp_mmu_max_gfn_host(void)
 	return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 }
 
-static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
-			     bool shared)
+static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
+			       bool shared, int zap_level)
 {
 	struct tdp_iter iter;
 
 	gfn_t end = tdp_mmu_max_gfn_host();
 	gfn_t start = 0;
 
+	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
+			continue;
+
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		if (iter.level > zap_level)
+			continue;
+
+		if (!shared)
+			tdp_mmu_set_spte(kvm, &iter, 0);
+		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
+			goto retry;
+	}
+}
+
+static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
+			     bool shared)
+{
+
 	/*
 	 * The root must have an elevated refcount so that it's reachable via
 	 * mmu_notifier callbacks, which allows this path to yield and drop
@@ -827,22 +849,17 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	/*
-	 * No need to try to step down in the iterator when zapping an entire
-	 * root, zapping an upper-level SPTE will recurse on its children.
+	 * To avoid RCU stalls due to recursively removing huge swaths of SPs,
+	 * split the zap into two passes.  On the first pass, zap at the 1gb
+	 * level, and then zap top-level SPs on the second pass.  "1gb" is not
+	 * arbitrary, as KVM must be able to zap a 1gb shadow page without
+	 * inducing a stall to allow in-place replacement with a 1gb hugepage.
+	 *
+	 * Because zapping a SP recurses on its children, stepping down to
+	 * PG_LEVEL_4K in the iterator itself is unnecessary.
 	 */
-	for_each_tdp_pte_min_level(iter, root, root->role.level, start, end) {
-retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
-			continue;
-
-		if (!is_shadow_present_pte(iter.old_spte))
-			continue;
-
-		if (!shared)
-			tdp_mmu_set_spte(kvm, &iter, 0);
-		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
-			goto retry;
-	}
+	__tdp_mmu_zap_root(kvm, root, shared, PG_LEVEL_1G);
+	__tdp_mmu_zap_root(kvm, root, shared, root->role.level);
 
 	rcu_read_unlock();
 }
-- 
2.35.1.574.g5d30c73bfb-goog

