Return-Path: <kvm+bounces-45148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6EEAA62D1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D50C71B655E3
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F976223DFD;
	Thu,  1 May 2025 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cUfbDpZP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306A6223316
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124400; cv=none; b=BcTPmd3F4CsCYBWMsn6N9BcpwNKztoltKXZDwKrIQ/2EPZjKryq8kDq16+/ou9mrYpIH6YyKhAaWuS5YpfT3WbBzMO2Ne2F4CJQoPupmA/ou4DLULucwmInhYCM4iGeNoqdwcFum7V2p0JIXgLnqt3PVAhL772RT9KubfvHftXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124400; c=relaxed/simple;
	bh=FhkQzJGwkzEVuO5O3Z7vY5wsntRd5GGgjIgmxAE3ABU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=toKaVJuH68C7ryNlj/5+2c/ye0AVQNZGDF2/Tkz2dGjBCbQXaKATdfli42hBV1IGhgdV0aTZ7XWGGgEfIXtaO8r6b5V47Psw+v3Ul7pVosGyMJJY9b4qHGlNMMjcbiLWBW1T1Bm5cN/p5QUY94IxHgi/jGo0coeD2hmi5GW51HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cUfbDpZP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-306b590faaeso941662a91.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 11:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746124397; x=1746729197; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7i/6AHA3eZkCG1jysMcZvnPndxc/slissml3q+d5SBw=;
        b=cUfbDpZPhKunxYjTaDExcd4oa8WD1HwgbyjfFDTbKIYBWBZMdyIj+3UpMMG+3wr1dd
         AG58RUXqIlas04WCtEYWxe+NLnl41DnvHzmhd293A65oG6Qk1SgwJA1l/3cDYCUS0NJ/
         bxjZwDF6Nbt2OGHu1MryPVYgzVaC2hzvia7TKdl+Pg/SSiUiqwyf6kHUd92ZCrI8g+im
         +4/P6WimzeeySwhLf1t0WQWgMpCfLX6eAOA6bSb22/e3NX6YFDw/xl4vTBH7qt92jSUB
         GqBfKKjZUYVzCxLwimlF1r4VUAFdBAxvy4+up22SWQ428LzjdmzBiz1VXp6XllAVX9w1
         iPTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124397; x=1746729197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7i/6AHA3eZkCG1jysMcZvnPndxc/slissml3q+d5SBw=;
        b=f/mix7oUA53s7pConQ/Y6ExMkEGlP1PxUV+JWBTOJGJCo4j/651KiEdjviobAIkWro
         JdBou6XkAu9rKNDqVMem1VHQW2PXRv8OGVE2XZM5OaDNp/EeamIJRxXhXKUjc3GmE8DP
         zqotLkTlVj9HevJzqRKhjQPm3ChX7tWSYeF/sLNGW3x6qDgTqBjXi3mAm3azbFuWZVYP
         ZamuPqTQ35dm+m5MBejqEAA/Ez88Z/AlbGXA/alnAz2ihNt3OKreOWLaN0MEAEMOTQrq
         1eTNYfUB2kWXZiPSTPxQFCn10E2MhmvwF8aelOIjy2cYUUZ+P0K5MKny4ZKR1PI9rEGI
         5qEw==
X-Forwarded-Encrypted: i=1; AJvYcCWYyJqBsgYxe6PRugHBib9Vi/VslEImVDbsrrMVWMT6MoknOFySV1MGSjYiIjNd7tZcPxE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjSC7HDvwXAIyijOOeU9MsbimtRWguKcL5AIr+PsPkJ4XBYIMc
	wRZBT3bfwkplmTcTmfuYoiVn56HY/Kw4s0ynAgo7bAtyB5Mv16DhnEb6WitiOwlSgiuLxC5AiO8
	haiOJvJqITw==
X-Google-Smtp-Source: AGHT+IGUo/AnViO59tFfwHLnZghyustUCItXoiR9VXiwCzA3MoONpQDNNc8+fFtBEfWcc27wVlSRjIGNaB+pvQ==
X-Received: from pjbqo15.prod.google.com ([2002:a17:90b:3dcf:b0:2fc:201d:6026])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5147:b0:2ef:114d:7bf8 with SMTP id 98e67ed59e1d1-30a4e5854c9mr258461a91.6.1746124397377;
 Thu, 01 May 2025 11:33:17 -0700 (PDT)
