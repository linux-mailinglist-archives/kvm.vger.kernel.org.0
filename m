Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBDF163590
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgBRV6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:58:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:52969 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbgBRV6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:58:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:58:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="436004640"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 13:58:32 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com
Cc:     hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        liran.alon@oracle.com, luto@kernel.org, joro@8bytes.org,
        rick.p.edgecombe@intel.com, kristen@linux.intel.com,
        arjan@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, John Andersen <john.s.andersen@intel.com>
Subject: [RFC v2 2/4] KVM: X86: Add CR pin MSRs
Date:   Tue, 18 Feb 2020 13:59:00 -0800
Message-Id: <20200218215902.5655-3-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200218215902.5655-1-john.s.andersen@intel.com>
References: <20200218215902.5655-1-john.s.andersen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a CR pin feature bit to the KVM cpuid. Add read only MSRs to KVM
which guests use to identify which bits they may request be pinned. Add
CR pinned MSRs to KVM. Allow guests to request that KVM pin certain
bits within control register 0 or 4 via the CR pinned MSRs. Writes to
the MSRs fail if they include bits which aren't allowed. Host userspace
may clear or modify pinned bits at any time. Once pinned bits are set,
the guest may pin additional allowed bits, but not clear any. Clear
pinning on vCPU reset.

In the event that the guest vCPU attempts to disable any of the pinned
bits, send that vCPU a general protection fault, and leave the register
unchanged. Entering SMM unconditionally clears various CR0/4 bits, some
of which may be pinned by the OS. To avoid triggering a fault during
SMIs, pinning isn't enforced when the vCPU is running in SMM. Upon
exiting SMM CR0/4 values are restored from SMRAM. kvm_pre_leave_smm
ensures CR0/4 values in SMRAM have pinned bits set appropriately before
restoration. Clearing pinning on vCPU reset avoids faulting when
non-boot CPUs are disabled and then re-enabled, which is done when
hibernating.

Should userspace expose the CR pinning CPUID feature bit, it must zero
CR pinned MSRs on reboot. If it does not, it runs the risk of having the
guest enable pinning and subsequently cause general protection faults on
next boot due to early boot code setting control registers to values
which do not contain the pinned bits. Userspace is responsible for
migrating the contents of the CR* pinned MSRs. If userspace fails to
migrate the MSRs the protection will no longer be active.

Pinning of sensitive CR bits has already been implemented to protect
against exploits directly calling native_write_cr*(). The current
protection cannot stop ROP attacks which jump directly to a MOV CR
instruction.

https://web.archive.org/web/20171029060939/http://www.blackbunny.io/linux-kernel-x86-64-bypass-smep-kaslr-kptr_restric/

Guests running with paravirtualized CR pinning can now be protected
against the use of ROP to disable CR bits. The same bits that are being
pinned natively may be pinned via the CR pinned MSRs. These bits are WP
in CR0, and SMEP, SMAP, and UMIP in CR4.

Other hypervisors such as HyperV have implemented similar protections
for Control Registers and MSRs; which security researchers have found
effective.

https://www.abatchy.com/2018/01/kernel-exploitation-4

Future work could implement similar MSRs to protect bits elsewhere, such
as MSRs. The NXE bit of the EFER MSR is a prime candidate.

Changes for QEMU are required to expose the CR pin cpuid feature bit. As
well as clear the MSRs on reboot and enable migration.

https://github.com/qemu/qemu/commit/e7a0ff8a8dcde1ef2b83a9d93129614f512752ae
https://github.com/qemu/qemu/commit/7e8c770c91616ae8d2d6b15bcc2865be594c8852

Signed-off-by: John Andersen <john.s.andersen@intel.com>
---
 Documentation/virt/kvm/msr.rst       |  38 ++++++++
 arch/x86/include/asm/kvm_host.h      |   2 +
 arch/x86/include/uapi/asm/kvm_para.h |   5 ++
 arch/x86/kvm/cpuid.c                 |   3 +-
 arch/x86/kvm/x86.c                   | 130 ++++++++++++++++++++++++++-
 5 files changed, 176 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index 33892036672d..075e15a2c246 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -319,3 +319,41 @@ data:
 
 	KVM guests can request the host not to poll on HLT, for example if
 	they are performing polling themselves.
