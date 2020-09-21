Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88324271DA7
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 10:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgIUIMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 04:12:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46710 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgIUIMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 04:12:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08L898vp163663;
        Mon, 21 Sep 2020 08:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=9P1BqW5eEbN0sm2+B7OnQjLwAserdN/C+elcGXIC7Lo=;
 b=iF/4Geci4wf7es0sEgE2g4Hcw6u9oheYE0df46kGUeKuHGrMAo0PMNT4WQNhNMFsJ9HM
 8HVO5E97oiBFuBMgF5Gb/2jay9tbEWWjGxpEUTdM0tyxPEbBuqakVtGTpipv4WSC+xqW
 bIfjTA2UI7glr9KO8+NPnDCKo0gaQAiKSz7x3Y2EWIp3FDl4SPzDSTamVxeLT37BhAQ8
 5OHjFnQ7ltkIOHpCKMLa2uYhLp623Xhkonzd8+sT83efQufSiAmt7KajgBguxyhSSPLB
 zVdvEbZcEAx2j/X5qpOq+Xgbq3lxwX9OYMa1rqrk0dleQTa0vr4/qpMZTpHd6I6bZE4h Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33n9xkm3aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Sep 2020 08:12:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08L86GHV142937;
        Mon, 21 Sep 2020 08:10:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33nujkb3df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 08:10:38 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08L8AbcB022458;
        Mon, 21 Sep 2020 08:10:37 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.230.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 01:10:37 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 1/3 v3] KVM: nVMX: KVM needs to unset "unrestricted guest" VM-execution control in vmcs02 if vmcs12 doesn't set it
Date:   Mon, 21 Sep 2020 08:10:25 +0000
Message-Id: <20200921081027.23047-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200921081027.23047-1-krish.sadhukhan@oracle.com>
References: <20200921081027.23047-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9750 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210059
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9750 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=1 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, prepare_vmcs02_early() does not check if the "unrestricted guest"
VM-execution control in vmcs12 is turned off and leaves the corresponding
bit on in vmcs02. Due to this setting, vmentry checks which are supposed to
render the nested guest state as invalid when this VM-execution control is
not set, are passing in hardware.

This patch turns off the "unrestricted guest" VM-execution control in vmcs02
if vmcs12 has turned it off.

Suggested-by: Jim Mattson <jmattson@google.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/nested.c |  3 +++
 arch/x86/kvm/vmx/vmx.c    | 17 +++++++++--------
 arch/x86/kvm/vmx/vmx.h    |  7 +++++++
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1bb6b31eb646..86fc044e5af9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2314,6 +2314,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write16(GUEST_INTR_STATUS,
 				vmcs12->guest_intr_status);
 
+		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_UNRESTRICTED_GUEST))
+		    exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
+
 		secondary_exec_controls_set(vmx, exec_control);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8646a797b7a8..0559c11d227c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1441,7 +1441,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long old_rflags;
 
-	if (enable_unrestricted_guest) {
+	if (is_unrestricted_guest(vcpu)) {
 		kvm_register_mark_available(vcpu, VCPU_EXREG_RFLAGS);
 		vmx->rflags = rflags;
 		vmcs_writel(GUEST_RFLAGS, rflags);
@@ -2267,7 +2267,8 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & guest_owned_bits;
 		break;
 	case VCPU_EXREG_CR3:
-		if (enable_unrestricted_guest || (enable_ept && is_paging(vcpu)))
+		if (is_unrestricted_guest(vcpu) ||
+		    (enable_ept && is_paging(vcpu)))
 			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
 		break;
 	case VCPU_EXREG_CR4:
@@ -3033,7 +3034,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	unsigned long hw_cr0;
 
 	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
-	if (enable_unrestricted_guest)
+	if (is_unrestricted_guest(vcpu))
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
 	else {
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON;
@@ -3054,7 +3055,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 #endif
 
-	if (enable_ept && !enable_unrestricted_guest)
+	if (enable_ept && !is_unrestricted_guest(vcpu))
 		ept_update_paging_mode_cr0(&hw_cr0, cr0, vcpu);
 
 	vmcs_writel(CR0_READ_SHADOW, cr0);
@@ -3134,7 +3135,7 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long hw_cr4;
 
 	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
-	if (enable_unrestricted_guest)
+	if (is_unrestricted_guest(vcpu))
 		hw_cr4 |= KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST;
 	else if (vmx->rmode.vm86_active)
 		hw_cr4 |= KVM_RMODE_VM_CR4_ALWAYS_ON;
@@ -3169,7 +3170,7 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	vcpu->arch.cr4 = cr4;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR4);
 
-	if (!enable_unrestricted_guest) {
+	if (!is_unrestricted_guest(vcpu)) {
 		if (enable_ept) {
 			if (!is_paging(vcpu)) {
 				hw_cr4 &= ~X86_CR4_PAE;
@@ -3309,7 +3310,7 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	 * tree. Newer qemu binaries with that qemu fix would not need this
 	 * kvm hack.
 	 */
-	if (enable_unrestricted_guest && (seg != VCPU_SREG_LDTR))
+	if (is_unrestricted_guest(vcpu) && (seg != VCPU_SREG_LDTR))
 		var->type |= 0x1; /* Accessed */
 
 	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
@@ -3500,7 +3501,7 @@ static bool cs_ss_rpl_check(struct kvm_vcpu *vcpu)
  */
 static bool guest_state_valid(struct kvm_vcpu *vcpu)
 {
-	if (enable_unrestricted_guest)
+	if (is_unrestricted_guest(vcpu))
 		return true;
 
 	/* real mode guest state checks */
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a2f82127c170..0a39a7831ba9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -555,6 +555,13 @@ static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
 	return !enable_ept || cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
 }
 
+static inline bool is_unrestricted_guest(struct kvm_vcpu *vcpu)
+{
+	return enable_unrestricted_guest && (!is_guest_mode(vcpu) ||
+	    (secondary_exec_controls_get(to_vmx(vcpu)) &
+	    SECONDARY_EXEC_UNRESTRICTED_GUEST));
+}
+
 void dump_vmcs(void);
 
 #endif /* __KVM_X86_VMX_H */
-- 
2.18.4

