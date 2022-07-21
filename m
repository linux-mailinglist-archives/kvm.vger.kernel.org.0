Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57A657D0FE
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiGUQNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiGUQNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A225C88760;
        Thu, 21 Jul 2022 09:13:25 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LG7CBJ006417;
        Thu, 21 Jul 2022 16:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=HSKM9uwsLICGYwEyRylcCFzjFnjPs4LSVa9/i1HZ/78=;
 b=Kh+lWj+8KkhoQk7oYfk3wbCx3HswQMCAhnWMaASi+hzqJHeyKxQUk4lkbfK3JJWDWUH2
 MqawmBMgTefJ+Qd3SnhHc8nWQqqChyh9H6BKTJyJhZ3I2Hcm/YNeMjiwRSvG86btOtd3
 SgoWfujpBz1QsHyazTsCjXVd/IzJISK/3OxkahC7L4c4VHefUP+MkSAiHjiPypSWpL9I
 oKTNdEYUZd8lnmRWxsGM9E2Qlc09d6r2tlkz0Y8D9ip02fN1esl0I9CrMDzYkoNq5bU/
 vJA0zUBtyEIyHxNcEzGlJSc7cSfQv7UjHsDsEZjKY7kzLN6XSTVtq4r/ePrIxGXdt3iz /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf90nt1vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:24 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LG7qpX010589;
        Thu, 21 Jul 2022 16:13:24 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf90nt1u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:24 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6uwu012383;
        Thu, 21 Jul 2022 16:13:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3hbmy8y9cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGBUXU22938108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:11:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92F78A405B;
        Thu, 21 Jul 2022 16:13:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17B24A4054;
        Thu, 21 Jul 2022 16:13:18 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:18 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [GIT PULL 23/42] s390: Add attestation query information
Date:   Thu, 21 Jul 2022 18:12:43 +0200
Message-Id: <20220721161302.156182-24-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZIB3Npp5iVqXxpgPVFvxh5hPOY-m3rSY
X-Proofpoint-GUID: aia9Dn9NDkpnh4LAZ8UTc8PnV1I5pe_B
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

We have information about the supported attestation header version
and plaintext attestation flag bits.
Let's expose it via the sysfs files.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/lkml/20220601100245.3189993-1-seiden@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/boot/uv.c        |  2 ++
 arch/s390/include/asm/uv.h |  7 ++++++-
 arch/s390/kernel/uv.c      | 20 ++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index 67c737c1e580..a5fa667160b2 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -45,6 +45,8 @@ void uv_query_info(void)
 		uv_info.supp_se_hdr_pcf = uvcb.supp_se_hdr_pcf;
 		uv_info.conf_dump_storage_state_len = uvcb.conf_dump_storage_state_len;
 		uv_info.conf_dump_finalize_len = uvcb.conf_dump_finalize_len;
+		uv_info.supp_att_req_hdr_ver = uvcb.supp_att_req_hdr_ver;
+		uv_info.supp_att_pflags = uvcb.supp_att_pflags;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 3e597bb634bd..18fe04c8547e 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -124,7 +124,10 @@ struct uv_cb_qui {
 	u64 reservedc0;				/* 0x00c0 */
 	u64 conf_dump_storage_state_len;	/* 0x00c8 */
 	u64 conf_dump_finalize_len;		/* 0x00d0 */
-	u8  reservedd8[256 - 216];		/* 0x00d8 */
+	u64 reservedd8;				/* 0x00d8 */
+	u64 supp_att_req_hdr_ver;		/* 0x00e0 */
+	u64 supp_att_pflags;			/* 0x00e8 */
+	u8 reservedf0[256 - 240];		/* 0x00f0 */
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
@@ -350,6 +353,8 @@ struct uv_info {
 	unsigned long supp_se_hdr_pcf;
 	unsigned long conf_dump_storage_state_len;
 	unsigned long conf_dump_finalize_len;
+	unsigned long supp_att_req_hdr_ver;
+	unsigned long supp_att_pflags;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 84fe33b6af4d..c13d5a7b71f0 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -479,6 +479,24 @@ static ssize_t uv_query_max_guest_addr(struct kobject *kobj,
 static struct kobj_attribute uv_query_max_guest_addr_attr =
 	__ATTR(max_address, 0444, uv_query_max_guest_addr, NULL);
 
+static ssize_t uv_query_supp_att_req_hdr_ver(struct kobject *kobj,
+					     struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_att_req_hdr_ver);
+}
+
+static struct kobj_attribute uv_query_supp_att_req_hdr_ver_attr =
+	__ATTR(supp_att_req_hdr_ver, 0444, uv_query_supp_att_req_hdr_ver, NULL);
+
+static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
+					struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_att_pflags);
+}
+
+static struct kobj_attribute uv_query_supp_att_pflags_attr =
+	__ATTR(supp_att_pflags, 0444, uv_query_supp_att_pflags, NULL);
+
 static struct attribute *uv_query_attrs[] = {
 	&uv_query_facilities_attr.attr,
 	&uv_query_feature_indications_attr.attr,
@@ -490,6 +508,8 @@ static struct attribute *uv_query_attrs[] = {
 	&uv_query_dump_storage_state_len_attr.attr,
 	&uv_query_dump_finalize_len_attr.attr,
 	&uv_query_dump_cpu_len_attr.attr,
+	&uv_query_supp_att_req_hdr_ver_attr.attr,
+	&uv_query_supp_att_pflags_attr.attr,
 	NULL,
 };
 
-- 
2.36.1

