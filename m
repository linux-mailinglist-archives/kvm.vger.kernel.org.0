Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750F852D4BB
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiESNqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239056AbiESNpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2014FDE309
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F8E5B824AE
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43C8C385B8;
        Thu, 19 May 2022 13:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967876;
        bh=BDsaJNcPZTWeO0VnJ4T5Va/FaalzBuQkFu3ATLCjLco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbM6rpmYqcnCRss5TQv/BCu+sWUvflrdeDDHwGR0o/i7tITs6eBASUeh7xm65GmbR
         aBgz7kJYYshNGhnEX/mrfXO/+0+6ltmaZmvQR1jJ4w2RDCA4kniOoaBdgoURpgsmjn
         4LgXuZsaST/lh6WV3FbVwftgz16126A/s64CtSPNzhL75U1B1BYeqxnbV2NiH/xXmy
         tuUMCm2ybziZ/vPeZERGy01QeuLRCwKcnI5pk1F6U36NHc0rkKzZjPyoexre0U3xF/
         BfsBq948TyVBI0hUuOqHcA+HmPiH3h1v8EPnh3Y8YnEJRv3y00pF/uHPMJbY7AU45g
         dQbaaKpS2lu1A==
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
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 33/89] KVM: arm64: Handle guest stage-2 page-tables entirely at EL2
Date:   Thu, 19 May 2022 14:41:08 +0100
Message-Id: <20220519134204.5379-34-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that EL2 is able to manage guest stage-2 page-tables, avoid
allocating a separate MMU structure in the host and instead introduce a
new fault handler which responds to guest stage-2 faults by sharing
GUP-pinned pages with the guest via a hypercall. These pages are
recovered (and unpinned) on guest teardown via the page reclaim
hypercall.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   |   1 +
 arch/arm64/include/asm/kvm_host.h  |   6 ++
 arch/arm64/kvm/arm.c               |  10 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  49 ++++++++++-
 arch/arm64/kvm/mmu.c               | 137 +++++++++++++++++++++++++++--
 arch/arm64/kvm/pkvm.c              |  17 ++++
 6 files changed, 212 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a68381699c40..931a351da3f2 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -65,6 +65,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_reclaim_page,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_map_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3c6ed1f3887d..9252841850e4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -158,10 +158,16 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_pinned_page {
+	struct list_head	link;
+	struct page		*page;
+};
+
 struct kvm_protected_vm {
 	unsigned int shadow_handle;
 	struct mutex shadow_lock;
 	struct kvm_hyp_memcache teardown_mc;
+	struct list_head pinned_pages;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 694ba3792e9d..5b41551a978b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -358,7 +358,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	if (is_protected_kvm_enabled())
+		free_hyp_memcache(&vcpu->arch.pkvm_memcache);
+	else
+		kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
 
@@ -385,6 +389,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
+	if (is_protected_kvm_enabled())
+		goto nommu;
+
 	mmu = vcpu->arch.hw_mmu;
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
@@ -402,6 +409,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		*last_ran = vcpu->vcpu_id;
 	}
 
