Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77875153D7
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380077AbiD2SnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359759AbiD2SnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:43:06 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521DDD64D1
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:47 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o6-20020a17090a420600b001d90365bda4so4434725pjg.1
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JX0jdNV+cZNA/oe+LeTeOjDC1enCtQmv3fKIlmN/wK4=;
        b=Qm3qvTeCJls+TSPV8ox/Gz/bz/j5AZRHojI4lIR44KXWxv5e8kP9Yti2kl26ohlzOV
         0RBDmQZMIYm9QXhpJ1AGIOi/LkQ8ZGTWT3ud5HaFZsBOwl/RlwYU+VJ1tL34/46M113B
         e9IIGX1mYSIy5rf8QkcmYuXvtfHvqRA3MKZEPpLO+K00y/7zfVIqbYpCJSdvU8naw8or
         bki1UYwq1Q9kqVKpu0xwmWnT39lENgzWxYh52MzrW8vGRpFXV6ESa39XcqrV+2rAJ+cB
         /Z6bAmbgsNIrttxOcwBYfI4EM/QxNNUKfKWLzBqCDHqCFAzMtkXHnMulWqAnWuJMGR1V
         Wpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JX0jdNV+cZNA/oe+LeTeOjDC1enCtQmv3fKIlmN/wK4=;
        b=FgOSfF1CA6il+otIhFdTSZLcofhDa3JFqjIqdBjDbwHuUYrMLk8sQjEL3HL1Py/tJK
         vbhGZwIXMZfgmInPtYP0Njvnthu/ogOLvjVa8CTyZhAJ9R+SMezV39rSNfsUmehLkXuc
         7taPL/xtOwqVrzo1XaJT564j8gyCIWuf0ybBshKb6Jpn9zhrZ83vyuU9+T6IsozlA0Qo
         pTzOM55OBTK+NYZEzzU5Zp6kdUpnwYBTui7lyBKLRjsmN31PaxpW7uvFLHcEznAVefaq
         6JqgIQw8rexiwPIhpSpz7lnk+vl99Tbg982wkyyPZjhyDu22UfUGDxUEegWAmmLFAvFk
         Djag==
X-Gm-Message-State: AOAM533cUG9UzU3c1DL8/1M19pyoDhE+pbJ6U26YAOwTGmgLAe1RUsaZ
        XA246wyFu6JqVBNtlnxn6VuXCujV0e6uYg==
X-Google-Smtp-Source: ABdhPJw8HErDPYBHSTjEqN48Ybr+ClfM5LBVrA+sgQDDUG6c44Yzhiy9+IL+OwNekJwUpjXPuOrFRYEwcoTIHA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:8215:0:b0:4f7:125a:c88c with SMTP id
 k21-20020aa78215000000b004f7125ac88cmr432877pfi.70.1651257586809; Fri, 29 Apr
 2022 11:39:46 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:39:28 +0000
In-Reply-To: <20220429183935.1094599-1-dmatlack@google.com>
Message-Id: <20220429183935.1094599-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 2/9] KVM: selftests: Add option to create 2M and 1G EPT mappings
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 105 ++++++++++---------
 1 file changed, 57 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index d089d8b850b5..1fa2d1059ade 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -392,27 +392,60 @@ void nested_vmx_check_supported(void)
 	}
 }
 
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr)
+static void nested_create_upper_pte(struct kvm_vm *vm,
+				    struct eptPageTableEntry *pte,
+				    uint64_t nested_paddr,
+				    uint64_t paddr,
+				    int current_level,
+				    int target_level)
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
+	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
+	struct eptPageTableEntry *pt;
 	uint16_t index[4];
-	struct eptPageTableEntry *pml4e;
 
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
@@ -423,49 +456,25 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	index[2] = (nested_paddr >> 30) & 0x1ffu;
 	index[3] = (nested_paddr >> 39) & 0x1ffu;
 
-	/* Allocate page directory pointer table if not present. */
-	pml4e = vmx->eptp_hva;
-	if (!pml4e[index[3]].readable) {
-		pml4e[index[3]].address = vm_alloc_page_table(vm) >> vm->page_shift;
-		pml4e[index[3]].writable = true;
-		pml4e[index[3]].readable = true;
-		pml4e[index[3]].executable = true;
-	}
+	pt = vmx->eptp_hva;
 
-	/* Allocate page directory table if not present. */
-	struct eptPageTableEntry *pdpe;
-	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
-	if (!pdpe[index[2]].readable) {
-		pdpe[index[2]].address = vm_alloc_page_table(vm) >> vm->page_shift;
-		pdpe[index[2]].writable = true;
-		pdpe[index[2]].readable = true;
-		pdpe[index[2]].executable = true;
-	}
+	for (int current_level = 3; current_level >= 0; current_level--) {
+		struct eptPageTableEntry *pte = &pt[index[current_level]];
 
-	/* Allocate page table if not present. */
-	struct eptPageTableEntry *pde;
-	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
-	if (!pde[index[1]].readable) {
-		pde[index[1]].address = vm_alloc_page_table(vm) >> vm->page_shift;
-		pde[index[1]].writable = true;
-		pde[index[1]].readable = true;
-		pde[index[1]].executable = true;
-	}
+		nested_create_upper_pte(vm, pte, nested_paddr, paddr,
+					current_level, target_level);
 
-	/* Fill in page table entry. */
-	struct eptPageTableEntry *pte;
-	pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
-	pte[index[0]].address = paddr >> vm->page_shift;
-	pte[index[0]].writable = true;
-	pte[index[0]].readable = true;
-	pte[index[0]].executable = true;
+		if (pte->page_size)
+			break;
 
-	/*
-	 * For now mark these as accessed and dirty because the only
-	 * testcase we have needs that.  Can be reconsidered later.
-	 */
-	pte[index[0]].accessed = true;
-	pte[index[0]].dirty = true;
+		pt = addr_gpa2hva(vm, pte->address * vm->page_size);
+	}
+}
+
+void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		   uint64_t nested_paddr, uint64_t paddr)
+{
+	__nested_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
 }
 
 /*
-- 
2.36.0.464.gb9c8b46e94-goog

