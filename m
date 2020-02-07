Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE9C155DB5
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgBGSQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:48 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40630 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727390AbgBGSQp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:45 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 63A26305D3D4;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 537C93052074;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 17/78] KVM: svm: pass struct kvm_vcpu to set_msr_interception()
Date:   Fri,  7 Feb 2020 20:15:35 +0200
Message-Id: <20200207181636.1065-18-alazar@bitdefender.com>
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

This is needed in order to handle clients controlling the MSR related
VM-exits.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/svm.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0021d8c2feca..174ced633b60 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1077,7 +1077,8 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, unsigned msr)
 	return !!test_bit(bit_write,  &tmp);
 }
 
-static void set_msr_interception(u32 *msrpm, unsigned msr,
+static void set_msr_interception(struct kvm_vcpu *vcpu,
+				 u32 *msrpm, unsigned msr,
 				 int type, bool value)
 {
 	u8 bit_read, bit_write;
@@ -1116,7 +1117,7 @@ static void svm_vcpu_init_msrpm(u32 *msrpm)
 		if (!direct_access_msrs[i].always)
 			continue;
 
-		set_msr_interception(msrpm, direct_access_msrs[i].index,
+		set_msr_interception(NULL, msrpm, direct_access_msrs[i].index,
 				     MSR_TYPE_RW, 1);
 	}
 }
@@ -1169,13 +1170,13 @@ static void svm_enable_lbrv(struct vcpu_svm *svm)
 	u32 *msrpm = svm->msrpm;
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP,
+	set_msr_interception(&svm->vcpu, msrpm, MSR_IA32_LASTBRANCHFROMIP,
 			     MSR_TYPE_RW, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP,
+	set_msr_interception(&svm->vcpu, msrpm, MSR_IA32_LASTBRANCHTOIP,
 			     MSR_TYPE_RW, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP,
+	set_msr_interception(&svm->vcpu, msrpm, MSR_IA32_LASTINTFROMIP,
 			     MSR_TYPE_RW, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP,
+	set_msr_interception(&svm->vcpu, msrpm, MSR_IA32_LASTINTTOIP,
 			     MSR_TYPE_RW, 1);
 }
 
@@ -1184,13 +1185,13 @@ static void svm_disable_lbrv(struct vcpu_svm *svm)
 	u32 *msrpm = svm->msrpm;
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP,
+	set_msr_interception(&svm->vcpu, msrpm, MSR_IA32_LASTBRANCHFROMIP,
 			     MSR_TYPE_RW, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP,
+	set_msr_interception(&svm->vcpu, msrpm, MSR_IA32_LASTBRANCHTOIP,
 			     MSR_TYPE_RW, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP,
+	set_msr_interception(&svm->vcpu, msrpm, MSR_IA32_LASTINTFROMIP,
 			     MSR_TYPE_RW, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP,
+	set_msr_interception(&svm->vcpu, msrpm, MSR_IA32_LASTINTTOIP,
 			     MSR_TYPE_RW, 0);
 }
 
@@ -4327,7 +4328,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(svm->msrpm, MSR_IA32_SPEC_CTRL,
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
 				     MSR_TYPE_RW, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
@@ -4344,7 +4345,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
 		if (is_guest_mode(vcpu))
 			break;
-		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD,
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD,
+				     MSR_TYPE_R, 0);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD,
 				     MSR_TYPE_W, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
