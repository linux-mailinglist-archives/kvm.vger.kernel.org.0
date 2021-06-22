Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19053B0E4C
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhFVUJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbhFVUI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:59 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D4AC061148
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:18 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 14-20020a37060e0000b02903aad32851d2so19483377qkg.1
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=F+aDoisUMv9FYrbslXchYMKlLTnuu7gQs66W2KkrMGA=;
        b=FZQMZisqKzCjlft81h/1+2T0bJqreCcmsOl+x4GP+BkrxqKR4t/LE/xFyDfKH3c1dF
         1t1+NamqFMWM/DlbmxoUZN7fxyKBzm2fmVbNdRHTcrOS4/xd37wCmKzyRgMEaG5OUYyz
         uDipEGcIdXluOJdCnbSbIG40Pl/DM78BR0kkA7GKCitDGnoBayzBvItk+1hgibfJpx5v
         wZHkBOVlWG7BYwbMZ0GrB0ijN7znUWYtwnu9Co+zASZV5G/VopfjDS52sN3dKdB/wynD
         At9C673YzPI0D/e4osrkomCn5kfZsNlHh/IsmhAvvCWe162iHPDOe0Oo3GO04hsrdDE+
         dhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=F+aDoisUMv9FYrbslXchYMKlLTnuu7gQs66W2KkrMGA=;
        b=KjxlY7SSet20fLZYTLwyMHKxF846U1inoqOl8prgEOEtDHDDFrpEhqfxiZathK0O8K
         /zOx18loukg3tqcvFPNwDoZpbkjzpvgRZtG8iksLdiiOXVTkbVPfA8CUj+hhKGZoMxF5
         bnx51HvlkunsG6WNwyaiEdZuWHSCXdC1Tgrim09QVcFuSvL/jJNhflJiOdNY8DpXSz2m
         FxEYlDi99Z1C6hnRECCh3p9QTPt/97yWsGtq2GbdmmsyRsNOgOcErc5zPujDEz4oca17
         bOWWYLywycrFU9RKxGAo0Jv/iItD3qJzosidv3KkKnwPFc6ZmM+jExvjo7gYqFmK74jv
         8KAw==
X-Gm-Message-State: AOAM531Fhl1NyAdy74suQgSPNJqJS4sESWCBqERz0ojzMKxZRgNoHf96
        usOhLJ8Ee8kKBC7zYHzc17fDiGGRyqk=
X-Google-Smtp-Source: ABdhPJzBAHtFkgRlqbbouW+RMXTItYUICJmvNy5tlSiW1+Tn2EGirIP/8N0SscihAZsDi7agVp6KaPH0Nlc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:c70e:: with SMTP id w14mr7615002ybe.94.1624392377639;
 Tue, 22 Jun 2021 13:06:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:27 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-18-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 17/19] KVM: selftests: Genericize upper level page table entry struct
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

In preparation for adding hugepage support, replace "pageMapL4Entry",
"pageDirectoryPointerEntry", and "pageDirectoryEntry" with a common
"pageUpperEntry", and add a helper to create an upper level entry. All
upper level entries have the same layout, using unique structs provides
minimal value and requires a non-trivial amount of code duplication.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 91 ++++++-------------
 1 file changed, 26 insertions(+), 65 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index cd111093f018..cc2483db47a9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -20,37 +20,7 @@
 vm_vaddr_t exception_handlers;
 
 /* Virtual translation table structure declarations */
