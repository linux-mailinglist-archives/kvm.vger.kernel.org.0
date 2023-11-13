Return-Path: <kvm+bounces-1548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69BBA7E94E1
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDD8E1F20D4B
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691BD847B;
	Mon, 13 Nov 2023 02:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="fY1T43fQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01B7C153
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:31:58 +0000 (UTC)
Received: from smtp-8faf.mail.infomaniak.ch (smtp-8faf.mail.infomaniak.ch [IPv6:2001:1600:3:17::8faf])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA18ED42
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:31:52 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCt645CMzMpyLN;
	Mon, 13 Nov 2023 02:24:14 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCt50b6fz3W;
	Mon, 13 Nov 2023 03:24:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842254;
	bh=1rCZlaZ8yKqXCX830pyMWcBESjd8hIo3B7pvzokyEX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fY1T43fQ69r5j3aWJFjq32XSu4yZEZYI2E+LP9K18ORFFEtvxB8OTkhmOFB9B8xuU
	 0sUkkutgL0KW5fBpSGVrCuj44f5CvbVH1lhuXp8SKoBYGSQSdqzxDgnfSd+jhoS0Th
	 q4yvQzmeGfq3TKnbmej2xh2UjKNCfj2BICLeWDYg=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 05/19] KVM: VMX: Add MBEC support
Date: Sun, 12 Nov 2023 21:23:12 -0500
Message-ID: <20231113022326.24388-6-mic@digikod.net>
In-Reply-To: <20231113022326.24388-1-mic@digikod.net>
References: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

This changes add support for VMX_FEATURE_MODE_BASED_EPT_EXEC (named
ept_mode_based_exec in /proc/cpuinfo and MBEC elsewhere), which enables
to separate EPT execution bits for supervisor vs. user.  It transforms
the semantic of VMX_EPT_EXECUTABLE_MASK from a global execution to a
kernel execution, and use the VMX_EPT_USER_EXECUTABLE_MASK bit to
identify user execution.

The main use case is to be able to restrict kernel execution while
ignoring user space execution from the hypervisor point of view.
Indeed, user space execution can already be restricted by the guest
kernel.

This change enables MBEC but doesn't change the default configuration,
which is to allow execution for all guest memory.  However, the next
commit levages MBEC to restrict kernel memory pages.

MBEC can be configured with the new "enable_mbec" module parameter, set
to true by default.  However, MBEC is disable for L1 and L2 for now.

The MMU tracepoints are updated to reflect the difference between kernel
and user space executions, see is_executable_pte().

Replace EPT_VIOLATION_RWX_MASK (3 bits) with 4 dedicated
EPT_VIOLATION_READ, EPT_VIOLATION_WRITE, EPT_VIOLATION_KERNEL_INSTR, and
EPT_VIOLATION_USER_INSTR bits.

From the Intel 64 and IA-32 Architectures Software Developer's Manual,
Volume 3C (System Programming Guide), Part 3:

SECONDARY_EXEC_MODE_BASED_EPT_EXEC (bit 22):
If either the "unrestricted guest" VM-execution control or the
"mode-based execute control for EPT" VM-execution control is 1, the
"enable EPT" VM-execution control must also be 1.

EPT_VIOLATION_KERNEL_INSTR_BIT (bit 5):
The logical-AND of bit 2 in the EPT paging-structure entries used to
translate the guest-physical address of the access causing the EPT
violation.  If the "mode-based execute control for EPT" VM-execution
control is 0, this indicates whether the guest-physical address was
executable. If that control is 1, this indicates whether the
guest-physical address was executable for supervisor-mode linear
addresses.

EPT_VIOLATION_USER_INSTR_BIT (bit 6):
If the "mode-based execute control" VM-execution control is 0, the value
of this bit is undefined. If that control is 1, this bit is the
logical-AND of bit 10 in the EPT paging-structures entries used to
translate the guest-physical address of the access causing the EPT
violation. In this case, it indicates whether the guest-physical address
was executable for user-mode linear addresses.

PT_USER_EXEC_MASK (bit 10):
Execute access for user-mode linear addresses. If the "mode-based
execute control for EPT" VM-execution control is 1, indicates whether
instruction fetches are allowed from user-mode linear addresses in the
512-GByte region controlled by this entry. If that control is 0, this
bit is ignored.

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
---

Changes since v1:
* Import the MMU tracepoint changes from the v1's "Enable guests to lock
  themselves thanks to MBEC" patch.
---
 arch/x86/include/asm/vmx.h      | 11 +++++++++--
 arch/x86/kvm/mmu.h              |  3 ++-
 arch/x86/kvm/mmu/mmu.c          |  8 ++++++--
 arch/x86/kvm/mmu/mmutrace.h     | 11 +++++++----
 arch/x86/kvm/mmu/paging_tmpl.h  | 16 ++++++++++++++--
 arch/x86/kvm/mmu/spte.c         |  4 +++-
 arch/x86/kvm/mmu/spte.h         | 15 +++++++++++++--
 arch/x86/kvm/vmx/capabilities.h |  7 +++++++
 arch/x86/kvm/vmx/nested.c       |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 29 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h          |  1 +
 11 files changed, 95 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0e73616b82f3..7fd390484b36 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -513,6 +513,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_USER_EXECUTABLE_MASK		(1ull << 10)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
