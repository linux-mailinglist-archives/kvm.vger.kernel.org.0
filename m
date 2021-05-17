Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4443C386558
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 22:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbhEQUJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 16:09:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6626 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237798AbhEQUJ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 16:09:27 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HK3sX8090796;
        Mon, 17 May 2021 16:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QKQ+SK18QjTdDDvFQeDw0dje8O3/N6slz7Qy6rKlj28=;
 b=rEq0J2EcrMIRQ5II0NWai8ORq9YKYgrqK6q/WZrhfRggxU79/oH+AqJyBEnfczL9S3E8
 TKqauasbhVfjO+BSzBaaBjrsK9e3vC2F69E+BfLeizZesqlceXujlUqFPwYn17+vxZcm
 PARzeAhdaXA0aZDbr7Ztt2/cPuklA3slFbGJRvIQuNsJQkJeMLiDOiOtvIedOZAuILE0
 YF+pt9hORmWcIU9pRcSQcEwjmrJUITShilmOUBeqaxyWst0BcpwKtHXtRxyXTZu/7FBl
 ZmmZfpVBhYxh/Ayeq6z1zAOR4amBBl0VDqKrs+DfPDecSObsedbjAIHSBSRtYrfa0zs1 lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ky5ng495-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:09 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HK3wsM093294;
        Mon, 17 May 2021 16:08:09 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ky5ng48n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:09 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HK87cs027595;
        Mon, 17 May 2021 20:08:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 38j5x80kd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 20:08:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HK84Md26935660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 20:08:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DFDD5204F;
        Mon, 17 May 2021 20:08:04 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DDD8E52051;
        Mon, 17 May 2021 20:08:03 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 11/11] KVM: s390: pv: add support for UV feature bits
Date:   Mon, 17 May 2021 22:07:58 +0200
Message-Id: <20210517200758.22593-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517200758.22593-1-imbrenda@linux.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S8AVUrw8zZZ6Itdop9DP46nZF83mSsdB
X-Proofpoint-ORIG-GUID: 6nDfyXTqJQe0vxGqoBn2E345f3RPk03X
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for Ultravisor feature bits, and take advantage of the
functionality advertised to speed up the lazy destroy mechanism.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/boot/uv.c        | 1 +
 arch/s390/include/asm/uv.h | 9 ++++++++-
 arch/s390/kernel/uv.c      | 3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index 87641dd65ccf..efdb55364919 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -36,6 +36,7 @@ void uv_query_info(void)
 		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
 		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
 		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_id;
+		uv_info.feature_bits = uvcb.uv_feature_bits;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 1de5ff5e192a..808c2f0e0d7c 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -73,6 +73,11 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
 };
 
+/* Bits in uv features field */
+enum uv_features {
+	BIT_UVC_FEAT_MISC_0 = 0,
+};
+
 struct uv_cb_header {
 	u16 len;
 	u16 cmd;	/* Command Code */
@@ -97,7 +102,8 @@ struct uv_cb_qui {
 	u64 max_guest_stor_addr;
 	u8  reserved88[158 - 136];
 	u16 max_guest_cpu_id;
-	u8  reserveda0[200 - 160];
+	u64 uv_feature_bits;
+	u8  reserveda0[200 - 168];
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
@@ -274,6 +280,7 @@ struct uv_info {
 	unsigned long max_sec_stor_addr;
 	unsigned int max_num_sec_conf;
 	unsigned short max_guest_cpu_id;
+	unsigned long feature_bits;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 434d81baceed..b1fa38d5c388 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -291,7 +291,8 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 
 static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
 {
-	return uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
+	return !test_bit_inv(BIT_UVC_FEAT_MISC_0, &uv_info.feature_bits) &&
+		uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
 		atomic_read(&mm->context.is_protected) > 1;
 }
 
-- 
2.31.1

