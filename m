Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBEA155DCE
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgBGSSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:18:41 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40684 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbgBGSQo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:44 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5A03E305D3D3;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4B83F3052073;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 16/78] KVM: x86: use MSR_TYPE_R, MSR_TYPE_W and MSR_TYPE_RW with AMD code too
Date:   Fri,  7 Feb 2020 20:15:34 +0200
Message-Id: <20200207181636.1065-17-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

These changes prepare the patch that adds .control_msr_intercept().

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/svm.c              | 42 ++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.h          |  4 ----
 3 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8cdb6cece618..2136f273645a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -138,6 +138,10 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define CR_TYPE_W	2
 #define CR_TYPE_RW	3
 
+#define MSR_TYPE_R	1
+#define MSR_TYPE_W	2
+#define MSR_TYPE_RW	3
+
 #define ASYNC_PF_PER_VCPU 64
 
 enum kvm_reg {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e3369562d6fe..0021d8c2feca 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1078,7 +1078,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, unsigned msr)
 }
 
 static void set_msr_interception(u32 *msrpm, unsigned msr,
-				 int read, int write)
+				 int type, bool value)
 {
 	u8 bit_read, bit_write;
 	unsigned long tmp;
@@ -1097,8 +1097,11 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 
 	BUG_ON(offset == MSR_INVALID);
 
-	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
-	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+	if (type & MSR_TYPE_R)
+		value ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
+	if (type & MSR_TYPE_W)
+		value ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+
 
 	msrpm[offset] = tmp;
 }
@@ -1113,7 +1116,8 @@ static void svm_vcpu_init_msrpm(u32 *msrpm)
 		if (!direct_access_msrs[i].always)
 			continue;
 
-		set_msr_interception(msrpm, direct_access_msrs[i].index, 1, 1);
+		set_msr_interception(msrpm, direct_access_msrs[i].index,
+				     MSR_TYPE_RW, 1);
 	}
 }
 
@@ -1165,10 +1169,14 @@ static void svm_enable_lbrv(struct vcpu_svm *svm)
 	u32 *msrpm = svm->msrpm;
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP,
+			     MSR_TYPE_RW, 1);
+	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP,
+			     MSR_TYPE_RW, 1);
+	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP,
+			     MSR_TYPE_RW, 1);
+	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP,
+			     MSR_TYPE_RW, 1);
 }
 
 static void svm_disable_lbrv(struct vcpu_svm *svm)
@@ -1176,10 +1184,14 @@ static void svm_disable_lbrv(struct vcpu_svm *svm)
 	u32 *msrpm = svm->msrpm;
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP,
+			     MSR_TYPE_RW, 0);
+	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP,
+			     MSR_TYPE_RW, 0);
+	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP,
+			     MSR_TYPE_RW, 0);
+	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP,
+			     MSR_TYPE_RW, 0);
 }
 
 static void disable_nmi_singlestep(struct vcpu_svm *svm)
@@ -4315,7 +4327,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		set_msr_interception(svm->msrpm, MSR_IA32_SPEC_CTRL,
+				     MSR_TYPE_RW, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
@@ -4331,7 +4344,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
 		if (is_guest_mode(vcpu))
 			break;
-		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
+		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD,
+				     MSR_TYPE_W, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a4f7f737c5d4..919fffcdf602 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -16,10 +16,6 @@ extern u64 host_efer;
 
 extern u32 get_umwait_control_msr(void);
 
-#define MSR_TYPE_R	1
-#define MSR_TYPE_W	2
-#define MSR_TYPE_RW	3
-
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
 #ifdef CONFIG_X86_64
