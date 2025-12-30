Return-Path: <kvm+bounces-66885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 24662CEAD35
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CEF6630019E4
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE4F32D42F;
	Tue, 30 Dec 2025 23:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wqq54Den"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF906316910
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135741; cv=none; b=WmEx5jxk9NKHugxuCqKMyLoWbrPb16R3DNMl1kGC/PJh0muwKLrDj3a4rJAT+Kh1ayLgY6Fe34n+a8a8zkxK5lpCiSuQIaNZM/x8uJlficQwGlBCpn3xR/afSZjUCCCkAgERoSZVOIFeX0dtpshDZPg6xFNfDAYS4NU6TybFRhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135741; c=relaxed/simple;
	bh=AgZ+fbG5FQCIMKh1nY6n3ojPHo4Xii3azjxxpDjCjck=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NjeUOsHXX6jsY1LxKsXiWDM3VzyqHhBazZaOO7cdKCp8iRqMo50PyMQ3temiY3BHWtvpZAqMtEePw3RXp93cxp1C3LAv+AI5xasWNzg5nbytfIwW2QhkvepU6fFwhm77ur6K2vfZGvH8l3bRLQf7mqicnZxoIYycJ0zdtsJX+wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wqq54Den; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c6e05af3bso22763853a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135737; x=1767740537; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=58nGY4ldtTkRgfnQQsIVSVuYVZGfnI/GIgKO3s4AINY=;
        b=wqq54DencKpEVKF+/ZRe/p6aFGcRxXQ2AWAyTBtOUhWqtLOVpHf4g17eew/ouX1yQh
         hUWd+AHN9Tua+aVq/+zRV+Rq/Ug3Tjc/w4pBSBPNokZ3oFx7Z/Cq2JZHX1NEGmPvKoJV
         bolg+2pSDEy2he4KgZHzfUpjvVt+JX5Rsz27J5eqVaV3h+aEE44/8jO/84ZwPhXDj34M
         A65cSeBOA+Sm2kxnjDR5cq9skNNcfOOYNkaT2iJN94SA9/dz4Xlkh9ZEQwZ+TeRzpwpC
         FQfKQxInWvosAA90Du2rTWAmlCU44ijo/ctjN/5KCsrT/mfAHr9eCDr+zwDR3JE7R3SG
         7EZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135737; x=1767740537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=58nGY4ldtTkRgfnQQsIVSVuYVZGfnI/GIgKO3s4AINY=;
        b=aiUH3wlOj9oUH7wk8y3r6aP5cQc255XnYjfgjjc4/I5NG7IgxcdrWOuzDJ9dO0Tt1H
         mwQIu+bV2fZzfRHR5/fAWWwHGtZKPE2mKSaIYbST2iji67oRKOXfVlDdEJhcycVqYSbh
         ZQeDBCy5S4Uhcqd1UTxHORrnSTtDBG2MH4y36tH+DONlLRzmRKROnF7X49i8yDXKnvvJ
         1wADyUY/EM85JJ6lghRhPE8wqtZE51V09Uqe3pT6Z0k+FoRFwHe6+8G5BM4Z5PDHAiet
         m4XdB8gXNEj5WqlqZWw11oDl1n+THXlR7NQPJj7r+S7BKezlLao831nUIINJMN34MlIe
         klFw==
X-Gm-Message-State: AOJu0YxG8Up6Cc2UuXRCHJYAKpthXEy40iEYXY9teUB6wcFXVeCD5PCh
	5sz7RS19IPTLdJqAJSPlAwgYKdv99V3IOa0zZ5ZhHci87zsq9c6PvkdgHKNAqOjsMXmENcNxSY2
	ICWgfQQ==
X-Google-Smtp-Source: AGHT+IHYP5GuhSEXKm9bE6+AiGelDQ95KXay8Hc3+Dh7sZg4xo9JYXOIH/yq4oOqsJcIf2r6UztQNZfvedQ=
X-Received: from pjblp6.prod.google.com ([2002:a17:90b:4a86:b0:34a:aa6a:e179])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b43:b0:343:e2ba:e8be
 with SMTP id 98e67ed59e1d1-34e9214bec7mr27723847a91.10.1767135737056; Tue, 30
 Dec 2025 15:02:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:43 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-15-seanjc@google.com>
Subject: [PATCH v4 14/21] KVM: selftests: Move TDP mapping functions outside
 of vmx.c
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

Now that the functions are no longer VMX-specific, move them to
processor.c. Do a minor comment tweak replacing 'EPT' with 'TDP'.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |  4 ++
 tools/testing/selftests/kvm/include/x86/vmx.h |  3 -
 .../testing/selftests/kvm/lib/x86/processor.c | 53 ++++++++++++++
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 71 -------------------
 4 files changed, 57 insertions(+), 74 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 4c0d2fc83c1c..d134c886f280 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1477,6 +1477,10 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level);
 
