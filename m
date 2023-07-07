Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4074B35F
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 16:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbjGGOzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 10:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbjGGOzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 10:55:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3042126;
        Fri,  7 Jul 2023 07:54:57 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 367Elp3s006314;
        Fri, 7 Jul 2023 14:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fGhjclkq1nJ+rQZb8ylzfhHGDTh+wHFJhzoxsFIvUJc=;
 b=E93eDEZf0i+sAeZD6Mb1UO0W/rbjAnsOTgKDVP1iaCgREesY4oXPqbvyZWyNepN2YhR9
 c3NoGzx8iy/xB37NWCYOSUDUAqVIEe4TF0GFHngz8m50n2NAAn4BDUwS+genEVY91j3i
 Ht7hZqRzxIMJzfXRPNJQoSkRkmi8GEqfKZ0zJOawFqolg7JVwkT29mA8MTm0QY2fsXUu
 UTW+wVjY9DN81+ZMaJ7IPUH9aILmRmP0SuG7ofUidSZ5/eBGhd/OBZYbTwJJMshj/WNB
 NeH5zXbrf/x6KOGSEUO5fqNubGhqRjwPdNCBQCMli/lKQDRBUWCdCSBdO7D/rizaG+fK 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpmsd850h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 14:54:56 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 367EnfBw011029;
        Fri, 7 Jul 2023 14:54:55 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpmsd84yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 14:54:55 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 367BOfJO014037;
        Fri, 7 Jul 2023 14:54:53 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3rjbs4u00b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 14:54:53 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 367EsosA61276650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jul 2023 14:54:50 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB9F720043;
        Fri,  7 Jul 2023 14:54:49 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 137B52004B;
        Fri,  7 Jul 2023 14:54:49 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jul 2023 14:54:48 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/2] lib: s390x: sclp: Add line mode input handling
Date:   Fri,  7 Jul 2023 14:54:10 +0000
Message-Id: <20230707145410.1679-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230707145410.1679-1-frankja@linux.ibm.com>
References: <20230707145410.1679-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pcdtDeVm7Q3jWJb8OxJnXtKdCv0MKXC0
X-Proofpoint-GUID: pYum4AKWFSXxrlXxLCkXPpHtPKv7Bsj6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-07_10,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307070134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time to add line-mode input so we can use input handling under LPAR if
there's no access to a ASCII console.

Line-mode IO is pretty wild and the documentation could be improved a
lot. Hence I've copied the input parsing functions from the s390-tools
zipl code.

For some reason output is a type 2 event but input is a type 1
event. This also means that the input and output structures are
different from each other.

