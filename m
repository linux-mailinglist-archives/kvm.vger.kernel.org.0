Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D21B8C42
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 10:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437734AbfITIEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 04:04:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437722AbfITIEV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Sep 2019 04:04:21 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8K7lSYs177670
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 04:04:20 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v4sh52bwn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 04:04:20 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 20 Sep 2019 09:04:17 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Sep 2019 09:04:14 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8K84D0l57606318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 08:04:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5FDC42042;
        Fri, 20 Sep 2019 08:04:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70D8542049;
        Fri, 20 Sep 2019 08:04:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.207])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 08:04:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/6] s390x: Add linemode console
Date:   Fri, 20 Sep 2019 10:03:52 +0200
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190920080356.1948-1-frankja@linux.ibm.com>
References: <20190920080356.1948-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19092008-0008-0000-0000-00000318D10F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092008-0009-0000-0000-00004A3758E1
Message-Id: <20190920080356.1948-3-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=826 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

z/VM isn't fond of vt220, so we need line mode when running under
z/VM.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/sclp-console.c | 181 +++++++++++++++++++++++++++++++++++----
 lib/s390x/sclp.h         |  55 +++++++++++-
 2 files changed, 218 insertions(+), 18 deletions(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index a5ef45f..19416b5 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -11,21 +11,165 @@
 #include <libcflat.h>
 #include <string.h>
 #include <asm/page.h>
+#include <asm/arch_def.h>
+#include <asm/io.h>
 #include "sclp.h"
 
+/*
+ * ASCII (IBM PC 437) -> EBCDIC 037
+ */
+static uint8_t _ascebc[256] = {
+ /*00 NUL   SOH   STX   ETX   EOT   ENQ   ACK   BEL */
+     0x00, 0x01, 0x02, 0x03, 0x37, 0x2D, 0x2E, 0x2F,
+ /*08  BS    HT    LF    VT    FF    CR    SO    SI */
+ /*              ->NL                               */
+     0x16, 0x05, 0x15, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
+ /*10 DLE   DC1   DC2   DC3   DC4   NAK   SYN   ETB */
+     0x10, 0x11, 0x12, 0x13, 0x3C, 0x3D, 0x32, 0x26,
+ /*18 CAN    EM   SUB   ESC    FS    GS    RS    US */
+ /*                               ->IGS ->IRS ->IUS */
+     0x18, 0x19, 0x3F, 0x27, 0x22, 0x1D, 0x1E, 0x1F,
+ /*20  SP     !     "     #     $     %     &     ' */
+     0x40, 0x5A, 0x7F, 0x7B, 0x5B, 0x6C, 0x50, 0x7D,
+ /*28   (     )     *     +     ,     -    .      / */
+     0x4D, 0x5D, 0x5C, 0x4E, 0x6B, 0x60, 0x4B, 0x61,
+ /*30   0     1     2     3     4     5     6     7 */
+     0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7,
+ /*38   8     9     :     ;     <     =     >     ? */
+     0xF8, 0xF9, 0x7A, 0x5E, 0x4C, 0x7E, 0x6E, 0x6F,
+ /*40   @     A     B     C     D     E     F     G */
+     0x7C, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7,
+ /*48   H     I     J     K     L     M     N     O */
+     0xC8, 0xC9, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6,
+ /*50   P     Q     R     S     T     U     V     W */
+     0xD7, 0xD8, 0xD9, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6,
+ /*58   X     Y     Z     [     \     ]     ^     _ */
+     0xE7, 0xE8, 0xE9, 0xBA, 0xE0, 0xBB, 0xB0, 0x6D,
+ /*60   `     a     b     c     d     e     f     g */
+     0x79, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
+ /*68   h     i     j     k     l     m     n     o */
+     0x88, 0x89, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96,
+ /*70   p     q     r     s     t     u     v     w */
+     0x97, 0x98, 0x99, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6,
+ /*78   x     y     z     {     |     }     ~    DL */
+     0xA7, 0xA8, 0xA9, 0xC0, 0x4F, 0xD0, 0xA1, 0x07,
+ /*80*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*88*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*90*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*98*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*A0*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*A8*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*B0*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*B8*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*C0*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*C8*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*D0*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*D8*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*E0        sz	*/
+     0x3F, 0x59, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*E8*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*F0*/
+     0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+ /*F8*/
+     0x90, 0x3F, 0x3F, 0x3F, 0x3F, 0xEA, 0x3F, 0xFF
+};
+
+static void sclp_print_ascii(const char *str)
+{
+	int len = strlen(str);
+	WriteEventData *sccb = (void *)_sccb;
+
+	sclp_mark_busy();
+	memset(sccb, 0, sizeof(*sccb));
+	sccb->h.length = offsetof(WriteEventData, msg) + len;
+	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
+	sccb->ebh.length = sizeof(EventBufferHeader) + len;
+	sccb->ebh.type = SCLP_EVENT_ASCII_CONSOLE_DATA;
+	memcpy(&sccb->msg, str, len);
+
+	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
+}
+
+static void sclp_print_lm(const char *str)
+{
+	unsigned char *ptr, *end, ch;
+	unsigned int count, offset, len;
+	struct WriteEventData *sccb;
+	struct mdb *mdb;
+	struct mto *mto;
+	struct go *go;
+
+	sclp_mark_busy();
+	sccb = (struct WriteEventData *) _sccb;
+	end = (unsigned char *) sccb + 4096 - 1;
+	memset(sccb, 0, sizeof(*sccb));
+	ptr = (unsigned char *) &sccb->msg.mdb.mto;
+	len = strlen(str);
+	offset = 0;
+	do {
+		for (count = sizeof(*mto); offset < len; count++) {
+			ch = str[offset++];
+			if (ch == 0x0a || ptr + count > end)
+				break;
+			ptr[count] = _ascebc[ch];
+		}
+		mto = (struct mto *) ptr;
+		mto->length = count;
+		mto->type = 4;
+		mto->line_type_flags = LNTPFLGS_ENDTEXT;
+		ptr += count;
+	} while (offset < len && ptr + sizeof(*mto) <= end);
+	len = ptr - (unsigned char *) sccb;
+	sccb->h.length = len - offsetof(struct WriteEventData, h);
+	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
+	sccb->ebh.type = EVTYP_MSG;
+	sccb->ebh.length = len - offsetof(struct WriteEventData, ebh);
+	mdb = &sccb->msg.mdb;
+	mdb->header.type = 1;
+	mdb->header.tag = 0xD4C4C240;
+	mdb->header.revision_code = 1;
+	mdb->header.length = len - offsetof(struct WriteEventData, msg.mdb.header);
+	go = &mdb->go;
+	go->length = sizeof(*go);
+	go->type = 1;
+	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
+}
+
+/*
+ * SCLP needs to be initialized by setting a send and receive mask,
+ * indicating which messages the control program (we) want(s) to
+ * send/receive.
+ */
 static void sclp_set_write_mask(void)
 {
 	WriteEventMask *sccb = (void *)_sccb;
 
 	sclp_mark_busy();
+	memset(_sccb, 0, sizeof(*sccb));
 	sccb->h.length = sizeof(WriteEventMask);
-	sccb->mask_length = sizeof(unsigned int);
-	sccb->receive_mask = SCLP_EVENT_MASK_MSG_ASCII;
-	sccb->cp_receive_mask = SCLP_EVENT_MASK_MSG_ASCII;
-	sccb->send_mask = SCLP_EVENT_MASK_MSG_ASCII;
-	sccb->cp_send_mask = SCLP_EVENT_MASK_MSG_ASCII;
+	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
+	sccb->mask_length = sizeof(sccb_mask_t);
+
+	/* For now we don't process sclp input. */
+	sccb->cp_receive_mask = 0;
+	/* We send ASCII and line mode. */
+	sccb->cp_send_mask = SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG;
 
 	sclp_service_call(SCLP_CMD_WRITE_EVENT_MASK, sccb);
+	assert(sccb->h.response_code == SCLP_RC_NORMAL_COMPLETION);
 }
 
 void sclp_console_setup(void)
@@ -35,16 +179,19 @@ void sclp_console_setup(void)
 
 void sclp_print(const char *str)
 {
-	int len = strlen(str);
-	WriteEventData *sccb = (void *)_sccb;
-
-	sclp_mark_busy();
-	sccb->h.length = sizeof(WriteEventData) + len;
-	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
-	sccb->ebh.length = sizeof(EventBufferHeader) + len;
-	sccb->ebh.type = SCLP_EVENT_ASCII_CONSOLE_DATA;
-	sccb->ebh.flags = 0;
-	memcpy(sccb->data, str, len);
-
-	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
+	/*
+	 * z/VM advertises a vt220 console which is not functional:
+	 * (response code 05F0, "not active because of the state of
+	 * the machine"). Hence testing the masks would only work if
+	 * we also use stsi data to distinguish z/VM.
+	 *
+	 * Let's rather print on all available consoles.
+	 */
+	if (strlen(str) > (PAGE_SIZE / 2)) {
+		sclp_print_ascii("Warning: Printing is limited to 2KB of data.");
+		sclp_print_lm("Warning: Printing is limited to 2KB of data.");
+		return;
+	}
+	sclp_print_ascii(str);
+	sclp_print_lm(str);
 }
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 63cf609..98c482a 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -179,6 +179,7 @@ typedef struct SCCB {
 /* SCLP event masks */
 #define SCLP_EVENT_MASK_SIGNAL_QUIESCE          0x00000008
 #define SCLP_EVENT_MASK_MSG_ASCII               0x00000040
+#define SCLP_EVENT_MASK_MSG          		0x40000000
 
 #define SCLP_UNCONDITIONAL_READ                 0x00
 #define SCLP_SELECTIVE_READ                     0x01
@@ -193,6 +194,55 @@ typedef struct WriteEventMask {
     uint32_t receive_mask;
 } __attribute__((packed)) WriteEventMask;
 
+#define MDBTYP_GO               0x0001
+#define MDBTYP_MTO              0x0004
+#define EVTYP_MSG               0x02
+#define LNTPFLGS_CNTLTEXT       0x8000
+#define LNTPFLGS_LABELTEXT      0x4000
+#define LNTPFLGS_DATATEXT       0x2000
+#define LNTPFLGS_ENDTEXT        0x1000
+#define LNTPFLGS_PROMPTTEXT     0x0800
+
+typedef uint32_t sccb_mask_t;
+
+/* SCLP line mode console related structures. */
+
+struct mto {
+	u16 length;
+	u16 type;
+	u16 line_type_flags;
+	u8  alarm_control;
+	u8  _reserved[3];
+} __attribute__((packed));
+
+struct go {
+	u16 length;
+	u16 type;
+	u32 domid;
+	u8  hhmmss_time[8];
+	u8  th_time[3];
+	u8  reserved_0;
+	u8  dddyyyy_date[7];
+	u8  _reserved_1;
+	u16 general_msg_flags;
+	u8  _reserved_2[10];
+	u8  originating_system_name[8];
+	u8  job_guest_name[8];
+} __attribute__((packed));
+
+struct mdb_header {
+	u16 length;
+	u16 type;
+	u32 tag;
+	u32 revision_code;
+} __attribute__((packed));
+
+struct mdb {
+	struct mdb_header header;
+	struct go go;
+	struct mto mto;
+} __attribute__((packed));
+
 typedef struct EventBufferHeader {
     uint16_t length;
     uint8_t  type;
@@ -203,7 +253,10 @@ typedef struct EventBufferHeader {
 typedef struct WriteEventData {
     SCCBHeader h;
     EventBufferHeader ebh;
-    char data[0];
+    union {
+	char data[0];
+	struct mdb mdb;
+    } msg;
 } __attribute__((packed)) WriteEventData;
 
 typedef struct ReadEventData {
-- 
2.17.2

