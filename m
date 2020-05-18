Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28AD1D716E
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 09:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgERHBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 03:01:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44677 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgERHBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 03:01:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id 50so10373191wrc.11;
        Mon, 18 May 2020 00:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3ktmgsg3xha6B5GpCBnFJna4pj320XLto2kPDS1ikDE=;
        b=T2QKurqI5XFIrsECec6cxzMEg3mZffhA/rx6kUo9fzSuheKC/Mj9XgMqnBhpI7CP9Y
         W2mp154lRiH6B12MPwd1ihcqwU+oFKMrAR2cxAo1VEwsIH+k82Fj/jUyVy/ovZa+VeCo
         P2SyI/NuvlwdJ0OOFkegCNuqAWtDG5nYGAvaM7ZvkBuRDJiDbkCd3B/bGysyYn4amVjl
         /gEkfiXOvVeyy8enhKJ3MnZOG5eH4ylr4kdl0e7oLwCtPqB6hx2G4LJbreNlex08DS4Y
         C3z9uBj22IbbNZyeGPfSB9Qw0F90C451LLRmWc/V+2T1Mu4ex4S1cyVr4mSz9xJVzV6T
         Jr/A==
X-Gm-Message-State: AOAM532ISmvD17cER4AI3mIY1Zn/jgMre2TA2HcejVb9X471YYSlZkDW
        ObTEuIc0N38lKnOl+W6SwnU=
X-Google-Smtp-Source: ABdhPJwBZQmTLzFsw3b2/RzAQB0Mx8mNx5PVWc79zHrUBFr79ME2FpxDJKCgCbecZP7DaH6ZCTJwig==
X-Received: by 2002:a5d:5751:: with SMTP id q17mr18353783wrw.106.1589785269150;
        Mon, 18 May 2020 00:01:09 -0700 (PDT)
Received: from bf.nubificus.co.uk ([2a02:587:b919:800:aaa1:59ff:fe09:f176])
        by smtp.gmail.com with ESMTPSA id 77sm15918421wrc.6.2020.05.18.00.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 00:01:08 -0700 (PDT)
Date:   Mon, 18 May 2020 10:01:07 +0300
From:   Anastassios Nanos <ananos@nubificus.co.uk>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] KVMM: Memory and interface related changes
Message-ID: <63cf223058e7963891dcfb8cf0c5ccfe31548712.1589784221.git.ananos@nubificus.co.uk>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1589784221.git.ananos@nubificus.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To run KVMM guests, we need to extend the KVM memory subsystem
to support kernel-allocated memory. To do this, we allow "vmalloced"
space to be used as KVM guest addresses.

Additionally, since current->mm is NULL when being in the Kernel, in
the context of kthreads, we check whether mm refers to a kthread or
a userspace process, and proceed accordingly.

Finally, when pages need to be pinned (when get_user_pages is used),
we just return the vmalloc_to_page result, instead of going through
get_user_pages and returning the relevant pfn.

Signed-off-by: Anastassios Nanos <ananos@nubificus.co.uk>
Signed-off-by: Konstantinos Papazafeiropoulos <kostis@nubificus.co.uk>
Signed-off-by: Charalampos Mainas <cmainas@nubificus.co.uk>
Signed-off-by: Stratos Psomadakis <psomas@nubificus.co.uk>
---
 arch/arm64/kvm/fpsimd.c             |  2 +-
 arch/x86/include/asm/fpu/internal.h | 10 ++-
 arch/x86/kvm/emulate.c              |  3 +-
 arch/x86/kvm/vmx/vmx.c              |  3 +-
 arch/x86/kvm/x86.c                  |  7 ++-
 include/linux/kvm_host.h            | 12 ++++
 virt/kvm/arm/mmu.c                  | 34 ++++++----
 virt/kvm/async_pf.c                 |  4 +-
 virt/kvm/kvm_main.c                 | 97 ++++++++++++++++++++++-------
 9 files changed, 129 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 274f8c47b22c..411c9ae1f12a 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -66,7 +66,7 @@ EXPORT_SYMBOL(kvmm_kvm_arch_vcpu_run_map_fp);
  */
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
-	BUG_ON(!current->mm);
+	BUG_ON(!(vcpu->kvm->is_kvmm_vm ? current->active_mm : current->mm));
 
 	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
 			      KVM_ARM64_HOST_SVE_IN_USE |
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 44c48e34d799..f9e70df3b268 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -536,7 +536,8 @@ static inline void __fpregs_load_activate(void)
 	struct fpu *fpu = &current->thread.fpu;
 	int cpu = smp_processor_id();
 
