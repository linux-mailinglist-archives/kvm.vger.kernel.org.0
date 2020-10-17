Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53D7290FFE
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 08:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411688AbgJQGEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 02:04:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52364 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436799AbgJQGEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 02:04:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09H00iio150291;
        Sat, 17 Oct 2020 00:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=WuWq34kkxX2RV/tWqIFlgyd5ZnXq0sK9LT4MF9ifw/g=;
 b=hz839BBmMF5MR2rHZ9cnCY+qzkls+CwUiWlQPt6i9tLFL591zxNS0yIGp879M1zj5qBB
 kz70YBVM4HNRKEmJCuHFRxCYN6mJVijHsHS8IGyn8QZtTE5Cm3mB0SMowg47GjCjozLd
 h7Hbzv6H7oVuNMpHQ8n2RDgUk/GnZuvB4pW5x5gr32rZQrNpeB++yZcCylH404m/b/sx
 fJzcmgOUxEmVGP9z6Nq2NA3KwNJN7zmVVaK2ODzg7vWyoPnpnaBeMrBHThsvFtUlM3KQ
 1xMGeC2N3guq5vZ+qzTexm4fbZZculPu/Mq40STnV3tfHNE7L2NVnMBmCx3LLRNuJvdk GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3434wm44vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 17 Oct 2020 00:02:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09H02leV042922;
        Sat, 17 Oct 2020 00:02:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 347nqrg01y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Oct 2020 00:02:55 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09H02sLc022733;
        Sat, 17 Oct 2020 00:02:54 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Oct 2020 17:02:53 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 1/2] KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Sat, 17 Oct 2020 00:02:33 +0000
Message-Id: <20201017000234.42326-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201017000234.42326-1-krish.sadhukhan@oracle.com>
References: <20201017000234.42326-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160169
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
index 8a1f5382a4ea..261240acc7e9 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -272,9 +272,13 @@ struct __attribute__ ((__packed__)) vmcb {
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
index e90bc436f584..840fbf0582bb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -202,6 +202,9 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
+	u32 type, vector;
+	bool valid;
+
 	if ((control->intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
 		return false;
 
@@ -212,6 +215,17 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	    !npt_enabled)
 		return false;
 
+	valid = control->event_inj & SVM_EVTINJ_VALID;
+	type = control->event_inj & SVM_EVTINJ_TYPE_MASK;
+	if (valid && ((type == SVM_EVTINJ_TYPE_RESV1) ||
+	    (type >= SVM_EVTINJ_TYPE_RESV5)))
+		return false;
+
+	vector = control->event_inj & SVM_EVTINJ_VEC_MASK;
+	if (valid && (type == SVM_EVTINJ_TYPE_EXEPT) &&
+	    (vector == NMI_VECTOR || (vector > 31 && vector < 256)))
+		return false;
+
 	return true;
 }
 
-- 
2.18.4

