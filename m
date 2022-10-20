Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6593B6061E6
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiJTNji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiJTNjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:39:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837DC5FB9
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A16B261B6C
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41D8C43140;
        Thu, 20 Oct 2022 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666273162;
        bh=OHXqMIB2LbayrZqeR4Q3x+o3p8l92AZ82Uphr3yNHMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnWK1UFfVh9iQ0qxdi6RVZ9qgzRbZkB/5L/oR/5Z3uGzgCGI2hKv4/m+KkxhSdUon
         7kvCyHjWoF+VKAt+ejvqkhU5CVTLnI76VCTfvKo7P2093gMmjYlHnExEppGCOEDSNY
         UHa6sMstN+nU7Oih45l3zq+sMpXUo4MnX9LsfwUx+CTRU7CbsXe664a7TulzpvkvN4
         IQ11XI35I/liHVMMqL5VTa2e4SWIyby+cxUnakUL7XCPVtEPaDkZxIJ/xJQ9IDTcS4
         BcUUOlNBhXdbbg4vWtdjpd0J0aWriArPN4AyYhleKRGjvvrakWI4+ZUaLMosgRXH/N
         i/Z2Rut/TqSSA==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 12/25] KVM: arm64: Add infrastructure to create and track pKVM instances at EL2
Date:   Thu, 20 Oct 2022 14:38:14 +0100
Message-Id: <20221020133827.5541-13-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221020133827.5541-1-will@kernel.org>
References: <20221020133827.5541-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fuad Tabba <tabba@google.com>

Introduce a global table (and lock) to track pKVM instances at EL2, and
provide hypercalls that can be used by the untrusted host to create and
destroy pKVM VMs and their vCPUs. pKVM VM/vCPU state is directly
accessible only by the trusted hypervisor (EL2).

Each pKVM VM is directly associated with an untrusted host KVM instance,
and is referenced by the host using an opaque handle. Future patches
will provide hypercalls to allow the host to initialize/set/get pKVM
VM/vCPU state using the opaque handle.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Co-developed-by: Will Deacon <will@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h              |   3 +
 arch/arm64/include/asm/kvm_host.h             |   8 +
 arch/arm64/include/asm/kvm_pgtable.h          |   8 +
 arch/arm64/include/asm/kvm_pkvm.h             |   8 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  58 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  31 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  14 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 379 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   8 +
 arch/arm64/kvm/hyp/pgtable.c                  |   9 +
 arch/arm64/kvm/pkvm.c                         |   1 +
 12 files changed, 530 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 53035763e48e..de52ba775d48 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -76,6 +76,9 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
+	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
+	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
+	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 45e2136322ba..d3dd7ab9c79e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -115,6 +115,8 @@ struct kvm_smccc_features {
 	unsigned long vendor_hyp_bmap;
 };
 
+typedef unsigned int pkvm_handle_t;
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -166,6 +168,12 @@ struct kvm_arch {
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
+
+	/*
+	 * For an untrusted host VM, 'pkvm_handle' is used to lookup
+	 * the associated pKVM instance in the hypervisor.
+	 */
+	pkvm_handle_t pkvm_handle;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1b098bd4cd37..4f6d79fe4352 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -288,6 +288,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  */
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
 
+/**
+ * kvm_pgtable_stage2_pgd_size() - Helper to compute size of a stage-2 PGD
+ * @vtcr:	Content of the VTCR register.
+ *
+ * Return: the size (in bytes) of the stage-2 PGD
+ */
+size_t kvm_pgtable_stage2_pgd_size(u64 vtcr);
+
 /**
  * __kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 8f7b8a2314bb..f4e3133d6550 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -9,6 +9,9 @@
 #include <linux/memblock.h>
 #include <asm/kvm_pgtable.h>
 
+/* Maximum number of VMs that can co-exist under pKVM. */
+#define KVM_MAX_PVMS 255
+
 #define HYP_MEMBLOCK_REGIONS 128
 
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
@@ -40,6 +43,11 @@ static inline unsigned long hyp_vmemmap_pages(size_t vmemmap_entry_size)
 	return res >> PAGE_SHIFT;
 }
 
