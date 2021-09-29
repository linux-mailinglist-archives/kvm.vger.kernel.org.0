Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE541BE3F
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 06:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244109AbhI2Ebi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 00:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243938AbhI2Eba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 00:31:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E17BC061755
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 21:29:46 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ce20-20020a17090aff1400b0019f13f6a749so3030444pjb.4
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 21:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcDKPT+o8pM718i3RLMaqx3xW7Im6h5PXbupy2CRXlk=;
        b=AlxJKNLVCtbK//MPu0SwfjNSQbHwwFNaK/3A0HUgxYAYkHcIT+rlmMLLt2qZrpyAyp
         C5t1oA+CT6G5meEEeMzD5kZ8i4MvQTTRPGyO+QzHMZUkoUC3ZJlQo5YNYhLT1Gzx9doh
         asWRl+ES1erLKQgBHQzTmUb6DExqco2ElcumI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcDKPT+o8pM718i3RLMaqx3xW7Im6h5PXbupy2CRXlk=;
        b=Bi+I7WxKB2b58ThwYJm3iZMA0ytR3nuJByk6Q4rePRuEc8s49E+1P1JhC1Sxv0Fh3W
         JEhxmvFNjq36+8gIA3ObaWB1bmQhWQjkY6n17ML3nr/ZHsSepP977GH6f6Y5eQEw6ewj
         f1Lq3ihD/+vF/umgZSQHZ6hq+fS2dS9iQTuL7/TUr4FSXGC0UADMi5Cw4OWnGcn0cmMW
         jl5K41BBBmXsYMm021Cf77oXoFlwoD+kfjQ9zSm0GJ5KiR+XErVkTgMwnQHXcl+11eq9
         h0xePJBr1SphyDc7wc4pxnh/nuyX3jAa/WHrOsCxhoqZLrvfCkI8xbH+Gesk3T4RivSy
         w2SQ==
X-Gm-Message-State: AOAM530qoQ5fQpefA8A/Bc1RKiIRFuPadXD0998teSlPkabWymqEZMWU
        chbhS0yt9mpvbZ9fsoS11+HPZg==
X-Google-Smtp-Source: ABdhPJzx/fGyiGUmfwWIVEkifAtKjOaGFTb3lns1h2o/LCiNDuEd1upLa4vG7ByFxiynE/6fn+dXhQ==
X-Received: by 2002:a17:90a:f196:: with SMTP id bv22mr4057172pjb.212.1632889785769;
        Tue, 28 Sep 2021 21:29:45 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:f818:368:93ef:fa36])
        by smtp.gmail.com with UTF8SMTPSA id p17sm268006pjg.54.2021.09.28.21.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 21:29:45 -0700 (PDT)
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
Subject: [PATCH v4 3/4] KVM: arm64/mmu: use gfn_to_pfn_page
Date:   Wed, 29 Sep 2021 13:29:07 +0900
Message-Id: <20210929042908.1313874-4-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929042908.1313874-1-stevensd@google.com>
References: <20210929042908.1313874-1-stevensd@google.com>
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
 arch/arm64/kvm/mmu.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1a94a7ca48f2..dc03cc66858e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -829,7 +829,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 static unsigned long
 transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
-			    phys_addr_t *ipap)
+			    struct page **page, phys_addr_t *ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
 
@@ -838,7 +838,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
+	if (*page &&
+	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
 	    get_user_mapping_size(kvm, hva) >= PMD_SIZE) {
 		/*
 		 * The address we faulted on is backed by a transparent huge
@@ -859,10 +860,11 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		 * page accordingly.
 		 */
 		*ipap &= PMD_MASK;
-		kvm_release_pfn_clean(pfn);
+		put_page(*page);
 		pfn &= ~(PTRS_PER_PMD - 1);
-		get_page(pfn_to_page(pfn));
 		*pfnp = pfn;
+		*page = pfn_to_page(pfn);
+		get_page(*page);
 
 		return PMD_SIZE;
 	}
@@ -955,6 +957,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	short vma_shift;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
+	struct page *page;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
@@ -1056,8 +1059,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __gfn_to_pfn_page_memslot(memslot, gfn, false, NULL,
+					write_fault, &writable, NULL, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
@@ -1102,7 +1105,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			vma_pagesize = fault_granule;
 		else
 			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
-								   hva, &pfn,
+								   hva,
+								   &pfn, &page,
 								   &fault_ipa);
 	}
 
@@ -1142,14 +1146,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
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
2.33.0.685.g46640cef36-goog

