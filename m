Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D222152807F
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241972AbiEPJJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241485AbiEPJJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:09:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0826118E32;
        Mon, 16 May 2022 02:09:30 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G7jn1B027079;
        Mon, 16 May 2022 09:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7ov+o/DM6ARj9skDUTd4+TcIF883wzE/meiCoC9Ij0o=;
 b=aABY6xw2I6HoOYDknZVoEHqU3QptRlxbQGGcONMuWBBA7zi0ErgZZDngnHnMt1L894NS
 Q2Fl+yZXuF59BR1PHNnhgGjsL4G6jj3glm+ws/3jhEZOt6sK4HZ1sJH25G22QGlxfMFK
 bkNQrwZtXkdMNl9RfMoY48ydZvjHW8xanglVNwRNJMwDzJh461+4qiFGXLkTzq3XFMAJ
 RXsuLAn7F5bOMgtaZ2ELKNkkLjrrOb0m5NR6TOskX39dT35Opv/Q0KjLU3qxQFnytNuo
 UmquW/2opzsJgp/yqMUyeOCeWMyLSRjfHbObB4xIW/KYZIeJtMd5TRRNy4Xfk1rLv6iD hg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3jgtsh5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G98ADA007328;
        Mon, 16 May 2022 09:09:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429abqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:28 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G99Pov24445200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 09:09:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F4B142042;
        Mon, 16 May 2022 09:09:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86B894203F;
        Mon, 16 May 2022 09:09:24 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 09:09:24 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v5 01/10] s390x: Add SE hdr query information
Date:   Mon, 16 May 2022 09:08:08 +0000
Message-Id: <20220516090817.1110090-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220516090817.1110090-1-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dYeKpKQCezlu_4p8ZuWKbJWCVxIkmNXL
X-Proofpoint-ORIG-GUID: dYeKpKQCezlu_4p8ZuWKbJWCVxIkmNXL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_03,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
2.34.1