@@ -558,13 +559,19 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_ACC_READ_BIT	0
 #define EPT_VIOLATION_ACC_WRITE_BIT	1
 #define EPT_VIOLATION_ACC_INSTR_BIT	2
-#define EPT_VIOLATION_RWX_SHIFT		3
+#define EPT_VIOLATION_READ_BIT		3
+#define EPT_VIOLATION_WRITE_BIT		4
+#define EPT_VIOLATION_KERNEL_INSTR_BIT	5
+#define EPT_VIOLATION_USER_INSTR_BIT	6
 #define EPT_VIOLATION_GVA_IS_VALID_BIT	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
 #define EPT_VIOLATION_ACC_INSTR		(1 << EPT_VIOLATION_ACC_INSTR_BIT)
-#define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
+#define EPT_VIOLATION_READ		(1 << EPT_VIOLATION_READ_BIT)
+#define EPT_VIOLATION_WRITE		(1 << EPT_VIOLATION_WRITE_BIT)
+#define EPT_VIOLATION_KERNEL_INSTR	(1 << EPT_VIOLATION_KERNEL_INSTR_BIT)
+#define EPT_VIOLATION_USER_INSTR	(1 << EPT_VIOLATION_USER_INSTR_BIT)
 #define EPT_VIOLATION_GVA_IS_VALID	(1 << EPT_VIOLATION_GVA_IS_VALID_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 253fb2093d5d..65168d3a4e31 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -24,6 +24,7 @@ extern bool __read_mostly enable_mmio_caching;
 #define PT_PAGE_SIZE_MASK (1ULL << PT_PAGE_SIZE_SHIFT)
 #define PT_PAT_MASK (1ULL << 7)
 #define PT_GLOBAL_MASK (1ULL << 8)
+#define PT_USER_EXEC_MASK (1ULL << 10)
 #define PT64_NX_SHIFT 63
 #define PT64_NX_MASK (1ULL << PT64_NX_SHIFT)
 
@@ -102,7 +103,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only, bool has_mbec);
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index baeba8fc1c38..7e053973125c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -29,6 +29,9 @@
 #include "cpuid.h"
 #include "spte.h"
 
