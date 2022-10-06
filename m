Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29D5F5DFF
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJFAp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJFAph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:45:37 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5D03ED7F
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:45:28 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-355ae0f4d3dso4077197b3.14
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KCatH2eHT7/5mI1zch6fVZ/CaNm/H7x84O4ctVrQdBM=;
        b=aTmaEH8j0hr0fqaSoWuhmNSPOZcc3S7bVLBCg7BCWyc/RhBb4HDtYG8k686FcYjOhh
         lSdI/ve6Zwbt+bKsGdctvay9z9O5eBnuaczc1iLomTYzRF+7iYIBn9wRQ1/xczECYN+j
         x3ZJUUtve+/fIBUmXsam32XNL+ie9P5OcRpsbTvfwmoITUX8xn6ABsNYR1D9AOTqdW1A
         Ge4iIiFkVX0QvdQHvdR5xp6SCqzILEEF/vnJdbXS3c+ex6UszWv8RuelYd3yrsFBs3je
         CKSAEhy8wsIyu/aRGUCKpnfYKpUwgnZ7l1z1e8ALZJ3OGc+FdEsTQUwWsFoPtMpi02rC
         kRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KCatH2eHT7/5mI1zch6fVZ/CaNm/H7x84O4ctVrQdBM=;
        b=fRSgbqu3YzKwS4MClE/8/cgNsn396gETqXcVc/TdUga0btZ3wQzAEzUmrpez/7KD+T
         BxKk/x/UVwYyNxY1E59ZQf40MHdmRyOVNh1Yp6ZhaMC1RZKIhizm8JnHCZb3qL3ysZEz
         DDYPyRbty3FCaFAzBGovllKL+9rRlQ7Q7yF+Rup2BEqFFz35lmNrBkQGfL+einHkfC5K
         maI4pF1GiW45piQU7QohrT76CrIti6VGs6P+4ah90J6BoCwFuiYO3jcAPvB8SUmzqOgX
         IGXZO2VDIswNLJd5Fi3sIxT4t5kBvam4O1UOTpenr+fHjeai5+2GrTrc7ShlcG1y+0A5
         PqXA==
X-Gm-Message-State: ACrzQf0vlDVnkSD63Iqw1seW9qW2jznP/BSKV0vTkJbrM/6CEIK31ZAO
        2ym3goWf2uEz/0RcILLdpTS3DTLolew=
X-Google-Smtp-Source: AMsMyM5Ljc/bq5g7GYkNzisAVo14HEUR1A2lErcNiPuRHKi7WkmVAQL8hcijU8XRhrYpj46emfAbBKLc8Bk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b745:0:b0:6b5:338b:f686 with SMTP id
 e5-20020a25b745000000b006b5338bf686mr2641561ybm.216.1665017127069; Wed, 05
 Oct 2022 17:45:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:45:12 +0000
In-Reply-To: <20221006004512.666529-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006004512.666529-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006004512.666529-8-seanjc@google.com>
Subject: [PATCH 7/7] KVM: selftests: Play nice with huge pages when getting PTEs/GPAs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Play nice with huge pages when getting PTEs and translating GVAs to GPAs,
there's no reason to disallow using huge pages in selftests.  Use
PG_LEVEL_NONE to indicate that the caller doesn't care about the mapping
level and just wants to get the pte+level.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 11 ++++-
 .../selftests/kvm/lib/x86_64/processor.c      | 45 ++++++++++++++++---
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 9676a3464758..e000e35c948f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -172,11 +172,16 @@ struct kvm_x86_cpu_feature {
 #define PTE_GLOBAL_MASK         BIT_ULL(8)
 #define PTE_NX_MASK             BIT_ULL(63)
 
+#define PHYSICAL_PAGE_MASK      GENMASK_ULL(51, 12)
+
 #define PAGE_SHIFT		12
 #define PAGE_SIZE		(1ULL << PAGE_SHIFT)
-#define PAGE_MASK		(~(PAGE_SIZE-1))
+#define PAGE_MASK		(~(PAGE_SIZE-1) & PHYSICAL_PAGE_MASK)
+
+#define HUGEPAGE_SHIFT(x)	(PAGE_SHIFT + (((x) - 1) * 9))
+#define HUGEPAGE_SIZE(x)	(1UL << HUGEPAGE_SHIFT(x))
+#define HUGEPAGE_MASK(x)	(~(HUGEPAGE_SIZE(x) - 1) & PHYSICAL_PAGE_MASK)
 
-#define PHYSICAL_PAGE_MASK      GENMASK_ULL(51, 12)
 #define PTE_GET_PA(pte)		((pte) & PHYSICAL_PAGE_MASK)
 #define PTE_GET_PFN(pte)        (PTE_GET_PA(pte) >> PAGE_SHIFT)
 
@@ -828,6 +833,8 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 
 bool kvm_is_tdp_enabled(void);
 
+uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
+				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 053f64191122..efa20d0f9927 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -245,10 +245,26 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
-uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
+static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
+{
+	if (*pte & PTE_LARGE_MASK) {
+		TEST_ASSERT(*level == PG_LEVEL_NONE ||
+			    *level == current_level,
+			    "Unexpected hugepage at level %d\n", current_level);
+		*level = current_level;
+	}
+
+	return *level == current_level;
+}
+
+uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
+				    int *level)
 {
 	uint64_t *pml4e, *pdpe, *pde;
 
+	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level < PG_LEVEL_NUM,
+		    "Invalid PG_LEVEL_* '%d'", *level);
+
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
@@ -263,18 +279,27 @@ uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
 		"Canonical check failed.  The virtual address is invalid.");
 
 	pml4e = virt_get_pte(vm, &vm->pgd, vaddr, PG_LEVEL_512G);
+	if (vm_is_target_pte(pml4e, level, PG_LEVEL_512G))
+		return pml4e;
 
 	pdpe = virt_get_pte(vm, pml4e, vaddr, PG_LEVEL_1G);
-	TEST_ASSERT(!(*pdpe & PTE_LARGE_MASK),
-		"Expected pdpe to map a pde not a 1-GByte page.");
+	if (vm_is_target_pte(pdpe, level, PG_LEVEL_1G))
+		return pdpe;
 
 	pde = virt_get_pte(vm, pdpe, vaddr, PG_LEVEL_2M);
-	TEST_ASSERT(!(*pde & PTE_LARGE_MASK),
-		"Expected pde to map a pte not a 2-MByte page.");
+	if (vm_is_target_pte(pde, level, PG_LEVEL_2M))
+		return pde;
 
 	return virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
 }
 
+uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
+{
+	int level = PG_LEVEL_4K;
+
+	return __vm_get_page_table_entry(vm, vaddr, &level);
+}
+
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	uint64_t *pml4e, *pml4e_start;
@@ -458,11 +483,17 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
 
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
-	uint64_t *pte = vm_get_page_table_entry(vm, gva);
+	int level = PG_LEVEL_NONE;
+	uint64_t *pte = __vm_get_page_table_entry(vm, gva, &level);
 
 	TEST_ASSERT(*pte & PTE_PRESENT_MASK,
 		    "Leaf PTE not PRESENT for gva: 0x%08lx", gva);
-	return PTE_GET_PA(*pte) | (gva & ~PAGE_MASK);
+
+	/*
+	 * No need for a hugepage mask on the PTE, x86-64 requires the "unused"
+	 * address bits to be zero.
+	 */
+	return PTE_GET_PA(*pte) | (gva & ~HUGEPAGE_MASK(level));
 }
 
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
-- 
2.38.0.rc1.362.ged0d419d3c-goog

