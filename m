Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6527C531460
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiEWNY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 09:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiEWNYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 09:24:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773B712D22;
        Mon, 23 May 2022 06:24:17 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ND6aBg016906;
        Mon, 23 May 2022 13:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HzBAqXTluqfHmRDvLzs26uLfXg3kXGzzuFGVf2/5Tbs=;
 b=FJgJemFQRKngp5zQXNI5sTalGY6s7CrFvAQ8PIIqBGtn2k/ZNDJ2bwK4uZ/p1sC9HO7J
 LFtj6ar7lGiw3cg//5DZ/HS0mkFnVafW5L8pXtn4cB8PVvuF+P61bXmV2C7M7LducbTk
 wQYKQOPNpCJSeMV/aepLaUyTdSHGteChxGY1z3yEbH58fL06yB35OcJCgdSTQgAj5ZBV
 b6UK7GbR2eqQFJlWJqYdHvBx7MU6G4irxTG8GxQ3jsabTFdsvUKSBIN1Ed1/060oEuBn
 AUY4aE6WNRoO8P6ML2EmlJIPcPH1Lq5HrvHZ2lcZCv4SO+COn3vNGshkB1aPgqtxDx2v ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g87p05bb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 13:24:16 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24ND16Ro017168;
        Mon, 23 May 2022 13:24:16 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g87p05ba6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 13:24:16 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24NCKoEj011955;
        Mon, 23 May 2022 13:24:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3g6qq9ad72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 13:24:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24NDNMms32375138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 13:23:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6524A404D;
        Mon, 23 May 2022 13:24:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DBACA4040;
        Mon, 23 May 2022 13:24:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 May 2022 13:24:09 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 3/3] s390x: Test effect of storage keys on diag 308
Date:   Mon, 23 May 2022 15:24:06 +0200
Message-Id: <20220523132406.1820550-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220523132406.1820550-1-scgl@linux.ibm.com>
References: <20220523132406.1820550-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Qc9NBEapVJ6vExRuqSvEZXg6tt-Dnxj8
X-Proofpoint-GUID: FBtQX8bxlfpdX05M1isNvmdOtvSAbGgG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 mlxscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230073
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
---
 s390x/skey.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/s390x/skey.c b/s390x/skey.c
index a55034b5..074667e2 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -300,6 +300,31 @@ static void test_store_cpu_address(void)
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
@@ -712,6 +737,7 @@ int main(void)
 	test_chg();
 	test_test_protection();
 	test_store_cpu_address();
+	test_diag_308();
 	test_channel_subsystem_call();
 
 	setup_vm();
-- 
2.33.1

