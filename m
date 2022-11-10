Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E25624A23
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiKJTER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiKJTEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:04:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAE63E09D
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 11:03:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24A7DB8218E
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 19:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905C4C433D7;
        Thu, 10 Nov 2022 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668107036;
        bh=mOL4Ec60ezI5bZVyIc/dh1MfcoV902eT+uFOLxuGxDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZUfNbyUXHX587pgVvmiVpr1mKiRd3ORLMYlQMPGfjtdWbR19l/Je2bFDIJrzUXq3
         jENgs1weyYhw1TK/EZ9JJ8uGsyzUp4WpHMgbTAp322Z6MbfmWlVSLhekHJB0j8UCXV
         EVwFM9CJwzdN97B0qqsAXrEcHLkSXtjTSwNZHVOQ2UcWsDhIQ6fGj5aOl7C7Ihmcgi
         KL3AJ8DtEkoNxv/ufQXhojBij+ccj5y2XNy2FyQw/XpfPnYQRQSwbeJlchlJIYCqTq
         tssnr+Jp0yrNezPLXJ/0oAjAyl9/2Zz+PZb1Ba3wwB9Cl37GQztlqFO2I91/aT43XS
         ZjArso1Lx5BVQ==
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
Subject: [PATCH v6 13/26] KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from EL1
Date:   Thu, 10 Nov 2022 19:02:46 +0000
Message-Id: <20221110190259.26861-14-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221110190259.26861-1-will@kernel.org>
References: <20221110190259.26861-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fuad Tabba <tabba@google.com>

With the pKVM hypervisor at EL2 now offering hypercalls to the host for
creating and destroying VM and vCPU structures, plumb these in to the
existing arm64 KVM backend to ensure that the hypervisor data structures
are allocated and initialised on first vCPU run for a pKVM guest.

