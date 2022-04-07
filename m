Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6771F4F7A16
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 10:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243268AbiDGIqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 04:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243252AbiDGIqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 04:46:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C10B18425D;
        Thu,  7 Apr 2022 01:44:40 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2376A8XS029057;
        Thu, 7 Apr 2022 08:44:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zYpnu2Mol32tcA3TcTlE1tf7qr23StNEAfsnHMwwm9c=;
 b=KDBo0uXQuyxkmETLBkdw8eD4IgVGxDNI5eYN9TeYHzbGHM2gwjzPdoMQ/MR8kIhebgkS
 XVWUiWyx1ZR1Ba2TweVOANHoVqkdcUiz7Rx/Dr7ebEuGL53YGxizFt5NxF+7QQS66K/a
 S42segNuhm09B46plKDcHsh1oeb5fVhbIFDfVW1R+4NauD155oA3nPRZGS2eFcQbFIoy
 3qrsy00azr/byWGKmjH+s72u8wXxmApJMfRIsyaccgYIzOpaB1thKW2ba4tAkZCkxEIr
 04SYUXwPGN9m819ykCuH7v9t9nhEvnoIFTSN+5+1XPLVuKCL+piLs5GsxgeOGKkW6oa0 Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f97nbh45y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:39 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2378ds8o024729;
        Thu, 7 Apr 2022 08:44:39 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f97nbh453-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:39 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2378XLtM016680;
        Thu, 7 Apr 2022 08:44:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e491e3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2378iX7d43516204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:44:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAA61AE055;
        Thu,  7 Apr 2022 08:44:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24CE1AE045;
        Thu,  7 Apr 2022 08:44:33 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 08:44:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/9] s390x: snippets: asm: Add license and copyright headers
Date:   Thu,  7 Apr 2022 08:44:17 +0000
Message-Id: <20220407084421.2811-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407084421.2811-1-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sBPrryXlFobNfvdHhAE2VsTmf-4yPDRW
X-Proofpoint-ORIG-GUID: GrR2de-wr6mOwIq66yWUkuK4ybMn388H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time for some cleanup of the snippets to make them look like any other
test file.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/snippets/asm/snippet-pv-diag-288.S   | 9 +++++++++
 s390x/snippets/asm/snippet-pv-diag-500.S   | 9 +++++++++
 s390x/snippets/asm/snippet-pv-diag-yield.S | 9 +++++++++
 3 files changed, 27 insertions(+)

diff --git a/s390x/snippets/asm/snippet-pv-diag-288.S b/s390x/snippets/asm/snippet-pv-diag-288.S
index e3e63121..aaee3cd1 100644
--- a/s390x/snippets/asm/snippet-pv-diag-288.S
+++ b/s390x/snippets/asm/snippet-pv-diag-288.S
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Diagnose 0x288 snippet used for PV interception testing.
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
 #include <asm/asm-offsets.h>
 .section .text
 
diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets/asm/snippet-pv-diag-500.S
index 50c06779..8dd66bd9 100644
--- a/s390x/snippets/asm/snippet-pv-diag-500.S
+++ b/s390x/snippets/asm/snippet-pv-diag-500.S
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Diagnose 0x500 snippet used for PV interception tests
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
 #include <asm/asm-offsets.h>
 .section .text
 
diff --git a/s390x/snippets/asm/snippet-pv-diag-yield.S b/s390x/snippets/asm/snippet-pv-diag-yield.S
index 5795cf0f..78a5b07a 100644
--- a/s390x/snippets/asm/snippet-pv-diag-yield.S
+++ b/s390x/snippets/asm/snippet-pv-diag-yield.S
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Diagnose 0x44 and 0x9c snippet used for PV interception tests
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
 .section .text
 
 xgr	%r0, %r0
-- 
2.32.0

