Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB42D83A2
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 01:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437956AbgLLAvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 19:51:13 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42102 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437957AbgLLAvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 19:51:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BC0nS4i166428;
        Sat, 12 Dec 2020 00:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=6b7bkdK3RairZuKEql1fqwFQvoSZbDq3HT3Ffh/Rs7Y=;
 b=DH5wTzuMOXtLwp3c3EZ36vBCfeALBfWoY1XMl4diwg+8itGHPpORVjgpvDBoew65lk8U
 5et8g1621PH/NvjRaWPD66g8hrmjit4N6EWN6rkvxmDBtWZbP3ki5ki0RX0K5cOemZ/2
 5LymsM5gAIqDdPHDvOVcKDwJ+BcAM2m5FctA4s/00JImz5ta9CPAuvZEt8Jn80rDJcqq
 i9d5hr3pTwyM2RFVlMZDdFF4WaW/+k4oekUUiKrrVmd+jTUEfE5OzBP6GwdDXFntlMhD
 Uz4aNhfpssj8D545Bgh2ZHBrHhC04Twz4tfmvjScQlBWvKc8afs9p5or/LKZmw/uBS/R NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcb00vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 12 Dec 2020 00:50:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BC0ixP2173947;
        Sat, 12 Dec 2020 00:50:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 358ksu96dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Dec 2020 00:50:27 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BC0oQJH022915;
        Sat, 12 Dec 2020 00:50:26 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Dec 2020 16:50:26 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Subject: [PATCH 1/2 v5] KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Sat, 12 Dec 2020 00:50:18 +0000
Message-Id: <20201212005019.6807-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212005019.6807-1-krish.sadhukhan@oracle.com>
References: <20201212005019.6807-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012120003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012120004
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
 arch/x86/kvm/svm/nested.c  | 15 +++++++++++++++
 2 files changed, 19 insertions(+)

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
index 9e4c226dbf7d..cb5593bdda11 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -212,6 +212,10 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
+	u8 vector;
+	u32 type;
+	bool valid;
+
 	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
 		return false;
 
@@ -222,6 +226,17 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	    !npt_enabled)
 		return false;
 
+	valid = control->event_inj & SVM_EVTINJ_VALID;
+	type = control->event_inj & SVM_EVTINJ_TYPE_MASK;
+	if (valid && (type == SVM_EVTINJ_TYPE_RESV1 ||
+	    type >= SVM_EVTINJ_TYPE_RESV5))
+		return false;
+
+	vector = control->event_inj & SVM_EVTINJ_VEC_MASK;
+	if (valid && type == SVM_EVTINJ_TYPE_EXEPT &&
+	    (vector == NMI_VECTOR || vector > 31))
+			return false;
+
 	return true;
 }
 
-- 
2.27.0

