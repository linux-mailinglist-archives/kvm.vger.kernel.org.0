Return-Path: <kvm+bounces-49858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BF94ADEA73
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF05E40015D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC2A2E92C9;
	Wed, 18 Jun 2025 11:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GF+tXaFh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9D02E8E02
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246592; cv=none; b=bjS3k99/GXbSQFBHQhBtILN/rf3l5Ph/kqMcUb08c+5IHQly3azalpWgPYqsAyjc3T63NGiaFKeppZIdyIjnnqTqGDcqLQi/CjcyOGsMxjAx4fwZEknGyEqLK8zXE4Zm979WP+M2EU6wGnBzscCioG6Jp/WwVJFqEIZ84JVJi4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246592; c=relaxed/simple;
	bh=P4lZ2mtLaeQ3GLE74/sFfvJ7vB7exgTSt9fB9Qi+RZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNJIIXM6vQeQmxBi8dl2Zn4D8IJ0ktzfPAhM+p32hlMffMKrLqEsw2FKyIVCHWmKTVMc6JbRmA0LcrZloIrFUtElCcUAnW9d4lUA/kBD9y7UWtkE0RRfR5WOh3unfar0sQMA552qaiDSD5RCN2s22vIRqAf3rc6N3hxv53iXvCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GF+tXaFh; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-234d366e5f2so90111005ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246590; x=1750851390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2p5mv+mJk3QRDyfTxwUw01alJmtpxQQyJ0sOt3jdEOc=;
        b=GF+tXaFhakXOdhsAFQrrqYPhqQ35qrL5DYaXsx06tmyOm0S9izxP4FIeHbo2nZjOPW
         JorUkMAU9ALSlmTuqbWcDebLssHbhbGLDxST35ZVO8bwmUhpMbmKAVfKxiDNydHyEdrd
         LjO+1b87vE50Z9RjhlXMZlZNqMfvq6tDCXmD5ALJck107tCA/mK+MK5R02RJPijC15oo
         aLujM9+TQjB1gfanrMVMRmVXn7js/RQwOPE7q2khJUObgQc/cRgbF19gEcLOiMRCCbcj
         BkZnJAl2atY72DD/atSi0XGwgAQNIBFv+JNy4OZZy4IkY9NFX43RS3xfiAMn4gq8I+WR
         wjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246590; x=1750851390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2p5mv+mJk3QRDyfTxwUw01alJmtpxQQyJ0sOt3jdEOc=;
        b=vjhGgdksTpA5MATHKpepmIl0xqKQdIJmIXiFR+t0nBPj8/NYnp+0rPeHo5LuDadrAT
         8QEvvTLa/Z2iC3UkrQPzkBzbZiaF5x+veTXTmzc5NEHFgLYah2aFLg9NZUEEueyF9RC0
         7yhx4hHEgKe8Zq5rN1xaKEaZY9UsU9f1XuAYqLkTcfL3Ci3rIPdHOJ3YVWBQqwhZKcI8
         NNh6s/uOofqbwq5fnozrVzV1kARtzdHzj3d2Mr542aCmSv93eyiu7vQhv4/yKstd/02O
         U2LdiG02LaIdzHkuIM/D6vq2bSdtzYhY1VWj2gHs9PMrb+FJdPX/1sHoMrj4WW4nzzTy
         3izg==
X-Forwarded-Encrypted: i=1; AJvYcCUQWYa9/n7Mx8jb2fqiK9L779cXwFbY9BZVrMB1Eg6eJDMrgB9dc2UMx6Kdq9tss37dsRs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8NDemY8sHft5QNAcMPTcURaE+dJ6/K3q9pA/w7sTY3HMSfWr/
	odW2HJXRo7FAyo20VoTAc+abprBJnKxY/kJV6d9Ty244NP73vnyis8NBbFJB+bG940g=
