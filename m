Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AB9624A2B
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiKJTEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiKJTEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:04:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5871B7BA
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 11:04:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18444B822E0
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 19:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C88C433D6;
        Thu, 10 Nov 2022 19:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668107058;
        bh=LD9Jo+hmzhPHf1JOQcHWw0nfYDQYup5DLMLm/11J3vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSfzt3CcQI4KyXTsSBqHHvfXksFKL51uMKSMc7ahFq2w2kpm2V0dFup1yxwbqNY90
         1hHbUYxRDnrZWXey0JRkoMDfzDEIv0ULLwMhw3m4fTnNWfk62Vx7MJItbK8KYjpK9n
         LYTjphBEnt3MuvESwYAVktRrntGjqc3AsFuVIEd2wkj86gGXrtYXrpf2narehN3p8f
         NGniHtuMlcrm7xf2TXdV3+Zszyfiul/gTr8FQNtAwV1gPaofETZgoArFdaMxbdRRe4
         u7s7DVfcmDvW49QTjB/qeriwq7S1den8f0kmilzg8m2LZgepsjwYOfFBDeZF4klpwV
         wSAv53RBvlEAw==
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
Subject: [PATCH v6 19/26] KVM: arm64: Instantiate guest stage-2 page-tables at EL2
Date:   Thu, 10 Nov 2022 19:02:52 +0000
Message-Id: <20221110190259.26861-20-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

Extend the initialisation of guest data structures within the pKVM
hypervisor at EL2 so that we instantiate a memory pool and a full
'struct kvm_s2_mmu' structure for each VM, with a stage-2 page-table
entirely independent from the one managed by the host at EL1.

The 'struct kvm_pgtable_mm_ops' used by the page-table code is populated
with a set of callbacks that can manage guest pages in the hypervisor
without any direct intervention from the host, allocating page-table
pages from the provided pool and returning these to the host on VM
teardown. To keep things simple, the stage-2 MMU for the guest is
configured identically to the host stage-2 in the VTCR register and so
the IPA size of the guest must match the PA size of the host.

For now, the new page-table is unused as there is no way for the host
to map anything into it. Yet.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |   6 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c  | 125 ++++++++++++++++++++++++-
 arch/arm64/kvm/mmu.c                   |   4 +-
 3 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 8c653a3b9501..d14dfbcb7da1 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -9,6 +9,9 @@
 
 #include <asm/kvm_pkvm.h>
 
+#include <nvhe/gfp.h>
+#include <nvhe/spinlock.h>
+
 /*
  * Holds the relevant data for maintaining the vcpu state completely at hyp.
  */
