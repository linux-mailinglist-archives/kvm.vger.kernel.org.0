Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1359649E461
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 15:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242012AbiA0OQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 09:16:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6056 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238954AbiA0OQK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 09:16:10 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RE8Rtd036716;
        Thu, 27 Jan 2022 14:16:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4fkgnCc6JcY+qJx3H+sgnfd6DyjkE0DW/l0qKQx+EGw=;
 b=Vkx4MPf5WYECBLOE8VCqHLeHu7JN5e4TmYkzX2xP/W32wJ1iqAqjGE/mGxVuZzmwiDa4
 JbpT98XcJy3p+n0ECsgq5cS4A4hOInXnjTD4t85lwj9ObyBqiy4+f0a9u6B3zY5v4eC1
 gHrjRuo4zQzm0AIPr8rdufcOwPGLj+vlfoDVxW/oLgVVcojLVZ0IS4uxMXndpkmVIVvN
 z1E2JdH8MQVGMJ19pUbnTwWHfGfWfbsT2jagfBd9adXcm+TVW2XXaWArnoFbqjI+MHRq
 DPZswjMl8FYGarc1exaiVXl3GoCZQbq0nu0py9epN5SqR/wuDzTuXnS4sKdnshQTkEpf vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dutr9k33v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:16:09 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20REG9Om035969;
        Thu, 27 Jan 2022 14:16:09 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dutr9k33a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:16:09 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20RECNgf015948;
        Thu, 27 Jan 2022 14:16:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3dr9j9epj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:16:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20REG22940436192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 14:16:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A365652074;
        Thu, 27 Jan 2022 14:16:02 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 755FC5205F;
        Thu, 27 Jan 2022 14:16:01 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/4] s390x: uv-host: Add attestation test
Date:   Thu, 27 Jan 2022 14:15:56 +0000
Message-Id: <20220127141559.35250-2-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127141559.35250-1-seiden@linux.ibm.com>
References: <20220127141559.35250-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TAD6xDvtrEEY9Gv_IaljdbV2Rq0LciwK
X-Proofpoint-ORIG-GUID: yCRPLw_K4uJ3YrQyRZc1C2MZYOZ9IWJP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds an invalid command test for attestation in the uv-host.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 24 +++++++++++++++++++++++-
 s390x/uv-host.c    |  3 ++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 97c90e81..38c322bf 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -1,10 +1,11 @@
 /*
  * s390x Ultravisor related definitions
  *
- * Copyright (c) 2020 IBM Corp
+ * Copyright (c) 2020, 2022 IBM Corp
  *
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
+ *  Steffen Eiden <seiden@linux.ibm.com>
  *
  * This code is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2.
@@ -47,6 +48,7 @@
 #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
+#define UVC_CMD_ATTESTATION		0x1020
 
 /* Bits in installed uv calls */
 enum uv_cmds_inst {
@@ -71,6 +73,7 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
+	BIT_UVC_CMD_ATTESTATION = 28,
 };
 
 struct uv_cb_header {
@@ -178,6 +181,25 @@ struct uv_cb_cfs {
 	u64 paddr;
 }  __attribute__((packed))  __attribute__((aligned(8)));
 
+/* Retrieve Attestation Measurement */
+struct uv_cb_attest {
+	struct uv_cb_header header;	/* 0x0000 */
+	u64 reserved08[2];		/* 0x0008 */
+	u64 arcb_addr;			/* 0x0018 */
+	u64 continuation_token;		/* 0x0020 */
+	u8  reserved28[6];		/* 0x0028 */
+	u16 user_data_length;		/* 0x002e */
+	u8  user_data[256];		/* 0x0030 */
+	u32 reserved130[3];		/* 0x0130 */
+	u32 measurement_length;		/* 0x013c */
+	u64 measurement_address;	/* 0x0140 */
+	u8 config_uid[16];		/* 0x0148 */
+	u32 reserved158;		/* 0x0158 */
+	u32 add_data_length;		/* 0x015c */
+	u64 add_data_address;		/* 0x0160 */
+	u64 reserved168[4];		/* 0x0168 */
+}  __attribute__((packed))  __attribute__((aligned(8)));
+
 /* Set Secure Config Parameter */
 struct uv_cb_ssc {
 	struct uv_cb_header header;
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 92a41069..0f8ab94a 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -2,7 +2,7 @@
 /*
  * Guest Ultravisor Call tests
  *
- * Copyright (c) 2021 IBM Corp
+ * Copyright (c) 2021, 2022 IBM Corp
  *
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
@@ -418,6 +418,7 @@ static struct cmd_list invalid_cmds[] = {
 	{ "bogus", 0x4242, sizeof(struct uv_cb_header), -1},
 	{ "share", UVC_CMD_SET_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_SET_SHARED_ACCESS },
 	{ "unshare", UVC_CMD_REMOVE_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_REMOVE_SHARED_ACCESS },
+	{ "attest", UVC_CMD_ATTESTATION, sizeof(struct uv_cb_attest), BIT_UVC_CMD_ATTESTATION },
 	{ NULL, 0, 0 },
 };
 
-- 
2.30.2

