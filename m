Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376213B0E43
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhFVUIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbhFVUId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:33 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FA6C061768
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:11 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id a12-20020ac8108c0000b029023c90fba3dcso418289qtj.7
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=FtKb1Oja40iEYlEY6CpuJYeyFGLCkUnIudjDcyfTZnQ=;
        b=H2Pcuwrj60zu1Y5Poiq1O3xsyq844/o7F6/78ScorfrGv1WOch17SCOdAmRrLnhHDJ
         Lgl48aOYFRkQhQl3pYs566OVqLsEEsb3Y+6umnL9vyBRs3rhQ0Y0MIs1oly/Sa8UW+uD
         2b6Fjbc+DppoXOaQKI/clz7NLP2gnR4OHMyeeUNSSznAtYbXYpSOPOPFO66x6Th3SwLK
         VjTAmwX7ri2VHsQJIUQp2fEait/oUSLzbdFw6lFclaKgnrJzEszv5xXBomgFxyhV6jHi
         wfkqMwiYjHldMpFC/NpxMESlF2OZdw2gQbjIDz82aO22OWt2E8sKRMuWc3TRsX82BjR0
         3mbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=FtKb1Oja40iEYlEY6CpuJYeyFGLCkUnIudjDcyfTZnQ=;
        b=LaJofmtkzs5gbZCYAE0It4P4Kuuwit5Zvzsmy4c88xsIZ1jxgpjF+q5jOg/meOBRqP
         R51yD3E1F3dysCdv5xJUk7CX2kYVH/98WMJx3X3o0f8vbmbpJiXd+NFQft86QWxmCibk
         Ov8oEuptNoZZWfnRB/l96xTD/e/nIVkjNK4fDaG8tgCjQrXDnoSqvDoQk8eeP/md/XcO
         eAgMNItBgu7HOrXgX67NDOIybGQruRKV+rf2KoTfAjMCyerlLnwpt47OAJF+0GE08dbH
         9m7UT+7FAlBFDgBW7dwkggSX1FIIXBMWgNbFTMkokchxNhJMKz7a6Ze/zBQXOyZQJpWw
         31uQ==
X-Gm-Message-State: AOAM533SA1CwjPptrNk8FxQ4imi5wimIz4PeN4fEKtMw+LUBd0DsaTmB
        EMXwlf2pWq7mnDwce+R+Aa9Kqo2V3LA=
X-Google-Smtp-Source: ABdhPJxkqmYm0T2O5mJ7aJpQj1iiJpBz1qKim2nfD+Ot3QICcM16jT3u/RULnlq9K0QNGsSxCP/EK5rd4K4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:ad4:5a07:: with SMTP id ei7mr604559qvb.46.1624392370801;
 Tue, 22 Jun 2021 13:06:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:24 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 14/19] KVM: selftests: Add wrapper to allocate page table page
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

Add a helper to allocate a page for use in constructing the guest's page
tables.  All architectures have identical address and memslot
requirements (which appear to be arbitrary anyways).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 .../selftests/kvm/lib/aarch64/processor.c     | 19 ++++++-------------
 tools/testing/selftests/kvm/lib/kvm_util.c    |  8 ++++++++
 .../selftests/kvm/lib/s390x/processor.c       |  2 --
 .../selftests/kvm/lib/x86_64/processor.c      | 19 ++++---------------
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 12 +++---------
 6 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 532541ac1e35..62573918299c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -30,6 +30,7 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
+#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
 
 #define DEFAULT_GUEST_PHY_PAGES		512
 #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
@@ -262,6 +263,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
+vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
 /*
  * Create a VM with reasonable defaults
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index ba6f0cff7892..ad465ca16237 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -11,7 +11,6 @@
 #include "../kvm_util_internal.h"
 #include "processor.h"
 
-#define KVM_GUEST_PAGE_TABLE_MIN_PADDR		0x180000
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
@@ -104,25 +103,19 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		paddr, vm->max_gfn, vm->page_size);
 
 	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, vaddr) * 8;
-	if (!*ptep) {
-		*ptep = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-		*ptep |= 3;
-	}
+	if (!*ptep)
+		*ptep = vm_alloc_page_table(vm) | 3;
 
 	switch (vm->pgtable_levels) {
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, vaddr) * 8;
-		if (!*ptep) {
-			*ptep = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-			*ptep |= 3;
-		}
+		if (!*ptep)
+			*ptep = vm_alloc_page_table(vm) | 3;
 		/* fall through */
 	case 3:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, vaddr) * 8;