+static inline unsigned long hyp_vm_table_pages(void)
+{
+	return PAGE_ALIGN(KVM_MAX_PVMS * sizeof(void *)) >> PAGE_SHIFT;
+}
+
 static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
 {
 	unsigned long total = 0, i;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 0a6d3e7f2a43..ce9a796a85ee 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -11,6 +11,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/virt.h>
+#include <nvhe/pkvm.h>
 #include <nvhe/spinlock.h>
 
 /*
@@ -68,10 +69,12 @@ bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
+int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
 int hyp_pin_shared_mem(void *from, void *to);
 void hyp_unpin_shared_mem(void *from, void *to);
+void reclaim_guest_pages(struct pkvm_hyp_vm *vm);
 
 static __always_inline void __load_host_stage2(void)
 {
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
new file mode 100644
index 000000000000..8c653a3b9501
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Google LLC
+ * Author: Fuad Tabba <tabba@google.com>
+ */
+
+#ifndef __ARM64_KVM_NVHE_PKVM_H__
+#define __ARM64_KVM_NVHE_PKVM_H__
+
+#include <asm/kvm_pkvm.h>
+
+/*
+ * Holds the relevant data for maintaining the vcpu state completely at hyp.
+ */
+struct pkvm_hyp_vcpu {
+	struct kvm_vcpu vcpu;
+
+	/* Backpointer to the host's (untrusted) vCPU instance. */
+	struct kvm_vcpu *host_vcpu;
+};
+
+/*
+ * Holds the relevant data for running a protected vm.
+ */
+struct pkvm_hyp_vm {
+	struct kvm kvm;
+
+	/* Backpointer to the host's (untrusted) KVM instance. */
+	struct kvm *host_kvm;
+
+	/* The guest's stage-2 page-table managed by the hypervisor. */
+	struct kvm_pgtable pgt;
+
+	/*
+	 * The number of vcpus initialized and ready to run.
+	 * Modifying this is protected by 'vm_table_lock'.
+	 */
+	unsigned int nr_vcpus;
+
+	/* Array of the hyp vCPU structures for this VM. */
+	struct pkvm_hyp_vcpu *vcpus[];
+};
+
+static inline struct pkvm_hyp_vm *
+pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	return container_of(hyp_vcpu->vcpu.kvm, struct pkvm_hyp_vm, kvm);
+}
+
+void pkvm_hyp_vm_table_init(void *tbl);
+
+int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
+		   unsigned long pgd_hva);
+int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
+		     unsigned long vcpu_hva);
+int __pkvm_teardown_vm(pkvm_handle_t handle);
+
+#endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3cea4b6ac23e..b5f3fcfe9135 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -15,6 +15,7 @@
 
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
+#include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
@@ -191,6 +192,33 @@ static void handle___pkvm_vcpu_init_traps(struct kvm_cpu_context *host_ctxt)
 	__pkvm_vcpu_init_traps(kern_hyp_va(vcpu));
 }
 
+static void handle___pkvm_init_vm(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
+	DECLARE_REG(unsigned long, vm_hva, host_ctxt, 2);
+	DECLARE_REG(unsigned long, pgd_hva, host_ctxt, 3);
+
+	host_kvm = kern_hyp_va(host_kvm);
+	cpu_reg(host_ctxt, 1) = __pkvm_init_vm(host_kvm, vm_hva, pgd_hva);
+}
+
+static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 2);
+	DECLARE_REG(unsigned long, vcpu_hva, host_ctxt, 3);
+
+	host_vcpu = kern_hyp_va(host_vcpu);
+	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
+}
+
+static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -220,6 +248,9 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_aprs),
 	HANDLE_FUNC(__pkvm_vcpu_init_traps),
+	HANDLE_FUNC(__pkvm_init_vm),
+	HANDLE_FUNC(__pkvm_init_vcpu),
+	HANDLE_FUNC(__pkvm_teardown_vm),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bec8306c2392..2ef6aaa21ba5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -141,6 +141,20 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 	return 0;
 }
 