Date: Thu,  1 May 2025 11:32:56 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501183304.2433192-3-dmatlack@google.com>
Subject: [PATCH 02/10] KVM: selftests: Use gpa_t instead of vm_paddr_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, James Houghton <jthoughton@google.com>, 
	Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Replace all occurrences of vm_paddr_t with gpa_t to align with KVM code
and with the conversion helpers (e.g. addr_hva2gpa()). Also replace
vm_paddr in function names with gpa to align with the new type name.

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | \
          xargs sed -i 's/vm_paddr_/gpa_/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/arm64/vgic_lpi_stress.c     | 20 +++++------
 tools/testing/selftests/kvm/dirty_log_test.c  |  2 +-
 .../testing/selftests/kvm/include/arm64/gic.h |  4 +--
 .../selftests/kvm/include/arm64/gic_v3_its.h  |  8 ++---
 .../testing/selftests/kvm/include/kvm_util.h  | 33 +++++++++----------
 .../selftests/kvm/include/kvm_util_types.h    |  2 +-
 .../selftests/kvm/include/riscv/ucall.h       |  2 +-
 .../selftests/kvm/include/s390/ucall.h        |  2 +-
 .../selftests/kvm/include/ucall_common.h      |  4 +--
 tools/testing/selftests/kvm/include/x86/sev.h |  2 +-
 .../testing/selftests/kvm/include/x86/ucall.h |  2 +-
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 .../testing/selftests/kvm/lib/arm64/gic_v3.c  |  4 +--
 .../selftests/kvm/lib/arm64/gic_v3_its.c      | 12 +++----
 .../selftests/kvm/lib/arm64/processor.c       |  2 +-
 tools/testing/selftests/kvm/lib/arm64/ucall.c |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++------
 tools/testing/selftests/kvm/lib/memstress.c   |  2 +-
 .../selftests/kvm/lib/riscv/processor.c       |  2 +-
 .../selftests/kvm/lib/s390/processor.c        |  4 +--
 .../testing/selftests/kvm/lib/ucall_common.c  |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  2 +-
 tools/testing/selftests/kvm/lib/x86/sev.c     |  2 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |  4 +--
 .../selftests/kvm/s390/ucontrol_test.c        |  2 +-
 tools/testing/selftests/kvm/steal_time.c      |  4 +--
 .../testing/selftests/kvm/x86/hyperv_clock.c  |  2 +-
 .../kvm/x86/hyperv_extended_hypercalls.c      |  2 +-
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |  8 ++---
 .../selftests/kvm/x86/kvm_clock_test.c        |  4 +--
 30 files changed, 82 insertions(+), 84 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index fc4fe52fb6f8..3cb3f5d6ea8b 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -23,7 +23,7 @@
 #define GIC_LPI_OFFSET	8192
 
 static size_t nr_iterations = 1000;
-static vm_paddr_t gpa_base;
+static gpa_t gpa_base;
 
 static struct kvm_vm *vm;
 static struct kvm_vcpu **vcpus;
