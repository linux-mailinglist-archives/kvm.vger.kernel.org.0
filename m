Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27724D44BA
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 11:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241270AbiCJKdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 05:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241354AbiCJKdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 05:33:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D6313DE3C;
        Thu, 10 Mar 2022 02:32:11 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22A9rR9V020282;
        Thu, 10 Mar 2022 10:32:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tHG6dwD8rHSa4La+s0NfWhY+58kP16E5ilCGcqguAOs=;
 b=If4pD44lIGwPYyk6ZRunh8Nw0PA00f4xd4QfAv9wkrqhjqRYNGf9pbQqJIRrgviGPkcY
 Fpt2MM924TkYRykKCEPAGEBHb0egVgOl0wqCLB/IW36MuUcYj9Wwf0oPriII49vw8ylx
 +NwzJg9MX8//gkzp4sF0Bv6+zp6ZTyq/Gu3A5JYX7LFSKnGS8l8b2pRuc/r3B6S4mgrf
 BptjAZ1ULCAkYlsA/rkMQqJF5osatlE2FbjCrAcZLbY05+sqPBj6j8NzJioTi+iTZbve
 XHDimEyyAZ0e5XhjLNSO2etq+F2g9Mb6clkr5zBi2LQifzeguHe12JWMLSU1Y32fUG/J 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqf3n0s4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:10 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22A9rYFj020516;
        Thu, 10 Mar 2022 10:32:10 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqf3n0rxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22AAMWCm013676;
        Thu, 10 Mar 2022 10:31:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3ep8c3v2x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:31:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22AAVjnJ49545690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 10:31:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89D2E5204F;
        Thu, 10 Mar 2022 10:31:45 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EDD6B5204E;
        Thu, 10 Mar 2022 10:31:44 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v2 2/9] s390: uv: Add dump fields to query
Date:   Thu, 10 Mar 2022 10:31:05 +0000
Message-Id: <20220310103112.2156-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220310103112.2156-1-frankja@linux.ibm.com>
References: <20220310103112.2156-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1RjJuyegjvONCPIbJoAwK3_nBsUaWoME
X-Proofpoint-GUID: Yo10oc84B2PjHPD5cWiGedrHkkM1SL-q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 phishscore=0 clxscore=1015 spamscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new dump feature requires us to know how much memory is needed for
the "dump storage state" and "dump finalize" ultravisor call. These
values are reported via the UV query call.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/boot/uv.c        |  2 ++
 arch/s390/include/asm/uv.h |  5 +++++
 arch/s390/kernel/uv.c      | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index b100b57cf15d..67c737c1e580 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -43,6 +43,8 @@ void uv_query_info(void)
 		uv_info.uv_feature_indications = uvcb.uv_feature_indications;
 		uv_info.supp_se_hdr_ver = uvcb.supp_se_hdr_versions;
 		uv_info.supp_se_hdr_pcf = uvcb.supp_se_hdr_pcf;
+		uv_info.conf_dump_storage_state_len = uvcb.conf_dump_storage_state_len;
+		uv_info.conf_dump_finalize_len = uvcb.conf_dump_finalize_len;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 75b88247707a..a774267e9a12 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -112,6 +112,9 @@ struct uv_cb_qui {
 	u64 supp_se_hdr_versions;		/* 0x00b0 */
 	u64 supp_se_hdr_pcf;			/* 0x00b8 */
 	u64 reservedc0;				/* 0x00c0 */
+	u64 conf_dump_storage_state_len;	/* 0x00c8 */
+	u64 conf_dump_finalize_len;		/* 0x00d0 */
+	u8  reservedd8[256 - 216];		/* 0x00d8 */
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
@@ -291,6 +294,8 @@ struct uv_info {
 	unsigned long uv_feature_indications;
 	unsigned long supp_se_hdr_ver;
 	unsigned long supp_se_hdr_pcf;
+	unsigned long conf_dump_storage_state_len;
+	unsigned long conf_dump_finalize_len;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 852840384e75..84fe33b6af4d 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -410,6 +410,36 @@ static ssize_t uv_query_supp_se_hdr_pcf(struct kobject *kobj,
 static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
 	__ATTR(supp_se_hdr_pcf, 0444, uv_query_supp_se_hdr_pcf, NULL);
 
+static ssize_t uv_query_dump_cpu_len(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n",
+			uv_info.guest_cpu_stor_len);
+}
+
+static struct kobj_attribute uv_query_dump_cpu_len_attr =
+	__ATTR(uv_query_dump_cpu_len, 0444, uv_query_dump_cpu_len, NULL);
+
+static ssize_t uv_query_dump_storage_state_len(struct kobject *kobj,
+					       struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n",
+			uv_info.conf_dump_storage_state_len);
+}
+
+static struct kobj_attribute uv_query_dump_storage_state_len_attr =
+	__ATTR(dump_storage_state_len, 0444, uv_query_dump_storage_state_len, NULL);
+
+static ssize_t uv_query_dump_finalize_len(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%lx\n",
+			uv_info.conf_dump_finalize_len);
+}
+
+static struct kobj_attribute uv_query_dump_finalize_len_attr =
+	__ATTR(dump_finalize_len, 0444, uv_query_dump_finalize_len, NULL);
+
 static ssize_t uv_query_feature_indications(struct kobject *kobj,
 					    struct kobj_attribute *attr, char *buf)
 {
@@ -457,6 +487,9 @@ static struct attribute *uv_query_attrs[] = {
 	&uv_query_max_guest_addr_attr.attr,
 	&uv_query_supp_se_hdr_ver_attr.attr,
 	&uv_query_supp_se_hdr_pcf_attr.attr,
+	&uv_query_dump_storage_state_len_attr.attr,
+	&uv_query_dump_finalize_len_attr.attr,
+	&uv_query_dump_cpu_len_attr.attr,
 	NULL,
 };
 
-- 
2.32.0