+int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
+{
+	vm->pgt.pgd = pgd;
+	return 0;
+}
+
+void reclaim_guest_pages(struct pkvm_hyp_vm *vm)
+{
+	unsigned long nr_pages;
+
+	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
+}
+
 int __pkvm_prot_finalize(void)
 {
 	struct kvm_s2_mmu *mmu = &host_mmu.arch.mmu;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 85d3b7ae720f..dcc7baeb8906 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -7,6 +7,9 @@
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
 #include <nvhe/fixed_config.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/memory.h>
+#include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
 /*
@@ -183,3 +186,379 @@ void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 	pvm_init_traps_aa64mmfr0(vcpu);
 	pvm_init_traps_aa64mmfr1(vcpu);
 }
+
+/*
+ * Start the VM table handle at the offset defined instead of at 0.
+ * Mainly for sanity checking and debugging.
+ */
+#define HANDLE_OFFSET 0x1000
+
+static unsigned int vm_handle_to_idx(pkvm_handle_t handle)
+{
+	return handle - HANDLE_OFFSET;
+}
+
+static pkvm_handle_t idx_to_vm_handle(unsigned int idx)
+{
+	return idx + HANDLE_OFFSET;
+}
+
+/*
+ * Spinlock for protecting state related to the VM table. Protects writes
+ * to 'vm_table' and 'nr_table_entries' as well as reads and writes to
+ * 'last_hyp_vcpu_lookup'.
+ */
+static DEFINE_HYP_SPINLOCK(vm_table_lock);
+
+/*
+ * The table of VM entries for protected VMs in hyp.
+ * Allocated at hyp initialization and setup.
+ */
+static struct pkvm_hyp_vm **vm_table;
+
+void pkvm_hyp_vm_table_init(void *tbl)
+{
+	WARN_ON(vm_table);
+	vm_table = tbl;
+}
+
+/*
+ * Return the hyp vm structure corresponding to the handle.
+ */
+static struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle)
+{
+	unsigned int idx = vm_handle_to_idx(handle);
+
+	if (unlikely(idx >= KVM_MAX_PVMS))
+		return NULL;
+
+	return vm_table[idx];
+}
+
+static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
+{
+	if (host_vcpu)
+		hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
+}
+
+static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
+			     unsigned int nr_vcpus)
+{
+	int i;
+
+	for (i = 0; i < nr_vcpus; i++)
+		unpin_host_vcpu(hyp_vcpus[i]->host_vcpu);
+}
+
+static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
+			     unsigned int nr_vcpus)
+{
+	hyp_vm->host_kvm = host_kvm;
+	hyp_vm->kvm.created_vcpus = nr_vcpus;
+	hyp_vm->kvm.arch.vtcr = host_mmu.arch.vtcr;
+}
+
+static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
+			      struct pkvm_hyp_vm *hyp_vm,
+			      struct kvm_vcpu *host_vcpu,
+			      unsigned int vcpu_idx)
+{
+	int ret = 0;
+
+	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
+		return -EBUSY;
+
+	if (host_vcpu->vcpu_idx != vcpu_idx) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	hyp_vcpu->host_vcpu = host_vcpu;
+
+	hyp_vcpu->vcpu.kvm = &hyp_vm->kvm;
+	hyp_vcpu->vcpu.vcpu_id = READ_ONCE(host_vcpu->vcpu_id);
+	hyp_vcpu->vcpu.vcpu_idx = vcpu_idx;
+
+	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
+done:
+	if (ret)
+		unpin_host_vcpu(host_vcpu);
+	return ret;
+}
+
+static int find_free_vm_table_entry(struct kvm *host_kvm)
+{
+	int i;
+
+	for (i = 0; i < KVM_MAX_PVMS; ++i) {
+		if (!vm_table[i])
+			return i;
+	}
+
+	return -ENOMEM;
+}
+
+/*
+ * Allocate a VM table entry and insert a pointer to the new vm.
+ *
+ * Return a unique handle to the protected VM on success,
+ * negative error code on failure.
+ */
+static pkvm_handle_t insert_vm_table_entry(struct kvm *host_kvm,
+					   struct pkvm_hyp_vm *hyp_vm)
+{
+	struct kvm_s2_mmu *mmu = &hyp_vm->kvm.arch.mmu;
+	int idx;
+
+	hyp_assert_lock_held(&vm_table_lock);
+
+	/*
+	 * Initializing protected state might have failed, yet a malicious
+	 * host could trigger this function. Thus, ensure that 'vm_table'
+	 * exists.
+	 */
+	if (unlikely(!vm_table))
+		return -EINVAL;
+
+	idx = find_free_vm_table_entry(host_kvm);
+	if (idx < 0)
+		return idx;
+
+	hyp_vm->kvm.arch.pkvm_handle = idx_to_vm_handle(idx);
+
+	/* VMID 0 is reserved for the host */
+	atomic64_set(&mmu->vmid.id, idx + 1);
+
+	mmu->arch = &hyp_vm->kvm.arch;
+	mmu->pgt = &hyp_vm->pgt;
+
+	vm_table[idx] = hyp_vm;
+	return hyp_vm->kvm.arch.pkvm_handle;
+}
+
+/*
+ * Deallocate and remove the VM table entry corresponding to the handle.
+ */
+static void remove_vm_table_entry(pkvm_handle_t handle)
+{
+	hyp_assert_lock_held(&vm_table_lock);
+	vm_table[vm_handle_to_idx(handle)] = NULL;
+}
+
+static size_t pkvm_get_hyp_vm_size(unsigned int nr_vcpus)
+{
+	return size_add(sizeof(struct pkvm_hyp_vm),
+		size_mul(sizeof(struct pkvm_hyp_vcpu *), nr_vcpus));
+}
+
+static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
+{
+	void *va = (void *)kern_hyp_va(host_va);
+
+	if (!PAGE_ALIGNED(va))
+		return NULL;
+
+	if (__pkvm_host_donate_hyp(hyp_virt_to_pfn(va),
+				   PAGE_ALIGN(size) >> PAGE_SHIFT))
+		return NULL;
+
+	return va;
+}
+
+static void *map_donated_memory(unsigned long host_va, size_t size)
+{
+	void *va = map_donated_memory_noclear(host_va, size);
+
+	if (va)
+		memset(va, 0, size);
+
+	return va;
+}
+
+static void __unmap_donated_memory(void *va, size_t size)
+{
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
+				       PAGE_ALIGN(size) >> PAGE_SHIFT));
+}
+
+static void unmap_donated_memory(void *va, size_t size)
+{
+	if (!va)
+		return;
+
+	memset(va, 0, size);
+	__unmap_donated_memory(va, size);
+}
+
+static void unmap_donated_memory_noclear(void *va, size_t size)
+{
+	if (!va)
+		return;
+
+	__unmap_donated_memory(va, size);
+}
+
+/*
+ * Initialize the hypervisor copy of the protected VM state using the
+ * memory donated by the host.
+ *
+ * Unmaps the donated memory from the host at stage 2.
+ *
+ * kvm: A pointer to the host's struct kvm.
+ * vm_hva: The host va of the area being donated for the VM state.
+ *	   Must be page aligned.
+ * pgd_hva: The host va of the area being donated for the stage-2 PGD for
+ *	    the VM. Must be page aligned. Its size is implied by the VM's
+ *	    VTCR.
+ *
+ * Return a unique handle to the protected VM on success,
+ * negative error code on failure.
+ */
+int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
+		   unsigned long pgd_hva)
+{
+	struct pkvm_hyp_vm *hyp_vm = NULL;
+	size_t vm_size, pgd_size;
+	unsigned int nr_vcpus;
+	void *pgd = NULL;
+	int ret;
+
+	ret = hyp_pin_shared_mem(host_kvm, host_kvm + 1);
+	if (ret)
+		return ret;
+
+	nr_vcpus = READ_ONCE(host_kvm->created_vcpus);
+	if (nr_vcpus < 1) {
+		ret = -EINVAL;
+		goto err_unpin_kvm;
+	}
+
+	vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
+	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.vtcr);
+
+	ret = -ENOMEM;
+
+	hyp_vm = map_donated_memory(vm_hva, vm_size);
+	if (!hyp_vm)
+		goto err_remove_mappings;
+
+	pgd = map_donated_memory_noclear(pgd_hva, pgd_size);
+	if (!pgd)
+		goto err_remove_mappings;
+
+	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus);
+
+	hyp_spin_lock(&vm_table_lock);
+	ret = insert_vm_table_entry(host_kvm, hyp_vm);
+	if (ret < 0)
+		goto err_unlock;
+
+	ret = kvm_guest_prepare_stage2(hyp_vm, pgd);
+	if (ret)
+		goto err_remove_vm_table_entry;
+	hyp_spin_unlock(&vm_table_lock);
+
+	return hyp_vm->kvm.arch.pkvm_handle;
+
+err_remove_vm_table_entry:
+	remove_vm_table_entry(hyp_vm->kvm.arch.pkvm_handle);
+err_unlock:
+	hyp_spin_unlock(&vm_table_lock);
+err_remove_mappings:
+	unmap_donated_memory(hyp_vm, vm_size);
+	unmap_donated_memory(pgd, pgd_size);
+err_unpin_kvm:
+	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
+	return ret;
+}
+
+/*
+ * Initialize the hypervisor copy of the protected vCPU state using the
+ * memory donated by the host.
+ *
+ * handle: The handle for the protected vm.
+ * host_vcpu: A pointer to the corresponding host vcpu.
+ * vcpu_hva: The host va of the area being donated for the vcpu state.
+ *	     Must be page aligned. The size of the area must be equal to
+ *	     the page-aligned size of 'struct pkvm_hyp_vcpu'.
+ * Return 0 on success, negative error code on failure.
+ */
+int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
+		     unsigned long vcpu_hva)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct pkvm_hyp_vm *hyp_vm;
+	unsigned int idx;
+	int ret;
+
+	hyp_vcpu = map_donated_memory(vcpu_hva, sizeof(*hyp_vcpu));
+	if (!hyp_vcpu)
+		return -ENOMEM;
+
+	hyp_spin_lock(&vm_table_lock);
+
+	hyp_vm = get_vm_by_handle(handle);
+	if (!hyp_vm) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+	idx = hyp_vm->nr_vcpus;
+	if (idx >= hyp_vm->kvm.created_vcpus) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu, idx);
+	if (ret)
+		goto unlock;
+
+	hyp_vm->vcpus[idx] = hyp_vcpu;
+	hyp_vm->nr_vcpus++;
+unlock:
+	hyp_spin_unlock(&vm_table_lock);
+
+	if (ret)
+		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
+
+	return ret;
+}
+
+int __pkvm_teardown_vm(pkvm_handle_t handle)
+{
+	struct pkvm_hyp_vm *hyp_vm;
+	size_t vm_size;
+	int err;
+
+	hyp_spin_lock(&vm_table_lock);
+	hyp_vm = get_vm_by_handle(handle);
+	if (!hyp_vm) {
+		err = -ENOENT;
+		goto err_unlock;
+	}
+
+	if (WARN_ON(hyp_page_count(hyp_vm))) {
+		err = -EBUSY;
+		goto err_unlock;
+	}
+
+	/* Ensure the VMID is clean before it can be reallocated */
+	__kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
+	remove_vm_table_entry(handle);
+	hyp_spin_unlock(&vm_table_lock);
+
+	/* Reclaim guest pages (including page-table pages) */
+	reclaim_guest_pages(hyp_vm);
+	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->nr_vcpus);
+
+	/* Push the metadata pages to the teardown memcache */
+	hyp_unpin_shared_mem(hyp_vm->host_kvm, hyp_vm->host_kvm + 1);
+
+	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
+	unmap_donated_memory(hyp_vm, vm_size);
+	return 0;
+
+err_unlock:
+	hyp_spin_unlock(&vm_table_lock);
+	return err;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 0312c9c74a5a..2be72fbe7279 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -16,6 +16,7 @@
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
+#include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
 unsigned long hyp_nr_cpus;
