Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B832D19E1
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 20:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgLGTm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 14:42:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgLGTm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 14:42:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7Je3JL004397;
        Mon, 7 Dec 2020 19:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=YznBnGGBSe/ExXpZhWJv2v3AfxSsYP+g6lEvIIUivu8=;
 b=PhYp3b4bX2EXecjtm0XhlhAFxuSwyfnyQXy9fFR4lssMPuazwBt+ELh+nfahT60DoqNL
 H6gm6PiLlpkpzwllL4qpxbjSX9ybC/SdBABbDjPjAhG+tmtf84fK0XAYMnD1GExkTYJY
 HOtX/IojXzxHloW3lNGzPGilgjFzdXpz5UzFuiMyrbRm5mWxtwgZwuNEQXmKsmtLifQ3
 4sYE4eJcJvDJAveqkgGnGbKfhkZnbkbphjCbh4SPH2/Zh6rwe2uNKGX3OLZ3dwd7v+Y6
 eDTGFRap9EHWRX95DsWSIm7JQdf9eXlCsZL6c7YDpRBINo8JD6Ip1RyWFVtPKGCrj4Bv wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mqq66c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 19:41:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7JeiJO044487;
        Mon, 7 Dec 2020 19:41:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358ksmn0xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 19:41:42 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7JffDK015262;
        Mon, 7 Dec 2020 19:41:41 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 11:41:41 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/2 v4] KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Mon,  7 Dec 2020 19:41:28 +0000
Message-Id: <20201207194129.7543-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201207194129.7543-1-krish.sadhukhan@oracle.com>
References: <20201207194129.7543-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to sections "Canonicalization and Consistency Checks" and "Event
Injection" in APM vol 2

    VMRUN exits with VMEXIT_INVALID error code if either:
      - Reserved values of TYPE have been specified, or
      - TYPE = 3 (exception) has been specified with a vector that does not
	correspond to an exception (this includes vector 2, which is an NMI,
	not an exception).

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/asm/svm.h |  4 ++++
 arch/x86/kvm/svm/nested.c  | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 71d630bb5e08..d676f140cd19 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -341,9 +341,13 @@ struct vmcb {
 #define SVM_EVTINJ_TYPE_MASK (7 << SVM_EVTINJ_TYPE_SHIFT)
 
 #define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
+#define SVM_EVTINJ_TYPE_RESV1 (1 << SVM_EVTINJ_TYPE_SHIFT)
 #define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
 #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
 #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
+#define SVM_EVTINJ_TYPE_RESV5 (5 << SVM_EVTINJ_TYPE_SHIFT)
+#define SVM_EVTINJ_TYPE_RESV6 (6 << SVM_EVTINJ_TYPE_SHIFT)
+#define SVM_EVTINJ_TYPE_RESV7 (7 << SVM_EVTINJ_TYPE_SHIFT)
 
 #define SVM_EVTINJ_VALID (1 << 31)
 #define SVM_EVTINJ_VALID_ERR (1 << 11)
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9e4c226dbf7d..fa51231c1f24 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -212,6 +212,9 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
+	u8 type, vector;
+	bool valid;
+
 	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
 		return false;
 
@@ -222,6 +225,17 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	    !npt_enabled)
 		return false;
 
+	valid = control->event_inj & SVM_EVTINJ_VALID;
+	type = control->event_inj & SVM_EVTINJ_TYPE_MASK;
+	if (valid && (type == SVM_EVTINJ_TYPE_RESV1 ||
+	    type >= SVM_EVTINJ_TYPE_RESV5))
+		return false;
+
+	vector = control->event_inj & SVM_EVTINJ_VEC_MASK;
+	if (valid && (type == SVM_EVTINJ_TYPE_EXEPT))
+		if (vector == NMI_VECTOR || vector > 31)
+			return false;
+
 	return true;
 }
 
-- 
2.27.0

