Return-Path: <kvm+bounces-66874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D23AFCEAD00
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:02:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B69753019E32
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58722DFF3F;
	Tue, 30 Dec 2025 23:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t3Jh0woY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ABD2E4263
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135720; cv=none; b=i6JqJIqvBeXoVe4SKLAHhhaUn5R/oOdXn3xpDTnGppW44Ep92VEllMtFWidW6u0xtkvdxx+OYGNuZZdiSPAu+H7N27VvZNvFl75CtiSYWp7ezmdffdj7JI/JrlRj57nlx1A/JdTM1CaqLHe4elDlP8nuJ/xIQxz6WI1AoCJGkhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135720; c=relaxed/simple;
	bh=91L4txYNNUE5SJojuQZ2nZ3cjzuGzWc5839mOJ9F1/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CUkunrdlj4XAS5F9q2ySZ7tU9bh8El36z1xbhWcXExuR3rvRYMAbqa42PNY0maS2ma/WCm4DrtzJ3Oa2gVhqzDR0Ede4ZrCQ6uNjsW0xsBJiKkPwDaW16MbGUxlEelYxaH5QefP+mOMI5jgI2usfiRsnGzEgI9vIpcI4fmxcyPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t3Jh0woY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ea5074935so9470874a91.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135718; x=1767740518; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yWDCaLTCIbcQO/h6zTAUUdpMSrBY0ICbFLNvpCPkE/c=;
        b=t3Jh0woY1HX/s6vS/bv0qDU+8/bGsHpu9GOB4uAPcugNTpa20rL1Y1PBhnVKiaiDlw
         /lD4tQXR1zD/EbRli6PPIfHEqFEPtqMhPo5ClNDSnTVTN0BZaDXiS9719PUvhrikJIQg
         XuSm+M+WLUwvez0Ku4kqubHjoQRGlgU4zu/j2wXzNLO8v2Vdcvqax+w88Btog0inK9t/
         hchPgbgG8AE3whHY14t6BGKekRP4vpvQ3SGzpNd1QxZk91HaX7NrrweDDHDUqIJ0FcPn
         83F1/HljZYvto6ul5TYbOPxdJ2C49Npr65MSmWM6b9ofthnmlpPoqNlUiiaOqVHqwBYJ
         kiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135718; x=1767740518;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yWDCaLTCIbcQO/h6zTAUUdpMSrBY0ICbFLNvpCPkE/c=;
        b=DXKEpm2g05uOJQ3gqkmmRu6AucYZMwihj6mAKyrBtCvvx8OqreHLOFm/BkynGsUHsD
         fHjb6kDBUnhpgWayQt7Yd3+7Z+gB2TRd1PvqAQuD2w4BpFnxMT3T+k6XW3fhsAS4rMQ2
         wMHPE8r6I7ayuPJ1loYjBAV1vT3F3OckSv0+gftQ5MH010EeBMk6qBPo2b6TI9vW2A0C
         KzveJ+YYHDsuvLD/Cg9835rblC3JgVmMrdVlFLEgKAvbyER8/MlYLEV8oBtMXotDRKKl
         DD5RRHDvi3rBbbWM2zXBa0ksun64+qQ4cFmHITWGek2WOTxk9cslZPJL11u/oVBcOcBB
         qpiQ==
X-Gm-Message-State: AOJu0YyEK+Oe39/h2p2JbLQkk26XcA8hw0/GjW1VaTGnHl+36Zi5/4/p
	5wMX1QLkZFV9jOoEHcWsdUB6dsZwhYn/Y4bUhALIalGyPMwIR0IrC2yYLBxNoNzSGs/taiSbsma
	tLPxamg==
X-Google-Smtp-Source: AGHT+IHV3rTLFIW3Ya/WfGECQ4NGCUq3VWcqeP/2rJnzAJYZRKybcHRTVRGE5PryLt5G6ChfGloqjW0LJ10=
X-Received: from pjbin23.prod.google.com ([2002:a17:90b:4397:b0:34c:f8b8:349b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f83:b0:340:bb56:79de
 with SMTP id 98e67ed59e1d1-34e921ee80bmr29589802a91.30.1767135717583; Tue, 30
 Dec 2025 15:01:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:32 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-4-seanjc@google.com>
Subject: [PATCH v4 03/21] KVM: selftests: Rename nested TDP mapping functions
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

Rename the functions from nested_* to tdp_* to make their purpose
clearer.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/vmx.h | 16 +++---
 .../testing/selftests/kvm/lib/x86/memstress.c |  4 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 50 +++++++++----------
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  6 +--
 4 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 91916b8aa94b..04b8231d032a 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -559,14 +559,14 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr);
-void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void nested_identity_map_default_memslots(struct vmx_pages *vmx,
-					  struct kvm_vm *vm);
-void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
-			    uint64_t addr, uint64_t size);
+void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
+		uint64_t paddr);
+void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
+	     uint64_t paddr, uint64_t size);
+void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
+				       struct kvm_vm *vm);
+void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+			 uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 0b1f288ad556..1928b00bde51 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -70,11 +70,11 @@ void memstress_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 	 * KVM can shadow the EPT12 with the maximum huge page size supported
 	 * by the backing source.
 	 */
