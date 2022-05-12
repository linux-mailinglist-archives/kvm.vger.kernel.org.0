Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD12152491D
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352052AbiELJgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352036AbiELJfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BD469B7C
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:38 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9FM7J021301
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Yfj2xwdUzOmOiVT5LK5MFFrMVuZrd91sSVqc1+lKy70=;
 b=f9+ZUfg8QcRC03jGmH87GjkHLgVfJ21UlJ8p03HgpkV3Hwt5M2eGEeLfLAL5kkN7mJpY
 xj4jyouvcPo6NADEd8lT+Y9uH4g9GU9bn9VAbP6/HD29RuDRYIHEyP2Ixc7W70KrMZel
 CwfJnQaDAl7phLhZzESZq+MZUslqdliVWw2kamD9Pv6lOZ+ZnnsJeE1m37pkEtDj5kmD
 pyy4yDzCcv+qC7+ajsk/j3n+a+VzL6ojz0pzGiALVQvHRTHJqO7vkTTLWkyJ0rBKETUC
 1NGp9m74eeLbgUgLSjY0Ff2Z1u0Q7Ck17GojwIxNRrSAs16FICyeCB1sTcgHaj2IaBIo 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9VvjT032151
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:37 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XWCc008194;
        Thu, 12 May 2022 09:35:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3fwgd8wa01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZWcK44630412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7572C11C04A;
        Thu, 12 May 2022 09:35:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 354D111C04C;
        Thu, 12 May 2022 09:35:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:32 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 10/28] s390x: snippets: asm: Add license and copyright headers
Date:   Thu, 12 May 2022 11:35:05 +0200
Message-Id: <20220512093523.36132-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EOdj_8y4dHo5raWxEjdmTW5q2xWAdvkA
X-Proofpoint-GUID: SOBT3oYCneIwRE5e8unJIaRFlEOKVMbS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Time for some cleanup of the snippets to make them look like any other
test file.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.36.1

