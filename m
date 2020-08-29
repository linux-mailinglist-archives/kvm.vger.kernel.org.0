Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CCE2563C1
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 02:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgH2Asp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 20:48:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33212 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgH2Asj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 20:48:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0U3aE134209;
        Sat, 29 Aug 2020 00:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=AK3ceaMS2xLAiJtKedx0lh6pZWWXLH/6q1MB2rK8Bvo=;
 b=GjmdBY+JP58tWETrkJyk5/LMdIW1nONNtrk9CinNd5a4ytOE/ePu7KBq/9U2C/EaF/R6
 6jUpxjbcDTMYXSyDeMMGNyeglvQGLOKgNlZNRWWHjx3tBRTzj652W0QBkwlHgpNKE3QS
 qOqVf1Q5kbLwGrh+jcRFD1JdzDJ9MffxuLvZXt6W5dCoIXy5Kvf7SF+nOpfQA85IrdZ+
 Pw+cpgtKrVTacaU9L/Y0f9ADOtoIIddlpmhL4Y+o5dqWZ8NbGD3IRscCZzw0Z4iWFFCC
 e/506m9CrucrFgq5OY7lniv5AQI0Xon2Wzav7R7/fXPyeT4N9RzHTHH+Axtpwv1J5jLx mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 333w6ud754-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 29 Aug 2020 00:48:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0Un41113603;
        Sat, 29 Aug 2020 00:48:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 333ru3dgvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Aug 2020 00:48:34 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07T0mXrs032682;
        Sat, 29 Aug 2020 00:48:33 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 17:48:33 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/3] KVM: nSVM: Add check for CR3 and CR4 reserved bits to svm_set_nested_state()
Date:   Sat, 29 Aug 2020 00:48:23 +0000
Message-Id: <20200829004824.4577-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
References: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008290000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 51 ++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fb68467e6049..7a51ce465f3e 100644
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
@@ -1114,9 +1122,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	/*
 	 * Validate host state saved from before VMRUN (see
 	 * nested_svm_check_permissions).
-	 * TODO: validate reserved bits for all saved state.
 	 */
-	if (!(save.cr0 & X86_CR0_PG))
+	if (!nested_vmcb_check_cr3_cr4(svm, &save))
 		return -EINVAL;
 
 	/*
-- 
2.18.4

