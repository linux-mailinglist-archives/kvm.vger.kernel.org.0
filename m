Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00DE19791B
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgC3KT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:19:58 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43836 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729206AbgC3KT4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:56 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CE28A30747D5;
        Mon, 30 Mar 2020 13:12:51 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AC974305B7A0;
        Mon, 30 Mar 2020 13:12:51 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 20/81] KVM: vmx: pass struct kvm_vcpu to the intercept msr related functions
Date:   Mon, 30 Mar 2020 13:12:07 +0300
Message-Id: <20200330101308.21702-21-alazar@bitdefender.com>
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
 arch/x86/kvm/vmx/vmx.c | 70 +++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2801b1f7054f..4dc6fbf91ca5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -343,7 +343,8 @@ module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
 static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
+							  unsigned long *msr_bitmap,
 							  u32 msr, int type);
 
 void vmx_vmexit(void);
@@ -2067,7 +2068,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * in the merging. We update the vmcs01 here for L1 as well
 		 * since it will end up touching the MSR anyway now.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap,
+		vmx_disable_intercept_for_msr(vcpu, vmx->vmcs01.msr_bitmap,
 					      MSR_IA32_SPEC_CTRL,
 					      MSR_TYPE_RW);
 		break;
@@ -2103,8 +2104,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * vmcs02.msr_bitmap here since it gets completely overwritten
 		 * in the merging.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap, MSR_IA32_PRED_CMD,
-					      MSR_TYPE_W);
+		vmx_disable_intercept_for_msr(vcpu, vmx->vmcs01.msr_bitmap,
+					      MSR_IA32_PRED_CMD, MSR_TYPE_W);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (!kvm_pat_valid(data))
@@ -3644,7 +3645,8 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
+							  unsigned long *msr_bitmap,
 							  u32 msr, int type)
 {
 	int f = sizeof(unsigned long);
@@ -3682,7 +3684,8 @@ static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bit
 	}
 }
 
-static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
+							 unsigned long *msr_bitmap,
 							 u32 msr, int type)
 {
 	int f = sizeof(unsigned long);
@@ -3720,13 +3723,14 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
+						      unsigned long *msr_bitmap,
 			     			      u32 msr, int type, bool value)
 {
 	if (value)
-		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
+		vmx_enable_intercept_for_msr(vcpu, msr_bitmap, msr, type);
 	else
-		vmx_disable_intercept_for_msr(msr_bitmap, msr, type);
+		vmx_disable_intercept_for_msr(vcpu, msr_bitmap, msr, type);
 }
 
 static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
@@ -3744,7 +3748,8 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 	return mode;
 }
 
-static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
+static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
+					 unsigned long *msr_bitmap,
 					 u8 mode)
 {
 	int msr;
@@ -3760,11 +3765,11 @@ static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
 		 * TPR reads and writes can be virtualized even if virtual interrupt
 		 * delivery is not in use.
 		 */
-		vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(vcpu, msr_bitmap, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW);
 		if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
-			vmx_enable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_R);
-			vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
-			vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
+			vmx_enable_intercept_for_msr(vcpu, msr_bitmap, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_R);
+			vmx_disable_intercept_for_msr(vcpu, msr_bitmap, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
+			vmx_disable_intercept_for_msr(vcpu, msr_bitmap, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
 		}
 	}
 }
@@ -3780,7 +3785,7 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 		return;
 
 	if (changed & (MSR_BITMAP_MODE_X2APIC | MSR_BITMAP_MODE_X2APIC_APICV))
-		vmx_update_msr_bitmap_x2apic(msr_bitmap, mode);
+		vmx_update_msr_bitmap_x2apic(vcpu, msr_bitmap, mode);
 
 	vmx->msr_bitmap_mode = mode;
 }
@@ -3789,20 +3794,21 @@ void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
 {
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
 	bool flag = !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
 	u32 i;
 
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_STATUS,
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, MSR_IA32_RTIT_STATUS,
 							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_OUTPUT_BASE,
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, MSR_IA32_RTIT_OUTPUT_BASE,
 							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_OUTPUT_MASK,
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, MSR_IA32_RTIT_OUTPUT_MASK,
 							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_CR3_MATCH,
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, MSR_IA32_RTIT_CR3_MATCH,
 							MSR_TYPE_RW, flag);
 	for (i = 0; i < vmx->pt_desc.addr_range; i++) {
-		vmx_set_intercept_for_msr(msr_bitmap,
+		vmx_set_intercept_for_msr(vcpu, msr_bitmap,
 			MSR_IA32_RTIT_ADDR0_A + i * 2, MSR_TYPE_RW, flag);
-		vmx_set_intercept_for_msr(msr_bitmap,
+		vmx_set_intercept_for_msr(vcpu, msr_bitmap,
 			MSR_IA32_RTIT_ADDR0_B + i * 2, MSR_TYPE_RW, flag);
 	}
 }
@@ -6804,18 +6810,18 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		goto free_pml;
 
 	msr_bitmap = vmx->vmcs01.msr_bitmap;
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
 	if (kvm_cstate_in_guest(vcpu->kvm)) {
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
 	}
 	vmx->msr_bitmap_mode = 0;
 
