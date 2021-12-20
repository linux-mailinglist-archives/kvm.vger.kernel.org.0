Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A55047B2A8
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 19:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbhLTSLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 13:11:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240358AbhLTSLN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 13:11:13 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BKI327E005406;
        Mon, 20 Dec 2021 18:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=i0wTZ6TdiyGpLsfK5tMVrWYDORzw5cpqciVC0C3THO0=;
 b=SdmbF/cTPmQK51cj89dN1XCKcl70T/yRTOk2QMCex6BEs5d2gldm96hLMHEH4cTX5P3t
 Cl1W3fgL6eRWgkVnWm0IUqcyBmbzE9TLoHqfoIq5+jJnU7JCLcBfJtLyGReIicrq/9FP
 PytPCr5Hv2It9a5ld0NiA15kBc6PkwXwILTZuBO19twwlEaqFdtrCGRyxnsy5UnkIrGo
 YDMQrhJgyL/eWC9rt57LmGGucclUROKa4fiaDK2xbswNZR9NxHCNdklDZ7ZAvudBMd2Z
 i+q00+iewnj6Tyizq5jLrUfiGM6crhERa/dtUw110VFojaK/HdTcT9NL2zkHILTY8Sy9 GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d2q0jtgtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:13 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BKI6WpJ027058;
        Mon, 20 Dec 2021 18:11:12 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d2q0jtgsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:12 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BKI4hkv029682;
        Mon, 20 Dec 2021 18:11:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3d1799pc9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BKIB6LE43975044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 18:11:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF61311C050;
        Mon, 20 Dec 2021 18:11:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC61311C05E;
        Mon, 20 Dec 2021 18:11:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Dec 2021 18:11:06 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 7D3E7E63B2; Mon, 20 Dec 2021 19:11:06 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 5/6] s390: uv: Add offset comments to UV query struct and fix naming
Date:   Mon, 20 Dec 2021 19:11:03 +0100
Message-Id: <20211220181104.595009-6-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211220181104.595009-1-borntraeger@linux.ibm.com>
References: <20211220181104.595009-1-borntraeger@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jUKsGKw0b6jJCT4id2hsFOG2SfNVT9ZT
X-Proofpoint-ORIG-GUID: yRmJsyZlM98QbbXVh8Bt-VUvZJ_YrXSj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_08,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112200101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Changes to the struct are easier to manage with offset comments so
let's add some. And now that we know that the last struct member has
the wrong name let's also fix this.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 72d3e49c2860..86218382d29c 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -91,23 +91,23 @@ struct uv_cb_header {
 
 /* Query Ultravisor Information */
 struct uv_cb_qui {
-	struct uv_cb_header header;
-	u64 reserved08;
-	u64 inst_calls_list[4];
-	u64 reserved30[2];
-	u64 uv_base_stor_len;
-	u64 reserved48;
-	u64 conf_base_phys_stor_len;
-	u64 conf_base_virt_stor_len;
-	u64 conf_virt_var_stor_len;
-	u64 cpu_stor_len;
-	u32 reserved70[3];
-	u32 max_num_sec_conf;
-	u64 max_guest_stor_addr;
-	u8  reserved88[158 - 136];
-	u16 max_guest_cpu_id;
-	u64 uv_feature_indications;
-	u8  reserveda0[200 - 168];
+	struct uv_cb_header header;		/* 0x0000 */
+	u64 reserved08;				/* 0x0008 */
+	u64 inst_calls_list[4];			/* 0x0010 */
+	u64 reserved30[2];			/* 0x0030 */
+	u64 uv_base_stor_len;			/* 0x0040 */
+	u64 reserved48;				/* 0x0048 */
+	u64 conf_base_phys_stor_len;		/* 0x0050 */
+	u64 conf_base_virt_stor_len;		/* 0x0058 */
+	u64 conf_virt_var_stor_len;		/* 0x0060 */
+	u64 cpu_stor_len;			/* 0x0068 */
+	u32 reserved70[3];			/* 0x0070 */
+	u32 max_num_sec_conf;			/* 0x007c */
+	u64 max_guest_stor_addr;		/* 0x0080 */
+	u8  reserved88[158 - 136];		/* 0x0088 */
+	u16 max_guest_cpu_id;			/* 0x009e */
+	u64 uv_feature_indications;		/* 0x00a0 */
+	u8  reserveda8[200 - 168];		/* 0x00a8 */
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
-- 
2.33.1

