Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547D5709435
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 11:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjESJ4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 05:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbjESJ4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 05:56:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B86710D2;
        Fri, 19 May 2023 02:56:00 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34J9sUt3000799;
        Fri, 19 May 2023 09:56:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lZ/PTD60GfqoOPeOp+5paL0BJEuzSDUoIEJtRApHt2c=;
 b=oZ0T9TjOtps1CFiNGG0wgnv6D7dYCiqG0fKmQTfhKSU4rkqvkegC8ezLDHUgldSqzmOw
 dosI/mvGXvATfOCD5Or/OLq+3AOZTkNc68BqtupH+uwceUgfnRzXeZF98bqoWsWkJdFP
 IIwOYD68PNjNA3U3AFtaUDHd9505U6HmHXhbZC9IXD4mUV7U+paEKwyShx6lz+MkJz6B
 1Quiu3rIpik6VhtRliK0ggquo4I1FHnsVZb06DkB71TAZ4/plD5V/q71ohX8NQKT9KhN
 P76CqjO8IVtcfG6J6H6zgUkrtn0QYYS10lCea+oI5753I2i8FcW2s//NS/vu9PvkpWiF Gg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qp6w500wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 09:55:59 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34J9bE8M023975;
        Fri, 19 May 2023 09:37:14 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qj264tjgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 09:37:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34J9bAjN17367704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 09:37:10 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3BE220040;
        Fri, 19 May 2023 09:37:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62C5520043;
        Fri, 19 May 2023 09:37:10 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 19 May 2023 09:37:10 +0000 (GMT)
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
Subject: [PATCH v2 5/6] s390/uv: replace scnprintf with sysfs_emit
Date:   Fri, 19 May 2023 11:37:07 +0200
Message-Id: <20230519093708.810957-6-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519093708.810957-1-seiden@linux.ibm.com>
References: <20230519093708.810957-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RHQdV-UKLLWm5Sj7HlZH2dkRinL1kXOE
X-Proofpoint-ORIG-GUID: RHQdV-UKLLWm5Sj7HlZH2dkRinL1kXOE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_06,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305190080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace scnprintf(page, PAGE_SIZE, ...) with the page size aware
sysfs_emit(page, ...) which adds some sanity checks.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index cb2ee06df286..d5b5d7e83c17 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -462,11 +462,11 @@ EXPORT_SYMBOL_GPL(arch_make_page_accessible);
 static ssize_t uv_query_facilities(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *page)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n%lx\n%lx\n%lx\n",
-			uv_info.inst_calls_list[0],
-			uv_info.inst_calls_list[1],
-			uv_info.inst_calls_list[2],
-			uv_info.inst_calls_list[3]);
+	return sysfs_emit(page, "%lx\n%lx\n%lx\n%lx\n",
+			  uv_info.inst_calls_list[0],
+			  uv_info.inst_calls_list[1],
+			  uv_info.inst_calls_list[2],
+			  uv_info.inst_calls_list[3]);
 }
 
 static struct kobj_attribute uv_query_facilities_attr =
@@ -493,8 +493,7 @@ static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
 static ssize_t uv_query_dump_cpu_len(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *page)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n",
-			uv_info.guest_cpu_stor_len);
+	return sysfs_emit(page, "%lx\n", uv_info.guest_cpu_stor_len);
 }
 
 static struct kobj_attribute uv_query_dump_cpu_len_attr =
@@ -503,8 +502,7 @@ static struct kobj_attribute uv_query_dump_cpu_len_attr =
 static ssize_t uv_query_dump_storage_state_len(struct kobject *kobj,
 					       struct kobj_attribute *attr, char *page)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n",
-			uv_info.conf_dump_storage_state_len);
+	return sysfs_emit(page, "%lx\n", uv_info.conf_dump_storage_state_len);
 }
 
 static struct kobj_attribute uv_query_dump_storage_state_len_attr =
@@ -513,8 +511,7 @@ static struct kobj_attribute uv_query_dump_storage_state_len_attr =
 static ssize_t uv_query_dump_finalize_len(struct kobject *kobj,
 					  struct kobj_attribute *attr, char *page)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n",
-			uv_info.conf_dump_finalize_len);
+	return sysfs_emit(page, "%lx\n", uv_info.conf_dump_finalize_len);
 }
 
 static struct kobj_attribute uv_query_dump_finalize_len_attr =
@@ -532,8 +529,7 @@ static struct kobj_attribute uv_query_feature_indications_attr =
 static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *page)
 {
-	return scnprintf(page, PAGE_SIZE, "%d\n",
-			uv_info.max_guest_cpu_id + 1);
+	return sysfs_emit(page, "%d\n", uv_info.max_guest_cpu_id + 1);
 }
 
 static struct kobj_attribute uv_query_max_guest_cpus_attr =
@@ -542,8 +538,7 @@ static struct kobj_attribute uv_query_max_guest_cpus_attr =
 static ssize_t uv_query_max_guest_vms(struct kobject *kobj,
 				      struct kobj_attribute *attr, char *page)
 {
-	return scnprintf(page, PAGE_SIZE, "%d\n",
-			uv_info.max_num_sec_conf);
+	return sysfs_emit(page, "%d\n", uv_info.max_num_sec_conf);
 }
 
 static struct kobj_attribute uv_query_max_guest_vms_attr =
@@ -552,8 +547,7 @@ static struct kobj_attribute uv_query_max_guest_vms_attr =
 static ssize_t uv_query_max_guest_addr(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *page)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n",
-			uv_info.max_sec_stor_addr);
+	return sysfs_emit(page, "%lx\n", uv_info.max_sec_stor_addr);
 }
 
 static struct kobj_attribute uv_query_max_guest_addr_attr =
@@ -562,7 +556,7 @@ static struct kobj_attribute uv_query_max_guest_addr_attr =
 static ssize_t uv_query_supp_att_req_hdr_ver(struct kobject *kobj,
 					     struct kobj_attribute *attr, char *page)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_att_req_hdr_ver);
+	return sysfs_emit(page, "%lx\n", uv_info.supp_att_req_hdr_ver);
 }
 
 static struct kobj_attribute uv_query_supp_att_req_hdr_ver_attr =
@@ -571,7 +565,7 @@ static struct kobj_attribute uv_query_supp_att_req_hdr_ver_attr =
 static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
 					struct kobj_attribute *attr, char *page)
 {
-	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_att_pflags);
+	return sysfs_emit(page, "%lx\n", uv_info.supp_att_pflags);
 }
 
 static struct kobj_attribute uv_query_supp_att_pflags_attr =
@@ -605,7 +599,7 @@ static ssize_t uv_is_prot_virt_guest(struct kobject *kobj,
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
 	val = prot_virt_guest;
 #endif
-	return scnprintf(page, PAGE_SIZE, "%d\n", val);
+	return sysfs_emit(page, "%d\n", val);
 }
 
 static ssize_t uv_is_prot_virt_host(struct kobject *kobj,
@@ -617,7 +611,7 @@ static ssize_t uv_is_prot_virt_host(struct kobject *kobj,
 	val = prot_virt_host;
 #endif
 
-	return scnprintf(page, PAGE_SIZE, "%d\n", val);
+	return sysfs_emit(page, "%d\n", val);
 }
 
 static struct kobj_attribute uv_prot_virt_guest =
-- 
2.40.1

