Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866592C91AC
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 23:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388769AbgK3WyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 17:54:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58078 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730855AbgK3WyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 17:54:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMdO7D035941;
        Mon, 30 Nov 2020 22:53:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=JGVygv4vHzUJ71gIuU1M2dX+kKCuEAFztkCxmZAPKbc=;
 b=FAJrgfm6prnBbMKWtRU0HmGjjqYaonlZVetn8xKSW9+gUCMTbZAFtkbKRY/PTqwjZPW3
 t3uaakn+mGoK79R60ngg691rQtWzBKZozqdd98Z0OefsUdaMh+fhoEKIDeOVgMJs8WvT
 pD400d8T98NEuHt35GbXtBB5cnjX40zNMoprqkdXVHvkzSFv5ayLAe+F15QejEUda7Zb
 1Nvar3yTf8AY9aOgCDhBqCJ5OTU2Q+5lLi2R+VRRd+aLal2R81nPFI02iLZLilgIceAz
 5Dz40NY0oPteof9uGsWUmA1LB+nMRlheaTsIZDxkwOf8X6tb17lRm0aWypgzxOnP4Y8V 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkfqvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 22:53:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMeDhP106972;
        Mon, 30 Nov 2020 22:53:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540ar8tae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 22:53:15 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUMrFqB010381;
        Mon, 30 Nov 2020 22:53:15 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 14:53:14 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/2 v3] KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Mon, 30 Nov 2020 22:53:05 +0000
Message-Id: <20201130225306.15075-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201130225306.15075-1-krish.sadhukhan@oracle.com>
References: <20201130225306.15075-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300141
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
index 05d564c8d034..2599b32ea7be 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -212,6 +212,9 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
+	u32 type, vector;
+	bool valid;
+
 	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
 		return false;
 
@@ -222,6 +225,17 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	    !npt_enabled)
 		return false;
 
+	valid = control->event_inj & SVM_EVTINJ_VALID;
+	type = control->event_inj & SVM_EVTINJ_TYPE_MASK;
+	if (valid && type == SVM_EVTINJ_TYPE_RESV1 ||
+	    type >= SVM_EVTINJ_TYPE_RESV5)
+		return false;
+
+	vector = control->event_inj & SVM_EVTINJ_VEC_MASK;
+	if (valid && type == SVM_EVTINJ_TYPE_EXEPT &&
+	    vector == NMI_VECTOR || (vector > 31 && vector < 256))
+		return false;
+
 	return true;
 }
 
-- 
2.27.0

