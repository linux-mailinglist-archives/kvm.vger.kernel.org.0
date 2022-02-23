Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162654C0C18
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238505AbiBWF1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbiBWF0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:49 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095BB6D19B
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:10 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e129-20020a25d387000000b006245d830ca6so12324499ybf.13
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vfUNGUzwKPwc6P8NLNU+G63bl3V3MlYghQJcmtOSBSE=;
        b=C/GDnUFZL4LltMsvS5FMOZ/XDx/Be18sR4fVDAdJWkBYRmDcKo9NUb1We9xS3LmtRX
         yqMgXlP8N7xZF8Ux9+U55HvDcm/rY0cp41ABtNZNYkR8wwwnlp5Tc/Z+WHg/tqCClya8
         drGn7Okq0DGr0wllM266iYWMJ6XzagvRVWp/SuheBkEQDwBl5n0u5tK2RWK5glZ9ZfVv
         eEvwT9dopjeCYjYsqzOL8esps1cNs0pAqvlGBd0CeJIX0vdenIhUxI0GrChVSsd4iQJA
         j46UlOr9zWrPPZy9HcKzVHRGC9BZ83U6lLLZDxYZVj1AeRVrqyWEuBaLgII5jGj/PpWl
         RKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vfUNGUzwKPwc6P8NLNU+G63bl3V3MlYghQJcmtOSBSE=;
        b=qNj/b5WdTsA/gaTIOCt19vcjRTIOXfNx0qHhTxvazPiTo2F5sPtxouZ6HQWmelDnkX
         Juzu/tUc24IbDfllfwv0/y6GdRVqqrEN44cDFEBVmiwMTXB//NumsdpahXVrj8g9Ucut
         rVxrOGTikHJBAL7K6lARuEIOWDMnRwrlht4oh8UFT0+hnHCjud50arn1bwQG8srzRIfg
         RNcMjzxYigjyPa2t7nnLPzTmXdUwuRPSYC7tag3LpdXcioA7fjdJC2OVNx83QBmP7+qd
         YP46UVYiOEjHZh61oREzXZTTmLajBd950ZRc1QP8qnF5dx1T93XU7TzAWeq4qtTa5cjC
         6UGg==
X-Gm-Message-State: AOAM5305ZlyD9dW/pKzFPee2b5bl/Tsb8BBpntkqQ1r5diOEXF1BseSx
        axg6u13wtMwP3OKNErn5Kc7O9BQXPMn7
X-Google-Smtp-Source: ABdhPJzDIIPPMetTAHkgCVvjLqBOhwyQ9fOAQZEm98thqfQ3nuARy106JiYU5crLZ1jrdqAZ9ScyawbA4X0V
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:945:0:b0:2ca:287c:6cf3 with SMTP id
 66-20020a810945000000b002ca287c6cf3mr26007076ywj.408.1645593899054; Tue, 22
 Feb 2022 21:24:59 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:09 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-34-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 33/47] kvm: asi: Map guest memory into restricted ASI
 address space
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A module parameter treat_all_userspace_as_nonsensitive is added,
which if set, maps the entire userspace of the process running the VM
into the ASI restricted address space.

If the flag is not set (the default), then just the userspace memory
mapped into the VM's address space is mapped into the ASI restricted
address space.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              |  6 ++++
 arch/x86/kvm/mmu/mmu.c          | 54 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h  | 14 +++++++++
 arch/x86/kvm/x86.c              | 19 +++++++++++-
 include/linux/kvm_host.h        |  3 ++
 virt/kvm/kvm_main.c             |  7 +++++
 7 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 98cbd6447e3e..e63a2f244d7b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -681,6 +681,8 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
+	struct asi_pgtbl_pool asi_pgtbl_pool;
+
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
 	 * In vcpu_run, we switch between the user and guest FPU contexts.
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9ae6168d381e..60b84331007d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -49,6 +49,12 @@
 
 #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+extern bool treat_all_userspace_as_nonsensitive;