@@ -24,6 +25,7 @@ unsigned long hyp_nr_cpus;
 			 (unsigned long)__per_cpu_start)
 
 static void *vmemmap_base;
+static void *vm_table_base;
 static void *hyp_pgt_base;
 static void *host_s2_pgt_base;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
@@ -40,6 +42,11 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	if (!vmemmap_base)
 		return -ENOMEM;
 
+	nr_pages = hyp_vm_table_pages();
+	vm_table_base = hyp_early_alloc_contig(nr_pages);
+	if (!vm_table_base)
+		return -ENOMEM;
+
 	nr_pages = hyp_s1_pgtable_pages();
 	hyp_pgt_base = hyp_early_alloc_contig(nr_pages);
 	if (!hyp_pgt_base)
@@ -314,6 +321,7 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	pkvm_hyp_vm_table_init(vm_table_base);
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index cdf8e76b0be1..a1a27f88a312 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1200,6 +1200,15 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	return 0;
 }
 
+size_t kvm_pgtable_stage2_pgd_size(u64 vtcr)
+{
+	u32 ia_bits = VTCR_EL2_IPA(vtcr);
+	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
+	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
+
+	return kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
+}
+
 static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			      enum kvm_pgtable_walk_flags flag,
 			      void * const arg)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 34229425b25d..71493136e59c 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -71,6 +71,7 @@ void __init kvm_hyp_reserve(void)
 
 	hyp_mem_pages += hyp_s1_pgtable_pages();
 	hyp_mem_pages += host_s2_pgtable_pages();
+	hyp_mem_pages += hyp_vm_table_pages();
 	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
 
 	/*
-- 
2.38.0.413.g74048e4d9e-goog

