Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE36C724AE6
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237934AbjFFSJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 14:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238679AbjFFSIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 14:08:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDAA172B;
        Tue,  6 Jun 2023 11:08:39 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356I0GH9024764;
        Tue, 6 Jun 2023 18:08:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2li1d4k0Sy7+Odm9I2SLNJrdwYFXfA3Iw2Iqxjdo9dE=;
 b=dB8sdjM6RDUGYX7DKkgbYu6i6X1npDCKe0Npepd+aLFoO8QB2Qpp7XducNcZJGujZmI1
 oU4oIChvrgnTQwejF7a3Zv95uqyM3vkEUNsqUWCJPzUjUKOpH3SZQP+XR0GppuNCwPg6
 wuHv8OK3KkOM2VWtxQQzSOZGHYS1Vieg2XyFGvCZ6do+F1zey4bIf//vIdFyLxNyE+lC
 foUjBV+HoiAxDIG3DjKSlq1ZW2g01m+2hqehPxHfDZu+iwPo2mp/VAqihm1OoQvJQiYK
 7SRlj7PwYDtyZ9ILaz2wwKumFB79+3qyVmETpcVvLoTVH8vrqw7ZR7fJiPHANYY9NyHY TA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r29pn8971-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 18:08:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3562StQH019840;
        Tue, 6 Jun 2023 18:08:23 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qyxmyj8xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 18:08:23 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 356I8KQJ25952838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jun 2023 18:08:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70CF120043;
        Tue,  6 Jun 2023 18:08:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C8232004B;
        Tue,  6 Jun 2023 18:08:20 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jun 2023 18:08:19 +0000 (GMT)
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
Subject: [PATCH v4 5/6] s390/uv: replace scnprintf with sysfs_emit
Date:   Tue,  6 Jun 2023 20:08:16 +0200
Message-Id: <20230606180817.3019077-6-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606180817.3019077-1-seiden@linux.ibm.com>
References: <20230606180817.3019077-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BED5ftyWa2Nv-G9U51QxcH_M170-xkFX
X-Proofpoint-GUID: BED5ftyWa2Nv-G9U51QxcH_M170-xkFX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_13,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 adultscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060156
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace scnprintf(page, PAGE_SIZE, ...) with the page size aware
sysfs_emit(buf, ...) which adds some sanity checks.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 58 +++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index cb2ee06df286..23fa2f2e90fc 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -460,13 +460,13 @@ EXPORT_SYMBOL_GPL(arch_make_page_accessible);
 
 #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
 static ssize_t uv_query_facilities(struct kobject *kobj,
-				   struct kobj_attribute *attr, char *page)
+				   struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n%lx\n%lx\n%lx\n",
-			uv_info.inst_calls_list[0],
-			uv_info.inst_calls_list[1],
-			uv_info.inst_calls_list[2],
-			uv_info.inst_calls_list[3]);
+	return sysfs_emit(buf, "%lx\n%lx\n%lx\n%lx\n",
+			  uv_info.inst_calls_list[0],
+			  uv_info.inst_calls_list[1],
+			  uv_info.inst_calls_list[2],
+			  uv_info.inst_calls_list[3]);
 }
 
 static struct kobj_attribute uv_query_facilities_attr =
@@ -491,30 +491,27 @@ static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
 	__ATTR(supp_se_hdr_pcf, 0444, uv_query_supp_se_hdr_pcf, NULL);
 
 static ssize_t uv_query_dump_cpu_len(struct kobject *kobj,
-				     struct kobj_attribute *attr, char *page)
+				     struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n",
-			uv_info.guest_cpu_stor_len);
+	return sysfs_emit(buf, "%lx\n", uv_info.guest_cpu_stor_len);
 }
 
 static struct kobj_attribute uv_query_dump_cpu_len_attr =
 	__ATTR(uv_query_dump_cpu_len, 0444, uv_query_dump_cpu_len, NULL);
 
 static ssize_t uv_query_dump_storage_state_len(struct kobject *kobj,
-					       struct kobj_attribute *attr, char *page)
+					       struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n",
-			uv_info.conf_dump_storage_state_len);
+	return sysfs_emit(buf, "%lx\n", uv_info.conf_dump_storage_state_len);
 }
 
 static struct kobj_attribute uv_query_dump_storage_state_len_attr =
 	__ATTR(dump_storage_state_len, 0444, uv_query_dump_storage_state_len, NULL);
 
 static ssize_t uv_query_dump_finalize_len(struct kobject *kobj,
-					  struct kobj_attribute *attr, char *page)
+					  struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n",
-			uv_info.conf_dump_finalize_len);
+	return sysfs_emit(buf, "%lx\n", uv_info.conf_dump_finalize_len);
 }
 
 static struct kobj_attribute uv_query_dump_finalize_len_attr =
