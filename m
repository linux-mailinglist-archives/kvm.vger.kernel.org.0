Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF924228A81
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731276AbgGUVQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:02 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37852 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731211AbgGUVQA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 51533305D766;
        Wed, 22 Jul 2020 00:09:21 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 2FB35304FA13;
        Wed, 22 Jul 2020 00:09:21 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 17/84] KVM: x86: use MSR_TYPE_R, MSR_TYPE_W and MSR_TYPE_RW with AMD
Date:   Wed, 22 Jul 2020 00:08:15 +0300
Message-Id: <20200721210922.7646-18-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This is a preparatory patch in order to use a common interface to
enable/disable the MSR interception.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++
 arch/x86/kvm/svm/svm.c          | 43 ++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.h          |  4 ---
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6be832ba9c97..a3230ab377db 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -140,6 +140,10 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define CR_TYPE_W	2
 #define CR_TYPE_RW	3
 
+#define MSR_TYPE_R	1
+#define MSR_TYPE_W	2
+#define MSR_TYPE_RW	3
+
 #define ASYNC_PF_PER_VCPU 64
 
 enum kvm_reg {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4e5b07606891..e16be80edd7e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -584,7 +584,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, unsigned msr)
 }
 
 static void set_msr_interception(u32 *msrpm, unsigned msr,
-				 int read, int write)
+				 int type, bool value)
 {
 	u8 bit_read, bit_write;
 	unsigned long tmp;
@@ -603,8 +603,10 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 
 	BUG_ON(offset == MSR_INVALID);
 
-	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
-	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+	if (type & MSR_TYPE_R)
+		value ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
+	if (type & MSR_TYPE_W)
+		value ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
 
 	msrpm[offset] = tmp;
 }
@@ -619,7 +621,8 @@ static void svm_vcpu_init_msrpm(u32 *msrpm)
 		if (!direct_access_msrs[i].always)
 			continue;
 
-		set_msr_interception(msrpm, direct_access_msrs[i].index, 1, 1);
+		set_msr_interception(msrpm, direct_access_msrs[i].index,
+				     MSR_TYPE_RW, 1);
 	}
 }
 
@@ -671,10 +674,14 @@ static void svm_enable_lbrv(struct vcpu_svm *svm)
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
@@ -682,10 +689,14 @@ static void svm_disable_lbrv(struct vcpu_svm *svm)
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
 
 void disable_nmi_singlestep(struct vcpu_svm *svm)
@@ -2618,7 +2629,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		set_msr_interception(svm->msrpm, MSR_IA32_SPEC_CTRL,
+				     MSR_TYPE_RW, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
@@ -2633,7 +2645,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			break;
 
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
+		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD,
+				     MSR_TYPE_R, 0);
+		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD,
+				     MSR_TYPE_W, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 639798e4a6ca..aa0c7ffd588b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -14,10 +14,6 @@
 
 extern const u32 vmx_msr_index[];
 
-#define MSR_TYPE_R	1
-#define MSR_TYPE_W	2
-#define MSR_TYPE_RW	3
-
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
 #ifdef CONFIG_X86_64
