Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA0E290F96
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 07:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436695AbgJQFq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 01:46:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44864 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411848AbgJQFq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 01:46:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GNxxiG102550;
        Sat, 17 Oct 2020 00:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=XCa2PomrhYYZh08raq454QQAjaEb0x+ylP6h2IZKPkQ=;
 b=ptTfdg3kwv+UoaEe3nxGcoAittRNkxCMOO1BR4cN3RmPhuRtOOcN7WppWXjNIIZ9EC3a
 /MZ3VimFhBEfUYZ/jseu/DptwHnxjXIPc2tCZqNYe6HPa2LdcLChBElCne7nQJPBiJcp
 pUdC0pBoKNP9aarPEVQR3XFxp2kfPTsMFWuL0yUk/7zGfAsjGzPy/P4S2p/v9yAXMZwm
 OC70+4zoc0arXxs5qeIMkHi+3sRu0WpiTFrcMp9zovB/50MwxEZW9+/MlOBzAhQ22YfU
 8XNdfIR3/9tpOHpPJcmPiQTJq5RfUaBFhtw5mmgCNk11GHKXajR/c4eEVXvcnA58cHTp Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 343vaetfjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 17 Oct 2020 00:04:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GNxh63060494;
        Sat, 17 Oct 2020 00:02:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 344by76jj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Oct 2020 00:02:55 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09H02sdl029993;
        Sat, 17 Oct 2020 00:02:54 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Oct 2020 17:02:54 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/2] nSVM: Test reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Sat, 17 Oct 2020 00:02:34 +0000
Message-Id: <20201017000234.42326-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201017000234.42326-1-krish.sadhukhan@oracle.com>
References: <20201017000234.42326-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=958 spamscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010160169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=970 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 spamscore=0 adultscore=0 lowpriorityscore=0
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

Existing tests already cover part of the second rule. This patch covers the
the first rule and the missing pieces of the second rule.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index f78c9e4..e6554e4 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2132,6 +2132,45 @@ static void test_dr(void)
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
+	i = 32;
+	while (i < 256) {
+		vmcb->control.event_inj = i | SVM_EVTINJ_TYPE_EXEPT |
+		    SVM_EVTINJ_VALID;
+		report(svm_vmrun() == SVM_EXIT_ERR && count_exc == 0,
+		    "Test invalid vector (%u) in EVENTINJ for event type "
+		    "\'exception\'", i);
+		i += 4;
+	}
+
+	vmcb->control.event_inj = event_inj_saved;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2141,6 +2180,7 @@ static void svm_guest_state_test(void)
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_event_inject();
 }
 
 struct svm_test svm_tests[] = {
-- 
2.18.4

