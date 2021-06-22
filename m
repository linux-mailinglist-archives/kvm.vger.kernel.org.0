Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825633B0E3E
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhFVUIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbhFVUI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:27 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF29C0613A4
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:07 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id d194-20020a3768cb0000b02903ad9d001bb6so19421591qkc.7
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jahsR7+wqx/S90A0zr29ei0agBIt70mJVNonptHkRIc=;
        b=od950o4p8fN0CjHAn1h+3t7TaP0v/0IW9YD/Q6eVGtNX+YR67CHBoZb3KPS3LnZf9j
         SLcINH7lopVlWx5wRT7DBIUrBAAO4nQbCPBKoxO26OXMPoM+5ofPxCsz3y+iFw99x7O6
         EfmsiyRwWgiPy+2RK3GRrOxvdLe0Lq8g1cgOkmmnhTSShY6lfNlOMbeOfxj9ORo5K9L2
         TOmeZ6fyQgURggLm6MWKm1WUG2HPZXhsgz7Ot7oRt7wycHDAB/yzJ2P72NHGkIJi67Gh
         blYXBYL38S3gkxW5MVP6s26tepeTO8jLB6d/thpymtXpxJLJFRB5kUUg6Eni/JR1tc8q
         Lo4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jahsR7+wqx/S90A0zr29ei0agBIt70mJVNonptHkRIc=;
        b=Y51eXzMoL7uv4SDQFiN1ZpJ94e/pm1ZAC1LubBUk7mKSjuBnvVyGTvReLodk+UPP+w
         X1FpVIzbSfyI/DiL22CEg2D5axGtNOZ1sJkMaqZxfud0ihV5B8F5Y5jm27dEH1ypeTCB
         WAm3zyKRzWqiTFpB6GVxfRKUnc3zv6pmEsJzN+MW61WtHCVwot2livQiEDxFOtgbsdzq
         GzdnrDFGn93iLcCE5IuLxhVsbI65tzRU5aD+hjWgMhST6hQWirw4ISwcURlcrS/BSPQ/
         q5+qfJpabGLaNnx8dP/K4o8wXMjKY/d4dHEaazEM/av8MFP4MemoNghpGtjJcWlKlsva
         d3Mg==
X-Gm-Message-State: AOAM533gku/cS170X1jID0QPy/T0mBh8kjiHQj+8vQvfVUpTAE+6h9mb
        DoXueH9f5w65akIUC9jXRCMsColUOho=
X-Google-Smtp-Source: ABdhPJwYDtg9gpjgzWJDyFWO+3VUNjKpeobkc8oITXZ5jCScINW/czvmuVmD4RrQKY2dLz9p6UPRHD+cabU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a0c:fac3:: with SMTP id p3mr576119qvo.29.1624392366461;
 Tue, 22 Jun 2021 13:06:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:22 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 12/19] KVM: selftests: Unconditionally use memslot '0' for
 page table allocations
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

Drop the memslot param from virt_pg_map() and virt_map() and shove the
hardcoded '0' down to the vm_phy_page_alloc() calls.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c      |  2 +-
 tools/testing/selftests/kvm/include/kvm_util.h    |  5 ++---
 tools/testing/selftests/kvm/kvm_page_table_test.c |  2 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c | 15 +++++++--------
 tools/testing/selftests/kvm/lib/aarch64/ucall.c   |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c        |  6 +++---
 tools/testing/selftests/kvm/lib/perf_test_util.c  |  2 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c |  9 ++++-----
 .../testing/selftests/kvm/lib/x86_64/processor.c  |  9 ++++-----
 tools/testing/selftests/kvm/memslot_perf_test.c   |  2 +-
 .../selftests/kvm/set_memory_region_test.c        |  2 +-
 tools/testing/selftests/kvm/steal_time.c          |  2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c     |  2 +-
 .../testing/selftests/kvm/x86_64/xapic_ipi_test.c |  2 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c        |  2 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c        |  2 +-
 16 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9026fa4ea133..5fe0140e407e 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -760,7 +760,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				    KVM_MEM_LOG_DIRTY_PAGES);
 
 	/* Do mapping for the dirty track memory slot */
-	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages, 0);
+	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
 
 	/* Cache the HVA pointer of the region */
 	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 72cdd4d0a6ee..532541ac1e35 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -145,7 +145,7 @@ vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-	      unsigned int npages, uint32_t pgd_memslot);
+	      unsigned int npages);
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
@@ -256,8 +256,7 @@ void virt_pgd_alloc(struct kvm_vm *vm);
  * Within @vm, creates a virtual translation for the page starting
  * at @vaddr to the page starting at @paddr.
  */
