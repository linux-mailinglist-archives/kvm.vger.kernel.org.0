Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FB8217C50
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 02:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgGHAkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 20:40:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35592 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbgGHAkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 20:40:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0680W80N116111;
        Wed, 8 Jul 2020 00:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=H+usw7RJyJAnZdAjRR/3HsR/75pNIqdieIWMc11pMio=;
 b=VfrroOwAz4AAY4pjU2jSaN8G5vvZo62o/U9pnPS9a3qTtAma28HoBRxTRCnprIKfoGPe
 62msQKmsB0GFAIdLwT0AFjvM9e31IbpPvU0QNtrqA1lGYGl2P1zPrPAJeAU/R7y8hJiO
 LG0to6WbF21RcXCv5PG2KKigrfBqf4ZLIhmWUZ5ASA5F6Q0mQXQ5KwuYHtl+EzAK1k6E
 wGgpeAh/LEc4hQoiAbJbGjLdfhRm1O+VAmQLXAziqYMKiXOI0+hmKH427qntfVRHISel
 j1ndgMaHjc+gezmnNGuD1MQmOIZ3O0D5/KI3URKGA5mZm9U2QBd12AuSV81yFK/+Qo8N YA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 323wackcjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 00:40:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0680YFmD022448;
        Wed, 8 Jul 2020 00:40:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3233py1syv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 00:40:07 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0680e6k3023813;
        Wed, 8 Jul 2020 00:40:06 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 17:40:05 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/3 v4] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests
Date:   Wed,  8 Jul 2020 00:39:56 +0000
Message-Id: <1594168797-29444-3-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0 cotscore=-2147483648
 suspectscore=1 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2
the following guest state is illegal:

    "Any MBZ bit of CR3 is set."
    "Any MBZ bit of CR4 is set."

Suggeted-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 22 ++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h    |  5 ++++-
 arch/x86/kvm/x86.c        |  3 ++-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6bceafb..6d2ac5a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -222,7 +222,9 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vmcb *vmcb)
+extern int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+
+static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
 {
 	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
@@ -231,6 +233,22 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	    (vmcb->save.cr0 & X86_CR0_NW))
 		return false;
 
+	if (!is_long_mode(&(svm->vcpu))) {
+		if (vmcb->save.cr4 & X86_CR4_PAE) {
+			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
+				return false;
+		} else {
+			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
+				return false;
+		}
+	} else {
+		if ((vmcb->save.cr4 & X86_CR4_PAE) &&
+		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
+			return false;
+	}
+	if (kvm_valid_cr4(&(svm->vcpu), vmcb->save.cr4))
+		return false;
+
 	return nested_vmcb_check_controls(&vmcb->control);
 }
 
@@ -416,7 +434,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	nested_vmcb = map.hva;
 
-	if (!nested_vmcb_checks(nested_vmcb)) {
+	if (!nested_vmcb_checks(svm, nested_vmcb)) {
 		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
 		nested_vmcb->control.exit_code_hi = 0;
 		nested_vmcb->control.exit_info_1  = 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00..26b14ec 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -346,7 +346,10 @@ static inline bool gif_set(struct vcpu_svm *svm)
 }
 
 /* svm.c */
-#define MSR_INVALID			0xffffffffU
+#define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
+#define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
+#define MSR_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
+#define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f0335bc..732ae6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -932,7 +932,7 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
 
-static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	if (cr4 & cr4_reserved_bits)
 		return -EINVAL;
@@ -942,6 +942,7 @@ static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_valid_cr4);
 
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-- 
1.8.3.1

