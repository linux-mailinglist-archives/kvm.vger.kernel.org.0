Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32823127211
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 01:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfLTANb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 19:13:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:64772 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbfLTANb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 19:13:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 16:13:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,333,1571727600"; 
   d="scan'208";a="241340281"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga004.fm.intel.com with ESMTP; 19 Dec 2019 16:13:29 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     kvm@vger.kernel.org
Cc:     John Andersen <john.s.andersen@intel.com>
Subject: [RFC 1/2] KVM: X86: Add CR pin MSRs
Date:   Thu, 19 Dec 2019 16:13:21 -0800
Message-Id: <20191220001322.22317-2-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220001322.22317-1-john.s.andersen@intel.com>
References: <20191220001322.22317-1-john.s.andersen@intel.com>
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
the guest may pin additional allowed bits, but not clear any. The guest
may never read pinned bits. If an attacker were to read the CR pinned
MSRs, they might decide to preform another attack which would not cause
a general protection fault.

In the event that the guest vcpu attempts to disable any of the pinned
bits, send that vcpu a general protection fault, and leave the register
unchanged. Entering SMM unconditionally clears various CR0/4 bits, some
of which may be pinned by the OS. To avoid trigerring shutdown on SMIs,
pinning isn't enforced when the vCPU is running in SMM.

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

Guests running with paravirtualized CR pinning are now protected against
the use of ROP to disable CR bits. The same bits that are being pinned
natively may be pinned via the CR pinned MSRs. These bits are WP in CR0,
and SMEP, SMAP, and UMIP in CR4.

Other hypervisors such as HyperV have implemented similar protections
for Control Registers and MSRs; which security researchers have found
effective.

https://www.abatchy.com/2018/01/kernel-exploitation-4

Future patches could implement similar MSR and hypercall combinations
to protect bits in MSRs. The NXE bit of the EFER MSR is a prime
candidate.

Patches for QEMU are required to expose the CR pin cpuid feature bit. As
well as clear the MSRs on reboot and enable migration.

https://github.com/qemu/qemu/commit/e7a0ff8a8dcde1ef2b83a9d93129614f512752ae
https://github.com/qemu/qemu/commit/7e8c770c91616ae8d2d6b15bcc2865be594c8852

Signed-off-by: John Andersen <john.s.andersen@intel.com>
---
 Documentation/virt/kvm/msr.txt       | 38 +++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h      |  2 ++
 arch/x86/include/uapi/asm/kvm_para.h |  5 ++++
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/x86.c                   | 45 ++++++++++++++++++++++++++++
 5 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/msr.txt b/Documentation/virt/kvm/msr.txt
index df1f4338b3ca..c78efd5bcfc1 100644
--- a/Documentation/virt/kvm/msr.txt
+++ b/Documentation/virt/kvm/msr.txt
@@ -282,3 +282,41 @@ MSR_KVM_POLL_CONTROL: 0x4b564d05
 	KVM guests can request the host not to poll on HLT, for example if
 	they are performing polling themselves.
 
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
+
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b79cd6aa4075..ee8da4191920 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -562,10 +562,12 @@ struct kvm_vcpu_arch {
 
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
index cfafa320a8cf..19fb49753442 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -712,7 +712,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
-			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
+			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_CR_PIN);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ed167e039e5..eb1640ada8b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -753,6 +753,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
 		return 1;
 
+	if (!is_smm(vcpu) && (cr0 ^ old_cr0) & vcpu->arch.cr0_pinned)
+		return 1;
+
 	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 #ifdef CONFIG_X86_64
 		if ((vcpu->arch.efer & EFER_LME)) {
@@ -916,6 +919,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
 
+	if (!is_smm(vcpu) && (cr4 ^ old_cr4) & vcpu->arch.cr4_pinned)
+		return 1;
+
 	if (is_long_mode(vcpu)) {
 		if (!(cr4 & X86_CR4_PAE))
 			return 1;
@@ -1234,6 +1240,10 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
+	MSR_KVM_CR0_PIN_ALLOWED,
+	MSR_KVM_CR4_PIN_ALLOWED,
+	MSR_KVM_CR0_PINNED,
+	MSR_KVM_CR4_PINNED,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -2621,6 +2631,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time));
 }
 
+#define KVM_CR0_PIN_ALLOWED	(X86_CR0_WP)
+#define KVM_CR4_PIN_ALLOWED	(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP)
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	bool pr = false;
@@ -2811,6 +2824,22 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
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
@@ -3054,6 +3083,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
+		if (!msr_info->host_initiated)
+			return 1;
+		msr_info->data = vcpu->arch.cr0_pinned;
+		break;
+	case MSR_KVM_CR4_PINNED:
+		if (!msr_info->host_initiated)
+			return 1;
+		msr_info->data = vcpu->arch.cr4_pinned;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
-- 
2.21.0