@@ -530,48 +527,45 @@ static struct kobj_attribute uv_query_feature_indications_attr =
 	__ATTR(feature_indications, 0444, uv_query_feature_indications, NULL);
 
 static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
-				       struct kobj_attribute *attr, char *page)
+				       struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(page, PAGE_SIZE, "%d\n",
-			uv_info.max_guest_cpu_id + 1);
+	return sysfs_emit(buf, "%d\n", uv_info.max_guest_cpu_id + 1);
 }
 
 static struct kobj_attribute uv_query_max_guest_cpus_attr =
 	__ATTR(max_cpus, 0444, uv_query_max_guest_cpus, NULL);
 
 static ssize_t uv_query_max_guest_vms(struct kobject *kobj,
-				      struct kobj_attribute *attr, char *page)
+				      struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(page, PAGE_SIZE, "%d\n",
-			uv_info.max_num_sec_conf);
+	return sysfs_emit(buf, "%d\n", uv_info.max_num_sec_conf);
 }
 
 static struct kobj_attribute uv_query_max_guest_vms_attr =
 	__ATTR(max_guests, 0444, uv_query_max_guest_vms, NULL);
 
 static ssize_t uv_query_max_guest_addr(struct kobject *kobj,
-				       struct kobj_attribute *attr, char *page)
+				       struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n",
-			uv_info.max_sec_stor_addr);
+	return sysfs_emit(buf, "%lx\n", uv_info.max_sec_stor_addr);
 }
 
 static struct kobj_attribute uv_query_max_guest_addr_attr =
 	__ATTR(max_address, 0444, uv_query_max_guest_addr, NULL);
 
 static ssize_t uv_query_supp_att_req_hdr_ver(struct kobject *kobj,
-					     struct kobj_attribute *attr, char *page)
+					     struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_att_req_hdr_ver);
+	return sysfs_emit(buf, "%lx\n", uv_info.supp_att_req_hdr_ver);
 }
 
 static struct kobj_attribute uv_query_supp_att_req_hdr_ver_attr =
 	__ATTR(supp_att_req_hdr_ver, 0444, uv_query_supp_att_req_hdr_ver, NULL);
 
 static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
-					struct kobj_attribute *attr, char *page)
+					struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_att_pflags);
+	return sysfs_emit(buf, "%lx\n", uv_info.supp_att_pflags);
 }
 
 static struct kobj_attribute uv_query_supp_att_pflags_attr =
@@ -598,18 +592,18 @@ static struct attribute_group uv_query_attr_group = {
 };
 
 static ssize_t uv_is_prot_virt_guest(struct kobject *kobj,
-				     struct kobj_attribute *attr, char *page)
+				     struct kobj_attribute *attr, char *buf)
 {
 	int val = 0;
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
 	val = prot_virt_guest;
 #endif
-	return scnprintf(page, PAGE_SIZE, "%d\n", val);
+	return sysfs_emit(buf, "%d\n", val);
 }
 
 static ssize_t uv_is_prot_virt_host(struct kobject *kobj,
-				    struct kobj_attribute *attr, char *page)
+				    struct kobj_attribute *attr, char *buf)
 {
 	int val = 0;
 
@@ -617,7 +611,7 @@ static ssize_t uv_is_prot_virt_host(struct kobject *kobj,
 	val = prot_virt_host;
 #endif
 
-	return scnprintf(page, PAGE_SIZE, "%d\n", val);
+	return sysfs_emit(buf, "%d\n", val);
 }
 
 static struct kobj_attribute uv_prot_virt_guest =
-- 
2.40.1

