Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31790667A08
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240580AbjALP52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbjALP4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:56:31 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A435D412;
        Thu, 12 Jan 2023 07:46:42 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CFhB1t035687;
        Thu, 12 Jan 2023 15:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KFUrNtigUEeaHqHBmmpeE1iOWem11CVHE+3cGHeVykU=;
 b=forpD1MPaH6QLhqUZSH9eaQ5lRnTUeSz7SXtQFvxfG8D5Ay6XaRxcgs0mQOs3KukkL/P
 rWc2+TJp19ifIkJ1OzlL3GK1+RDZ/PiuUjaic38apu/OqGtHm/9lX52oMZcQHjFo2GPc
 nNiHNXg30HxrcLxD9YlqJRGxV10W9QNPYST2wjbo5dbzzNe4+h2VDpycNFDPE1Eo+K0d
 WujoN3Fru2FastGO1o4/7xRqXVy7CG4GjBdPu6CGMoUXX3bX9wmHf3JNSrq2a/GVw/T3
 QxfTlH7UwmG8NYdd4wFkWxSP+MPSPyIkHYZVs0O6MQYt3Km61cMbPFlLCFfu8iHGgY8T 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2n3e835n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:41 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30CFh1S9035247;
        Thu, 12 Jan 2023 15:46:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2n3e834u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CFMRWd030858;
        Thu, 12 Jan 2023 15:46:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n1kf7jprf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CFkac223658982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 15:46:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F32FF20049;
        Thu, 12 Jan 2023 15:46:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C81A420040;
        Thu, 12 Jan 2023 15:46:35 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 15:46:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/7] s390x: Cleanup flat.lds
Date:   Thu, 12 Jan 2023 15:45:42 +0000
Message-Id: <20230112154548.163021-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112154548.163021-1-frankja@linux.ibm.com>
References: <20230112154548.163021-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -cWULVOz1rVe4br72WcDKGie9Y_A1dcY
X-Proofpoint-GUID: W0r4RtyFv7k3fyyhMMcrV_SFf77wkBGI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_08,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=987
 malwarescore=0 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It seems like the loader file was copied over from another
architecture which has a different page size (64K) than s390 (4K).

Let's use a 4k alignment instead of the 64k one and remove unneeded
entries.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/flat.lds | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/s390x/flat.lds b/s390x/flat.lds
index de9da1a8..952f6cd4 100644
--- a/s390x/flat.lds
+++ b/s390x/flat.lds
@@ -24,20 +24,8 @@ SECTIONS
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
 	.data : {
 		*(.data)
 		*(.data.rel*)
@@ -48,10 +36,11 @@ SECTIONS
 	__bss_start = .;
 	.bss : { *(.bss) }
 	__bss_end = .;
-	. = ALIGN(64K);
+	. = ALIGN(4K);
 	edata = .;
+	/* Reserve 64K for the stack */
 	. += 64K;
-	. = ALIGN(64K);
+	. = ALIGN(4K);
 	/*
 	 * stackptr set with initial stack frame preallocated
 	 */
-- 
2.34.1

