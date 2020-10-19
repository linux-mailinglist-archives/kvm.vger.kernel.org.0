Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A6A293155
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 00:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgJSWiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 18:38:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50424 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgJSWiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 18:38:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JMIn94084700;
        Mon, 19 Oct 2020 22:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=HP4ykR3R0iwJZXcpzLQ6riSiwYYg8qZvFJCz5Jl3mJY=;
 b=aOiXM0yswLbt//Rppkdelfb6n/2deXsK4iTsAPOBGmuihdV33zAwxSuzDUYRGUjvGiWg
 rs1/FFAellnEB++1NQ1i/71sMP7h/csNvyK326Tng3QdgDYKHQ9TFO6fY50GuNL8RKWJ
 SpCvjaXPj0faZBsunHGfeHbvgh4V3FZLdVvttdsavghDg/9XDqnnXMwhEr4bnUhFmrwk
 60GygqJN40EQHft52wcKV5RTVCrbeL3rdmEhE71UJIEDtU8iICEVrjLYpjVXBYU+wmhk
 FcguJPh8/FMkrXSHgjuDoVn2dHIy1nSSRenNjkE+LUE0gcj16enRvqc2xrTTAzEpOBOD sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 349jrpg6hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 22:38:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JMK5Wh004079;
        Mon, 19 Oct 2020 22:36:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 348acq1c28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 22:36:17 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09JMaGgF012864;
        Mon, 19 Oct 2020 22:36:16 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 15:36:16 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/2 v2] nSVM: Test reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Mon, 19 Oct 2020 22:35:57 +0000
Message-Id: <20201019223557.36491-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201019223557.36491-1-krish.sadhukhan@oracle.com>
References: <20201019223557.36491-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 spamscore=0 mlxlogscore=988
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=1 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190150
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

Existing tests already cover part of the second rule. This patch covers the
the first rule and the missing pieces of the second rule.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index f78c9e4..b9be522 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2132,6 +2132,43 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+static void test_event_inject(void)
+{
+	u32 i;
+	u32 event_inj_saved = vmcb->control.event_inj;
+
+	handle_exception(DE_VECTOR, my_isr);
+
+	report (svm_vmrun() == SVM_EXIT_VMMCALL && count_exc == 0, "Test "
+	    "No EVENTINJ");
+
+	/*
+	 * Reserved values for 'Type' in EVENTINJ causes VMEXIT_INVALID.
+	 */
+	for (i = 1; i < 8; i++) {
+		if (i != 1 && i < 5)
+			continue;
+		vmcb->control.event_inj = DE_VECTOR |
+		    i << SVM_EVTINJ_TYPE_SHIFT | SVM_EVTINJ_VALID;
+		report(svm_vmrun() == SVM_EXIT_ERR && count_exc == 0,
+		    "Test invalid TYPE (%x) in EVENTINJ", i);
+	}
+
+	/*
+	 * Invalid vector number for event type 'exception' in EVENTINJ
+	 * causes VMEXIT_INVALID.
+	 */
+	for (i = 32; i < 256; i += 4) {
+		vmcb->control.event_inj = i | SVM_EVTINJ_TYPE_EXEPT |
+		    SVM_EVTINJ_VALID;
+		report(svm_vmrun() == SVM_EXIT_ERR && count_exc == 0,
+		    "Test invalid vector (%u) in EVENTINJ for event type "
+		    "\'exception\'", i);
+	}
+
+	vmcb->control.event_inj = event_inj_saved;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2141,6 +2178,7 @@ static void svm_guest_state_test(void)
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_event_inject();
 }
 
 struct svm_test svm_tests[] = {
-- 
2.18.4