The input can consist of multiple structures which don't contain text
data before the input text data is reached. Hence we need a bunch of
search functions to retrieve a pointer to the text data.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 174 ++++++++++++++++++++++++++++++++++-----
 lib/s390x/sclp.h         |  26 +++++-
 2 files changed, 180 insertions(+), 20 deletions(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 66572774..15187874 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -85,6 +85,41 @@ static uint8_t _ascebc[256] = {
      0x90, 0x3F, 0x3F, 0x3F, 0x3F, 0xEA, 0x3F, 0xFF
 };
 
+static const uint8_t _ebcasc[] = {
+    0x00, 0x01, 0x02, 0x03, 0x07, 0x09, 0x07, 0x7F,
+    0x07, 0x07, 0x07, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
+    0x10, 0x11, 0x12, 0x13, 0x07, 0x0A, 0x08, 0x07,
+    0x18, 0x19, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
+    0x07, 0x07, 0x1C, 0x07, 0x07, 0x0A, 0x17, 0x1B,
+    0x07, 0x07, 0x07, 0x07, 0x07, 0x05, 0x06, 0x07,
+    0x07, 0x07, 0x16, 0x07, 0x07, 0x07, 0x07, 0x04,
+    0x07, 0x07, 0x07, 0x07, 0x14, 0x15, 0x07, 0x1A,
+    0x20, 0xFF, 0x83, 0x84, 0x85, 0xA0, 0x07, 0x86,
+    0x87, 0xA4, 0x5B, 0x2E, 0x3C, 0x28, 0x2B, 0x21,
+    0x26, 0x82, 0x88, 0x89, 0x8A, 0xA1, 0x8C, 0x07,
+    0x8D, 0xE1, 0x5D, 0x24, 0x2A, 0x29, 0x3B, 0x5E,
+    0x2D, 0x2F, 0x07, 0x8E, 0x07, 0x07, 0x07, 0x8F,
+    0x80, 0xA5, 0x07, 0x2C, 0x25, 0x5F, 0x3E, 0x3F,
+    0x07, 0x90, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
+    0x70, 0x60, 0x3A, 0x23, 0x40, 0x27, 0x3D, 0x22,
+    0x07, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
+    0x68, 0x69, 0xAE, 0xAF, 0x07, 0x07, 0x07, 0xF1,
+    0xF8, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70,
+    0x71, 0x72, 0xA6, 0xA7, 0x91, 0x07, 0x92, 0x07,
+    0xE6, 0x7E, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
+    0x79, 0x7A, 0xAD, 0xAB, 0x07, 0x07, 0x07, 0x07,
+    0x9B, 0x9C, 0x9D, 0xFA, 0x07, 0x07, 0x07, 0xAC,
+    0xAB, 0x07, 0xAA, 0x7C, 0x07, 0x07, 0x07, 0x07,
+    0x7B, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
+    0x48, 0x49, 0x07, 0x93, 0x94, 0x95, 0xA2, 0x07,
+    0x7D, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50,
+    0x51, 0x52, 0x07, 0x96, 0x81, 0x97, 0xA3, 0x98,
+    0x5C, 0xF6, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
+    0x59, 0x5A, 0xFD, 0x07, 0x99, 0x07, 0x07, 0x07,
+    0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
+    0x38, 0x39, 0x07, 0x07, 0x9A, 0x07, 0x07, 0x07,
+};
+
 static char lm_buff[120];
 static unsigned char lm_buff_off;
 static struct spinlock lm_buff_lock;
@@ -225,7 +260,8 @@ static void sclp_write_event_mask(int receive_mask, int send_mask)
 
 static void sclp_console_enable_read(void)
 {
-	sclp_write_event_mask(SCLP_EVENT_MASK_MSG_ASCII, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
+	sclp_write_event_mask(SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_OPCMD,
+			      SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
 }
 
 static void sclp_console_disable_read(void)
@@ -258,37 +294,137 @@ void sclp_print(const char *str)
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
+	 for (i = 0; i < len; i++)
+		 data[i] = _ebcasc[(uint8_t)data[i]];
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
index 853529bf..c9bb4a71 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -225,6 +225,7 @@ typedef struct SCCB {
 } __attribute__((packed)) SCCB;
 
 /* SCLP event types */
+#define SCLP_EVENT_OP_CMD			0x01
 #define SCLP_EVENT_ASCII_CONSOLE_DATA           0x1a
 #define SCLP_EVENT_SIGNAL_QUIESCE               0x1d
 
@@ -232,6 +233,7 @@ typedef struct SCCB {
 #define SCLP_EVENT_MASK_SIGNAL_QUIESCE          0x00000008
 #define SCLP_EVENT_MASK_MSG_ASCII               0x00000040
 #define SCLP_EVENT_MASK_MSG          		0x40000000
+#define SCLP_EVENT_MASK_OPCMD          		0x80000000
 
 #define SCLP_UNCONDITIONAL_READ                 0x00
 #define SCLP_SELECTIVE_READ                     0x01
@@ -295,6 +297,23 @@ struct mdb {
 	struct mto mto;
 } __attribute__((packed));
 
+/* vector keys and ids */
+#define GDS_ID_MDSMU		0x1310
+#define GDS_ID_CPMSU		0x1212
+#define GDS_ID_TEXTCMD		0x1320
+#define GDS_KEY_SELFDEFTEXTMSG	0x31
+#define EBC_MDB			0xd4c4c240
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
@@ -319,12 +338,17 @@ typedef struct ReadEventData {
 
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

