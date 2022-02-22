Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD3A4BFB48
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 15:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbiBVOzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 09:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiBVOze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 09:55:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E2F10C527;
        Tue, 22 Feb 2022 06:55:08 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MDhWdI024872;
        Tue, 22 Feb 2022 14:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ayq88onlxV92hKR0dP6eKjRmjM6rdQBMYSPSToOWGd4=;
 b=PLfwY3fwkdA5BXIeyxG2P4B0nJ3srPGjaUclgy/DfUd04ireULmW1yUFnzPJtEvrlTjW
 0BzE9ZZwJ2ddK9MGbMpy678DZpsiS6nwzykPVYdo0CjYy8r/BG9LHQpKxX1QeiQH7yZ3
 Z2kb03/xvmzk0ACBSQCB7rmiCfNYvJY0GMOF9hySwSlgXYmRqyXNEI/k6nctDJSUAGVJ
 LSfKCei9/E33j0DEQBqPIqmFi5IrJfglPIBBESqdYeWrvEH8EJArMvIQtZ5esUSSxObI
 2vryWFicp0rMKOnUoNTtcUjJDb7uqGADyJmdHVyYAvfd+FGM97cltOE5UQoe1THxHt+Q IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecyn9v20y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:08 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21MEMOA0005388;
        Tue, 22 Feb 2022 14:55:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecyn9v1yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21MEhdMW010539;
        Tue, 22 Feb 2022 14:55:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear693pu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:05 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21MEt2xE59179448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 14:55:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51DD1A4060;
        Tue, 22 Feb 2022 14:55:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24957A405F;
        Tue, 22 Feb 2022 14:55:01 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 14:55:00 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 3/5] s390x: uv-guest: remove duplicated checks
Date:   Tue, 22 Feb 2022 14:54:54 +0000
Message-Id: <20220222145456.9956-4-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222145456.9956-1-seiden@linux.ibm.com>
References: <20220222145456.9956-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _fUbV2enR6NEX8sq_K35ImbSMatpS-iM
X-Proofpoint-ORIG-GUID: XqMg0wbUf1gmce9JNLqb88124dIs7hO-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202220091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

