Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B719C1A3BF7
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 23:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgDIVcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 17:32:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41096 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgDIVcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 17:32:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039LN5ZN021407;
        Thu, 9 Apr 2020 21:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ihUhFhpj3fVrjo+Pa4wWIprtfvUQwzlDc9R70YsCDSM=;
 b=enZFGIyBbUJZDcVh0nAjG/LS345e9euUMCVEBFIeH5SbCusKlfwEMaZQMdGQV69wL60x
 FBEH3eWAEx0GATkEQ/RUFKNGYkRE7g5QPl7pTqdrjm8h68M6Kyl2glrTij2oozTg31Lp
 M4nwTKK6PFuBwUazAxfESvWcYaJiUydIHQR2chQacohTpZamKxvQyHDtWnxljzu6JDnK
 0wyJyWCenQ3HAtYj6sCEOQaDOnatJqmFb0dNUquVEEwpxg1qrcJK7I7IMJwB/JEf4Voz
 a3YAigmgehnosF4RAQFtHH4jn/vRCsLGXZ/LamSmIRKW6gIXhtMeh3KHVbKPdcdj0rUQ 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 309gw4fthu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 21:32:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039LLd5C124255;
        Thu, 9 Apr 2020 21:30:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3091m9mk2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 21:30:48 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 039LUkSs024394;
        Thu, 9 Apr 2020 21:30:47 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 14:30:46 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 3/3] kvm-unit-tests: nSVM: Test CR0.CD and CR0.NW combination on VMRUN of nested guests
Date:   Thu,  9 Apr 2020 16:50:35 -0400
Message-Id: <20200409205035.16830-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200409205035.16830-1-krish.sadhukhan@oracle.com>
References: <20200409205035.16830-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=15 mlxlogscore=927
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004090151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=15 malwarescore=0 spamscore=0 mlxlogscore=972 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2,
the following guest state combination is illegal:

        "CR0.CD is zero and CR0.NW is set"

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 16b9dfd..8bdefc5 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1352,15 +1352,41 @@ static void basic_guest_main(struct svm_test *test)
 
 static void svm_guest_state_test(void)
 {
+	test_set_guest(basic_guest_main);
+
+	/*
+	 * Un-setting EFER.SVME is illegal
+	 */
 	u64 efer_saved = vmcb->save.efer;
 	u64 efer = efer_saved;
 
-	test_set_guest(basic_guest_main);
 	report (svm_vmrun() == SVM_EXIT_VMMCALL, "EFER.SVME: %lx", efer);
 	efer &= ~EFER_SVME;
 	vmcb->save.efer = efer;
 	report (svm_vmrun() == SVM_EXIT_ERR, "EFER.SVME: %lx", efer);
 	vmcb->save.efer = efer_saved;
+
+	/*
+	 * Un-setting CR0.CD and setting CR0.NW is illegal combination
+	 */
+	u64 cr0_saved = vmcb->save.cr0;
+	u64 cr0 = cr0_saved;
+
+	cr0 |= X86_CR0_CD;
+	cr0 &= ~X86_CR0_NW;
+	vmcb->save.cr0 = cr0;
+	report (svm_vmrun() == SVM_EXIT_VMMCALL, "CR0: %lx", cr0);
+	cr0 |= X86_CR0_NW;
+	vmcb->save.cr0 = cr0;
+	report (svm_vmrun() == SVM_EXIT_VMMCALL, "CR0: %lx", cr0);
+	cr0 &= ~X86_CR0_NW;
+	cr0 &= ~X86_CR0_CD;
+	vmcb->save.cr0 = cr0;
+	report (svm_vmrun() == SVM_EXIT_VMMCALL, "CR0: %lx", cr0);
+	cr0 |= X86_CR0_NW;
+	vmcb->save.cr0 = cr0;
+	report (svm_vmrun() == SVM_EXIT_ERR, "CR0: %lx", cr0);
+	vmcb->save.cr0 = cr0_saved;
 }
 
 struct svm_test svm_tests[] = {
-- 
1.8.3.1