@@ -35,14 +35,14 @@ static struct test_data {
 	u32		nr_devices;
 	u32		nr_event_ids;
 
-	vm_paddr_t	device_table;
-	vm_paddr_t	collection_table;
-	vm_paddr_t	cmdq_base;
+	gpa_t		device_table;
+	gpa_t		collection_table;
+	gpa_t		cmdq_base;
 	void		*cmdq_base_va;
-	vm_paddr_t	itt_tables;
+	gpa_t		itt_tables;
 
-	vm_paddr_t	lpi_prop_table;
-	vm_paddr_t	lpi_pend_tables;
+	gpa_t		lpi_prop_table;
+	gpa_t		lpi_pend_tables;
 } test_data =  {
 	.nr_cpus	= 1,
 	.nr_devices	= 1,
@@ -73,7 +73,7 @@ static void guest_setup_its_mappings(void)
 	/* Round-robin the LPIs to all of the vCPUs in the VM */
 	coll_id = 0;
 	for (device_id = 0; device_id < nr_devices; device_id++) {
-		vm_paddr_t itt_base = test_data.itt_tables + (device_id * SZ_64K);
+		gpa_t itt_base = test_data.itt_tables + (device_id * SZ_64K);
 
 		its_send_mapd_cmd(test_data.cmdq_base_va, device_id,
 				  itt_base, SZ_64K, true);
@@ -183,7 +183,7 @@ static void setup_test_data(void)
 	size_t pages_per_64k = vm_calc_num_guest_pages(vm->mode, SZ_64K);
 	u32 nr_devices = test_data.nr_devices;
 	u32 nr_cpus = test_data.nr_cpus;
-	vm_paddr_t cmdq_base;
+	gpa_t cmdq_base;
 
 	test_data.device_table = vm_phy_pages_alloc(vm, pages_per_64k,
 						    gpa_base,
@@ -222,7 +222,7 @@ static void setup_gic(void)
 
 static void signal_lpi(u32 device_id, u32 event_id)
 {
-	vm_paddr_t db_addr = GITS_BASE_GPA + GITS_TRANSLATER;
+	gpa_t db_addr = GITS_BASE_GPA + GITS_TRANSLATER;
 
 	struct kvm_msi msi = {
 		.address_lo	= db_addr,
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 23593d9eeba9..a7744974663b 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -669,7 +669,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
 
 	/* Cache the HVA pointer of the region */
-	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
+	host_test_mem = addr_gpa2hva(vm, (gpa_t)guest_test_phys_mem);
 
 	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, host_page_size);
diff --git a/tools/testing/selftests/kvm/include/arm64/gic.h b/tools/testing/selftests/kvm/include/arm64/gic.h
index baeb3c859389..7dbecc6daa4e 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic.h
@@ -58,7 +58,7 @@ void gic_irq_clear_pending(unsigned int intid);
 bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);
 
-void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
-			   vm_paddr_t pend_table);
+void gic_rdist_enable_lpis(gpa_t cfg_table, size_t cfg_table_size,
+			   gpa_t pend_table);
 
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
index 3722ed9c8f96..57eabcd64104 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
@@ -5,11 +5,11 @@
 
 #include <linux/sizes.h>
 
-void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
-	      vm_paddr_t device_tbl, size_t device_tbl_sz,
-	      vm_paddr_t cmdq, size_t cmdq_size);
+void its_init(gpa_t coll_tbl, size_t coll_tbl_sz,
+	      gpa_t device_tbl, size_t device_tbl_sz,
+	      gpa_t cmdq, size_t cmdq_size);
 
-void its_send_mapd_cmd(void *cmdq_base, u32 device_id, vm_paddr_t itt_base,
+void its_send_mapd_cmd(void *cmdq_base, u32 device_id, gpa_t itt_base,
 		       size_t itt_size, bool valid);
 void its_send_mapc_cmd(void *cmdq_base, u32 vcpu_id, u32 collection_id, bool valid);
 void its_send_mapti_cmd(void *cmdq_base, u32 device_id, u32 event_id,
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 4b7012bd8041..67ac59f66b6e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -98,8 +98,8 @@ struct kvm_vm {
 	struct sparsebit *vpages_mapped;
 	bool has_irqchip;
 	bool pgd_created;
-	vm_paddr_t ucall_mmio_addr;
-	vm_paddr_t pgd;
+	gpa_t ucall_mmio_addr;
+	gpa_t pgd;
 	gva_t handlers;
 	uint32_t dirty_ring_size;
 	uint64_t gpa_tag_mask;
@@ -616,16 +616,16 @@ gva_t gva_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	      unsigned int npages);
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
+void *addr_gpa2hva(struct kvm_vm *vm, gpa_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
-vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
-void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
+gpa_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
+void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa);
 
 #ifndef vcpu_arch_put_guest
 #define vcpu_arch_put_guest(mem, val) do { (mem) = (val); } while (0)
 #endif
 
-static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+static inline gpa_t vm_untag_gpa(struct kvm_vm *vm, gpa_t gpa)
 {
 	return gpa & ~vm->gpa_tag_mask;
 }
@@ -876,15 +876,14 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot);
-vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-				vm_paddr_t paddr_min, uint32_t memslot,
-				bool protected);
-vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, uint32_t memslot);
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			   gpa_t paddr_min, uint32_t memslot,
+			   bool protected);
+gpa_t vm_alloc_page_table(struct kvm_vm *vm);
 
