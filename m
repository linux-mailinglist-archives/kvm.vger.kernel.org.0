Return-Path: <kvm+bounces-1469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C334D7E7CB3
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:55:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 644DBB211C5
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5401DFC4;
	Fri, 10 Nov 2023 13:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KwEiPV/W"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CC21B27A
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:32 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1775838220
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:31 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADHjUJ018420;
	Fri, 10 Nov 2023 13:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=XdjLODomn8LX+WPnNbGl1STek+9izqbWL5RMnbFJw4U=;
 b=KwEiPV/W7MHBNPmJQ8Q1lQFSyfzgW86N0YK3t0sBHctBw6I4G4YxcMy9mZpxMxshXFWU
 WSjDDxED+fEaEE12s02EJeDxfsmmIROFwGauAo4NpsbZ+03TJ4rlESjf16BZ2rTVzCut
 et4K32SDQu4KsKnrau52jj/2rlAw/Dduqq+6u1pCvy/7VGi1cr4IO5ueLpM0nV0wJnkR
 /LKznzLc1QIOY44ZjAZ0loKx4LHXdtUt4hsSjAdecEEieqfnaPgt0avSip7+Fsm7isNq
 tL912alTQvFhMEoS2cCR+KJBWhLUkwHoL5eh0jqjAfeONX7WJzJSxko0PX4KUH7k5gZl NA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n97s6y4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:22 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADJ9kl022709;
	Fri, 10 Nov 2023 13:54:21 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n97s6wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:21 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAB3Cp1028299;
	Fri, 10 Nov 2023 13:54:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22u73r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsEiC55574842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BE2C2004B;
	Fri, 10 Nov 2023 13:54:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5928420043;
	Fri, 10 Nov 2023 13:54:09 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:09 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 04/26] lib: s390x: sclp: Add compat handling for HMC ASCII consoles
Date: Fri, 10 Nov 2023 14:52:13 +0100
Message-ID: <20231110135348.245156-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dVSlD3XBRAvJKM9IZ7AwHIpkpd_8zu8l
X-Proofpoint-GUID: 5i7kY6Y_8uUu2TZhraqARnYkYtB7LWHL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 spamscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

From: Janosch Frank <frankja@linux.ibm.com>

Without the \r the output of the HMC ASCII console takes a lot of
additional effort to read in comparison to the line mode console.

Additionally we add a console clear for the HMC ASCII console so that
old messages from a previously running operating system are not
polluting the console.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20231031095519.73311-3-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 19c74e4..6c965b6 100644
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
@@ -97,14 +100,29 @@ static void sclp_print_ascii(const char *str)
 {
 	int len = strlen(str);
 	WriteEventData *sccb = (void *)_sccb;
+	char *str_dest = (char *)&sccb->msg;
+	int src_ind, dst_ind;
 
 	sclp_mark_busy();
 	memset(sccb, 0, sizeof(*sccb));
+
+	for (src_ind = 0, dst_ind = 0;
+	     src_ind < len && dst_ind < (PAGE_SIZE / 2);
+	     src_ind++, dst_ind++) {
+		str_dest[dst_ind] = str[src_ind];
+		/* Add a \r to the \n for HMC ASCII console */
+		if (str[src_ind] == '\n' && lpar_ascii_compat) {
+			dst_ind++;
+			str_dest[dst_ind] = '\r';
+		}
+	}
+
+	/* Len might have changed because of the compat behavior */
+	len = dst_ind;
 	sccb->h.length = offsetof(WriteEventData, msg) + len;
 	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
 	sccb->ebh.length = sizeof(EventBufferHeader) + len;
 	sccb->ebh.type = SCLP_EVENT_ASCII_CONSOLE_DATA;
-	memcpy(&sccb->msg, str, len);
 
 	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
 }
@@ -218,8 +236,13 @@ static void sclp_console_disable_read(void)
 
 void sclp_console_setup(void)
 {
+	lpar_ascii_compat = detect_host() == HOST_IS_LPAR;
+
 	/* We send ASCII and line mode. */
 	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
+	/* Hard terminal reset to clear screen for HMC ASCII console */
+	if (lpar_ascii_compat)
+		sclp_print_ascii("\ec");
 }
 
 void sclp_print(const char *str)
-- 
2.41.0