@@ -30,6 +33,9 @@ struct pkvm_hyp_vm {
 
 	/* The guest's stage-2 page-table managed by the hypervisor. */
 	struct kvm_pgtable pgt;
+	struct kvm_pgtable_mm_ops mm_ops;
+	struct hyp_pool pool;
+	hyp_spinlock_t lock;
 
 	/*
 	 * The number of vcpus initialized and ready to run.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8b4d3f0aa7a0..0162afba6dc4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,6 +25,21 @@ struct host_mmu host_mmu;
 
 static struct hyp_pool host_s2_pool;
 
+static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
+#define current_vm (*this_cpu_ptr(&__current_vm))
+
+static void guest_lock_component(struct pkvm_hyp_vm *vm)
+{
+	hyp_spin_lock(&vm->lock);
+	current_vm = vm;
+}
+
+static void guest_unlock_component(struct pkvm_hyp_vm *vm)
+{
+	current_vm = NULL;
+	hyp_spin_unlock(&vm->lock);
+}
+
 static void host_lock_component(void)
 {
 	hyp_spin_lock(&host_mmu.lock);
@@ -140,18 +155,124 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 	return 0;
 }
 
+static bool guest_stage2_force_pte_cb(u64 addr, u64 end,
+				      enum kvm_pgtable_prot prot)
+{
+	return true;
+}
+
+static void *guest_s2_zalloc_pages_exact(size_t size)
+{
+	void *addr = hyp_alloc_pages(&current_vm->pool, get_order(size));
+
+	WARN_ON(size != (PAGE_SIZE << get_order(size)));
+	hyp_split_page(hyp_virt_to_page(addr));
+
+	return addr;
+}
+
+static void guest_s2_free_pages_exact(void *addr, unsigned long size)
+{
+	u8 order = get_order(size);
+	unsigned int i;
+
+	for (i = 0; i < (1 << order); i++)
+		hyp_put_page(&current_vm->pool, addr + (i * PAGE_SIZE));
+}
+
+static void *guest_s2_zalloc_page(void *mc)
+{
+	struct hyp_page *p;
+	void *addr;
+
+	addr = hyp_alloc_pages(&current_vm->pool, 0);
+	if (addr)
+		return addr;
+
+	addr = pop_hyp_memcache(mc, hyp_phys_to_virt);
+	if (!addr)
+		return addr;
+
+	memset(addr, 0, PAGE_SIZE);
+	p = hyp_virt_to_page(addr);
+	memset(p, 0, sizeof(*p));
+	p->refcount = 1;
+
+	return addr;
+}
+
+static void guest_s2_get_page(void *addr)
+{
+	hyp_get_page(&current_vm->pool, addr);
+}
+
+static void guest_s2_put_page(void *addr)
+{
+	hyp_put_page(&current_vm->pool, addr);
+}
+
+static void clean_dcache_guest_page(void *va, size_t size)
+{
+	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
+	hyp_fixmap_unmap();
+}
+
+static void invalidate_icache_guest_page(void *va, size_t size)
+{
+	__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
+	hyp_fixmap_unmap();
+}
+
 int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 {
-	vm->pgt.pgd = pgd;
+	struct kvm_s2_mmu *mmu = &vm->kvm.arch.mmu;
+	unsigned long nr_pages;
+	int ret;
+
+	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
+	ret = hyp_pool_init(&vm->pool, hyp_virt_to_pfn(pgd), nr_pages, 0);
+	if (ret)
+		return ret;
+
+	hyp_spin_lock_init(&vm->lock);
+	vm->mm_ops = (struct kvm_pgtable_mm_ops) {
+		.zalloc_pages_exact	= guest_s2_zalloc_pages_exact,
+		.free_pages_exact	= guest_s2_free_pages_exact,
+		.zalloc_page		= guest_s2_zalloc_page,
+		.phys_to_virt		= hyp_phys_to_virt,
+		.virt_to_phys		= hyp_virt_to_phys,
+		.page_count		= hyp_page_count,
+		.get_page		= guest_s2_get_page,
+		.put_page		= guest_s2_put_page,
+		.dcache_clean_inval_poc	= clean_dcache_guest_page,
+		.icache_inval_pou	= invalidate_icache_guest_page,
+	};
+
+	guest_lock_component(vm);
+	ret = __kvm_pgtable_stage2_init(mmu->pgt, mmu, &vm->mm_ops, 0,
+					guest_stage2_force_pte_cb);
+	guest_unlock_component(vm);
+	if (ret)
+		return ret;
+
+	vm->kvm.arch.mmu.pgd_phys = __hyp_pa(vm->pgt.pgd);
+
 	return 0;
 }
 
 void reclaim_guest_pages(struct pkvm_hyp_vm *vm)
 {
+	void *pgd = vm->pgt.pgd;
 	unsigned long nr_pages;
 
 	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
-	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
+
+	guest_lock_component(vm);
+	kvm_pgtable_stage2_destroy(&vm->pgt);
+	vm->kvm.arch.mmu.pgd_phys = 0ULL;
+	guest_unlock_component(vm);
+
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(pgd), nr_pages));
 }
 
 int __pkvm_prot_finalize(void)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 43761d31f763..301fc7275062 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -686,7 +686,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 		return -EINVAL;
 
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
-	if (phys_shift) {
+	if (is_protected_kvm_enabled()) {
+		phys_shift = kvm_ipa_limit;
+	} else if (phys_shift) {
 		if (phys_shift > kvm_ipa_limit ||
 		    phys_shift < ARM64_MIN_PARANGE_BITS)
 			return -EINVAL;
-- 
2.38.1.431.g37b22c650d-goog

