Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D593B0E48
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhFVUJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbhFVUIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:46 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092CEC06121D
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:14 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id eb2-20020ad44e420000b029025a58adfc6bso326008qvb.9
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LQ7cDRNQ0IvnYA0VYL5hK2rgq5Ky9LLK9rEW1UP7T5g=;
        b=YkHKOUUIB+Z7tGQ94/93eTG/Q7WcB9OPfz6OZJJd8mE0GdxIF+4t4Cx6NrNl1FpRLy
         tWtb2Nya+Z5Wx7kPB6ff5KYleL6fDSUpmFcGW93s2K3JaYZL6DIIw1ztVMI4Q2p8H02E
         spaTmZCT0Ett3caxehRh71nnv2XBuJWexttdc1BEf6oK6piCTT7rcfSXq9qsG0jZ6RB0
         nwujMF1zcI98gZl3rRVQUyNVWts4y/swWUxuGSjhiNA+6G535Z7u7L+YPqH3c08AmIrM
         BGKY7uifkqStKJ0GKWuX20jIxlYakoFyPf+hTHvSEOIjZVpWmqD/iFjzpi7wXaKMo0MQ
         ahcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LQ7cDRNQ0IvnYA0VYL5hK2rgq5Ky9LLK9rEW1UP7T5g=;
        b=RbHIi36owCeerG5dNz9ysKrChsER46alBNOYI2MBSWTcckcqy6+lVfE0iiE4lo92+Y
         z4XcIcUiSuPoPmB7U7IGXmzJoOLLeobLLmLd9vUoTVpNADUZxS2wu5aK+y90sqXezcJq
         SDyp8yabfurPY2JN5NyHyYvNVduAR7x4Sol53nOmqcZZkWs2VY7ekGLbigBMSIIZLc6g
         x8EC0hfNm19nYPRw2Vj6+u0i/2HUKhTHlkhMj5GQyC+FTK3ApOR3iMZd9wezncrycw4n
         Iwgp8IH2pyYfnHngBkcqD1SiKR3BNpeI0CDUivZAwF3OwxDFvImFSA7UM9vPXHn/d5KE
         8drg==
X-Gm-Message-State: AOAM530V6WEJRGjwNHQ6U03uZ6MAHrQmj9aWj3gC/d6MlnocauK1547E
        rCbnErr0dQpqXhG8C5mMkQj1rPnpysI=
X-Google-Smtp-Source: ABdhPJxD49e49apdkQN2604ea1Q0G3GHDtgETqeRrkZr7pAWbQkTJI94V8jBN8N+X5vWHj+oLqchh6x0Fkw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:6f56:: with SMTP id k83mr7619230ybc.281.1624392373158;
 Tue, 22 Jun 2021 13:06:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:25 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 15/19] KVM: selftests: Rename x86's page table "address" to "pfn"
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

Rename the "address" field to "pfn" in x86's page table structs to match
reality.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 47 +++++++++----------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 1e7ea77502cf..50cb78e15078 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -30,7 +30,7 @@ struct pageMapL4Entry {
 	uint64_t ignored_06:1;
 	uint64_t page_size:1;
 	uint64_t ignored_11_08:4;
-	uint64_t address:40;
+	uint64_t pfn:40;
 	uint64_t ignored_62_52:11;
 	uint64_t execute_disable:1;
 };
@@ -45,7 +45,7 @@ struct pageDirectoryPointerEntry {
 	uint64_t ignored_06:1;
 	uint64_t page_size:1;
 	uint64_t ignored_11_08:4;
-	uint64_t address:40;
+	uint64_t pfn:40;
 	uint64_t ignored_62_52:11;
 	uint64_t execute_disable:1;
 };
@@ -60,7 +60,7 @@ struct pageDirectoryEntry {
 	uint64_t ignored_06:1;
 	uint64_t page_size:1;
 	uint64_t ignored_11_08:4;
-	uint64_t address:40;
+	uint64_t pfn:40;
 	uint64_t ignored_62_52:11;
 	uint64_t execute_disable:1;
 };
@@ -76,7 +76,7 @@ struct pageTableEntry {
 	uint64_t reserved_07:1;
 	uint64_t global:1;
 	uint64_t ignored_11_09:3;
-	uint64_t address:40;
+	uint64_t pfn:40;
 	uint64_t ignored_62_52:11;
 	uint64_t execute_disable:1;
 };
@@ -249,33 +249,33 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	/* Allocate page directory pointer table if not present. */
 	pml4e = addr_gpa2hva(vm, vm->pgd);
 	if (!pml4e[index[3]].present) {
-		pml4e[index[3]].address = vm_alloc_page_table(vm) >> vm->page_shift;
+		pml4e[index[3]].pfn = vm_alloc_page_table(vm) >> vm->page_shift;
 		pml4e[index[3]].writable = true;
 		pml4e[index[3]].present = true;
 	}
 
 	/* Allocate page directory table if not present. */
 	struct pageDirectoryPointerEntry *pdpe;
