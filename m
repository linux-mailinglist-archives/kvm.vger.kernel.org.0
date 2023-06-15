Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A6B7314E0
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 12:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343571AbjFOKGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 06:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343503AbjFOKFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 06:05:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D068270F;
        Thu, 15 Jun 2023 03:05:43 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35F9qaLL028514;
        Thu, 15 Jun 2023 10:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AdEqxT9Vo62yvP6SN/eeZ7PW4ghWGn2BaY6IXifXIdI=;
 b=hn6CqPbQ9NFtt4xWjlK2GcrBxsVMjaLjC4+6qwpmbyVHyUNfJ7+1iLFPxDIe3QZfrik0
 D8tYjYiLfw7IjuMNc7DpuokAOXyfKBlgmJkOgkMUg6qr7AcAPX4vlyxz19J3q5z/MekQ
 ocGTzN5ShjSncNIIXgqLivRc2n+E5wz9RQppLVPYEbRn1XrRCM0JG8FM2qSr9e6My2H9
 XmejH3ievm/SzU2QgE0yvJAuwnf6EfU2NADJwtDTFBdgP/RqPFOhGt5R34e/6MAx4lt9
 9Qbtv5IF5JYfh9AFlkqXd6R9TIvVdfPOvCp7beUn48xgsuMgYDYSj36YZ8llIM1GlMTa Bw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r80d18eac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 10:05:42 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35F2iApC003049;
        Thu, 15 Jun 2023 10:05:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3r4gee3h1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 10:05:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35FA5Zk147448444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 10:05:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30CF72006F;
        Thu, 15 Jun 2023 10:05:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 024C620071;
        Thu, 15 Jun 2023 10:05:35 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jun 2023 10:05:34 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v5 7/7] s390/uv: Update query for secret-UVCs
Date:   Thu, 15 Jun 2023 12:05:33 +0200
Message-Id: <20230615100533.3996107-8-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615100533.3996107-1-seiden@linux.ibm.com>
References: <20230615100533.3996107-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jiBBxd4z5KpTienB8Vghb15vRcaEQ_Uy
X-Proofpoint-ORIG-GUID: jiBBxd4z5KpTienB8Vghb15vRcaEQ_Uy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-15_06,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the query struct such that secret-UVC related
information can be parsed.
Add sysfs files for these new values.

'supp_add_secret_req_ver' notes the supported versions for the
Add Secret UVC. Bit 0 indicates that version 0x100 is supported,
bit 1 indicates 0x200, and so on.

'supp_add_secret_pcf' notes the supported plaintext flags for
the Add Secret UVC.

'supp_secret_types' notes the supported types of secrets.
Bit 0 indicates secret type 1, bit 1 indicates type 2, and so on.

'max_secrets' notes the maximum amount of secrets the secret store can
store per pv guest.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/boot/uv.c        |  4 ++++
 arch/s390/include/asm/uv.h | 13 +++++++++++--
 arch/s390/kernel/uv.c      | 40 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index 0a077c0a2056..1e66d2cbb096 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -47,6 +47,10 @@ void uv_query_info(void)
 		uv_info.conf_dump_finalize_len = uvcb.conf_dump_finalize_len;
 		uv_info.supp_att_req_hdr_ver = uvcb.supp_att_req_hdr_ver;
 		uv_info.supp_att_pflags = uvcb.supp_att_pflags;
