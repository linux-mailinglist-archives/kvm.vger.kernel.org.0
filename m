Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456206CFF4F
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjC3I6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 04:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjC3I62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:58:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992D87D88
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:58:24 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f22so13340671plr.0
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680166704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RprU1FQJyxxcIHKiSPrHpqU5Norly3mnaXVCeZUl59M=;
        b=QDHkG5g+mhdDG+FzgKVq7FS5dKNc0YNfht7PzrIPGup07HPZi96FiixkgwPtKVIYGG
         YvA5YfJDQPGG3571GI68xmqSNKdRgYDNHzSXM1UF4Q6IX2GZf6W5zqMvZt/sbbPzmznM
         kDgvKePhP/3e133fLy2oCD4sa564mWqMu9USM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680166704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RprU1FQJyxxcIHKiSPrHpqU5Norly3mnaXVCeZUl59M=;
        b=KYXnjp1J8g1mdu7qc8ZPke2vbO2M0Oq9CB/2FQg8Ixl5gvw2k5wWXf+Jc5RzFvuLeu
         rZcsu+3zSgRNDC8pHRJN5dRdviDPRfwgx9oHVrJtntBGSNWNdbDTOEj/MH2U0PBlbxXM
         7Q+W9ZbcQcPrQrRJ6X8YedgpzoHuXHqMS4lSd5wx3pPI4NEtAF3MI8YrMtdXugV3Wmam
         a4Kvb+I7BlgqWf4y8lDju6WMCmaPClK84w1NB666AW28XXbEE/XVGlaml0UKK5W5MFFP
         brg0kQ9o1aTNKqToa6gSl6kmngB05uYURj6ZUR3wUDJzxvHIUsdSAAypOzAQTrBa/9Lq
         kaGg==
X-Gm-Message-State: AAQBX9cKQ4B0bKyN86gB8p1B68iIzuA5DAhOu4JjxKk6Htr1UgjIHevz
        ArCzGio1ARXDExEZ2ksX3cDuQA==
X-Google-Smtp-Source: AKy350b5AnG4pGNdCaiDN/aoj+xwtATD8wEB5ynusbMELHN8Cc/7Z1ktbP31uXiprAlWbm9qTDcdLw==
X-Received: by 2002:a17:902:c44c:b0:1a1:8edc:c5f8 with SMTP id m12-20020a170902c44c00b001a18edcc5f8mr18986019plm.56.1680166703992;
        Thu, 30 Mar 2023 01:58:23 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:1320:eef8:d0bb:b161])
        by smtp.gmail.com with UTF8SMTPSA id bi11-20020a170902bf0b00b0019f11caf11asm24358430plb.166.2023.03.30.01.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 01:58:23 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v6 3/4] KVM: arm64/mmu: use gfn_to_pfn_noref
Date:   Thu, 30 Mar 2023 17:58:01 +0900
Message-Id: <20230330085802.2414466-4-stevensd@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
In-Reply-To: <20230330085802.2414466-1-stevensd@google.com>
References: <20230330085802.2414466-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Switch the arm64 mmu to the new gfn_to_pfn_noref functions. This allows
IO and PFNMAP mappings backed with valid struct pages but without
refcounting (e.g. tail pages of non-compound higher order allocations)
to be mapped into the guest.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/arm64/kvm/mmu.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ff..0fd726e82a19 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1082,7 +1082,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 static unsigned long
 transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
-			    phys_addr_t *ipap)
+			    struct page **page, phys_addr_t *ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
 
@@ -1091,7 +1091,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
+	if (*page &&
+	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
 	    get_user_mapping_size(kvm, hva) >= PMD_SIZE) {
 		/*
 		 * The address we faulted on is backed by a transparent huge
@@ -1112,10 +1113,11 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		 * page accordingly.
 		 */
 		*ipap &= PMD_MASK;
-		kvm_release_pfn_clean(pfn);
+		kvm_release_page_clean(*page);
 		pfn &= ~(PTRS_PER_PMD - 1);
-		get_page(pfn_to_page(pfn));
 		*pfnp = pfn;
+		*page = pfn_to_page(pfn);
+		get_page(*page);
 
 		return PMD_SIZE;
 	}
@@ -1201,6 +1203,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	short vma_shift;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
+	struct page *page;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
@@ -1301,8 +1304,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __gfn_to_pfn_noref_memslot(memslot, gfn, false, false, NULL,
+					 write_fault, &writable, NULL, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
@@ -1348,7 +1351,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			vma_pagesize = fault_granule;
 		else
 			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
-								   hva, &pfn,
+								   hva,
+								   &pfn, &page,
 								   &fault_ipa);
 	}
 
@@ -1395,8 +1399,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 out_unlock:
 	read_unlock(&kvm->mmu_lock);
-	kvm_set_pfn_accessed(pfn);
-	kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_noref_clean(pfn, page);
 	return ret != -EAGAIN ? ret : 0;
 }
 
-- 
2.40.0.348.gf938b09366-goog

