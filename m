Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813535B831D
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiINIgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiINIg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CD267C90
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:36:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A110B81681
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B057C4347C;
        Wed, 14 Sep 2022 08:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144580;
        bh=MTvQFSZG4vCk/H/YW0N6L6nwP5YUiWUxFHraR/uYdFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEvdyst9lDq77hhSi7TMv2GqCwunp0NUX7th58GNsjaDevVrDYdt45aj+HYJvzoFB
         KwScNa1RN9OY3NfoDK6dL5DSB4P3WwcdiQZ72MXnxt/aPRgLNTge59ywyC4vr7UaDj
         VWT2Rpw3NVjGJf8+u/Km+SUPdvc1SgZ4USdaEqirCp4XnNyqyI346kOhXNd5iKTeTe
         O5V1TQD1PQvtkJ7rdtmsR+ET1tCVJ11IaTbJ6s16f3GIvvQvDhIx31z653AyfnBc+9
         xQZOSjq2lO8pKwTt6RhW453fKa19LJGeS8fgXZNXC3h3xA90nxgtDNZ2tzR0swJmxj
         0sBL2hsMmdAfA==
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
Subject: [PATCH v3 20/25] KVM: arm64: Return guest memory from EL2 via dedicated teardown memcache
Date:   Wed, 14 Sep 2022 09:34:55 +0100
Message-Id: <20220914083500.5118-21-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

Rather than relying on the host to free the previously-donated pKVM
hypervisor VM pages explicitly on teardown, introduce a dedicated
teardown memcache which allows the host to reclaim guest memory
resources without having to keep track of all of the allocations made by
the pKVM hypervisor at EL2.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h             |  7 +----
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 17 ++++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 20 ++++++++++--
 arch/arm64/kvm/pkvm.c                         | 31 ++++---------------
 5 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 93f25231b247..362fe3073970 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -177,12 +177,7 @@ typedef unsigned int pkvm_handle_t;
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct mutex vm_lock;
-
-	struct {
-		void *pgd;
-		void *vm;
-		void *vcpus[KVM_MAX_VCPUS];
-	} hyp_donations;
+	struct kvm_hyp_memcache teardown_mc;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 420b87e755a4..b7bdbe63deed 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -76,7 +76,7 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
 int hyp_pin_shared_mem(void *from, void *to);
 void hyp_unpin_shared_mem(void *from, void *to);
-void reclaim_guest_pages(struct pkvm_hyp_vm *vm);
+void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc);
 int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
 		    struct kvm_hyp_memcache *host_mc);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 27b16a6b85bb..ffa56a89acdb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -260,19 +260,24 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 	return 0;
 }
 
-void reclaim_guest_pages(struct pkvm_hyp_vm *vm)
+void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
 {
-	void *pgd = vm->pgt.pgd;
-	unsigned long nr_pages;
-
-	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
+	void *addr;
 
+	/* Dump all pgtable pages in the hyp_pool */
 	guest_lock_component(vm);
 	kvm_pgtable_stage2_destroy(&vm->pgt);
 	vm->kvm.arch.mmu.pgd_phys = 0ULL;
 	guest_unlock_component(vm);
 
-	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(pgd), nr_pages));
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
index 6ff78118a140..09e221ea6184 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -539,8 +539,21 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	return ret;
 }
 
+static void
+teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
+{
+	size = PAGE_ALIGN(size);
+	memset(addr, 0, size);
+
+	for (void *start = addr; start < addr + size; start += PAGE_SIZE)
+		push_hyp_memcache(mc, start, hyp_virt_to_phys);
+
+	unmap_donated_memory_noclear(addr, size);
+}
+
 int __pkvm_teardown_vm(pkvm_handle_t handle)
 {
+	struct kvm_hyp_memcache *mc;
 	struct pkvm_hyp_vm *hyp_vm;
 	unsigned int idx;
 	int err;
@@ -563,7 +576,8 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 
 	/* Reclaim guest pages (including page-table pages) */
-	reclaim_guest_pages(hyp_vm);
+	mc = &hyp_vm->host_kvm->arch.pkvm.teardown_mc;
+	reclaim_guest_pages(hyp_vm, mc);
 	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->nr_vcpus);
 
 	/* Push the metadata pages to the teardown memcache */
@@ -572,10 +586,10 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
 		struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
 
-		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
+		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
 	}
 
-	unmap_donated_memory(hyp_vm, hyp_vm->donated_memory_size);
+	teardown_donated_memory(mc, hyp_vm, hyp_vm->donated_memory_size);
 	return 0;
 
 err_unlock:
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 754632a608e3..a9953db08592 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -147,8 +147,6 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	handle = ret;
 
 	host_kvm->arch.pkvm.handle = handle;
-	host_kvm->arch.pkvm.hyp_donations.pgd = pgd;
-	host_kvm->arch.pkvm.hyp_donations.vm = hyp_vm;
 
 	/* Donate memory for the vcpus at hyp and initialize it. */
 	hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
@@ -167,12 +165,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 			goto destroy_vm;
 		}
 
-		host_kvm->arch.pkvm.hyp_donations.vcpus[idx] = hyp_vcpu;
-
 		ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, host_vcpu,
 					hyp_vcpu);
-		if (ret)
+		if (ret) {
+			free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
 			goto destroy_vm;
+		}
 	}
 
 	return 0;
@@ -201,30 +199,13 @@ int pkvm_create_hyp_vm(struct kvm *host_kvm)
 
 void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 {
-	unsigned long idx, nr_vcpus = host_kvm->created_vcpus;
-	size_t pgd_sz, hyp_vm_sz;
-
-	if (host_kvm->arch.pkvm.handle)
+	if (host_kvm->arch.pkvm.handle) {
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
 					  host_kvm->arch.pkvm.handle));
-
-	host_kvm->arch.pkvm.handle = 0;
-
-	for (idx = 0; idx < nr_vcpus; ++idx) {
-		void *hyp_vcpu = host_kvm->arch.pkvm.hyp_donations.vcpus[idx];
-
-		if (!hyp_vcpu)
-			break;
-
-		free_pages_exact(hyp_vcpu, PAGE_ALIGN(PKVM_HYP_VCPU_SIZE));
 	}
 
-	hyp_vm_sz = PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
-					size_mul(sizeof(void *), nr_vcpus)));
-	pgd_sz = kvm_pgtable_stage2_pgd_size(host_kvm->arch.vtcr);
-
-	free_pages_exact(host_kvm->arch.pkvm.hyp_donations.vm, hyp_vm_sz);
-	free_pages_exact(host_kvm->arch.pkvm.hyp_donations.pgd, pgd_sz);
+	host_kvm->arch.pkvm.handle = 0;
+	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
 }
 
 int pkvm_init_host_vm(struct kvm *host_kvm)
-- 
2.37.2.789.g6183377224-goog