+		uv_info.supp_add_secret_req_ver = uvcb.supp_add_secret_req_ver;
+		uv_info.supp_add_secret_pcf = uvcb.supp_add_secret_pcf;
+		uv_info.supp_secret_types = uvcb.supp_secret_types;
+		uv_info.max_secrets = uvcb.max_secrets;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 1d47b3e40be8..d2cd42bb2c26 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -123,7 +123,7 @@ struct uv_cb_qui {
 	u32 reserved70[3];			/* 0x0070 */
 	u32 max_num_sec_conf;			/* 0x007c */
 	u64 max_guest_stor_addr;		/* 0x0080 */
-	u8  reserved88[158 - 136];		/* 0x0088 */
+	u8  reserved88[0x9e - 0x88];		/* 0x0088 */
 	u16 max_guest_cpu_id;			/* 0x009e */
 	u64 uv_feature_indications;		/* 0x00a0 */
 	u64 reserveda8;				/* 0x00a8 */
@@ -135,7 +135,12 @@ struct uv_cb_qui {
 	u64 reservedd8;				/* 0x00d8 */
 	u64 supp_att_req_hdr_ver;		/* 0x00e0 */
 	u64 supp_att_pflags;			/* 0x00e8 */
-	u8 reservedf0[256 - 240];		/* 0x00f0 */
+	u64 reservedf0;				/* 0x00f0 */
+	u64 supp_add_secret_req_ver;		/* 0x00f8 */
+	u64 supp_add_secret_pcf;		/* 0x0100 */
+	u64 supp_secret_types;			/* 0x0180 */
+	u16 max_secrets;			/* 0x0110 */
+	u8 reserved112[0x120 - 0x112];		/* 0x0112 */
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
@@ -384,6 +389,10 @@ struct uv_info {
 	unsigned long conf_dump_finalize_len;
 	unsigned long supp_att_req_hdr_ver;
 	unsigned long supp_att_pflags;
+	unsigned long supp_add_secret_req_ver;
+	unsigned long supp_add_secret_pcf;
+	unsigned long supp_secret_types;
+	unsigned short max_secrets;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index b8721b67a50d..6a0153289ace 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -580,6 +580,42 @@ static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
 static struct kobj_attribute uv_query_supp_att_pflags_attr =
 	__ATTR(supp_att_pflags, 0444, uv_query_supp_att_pflags, NULL);
 
+static ssize_t uv_query_supp_add_secret_req_ver(struct kobject *kobj,
+						struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lx\n", uv_info.supp_add_secret_req_ver);
+}
+
+static struct kobj_attribute uv_query_supp_add_secret_req_ver_attr =
+	__ATTR(supp_add_secret_req_ver, 0444, uv_query_supp_add_secret_req_ver, NULL);
+
+static ssize_t uv_query_supp_add_secret_pcf(struct kobject *kobj,
+					    struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lx\n", uv_info.supp_add_secret_pcf);
+}
+
+static struct kobj_attribute uv_query_supp_add_secret_pcf_attr =
+	__ATTR(supp_add_secret_pcf, 0444, uv_query_supp_add_secret_pcf, NULL);
+
+static ssize_t uv_query_supp_secret_types(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lx\n", uv_info.supp_secret_types);
+}
+
+static struct kobj_attribute uv_query_supp_secret_types_attr =
+	__ATTR(supp_secret_types, 0444, uv_query_supp_secret_types, NULL);
+
+static ssize_t uv_query_max_secrets(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", uv_info.max_secrets);
+}
+
+static struct kobj_attribute uv_query_max_secrets_attr =
+	__ATTR(max_secrets, 0444, uv_query_max_secrets, NULL);
+
 static struct attribute *uv_query_attrs[] = {
 	&uv_query_facilities_attr.attr,
 	&uv_query_feature_indications_attr.attr,
@@ -593,6 +629,10 @@ static struct attribute *uv_query_attrs[] = {
 	&uv_query_dump_cpu_len_attr.attr,
 	&uv_query_supp_att_req_hdr_ver_attr.attr,
 	&uv_query_supp_att_pflags_attr.attr,
+	&uv_query_supp_add_secret_req_ver_attr.attr,
+	&uv_query_supp_add_secret_pcf_attr.attr,
+	&uv_query_supp_secret_types_attr.attr,
+	&uv_query_max_secrets_attr.attr,
 	NULL,
 };
 
-- 
2.40.1

