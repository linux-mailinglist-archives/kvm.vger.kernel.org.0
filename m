Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA7A2D1B17
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgLGUsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:21 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42592 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbgLGUsT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:19 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 7C8C2305D509;
        Mon,  7 Dec 2020 22:46:14 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 53D873072784;
        Mon,  7 Dec 2020 22:46:14 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 16/81] KVM: x86: svm: use the vmx convention to control the MSR interception
Date:   Mon,  7 Dec 2020 22:45:17 +0200
Message-Id: <20201207204622.15258-17-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
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
 arch/x86/include/asm/kvm_host.h |  4 ++
 arch/x86/kvm/svm/svm.c          | 88 +++++++++++++++++++++------------
 arch/x86/kvm/vmx/vmx.h          |  4 --
 3 files changed, 60 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5236008d231f..8586c9f4feba 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -141,6 +141,10 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define CR_TYPE_W	2
 #define CR_TYPE_RW	3
 
+#define MSR_TYPE_R	1
+#define MSR_TYPE_W	2
+#define MSR_TYPE_RW	3
+
 #define ASYNC_PF_PER_VCPU 64
 
 enum kvm_reg {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4478942f10a5..8d662ccf5b62 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -584,8 +584,8 @@ static int direct_access_msr_slot(u32 msr)
 	return -ENOENT;
 }
 
-static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
-				     int write)
+static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr,
+				     int type, bool value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int slot = direct_access_msr_slot(msr);
@@ -594,15 +594,19 @@ static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
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
@@ -630,7 +634,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 }
 
 static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
-					u32 msr, int read, int write)
+					u32 msr, int type, bool value)
 {
 	u8 bit_read, bit_write;
 	unsigned long tmp;
@@ -643,11 +647,13 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
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
@@ -656,17 +662,19 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 
 	BUG_ON(offset == MSR_INVALID);
 
-	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
-	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+	if (type & MSR_TYPE_R)
+		value  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
+	if (type & MSR_TYPE_W)
+		value  ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
 
 	msrpm[offset] = tmp;
 }
 
 static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
-				 int read, int write)
+				 int type, bool value)
 {
-	set_shadow_msr_intercept(vcpu, msr, read, write);
-	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
+	set_shadow_msr_intercept(vcpu, msr, type, value);
+	set_msr_interception_bitmap(vcpu, msrpm, msr, type, value);
 }
 
 u32 *svm_vcpu_alloc_msrpm(void)
@@ -690,7 +698,8 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
 		if (!direct_access_msrs[i].always)
 			continue;
-		set_msr_interception(vcpu, msrpm, direct_access_msrs[i].index, 1, 1);
+		set_msr_interception(vcpu, msrpm, direct_access_msrs[i].index,
+				     MSR_TYPE_RW, 1);
 	}
 }
 
@@ -715,7 +724,10 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 		u32 read = test_bit(i, svm->shadow_msr_intercept.read);
 		u32 write = test_bit(i, svm->shadow_msr_intercept.write);
 
-		set_msr_interception_bitmap(vcpu, svm->msrpm, msr, read, write);
+		set_msr_interception_bitmap(vcpu, svm->msrpm, msr,
+					    MSR_TYPE_R, read);
+		set_msr_interception_bitmap(vcpu, svm->msrpm, msr,
+					    MSR_TYPE_W, write);
 	}
 }
 
@@ -767,10 +779,14 @@ static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
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
@@ -778,10 +794,14 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
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
@@ -2734,7 +2754,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
+				     MSR_TYPE_RW, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
@@ -2749,7 +2770,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
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
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9d3a557949ac..892e9ca643c4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -16,10 +16,6 @@
 
 extern const u32 vmx_msr_index[];
 
-#define MSR_TYPE_R	1
-#define MSR_TYPE_W	2
-#define MSR_TYPE_RW	3
-
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
 #ifdef CONFIG_X86_64
