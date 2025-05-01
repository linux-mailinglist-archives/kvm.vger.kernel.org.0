Return-Path: <kvm+bounces-45149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 108BFAA62D2
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 321114A6FAC
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B721C224883;
	Thu,  1 May 2025 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DZT52K8v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF162144CF
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124400; cv=none; b=qU2dfw8ysndv0RX8pWgzJRiosB4Usc3U+j/jfwaS80EivtUGi7uL8ILjf5SVGiXOz3yjqNBpoQ6lqQC/yWD2mSBfAWTlZwaPHDasHGW6GkuVVSibr8G0kPPsW4Bcs6fneKqalDFBxuI4tZ4TdtMnq+qqlAJdmsVzhZ9E5y/43mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124400; c=relaxed/simple;
	bh=f32KjIptMcuCfHTlM1ASfP/B8/4Pp0nzb+wpUvj2IQU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PwK6jdTf/Ddv6Qvk2UjmXZ0FDFO1AySLvZ8wNgLORLcyTxpsdI7f3QEgrrKlD6cNrcIjR/2BIowmb6QocfLy/SiTEdIZtNqPbySRqnQuNpGIMCCJRt4VkzF6CufJGB+eLrMxEBYBrt870tPuO7CMf+s0fRuK2TU4LwbrJ/gtUpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DZT52K8v; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22aa75e6653so10344915ad.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 11:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746124396; x=1746729196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rDlExpp3n5KZ1NyOesTuTzyrsEDUylmRAN3IWj3leq4=;
        b=DZT52K8vJezlU4gZHg0VLA0L987GnOzRIT0Vg4erf7eVyKvJgWuRZ7p7qtwWGyTbva
         SAl7oIHguPv0qZsCaSe/DphrhS7Nv6YPcXIqG5+kWmscZdXsG4hC/a5dRCm6uBgwa8hk
         OlBp+VhT2ZH+CHbbFevQOh77DAXgV6OgiqfSWykdTDIxkgS0W4qY7P0nW73jGcz1QdGI
         cKacsp48YY5GvZO5Jv3uFCZ9N4ZgP07cJmHYv4hRDXC7Q/jBAtj7VA5xyXxeVbtEPWt6
         soVxwKy4zEcy8y3t4sQPMvRjHLZjVFllAbMhxEXAbQTNkChKGvy5OXykL0AmA10Z+mNL
         81pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124396; x=1746729196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rDlExpp3n5KZ1NyOesTuTzyrsEDUylmRAN3IWj3leq4=;
        b=hs/HLwZFbqPkNiU3X3xRgxub5vyzhgDecrXeiFHVLiKb3LnrUIgV+VPf54Fd8FHf2k
         HNuLNwr7qoBxsK/geb1VjSar/jg5JFO54G6iKurczACMiJ6CurOmm0wni19i0TrOhYtz
         F0GuDgh83tjRKFNV4BVFDlq2HratoKgxagtOHrqIZhRbuCAmRZSpRDY7G+MRftC5ESao
         qxqJtOhDBiCiRLHUa4Wzh7tf3hWAb/Gxg0Yt0KykQxPISDcxgJ8B/uD6jN4GVxWbwsUE
         OcEogkboM0qQQIsW4XtrEJbw/S8X+7ng6yTKucm2zJbIiA2+n+ItRPG8yqAEIcBx+awF
         sG1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhh3U1m/5JDBFMqFugLJjumCvyG/eRM/69NbL6ZXqlOjaxOWBGuaQZ6ds1THmDwngpNz4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7d2NQSJKjwupUq6sPOgufwLtEWRXNCReqI9hND/lW3JP/7bC+
	K/jXj7h1x7nhpYaQqOTytNOoxtkTH1BK/I5F8SHvxm3+PNm2xqYz72h0exVIuES8uLw47PxKZ9T
	5GHNScfD0Sg==
X-Google-Smtp-Source: AGHT+IHSxNDZSni1tfj+AFhiSBKf7zUiTbe1J7HGguPsJsecH1VwXegqIXc0m0TJAPnkcQcFiMRcMn7obeGPFA==
X-Received: from plri8.prod.google.com ([2002:a17:903:32c8:b0:22d:e553:86eb])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:fc47:b0:223:4816:3e9e with SMTP id d9443c01a7336-22e1031e332mr1434415ad.13.1746124395675;
 Thu, 01 May 2025 11:33:15 -0700 (PDT)
Date: Thu,  1 May 2025 11:32:55 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501183304.2433192-2-dmatlack@google.com>
Subject: [PATCH 01/10] KVM: selftests: Use gva_t instead of vm_vaddr_t
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

Replace all occurrences of vm_vaddr_t with gva_t to align with KVM code
and with the conversion helpers (e.g. addr_gva2hva()). Also replace
vm_vaddr in function names with gva to align with the new type name.

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | \
          xargs sed -i 's/vm_vaddr_/gva_/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  6 +--
 .../selftests/kvm/include/arm64/processor.h   |  2 +-
 .../selftests/kvm/include/arm64/ucall.h       |  4 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 36 ++++++-------
 .../selftests/kvm/include/kvm_util_types.h    |  2 +-
 .../selftests/kvm/include/riscv/ucall.h       |  2 +-
 .../selftests/kvm/include/s390/ucall.h        |  2 +-
 .../selftests/kvm/include/ucall_common.h      |  4 +-
 .../selftests/kvm/include/x86/hyperv.h        | 10 ++--
 .../selftests/kvm/include/x86/kvm_util_arch.h |  6 +--
 .../selftests/kvm/include/x86/svm_util.h      |  2 +-
 tools/testing/selftests/kvm/include/x86/vmx.h |  2 +-
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 .../selftests/kvm/lib/arm64/processor.c       | 28 +++++-----
 tools/testing/selftests/kvm/lib/arm64/ucall.c |  6 +--
 tools/testing/selftests/kvm/lib/elf.c         |  6 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 51 +++++++++----------
 .../selftests/kvm/lib/riscv/processor.c       | 16 +++---
 .../selftests/kvm/lib/s390/processor.c        |  8 +--
 .../testing/selftests/kvm/lib/ucall_common.c  | 12 ++---
 tools/testing/selftests/kvm/lib/x86/hyperv.c  | 10 ++--
 .../testing/selftests/kvm/lib/x86/memstress.c |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 30 +++++------
 tools/testing/selftests/kvm/lib/x86/svm.c     | 10 ++--
 tools/testing/selftests/kvm/lib/x86/ucall.c   |  2 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 20 ++++----
 .../selftests/kvm/riscv/sbi_pmu_test.c        |  2 +-
 tools/testing/selftests/kvm/s390/memop.c      | 18 +++----
 tools/testing/selftests/kvm/s390/tprot.c      | 10 ++--
 tools/testing/selftests/kvm/steal_time.c      |  2 +-
 tools/testing/selftests/kvm/x86/amx_test.c    |  8 +--
 tools/testing/selftests/kvm/x86/cpuid_test.c  |  6 +--
 .../testing/selftests/kvm/x86/hyperv_clock.c  |  4 +-
 .../testing/selftests/kvm/x86/hyperv_evmcs.c  |  8 +--
 .../kvm/x86/hyperv_extended_hypercalls.c      | 10 ++--
 .../selftests/kvm/x86/hyperv_features.c       | 12 ++---
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  | 10 ++--
 .../selftests/kvm/x86/hyperv_svm_test.c       |  8 +--
 .../selftests/kvm/x86/hyperv_tlb_flush.c      | 20 ++++----
 .../selftests/kvm/x86/kvm_clock_test.c        |  4 +-
 .../selftests/kvm/x86/nested_emulation_test.c |  2 +-
 .../kvm/x86/nested_exceptions_test.c          |  2 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |  6 +--
 tools/testing/selftests/kvm/x86/smm_test.c    |  2 +-
 tools/testing/selftests/kvm/x86/state_test.c  |  2 +-
 .../selftests/kvm/x86/svm_int_ctl_test.c      |  2 +-
 .../kvm/x86/svm_nested_shutdown_test.c        |  2 +-
 .../kvm/x86/svm_nested_soft_inject_test.c     |  6 +--
 .../selftests/kvm/x86/svm_vmcall_test.c       |  2 +-
 .../kvm/x86/triple_fault_event_test.c         |  4 +-
 .../selftests/kvm/x86/vmx_apic_access_test.c  |  2 +-
 .../kvm/x86/vmx_close_while_nested_test.c     |  2 +-
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  2 +-
 .../kvm/x86/vmx_invalid_nested_guest_state.c  |  2 +-
 .../kvm/x86/vmx_nested_tsc_scaling_test.c     |  2 +-
 .../kvm/x86/vmx_preemption_timer_test.c       |  2 +-
 .../selftests/kvm/x86/vmx_tsc_adjust_test.c   |  2 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  4 +-
 58 files changed, 225 insertions(+), 226 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index f4ac28d53747..f6b77da48785 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -714,7 +714,7 @@ static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 		struct kvm_inject_args *args)
 {
 	struct kvm_inject_args *kvm_args_hva;
-	vm_vaddr_t kvm_args_gva;
+	gva_t kvm_args_gva;
 
 	kvm_args_gva = uc->args[1];
 	kvm_args_hva = (struct kvm_inject_args *)addr_gva2hva(vm, kvm_args_gva);
@@ -735,7 +735,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_inject_args inject_args;
-	vm_vaddr_t args_gva;
+	gva_t args_gva;
 
 	struct test_args args = {
 		.nr_irqs = nr_irqs,
@@ -753,7 +753,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	vcpu_init_descriptor_tables(vcpu);
 
 	/* Setup the guest args page (so it gets the args). */
-	args_gva = vm_vaddr_alloc_page(vm);
+	args_gva = gva_alloc_page(vm);
 	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
 	vcpu_args_set(vcpu, 1, args_gva);
 
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index b0fc0f945766..68b692e1cc32 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -175,7 +175,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
-uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva);
 
 static inline void cpu_relax(void)
 {
diff --git a/tools/testing/selftests/kvm/include/arm64/ucall.h b/tools/testing/selftests/kvm/include/arm64/ucall.h
index 4ec801f37f00..2210d3d94c40 100644
--- a/tools/testing/selftests/kvm/include/arm64/ucall.h
+++ b/tools/testing/selftests/kvm/include/arm64/ucall.h
@@ -10,9 +10,9 @@
  * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
  * VM), it must not be accessed from host code.
  */
-extern vm_vaddr_t *ucall_exit_mmio_addr;
+extern gva_t *ucall_exit_mmio_addr;
 
-static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+static inline void ucall_arch_do_ucall(gva_t uc)
 {
 	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 373912464fb4..4b7012bd8041 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -100,7 +100,7 @@ struct kvm_vm {
 	bool pgd_created;
 	vm_paddr_t ucall_mmio_addr;
 	vm_paddr_t pgd;
-	vm_vaddr_t handlers;
+	gva_t handlers;
 	uint32_t dirty_ring_size;
 	uint64_t gpa_tag_mask;
 
@@ -602,22 +602,22 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 void vm_populate_vaddr_bitmap(struct kvm_vm *vm);
-vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			    enum kvm_mem_region_type type);
-vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
-				 vm_vaddr_t vaddr_min,
-				 enum kvm_mem_region_type type);
-vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
-vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
-				 enum kvm_mem_region_type type);
-vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
+gva_t gva_unused_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
+gva_t gva_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
+gva_t __gva_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+		  enum kvm_mem_region_type type);
+gva_t gva_alloc_shared(struct kvm_vm *vm, size_t sz,
+		       gva_t vaddr_min,
+		       enum kvm_mem_region_type type);
+gva_t gva_alloc_pages(struct kvm_vm *vm, int nr_pages);
+gva_t __gva_alloc_page(struct kvm_vm *vm,
+		       enum kvm_mem_region_type type);
+gva_t gva_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	      unsigned int npages);
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
-void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
+void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
@@ -994,12 +994,12 @@ vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
 }
 
 #define sync_global_to_guest(vm, g) ({				\