X-Gm-Gg: ASbGncsc30HHs14grhdBnW0T++yYHUz2Kmhvy7XF9O8qU38/BWh0pokKNf4dPr5pw3x
	bRCo3H9M/q19iKXMbfNpFN3EMlUSHP4K/dPC3E2Ronm7MA5/bfcZZSkaFYn5Nf7I6dR7wq+5yRb
	X6kQUcVkhytCJPtfibiwZ6P/DuZTLzp8E80CrHzmlcWTt0Fb/mKwCr2JzRxYm3w7tke6BLnrRZI
	58IxNfIk4AvI+/BoIwY83vlAQPj6Qdw5Hr4AB6unneFIErSP67yIDpDZjziuX1MJPz9sM0KyIhy
	xRJyKhs+lA8c6MEapcIF4uKuNqo++Gf83ka6nKcQYbm0fQKrOEHRfkWwc1MJ5eECUrMyyhyBVTv
	IAoOKHVs3PPol9yh/Zpgt8JODlizb
X-Google-Smtp-Source: AGHT+IEBquBrf2XB4FByIM0NjX1oGNwUDdFIttWNjoo91vzWLERz/6T2M0LEaAO4ssBEon09H6iLyQ==
X-Received: by 2002:a17:903:74f:b0:234:b422:7120 with SMTP id d9443c01a7336-2366b3137c0mr188903225ad.9.1750246589968;
        Wed, 18 Jun 2025 04:36:29 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:36:29 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 09/12] RISC-V: KVM: Introduce struct kvm_gstage_mapping
Date: Wed, 18 Jun 2025 17:05:29 +0530
Message-ID: <20250618113532.471448-10-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250618113532.471448-1-apatel@ventanamicro.com>
References: <20250618113532.471448-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce struct kvm_gstage_mapping which represents a g-stage
mapping at a particular g-stage page table level. Also, update
the kvm_riscv_gstage_map() to return the g-stage mapping upon
success.

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_mmu.h |  9 ++++-
 arch/riscv/kvm/mmu.c             | 58 ++++++++++++++++++--------------
 arch/riscv/kvm/vcpu_exit.c       |  3 +-
 3 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_mmu.h b/arch/riscv/include/asm/kvm_mmu.h
index 4e1654282ee4..91c11e692dc7 100644
--- a/arch/riscv/include/asm/kvm_mmu.h
+++ b/arch/riscv/include/asm/kvm_mmu.h
@@ -8,6 +8,12 @@
 
 #include <linux/kvm_types.h>
 
+struct kvm_gstage_mapping {
+	gpa_t addr;
+	pte_t pte;
+	u32 level;
+};
+
 int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 			     phys_addr_t hpa, unsigned long size,
 			     bool writable, bool in_atomic);
@@ -15,7 +21,8 @@ void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
 			      unsigned long size);
 int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
-			 gpa_t gpa, unsigned long hva, bool is_write);
+			 gpa_t gpa, unsigned long hva, bool is_write,
+			 struct kvm_gstage_mapping *out_map);
 int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
 void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index c1a3eb076df3..806614b3e46d 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -135,18 +135,18 @@ static void gstage_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
 	kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0, addr, BIT(order), order);
 }
 
