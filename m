Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B9960CB2B
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiJYLo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiJYLn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9FB172B6E
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:56 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8T0D028356
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LBNGIx0NhGmblKcVx4Tvn9bAbddOPCXabpCjyURzZa4=;
 b=Ihmo645eoFoQ8D8S9pTMEBw14nbGAkpSubFvJG8PxIeVL3c+nJrxGThQn7D7Y6Ce+bKc
 SnaoiAaZ+DZFRG2e1ro9XHIWU2TzzRMn72KAvv7w5aBhMI3uWCr9+kgeB57WAMPMgsFk
 yhcGY3cGcINW/mvcqiyfAq619xvUjhWSz6R6HJKlgXU3UyDm+ayVXyiLedXX3vFV07mC
 PedGEUSk0+JiXajRxf6qUetoqbw4KtEDC4d15S4xji83vKfyt9xHpxg0Ay3+3j9FPoQ5
 TaEGz5HJGDWoFzpQg/NprbTWF49jKiKaSbWmXGc3QjLAJ0n25BabK+IIQ/a0057vrAAP cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kebjt8aaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PBFMcL026943
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kebjt8aa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBc2fm026793;
        Tue, 25 Oct 2022 11:43:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3kc859dhpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhoO24981398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3589EAE045;
        Tue, 25 Oct 2022 11:43:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 038A3AE051;
        Tue, 25 Oct 2022 11:43:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 17/22] s390x: snippets: asm: Add a macro to write an exception PSW
Date:   Tue, 25 Oct 2022 13:43:40 +0200
Message-Id: <20221025114345.28003-18-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UvGy8eSs2XqvYcjgr8f1wAt94uczpVwp
X-Proofpoint-ORIG-GUID: CRhwr9B-kgS9IlV8ILYM9FCTq_ZOHkTV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 mlxscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Setting exception new PSWs is commonly needed so let's add a macro for
that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20221021063902.10878-2-frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/snippets/asm/macros.S              | 28 ++++++++++++++++++++++++
 s390x/snippets/asm/snippet-pv-diag-288.S |  4 ++--
 s390x/snippets/asm/snippet-pv-diag-500.S |  6 ++---
 3 files changed, 32 insertions(+), 6 deletions(-)
 create mode 100644 s390x/snippets/asm/macros.S

diff --git a/s390x/snippets/asm/macros.S b/s390x/snippets/asm/macros.S
new file mode 100644
index 00000000..667fb6dc
--- /dev/null
+++ b/s390x/snippets/asm/macros.S
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Commonly used assembly macros
+ *
+ * Copyright (c) 2022 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <asm/asm-offsets.h>
+
+/*
+ * Writes a PSW to addr_psw, useful for exception PSWs in lowcore
+ *
+ * reg is the scratch register used for temporary storage, it's NOT restored
+ * The psw address part is defined via psw_new_addr
+ * The psw mask part is always 64 bit
+ */
+.macro SET_PSW_NEW_ADDR reg, psw_new_addr, addr_psw
+larl	\reg, psw_mask_64
+stg	\reg, \addr_psw
+larl	\reg, \psw_new_addr
+stg	\reg, \addr_psw + 8
+.endm
+
+.section .rodata
+psw_mask_64:
+	.quad	0x0000000180000000
diff --git a/s390x/snippets/asm/snippet-pv-diag-288.S b/s390x/snippets/asm/snippet-pv-diag-288.S
index aaee3cd1..63f2113b 100644
--- a/s390x/snippets/asm/snippet-pv-diag-288.S
+++ b/s390x/snippets/asm/snippet-pv-diag-288.S
@@ -8,6 +8,7 @@
  *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <asm/asm-offsets.h>
+#include "macros.S"
 .section .text
 
 /* Clean and pre-load registers that are used for diag 288 */
@@ -19,8 +20,7 @@ lghi	%r1, 2
 lghi	%r2, 3
 
 /* Let's jump to the pgm exit label on a PGM */
-larl	%r4, exit_pgm
-stg     %r4, GEN_LC_PGM_NEW_PSW + 8
+SET_PSW_NEW_ADDR 4, exit_pgm, GEN_LC_PGM_NEW_PSW
 
 /* Execute the diag288 */
 diag	%r0, %r2, 0x288
diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets/asm/snippet-pv-diag-500.S
index 8dd66bd9..f4d75388 100644
--- a/s390x/snippets/asm/snippet-pv-diag-500.S
+++ b/s390x/snippets/asm/snippet-pv-diag-500.S
@@ -8,6 +8,7 @@
  *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <asm/asm-offsets.h>
+#include "macros.S"
 .section .text
 
 /* Clean and pre-load registers that are used for diag 500 */
@@ -21,10 +22,7 @@ lghi	%r3, 3
 lghi	%r4, 4
 
 /* Let's jump to the next label on a PGM */
-xgr	%r5, %r5
-stg	%r5, GEN_LC_PGM_NEW_PSW
-larl	%r5, next
-stg	%r5, GEN_LC_PGM_NEW_PSW + 8
+SET_PSW_NEW_ADDR 5, next, GEN_LC_PGM_NEW_PSW
 
 /* Execute the diag500 */
 diag	0, 0, 0x500
-- 
2.37.3