-	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	typeof(g) *_p = addr_gva2hva(vm, (gva_t)&(g));	\
 	memcpy(_p, &(g), sizeof(g));				\
 })
 
 #define sync_global_from_guest(vm, g) ({			\
-	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	typeof(g) *_p = addr_gva2hva(vm, (gva_t)&(g));	\
 	memcpy(&(g), _p, sizeof(g));				\
 })
 
@@ -1010,7 +1010,7 @@ vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
  * undesirable to change the host's copy of the global.
  */
 #define write_guest_global(vm, g, val) ({			\
-	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	typeof(g) *_p = addr_gva2hva(vm, (gva_t)&(g));	\
 	typeof(g) _val = val;					\
 								\
 	memcpy(_p, &(_val), sizeof(g));				\
@@ -1104,9 +1104,9 @@ static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr
  * Returns the VM physical address of the translated VM virtual
  * address given by @gva.
  */
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva);
 
-static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	return addr_arch_gva2gpa(vm, gva);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
index ec787b97cf18..a53e04286554 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_types.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
@@ -15,6 +15,6 @@
 #define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
 
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
-typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
+typedef uint64_t gva_t; /* Virtual Machine (Guest) virtual address */
 
 #endif /* SELFTEST_KVM_UTIL_TYPES_H */
diff --git a/tools/testing/selftests/kvm/include/riscv/ucall.h b/tools/testing/selftests/kvm/include/riscv/ucall.h
index a695ae36f3e0..41d56254968e 100644
--- a/tools/testing/selftests/kvm/include/riscv/ucall.h
+++ b/tools/testing/selftests/kvm/include/riscv/ucall.h
@@ -11,7 +11,7 @@ static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
-static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+static inline void ucall_arch_do_ucall(gva_t uc)
 {
 	sbi_ecall(KVM_RISCV_SELFTESTS_SBI_EXT,
 		  KVM_RISCV_SELFTESTS_SBI_UCALL,
diff --git a/tools/testing/selftests/kvm/include/s390/ucall.h b/tools/testing/selftests/kvm/include/s390/ucall.h
index 8035a872a351..befee84c4609 100644
--- a/tools/testing/selftests/kvm/include/s390/ucall.h
+++ b/tools/testing/selftests/kvm/include/s390/ucall.h
@@ -10,7 +10,7 @@ static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
-static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+static inline void ucall_arch_do_ucall(gva_t uc)
 {
 	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
 	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index d9d6581b8d4f..e5499f170834 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -30,7 +30,7 @@ struct ucall {
 };
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
-void ucall_arch_do_ucall(vm_vaddr_t uc);
+void ucall_arch_do_ucall(gva_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
@@ -48,7 +48,7 @@ int ucall_nr_pages_required(uint64_t page_size);
  * the full ucall() are problematic and/or unwanted.  Note, this will come out
  * as UCALL_NONE on the backend.
  */
-#define GUEST_UCALL_NONE()	ucall_arch_do_ucall((vm_vaddr_t)NULL)
+#define GUEST_UCALL_NONE()	ucall_arch_do_ucall((gva_t)NULL)
 
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
diff --git a/tools/testing/selftests/kvm/include/x86/hyperv.h b/tools/testing/selftests/kvm/include/x86/hyperv.h
index f13e532be240..eedfff3cf102 100644
--- a/tools/testing/selftests/kvm/include/x86/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86/hyperv.h
@@ -254,8 +254,8 @@
  * Issue a Hyper-V hypercall. Returns exception vector raised or 0, 'hv_status'
  * is set to the hypercall status (if no exception occurred).
  */
-static inline uint8_t __hyperv_hypercall(u64 control, vm_vaddr_t input_address,
-					 vm_vaddr_t output_address,
+static inline uint8_t __hyperv_hypercall(u64 control, gva_t input_address,
+					 gva_t output_address,
 					 uint64_t *hv_status)
 {
 	uint64_t error_code;
@@ -274,8 +274,8 @@ static inline uint8_t __hyperv_hypercall(u64 control, vm_vaddr_t input_address,
 }
 
 /* Issue a Hyper-V hypercall and assert that it succeeded. */
-static inline void hyperv_hypercall(u64 control, vm_vaddr_t input_address,
-				    vm_vaddr_t output_address)
+static inline void hyperv_hypercall(u64 control, gva_t input_address,
+				    gva_t output_address)
 {
 	uint64_t hv_status;
 	uint8_t vector;
@@ -347,7 +347,7 @@ struct hyperv_test_pages {
 };
 
 struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
-						       vm_vaddr_t *p_hv_pages_gva);
+						       gva_t *p_hv_pages_gva);
 
 /* HV_X64_MSR_TSC_INVARIANT_CONTROL bits */
 #define HV_INVARIANT_TSC_EXPOSED               BIT_ULL(0)
diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index 972bb1c4ab4c..36d4b6727cb6 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -11,9 +11,9 @@
 extern bool is_forced_emulation_enabled;
 
 struct kvm_vm_arch {
-	vm_vaddr_t gdt;
-	vm_vaddr_t tss;
-	vm_vaddr_t idt;
+	gva_t gdt;
+	gva_t tss;
+	gva_t idt;
 
 	uint64_t c_bit;
 	uint64_t s_bit;
diff --git a/tools/testing/selftests/kvm/include/x86/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
index b74c6dcddcbd..c2ebb8b61e38 100644
--- a/tools/testing/selftests/kvm/include/x86/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
@@ -53,7 +53,7 @@ static inline void vmmcall(void)
 		"clgi\n"	\
 		)
 
-struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
+struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, gva_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
 
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index edb3c391b982..16603e8f2006 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -552,7 +552,7 @@ union vmx_ctrl_msr {
 	};
 };
 
-struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
+struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, gva_t *p_vmx_gva);
 bool prepare_for_vmx_operation(struct vmx_pages *vmx);
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
 bool load_vmcs(struct vmx_pages *vmx);
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index dd8b12f626d3..6e909a96b095 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -295,7 +295,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	ret = sem_init(&test_stage_completed, 0, 0);
 	TEST_ASSERT(ret == 0, "Error in sem_init");
 
-	current_stage = addr_gva2hva(vm, (vm_vaddr_t)(&guest_test_stage));
+	current_stage = addr_gva2hva(vm, (gva_t)(&guest_test_stage));
 	*current_stage = NUM_TEST_STAGES;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 9d69904cb608..102b0b829420 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -18,14 +18,14 @@
 
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
 
-static vm_vaddr_t exception_handlers;
+static gva_t exception_handlers;
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
 	return (v + vm->page_size) & ~(vm->page_size - 1);
 }
 
-static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
+static uint64_t pgd_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
 	uint64_t mask = (1UL << (vm->va_bits - shift)) - 1;
@@ -33,7 +33,7 @@ static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	return (gva >> shift) & mask;
 }
 
-static uint64_t pud_index(struct kvm_vm *vm, vm_vaddr_t gva)
+static uint64_t pud_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = 2 * (vm->page_shift - 3) + vm->page_shift;
 	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
@@ -44,7 +44,7 @@ static uint64_t pud_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	return (gva >> shift) & mask;
 }
 
