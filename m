Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4341151346E
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 15:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346808AbiD1NI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 09:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346770AbiD1NIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 09:08:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2108788784;
        Thu, 28 Apr 2022 06:05:35 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SBoXvB025250;
        Thu, 28 Apr 2022 13:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=D5tgUAeYcHLPfTfUGanjY8nkWCjLROLGmNJIpowKGY8=;
 b=FY+LVJELE5IHq61jKlnpND+4Jnkejw3YDDWurUt+zUkFpVuq9VEKMi/CuB8z/mOZaJp6
 /ZUxxChPRlY7XyWssgpusMX9SZSwenlLYPlm8mQYBhLI3BjrvXLgo0Lh96CMAm1nfeJN
 RLPyvFKkXDqYuFFi1RH1CLB6Hect2WlcF6MJhvIXCFxp4JaLHzo+Q5t6xr+CaskUlAzA
 S6Twrm1ox8yykWp7qZ8uqoaLNjTAbpWn6JhB4boMY7J5s4YlukxFCoDyr7se7mYeMnFS
 3nUuEz//0xTwq7wvTQ8wk7NxdI9sJA7XzDu/c1KcFDQ7HcCbNFPoJV37HTQY9er7dkgU Hw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqqtmwh8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:05:34 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23SCwoqX027145;
        Thu, 28 Apr 2022 13:05:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3fm938wyk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:05:32 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23SD5TRp50463138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 13:05:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ED884203F;
        Thu, 28 Apr 2022 13:05:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A679C42042;
        Thu, 28 Apr 2022 13:05:28 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Apr 2022 13:05:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH 1/9] s390x: Add SE hdr query information
Date:   Thu, 28 Apr 2022 13:00:54 +0000
Message-Id: <20220428130102.230790-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220428130102.230790-1-frankja@linux.ibm.com>
References: <20220428130102.230790-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6iL59dmWolnczqVQ-0aPletvhSKUYBN5
X-Proofpoint-GUID: 6iL59dmWolnczqVQ-0aPletvhSKUYBN5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have information about the supported se header version and pcf bits
so let's expose it via the sysfs files.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/boot/uv.c        |  2 ++
 arch/s390/include/asm/uv.h |  7 ++++++-
 arch/s390/kernel/uv.c      | 20 ++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index e6be155ab2e5..b100b57cf15d 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -41,6 +41,8 @@ void uv_query_info(void)
 		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
 		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_id;
 		uv_info.uv_feature_indications = uvcb.uv_feature_indications;
+		uv_info.supp_se_hdr_ver = uvcb.supp_se_hdr_versions;
+		uv_info.supp_se_hdr_pcf = uvcb.supp_se_hdr_pcf;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index cfea7b77a5b8..46498b8c587b 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -110,7 +110,10 @@ struct uv_cb_qui {
 	u8  reserved88[158 - 136];		/* 0x0088 */
 	u16 max_guest_cpu_id;			/* 0x009e */
 	u64 uv_feature_indications;		/* 0x00a0 */
-	u8  reserveda8[200 - 168];		/* 0x00a8 */
+	u64 reserveda8;				/* 0x00a8 */
+	u64 supp_se_hdr_versions;		/* 0x00b0 */
+	u64 supp_se_hdr_pcf;			/* 0x00b8 */
+	u64 reservedc0;				/* 0x00c0 */
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
@@ -307,6 +310,8 @@ struct uv_info {
 	unsigned int max_num_sec_conf;
 	unsigned short max_guest_cpu_id;
 	unsigned long uv_feature_indications;
+	unsigned long supp_se_hdr_ver;
+	unsigned long supp_se_hdr_pcf;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index a5425075dd25..852840384e75 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -392,6 +392,24 @@ static ssize_t uv_query_facilities(struct kobject *kobj,
 static struct kobj_attribute uv_query_facilities_attr =
 	__ATTR(facilities, 0444, uv_query_facilities, NULL);
 
+static ssize_t uv_query_supp_se_hdr_ver(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lx\n", uv_info.supp_se_hdr_ver);
+}
+
+static struct kobj_attribute uv_query_supp_se_hdr_ver_attr =
+	__ATTR(supp_se_hdr_ver, 0444, uv_query_supp_se_hdr_ver, NULL);
+
+static ssize_t uv_query_supp_se_hdr_pcf(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lx\n", uv_info.supp_se_hdr_pcf);
+}
+
+static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
+	__ATTR(supp_se_hdr_pcf, 0444, uv_query_supp_se_hdr_pcf, NULL);
+
 static ssize_t uv_query_feature_indications(struct kobject *kobj,
 					    struct kobj_attribute *attr, char *buf)
 {
@@ -437,6 +455,8 @@ static struct attribute *uv_query_attrs[] = {
 	&uv_query_max_guest_cpus_attr.attr,
 	&uv_query_max_guest_vms_attr.attr,
 	&uv_query_max_guest_addr_attr.attr,
+	&uv_query_supp_se_hdr_ver_attr.attr,
+	&uv_query_supp_se_hdr_pcf_attr.attr,
 	NULL,
 };
 
-- 
2.32.0

