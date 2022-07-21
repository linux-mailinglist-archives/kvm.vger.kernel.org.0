Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B2657CCE4
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiGUOIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiGUOIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:08:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CCB7AB1A
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:56 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDVHtj029863
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=W+sJrchunV5VAqANENWoIhOlTxq1C+gX0gZqhUsiMXc=;
 b=GjaOF/QWg2s0SPDJzADr85uCQ+5h+5DbEa9wmxGp5vwxe0JA4Fga76BB9hOviA5VSJQ2
 GMjmeoBt+Dm5bxY7FvC0Kw6B0ckjN4UY1KwbfpDT1wrvLIBRQBqyTSOsiP48a7HRwjFa
 9z+mTRjYuDMVyYI07MX1Zswvh2uRK2cZNFAmGc+X39E7JB6OQRYjSzprtAn1Q6D0MqUM
 TyGfC0Y4Ux86UqN78d7XEoGC7TRBYNHYQNCmtP5glJuArzy+s/kgnuVz3ktKSEeN3mCR
 WP4T2eRPhLW9O9joIsFQdsbOsfti02bNmntPAyuha02eZLGUQW5s8DYz2ID23p2+sqJV Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7rrscs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:55 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LE2QVn013057
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:47 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7rrsc1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:47 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE70S4031126;
        Thu, 21 Jul 2022 14:07:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3hbmy8y6gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE76J917433044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:07:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAEF64C058;
        Thu, 21 Jul 2022 14:07:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A72FC4C050;
        Thu, 21 Jul 2022 14:07:05 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:05 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 11/12] s390x: intercept: fence one test when using TCG
Date:   Thu, 21 Jul 2022 16:07:00 +0200
Message-Id: <20220721140701.146135-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v9Ld2m-Z6Nb0EnwLN4ATJ0ja-r8Dxog0
X-Proofpoint-GUID: NQFw6kFuI83ny_74Z-UK2Ae6NLBnGGrG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Qemu commit f8333de2793 ("target/s390x/tcg: SPX: check validity of new prefix")
fixes a TCG bug discovered with a new testcase in the intercept test.

The gitlab pipeline for the KVM unit tests uses TCG and it will keep
failing every time as long as the pipeline uses a version of Qemu
without the aforementioned patch.

Fence the specific testcase for now. Once the pipeline is fixed, this
patch can safely be reverted.

This patch is meant to go on top this already queued patch from Janis:
"s390x/intercept: Test invalid prefix argument to SET PREFIX"
https://lore.kernel.org/all/20220627152412.2243255-1-scgl@linux.ibm.com/

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20220721133002.142897-2-imbrenda@linux.ibm.com
Message-Id: <20220721133002.142897-2-imbrenda@linux.ibm.com>
---
 s390x/intercept.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/s390x/intercept.c b/s390x/intercept.c
index 54bed5a4..656b8adb 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/time.h>
+#include <hardware.h>
 
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
@@ -76,7 +77,8 @@ static void test_spx(void)
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 
 	new_prefix = get_ram_size() & 0x7fffe000;
-	if (get_ram_size() - new_prefix < 2 * PAGE_SIZE) {
+	/* TODO: Remove host_is_tcg() checks once CIs are using QEMU >= 7.1 */
+	if (!host_is_tcg() && (get_ram_size() - new_prefix < 2 * PAGE_SIZE)) {
 		expect_pgm_int();
 		asm volatile("spx	%0 " : : "Q"(new_prefix));
 		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
@@ -88,7 +90,10 @@ static void test_spx(void)
 		 * the address to 8k we have a completely accessible area.
 		 */
 	} else {
-		report_skip("inaccessible prefix area");
+		if (host_is_tcg())
+			report_skip("inaccessible prefix area (workaround for TCG bug)");
+		else
+			report_skip("inaccessible prefix area");
 	}
 }
 
-- 
2.36.1

