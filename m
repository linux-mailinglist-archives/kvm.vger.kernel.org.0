Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878847BF47F
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 09:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442488AbjJJHjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 03:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442547AbjJJHjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 03:39:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFADB0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 00:39:07 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A75tAV022894
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H+rArTHylNnlIuib/Nms6oM0O0efreJMBQnr359S99M=;
 b=hoAPHXUy06QLvx+VAfkpUL5b6Kz12ep+/t7MHZTtxkG+WujgwijgbmGttIKn7XOw95Gb
 VIP+iDcS5VOuHJAxGK902i3MavlDun/psYnYu75bKpqUaRpAjFmHsw1HmFPNzv+Wlqws
 OB0jprnrk9FSUH3YBPmGRN20bvfIFg9qC7gofoiI28wCl8QUL+39NaIBfurPd/upI1j1
 F9AFyIRENGzFURd6WG98MdNR17dj1k1VQIVmGurF6tQXpkOJ3wGwOMb6GBl7uja2jEgd
 QDxEiMGN8sJ0etGe9tgAnypYwcMngBxno+Ff9/Dfk9iptxiBBkL4jqjuTRdDc0vZUEHm 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn1qrse5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:07 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A7KpWt010030
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:06 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn1qrse52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 07:39:06 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6uANB024445;
        Tue, 10 Oct 2023 07:39:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkhnsf4me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 07:39:05 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A7d3a020513364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 07:39:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21B0320043;
        Tue, 10 Oct 2023 07:39:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9F0A20040;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/3] lib: s390x: sclp: Add line mode input handling
Date:   Tue, 10 Oct 2023 07:38:55 +0000
Message-Id: <20231010073855.26319-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010073855.26319-1-frankja@linux.ibm.com>
References: <20231010073855.26319-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P1u6gMvZcotsp0ncpZpmEFFM8bOkoSE1
X-Proofpoint-ORIG-GUID: b2F_iXduKLRkRuIacQz-H7AcowW0COHV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time to add line-mode input so we can use input handling under LPAR if
there's no access to a ASCII console.

Line-mode IO is pretty wild and the documentation could be improved a
lot. Hence I've copied the input parsing functions from Linux.

For some reason output is a type 2 event but input is a type 1
event. This also means that the input and output structures are
different from each other.

