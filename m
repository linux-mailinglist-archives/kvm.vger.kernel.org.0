Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74ED866CE85
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjAPSNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbjAPSMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:12:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CD63B3CB
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:59:09 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHXf7s006681
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NsB+ZTfQ2Yef4dtXYg0qkzLmShHQ5mwGJb+eTOBekWU=;
 b=fNyRjKrWHIXQ0H4pJkY5Yk74JEkcOoG1n3h+d9CyU+70kn4oW6CIbcLKmf1FCCUDR1zD
 Dl9maZghY2/q4EhSsy5V33qysZAmgFYV9gp/T/U6Ygx9v2lPkPBkdCMHrWXVPeNhdgq4
 ixz0uSGj8ZVQutZgldnwFRSw4sNDSwIkf0adGIMVuSahKu9O1iCLHHtABFTQKh4lkOaj
 FQROeio3Sg3YpSh5JkMKK4IjPLbbVr1eHDcXYvnsIKN40mrX2/PQrZP34XSCEZ1Ulw4B
 WfpW8D7SBkfGuE2yLhhe4oFd/HM9pawJzLGjUprXRosQE0juk5eYjgIuRlL2H7EY6hgQ VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n4cvx1x0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:08 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHx85V018125
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n4cvx1x0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GFebfP023789;
        Mon, 16 Jan 2023 17:59:06 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16jrtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GHx2SJ22479104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:59:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 653E62004B;
        Mon, 16 Jan 2023 17:59:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B42EF20040;
        Mon, 16 Jan 2023 17:59:01 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.31.34])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 17:59:01 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 8/9] s390x: use STACK_FRAME_SIZE macro in linker scripts
Date:   Mon, 16 Jan 2023 18:57:56 +0100
Message-Id: <20230116175757.71059-9-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116175757.71059-1-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VFCVYRxF1ad_SvgSc09Ekdrbi66u98QV
X-Proofpoint-GUID: uGdT1ifBaDzXTHo7FTM8l8vUvgRwbUtI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=988 phishscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301160131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the `STACK_FRAME_SIZE` macro instead of a hard-coded value of 160.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/flat.lds.S            | 4 +++-
 s390x/snippets/c/flat.lds.S | 6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/s390x/flat.lds.S b/s390x/flat.lds.S
index 952f6cd457ed..0cb7e383cc76 100644
--- a/s390x/flat.lds.S
+++ b/s390x/flat.lds.S
@@ -1,3 +1,5 @@
+#include <asm/asm-offsets.h>
+
 SECTIONS
 {
 	.lowcore : {
@@ -44,6 +46,6 @@ SECTIONS
 	/*
 	 * stackptr set with initial stack frame preallocated
 	 */
-	stackptr = . - 160;
+	stackptr = . - STACK_FRAME_SIZE;
 	stacktop = .;
 }
diff --git a/s390x/snippets/c/flat.lds.S b/s390x/snippets/c/flat.lds.S
index 9e5eb66bec23..468b5f1eebe8 100644
--- a/s390x/snippets/c/flat.lds.S
+++ b/s390x/snippets/c/flat.lds.S
@@ -1,3 +1,5 @@
+#include <asm/asm-offsets.h>
+
 SECTIONS
 {
 	.lowcore : {
@@ -18,9 +20,9 @@ SECTIONS
 	. = 0x4000;
 	/*
 	 * The stack grows down from 0x4000 to 0x2000, we pre-allocoate
-	 * a frame via the -160.
+	 * a frame via the -STACK_FRAME_SIZE.
 	 */
-	stackptr = . - 160;
+	stackptr = . - STACK_FRAME_SIZE;
 	stacktop = .;
 	/* Start text 0x4000 */
 	.text : {
-- 
2.34.1

