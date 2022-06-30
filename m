Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3033561DAD
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbiF3OOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237537AbiF3ON0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB9B15714
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CCB861FCB
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D787C34115;
        Thu, 30 Jun 2022 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597549;
        bh=30dNE0wWVFK96CPhSt0kble4nLGBd3sqOAIzyYktuZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBQ1FC/rmwtl/nbtkcDgDbzXz/I0tdCnVXtgM8mVz/8KUxQu0Jof6biBGWYfLwsfJ
         /XjWJHdiYqHcA9IkP03K/BkbIYz5zLukiuyYdL3ZH+iCuVIidreGvURcSymuElUeSX
         g5hL3PKru9ueEu08z7f5PEBPyDBTukzlEgzgaRJu0Htp7Pje82e8sB5NwmWBcppP1A
         r+IkzMwR4EZJ1pkoM4JsSotXtgzUwxR+dHUyjJnJlnZ4fl3BHkg5DROU8IvXGEp8Br
         WBbmqSgPR9UJK1PFBUfWal91DACjASrGyG5aoeXi/t8MixGwDz9oBL4/gW5lR9c4Na
         e3FOUm4t4JmYA==
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
Subject: [PATCH v2 19/24] KVM: arm64: Return guest memory from EL2 via dedicated teardown memcache
Date:   Thu, 30 Jun 2022 14:57:42 +0100
Message-Id: <20220630135747.26983-20-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

Rather than relying on the host to free the shadow VM pages explicitly
on teardown, introduce a dedicated teardown memcache which allows the
host to reclaim guest memory resources without having to keep track of
all of the allocations made by EL2.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h             |  6 +-----
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 17 +++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +++++++-
 arch/arm64/kvm/pkvm.c                         | 12 +-----------
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 70a2db91665d..09481268c224 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -175,11 +175,7 @@ struct kvm_smccc_features {
 struct kvm_protected_vm {
 	unsigned int shadow_handle;
 	struct mutex shadow_lock;
-
-	struct {
-		void *pgd;
-		void *shadow;
-	} hyp_donations;
+	struct kvm_hyp_memcache teardown_mc;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 36eea31a1c5f..663019992b67 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -76,7 +76,7 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
 int hyp_pin_shared_mem(void *from, void *to);
 void hyp_unpin_shared_mem(void *from, void *to);
-void reclaim_guest_pages(struct kvm_shadow_vm *vm);
+void reclaim_guest_pages(struct kvm_shadow_vm *vm, struct kvm_hyp_memcache *mc);
 int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
 		    struct kvm_hyp_memcache *host_mc);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 5b22bba77e57..bcfdba1881c1 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -260,19 +260,24 @@ int kvm_guest_prepare_stage2(struct kvm_shadow_vm *vm, void *pgd)
 	return 0;
 }
 
-void reclaim_guest_pages(struct kvm_shadow_vm *vm)
+void reclaim_guest_pages(struct kvm_shadow_vm *vm, struct kvm_hyp_memcache *mc)
 {
-	unsigned long nr_pages, pfn;
-
-	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
-	pfn = hyp_virt_to_pfn(vm->pgt.pgd);
+	void *addr;
 
+	/* Dump all pgtable pages in the hyp_pool */
 	guest_lock_component(vm);
 	kvm_pgtable_stage2_destroy(&vm->pgt);
 	vm->kvm.arch.mmu.pgd_phys = 0ULL;
 	guest_unlock_component(vm);
 
-	WARN_ON(__pkvm_hyp_donate_host(pfn, nr_pages));
+	/* Drain the hyp_pool into the memcache */
+	addr = hyp_alloc_pages(&vm->pool, 0);
+	while (addr) {
+		memset(hyp_virt_to_page(addr), 0, sizeof(struct hyp_page));
+		push_hyp_memcache(mc, addr, hyp_virt_to_phys);
+		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
+		addr = hyp_alloc_pages(&vm->pool, 0);
+	}
 }
 
 int __pkvm_prot_finalize(void)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 114c5565de7d..a4a518b2a43b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -546,8 +546,10 @@ int __pkvm_init_shadow(struct kvm *kvm, unsigned long shadow_hva,
 
 int __pkvm_teardown_shadow(unsigned int shadow_handle)
 {
+	struct kvm_hyp_memcache *mc;
 	struct kvm_shadow_vm *vm;
 	size_t shadow_size;
+	void *addr;
 	int err;
 
 	/* Lookup then remove entry from the shadow table. */
@@ -569,7 +571,8 @@ int __pkvm_teardown_shadow(unsigned int shadow_handle)
 	hyp_spin_unlock(&shadow_lock);
 
 	/* Reclaim guest pages (including page-table pages) */
-	reclaim_guest_pages(vm);
+	mc = &vm->host_kvm->arch.pkvm.teardown_mc;
+	reclaim_guest_pages(vm, mc);
 	unpin_host_vcpus(vm->shadow_vcpu_states, vm->kvm.created_vcpus);
 
 	/* Push the metadata pages to the teardown memcache */
@@ -577,6 +580,9 @@ int __pkvm_teardown_shadow(unsigned int shadow_handle)
 	hyp_unpin_shared_mem(vm->host_kvm, vm->host_kvm + 1);
 
 	memset(vm, 0, shadow_size);
+	for (addr = vm; addr < (void *)vm + shadow_size; addr += PAGE_SIZE)
+		push_hyp_memcache(mc, addr, hyp_virt_to_phys);
+
 	unmap_donated_memory_noclear(vm, shadow_size);
 	return 0;
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b4466b31d7c8..b174d6dfde36 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -160,8 +160,6 @@ static int __kvm_shadow_create(struct kvm *kvm)
 
 	/* Store the shadow handle given by hyp for future call reference. */
 	kvm->arch.pkvm.shadow_handle = shadow_handle;
-	kvm->arch.pkvm.hyp_donations.pgd = pgd;
-	kvm->arch.pkvm.hyp_donations.shadow = shadow_addr;
 	return 0;
 
 free_shadow:
@@ -185,20 +183,12 @@ int kvm_shadow_create(struct kvm *kvm)
 
 void kvm_shadow_destroy(struct kvm *kvm)
 {
-	size_t pgd_sz, shadow_sz;
-
 	if (kvm->arch.pkvm.shadow_handle)
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_shadow,
 					  kvm->arch.pkvm.shadow_handle));
 
 	kvm->arch.pkvm.shadow_handle = 0;
-
-	shadow_sz = PAGE_ALIGN(KVM_SHADOW_VM_SIZE +
-			       KVM_SHADOW_VCPU_STATE_SIZE * kvm->created_vcpus);
-	pgd_sz = kvm_pgtable_stage2_pgd_size(kvm->arch.vtcr);
-
-	free_pages_exact(kvm->arch.pkvm.hyp_donations.shadow, shadow_sz);
-	free_pages_exact(kvm->arch.pkvm.hyp_donations.pgd, pgd_sz);
+	free_hyp_memcache(&kvm->arch.pkvm.teardown_mc);
 }
 
 int kvm_init_pvm(struct kvm *kvm)
-- 
2.37.0.rc0.161.g10f37bed90-goog

