Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3167D16A535
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 12:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgBXLlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 06:41:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727504AbgBXLlR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 06:41:17 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OBdLDa080182;
        Mon, 24 Feb 2020 06:41:17 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb1b75f4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:16 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OBdQXG080554;
        Mon, 24 Feb 2020 06:41:16 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb1b75f3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:16 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01OBag51016932;
        Mon, 24 Feb 2020 11:41:15 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 2yaux632jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 11:41:15 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OBfDCj45613496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 11:41:13 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D3A72805A;
        Mon, 24 Feb 2020 11:41:13 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D99928059;
        Mon, 24 Feb 2020 11:41:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 11:41:13 +0000 (GMT)
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
Subject: [PATCH v4 34/36] s390: protvirt: Add sysfs firmware interface for Ultravisor information
Date:   Mon, 24 Feb 2020 06:41:05 -0500
Message-Id: <20200224114107.4646-35-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224114107.4646-1-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240099
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
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kernel/uv.c | 86 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 4539003dac9d..550e9617c459 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -323,5 +323,91 @@ int arch_make_page_accessible(struct page *page)
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

