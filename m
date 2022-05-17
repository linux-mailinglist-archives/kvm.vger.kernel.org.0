Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49E752AB75
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352484AbiEQTFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349953AbiEQTFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:30 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46AE3F30C
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d125-20020a636883000000b003db5e24db27so25480pgc.13
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wYqtaE2fOJCw5qa6WHUEtvSbkPyRLrsFQ6NUPX8GobA=;
        b=NhsBar4v0DYt1jljvAhq1LFyG+jfdiPa0dEl45VzttN2jrZjTzfSmn8nPsI6HtcL0/
         nnR0Mc2QVvh/ZdS1cEBO1td9QWfw7s2mwvcc7mG+PO9x+l2PkL5GnVVvvY1lXiv9HW71
         1AZBOar18UB2GYl9/9hWeCy/iUaKzIEkHqs8aGU2CrV8M0PJ7kw9+BAJnNb+rSaPOO3K
         AFM1Pubmk4SQZdtPbvW6ZWyS09JUXmQheZA/YTCJ9WpFFE+FRzNtA9DQ7eVWqx4q0XQF
         HI6x4kBtdgXldU3qB+OVjU+vZMoUFimt1zgQdKtMLKiRyzTy0PWYCHyDML4rRzg/SCJc
         iCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wYqtaE2fOJCw5qa6WHUEtvSbkPyRLrsFQ6NUPX8GobA=;
        b=Pko4/BXkjOwx7Fxnww3eoddDUNEc+DPNFCNy/uA8oSLXLmzwGAXNiOvSM2kEf6ZlS6
         qTvh8sCCddaeweMqHRucfp28Yzaqu9RR4Yaj3km533hiBd7R5P7tyGnTckU40uJ7dFPI
         ZCxPxaG7z9kvKXefemk2FfFaKF9ehPdTAxQzJ5B+oNl5jTpt3FbLnkW3x+JV5YfRtnXS
         CkIO5vGePHIRM8hVJr4M4L+Dyr6WtUeqUNqItIE+tgeB3WYlPEmA6IMn4n50iS+BzcM5
         2ex7mEL5AWN37qqc3slVaJOoj4cOFzZHgTnIIbTGl6I+qP0QMJu0Svub1c4b7IKXUBwS
         Vb5w==
X-Gm-Message-State: AOAM532PVi8AmiJcrcIQgpuBP8Cfa+hHgd77bCU2FcRaKEG65DnzOqJw
        I0w4N5TIdPrJwd/gYnuRufuhq73D584N8g==
X-Google-Smtp-Source: ABdhPJzz/EvdkQBDTKdh/Qmv12QsPAnoMDBz9xJ46kF1gPt+DP7h5p65oOFZRVowSWYmMfumeL2BUQqfzj4uaQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:a383:b0:161:8397:b493 with SMTP
 id x3-20020a170902a38300b001618397b493mr10236919pla.127.1652814329151; Tue,
 17 May 2022 12:05:29 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:16 +0000
In-Reply-To: <20220517190524.2202762-1-dmatlack@google.com>
Message-Id: <20220517190524.2202762-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 02/10] KVM: selftests: Add option to create 2M and 1G EPT mappings
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
2.36.0.550.gb090851708-goog

