Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12B0460DC2
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 04:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377595AbhK2DuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 22:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377230AbhK2DsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 22:48:12 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E079AC0613FD
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 19:43:53 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so14406377pju.3
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 19:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1E5J112/KKe5nzfIjRapghLBkhpzMa3/YxcaryPQAAY=;
        b=CPZyN1kOZxK9jC2nDgnbHL1qPOcAxvPYZ4/Ldp15ZFP8LQUMl5fThYRqCxYekmI+Ti
         jaGDXmQRNigPBEiMxuYtVffQzOSXSTMZfCgxkkTeXS6mHjhsZzo3h+r10/68GkCXPnC9
         CxPtfq+6DPfEA6ybJRpLeLHrmjDI7ysst1V7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1E5J112/KKe5nzfIjRapghLBkhpzMa3/YxcaryPQAAY=;
        b=djZ0hRZyyhNi5D5Odr6Zfzw0pXx6JMUx1pWbMIiqApEYDzZmpaVIOujRr9JhjOxo4U
         PE3fu1C23k9Dhiyhumry8UFGUmZA3jQVnhPHPqmt3GpGsmxVVkUxfE5rSG8227djopHF
         8ybzTdtG7PABourMsWkR47N1WqKZrzaoZwKGebf4PBCPH96NLUn12cSEAPgElGfG5KPD
         amdiTq4cZwiibCG8hbn+lepojBF639YJA779CfaHkkM1X58pUOfGDkKgf5pRqyk3WhKC
         Fv5BvRIn/rZXjjhgWdizeZqTc7M6JvUUTnPCUUaactinPruw8B68TYQCdPY35zLAdSdL
         5TfQ==
X-Gm-Message-State: AOAM5320HZ0yux8pXy+5WKFaoIFiV4qK6X/2oRK63bLMjatZROiflfQg
        FtBkUy0WbgxY0iokcCobunPH2w==
X-Google-Smtp-Source: ABdhPJzR1mYlqKwgxgr65ZpLjYIw4Q3tENBbFuvuJ6S4uxpSlpvxqFbVGGaQXv+7du9DJSv52f6+mQ==
X-Received: by 2002:a17:90a:e506:: with SMTP id t6mr34337394pjy.9.1638157433470;
        Sun, 28 Nov 2021 19:43:53 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:72d1:80f6:e1c9:ed0a])
        by smtp.gmail.com with UTF8SMTPSA id h13sm14337804pfv.84.2021.11.28.19.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 19:43:53 -0800 (PST)
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
Subject: [PATCH v5 3/4] KVM: arm64/mmu: use gfn_to_pfn_page
Date:   Mon, 29 Nov 2021 12:43:16 +0900
Message-Id: <20211129034317.2964790-4-stevensd@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129034317.2964790-1-stevensd@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
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
index 326cdfec74a1..197fb8afbb94 100644
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
2.34.0.rc2.393.gf8c9666880-goog

