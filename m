Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B8458F321
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbiHJTav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiHJTao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:30:44 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF13F72ED2
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:42 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-32a8e40e2dcso17031387b3.23
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=mFqP1F0ShkyQorPrJQoLgbSuKmrSiDmNhHy0lRjOzJE=;
        b=qMMDDHNedwjA7zqPuw6Nex1YvjI+wnTEu3dTcGVr4YFt2dlvPdqZc4ocMMn9OcaJ1u
         bNOv6WPuFMx17L605tZK2feM/UniON1PqKa8mmfHK5wP9GDR9nJkh6o7w8T7WQtX6yY5
         IieYw2WVZgwKDHZ0RsssIZNyrRKvBXHUll+9i2SAzXbQKQSmrI/eEgIYo2qz1LkXxGxx
         F8+Ozn862bgg+OhFTcwKqmsEXfksNIxUKTBI8ybmwrYZSuK/mHe5NbkTP2LmxZ4Fx5Ls
         ZcQs0NK70uyil6rXC++AD3JBymVRgk25Vt2ukme7wKzbtixCF3+h1rQid3l6nyDQPJjt
         TrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=mFqP1F0ShkyQorPrJQoLgbSuKmrSiDmNhHy0lRjOzJE=;
        b=3AUEai4HoIzAY2eApDiMXtpa69oJl9BMGnxzfy1zjCwuH1gXEsBoBbqmdP0R7clTEm
         ibjjAHw9h8RkdvaiJ+PGIuN6FIPjrAT9j6zWj5y1Vi0sTQsPjW0h4JUkaGPv9x+D0BIX
         XLiIW1mjN/wn6vTuL/OxxkKYDtNeT+Oonj27gdqwuexGdq2+QXrBCOhnOPdN1Bo6x6wK
         y2QzRsE9adCcbhXm3Ikk+QwemZF8JA/dpNZ/98uqAnwWtgEfiRcvVSTWscB27lIGWnwL
         HPOSGlCQ9838i8+vGD/qRwkbjSdFEQSZ2kdHAzl0pe2Ar9By6A+yC0hseqgrWockkugS
         6Ozw==
X-Gm-Message-State: ACgBeo2cJLDvvKWrysvdP2Oz+7HQJVNt+/dNL/09mY8LfGAXX10BIpBX
        nowOce8DHJNJAfqQpKohfFJvZwI=
X-Google-Smtp-Source: AA6agR706JjdcLT2M4esNrx3T5Owpv6PWcuQ0vDvB4kKku+q3s3am/yxaVtaQ/ck4iSq1T5v728hqWA=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:4d8b:fb2a:2ecb:c2bb])
 (user=pcc job=sendgmr) by 2002:a25:e542:0:b0:671:7f71:6895 with SMTP id
 c63-20020a25e542000000b006717f716895mr26223708ybh.7.1660159842232; Wed, 10
 Aug 2022 12:30:42 -0700 (PDT)
Date:   Wed, 10 Aug 2022 12:30:28 -0700
In-Reply-To: <20220810193033.1090251-1-pcc@google.com>
Message-Id: <20220810193033.1090251-3-pcc@google.com>
Mime-Version: 1.0
References: <20220810193033.1090251-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 2/7] KVM: arm64: Simplify the sanitise_mte_tags() logic
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
2.37.1.559.g78731f0fdb-goog

