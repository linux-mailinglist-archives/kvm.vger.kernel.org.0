Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60529699AE0
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjBPRNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBPRNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:13:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F1D4E5CC
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:13:02 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GGfg3C025129
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=PfJD8uNVWHyySio+b+MYaXlGRKlFmIIrsUdNruxhpc4=;
 b=nNhQFLx7JfKVmR9S2qQ8rxt3O+PWKlTxMwV/ysJhxuSe/EvEwlmVwpdtU4eS4g4PgAJ0
 e212bilTQpQsLzeNwWUfwksctsH8HN9UF2TO7tp+caxwh3RO18bFkvj1i8bV9t4IRmyX
 qHO7vpnDur7C49OLL3yTp/xAId6xq3cZC8ofwCZbsWS4DGisunZgrz62wuHN7l+whgpB
 YLjIxTTm2+LCRZfMY4mD87SQhLeSf6cLtMgTDmzxwNd6bPIBZ7lNizPT5oKurcJSok3s
 Pe3X2cIyff++/RV91jYYMmbUa++IWEidFD+wo/5Kd5jHof75zjQ0chWhUmX4MAh247+w WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsr7tgsd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GH0WaZ031655
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsr7tgsc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:13:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G63IWW010953;
        Thu, 16 Feb 2023 17:12:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6xyn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:12:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GHCuWn46596466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 17:12:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD6AC2004F;
        Thu, 16 Feb 2023 17:12:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B62AD2004B;
        Thu, 16 Feb 2023 17:12:56 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 17:12:56 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 05/10] s390x: snippets: c: Cleanup flat.lds
Date:   Thu, 16 Feb 2023 18:12:50 +0100
Message-Id: <20230216171255.48799-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216171255.48799-1-imbrenda@linux.ibm.com>
References: <20230216171255.48799-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pFOCw9mtiC_5Rwi8og3sgWx1DYt6MoEt
X-Proofpoint-GUID: zR5JAlRQ9uDpTJrjR8PZ_eN9DCQICDzg
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_13,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0
 adultscore=0 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=832 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

There are a lot of things in there which we don't need for snippets
and the alignments can be switched from 64K to 4K since that's the
s390 page size.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230112154548.163021-3-frankja@linux.ibm.com
Message-Id: <20230112154548.163021-3-frankja@linux.ibm.com>
---
 s390x/snippets/c/flat.lds | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
index 260ab1c4..9e5eb66b 100644
--- a/s390x/snippets/c/flat.lds
+++ b/s390x/snippets/c/flat.lds
@@ -16,27 +16,22 @@ SECTIONS
 		 QUAD(0x0000000000004000)
 	}
 	. = 0x4000;
+	/*
+	 * The stack grows down from 0x4000 to 0x2000, we pre-allocoate
+	 * a frame via the -160.
+	 */
 	stackptr = . - 160;
 	stacktop = .;
+	/* Start text 0x4000 */
 	.text : {
 		*(.init)
 		*(.text)
 		*(.text.*)
 	}
-	. = ALIGN(64K);
+	. = ALIGN(4K);
 	etext = .;
-	.opd : { *(.opd) }
-	. = ALIGN(16);
-	.dynamic : {
-		dynamic_start = .;
-		*(.dynamic)
-	}
-	.dynsym : {
-		dynsym_start = .;
-		*(.dynsym)
-	}
-	.rela.dyn : { *(.rela*) }
-	. = ALIGN(16);
+	/* End text */
+	/* Start data */
 	.data : {
 		*(.data)
 		*(.data.rel*)
@@ -44,11 +39,6 @@ SECTIONS
 	. = ALIGN(16);
 	.rodata : { *(.rodata) *(.rodata.*) }
 	. = ALIGN(16);
-	__bss_start = .;
 	.bss : { *(.bss) }
-	__bss_end = .;
-	. = ALIGN(64K);
-	edata = .;
-	. += 64K;
-	. = ALIGN(64K);
+	/* End data */
 }
-- 
2.39.1

