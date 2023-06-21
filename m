Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C59738967
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbjFUPfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbjFUPey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:34:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079011FFA;
        Wed, 21 Jun 2023 08:34:29 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LFPTse009992;
        Wed, 21 Jun 2023 15:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=6Ow8M76yyb0ETXTWmKD7gTGVplFd/Xm3mz1VcbqGynw=;
 b=XLao6dBWEg6XbUHCjzjaucunGQZB4l/kGfj+2nIyAZCYggcaKamZ70sIh0YgJ369dQ9T
 XPpyjjz4Rjw4V+WMWGPxtISCl9B33zjsvtC1CiGc4HB/Vhii06eF2Ra6gkO8KZ43VHvu
 fh2Mb2neUOIsrlnUY7I0DMtj7am8HvYoMY5Kh9OIksQpUiF3M9KBHhr59vaeYjwLTgZi
 kHpHwgx2Gjtc+I3F+P44+iCYW7v3UmLcI4NE8mhO+L0KvmBQftNsBYY45FPL8fk4FbPH
 qppDzAIDmf/de2eZKM39ocsLN3t4kZxCQ4bqXhXwu0X1ZbtnIuf4W2qQ6xUT5Bw31lLw eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3u70aq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:28 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LFPoSh010394;
        Wed, 21 Jun 2023 15:34:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3u70ak8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35L3IF3g011691;
        Wed, 21 Jun 2023 15:34:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3r94f5aue3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LFYLsH44695824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 15:34:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F163320040;
        Wed, 21 Jun 2023 15:34:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D1E420049;
        Wed, 21 Jun 2023 15:34:20 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.33.34])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jun 2023 15:34:20 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, pmorel@linux.ibm.com
Subject: [GIT PULL 11/11] s390/uv: Update query for secret-UVCs
Date:   Wed, 21 Jun 2023 17:29:17 +0200
Message-ID: <20230621153227.57250-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230621153227.57250-1-frankja@linux.ibm.com>
References: <20230621153227.57250-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oPTSMQhJlywPQ72mjM0M0kSgQ-HUlI5A
X-Proofpoint-ORIG-GUID: x0VA4QBuq-ZcdKiwX0knXSNyGjGhb2-N
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_08,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 adultscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306210131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

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
Link: https://lore.kernel.org/r/20230615100533.3996107-8-seiden@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20230615100533.3996107-8-seiden@linux.ibm.com>
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
index 3203ffbdde6b..d6bb2f4f78d1 100644
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
index 6a23a13d0dfc..273a0281a189 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -579,6 +579,42 @@ static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
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
@@ -592,6 +628,10 @@ static struct attribute *uv_query_attrs[] = {
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
2.41.0

