Return-Path: <kvm+bounces-48482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8EAACE9F9
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFE79171074
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259BC2153FB;
	Thu,  5 Jun 2025 06:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="G2AairEB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99EB211711
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104146; cv=none; b=p79z0wE5aQsL+iWbc1G2LHcZTHic7YawbOaNkFLvpYd8J8CL3brd2xTqvniPFK6qwl2VMHuZ0pNis98Y04AUhFh+PBPrL7jGmvVWnllRNhP/Dh7ZRf1yGHoDCkGcA+h1sAPd7Tf3auzDA67pR81HNwd900ofPCKTFFXQxlgOyCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104146; c=relaxed/simple;
	bh=6sszuUfccYuEtJctsI5BNx1ZHbTwew1hmbwnSMnNPl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szvt1Kwp6ZP/wkMMrZG4p7fhlJWg7NeUCrpHzA0vJbfP4p/iwqtgRMJJIqWWOlO6Dsmx5MORYwJxL/tFL+B3UVrlK/EQ3b7ZllTtMAFe9FUxnDz+g+jB7ZAosPh+m75QUwQhbMhj7T/9yP/dVjfHzzM8PHk8I57IEweAHvr9cLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=G2AairEB; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2349f096605so7052055ad.3
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104144; x=1749708944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZLXSy5dKdnrCLdxDNwluOSVBrj34xrZ5br2B7QUPFM=;
        b=G2AairEBuM94wAjFcm6qq6RM6ARY5RGxyZGFQ16ABMetm8uotzHfENwYxMrkQMBflJ
         V5qiFgt6WqjyA53fSA8bszeC1Mb9OU1mDJO8M/67Fe79PeIUbCZoywmn41mUVqlOxRdt
         plX2gNDQ+FE9iHDf3i0wY+HZblxHk7rgyM8MUqiqZFWUnLlikhExsdkoqIKgwjBIkvv6
         TS2C0WpUvQvETMXwqFLLeugTiWVB5awTbU6BLYinWvdv3DwsVZ11zBR2LxCcVgsiuzd4
         ekfVZHOea+IPogteJJjKpjygyIIkLySE/joj0+3FHGE7pgSPH0wOg5kM+ZxptQHhxptV
         1dIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104144; x=1749708944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZLXSy5dKdnrCLdxDNwluOSVBrj34xrZ5br2B7QUPFM=;
        b=NyjUytvrMHLNEzKSPe68gsrl+1nBKpeIILWHrluFZAPfA0+i1ljpsPXpPk+m+itSgW
         vv+t7XOeRO+lGWUC7RkHT24NlpmGUJc3EHcBrD2imLMUpUQMhtXz3089Rh5LVHAOrrmC
         v5kbueFL97ylT/GFQH4yRdBJhZ2HOYXcF6ZVMJ2mGAU6aZNhMAxF0RBK1iR/0WNjr4M0
         m/kyEBmMQGtKkoQlOyzE5Kn5T1zNKdRJ1ddPNAq+GAVw2M5S5zSicmdq1rkCHNDFxOB6
         LndG0Uv/cdJxHdkSygww26Igms0u059BnJG3xuMepJSn7chDBVPTdEL5/A92AuANOFOQ
         70jg==
X-Forwarded-Encrypted: i=1; AJvYcCWlnZs8ybenWgt6Dzqv1K+omvdS63Pr3rvqDCFVThv+x94Ok6WVKsjGjSEbXh5349f7Cgg=@vger.kernel.org
X-Gm-Message-State: AOJu0YycjAA7SkqENPIrZ5JUhMq31AupVLhYzB7bf+X44H6RXGuOHemW
	DXFKCPuTR44844VLNDw7hSpPQnDo/K0WftYizrY5gNgQFzvMPOAvVWTpHPgF2EwA2ho=
X-Gm-Gg: ASbGnctitYJMLEzDAma50/O6+ouVrSiN13XTB10wfNrJ1BQvcA9WK2LKVfAcly1hwV3
	BBBESaVY+EuE9PWAbdOZhtOqbR5Mg2P+L9n5OpveLEmn0aQ9joGjHKLEVHwZm4BFabDtVF49Ju8
	HcrVbOu3Wl2JtpA3KjYJPG+EPlCN5l5Ov1kYAlagWk5h50JdHcGnm2lI8HeS/5wvO2GEIuIZHr5
	XcwdOImIAoUP924yNoquyNKo+Wdn/a4HnHLK28vf/Wmw+xCIhBO9m77eKgOObz3hlk5qT4FYNc2
	c0BMD8P21Rcjf3ScNu0v4buNHiJjrQpHO9Oinl92/t6fmsZUyUMCewfZKsnTng2pF2NAXiAYFx9
	dkAZaNGTebC6xB86Y
X-Google-Smtp-Source: AGHT+IFO2epwN2LjtG31OoHm0egnGNF3it3sm9FcAWa7tNOhP+eBWwaD0IdyHqo/ELqbwOrF1xeE1A==
X-Received: by 2002:a17:903:230d:b0:234:8f5d:e3bd with SMTP id d9443c01a7336-235e11ebbaemr80514335ad.39.1749104143890;
        Wed, 04 Jun 2025 23:15:43 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:43 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 10/13] RISC-V: KVM: Introduce struct kvm_gstage_mapping
Date: Thu,  5 Jun 2025 11:44:55 +0530
Message-ID: <20250605061458.196003-11-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce struct kvm_gstage_mapping which represents a g-stage
mapping at a particular page table level of the g-stage. Also,
update the kvm_riscv_gstage_map() to return the g-stage mapping
upon success.

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
index c9d87e7472fb..934c97c21130 100644
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
@@ -350,7 +352,6 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 			     phys_addr_t hpa, unsigned long size,
 			     bool writable, bool in_atomic)
 {
-	pte_t pte;
 	int ret = 0;
 	unsigned long pfn;
 	phys_addr_t addr, end;
@@ -358,22 +359,25 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
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
@@ -591,7 +595,8 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
-			 gpa_t gpa, unsigned long hva, bool is_write)
+			 gpa_t gpa, unsigned long hva, bool is_write,
+			 struct kvm_gstage_mapping *out_map)
 {
 	int ret;
 	kvm_pfn_t hfn;
@@ -606,6 +611,9 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	unsigned long vma_pagesize, mmu_seq;
 	struct page *page;
 
+	/* Setup initial state of output mapping */
+	memset(out_map, 0, sizeof(*out_map));
+
 	/* We need minimum second+third level pages */
 	ret = kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
 	if (ret) {
@@ -675,10 +683,10 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
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
index cc82bbab0e24..4fadf2bcd070 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -14,6 +14,7 @@
 static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			     struct kvm_cpu_trap *trap)
 {
+	struct kvm_gstage_mapping host_map;
 	struct kvm_memory_slot *memslot;
 	unsigned long hva, fault_addr;
 	bool writable;
@@ -42,7 +43,7 @@ static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	}
 
 	ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
-		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
+		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false, &host_map);
 	if (ret < 0)
 		return ret;
 
-- 
2.43.0


