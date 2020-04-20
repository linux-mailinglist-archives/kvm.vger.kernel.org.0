Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23581B1A34
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 01:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgDTXks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 19:40:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgDTXks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 19:40:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNcF64025372;
        Mon, 20 Apr 2020 23:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Nvhtf8pjnU4Bqu33y3oH3xlUHGdsKeDVd3Yr/oy/8JI=;
 b=bLlnhxlJckl0yk+GM00IP5bZppsmzaunSYGUq/W1LSlgZvxO9ZEHu1fyVbVA72kCOyOz
 hEyiVTlTSX6Nebahiv9NCfJFGgfwKN+5rHKsrNo1YGglZFITov5zSetQycMG6gnfQzcE
 QFpjf4WB8jkyi7inusn+yMBfO1IKuB3tZ6vXEa+L/xum28m34EX3KWedWHcN0kqB7fO2
 h4BC5Kc/TnoFqdHOfLvc0MqJvWSQGRQjLOiSnOJp+Gshc9bDHGePLBP1sq9lo9+95tE9
 d85Z5A2LKZehUiaMLbc1+Yhvd7UwM7vu4eCeqZhT8AEMKg+TBK91eIHorG9ybzC98wvS hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30grpgehtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 23:40:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNcI7J090118;
        Mon, 20 Apr 2020 23:38:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30gb1eg26h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 23:38:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03KNchjY017405;
        Mon, 20 Apr 2020 23:38:43 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 16:38:43 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] kvm-unit-tests: nSVM: Test that CR0[63:32] are not set on VMRUN of nested guests
Date:   Mon, 20 Apr 2020 18:58:25 -0400
Message-Id: <20200420225825.3184-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200420225825.3184-1-krish.sadhukhan@oracle.com>
References: <20200420225825.3184-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=13
 spamscore=0 mlxlogscore=998 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=13 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200183
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2,
the following guest state is illegal:

	"CR0[63:32] are not zero."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8bdefc5..3bfa484 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1387,6 +1387,20 @@ static void svm_guest_state_test(void)
 	vmcb->save.cr0 = cr0;
 	report (svm_vmrun() == SVM_EXIT_ERR, "CR0: %lx", cr0);
 	vmcb->save.cr0 = cr0_saved;
+
+	/*
+	 * CR0[63:32] are not zero
+	 */
+	int i;
+
+	cr0 = cr0_saved;
+	for (i = 32; i < 63; i = i + 4) {
+		cr0 = cr0_saved | (1ull << i);
+		vmcb->save.cr0 = cr0;
+		report (svm_vmrun() == SVM_EXIT_ERR, "CR0[63:32]: %lx",
+		    cr0 >> 32);
+	}
+	vmcb->save.cr0 = cr0_saved;
 }
 
 struct svm_test svm_tests[] = {
-- 
1.8.3.1