-		if (!*ptep) {
-			*ptep = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-			*ptep |= 3;
-		}
+		if (!*ptep)
+			*ptep = vm_alloc_page_table(vm) | 3;
 		/* fall through */
 	case 2:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, vaddr) * 8;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 555d773f6bdb..58668b97d57b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2213,6 +2213,14 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
 }
 
+/* Arbitrary minimum physical address used for virtual translation tables. */
+#define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
+
+vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
+{
+	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+}
+
 /*
  * Address Guest Virtual to Host Virtual
  *
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index fbc4ea2a0d64..f87c7137598e 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -9,8 +9,6 @@
 #include "kvm_util.h"
 #include "../kvm_util_internal.h"
 
-#define KVM_GUEST_PAGE_TABLE_MIN_PADDR		0x180000
-
 #define PAGES_PER_REGION 4
 
 void virt_pgd_alloc(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index e02f9b43f047..1e7ea77502cf 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -17,9 +17,6 @@
 #define DEFAULT_CODE_SELECTOR 0x8
 #define DEFAULT_DATA_SELECTOR 0x10
 
-/* Minimum physical address used for virtual translation tables. */
-#define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
-
 vm_vaddr_t exception_handlers;
 
 /* Virtual translation table structure declarations */
@@ -214,9 +211,7 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 
 	/* If needed, create page map l4 table. */
 	if (!vm->pgd_created) {
-		vm_paddr_t paddr = vm_phy_page_alloc(vm,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-		vm->pgd = paddr;
+		vm->pgd = vm_alloc_page_table(vm);
 		vm->pgd_created = true;
 	}
 }
@@ -254,9 +249,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	/* Allocate page directory pointer table if not present. */
 	pml4e = addr_gpa2hva(vm, vm->pgd);
 	if (!pml4e[index[3]].present) {
-		pml4e[index[3]].address = vm_phy_page_alloc(vm,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0)
-			>> vm->page_shift;
+		pml4e[index[3]].address = vm_alloc_page_table(vm) >> vm->page_shift;
 		pml4e[index[3]].writable = true;
 		pml4e[index[3]].present = true;
 	}
@@ -265,9 +258,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	struct pageDirectoryPointerEntry *pdpe;
 	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
 	if (!pdpe[index[2]].present) {
-		pdpe[index[2]].address = vm_phy_page_alloc(vm,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0)
-			>> vm->page_shift;
+		pdpe[index[2]].address = vm_alloc_page_table(vm) >> vm->page_shift;
 		pdpe[index[2]].writable = true;
 		pdpe[index[2]].present = true;
 	}
@@ -276,9 +267,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	struct pageDirectoryEntry *pde;
 	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
 	if (!pde[index[1]].present) {
-		pde[index[1]].address = vm_phy_page_alloc(vm,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0)
-			>> vm->page_shift;
+		pde[index[1]].address = vm_alloc_page_table(vm) >> vm->page_shift;
 		pde[index[1]].writable = true;
 		pde[index[1]].present = true;
 	}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 1d26c3979eda..d089d8b850b5 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -426,9 +426,7 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	/* Allocate page directory pointer table if not present. */
 	pml4e = vmx->eptp_hva;
 	if (!pml4e[index[3]].readable) {
-		pml4e[index[3]].address = vm_phy_page_alloc(vm,
-			  KVM_EPT_PAGE_TABLE_MIN_PADDR, 0)
-			>> vm->page_shift;
+		pml4e[index[3]].address = vm_alloc_page_table(vm) >> vm->page_shift;
 		pml4e[index[3]].writable = true;
 		pml4e[index[3]].readable = true;
 		pml4e[index[3]].executable = true;
@@ -438,9 +436,7 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	struct eptPageTableEntry *pdpe;
 	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
 	if (!pdpe[index[2]].readable) {
-		pdpe[index[2]].address = vm_phy_page_alloc(vm,
-			  KVM_EPT_PAGE_TABLE_MIN_PADDR, 0)
-			>> vm->page_shift;
+		pdpe[index[2]].address = vm_alloc_page_table(vm) >> vm->page_shift;
 		pdpe[index[2]].writable = true;
 		pdpe[index[2]].readable = true;
 		pdpe[index[2]].executable = true;
@@ -450,9 +446,7 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	struct eptPageTableEntry *pde;
 	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
 	if (!pde[index[1]].readable) {
-		pde[index[1]].address = vm_phy_page_alloc(vm,
-			  KVM_EPT_PAGE_TABLE_MIN_PADDR, 0)
-			>> vm->page_shift;
+		pde[index[1]].address = vm_alloc_page_table(vm) >> vm->page_shift;
 		pde[index[1]].writable = true;
 		pde[index[1]].readable = true;
 		pde[index[1]].executable = true;
-- 
2.32.0.288.g62a8d224e6-goog

