Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C278015F992
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgBNW1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:27:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11064 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728157AbgBNW1l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:27:41 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EMOcLs035805;
        Fri, 14 Feb 2020 17:27:41 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y3wxvypxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:40 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EMOeD8035940;
        Fri, 14 Feb 2020 17:27:40 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y3wxvypxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:40 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EMP6Ku003833;
        Fri, 14 Feb 2020 22:27:39 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 2y5bc09xa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 22:27:39 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EMRaBA62390662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 22:27:36 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F6FF136094;
        Fri, 14 Feb 2020 22:27:36 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6695B136091;
        Fri, 14 Feb 2020 22:27:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 22:27:35 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v2 38/42] s390: protvirt: Add sysfs firmware interface for Ultravisor information
Date:   Fri, 14 Feb 2020 17:26:54 -0500
Message-Id: <20200214222658.12946-39-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200214222658.12946-1-borntraeger@de.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_08:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

That information, e.g. the maximum number of guests or installed
Ultravisor facilities, is interesting for QEMU, Libvirt and
administrators.

Let's provide an easily parsable API to get that information.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 86 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 9a6c309864a0..fb606b171f42 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -322,5 +322,91 @@ int arch_make_page_accessible(struct page *page)
 	return rc;
 }
 EXPORT_SYMBOL_GPL(arch_make_page_accessible);
+#endif
+
+#if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
+static ssize_t uv_query_facilities(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%lx\n%lx\n%lx\n%lx\n",
+			uv_info.inst_calls_list[0],
+			uv_info.inst_calls_list[1],
+			uv_info.inst_calls_list[2],
+			uv_info.inst_calls_list[3]);
+}
+
+static struct kobj_attribute uv_query_facilities_attr =
+	__ATTR(facilities, 0444, uv_query_facilities, NULL);
+
+static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%d\n",
+			uv_info.max_guest_cpus);
+}
+
+static struct kobj_attribute uv_query_max_guest_cpus_attr =
+	__ATTR(max_cpus, 0444, uv_query_max_guest_cpus, NULL);
+
+static ssize_t uv_query_max_guest_vms(struct kobject *kobj,
+				      struct kobj_attribute *attr, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%d\n",
+			uv_info.max_num_sec_conf);
+}
+
+static struct kobj_attribute uv_query_max_guest_vms_attr =
+	__ATTR(max_guests, 0444, uv_query_max_guest_vms, NULL);
+
+static ssize_t uv_query_max_guest_addr(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%lx\n",
+			uv_info.max_sec_stor_addr);
+}
+
+static struct kobj_attribute uv_query_max_guest_addr_attr =
+	__ATTR(max_address, 0444, uv_query_max_guest_addr, NULL);
+
+static struct attribute *uv_query_attrs[] = {
+	&uv_query_facilities_attr.attr,
+	&uv_query_max_guest_cpus_attr.attr,
+	&uv_query_max_guest_vms_attr.attr,
+	&uv_query_max_guest_addr_attr.attr,
+	NULL,
+};
+
+static struct attribute_group uv_query_attr_group = {
+	.attrs = uv_query_attrs,
+};
 
+static struct kset *uv_query_kset;
+struct kobject *uv_kobj;
+
+static int __init uv_info_init(void)
+{
+	int rc = -ENOMEM;
+
+	if (!test_facility(158))
+		return 0;
+
+	uv_kobj = kobject_create_and_add("uv", firmware_kobj);
+	if (!uv_kobj)
+		return -ENOMEM;
+
+	uv_query_kset = kset_create_and_add("query", NULL, uv_kobj);
+	if (!uv_query_kset)
+		goto out_kobj;
+
+	rc = sysfs_create_group(&uv_query_kset->kobj, &uv_query_attr_group);
+	if (!rc)
+		return 0;
+
+	kset_unregister(uv_query_kset);
+out_kobj:
+	kobject_del(uv_kobj);
+	kobject_put(uv_kobj);
+	return rc;
+}
+device_initcall(uv_info_init);
 #endif
-- 
2.25.0

