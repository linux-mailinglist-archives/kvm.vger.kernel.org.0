Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F17F3B0E4A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhFVUJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhFVUIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:46 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4F0C0611C3
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:16 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id t144-20020a3746960000b02903ad9c5e94baso19384103qka.16
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4es5xYXrARN+tNxb/9lvWy7uMZX89sleaLly9UWN6t4=;
        b=YFNkzev8vT9agbQvYkkUfAiLi+lfarOBz5FFNDJ5/tY91W0J2ys66oucuvIsvEAzgY
         CG9DX9JVFZW9yYVpYIS8lNb9bmd+P7OoSAbjr0Zphnp0UsvdSeTFg9cd+cgixuzUQUcZ
         0uC8spDH/cfHaM1v2F6HviYieOuDV3ClCSVxg3PDdfy66ShABbPvvluGQBKCAx9uJ+DN
         gsExwtWzLX8Ks4yi02TiRSMTH1U9Gwybw3VgvsTC3777dZaR1OHiZ4/+rUzPaF87Ihiq
         in4jdWijxVhHeBd8xBNnopJjcUt54NQZ9wkALApISNRyxEgKGRz4gCxfNBgLBKaThN+e
         lA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4es5xYXrARN+tNxb/9lvWy7uMZX89sleaLly9UWN6t4=;
        b=CUVktBvWlb7RrfNYBpDuTJ8QXMcSjnnNV8B35nZOMvclKBihjj0iEl/9El/ekPhtv5
         ZVGOyjn0yqcs+MItX3FYTQF10ehl9heuLw3J0I29v0GalvSyWGAuqmSgF1nzHu4zq2OV
         UeccOGP/IoymuvxfBvoJ/Y7ROpQ0VgY1Yj8X3bkggSqTXBTlS5o8jXV0T5MU/J3zLcCb
         oNrVHomnO1WeuoVUpGUhbfaQWNUITuaA5WZ3QepafKBRQGvwWZHQWO8E80GGYY2rgnw9
         wWt+9sXo8Ezoxd+/j0/Dp1RZPa43gxVCihWrZXYENvRGzj8j36/QdfFRnmpNZkrPpjfO
         em+g==
X-Gm-Message-State: AOAM5307dr/K9vb24Ah6myGMyT/oSMG+Gz/oDuGm0R/R+NAfh6atpsdK
        ewkqMTwlIHPeb1DHVM/lN986thrsyDk=
X-Google-Smtp-Source: ABdhPJyvxMUAyMP9Ke2GvBEpQ9sMHXByo58xc4QtcfNCzzI9qnUmgWgRDHpjr/Ddo8N9wsaTcvhvihYaS38=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:cc0a:: with SMTP id l10mr6995644ybf.356.1624392375340;
 Tue, 22 Jun 2021 13:06:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:26 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-17-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 16/19] KVM: selfests: Add PTE helper for x86-64 in preparation
 for hugepages
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to retrieve a PTE pointer given a PFN, address, and level
in preparation for adding hugepage support.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 59 ++++++++++---------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 50cb78e15078..cd111093f018 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -216,10 +216,21 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
+static void *virt_get_pte(struct kvm_vm *vm, uint64_t pt_pfn, uint64_t vaddr,
+			  int level)
+{
+	uint64_t *page_table = addr_gpa2hva(vm, pt_pfn << vm->page_shift);
+	int index = vaddr >> (vm->page_shift + level * 9) & 0x1ffu;
+
+	return &page_table[index];
+}
+
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	uint16_t index[4];
 	struct pageMapL4Entry *pml4e;
+	struct pageDirectoryPointerEntry *pdpe;
+	struct pageDirectoryEntry *pde;
+	struct pageTableEntry *pte;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -241,43 +252,35 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		paddr, vm->max_gfn, vm->page_size);
 
-	index[0] = (vaddr >> 12) & 0x1ffu;
-	index[1] = (vaddr >> 21) & 0x1ffu;
-	index[2] = (vaddr >> 30) & 0x1ffu;
-	index[3] = (vaddr >> 39) & 0x1ffu;
-
 	/* Allocate page directory pointer table if not present. */
-	pml4e = addr_gpa2hva(vm, vm->pgd);
-	if (!pml4e[index[3]].present) {
-		pml4e[index[3]].pfn = vm_alloc_page_table(vm) >> vm->page_shift;
-		pml4e[index[3]].writable = true;
-		pml4e[index[3]].present = true;
+	pml4e = virt_get_pte(vm, vm->pgd >> vm->page_shift, vaddr, 3);
+	if (!pml4e->present) {
+		pml4e->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
+		pml4e->writable = true;
+		pml4e->present = true;
 	}
 
 	/* Allocate page directory table if not present. */
-	struct pageDirectoryPointerEntry *pdpe;
-	pdpe = addr_gpa2hva(vm, pml4e[index[3]].pfn * vm->page_size);
-	if (!pdpe[index[2]].present) {
-		pdpe[index[2]].pfn = vm_alloc_page_table(vm) >> vm->page_shift;
-		pdpe[index[2]].writable = true;
-		pdpe[index[2]].present = true;
+	pdpe = virt_get_pte(vm, pml4e->pfn, vaddr, 2);
+	if (!pdpe->present) {
+		pdpe->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
+		pdpe->writable = true;
+		pdpe->present = true;
 	}
 
 	/* Allocate page table if not present. */
-	struct pageDirectoryEntry *pde;
-	pde = addr_gpa2hva(vm, pdpe[index[2]].pfn * vm->page_size);
-	if (!pde[index[1]].present) {
-		pde[index[1]].pfn = vm_alloc_page_table(vm) >> vm->page_shift;
-		pde[index[1]].writable = true;
-		pde[index[1]].present = true;
+	pde = virt_get_pte(vm, pdpe->pfn, vaddr, 1);
+	if (!pde->present) {
+		pde->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
+		pde->writable = true;
+		pde->present = true;
 	}
 
 	/* Fill in page table entry. */
-	struct pageTableEntry *pte;
-	pte = addr_gpa2hva(vm, pde[index[1]].pfn * vm->page_size);
-	pte[index[0]].pfn = paddr >> vm->page_shift;
-	pte[index[0]].writable = true;
-	pte[index[0]].present = 1;
+	pte = virt_get_pte(vm, pde->pfn, vaddr, 0);
+	pte->pfn = paddr >> vm->page_shift;
+	pte->writable = true;
+	pte->present = 1;
 }
 
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
-- 
2.32.0.288.g62a8d224e6-goog

