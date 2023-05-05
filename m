Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5A96F85E4
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjEEPeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjEEPee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:34:34 -0400
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EFA198E
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:34:30 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QCZDF6ppRzMq81r;
        Fri,  5 May 2023 17:22:05 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QCZDF1ydFzMptBL;
        Fri,  5 May 2023 17:22:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1683300125;
        bh=PyAeGY6RXqTYQefM0sl5cf8gwLNcu9YypouNBS2PSvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gx2MJRBQRK/Q7zeNftCJx4FHowj9XptOmH9PCuCsUSu0Bp7v+0qbMxJPxRE/O0jXB
         coJOo2nnquoJ+LYtPiXbpt1gGK6521yg3b0SbAlgonaVc1WJSFYSTnWf6gVnc0qPj3
         BlSHXvPRMTfLaM2oFX0fm3FNVa7xLedl9XNnFLhY=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v1 8/9] KVM: x86/mmu: Enable guests to lock themselves thanks to MBEC
Date:   Fri,  5 May 2023 17:20:45 +0200
Message-Id: <20230505152046.6575-9-mic@digikod.net>
In-Reply-To: <20230505152046.6575-1-mic@digikod.net>
References: <20230505152046.6575-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This changes enable to enforce a deny-by-default execution security
policy for guest kernels, leveraged by the Heki implementation.

Create synthetic page faults when an access is denied by Heki.  This
kind of kernel page fault needs to be handled by guests, which is not
currently the case, making it try again and again, but we are working to
calm down such guests by teaching them how to handle such page faults.

The MMU tracepoints are updated to reflect the difference between kernel
and user space executions.

kvm_heki_fix_all_ept_exec_perm() walks through all guest memory pages to
set the configured default execution permissions (i.e. only allow
configured executabel memory pages).

The struct heki_mem_range's attribute field now understand
HEKI_ATTR_MEM_EXEC, which allows the related kernel sections to be
executable, and deny any other kernel memory from being executable for
the whole lifetime of the guest.  This obviously can only work with
static kernels and we are exploring ways to handle authenticated and
dynamic kernel memory permission updates.

If the host doesn't have MBEC enabled, the KVM_HC_LOCK_MEM_PAGE_RANGES
hypecall will return -KVM_EOPNOTSUPP and might only apply the previous
ranges, if any.  This is useful to develop this RFC and make sure
execution restrictions are enforced (and not silently ignored), but this
behavior might change in a future patch series.  Guest kernels could
check for MBEC support to not use the HEKI_ATTR_MEM_EXEC attribute.

The number of configurable memory ranges per guest is 16 for now.  This
will change with a follow-up.

There are currently some pr_warn() calls to make it easy to test this
code.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20230505152046.6575-9-mic@digikod.net
---
 Documentation/virt/kvm/x86/hypercalls.rst |  4 +-
 arch/x86/kvm/mmu/mmu.c                    | 35 ++++++++-
 arch/x86/kvm/mmu/mmutrace.h               | 11 ++-
 arch/x86/kvm/mmu/spte.c                   | 19 ++++-
 arch/x86/kvm/mmu/spte.h                   | 15 +++-
 arch/x86/kvm/mmu/tdp_mmu.c                | 73 ++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h                |  4 +
 arch/x86/kvm/x86.c                        | 90 ++++++++++++++++++++++-
 arch/x86/kvm/x86.h                        |  7 ++
 include/linux/kvm_host.h                  |  4 +
 virt/kvm/kvm_main.c                       |  1 +
 11 files changed, 250 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/x86/hypercalls.rst b/Documentation/virt/kvm/x86/hypercalls.rst
index 8aa5d28986e3..5accf5f6de13 100644
--- a/Documentation/virt/kvm/x86/hypercalls.rst
+++ b/Documentation/virt/kvm/x86/hypercalls.rst
@@ -204,7 +204,9 @@ must also set up an MSR filter to process writes to MSR_KVM_MIGRATION_CONTROL.
 
 The hypercall lets a guest request memory permissions to be removed for itself,
 identified with set of physical page ranges (GFNs).  The HEKI_ATTR_MEM_NOWRITE