-void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		 uint32_t memslot);
+void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr);
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 82171f17c1d7..0d04a7db7f24 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -303,7 +303,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 				    TEST_MEM_SLOT_INDEX, guest_num_pages, 0);
 
 	/* Do mapping(GVA->GPA) for the testing memory slot */
-	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages, 0);
+	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
 
 	/* Cache the HVA pointer of the region */
 	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index eb079d828b36..ba6f0cff7892 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -83,8 +83,8 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		  uint32_t pgd_memslot, uint64_t flags)
+static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			 uint64_t flags)
 {
 	uint8_t attr_idx = flags & 7;
 	uint64_t *ptep;
@@ -105,7 +105,7 @@ void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, vaddr) * 8;
 	if (!*ptep) {
-		*ptep = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, pgd_memslot);
+		*ptep = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
 		*ptep |= 3;
 	}
 
@@ -113,14 +113,14 @@ void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, vaddr) * 8;
 		if (!*ptep) {
-			*ptep = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, pgd_memslot);
+			*ptep = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
 			*ptep |= 3;
 		}
 		/* fall through */
 	case 3:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, vaddr) * 8;
 		if (!*ptep) {
-			*ptep = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, pgd_memslot);
+			*ptep = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
 			*ptep |= 3;
 		}
 		/* fall through */
@@ -135,12 +135,11 @@ void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	*ptep |= (attr_idx << 2) | (1 << 10) /* Access Flag */;
 }
 
-void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		 uint32_t pgd_memslot)
+void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
 
-	_virt_pg_map(vm, vaddr, paddr, pgd_memslot, attr_idx);
+	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
 vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index 2f37b90ee1a9..e0b0164e9af8 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -14,7 +14,7 @@ static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
 	if (kvm_userspace_memory_region_find(vm, gpa, gpa + 1))
 		return false;
 
-	virt_pg_map(vm, gpa, gpa, 0);
+	virt_pg_map(vm, gpa, gpa);
 
 	ucall_exit_mmio_addr = (vm_vaddr_t *)gpa;
 	sync_global_to_guest(vm, ucall_exit_mmio_addr);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 541315dc230f..555d773f6bdb 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1269,7 +1269,7 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 	for (vm_vaddr_t vaddr = vaddr_start; pages > 0;
 		pages--, vaddr += vm->page_size, paddr += vm->page_size) {
 
-		virt_pg_map(vm, vaddr, paddr, 0);
+		virt_pg_map(vm, vaddr, paddr);
 
 		sparsebit_set(vm->vpages_mapped,
 			vaddr >> vm->page_shift);
@@ -1334,7 +1334,7 @@ vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
  * @npages starting at @vaddr to the page range starting at @paddr.
  */
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-	      unsigned int npages, uint32_t pgd_memslot)
+	      unsigned int npages)
 {
 	size_t page_size = vm->page_size;
 	size_t size = npages * page_size;
@@ -1343,7 +1343,7 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		virt_pg_map(vm, vaddr, paddr, pgd_memslot);
+		virt_pg_map(vm, vaddr, paddr);
 		vaddr += page_size;
 		paddr += page_size;
 	}
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 7397ca299835..b488f4aefea8 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -101,7 +101,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				    guest_num_pages, 0);
 
 	/* Do mapping for the demand paging memory slot */
-	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages, 0);
+	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
 
 	ucall_init(vm, NULL);
 
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index b46e90b88820..fbc4ea2a0d64 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -36,12 +36,12 @@ void virt_pgd_alloc(struct kvm_vm *vm)
  * a page table (ri == 4). Returns a suitable region/segment table entry
  * which points to the freshly allocated pages.
  */
-static uint64_t virt_alloc_region(struct kvm_vm *vm, int ri, uint32_t memslot)
+static uint64_t virt_alloc_region(struct kvm_vm *vm, int ri)
 {
 	uint64_t taddr;
 
 	taddr = vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
-				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, memslot);
+				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
 	memset(addr_gpa2hva(vm, taddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	return (taddr & REGION_ENTRY_ORIGIN)
@@ -49,8 +49,7 @@ static uint64_t virt_alloc_region(struct kvm_vm *vm, int ri, uint32_t memslot)
 		| ((ri < 4 ? (PAGES_PER_REGION - 1) : 0) & REGION_ENTRY_LENGTH);
 }
 
-void virt_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa,
-		 uint32_t memslot)
+void virt_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 {
 	int ri, idx;
 	uint64_t *entry;
@@ -77,7 +76,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa,
 	for (ri = 1; ri <= 4; ri++) {
 		idx = (gva >> (64 - 11 * ri)) & 0x7ffu;
 		if (entry[idx] & REGION_ENTRY_INVALID)
-			entry[idx] = virt_alloc_region(vm, ri, memslot);
+			entry[idx] = virt_alloc_region(vm, ri);
 		entry = addr_gpa2hva(vm, entry[idx] & REGION_ENTRY_ORIGIN);
 	}
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c647e8175090..e02f9b43f047 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -221,8 +221,7 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-	uint32_t pgd_memslot)
+void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	uint16_t index[4];
 	struct pageMapL4Entry *pml4e;
