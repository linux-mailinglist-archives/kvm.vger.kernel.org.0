Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55696667A13
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbjALP5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjALP4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:56:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5325FE1;
        Thu, 12 Jan 2023 07:47:38 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CFcrrx011765;
        Thu, 12 Jan 2023 15:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ll1HBSaTjnNwq5VWjmoTQ922t4aAQXroHF/DN5fBBQI=;
 b=hwLsFEc737RQ3xGsGX5+jfrQsgR2qnquofefBhbqkgPZ06f+rDnA88al4U9cAEz1nwsC
 PKDfFKNLSa81Y7+5ML9f7mmyr10aQUXMlH42DmieIClF4Ug7TWpRVvT+apj0S23b6M5U
 B9dGHQPLG9trwLkjMEISsv/PqABHAbo/Dg1RZRpx65iPcgvRy1iXjMFWIP8hyEf1JwCN
 ncj81qT3UsRLTf/mtx8RauRDCj0MwLOM4ELer+OdagdvTAyKD3Ndy0dqSplx+g/2a4kI
 9FbuhnLlANp7W11ziE+zPw8HtiNv67IQ7Z2UngDDre37IgKcVWo/c5OZjmBh76NnYvLY jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2mb0hhdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:47:37 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30CFd5km012467;
        Thu, 12 Jan 2023 15:47:37 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2mb0hhca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:47:37 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CC5BRU030569;
        Thu, 12 Jan 2023 15:46:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n1kyx9xsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CFka2420381964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 15:46:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2663620040;
        Thu, 12 Jan 2023 15:46:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0449E2004B;
        Thu, 12 Jan 2023 15:46:36 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 15:46:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/7] s390x: snippets: c: Cleanup flat.lds
Date:   Thu, 12 Jan 2023 15:45:43 +0000
Message-Id: <20230112154548.163021-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112154548.163021-1-frankja@linux.ibm.com>
References: <20230112154548.163021-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y3GNx-DAt8zmkKT7mnd3FkDROXGNQj-v
X-Proofpoint-ORIG-GUID: T1Yt3a6T4rM8YGC8XC5DQVftVEd0L79i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_08,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 mlxlogscore=746 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are a lot of things in there which we don't need for snippets
and the alignments can be switched from 64K to 4K since that's the
s390 page size.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.34.1