-	if (WARN_ON_ONCE(current->flags & PF_KTHREAD))
+	/* don't do anything if we're in the kernel */
+	if (current->flags & PF_KTHREAD)
 		return;
 
 	if (!fpregs_state_valid(fpu, cpu)) {
@@ -571,7 +572,8 @@ static inline void __fpregs_load_activate(void)
  */
 static inline void switch_fpu_prepare(struct fpu *old_fpu, int cpu)
 {
-	if (static_cpu_has(X86_FEATURE_FPU) && !(current->flags & PF_KTHREAD)) {
+	if (static_cpu_has(X86_FEATURE_FPU) &&
+	    !(current->flags & PF_KTHREAD)) {
 		if (!copy_fpregs_to_fpstate(old_fpu))
 			old_fpu->last_cpu = -1;
 		else
@@ -598,6 +600,10 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 	if (!static_cpu_has(X86_FEATURE_FPU))
 		return;
 
+	/* don't do anything if we're in the kernel */
+	if (current->flags & PF_KTHREAD)
+		return;
+
 	set_thread_flag(TIF_NEED_FPU_LOAD);
 
 	if (!cpu_feature_enabled(X86_FEATURE_OSPKE))
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index bddaba9c68dd..0f6bc2404d0d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1086,7 +1086,8 @@ static void emulator_get_fpu(void)
 	fpregs_lock();
 
 	fpregs_assert_state_consistent();
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+	if (test_thread_flag(TIF_NEED_FPU_LOAD) &&
+	    !(current->flags & PF_KTHREAD))
 		switch_fpu_return();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 83050977490c..2e34cf5829f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1166,7 +1166,8 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	savesegment(es, host_state->es_sel);
 
 	gs_base = cpu_kernelmode_gs_base(cpu);
-	if (likely(is_64bit_mm(current->mm))) {
+	if (likely(is_64bit_mm(vcpu->kvm->is_kvmm_vm ?
+	    current->active_mm : current->mm))) {
 		save_fsgs_for_kvm();
 		fs_sel = current->thread.fsindex;
 		gs_sel = current->thread.gsindex;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4039402aa7d..42451faa6c0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8390,7 +8390,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	guest_enter_irqoff();
 
 	fpregs_assert_state_consistent();
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+	if (test_thread_flag(TIF_NEED_FPU_LOAD) &&
+	    !(current->flags & PF_KTHREAD))
 		switch_fpu_return();
 
 	if (unlikely(vcpu->arch.switch_db_regs)) {
@@ -9903,11 +9904,13 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	if (current->mm == kvm->mm) {
+	if (current->mm == kvm->mm || kvm->is_kvmm_vm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
 		 * unless the the memory map has changed due to process exit
 		 * or fd copying.
+		 * In case it is a kvmm VM, then we need to invalidate the
+		 * regions allocated.
 		 */
 		mutex_lock(&kvm->slots_lock);
 		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 794b97c4ddf9..c4d23bbfff60 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -121,8 +121,19 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
 #define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
 #define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
 
+static inline bool kvmm_valid_addr(unsigned long addr)
+{
+	if (is_vmalloc_addr((void *)addr))
+		return true;
+	else
+		return false;
+}
+
 static inline bool kvm_is_error_hva(unsigned long addr)
 {
+	if (kvmm_valid_addr(addr))
+		return 0;
+
 	return addr >= PAGE_OFFSET;
 }
 
@@ -503,6 +514,7 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	bool is_kvmm_vm;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index e3b9ee268823..c53f3b4b1b28 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -926,6 +926,8 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = PAGE_SIZE * memslot->npages;
 	hva_t reg_end = hva + size;
+	struct mm_struct *mm = kvm->is_kvmm_vm ?
+				current->active_mm : current->mm;
 
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
@@ -940,7 +942,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 	 *     +--------------------------------------------+
 	 */
 	do {
-		struct vm_area_struct *vma = find_vma(current->mm, hva);
+		struct vm_area_struct *vma = find_vma(mm, hva);
 		hva_t vm_start, vm_end;
 
 		if (!vma || vma->vm_start >= reg_end)
@@ -972,9 +974,11 @@ void stage2_unmap_vm(struct kvm *kvm)
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	int idx;
+	struct mm_struct *mm = kvm->is_kvmm_vm ?
+				current->active_mm : current->mm;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	down_read(&current->mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	spin_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
@@ -982,7 +986,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 		stage2_unmap_memslot(kvm, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -1673,6 +1677,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	pgprot_t mem_type = PAGE_S2;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long vma_pagesize, flags = 0;
+	struct mm_struct *mm = kvm->is_kvmm_vm ?
+				current->active_mm : current->mm;
 
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
@@ -1684,15 +1690,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	/* Let's check if we will get back a huge page backed by hugetlbfs */
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma_intersection(current->mm, hva, hva + 1);
-	if (unlikely(!vma)) {
+	down_read(&mm->mmap_sem);
+	vma = find_vma_intersection(mm, hva, hva + 1);
+	/* vma is invalid for a KVMM guest */
+	if (unlikely(!vma) && !kvm->is_kvmm_vm) {
 		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
-		up_read(&current->mm->mmap_sem);
+		up_read(&mm->mmap_sem);
 		return -EFAULT;
 	}
 
-	if (is_vm_hugetlb_page(vma))
+	/* FIXME: not sure how to handle hugetlb in KVMM, skip for now */
+	if (is_vm_hugetlb_page(vma) && !kvm->is_kvmm_vm)
 		vma_shift = huge_page_shift(hstate_vma(vma));
 	else
 		vma_shift = PAGE_SHIFT;
@@ -1715,7 +1723,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (vma_pagesize == PMD_SIZE ||
 	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 
 	/* We need minimum second+third level pages */
 	ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
@@ -2278,6 +2286,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t reg_end = hva + mem->memory_size;
 	bool writable = !(mem->flags & KVM_MEM_READONLY);
 	int ret = 0;
+	struct mm_struct *mm = kvm->is_kvmm_vm ?
+				current->active_mm : current->mm;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
@@ -2291,7 +2301,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	    (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
-	down_read(&current->mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
 	 * between them, so iterate over all of them to find out if we can map
@@ -2305,7 +2315,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 *     +--------------------------------------------+
 	 */
 	do {
-		struct vm_area_struct *vma = find_vma(current->mm, hva);
+		struct vm_area_struct *vma = find_vma(mm, hva);
 		hva_t vm_start, vm_end;
 
 		if (!vma || vma->vm_start >= reg_end)
@@ -2350,7 +2360,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		stage2_flush_memslot(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	return ret;
 }
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 15e5b037f92d..d0b23e1afb87 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -175,7 +175,9 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	work->cr2_or_gpa = cr2_or_gpa;
 	work->addr = hva;
 	work->arch = *arch;
-	work->mm = current->mm;
+	/* if we're a KVMM VM, then current->mm is null */
+	work->mm = work->vcpu->kvm->is_kvmm_vm ?
+			current->active_mm : current->mm;
 	mmget(work->mm);
 	kvm_get_kvm(work->vcpu->kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dcbecc2ab370..5e1929f7f282 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -541,6 +541,9 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 
 static int kvm_init_mmu_notifier(struct kvm *kvm)
 {
+	/* FIXME: ignore mmu_notifiers for KVMM guests, for now */
+	if (kvm->is_kvmm_vm)
+		return 0;
 	kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
 	return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
 }
@@ -672,13 +675,22 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	struct kvm *kvm = kvm_arch_alloc_vm();
 	int r = -ENOMEM;
 	int i;
+	/* if we're a KVMM guest, then current->mm is NULL */
+	struct mm_struct *mm = (type == 1) ? current->active_mm : current->mm;
 
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
+	if (type == 1) {
+		kvm->is_kvmm_vm = true;
+		type = 0;
+	} else {
+		kvm->is_kvmm_vm = false;
+	}
+
 	spin_lock_init(&kvm->mmu_lock);
-	mmgrab(current->mm);
-	kvm->mm = current->mm;
+	mmgrab(mm);
+	kvm->mm = mm;
 	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
@@ -741,7 +753,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 out_err:
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	if (kvm->mmu_notifier.ops)
-		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
+		mmu_notifier_unregister(&kvm->mmu_notifier, mm);
 #endif
 out_err_no_mmu_notifier:
 	hardware_disable_all();
@@ -758,7 +770,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	cleanup_srcu_struct(&kvm->srcu);
 out_err_no_srcu:
 	kvm_arch_free_vm(kvm);
-	mmdrop(current->mm);
+	mmdrop(mm);
 	return ERR_PTR(r);
 }
 struct kvm *kvmm_kvm_create_vm(unsigned long type)
@@ -1228,8 +1240,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* We can read the guest memory with __xxx_user() later on. */
 	if ((id < KVM_USER_MEM_SLOTS) &&
 	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
-	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
-			mem->memory_size)))
+	     !(access_ok((void __user *)(unsigned long)mem->userspace_addr,
+			mem->memory_size) || kvm->is_kvmm_vm)))
 		return -EINVAL;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
 		return -EINVAL;
@@ -1484,7 +1496,6 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	return 0;
 }
 
-
 /**
  * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
  * @kvm: kvm instance
@@ -1636,6 +1647,8 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	struct vm_area_struct *vma;
 	unsigned long addr, size;
+	struct mm_struct *mm = vcpu->kvm->is_kvmm_vm ?
+				current->active_mm : current->mm;
 
 	size = PAGE_SIZE;
 
@@ -1643,15 +1656,15 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 	if (kvm_is_error_hva(addr))
 		return PAGE_SIZE;
 
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, addr);
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, addr);
 	if (!vma)
 		goto out;
 
 	size = vma_kernel_pagesize(vma);
 
 out:
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 
 	return size;
 }
@@ -1760,8 +1773,12 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 	 */
 	if (!(write_fault || writable))
 		return false;
-
-	npages = __get_user_pages_fast(addr, 1, 1, page);
+	if (kvmm_valid_addr(addr)) {
+		npages = 1;
+		page[0] = vmalloc_to_page((void *)addr);
+	} else {
+		npages = __get_user_pages_fast(addr, 1, 1, page);
+	}
 	if (npages == 1) {
 		*pfn = page_to_pfn(page[0]);
 
@@ -1794,15 +1811,28 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 	if (async)
 		flags |= FOLL_NOWAIT;
 
-	npages = get_user_pages_unlocked(addr, 1, &page, flags);
+	if (kvmm_valid_addr(addr)) {
+		npages = 1;
+		page = vmalloc_to_page((void *)addr);
+	} else {
+		npages = get_user_pages_unlocked(addr, 1, &page, flags);
+	}
 	if (npages != 1)
 		return npages;
 
 	/* map read fault as writable if possible */
 	if (unlikely(!write_fault) && writable) {
 		struct page *wpage;
+		int lnpages = 0;
+
+		if (kvmm_valid_addr(addr)) {
+			npages_local = 1;
+			wpage = vmalloc_to_page((void *)addr);
+		} else {
+			lnpages = __get_user_pages_fast(addr, 1, 1, &wpage);
+		}
 
-		if (__get_user_pages_fast(addr, 1, 1, &wpage) == 1) {
+		if (lnpages == 1) {
 			*writable = true;
 			put_page(page);
 			page = wpage;
@@ -1830,6 +1860,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 {
 	unsigned long pfn;
 	int r;
+	struct mm_struct *mm = kvmm_valid_addr(addr) ?
+				current->active_mm : current->mm;
 
 	r = follow_pfn(vma, addr, &pfn);
 	if (r) {
@@ -1838,7 +1870,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		 * not call the fault handler, so do it here.
 		 */
 		bool unlocked = false;
-		r = fixup_user_fault(current, current->mm, addr,
+		r = fixup_user_fault(current, mm, addr,
 				     (write_fault ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
 		if (unlocked)
@@ -1892,6 +1924,8 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn = 0;
 	int npages, r;
+	struct mm_struct *mm = kvmm_valid_addr(addr) ?
+				current->active_mm : current->mm;
 
 	/* we can do it either atomically or asynchronously, not both */
 	BUG_ON(atomic && async);
@@ -1906,7 +1940,7 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (npages == 1)
 		return pfn;
 
-	down_read(&current->mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	if (npages == -EHWPOISON ||
 	      (!async && check_user_page_hwpoison(addr))) {
 		pfn = KVM_PFN_ERR_HWPOISON;
@@ -1914,7 +1948,7 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	}
 
 retry:
-	vma = find_vma_intersection(current->mm, addr, addr + 1);
+	vma = find_vma_intersection(mm, addr, addr + 1);
 
 	if (vma == NULL)
 		pfn = KVM_PFN_ERR_FAULT;
@@ -1930,7 +1964,7 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 		pfn = KVM_PFN_ERR_FAULT;
 	}
 exit:
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	return pfn;
 }
 
@@ -2208,6 +2242,9 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
+	/* rely on the fact that we're in the kernel */
+	if (current->flags & PF_KTHREAD)
+		return;
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
 		put_page(pfn_to_page(pfn));
 }
@@ -2244,6 +2281,9 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 
 void kvm_get_pfn(kvm_pfn_t pfn)
 {
+	/* rely on the fact that we're in the kernel */
+	if (current->flags & PF_KTHREAD)
+		return;
 	if (!kvm_is_reserved_pfn(pfn))
 		get_page(pfn_to_page(pfn));
 }
@@ -3120,8 +3160,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	int r;
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
+	struct mm_struct *mm = vcpu->kvm->is_kvmm_vm ?
+				current->active_mm : current->mm;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != mm)
 		return -EIO;
 
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
@@ -3327,9 +3369,12 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = compat_ptr(arg);
 	int r;
+	struct mm_struct *mm = vcpu->kvm->is_kvmm_vm ?
+				       current->active_mm : current->mm;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != mm) {
 		return -EIO;
+	}
 
 	switch (ioctl) {
 	case KVM_SET_SIGNAL_MASK: {
@@ -3392,8 +3437,10 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
 			     unsigned long arg)
 {
 	struct kvm_device *dev = filp->private_data;
+	struct mm_struct *mm = dev->kvm->is_kvmm_vm ?
+				       current->active_mm : current->mm;
 
-	if (dev->kvm->mm != current->mm)
+	if (dev->kvm->mm != mm)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3600,8 +3647,10 @@ static long kvm_vm_ioctl(struct file *filp,
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r;
+	struct mm_struct *mm = kvm->is_kvmm_vm ?
+				       current->active_mm : current->mm;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != mm)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
@@ -3797,9 +3846,11 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
+	struct mm_struct *mm = kvm->is_kvmm_vm ?
+				       current->active_mm : current->mm;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != mm)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_GET_DIRTY_LOG: {
-- 
2.20.1

