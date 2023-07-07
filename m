Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E3474B35D
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 16:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjGGOzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 10:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbjGGOy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 10:54:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0542122;
        Fri,  7 Jul 2023 07:54:55 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 367Ep3Ej026841;
        Fri, 7 Jul 2023 14:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=d51gIPBqumhmoz8tY6ExeotkiiiMsbvxNlzIaZJ9nBE=;
 b=gvWFGYYFB3Nv+sAp+D1v5OqqBds05qwVZJn2OZQ94Sq1QyBlg9zhIp15AXVvowlQihMS
 MSo/uxXTcz0Tq8tpYFJltSsVwCXcbM5MjKUSuf2Ji2G2+dqHbDvC2RqSP/cBcLpyNAvg
 dCBD/tnSy7Xy+K9J7RZqCmZZQUpcLr0Q+Z90tpLn/9BR/unBGQgvWATPnd7/GpSchMP0
 Bsof6dm80N1COrI4Y741unh1Ymdkdu9+5Ui3uFELyPEzX6y8hHlYzYeOSfMrUAQOZ56Q
 1gIgQIe6iKtGNCiggfI/AXYDUx245eau49McXYINTZy9cyHeEJ/FeS18JEioTPzmgeVR 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpmu4g3e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 14:54:55 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 367EpNEU027856;
        Fri, 7 Jul 2023 14:54:54 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpmu4g3d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 14:54:54 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3677lTER022404;
        Fri, 7 Jul 2023 14:54:52 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rjbs4tyb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 14:54:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 367Esm1b16712310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jul 2023 14:54:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9A4B2004B;
        Fri,  7 Jul 2023 14:54:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0217C20043;
        Fri,  7 Jul 2023 14:54:48 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jul 2023 14:54:47 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/2] lib: s390x: sclp: Add carriage return to line feed
Date:   Fri,  7 Jul 2023 14:54:09 +0000
Message-Id: <20230707145410.1679-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230707145410.1679-1-frankja@linux.ibm.com>
References: <20230707145410.1679-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ho7voHLAJgz_xmg-tDVleunvI-e8O_SL
X-Proofpoint-GUID: Eps1vMi9Cj9p_MUE3eKddyo5RTH7izxw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-07_10,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 phishscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307070134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without the \r the output of the HMC ASCII console takes a lot of
additional effort to read in comparison to the line mode console.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 19c74e46..66572774 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -97,14 +97,31 @@ static void sclp_print_ascii(const char *str)
 {
 	int len = strlen(str);
 	WriteEventData *sccb = (void *)_sccb;
+	char *str_dest = (char *)&sccb->msg;
+	int i = 0, j = 0;
 
 	sclp_mark_busy();
 	memset(sccb, 0, sizeof(*sccb));
+
+	/*
+	 * Copy the string over and add a \r to all \n since the HMC
+	 * ASCII console requires it.
+	 */
+	for (; i < len && j < (PAGE_SIZE / 2); i++) {
+		if (str[i] == '\n') {
+			str_dest[j] = '\r';
+			j++;
+		}
+		str_dest[j] = str[i];
+		j++;
+	}
+
+	/* len has changed since we might have added \r */
+	len = j;
 	sccb->h.length = offsetof(WriteEventData, msg) + len;
 	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
 	sccb->ebh.length = sizeof(EventBufferHeader) + len;
 	sccb->ebh.type = SCLP_EVENT_ASCII_CONSOLE_DATA;
-	memcpy(&sccb->msg, str, len);
 
 	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
 }
-- 
2.34.1