@@ -256,7 +255,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	pml4e = addr_gpa2hva(vm, vm->pgd);
 	if (!pml4e[index[3]].present) {
 		pml4e[index[3]].address = vm_phy_page_alloc(vm,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, pgd_memslot)
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0)
 			>> vm->page_shift;
 		pml4e[index[3]].writable = true;
 		pml4e[index[3]].present = true;
@@ -267,7 +266,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
 	if (!pdpe[index[2]].present) {
 		pdpe[index[2]].address = vm_phy_page_alloc(vm,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, pgd_memslot)
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0)
 			>> vm->page_shift;
 		pdpe[index[2]].writable = true;
 		pdpe[index[2]].present = true;
@@ -278,7 +277,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
 	if (!pde[index[1]].present) {
 		pde[index[1]].address = vm_phy_page_alloc(vm,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, pgd_memslot)
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0)
 			>> vm->page_shift;
 		pde[index[1]].writable = true;
 		pde[index[1]].present = true;
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 11239652d805..d6e381e01db7 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -306,7 +306,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 		guest_addr += npages * 4096;
 	}
 
-	virt_map(data->vm, MEM_GPA, MEM_GPA, mempages, 0);
+	virt_map(data->vm, MEM_GPA, MEM_GPA, mempages);
 
 	sync = (typeof(sync))vm_gpa2hva(data, MEM_SYNC_GPA, NULL);
 	atomic_init(&sync->start_flag, false);
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 978f5b5f4dc0..d79d58eada9f 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -132,7 +132,7 @@ static struct kvm_vm *spawn_vm(pthread_t *vcpu_thread, void *guest_code)
 	gpa = vm_phy_pages_alloc(vm, 2, MEM_REGION_GPA, MEM_REGION_SLOT);
 	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc\n");
 
-	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 2, 0);
+	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 2);
 
 	/* Ditto for the host mapping so that both pages can be zeroed. */
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index fcc840088c91..48f918cca2af 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -295,7 +295,7 @@ int main(int ac, char **av)
 	vm = vm_create_default(0, 0, guest_code);
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
-	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages, 0);
+	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
 	ucall_init(vm, NULL);
 
 	/* Add the rest of the VCPUs */
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index 537de1068554..18f636197827 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -97,7 +97,7 @@ int main(int argc, char *argv[])
 	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
 	 * affects both L1 and L2.  However...
 	 */
-	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES, 0);
+	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
 
 	/*
 	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 5a79c8ed4611..1846117ad584 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -423,7 +423,7 @@ int main(int argc, char *argv[])
 	vcpu_init_descriptor_tables(vm, HALTER_VCPU_ID);
 	vm_handle_exception(vm, IPI_VECTOR, guest_ipi_handler);
 
-	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA, 0);
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 
 	vm_vcpu_add_default(vm, SENDER_VCPU_ID, sender_guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 1f4a0599683c..117bf49a3d79 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -146,7 +146,7 @@ int main(int argc, char *argv[])
 	/* Map a region for the shared_info page */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    SHINFO_REGION_GPA, SHINFO_REGION_SLOT, 2, 0);
-	virt_map(vm, SHINFO_REGION_GVA, SHINFO_REGION_GPA, 2, 0);
+	virt_map(vm, SHINFO_REGION_GVA, SHINFO_REGION_GPA, 2);
 
 	struct kvm_xen_hvm_config hvmc = {
 		.flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index 8389e0bfd711..adc94452b57c 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -103,7 +103,7 @@ int main(int argc, char *argv[])
 	/* Map a region for the hypercall pages */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    HCALL_REGION_GPA, HCALL_REGION_SLOT, 2, 0);
-	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 2, 0);
+	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 2);
 
 	for (;;) {
 		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
-- 
2.32.0.288.g62a8d224e6-goog

