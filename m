Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771FC60703C
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiJUGnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJUGnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:43:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DC3242C81
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 23:43:35 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L68Zxc031119
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eQakatbr7Fp3Mh+j479bIig8Yye+ByeP1jYgQrARLhc=;
 b=ZtEzP92Smu66vcIYg49h9Y1z9MP1uAxjzu37+aFFgKm0mTP2mMzjXMEgUB9l7MFgMbL/
 n5ga+2cLOLwc+mhtVz13DQMMnd1AZXGkqYCsozmHQ514CJQfmGSQGOHnerIjYLihYomU
 j3a1GUz3X+GA2xvRTtCtEYR4JcUys5Q3ZECnZx1ci8+/TytO7+rXlWPUfayA+JjjS/Qz
 YQWTYp87SPOGDUjybB1tv49HJi6qUVOi07N5tYH1ryPGF3dCNe99q3n4VCr+OLJ2nFdj
 qAHT1iZAkXTC9Q0ejX7HBw2d0lsHGbA2bsPVWOIEilR4YImTMkF2sg48Z6lVjtAVdWVP 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbnmf96n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:34 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29L6hIGN027686
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:34 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbnmf96mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 06:43:33 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29L6ar2A021244;
        Fri, 21 Oct 2022 06:43:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3k7mg8yjck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 06:43:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29L6hSeY53477654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 06:43:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 225A611C050;
        Fri, 21 Oct 2022 06:43:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71EA311C04A;
        Fri, 21 Oct 2022 06:43:27 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Oct 2022 06:43:27 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/6] s390x: snippets: asm: Add a macro to write an exception PSW
Date:   Fri, 21 Oct 2022 06:38:57 +0000
Message-Id: <20221021063902.10878-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021063902.10878-1-frankja@linux.ibm.com>
References: <20221021063902.10878-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gDcXRgMXNYGEuBfALEppf1M79EQOUgFW
X-Proofpoint-GUID: oCp00GPVWiraHwWdIEsTK1XT92UtkLDT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_01,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 clxscore=1015 adultscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210038
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
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