+#else
+#define treat_all_userspace_as_nonsensitive true
+#endif
+
 static __always_inline u64 rsvd_bits(int s, int e)
 {
 	BUILD_BUG_ON(__builtin_constant_p(e) && __builtin_constant_p(s) && e < s);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fcdf3f8bb59a..485c0ba3ce8b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -91,6 +91,11 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
 static bool __read_mostly force_flush_and_sync_on_reuse;
 module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+bool __ro_after_init treat_all_userspace_as_nonsensitive;
+module_param(treat_all_userspace_as_nonsensitive, bool, 0444);
+#endif
+
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
  * where the hardware walks 2 page tables:
@@ -2757,6 +2762,21 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	return ret;
 }
 
+static void asi_map_gfn_range(struct kvm_vcpu *vcpu,
+			      struct kvm_memory_slot *slot,
+			      gfn_t gfn, size_t npages)
+{
+	int err;
+	size_t hva = __gfn_to_hva_memslot(slot, gfn);
+
+	err = asi_map_user(vcpu->kvm->asi, (void *)hva, PAGE_SIZE * npages,
+			   &vcpu->arch.asi_pgtbl_pool, slot->userspace_addr,
+			   slot->userspace_addr + slot->npages * PAGE_SIZE);
+	if (err)
+		kvm_err("asi_map_user for %lx-%lx failed with code %d", hva,
+			hva + PAGE_SIZE * npages, err);
+}
+
 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp,
 				    u64 *start, u64 *end)
@@ -2776,6 +2796,9 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	if (ret <= 0)
 		return -1;
 
+	if (!treat_all_userspace_as_nonsensitive)
+		asi_map_gfn_range(vcpu, slot, gfn, ret);
+
 	for (i = 0; i < ret; i++, gfn++, start++) {
 		mmu_set_spte(vcpu, slot, start, access, gfn,
 			     page_to_pfn(pages[i]), NULL);
@@ -3980,6 +4003,15 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	return true;
 }
 
+static void vcpu_fill_asi_pgtbl_pool(struct kvm_vcpu *vcpu)
+{
+	int err = asi_fill_pgtbl_pool(&vcpu->arch.asi_pgtbl_pool,
+				      CONFIG_PGTABLE_LEVELS - 1, GFP_KERNEL);
+
+	if (err)
+		kvm_err("asi_fill_pgtbl_pool failed with code %d", err);
+}
+
 /*
  * Returns true if the page fault is stale and needs to be retried, i.e. if the
  * root was invalidated by a memslot update or a relevant mmu_notifier fired.
@@ -4013,6 +4045,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 
 	unsigned long mmu_seq;
+	bool try_asi_map;
 	int r;
 
 	fault->gfn = fault->addr >> PAGE_SHIFT;
@@ -4038,6 +4071,12 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (handle_abnormal_pfn(vcpu, fault, ACC_ALL, &r))
 		return r;
 
+	try_asi_map = !treat_all_userspace_as_nonsensitive &&
+		      !is_noslot_pfn(fault->pfn);
+
+	if (try_asi_map)
+		vcpu_fill_asi_pgtbl_pool(vcpu);
+
 	r = RET_PF_RETRY;
 
 	if (is_tdp_mmu_fault)
@@ -4052,6 +4091,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		goto out_unlock;
 
+	if (try_asi_map)
+		asi_map_gfn_range(vcpu, fault->slot, fault->gfn, 1);
+
 	if (is_tdp_mmu_fault)
 		r = kvm_tdp_mmu_map(vcpu, fault);
 	else
@@ -5584,6 +5626,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;
 
+	asi_init_pgtbl_pool(&vcpu->arch.asi_pgtbl_pool);
+
 	ret = __kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
 	if (ret)
 		return ret;
@@ -5713,6 +5757,15 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
+	/*
+	 * Currently, we just zap the entire address range, instead of only the
+	 * memslot. So we also just asi_unmap the entire userspace. But in the
+	 * future, if we zap only the range belonging to the memslot, then we
+	 * should also asi_unmap only that range.
+	 */
+	if (!treat_all_userspace_as_nonsensitive)
+		asi_unmap_user(kvm->asi, 0, TASK_SIZE_MAX);
+
 	kvm_mmu_zap_all_fast(kvm);
 }
 
