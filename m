Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD824543AB8
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiFHRps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiFHRpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:45:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8506183167;
        Wed,  8 Jun 2022 10:45:45 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258FhSba027439;
        Wed, 8 Jun 2022 17:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JnD0ujQO3gPXjpIRdSMloY3wDrS/eiESuHbrBzwtPR4=;
 b=mXTpLExPVmS8zLxLzHzOzRvk5rRhJZMyfNdcfyUgETgUquEjIn48Y4Rw5w/lyFXumf5f
 CPm/bbNLBbRTu2XhD0v4iVccr/F1+NLSc7dYZ0y2cLsMFcgXy+nY1m+97YcweQu17GgO
 QGx6iYLJZGnkadUtAm9vsQU9KthJMekj1S1VNJIPZX6BCcpWZTNjfNbki1OkiOtPOLW9
 8a56mg+pyQQV4lr0ufjStpo9NBgPnyIUnK7N/1s3PiQG1FvpBft9itTwWzH/jAyNNt+R
 kgpc2w561Ez9Tqgkb/oL4CAJoPVVDeqECI2R3Gnb2zVd6e0DKF1uXQRka6L95e8Wl7/8 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjxngamka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:44 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258HVwOE009689;
        Wed, 8 Jun 2022 17:45:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjxngamk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258HM8Kq003344;
        Wed, 8 Jun 2022 17:45:42 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3gfy19dsen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258Hjd7k11534800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 17:45:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29D4111C04C;
        Wed,  8 Jun 2022 17:45:39 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E531B11C04A;
        Wed,  8 Jun 2022 17:45:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 17:45:38 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 3/3] s390x: Test effect of storage keys on diag 308
Date:   Wed,  8 Jun 2022 19:45:36 +0200
Message-Id: <20220608174536.1700357-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608174536.1700357-1-scgl@linux.ibm.com>
References: <20220608174536.1700357-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P-Ob8chekW0tP2PIWVhWjLqg3bNmII8r
X-Proofpoint-ORIG-GUID: aDdAqMm8Z2t1nqMOniTLLPLrKtnDbI7W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that key-controlled protection does not apply to diag 308.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/skey.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/s390x/skey.c b/s390x/skey.c
index 36b81cec..87418f19 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -305,6 +305,31 @@ static void test_store_cpu_address(void)
 	report_prefix_pop();
 }
 
+static void test_diag_308(void)
+{
+	uint16_t response;
+	uint32_t *ipib = (uint32_t *)pagebuf;
+
+	report_prefix_push("DIAG 308");
+	WRITE_ONCE(ipib[0], 0); /* Invalid length */
+	set_storage_key(ipib, 0x28, 0);
+	/* key-controlled protection does not apply */
+	asm volatile (
+		"lr	%%r2,%[ipib]\n\t"
+		"spka	0x10\n\t"
+		"diag	%%r2,%[code],0x308\n\t"
+		"spka	0\n\t"
+		"lr	%[response],%%r3\n"
+		: [response] "=d" (response)
+		: [ipib] "d" (ipib),
+		  [code] "d" (5)
+		: "%r2", "%r3"
+	);
+	report(response == 0x402, "no exception on fetch, response: invalid IPIB");
+	set_storage_key(ipib, 0x00, 0);
+	report_prefix_pop();
+}
+
 /*
  * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
  * with access key 1.
@@ -717,6 +742,7 @@ int main(void)
 	test_chg();
 	test_test_protection();
 	test_store_cpu_address();
+	test_diag_308();
 	test_channel_subsystem_call();
 
 	setup_vm();
-- 
2.33.1

