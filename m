Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F249E5F5DF8
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJFApg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJFAp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:45:26 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E503472C
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:45:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-358c893992cso4188757b3.9
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=O9zzrj71ODVbYnDDy0jgcppAPNlAGvICv+49NEPzfnc=;
        b=T7fZJpEtTKXswD5xBDEOcbcqIcbwV/sOO5vof+HNmR2ccgYgCsO8T/Ius86GqGKXhK
         xR9N44ahLs/WTA+YZEpBXjj3UCBOK1TPrvpbSskAL3B3d+yH9bH90gOto1f5at9YLKMU
         LmdtODgF8Q9q7zqIEBFD2w8T+elZY0DG/rOQnlIbZ6xAOiOenlPYd51Hwy3GPqQydAvk
         58xLCdiXuNFJny73eEVWOR+8H+UYL0Kqxkfku1HlH/9AlWXkpNUyZzA/FgXItikVJH2o
         ygVcWDK+4dKvAdl8tHwBfPdIJHxtZxpNSzPYUWg0zJMJuTIiY9xcCxsdrvZ0XMzEjdDL
         7D6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O9zzrj71ODVbYnDDy0jgcppAPNlAGvICv+49NEPzfnc=;
        b=HdbbAuETkRWe+9p23D6JmY7b8HsKfVsWNAKM3ZsaGecgaexeheeh17QRVQ8YjC21wL
         ci1uTeGCBdnYg3eNMoRSXr/rLVoFFfF4JiQWjvQRRYDx9y1x2AVbVEER9qYsy6o4ULgN
         zHHCoWNihoBsqUYr51eAbCAgbv4ub0p0opoRuDSqcH2ha9bOx7BKNT1YvufxtAvVo0Te
         KcUdJplZDvzepy7G4abKIE1EVT4bI5bx+if9T8XdQH+zOl2hEh+d5ppu9W4M6gYts+4o
         YeO1pJT7VfnnBymXMVkA1JRdO3IrQjipXLUk3qNFktZ67tmQUbVL6H0JbaqYmAiwQ4F8
         NuyQ==
X-Gm-Message-State: ACrzQf2hy8KWQuzhv1kBXjjUz6f9ev3Yt2DGGGkjCBKQ4ksRvn/Gc2bL
        tEHqsmLg7shKa+na5G8dzCORc137pCU=
X-Google-Smtp-Source: AMsMyM502IFVAOparPEReWGXDNORaqkAt7oRbWwqkLa1VFUFBkwdimgEWhHLPrSKL14nSIv2PLQIrg+4AgA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:5a42:0:b0:35d:80ee:eb7d with SMTP id
 o63-20020a815a42000000b0035d80eeeb7dmr2351119ywb.272.1665017120735; Wed, 05
 Oct 2022 17:45:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:45:08 +0000
In-Reply-To: <20221006004512.666529-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006004512.666529-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006004512.666529-4-seanjc@google.com>
Subject: [PATCH 3/7] KVM: selftests: Remove useless shifts when creating guest
 page tables
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

Remove the pointless shift from GPA=>GFN and immediately back to
GFN=>GPA when creating guest page tables.  Ignore the other walkers
that have a similar pattern for the moment, they will be converted
to use virt_get_pte() in the near future.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h    |  3 ++-
 .../selftests/kvm/lib/x86_64/processor.c        | 17 ++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 53d52a5ace48..9676a3464758 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -177,7 +177,8 @@ struct kvm_x86_cpu_feature {
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
 #define PHYSICAL_PAGE_MASK      GENMASK_ULL(51, 12)
-#define PTE_GET_PFN(pte)        (((pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
+#define PTE_GET_PA(pte)		((pte) & PHYSICAL_PAGE_MASK)
+#define PTE_GET_PFN(pte)        (PTE_GET_PA(pte) >> PAGE_SHIFT)
 
 /* General Registers in 64-Bit Mode */
 struct gpr64_regs {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9e196837a794..324bf24564a1 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -131,23 +131,23 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-static void *virt_get_pte(struct kvm_vm *vm, uint64_t pt_pfn, uint64_t vaddr,
+static void *virt_get_pte(struct kvm_vm *vm, uint64_t pt_gpa, uint64_t vaddr,
 			  int level)
 {
-	uint64_t *page_table = addr_gpa2hva(vm, pt_pfn << vm->page_shift);
+	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
 	return &page_table[index];
 }
 
 static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
-				       uint64_t pt_pfn,
+				       uint64_t pt_gpa,
 				       uint64_t vaddr,
 				       uint64_t paddr,
 				       int current_level,
 				       int target_level)
 {
-	uint64_t *pte = virt_get_pte(vm, pt_pfn, vaddr, current_level);
+	uint64_t *pte = virt_get_pte(vm, pt_gpa, vaddr, current_level);
 
 	if (!(*pte & PTE_PRESENT_MASK)) {
 		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
@@ -197,21 +197,20 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
 	 */
-	pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift,
-				      vaddr, paddr, PG_LEVEL_512G, level);
+	pml4e = virt_create_upper_pte(vm, vm->pgd, vaddr, paddr, PG_LEVEL_512G, level);
 	if (*pml4e & PTE_LARGE_MASK)
 		return;
 
-	pdpe = virt_create_upper_pte(vm, PTE_GET_PFN(*pml4e), vaddr, paddr, PG_LEVEL_1G, level);
+	pdpe = virt_create_upper_pte(vm, PTE_GET_PA(*pml4e), vaddr, paddr, PG_LEVEL_1G, level);
 	if (*pdpe & PTE_LARGE_MASK)
 		return;
 
-	pde = virt_create_upper_pte(vm, PTE_GET_PFN(*pdpe), vaddr, paddr, PG_LEVEL_2M, level);
+	pde = virt_create_upper_pte(vm, PTE_GET_PA(*pdpe), vaddr, paddr, PG_LEVEL_2M, level);
 	if (*pde & PTE_LARGE_MASK)
 		return;
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, PTE_GET_PFN(*pde), vaddr, PG_LEVEL_4K);
+	pte = virt_get_pte(vm, PTE_GET_PA(*pde), vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

