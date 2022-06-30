Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5209561CF6
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiF3OOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237515AbiF3ONY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69D2BC01
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46152B82AEF
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8086FC341CC;
        Thu, 30 Jun 2022 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597523;
        bh=YA1JdkQfJIo63VsfW/ctzNVM2gStbJ6z2dfPdQHmKlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxEtgP/kXcIkd8SefAmwQVkyrzKpPufR6JKZwBLDWTHy3jrmFnAHbpCzlb+mEkeD8
         Yen3PSJnt4JVtgzGskUPxmpkFQC9vjj+WTI1hz2Y4cnOVqDGClcJbnN8PZ990jzTOM
         g/YT/Uc24DiDwojygtO4zSYeftjUmOqi7Jk9bwUR+8SHKpApPIh2FRIupQxIj3c4PB
         Xi2CBLn8CK/RXCuyfxpO0Jo+R5ZwQSc5sUrov+DDOYxfAFiH6hZf0zVNkO2kd11lWG
         1xs3RBCPb4SCWySCBl7euHLH4UEg8I5iWnWeHOFQ1jexqJr6b+OiqAfPFPqpSvDifr
         0QpaM/scR/+sw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 12/24] KVM: arm64: Introduce shadow VM state at EL2
Date:   Thu, 30 Jun 2022 14:57:35 +0100
Message-Id: <20220630135747.26983-13-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fuad Tabba <tabba@google.com>

Introduce a table of shadow VM structures at EL2 and provide hypercalls
to the host for creating and destroying shadow VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h              |   2 +
 arch/arm64/include/asm/kvm_host.h             |   6 +
 arch/arm64/include/asm/kvm_pgtable.h          |   8 +
 arch/arm64/include/asm/kvm_pkvm.h             |   8 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  60 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  21 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  14 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 398 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   8 +
 arch/arm64/kvm/hyp/pgtable.c                  |   9 +
 arch/arm64/kvm/pkvm.c                         |   1 +
 12 files changed, 538 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2e277f2ed671..fac4ed699913 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -76,6 +76,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
+	__KVM_HOST_SMCCC_FUNC___pkvm_init_shadow,
+	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_shadow,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2cc42e1fec18..41348ac728f9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -115,6 +115,10 @@ struct kvm_smccc_features {
 	unsigned long vendor_hyp_bmap;
 };
 
