Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E71743DF9
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 16:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbjF3Ozf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 10:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbjF3Ozd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 10:55:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702951999;
        Fri, 30 Jun 2023 07:55:32 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UEjjlY022990;
        Fri, 30 Jun 2023 14:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4o/zAtXoZW8UB+8izteMfNR07CxCYWqfh5RjZNMTi+A=;
 b=UKY+u2xp+BUbvEsbSn8A8uCzCmcCROhlfwGHAWYZiKZapwDFHN/hiTmS/4Dk6MC4dpvB
 /d8A970o5MgotRQt3ShmAzVsOHGFBHPStzduUEAe9akJr/7Ipv1pSFcMlixb32e5WmJQ
 FHQcV5SFnOilzJKAIAdANUhGEQaWJPQlZK+NVnllmhKMusbW9ybu9yZigE84QYOXvcfC
 AzrFnoDP6WQCeFWoSXcYm/SzUizaNf7juc1HzjBVKPAeqUanyKrRmUcew1wd3EhWOxPa
 o2gfsliKXqYDfi73wrvmPD/IftT4Su/Qc2VS4PWbSCDvMpov1Z6im1jgunvGNWWGvk/h cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj13k88p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:55:31 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35UEjxXB023975;
        Fri, 30 Jun 2023 14:55:30 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj13k88mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:55:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U98sME002456;
        Fri, 30 Jun 2023 14:55:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rdr4532vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:55:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35UEtPGl22610610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 14:55:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BB8920049;
        Fri, 30 Jun 2023 14:55:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40B4D20040;
        Fri, 30 Jun 2023 14:55:24 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 14:55:24 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests RFC 1/3] lib: s390x: sclp: Add carriage return to line feed
Date:   Fri, 30 Jun 2023 14:54:47 +0000
Message-Id: <20230630145449.2312-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230630145449.2312-1-frankja@linux.ibm.com>
References: <20230630145449.2312-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AhL6b5xYYA16INkBYpENhGMLFc83ucOt
X-Proofpoint-GUID: oZjLet52PWDFY1pyNO4h8_nmH8oMU0XV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306300123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without the \r the output of the ASCII console takes a lot of
additional effort to read in comparison to the line mode console.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 19c74e46..384080b0 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -97,14 +97,27 @@ static void sclp_print_ascii(const char *str)
 {
 	int len = strlen(str);
 	WriteEventData *sccb = (void *)_sccb;
+	char *str_dest = (char *)&sccb->msg;
+	int i = 0;
 
 	sclp_mark_busy();
 	memset(sccb, 0, sizeof(*sccb));
+
+	for (; i < len; i++) {
+		*str_dest = str[i];
+		str_dest++;
+		/* Add a \r to the \n */
+		if (str[i] == '\n') {
+			*str_dest = '\r';
+			str_dest++;
+		}
+	}
+
+	len = (uintptr_t)str_dest - (uintptr_t)&sccb->msg;
 	sccb->h.length = offsetof(WriteEventData, msg) + len;
 	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
 	sccb->ebh.length = sizeof(EventBufferHeader) + len;
 	sccb->ebh.type = SCLP_EVENT_ASCII_CONSOLE_DATA;
-	memcpy(&sccb->msg, str, len);
 
 	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
 }
-- 
2.34.1