-static uint64_t pmd_index(struct kvm_vm *vm, vm_vaddr_t gva)
+static uint64_t pmd_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = (vm->page_shift - 3) + vm->page_shift;
 	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
@@ -55,7 +55,7 @@ static uint64_t pmd_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	return (gva >> shift) & mask;
 }
 
-static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva)
+static uint64_t pte_index(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
 	return (gva >> vm->page_shift) & mask;
@@ -185,7 +185,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep;
 
@@ -223,7 +223,7 @@ uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
 	exit(EXIT_FAILURE);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep = virt_get_pte_hva(vm, gva);
 
@@ -389,9 +389,9 @@ static struct kvm_vcpu *__aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 
 	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
 					     vm->page_size;
-	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
-				       DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
-				       MEM_REGION_DATA);
+	stack_vaddr = __gva_alloc(vm, stack_size,
+				  DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
+				  MEM_REGION_DATA);
 
 	aarch64_vcpu_setup(vcpu, init);
 
@@ -503,10 +503,10 @@ void route_exception(struct ex_regs *regs, int vector)
 
 void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
-	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
-					vm->page_size, MEM_REGION_DATA);
+	vm->handlers = __gva_alloc(vm, sizeof(struct handlers),
+				   vm->page_size, MEM_REGION_DATA);
 
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+	*(gva_t *)addr_gva2hva(vm, (gva_t)(&exception_handlers)) = vm->handlers;
 }
 
 void vm_install_sync_handler(struct kvm_vm *vm, int vector, int ec,
@@ -638,7 +638,7 @@ void kvm_selftest_arch_init(void)
 	guest_modes_append_default();
 }
 
-void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
+void gva_populate_bitmap(struct kvm_vm *vm)
 {
 	/*
 	 * arm64 selftests use only TTBR0_EL1, meaning that the valid VA space
diff --git a/tools/testing/selftests/kvm/lib/arm64/ucall.c b/tools/testing/selftests/kvm/lib/arm64/ucall.c
index ddab0ce89d4d..a1a3b4dcdce1 100644
--- a/tools/testing/selftests/kvm/lib/arm64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/arm64/ucall.c
@@ -6,17 +6,17 @@
  */
 #include "kvm_util.h"
 
-vm_vaddr_t *ucall_exit_mmio_addr;
+gva_t *ucall_exit_mmio_addr;
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
-	vm_vaddr_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
+	gva_t mmio_gva = gva_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
 
 	virt_map(vm, mmio_gva, mmio_gpa, 1);
 
 	vm->ucall_mmio_addr = mmio_gpa;
 
-	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gva);
+	write_guest_global(vm, ucall_exit_mmio_addr, (gva_t *)mmio_gva);
 }
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index f34d926d9735..6fddebb96a3c 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -157,12 +157,12 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 			"memsize of 0,\n"
 			"  phdr index: %u p_memsz: 0x%" PRIx64,
 			n1, (uint64_t) phdr.p_memsz);
-		vm_vaddr_t seg_vstart = align_down(phdr.p_vaddr, vm->page_size);
-		vm_vaddr_t seg_vend = phdr.p_vaddr + phdr.p_memsz - 1;
+		gva_t seg_vstart = align_down(phdr.p_vaddr, vm->page_size);
+		gva_t seg_vend = phdr.p_vaddr + phdr.p_memsz - 1;
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		vm_vaddr_t vaddr = __vm_vaddr_alloc(vm, seg_size, seg_vstart,
+		gva_t vaddr = __gva_alloc(vm, seg_size, seg_vstart,
 						    MEM_REGION_CODE);
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 815bc45dd8dc..2e6d275d4ba0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -262,7 +262,7 @@ _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params)
  * based on the MSB of the VA. On architectures with this behavior
  * the VA region spans [0, 2^(va_bits - 1)), [-(2^(va_bits - 1), -1].
  */
-__weak void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
+__weak void gva_populate_bitmap(struct kvm_vm *vm)
 {
 	sparsebit_set_num(vm->vpages_valid,
 		0, (1ULL << (vm->va_bits - 1)) >> vm->page_shift);
@@ -362,7 +362,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 
 	/* Limit to VA-bit canonical virtual addresses. */
 	vm->vpages_valid = sparsebit_alloc();
-	vm_vaddr_populate_bitmap(vm);
+	gva_populate_bitmap(vm);
 
 	/* Limit physical addresses to PA-bits. */
 	vm->max_gfn = vm_compute_max_gfn(vm);
@@ -1373,8 +1373,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  * TEST_ASSERT failure occurs for invalid input or no area of at least
  * sz unallocated bytes >= vaddr_min is available.
  */
-vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
-			       vm_vaddr_t vaddr_min)
+gva_t gva_unused_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
 {
 	uint64_t pages = (sz + vm->page_size - 1) >> vm->page_shift;
 
@@ -1439,10 +1438,10 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
-				     vm_vaddr_t vaddr_min,
-				     enum kvm_mem_region_type type,
-				     bool protected)
+static gva_t ____gva_alloc(struct kvm_vm *vm, size_t sz,
+			   gva_t vaddr_min,
+			   enum kvm_mem_region_type type,
+			   bool protected)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
@@ -1455,10 +1454,10 @@ static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
 	 * Find an unused range of virtual page addresses of at least
 	 * pages in length.
 	 */
-	vm_vaddr_t vaddr_start = vm_vaddr_unused_gap(vm, sz, vaddr_min);
+	gva_t vaddr_start = gva_unused_gap(vm, sz, vaddr_min);
 
 	/* Map the virtual pages. */
-	for (vm_vaddr_t vaddr = vaddr_start; pages > 0;
+	for (gva_t vaddr = vaddr_start; pages > 0;
 		pages--, vaddr += vm->page_size, paddr += vm->page_size) {
 
 		virt_pg_map(vm, vaddr, paddr);
@@ -1469,18 +1468,18 @@ static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
 	return vaddr_start;
 }
 
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			    enum kvm_mem_region_type type)
+gva_t __gva_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+		  enum kvm_mem_region_type type)
 {
-	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type,
+	return ____gva_alloc(vm, sz, vaddr_min, type,
 				  vm_arch_has_protected_memory(vm));
 }
 
-vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
-				 vm_vaddr_t vaddr_min,
-				 enum kvm_mem_region_type type)
+gva_t gva_alloc_shared(struct kvm_vm *vm, size_t sz,
+		       gva_t vaddr_min,
+		       enum kvm_mem_region_type type)
 {
-	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, false);
+	return ____gva_alloc(vm, sz, vaddr_min, type, false);
 }
 
 /*
@@ -1502,9 +1501,9 @@ vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
  * a unique set of pages, with the minimum real allocation being at least
  * a page. The allocated physical space comes from the TEST_DATA memory region.
  */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+gva_t gva_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
 {
-	return __vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA);
+	return __gva_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA);
 }
 
 /*
@@ -1521,14 +1520,14 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
  * Allocates at least N system pages worth of bytes within the virtual address
  * space of the vm.
  */
-vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
+gva_t gva_alloc_pages(struct kvm_vm *vm, int nr_pages)
 {
-	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
+	return gva_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
 }
 
-vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type)
+gva_t __gva_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type)
 {
-	return __vm_vaddr_alloc(vm, getpagesize(), KVM_UTIL_MIN_VADDR, type);
+	return __gva_alloc(vm, getpagesize(), KVM_UTIL_MIN_VADDR, type);
 }
 
 /*
@@ -1545,9 +1544,9 @@ vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type typ
  * Allocates at least one system page worth of bytes within the virtual address
  * space of the vm.
  */
-vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
+gva_t gva_alloc_page(struct kvm_vm *vm)
 {
-	return vm_vaddr_alloc_pages(vm, 1);
+	return gva_alloc_pages(vm, 1);
 }
 
 /*
@@ -2140,7 +2139,7 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
  * Return:
  *   Equivalent host virtual address
  */
-void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
+void *addr_gva2hva(struct kvm_vm *vm, gva_t gva)
 {
 	return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
 }
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index dd663bcf0cc0..3ba5163c72b3 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -14,7 +14,7 @@
 
 #define DEFAULT_RISCV_GUEST_STACK_VADDR_MIN	0xac0000
 
-static vm_vaddr_t exception_handlers;
+static gva_t exception_handlers;
 
 bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
 {
@@ -56,7 +56,7 @@ static uint32_t pte_index_shift[] = {
 	PGTBL_L3_INDEX_SHIFT,
 };
 
-static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
+static uint64_t pte_index(struct kvm_vm *vm, gva_t gva, int level)
 {
 	TEST_ASSERT(level > -1,
 		"Negative page table level (%d) not possible", level);
@@ -123,7 +123,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 		PGTBL_PTE_PERM_MASK | PGTBL_PTE_VALID_MASK;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep;
 	int level = vm->pgtable_levels - 1;
@@ -306,9 +306,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 
 	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
 					     vm->page_size;
-	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
-				       DEFAULT_RISCV_GUEST_STACK_VADDR_MIN,
-				       MEM_REGION_DATA);
+	stack_vaddr = __gva_alloc(vm, stack_size,
+				  DEFAULT_RISCV_GUEST_STACK_VADDR_MIN,
+				  MEM_REGION_DATA);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	riscv_vcpu_mmu_setup(vcpu);
@@ -433,10 +433,10 @@ void vcpu_init_vector_tables(struct kvm_vcpu *vcpu)
 
 void vm_init_vector_tables(struct kvm_vm *vm)
 {
-	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
+	vm->handlers = __gva_alloc(vm, sizeof(struct handlers),
 				   vm->page_size, MEM_REGION_DATA);
 
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+	*(gva_t *)addr_gva2hva(vm, (gva_t)(&exception_handlers)) = vm->handlers;
 }
 
 void vm_install_exception_handler(struct kvm_vm *vm, int vector, exception_handler_fn handler)
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 20cfe970e3e3..a6438e3ea8e7 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -86,7 +86,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 	entry[idx] = gpa;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int ri, idx;
 	uint64_t *entry;
@@ -171,9 +171,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
 
-	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
-				       DEFAULT_GUEST_STACK_VADDR_MIN,
-				       MEM_REGION_DATA);
+	stack_vaddr = __gva_alloc(vm, stack_size,
+				  DEFAULT_GUEST_STACK_VADDR_MIN,
+				  MEM_REGION_DATA);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 42151e571953..3a72169b61ac 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -29,11 +29,11 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 	struct ucall_header *hdr;
 	struct ucall *uc;
-	vm_vaddr_t vaddr;
+	gva_t vaddr;
 	int i;
 
-	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
-				      MEM_REGION_DATA);
+	vaddr = gva_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
+				 MEM_REGION_DATA);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
@@ -96,7 +96,7 @@ void ucall_assert(uint64_t cmd, const char *exp, const char *file,
 	guest_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
 	va_end(va);
 
-	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+	ucall_arch_do_ucall((gva_t)uc->hva);
 
 	ucall_free(uc);
 }
@@ -113,7 +113,7 @@ void ucall_fmt(uint64_t cmd, const char *fmt, ...)
 	guest_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
 	va_end(va);
 
-	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+	ucall_arch_do_ucall((gva_t)uc->hva);
 
 	ucall_free(uc);
 }
@@ -135,7 +135,7 @@ void ucall(uint64_t cmd, int nargs, ...)
 		WRITE_ONCE(uc->args[i], va_arg(va, uint64_t));
 	va_end(va);
 
-	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+	ucall_arch_do_ucall((gva_t)uc->hva);
 
 	ucall_free(uc);
 }
diff --git a/tools/testing/selftests/kvm/lib/x86/hyperv.c b/tools/testing/selftests/kvm/lib/x86/hyperv.c
index 15bc8cd583aa..2284bc936404 100644
--- a/tools/testing/selftests/kvm/lib/x86/hyperv.c
+++ b/tools/testing/selftests/kvm/lib/x86/hyperv.c
@@ -76,23 +76,23 @@ bool kvm_hv_cpu_has(struct kvm_x86_cpu_feature feature)
 }
 
 struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
-						       vm_vaddr_t *p_hv_pages_gva)
+						       gva_t *p_hv_pages_gva)
 {
-	vm_vaddr_t hv_pages_gva = vm_vaddr_alloc_page(vm);
+	gva_t hv_pages_gva = gva_alloc_page(vm);
 	struct hyperv_test_pages *hv = addr_gva2hva(vm, hv_pages_gva);
 
 	/* Setup of a region of guest memory for the VP Assist page. */
-	hv->vp_assist = (void *)vm_vaddr_alloc_page(vm);
+	hv->vp_assist = (void *)gva_alloc_page(vm);
 	hv->vp_assist_hva = addr_gva2hva(vm, (uintptr_t)hv->vp_assist);
 	hv->vp_assist_gpa = addr_gva2gpa(vm, (uintptr_t)hv->vp_assist);
 
 	/* Setup of a region of guest memory for the partition assist page. */
-	hv->partition_assist = (void *)vm_vaddr_alloc_page(vm);
+	hv->partition_assist = (void *)gva_alloc_page(vm);
 	hv->partition_assist_hva = addr_gva2hva(vm, (uintptr_t)hv->partition_assist);
 	hv->partition_assist_gpa = addr_gva2gpa(vm, (uintptr_t)hv->partition_assist);
 
 	/* Setup of a region of guest memory for the enlightened VMCS. */
-	hv->enlightened_vmcs = (void *)vm_vaddr_alloc_page(vm);
+	hv->enlightened_vmcs = (void *)gva_alloc_page(vm);
 	hv->enlightened_vmcs_hva = addr_gva2hva(vm, (uintptr_t)hv->enlightened_vmcs);
 	hv->enlightened_vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)hv->enlightened_vmcs);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 7f5d62a65c68..e5249c442318 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -81,7 +81,7 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 {
 	struct vmx_pages *vmx, *vmx0 = NULL;
 	struct kvm_regs regs;
-	vm_vaddr_t vmx_gva;
+	gva_t vmx_gva;
 	int vcpu_id;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index bd5a802fa7a5..3ff61033790e 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -17,7 +17,7 @@
 #define KERNEL_DS	0x10
 #define KERNEL_TSS	0x18
 
-vm_vaddr_t exception_handlers;
+gva_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
 bool is_forced_emulation_enabled;
@@ -463,7 +463,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 	segp->present = true;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int level = PG_LEVEL_NONE;
 	uint64_t *pte = __vm_get_page_table_entry(vm, gva, &level);
@@ -478,7 +478,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
 }
 
-static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp)
+static void kvm_seg_set_tss_64bit(gva_t base, struct kvm_segment *segp)
 {
 	memset(segp, 0, sizeof(*segp));
 	segp->base = base;
@@ -588,16 +588,16 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 	struct kvm_segment seg;
 	int i;
 
-	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-	vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
+	vm->arch.gdt = __gva_alloc_page(vm, MEM_REGION_DATA);
+	vm->arch.idt = __gva_alloc_page(vm, MEM_REGION_DATA);
+	vm->handlers = __gva_alloc_page(vm, MEM_REGION_DATA);
+	vm->arch.tss = __gva_alloc_page(vm, MEM_REGION_DATA);
 
 	/* Handlers have the same address in both address spaces.*/
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
 
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+	*(gva_t *)addr_gva2hva(vm, (gva_t)(&exception_handlers)) = vm->handlers;
 
 	kvm_seg_set_kernel_code_64bit(&seg);
 	kvm_seg_fill_gdt_64bit(vm, &seg);
@@ -612,9 +612,9 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			       void (*handler)(struct ex_regs *))
 {
-	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
+	gva_t *handlers = (gva_t *)addr_gva2hva(vm, vm->handlers);
 
-	handlers[vector] = (vm_vaddr_t)handler;
+	handlers[vector] = (gva_t)handler;
 }
 
 void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
