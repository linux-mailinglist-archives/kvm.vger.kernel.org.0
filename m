Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB0F6F85B7
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbjEEP3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjEEP3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:29:38 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 May 2023 08:29:30 PDT
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF8D1435E
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:29:30 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QCZDD5yVJzMqDN2;
        Fri,  5 May 2023 17:22:04 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QCZDD0z6dzMpxBc;
        Fri,  5 May 2023 17:22:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1683300124;
        bh=numFKFwerBzb1GFmju5PzfUy3LvlXvoHGRlXH+KNT+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aY8puWEd6eYwOhiBC5f3v2W8STDFR1ws5t4KGxnuMkV/veHF5dk9ikWYLtZACCzKL
         ZZHQs/vJJkdeZe4WGYydF7qoNq+EgiNGsn5zsfWYHRSGNlObVxnWCaLzSzlH/rsRqO
         0NTmO3IcYiupEfrP7vmngHe/c3dwNtOvqClQ6aug=
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
Subject: [PATCH v1 7/9] KVM: VMX: Add MBEC support
Date:   Fri,  5 May 2023 17:20:44 +0200
Message-Id: <20230505152046.6575-8-mic@digikod.net>
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
Link: https://lore.kernel.org/r/20230505152046.6575-8-mic@digikod.net
---
 arch/x86/include/asm/vmx.h      | 11 +++++++++--
 arch/x86/kvm/mmu.h              |  3 ++-
 arch/x86/kvm/mmu/mmu.c          |  6 +++++-
 arch/x86/kvm/mmu/paging_tmpl.h  | 16 ++++++++++++++--
 arch/x86/kvm/mmu/spte.c         |  4 +++-
 arch/x86/kvm/vmx/capabilities.h |  7 +++++++
 arch/x86/kvm/vmx/nested.c       |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 28 +++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h          |  1 +
 9 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 498dc600bd5c..452e7d153832 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -511,6 +511,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_USER_EXECUTABLE_MASK		(1ull << 10)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
@@ -556,13 +557,19 @@ enum vm_entry_failure_code {
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
index 6bdaacb6faa0..3c4fd4618cc1 100644
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
index e5d1e241ff0f..a47e63217eb8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -27,6 +27,9 @@
 #include "cpuid.h"
 #include "spte.h"
 
+/* Required by paging_tmpl.h for enable_mbec */
+#include "../vmx/capabilities.h"
+
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -3763,7 +3766,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 */
 	pm_mask = PT_PRESENT_MASK | shadow_me_value;
 	if (mmu->root_role.level >= PT64_ROOT_4LEVEL) {
-		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK |
+			   PT_USER_EXEC_MASK;
 
 		if (WARN_ON_ONCE(!mmu->pml4_root)) {
 			r = -EIO;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0f6455072055..12119d519c77 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -498,8 +498,20 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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
index 639f220a1ed5..f1e2e3cad878 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -430,13 +430,15 @@ void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
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
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cd2ac9536c99..2cc5d7d20144 100644
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
 		SECONDARY_EXEC_XSAVES;
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
index d93c715cda6a..3c381c75e2a9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2317,6 +2317,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		/* VMCS shadowing for L2 is emulated for now */
 		exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
 
+		/* MBEC is currently only handled for L0. */
+		exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+
 		/*
 		 * Preset *DT exiting when emulating UMIP, so that vmx_set_cr4()
 		 * will not have to rewrite the controls just for this bit.
@@ -6870,6 +6873,10 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 	 */
 	msrs->secondary_ctls_low = 0;
 
+	/*
+	 * Currently, SECONDARY_EXEC_MODE_BASED_EPT_EXEC is only handled for
+	 * L0 and doesn't need to be exposed to L1 nor L2.
+	 */
 	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
 	msrs->secondary_ctls_high &=
 		SECONDARY_EXEC_DESC |
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 931688edc8eb..004fd4e5e057 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -94,6 +94,9 @@ bool __read_mostly enable_unrestricted_guest = 1;
 module_param_named(unrestricted_guest,
 			enable_unrestricted_guest, bool, S_IRUGO);
 
+bool __read_mostly enable_mbec = true;
+module_param_named(mbec, enable_mbec, bool, 0444);
+
 bool __read_mostly enable_ept_ad_bits = 1;
 module_param_named(eptad, enable_ept_ad_bits, bool, S_IRUGO);
 
@@ -4518,10 +4521,21 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
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
@@ -5658,7 +5672,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 
 static int handle_ept_violation(struct kvm_vcpu *vcpu)
 {
-	unsigned long exit_qualification;
+	unsigned long exit_qualification, rwx_mask;
 	gpa_t gpa;
 	u64 error_code;
 
@@ -5688,7 +5702,11 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
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
@@ -8345,6 +8363,9 @@ static __init int hardware_setup(void)
 	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
 		enable_unrestricted_guest = 0;
 
+	if (!cpu_has_vmx_mbec() || !enable_ept)
+		enable_mbec = false;
+
 	if (!cpu_has_vmx_flexpriority())
 		flexpriority_enabled = 0;
 
@@ -8404,7 +8425,8 @@ static __init int hardware_setup(void)
 
 	if (enable_ept)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
-				      cpu_has_vmx_ept_execute_only());
+				      cpu_has_vmx_ept_execute_only(),
+				      enable_mbec);
 
 	/*
 	 * Setup shadow_me_value/shadow_me_mask to include MKTME KeyID
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..815db44cd51e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -585,6 +585,7 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
+	 SECONDARY_EXEC_MODE_BASED_EPT_EXEC |				\
 	 SECONDARY_EXEC_ENCLS_EXITING)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
-- 
2.40.1