+
+MSR_KVM_CR0_PIN_ALLOWED: 0x4b564d06
+MSR_KVM_CR4_PIN_ALLOWED: 0x4b564d07
+	Read only registers informing the guest which bits may be pinned for
+	each control register respectively via the CR pinned MSRs.
+
+	data: Bits which may be pinned.
+
+	Attempting to pin bits other than these will result in a failure when
+	writing to the respective CR pinned MSR.
+
+	Bits which are allowed to be pinned are WP for CR0 and SMEP, SMAP, and
+	UMIP for CR4.
+
+MSR_KVM_CR0_PINNED: 0x4b564d08
+MSR_KVM_CR4_PINNED: 0x4b564d09
+	Used to configure pinned bits in control registers
+
+	data: Bits to be pinned.
+
+	Fails if data contains bits which are not allowed to be pinned. Bits
+	which are allowed to be pinned can be found by reading the CR pin
+	allowed MSRs.
+
+	The MSRs are read/write for host userspace, and write-only for the
+	guest.
+
+	Once set to a non-zero value, the guest cannot clear any of the bits
+	that have been pinned to 1. The guest can set more bits to 1, so long
+	as those bits appear in the allowed MSR.
+
+	Host userspace may clear or change pinned bits at any point. Host
+	userspace must clear pinned bits on reboot.
+
+	The MSR enables bit pinning for control registers. Pinning is active
+	when the guest is not in SMM. If the guest attempts to write values to
+	cr* where bits differ from pinned bits, the write will fail and the
+	guest will be sent a general protection fault.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 40a0c0fd95ca..69625a18aa88 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -569,10 +569,12 @@ struct kvm_vcpu_arch {
 
 	unsigned long cr0;
 	unsigned long cr0_guest_owned_bits;
+	unsigned long cr0_pinned;
 	unsigned long cr2;
 	unsigned long cr3;
 	unsigned long cr4;
 	unsigned long cr4_guest_owned_bits;
+	unsigned long cr4_pinned;
 	unsigned long cr8;
 	u32 pkru;
 	u32 hflags;
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 2a8e0b6b9805..e6c61e455adf 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -31,6 +31,7 @@
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_CR_PIN		14
 
 #define KVM_HINTS_REALTIME      0
 
@@ -50,6 +51,10 @@
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
+#define MSR_KVM_CR0_PIN_ALLOWED	0x4b564d06
+#define MSR_KVM_CR4_PIN_ALLOWED	0x4b564d07
+#define MSR_KVM_CR0_PINNED	0x4b564d08
+#define MSR_KVM_CR4_PINNED	0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..94f0b2032524 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -716,7 +716,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
-			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
+			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_CR_PIN);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5d64ebc35d..2ee0e9886a6e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -733,6 +733,9 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(pdptrs_changed);
 
+#define KVM_CR0_PIN_ALLOWED	(X86_CR0_WP)
+#define KVM_CR4_PIN_ALLOWED	(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP)
+
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
@@ -753,6 +756,11 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
 		return 1;
 