@@ -664,12 +664,12 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	struct kvm_mp_state mp_state;
 	struct kvm_regs regs;
-	vm_vaddr_t stack_vaddr;
+	gva_t stack_vaddr;
 	struct kvm_vcpu *vcpu;
 
-	stack_vaddr = __vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
-				       DEFAULT_GUEST_STACK_VADDR_MIN,
-				       MEM_REGION_DATA);
+	stack_vaddr = __gva_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
+				  DEFAULT_GUEST_STACK_VADDR_MIN,
+				  MEM_REGION_DATA);
 
 	stack_vaddr += DEFAULT_STACK_PGS * getpagesize();
 
@@ -683,7 +683,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	 * may need to subtract 4 bytes instead of 8 bytes.
 	 */
 	TEST_ASSERT(IS_ALIGNED(stack_vaddr, PAGE_SIZE),
-		    "__vm_vaddr_alloc() did not provide a page-aligned address");
+		    "__gva_alloc() did not provide a page-aligned address");
 	stack_vaddr -= 8;
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index d239c2097391..104fe606d7d1 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -28,20 +28,20 @@ u64 rflags;
  *   Pointer to structure with the addresses of the SVM areas.
  */
 struct svm_test_data *
-vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
+vcpu_alloc_svm(struct kvm_vm *vm, gva_t *p_svm_gva)
 {
-	vm_vaddr_t svm_gva = vm_vaddr_alloc_page(vm);
+	gva_t svm_gva = gva_alloc_page(vm);
 	struct svm_test_data *svm = addr_gva2hva(vm, svm_gva);
 
-	svm->vmcb = (void *)vm_vaddr_alloc_page(vm);
+	svm->vmcb = (void *)gva_alloc_page(vm);
 	svm->vmcb_hva = addr_gva2hva(vm, (uintptr_t)svm->vmcb);
 	svm->vmcb_gpa = addr_gva2gpa(vm, (uintptr_t)svm->vmcb);
 
-	svm->save_area = (void *)vm_vaddr_alloc_page(vm);
+	svm->save_area = (void *)gva_alloc_page(vm);
 	svm->save_area_hva = addr_gva2hva(vm, (uintptr_t)svm->save_area);
 	svm->save_area_gpa = addr_gva2gpa(vm, (uintptr_t)svm->save_area);
 
-	svm->msr = (void *)vm_vaddr_alloc_page(vm);
+	svm->msr = (void *)gva_alloc_page(vm);
 	svm->msr_hva = addr_gva2hva(vm, (uintptr_t)svm->msr);
 	svm->msr_gpa = addr_gva2gpa(vm, (uintptr_t)svm->msr);
 	memset(svm->msr_hva, 0, getpagesize());
diff --git a/tools/testing/selftests/kvm/lib/x86/ucall.c b/tools/testing/selftests/kvm/lib/x86/ucall.c
index 1265cecc7dd1..1af2a6880cdf 100644
--- a/tools/testing/selftests/kvm/lib/x86/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86/ucall.c
@@ -8,7 +8,7 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
-void ucall_arch_do_ucall(vm_vaddr_t uc)
+void ucall_arch_do_ucall(gva_t uc)
 {
 	/*
 	 * FIXME: Revert this hack (the entire commit that added it) once nVMX
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index d4d1208dd023..ea37261b207c 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -70,39 +70,39 @@ int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
  *   Pointer to structure with the addresses of the VMX areas.
  */
 struct vmx_pages *
-vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
+vcpu_alloc_vmx(struct kvm_vm *vm, gva_t *p_vmx_gva)
 {
-	vm_vaddr_t vmx_gva = vm_vaddr_alloc_page(vm);
+	gva_t vmx_gva = gva_alloc_page(vm);
 	struct vmx_pages *vmx = addr_gva2hva(vm, vmx_gva);
 
 	/* Setup of a region of guest memory for the vmxon region. */
-	vmx->vmxon = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmxon = (void *)gva_alloc_page(vm);
 	vmx->vmxon_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmxon);
 	vmx->vmxon_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmxon);
 
 	/* Setup of a region of guest memory for a vmcs. */
-	vmx->vmcs = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmcs = (void *)gva_alloc_page(vm);
 	vmx->vmcs_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmcs);
 	vmx->vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmcs);
 
 	/* Setup of a region of guest memory for the MSR bitmap. */
-	vmx->msr = (void *)vm_vaddr_alloc_page(vm);
+	vmx->msr = (void *)gva_alloc_page(vm);
 	vmx->msr_hva = addr_gva2hva(vm, (uintptr_t)vmx->msr);
 	vmx->msr_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->msr);
 	memset(vmx->msr_hva, 0, getpagesize());
 
 	/* Setup of a region of guest memory for the shadow VMCS. */
-	vmx->shadow_vmcs = (void *)vm_vaddr_alloc_page(vm);
+	vmx->shadow_vmcs = (void *)gva_alloc_page(vm);
 	vmx->shadow_vmcs_hva = addr_gva2hva(vm, (uintptr_t)vmx->shadow_vmcs);
 	vmx->shadow_vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->shadow_vmcs);
 
 	/* Setup of a region of guest memory for the VMREAD and VMWRITE bitmaps. */
-	vmx->vmread = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmread = (void *)gva_alloc_page(vm);
 	vmx->vmread_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmread);
 	vmx->vmread_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmread);
 	memset(vmx->vmread_hva, 0, getpagesize());
 
-	vmx->vmwrite = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmwrite = (void *)gva_alloc_page(vm);
 	vmx->vmwrite_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmwrite);
 	vmx->vmwrite_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmwrite);
 	memset(vmx->vmwrite_hva, 0, getpagesize());
@@ -539,14 +539,14 @@ void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 {
 	TEST_ASSERT(kvm_cpu_has_ept(), "KVM doesn't support nested EPT");
 
-	vmx->eptp = (void *)vm_vaddr_alloc_page(vm);
+	vmx->eptp = (void *)gva_alloc_page(vm);
 	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
 	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);
 }
 
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm)
 {
-	vmx->apic_access = (void *)vm_vaddr_alloc_page(vm);
+	vmx->apic_access = (void *)gva_alloc_page(vm);
 	vmx->apic_access_hva = addr_gva2hva(vm, (uintptr_t)vmx->apic_access);
 	vmx->apic_access_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->apic_access);
 }
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 03406de4989d..e166e20544d3 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -574,7 +574,7 @@ static void test_vm_setup_snapshot_mem(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	virt_map(vm, PMU_SNAPSHOT_GPA_BASE, PMU_SNAPSHOT_GPA_BASE, 1);
 
 	snapshot_gva = (void *)(PMU_SNAPSHOT_GPA_BASE);
-	snapshot_gpa = addr_gva2gpa(vcpu->vm, (vm_vaddr_t)snapshot_gva);
+	snapshot_gpa = addr_gva2gpa(vcpu->vm, (gva_t)snapshot_gva);
 	sync_global_to_guest(vcpu->vm, snapshot_gva);
 	sync_global_to_guest(vcpu->vm, snapshot_gpa);
 }
