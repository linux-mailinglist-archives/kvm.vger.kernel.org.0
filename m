Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EE9285218
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 21:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgJFTJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 15:09:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47938 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgJFTJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 15:09:09 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096J09xF109287;
        Tue, 6 Oct 2020 19:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=rdka2jjTEeN3nmXtfJ22paxgOqiCjdnOwofrk9ZtLMI=;
 b=hR9/EHHNllnkKNapywvLZF2vgyDlViH++na5iMjTPf+i6xiM8XhOCOmT/xy+J9JP0BvX
 5IbamQ47alm+xzUwVt6R2XZGMBskscoNpjN8BHbkN6myLx51oSzQrpSqnu475lLt1HjW
 EsL9BjJih3qcU3pUqjJp0Pvfn7aizeUHsmCQ7e69Il8rJQq8M3QJ7SqoeIVKRLP3okBT
 wGka2nRuuOQVO6Ve++t32VHvGOm4af7TuDit/8SgcV+NRPnLSr52si2+kYEDZ4o6N9XP
 QhnXU/+Hknewkf08iBZCFfU4vh5VVb1SiVdNIt92byvC98ReB8CKyOcZ1Pg9m9wuYHP3 wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetax3sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 19:09:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096J0oxf109698;
        Tue, 6 Oct 2020 19:07:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33y36yf1jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 19:07:04 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 096J73Nj004251;
        Tue, 6 Oct 2020 19:07:03 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 12:07:03 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/4 v3] KVM: nSVM: Add check for reserved bits for CR3, CR4, DR6, DR7 and EFER to svm_set_nested_state()
Date:   Tue,  6 Oct 2020 19:06:52 +0000
Message-Id: <20201006190654.32305-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
References: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=1 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The path for SVM_SET_NESTED_STATE needs to have the same checks for the CPU
registers, as we have in the VMRUN path for a nested guest. This patch adds
those missing checks to svm_set_nested_state().

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 49 +++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e90bc436f584..28a931fa599e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -215,9 +215,29 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	return true;
 }
 
+static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
+				      struct vmcb_save_area *save)
+{
+	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
+		if (!(save->cr4 & X86_CR4_PAE) || !(save->cr0 & X86_CR0_PE) ||
+		    (save->cr3 & MSR_CR3_LONG_MBZ_MASK))
+			return false;
+	} else if (save->cr4 & X86_CR4_PAE) {
+		if (save->cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
+			return false;
+	} else {
+		if (save->cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
+			return false;
+	}
+
+	if (kvm_valid_cr4(&svm->vcpu, save->cr4))
+		return false;
+
+	return true;
+}
+
 static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
 {
-	bool nested_vmcb_lma;
 	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
 
@@ -228,25 +248,7 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
 	if (!kvm_dr6_valid(vmcb->save.dr6) || !kvm_dr7_valid(vmcb->save.dr7))
 		return false;
 
-	nested_vmcb_lma =
-	        (vmcb->save.efer & EFER_LME) &&
-		(vmcb->save.cr0 & X86_CR0_PG);
-
-	if (!nested_vmcb_lma) {
-		if (vmcb->save.cr4 & X86_CR4_PAE) {
-			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
-				return false;
-		} else {
-			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
-				return false;
-		}
-	} else {
-		if (!(vmcb->save.cr4 & X86_CR4_PAE) ||
-		    !(vmcb->save.cr0 & X86_CR0_PE) ||
-		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
-			return false;
-	}
-	if (kvm_valid_cr4(&svm->vcpu, vmcb->save.cr4))
+	if (!nested_vmcb_check_cr3_cr4(svm, &(vmcb->save)))
 		return false;
 
 	return nested_vmcb_check_controls(&vmcb->control);
@@ -1116,9 +1118,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	/*
 	 * Validate host state saved from before VMRUN (see
 	 * nested_svm_check_permissions).
-	 * TODO: validate reserved bits for all saved state.
 	 */
-	if (!(save.cr0 & X86_CR0_PG))
+	if (!(save.cr0 & X86_CR0_PG) ||
+	    !nested_vmcb_check_cr3_cr4(svm, &save) ||
+	    !kvm_dr6_valid(save.dr6) ||
+	    !kvm_dr7_valid(save.dr7) ||
+	    !kvm_valid_efer(vcpu, save.efer))
 		return -EINVAL;
 
 	/*
-- 
2.18.4