-static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-					    vm_paddr_t paddr_min, uint32_t memslot)
+static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				       gpa_t paddr_min, uint32_t memslot)
 {
 	/*
 	 * By default, allocate memory as protected for VMs that support
@@ -1104,9 +1103,9 @@ static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr
  * Returns the VM physical address of the translated VM virtual
  * address given by @gva.
  */
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva);
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva);
 
-static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, gva_t gva)
+static inline gpa_t addr_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	return addr_arch_gva2gpa(vm, gva);
 }
@@ -1148,7 +1147,7 @@ void kvm_selftest_arch_init(void);
 
 void kvm_arch_vm_post_create(struct kvm_vm *vm);
 
-bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
+bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
index a53e04286554..224a29cea790 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_types.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
@@ -14,7 +14,7 @@
 #define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
 #define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
 
-typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
+typedef uint64_t gpa_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t gva_t; /* Virtual Machine (Guest) virtual address */
 
 #endif /* SELFTEST_KVM_UTIL_TYPES_H */
diff --git a/tools/testing/selftests/kvm/include/riscv/ucall.h b/tools/testing/selftests/kvm/include/riscv/ucall.h
index 41d56254968e..2de7c6a36096 100644
--- a/tools/testing/selftests/kvm/include/riscv/ucall.h
+++ b/tools/testing/selftests/kvm/include/riscv/ucall.h
@@ -7,7 +7,7 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_RISCV_SBI
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+static inline void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/include/s390/ucall.h b/tools/testing/selftests/kvm/include/s390/ucall.h
index befee84c4609..3907d629304f 100644
--- a/tools/testing/selftests/kvm/include/s390/ucall.h
+++ b/tools/testing/selftests/kvm/include/s390/ucall.h
@@ -6,7 +6,7 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_S390_SIEIC
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+static inline void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index e5499f170834..1db399c00d02 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -29,7 +29,7 @@ struct ucall {
 	struct ucall *hva;
 };
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa);
 void ucall_arch_do_ucall(gva_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
@@ -39,7 +39,7 @@ __printf(5, 6) void ucall_assert(uint64_t cmd, const char *exp,
 				 const char *file, unsigned int line,
 				 const char *fmt, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
-void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
 
 /*
diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index 82c11c81a956..9aefe83e16b8 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -82,7 +82,7 @@ static inline void sev_register_encrypted_memory(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
 }
 
-static inline void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
+static inline void sev_launch_update_data(struct kvm_vm *vm, gpa_t gpa,
 					  uint64_t size)
 {
 	struct kvm_sev_launch_update_data update_data = {
diff --git a/tools/testing/selftests/kvm/include/x86/ucall.h b/tools/testing/selftests/kvm/include/x86/ucall.h
index d3825dcc3cd9..0e4950041e3e 100644
--- a/tools/testing/selftests/kvm/include/x86/ucall.h
+++ b/tools/testing/selftests/kvm/include/x86/ucall.h
@@ -6,7 +6,7 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_IO
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+static inline void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 6e909a96b095..6cf1fa092752 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -284,7 +284,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
 
 	/* Cache the HVA pointer of the region */
-	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
+	host_test_mem = addr_gpa2hva(vm, (gpa_t)guest_test_phys_mem);
 
 	/* Export shared structure test_args to guest */
 	sync_global_to_guest(vm, test_args);
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
index 66d05506f78b..911650132446 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
@@ -402,8 +402,8 @@ const struct gic_common_ops gicv3_ops = {
 	.gic_irq_set_config = gicv3_irq_set_config,
 };
 
-void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
-			   vm_paddr_t pend_table)
+void gic_rdist_enable_lpis(gpa_t cfg_table, size_t cfg_table_size,
+			   gpa_t pend_table)
 {
 	volatile void *rdist_base = gicr_base_cpu(guest_get_vcpuid());
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
index 09f270545646..37ef53b8fa33 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
@@ -52,7 +52,7 @@ static unsigned long its_find_baser(unsigned int type)
 	return -1;
 }
 
-static void its_install_table(unsigned int type, vm_paddr_t base, size_t size)
+static void its_install_table(unsigned int type, gpa_t base, size_t size)
 {
 	unsigned long offset = its_find_baser(type);
 	u64 baser;
@@ -67,7 +67,7 @@ static void its_install_table(unsigned int type, vm_paddr_t base, size_t size)
 	its_write_u64(offset, baser);
 }
 
-static void its_install_cmdq(vm_paddr_t base, size_t size)
+static void its_install_cmdq(gpa_t base, size_t size)
 {
 	u64 cbaser;
 
@@ -80,9 +80,9 @@ static void its_install_cmdq(vm_paddr_t base, size_t size)
 	its_write_u64(GITS_CBASER, cbaser);
 }
 
-void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
-	      vm_paddr_t device_tbl, size_t device_tbl_sz,
-	      vm_paddr_t cmdq, size_t cmdq_size)
+void its_init(gpa_t coll_tbl, size_t coll_tbl_sz,
+	      gpa_t device_tbl, size_t device_tbl_sz,
+	      gpa_t cmdq, size_t cmdq_size)
 {
 	u32 ctlr;
 
@@ -197,7 +197,7 @@ static void its_send_cmd(void *cmdq_base, struct its_cmd_block *cmd)
 	}
 }
 
