Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1EA5DE98
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 09:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfGCHOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 03:14:12 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38707 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfGCHOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 03:14:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id 9so713527ple.5;
        Wed, 03 Jul 2019 00:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ccH1lY4O7n4BXQuRS1GgwOEGuGvqXICf1/+JCvsaWLs=;
        b=brtAaApk3IjptbtCTY1PFy+nzymP6csVNXYCozRsX3HPpzNN+BAs5Fwg9RiTPW0c+s
         xe04LZWkGZfRXIEka4s9rEfyduWgy2JHoImF2Rk68YeDN036CGtqYdW/C4QFsBLKZh0b
         5M0HTBNXRGzkaZK2IZo9JpUvE6uM1R86tb5LpcAd2NQTr6pVeuQr6vOPI0c8MnF2N1ol
         cnYc+AAP+6Vfmeab6wXl2Hw4oqJiePCrloB6bFaGJnwPhPC5Fx9LNkD2YLHExe1kLmcu
         1vFMrcWXSKYJwLKIP5vY5s/uoDjK/cSL/AIFmj3iRgka5nTTb0LsIzzzZwsvCqJbT1bc
         UEyg==
X-Gm-Message-State: APjAAAVFCpVTNs6ZTeyXHCQubZHguYk+o0q4qD9CC1GccnW8OK62vEqC
        q0cL+VtI+kUL7tsKArKeAIc=
X-Google-Smtp-Source: APXvYqxDiu4XHF/h685l75XKdA+4AtAWMjLUqXNKPxMi634QNbO+Oh5f6iZUYJKpj5KI9u+azIzt2A==
X-Received: by 2002:a17:902:2983:: with SMTP id h3mr40803893plb.45.1562138048504;
        Wed, 03 Jul 2019 00:14:08 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id j21sm1256593pfh.86.2019.07.03.00.14.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 00:14:07 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Nadav Amit <namit@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v2 4/9] x86/mm/tlb: Flush remote and local TLBs concurrently
Date:   Tue,  2 Jul 2019 16:51:46 -0700
Message-Id: <20190702235151.4377-5-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702235151.4377-1-namit@vmware.com>
References: <20190702235151.4377-1-namit@vmware.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To improve TLB shootdown performance, flush the remote and local TLBs
concurrently. Introduce flush_tlb_multi() that does so. Introduce
paravirtual versions of flush_tlb_multi() for KVM, Xen and hyper-v (Xen
and hyper-v are only compile-tested).

While the updated smp infrastructure is capable of running a function on
a single local core, it is not optimized for this case. The multiple
function calls and the indirect branch introduce some overhead, and
might make local TLB flushes slower than they were before the recent
changes.

Before calling the SMP infrastructure, check if only a local TLB flush
is needed to restore the lost performance in this common case. This
requires to check mm_cpumask() one more time, but unless this mask is
updated very frequently, this should impact performance negatively.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: Juergen Gross <jgross@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: linux-hyperv@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 arch/x86/hyperv/mmu.c                 | 13 +++---
 arch/x86/include/asm/paravirt.h       |  6 +--
 arch/x86/include/asm/paravirt_types.h |  4 +-
 arch/x86/include/asm/tlbflush.h       |  9 ++--
 arch/x86/include/asm/trace/hyperv.h   |  2 +-
 arch/x86/kernel/kvm.c                 | 11 +++--
 arch/x86/kernel/paravirt.c            |  2 +-
 arch/x86/mm/tlb.c                     | 65 ++++++++++++++++++++-------
 arch/x86/xen/mmu_pv.c                 | 20 ++++++---
 include/trace/events/xen.h            |  2 +-
 10 files changed, 91 insertions(+), 43 deletions(-)

diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
index e65d7fe6489f..1177f863e4cd 100644
--- a/arch/x86/hyperv/mmu.c
+++ b/arch/x86/hyperv/mmu.c
@@ -50,8 +50,8 @@ static inline int fill_gva_list(u64 gva_list[], int offset,
 	return gva_n - offset;
 }
 