-memory page range attribute forbids related modification to the guest.
+memory page range attribute forbids related modification to the guest.  The
+HEKI_ATTR_MEM_EXEC attribute allows execution on the specified pages while
+removing it for all the others.
 
 Returns 0 on success or a KVM error code otherwise.
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a47e63217eb8..56a8bcac1b82 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3313,7 +3313,7 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 static bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
 {
 	if (fault->exec)
-		return is_executable_pte(spte);
+		return is_executable_pte(spte, !fault->user);
 
 	if (fault->write)
 		return is_writable_pte(spte);
@@ -5602,6 +5602,39 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
+	/* Skips real page faults if not needed. */
+	if ((error_code & PFERR_FETCH_MASK) &&
+	    !kvm_heki_is_exec_allowed(vcpu, cr2_or_gpa)) {
+		/*
+		 * TODO: To avoid kvm_heki_is_exec_allowed() call, check
+		 * enable_mbec and EPT_VIOLATION_KERNEL_INSTR, see
+		 * handle_ept_violation().
+		 */
+		struct x86_exception fault = {
+			.vector = PF_VECTOR,
+			.error_code_valid = true,
+			.error_code = error_code,
+			.nested_page_fault = false,
+			/*
+			 * TODO: This kind of kernel page fault needs to be handled by
+			 * the guest, which is not currently the case, making it try
+			 * again and again.
+			 *
+			 * You may want to test with cr2_or_gva to see the page
+			 * fault caught by the guest kernel (thinking it is a
+			 * user space fault).
+			 */
+			.address = static_call(kvm_x86_fault_gva)(vcpu),
+			.async_page_fault = false,
+		};
+
+		pr_warn_ratelimited(
+			"heki-kvm: Creating fetch #PF at 0x%016llx\n",
+			fault.address);
+		kvm_inject_page_fault(vcpu, &fault);
+		return RET_PF_INVALID;
+	}
+
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
 		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index ae86820cef69..cb7df95aec25 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -342,7 +342,8 @@ TRACE_EVENT(
 		__field(u8, level)
 		/* These depend on page entry type, so compute them now.  */
 		__field(bool, r)
-		__field(bool, x)
+		__field(bool, kx)
+		__field(bool, ux)
 		__field(signed char, u)
 	),
 
@@ -352,15 +353,17 @@ TRACE_EVENT(
 		__entry->sptep = virt_to_phys(sptep);
 		__entry->level = level;
 		__entry->r = shadow_present_mask || (__entry->spte & PT_PRESENT_MASK);
-		__entry->x = is_executable_pte(__entry->spte);
+		__entry->kx = is_executable_pte(__entry->spte, true);
+		__entry->ux = is_executable_pte(__entry->spte, false);
 		__entry->u = shadow_user_mask ? !!(__entry->spte & shadow_user_mask) : -1;
 	),
 
-	TP_printk("gfn %llx spte %llx (%s%s%s%s) level %d at %llx",
+	TP_printk("gfn %llx spte %llx (%s%s%s%s%s) level %d at %llx",
 		  __entry->gfn, __entry->spte,
 		  __entry->r ? "r" : "-",
 		  __entry->spte & PT_WRITABLE_MASK ? "w" : "-",
-		  __entry->x ? "x" : "-",
+		  __entry->kx ? "X" : "-",
+		  __entry->ux ? "x" : "-",
 		  __entry->u == -1 ? "" : (__entry->u ? "u" : "-"),
 		  __entry->level, __entry->sptep
 	)
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index f1e2e3cad878..c9fabb3c9cb2 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -184,10 +184,25 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		pte_access &= ~ACC_EXEC_MASK;
 	}
 
-	if (pte_access & ACC_EXEC_MASK)
+	if (pte_access & ACC_EXEC_MASK) {
 		spte |= shadow_x_mask;
-	else
+#ifdef CONFIG_HEKI
+		/*
+		 * FIXME: Race condition (at boot) if no
+		 * lockdep_assert_held_write(vcpu->kvm->mmu_lock);
+		 */
+		if (READ_ONCE(vcpu->kvm->heki_kernel_exec_locked)) {
+			if (!heki_exec_is_allowed(vcpu->kvm, gfn))
+				spte &= ~VMX_EPT_EXECUTABLE_MASK;
+			else
+				pr_warn("heki-kvm: Allowing kernel execution "
+					"for GFN 0x%llx\n",
+					gfn);
+		}
+#endif /* CONFIG_HEKI */
+	} else {
 		spte |= shadow_nx_mask;
+	}
 
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 6f54dc9409c9..30b250d03132 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -3,7 +3,10 @@
 #ifndef KVM_X86_MMU_SPTE_H
 #define KVM_X86_MMU_SPTE_H
 
+#include <asm/vmx.h>
+
 #include "mmu_internal.h"
+#include "../vmx/vmx.h"
 
 /*
  * A MMU present SPTE is backed by actual memory and may or may not be present
@@ -307,9 +310,17 @@ static inline bool is_last_spte(u64 pte, int level)
 	return (level == PG_LEVEL_4K) || is_large_pte(pte);
 }
 
-static inline bool is_executable_pte(u64 spte)
+static inline bool is_executable_pte(u64 spte, bool for_kernel_mode)
 {
-	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
+	u64 x_mask = shadow_x_mask;
+
+	if (enable_mbec) {
+		if (for_kernel_mode)
+			x_mask &= ~VMX_EPT_USER_EXECUTABLE_MASK;
+		else
+			x_mask &= ~VMX_EPT_EXECUTABLE_MASK;
+	}
+	return (spte & (x_mask | shadow_nx_mask)) == x_mask;
 }
 
 static inline kvm_pfn_t spte_to_pfn(u64 pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d6df38d371a0..0be34a9e90c0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -7,7 +7,10 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#include "../x86.h"
+
 #include <asm/cmpxchg.h>
+#include <asm/vmx.h>
 #include <trace/events/kvm.h>
 
 static bool __read_mostly tdp_mmu_enabled = true;
@@ -1021,6 +1024,76 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	}
 }
 
+#ifdef CONFIG_HEKI
+
+/* TODO: Handle flush? */
+void kvm_heki_fix_all_ept_exec_perm(struct kvm *const kvm)
+{
+	int i;
+	struct kvm_mmu_page *root;
+	const gfn_t start = 0;
+	const gfn_t end = tdp_mmu_max_gfn_exclusive();
+
+	if (WARN_ON_ONCE(!is_tdp_mmu_enabled(kvm)))
+		return;
+
+	if (WARN_ON_ONCE(!enable_mbec))
+		return;
+
+	write_lock(&kvm->mmu_lock);
+
+	/*
+	 * Because heki_exec_locked is only set with this code, it cannot be
+	 * unlocked.  This is protected against race condition thanks to
+	 * mmu_lock.
+	 */
+	WRITE_ONCE(kvm->heki_kernel_exec_locked, true);
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		for_each_tdp_mmu_root(kvm, root, i) {
+			struct tdp_iter iter;
+
+			WARN_ON_ONCE(!refcount_read(&root->tdp_mmu_root_count));
+
+			/*
+			 * TODO: Make sure
+			 * !is_shadow_present_pte()/SPTE_MMU_PRESENT_MASK are
+			 * well handled when they are present.
+			 */
+
+			rcu_read_lock();
+			tdp_root_for_each_leaf_pte(iter, root, start, end) {
+				u64 new_spte;
+
+				if (heki_exec_is_allowed(kvm, iter.gfn)) {
+					pr_warn("heki-kvm: Allowing kernel "
+						"execution for GFN 0x%llx\n",
+						iter.gfn);
+					continue;
+				}
+				pr_warn("heki-kvm: Denying kernel execution "
+					"for GFN 0x%llx\n",
+					iter.gfn);
+
+retry:
+				new_spte = iter.old_spte &
+					   ~VMX_EPT_EXECUTABLE_MASK;
+				if (new_spte == iter.old_spte)
+					continue;
+
+				if (tdp_mmu_set_spte_atomic(kvm, &iter,
+							    new_spte))
+					goto retry;
+			}
+			rcu_read_unlock();
+		}
+	}
+	write_unlock(&kvm->mmu_lock);
+	pr_warn("heki-kvm: Locked executable kernel memory\n");
+}
+
+#endif /* CONFIG_HEKI */
+
 /*
  * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
  * zap" completes.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index d3714200b932..8b70b6af68d4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -24,6 +24,10 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
+#ifdef CONFIG_HEKI
+void kvm_heki_fix_all_ept_exec_perm(struct kvm *const kvm);
+#endif /* CONFIG_HEKI */
+
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a529455359ac..7ac8d9fabc18 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -20,6 +20,7 @@
 #include "irq.h"
 #include "ioapic.h"
 #include "mmu.h"
