Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF5D50B5B0
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446935AbiDVK55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348369AbiDVK5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:57:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B70EAE47;
        Fri, 22 Apr 2022 03:55:01 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M8p43A020177;
        Fri, 22 Apr 2022 10:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FLbfF4lxoLKAJgBVo77uryazPk0UTQp6mgtFc2scWm8=;
 b=M6DEEeY5g1yqAARrsQfM2IOGpSZvhcMbQpGTNDJBt16RyMaFUj0zim1sqTcdFLQbdCsJ
 gta28HnQ7sIZh27+vPrzbKZBMASKR75KOMoRdZR1efe5r1qn39zZTq0LedZlaRRkIi1y
 DA7V37vgFW3qIjsGKhWmiDOhxWf5+G0MqLRSE7D6guOIEqu1+a1fdtUeE2gKeE1gWPcs
 020jf9EDe1HvbACzjBW67PuI1InDcIVhDPqjFq4jzeXNgJkV7ELfyiOi8qZ77XWTrXZW
 iBp8ZZ/BDeNC7uD2VMGBOvp3le3wmVtbs4KYIcsaoWmXNanplxyu6wK4jMxpwELqZ5qc Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fk1yex5rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:55:00 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23MAp4xJ028755;
        Fri, 22 Apr 2022 10:55:00 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fk1yex5rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:55:00 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23MArp6a006045;
        Fri, 22 Apr 2022 10:54:58 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u5scb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:54:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23MAt60v47251734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 10:55:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B3E0AE05F;
        Fri, 22 Apr 2022 10:54:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61BE0AE059;
        Fri, 22 Apr 2022 10:54:54 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 10:54:54 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 1/4] lib: s390x: add support for SCLP console read
Date:   Fri, 22 Apr 2022 12:54:50 +0200
Message-Id: <20220422105453.2153299-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220422105453.2153299-1-nrb@linux.ibm.com>
References: <20220422105453.2153299-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MsPMwPy5NcYq1nswWjPGkuQAGXdL6sJF
X-Proofpoint-GUID: Net9m2uw7ZM28HkjS4PyeshVyzCPaxPr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a basic implementation for reading from the SCLP ASCII console. The goal of
this is to support migration tests on s390x. To know when the migration has been
finished, we need to listen for a newline on our console.

Hence, this implementation is focused on the SCLP ASCII console of QEMU and
currently won't work under e.g. LPAR.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 79 +++++++++++++++++++++++++++++++++++++---
 lib/s390x/sclp.h         |  8 ++++
 s390x/Makefile           |  1 +
 3 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index fa36a6a42381..19c74e46d16f 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -89,6 +89,10 @@ static char lm_buff[120];
 static unsigned char lm_buff_off;
 static struct spinlock lm_buff_lock;
 
+static char read_buf[4096];
+static int read_index = sizeof(read_buf) - 1;
+static int read_buf_length = 0;
+
 static void sclp_print_ascii(const char *str)
 {
 	int len = strlen(str);
@@ -185,7 +189,7 @@ static void sclp_print_lm(const char *str)
  * indicating which messages the control program (we) want(s) to
  * send/receive.
  */
-static void sclp_set_write_mask(void)
+static void sclp_write_event_mask(int receive_mask, int send_mask)
 {
 	WriteEventMask *sccb = (void *)_sccb;
 
@@ -195,18 +199,27 @@ static void sclp_set_write_mask(void)
 	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
 	sccb->mask_length = sizeof(sccb_mask_t);
 
-	/* For now we don't process sclp input. */
-	sccb->cp_receive_mask = 0;
-	/* We send ASCII and line mode. */
-	sccb->cp_send_mask = SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG;
+	sccb->cp_receive_mask = receive_mask;
+	sccb->cp_send_mask = send_mask;
 
 	sclp_service_call(SCLP_CMD_WRITE_EVENT_MASK, sccb);
 	assert(sccb->h.response_code == SCLP_RC_NORMAL_COMPLETION);
 }
 
+static void sclp_console_enable_read(void)
+{
+	sclp_write_event_mask(SCLP_EVENT_MASK_MSG_ASCII, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
+}
+
+static void sclp_console_disable_read(void)
+{
+	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
+}
+
 void sclp_console_setup(void)
 {
-	sclp_set_write_mask();
+	/* We send ASCII and line mode. */
+	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
 }
 
 void sclp_print(const char *str)
@@ -227,3 +240,57 @@ void sclp_print(const char *str)
 	sclp_print_ascii(str);
 	sclp_print_lm(str);
 }
+
+static int console_refill_read_buffer(void)
+{
+	const int max_event_buffer_len = SCCB_SIZE - offsetof(ReadEventDataAsciiConsole, ebh);
+	ReadEventDataAsciiConsole *sccb = (void *)_sccb;
+	const int event_buffer_ascii_recv_header_len = sizeof(sccb->ebh) + sizeof(sccb->type);
+	int ret = -1;
+
+	sclp_console_enable_read();
+
+	sclp_mark_busy();
+	memset(sccb, 0, SCCB_SIZE);
+	sccb->h.length = PAGE_SIZE;
+	sccb->h.function_code = SCLP_UNCONDITIONAL_READ;
+	sccb->h.control_mask[2] = SCLP_CM2_VARIABLE_LENGTH_RESPONSE;
+
+	sclp_service_call(SCLP_CMD_READ_EVENT_DATA, sccb);
+
+	if (sccb->h.response_code == SCLP_RC_NO_EVENT_BUFFERS_STORED ||
+	    sccb->ebh.type != SCLP_EVENT_ASCII_CONSOLE_DATA ||
+	    sccb->type != SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS) {
+		ret = -1;
+		goto out;
+	}
+
+	assert(sccb->ebh.length <= max_event_buffer_len);
+	assert(sccb->ebh.length > event_buffer_ascii_recv_header_len);
+
+	read_buf_length = sccb->ebh.length - event_buffer_ascii_recv_header_len;
+
+	assert(read_buf_length <= sizeof(read_buf));
+	memcpy(read_buf, sccb->data, read_buf_length);
+
+	read_index = 0;
+	ret = 0;
+
+out:
+	sclp_console_disable_read();
+
+	return ret;
+}
+
+int __getchar(void)
+{
+	int ret;
+
+	if (read_index >= read_buf_length) {
+		ret = console_refill_read_buffer();
+		if (ret < 0)
+			return ret;
+	}
+
+	return read_buf[read_index++];
+}
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index fead007a6037..e48a5a3df20b 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -313,6 +313,14 @@ typedef struct ReadEventData {
 	uint32_t mask;
 } __attribute__((packed)) ReadEventData;
 
+#define SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS 0
+typedef struct ReadEventDataAsciiConsole {
+	SCCBHeader h;
+	EventBufferHeader ebh;
+	uint8_t type;
+	char data[];
+} __attribute__((packed)) ReadEventDataAsciiConsole;
+
 extern char _sccb[];
 void sclp_setup_int(void);
 void sclp_handle_ext(void);
diff --git a/s390x/Makefile b/s390x/Makefile
index c11f6efbd767..f38f442b9cb1 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -75,6 +75,7 @@ cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/alloc_page.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc_phys.o
+cflatobjs += lib/getchar.o
 cflatobjs += lib/s390x/io.o
 cflatobjs += lib/s390x/stack.o
 cflatobjs += lib/s390x/sclp.o
-- 
2.31.1

