Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6586061F3
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiJTNkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiJTNkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:40:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A476AEA7
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 613BACE2592
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1CCC43142;
        Thu, 20 Oct 2022 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666273187;
        bh=o5Y9y8aWciq2NFHUedSOz5UeLnNge2DRdSy8FW4ONFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6AMHsFzCViQ1oAG6tEnsmGVXa8Nnpww6D9mQau4r1H3EKVnq7FtMeLy/6epECSl5
         J3cUAQLNw5YwTWk0d5PVlQ2CoLyau9s6mOZvbR0fOGJDCrFYBHjblK0XWf/C8/bKun
         3IKCU4PulIA0gS6ao48Otzg0XUssK5B6GzuwMFfI4EKzEbt4vLBGqy2/kIbNGAUIln
         PsFkyQQlZwd00Rig2+hkyFcy4I4HbVspzybCZzsJxrm/2QqAOBvePHvU+VW7KiJN2d
         bKSRCHTg3ik6zH4Xam6s84VWObbYTZER6eNZLs+PUJtbbjxS0YTIXoHlHY1YWzPZHL
         beOmUyrJNYnPg==
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
Subject: [PATCH v5 19/25] KVM: arm64: Instantiate guest stage-2 page-tables at EL2
Date:   Thu, 20 Oct 2022 14:38:21 +0100
Message-Id: <20221020133827.5541-20-will@kernel.org>
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
index 1c38451050e5..27b16a6b85bb 100644
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
2.38.0.413.g74048e4d9e-goog