-void its_send_mapd_cmd(void *cmdq_base, u32 device_id, vm_paddr_t itt_base,
+void its_send_mapd_cmd(void *cmdq_base, u32 device_id, gpa_t itt_base,
 		       size_t itt_size, bool valid)
 {
 	struct its_cmd_block cmd = {};
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 102b0b829420..e57b757b4256 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -223,7 +223,7 @@ uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva)
 	exit(EXIT_FAILURE);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep = virt_get_pte_hva(vm, gva);
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/ucall.c b/tools/testing/selftests/kvm/lib/arm64/ucall.c
index a1a3b4dcdce1..62109407a1ff 100644
--- a/tools/testing/selftests/kvm/lib/arm64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/arm64/ucall.c
@@ -8,7 +8,7 @@
 
 gva_t *ucall_exit_mmio_addr;
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 	gva_t mmio_gva = gva_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2e6d275d4ba0..6dd2755fdb7b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1446,7 +1446,7 @@ static gva_t ____gva_alloc(struct kvm_vm *vm, size_t sz,
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = __vm_phy_pages_alloc(vm, pages,
+	gpa_t paddr = __vm_phy_pages_alloc(vm, pages,
 						KVM_UTIL_MIN_PFN * vm->page_size,
 						vm->memslots[type], protected);
 
@@ -1600,7 +1600,7 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
  * address providing the memory to the vm physical address is returned.
  * A TEST_ASSERT failure occurs if no region containing gpa exists.
  */
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
+void *addr_gpa2hva(struct kvm_vm *vm, gpa_t gpa)
 {
 	struct userspace_mem_region *region;
 
@@ -1633,7 +1633,7 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
  * VM physical address is returned. A TEST_ASSERT failure occurs if no
  * region containing hva exists.
  */
-vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
+gpa_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 {
 	struct rb_node *node;
 
@@ -1644,7 +1644,7 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 		if (hva >= region->host_mem) {
 			if (hva <= (region->host_mem
 				+ region->region.memory_size - 1))
-				return (vm_paddr_t)((uintptr_t)
+				return (gpa_t)((uintptr_t)
 					region->region.guest_phys_addr
 					+ (hva - (uintptr_t)region->host_mem));
 
@@ -1676,7 +1676,7 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
  * memory without mapping said memory in the guest's address space. And, for
  * userfaultfd-based demand paging, to do so without triggering userfaults.
  */
-void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
+void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa)
 {
 	struct userspace_mem_region *region;
 	uintptr_t offset;
@@ -2069,9 +2069,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-				vm_paddr_t paddr_min, uint32_t memslot,
-				bool protected)
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			   gpa_t paddr_min, uint32_t memslot,
+			   bool protected)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -2115,13 +2115,12 @@ vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return base * vm->page_size;
 }
 
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot)
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, uint32_t memslot)
 {
 	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
 }
 
-vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
+gpa_t vm_alloc_page_table(struct kvm_vm *vm)
 {
 	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
 				 vm->memslots[MEM_REGION_PT]);
@@ -2303,7 +2302,7 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	kvm_selftest_arch_init();
 }
 
-bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
+bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr)
 {
 	sparsebit_idx_t pg = 0;
 	struct userspace_mem_region *region;
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 313277486a1d..d51680509839 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -207,7 +207,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	/* Add extra memory slots for testing */
 	for (i = 0; i < slots; i++) {
 		uint64_t region_pages = guest_num_pages / slots;
-		vm_paddr_t region_start = args->gpa + region_pages * args->guest_page_size * i;
+		gpa_t region_start = args->gpa + region_pages * args->guest_page_size * i;
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    MEMSTRESS_MEM_SLOT_INDEX + i,
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 3ba5163c72b3..c4717aad1b3c 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -123,7 +123,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 		PGTBL_PTE_PERM_MASK | PGTBL_PTE_VALID_MASK;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep;
 	int level = vm->pgtable_levels - 1;
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index a6438e3ea8e7..2baafbe608ac 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -12,7 +12,7 @@
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	vm_paddr_t paddr;
+	gpa_t paddr;
 
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
@@ -86,7 +86,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 	entry[idx] = gpa;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int ri, idx;
 	uint64_t *entry;
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 3a72169b61ac..60297819d508 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -25,7 +25,7 @@ int ucall_nr_pages_required(uint64_t page_size)
  */
 static struct ucall_header *ucall_pool;
 
-void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 	struct ucall_header *hdr;
 	struct ucall *uc;
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 3ff61033790e..5a97cf829291 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -463,7 +463,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 	segp->present = true;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int level = PG_LEVEL_NONE;
 	uint64_t *pte = __vm_get_page_table_entry(vm, gva, &level);
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index e9535ee20b7f..5fcd26ac2def 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -17,7 +17,7 @@
 static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)
 {
 	const struct sparsebit *protected_phy_pages = region->protected_phy_pages;
-	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
+	const gpa_t gpa_base = region->region.guest_phys_addr;
 	const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;
 	sparsebit_idx_t i, j;
 
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index e166e20544d3..c0ec7b284a3d 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -24,7 +24,7 @@ union sbi_pmu_ctr_info ctrinfo_arr[RISCV_MAX_PMU_COUNTERS];
 /* Snapshot shared memory data */
 #define PMU_SNAPSHOT_GPA_BASE		BIT(30)
 static void *snapshot_gva;
-static vm_paddr_t snapshot_gpa;
+static gpa_t snapshot_gpa;
 
 static int vcpu_shared_irq_count;
 static int counter_in_use;
@@ -241,7 +241,7 @@ static inline void verify_sbi_requirement_assert(void)
 		__GUEST_ASSERT(0, "SBI implementation version doesn't support PMU Snapshot");
 }
 
-static void snapshot_set_shmem(vm_paddr_t gpa, unsigned long flags)
+static void snapshot_set_shmem(gpa_t gpa, unsigned long flags)
 {
 	unsigned long lo = (unsigned long)gpa;
 #if __riscv_xlen == 32
diff --git a/tools/testing/selftests/kvm/s390/ucontrol_test.c b/tools/testing/selftests/kvm/s390/ucontrol_test.c
index d265b34c54be..d9f0584978a9 100644
--- a/tools/testing/selftests/kvm/s390/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390/ucontrol_test.c
@@ -111,7 +111,7 @@ FIXTURE(uc_kvm)
 	uintptr_t base_hva;
 	uintptr_t code_hva;
 	int kvm_run_size;
-	vm_paddr_t pgd;
+	gpa_t pgd;
 	void *vm_mem;
 	int vcpu_fd;
 	int kvm_fd;
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 24eaabe372bc..fd931243b6ce 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -210,7 +210,7 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 /* SBI STA shmem must have 64-byte alignment */
 #define STEAL_TIME_SIZE		((sizeof(struct sta_struct) + 63) & ~63)
 
-static vm_paddr_t st_gpa[NR_VCPUS];
+static gpa_t st_gpa[NR_VCPUS];
 
 struct sta_struct {
 	uint32_t sequence;
@@ -220,7 +220,7 @@ struct sta_struct {
 	uint8_t pad[47];
 } __packed;
 
-static void sta_set_shmem(vm_paddr_t gpa, unsigned long flags)
+static void sta_set_shmem(gpa_t gpa, unsigned long flags)
 {
 	unsigned long lo = (unsigned long)gpa;
 #if __riscv_xlen == 32
diff --git a/tools/testing/selftests/kvm/x86/hyperv_clock.c b/tools/testing/selftests/kvm/x86/hyperv_clock.c
index 046d33ec69fc..dd8ce5686736 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_clock.c
@@ -98,7 +98,7 @@ static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
 	GUEST_ASSERT(r2 >= t1 && r2 - t2 < 100000);
 }
 
-static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_gpa)
+static void guest_main(struct ms_hyperv_tsc_page *tsc_page, gpa_t tsc_page_gpa)
 {
 	u64 tsc_scale, tsc_offset;
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
index 43e1c5149d97..f2d990ce4e2b 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
@@ -15,7 +15,7 @@
 /* Any value is fine */
 #define EXT_CAPABILITIES 0xbull
 
-static void guest_code(vm_paddr_t in_pg_gpa, vm_paddr_t out_pg_gpa,
+static void guest_code(gpa_t in_pg_gpa, gpa_t out_pg_gpa,
 		       gva_t out_pg_gva)
 {
 	uint64_t *output_gva;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index aa795f9a5950..bc5828ce505e 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -62,7 +62,7 @@ struct hv_tlb_flush_ex {
  */
 struct test_data {
 	gva_t hcall_gva;
-	vm_paddr_t hcall_gpa;
+	gpa_t hcall_gpa;
 	gva_t test_pages;
 	gva_t test_pages_pte[NTEST_PAGES];
 };
@@ -133,7 +133,7 @@ static void set_expected_val(void *addr, u64 val, int vcpu_id)
  * Update PTEs swapping two test pages.
  * TODO: use swap()/xchg() when these are provided.
  */
-static void swap_two_test_pages(vm_paddr_t pte_gva1, vm_paddr_t pte_gva2)
+static void swap_two_test_pages(gpa_t pte_gva1, gpa_t pte_gva2)
 {
 	uint64_t tmp = *(uint64_t *)pte_gva1;
 
@@ -201,7 +201,7 @@ static void sender_guest_code(gva_t test_data)
 	struct test_data *data = (struct test_data *)test_data;
 	struct hv_tlb_flush *flush = (struct hv_tlb_flush *)data->hcall_gva;
 	struct hv_tlb_flush_ex *flush_ex = (struct hv_tlb_flush_ex *)data->hcall_gva;
-	vm_paddr_t hcall_gpa = data->hcall_gpa;
+	gpa_t hcall_gpa = data->hcall_gpa;
 	int i, stage = 1;
 
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
@@ -582,7 +582,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu[3];
 	pthread_t threads[2];
 	gva_t test_data_page, gva;
-	vm_paddr_t gpa;
+	gpa_t gpa;
 	uint64_t *pte;
 	struct test_data *data;
 	struct ucall uc;
diff --git a/tools/testing/selftests/kvm/x86/kvm_clock_test.c b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
index b335ee2a8e97..ada4b2abf55d 100644
--- a/tools/testing/selftests/kvm/x86/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
@@ -31,7 +31,7 @@ static struct test_case test_cases[] = {
 #define GUEST_SYNC_CLOCK(__stage, __val)			\
 		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
 
-static void guest_main(vm_paddr_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
+static void guest_main(gpa_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
 {
 	int i;
 
@@ -136,7 +136,7 @@ int main(void)
 {
 	struct kvm_vcpu *vcpu;
 	gva_t pvti_gva;
-	vm_paddr_t pvti_gpa;
+	gpa_t pvti_gpa;
 	struct kvm_vm *vm;
 	int flags;
 
-- 
2.49.0.906.g1f30a19c02-goog


