Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0016C197903
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgC3KUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:53 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43784 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729584AbgC3KUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A9FE930747D4;
        Mon, 30 Mar 2020 13:12:51 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8B087305B7A2;
        Mon, 30 Mar 2020 13:12:51 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 19/81] KVM: svm: pass struct kvm_vcpu to set_msr_interception()
Date:   Mon, 30 Mar 2020 13:12:06 +0300
Message-Id: <20200330101308.21702-20-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
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

Passing NULL during initialization is OK
because a vCPU can be introspected only after initialization.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/svm.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 70c8c913f14e..37c78bb4ba0b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1080,7 +1080,8 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, unsigned msr)
 	return !!test_bit(bit_write,  &tmp);
 }
 
-static void set_msr_interception(u32 *msrpm, unsigned msr,
+static void set_msr_interception(struct kvm_vcpu *vcpu,
+				 u32 *msrpm, unsigned msr,
 				 int type, bool value)
 {
 	u8 bit_read, bit_write;
@@ -1119,7 +1120,7 @@ static void svm_vcpu_init_msrpm(u32 *msrpm)
 		if (!direct_access_msrs[i].always)
 			continue;
 
-		set_msr_interception(msrpm, direct_access_msrs[i].index,
+		set_msr_interception(NULL, msrpm, direct_access_msrs[i].index,
 				     MSR_TYPE_RW, 1);
 	}
 }
@@ -1172,13 +1173,13 @@ static void svm_enable_lbrv(struct vcpu_svm *svm)
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
 
@@ -1187,13 +1188,13 @@ static void svm_disable_lbrv(struct vcpu_svm *svm)
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
 
@@ -4362,7 +4363,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(svm->msrpm, MSR_IA32_SPEC_CTRL,
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
 				     MSR_TYPE_RW, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
@@ -4378,9 +4379,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			break;
 
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD,
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD,
 				     MSR_TYPE_R, 0);
-		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD,
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD,
 				     MSR_TYPE_W, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
