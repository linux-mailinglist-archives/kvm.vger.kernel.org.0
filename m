Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F7730BA81
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 10:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhBBJCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 04:02:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:41961 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhBBJCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 04:02:07 -0500
IronPort-SDR: Lg5Urppqis4XRE7RzKH2IO5JFP8y7UnXIVvsG6G0962HfDqgcwoXOv5APCqyjhY0bN1dZGWTWL
 PwpKg8Iv7fEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167929215"
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="167929215"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:01:25 -0800
IronPort-SDR: gnUXbQ3V6kGW8lXVj6PIheLMNT4OxxLyIzr4p4IrWbEA/b+8sPPXzf14Q2xFmz6tLpfguSnX1f
 Ygo/Il9Y2maw==
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="479491914"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:01:22 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: X86: Rename DR6_INIT to DR6_ACTIVE_LOW
Date:   Tue,  2 Feb 2021 17:04:31 +0800
Message-Id: <20210202090433.13441-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202090433.13441-1-chenyi.qiang@intel.com>
References: <20210202090433.13441-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DR6_INIT contains the 1-reserved bits as well as the bit that is cleared
to 0 when the condition (e.g. RTM) happens. The value can be used to
initialize dr6 and also be the XOR mask between the #DB exit
qualification (or payload) and DR6.

Concerning that DR6_INIT is used as initial value only once, rename it
to DR6_ACTIVE_LOW and apply it in other places, which would make the
incoming changes for bus lock debug exception more simple.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ++++++++-
 arch/x86/kvm/emulate.c          |  2 +-
 arch/x86/kvm/svm/nested.c       |  2 +-
 arch/x86/kvm/svm/svm.c          |  6 +++---
 arch/x86/kvm/vmx/nested.c       |  4 ++--
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/x86.c              | 33 +++++++++++++++++++--------------
 7 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ab7b46087b7..5b80f92a7fde 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -201,7 +201,14 @@ enum x86_intercept_stage;
 #define DR6_BT		(1 << 15)
 #define DR6_RTM		(1 << 16)
 #define DR6_FIXED_1	0xfffe0ff0
-#define DR6_INIT	0xffff0ff0
+/*
+ * DR6_ACTIVE_LOW is actual the result of DR6_FIXED_1 | ACTIVE_LOW_BITS.
+ * We can regard all the current FIXED_1 bits as active_low bits even
+ * though in no case they will be turned into 0. But if they are defined
+ * in the future, it will require no code change.
+ * At the same time, it can be served as the init/reset value for DR6.
+ */
+#define DR6_ACTIVE_LOW	0xffff0ff0
 #define DR6_VOLATILE	0x0001e00f
 
 #define DR7_BP_EN_MASK	0x000000ff
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 56cae1ff9e3f..db78ade570f0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4327,7 +4327,7 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
 
 		ctxt->ops->get_dr(ctxt, 6, &dr6);
 		dr6 &= ~DR_TRAP_BITS;
-		dr6 |= DR6_BD | DR6_RTM;
+		dr6 |= DR6_BD | DR6_ACTIVE_LOW;
 		ctxt->ops->set_dr(ctxt, 6, dr6);
 		return emulate_db(ctxt);
 	}
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b0b667456b2e..6db85fbcf5d0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -395,7 +395,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 	svm->vmcb->save.rsp = vmcb12->save.rsp;
 	svm->vmcb->save.rip = vmcb12->save.rip;
 	svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
-	svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_FIXED_1 | DR6_RTM;
+	svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
 	svm->vmcb->save.cpl = vmcb12->save.cpl;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cce0143a6f80..eaf1c523d16a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1860,7 +1860,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	get_debugreg(vcpu->arch.db[2], 2);
 	get_debugreg(vcpu->arch.db[3], 3);
 	/*
-	 * We cannot reset svm->vmcb->save.dr6 to DR6_FIXED_1|DR6_RTM here,
+	 * We cannot reset svm->vmcb->save.dr6 to DR6_ACTIVE_LOW here,
 	 * because db_interception might need it.  We can do it before vmentry.
 	 */
 	vcpu->arch.dr6 = svm->vmcb->save.dr6;
