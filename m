Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC1552F638
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240142AbiETXdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354149AbiETXdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:01 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610AB1AB7B5
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:32:57 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s2-20020a17090302c200b00158ea215fa2so4723032plk.3
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3YnW/PaLyJgDTu61KobGsZ8UH0DNCazauPQKjEmJn0Q=;
        b=C97kavYd4fpevG4pJ4wjQloaKNU7HUuYB43iSNRjLiTy9rUtPh1fTOi3dxsiRr/XvZ
         KOnUIm2wrVVX9KYpelNOmr74727LmQ1oLmeanxG8lb5plfSZTmuQT9kF5LfO5Xw1TgKb
         o5hulL5BdzWI8g620RSMTk3vPoDtxAXGuIixFuZ4usknB9fQYLnK7lHofqtScxieKRte
         B7tl8YQSvya9/Y6CxYvw41abI3vWTP16MsKVPOc/8lmGiXaoRkZ6BszI68bzqrRAkkNX
         Eu+gpInnqduMxfYDHbnVSYGtvG/MBgI//9ReLVn8LYjqS7tXSYP6K11Rbscvx4kgQy1s
         TgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3YnW/PaLyJgDTu61KobGsZ8UH0DNCazauPQKjEmJn0Q=;
        b=eMLbWGr3ZmVktC2OVyBJ3bhsHBzMP6mwBR15HUpWp4CU7ityW6HKsuwT8bDXCXGKvI
         M7LgKdsk1EOtiw/Ljvkamh+NpiVONm+F8RPE2hTYQrDbYXHetheBoPhv74JjLwxW90Gz
         pZXo94lAhEYzrztYVatXG2P8VAnz72OSmId6htuR2ei0W36b8pzovOF/9DFTnyIE/PXt
         J8cRyIa3zT7+DV8k4BX6ZHqmKsLrsk8Xde2T5Sa2wM20JLSwVmcOiZPGDg6LnAPMFYYx
         b+Pmzn1vZ0rUO/SjrSbFSCNMx+p9j/KwGF2pvoJJWyPrhFe+sC4XZm2uCLoz49bZ+P/M
         awXg==
X-Gm-Message-State: AOAM530NIRBvAaQrXOCMxeWeRWhHlZSrKL70nUXNZ3K1SVDlLxuPm5pI
        CAXTONdoUycEhvtc94/WTn+UgisjwZPM0w==
X-Google-Smtp-Source: ABdhPJwmsbCwcd9CjIjBaaF0r9bvCjgfWubEcG5HwOuwGFK4kgtamME9+0F5jTQtQnKoe2yyWbu9MsA+TMbrCg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:8d83:b0:161:f4b3:6457 with SMTP
 id v3-20020a1709028d8300b00161f4b36457mr4822213plo.122.1653089576872; Fri, 20
 May 2022 16:32:56 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:40 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 02/11] KVM: selftests: Add option to create 2M and 1G EPT mappings
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

