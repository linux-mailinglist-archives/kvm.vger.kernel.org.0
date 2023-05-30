Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D4F716027
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 14:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjE3MmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 08:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjE3Ml7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 08:41:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C291B8;
        Tue, 30 May 2023 05:41:39 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCOgaW004837;
        Tue, 30 May 2023 12:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AwsM0KHoRY8ND2CYmfVHWD9IMFqjKUjDnDev17HtS10=;
 b=oD6Nr/mjRw3fG0koa9k0z0X40qllwAfVJ8DKj0UcRlCtqMkcyppSVhFWpEHiqKA1m0SQ
 V0vzE130JcitmR/4zmMdf2ZSymvz9FO+arJwdTX68uaZnIhYxl+u8Edj5K6SkF4GbVIr
 gfNTBh24/DlU1HR29qD5mglYYmgsbQPm/U3LvwDDWLF+8+EqOSoWm6QS13ukrYqba0fr
 k9ZNmVnCMqVWuUp4a+4nWVgPUxGrHGVQtXE46CBgrdPSWJTxLL62fiv2iQk1wpKaYNRn
 H5YYUssaIIwEXTw75CRZU1PilqGN4WKlujVpJhcMskn87c44gRtj4I5qs4Mm5Rtw4YnV ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwh4g8ks0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:41:04 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UCf3Vq018149;
        Tue, 30 May 2023 12:41:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwh4g8kr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:41:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34U5OjdG010603;
        Tue, 30 May 2023 12:41:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qu9g518dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:41:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UCewDS26477232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 12:40:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4510E20040;
        Tue, 30 May 2023 12:40:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E96D620043;
        Tue, 30 May 2023 12:40:57 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 12:40:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/2] s390x: sclp: Implement SCLP_RC_INSUFFICIENT_SCCB_LENGTH
Date:   Tue, 30 May 2023 14:40:56 +0200
Message-Id: <20230530124056.18332-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230530124056.18332-1-pmorel@linux.ibm.com>
References: <20230530124056.18332-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gV1wrk6WbrpxDo9P0ESLIpJV_IHRztA-
X-Proofpoint-GUID: o1xiBZuyamLXaeCtlu64M5FiKy_5MDq9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If SCLP_CMDW_READ_SCP_INFO fails due to a short buffer, retry
with a greater buffer.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/sclp.c | 58 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 34a31da..9d51ca4 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -17,13 +17,14 @@
 #include "sclp.h"
 #include <alloc_phys.h>
 #include <alloc_page.h>
+#include <asm/facility.h>
 
 extern unsigned long stacktop;
 
 static uint64_t storage_increment_size;
 static uint64_t max_ram_size;
 static uint64_t ram_size;
-char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+char _read_info[2 * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 static ReadInfo *read_info;
 struct sclp_facilities sclp_facilities;
 
@@ -89,10 +90,41 @@ void sclp_clear_busy(void)
 	spin_unlock(&sclp_lock);
 }
 
-static void sclp_read_scp_info(ReadInfo *ri, int length)
+static bool sclp_read_scp_info_extended(unsigned int command, ReadInfo *ri)
+{
+	int cc;
+
+	if (!test_facility(140)) {
+		report_abort("S390_FEAT_EXTENDED_LENGTH_SCCB missing");
+		return false;
+	}
+	if (ri->h.length > (2 * PAGE_SIZE)) {
+		report_abort("SCLP_READ_INFO expected size too big");
+		return false;
+	}
+
+	sclp_mark_busy();
+	memset(&ri->h, 0, sizeof(ri->h));
+	ri->h.length = 2 * PAGE_SIZE;
+
+	cc = sclp_service_call(command, ri);
+	if (cc) {
+		report_abort("SCLP_READ_INFO error");
+		return false;
+	}
+	if (ri->h.response_code != SCLP_RC_NORMAL_READ_COMPLETION) {
+		report_abort("SCLP_READ_INFO error %02x", ri->h.response_code);
+		return false;
+	}
+
+	return true;
+}
+
+static void sclp_read_scp_info(ReadInfo *ri)
 {
 	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
 				    SCLP_CMDW_READ_SCP_INFO };
+	int length = PAGE_SIZE;
 	int i, cc;
 
 	for (i = 0; i < ARRAY_SIZE(commands); i++) {
@@ -101,19 +133,29 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
 		ri->h.length = length;
 
 		cc = sclp_service_call(commands[i], ri);
-		if (cc)
-			break;
-		if (ri->h.response_code == SCLP_RC_NORMAL_READ_COMPLETION)
+		if (cc) {
+			report_abort("SCLP_READ_INFO error");
 			return;
-		if (ri->h.response_code != SCLP_RC_INVALID_SCLP_COMMAND)
+		}
+
+		switch (ri->h.response_code) {
+		case SCLP_RC_NORMAL_READ_COMPLETION:
+			return;
+		case SCLP_RC_INVALID_SCLP_COMMAND:
 			break;
+		case SCLP_RC_INSUFFICIENT_SCCB_LENGTH:
+			sclp_read_scp_info_extended(commands[i], ri);
+			return;
+		default:
+			report_abort("READ_SCP_INFO failed");
+			return;
+		}
 	}
-	report_abort("READ_SCP_INFO failed");
 }
 
 void sclp_read_info(void)
 {
-	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
+	sclp_read_scp_info((void *)_read_info);
 	read_info = (ReadInfo *)_read_info;
 }
 
-- 
2.31.1

