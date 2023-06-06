Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0263272411C
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 13:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbjFFLh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 07:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236710AbjFFLhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 07:37:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31ECFE5B;
        Tue,  6 Jun 2023 04:37:45 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356BMlw8017605;
        Tue, 6 Jun 2023 11:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hQvxa/208GGap2m5CEKlCdSeXsPpBXC4SNfyCCt+N5k=;
 b=TAygvyywlkIeZn6Bnb1yIKxt9ftLERVRuoDnBnAg7ZEHJdSbFo00AZVoqKQMwo9OuSoO
 6xChaX7aO43/sveea35pCMceMyWzUnPcJYH6Eub9IbeQcvarcodY6okrKNTTa6C5EiDG
 MkAcu8QaMadRvMfpndzV1b95HkN0o2gRVWSSmOETOqc7C2WX4tMZbmVp+9LXKBJyTzDR
 FP2O1yt8SOCu/mlUtU9YOXDOJ7ufSYp/P1JQ3eepNmOaTawfT6d784ctXgZ3c/mURDST
 2YLTREku3rc3QYWn2vQKiA0TEWuwFVed16Lu5eYMEJzKTSQ60t9soeGcuQnrooN40/3x Hg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r23v9rb2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 11:37:44 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3569muLn017239;
        Tue, 6 Jun 2023 11:37:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qyx8xhgfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 11:37:42 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 356BbcQ838076754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jun 2023 11:37:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4C9A2004B;
        Tue,  6 Jun 2023 11:37:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 952722004E;
        Tue,  6 Jun 2023 11:37:38 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jun 2023 11:37:38 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: [PATCH v3 6/6] s390/uv: Update query for secret-UVCs
Date:   Tue,  6 Jun 2023 13:37:36 +0200
Message-Id: <20230606113736.2934503-7-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606113736.2934503-1-seiden@linux.ibm.com>
References: <20230606113736.2934503-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MNrnFtwaXe_K-WiMyvd0EfT4VTLPXb7L
X-Proofpoint-GUID: MNrnFtwaXe_K-WiMyvd0EfT4VTLPXb7L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_07,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 phishscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060093
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
---
 arch/s390/boot/uv.c        |  4 ++++
 arch/s390/include/asm/uv.h | 13 +++++++++++--
 arch/s390/kernel/uv.c      | 40 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index 0a077c0a2056..323b5cae3cf1 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -47,6 +47,10 @@ void uv_query_info(void)
 		uv_info.conf_dump_finalize_len = uvcb.conf_dump_finalize_len;
 		uv_info.supp_att_req_hdr_ver = uvcb.supp_att_req_hdr_ver;
 		uv_info.supp_att_pflags = uvcb.supp_att_pflags;
+		uv_info.supp_add_secret_req_ver = uvcb.supp_add_secret_req_ver;
+		uv_info.supp_add_secret_pcf = uvcb.supp_add_secret_pcf;
+		uv_info.supp_secret_types = uvcb.supp_secret_types;
+		uv_info.max_secrets = uvcb.max_num_secrets;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 3203ffbdde6b..d71eb9b887d3 100644
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
+	u16 max_num_secrets;			/* 0x0110 */
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
index cd3a591edab3..7043c0318960 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -571,6 +571,42 @@ static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
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
@@ -584,6 +620,10 @@ static struct attribute *uv_query_attrs[] = {
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