+	if (!is_smm(vcpu)
+		&& vcpu->arch.cr0_pinned
+		&& ((cr0 ^ vcpu->arch.cr0_pinned) & KVM_CR0_PIN_ALLOWED))
+		return 1;
+
 	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 #ifdef CONFIG_X86_64
 		if ((vcpu->arch.efer & EFER_LME)) {
@@ -932,6 +940,11 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
 
+	if (!is_smm(vcpu)
+		&& vcpu->arch.cr4_pinned
+		&& ((cr4 ^ vcpu->arch.cr4_pinned) & KVM_CR4_PIN_ALLOWED))
+		return 1;
+
 	if (is_long_mode(vcpu)) {
 		if (!(cr4 & X86_CR4_PAE))
 			return 1;
@@ -1255,6 +1268,10 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
+	MSR_KVM_CR0_PIN_ALLOWED,
+	MSR_KVM_CR4_PIN_ALLOWED,
+	MSR_KVM_CR0_PINNED,
+	MSR_KVM_CR4_PINNED,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -2878,6 +2895,28 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+	case MSR_KVM_CR0_PIN_ALLOWED:
+	case MSR_KVM_CR4_PIN_ALLOWED:
+		if (report_ignored_msrs)
+			vcpu_debug_ratelimited(vcpu, "unhandled wrmsr: 0x%x data 0x%llx\n",
+				    msr, data);
+		break;
+	case MSR_KVM_CR0_PINNED:
+		if (data & ~KVM_CR0_PIN_ALLOWED)
+			return 1;
+		if (msr_info->host_initiated)
+			vcpu->arch.cr0_pinned = data;
+		else
+			vcpu->arch.cr0_pinned |= data;
+		break;
+	case MSR_KVM_CR4_PINNED:
+		if (data & ~KVM_CR4_PIN_ALLOWED)
+			return 1;
+		if (msr_info->host_initiated)
+			vcpu->arch.cr4_pinned = data;
+		else
+			vcpu->arch.cr4_pinned |= data;
+		break;
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3124,6 +3163,18 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KVM_POLL_CONTROL:
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+	case MSR_KVM_CR0_PIN_ALLOWED:
+		msr_info->data = KVM_CR0_PIN_ALLOWED;
+		break;
+	case MSR_KVM_CR4_PIN_ALLOWED:
+		msr_info->data = KVM_CR4_PIN_ALLOWED;
+		break;
+	case MSR_KVM_CR0_PINNED:
+		msr_info->data = vcpu->arch.cr0_pinned;
+		break;
+	case MSR_KVM_CR4_PINNED:
+		msr_info->data = vcpu->arch.cr4_pinned;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -6316,10 +6367,84 @@ static void emulator_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned emul_fla
 	emul_to_vcpu(ctxt)->arch.hflags = emul_flags;
 }
 
+static inline u64 restore_pinned(u64 val, u64 subset, u64 pinned)
+{
+	u64 pinned_high = pinned & subset;
+	u64 pinned_low = ~pinned & subset;
+
+	val |= pinned_high;
+	val &= ~pinned_low;
+
+	return val;
+}
+
+static void kvm_pre_leave_smm_32_restore_crX_pinned(struct kvm_vcpu *vcpu,
+						    const char *smstate,
+						    u16 offset,
+						    unsigned long allowed,
+						    unsigned long cr_pinned)
+{
+	u32 cr;
+
+	cr = GET_SMSTATE(u32, smstate, offset);
+	cr = (u32)restore_pinned(cr, allowed, cr_pinned);
+	put_smstate(u32, smstate, offset, cr);
+}
+
+static void kvm_pre_leave_smm_32_restore_cr_pinned(struct kvm_vcpu *vcpu,
+						   const char *smstate)
+{
+	if (vcpu->arch.cr0_pinned)
+		kvm_pre_leave_smm_32_restore_crX_pinned(vcpu, smstate, 0x7ffc,
+							KVM_CR0_PIN_ALLOWED,
+							vcpu->arch.cr0_pinned);
+
+	if (vcpu->arch.cr4_pinned)
+		kvm_pre_leave_smm_32_restore_crX_pinned(vcpu, smstate, 0x7f14,
+							KVM_CR4_PIN_ALLOWED,
+							vcpu->arch.cr4_pinned);
+}
+
+static void kvm_pre_leave_smm_64_restore_crX_pinned(struct kvm_vcpu *vcpu,
+						    const char *smstate,
+						    u16 offset,
+						    unsigned long allowed,
+						    unsigned long cr_pinned)
+{
+	u32 cr;
+
+	cr = GET_SMSTATE(u64, smstate, offset);
+	cr = restore_pinned(cr, allowed, cr_pinned);
+	put_smstate(u64, smstate, offset, cr);
+}
+
+static void kvm_pre_leave_smm_64_restore_cr_pinned(struct kvm_vcpu *vcpu,
+						   const char *smstate)
+{
+	if (vcpu->arch.cr0_pinned)
+		kvm_pre_leave_smm_64_restore_crX_pinned(vcpu, smstate, 0x7f58,
+							KVM_CR0_PIN_ALLOWED,
+							vcpu->arch.cr0_pinned);
+
+	if (vcpu->arch.cr4_pinned)
+		kvm_pre_leave_smm_64_restore_crX_pinned(vcpu, smstate, 0x7f48,
+							KVM_CR4_PIN_ALLOWED,
+							vcpu->arch.cr4_pinned);
+}
+
 static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
 				  const char *smstate)
 {
-	return kvm_x86_ops->pre_leave_smm(emul_to_vcpu(ctxt), smstate);
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
+#ifdef CONFIG_X86_64
+	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
+		kvm_pre_leave_smm_64_restore_cr_pinned(vcpu, smstate);
+	else
+#endif
+		kvm_pre_leave_smm_32_restore_cr_pinned(vcpu, smstate);
+
+	return kvm_x86_ops->pre_leave_smm(vcpu, smstate);
 }
 
 static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
@@ -9490,6 +9615,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.ia32_xss = 0;
 
+	vcpu->arch.cr0_pinned = 0;
+	vcpu->arch.cr4_pinned = 0;
+
 	kvm_x86_ops->vcpu_reset(vcpu, init_event);
 }
 
-- 
2.21.0

