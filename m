Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811E66C6576
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjCWKnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjCWKn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:43:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BAE3B3FE
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:40:27 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N9fgQ8012435
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=W2XHJOQ7JrGTJF8+kIvW5eHutaHGZlOxepo0llJ+Sfk=;
 b=kBKEfw15JZDc8lkLEzQ8iweScNDwG1W9X1eBj8FDFYEgIHvAUG2quLF0dQSRigIUZQLl
 3pjEg7wmJoGvIrzKK6IuoWbrb1DeOtlO2/edE1wTEmfH8yfv4LpLFrnGMnhWhaDdWtjq
 wHKqvgR3zr4PMrwQUH/Wclg/cJL7cnQM9VpoIubTZ7ttufjpIAdI2xkN/5xtnFppVKUX
 +IVrwmWw4Mpwie4nLJZkUDBlH5JDZBjYa7DcEDt3cKvw6tlUtMNYAwidFErtfxZVyUJb
 VD9y7NT9QY9xinmqoHm4MgXx7oI7nhy02cLR9TLgE0Yf3+eyi2YvzQzPqEUYQUHZlsmp PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmc2hah8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:25 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32N9hvdm023491
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:25 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmc2hagf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:25 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32MNx1S7006800;
        Thu, 23 Mar 2023 10:40:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pd4x662fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NAeJ0x44302640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 10:40:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A97F2004D;
        Thu, 23 Mar 2023 10:40:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66EC320043;
        Thu, 23 Mar 2023 10:40:18 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 10:40:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org, nrb@linux.ibm.com
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 6/8] s390x: uv-host: Fix create guest variable storage prefix check
Date:   Thu, 23 Mar 2023 10:39:11 +0000
Message-Id: <20230323103913.40720-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230323103913.40720-1-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zyTJ1Wh8Q3dRD0HAtuEnk8BJwdHGCSei
X-Proofpoint-ORIG-GUID: yX-bgqXSyRgI8WKW8KbPQ2mDtjOfTvP-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230080
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want more than one cpu and the rc is 10B, not 109.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 42ea2a53..d92571b5 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -434,11 +434,15 @@ static void test_config_create(void)
 	       "base storage origin contains lowcore");
 	uvcb_cgc.conf_base_stor_origin = tmp;
 
-	if (smp_query_num_cpus() == 1) {
+	/*
+	 * Let's not make it too easy and use a second cpu to set a
+	 * non-zero prefix.
+	 */
+	if (smp_query_num_cpus() > 1) {
 		sigp_retry(1, SIGP_SET_PREFIX,
 			   uvcb_cgc.conf_var_stor_origin + PAGE_SIZE, NULL);
 		rc = uv_call(0, (uint64_t)&uvcb_cgc);
-		report(uvcb_cgc.header.rc == 0x10e && rc == 1 &&
+		report(uvcb_cgc.header.rc == 0x10b && rc == 1 &&
 		       !uvcb_cgc.guest_handle, "variable storage area contains lowcore");
 		sigp_retry(1, SIGP_SET_PREFIX, 0x0, NULL);
 	}
-- 
2.34.1