The current EPT mapping code in the selftests only supports mapping 4K
pages. This commit extends that support with an option to map at 2M or
1G. This will be used in a future commit to create large page mappings
to test eager page splitting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 110 ++++++++++---------
 1 file changed, 60 insertions(+), 50 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index d089d8b850b5..fdc1e6deb922 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -392,80 +392,90 @@ void nested_vmx_check_supported(void)
 	}
 }
 
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr)
+static void nested_create_pte(struct kvm_vm *vm,
+			      struct eptPageTableEntry *pte,
+			      uint64_t nested_paddr,
+			      uint64_t paddr,
+			      int current_level,
+			      int target_level)
+{
+	if (!pte->readable) {
+		pte->writable = true;
+		pte->readable = true;
+		pte->executable = true;
+		pte->page_size = (current_level == target_level);
+		if (pte->page_size)
+			pte->address = paddr >> vm->page_shift;
+		else
+			pte->address = vm_alloc_page_table(vm) >> vm->page_shift;
+	} else {
+		/*
+		 * Entry already present.  Assert that the caller doesn't want
+		 * a hugepage at this level, and that there isn't a hugepage at
+		 * this level.
+		 */
+		TEST_ASSERT(current_level != target_level,
+			    "Cannot create hugepage at level: %u, nested_paddr: 0x%lx\n",
+			    current_level, nested_paddr);
+		TEST_ASSERT(!pte->page_size,
+			    "Cannot create page table at level: %u, nested_paddr: 0x%lx\n",
+			    current_level, nested_paddr);
+	}
+}
+
+
+void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		     uint64_t nested_paddr, uint64_t paddr, int target_level)
 {
-	uint16_t index[4];
-	struct eptPageTableEntry *pml4e;
+	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
+	struct eptPageTableEntry *pt = vmx->eptp_hva, *pte;
+	uint16_t index;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		    "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
-	TEST_ASSERT((nested_paddr % vm->page_size) == 0,
+	TEST_ASSERT((nested_paddr % page_size) == 0,
 		    "Nested physical address not on page boundary,\n"
-		    "  nested_paddr: 0x%lx vm->page_size: 0x%x",
-		    nested_paddr, vm->page_size);
+		    "  nested_paddr: 0x%lx page_size: 0x%lx",
+		    nested_paddr, page_size);
 	TEST_ASSERT((nested_paddr >> vm->page_shift) <= vm->max_gfn,
 		    "Physical address beyond beyond maximum supported,\n"
 		    "  nested_paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		    paddr, vm->max_gfn, vm->page_size);
-	TEST_ASSERT((paddr % vm->page_size) == 0,
+	TEST_ASSERT((paddr % page_size) == 0,
 		    "Physical address not on page boundary,\n"
-		    "  paddr: 0x%lx vm->page_size: 0x%x",
-		    paddr, vm->page_size);
+		    "  paddr: 0x%lx page_size: 0x%lx",
+		    paddr, page_size);
 	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
 		    "Physical address beyond beyond maximum supported,\n"
 		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		    paddr, vm->max_gfn, vm->page_size);
 
-	index[0] = (nested_paddr >> 12) & 0x1ffu;
-	index[1] = (nested_paddr >> 21) & 0x1ffu;
-	index[2] = (nested_paddr >> 30) & 0x1ffu;
-	index[3] = (nested_paddr >> 39) & 0x1ffu;
-
-	/* Allocate page directory pointer table if not present. */
-	pml4e = vmx->eptp_hva;
-	if (!pml4e[index[3]].readable) {
-		pml4e[index[3]].address = vm_alloc_page_table(vm) >> vm->page_shift;
-		pml4e[index[3]].writable = true;
-		pml4e[index[3]].readable = true;
-		pml4e[index[3]].executable = true;
-	}
+	for (int level = PG_LEVEL_512G; level >= PG_LEVEL_4K; level--) {
+		index = (nested_paddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
+		pte = &pt[index];
 
-	/* Allocate page directory table if not present. */
-	struct eptPageTableEntry *pdpe;
-	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
-	if (!pdpe[index[2]].readable) {
-		pdpe[index[2]].address = vm_alloc_page_table(vm) >> vm->page_shift;
-		pdpe[index[2]].writable = true;
-		pdpe[index[2]].readable = true;
-		pdpe[index[2]].executable = true;
-	}
+		nested_create_pte(vm, pte, nested_paddr, paddr, level, target_level);
 
-	/* Allocate page table if not present. */
-	struct eptPageTableEntry *pde;
-	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
-	if (!pde[index[1]].readable) {
-		pde[index[1]].address = vm_alloc_page_table(vm) >> vm->page_shift;
-		pde[index[1]].writable = true;
-		pde[index[1]].readable = true;
-		pde[index[1]].executable = true;
-	}
+		if (pte->page_size)
+			break;
 
-	/* Fill in page table entry. */
-	struct eptPageTableEntry *pte;
-	pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
-	pte[index[0]].address = paddr >> vm->page_shift;
-	pte[index[0]].writable = true;
-	pte[index[0]].readable = true;
-	pte[index[0]].executable = true;
+		pt = addr_gpa2hva(vm, pte->address * vm->page_size);
+	}
 
 	/*
 	 * For now mark these as accessed and dirty because the only
 	 * testcase we have needs that.  Can be reconsidered later.
 	 */
-	pte[index[0]].accessed = true;
-	pte[index[0]].dirty = true;
+	pte->accessed = true;
+	pte->dirty = true;
+
+}
+
+void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		   uint64_t nested_paddr, uint64_t paddr)
+{
+	__nested_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
 }
 
 /*
-- 
2.36.1.124.g0e6072fb45-goog