+void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
+void tdp_identity_map_default_memslots(struct kvm_vm *vm);
+void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
+
 /*
  * Basic CPU control in CR0
  */
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 4dd4c2094ee6..92b918700d24 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -557,9 +557,6 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void tdp_identity_map_default_memslots(struct kvm_vm *vm);
-void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
 void vm_enable_ept(struct kvm_vm *vm);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 41316cac94e0..29e7d172f945 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -472,6 +472,59 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 }
 
+void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+	       uint64_t size, int level)
+{
+	size_t page_size = PG_LEVEL_SIZE(level);
+	size_t npages = size / page_size;
+
+	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
+	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+
+	while (npages--) {
+		__virt_pg_map(vm, &vm->stage2_mmu, nested_paddr, paddr, level);
+		nested_paddr += page_size;
+		paddr += page_size;
+	}
+}
+
+void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+	     uint64_t size)
+{
+	__tdp_map(vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+}
+
+/* Prepare an identity extended page table that maps all the
+ * physical pages in VM.
+ */
+void tdp_identity_map_default_memslots(struct kvm_vm *vm)
+{
+	uint32_t s, memslot = 0;
+	sparsebit_idx_t i, last;
+	struct userspace_mem_region *region = memslot2region(vm, memslot);
+
+	/* Only memslot 0 is mapped here, ensure it's the only one being used */
+	for (s = 0; s < NR_MEM_REGIONS; s++)
+		TEST_ASSERT_EQ(vm->memslots[s], 0);
+
+	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
+	last = i + (region->region.memory_size >> vm->page_shift);
+	for (;;) {
+		i = sparsebit_next_clear(region->unused_phy_pages, i);
+		if (i > last)
+			break;
+
+		tdp_map(vm, (uint64_t)i << vm->page_shift,
+			(uint64_t)i << vm->page_shift, 1 << vm->page_shift);
+	}
+}
+
+/* Identity map a region with 1GiB Pages. */
+void tdp_identity_map_1g(struct kvm_vm *vm, uint64_t addr, uint64_t size)
+{
+	__tdp_map(vm, addr, addr, size, PG_LEVEL_1G);
+}
+
 /*
  * Set Unusable Segment
  *
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index e3737b3d9120..448a63457467 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -373,77 +373,6 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
-/*
- * Map a range of EPT guest physical addresses to the VM's physical address
- *
- * Input Args:
- *   vm - Virtual Machine
- *   nested_paddr - Nested guest physical address to map
- *   paddr - VM Physical Address
- *   size - The size of the range to map
- *   level - The level at which to map the range
- *
- * Output Args: None
- *
- * Return: None
- *
- * Within the VM given by vm, creates a nested guest translation for the
- * page range starting at nested_paddr to the page range starting at paddr.
- */
-void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
-	       uint64_t size, int level)
-{
-	struct kvm_mmu *mmu = &vm->stage2_mmu;
-	size_t page_size = PG_LEVEL_SIZE(level);
-	size_t npages = size / page_size;
-
-	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
-	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
-
-	while (npages--) {
-		__virt_pg_map(vm, mmu, nested_paddr, paddr, level);
-		nested_paddr += page_size;
-		paddr += page_size;
-	}
-}
-
-void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
-	     uint64_t size)
-{
-	__tdp_map(vm, nested_paddr, paddr, size, PG_LEVEL_4K);
-}
-
-/* Prepare an identity extended page table that maps all the
- * physical pages in VM.
- */
-void tdp_identity_map_default_memslots(struct kvm_vm *vm)
-{
-	uint32_t s, memslot = 0;
-	sparsebit_idx_t i, last;
-	struct userspace_mem_region *region = memslot2region(vm, memslot);
-
-	/* Only memslot 0 is mapped here, ensure it's the only one being used */
-	for (s = 0; s < NR_MEM_REGIONS; s++)
-		TEST_ASSERT_EQ(vm->memslots[s], 0);
-
-	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
-	last = i + (region->region.memory_size >> vm->page_shift);
-	for (;;) {
-		i = sparsebit_next_clear(region->unused_phy_pages, i);
-		if (i > last)
-			break;
-
-		tdp_map(vm, (uint64_t)i << vm->page_shift,
-			(uint64_t)i << vm->page_shift, 1 << vm->page_shift);
-	}
-}
-
-/* Identity map a region with 1GiB Pages. */
-void tdp_identity_map_1g(struct kvm_vm *vm, uint64_t addr, uint64_t size)
-{
-	__tdp_map(vm, addr, addr, size, PG_LEVEL_1G);
-}
-
 bool kvm_cpu_has_ept(void)
 {
 	uint64_t ctrl;
-- 
2.52.0.351.gbe84eed79e-goog


