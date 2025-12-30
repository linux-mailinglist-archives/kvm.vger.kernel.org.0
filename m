Return-Path: <kvm+bounces-66882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE798CEAD80
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:15:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E76EC3065794
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1032731D730;
	Tue, 30 Dec 2025 23:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NM4tcSTQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E913043BE
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135736; cv=none; b=eEmRAPIxfY0uAgZvE9zGXz6kiW5XCecNTaYLuhSn4+5S+5Oad/dTZC8OBR2R5ULWtD5qRIJCOXnDlxUh8fGJujJFxY85GkybIglF1OFWq8Sjwxq0WqBO1+QaKrGYlD8pcw7ZiBJew/I6/oJH1NOHriWQI/fAAj0efEGGiSnvfc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135736; c=relaxed/simple;
	bh=Yh8Qab0Gq4P0gx+ZK5aVX/2lf28QcgZxjaey8n2Vr4c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gbA6+AcAIH0y8RJw/yEhjhKlV5Iygwpxr3WIyDpA1LHxczmYpSVczy+BifElza46127s/wdYegv/0hwh5f1+4yETgXBiQg3Krp45RcFbXS6LSK2JBL70f2fwYN2lriDSgw5bDYnW9kkodnNW0NWJi3LQImknT9F7dlHNBbPmU/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NM4tcSTQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34eff656256so7531925a91.2
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135732; x=1767740532; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ja2t3RddJQQ9WtlMGrZPDGGnut4pYDpTPLHSPL1hvlg=;
        b=NM4tcSTQsnog7kEFqij1HPgUespL5azjSD2YAmvQ16xjGL+BCaCYFxoIACilYFosNi
         J9YuTRwp53KWD5jEeSjdhngm7TqKnNngnr2iT4wfkODJPBNQwxOYpib1Sc6ypHSbsFjZ
         5fdNN0Tk9b1bdBD1tdS7zQEYncVPcRiYZpSGe9S1lMj0K+AKs7FPcmv2u+2jc/b7QEQI
         91vCaSlKw3lo9RIR0sOU9jdfw25Xfu7PhDhYvQSaiKPHYR1bKZ/izvJWuJDHja/pIH7H
         axIQZzcWnzm+oTOxVKxO6m1dtNiFaH9u7SIriNhgeZLU+BHXhzumlaykruDm1pu+Cuys
         v9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135732; x=1767740532;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ja2t3RddJQQ9WtlMGrZPDGGnut4pYDpTPLHSPL1hvlg=;
        b=iKBmmVX8lFaVFrxQGTU1hRIDaHIPuDDZJmDUiZpaUolbx0nbSfPHfffYNPPhPA9Nnm
         QkJOdoxQZM29MpP3JcwIv7osNP2+/KByNdtUjIJgH+9ORKXHOgWLMw2yOktJvasmPRMg
         wW/NX6SDvQBUAnurt4mADFAU1urrrYbFsq+PZETAeH5uHiOKIjgXWTf2sU/osSjKS7tD
         Zk7ySnuLsc6JZDI92/SZoH11WltjiTfrBo3zI8USdZSnBmRFjvDumQaaPHHpufB0FQOd
         ngd3/pXDiRByp0qE8HoZBb5kqTVOGA3lMWFkikUaTIjmpmko71r0udBdoWq/UA+ugUXY
         HXow==
X-Gm-Message-State: AOJu0YzTRucjLWyf68y1RFxE60A/6JYA3lbxEJOTaZiHAdYWr/tvba1J
	TURk8OlBS3L4uDfXFv7CKzKAr2bBF9hPnbx8fiEw6cIV7mvAE8dfK8F3Uv7XGCnM7gxooKJcl0v
	I/BJdJw==
X-Google-Smtp-Source: AGHT+IFlmvuQfNmiHzFuNq9XlPth424WfhGaGaW+Waxyx9tMx4HEJVVNAsbuKBuWKPaCjxwrIKXmvslHERQ=
X-Received: from pjbnw17.prod.google.com ([2002:a17:90b:2551:b0:34c:30f1:8d54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3882:b0:340:d511:e167
 with SMTP id 98e67ed59e1d1-34e9207378fmr28865851a91.0.1767135731850; Tue, 30
 Dec 2025 15:02:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:40 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-12-seanjc@google.com>
Subject: [PATCH v4 11/21] KVM: selftests: Stop passing VMX metadata to TDP
 mapping functions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Yosry Ahmed <yosry.ahmed@linux.dev>

The root GPA can now be retrieved from the nested MMU, stop passing VMX
metadata. This is in preparation for making these functions work for
NPTs as well.

Opportunistically drop tdp_pg_map() since it's unused.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/vmx.h | 11 ++-----
 .../testing/selftests/kvm/lib/x86/memstress.c | 11 +++----
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 33 +++++++------------
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  9 +++--
 4 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 1fd83c23529a..4dd4c2094ee6 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -557,14 +557,9 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
-		uint64_t paddr);
-void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
-	     uint64_t paddr, uint64_t size);
-void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
-				       struct kvm_vm *vm);
-void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
-			 uint64_t addr, uint64_t size);
+void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
+void tdp_identity_map_default_memslots(struct kvm_vm *vm);
+void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
 void vm_enable_ept(struct kvm_vm *vm);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 00f7f11e5f0e..3319cb57a78d 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -59,7 +59,7 @@ uint64_t memstress_nested_pages(int nr_vcpus)
 	return 513 + 10 * nr_vcpus;
 }
 
