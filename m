Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3132C3B0F21
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhFVVD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhFVVD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:27 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C86C061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:11 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id r190-20020a375dc70000b02903acea04c19fso19593199qkb.8
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=u95zDG6n6gRWNnnEaj1cPaIdVUcCRGEQQdX0rZcjzdE=;
        b=uBLIb7qV2LD2zF8Q+Kgz6urlUI8Iws9XaybkJrLC+GY+V2ubhPmdTplt7Bn7jpN9WB
         UbCrmkK968Ybt16+gVIj4NGFGPpYXs+PlQadbsyjHRWBO2CJqkkCcSazKILCW4VY/nBa
         IdOvyjE2ko90isTyaZV3By+eEABW9oSbJW37oyfw2jobLIV0zhOpdKlwCYV3yYLILUbK
         cMdpIGrg6+Gc3byo2beBTWQF8ZnQaz4zxlzyAEcMfAwJDM418kYySNuse1bTbR8Y1ELc
         3YhlPsN1cRh8xZj8gfH2sqJIt3+cI+h4J157JFWF8cklcRScYs45ADIay1e5J+crQ7WU
         GDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=u95zDG6n6gRWNnnEaj1cPaIdVUcCRGEQQdX0rZcjzdE=;
        b=A3VDvFDRPwlrfXu6ByN32NMvUC0V21EnJGWNCi679qw48pYNdImGY/R5RQCA7YGOBi
         UCjzAg7zula3k1O4ZaKNzGfoHz5lviYCIgyVzurv2gn4R2PkLkXkrTG0pzZQW7lsENAE
         lFjUaZAd6Is/ZZzPQi+M75HVbquqJsJk21uTUt06l9gr7azFH8xlucRJm7GCXMRGyLdG
         2111aSDdzv4eTj846nISZ59BiYhsi0SQoNZg6mz+mpcu9r4DhNy8YYzoKdEnHW51wZQF
         KMM/Sgs6QjEk+Yf+9L3E3i0uSOvwts09SE6iGzMQcHjH5qC4twL0dmS1GjQntFsWtdvj
         /Xsw==
X-Gm-Message-State: AOAM5311ZCjewW7TLwzaTOTWxyIoFPyzkkqYNBLRTkMSs87cneSqpyyi
        MD/rM0057LZDj8snXZ5hj7eYXY099/Y=
X-Google-Smtp-Source: ABdhPJxfUbOvVeR5catbBRfoWmNUlSAJtnOTk04ODfJnFLTZoXqDOZCrZHEKMzONAUwenZB2ZrKq6Y7eWKE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:ad4:4b22:: with SMTP id s2mr842942qvw.22.1624395670698;
 Tue, 22 Jun 2021 14:01:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:44 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 09/12] lib/vmalloc: Let arch code pass a value
 to its setup_mmu() helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an inner __setup_vm() that takes an opaque param and passes said
param along to setup_mmu().  x86 will use the param to configure its page
tables for kernel vs. user so that tests that want to enable SMEP (fault
if kernel executes user page) can do so without resorting to hacks and
without breaking tests that need user pages, i.e. that run user code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/arm/mmu.c   | 2 +-
 lib/s390x/mmu.c | 3 ++-
 lib/vmalloc.c   | 9 +++++++--
 lib/vmalloc.h   | 4 +++-
 lib/x86/vm.c    | 2 +-
 s390x/uv-host.c | 2 +-
 6 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 7628f79..e1a72fe 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -153,7 +153,7 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 	}
 }
 
-void *setup_mmu(phys_addr_t phys_end)
+void *setup_mmu(phys_addr_t phys_end, void *unused)
 {
 	struct mem_region *r;
 
diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
index c973443..6f9e650 100644
--- a/lib/s390x/mmu.c
+++ b/lib/s390x/mmu.c
@@ -343,7 +343,8 @@ static void setup_identity(pgd_t *pgtable, phys_addr_t start_addr,
 	}
 }
 
-void *setup_mmu(phys_addr_t phys_end){
+void *setup_mmu(phys_addr_t phys_end, void *unused)
+{
 	pgd_t *page_root;
 
 	/* allocate a region-1 table */
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index aa7cc41..5726825 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -206,7 +206,7 @@ void init_alloc_vpage(void *top)
 	spin_unlock(&lock);
 }
 
-void setup_vm()
+void __setup_vm(void *opaque)
 {
 	phys_addr_t base, top;
 
@@ -228,7 +228,7 @@ void setup_vm()
 
 	find_highmem();
 	phys_alloc_get_unused(&base, &top);
-	page_root = setup_mmu(top);
+	page_root = setup_mmu(top, opaque);
 	if (base != top) {
 		base = PAGE_ALIGN(base) >> PAGE_SHIFT;
 		top = top >> PAGE_SHIFT;
@@ -240,3 +240,8 @@ void setup_vm()
 	alloc_ops = &vmalloc_ops;
 	spin_unlock(&lock);
 }
+
+void setup_vm(void)
+{
+	__setup_vm(NULL);
+}
diff --git a/lib/vmalloc.h b/lib/vmalloc.h
index 346f94f..0269fdd 100644
--- a/lib/vmalloc.h
+++ b/lib/vmalloc.h
@@ -14,9 +14,11 @@ extern void *alloc_vpage(void);
 extern void init_alloc_vpage(void *top);
 /* Set up the virtual allocator; also sets up the page allocator if needed */
 extern void setup_vm(void);
+/* As above, plus passes an opaque value to setup_mmu(). */
+extern void __setup_vm(void *opaque);
 
 /* Set up paging */
-extern void *setup_mmu(phys_addr_t top);
+extern void *setup_mmu(phys_addr_t top, void *opaque);
 /* Walk the page table and resolve the virtual address to a physical address */
 extern phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt);
 /* Map the virtual address to the physical address for the given page tables */
diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index e223bb4..221d427 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -147,7 +147,7 @@ static void set_additional_vcpu_vmregs(struct vm_vcpu_info *info)
 	write_cr0(info->cr0);
 }
 
-void *setup_mmu(phys_addr_t end_of_memory)
+void *setup_mmu(phys_addr_t end_of_memory, void *unused)
 {
     pgd_t *cr3 = alloc_page();
     struct vm_vcpu_info info;
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 49c66f1..426a67f 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -446,7 +446,7 @@ static void setup_vmem(void)
 {
 	uint64_t asce, mask;
 
-	setup_mmu(get_max_ram_size());
+	setup_mmu(get_max_ram_size(), NULL);
 	asce = stctg(1);
 	lctlg(13, asce);
 	mask = extract_psw_mask() | 0x0000C00000000000UL;
-- 
2.32.0.288.g62a8d224e6-goog

