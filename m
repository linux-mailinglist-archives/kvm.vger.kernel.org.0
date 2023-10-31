Return-Path: <kvm+bounces-177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4309E7DCA40
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D1E61F220B2
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DFC019445;
	Tue, 31 Oct 2023 09:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OOrbJWnz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE16179B9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:56:01 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FE4DB
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 02:56:00 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39V9FKjb014661
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HdSSe8jMUMzaqPn6DiTNB/DFTf5Zup3aDjavXM8aRm8=;
 b=OOrbJWnzdOw6PECh8WjkWtHxbu+X5V/b5QRdWrw2rVL+sm6Q4UJ+nqKbQP/pD3PVxHEV
 Z/nywS9oPZDQWt1L14nsVrKN/zQDb65HzbFnaxRJHVXovq8N9nRYVteX7jOk30QeplB6
 iRH069Anaour/cxs7mm9BLPjrwiP685FeR6inaqJoeKKchnMooYp+Oex0reuB+Y/plmk
 JbsfDRUapsRfCdTiFrt2vKNTrEJ3nSt7u6UpABgrEO8Fm7XJnOoEZtVKF7zWpRoStNsU
 XgHL7U/4r1F/H0no5jMl6JiTkEpWIwT4Mb6jaF5HojJpR8D3cWmIYHxgcK/W5Rw6AugK 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2xsk1exr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:55:58 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39V9ceai004120
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:55:58 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2xsk1exf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Oct 2023 09:55:58 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39V9Cqnx011268;
	Tue, 31 Oct 2023 09:55:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1eujy2b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Oct 2023 09:55:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39V9tsxt9306804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Oct 2023 09:55:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C7F820040;
	Tue, 31 Oct 2023 09:55:54 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 076742004B;
	Tue, 31 Oct 2023 09:55:54 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 31 Oct 2023 09:55:53 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/3] lib: s390x: sclp: Add compat handling for HMC ASCII consoles
Date: Tue, 31 Oct 2023 09:55:18 +0000
Message-Id: <20231031095519.73311-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031095519.73311-1-frankja@linux.ibm.com>
References: <20231031095519.73311-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dHyzXKdiZjw7VaK5kVBgcBSGJk1B_Ew0
X-Proofpoint-ORIG-GUID: PUdADKJmS0uxd1zPm-9GuoFGVBb3RbEv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_13,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310310077

Without the \r the output of the HMC ASCII console takes a lot of
additional effort to read in comparison to the line mode console.

Additionally we add a console clear for the HMC ASCII console so that
old messages from a previously running operating system are not
polluting the console.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 19c74e46..6c965b6d 100644
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
2.34.1


