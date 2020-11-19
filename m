Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136CA2B8EBB
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 10:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgKSJ1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 04:27:34 -0500
Received: from mga04.intel.com ([192.55.52.120]:20996 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgKSJ1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 04:27:33 -0500
IronPort-SDR: UO349H9U/89KrqdZCWmxXiPW0OA8ziyPaTJDJiVhMkGlbIbxGxDAac6ZKH4V3g7WMK6GMZdNBd
 vMkiUE95ACkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="168688341"
X-IronPort-AV: E=Sophos;i="5.77,490,1596524400"; 
   d="scan'208";a="168688341"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 01:27:32 -0800
IronPort-SDR: wf30peE+SOF/QYcS/nygh5jnvy6VW04yMiCwl03jQ2sJRqF4AdbyNJI73lyRl5+xzgl5JAwYJM
 849+mdTgtu1A==
X-IronPort-AV: E=Sophos;i="5.77,490,1596524400"; 
   d="scan'208";a="544939808"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 01:27:29 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] KVM: X86: Add support for the emulation of DR6_BUS_LOCK bit
Date:   Thu, 19 Nov 2020 17:29:56 +0800
Message-Id: <20201119092957.16940-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119092957.16940-1-chenyi.qiang@intel.com>
References: <20201119092957.16940-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid breaking the CPUs without bus lock detection, activate the
DR6_BUS_LOCK bit (bit 11) conditionally in DR6_FIXED_1 bits.

The set/clear of DR6_BUS_LOCK is similar to the DR6_RTM in DR6
register. The processor clears DR6_BUS_LOCK when bus lock debug
exception is generated. (For all other #DB the processor sets this bit
to 1.) Software #DB handler should set this bit before returning to the
interrupted task.

For VM exit caused by debug exception, bit 11 of the exit qualification
is set to indicate that a bus lock debug exception condition was
detected. The VMM should emulate the exception by clearing bit 11 of the
guest DR6.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/emulate.c          |  2 +-
 arch/x86/kvm/svm/svm.c          |  6 +++---
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  6 ++++--
 arch/x86/kvm/x86.c              | 28 +++++++++++++++++-----------
 6 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 324ddd7fd0aa..531a2fccbed1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -196,13 +196,14 @@ enum x86_intercept_stage;
 
 #define KVM_NR_DB_REGS	4
 
+#define DR6_BUS_LOCK   (1 << 11)
 #define DR6_BD		(1 << 13)
 #define DR6_BS		(1 << 14)
 #define DR6_BT		(1 << 15)
 #define DR6_RTM		(1 << 16)
-#define DR6_FIXED_1	0xfffe0ff0
+#define DR6_FIXED_1	0xfffe07f0
 #define DR6_INIT	0xffff0ff0
-#define DR6_VOLATILE	0x0001e00f
+#define DR6_VOLATILE	0x0001e80f
 
 #define DR7_BP_EN_MASK	0x000000ff
 #define DR7_GE		(1 << 9)
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 56cae1ff9e3f..882598da20f0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4327,7 +4327,7 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
 
 		ctxt->ops->get_dr(ctxt, 6, &dr6);
 		dr6 &= ~DR_TRAP_BITS;
-		dr6 |= DR6_BD | DR6_RTM;
+		dr6 |= DR6_BD | DR6_RTM | DR6_BUS_LOCK;
 		ctxt->ops->set_dr(ctxt, 6, dr6);
 		return emulate_db(ctxt);
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1e81cfebd491..2f0ef1688322 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1778,7 +1778,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	get_debugreg(vcpu->arch.db[2], 2);
 	get_debugreg(vcpu->arch.db[3], 3);
 	/*
-	 * We cannot reset svm->vmcb->save.dr6 to DR6_FIXED_1|DR6_RTM here,
+	 * We cannot reset svm->vmcb->save.dr6 to DR6_FIXED_1|DR6_RTM|DR6_BUS_LOCK here,
 	 * because db_interception might need it.  We can do it before vmentry.
 	 */
 	vcpu->arch.dr6 = svm->vmcb->save.dr6;