In the host, 'struct kvm_protected_vm' is introduced to hold the handle
of the pKVM VM instance as well as to track references to the memory
donated to the hypervisor so that it can be freed back to the host
allocator following VM teardown. The stage-2 page-table, hypervisor VM
and vCPU structures are allocated separately so as to avoid the need for
a large physically-contiguous allocation in the host at run-time.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  |  14 ++-
 arch/arm64/include/asm/kvm_pkvm.h  |   4 +
 arch/arm64/kvm/arm.c               |  14 +++
 arch/arm64/kvm/hyp/hyp-constants.c |   3 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  15 +++-
 arch/arm64/kvm/pkvm.c              | 138 +++++++++++++++++++++++++++++
 6 files changed, 182 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d3dd7ab9c79e..467393e7331f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -117,6 +117,16 @@ struct kvm_smccc_features {
 
 typedef unsigned int pkvm_handle_t;
 
+struct kvm_protected_vm {
+	pkvm_handle_t handle;
+
+	struct {
+		void *pgd;
+		void *vm;
+		void *vcpus[KVM_MAX_VCPUS];
+	} hyp_donations;
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -170,10 +180,10 @@ struct kvm_arch {
 	struct kvm_smccc_features smccc_feat;
 
 	/*
-	 * For an untrusted host VM, 'pkvm_handle' is used to lookup
+	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
 	 */
-	pkvm_handle_t pkvm_handle;
+	struct kvm_protected_vm pkvm;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index f4e3133d6550..01129b0d4c68 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -14,6 +14,10 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
+int pkvm_init_host_vm(struct kvm *kvm);
+int pkvm_create_hyp_vm(struct kvm *kvm);
+void pkvm_destroy_hyp_vm(struct kvm *kvm);
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..30d6fc5d3a93 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -37,6 +37,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
 
@@ -150,6 +151,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_free_stage2_pgd;
 
+	ret = pkvm_init_host_vm(kvm);
+	if (ret)
+		goto out_free_stage2_pgd;
+
 	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
 		ret = -ENOMEM;
 		goto out_free_stage2_pgd;
@@ -187,6 +192,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	kvm_vgic_destroy(kvm);
 
+	if (is_protected_kvm_enabled())
+		pkvm_destroy_hyp_vm(kvm);
+
 	kvm_destroy_vcpus(kvm);
 
 	kvm_unshare_hyp(kvm, kvm + 1);
@@ -569,6 +577,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+	if (is_protected_kvm_enabled()) {
+		ret = pkvm_create_hyp_vm(kvm);
+		if (ret)
+			return ret;
+	}
+
 	if (!irqchip_in_kernel(kvm)) {
 		/*
 		 * Tell the rest of the code that there are userspace irqchip
diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
index b3742a6691e8..b257a3b4bfc5 100644
--- a/arch/arm64/kvm/hyp/hyp-constants.c
+++ b/arch/arm64/kvm/hyp/hyp-constants.c
@@ -2,9 +2,12 @@
 
 #include <linux/kbuild.h>
 #include <nvhe/memory.h>
+#include <nvhe/pkvm.h>
 
 int main(void)
 {
 	DEFINE(STRUCT_HYP_PAGE_SIZE,	sizeof(struct hyp_page));
+	DEFINE(PKVM_HYP_VM_SIZE,	sizeof(struct pkvm_hyp_vm));
+	DEFINE(PKVM_HYP_VCPU_SIZE,	sizeof(struct pkvm_hyp_vcpu));
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 64f448b64201..80b8fb5b79fd 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -324,7 +324,7 @@ static pkvm_handle_t insert_vm_table_entry(struct kvm *host_kvm,
 	if (idx < 0)
 		return idx;
 
-	hyp_vm->kvm.arch.pkvm_handle = idx_to_vm_handle(idx);
+	hyp_vm->kvm.arch.pkvm.handle = idx_to_vm_handle(idx);
 
 	/* VMID 0 is reserved for the host */
 	atomic64_set(&mmu->vmid.id, idx + 1);
@@ -333,7 +333,7 @@ static pkvm_handle_t insert_vm_table_entry(struct kvm *host_kvm,
 	mmu->pgt = &hyp_vm->pgt;
 
 	vm_table[idx] = hyp_vm;
-	return hyp_vm->kvm.arch.pkvm_handle;
+	return hyp_vm->kvm.arch.pkvm.handle;
 }
 
 /*
@@ -458,10 +458,10 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 		goto err_remove_vm_table_entry;
 	hyp_spin_unlock(&vm_table_lock);
 
-	return hyp_vm->kvm.arch.pkvm_handle;
+	return hyp_vm->kvm.arch.pkvm.handle;
 
 err_remove_vm_table_entry:
-	remove_vm_table_entry(hyp_vm->kvm.arch.pkvm_handle);
+	remove_vm_table_entry(hyp_vm->kvm.arch.pkvm.handle);
 err_unlock:
 	hyp_spin_unlock(&vm_table_lock);
 err_remove_mappings:
@@ -528,6 +528,7 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
 	struct kvm *host_kvm;
+	unsigned int idx;
 	size_t vm_size;
 	int err;
 
@@ -553,6 +554,12 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->nr_vcpus);
 
 	/* Return the metadata pages to the host */
+	for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
+		struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
+
+		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
+	}
+
 	host_kvm = hyp_vm->host_kvm;
 	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
 	unmap_donated_memory(hyp_vm, vm_size);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 71493136e59c..8c443b915e43 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/memblock.h>
+#include <linux/mutex.h>
 #include <linux/sort.h>
 
 #include <asm/kvm_pkvm.h>
@@ -94,3 +95,140 @@ void __init kvm_hyp_reserve(void)
 	kvm_info("Reserved %lld MiB at 0x%llx\n", hyp_mem_size >> 20,
 		 hyp_mem_base);
 }
+
+/*
+ * Allocates and donates memory for hypervisor VM structs at EL2.
+ *
+ * Allocates space for the VM state, which includes the hyp vm as well as
+ * the hyp vcpus.
+ *
+ * Stores an opaque handler in the kvm struct for future reference.
+ *
+ * Return 0 on success, negative error code on failure.
+ */
+static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
+{
+	size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
+	struct kvm_vcpu *host_vcpu;
+	pkvm_handle_t handle;
+	void *pgd, *hyp_vm;
+	unsigned long idx;
+	int ret;
+
+	if (host_kvm->created_vcpus < 1)
+		return -EINVAL;
+
+	pgd_sz = kvm_pgtable_stage2_pgd_size(host_kvm->arch.vtcr);
+
+	/*
+	 * The PGD pages will be reclaimed using a hyp_memcache which implies
+	 * page granularity. So, use alloc_pages_exact() to get individual
+	 * refcounts.
+	 */
+	pgd = alloc_pages_exact(pgd_sz, GFP_KERNEL_ACCOUNT);
+	if (!pgd)
+		return -ENOMEM;
+
+	/* Allocate memory to donate to hyp for vm and vcpu pointers. */
+	hyp_vm_sz = PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
+					size_mul(sizeof(void *),
+						 host_kvm->created_vcpus)));
+	hyp_vm = alloc_pages_exact(hyp_vm_sz, GFP_KERNEL_ACCOUNT);
+	if (!hyp_vm) {
+		ret = -ENOMEM;
+		goto free_pgd;
+	}
+
+	/* Donate the VM memory to hyp and let hyp initialize it. */
+	ret = kvm_call_hyp_nvhe(__pkvm_init_vm, host_kvm, hyp_vm, pgd);
+	if (ret < 0)
+		goto free_vm;
+
+	handle = ret;
+
+	host_kvm->arch.pkvm.handle = handle;
+	host_kvm->arch.pkvm.hyp_donations.pgd = pgd;
+	host_kvm->arch.pkvm.hyp_donations.vm = hyp_vm;
+
+	/* Donate memory for the vcpus at hyp and initialize it. */
+	hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
+	kvm_for_each_vcpu(idx, host_vcpu, host_kvm) {
+		void *hyp_vcpu;
+
+		/* Indexing of the vcpus to be sequential starting at 0. */
+		if (WARN_ON(host_vcpu->vcpu_idx != idx)) {
+			ret = -EINVAL;
+			goto destroy_vm;
+		}
+
+		hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
+		if (!hyp_vcpu) {
+			ret = -ENOMEM;
+			goto destroy_vm;
+		}
+
+		host_kvm->arch.pkvm.hyp_donations.vcpus[idx] = hyp_vcpu;
+
+		ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, host_vcpu,
+					hyp_vcpu);
+		if (ret)
+			goto destroy_vm;
+	}
+
+	return 0;
+
+destroy_vm:
+	pkvm_destroy_hyp_vm(host_kvm);
+	return ret;
+free_vm:
+	free_pages_exact(hyp_vm, hyp_vm_sz);
+free_pgd:
+	free_pages_exact(pgd, pgd_sz);
+	return ret;
+}
+
+int pkvm_create_hyp_vm(struct kvm *host_kvm)
+{
+	int ret = 0;
+
+	mutex_lock(&host_kvm->lock);
+	if (!host_kvm->arch.pkvm.handle)
+		ret = __pkvm_create_hyp_vm(host_kvm);
+	mutex_unlock(&host_kvm->lock);
+
+	return ret;
+}
+
+void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
+{
+	unsigned long idx, nr_vcpus = host_kvm->created_vcpus;
+	size_t pgd_sz, hyp_vm_sz;
+
+	if (host_kvm->arch.pkvm.handle)
+		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
+					  host_kvm->arch.pkvm.handle));
+
+	host_kvm->arch.pkvm.handle = 0;
+
+	for (idx = 0; idx < nr_vcpus; ++idx) {
+		void *hyp_vcpu = host_kvm->arch.pkvm.hyp_donations.vcpus[idx];
+
+		if (!hyp_vcpu)
+			break;
+
+		free_pages_exact(hyp_vcpu, PAGE_ALIGN(PKVM_HYP_VCPU_SIZE));
+	}
+
+	hyp_vm_sz = PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
+					size_mul(sizeof(void *), nr_vcpus)));
+	pgd_sz = kvm_pgtable_stage2_pgd_size(host_kvm->arch.vtcr);
+
+	free_pages_exact(host_kvm->arch.pkvm.hyp_donations.vm, hyp_vm_sz);
+	free_pages_exact(host_kvm->arch.pkvm.hyp_donations.pgd, pgd_sz);
+}
+
+int pkvm_init_host_vm(struct kvm *host_kvm)
+{
+	mutex_init(&host_kvm->lock);
+	return 0;
+}
-- 
2.38.1.431.g37b22c650d-goog