-static int gstage_set_pte(struct kvm *kvm, u32 level,
-			   struct kvm_mmu_memory_cache *pcache,
-			   gpa_t addr, const pte_t *new_pte)
+static int gstage_set_pte(struct kvm *kvm,
+			  struct kvm_mmu_memory_cache *pcache,
+			  const struct kvm_gstage_mapping *map)
 {
 	u32 current_level = gstage_pgd_levels - 1;
 	pte_t *next_ptep = (pte_t *)kvm->arch.pgd;
-	pte_t *ptep = &next_ptep[gstage_pte_index(addr, current_level)];
+	pte_t *ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
 
-	if (current_level < level)
+	if (current_level < map->level)
 		return -EINVAL;
 
-	while (current_level != level) {
+	while (current_level != map->level) {
 		if (gstage_pte_leaf(ptep))
 			return -EEXIST;
 
@@ -165,13 +165,13 @@ static int gstage_set_pte(struct kvm *kvm, u32 level,
 		}
 
 		current_level--;
-		ptep = &next_ptep[gstage_pte_index(addr, current_level)];
+		ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
 	}
 
-	if (pte_val(*ptep) != pte_val(*new_pte)) {
-		set_pte(ptep, *new_pte);
+	if (pte_val(*ptep) != pte_val(map->pte)) {
+		set_pte(ptep, map->pte);
 		if (gstage_pte_leaf(ptep))
-			gstage_remote_tlb_flush(kvm, current_level, addr);
+			gstage_remote_tlb_flush(kvm, current_level, map->addr);
 	}
 
 	return 0;
@@ -181,14 +181,16 @@ static int gstage_map_page(struct kvm *kvm,
 			   struct kvm_mmu_memory_cache *pcache,
 			   gpa_t gpa, phys_addr_t hpa,
 			   unsigned long page_size,
-			   bool page_rdonly, bool page_exec)
+			   bool page_rdonly, bool page_exec,
+			   struct kvm_gstage_mapping *out_map)
 {
-	int ret;
-	u32 level = 0;
-	pte_t new_pte;
 	pgprot_t prot;
+	int ret;
 
-	ret = gstage_page_size_to_level(page_size, &level);
+	out_map->addr = gpa;
+	out_map->level = 0;
+
+	ret = gstage_page_size_to_level(page_size, &out_map->level);
 	if (ret)
 		return ret;
 
@@ -216,10 +218,10 @@ static int gstage_map_page(struct kvm *kvm,
 		else
 			prot = PAGE_WRITE;
 	}
-	new_pte = pfn_pte(PFN_DOWN(hpa), prot);
-	new_pte = pte_mkdirty(new_pte);
+	out_map->pte = pfn_pte(PFN_DOWN(hpa), prot);
+	out_map->pte = pte_mkdirty(out_map->pte);
 
-	return gstage_set_pte(kvm, level, pcache, gpa, &new_pte);
+	return gstage_set_pte(kvm, pcache, out_map);
 }
 
 enum gstage_op {
@@ -352,7 +354,6 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 			     phys_addr_t hpa, unsigned long size,
 			     bool writable, bool in_atomic)
 {
-	pte_t pte;
 	int ret = 0;
 	unsigned long pfn;
 	phys_addr_t addr, end;
@@ -360,22 +361,25 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
 		.gfp_zero = __GFP_ZERO,
 	};
+	struct kvm_gstage_mapping map;
 
 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(hpa);
 
 	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
-		pte = pfn_pte(pfn, PAGE_KERNEL_IO);
+		map.addr = addr;
+		map.pte = pfn_pte(pfn, PAGE_KERNEL_IO);
+		map.level = 0;
 
 		if (!writable)
-			pte = pte_wrprotect(pte);
+			map.pte = pte_wrprotect(map.pte);
 
 		ret = kvm_mmu_topup_memory_cache(&pcache, gstage_pgd_levels);
 		if (ret)
 			goto out;
 
 		spin_lock(&kvm->mmu_lock);
-		ret = gstage_set_pte(kvm, 0, &pcache, addr, &pte);
+		ret = gstage_set_pte(kvm, &pcache, &map);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			goto out;
@@ -593,7 +597,8 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
-			 gpa_t gpa, unsigned long hva, bool is_write)
+			 gpa_t gpa, unsigned long hva, bool is_write,
+			 struct kvm_gstage_mapping *out_map)
 {
 	int ret;
 	kvm_pfn_t hfn;
@@ -608,6 +613,9 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	unsigned long vma_pagesize, mmu_seq;
 	struct page *page;
 
+	/* Setup initial state of output mapping */
+	memset(out_map, 0, sizeof(*out_map));
+
 	/* We need minimum second+third level pages */
 	ret = kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
 	if (ret) {
@@ -677,10 +685,10 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	if (writable) {
 		mark_page_dirty(kvm, gfn);
 		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
-				      vma_pagesize, false, true);
+				      vma_pagesize, false, true, out_map);
 	} else {
 		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
-				      vma_pagesize, true, true);
+				      vma_pagesize, true, true, out_map);
 	}
 
 	if (ret)
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 965df528de90..6b4694bc07ea 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -15,6 +15,7 @@
 static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			     struct kvm_cpu_trap *trap)
 {
+	struct kvm_gstage_mapping host_map;
 	struct kvm_memory_slot *memslot;
 	unsigned long hva, fault_addr;
 	bool writable;
@@ -43,7 +44,7 @@ static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	}
 
 	ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
-		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
+		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false, &host_map);
 	if (ret < 0)
 		return ret;
 
-- 
2.43.0