diff --git a/tools/testing/selftests/kvm/s390/memop.c b/tools/testing/selftests/kvm/s390/memop.c
index 4374b4cd2a80..a808fb2f6b2c 100644
--- a/tools/testing/selftests/kvm/s390/memop.c
+++ b/tools/testing/selftests/kvm/s390/memop.c
@@ -878,10 +878,10 @@ static void guest_copy_key_fetch_prot_override(void)
 static void test_copy_key_fetch_prot_override(void)
 {
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
-	vm_vaddr_t guest_0_page, guest_last_page;
+	gva_t guest_0_page, guest_last_page;
 
-	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
-	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
+	guest_0_page = gva_alloc(t.kvm_vm, PAGE_SIZE, 0);
+	guest_last_page = gva_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
 	if (guest_0_page != 0 || guest_last_page != last_page_addr) {
 		print_skip("did not allocate guest pages at required positions");
 		goto out;
@@ -917,10 +917,10 @@ static void test_copy_key_fetch_prot_override(void)
 static void test_errors_key_fetch_prot_override_not_enabled(void)
 {
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
-	vm_vaddr_t guest_0_page, guest_last_page;
+	gva_t guest_0_page, guest_last_page;
 
-	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
-	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
+	guest_0_page = gva_alloc(t.kvm_vm, PAGE_SIZE, 0);
+	guest_last_page = gva_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
 	if (guest_0_page != 0 || guest_last_page != last_page_addr) {
 		print_skip("did not allocate guest pages at required positions");
 		goto out;
@@ -938,10 +938,10 @@ static void test_errors_key_fetch_prot_override_not_enabled(void)
 static void test_errors_key_fetch_prot_override_enabled(void)
 {
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
-	vm_vaddr_t guest_0_page, guest_last_page;
+	gva_t guest_0_page, guest_last_page;
 
-	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
-	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
+	guest_0_page = gva_alloc(t.kvm_vm, PAGE_SIZE, 0);
+	guest_last_page = gva_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
 	if (guest_0_page != 0 || guest_last_page != last_page_addr) {
 		print_skip("did not allocate guest pages at required positions");
 		goto out;
diff --git a/tools/testing/selftests/kvm/s390/tprot.c b/tools/testing/selftests/kvm/s390/tprot.c
index 12d5e1cb62e3..b50209979e10 100644
--- a/tools/testing/selftests/kvm/s390/tprot.c
+++ b/tools/testing/selftests/kvm/s390/tprot.c
@@ -146,7 +146,7 @@ static enum stage perform_next_stage(int *i, bool mapped_0)
 		/*
 		 * Some fetch protection override tests require that page 0
 		 * be mapped, however, when the hosts tries to map that page via
-		 * vm_vaddr_alloc, it may happen that some other page gets mapped
+		 * gva_alloc, it may happen that some other page gets mapped
 		 * instead.
 		 * In order to skip these tests we detect this inside the guest
 		 */
@@ -207,7 +207,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
-	vm_vaddr_t guest_0_page;
+	gva_t guest_0_page;
 
 	ksft_print_header();
 	ksft_set_plan(STAGE_END);
@@ -216,10 +216,10 @@ int main(int argc, char *argv[])
 	run = vcpu->run;
 
 	HOST_SYNC(vcpu, STAGE_INIT_SIMPLE);
-	mprotect(addr_gva2hva(vm, (vm_vaddr_t)pages), PAGE_SIZE * 2, PROT_READ);
+	mprotect(addr_gva2hva(vm, (gva_t)pages), PAGE_SIZE * 2, PROT_READ);
 	HOST_SYNC(vcpu, TEST_SIMPLE);
 
-	guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
+	guest_0_page = gva_alloc(vm, PAGE_SIZE, 0);
 	if (guest_0_page != 0) {
 		/* Use NO_TAP so we don't get a PASS print */
 		HOST_SYNC_NO_TAP(vcpu, STAGE_INIT_FETCH_PROT_OVERRIDE);
@@ -229,7 +229,7 @@ int main(int argc, char *argv[])
 		HOST_SYNC(vcpu, STAGE_INIT_FETCH_PROT_OVERRIDE);
 	}
 	if (guest_0_page == 0)
-		mprotect(addr_gva2hva(vm, (vm_vaddr_t)0), PAGE_SIZE, PROT_READ);
+		mprotect(addr_gva2hva(vm, (gva_t)0), PAGE_SIZE, PROT_READ);
 	run->s.regs.crs[0] |= CR0_FETCH_PROTECTION_OVERRIDE;
 	run->kvm_dirty_regs = KVM_SYNC_CRS;
 	HOST_SYNC(vcpu, TEST_FETCH_PROT_OVERRIDE);
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index cce2520af720..24eaabe372bc 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -280,7 +280,7 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 {
 	/* ST_GPA_BASE is identity mapped */
 	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
-	st_gpa[i] = addr_gva2gpa(vcpu->vm, (vm_vaddr_t)st_gva[i]);
+	st_gpa[i] = addr_gva2gpa(vcpu->vm, (gva_t)st_gva[i]);
 	sync_global_to_guest(vcpu->vm, st_gva[i]);
 	sync_global_to_guest(vcpu->vm, st_gpa[i]);
 }
diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index f4ce5a185a7d..d49230ad5caf 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -201,7 +201,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_x86_state *state;
 	int xsave_restore_size;
-	vm_vaddr_t amx_cfg, tiledata, xstate;
+	gva_t amx_cfg, tiledata, xstate;
 	struct ucall uc;
 	u32 amx_offset;
 	int ret;
@@ -232,15 +232,15 @@ int main(int argc, char *argv[])
 	vm_install_exception_handler(vm, NM_VECTOR, guest_nm_handler);
 
 	/* amx cfg for guest_code */
-	amx_cfg = vm_vaddr_alloc_page(vm);
+	amx_cfg = gva_alloc_page(vm);
 	memset(addr_gva2hva(vm, amx_cfg), 0x0, getpagesize());
 
 	/* amx tiledata for guest_code */
-	tiledata = vm_vaddr_alloc_pages(vm, 2);
+	tiledata = gva_alloc_pages(vm, 2);
 	memset(addr_gva2hva(vm, tiledata), rand() | 1, 2 * getpagesize());
 
 	/* XSAVE state for guest_code */
-	xstate = vm_vaddr_alloc_pages(vm, DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
+	xstate = gva_alloc_pages(vm, DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
 	memset(addr_gva2hva(vm, xstate), 0, PAGE_SIZE * DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
 	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
 
diff --git a/tools/testing/selftests/kvm/x86/cpuid_test.c b/tools/testing/selftests/kvm/x86/cpuid_test.c
index 7b3fda6842bc..43e1cbcb3592 100644
--- a/tools/testing/selftests/kvm/x86/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86/cpuid_test.c
@@ -140,10 +140,10 @@ static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 	}
 }
 
-struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct kvm_cpuid2 *cpuid)
+struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, gva_t *p_gva, struct kvm_cpuid2 *cpuid)
 {
 	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
-	vm_vaddr_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR);
+	gva_t gva = gva_alloc(vm, size, KVM_UTIL_MIN_VADDR);
 	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
 
 	memcpy(guest_cpuids, cpuid, size);
@@ -202,7 +202,7 @@ static void test_get_cpuid2(struct kvm_vcpu *vcpu)
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t cpuid_gva;
+	gva_t cpuid_gva;
 	struct kvm_vm *vm;
 	int stage;
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_clock.c b/tools/testing/selftests/kvm/x86/hyperv_clock.c
index e058bc676cd6..046d33ec69fc 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_clock.c
@@ -208,7 +208,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	vm_vaddr_t tsc_page_gva;
+	gva_t tsc_page_gva;
 	int stage;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_TIME));
@@ -218,7 +218,7 @@ int main(void)
 
 	vcpu_set_hv_cpuid(vcpu);
 
-	tsc_page_gva = vm_vaddr_alloc_page(vm);
+	tsc_page_gva = gva_alloc_page(vm);
 	memset(addr_gva2hva(vm, tsc_page_gva), 0x0, getpagesize());
 	TEST_ASSERT((addr_gva2gpa(vm, tsc_page_gva) & (getpagesize() - 1)) == 0,
 		"TSC page has to be page aligned");
diff --git a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
index 74cf19661309..58f27dcc3d5f 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
@@ -76,7 +76,7 @@ void l2_guest_code(void)
 }
 
 void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages,
-		vm_vaddr_t hv_hcall_page_gpa)
+		gva_t hv_hcall_page_gpa)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
@@ -231,8 +231,8 @@ static struct kvm_vcpu *save_restore_vm(struct kvm_vm *vm,
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva = 0, hv_pages_gva = 0;
-	vm_vaddr_t hcall_page;
+	gva_t vmx_pages_gva = 0, hv_pages_gva = 0;
+	gva_t hcall_page;
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -246,7 +246,7 @@ int main(int argc, char *argv[])
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	hcall_page = vm_vaddr_alloc_pages(vm, 1);
+	hcall_page = gva_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
 
 	vcpu_set_hv_cpuid(vcpu);
diff --git a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
index 949e08e98f31..43e1c5149d97 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
@@ -16,7 +16,7 @@
 #define EXT_CAPABILITIES 0xbull
 
 static void guest_code(vm_paddr_t in_pg_gpa, vm_paddr_t out_pg_gpa,
-		       vm_vaddr_t out_pg_gva)
+		       gva_t out_pg_gva)
 {
 	uint64_t *output_gva;
 
@@ -35,8 +35,8 @@ static void guest_code(vm_paddr_t in_pg_gpa, vm_paddr_t out_pg_gpa,
 
 int main(void)
 {
-	vm_vaddr_t hcall_out_page;
-	vm_vaddr_t hcall_in_page;
+	gva_t hcall_out_page;
+	gva_t hcall_in_page;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
@@ -57,11 +57,11 @@ int main(void)
 	vcpu_set_hv_cpuid(vcpu);
 
 	/* Hypercall input */
-	hcall_in_page = vm_vaddr_alloc_pages(vm, 1);
+	hcall_in_page = gva_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_in_page), 0x0, vm->page_size);
 
 	/* Hypercall output */
-	hcall_out_page = vm_vaddr_alloc_pages(vm, 1);
+	hcall_out_page = gva_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_out_page), 0x0, vm->page_size);
 
 	vcpu_args_set(vcpu, 3, addr_gva2gpa(vm, hcall_in_page),
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index 068e9c69710d..5cf19d96120d 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -82,7 +82,7 @@ static void guest_msr(struct msr_data *msr)
 	GUEST_DONE();
 }
 
