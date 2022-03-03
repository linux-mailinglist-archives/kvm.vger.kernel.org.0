Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6E54CC637
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbiCCTkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236172AbiCCTkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 110D41A271C
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Szv77DNh8Njb+g/24MZ9SNeefN0yh1SOeI/rBcaUhWc=;
        b=RGuAu9of3JqjXZWRAj96GdZwgOFkjLbfkfhfFk9ugfTfGhwEnQGfWZY2VZ+YaPJFpjbhGh
        3Gs2NBA47NbR/bfOPJU5U9h2b3Z5+7ydi9jax88OcaESeJshQ1WwoRAaa2HjjENpP0oUVK
        lT/ESbLIArPpuCiUreaA+KPdmBe/ikE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-8fC30IhNPrG7pzWaOESZpg-1; Thu, 03 Mar 2022 14:39:16 -0500
X-MC-Unique: 8fC30IhNPrG7pzWaOESZpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71C531800D50;
        Thu,  3 Mar 2022 19:39:14 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DC275FC22;
        Thu,  3 Mar 2022 19:39:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 23/30] KVM: x86/mmu: Zap roots in two passes to avoid inducing RCU stalls
Date:   Thu,  3 Mar 2022 14:38:35 -0500
Message-Id: <20220303193842.370645-24-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

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
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-22-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 51 +++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 408e21e4009c..e24a1bff9218 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -822,14 +822,36 @@ static inline gfn_t tdp_mmu_max_gfn_host(void)
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
@@ -847,22 +869,17 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
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
2.31.1


