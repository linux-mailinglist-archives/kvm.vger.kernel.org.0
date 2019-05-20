Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5225624033
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 20:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfETSWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 14:22:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:43805 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbfETSWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 14:22:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 11:22:13 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 20 May 2019 11:22:12 -0700
Date:   Mon, 20 May 2019 11:22:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: #VE support for VMI
Message-ID: <20190520182212.GC28482@linux.intel.com>
References: <571322cc13b98f3805a4843db28f5befbb1bd5a9.camel@bitdefender.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <571322cc13b98f3805a4843db28f5befbb1bd5a9.camel@bitdefender.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, May 20, 2019 at 06:48:09PM +0300, Mihai Donțu wrote:
> Hi Paolo,
> 
> We are looking at adding #VE support to the VMI subsystem we are
> working on. Its purpose is to suppress VMEXIT-s caused by the page
> table walker when the guest page tables are write-protected. A very
> small in-guest agent (protected by the hypervisor) will receive the EPT
> violation events, handle PT-walk writes and turn the rest into VMCALL-
> s.
> 
> A brief presentation of similar work on Xen can be found here:
> https://www.slideshare.net/xen_com_mgr/xpdss17-hypervisorbased-security-bringing-virtualized-exceptions-into-the-game-mihai-dontu-bitdefender
> 
> There is a bit of an issue with using #VE on KVM, though: because the
> EPT is built on-the-fly (as the guest runs), when we enable #VE in
> VMCS, all EPT violations become virtualized, because all EPTE-s have
> bit 63 zero (0: convert to #VE, 1: generate VMEXIT). At the moment, I
> see two solutions:
> 
> (a) have the in-guest agent generate a VMCALL that KVM will interpret
> as EPT-violation and call the default page fault handler;
> (b) populate the EPT completely before entering the guest;
> 
> The first one requires adding dedicated code for KVM in the agent used
> for handling #VE events, something we are trying to avoid. The second
> one has implications we can't fully see, besides migration with which
> we don't interact (VMI is designed to be disabled before migration
> starts, implicitly #VE too).
> 
> I would appreciate any opinion / suggestion you have on a proper
> approach to this issue.

(c) set suppress #VE for cleared EPT entries

The attached patches are compile tested only, are missing the actual
#VE enabling, and are 64-bit only, but the underlying concept has been
tested.  The code is from a PoC for unrelated #VE shenanigans, so
there's a non-zero chance I missed something important when porting the
code (the source branch is a bit messy).

--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-KVM-VMX-Define-EPT-suppress-VE-bit-bit-63-in-EPT-lea.patch"

From 2be83e13b70aba781a2c2549cf2cfb80ae6366bd Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Thu, 18 Jan 2018 13:03:04 -0800
Subject: [PATCH 1/2] KVM: VMX: Define EPT suppress #VE bit (bit 63 in EPT leaf
 entries)