The input can consist of multiple structures which don't contain text
data before the input text data is reached. Hence we need a bunch of
search functions to retrieve a pointer to the text data.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 180 ++++++++++++++++++++++++++++++++++-----
 lib/s390x/sclp.h         |  26 +++++-
 2 files changed, 185 insertions(+), 21 deletions(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 313be1e4..23c09b70 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -1,8 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * SCLP ASCII access driver
+ * SCLP line mode and ASCII console driver
  *
  * Copyright (c) 2013 Alexander Graf <agraf@suse.de>
+ *
+ * Copyright IBM Corp. 1999
+ * Author(s): Martin Peschke <mpeschke@de.ibm.com>
+ *	      Martin Schwidefsky <schwidefsky@de.ibm.com>
  */
 
 #include <libcflat.h>
@@ -86,6 +90,41 @@ static uint8_t _ascebc[256] = {
      0x90, 0x3F, 0x3F, 0x3F, 0x3F, 0xEA, 0x3F, 0xFF
 };
 
+static const uint8_t _ebcasc[] = {
+	0x00, 0x01, 0x02, 0x03, 0x07, 0x09, 0x07, 0x7F,
+	0x07, 0x07, 0x07, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
+	0x10, 0x11, 0x12, 0x13, 0x07, 0x0A, 0x08, 0x07,
+	0x18, 0x19, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
+	0x07, 0x07, 0x1C, 0x07, 0x07, 0x0A, 0x17, 0x1B,
+	0x07, 0x07, 0x07, 0x07, 0x07, 0x05, 0x06, 0x07,
+	0x07, 0x07, 0x16, 0x07, 0x07, 0x07, 0x07, 0x04,
+	0x07, 0x07, 0x07, 0x07, 0x14, 0x15, 0x07, 0x1A,
+	0x20, 0xFF, 0x83, 0x84, 0x85, 0xA0, 0x07, 0x86,
+	0x87, 0xA4, 0x5B, 0x2E, 0x3C, 0x28, 0x2B, 0x21,
+	0x26, 0x82, 0x88, 0x89, 0x8A, 0xA1, 0x8C, 0x07,
+	0x8D, 0xE1, 0x5D, 0x24, 0x2A, 0x29, 0x3B, 0x5E,
+	0x2D, 0x2F, 0x07, 0x8E, 0x07, 0x07, 0x07, 0x8F,
+	0x80, 0xA5, 0x07, 0x2C, 0x25, 0x5F, 0x3E, 0x3F,
+	0x07, 0x90, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
+	0x70, 0x60, 0x3A, 0x23, 0x40, 0x27, 0x3D, 0x22,
+	0x07, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
+	0x68, 0x69, 0xAE, 0xAF, 0x07, 0x07, 0x07, 0xF1,
+	0xF8, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70,
+	0x71, 0x72, 0xA6, 0xA7, 0x91, 0x07, 0x92, 0x07,
+	0xE6, 0x7E, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
+	0x79, 0x7A, 0xAD, 0xAB, 0x07, 0x07, 0x07, 0x07,
+	0x9B, 0x9C, 0x9D, 0xFA, 0x07, 0x07, 0x07, 0xAC,
+	0xAB, 0x07, 0xAA, 0x7C, 0x07, 0x07, 0x07, 0x07,
+	0x7B, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
+	0x48, 0x49, 0x07, 0x93, 0x94, 0x95, 0xA2, 0x07,
+	0x7D, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50,
+	0x51, 0x52, 0x07, 0x96, 0x81, 0x97, 0xA3, 0x98,
+	0x5C, 0xF6, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
+	0x59, 0x5A, 0xFD, 0x07, 0x99, 0x07, 0x07, 0x07,
+	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
+	0x38, 0x39, 0x07, 0x07, 0x9A, 0x07, 0x07, 0x07,
+};
+
 static bool lpar_ascii_compat;
 
 static char lm_buff[120];
@@ -224,7 +263,8 @@ static void sclp_write_event_mask(int receive_mask, int send_mask)
 
 static void sclp_console_enable_read(void)
 {
-	sclp_write_event_mask(SCLP_EVENT_MASK_MSG_ASCII, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
+	sclp_write_event_mask(SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_OPCMD,
+			      SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
 }
 
 static void sclp_console_disable_read(void)
@@ -262,37 +302,137 @@ void sclp_print(const char *str)
 	sclp_print_lm(str);
 }
 
+static char *console_read_ascii(struct EventBufferHeader *ebh, int *len)
+{
+	struct ReadEventDataAsciiConsole *evdata = (void *)ebh;
+	const int max_event_buffer_len = SCCB_SIZE - offsetof(ReadEventDataAsciiConsole, ebh);
+	const int event_buffer_ascii_recv_header_len = offsetof(ReadEventDataAsciiConsole, data);
+
+	assert(ebh->length <= max_event_buffer_len);
+	assert(ebh->length > event_buffer_ascii_recv_header_len);
+
+	*len = ebh->length - event_buffer_ascii_recv_header_len;
+	return evdata->data;
+}
+
+
+static struct gds_vector *sclp_find_gds_vector(void *start, void *end, uint16_t id)
+{
+	struct gds_vector *v;
+
+	for (v = start; (void *)v < end; v = (void *)v + v->length)
+		if (v->gds_id == id)
+			return v;
+	return NULL;
+}
+
+static struct gds_subvector *sclp_eval_selfdeftextmsg(struct gds_subvector *sv)
+{
+	void *end;
+
+	end = (void *)sv + sv->length;
+	for (sv = sv + 1; (void *)sv < end; sv = (void *)sv + sv->length)
+		if (sv->key == 0x30)
+			return sv;
+	return NULL;
+}
+
+static struct gds_subvector *sclp_eval_textcmd(struct gds_vector *v)
+{
+	struct gds_subvector *sv;
+	void *end;
+
+	end = (void *)v + v->length;
+	for (sv = (struct gds_subvector *)(v + 1); (void *)sv < end;
+	     sv = (void *)sv + sv->length)
+		if (sv->key == GDS_KEY_SELFDEFTEXTMSG)
+			return sclp_eval_selfdeftextmsg(sv);
+	return NULL;
+}
+
+static struct gds_subvector *sclp_eval_cpmsu(struct gds_vector *v)
+{
+	void *end;
+
+	end = (void *)v + v->length;
+	for (v = v + 1; (void *)v < end; v = (void *)v + v->length)
+		if (v->gds_id == GDS_ID_TEXTCMD)
+			return sclp_eval_textcmd(v);
+	return NULL;
+}
+
+static struct gds_subvector *sclp_eval_mdsmu(struct gds_vector *v)
+{
+	v = sclp_find_gds_vector(v + 1, (void *)v + v->length, GDS_ID_CPMSU);
+	if (v)
+		return sclp_eval_cpmsu(v);
+	return NULL;
+}
+
+static char *console_read_lm(struct EventBufferHeader *ebh, int *len)
+{
+	struct gds_vector *v = (void *)ebh + sizeof(*ebh);
+	struct gds_subvector *sv;
+
+	v = sclp_find_gds_vector(v, (void *)ebh + ebh->length,
+				 GDS_ID_MDSMU);
+	if (!v)
+		return NULL;
+
+	sv = sclp_eval_mdsmu(v);
+	if (!sv)
+		return NULL;
+
+	*len = sv->length - (sizeof(*sv));
+	return (char *)(sv + 1);
+}
+
+static void ebc_to_asc(char *data, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		data[i] = _ebcasc[(uint8_t)data[i]];
+}
+
 static int console_refill_read_buffer(void)
 {
-	const int max_event_buffer_len = SCCB_SIZE - offsetof(ReadEventDataAsciiConsole, ebh);
-	ReadEventDataAsciiConsole *sccb = (void *)_sccb;
-	const int event_buffer_ascii_recv_header_len = sizeof(sccb->ebh) + sizeof(sccb->type);
-	int ret = -1;
+	struct SCCBHeader *sccb = (struct SCCBHeader *)_sccb;
+	struct EventBufferHeader *ebh = (void *)_sccb + sizeof(struct SCCBHeader);
+	char *data;
+	int ret = -1, len;
 
 	sclp_console_enable_read();
 
 	sclp_mark_busy();
-	memset(sccb, 0, SCCB_SIZE);
-	sccb->h.length = PAGE_SIZE;
-	sccb->h.function_code = SCLP_UNCONDITIONAL_READ;
-	sccb->h.control_mask[2] = SCLP_CM2_VARIABLE_LENGTH_RESPONSE;
+	memset(_sccb, 0, SCCB_SIZE);
+	sccb->length = PAGE_SIZE;
+	sccb->function_code = SCLP_UNCONDITIONAL_READ;
+	sccb->control_mask[2] = SCLP_CM2_VARIABLE_LENGTH_RESPONSE;
 
 	sclp_service_call(SCLP_CMD_READ_EVENT_DATA, sccb);
 
-	if (sccb->h.response_code == SCLP_RC_NO_EVENT_BUFFERS_STORED ||
-	    sccb->ebh.type != SCLP_EVENT_ASCII_CONSOLE_DATA ||
-	    sccb->type != SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS) {
-		ret = -1;
+	if (sccb->response_code == SCLP_RC_NO_EVENT_BUFFERS_STORED)
+		goto out;
+
+	switch (ebh->type) {
+	case SCLP_EVENT_OP_CMD:
+		data = console_read_lm(ebh, &len);
+		if (data)
+			ebc_to_asc(data, len);
+		break;
+	case SCLP_EVENT_ASCII_CONSOLE_DATA:
+		data = console_read_ascii(ebh, &len);
+		break;
+	default:
 		goto out;
 	}
 
-	assert(sccb->ebh.length <= max_event_buffer_len);
-	assert(sccb->ebh.length > event_buffer_ascii_recv_header_len);
+	if (!data)
+		goto out;
 
-	read_buf_length = sccb->ebh.length - event_buffer_ascii_recv_header_len;
-
-	assert(read_buf_length <= sizeof(read_buf));
-	memcpy(read_buf, sccb->data, read_buf_length);
+	assert(len <= sizeof(read_buf));
+	memcpy(read_buf, data, len);
 
 	read_index = 0;
 	ret = 0;
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 6a611bc3..22f120d1 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -226,6 +226,7 @@ typedef struct SCCB {
 } __attribute__((packed)) SCCB;
 
 /* SCLP event types */
+#define SCLP_EVENT_OP_CMD			0x01
 #define SCLP_EVENT_ASCII_CONSOLE_DATA           0x1a
 #define SCLP_EVENT_SIGNAL_QUIESCE               0x1d
 
@@ -233,6 +234,7 @@ typedef struct SCCB {
 #define SCLP_EVENT_MASK_SIGNAL_QUIESCE          0x00000008
 #define SCLP_EVENT_MASK_MSG_ASCII               0x00000040
 #define SCLP_EVENT_MASK_MSG          		0x40000000
+#define SCLP_EVENT_MASK_OPCMD			0x80000000
 
 #define SCLP_UNCONDITIONAL_READ                 0x00
 #define SCLP_SELECTIVE_READ                     0x01
@@ -296,6 +298,23 @@ struct mdb {
 	struct mto mto;
 } __attribute__((packed));
 
+/* vector keys and ids */
+#define GDS_ID_MDSMU		0x1310
+#define GDS_ID_CPMSU		0x1212
+#define GDS_ID_TEXTCMD		0x1320
+#define GDS_KEY_SELFDEFTEXTMSG	0x31
+#define EBC_MDB                 0xd4c4c240
+
+struct gds_vector {
+	uint16_t     length;
+	uint16_t     gds_id;
+} __attribute__((packed));
+
+struct gds_subvector {
+	uint8_t      length;
+	uint8_t      key;
+} __attribute__((packed));
+
 typedef struct EventBufferHeader {
 	uint16_t length;
 	uint8_t  type;
@@ -320,12 +339,17 @@ typedef struct ReadEventData {
 
 #define SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS 0
 typedef struct ReadEventDataAsciiConsole {
-	SCCBHeader h;
 	EventBufferHeader ebh;
 	uint8_t type;
 	char data[];
 } __attribute__((packed)) ReadEventDataAsciiConsole;
 
+struct ReadEventDataLMConsole {
+	SCCBHeader h;
+	EventBufferHeader ebh;
+	struct gds_vector v[];
+};
+
 extern char _sccb[];
 void sclp_setup_int(void);
 void sclp_handle_ext(void);
-- 
2.34.1

