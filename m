Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2558473896B
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjFUPfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbjFUPev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:34:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622321FEF;
        Wed, 21 Jun 2023 08:34:28 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LFPTsc009992;
        Wed, 21 Jun 2023 15:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=nNDYk+Xje2XH5AMwI9j9WBwWLQLNNYPDEP9vraj5IHU=;
 b=FmX3VDMOAl5aql7HwmI+8bDTMxLyNaQnbXqhhNw2/THeRvekGY7kHdCFETKx4q8IyRfm
 OtvTT4VERGGKDnjTrvu+6SAKiqR4oWd4vO3t0RqkfhIePYpnSyHv4akTqljMLgGZsgqn
 71zEY6IY5ItJOBt6Ulux4jlcWApYv2Ih8iSlUlDk41+Ys2b7g1lSCfMsv15cm/a96FIq
 lnh0HUxXAh1tyHM1DQOzI2OBzqs/KsvNTwqVyM5xekEMR/3iPC9u/CyfNqxHHhd4HKlo
 L9RfkVClGuDXa3CiMY9KlWsmmxaUEO1/IZAu/wZwVpGyxncxnFNOb9zFThY4edShpVDN ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3u70apx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:27 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LFQKrR012092;
        Wed, 21 Jun 2023 15:34:27 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3u70ajx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:26 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35L1mlLu028256;
        Wed, 21 Jun 2023 15:34:24 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3r94f5255u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LFYKAY14221984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 15:34:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C32E20040;
        Wed, 21 Jun 2023 15:34:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15FB020043;
        Wed, 21 Jun 2023 15:34:20 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.33.34])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jun 2023 15:34:20 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, pmorel@linux.ibm.com
Subject: [GIT PULL 10/11] s390/uv: replace scnprintf with sysfs_emit
Date:   Wed, 21 Jun 2023 17:29:16 +0200
Message-ID: <20230621153227.57250-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230621153227.57250-1-frankja@linux.ibm.com>
References: <20230621153227.57250-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ezuaGrIPUOEsVXgwe4pvP0uhBb2Wgl3l
X-Proofpoint-ORIG-GUID: uNCRnVy9KKn24DFEaZexoNgDoX3e4mUq
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

Replace scnprintf(page, PAGE_SIZE, ...) with the page size aware
sysfs_emit(buf, ...) which adds some sanity checks.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230615100533.3996107-7-seiden@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20230615100533.3996107-7-seiden@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 58 +++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index e320a382fa85..6a23a13d0dfc 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -468,13 +468,13 @@ EXPORT_SYMBOL_GPL(arch_make_page_accessible);
 
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
@@ -499,30 +499,27 @@ static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
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
@@ -538,48 +535,45 @@ static struct kobj_attribute uv_query_feature_indications_attr =
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
@@ -606,18 +600,18 @@ static struct attribute_group uv_query_attr_group = {
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
 
@@ -625,7 +619,7 @@ static ssize_t uv_is_prot_virt_host(struct kobject *kobj,
 	val = prot_virt_host;
 #endif
 
-	return scnprintf(page, PAGE_SIZE, "%d\n", val);
+	return sysfs_emit(buf, "%d\n", val);
 }
 
 static struct kobj_attribute uv_prot_virt_guest =
-- 
2.41.0

