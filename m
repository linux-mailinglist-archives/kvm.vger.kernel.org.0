Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEAF618D79
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 02:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiKDBLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 21:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiKDBLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 21:11:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F536220C5
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 18:11:07 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-352e29ff8c2so33620047b3.21
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 18:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8wvPVNBIGqPordV4VqCP60h9NBW3OrQ+oktJeQ7thTw=;
        b=A+A0tEpthLB+uuGmFa5yS0IHcK7j38Tj0ebvhxSMPg5emU5TZZt2mYe9MZh7RAtr0y
         Ps00sS0Er2FbYA2csEblRJ1UfNxH9upYvLoLCdEkMyFMXQBFOhNaC2MCVmmTypPwANaO
         vJUmDW5hpXkvRUy2dJnOSd+c2zABMrXNOESfwAiNk9IO2oZPq1WieXohqRV2p1kj+aO3
         w11BWq3t4PIQVWPI1rpRlsVI+HWzbrfNvVm/toq/WiprZlRhhvXKwv1BkHKFv0oDtHxC
         SsTRY97Q6pnqX6cUoNLCT9g9pBtiOytIELUkyKORJXfQh5+ohRzxLE7H8/lfP8qosxxz
         oojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wvPVNBIGqPordV4VqCP60h9NBW3OrQ+oktJeQ7thTw=;
        b=2YZ9KI0xiIHuucSYCRW9zQynUtD3y3C/1wPo2+YKx4bWLGvhjJFRhdTzkEIA5TFVxS
         rlRFOT/xW/ZvVQKjWP62Xn6wi3KFgnzQKk2894SWWSG22K3dfbUE/l2BLgPY69VbjFu6
         9X8uAfv7/VGTK/qwqOFq+DDzPDz1qmldheHKSe9MUj6dmuPl/+l1g56PklcTTp2prPar
         reByZn3C3n90WxuUbg9fshDAIoe4Hi73e5cTXuEkhfhKP8umfh5RJ2ZYpxc0airMGXGL
         NHsX1ATOd6J8kGgkTI3Emx4WnNpMOCkyDewVHxKFbwYFCvVcU3OzX6XH9B850l9D1+lc
         ROVQ==
X-Gm-Message-State: ANoB5pnCVj+SmrhSO5XghmQhi9K6RvLPlPDDNyvNPjdgXtxMZ9za0tsY
        kjE2SLNPEeWz4GtMVXL2r9XXVb8=
X-Google-Smtp-Source: AA0mqf6aCG6H1JcdeUQvIHj3QDAK9Uph6TKu2Ix1eLoqmjpSVgiU9fa0kE/LaoMn+PfmE2uXJxHiEHw=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a25:234f:0:b0:6d2:f2e8:c131 with SMTP id
 j76-20020a25234f000000b006d2f2e8c131mr31156ybj.418.1667524266424; Thu, 03 Nov
 2022 18:11:06 -0700 (PDT)
Date:   Thu,  3 Nov 2022 18:10:36 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-4-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 3/8] KVM: arm64: Simplify the sanitise_mte_tags() logic
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
[pcc@google.com: fix the page initializer]
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/mmu.c | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2c3759f1f2c5..e81bfb730629 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1091,23 +1091,14 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
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
@@ -1115,8 +1106,6 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 			set_page_mte_tagged(page);
 		}
 	}
-
-	return 0;
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
@@ -1127,7 +1116,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault;
 	bool device = false;
-	bool shared;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1177,8 +1165,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
 
-	shared = (vma->vm_flags & VM_SHARED);
-
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
@@ -1299,12 +1285,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
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
@@ -1526,15 +1513,18 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
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
2.38.1.431.g37b22c650d-goog

