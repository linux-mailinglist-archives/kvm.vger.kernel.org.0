Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00A9229C98
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgGVQB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:57 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37952 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729642AbgGVQBl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:41 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id AF338305D76D;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A48B7305FFA9;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 22/34] KVM: VMX: Suppress EPT violation #VE by default (when enabled)
Date:   Wed, 22 Jul 2020 19:01:09 +0300
Message-Id: <20200722160121.9601-23-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Unfortunately (for software), EPT violation #VEs are opt-out on a per
page basis, e.g. a not-present EPT violation on a zeroed EPT entry will
be morphed to a #VE due to the "suppress #VE" bit not being set.

When EPT violation #VEs are enabled, use a variation of clear_page()
that sets bit 63 (suppress #VE) in all 8-byte entries.  To wire up the
new behavior in the x86 MMU, add a new kvm_x86_ops hook and a new mask
to define a "shadow init value", which is needed to express the concept
that a cleared spte has a non-zero value when EPT violation #VEs are in
use.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/Makefile           |  2 +-
 arch/x86/kvm/mmu.h              |  1 +
 arch/x86/kvm/mmu/mmu.c          | 22 +++++++++++++++-------
 arch/x86/kvm/vmx/clear_page.S   | 17 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 18 +++++++++++++++---
 6 files changed, 50 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/clear_page.S

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a9f225f9dd12..e89cea041ec9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1168,6 +1168,7 @@ struct kvm_x86_ops {
 	 * the implementation may choose to ignore if appropriate.
 	 */
 	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
+	void (*clear_page)(void *page);
 
 	/*
 	 * Flush any TLB entries created by the guest.  Like tlb_flush_gva(),
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 3cfe76299dee..b5972a3fdfee 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -19,7 +19,7 @@ kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
 
-kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
+kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o vmx/clear_page.o
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2692b14fb605..02fa0d30407f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -52,6 +52,7 @@ static inline u64 rsvd_bits(int s, int e)
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask);
+void kvm_mmu_set_spte_init_value(u64 init_value);
 
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 22c83192bba1..810e22f41306 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -253,6 +253,7 @@ static u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_mmio_access_mask;
 static u64 __read_mostly shadow_present_mask;
 static u64 __read_mostly shadow_me_mask;
+static u64 __read_mostly shadow_init_value;
 
 /*
  * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
@@ -542,6 +543,12 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 
+void kvm_mmu_set_spte_init_value(u64 init_value)
+{
+	shadow_init_value = init_value;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_spte_init_value);
+
 static u8 kvm_get_shadow_phys_bits(void)
 {
 	/*
@@ -572,6 +579,7 @@ static void kvm_mmu_reset_all_pte_masks(void)
 	shadow_x_mask = 0;
 	shadow_present_mask = 0;
 	shadow_acc_track_mask = 0;
+	shadow_init_value = 0;
 
 	shadow_phys_bits = kvm_get_shadow_phys_bits();
 
@@ -612,7 +620,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
 
 static int is_shadow_present_pte(u64 pte)
 {
-	return (pte != 0) && !is_mmio_spte(pte);
+	return (pte != 0) && pte != shadow_init_value && !is_mmio_spte(pte);
 }
 
 static int is_large_pte(u64 pte)
@@ -923,9 +931,9 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 	u64 old_spte = *sptep;
 
 	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, 0ull);
+		__update_clear_spte_fast(sptep, shadow_init_value);
 	else
-		old_spte = __update_clear_spte_slow(sptep, 0ull);
+		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
 
 	if (!is_shadow_present_pte(old_spte))
 		return 0;
@@ -955,7 +963,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
  */
 static void mmu_spte_clear_no_track(u64 *sptep)
 {
-	__update_clear_spte_fast(sptep, 0ull);
+	__update_clear_spte_fast(sptep, shadow_init_value);
 }
 
 static u64 mmu_spte_get_lockless(u64 *sptep)
@@ -2660,7 +2668,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (level > PG_LEVEL_4K && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
-	clear_page(sp->spt);
+	kvm_x86_ops.clear_page(sp->spt);
 	trace_kvm_mmu_get_page(sp, true);
 
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
@@ -3637,7 +3645,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
 	bool fault_handled = false;
-	u64 spte = 0ull;
+	u64 spte = shadow_init_value;
 	uint retry_count = 0;
 
 	if (!page_fault_can_be_fast(error_code))
@@ -4073,7 +4081,7 @@ static bool
 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = 0ull;
+	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = shadow_init_value;
 	struct rsvd_bits_validate *rsvd_check;
 	int root, leaf;
 	bool reserved = false;
diff --git a/arch/x86/kvm/vmx/clear_page.S b/arch/x86/kvm/vmx/clear_page.S
new file mode 100644
index 000000000000..89fcf5697391
--- /dev/null
+++ b/arch/x86/kvm/vmx/clear_page.S
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+
+/*
+ * "Clear" an EPT page when EPT violation #VEs are enabled, in which case the
+ * suppress #VE bit needs to be set for all unused entries.
+ *
+ * %rdi	- page
+ */
+#define VMX_EPT_SUPPRESS_VE_BIT (1ull << 63)
+
+SYM_FUNC_START(vmx_suppress_ve_clear_page)
+	movl $4096/8,%ecx
+	movabsq $0x8000000000000000,%rax
+	rep stosq
+	ret
+SYM_FUNC_END(vmx_suppress_ve_clear_page)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c1dda14d18d..3428857c6157 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5639,14 +5639,24 @@ static void wakeup_handler(void)
 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 }
 
+void vmx_suppress_ve_clear_page(void *page);
+
 static void vmx_enable_tdp(void)
 {
+	u64 p_mask = 0;
+
+	if (!cpu_has_vmx_ept_execute_only())
+		p_mask |= VMX_EPT_READABLE_MASK;
+	if (kvm_ve_supported) {
+		p_mask |= VMX_EPT_SUPPRESS_VE_BIT;
+		kvm_mmu_set_spte_init_value(VMX_EPT_SUPPRESS_VE_BIT);
+		kvm_x86_ops.clear_page = vmx_suppress_ve_clear_page;
+	}
+
 	kvm_mmu_set_mask_ptes(VMX_EPT_READABLE_MASK,
 		enable_ept_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull,
 		enable_ept_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull,
-		0ull, VMX_EPT_EXECUTABLE_MASK,
-		cpu_has_vmx_ept_execute_only() ? 0ull : VMX_EPT_READABLE_MASK,
-		VMX_EPT_RWX_MASK, 0ull);
+		0ull, VMX_EPT_EXECUTABLE_MASK, p_mask, VMX_EPT_RWX_MASK, 0ull);
 
 	ept_set_mmio_spte_mask();
 }
@@ -8238,6 +8248,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.tlb_flush_gva = vmx_flush_tlb_gva,
 	.tlb_flush_guest = vmx_flush_tlb_guest,
 
+	.clear_page = clear_page,
+
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