-static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
+static void guest_hcall(gva_t pgs_gpa, struct hcall_data *hcall)
 {
 	u64 res, input, output;
 	uint8_t vector;
@@ -134,14 +134,14 @@ static void guest_test_msrs_access(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0;
-	vm_vaddr_t msr_gva;
+	gva_t msr_gva;
 	struct msr_data *msr;
 	bool has_invtsc = kvm_cpu_has(X86_FEATURE_INVTSC);
 
 	while (true) {
 		vm = vm_create_with_one_vcpu(&vcpu, guest_msr);
 
-		msr_gva = vm_vaddr_alloc_page(vm);
+		msr_gva = gva_alloc_page(vm);
 		memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
 		msr = addr_gva2hva(vm, msr_gva);
 
@@ -523,17 +523,17 @@ static void guest_test_hcalls_access(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0;
-	vm_vaddr_t hcall_page, hcall_params;
+	gva_t hcall_page, hcall_params;
 	struct hcall_data *hcall;
 
 	while (true) {
 		vm = vm_create_with_one_vcpu(&vcpu, guest_hcall);
 
 		/* Hypercall input/output */
-		hcall_page = vm_vaddr_alloc_pages(vm, 2);
+		hcall_page = gva_alloc_pages(vm, 2);
 		memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
 
-		hcall_params = vm_vaddr_alloc_page(vm);
+		hcall_params = gva_alloc_page(vm);
 		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
 		hcall = addr_gva2hva(vm, hcall_params);
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index 2b5b4bc6ef7e..865fdd8e4284 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -45,13 +45,13 @@ struct hv_send_ipi_ex {
 	struct hv_vpset vp_set;
 };
 
-static inline void hv_init(vm_vaddr_t pgs_gpa)
+static inline void hv_init(gva_t pgs_gpa)
 {
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 }
 
-static void receiver_code(void *hcall_page, vm_vaddr_t pgs_gpa)
+static void receiver_code(void *hcall_page, gva_t pgs_gpa)
 {
 	u32 vcpu_id;
 
@@ -85,7 +85,7 @@ static inline void nop_loop(void)
 		asm volatile("nop");
 }
 
-static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
+static void sender_guest_code(void *hcall_page, gva_t pgs_gpa)
 {
 	struct hv_send_ipi *ipi = (struct hv_send_ipi *)hcall_page;
 	struct hv_send_ipi_ex *ipi_ex = (struct hv_send_ipi_ex *)hcall_page;
@@ -243,7 +243,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu[3];
-	vm_vaddr_t hcall_page;
+	gva_t hcall_page;
 	pthread_t threads[2];
 	int stage = 1, r;
 	struct ucall uc;
@@ -253,7 +253,7 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu[0], sender_guest_code);
 
 	/* Hypercall input/output */
-	hcall_page = vm_vaddr_alloc_pages(vm, 2);
+	hcall_page = gva_alloc_pages(vm, 2);
 	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
 
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
index 0ddb63229bcb..436c16460fe0 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
@@ -67,7 +67,7 @@ void l2_guest_code(void)
 
 static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 						    struct hyperv_test_pages *hv_pages,
-						    vm_vaddr_t pgs_gpa)
+						    gva_t pgs_gpa)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
@@ -149,8 +149,8 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_gva = 0, hv_pages_gva = 0;
-	vm_vaddr_t hcall_page;
+	gva_t nested_gva = 0, hv_pages_gva = 0;
+	gva_t hcall_page;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
@@ -165,7 +165,7 @@ int main(int argc, char *argv[])
 	vcpu_alloc_svm(vm, &nested_gva);
 	vcpu_alloc_hyperv_test_pages(vm, &hv_pages_gva);
 
-	hcall_page = vm_vaddr_alloc_pages(vm, 1);
+	hcall_page = gva_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
 
 	vcpu_args_set(vcpu, 3, nested_gva, hv_pages_gva, addr_gva2gpa(vm, hcall_page));
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index 077cd0ec3040..aa795f9a5950 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -61,14 +61,14 @@ struct hv_tlb_flush_ex {
  * - GVAs of the test pages' PTEs
  */
 struct test_data {
-	vm_vaddr_t hcall_gva;
+	gva_t hcall_gva;
 	vm_paddr_t hcall_gpa;
-	vm_vaddr_t test_pages;
-	vm_vaddr_t test_pages_pte[NTEST_PAGES];
+	gva_t test_pages;
+	gva_t test_pages_pte[NTEST_PAGES];
 };
 
 /* 'Worker' vCPU code checking the contents of the test page */
-static void worker_guest_code(vm_vaddr_t test_data)
+static void worker_guest_code(gva_t test_data)
 {
 	struct test_data *data = (struct test_data *)test_data;
 	u32 vcpu_id = rdmsr(HV_X64_MSR_VP_INDEX);
@@ -196,7 +196,7 @@ static inline void post_test(struct test_data *data, u64 exp1, u64 exp2)
 #define TESTVAL2 0x0202020202020202
 
 /* Main vCPU doing the test */
-static void sender_guest_code(vm_vaddr_t test_data)
+static void sender_guest_code(gva_t test_data)
 {
 	struct test_data *data = (struct test_data *)test_data;
 	struct hv_tlb_flush *flush = (struct hv_tlb_flush *)data->hcall_gva;
@@ -581,7 +581,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu[3];
 	pthread_t threads[2];
-	vm_vaddr_t test_data_page, gva;
+	gva_t test_data_page, gva;
 	vm_paddr_t gpa;
 	uint64_t *pte;
 	struct test_data *data;
@@ -593,11 +593,11 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu[0], sender_guest_code);
 
 	/* Test data page */
-	test_data_page = vm_vaddr_alloc_page(vm);
+	test_data_page = gva_alloc_page(vm);
 	data = (struct test_data *)addr_gva2hva(vm, test_data_page);
 
 	/* Hypercall input/output */
-	data->hcall_gva = vm_vaddr_alloc_pages(vm, 2);
+	data->hcall_gva = gva_alloc_pages(vm, 2);
 	data->hcall_gpa = addr_gva2gpa(vm, data->hcall_gva);
 	memset(addr_gva2hva(vm, data->hcall_gva), 0x0, 2 * PAGE_SIZE);
 
@@ -606,7 +606,7 @@ int main(int argc, char *argv[])
 	 * and the test will swap their mappings. The third page keeps the indication
 	 * about the current state of mappings.
 	 */
-	data->test_pages = vm_vaddr_alloc_pages(vm, NTEST_PAGES + 1);
+	data->test_pages = gva_alloc_pages(vm, NTEST_PAGES + 1);
 	for (i = 0; i < NTEST_PAGES; i++)
 		memset(addr_gva2hva(vm, data->test_pages + PAGE_SIZE * i),
 		       (u8)(i + 1), PAGE_SIZE);
@@ -617,7 +617,7 @@ int main(int argc, char *argv[])
 	 * Get PTE pointers for test pages and map them inside the guest.
 	 * Use separate page for each PTE for simplicity.
 	 */
-	gva = vm_vaddr_unused_gap(vm, NTEST_PAGES * PAGE_SIZE, KVM_UTIL_MIN_VADDR);
+	gva = gva_unused_gap(vm, NTEST_PAGES * PAGE_SIZE, KVM_UTIL_MIN_VADDR);
 	for (i = 0; i < NTEST_PAGES; i++) {
 		pte = vm_get_page_table_entry(vm, data->test_pages + i * PAGE_SIZE);
 		gpa = addr_hva2gpa(vm, pte);
diff --git a/tools/testing/selftests/kvm/x86/kvm_clock_test.c b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
index 5bc12222d87a..b335ee2a8e97 100644
--- a/tools/testing/selftests/kvm/x86/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
@@ -135,7 +135,7 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t pvti_gva;
+	gva_t pvti_gva;
 	vm_paddr_t pvti_gpa;
 	struct kvm_vm *vm;
 	int flags;
@@ -147,7 +147,7 @@ int main(void)
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
-	pvti_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000);
+	pvti_gva = gva_alloc(vm, getpagesize(), 0x10000);
 	pvti_gpa = addr_gva2gpa(vm, pvti_gva);
 	vcpu_args_set(vcpu, 2, pvti_gpa, pvti_gva);
 
diff --git a/tools/testing/selftests/kvm/x86/nested_emulation_test.c b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
index abc824dba04f..d398add21e4c 100644
--- a/tools/testing/selftests/kvm/x86/nested_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
@@ -122,7 +122,7 @@ static void guest_code(void *test_data)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_test_data_gva;
+	gva_t nested_test_data_gva;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
diff --git a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
index 3641a42934ac..646cfb0022b3 100644
--- a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
@@ -216,7 +216,7 @@ static void queue_ss_exception(struct kvm_vcpu *vcpu, bool inject)
  */
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_test_data_gva;
+	gva_t nested_test_data_gva;
 	struct kvm_vcpu_events events;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index d97816dc476a..dc0734d2973c 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -66,15 +66,15 @@ static void test_sync_vmsa(uint32_t policy)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_vaddr_t gva;
+	gva_t gva;
 	void *hva;
 
 	double x87val = M_PI;
 	struct kvm_xsave __attribute__((aligned(64))) xsave = { 0 };
 
 	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_code_xsave, &vcpu);
-	gva = vm_vaddr_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
-				    MEM_REGION_TEST_DATA);
+	gva = gva_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
+			       MEM_REGION_TEST_DATA);
 	hva = addr_gva2hva(vm, gva);
 
 	vcpu_args_set(vcpu, 1, gva);
diff --git a/tools/testing/selftests/kvm/x86/smm_test.c b/tools/testing/selftests/kvm/x86/smm_test.c
index 55c88d664a94..ba64f4e8456d 100644
--- a/tools/testing/selftests/kvm/x86/smm_test.c
+++ b/tools/testing/selftests/kvm/x86/smm_test.c
@@ -127,7 +127,7 @@ void inject_smi(struct kvm_vcpu *vcpu)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index 141b7fc0c965..062f425db75b 100644
--- a/tools/testing/selftests/kvm/x86/state_test.c
+++ b/tools/testing/selftests/kvm/x86/state_test.c
@@ -225,7 +225,7 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 int main(int argc, char *argv[])
 {
 	uint64_t *xstate_bv, saved_xstate_bv;
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 	struct kvm_cpuid2 empty_cpuid = {};
 	struct kvm_regs regs1, regs2;
 	struct kvm_vcpu *vcpu, *vcpuN;
diff --git a/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c b/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
index 917b6066cfc1..d3cc5e4f7883 100644
--- a/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
@@ -82,7 +82,7 @@ static void l1_guest_code(struct svm_test_data *svm)
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t svm_gva;
+	gva_t svm_gva;
 	struct kvm_vm *vm;
 	struct ucall uc;
 
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c b/tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c
index 00135cbba35e..c6ea3d609a62 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c
@@ -42,7 +42,7 @@ static void l1_guest_code(struct svm_test_data *svm, struct idt_entry *idt)
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t svm_gva;
+	gva_t svm_gva;
 	struct kvm_vm *vm;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
index 7b6481d6c0d3..5068b2dd8005 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
@@ -144,8 +144,8 @@ static void run_test(bool is_nmi)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_vaddr_t svm_gva;
-	vm_vaddr_t idt_alt_vm;
+	gva_t svm_gva;
+	gva_t idt_alt_vm;
 	struct kvm_guest_debug debug;
 
 	pr_info("Running %s test\n", is_nmi ? "NMI" : "soft int");
@@ -161,7 +161,7 @@ static void run_test(bool is_nmi)
 	if (!is_nmi) {
 		void *idt, *idt_alt;
 
-		idt_alt_vm = vm_vaddr_alloc_page(vm);
+		idt_alt_vm = gva_alloc_page(vm);
 		idt_alt = addr_gva2hva(vm, idt_alt_vm);
 		idt = addr_gva2hva(vm, vm->arch.idt);
 		memcpy(idt_alt, idt, getpagesize());
diff --git a/tools/testing/selftests/kvm/x86/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86/svm_vmcall_test.c
index 8a62cca28cfb..b1887242f3b8 100644
--- a/tools/testing/selftests/kvm/x86/svm_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_vmcall_test.c
@@ -36,7 +36,7 @@ static void l1_guest_code(struct svm_test_data *svm)
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t svm_gva;
+	gva_t svm_gva;
 	struct kvm_vm *vm;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
diff --git a/tools/testing/selftests/kvm/x86/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
index 56306a19144a..f1c488e0d497 100644
--- a/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
@@ -72,13 +72,13 @@ int main(void)
 
 
 	if (has_vmx) {
-		vm_vaddr_t vmx_pages_gva;
+		gva_t vmx_pages_gva;
 
 		vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code_vmx);
 		vcpu_alloc_vmx(vm, &vmx_pages_gva);
 		vcpu_args_set(vcpu, 1, vmx_pages_gva);
 	} else {
-		vm_vaddr_t svm_gva;
+		gva_t svm_gva;
 
 		vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code_svm);
 		vcpu_alloc_svm(vm, &svm_gva);
diff --git a/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
index a81a24761aac..dc5c3d1db346 100644
--- a/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
@@ -72,7 +72,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages, unsigned long high_gpa)
 int main(int argc, char *argv[])
 {
 	unsigned long apic_access_addr = ~0ul;
-	vm_vaddr_t vmx_pages_gva;
+	gva_t vmx_pages_gva;
 	unsigned long high_gpa;
 	struct vmx_pages *vmx;
 	bool done = false;
diff --git a/tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c
index dad988351493..aa27053d7dcd 100644
--- a/tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c
@@ -47,7 +47,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva;
+	gva_t vmx_pages_gva;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index fa512d033205..9bf08e278ffe 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -79,7 +79,7 @@ void l1_guest_code(struct vmx_pages *vmx)
 
 static void test_vmx_dirty_log(bool enable_ept)
 {
-	vm_vaddr_t vmx_pages_gva = 0;
+	gva_t vmx_pages_gva = 0;
 	struct vmx_pages *vmx;
 	unsigned long *bmap;
 	uint64_t *host_test_mem;
diff --git a/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
index a100ee5f0009..a2eaceed9ad5 100644
--- a/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
+++ b/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
@@ -52,7 +52,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva;
+	gva_t vmx_pages_gva;
 	struct kvm_sregs sregs;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
diff --git a/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
index 1759fa5cb3f2..530d71b6d6bc 100644
--- a/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
@@ -120,7 +120,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_vaddr_t vmx_pages_gva;
+	gva_t vmx_pages_gva;
 
 	uint64_t tsc_start, tsc_end;
 	uint64_t tsc_khz;
diff --git a/tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c
index 00dd2ac07a61..1b7b6ba23de7 100644
--- a/tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c
@@ -152,7 +152,7 @@ void guest_code(struct vmx_pages *vmx_pages)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva = 0;
+	gva_t vmx_pages_gva = 0;
 
 	struct kvm_regs regs1, regs2;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
index 2ceb5c78c442..fc294ccc2a7e 100644
--- a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
@@ -119,7 +119,7 @@ static void report(int64_t val)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva;
+	gva_t vmx_pages_gva;
 	struct kvm_vcpu *vcpu;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index 35cb9de54a82..2aa14bd237d9 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -394,7 +394,7 @@ int main(int argc, char *argv[])
 	int run_secs = 0;
 	int delay_usecs = 0;
 	struct test_data_page *data;
-	vm_vaddr_t test_data_page_vaddr;
+	gva_t test_data_page_vaddr;
 	bool migrate = false;
 	pthread_t threads[2];
 	struct thread_params params[2];
@@ -415,7 +415,7 @@ int main(int argc, char *argv[])
 
 	params[1].vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
 
-	test_data_page_vaddr = vm_vaddr_alloc_page(vm);
+	test_data_page_vaddr = gva_alloc_page(vm);
 	data = addr_gva2hva(vm, test_data_page_vaddr);
 	memset(data, 0, sizeof(*data));
 	params[0].data = data;
-- 
2.49.0.906.g1f30a19c02-goog