@@ -1911,7 +1911,7 @@ static int db_interception(struct vcpu_svm *svm)
 	if (!(svm->vcpu.guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
-		u32 payload = (svm->vmcb->save.dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
+		u32 payload = svm->vmcb->save.dr6 ^ DR6_ACTIVE_LOW;
 		kvm_queue_exception_p(&svm->vcpu, DB_VECTOR, payload);
 		return 1;
 	}
@@ -3778,7 +3778,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
 		svm_set_dr6(svm, vcpu->arch.dr6);
 	else
-		svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM);
+		svm_set_dr6(svm, DR6_ACTIVE_LOW);
 
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e2f26564a12d..ef72278e67bb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -411,8 +411,8 @@ static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit
 		if (nr == DB_VECTOR) {
 			if (!has_payload) {
 				payload = vcpu->arch.dr6;
-				payload &= ~(DR6_FIXED_1 | DR6_BT);
-				payload ^= DR6_RTM;
+				payload &= ~DR6_BT;
+				payload ^= DR6_ACTIVE_LOW;
 			}
 			*exit_qual = payload;
 		} else
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75c9c6a0a3a4..ae79284e6199 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4824,7 +4824,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;
 		}
-		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
+		kvm_run->debug.arch.dr6 = dr6 | DR6_ACTIVE_LOW;
 		kvm_run->debug.arch.dr7 = vmcs_readl(GUEST_DR7);
 		fallthrough;
 	case BP_VECTOR:
@@ -5068,7 +5068,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		 * guest debugging itself.
 		 */
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
-			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_RTM | DR6_FIXED_1;
+			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_ACTIVE_LOW;
 			vcpu->run->debug.arch.dr7 = dr7;
 			vcpu->run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 			vcpu->run->debug.arch.exception = DB_VECTOR;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc7a3ce..1946e6710919 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -483,19 +483,24 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		 */
 		vcpu->arch.dr6 &= ~DR_TRAP_BITS;
 		/*
-		 * DR6.RTM is set by all #DB exceptions that don't clear it.
+		 * In order to reflect the #DB exception payload in guest
+		 * dr6, three components need to be considered: active low
+		 * bit, FIXED_1 bits and active high bits (e.g. DR6_BD,
+		 * DR6_BS and DR6_BT)
+		 * DR6_ACTIVE_LOW contains the FIXED_1 and active low bits.
+		 * In the target guest dr6:
+		 * FIXED_1 bits should always be set.
+		 * Active low bits should be cleared if 1-setting in payload.
+		 * Active high bits should be set if 1-setting in payload.
+		 *
+		 * Note, the payload is compatible with the pending debug
+		 * exceptions/exit qualification under VMX, that active_low bits
+		 * are active high in payload.
+		 * So they need to be flipped for DR6.
 		 */
-		vcpu->arch.dr6 |= DR6_RTM;
+		vcpu->arch.dr6 |= DR6_ACTIVE_LOW;
 		vcpu->arch.dr6 |= payload;
-		/*
-		 * Bit 16 should be set in the payload whenever the #DB
-		 * exception should clear DR6.RTM. This makes the payload
-		 * compatible with the pending debug exceptions under VMX.
-		 * Though not currently documented in the SDM, this also
-		 * makes the payload compatible with the exit qualification
-		 * for #DB exceptions under VMX.
-		 */
-		vcpu->arch.dr6 ^= payload & DR6_RTM;
+		vcpu->arch.dr6 ^= payload & DR6_ACTIVE_LOW;
 
 		/*
 		 * The #DB payload is defined as compatible with the 'pending
@@ -7197,7 +7202,7 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
-		kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM;
+		kvm_run->debug.arch.dr6 = DR6_BS | DR6_ACTIVE_LOW;
 		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
@@ -7241,7 +7246,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 					   vcpu->arch.eff_db);
 
 		if (dr6 != 0) {
-			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
+			kvm_run->debug.arch.dr6 = dr6 | DR6_ACTIVE_LOW;
 			kvm_run->debug.arch.pc = eip;
 			kvm_run->debug.arch.exception = DB_VECTOR;
 			kvm_run->exit_reason = KVM_EXIT_DEBUG;
@@ -10086,7 +10091,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	memset(vcpu->arch.db, 0, sizeof(vcpu->arch.db));
 	kvm_update_dr0123(vcpu);
-	vcpu->arch.dr6 = DR6_INIT;
+	vcpu->arch.dr6 = DR6_ACTIVE_LOW;
 	vcpu->arch.dr7 = DR7_FIXED_1;
 	kvm_update_dr7(vcpu);
 
-- 
2.17.1

