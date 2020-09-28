Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1E927A876
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 09:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgI1HVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 03:21:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34050 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgI1HVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 03:21:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7Ixv2015948;
        Mon, 28 Sep 2020 07:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=GeiYnokDDLlqHPZNwAyI/UGl33VSpFfTSXOu+meN720=;
 b=w7M2am5ZxsPdx1oDAm2l85M74hpe5R6s5ZJ+Ok/VWQ0hK04VLOBUpB0C7FCvP7iGHl3m
 d36tdXPl2zisMZpd+vxjEDW40Q/UHChyVno+gwDw6DIRVkuZ/sG3toGBoS328GotqgRi
 UNX53KKaXsaPl76Fx8f33s1mckW5xebalWq1zncFWw5pVeDoJY+kGZv2Y4/6+s/IFHqG
 FTJ65cD4OKTq8Gqk7UqQePPBwSSwzBhm5pgTwfLFnn+8PpiGXP9f9zrASt+FdiGSAinP
 wdpLjQJeB2Z3EKHeFwws/XmH7Al4c3hkywnw/79UOJYKUxuPD3M2vSGkjCPgqpjNnoRH 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33sx9muc4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 07:21:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7Jf7Z131356;
        Mon, 28 Sep 2020 07:21:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33tfjujg4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 07:21:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08S7L6ME008373;
        Mon, 28 Sep 2020 07:21:07 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 00:21:06 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/4 v2] KVM: nSVM: Add check for reserved bits for CR3, CR4, DR6, DR7 and EFER to svm_set_nested_state()
Date:   Mon, 28 Sep 2020 07:20:41 +0000
Message-Id: <20200928072043.9359-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
References: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The path for SVM_SET_NESTED_STATE needs to have the same checks for the CPU
registers, as we have in the VMRUN path for a nested guest. This patch adds
those missing checks to svm_set_nested_state().

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 55 +++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e90bc436f584..55c785587bd4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -215,9 +215,35 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	return true;
 }
 
+static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
+				      struct vmcb_save_area *save)
+{
+	bool nested_vmcb_lma =
+	        (save->efer & EFER_LME) &&
+		(save->cr0 & X86_CR0_PG);
+
+	if (!nested_vmcb_lma) {
+		if (save->cr4 & X86_CR4_PAE) {
+			if (save->cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
+				return false;
+		} else {
+			if (save->cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
+				return false;
+		}
+	} else {
+		if (!(save->cr4 & X86_CR4_PAE) ||
+		    !(save->cr0 & X86_CR0_PE) ||
+		    (save->cr3 & MSR_CR3_LONG_MBZ_MASK))
+			return false;
+	}
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
 
@@ -228,25 +254,7 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
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
@@ -1116,9 +1124,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
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

