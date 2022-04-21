Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF76F509CA2
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 11:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387883AbiDUJsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 05:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387858AbiDUJs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 05:48:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B9125C74;
        Thu, 21 Apr 2022 02:45:38 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9GaAg007990;
        Thu, 21 Apr 2022 09:45:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ayq88onlxV92hKR0dP6eKjRmjM6rdQBMYSPSToOWGd4=;
 b=KHmJGLUE+EQ8tj4Sp4BNaPrwLl26+Mt3v+l5gzKgQkcP2NgIAyU1zLvND+R/U49ZT8kn
 boVK8qRxDz4h8V95cmDD2ktXe71MkTKvFsLIn+WQVCqXcbC5pS4ime6fhXjGF5h9TaRO
 K6rC3xKaBcH7wY8a0913ldhw4Z1N7/u8OGgy0mJkrDO66F/LSlIQOVBJ2KJprwjKD7Ie
 Fd/s/naV2QZ8+q/DW+hvKQDvvd9+Boj0hRuri2CPUlmdOk9OvnD8jyNj8hRfIjhEMG1c
 4MCMwtpcoABlO52nlUXKGgm4VbvTEFYSPCzabnNBi7nB52uIjP1k5yWJZwTuckSFVw/7 Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjhsy70kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:37 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L9XXj0014747;
        Thu, 21 Apr 2022 09:45:37 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjhsy70k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:37 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L9dLYh014180;
        Thu, 21 Apr 2022 09:45:35 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne97mjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L9jg332949790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 09:45:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81AF811C052;
        Thu, 21 Apr 2022 09:45:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C078811C04A;
        Thu, 21 Apr 2022 09:45:30 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 09:45:30 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 3/5] s390x: uv-guest: remove duplicated checks
Date:   Thu, 21 Apr 2022 09:45:25 +0000
Message-Id: <20220421094527.32261-4-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421094527.32261-1-seiden@linux.ibm.com>
References: <20220421094527.32261-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u-8RI6FLuPA_Fhp2QLN8OIX5_Y79z8EB
X-Proofpoint-GUID: X7l4ikpCb0KRLAqKoMIYDMS2On0S8_h5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Removing some tests which are done at other points in the code
implicitly.

In lib/s390x/uc.c#setup_uv(void) the rc of the qui result is verified
using asserts.
The whole test is fenced by lib/s390x/uc.c#uv_os_is_guest(void) that
checks if SET and REMOVE SHARED is present.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-guest.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 99120cae..728c60aa 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -69,23 +69,15 @@ static void test_query(void)
 	cc = uv_call(0, (u64)&uvcb);
 	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
 
-	uvcb.header.len = sizeof(uvcb);
-	cc = uv_call(0, (u64)&uvcb);
-	report((!cc && uvcb.header.rc == UVC_RC_EXECUTED) ||
-	       (cc == 1 && uvcb.header.rc == 0x100),
-		"successful query");
-
 	/*
-	 * These bits have been introduced with the very first
-	 * Ultravisor version and are expected to always be available
-	 * because they are basic building blocks.
+	 * BIT_UVC_CMD_QUI, BIT_UVC_CMD_SET_SHARED_ACCESS and
+	 * BIT_UVC_CMD_REMOVE_SHARED_ACCESS are always present as they
+	 * have been introduced with the first Ultravisor version.
+	 * However, we only need to check for QUI as
+	 * SET/REMOVE SHARED are used to fence this test to be only
+	 * executed by protected guests.
 	 */
-	report(test_bit_inv(BIT_UVC_CMD_QUI, &uvcb.inst_calls_list[0]),
-	       "query indicated");
-	report(test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
-	       "share indicated");
-	report(test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
-	       "unshare indicated");
+	report(uv_query_test_call(BIT_UVC_CMD_QUI), "query indicated");
 	report_prefix_pop();
 }
 
-- 
2.30.2

