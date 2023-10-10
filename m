Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10847BF47D
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 09:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442531AbjJJHjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 03:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442514AbjJJHjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 03:39:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EC2AF
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 00:39:07 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A7bOO7002981
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rtTwEToSpcSjHFTunpVPy8XfryWVWJ4AF3J8JUIsXss=;
 b=FR4aAbE+4H36n+jdBsNzvk717HWaQB34PqmjhZ/2SGyFVvfxVMDugPsYv+9W5Q68RTyP
 AyWm3mQEW4o6/6eofxxmBzqGIwwky/svBnFOZgUfW5DxIcCrwEqQ5iuIzstBeP3uANvW
 2/SvXy2G3lWJjr4ui1cqOIzaaTZaZlQxnowmOsPcSaAP/k7n+AdLE5oahBRZFApwDsyR
 97+h+XsrKGwWSW9xMRrUB164xO5VxW/fEzO9BJhL13rCID9R0L0AX8f7ujHooFr6l12q
 aWDfuSMYgTl8sZB+1n/cHpCbM7b2GDgq3agV+Rnzzz2rMxeMuxJGwuIlE5PJgkTrLkYV rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn2cqr17b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:06 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A7d6sV008263
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:06 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn2cqr170-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 07:39:06 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6i01B023094;
        Tue, 10 Oct 2023 07:39:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkmc1eade-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 07:39:05 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A7d3Ht24314440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 07:39:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E37F32004B;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFBD320043;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/3] lib: s390x: sclp: Add compat handling for HMC ASCII consoles
Date:   Tue, 10 Oct 2023 07:38:54 +0000
Message-Id: <20231010073855.26319-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010073855.26319-1-frankja@linux.ibm.com>
References: <20231010073855.26319-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8jyvI0D7eTVlnCTXo1SrekhsqQ61_Dp8
X-Proofpoint-GUID: Qga3m655wVEH55ZdTXRA3sEnfkkgI7RB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310100056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without the \r the output of the HMC ASCII console takes a lot of
additional effort to read in comparison to the line mode console.

Additionally we add a console clear for the HMC ASCII console so that
old messages from a previously running operating system are not
polluting the console.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 19c74e46..313be1e4 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -11,6 +11,7 @@
 #include <asm/arch_def.h>
 #include <asm/io.h>
 #include <asm/spinlock.h>
+#include "hardware.h"
 #include "sclp.h"
 
 /*
@@ -85,6 +86,8 @@ static uint8_t _ascebc[256] = {
      0x90, 0x3F, 0x3F, 0x3F, 0x3F, 0xEA, 0x3F, 0xFF
 };
 
+static bool lpar_ascii_compat;
+
 static char lm_buff[120];
 static unsigned char lm_buff_off;
 static struct spinlock lm_buff_lock;
@@ -97,14 +100,27 @@ static void sclp_print_ascii(const char *str)
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
+		/* Add a \r to the \n for HMC ASCII console */
+		if (str[i] == '\n' && lpar_ascii_compat) {
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
@@ -218,8 +234,13 @@ static void sclp_console_disable_read(void)
 
 void sclp_console_setup(void)
 {
+	lpar_ascii_compat = detect_host_early() == HOST_IS_LPAR;
+
 	/* We send ASCII and line mode. */
 	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
+	/* Hard terminal reset to clear screen for HMC ASCII console */
+	if (lpar_ascii_compat)
+		sclp_print_ascii("\ec");
 }
 
 void sclp_print(const char *str)
-- 
2.34.1