@@ -1826,7 +1826,7 @@ static int db_interception(struct vcpu_svm *svm)
 	if (!(svm->vcpu.guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
-		u32 payload = (svm->vmcb->save.dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
+		u32 payload = (svm->vmcb->save.dr6 ^ (DR6_RTM|DR6_BUS_LOCK)) & ~DR6_FIXED_1;
 		kvm_queue_exception_p(&svm->vcpu, DB_VECTOR, payload);
 		return 1;
 	}
@@ -3575,7 +3575,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
 		svm_set_dr6(svm, vcpu->arch.dr6);
 	else
-		svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM);
+		svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM | DR6_BUS_LOCK);
 
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 89af692deb7e..475822b6d851 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -412,7 +412,7 @@ static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit
 			if (!has_payload) {
 				payload = vcpu->arch.dr6;
 				payload &= ~(DR6_FIXED_1 | DR6_BT);
-				payload ^= DR6_RTM;
+				payload ^= DR6_RTM | DR6_BUS_LOCK;
 			}
 			*exit_qual = payload;
 		} else
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..892340b031cb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4844,7 +4844,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;
 		}
-		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
+		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM |
+					  DR6_BUS_LOCK;
 		kvm_run->debug.arch.dr7 = vmcs_readl(GUEST_DR7);
 		fallthrough;
 	case BP_VECTOR:
@@ -5088,7 +5089,8 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		 * guest debugging itself.
 		 */
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
-			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_RTM | DR6_FIXED_1;
+			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_RTM | DR6_FIXED_1 |
+						    DR6_BUS_LOCK;
 			vcpu->run->debug.arch.dr7 = dr7;
 			vcpu->run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 			vcpu->run->debug.arch.exception = DB_VECTOR;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 078a39d489fe..2d506210f1f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -482,19 +482,20 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		 */
 		vcpu->arch.dr6 &= ~DR_TRAP_BITS;
 		/*
-		 * DR6.RTM is set by all #DB exceptions that don't clear it.
+		 * DR6.RTM and DR6.BUS_LOCK are set by all #DB exceptions
+		 * that don't clear it.
 		 */
-		vcpu->arch.dr6 |= DR6_RTM;
+		vcpu->arch.dr6 |= DR6_RTM | DR6_BUS_LOCK;
 		vcpu->arch.dr6 |= payload;
 		/*
-		 * Bit 16 should be set in the payload whenever the #DB
-		 * exception should clear DR6.RTM. This makes the payload
-		 * compatible with the pending debug exceptions under VMX.
-		 * Though not currently documented in the SDM, this also
-		 * makes the payload compatible with the exit qualification
-		 * for #DB exceptions under VMX.
+		 * Bit 16/Bit 11 should be set in the payload whenever
+		 * the #DB exception should clear DR6.RTM/DR6.BUS_LOCK.
+		 * This makes the payload compatible with the pending debug
+		 * exceptions under VMX. Though not currently documented in
+		 * the SDM, this also makes the payload compatible with the
+		 * exit qualification for #DB exceptions under VMX.
 		 */
-		vcpu->arch.dr6 ^= payload & DR6_RTM;
+		vcpu->arch.dr6 ^= payload & (DR6_RTM | DR6_BUS_LOCK);
 
 		/*
 		 * The #DB payload is defined as compatible with the 'pending
@@ -1108,6 +1109,9 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_RTM))
 		fixed |= DR6_RTM;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+		fixed |= DR6_BUS_LOCK;
 	return fixed;
 }
 
@@ -7172,7 +7176,8 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
-		kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM;
+		kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM |
+					  DR6_BUS_LOCK;
 		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
@@ -7216,7 +7221,8 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 					   vcpu->arch.eff_db);
 
 		if (dr6 != 0) {
-			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
+			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM |
+						  DR6_BUS_LOCK;
 			kvm_run->debug.arch.pc = eip;
 			kvm_run->debug.arch.exception = DB_VECTOR;
 			kvm_run->exit_reason = KVM_EXIT_DEBUG;
-- 
2.17.1

