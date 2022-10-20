Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C266061F1
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiJTNkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiJTNkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:40:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A581019C00
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 148C861B6C
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5074FC4347C;
        Thu, 20 Oct 2022 13:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666273191;
        bh=DjTSnAnbe8UZuI5vaWWksekR4L6u8jDQaNUvBD1t22c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDlFTbg/O7esnLmtLEWmOPuhSiUtKL+gXGxc/V0wAM9Vv4SbPN6W0ycXbPI6lbdXR
         Ve/d9JVsbmfougTA2r+MsybBdTnBbKjVvUx2uyrMVini5rdYxpeF8ZwkSGvc/xY5g7
         Oz/Aq/uclOPel2+gP5Kwa6QLkNajcCSv95CIK3c+2YJ+AyZxq3EAWDE3U1RtqzuRcZ
         NjOdhiexx1cvizxFPlRA3Bm8ll6b2DhaLJytaVsjZVd4pYoecKT5OBOpmqlRupJmzq
         0hPux9o1fChHjxLtlUhON757EkuPQHR1jvEuJCTJyYz1jNOKCSQq0/f+apsdjPRn5b
         OfTpMukYj2/zA==
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
Subject: [PATCH v5 20/25] KVM: arm64: Return guest memory from EL2 via dedicated teardown memcache
Date:   Thu, 20 Oct 2022 14:38:22 +0100
Message-Id: <20221020133827.5541-21-will@kernel.org>
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

Rather than relying on the host to free the previously-donated pKVM
hypervisor VM pages explicitly on teardown, introduce a dedicated
teardown memcache which allows the host to reclaim guest memory
resources without having to keep track of all of the allocations made by
the pKVM hypervisor at EL2.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
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
index 57218f0c449e..63307e7dc9c5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -176,12 +176,7 @@ typedef unsigned int pkvm_handle_t;
 
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
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
index 604505ed7727..0bf9d20b0eeb 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -527,8 +527,21 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
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
 	size_t vm_size;
@@ -552,7 +565,8 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 
 	/* Reclaim guest pages (including page-table pages) */
-	reclaim_guest_pages(hyp_vm);
+	mc = &hyp_vm->host_kvm->arch.pkvm.teardown_mc;
+	reclaim_guest_pages(hyp_vm, mc);
 	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->nr_vcpus);
 
 	/* Push the metadata pages to the teardown memcache */
@@ -561,11 +575,11 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
 		struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
 
-		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
+		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
 	}
 
 	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
-	unmap_donated_memory(hyp_vm, vm_size);
+	teardown_donated_memory(mc, hyp_vm, vm_size);
 	return 0;
 
 err_unlock:
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8c443b915e43..cf56958b1492 100644
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
2.38.0.413.g74048e4d9e-goog