+/* Required by paging_tmpl.h for enable_mbec */
+#include "../vmx/capabilities.h"
+
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -3410,7 +3413,7 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu,
 static bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
 {
 	if (fault->exec)
-		return is_executable_pte(spte);
+		return is_executable_pte(spte, !fault->user);
 
 	if (fault->write)
 		return is_writable_pte(spte);
@@ -3852,7 +3855,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 */
 	pm_mask = PT_PRESENT_MASK | shadow_me_value;
 	if (mmu->root_role.level >= PT64_ROOT_4LEVEL) {
-		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK |
+			   PT_USER_EXEC_MASK;
 
 		if (WARN_ON_ONCE(!mmu->pml4_root)) {
 			r = -EIO;
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
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c85255073f67..08f0c8d28245 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -510,8 +510,20 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 * Note, pte_access holds the raw RWX bits from the EPTE, not
 		 * ACC_*_MASK flags!
 		 */
-		vcpu->arch.exit_qualification |= (pte_access & VMX_EPT_RWX_MASK) <<
-						 EPT_VIOLATION_RWX_SHIFT;
+		vcpu->arch.exit_qualification |=
+			!!(pte_access & VMX_EPT_READABLE_MASK)
+			<< EPT_VIOLATION_READ_BIT;
+		vcpu->arch.exit_qualification |=
+			!!(pte_access & VMX_EPT_WRITABLE_MASK)
+			<< EPT_VIOLATION_WRITE_BIT;
+		vcpu->arch.exit_qualification |=
+			!!(pte_access & VMX_EPT_EXECUTABLE_MASK)
+			<< EPT_VIOLATION_KERNEL_INSTR_BIT;
+		if (enable_mbec) {
+			vcpu->arch.exit_qualification |=
+				!!(pte_access & VMX_EPT_USER_EXECUTABLE_MASK)
+				<< EPT_VIOLATION_USER_INSTR_BIT;
+		}
 	}
 #endif
 	walker->fault.address = addr;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..386cc1e8aab9 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -422,13 +422,15 @@ void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_me_spte_mask);
 
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only, bool has_mbec)
 {
 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
 	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
+	if (has_mbec)
+		shadow_x_mask |= VMX_EPT_USER_EXECUTABLE_MASK;
 	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
 	/*
 	 * EPT overrides the host MTRRs, and so KVM must program the desired
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a129951c9a88..2f402f81ee15 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -3,8 +3,11 @@
 #ifndef KVM_X86_MMU_SPTE_H
 #define KVM_X86_MMU_SPTE_H
 
+#include <asm/vmx.h>
+
 #include "mmu.h"
 #include "mmu_internal.h"
+#include "../vmx/vmx.h"
 
 /*
  * A MMU present SPTE is backed by actual memory and may or may not be present
@@ -320,9 +323,17 @@ static inline bool is_last_spte(u64 pte, int level)
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
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..70bd38645680 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -13,6 +13,7 @@ extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
 extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
+extern bool __read_mostly enable_mbec;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
 extern bool __read_mostly enable_ipiv;
@@ -255,6 +256,12 @@ static inline bool cpu_has_vmx_xsaves(void)
 		SECONDARY_EXEC_ENABLE_XSAVES;
 }
 
+static inline bool cpu_has_vmx_mbec(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+}
+
 static inline bool cpu_has_vmx_waitpkg(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..23a0341729d6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2324,6 +2324,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		/* VMCS shadowing for L2 is emulated for now */
 		exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
 
+		/* MBEC is currently only handled for L0. */
+		exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+
 		/*
 		 * Preset *DT exiting when emulating UMIP, so that vmx_set_cr4()
 		 * will not have to rewrite the controls just for this bit.
@@ -6863,6 +6866,10 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
 {
 	msrs->secondary_ctls_low = 0;
 
+	/*
+	 * Currently, SECONDARY_EXEC_MODE_BASED_EPT_EXEC is only handled for
+	 * L0 and doesn't need to be exposed to L1 nor L2.
+	 */
 	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
 	msrs->secondary_ctls_high &=
 		SECONDARY_EXEC_DESC |
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b631b1d7ba30..1b1581f578b0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -94,6 +94,10 @@ bool __read_mostly enable_unrestricted_guest = 1;
 module_param_named(unrestricted_guest,
 			enable_unrestricted_guest, bool, S_IRUGO);
 
+bool __read_mostly enable_mbec = true;
+EXPORT_SYMBOL_GPL(enable_mbec);
+module_param_named(mbec, enable_mbec, bool, 0444);
+
 bool __read_mostly enable_ept_ad_bits = 1;
 module_param_named(eptad, enable_ept_ad_bits, bool, S_IRUGO);
 
@@ -4596,10 +4600,21 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
 	if (!enable_ept) {
 		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
+		/*
+		 * From Intel's SDM:
+		 * If either the "unrestricted guest" VM-execution control or
+		 * the "mode-based execute control for EPT" VM-execution
+		 * control is 1, the "enable EPT" VM-execution control must
+		 * also be 1.
+		 */
 		enable_unrestricted_guest = 0;
+		enable_mbec = false;
 	}
 	if (!enable_unrestricted_guest)
 		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
+	if (!enable_mbec)
+		exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+
 	if (kvm_pause_in_guest(vmx->vcpu.kvm))
 		exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
 	if (!kvm_vcpu_apicv_active(vcpu))
@@ -5742,7 +5757,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 
 static int handle_ept_violation(struct kvm_vcpu *vcpu)
 {
-	unsigned long exit_qualification;
+	unsigned long exit_qualification, rwx_mask;
 	gpa_t gpa;
 	u64 error_code;
 
@@ -5772,7 +5787,11 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
 		      ? PFERR_FETCH_MASK : 0;
 	/* ept page table entry is present? */
-	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
+	rwx_mask = EPT_VIOLATION_READ | EPT_VIOLATION_WRITE |
+		   EPT_VIOLATION_KERNEL_INSTR;
+	if (enable_mbec)
+		rwx_mask |= EPT_VIOLATION_USER_INSTR;
+	error_code |= (exit_qualification & rwx_mask)
 		      ? PFERR_PRESENT_MASK : 0;
 
 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
@@ -8475,6 +8494,9 @@ static __init int hardware_setup(void)
 	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
 		enable_unrestricted_guest = 0;
 
+	if (!cpu_has_vmx_mbec() || !enable_ept)
+		enable_mbec = false;
+
 	if (!cpu_has_vmx_flexpriority())
 		flexpriority_enabled = 0;
 
@@ -8533,7 +8555,8 @@ static __init int hardware_setup(void)
 
 	if (enable_ept)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
-				      cpu_has_vmx_ept_execute_only());
+				      cpu_has_vmx_ept_execute_only(),
+				      enable_mbec);
 
 	/*
 	 * Setup shadow_me_value/shadow_me_mask to include MKTME KeyID
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24..882add2412e6 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -572,6 +572,7 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
+	 SECONDARY_EXEC_MODE_BASED_EPT_EXEC |				\
 	 SECONDARY_EXEC_ENCLS_EXITING)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
-- 
2.42.1