-static void hyperv_flush_tlb_others(const struct cpumask *cpus,
-				    const struct flush_tlb_info *info)
+static void hyperv_flush_tlb_multi(const struct cpumask *cpus,
+				   const struct flush_tlb_info *info)
 {
 	int cpu, vcpu, gva_n, max_gvas;
 	struct hv_tlb_flush **flush_pcpu;
@@ -59,7 +59,7 @@ static void hyperv_flush_tlb_others(const struct cpumask *cpus,
 	u64 status = U64_MAX;
 	unsigned long flags;
 
-	trace_hyperv_mmu_flush_tlb_others(cpus, info);
+	trace_hyperv_mmu_flush_tlb_multi(cpus, info);
 
 	if (!hv_hypercall_pg)
 		goto do_native;
@@ -69,6 +69,9 @@ static void hyperv_flush_tlb_others(const struct cpumask *cpus,
 
 	local_irq_save(flags);
 
+	if (cpumask_test_cpu(smp_processor_id(), cpus))
+		flush_tlb_func_local(info);
+
 	flush_pcpu = (struct hv_tlb_flush **)
 		     this_cpu_ptr(hyperv_pcpu_input_arg);
 
@@ -156,7 +159,7 @@ static void hyperv_flush_tlb_others(const struct cpumask *cpus,
 	if (!(status & HV_HYPERCALL_RESULT_MASK))
 		return;
 do_native:
-	native_flush_tlb_others(cpus, info);
+	native_flush_tlb_multi(cpus, info);
 }
 
 static u64 hyperv_flush_tlb_others_ex(const struct cpumask *cpus,
@@ -231,6 +234,6 @@ void hyperv_setup_mmu_ops(void)
 		return;
 
 	pr_info("Using hypercall for remote TLB flush\n");
-	pv_ops.mmu.flush_tlb_others = hyperv_flush_tlb_others;
+	pv_ops.mmu.flush_tlb_multi = hyperv_flush_tlb_multi;
 	pv_ops.mmu.tlb_remove_table = tlb_remove_table;
 }
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index c25c38a05c1c..316959e89258 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -62,10 +62,10 @@ static inline void __flush_tlb_one_user(unsigned long addr)
 	PVOP_VCALL1(mmu.flush_tlb_one_user, addr);
 }
 
-static inline void flush_tlb_others(const struct cpumask *cpumask,
-				    const struct flush_tlb_info *info)
+static inline void flush_tlb_multi(const struct cpumask *cpumask,
+				   const struct flush_tlb_info *info)
 {
-	PVOP_VCALL2(mmu.flush_tlb_others, cpumask, info);
+	PVOP_VCALL2(mmu.flush_tlb_multi, cpumask, info);
 }
 
 static inline void paravirt_tlb_remove_table(struct mmu_gather *tlb, void *table)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 946f8f1f1efc..54f4c718b5b0 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -211,8 +211,8 @@ struct pv_mmu_ops {
 	void (*flush_tlb_user)(void);
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_one_user)(unsigned long addr);
-	void (*flush_tlb_others)(const struct cpumask *cpus,
-				 const struct flush_tlb_info *info);
+	void (*flush_tlb_multi)(const struct cpumask *cpus,
+				const struct flush_tlb_info *info);
 
 	void (*tlb_remove_table)(struct mmu_gather *tlb, void *table);
 
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index dee375831962..36aa2a9b7597 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -517,7 +517,7 @@ static inline void __flush_tlb_one_kernel(unsigned long addr)
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_others(cpumask, info) flushes TLBs on other cpus
+ *  - flush_tlb_multi(cpumask, info) flushes TLBs on multiple cpus
  *
  * ..but the i386 has somewhat limited tlb flushing capabilities,
  * and page-granular flushes are available only on i486 and up.
@@ -563,13 +563,14 @@ extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned int stride_shift,
 				bool freed_tables);
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+extern void flush_tlb_func_local(const struct flush_tlb_info *info);
 
 static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
 {
 	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
 }
 
-void native_flush_tlb_others(const struct cpumask *cpumask,
+void native_flush_tlb_multi(const struct cpumask *cpumask,
 			     const struct flush_tlb_info *info);
 
 static inline u64 inc_mm_tlb_gen(struct mm_struct *mm)
@@ -593,8 +594,8 @@ static inline void arch_tlbbatch_add_mm(struct arch_tlbflush_unmap_batch *batch,
 extern void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
 #ifndef CONFIG_PARAVIRT
-#define flush_tlb_others(mask, info)	\
-	native_flush_tlb_others(mask, info)
+#define flush_tlb_multi(mask, info)	\
+	native_flush_tlb_multi(mask, info)
 
 #define paravirt_tlb_remove_table(tlb, page) \
 	tlb_remove_page(tlb, (void *)(page))
diff --git a/arch/x86/include/asm/trace/hyperv.h b/arch/x86/include/asm/trace/hyperv.h
index ace464f09681..85ca8560c7f9 100644
--- a/arch/x86/include/asm/trace/hyperv.h
+++ b/arch/x86/include/asm/trace/hyperv.h
@@ -8,7 +8,7 @@
 
 #if IS_ENABLED(CONFIG_HYPERV)
 
-TRACE_EVENT(hyperv_mmu_flush_tlb_others,
+TRACE_EVENT(hyperv_mmu_flush_tlb_multi,
 	    TP_PROTO(const struct cpumask *cpus,
 		     const struct flush_tlb_info *info),
 	    TP_ARGS(cpus, info),
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5169b8cc35bb..d00d551d4a2a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -580,7 +580,7 @@ static void __init kvm_apf_trap_init(void)
 
 static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
 
-static void kvm_flush_tlb_others(const struct cpumask *cpumask,
+static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
 			const struct flush_tlb_info *info)
 {
 	u8 state;
@@ -594,6 +594,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 	 * queue flush_on_enter for pre-empted vCPUs
 	 */
 	for_each_cpu(cpu, flushmask) {
+		/*
+		 * The local vCPU is never preempted, so we do not explicitly
+		 * skip check for local vCPU - it will never be cleared from
+		 * flushmask.
+		 */
 		src = &per_cpu(steal_time, cpu);
 		state = READ_ONCE(src->preempted);
 		if ((state & KVM_VCPU_PREEMPTED)) {
@@ -603,7 +608,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 		}
 	}
 
-	native_flush_tlb_others(flushmask, info);
+	native_flush_tlb_multi(flushmask, info);
 }
 
 static void __init kvm_guest_init(void)
@@ -628,7 +633,7 @@ static void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
 	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
 	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
-		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
+		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
 	}
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 98039d7fb998..7cdcffe2a028 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -363,7 +363,7 @@ struct paravirt_patch_template pv_ops = {
 	.mmu.flush_tlb_user	= native_flush_tlb,
 	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
 	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
-	.mmu.flush_tlb_others	= native_flush_tlb_others,
+	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
 	.mmu.tlb_remove_table	=
 			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5c9b1607191d..074288a6916e 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -551,7 +551,7 @@ static void flush_tlb_func_common(const struct flush_tlb_info *f,
 		 * garbage into our TLB.  Since switching to init_mm is barely
 		 * slower than a minimal flush, just switch to init_mm.
 		 *
-		 * This should be rare, with native_flush_tlb_others skipping
+		 * This should be rare, with native_flush_tlb_multi() skipping
 		 * IPIs to lazy TLB mode CPUs.
 		 */
 		switch_mm_irqs_off(NULL, &init_mm, NULL);
@@ -635,7 +635,7 @@ static void flush_tlb_func_common(const struct flush_tlb_info *f,
 	this_cpu_write(cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen, mm_tlb_gen);
 }
 
-static void flush_tlb_func_local(void *info)
+static void __flush_tlb_func_local(void *info)
 {
 	const struct flush_tlb_info *f = info;
 	enum tlb_flush_reason reason;
@@ -645,6 +645,11 @@ static void flush_tlb_func_local(void *info)
 	flush_tlb_func_common(f, true, reason);
 }
 
+void flush_tlb_func_local(const struct flush_tlb_info *info)
+{
+	__flush_tlb_func_local((void *)info);
+}
+
 static void flush_tlb_func_remote(void *info)
 {
 	const struct flush_tlb_info *f = info;
@@ -665,9 +670,14 @@ static bool tlb_is_not_lazy(int cpu)
 
 static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
 
-void native_flush_tlb_others(const struct cpumask *cpumask,
-			     const struct flush_tlb_info *info)
+void native_flush_tlb_multi(const struct cpumask *cpumask,
+			    const struct flush_tlb_info *info)
 {
+	/*
+	 * Do accounting and tracing. Note that there are (and have always been)
+	 * cases in which a remote TLB flush will be traced, but eventually
+	 * would not happen.
+	 */
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
 	if (info->end == TLB_FLUSH_ALL)
 		trace_tlb_flush(TLB_REMOTE_SEND_IPI, TLB_FLUSH_ALL);
@@ -687,10 +697,12 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 		 * means that the percpu tlb_gen variables won't be updated
 		 * and we'll do pointless flushes on future context switches.
 		 *
-		 * Rather than hooking native_flush_tlb_others() here, I think
+		 * Rather than hooking native_flush_tlb_multi() here, I think
 		 * that UV should be updated so that smp_call_function_many(),
 		 * etc, are optimal on UV.
 		 */
+		flush_tlb_func_local(info);
+
 		cpumask = uv_flush_tlb_others(cpumask, info);
 		if (cpumask)
 			smp_call_function_many(cpumask, flush_tlb_func_remote,
@@ -709,8 +721,9 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	 * doing a speculative memory access.
 	 */
 	if (info->freed_tables) {
-		smp_call_function_many(cpumask, flush_tlb_func_remote,
-			       (void *)info, 1);
+		__smp_call_function_many(cpumask, flush_tlb_func_remote,
+					 __flush_tlb_func_local,
+					 (void *)info, 1);
 	} else {
 		/*
 		 * Although we could have used on_each_cpu_cond_mask(),
@@ -737,7 +750,8 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 			if (tlb_is_not_lazy(cpu))
 				__cpumask_set_cpu(cpu, cond_cpumask);
 		}
-		smp_call_function_many(cond_cpumask, flush_tlb_func_remote,
+		__smp_call_function_many(cond_cpumask, flush_tlb_func_remote,
+					 __flush_tlb_func_local,
 					 (void *)info, 1);
 	}
 }
@@ -818,16 +832,29 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	info = get_flush_tlb_info(mm, start, end, stride_shift, freed_tables,
 				  new_tlb_gen);
 
-	if (mm == this_cpu_read(cpu_tlbstate.loaded_mm)) {
+	/*
+	 * Assert that mm_cpumask() corresponds with the loaded mm. We got one
+	 * exception: for init_mm we do not need to flush anything, and the
+	 * cpumask does not correspond with loaded_mm.
+	 */
+	VM_WARN_ON_ONCE(cpumask_test_cpu(smp_processor_id(), mm_cpumask(mm)) !=
+			(mm == this_cpu_read(cpu_tlbstate.loaded_mm)) &&
+			mm != &init_mm);
+
+	/*
+	 * flush_tlb_multi() is not optimized for the common case in which only
+	 * a local TLB flush is needed. Optimize this use-case by calling
+	 * flush_tlb_func_local() directly in this case.
+	 */
+	if (cpumask_any_but(mm_cpumask(mm), cpu) < nr_cpu_ids) {
+		flush_tlb_multi(mm_cpumask(mm), info);
+	} else {
 		lockdep_assert_irqs_enabled();
 		local_irq_disable();
 		flush_tlb_func_local(info);
 		local_irq_enable();
 	}
 
-	if (cpumask_any_but(mm_cpumask(mm), cpu) < nr_cpu_ids)
-		flush_tlb_others(mm_cpumask(mm), info);
-
 	put_flush_tlb_info();
 	put_cpu();
 }
@@ -890,16 +917,20 @@ void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
 	int cpu = get_cpu();
 
-	if (cpumask_test_cpu(cpu, &batch->cpumask)) {
+	/*
+	 * flush_tlb_multi() is not optimized for the common case in which only
+	 * a local TLB flush is needed. Optimize this use-case by calling
+	 * flush_tlb_func_local() directly in this case.
+	 */
+	if (cpumask_any_but(&batch->cpumask, cpu) < nr_cpu_ids) {
+		flush_tlb_multi(&batch->cpumask, &full_flush_tlb_info);
+	} else {
 		lockdep_assert_irqs_enabled();
 		local_irq_disable();
-		flush_tlb_func_local((void *)&full_flush_tlb_info);
+		flush_tlb_func_local(&full_flush_tlb_info);
 		local_irq_enable();
 	}
 
-	if (cpumask_any_but(&batch->cpumask, cpu) < nr_cpu_ids)
-		flush_tlb_others(&batch->cpumask, &full_flush_tlb_info);
-
 	cpumask_clear(&batch->cpumask);
 
 	put_cpu();
diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index beb44e22afdf..19e481e6e904 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -1355,8 +1355,8 @@ static void xen_flush_tlb_one_user(unsigned long addr)
 	preempt_enable();
 }
 
-static void xen_flush_tlb_others(const struct cpumask *cpus,
-				 const struct flush_tlb_info *info)
+static void xen_flush_tlb_multi(const struct cpumask *cpus,
+				const struct flush_tlb_info *info)
 {
 	struct {
 		struct mmuext_op op;
@@ -1366,7 +1366,7 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	const size_t mc_entry_size = sizeof(args->op) +
 		sizeof(args->mask[0]) * BITS_TO_LONGS(num_possible_cpus());
 
-	trace_xen_mmu_flush_tlb_others(cpus, info->mm, info->start, info->end);
+	trace_xen_mmu_flush_tlb_multi(cpus, info->mm, info->start, info->end);
 
 	if (cpumask_empty(cpus))
 		return;		/* nothing to do */
@@ -1375,9 +1375,17 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	args = mcs.args;
 	args->op.arg2.vcpumask = to_cpumask(args->mask);
 
-	/* Remove us, and any offline CPUS. */
+	/* Flush locally if needed and remove us */
+	if (cpumask_test_cpu(smp_processor_id(), to_cpumask(args->mask))) {
+		local_irq_disable();
+		flush_tlb_func_local(info);
+		local_irq_enable();
+
+		cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
+	}
+
+	/* Remove offline CPUS */
 	cpumask_and(to_cpumask(args->mask), cpus, cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
 
 	args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
 	if (info->end != TLB_FLUSH_ALL &&
@@ -2406,7 +2414,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.flush_tlb_user = xen_flush_tlb,
 	.flush_tlb_kernel = xen_flush_tlb,
 	.flush_tlb_one_user = xen_flush_tlb_one_user,
-	.flush_tlb_others = xen_flush_tlb_others,
+	.flush_tlb_multi = xen_flush_tlb_multi,
 	.tlb_remove_table = tlb_remove_table,
 
 	.pgd_alloc = xen_pgd_alloc,
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index 9a0e8af21310..546022acf160 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -362,7 +362,7 @@ TRACE_EVENT(xen_mmu_flush_tlb_one_user,
 	    TP_printk("addr %lx", __entry->addr)
 	);
 
-TRACE_EVENT(xen_mmu_flush_tlb_others,
+TRACE_EVENT(xen_mmu_flush_tlb_multi,
 	    TP_PROTO(const struct cpumask *cpus, struct mm_struct *mm,
 		     unsigned long addr, unsigned long end),
 	    TP_ARGS(cpus, mm, addr, end),
-- 
2.17.1

