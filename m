Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21159155DB6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgBGSQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:49 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40612 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727446AbgBGSQr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:47 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6A7D8305D3D5;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 5D3383052075;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 18/78] KVM: vmx: pass struct kvm_vcpu to the intercept msr related functions
Date:   Fri,  7 Feb 2020 20:15:36 +0200
Message-Id: <20200207181636.1065-19-alazar@bitdefender.com>
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
 arch/x86/kvm/vmx/vmx.c | 70 +++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 36dfb95ea578..e6878097d736 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -341,7 +341,8 @@ module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
 static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
+							  unsigned long *msr_bitmap,
 							  u32 msr, int type);
 
 void vmx_vmexit(void);
@@ -2015,7 +2016,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * in the merging. We update the vmcs01 here for L1 as well
 		 * since it will end up touching the MSR anyway now.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap,
+		vmx_disable_intercept_for_msr(vcpu, vmx->vmcs01.msr_bitmap,
 					      MSR_IA32_SPEC_CTRL,
 					      MSR_TYPE_RW);
 		break;
@@ -2050,8 +2051,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -3612,7 +3613,8 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
+							  unsigned long *msr_bitmap,
 							  u32 msr, int type)
 {
 	int f = sizeof(unsigned long);
@@ -3650,7 +3652,8 @@ static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bit
 	}
 }
 
-static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
+							 unsigned long *msr_bitmap,
 							 u32 msr, int type)
 {
 	int f = sizeof(unsigned long);
@@ -3688,13 +3691,14 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
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
@@ -3712,7 +3716,8 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 	return mode;
 }
 
-static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
+static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
+					 unsigned long *msr_bitmap,
 					 u8 mode)
 {
 	int msr;
@@ -3728,11 +3733,11 @@ static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
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
@@ -3748,7 +3753,7 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 		return;
 
 	if (changed & (MSR_BITMAP_MODE_X2APIC | MSR_BITMAP_MODE_X2APIC_APICV))
-		vmx_update_msr_bitmap_x2apic(msr_bitmap, mode);
+		vmx_update_msr_bitmap_x2apic(vcpu, msr_bitmap, mode);
 
 	vmx->msr_bitmap_mode = mode;
 }
@@ -3757,20 +3762,21 @@ void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
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
@@ -6780,18 +6786,18 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
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
 	if (kvm_cstate_in_guest(kvm)) {
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
 
