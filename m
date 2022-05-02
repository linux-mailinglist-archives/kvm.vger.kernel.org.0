Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FDC516D94
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 11:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384328AbiEBJnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 05:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384318AbiEBJnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 05:43:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F3715A22;
        Mon,  2 May 2022 02:39:36 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2426tpbR020879;
        Mon, 2 May 2022 09:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ayq88onlxV92hKR0dP6eKjRmjM6rdQBMYSPSToOWGd4=;
 b=NHkT+vIwOjaFWi3r10jNFq5qC35KwNOZ2Ua4eq8nY66UWlT8v+Qr1bMBFnoHcmyJdNcg
 UaCYABz/F+efRz+E+UKG8+NznqIaWPmfk/edGJleSwLt7M4p+uKcGF2fdzv2IfFrw9Lp
 yu31bzGj4Pzo8g8rZ3NAxmwW3Wc0JpshNN1paxdw9ToC0Sz09dnwlB/sttfzYH+yfh1W
 pdlv8etWeUApwvH5nkJgMaYM7P3PG2UxqCr5hLbJokGvLizH75slCYdnwZcNBAQmlSo2
 Yu3yQPN3IZB9wAdigre2twveBB0JCi8SqgSlhfY1KEWBykNIhEGghVtet5aI0sTNHq+o xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftafd2u8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:35 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2429LbkG023794;
        Mon, 2 May 2022 09:39:34 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftafd2u80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:34 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2429btjk001540;
        Mon, 2 May 2022 09:39:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3frvr8t1kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2429QEho47841688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 09:26:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A666BAE055;
        Mon,  2 May 2022 09:39:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5AE6AE045;
        Mon,  2 May 2022 09:39:28 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 09:39:28 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 3/6] s390x: uv-guest: remove duplicated checks
Date:   Mon,  2 May 2022 09:39:22 +0000
Message-Id: <20220502093925.4118-4-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220502093925.4118-1-seiden@linux.ibm.com>
References: <20220502093925.4118-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nsmm3QMkxPFV5p1oNrzFoQeWhtUEx-g_
X-Proofpoint-GUID: xejvYruZPPpxIi3DRvdy9VITNEi1ncsv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_03,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

