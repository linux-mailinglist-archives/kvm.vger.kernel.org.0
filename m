Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6CD2563D6
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 02:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgH2A5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 20:57:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33582 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgH2A5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 20:57:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0sUEY102182;
        Sat, 29 Aug 2020 00:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=uDjbNBVuawhF3AVAtaXgZ+JUtMQ5C/TyIR+uXkkF68s=;
 b=s9UEc1F0z+tIz8s1tvvQXpeFqi7zqyD+TA/D+0stA8fowH8/q5FFYVekS1bsZ6um1SZR
 cbwE9O7Rdbizw2we/hv1FOucI5ECKd6E+GM0jipSTcvNn2T+T+jI+4qg8MeKXNpZfWtF
 zO+u0xJVoyycq69Pf5QSqfiGnsXbSt/RT3Fk552zeuQXOB0w+lzdo5ezAQjsC5908+WM
 pRRNLhfzFGNtCYy5Y88kGrx0xZg7ZDX4RqZK59yNFGqiufg6D7QVo5R6gnTL4g40235b
 cExZcb+FswVrUZZgjN9dxUMRY3/Pq6u4hjqpfEw76v8oXr7Xy1kHcd0i6ok874Mj+oxu NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 333dbsemu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 29 Aug 2020 00:57:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0pT6l112662;
        Sat, 29 Aug 2020 00:57:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 337c4s0veu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Aug 2020 00:57:27 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07T0vQbJ023955;
        Sat, 29 Aug 2020 00:57:26 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 17:57:26 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH] nSVM: Add a test for the P (present) bit in NPT entry
Date:   Sat, 29 Aug 2020 00:57:20 +0000
Message-Id: <20200829005720.5325-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=1 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008290001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the P (present) bit in an NPT entry is cleared, VMRUN will fail and the
guest will exit to the host with an exit code of 0x400 (#NPF). The following
bits of importance in EXITINFO1 will be set/cleared to indicate the failure:

	bit# 0: cleared
	bit# 32: set

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1908c7c..e9f178a 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -720,6 +720,32 @@ static bool npt_nx_check(struct svm_test *test)
            && (vmcb->control.exit_info_1 == 0x100000015ULL);
 }
 
+static void npt_np_prepare(struct svm_test *test)
+{
+    u64 *pte;
+
+    scratch_page = alloc_page();
+    vmcb_ident(vmcb);
+    pte = npt_get_pte((u64)scratch_page);
+
+    *pte &= ~1ULL;
+}
+
+static void npt_np_test(struct svm_test *test)
+{
+    (void) *(volatile u64 *)scratch_page;
+}
+
+static bool npt_np_check(struct svm_test *test)
+{
+    u64 *pte = npt_get_pte((u64)scratch_page);
+
+    *pte |= 1ULL;
+
+    return (vmcb->control.exit_code == SVM_EXIT_NPF)
+           && (vmcb->control.exit_info_1 == 0x100000004ULL);
+}
+
 static void npt_us_prepare(struct svm_test *test)
 {
     u64 *pte;
@@ -2119,6 +2145,9 @@ struct svm_test svm_tests[] = {
     { "npt_nx", npt_supported, npt_nx_prepare,
       default_prepare_gif_clear, null_test,
       default_finished, npt_nx_check },
+    { "npt_np", npt_supported, npt_np_prepare,
+      default_prepare_gif_clear, npt_np_test,
+      default_finished, npt_np_check },
     { "npt_us", npt_supported, npt_us_prepare,
       default_prepare_gif_clear, npt_us_test,
       default_finished, npt_us_check },
-- 
2.18.4

