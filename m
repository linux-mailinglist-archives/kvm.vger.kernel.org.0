Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BFD57CCD7
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiGUOHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGUOHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:07:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C78D108
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:16 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LE2FOl022398
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Uo5Wk0OMWHSjq1G86GD7t67IrtYE8IfdhooHSjS8ato=;
 b=BbZjvcusd5QzIxVsM0cqfL7z1ZdPSRm4swBUrhiORq9zW6S9X9K6l5owoRQhMBdtZJpQ
 Gs6LEREBgyrJoL+4BmStEEB0GBlmO0bRIduzYrkUchGny7jZWZ6iakIq3GfUU3ech5TJ
 LRZgVguW0ZacmThFT4rd6SSnPaTE2ySLDCvsXSzwFYkudpLOuktP7JnG+teN7Evn8MdT
 9Hkx7ozI6bEZWJfRfFDLZf+gXK1kIjKTPNMQypGBN5TGATEdDgP6A4+YKOES4iVgKZGB
 SqCneXnnfVFj+N/c8QXWLcq8Bbw9Te+NHGSoDltWTumThN+42Gw+REBrorlGHMheMTtj wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf87909y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:15 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LE3Fm7028543
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:14 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf87909mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:13 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE5gSB001114;
        Thu, 21 Jul 2022 14:07:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8wbky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE74kP12190018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:07:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A2B74C050;
        Thu, 21 Jul 2022 14:07:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA4F94C044;
        Thu, 21 Jul 2022 14:07:03 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:03 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 06/12] s390x: Test effect of storage keys on diag 308
Date:   Thu, 21 Jul 2022 16:06:55 +0200
Message-Id: <20220721140701.146135-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0KNHUAfrr3T8Wms_0T93fKRbGWoV_HO_
X-Proofpoint-ORIG-GUID: RLelixXkcy8MBow6h3IqGublwHdKBrwc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Test that key-controlled protection does not apply to diag 308.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20220621143609.753452-4-scgl@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

