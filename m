Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3026BB8EEF
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 13:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438172AbfITLYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 07:24:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438173AbfITLYB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Sep 2019 07:24:01 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8KBLYLU135333
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 07:24:00 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v4wes10rb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 07:24:00 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 20 Sep 2019 12:23:58 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Sep 2019 12:23:55 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8KBNsCu51511386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 11:23:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DDF7A4053;
        Fri, 20 Sep 2019 11:23:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09A37A405D;
        Fri, 20 Sep 2019 11:23:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.207])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 11:23:52 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: Add linemode buffer to fix newline on every print
Date:   Fri, 20 Sep 2019 13:23:45 +0200
X-Mailer: git-send-email 2.17.2
In-Reply-To: <43bb9ff6-4233-3f6f-8cdb-3a00d1662d4d@redhat.com>
References: <43bb9ff6-4233-3f6f-8cdb-3a00d1662d4d@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 19092011-0016-0000-0000-000002AE8588
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092011-0017-0000-0000-0000330F39D3
Message-Id: <20190920112345.2359-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200107
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linemode seems to add a newline for each sent message which makes
reading rather hard. Hence we add a small buffer and only print if
it's full or a newline is encountered.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/sclp-console.c | 43 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 19416b5..6067a1a 100644
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
@@ -148,6 +152,37 @@ static void sclp_print_lm(const char *str)
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
+	int i;
+	const int len = strlen(str);
+
+	spin_lock(&lm_buff_lock);
+
+	for (i = 0; i < len; i++) {
+		lm_buff[lm_buff_off++] = str[i];
+
+		/* Buffer full or newline? */
+		if (str[i] == '\n' || lm_buff_off == (ARRAY_SIZE(lm_buff) - 1)) {
+			lm_print(lm_buff, lm_buff_off);
+			lm_buff_off = 0;
+		}
+	}
+	spin_unlock(&lm_buff_lock);
+}
+
 /*
  * SCLP needs to be initialized by setting a send and receive mask,
  * indicating which messages the control program (we) want(s) to
-- 
2.17.2