+#include "mmu/tdp_mmu.h"
 #include "i8254.h"
 #include "tss.h"
 #include "kvm_cache_regs.h"
@@ -31,6 +32,7 @@
 #include "lapic.h"
 #include "xen.h"
 #include "smm.h"
+#include "vmx/capabilities.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -9705,6 +9707,45 @@ heki_page_track_prewrite(struct kvm_vcpu *const vcpu, const gpa_t gpa,
 	return true;
 }
 
+bool heki_exec_is_allowed(const struct kvm *const kvm, const gfn_t gfn)
+{
+	unsigned int gfn_last;
+
+	if (!READ_ONCE(kvm->heki_kernel_exec_locked))
+		return true;
+
+	/*
+	 * heki_gfn_exec_last is initialized with (HEKI_GFN_MAX + 1),
+	 * and 0 means that heki_gfn_exec_last is full.
+	 */
+	for (gfn_last = atomic_read(&kvm->heki_gfn_exec_last);
+	     gfn_last > 0 && gfn_last <= HEKI_GFN_MAX;) {
+		gfn_last--;
+
+		/* Ignores unused slots. */
+		if (kvm->heki_gfn_exec[gfn_last].end == 0)
+			break;
+
+		if (gfn >= kvm->heki_gfn_exec[gfn_last].start &&
+		    gfn <= kvm->heki_gfn_exec[gfn_last].end) {
+			/* TODO: Opportunistically shrink heki_gfn_exec. */
+			return true;
+		}
+	}
+	return false;
+}
+
+bool kvm_heki_is_exec_allowed(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	const gfn_t gfn = gpa_to_gfn(gpa);
+	const struct kvm *const kvm = vcpu->kvm;
+
+	if (heki_exec_is_allowed(kvm, gfn))
+		return true;
+
+	return false;
+}
+
 static int kvm_heki_init_vm(struct kvm *const kvm)
 {
 	struct kvm_page_track_notifier_node *const node =
@@ -9733,6 +9774,7 @@ static int heki_lock_mem_page_ranges(struct kvm *const kvm, gpa_t mem_ranges,
 	int err;
 	size_t i, ranges_num;
 	struct heki_pa_range *ranges;
+	bool has_exec_restriction = false;
 
 	if (mem_ranges_size > HEKI_PA_RANGE_MAX_SIZE)
 		return -KVM_E2BIG;
@@ -9752,7 +9794,8 @@ static int heki_lock_mem_page_ranges(struct kvm *const kvm, gpa_t mem_ranges,
 
 	ranges_num = mem_ranges_size / sizeof(struct heki_pa_range);
 	for (i = 0; i < ranges_num; i++) {
-		const u64 attributes_mask = HEKI_ATTR_MEM_NOWRITE;
+		const u64 attributes_mask = HEKI_ATTR_MEM_NOWRITE |
+					    HEKI_ATTR_MEM_EXEC;
 		const gfn_t gfn_start = ranges[i].gfn_start;
 		const gfn_t gfn_end = ranges[i].gfn_end;
 		const u64 attributes = ranges[i].attributes;
@@ -9799,11 +9842,52 @@ static int heki_lock_mem_page_ranges(struct kvm *const kvm, gpa_t mem_ranges,
 					kvm, gfn, KVM_PAGE_TRACK_PREWRITE));
 		}
 
-		pr_warn("heki-kvm: Locking GFN 0x%llx-0x%llx with %s\n",
+		/*
+		 * Allow-list for execute permission,
+		 * see kvm_heki_fix_all_ept_exec_perm().
+		 */
+		if (attributes & HEKI_ATTR_MEM_EXEC) {
+			size_t gfn_i;
+
+			if (!enable_mbec) {
+				/*
+				 * Guests can check for MBEC support to avoid
+				 * such error by not using HEKI_ATTR_MEM_EXEC.
+				 */
+				err = -KVM_EOPNOTSUPP;
+				pr_warn("heki-kvm: HEKI_ATTR_MEM_EXEC "
+					"depends on MBEC, which is disabled.");
+				/*
+				 * We should continue partially applying
+				 * restrictions, but it is useful for this RFC
+				 * to exit early in case of missing MBEC
+				 * support.
+				 */
+				goto out_free_ranges;
+			}
+
+			has_exec_restriction = true;
+			gfn_i = atomic_dec_if_positive(
+				&kvm->heki_gfn_exec_last);
+			if (gfn_i == 0) {
+				err = -KVM_E2BIG;
+				goto out_free_ranges;
+			}
+
+			gfn_i--;
+			kvm->heki_gfn_exec[gfn_i].start = gfn_start;
+			kvm->heki_gfn_exec[gfn_i].end = gfn_end;
+		}
+
+		pr_warn("heki-kvm: Locking GFN 0x%llx-0x%llx with %s%s\n",
 			gfn_start, gfn_end,
-			(attributes & HEKI_ATTR_MEM_NOWRITE) ? "[nowrite]" : "");
+			(attributes & HEKI_ATTR_MEM_NOWRITE) ? "[nowrite]" : "",
+			(attributes & HEKI_ATTR_MEM_EXEC) ? "[exec]" : "");
 	}
 
+	if (has_exec_restriction)
+		kvm_heki_fix_all_ept_exec_perm(kvm);
+
 out_free_ranges:
 	kfree(ranges);
 	return err;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 3e80a60ecbd8..2127e551202d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -282,6 +282,8 @@ int heki_check_cr(const struct kvm *kvm, unsigned long cr, unsigned long val);
 
 bool kvm_heki_is_exec_allowed(struct kvm_vcpu *vcpu, gpa_t gpa);
 
+bool heki_exec_is_allowed(const struct kvm *const kvm, const gfn_t gfn);
+
 #else /* CONFIG_HEKI */
 
 static inline int heki_check_cr(const struct kvm *const kvm,
@@ -290,6 +292,11 @@ static inline int heki_check_cr(const struct kvm *const kvm,
 	return 0;
 }
 
+static inline bool kvm_heki_is_exec_allowed(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	return true;
+}
+
 #endif /* CONFIG_HEKI */
 
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab9dc723bc89..82c7b02cbcc3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -812,9 +812,13 @@ struct kvm {
 #define HEKI_GFN_MAX 16
 	atomic_t heki_gfn_no_write_num;
 	struct heki_gfn_range heki_gfn_no_write[HEKI_GFN_MAX];
+	atomic_t heki_gfn_exec_last;
+	struct heki_gfn_range heki_gfn_exec[HEKI_GFN_MAX];
 
 	atomic_long_t heki_pinned_cr0;
 	atomic_long_t heki_pinned_cr4;
+
+	bool heki_kernel_exec_locked;
 #endif /* CONFIG_HEKI */
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4aea936dfe73..a177f8ff5123 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1232,6 +1232,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 #ifdef CONFIG_HEKI
 	atomic_set(&kvm->heki_gfn_no_write_num, HEKI_GFN_MAX + 1);
+	atomic_set(&kvm->heki_gfn_exec_last, HEKI_GFN_MAX + 1);
 #endif /* CONFIG_HEKI */
 
 	preempt_notifier_inc();
-- 
2.40.1