-struct pageMapL4Entry {
-	uint64_t present:1;
-	uint64_t writable:1;
-	uint64_t user:1;
-	uint64_t write_through:1;
-	uint64_t cache_disable:1;
-	uint64_t accessed:1;
-	uint64_t ignored_06:1;
-	uint64_t page_size:1;
-	uint64_t ignored_11_08:4;
-	uint64_t pfn:40;
-	uint64_t ignored_62_52:11;
-	uint64_t execute_disable:1;
-};
-
-struct pageDirectoryPointerEntry {
-	uint64_t present:1;
-	uint64_t writable:1;
-	uint64_t user:1;
-	uint64_t write_through:1;
-	uint64_t cache_disable:1;
-	uint64_t accessed:1;
-	uint64_t ignored_06:1;
-	uint64_t page_size:1;
-	uint64_t ignored_11_08:4;
-	uint64_t pfn:40;
-	uint64_t ignored_62_52:11;
-	uint64_t execute_disable:1;
-};
-
-struct pageDirectoryEntry {
+struct pageUpperEntry {
 	uint64_t present:1;
 	uint64_t writable:1;
 	uint64_t user:1;
@@ -225,11 +195,24 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t pt_pfn, uint64_t vaddr,
 	return &page_table[index];
 }
 
+static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
+						    uint64_t pt_pfn,
+						    uint64_t vaddr,
+						    int level)
+{
+	struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, level);
+
+	if (!pte->present) {
+		pte->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
+		pte->writable = true;
+		pte->present = true;
+	}
+	return pte;
+}
+
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	struct pageMapL4Entry *pml4e;
-	struct pageDirectoryPointerEntry *pdpe;
-	struct pageDirectoryEntry *pde;
+	struct pageUpperEntry *pml4e, *pdpe, *pde;
 	struct pageTableEntry *pte;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
@@ -252,29 +235,10 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		paddr, vm->max_gfn, vm->page_size);
 
-	/* Allocate page directory pointer table if not present. */
-	pml4e = virt_get_pte(vm, vm->pgd >> vm->page_shift, vaddr, 3);
-	if (!pml4e->present) {
-		pml4e->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
-		pml4e->writable = true;
-		pml4e->present = true;
-	}
-
-	/* Allocate page directory table if not present. */
-	pdpe = virt_get_pte(vm, pml4e->pfn, vaddr, 2);
-	if (!pdpe->present) {
-		pdpe->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
-		pdpe->writable = true;
-		pdpe->present = true;
-	}
-
-	/* Allocate page table if not present. */
-	pde = virt_get_pte(vm, pdpe->pfn, vaddr, 1);
-	if (!pde->present) {
-		pde->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
-		pde->writable = true;
-		pde->present = true;
-	}
+	/* Allocate upper level page tables, if not already present. */
+	pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift, vaddr, 3);
+	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, 2);
+	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, 1);
 
 	/* Fill in page table entry. */
 	pte = virt_get_pte(vm, pde->pfn, vaddr, 0);
@@ -285,9 +249,9 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
-	struct pageMapL4Entry *pml4e, *pml4e_start;
-	struct pageDirectoryPointerEntry *pdpe, *pdpe_start;
-	struct pageDirectoryEntry *pde, *pde_start;
+	struct pageUpperEntry *pml4e, *pml4e_start;
+	struct pageUpperEntry *pdpe, *pdpe_start;
+	struct pageUpperEntry *pde, *pde_start;
 	struct pageTableEntry *pte, *pte_start;
 
 	if (!vm->pgd_created)
@@ -298,8 +262,7 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	fprintf(stream, "%*s      index hvaddr         gpaddr         "
 		"addr         w exec dirty\n",
 		indent, "");
-	pml4e_start = (struct pageMapL4Entry *) addr_gpa2hva(vm,
-		vm->pgd);
+	pml4e_start = (struct pageUpperEntry *) addr_gpa2hva(vm, vm->pgd);
 	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
 		pml4e = &pml4e_start[n1];
 		if (!pml4e->present)
@@ -468,9 +431,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
 vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint16_t index[4];
-	struct pageMapL4Entry *pml4e;
-	struct pageDirectoryPointerEntry *pdpe;
-	struct pageDirectoryEntry *pde;
+	struct pageUpperEntry *pml4e, *pdpe, *pde;
 	struct pageTableEntry *pte;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
-- 
2.32.0.288.g62a8d224e6-goog

