Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E757003E9
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 11:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbjELJie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 05:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbjELJid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 05:38:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B315C5FCD;
        Fri, 12 May 2023 02:38:29 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C9Xipi019431;
        Fri, 12 May 2023 09:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IMT6l+1O0MLIKFEa+71EZJO2IEXid9SBM3Wc/PApjZ0=;
 b=ddyhszu7CgrVvtqwyWcUgGFJ/xSFIL342Akebfb25SgkSn1cNBHlROcGhPrdWWax03lr
 Oh5dJ7Jqd9M+7Jq/QQCapy10901lntz6pbf0aeDdg3S/+PIQll/74GQcyKmdclOhVvjR
 iEbVItRjRohTP4RLewf/EgZ8jj0/RhCQ9Yd/YBVYsbBZokkILJGC2ys/aR5l6gfPtzmE
 JsmmuB5XuA1fObJGJmhc44cofh/dfjN5r9rpVQPaB9FaDoUXq1H5RCZq+0tnu37wvzOL
 1nLO7QU88pjf2RKQ4V0xDoaKfwVHzuBGrR/fZzEe0pUFo/vrXponLDNQsGDloAYpEe8i 2Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhjxd0e72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:38:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34C46JYf024128;
        Fri, 12 May 2023 09:31:59 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896t8et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:31:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34C9Vt4d39715436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 09:31:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7827320040;
        Fri, 12 May 2023 09:31:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25E262004B;
        Fri, 12 May 2023 09:31:55 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 12 May 2023 09:31:55 +0000 (GMT)
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
Subject: [PATCH 5/5] s390/uv: Update query for secret-UVCs
Date:   Fri, 12 May 2023 11:31:53 +0200
Message-Id: <20230512093153.206378-6-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512093153.206378-1-seiden@linux.ibm.com>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1XA_Vr4ZzUysHyFYalo4BH5yJ6MWPBE_
X-Proofpoint-ORIG-GUID: 1XA_Vr4ZzUysHyFYalo4BH5yJ6MWPBE_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305120079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the query struct such that secret-UVC related
information can be parsed.
Add sysfs files for these new values.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/boot/uv.c        |  4 ++++
 arch/s390/include/asm/uv.h | 11 ++++++++++-
 arch/s390/kernel/uv.c      | 40 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 1 deletion(-)

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
index 6180ac8909d5..eb2e11d8123f 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
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
+	u8 reserved112[288 - 274];		/* 0x0112 */
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
index 9f18a4af9c13..381444511bb7 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -587,6 +587,42 @@ static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
 static struct kobj_attribute uv_query_supp_att_pflags_attr =
 	__ATTR(supp_att_pflags, 0444, uv_query_supp_att_pflags, NULL);
 
+static ssize_t uv_query_supp_add_secret_req_ver(struct kobject *kobj,
+						struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_add_secret_req_ver);
+}
+
+static struct kobj_attribute uv_query_supp_add_secret_req_ver_attr =
+	__ATTR(supp_add_secret_req_ver, 0444, uv_query_supp_add_secret_req_ver, NULL);
+
+static ssize_t uv_query_supp_add_secret_pcf(struct kobject *kobj,
+					    struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_add_secret_pcf);
+}
+
+static struct kobj_attribute uv_query_supp_add_secret_pcf_attr =
+	__ATTR(supp_add_secret_pcf, 0444, uv_query_supp_add_secret_pcf, NULL);
+
+static ssize_t uv_query_supp_secret_types(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_secret_types);
+}
+
+static struct kobj_attribute uv_query_supp_secret_types_attr =
+	__ATTR(supp_secret_types, 0444, uv_query_supp_secret_types, NULL);
+
+static ssize_t uv_query_max_secrets(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%d\n", uv_info.max_secrets);
+}
+
+static struct kobj_attribute uv_query_max_num_secrets_attr =
+	__ATTR(max_secrets, 0444, uv_query_max_secrets, NULL);
+
 static struct attribute *uv_query_attrs[] = {
 	&uv_query_facilities_attr.attr,
 	&uv_query_feature_indications_attr.attr,
@@ -600,6 +636,10 @@ static struct attribute *uv_query_attrs[] = {
 	&uv_query_dump_cpu_len_attr.attr,
 	&uv_query_supp_att_req_hdr_ver_attr.attr,
 	&uv_query_supp_att_pflags_attr.attr,
+	&uv_query_supp_add_secret_req_ver_attr.attr,
+	&uv_query_supp_add_secret_pcf_attr.attr,
+	&uv_query_supp_secret_types_attr.attr,
+	&uv_query_max_num_secrets_attr.attr,
 	NULL,
 };
 
-- 
2.40.1