+nommu:
 	vcpu->cpu = cpu;
 
 	kvm_vgic_load(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7a0d95e28e00..245d267064b3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -32,8 +32,6 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 	shadow_vcpu->arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
 	shadow_vcpu->arch.sve_max_vl	= host_vcpu->arch.sve_max_vl;
 
-	shadow_vcpu->arch.hw_mmu	= host_vcpu->arch.hw_mmu;
-
 	shadow_vcpu->arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	shadow_vcpu->arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	shadow_vcpu->arch.cptr_el2	= host_vcpu->arch.cptr_el2;
@@ -107,6 +105,52 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+static int pkvm_refill_memcache(struct kvm_vcpu *shadow_vcpu,
+				struct kvm_vcpu *host_vcpu)
+{
+	struct kvm_shadow_vcpu_state *shadow_vcpu_state = get_shadow_state(shadow_vcpu);
+	u64 nr_pages = VTCR_EL2_LVLS(shadow_vcpu_state->shadow_vm->kvm.arch.vtcr) - 1;
+
+	return refill_memcache(&shadow_vcpu->arch.pkvm_memcache, nr_pages,
+			       &host_vcpu->arch.pkvm_memcache);
+}
+
+static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, pfn, host_ctxt, 1);
+	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 3);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *shadow_vcpu;
+	struct kvm *host_kvm;
+	unsigned int handle;
+	int ret = -EINVAL;
+
+	if (!is_protected_kvm_enabled())
+		goto out;
+
+	host_vcpu = kern_hyp_va(host_vcpu);
+	host_kvm = kern_hyp_va(host_vcpu->kvm);
+	handle = host_kvm->arch.pkvm.shadow_handle;
+	shadow_state = pkvm_load_shadow_vcpu_state(handle, host_vcpu->vcpu_idx);
+	if (!shadow_state)
+		goto out;
+
+	host_vcpu = shadow_state->host_vcpu;
+	shadow_vcpu = &shadow_state->shadow_vcpu;
+
+	/* Topup shadow memcache with the host's */
+	ret = pkvm_refill_memcache(shadow_vcpu, host_vcpu);
+	if (ret)
+		goto out_put_state;
+
+	ret = __pkvm_host_share_guest(pfn, gfn, shadow_vcpu);
+out_put_state:
+	pkvm_put_shadow_vcpu_state(shadow_state);
+out:
+	cpu_reg(host_ctxt, 1) =  ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -297,6 +341,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
 	HANDLE_FUNC(__pkvm_host_reclaim_page),
+	HANDLE_FUNC(__pkvm_host_map_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index df92b5f7ac63..c74c431588a3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -190,6 +190,22 @@ static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 si
 	__unmap_stage2_range(mmu, start, size, true);
 }
 
+static void pkvm_stage2_flush(struct kvm *kvm)
+{
+	struct kvm_pinned_page *ppage;
+
+	/*
+	 * Contrary to stage2_apply_range(), we don't need to check
+	 * whether the VM is being torn down, as this is always called
+	 * from a vcpu thread, and the list is only ever freed on VM
+	 * destroy (which only occurs when all vcpu are gone).
+	 */
+	list_for_each_entry(ppage, &kvm->arch.pkvm.pinned_pages, link) {
+		__clean_dcache_guest_page(page_address(ppage->page), PAGE_SIZE);
+		cond_resched_rwlock_write(&kvm->mmu_lock);
+	}
+}
+
 static void stage2_flush_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