-static void memstress_setup_ept_mappings(struct vmx_pages *vmx, struct kvm_vm *vm)
+static void memstress_setup_ept_mappings(struct kvm_vm *vm)
 {
 	uint64_t start, end;
 
@@ -68,16 +68,15 @@ static void memstress_setup_ept_mappings(struct vmx_pages *vmx, struct kvm_vm *v
 	 * KVM can shadow the EPT12 with the maximum huge page size supported
 	 * by the backing source.
 	 */
-	tdp_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
+	tdp_identity_map_1g(vm, 0, 0x100000000ULL);
 
 	start = align_down(memstress_args.gpa, PG_SIZE_1G);
 	end = align_up(memstress_args.gpa + memstress_args.size, PG_SIZE_1G);
-	tdp_identity_map_1g(vmx, vm, start, end - start);
+	tdp_identity_map_1g(vm, start, end - start);
 }
 
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
 {
-	struct vmx_pages *vmx;
 	struct kvm_regs regs;
 	vm_vaddr_t vmx_gva;
 	int vcpu_id;
@@ -87,11 +86,11 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 
 	vm_enable_ept(vm);
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
+		vcpu_alloc_vmx(vm, &vmx_gva);
 
 		/* The EPTs are shared across vCPUs, setup the mappings once */
 		if (vcpu_id == 0)
-			memstress_setup_ept_mappings(vmx, vm);
+			memstress_setup_ept_mappings(vm);
 
 		/*
 		 * Override the vCPU to run memstress_l1_guest_code() which will
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 9d4e391fdf2c..ea1c09f9e8ab 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -409,8 +409,8 @@ static void tdp_create_pte(struct kvm_vm *vm,
 }
 
 
-void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		  uint64_t nested_paddr, uint64_t paddr, int target_level)
+void __tdp_pg_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+		  int target_level)
 {
 	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
 	void *eptp_hva = addr_gpa2hva(vm, vm->arch.tdp_mmu->pgd);
@@ -453,12 +453,6 @@ void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	}
 }
 
-void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		uint64_t nested_paddr, uint64_t paddr)
-{
-	__tdp_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
-}
-
 /*
  * Map a range of EPT guest physical addresses to the VM's physical address
  *
@@ -476,9 +470,8 @@ void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  * Within the VM given by vm, creates a nested guest translation for the
  * page range starting at nested_paddr to the page range starting at paddr.
  */
-void __tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-	       uint64_t nested_paddr, uint64_t paddr, uint64_t size,
-		  int level)
+void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+	       uint64_t size, int level)
 {
 	size_t page_size = PG_LEVEL_SIZE(level);
 	size_t npages = size / page_size;
@@ -487,23 +480,22 @@ void __tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		__tdp_pg_map(vmx, vm, nested_paddr, paddr, level);
+		__tdp_pg_map(vm, nested_paddr, paddr, level);
 		nested_paddr += page_size;
 		paddr += page_size;
 	}
 }
 
-void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-	     uint64_t nested_paddr, uint64_t paddr, uint64_t size)
+void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+	     uint64_t size)
 {
-	__tdp_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+	__tdp_map(vm, nested_paddr, paddr, size, PG_LEVEL_4K);
 }
 
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
-				       struct kvm_vm *vm)
+void tdp_identity_map_default_memslots(struct kvm_vm *vm)
 {
 	uint32_t s, memslot = 0;
 	sparsebit_idx_t i, last;
@@ -520,16 +512,15 @@ void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
 		if (i > last)
 			break;
 
-		tdp_map(vmx, vm, (uint64_t)i << vm->page_shift,
+		tdp_map(vm, (uint64_t)i << vm->page_shift,
 			(uint64_t)i << vm->page_shift, 1 << vm->page_shift);
 	}
 }
 
 /* Identity map a region with 1GiB Pages. */
-void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
-			    uint64_t addr, uint64_t size)
+void tdp_identity_map_1g(struct kvm_vm *vm, uint64_t addr, uint64_t size)
 {
-	__tdp_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
+	__tdp_map(vm, addr, addr, size, PG_LEVEL_1G);
 }
 
 bool kvm_cpu_has_ept(void)
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 5c8cf8ac42a2..370f8d3117c2 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -80,7 +80,6 @@ void l1_guest_code(struct vmx_pages *vmx)
 static void test_vmx_dirty_log(bool enable_ept)
 {
 	vm_vaddr_t vmx_pages_gva = 0;
-	struct vmx_pages *vmx;
 	unsigned long *bmap;
 	uint64_t *host_test_mem;
 
@@ -96,7 +95,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	if (enable_ept)
 		vm_enable_ept(vm);
 
-	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vcpu, 1, vmx_pages_gva);
 
 	/* Add an extra memory slot for testing dirty logging */
@@ -120,9 +119,9 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 * GPAs as the EPT enabled case.
 	 */
 	if (enable_ept) {
-		tdp_identity_map_default_memslots(vmx, vm);
-		tdp_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
-		tdp_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_identity_map_default_memslots(vm);
+		tdp_map(vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_map(vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
-- 
2.52.0.351.gbe84eed79e-goog