+struct kvm_protected_vm {
+	unsigned int shadow_handle;
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -166,6 +170,8 @@ struct kvm_arch {
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
+
+	struct kvm_protected_vm pkvm;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 9f339dffbc1a..2d6b5058f7d3 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -288,6 +288,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  */
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
 
+/*
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
index 8f7b8a2314bb..11526e89fe5c 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -9,6 +9,9 @@
 #include <linux/memblock.h>
 #include <asm/kvm_pgtable.h>
 
+/* Maximum number of protected VMs that can be created. */
+#define KVM_MAX_PVMS 255
+
 #define HYP_MEMBLOCK_REGIONS 128
 
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
@@ -40,6 +43,11 @@ static inline unsigned long hyp_vmemmap_pages(size_t vmemmap_entry_size)
 	return res >> PAGE_SHIFT;
 }
 
+static inline unsigned long hyp_shadow_table_pages(void)
+{
+	return PAGE_ALIGN(KVM_MAX_PVMS * sizeof(void *)) >> PAGE_SHIFT;
+}
+
 static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
 {
 	unsigned long total = 0, i;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 3bea816296dc..3a0817b5c739 100644
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
+int kvm_guest_prepare_stage2(struct kvm_shadow_vm *vm, void *pgd);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
 int hyp_pin_shared_mem(void *from, void *to);
 void hyp_unpin_shared_mem(void *from, void *to);
+void reclaim_guest_pages(struct kvm_shadow_vm *vm);
 
 static __always_inline void __load_host_stage2(void)
 {
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
new file mode 100644
index 000000000000..1d0a33f70879
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -0,0 +1,60 @@
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
+struct kvm_shadow_vcpu_state {
+	/* The data for the shadow vcpu. */
+	struct kvm_vcpu shadow_vcpu;
+
+	/* A pointer to the host's vcpu. */
+	struct kvm_vcpu *host_vcpu;
+
+	/* A pointer to the shadow vm. */
+	struct kvm_shadow_vm *shadow_vm;
+};
+
+/*
+ * Holds the relevant data for running a protected vm.
+ */
+struct kvm_shadow_vm {
+	/* The data for the shadow kvm. */
+	struct kvm kvm;
+
+	/* The host's kvm structure. */
+	struct kvm *host_kvm;
+
+	/* The total size of the donated shadow area. */
+	size_t shadow_area_size;
+
+	struct kvm_pgtable pgt;
+
+	/* Array of the shadow state per vcpu. */
+	struct kvm_shadow_vcpu_state shadow_vcpu_states[0];
+};
+
+static inline struct kvm_shadow_vcpu_state *get_shadow_state(struct kvm_vcpu *shadow_vcpu)
+{
+	return container_of(shadow_vcpu, struct kvm_shadow_vcpu_state, shadow_vcpu);
+}
+
+static inline struct kvm_shadow_vm *get_shadow_vm(struct kvm_vcpu *shadow_vcpu)
+{
+	return get_shadow_state(shadow_vcpu)->shadow_vm;
+}
+
+void hyp_shadow_table_init(void *tbl);
+int __pkvm_init_shadow(struct kvm *kvm, unsigned long shadow_hva,
+		       size_t shadow_size, unsigned long pgd_hva);
+int __pkvm_teardown_shadow(unsigned int shadow_handle);
+
+#endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3cea4b6ac23e..a1fbd11c8041 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -15,6 +15,7 @@
 
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
+#include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
@@ -191,6 +192,24 @@ static void handle___pkvm_vcpu_init_traps(struct kvm_cpu_context *host_ctxt)
 	__pkvm_vcpu_init_traps(kern_hyp_va(vcpu));
 }
 
+static void handle___pkvm_init_shadow(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
+	DECLARE_REG(unsigned long, host_shadow_va, host_ctxt, 2);
+	DECLARE_REG(size_t, shadow_size, host_ctxt, 3);
+	DECLARE_REG(unsigned long, pgd, host_ctxt, 4);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_init_shadow(host_kvm, host_shadow_va,
+						   shadow_size, pgd);
+}
+
+static void handle___pkvm_teardown_shadow(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned int, shadow_handle, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_teardown_shadow(shadow_handle);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -220,6 +239,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_aprs),
 	HANDLE_FUNC(__pkvm_vcpu_init_traps),
+	HANDLE_FUNC(__pkvm_init_shadow),
+	HANDLE_FUNC(__pkvm_teardown_shadow),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index e2e3b30b072e..9baf731736be 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -141,6 +141,20 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 	return 0;
 }
 
+int kvm_guest_prepare_stage2(struct kvm_shadow_vm *vm, void *pgd)
+{
+	vm->pgt.pgd = pgd;
+	return 0;
+}
+
+void reclaim_guest_pages(struct kvm_shadow_vm *vm)
+{
+	unsigned long nr_pages;
+
+	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
+}
+
 int __pkvm_prot_finalize(void)
 {
 	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 99c8d8b73e70..77aeb787670b 100644
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
@@ -183,3 +186,398 @@ void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 	pvm_init_traps_aa64mmfr0(vcpu);
 	pvm_init_traps_aa64mmfr1(vcpu);
 }
+
+/*
+ * Start the shadow table handle at the offset defined instead of at 0.
+ * Mainly for sanity checking and debugging.
+ */
+#define HANDLE_OFFSET 0x1000
+
+static unsigned int shadow_handle_to_idx(unsigned int shadow_handle)
+{
+	return shadow_handle - HANDLE_OFFSET;
+}
+
+static unsigned int idx_to_shadow_handle(unsigned int idx)
+{
+	return idx + HANDLE_OFFSET;
+}
+
+/*
+ * Spinlock for protecting the shadow table related state.
+ * Protects writes to shadow_table, nr_shadow_entries, and next_shadow_alloc,
+ * as well as reads and writes to last_shadow_vcpu_lookup.
+ */
+static DEFINE_HYP_SPINLOCK(shadow_lock);
+
+/*
+ * The table of shadow entries for protected VMs in hyp.
+ * Allocated at hyp initialization and setup.
+ */
+static struct kvm_shadow_vm **shadow_table;
+
+/* Current number of vms in the shadow table. */
+static unsigned int nr_shadow_entries;
+
+/* The next entry index to try to allocate from. */
+static unsigned int next_shadow_alloc;
+
+void hyp_shadow_table_init(void *tbl)
+{
+	WARN_ON(shadow_table);
+	shadow_table = tbl;
+}
+
+/*
+ * Return the shadow vm corresponding to the handle.
+ */
+static struct kvm_shadow_vm *find_shadow_by_handle(unsigned int shadow_handle)
+{
+	unsigned int shadow_idx = shadow_handle_to_idx(shadow_handle);
+
+	if (unlikely(shadow_idx >= KVM_MAX_PVMS))
+		return NULL;
+
+	return shadow_table[shadow_idx];
+}
+
+static void unpin_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
+			     unsigned int nr_vcpus)
+{
+	int i;
+
+	for (i = 0; i < nr_vcpus; i++) {
+		struct kvm_vcpu *host_vcpu = shadow_vcpu_states[i].host_vcpu;
+		hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
+	}
+}
+
+static int set_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
+			  unsigned int nr_vcpus,
+			  struct kvm_vcpu **vcpu_array,
+			  size_t vcpu_array_size)
+{
+	int i;
+
+	if (vcpu_array_size < sizeof(*vcpu_array) * nr_vcpus)
+		return -EINVAL;
+
+	for (i = 0; i < nr_vcpus; i++) {
+		struct kvm_vcpu *host_vcpu = kern_hyp_va(vcpu_array[i]);
+
+		if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1)) {
+			unpin_host_vcpus(shadow_vcpu_states, i);
+			return -EBUSY;
+		}
+
+		shadow_vcpu_states[i].host_vcpu = host_vcpu;
+	}
+
+	return 0;
+}
+
+static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
+			       struct kvm_vcpu **vcpu_array,
+			       unsigned int nr_vcpus)
+{
+	int i;
+
+	vm->host_kvm = kvm;
+	vm->kvm.created_vcpus = nr_vcpus;
+	vm->kvm.arch.vtcr = host_kvm.arch.vtcr;
+
+	for (i = 0; i < nr_vcpus; i++) {
+		struct kvm_shadow_vcpu_state *shadow_vcpu_state = &vm->shadow_vcpu_states[i];
+		struct kvm_vcpu *shadow_vcpu = &shadow_vcpu_state->shadow_vcpu;
+		struct kvm_vcpu *host_vcpu = shadow_vcpu_state->host_vcpu;
+
+		shadow_vcpu_state->shadow_vm = vm;
+
+		shadow_vcpu->kvm = &vm->kvm;
+		shadow_vcpu->vcpu_id = READ_ONCE(host_vcpu->vcpu_id);
+		shadow_vcpu->vcpu_idx = i;
+
+		shadow_vcpu->arch.hw_mmu = &vm->kvm.arch.mmu;
+	}
+
+	return 0;
+}
+
+static bool __exists_shadow(struct kvm *host_kvm)
+{
+	int i;
+	unsigned int nr_checked = 0;
+
+	for (i = 0; i < KVM_MAX_PVMS && nr_checked < nr_shadow_entries; i++) {
+		if (!shadow_table[i])
+			continue;
+
+		if (unlikely(shadow_table[i]->host_kvm == host_kvm))
+			return true;
+
+		nr_checked++;
+	}
+
+	return false;
+}
+
+/*
+ * Allocate a shadow table entry and insert a pointer to the shadow vm.
+ *
+ * Return a unique handle to the protected VM on success,
+ * negative error code on failure.
+ */
+static unsigned int insert_shadow_table(struct kvm *kvm,
+					struct kvm_shadow_vm *vm,
+					size_t shadow_size)
+{
+	struct kvm_s2_mmu *mmu = &vm->kvm.arch.mmu;
+	unsigned int shadow_handle;
+	unsigned int vmid;
+
+	hyp_assert_lock_held(&shadow_lock);
+
+	if (unlikely(nr_shadow_entries >= KVM_MAX_PVMS))
+		return -ENOMEM;
+
+	/*
+	 * Initializing protected state might have failed, yet a malicious host
+	 * could trigger this function. Thus, ensure that shadow_table exists.
+	 */
+	if (unlikely(!shadow_table))
+		return -EINVAL;
+
+	/* Check that a shadow hasn't been created before for this host KVM. */
+	if (unlikely(__exists_shadow(kvm)))
+		return -EEXIST;
+
+	/* Find the next free entry in the shadow table. */
+	while (shadow_table[next_shadow_alloc])
+		next_shadow_alloc = (next_shadow_alloc + 1) % KVM_MAX_PVMS;
+	shadow_handle = idx_to_shadow_handle(next_shadow_alloc);
+
+	vm->kvm.arch.pkvm.shadow_handle = shadow_handle;
+	vm->shadow_area_size = shadow_size;
+
+	/* VMID 0 is reserved for the host */
+	vmid = next_shadow_alloc + 1;
+	if (vmid > 0xff)
+		return -ENOMEM;
+
+	atomic64_set(&mmu->vmid.id, vmid);
+	mmu->arch = &vm->kvm.arch;
+	mmu->pgt = &vm->pgt;
+
+	shadow_table[next_shadow_alloc] = vm;
+	next_shadow_alloc = (next_shadow_alloc + 1) % KVM_MAX_PVMS;
+	nr_shadow_entries++;
+
+	return shadow_handle;
+}
+
+/*
+ * Deallocate and remove the shadow table entry corresponding to the handle.
+ */
+static void remove_shadow_table(unsigned int shadow_handle)
+{
+	hyp_assert_lock_held(&shadow_lock);
+	shadow_table[shadow_handle_to_idx(shadow_handle)] = NULL;
+	nr_shadow_entries--;
+}
+
+static size_t pkvm_get_shadow_size(unsigned int nr_vcpus)
+{
+	/* Shadow space for the vm struct and all of its vcpu states. */
+	return sizeof(struct kvm_shadow_vm) +
+	       sizeof(struct kvm_shadow_vcpu_state) * nr_vcpus;
+}
+
+/*
+ * Check whether the size of the area donated by the host is sufficient for
+ * the shadow structures required for nr_vcpus as well as the shadow vm.
+ */
+static int check_shadow_size(unsigned int nr_vcpus, size_t shadow_size)
+{
+	if (nr_vcpus < 1 || nr_vcpus > KVM_MAX_VCPUS)
+		return -EINVAL;
+
+	/*
+	 * Shadow size is rounded up when allocated and donated by the host,
+	 * so it's likely to be larger than the sum of the struct sizes.
+	 */
+	if (shadow_size < pkvm_get_shadow_size(nr_vcpus))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
+{
+	void *va = (void *)kern_hyp_va(host_va);
+
+	if (!PAGE_ALIGNED(va) || !PAGE_ALIGNED(size))
+		return NULL;
+
+	if (__pkvm_host_donate_hyp(hyp_virt_to_pfn(va), size >> PAGE_SHIFT))
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
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va), size >> PAGE_SHIFT));
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
+ * Initialize the shadow copy of the protected VM state using the memory
+ * donated by the host.
+ *
+ * Unmaps the donated memory from the host at stage 2.
+ *
+ * kvm: A pointer to the host's struct kvm (host va).
+ * shadow_hva: The host va of the area being donated for the shadow state.
+ *	       Must be page aligned.
+ * shadow_size: The size of the area being donated for the shadow state.
+ *		Must be a multiple of the page size.
+ * pgd_hva: The host va of the area being donated for the stage-2 PGD for
+ *	    the VM. Must be page aligned. Its size is implied by the VM's
+ *	    VTCR.
+ * Note: An array to the host KVM VCPUs (host VA) is passed via the pgd, as to
+ *	 not to be dependent on how the VCPU's are layed out in struct kvm.
+ *
+ * Return a unique handle to the protected VM on success,
+ * negative error code on failure.
+ */
+int __pkvm_init_shadow(struct kvm *kvm, unsigned long shadow_hva,
+		       size_t shadow_size, unsigned long pgd_hva)
+{
+	struct kvm_shadow_vm *vm = NULL;
+	unsigned int nr_vcpus;
+	size_t pgd_size = 0;
+	void *pgd = NULL;
+	int ret;
+
+	kvm = kern_hyp_va(kvm);
+	ret = hyp_pin_shared_mem(kvm, kvm + 1);
+	if (ret)
+		return ret;
+
+	nr_vcpus = READ_ONCE(kvm->created_vcpus);
+	ret = check_shadow_size(nr_vcpus, shadow_size);
+	if (ret)
+		goto err_unpin_kvm;
+
+	ret = -ENOMEM;
+
+	vm = map_donated_memory(shadow_hva, shadow_size);
+	if (!vm)
+		goto err_remove_mappings;
+
+	pgd_size = kvm_pgtable_stage2_pgd_size(host_kvm.arch.vtcr);
+	pgd = map_donated_memory_noclear(pgd_hva, pgd_size);
+	if (!pgd)
+		goto err_remove_mappings;
+
+	ret = set_host_vcpus(vm->shadow_vcpu_states, nr_vcpus, pgd, pgd_size);
+	if (ret)
+		goto err_remove_mappings;
+
+	ret = init_shadow_structs(kvm, vm, pgd, nr_vcpus);
+	if (ret < 0)
+		goto err_unpin_host_vcpus;
+
+	/* Add the entry to the shadow table. */
+	hyp_spin_lock(&shadow_lock);
+	ret = insert_shadow_table(kvm, vm, shadow_size);
+	if (ret < 0)
+		goto err_unlock_unpin_host_vcpus;
+
+	ret = kvm_guest_prepare_stage2(vm, pgd);
+	if (ret)
+		goto err_remove_shadow_table;
+	hyp_spin_unlock(&shadow_lock);
+
+	return vm->kvm.arch.pkvm.shadow_handle;
+
+err_remove_shadow_table:
+	remove_shadow_table(vm->kvm.arch.pkvm.shadow_handle);
+err_unlock_unpin_host_vcpus:
+	hyp_spin_unlock(&shadow_lock);
+err_unpin_host_vcpus:
+	unpin_host_vcpus(vm->shadow_vcpu_states, nr_vcpus);
+err_remove_mappings:
+	unmap_donated_memory(vm, shadow_size);
+	unmap_donated_memory_noclear(pgd, pgd_size);
+err_unpin_kvm:
+	hyp_unpin_shared_mem(kvm, kvm + 1);
+	return ret;
+}
+
+int __pkvm_teardown_shadow(unsigned int shadow_handle)
+{
+	struct kvm_shadow_vm *vm;
+	size_t shadow_size;
+	int err;
+
+	/* Lookup then remove entry from the shadow table. */
+	hyp_spin_lock(&shadow_lock);
+	vm = find_shadow_by_handle(shadow_handle);
+	if (!vm) {
+		err = -ENOENT;
+		goto err_unlock;
+	}
+
+	if (WARN_ON(hyp_page_count(vm))) {
+		err = -EBUSY;
+		goto err_unlock;
+	}
+
+	/* Ensure the VMID is clean before it can be reallocated */
+	__kvm_tlb_flush_vmid(&vm->kvm.arch.mmu);
+	remove_shadow_table(shadow_handle);
+	hyp_spin_unlock(&shadow_lock);
+
+	/* Reclaim guest pages (including page-table pages) */
+	reclaim_guest_pages(vm);
+	unpin_host_vcpus(vm->shadow_vcpu_states, vm->kvm.created_vcpus);
+
+	/* Push the metadata pages to the teardown memcache */
+	shadow_size = vm->shadow_area_size;
+	hyp_unpin_shared_mem(vm->host_kvm, vm->host_kvm + 1);
+
+	memset(vm, 0, shadow_size);
+	unmap_donated_memory_noclear(vm, shadow_size);
+	return 0;
+
+err_unlock:
+	hyp_spin_unlock(&shadow_lock);
+	return err;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 0312c9c74a5a..fb0eff15a89f 100644
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
+static void *shadow_table_base;
 static void *hyp_pgt_base;
 static void *host_s2_pgt_base;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
@@ -40,6 +42,11 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	if (!vmemmap_base)
 		return -ENOMEM;
 
+	nr_pages = hyp_shadow_table_pages();
+	shadow_table_base = hyp_early_alloc_contig(nr_pages);
+	if (!shadow_table_base)
+		return -ENOMEM;
+
 	nr_pages = hyp_s1_pgtable_pages();
 	hyp_pgt_base = hyp_early_alloc_contig(nr_pages);
 	if (!hyp_pgt_base)
@@ -314,6 +321,7 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	hyp_shadow_table_init(shadow_table_base);
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2cb3867eb7c2..1d300313009d 100644
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
index 34229425b25d..3947063cc3a1 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -71,6 +71,7 @@ void __init kvm_hyp_reserve(void)
 
 	hyp_mem_pages += hyp_s1_pgtable_pages();
 	hyp_mem_pages += host_s2_pgtable_pages();
+	hyp_mem_pages += hyp_shadow_table_pages();
 	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
 
 	/*
-- 
2.37.0.rc0.161.g10f37bed90-goog

