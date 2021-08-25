Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897653F6D89
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 04:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238735AbhHYCvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 22:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238800AbhHYCvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 22:51:44 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660CFC061796
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 19:50:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id j187so20028372pfg.4
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 19:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=557teW+frwo4Nr6ovWUFY7KeQxNTE5k/uRPl11taWZQ=;
        b=dJZPNbN+XP6sX7GpVU532TVhHZl6nHNwAU01QzJVrc3j/QFBm+gAVJOBv7Xnu2aH4/
         n025fIzhjwX1sIIdy+r5hLJcXuY4gL2NKJ4BGijImZ6GQyb7bW2WYYYteVrgwq1wZmyq
         m2QIpq6RQ6SeQqx0+SxU2QK1+XenesCF0sgVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=557teW+frwo4Nr6ovWUFY7KeQxNTE5k/uRPl11taWZQ=;
        b=H9T3Cx7TQRNR3BcWVF2czH5BKXLLNU66Qwes7AOIty/NRPdh4O+eVNHkj7e+i+ICo4
         /Mtyhko2F/iTGLuKC9rRXRSXySZmSbhS2ncXbpq5jgv9mKjjmNf6ZRe953qUq4rnyUPg
         cwh0Xv1n33gVgSOsWGdItpq7+GHBwjdG0HX+E6aMn8dGo+AO0OUfFoOzPIkwkE1UeEpi
         bYVe3FSlaGlr9V2tlvYebLHrsvJqaPuvmDL42fSOvRCI4AgYUV3XZo0ZK4FBs1UrwZ9w
         e3AZ7IVB3damrQGVbnG3PU3CMoudIuPNd7H8Uv/gpZSKgY0TCnFaLO9ZfQAwjr7JmQx1
         uyvQ==
X-Gm-Message-State: AOAM531jWO7WGfY8WC07/BIchCmiBHdlOlfelUA/uFBnYdiViHnG0lfo
        t+l38gPzlbHenaXyEtFKJ9U0eQ==
X-Google-Smtp-Source: ABdhPJy7fnzRhZlYP4VERGSECQAJC5znWGpeXh8ua0qlkt1Qha9Ceo47LlcixtFLfUP/SBRdvsH9qA==
X-Received: by 2002:a05:6a00:a8a:b029:356:be61:7f18 with SMTP id b10-20020a056a000a8ab0290356be617f18mr42253650pfl.29.1629859858992;
        Tue, 24 Aug 2021 19:50:58 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:d273:c78c:fce8:a0e2])
        by smtp.gmail.com with UTF8SMTPSA id y12sm22219470pgl.65.2021.08.24.19.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 19:50:58 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v3 3/4] KVM: arm64/mmu: use gfn_to_pfn_page
Date:   Wed, 25 Aug 2021 11:50:08 +0900
Message-Id: <20210825025009.2081060-4-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
In-Reply-To: <20210825025009.2081060-1-stevensd@google.com>
References: <20210825025009.2081060-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Covert usages of the deprecated gfn_to_pfn functions to the new
gfn_to_pfn_page functions.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/arm64/kvm/mmu.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0625bf2353c2..56859999b211 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -782,7 +782,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 static unsigned long
 transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
-			    phys_addr_t *ipap)
+			    struct page **page, phys_addr_t *ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
 
@@ -791,7 +791,7 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (kvm_is_transparent_hugepage(pfn) &&
+	if (*page && kvm_is_transparent_hugepage(pfn) &&
 	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
 		/*
 		 * The address we faulted on is backed by a transparent huge
@@ -812,10 +812,11 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
 		 * page accordingly.
 		 */
 		*ipap &= PMD_MASK;
-		kvm_release_pfn_clean(pfn);
+		put_page(*page);
 		pfn &= ~(PTRS_PER_PMD - 1);
-		kvm_get_pfn(pfn);
 		*pfnp = pfn;
+		*page = pfn_to_page(pfn);
+		get_page(*page);
 
 		return PMD_SIZE;
 	}
@@ -908,6 +909,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	short vma_shift;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
+	struct page *page;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
@@ -1009,8 +1011,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __gfn_to_pfn_page_memslot(memslot, gfn, false, NULL,
+					write_fault, &writable, NULL, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
@@ -1052,7 +1054,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
 		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
-							   &pfn, &fault_ipa);
+							   &pfn, &page,
+							   &fault_ipa);
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
@@ -1090,14 +1093,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
-		kvm_set_pfn_dirty(pfn);
+		if (page)
+			kvm_set_pfn_dirty(pfn);
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 	}
 
 out_unlock:
 	spin_unlock(&kvm->mmu_lock);
-	kvm_set_pfn_accessed(pfn);
-	kvm_release_pfn_clean(pfn);
+	if (page) {
+		kvm_set_pfn_accessed(pfn);
+		put_page(page);
+	}
 	return ret != -EAGAIN ? ret : 0;
 }
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

