Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B779B4A8156
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 10:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbiBCJTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 04:19:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236813AbiBCJTo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 04:19:44 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21398aPY012055;
        Thu, 3 Feb 2022 09:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8/gTrN2duCgDJGqMcibs2fbQG7m52p9/xBz4OwXVtZY=;
 b=h/mDcOmM5tVyZFkbd6Fqlu5XYsdborXtZ7j9PgoNmJ7PeLRqYnVHJh7JHcgIclr5ZZYr
 gYlfy7HRgoV3taTa9wfQE+QmJ4gcTtl+9y5hHvAGgF/E06LbBFWP4jiZVM6s/1j7kB24
 nYcuVeEdJdQ0Mzngeiqr+/dyDdGHZRffZoRvWhFKjmg8Tu4UfKI812bobDmHs4WUiUUr
 JnrQd9B00XtXv1ymIwYQsTEaBnmEKmSU38CLxr4RNs7NXwyf5kQB3IHXBD8NAe5m4p2b
 L46IDeB+BTQgBxPYtJv3Ui1lfMrR+oAP6vGbCMSOJMecBwWUjafSDPvt+XQYiZ4FIGNq SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e09h03fmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:44 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21399tb5017987;
        Thu, 3 Feb 2022 09:19:44 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e09h03fm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:44 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2139HNpG010416;
        Thu, 3 Feb 2022 09:19:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3dvvujjf66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:41 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2139JcQt40042962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 09:19:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0674552057;
        Thu,  3 Feb 2022 09:19:38 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 39F645204F;
        Thu,  3 Feb 2022 09:19:37 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/4] s390x: uv-host: Add attestation test
Date:   Thu,  3 Feb 2022 09:19:32 +0000
Message-Id: <20220203091935.2716-2-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220203091935.2716-1-seiden@linux.ibm.com>
References: <20220203091935.2716-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O6jRFusLlOJQn3_nlhlp39yyQs2Bi8pL
X-Proofpoint-GUID: aXHqeRjebX_npx_-x_EV-2TylHE5N7BL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_02,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds an invalid command test for attestation in the uv-host.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 23 ++++++++++++++++++++++-
 s390x/uv-host.c    |  1 +
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 97c90e81..7afbcffd 100644
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
index 92a41069..946f031e 100644
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

