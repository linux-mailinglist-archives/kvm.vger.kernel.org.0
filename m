Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B91584D5E
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 10:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbiG2I2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 04:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiG2I2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 04:28:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8393E83204
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 01:27:18 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T8Igs2027603
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vHXnHDpTloNk2ogAmOxJn1flc7fmoy7Bht6CezBdbso=;
 b=n5cO3Dn7KE03Dg04X7caqCyxMsiHqNqhziafhWG+0A5Abbxj0n7xjYGjfJQhqEWw9S/y
 OMSXIXub673wB6lk9BAwQqEYFXGlPzz6nKw4zLw/dcr0R6rPwJJT5viJvNHdUl22L96d
 8uKO/BMfq6Yz6uCSOi3B2De20Tg/dNCmcxN9WEwoAZMWOIpdf8+k6WgQTKpJH+Ewx1vR
 CEmusGYTwgb7Sgkuw6sTfuLAWJVmG3uDURVqHsGOMWpruapMeptfs7WWfFpXMF51ZCKq
 +8k/btJoKe/nj3GgpVblS5IsiVswzwhjaGLXIDGM+2DuIlVsBqH5FC3ZdGYZwKVLH5Io rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbx7g61g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26T8LYlI003052
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:17 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbx7g60j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:17 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26T8MbTt007098;
        Fri, 29 Jul 2022 08:27:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3hg945nhmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26T8RBvY30474552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 08:27:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA68C5204F;
        Fri, 29 Jul 2022 08:27:11 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 175D25204E;
        Fri, 29 Jul 2022 08:27:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 1/6] s390x: snippets: asm: Add a macro to write an exception PSW
Date:   Fri, 29 Jul 2022 08:26:28 +0000
Message-Id: <20220729082633.277240-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729082633.277240-1-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yQ0vHSpRc1QzAyaF84mlJDm_b25g4Ndu
X-Proofpoint-ORIG-GUID: kOvLHiTMqkxUJUe5H35f92ulRZdhMt9r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 mlxlogscore=963
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Setting exception new PSWs is commonly needed so let's add a macro for
that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.34.1