VMX provides a capability that allows EPT violations to be reflected
into the guest as Virtualization Exceptions (#VE).  The primary use case
of EPT violation #VEs is to improve the performance of virtualization-
based security solutions, e.g. eliminate a VM-Exit -> VM-Exit roundtrip
when utilizing EPT to protect priveleged data structures or code.

The "Suppress #VE" bit allows a VMM to opt-out of EPT violation #VEs on
a per page basis, e.g. when a page is marked not-present due to lazy
installation or is write-protected for dirty page logging.

The "Suppress #VE" bit is ignored:

  - By hardware that does not support EPT violation #VEs
  - When the EPT violation #VE VMCS control is disabled
  - On non-leaf EPT entries

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/vmx.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4e4133e86484..af52d6aa134a 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -501,6 +501,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
-- 
2.21.0


--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-KVM-VMX-Suppress-EPT-violation-VE-by-default-when-en.patch"

From 63771776cef6474bf6e61b7fc55f43f51bf757c8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Tue, 23 Jan 2018 11:43:27 -0800
Subject: [PATCH 2/2] KVM: VMX: Suppress EPT violation #VE by default (when
 enabled)

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
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/Makefile           |  2 +-
 arch/x86/kvm/mmu.c              | 23 ++++++++++++++++-------
 arch/x86/kvm/mmu.h              |  1 +
 arch/x86/kvm/svm.c              |  1 +
 arch/x86/kvm/vmx/clear_page.S   | 17 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 20 +++++++++++++++++---
 7 files changed, 54 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/clear_page.S

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d5457c7bb243..b7caf5dcd977 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1061,6 +1061,7 @@ struct kvm_x86_ops {
 	 * the implementation may choose to ignore if appropriate.
 	 */
 	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
+	void (*clear_page)(void *page);
 
 	void (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31ecf7a76d5a..d1594742b035 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -12,7 +12,7 @@ kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o page_track.o debugfs.o
 
-kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
+kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o vmx/clear_page.o
 kvm-amd-y		+= svm.o pmu_amd.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1e9ba81accba..3f8bb14a8a69 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -223,6 +223,8 @@ static u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_present_mask;
 static u64 __read_mostly shadow_me_mask;
 
+static u64 __read_mostly shadow_init_value;
+
 /*
  * SPTEs used by MMUs without A/D bits are marked with shadow_acc_track_value.
  * Non-present SPTEs with shadow_acc_track_value set are in place for access
@@ -471,6 +473,12 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 
+void kvm_mmu_set_spte_init_value(u64 init_value)
+{
+	shadow_init_value = init_value;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_spte_init_value);
+
 static void kvm_mmu_reset_all_pte_masks(void)
 {
 	u8 low_phys_bits;
@@ -483,6 +491,7 @@ static void kvm_mmu_reset_all_pte_masks(void)
 	shadow_mmio_mask = 0;
 	shadow_present_mask = 0;
 	shadow_acc_track_mask = 0;
+	shadow_init_value = 0;
 
 	/*
 	 * If the CPU has 46 or less physical address bits, then set an
@@ -522,7 +531,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
 
 static int is_shadow_present_pte(u64 pte)
 {
-	return (pte != 0) && !is_mmio_spte(pte);
+	return (pte != 0 && pte != shadow_init_value && !is_mmio_spte(pte));
 }
 
 static int is_large_pte(u64 pte)
@@ -833,9 +842,9 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 	u64 old_spte = *sptep;
 
 	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, 0ull);
+		__update_clear_spte_fast(sptep, shadow_init_value);
 	else
-		old_spte = __update_clear_spte_slow(sptep, 0ull);
+		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
 
 	if (!is_shadow_present_pte(old_spte))
 		return 0;
@@ -865,7 +874,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
  */
 static void mmu_spte_clear_no_track(u64 *sptep)
 {
-	__update_clear_spte_fast(sptep, 0ull);
+	__update_clear_spte_fast(sptep, shadow_init_value);
 }
 
 static u64 mmu_spte_get_lockless(u64 *sptep)
@@ -2499,7 +2508,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
-	clear_page(sp->spt);
+	kvm_x86_ops->clear_page(sp->spt);
 	trace_kvm_mmu_get_page(sp, true);
 
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
@@ -3370,7 +3379,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
 	bool fault_handled = false;
-	u64 spte = 0ull;
+	u64 spte = shadow_init_value;
 	uint retry_count = 0;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
@@ -3872,7 +3881,7 @@ static bool
 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = 0ull;
+	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = shadow_init_value;
 	int root, leaf;
 	bool reserved = false;
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 54c2a377795b..9447e97d01c7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -52,6 +52,7 @@ static inline u64 rsvd_bits(int s, int e)
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value);
+void kvm_mmu_set_spte_init_value(u64 init_value);
 
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f56be17ddf9b..8526b3c08541 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7211,6 +7211,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.tlb_flush = svm_flush_tlb,
 	.tlb_flush_gva = svm_flush_tlb_gva,
+	.clear_page = clear_page,
 
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
diff --git a/arch/x86/kvm/vmx/clear_page.S b/arch/x86/kvm/vmx/clear_page.S
new file mode 100644
index 000000000000..c48d9b6055ae
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
+ENTRY(vmx_suppress_ve_clear_page)
+	movl $4096/8,%ecx
+	movabsq $0x8000000000000000,%rax
+	rep stosq
+	ret
+ENDPROC(vmx_suppress_ve_clear_page)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0861c71a4379..82a345551790 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -117,6 +117,9 @@ module_param_named(pml, enable_pml, bool, S_IRUGO);
 static bool __read_mostly dump_invalid_vmcs = 0;
 module_param(dump_invalid_vmcs, bool, 0644);
 
+static bool __read_mostly ept_violation_ve;
+module_param(ept_violation_ve, bool, 0444);
+
 #define MSR_BITMAP_MODE_X2APIC		1
 #define MSR_BITMAP_MODE_X2APIC_APICV	2
 
@@ -5254,14 +5257,24 @@ static void wakeup_handler(void)
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
+	if (ept_violation_ve) {
+		p_mask |= VMX_EPT_SUPPRESS_VE_BIT;
+		kvm_mmu_set_spte_init_value(VMX_EPT_SUPPRESS_VE_BIT);
+		kvm_x86_ops->clear_page = vmx_suppress_ve_clear_page;
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
 	kvm_enable_tdp();
@@ -7636,6 +7649,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.tlb_flush = vmx_flush_tlb,
 	.tlb_flush_gva = vmx_flush_tlb_gva,
+	.clear_page = clear_page,
 
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
-- 
2.21.0


--Qxx1br4bt0+wmkIi--
