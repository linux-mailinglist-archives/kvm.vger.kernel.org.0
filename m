Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848DA57D820
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 03:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbiGVBvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 21:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiGVBvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 21:51:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9F890DAE
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 31-20020a63125f000000b00419a2da53bdso1640910pgs.8
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4BZROGdIJ6ey3ykeGXKKMyG5fxGLOs9dtND9v0m18DI=;
        b=MwDh0r7e9Z50plp25nl4fU2XJ0ebh5++1X9yJJYV97pjuLK0ahyEY3Y8MqgsKA30wo
         rDCddGIzUUQ2BQH+lTn83Rja5L3SCm6AZpaWt5SXKfXP8DCl4YIJKMCTCFvVTq2vvadH
         PuySAk39zirowz3Gyd8+qtVDsZXRxjmr6MpDmamAqsuZex6XJHHbyOA48OK2baHJCwEn
         83i97+hNJ7QVpTrzc3m5GFh2VtOAQbiLIxElelsydLR0K+KYHRweZq3CPpJI1rDgH0cV
         kh6oM05Ggd5zJVKnTVDWLz6qVwtNJZY96QC2Cf+7mEoOOYjlbzYJP+Z2lxv1xHyYq7Ol
         t5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4BZROGdIJ6ey3ykeGXKKMyG5fxGLOs9dtND9v0m18DI=;
        b=IIXYbSlfO5X1h1Xan6b8dLVcgrZyV2OJ8y3HrKVUHACyKuqUJRjc0jRS331+BXYtws
         IbDjzk5Zhge5MQ6/7gGQZFK20M/n4XJqySutjh0TRbgy3nDKRLjA8viawqL8F3HMmiQX
         p+0/sBsCvl8iOj5zrLkdmXm5C6RAq0imJ9cTEOoigSVUTKX3q+Uc1SVnTY0NppXX99KQ
         pbhaHfCoa1JxrmkNIdYpjvN/mds2k2OYb8WREDBh/jUC7ahdWjxK5nUAWwyo/2WDy+/e
         A4R4RhY/SMG+DO0mP1bj9XLQpee3LWd4ssEQTrUvI3STgHU40BD0rTJuESctravHHkuy
         rBLg==
X-Gm-Message-State: AJIora8a5S2vroCYFUMp/3nfKJLpPxYS+w5J1uK912lJ23ajkzfQ4hA/
        pmR9KRUjC7zp3NjXC2Kh0lUCoIw=
X-Google-Smtp-Source: AGRyM1vbtFVBRffsajgh0wYnjlyqGlcLkaXaKkTOQVsukeXgRgms6r3xxeGo4tZIWhNUOJdgZJEPUcI=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a17:90a:69e1:b0:1f2:2c0a:c30f with SMTP id
 s88-20020a17090a69e100b001f22c0ac30fmr7330979pjj.8.1658454659739; Thu, 21 Jul
 2022 18:50:59 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:50:28 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-3-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 2/7] KVM: arm64: Simplify the sanitise_mte_tags() logic
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Peter Collingbourne <pcc@google.com>
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

From: Catalin Marinas <catalin.marinas@arm.com>

Currently sanitise_mte_tags() checks if it's an online page before
attempting to sanitise the tags. Such detection should be done in the
caller via the VM_MTE_ALLOWED vma flag. Since kvm_set_spte_gfn() does
not have the vma, leave the page unmapped if not already tagged. Tag
initialisation will be done on a subsequent access fault in
user_mem_abort().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/mmu.c | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9012707f69c..1a3707aeb41f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1056,23 +1056,14 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
  * - mmap_lock protects between a VM faulting a page in and the VMM performing
  *   an mprotect() to add VM_MTE
  */
-static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
-			     unsigned long size)
+static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
+			      unsigned long size)
 {
 	unsigned long i, nr_pages = size >> PAGE_SHIFT;
-	struct page *page;
+	struct page *page = pfn_to_page(pfn);
 
 	if (!kvm_has_mte(kvm))
-		return 0;
-
-	/*
-	 * pfn_to_online_page() is used to reject ZONE_DEVICE pages
-	 * that may not support tags.
-	 */
-	page = pfn_to_online_page(pfn);
-
-	if (!page)
-		return -EFAULT;
+		return;
 
 	for (i = 0; i < nr_pages; i++, page++) {
 		if (!page_mte_tagged(page)) {
@@ -1080,8 +1071,6 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 			set_page_mte_tagged(page);
 		}
 	}
-
-	return 0;
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
@@ -1092,7 +1081,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault;
 	bool device = false;
-	bool shared;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1142,8 +1130,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
 
-	shared = (vma->vm_flags & VM_SHARED);
-
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
@@ -1264,12 +1250,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
-		if (!shared)
-			ret = sanitise_mte_tags(kvm, pfn, vma_pagesize);
-		else
+		if ((vma->vm_flags & VM_MTE_ALLOWED) &&
+		    !(vma->vm_flags & VM_SHARED)) {
+			sanitise_mte_tags(kvm, pfn, vma_pagesize);
+		} else {
 			ret = -EFAULT;
-		if (ret)
 			goto out_unlock;
+		}
 	}
 
 	if (writable)
@@ -1491,15 +1478,18 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_pfn_t pfn = pte_pfn(range->pte);
-	int ret;
 
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
 	WARN_ON(range->end - range->start != 1);
 
-	ret = sanitise_mte_tags(kvm, pfn, PAGE_SIZE);
-	if (ret)
+	/*
+	 * If the page isn't tagged, defer to user_mem_abort() for sanitising
+	 * the MTE tags. The S2 pte should have been unmapped by
+	 * mmu_notifier_invalidate_range_end().
+	 */
+	if (kvm_has_mte(kvm) && !page_mte_tagged(pfn_to_page(pfn)))
 		return false;
 
 	/*
-- 
2.37.1.359.gd136c6c3e2-goog

