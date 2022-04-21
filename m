Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870A1509C98
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 11:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387886AbiDUJse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 05:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387819AbiDUJs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 05:48:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1490240A5;
        Thu, 21 Apr 2022 02:45:37 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9ckDo011724;
        Thu, 21 Apr 2022 09:45:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=d6iyzaWShGXyPpjjkcAkZz1NdHZwpq/lMoyIBKZgrKU=;
 b=lIGDSOwXhRSVn6X0W3rC9T3dQCiVOWM5lrbH+TLW1W9nKUHeUdrmHi+MUpg5CM7jHmfQ
 hgsIuqmnnwDQaanB74tBy7TYHVx8Kn8uDwQrQ9FevZEE8x9guiMDO+kTCCgVADJrCXXB
 Lb1/yztDArkagDVGJpV8gJP7HtkE3tgTU+bT5LZSe8knYRbgEEM/EZEO++ALuAh1qGGT
 /O6MUmmcq+1WzbEFvyRzzJygSixlARSDEsrzJgVqPuz+vo3OxXpoeVmkek/piHP3yq0Z
 z0egzFqsdXkqFeJZhASsTeyZS0uBmGST9ZLboGLe1Y1U5LyPigB2Oxd7i/7O+DmZXsgk qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff3ht07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:37 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L9jbv4019904;
        Thu, 21 Apr 2022 09:45:37 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff3hsy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:36 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L9dCfs003562;
        Thu, 21 Apr 2022 09:45:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3ffne961ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L9jT5F58065162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 09:45:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9E0F11C04A;
        Thu, 21 Apr 2022 09:45:29 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7A8611C04C;
        Thu, 21 Apr 2022 09:45:28 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 09:45:28 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 1/5] s390x: uv-host: Add invalid command attestation check
Date:   Thu, 21 Apr 2022 09:45:23 +0000
Message-Id: <20220421094527.32261-2-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421094527.32261-1-seiden@linux.ibm.com>
References: <20220421094527.32261-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ko5gCJXi1N__Il245Fd3hHWc_vwKSWgN
X-Proofpoint-ORIG-GUID: ZRX7lUaFkyYGe48wqciHV--Sb1ElNJ3u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds an invalid command test for attestation in the uv-host.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 23 ++++++++++++++++++++++-
 s390x/uv-host.c    |  1 +
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 70bf65c4..7c8c399d 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -1,7 +1,7 @@
 /*
  * s390x Ultravisor related definitions
  *
- * Copyright (c) 2020 IBM Corp
+ * Copyright IBM Corp. 2020, 2022
  *
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
@@ -47,6 +47,7 @@
 #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
+#define UVC_CMD_ATTESTATION		0x1020
 
 /* Bits in installed uv calls */
 enum uv_cmds_inst {
@@ -71,6 +72,7 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
+	BIT_UVC_CMD_ATTESTATION = 28,
 };
 
 struct uv_cb_header {
@@ -178,6 +180,25 @@ struct uv_cb_cfs {
 	u64 paddr;
 }  __attribute__((packed))  __attribute__((aligned(8)));
 
+/* Retrieve Attestation Measurement */
+struct uv_cb_attest {
+	struct uv_cb_header header;	/* 0x0000 */
+	uint64_t reserved08[2];		/* 0x0008 */
+	uint64_t arcb_addr;		/* 0x0018 */
+	uint64_t continuation_token;	/* 0x0020 */
+	uint8_t  reserved28[6];		/* 0x0028 */
+	uint16_t user_data_length;	/* 0x002e */
+	uint8_t  user_data[256];	/* 0x0030 */
+	uint32_t reserved130[3];	/* 0x0130 */
+	uint32_t measurement_length;	/* 0x013c */
+	uint64_t measurement_address;	/* 0x0140 */
+	uint8_t  config_uid[16];	/* 0x0148 */
+	uint32_t reserved158;		/* 0x0158 */
+	uint32_t add_data_length;	/* 0x015c */
+	uint64_t add_data_address;	/* 0x0160 */
+	uint64_t reserved168[4];	/* 0x0168 */
+}  __attribute__((packed))  __attribute__((aligned(8)));
+
 /* Set Secure Config Parameter */
 struct uv_cb_ssc {
 	struct uv_cb_header header;
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index d3018e3c..726bcfa5 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -418,6 +418,7 @@ static struct cmd_list invalid_cmds[] = {
 	{ "bogus", 0x4242, sizeof(struct uv_cb_header), -1},
 	{ "share", UVC_CMD_SET_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_SET_SHARED_ACCESS },
 	{ "unshare", UVC_CMD_REMOVE_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_REMOVE_SHARED_ACCESS },
+	{ "attest", UVC_CMD_ATTESTATION, sizeof(struct uv_cb_attest), BIT_UVC_CMD_ATTESTATION },
 	{ NULL, 0, 0 },
 };
 
-- 
2.30.2

