Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134985534A0
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 16:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351815AbiFUOg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 10:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351798AbiFUOgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 10:36:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3DD20F73;
        Tue, 21 Jun 2022 07:36:25 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEC7un005571;
        Tue, 21 Jun 2022 14:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hgMdGcg41BVdqgv5+jxaCc6AmMGSC7+z4Gt13mJZ4/c=;
 b=nq60W9O1Pm7juQr/F31iSh8tv439VMltr3hozWrmNiXNwEIslcJRxeFpVLVb/i8VMjJu
 TcTZgYcNc9hXEKjPjeOevTVAHB6/UQKtB7Ot5jKIUuthBo757FUIOiHR0eFmk2bSmdW9
 hq/ZT7YvR7hpwLNDOfHrODV/cIqMxyP7M0PRcxIGZUzC3f71E4zLv2ne4BIjTHg99dIW
 SEdHd6zkt3/UIc+ypKu1EWizeq4KI94MMYQRY1DztCV/a5GZdZKtnUMhWura5IvmMbuy
 j4cKZLjB/PsmXc2HZpO7T6g8ANf7u+68VBkS2tRYebhKyB+0VHJumilxXeqvYAhi38S8 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufhm8wa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:24 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEDi7i014366;
        Tue, 21 Jun 2022 14:36:24 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufhm8w3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:23 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LEYsIo011808;
        Tue, 21 Jun 2022 14:36:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3gs6b939mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LEaC7m23986566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 14:36:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E3AEA4054;
        Tue, 21 Jun 2022 14:36:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B1B0A4060;
        Tue, 21 Jun 2022 14:36:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 14:36:12 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 3/3] s390x: Test effect of storage keys on diag 308
Date:   Tue, 21 Jun 2022 16:36:09 +0200
Message-Id: <20220621143609.753452-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220621143609.753452-1-scgl@linux.ibm.com>
References: <20220621143609.753452-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0TUK7-47wlYdKLLwheAKsxGPD-Y2MLWn
X-Proofpoint-GUID: wNc2P_VawT56o15P8oUOKZ6xj7LSG2CM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_07,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210062
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
index aa9b4dcd..7e85f97d 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -303,6 +303,31 @@ static void test_store_cpu_address(void)
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
@@ -715,6 +740,7 @@ int main(void)
 	test_chg();
 	test_test_protection();
 	test_store_cpu_address();
+	test_diag_308();
 	test_channel_subsystem_call();
 
 	setup_vm();
-- 
2.36.1

