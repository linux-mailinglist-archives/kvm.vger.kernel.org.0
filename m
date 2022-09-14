Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDFB5B830E
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiINIgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiINIgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:36:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B9B5F7E2
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E00C1B81101
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AA1C433C1;
        Wed, 14 Sep 2022 08:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144555;
        bh=yBziGwaQiI9PtC7eieh8v6eY62rS/gJp8YyIGUdH5nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnCXIumKnXgrjTcmgBDb0q0ECd4aqSvF3bGA+a0AFEUiv9p1EWGxJPX5RPSSrXBmB
         PQInUwdSRdi7WWUXHTGAIi9ZHp4YSTF7FVWStDoXNWz74g73kEBKP7cn0t6ogLroVV
         K8y5OAwi/lz5vixB4okpCodZ24o5HLca2tPRQZoJd10Es6y+/Gjb/EKQURZ8fPz6rC
         FOkFJtjYprrXTUzp4sHaIfgbJHYKq0ers958Avt25keggaIf5q9PZ394Xho3g8Ip7f
         4V59pb0/NvkmW3geNd4MBngQX3PRMWKLVmy9NoL+l23AmBFUpkB3KjxlNL42CdEpKI
         aGDfeGp5fDfhg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 13/25] KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from EL1
Date:   Wed, 14 Sep 2022 09:34:48 +0100
Message-Id: <20220914083500.5118-14-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  |  15 +++-
 arch/arm64/include/asm/kvm_pkvm.h  |   4 +
 arch/arm64/kvm/arm.c               |  14 +++
 arch/arm64/kvm/hyp/hyp-constants.c |   3 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  15 +++-
 arch/arm64/kvm/pkvm.c              | 138 +++++++++++++++++++++++++++++
 6 files changed, 183 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4844ba377871..546d4bdea932 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -117,6 +117,17 @@ struct kvm_smccc_features {
 
 typedef unsigned int pkvm_handle_t;
 
+struct kvm_protected_vm {
+	pkvm_handle_t handle;
+	struct mutex vm_lock;
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
 
@@ -170,10 +181,10 @@ struct kvm_arch {
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
index e22856cf4207..8340798b2289 100644
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
index 986cee6fbc7f..0befe2313604 100644
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
index 9e0222f58b91..6469bf45537a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -335,7 +335,7 @@ static pkvm_handle_t insert_vm_table_entry(struct kvm *host_kvm,
 	if (idx < 0)
 		return idx;
 
-	hyp_vm->kvm.arch.pkvm_handle = idx_to_vm_handle(idx);
+	hyp_vm->kvm.arch.pkvm.handle = idx_to_vm_handle(idx);
 	hyp_vm->donated_memory_size = donated_memory_size;
 
 	/* VMID 0 is reserved for the host */
@@ -345,7 +345,7 @@ static pkvm_handle_t insert_vm_table_entry(struct kvm *host_kvm,
 	mmu->pgt = &hyp_vm->pgt;
 
 	vm_table[idx] = hyp_vm;
-	return hyp_vm->kvm.arch.pkvm_handle;
+	return hyp_vm->kvm.arch.pkvm.handle;
 }
 
 /*
@@ -470,10 +470,10 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
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
@@ -539,6 +539,7 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 int __pkvm_teardown_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
+	unsigned int idx;
 	int err;
 
 	hyp_spin_lock(&vm_table_lock);
@@ -565,6 +566,12 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	/* Push the metadata pages to the teardown memcache */
 	hyp_unpin_shared_mem(hyp_vm->host_kvm, hyp_vm->host_kvm + 1);
 
+	for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
+		struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
+
+		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
+	}
+
 	unmap_donated_memory(hyp_vm, hyp_vm->donated_memory_size);
 	return 0;
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 71493136e59c..754632a608e3 100644
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
+	mutex_lock(&host_kvm->arch.pkvm.vm_lock);
+	if (!host_kvm->arch.pkvm.handle)
+		ret = __pkvm_create_hyp_vm(host_kvm);
+	mutex_unlock(&host_kvm->arch.pkvm.vm_lock);
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
+	mutex_init(&host_kvm->arch.pkvm.vm_lock);
+	return 0;
+}
-- 
2.37.2.789.g6183377224-goog