@@ -6194,6 +6247,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
+	asi_clear_pgtbl_pool(&vcpu->arch.asi_pgtbl_pool);
 }
 
 void kvm_mmu_module_exit(void)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 708a5d297fe1..193317ad60a4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -584,6 +584,9 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (is_error_pfn(pfn))
 		return false;
 
+	if (!treat_all_userspace_as_nonsensitive)
+		asi_map_gfn_range(vcpu, slot, gfn, 1);
+
 	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, pfn, NULL);
 	kvm_release_pfn_clean(pfn);
 	return true;
@@ -836,6 +839,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	int r;
 	unsigned long mmu_seq;
 	bool is_self_change_mapping;
+	bool try_asi_map;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
 	WARN_ON_ONCE(fault->is_tdp);
@@ -890,6 +894,12 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (handle_abnormal_pfn(vcpu, fault, walker.pte_access, &r))
 		return r;
 
+	try_asi_map = !treat_all_userspace_as_nonsensitive &&
+		      !is_noslot_pfn(fault->pfn);
+
+	if (try_asi_map)
+		vcpu_fill_asi_pgtbl_pool(vcpu);
+
 	/*
 	 * Do not change pte_access if the pfn is a mmio page, otherwise
 	 * we will cache the incorrect access into mmio spte.
@@ -919,6 +929,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
+
+	if (try_asi_map)
+		asi_map_gfn_range(vcpu, fault->slot, walker.gfn, 1);
+
 	r = FNAME(fetch)(vcpu, fault, &walker);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd07f677d084..d0df14deae80 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8722,7 +8722,10 @@ int kvm_arch_init(void *opaque)
 		goto out_free_percpu;
 
 	if (ops->runtime_ops->flush_sensitive_cpu_state) {
-		r = asi_register_class("KVM", ASI_MAP_STANDARD_NONSENSITIVE,
+		r = asi_register_class("KVM",
+				       ASI_MAP_STANDARD_NONSENSITIVE |
+				       (treat_all_userspace_as_nonsensitive ?
+					ASI_MAP_ALL_USERSPACE : 0),
 				       &kvm_asi_hooks);
 		if (r < 0)
 			goto out_mmu_exit;
@@ -9675,6 +9678,17 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (start <= apic_address && apic_address < end)
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
+
+	if (!treat_all_userspace_as_nonsensitive)
+		asi_unmap_user(kvm->asi, (void *)start, end - start);
+}
+
+void kvm_arch_mmu_notifier_invalidate_range_start(struct kvm *kvm,
+						  unsigned long start,
+						  unsigned long end)
+{
+	if (!treat_all_userspace_as_nonsensitive)
+		asi_unmap_user(kvm->asi, (void *)start, end - start);
 }
 
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
@@ -11874,6 +11888,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
+	if (!treat_all_userspace_as_nonsensitive)
+		asi_unmap_user(kvm->asi, 0, TASK_SIZE_MAX);
+
 	kvm_mmu_zap_all(kvm);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9dd63ed21f75..f31f7442eced 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1819,6 +1819,9 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 					    unsigned long start, unsigned long end);
+void kvm_arch_mmu_notifier_invalidate_range_start(struct kvm *kvm,
+						  unsigned long start,
+						  unsigned long end);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 72c4e6b39389..e8e9c8588908 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -162,6 +162,12 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 {
 }
 
+__weak void kvm_arch_mmu_notifier_invalidate_range_start(struct kvm *kvm,
+							 unsigned long start,
+							 unsigned long end)
+{
+}
+
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 {
 	/*
@@ -685,6 +691,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	spin_unlock(&kvm->mn_invalidate_lock);
 
 	__kvm_handle_hva_range(kvm, &hva_range);
+	kvm_arch_mmu_notifier_invalidate_range_start(kvm, range->start, range->end);
 
 	return 0;
 }
-- 
2.35.1.473.g83b2b277ed-goog

