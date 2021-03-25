Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E77348D30
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhCYJjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:39:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230026AbhCYJjP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 05:39:15 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P9XpkA051013
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=CZF861RXjsVXrCg27TvhsmfP2F4NqDUO4eb/vn9K6bE=;
 b=LmoW4Vr8LCC1MHyWfwzUyQUdYTcF/gJJRa1Euqponxbc90g0BdONLVQNtrW6v3eNyxMB
 yG3Q518w65GB1ToP4a5zNhGF1Ii3kCHB9u+sRK1OkWBwUhG5QEYzuaefdvWA1pnRg5fk
 DJejpfOiLwp/hhUSuIgDDZlxA3sFZEP3yffTBxrx735dowlgXS0vXnv/pyIyiGUqCiRw
 pkpkhZkazCX9YFs1ct3IgBuBOvohT9tbHlhTQJvG/sfFdfCjTi5I+cHeO4jbsi++q+DN
 E1ftw9EOwTE3SvgNrjZ1ulvDGo+0I+XVCRunzyloCWGtWl60W6oNxRqzHhNpUYC/E2Ad zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gq0b1v68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:15 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12P9XtVV051416
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:14 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gq0b1v5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 05:39:14 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12P9R6NU007114;
        Thu, 25 Mar 2021 09:39:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 37d99rd6y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:39:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12P9dAPp37421462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:39:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35F9511C04C;
        Thu, 25 Mar 2021 09:39:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6E8511C058;
        Thu, 25 Mar 2021 09:39:09 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 09:39:09 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/8] s390x: lib: css: separate wait for IRQ and check I/O completion
Date:   Thu, 25 Mar 2021 10:39:03 +0100
Message-Id: <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_02:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=973 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will may want to check the result of an I/O without waiting
for an interrupt.
For example because we do not handle interrupt.
Let's separate waiting for interrupt and the I/O complretion check.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  1 +
 lib/s390x/css_lib.c | 13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 0058355..5d1e1f0 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -317,6 +317,7 @@ int css_residual_count(unsigned int schid);
 
 void enable_io_isc(uint8_t isc);
 int wait_and_check_io_completion(int schid);
+int check_io_completion(int schid);
 
 /*
  * CHSC definitions
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index f5c4f37..1e5c409 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -487,18 +487,25 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
 }
 
 /* wait_and_check_io_completion:
+ * @schid: the subchannel ID
+ */
+int wait_and_check_io_completion(int schid)
+{
+	wait_for_interrupt(PSW_MASK_IO);
+	return check_io_completion(schid);
+}
+
+/* check_io_completion:
  * @schid: the subchannel ID
  *
  * Makes the most common check to validate a successful I/O
  * completion.
  * Only report failures.
  */
-int wait_and_check_io_completion(int schid)
+int check_io_completion(int schid)
 {
 	int ret = 0;
 
-	wait_for_interrupt(PSW_MASK_IO);
-
 	report_prefix_push("check I/O completion");
 
 	if (lowcore_ptr->io_int_param != schid) {
-- 
2.17.1

