Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886926143F
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 09:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfGGHjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 03:39:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45580 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGGHjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 03:39:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677cee1068598;
        Sun, 7 Jul 2019 07:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=w5dkcwOL6FShSWSRD3vxPsf8DrnJtfqeWNT06VsKeF8=;
 b=o0bGVYuy3leQcU2BxJvh9ZikV7OP39AMczAOZUg0SZPAXEcyAcddVhjNaJiAMyctlv/J
 oFVPJeIP6Av0+vZFyJTd6yFwzIJXxX4mII5pM6u0IwoPcuk7raBFMhKKRX+CbUpXkZMy
 F+mOmQbZ+E8fJP9nxjCBVekb3Oki9Q/zeWzPl42nKa/psDcDxuIOKd89++je5+FHJHZV
 AmRiuQeB+xHzOjLotifDMsApezOPmzNQ3W2Ezk+XRTtu1YIFFQ8cx7tyalkTkULwoH7P
 oO2q4KRKRgD5J+V15rqFtBWoPxF0C72pCkqwsk91ZyfuvYq84pZWgmD/fc2Mts7qccMu Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tjkkpa9fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677cZ3c105030;
        Sun, 7 Jul 2019 07:39:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tjkf1swpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x677dLYv023822;
        Sun, 7 Jul 2019 07:39:21 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jul 2019 07:39:21 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/5] KVM: nVMX: Skip VM-Execution Control vmentry checks that are necessary only if VMCS12 is dirty
Date:   Sun,  7 Jul 2019 03:11:43 -0400
Message-Id: <20190707071147.11651-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=629
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907070104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=689 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907070104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 ..so that every nested vmentry is not slowed down by those checks.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 57 +++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 856a83aa42f5..b0b59c78b3e8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2429,6 +2429,38 @@ static bool valid_ept_address(struct kvm_vcpu *vcpu, u64 address)
 	return true;
 }
 
+static int nested_check_vm_execution_controls_full(struct kvm_vcpu *vcpu,
+						   struct vmcs12 *vmcs12)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (nested_vmx_check_msr_bitmap_controls(vcpu, vmcs12) ||
+	    nested_vmx_check_pml_controls(vcpu, vmcs12))
+		return -EINVAL;
+
+	if (nested_cpu_has_ept(vmcs12) &&
+	    !valid_ept_address(vcpu, vmcs12->ept_pointer))
+		return -EINVAL;
+
+	if (nested_cpu_has_vmfunc(vmcs12)) {
+		if (vmcs12->vm_function_control &
+		    ~vmx->nested.msrs.vmfunc_controls)
+			return -EINVAL;
+
+		if (nested_cpu_has_eptp_switching(vmcs12)) {
+			if (!nested_cpu_has_ept(vmcs12) ||
+			    !page_address_valid(vcpu,
+			     vmcs12->eptp_list_address))
+				return -EINVAL;
+		}
+	}
+
+	if (nested_cpu_has_vpid(vmcs12) && !vmcs12->virtual_processor_id)
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * Checks related to VM-Execution Control Fields
  */
@@ -2437,6 +2469,10 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if ((vmx->nested.dirty_vmcs12) &&
+	    nested_check_vm_execution_controls_full(vcpu, vmcs12))
+		return -EINVAL;
+
 	if (!vmx_control_verify(vmcs12->pin_based_vm_exec_control,
 				vmx->nested.msrs.pinbased_ctls_low,
 				vmx->nested.msrs.pinbased_ctls_high) ||
@@ -2453,38 +2489,19 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 
 	if (vmcs12->cr3_target_count > nested_cpu_vmx_misc_cr3_count(vcpu) ||
 	    nested_vmx_check_io_bitmap_controls(vcpu, vmcs12) ||
-	    nested_vmx_check_msr_bitmap_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_tpr_shadow_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_apic_access_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_apicv_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_nmi_controls(vmcs12) ||
-	    nested_vmx_check_pml_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_unrestricted_guest_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_mode_based_ept_exec_controls(vcpu, vmcs12) ||
-	    nested_vmx_check_shadow_vmcs_controls(vcpu, vmcs12) ||
-	    (nested_cpu_has_vpid(vmcs12) && !vmcs12->virtual_processor_id))
+	    nested_vmx_check_shadow_vmcs_controls(vcpu, vmcs12))
 		return -EINVAL;
 
 	if (!nested_cpu_has_preemption_timer(vmcs12) &&
 	    nested_cpu_has_save_preemption_timer(vmcs12))
 		return -EINVAL;
 
-	if (nested_cpu_has_ept(vmcs12) &&
-	    !valid_ept_address(vcpu, vmcs12->ept_pointer))
-		return -EINVAL;
-
-	if (nested_cpu_has_vmfunc(vmcs12)) {
-		if (vmcs12->vm_function_control &
-		    ~vmx->nested.msrs.vmfunc_controls)
-			return -EINVAL;
-
-		if (nested_cpu_has_eptp_switching(vmcs12)) {
-			if (!nested_cpu_has_ept(vmcs12) ||
-			    !page_address_valid(vcpu, vmcs12->eptp_list_address))
-				return -EINVAL;
-		}
-	}
-
 	return 0;
 }
 
-- 
2.20.1

