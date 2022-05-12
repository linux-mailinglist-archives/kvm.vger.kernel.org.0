Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94043524925
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352124AbiELJgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352085AbiELJfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A4517AB9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:42 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9EGGY021281
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5/3WX2D41W/xLfqnorsHMfmxmTckXuLHYMuJLkJII/o=;
 b=HA7AEQux9CxyvCR95lFww4+If1wd4UKY+phvm0/K9oFz4BEIsb7d9LCBC5CjmPDZvpgH
 KvyaycrEMS6Bdi0Xv4Wc06hqy7Ab0kOqaijwsilgDCGTqvbNqmE3wMzyFH2itTTgwsPz
 tCTauCep4kgkxLYl7RP0HiT4BNd8bjuj+uDlPkOqyP2z5TPPuWdSpyPYyUZS7HfisLpr
 5+5yz8+dHt54r6EVBZbW6KUXC3fMrT1zqJePyGL49gl9vmNC7NQhk9tQLjpU1Jt4O5sG
 Ru/mDhcjf95vMmJ9AGHlEWkB/oMxKDiMpA25O+o5fykcmx5Hj3FIt7ysUuP09r7b9jcW Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0ye28cx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:40 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9SYDd013089
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:40 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0ye28cwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XUIE009769;
        Thu, 12 May 2022 09:35:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3fwg1hw8yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZYvG42205540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1DF711C04A;
        Thu, 12 May 2022 09:35:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7876411C05C;
        Thu, 12 May 2022 09:35:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:34 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 16/28] lib: s390x: add support for SCLP console read
Date:   Thu, 12 May 2022 11:35:11 +0200
Message-Id: <20220512093523.36132-17-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YmNj9jzA_wmaILav5Dc_Df-12pfoqbr5
X-Proofpoint-GUID: hBtdgvxghYLjsA1uBI2fQHuXnpUMRKAy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 impostorscore=0 mlxscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Add a basic implementation for reading from the SCLP ASCII console. The goal of
this is to support migration tests on s390x. To know when the migration has been
finished, we need to listen for a newline on our console.

Hence, this implementation is focused on the SCLP ASCII console of QEMU and
currently won't work under e.g. LPAR.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile           |  1 +
 lib/s390x/sclp.h         |  8 ++++
 lib/s390x/sclp-console.c | 79 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index c11f6efb..f38f442b 100644
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
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index fead007a..e48a5a3d 100644
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
diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index fa36a6a4..19c74e46 100644
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
-- 
2.36.1