@@ -215,9 +231,13 @@ static void stage2_flush_vm(struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 	write_lock(&kvm->mmu_lock);
 
-	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, bkt, slots)
-		stage2_flush_memslot(kvm, memslot);
+	if (!is_protected_kvm_enabled()) {
+		slots = kvm_memslots(kvm);
+		kvm_for_each_memslot(memslot, bkt, slots)
+			stage2_flush_memslot(kvm, memslot);
+	} else if (!kvm_vm_is_protected(kvm)) {
+		pkvm_stage2_flush(kvm);
+	}
 
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -636,7 +656,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 		return -EINVAL;
 
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
-	if (phys_shift) {
+	if (is_protected_kvm_enabled()) {
+		phys_shift = kvm_ipa_limit;
+	} else if (phys_shift) {
 		if (phys_shift > kvm_ipa_limit ||
 		    phys_shift < ARM64_MIN_PARANGE_BITS)
 			return -EINVAL;
@@ -652,6 +674,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
+	INIT_LIST_HEAD(&kvm->arch.pkvm.pinned_pages);
+	mmu->arch = &kvm->arch;
+
+	if (is_protected_kvm_enabled())
+		return 0;
 
 	if (mmu->pgt != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
@@ -760,6 +787,9 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
 
+	if (is_protected_kvm_enabled())
+		return;
+
 	write_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
 	if (pgt) {
@@ -1113,6 +1143,99 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	return 0;
 }
 
+static int pkvm_host_map_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu)
+{
+	int ret = kvm_call_hyp_nvhe(__pkvm_host_map_guest, pfn, gfn, vcpu);
+
+	/*
+	 * Getting -EPERM at this point implies that the pfn has already been
+	 * mapped. This should only ever happen when two vCPUs faulted on the
+	 * same page, and the current one lost the race to do the mapping.
+	 */
+	return (ret == -EPERM) ? -EAGAIN : ret;
+}
+
+static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			  unsigned long hva)
+{
+	struct kvm_hyp_memcache *hyp_memcache = &vcpu->arch.pkvm_memcache;
+	struct mm_struct *mm = current->mm;
+	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
+	struct kvm_pinned_page *ppage;
+	struct kvm *kvm = vcpu->kvm;
+	struct page *page;
+	u64 pfn;
+	int ret;
+
+	ret = topup_hyp_memcache(hyp_memcache, kvm_mmu_cache_min_pages(kvm));
+	if (ret)
+		return -ENOMEM;
+
+	ppage = kmalloc(sizeof(*ppage), GFP_KERNEL_ACCOUNT);
+	if (!ppage)
+		return -ENOMEM;
+
+	ret = account_locked_vm(mm, 1, true);
+	if (ret)
+		goto free_ppage;
+
+	mmap_read_lock(mm);
+	ret = pin_user_pages(hva, 1, flags, &page, NULL);
+	mmap_read_unlock(mm);
+
+	if (ret == -EHWPOISON) {
+		kvm_send_hwpoison_signal(hva, PAGE_SHIFT);
+		ret = 0;
+		goto dec_account;
+	} else if (ret != 1) {
+		ret = -EFAULT;
+		goto dec_account;
+	} else if (!PageSwapBacked(page)) {
+		/*
+		 * We really can't deal with page-cache pages returned by GUP
+		 * because (a) we may trigger writeback of a page for which we
+		 * no longer have access and (b) page_mkclean() won't find the
+		 * stage-2 mapping in the rmap so we can get out-of-whack with
+		 * the filesystem when marking the page dirty during unpinning
+		 * (see cc5095747edf ("ext4: don't BUG if someone dirty pages
+		 * without asking ext4 first")).
+		 *
+		 * Ideally we'd just restrict ourselves to anonymous pages, but
+		 * we also want to allow memfd (i.e. shmem) pages, so check for
+		 * pages backed by swap in the knowledge that the GUP pin will
+		 * prevent try_to_unmap() from succeeding.
+		 */
+		ret = -EIO;
+		goto dec_account;
+	}
+
+	write_lock(&kvm->mmu_lock);
+	pfn = page_to_pfn(page);
+	ret = pkvm_host_map_guest(pfn, fault_ipa >> PAGE_SHIFT, vcpu);
+	if (ret) {
+		if (ret == -EAGAIN)
+			ret = 0;
+		goto unpin;
+	}
+
+	ppage->page = page;
+	INIT_LIST_HEAD(&ppage->link);
+	list_add(&ppage->link, &kvm->arch.pkvm.pinned_pages);
+	write_unlock(&kvm->mmu_lock);
+
+	return 0;
+
+unpin:
+	write_unlock(&kvm->mmu_lock);
+	unpin_user_pages(&page, 1);
+dec_account:
+	account_locked_vm(mm, 1, false);
+free_ppage:
+	kfree(ppage);
+
+	return ret;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1470,7 +1593,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
+	if (is_protected_kvm_enabled())
+		ret = pkvm_mem_abort(vcpu, fault_ipa, hva);
+	else
+		ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
+
 	if (ret == 0)
 		ret = 1;
 out:
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b174d6dfde36..40e5490ef453 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/memblock.h>
+#include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/sort.h>
 
@@ -183,12 +184,28 @@ int kvm_shadow_create(struct kvm *kvm)
 
 void kvm_shadow_destroy(struct kvm *kvm)
 {
+	struct kvm_pinned_page *ppage, *tmp;
+	struct mm_struct *mm = current->mm;
+	struct list_head *ppages;
+
 	if (kvm->arch.pkvm.shadow_handle)
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_shadow,
 					  kvm->arch.pkvm.shadow_handle));
 
 	kvm->arch.pkvm.shadow_handle = 0;
 	free_hyp_memcache(&kvm->arch.pkvm.teardown_mc);
+
+	ppages = &kvm->arch.pkvm.pinned_pages;
+	list_for_each_entry_safe(ppage, tmp, ppages, link) {
+		WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_reclaim_page,
+					  page_to_pfn(ppage->page)));
+		cond_resched();
+
+		account_locked_vm(mm, 1, false);
+		unpin_user_pages_dirty_lock(&ppage->page, 1, true);
+		list_del(&ppage->link);
+		kfree(ppage);
+	}
 }
 
 int kvm_init_pvm(struct kvm *kvm)
-- 
2.36.1.124.g0e6072fb45-goog

