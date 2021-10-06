Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C274244F1
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbhJFRnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:42 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53652 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238424AbhJFRmo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:44 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B5C91307CAE5;
        Wed,  6 Oct 2021 20:30:58 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9AC143064495;
        Wed,  6 Oct 2021 20:30:58 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 14/77] KVM: x86: svm: use the vmx convention to control the MSR interception
Date:   Wed,  6 Oct 2021 20:30:10 +0300
Message-Id: <20211006173113.26445-15-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This is a preparatory patch in order to use a common interface to
enable/disable the MSR interception.

Also, it will allow to independently control the read and write
interceptions.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |   4 ++
 arch/x86/kvm/svm/sev.c          |  18 ++++--
 arch/x86/kvm/svm/svm.c          | 103 ++++++++++++++++++++------------
 arch/x86/kvm/svm/svm.h          |   2 +-
 arch/x86/kvm/vmx/vmx.h          |   4 --
 5 files changed, 83 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1e77cb825ec4..79b2d8abff36 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -150,6 +150,10 @@
 #define CR_TYPE_W	2
 #define CR_TYPE_RW	3
 
+#define MSR_TYPE_R	1
+#define MSR_TYPE_W	2
+#define MSR_TYPE_RW	3
+
 #define ASYNC_PF_PER_VCPU 64
 
 enum kvm_reg {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1e8b26b93b4f..29bf93c97b65 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2623,12 +2623,18 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
 	/* Clear intercepts on selected MSRs */
-	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, MSR_TYPE_RW,
+			     1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, MSR_TYPE_RW,
+			     1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP,
+			     MSR_TYPE_RW, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP,
+			     MSR_TYPE_RW, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP,
+			     MSR_TYPE_RW, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP,
+			     MSR_TYPE_RW, 1);
 }
 
 void sev_es_vcpu_reset(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 31109961183e..97f7406cf7d6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -616,8 +616,8 @@ static int direct_access_msr_slot(u32 msr)
 	return -ENOENT;
 }
 
-static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
-				     int write)
+static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr,
+				     int type, bool value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int slot = direct_access_msr_slot(msr);
@@ -626,15 +626,19 @@ static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
 		return;
 
 	/* Set the shadow bitmaps to the desired intercept states */
-	if (read)
-		set_bit(slot, svm->shadow_msr_intercept.read);
-	else
-		clear_bit(slot, svm->shadow_msr_intercept.read);
+	if (type & MSR_TYPE_R) {
+		if (value)
+			set_bit(slot, svm->shadow_msr_intercept.read);
+		else
+			clear_bit(slot, svm->shadow_msr_intercept.read);
+	}
 
-	if (write)
-		set_bit(slot, svm->shadow_msr_intercept.write);
-	else
-		clear_bit(slot, svm->shadow_msr_intercept.write);
+	if (type & MSR_TYPE_W) {
+		if (value)
+			set_bit(slot, svm->shadow_msr_intercept.write);
+		else
+			clear_bit(slot, svm->shadow_msr_intercept.write);
+	}
 }
 
 static bool valid_msr_intercept(u32 index)
@@ -662,7 +666,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 }
 
 static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
-					u32 msr, int read, int write)
+					u32 msr, int type, bool value)
 {
 	u8 bit_read, bit_write;
 	unsigned long tmp;
@@ -675,11 +679,13 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	WARN_ON(!valid_msr_intercept(msr));
 
 	/* Enforce non allowed MSRs to trap */
-	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
-		read = 0;
+	if (value && (type & MSR_TYPE_R) &&
+	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
+		type &= ~MSR_TYPE_R;
 
-	if (write && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
-		write = 0;
+	if (value && (type & MSR_TYPE_W) &&
+	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
+		type &= ~MSR_TYPE_W;
 
 	offset    = svm_msrpm_offset(msr);
 	bit_read  = 2 * (msr & 0x0f);
@@ -688,8 +694,10 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 
 	BUG_ON(offset == MSR_INVALID);
 
-	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
-	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+	if (type & MSR_TYPE_R)
+		value  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
+	if (type & MSR_TYPE_W)
+		value  ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
 
 	msrpm[offset] = tmp;
 
@@ -698,10 +706,10 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 }
 
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
-			  int read, int write)
+			  int type, bool value)
 {
-	set_shadow_msr_intercept(vcpu, msr, read, write);
-	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
+	set_shadow_msr_intercept(vcpu, msr, type, value);
+	set_msr_interception_bitmap(vcpu, msrpm, msr, type, value);
 }
 
 u32 *svm_vcpu_alloc_msrpm(void)
@@ -726,7 +734,8 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
 		if (!direct_access_msrs[i].always)
 			continue;
-		set_msr_interception(vcpu, msrpm, direct_access_msrs[i].index, 1, 1);
+		set_msr_interception(vcpu, msrpm, direct_access_msrs[i].index,
+				     MSR_TYPE_RW, 1);
 	}
 }
 
@@ -751,7 +760,10 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 		u32 read = test_bit(i, svm->shadow_msr_intercept.read);
 		u32 write = test_bit(i, svm->shadow_msr_intercept.write);
 
-		set_msr_interception_bitmap(vcpu, svm->msrpm, msr, read, write);
+		set_msr_interception_bitmap(vcpu, svm->msrpm, msr,
+					    MSR_TYPE_R, read);
+		set_msr_interception_bitmap(vcpu, svm->msrpm, msr,
+					    MSR_TYPE_W, write);
 	}
 }
 
@@ -803,10 +815,14 @@ static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP,
+			     MSR_TYPE_RW, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP,
+			     MSR_TYPE_RW, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP,
+			     MSR_TYPE_RW, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP,
+			     MSR_TYPE_RW, 1);
 }
 
 static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
@@ -814,10 +830,14 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP,
+			     MSR_TYPE_RW, 0);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP,
+			     MSR_TYPE_RW, 0);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP,
+			     MSR_TYPE_RW, 0);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP,
+			     MSR_TYPE_RW, 0);
 }
 
 void disable_nmi_singlestep(struct vcpu_svm *svm)
@@ -1192,8 +1212,10 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
 		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 0, 0);
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 0, 0);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP,
+				     MSR_TYPE_RW, 0);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP,
+				     MSR_TYPE_RW, 0);
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -1205,8 +1227,10 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 		/* No need to intercept these MSRs */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP,
+				     MSR_TYPE_RW, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP,
+				     MSR_TYPE_RW, 1);
 	}
 }
 
@@ -1334,7 +1358,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * of MSR_IA32_SPEC_CTRL.
 	 */
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
+				     MSR_TYPE_RW, 1);
 
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm);
@@ -3001,7 +3026,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
+				     MSR_TYPE_RW, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
@@ -3016,7 +3042,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			break;
 
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD,
+				     MSR_TYPE_R, 0);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD,
+				     MSR_TYPE_W, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 32c2d6d3424b..e1e63a7b0a57 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -440,7 +440,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
-			  int read, int write);
+			  int type, bool value);
 
 /* nested.c */
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 592217fd7d92..ffdfe62a17bc 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -14,10 +14,6 @@
 #include "vmx_ops.h"
 #include "cpuid.h"
 
-#define MSR_TYPE_R	1
-#define MSR_TYPE_W	2
-#define MSR_TYPE_RW	3
-
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
 #ifdef CONFIG_X86_64
