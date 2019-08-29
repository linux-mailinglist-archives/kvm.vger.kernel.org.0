Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4051CA19C3
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 14:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfH2MP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 08:15:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727751AbfH2MP2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Aug 2019 08:15:28 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7TC77XF043734
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 08:15:26 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2upead8p7c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 08:15:26 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 29 Aug 2019 13:15:25 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 29 Aug 2019 13:15:21 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7TCFKE656623288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 12:15:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA8BA52051;
        Thu, 29 Aug 2019 12:15:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.55.105])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8BAB552050;
        Thu, 29 Aug 2019 12:15:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 3/6] s390x: Add linemode buffer to fix newline on every print
Date:   Thu, 29 Aug 2019 14:14:56 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190829121459.1708-1-frankja@linux.ibm.com>
References: <20190829121459.1708-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082912-0028-0000-0000-000003953FE6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082912-0029-0000-0000-000024578021
Message-Id: <20190829121459.1708-4-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linemode seems to add a newline for each sent message which makes
reading rather hard. Hence we add a small buffer and only print if
it's full or a newline is encountered. Except for when the string is
longer than the buffer, then we flush the buffer and print directly.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/sclp-console.c | 70 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 19416b5..7397dc1 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -13,6 +13,7 @@
 #include <asm/page.h>
 #include <asm/arch_def.h>
 #include <asm/io.h>
+#include <asm/spinlock.h>
 #include "sclp.h"
 
 /*
@@ -87,6 +88,10 @@ static uint8_t _ascebc[256] = {
      0x90, 0x3F, 0x3F, 0x3F, 0x3F, 0xEA, 0x3F, 0xFF
 };
 
+static char lm_buff[120];
+static unsigned char lm_buff_off;
+static struct spinlock lm_buff_lock;
+
 static void sclp_print_ascii(const char *str)
 {
 	int len = strlen(str);
@@ -103,10 +108,10 @@ static void sclp_print_ascii(const char *str)
 	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
 }
 
-static void sclp_print_lm(const char *str)
+static void lm_print(const char *buff, int len)
 {
 	unsigned char *ptr, *end, ch;
-	unsigned int count, offset, len;
+	unsigned int count, offset;
 	struct WriteEventData *sccb;
 	struct mdb *mdb;
 	struct mto *mto;
@@ -117,11 +122,10 @@ static void sclp_print_lm(const char *str)
 	end = (unsigned char *) sccb + 4096 - 1;
 	memset(sccb, 0, sizeof(*sccb));
 	ptr = (unsigned char *) &sccb->msg.mdb.mto;
-	len = strlen(str);
 	offset = 0;
 	do {
 		for (count = sizeof(*mto); offset < len; count++) {
-			ch = str[offset++];
+			ch = buff[offset++];
 			if (ch == 0x0a || ptr + count > end)
 				break;
 			ptr[count] = _ascebc[ch];
@@ -148,6 +152,64 @@ static void sclp_print_lm(const char *str)
 	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
 }
 
+
+/*
+ * In contrast to the ascii console, linemode produces a new
+ * line with every write of data. The report() function uses
+ * several printf() calls to generate a line of data which
+ * would all end up on different lines.
+ *
+ * Hence we buffer here until we encounter a \n or the buffer
+ * is full. That means that linemode output can look a bit
+ * different from ascii and that it takes a bit longer for
+ * lines to appear.
+ */
+static void sclp_print_lm(const char *str)
+{
+	int len;
+	char *nl;
+
+	spin_lock(&lm_buff_lock);
+
+	len = strlen(str);
+	/*
+	 * No use in copying into lm_buff, its time to flush the
+	 * buffer and print str until finished.
+	 */
+	if (len > sizeof(lm_buff)) {
+		if (lm_buff_off)
+			lm_print(lm_buff, lm_buff_off);
+		lm_print(str, len);
+		memset(lm_buff, 0 , sizeof(lm_buff));
+		lm_buff_off = 0;
+		goto out;
+	}
+
+fill:
+	len = len < (sizeof(lm_buff) - lm_buff_off) ? len : (sizeof(lm_buff) - lm_buff_off);
+	if ((lm_buff_off < sizeof(lm_buff) - 1)) {
+		memcpy(&lm_buff[lm_buff_off], str, len);
+		lm_buff_off += len;
+	}
+	/* Buffer not full and no newline */
+	nl = strchr(lm_buff, '\n');
+	if (lm_buff_off != sizeof(lm_buff) - 1 && !nl)
+		goto out;
+
+	lm_print(lm_buff, lm_buff_off);
+	memset(lm_buff, 0 , sizeof(lm_buff));
+	lm_buff_off = 0;
+
+	if (len < strlen(str)) {
+		str = &str[len];
+		len = strlen(str);
+		goto fill;
+	}
+
+out:
+	spin_unlock(&lm_buff_lock);
+}
+
 /*
  * SCLP needs to be initialized by setting a send and receive mask,
  * indicating which messages the control program (we) want(s) to
-- 
2.17.0

