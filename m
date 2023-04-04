Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1126D5F2B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbjDDLhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbjDDLhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BC12D45
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:36:57 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334AnLJ7008407;
        Tue, 4 Apr 2023 11:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=XoGhQ+IhWWkgbg5ayNE4GSkQkWFRBC9dgLYY+SD7ir0=;
 b=ZTVKfDbWtaYnv6b1DJID14Ev8h9xLMZCFm/ZUSD4o58RThJULEWBK9SrK8LzGYKbfJkf
 fqD+zmmqTa4fFzmQ1Nca18sKSZnSvVeZm1pfViuF0Xs0dYZwCyD5DgoMemPGSShlYKnQ
 bX31HZAhH1meh8d2P2PSaWMwYSfVDUxm9n88A3joT4ruXoejXCnZPxxOh4yonEuu59PA
 C7rtXih6/KL0PGIs8cf+k3AXZALECMqO4BzSgsW0A5z7VFjBB6Vmlpch6yw7Z11EITfa
 Vy5xymE1R7KQimqq3skIJ8FKqxbJ6TSbYkO3o8FU138l1dvK1atwfgzr/BuvVexNK6SS Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prjfs9486-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:55 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334B5o2Y011694;
        Tue, 4 Apr 2023 11:36:54 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prjfs947j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:54 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3348wd8b026520;
        Tue, 4 Apr 2023 11:36:52 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ppbvfsvdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:52 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334Bamvg20316870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:48 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF7E820040;
        Tue,  4 Apr 2023 11:36:48 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 528FA20043;
        Tue,  4 Apr 2023 11:36:48 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:48 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v2 08/14] s390x/spec_ex: Use PSW macro
Date:   Tue,  4 Apr 2023 13:36:33 +0200
Message-Id: <20230404113639.37544-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113639.37544-1-nrb@linux.ibm.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R9Tj0t0J_7iY8-PylKD4subYr52i4YL0
X-Proofpoint-GUID: UKzfqHA_JNIJbeMgJkSvkUDHcJzZttf7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Replace explicit psw definition by PSW macro.
No functional change intended.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230404085454.2709061-2-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/spec_ex.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 42ecaed..2adc599 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -105,10 +105,7 @@ static int check_invalid_psw(void)
 /* For normal PSWs bit 12 has to be 0 to be a valid PSW*/
 static int psw_bit_12_is_1(void)
 {
-	struct psw invalid = {
-		.mask = BIT(63 - 12),
-		.addr = 0x00000000deadbeee
-	};
+	struct psw invalid = PSW(BIT(63 - 12), 0x00000000deadbeee);
 
 	expect_invalid_psw(invalid);
 	load_psw(invalid);
@@ -118,10 +115,7 @@ static int psw_bit_12_is_1(void)
 /* A short PSW needs to have bit 12 set to be valid. */
 static int short_psw_bit_12_is_0(void)
 {
-	struct psw invalid = {
-		.mask = BIT(63 - 12),
-		.addr = 0x00000000deadbeee
-	};
+	struct psw invalid = PSW(BIT(63 - 12), 0x00000000deadbeee);
 	struct short_psw short_invalid = {
 		.mask = 0x0,
 		.addr = 0xdeadbeee
-- 
2.39.2

