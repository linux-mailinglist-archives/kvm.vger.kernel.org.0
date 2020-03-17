Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3AF188F43
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 21:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCQUqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 16:46:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCQUqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 16:46:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HKivao090208;
        Tue, 17 Mar 2020 20:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wgypym40+ycNzjy5zt9w0vtraCjiXfZMokD9sMd7Q/M=;
 b=MoiKVGenUj75vQMaUXudTV5qtqUdCAIauoRLsaaQzqveNDiWrqKSRafb8oVluPLx6vXf
 atV0A5GrS01cmBtiwB5d7B2kKVVXO6i1yx9KM+b1eCpNqncGTzHs35xNkxCqxf66FdnQ
 8sgzUXKyvvQJqN17DIJAlw9xUN/GAmqnBM39joBp/h2ex5h2F/RxB0u0zSdzHoZq96EE
 o0+Ll1b44y36VaRFDvprCNou8tsrcpDC+GB3ejrCilbu/9346kSie95S1cN/XFeL8Ign
 dw/WWAiBBnCXvXQv4LVNrM59AHwypfHyyh/Ke7l7MGC+18mbjW1n4Q/8pw7vXfUehsHv UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yrq7ky6n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 20:46:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HKbXxS004907;
        Tue, 17 Mar 2020 20:44:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ys92e325d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 20:44:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02HKiUij030767;
        Tue, 17 Mar 2020 20:44:30 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Tue, 17 Mar 2020 13:43:17 -0700
MIME-Version: 1.0
Message-ID: <20200317200537.21593-4-krish.sadhukhan@oracle.com>
Date:   Tue, 17 Mar 2020 13:05:37 -0700 (PDT)
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 3/3] kvm-unit-test: nSVM: Test SVME.EFER on VMRUN of nested
 guests
References: <20200317200537.21593-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20200317200537.21593-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=996
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=13
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=13
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the section "Canonicalization and Consistency Checks" in 15.5.1
in APM vol 2, setting EFER.SVME to zero is an illegal guest state and will
cause the nested guest to VMEXIT to the guest with an exit code of
VMEXIT_INVALID.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 580bce6..8de4b8e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1197,6 +1197,28 @@ static bool pending_event_check_vmask(struct svm_test *test)
 
 #define TEST(name) { #name, .v2 = name }
 
+/*
+ * v2 tests
+ */
+
+static void basic_guest_main(struct svm_test *test)
+{
+}
+
+static void svm_guest_state_test(void)
+{
+	size_t offset = offsetof(struct vmcb_save_area, efer);
+	u64 efer_saved = vmcb_save_read64(offset);
+	u64 efer = efer_saved;
+
+	test_set_guest(basic_guest_main);
+	report (svm_vmrun() == SVM_EXIT_VMMCALL, "EFER.SVME: %lx", efer);
+	efer &= ~EFER_SVME;
+	vmcb_save_write64(offset, efer);
+	report (svm_vmrun() == SVM_EXIT_ERR, "EFER.SVME: %lx", efer);
+	vmcb_save_write64(offset, efer_saved);
+}
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -1277,5 +1299,6 @@ struct svm_test svm_tests[] = {
       pending_event_prepare_gif_clear_vmask,
       pending_event_test_vmask, pending_event_finished_vmask,
       pending_event_check_vmask },
+    TEST(svm_guest_state_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
1.8.3.1