-	nested_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
+	tdp_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
 
 	start = align_down(memstress_args.gpa, PG_SIZE_1G);
 	end = align_up(memstress_args.gpa + memstress_args.size, PG_SIZE_1G);
-	nested_identity_map_1g(vmx, vm, start, end - start);
+	tdp_identity_map_1g(vmx, vm, start, end - start);
 }
 
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index eec33ec63811..1954ccdfc353 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -362,12 +362,12 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
-static void nested_create_pte(struct kvm_vm *vm,
-			      struct eptPageTableEntry *pte,
-			      uint64_t nested_paddr,
-			      uint64_t paddr,
-			      int current_level,
-			      int target_level)
+static void tdp_create_pte(struct kvm_vm *vm,
+			   struct eptPageTableEntry *pte,
+			   uint64_t nested_paddr,
+			   uint64_t paddr,
+			   int current_level,
+			   int target_level)
 {
 	if (!pte->readable) {
 		pte->writable = true;
@@ -394,8 +394,8 @@ static void nested_create_pte(struct kvm_vm *vm,
 }
 
 
-void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		     uint64_t nested_paddr, uint64_t paddr, int target_level)
+void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		  uint64_t nested_paddr, uint64_t paddr, int target_level)
 {
 	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
 	struct eptPageTableEntry *pt = vmx->eptp_hva, *pte;
@@ -428,7 +428,7 @@ void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		index = (nested_paddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 		pte = &pt[index];
 
-		nested_create_pte(vm, pte, nested_paddr, paddr, level, target_level);
+		tdp_create_pte(vm, pte, nested_paddr, paddr, level, target_level);
 
 		if (pte->page_size)
 			break;
@@ -445,10 +445,10 @@ void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 
 }
 
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr)
+void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		uint64_t nested_paddr, uint64_t paddr)
 {
-	__nested_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
+	__tdp_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
 }
 
 /*
@@ -468,8 +468,8 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  * Within the VM given by vm, creates a nested guest translation for the
  * page range starting at nested_paddr to the page range starting at paddr.
  */
-void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		  uint64_t nested_paddr, uint64_t paddr, uint64_t size,
+void __tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+	       uint64_t nested_paddr, uint64_t paddr, uint64_t size,
 		  int level)
 {
 	size_t page_size = PG_LEVEL_SIZE(level);
@@ -479,23 +479,23 @@ void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		__nested_pg_map(vmx, vm, nested_paddr, paddr, level);
+		__tdp_pg_map(vmx, vm, nested_paddr, paddr, level);
 		nested_paddr += page_size;
 		paddr += page_size;
 	}
 }
 
-void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
+void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+	     uint64_t nested_paddr, uint64_t paddr, uint64_t size)
 {
-	__nested_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+	__tdp_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
 }
 
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void nested_identity_map_default_memslots(struct vmx_pages *vmx,
-					  struct kvm_vm *vm)
+void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
+				       struct kvm_vm *vm)
 {
 	uint32_t s, memslot = 0;
 	sparsebit_idx_t i, last;
@@ -512,18 +512,16 @@ void nested_identity_map_default_memslots(struct vmx_pages *vmx,
 		if (i > last)
 			break;
 
-		nested_map(vmx, vm,
-			   (uint64_t)i << vm->page_shift,
-			   (uint64_t)i << vm->page_shift,
-			   1 << vm->page_shift);
+		tdp_map(vmx, vm, (uint64_t)i << vm->page_shift,
+			(uint64_t)i << vm->page_shift, 1 << vm->page_shift);
 	}
 }
 
 /* Identity map a region with 1GiB Pages. */
-void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size)
 {
-	__nested_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
+	__tdp_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
 }
 
 bool kvm_cpu_has_ept(void)
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index aab7333aaef0..e7d0c08ba29d 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -121,9 +121,9 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 */
 	if (enable_ept) {
 		prepare_eptp(vmx, vm);
-		nested_identity_map_default_memslots(vmx, vm);
-		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
-		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_identity_map_default_memslots(vmx, vm);
+		tdp_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
-- 
2.52.0.351.gbe84eed79e-goog