-	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
+	pdpe = addr_gpa2hva(vm, pml4e[index[3]].pfn * vm->page_size);
 	if (!pdpe[index[2]].present) {
-		pdpe[index[2]].address = vm_alloc_page_table(vm) >> vm->page_shift;
+		pdpe[index[2]].pfn = vm_alloc_page_table(vm) >> vm->page_shift;
 		pdpe[index[2]].writable = true;
 		pdpe[index[2]].present = true;
 	}
 
 	/* Allocate page table if not present. */
 	struct pageDirectoryEntry *pde;
-	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
+	pde = addr_gpa2hva(vm, pdpe[index[2]].pfn * vm->page_size);
 	if (!pde[index[1]].present) {
-		pde[index[1]].address = vm_alloc_page_table(vm) >> vm->page_shift;
+		pde[index[1]].pfn = vm_alloc_page_table(vm) >> vm->page_shift;
 		pde[index[1]].writable = true;
 		pde[index[1]].present = true;
 	}
 
 	/* Fill in page table entry. */
 	struct pageTableEntry *pte;
-	pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
-	pte[index[0]].address = paddr >> vm->page_shift;
+	pte = addr_gpa2hva(vm, pde[index[1]].pfn * vm->page_size);
+	pte[index[0]].pfn = paddr >> vm->page_shift;
 	pte[index[0]].writable = true;
 	pte[index[0]].present = 1;
 }
@@ -305,11 +305,10 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 			" %u\n",
 			indent, "",
 			pml4e - pml4e_start, pml4e,
-			addr_hva2gpa(vm, pml4e), (uint64_t) pml4e->address,
+			addr_hva2gpa(vm, pml4e), (uint64_t) pml4e->pfn,
 			pml4e->writable, pml4e->execute_disable);
 
-		pdpe_start = addr_gpa2hva(vm, pml4e->address
-			* vm->page_size);
+		pdpe_start = addr_gpa2hva(vm, pml4e->pfn * vm->page_size);
 		for (uint16_t n2 = 0; n2 <= 0x1ffu; n2++) {
 			pdpe = &pdpe_start[n2];
 			if (!pdpe->present)
@@ -319,11 +318,10 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 				indent, "",
 				pdpe - pdpe_start, pdpe,
 				addr_hva2gpa(vm, pdpe),
-				(uint64_t) pdpe->address, pdpe->writable,
+				(uint64_t) pdpe->pfn, pdpe->writable,
 				pdpe->execute_disable);
 
-			pde_start = addr_gpa2hva(vm,
-				pdpe->address * vm->page_size);
+			pde_start = addr_gpa2hva(vm, pdpe->pfn * vm->page_size);
 			for (uint16_t n3 = 0; n3 <= 0x1ffu; n3++) {
 				pde = &pde_start[n3];
 				if (!pde->present)
@@ -332,11 +330,10 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 					"0x%-12lx 0x%-10lx %u  %u\n",
 					indent, "", pde - pde_start, pde,
 					addr_hva2gpa(vm, pde),
-					(uint64_t) pde->address, pde->writable,
+					(uint64_t) pde->pfn, pde->writable,
 					pde->execute_disable);
 
-				pte_start = addr_gpa2hva(vm,
-					pde->address * vm->page_size);
+				pte_start = addr_gpa2hva(vm, pde->pfn * vm->page_size);
 				for (uint16_t n4 = 0; n4 <= 0x1ffu; n4++) {
 					pte = &pte_start[n4];
 					if (!pte->present)
@@ -347,7 +344,7 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 						indent, "",
 						pte - pte_start, pte,
 						addr_hva2gpa(vm, pte),
-						(uint64_t) pte->address,
+						(uint64_t) pte->pfn,
 						pte->writable,
 						pte->execute_disable,
 						pte->dirty,
@@ -487,19 +484,19 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	if (!pml4e[index[3]].present)
 		goto unmapped_gva;
 
-	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
+	pdpe = addr_gpa2hva(vm, pml4e[index[3]].pfn * vm->page_size);
 	if (!pdpe[index[2]].present)
 		goto unmapped_gva;
 
-	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
+	pde = addr_gpa2hva(vm, pdpe[index[2]].pfn * vm->page_size);
 	if (!pde[index[1]].present)
 		goto unmapped_gva;
 
-	pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
+	pte = addr_gpa2hva(vm, pde[index[1]].pfn * vm->page_size);
 	if (!pte[index[0]].present)
 		goto unmapped_gva;
 
-	return (pte[index[0]].address * vm->page_size) + (gva & 0xfffu);
+	return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-- 
2.32.0.288.g62a8d224e6-goog

