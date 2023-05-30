Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420AC71609A
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 14:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjE3Mxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 08:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbjE3Mx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 08:53:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AA1FC;
        Tue, 30 May 2023 05:53:05 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCOgEL004816;
        Tue, 30 May 2023 12:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AwsM0KHoRY8ND2CYmfVHWD9IMFqjKUjDnDev17HtS10=;
 b=PCUMGLDngW85WYyeJvXyabC0cgMNC6vuSkvFPDXcOljqAxaVHF8m3tazseTN8gkCqekE
 GStsouXORSgV6PfFxgCLys5K++ylrYuNOR8vhyYElBp4f4GA/qjc7NXB2oVk9Adpjcgz
 tUF+yKlIzmq7+LZ2rytAG3+TQ3q4g9McT8uU9lcm+LbTvYkWWaGDBD4d+UQMROxIviLO
 kRqtd4bA5p/GNmRj+6y7UUsm4wrSJKNp7G8gaR6LgJXPc0Cwo5X72dg4v/P466bszXRy
 4pLvxICZJVjxTC6r6hOcg8e9CgHmi7ttCR71NaT0UxtE6njRxhjrAGQxhb93DocHBLpT Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwh4g8wmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:52:50 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UCfZnP021102;
        Tue, 30 May 2023 12:52:50 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwh4g8wkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:52:50 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34UC4m5u008343;
        Tue, 30 May 2023 12:52:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qu9g598fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:52:48 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UCqivp34013948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 12:52:44 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD8852004B;
        Tue, 30 May 2023 12:52:44 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92C222004F;
        Tue, 30 May 2023 12:52:44 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 12:52:44 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 2/2] s390x: sclp: Implement SCLP_RC_INSUFFICIENT_SCCB_LENGTH
Date:   Tue, 30 May 2023 14:52:43 +0200
Message-Id: <20230530125243.18883-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230530125243.18883-1-pmorel@linux.ibm.com>
References: <20230530125243.18883-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q-x_K94qSmGRRMktU4ap02eezBwXmktv
X-Proofpoint-GUID: YGyGNFHWSVSBQSm7Sz-k9bSgudyVY4Kd
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

