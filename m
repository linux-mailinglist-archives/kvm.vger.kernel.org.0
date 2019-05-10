Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04AE3199AD
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 10:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfEJIZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 04:25:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726992AbfEJIZR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 May 2019 04:25:17 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4A8P6xD140435
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 04:25:15 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sd4vrt62n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 04:25:13 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 10 May 2019 09:22:44 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 May 2019 09:22:40 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4A8McNk58851378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 08:22:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1D2DAE051;
        Fri, 10 May 2019 08:22:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AA27AE045;
        Fri, 10 May 2019 08:22:38 +0000 (GMT)
Received: from morel-ThinkPad-W530.boeblingen.de.ibm.com (unknown [9.145.187.238])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 May 2019 08:22:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     sebott@linux.vnet.ibm.com
Cc:     gerald.schaefer@de.ibm.com, pasic@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: [PATCH 4/4] vfio: vfio_iommu_type1: implement VFIO_IOMMU_INFO_CAPABILITIES
Date:   Fri, 10 May 2019 10:22:35 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557476555-20256-1-git-send-email-pmorel@linux.ibm.com>
References: <1557476555-20256-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051008-0016-0000-0000-0000027A405B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051008-0017-0000-0000-000032D6F9DC
Message-Id: <1557476555-20256-5-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=950 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905100059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement a capability intercafe for VFIO_IOMMU_GET_INFO and add the
first capability: VFIO_IOMMU_INFO_CAPABILITIES.

When calling the ioctl, the user must specify
VFIO_IOMMU_INFO_CAPABILITIES to retrieve the capabilities and must check
in the answer if capabilities are supported.
Older kernel will not check nor set the VFIO_IOMMU_INFO_CAPABILITIES in
the flags of vfio_iommu_type1_info.

The iommu get_attr callback will be called to retrieve the specific
attributes and fill the capabilities, VFIO_IOMMU_INFO_CAP_QFN for the
PCI query function attributes and VFIO_IOMMU_INFO_CAP_QGRP for the
PCI query function group.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/vfio/vfio_iommu_type1.c | 95 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index d0f731c..f7f8120 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1658,6 +1658,70 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 	return ret;
 }
 
+int vfio_iommu_type1_caps(struct vfio_iommu *iommu, struct vfio_info_cap *caps,
+			  size_t size)
+{
+	struct vfio_domain *d;
+	struct vfio_iommu_type1_info_block *info_fn;
+	struct vfio_iommu_type1_info_block *info_grp;
+	unsigned long total_size, fn_size, grp_size;
+	int ret;
+
+	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
+	if (!d)
+		return -ENODEV;
+	/* The size of these capabilities are device dependent */
+	fn_size = iommu_domain_get_attr(d->domain,
+					DOMAIN_ATTR_ZPCI_FN_SIZE, NULL);
+	if (fn_size < 0)
+		return fn_size;
+	fn_size +=  sizeof(struct vfio_info_cap_header);
+	total_size = fn_size;
+
+	grp_size = iommu_domain_get_attr(d->domain,
+					 DOMAIN_ATTR_ZPCI_GRP_SIZE, NULL);
+	if (grp_size < 0)
+		return grp_size;
+	grp_size +=  sizeof(struct vfio_info_cap_header);
+	total_size += grp_size;
+
+	/* Tell caller to call us with a greater buffer */
+	if (total_size > size) {
+		caps->size = total_size;
+		return 0;
+	}
+
+	info_fn = kzalloc(fn_size, GFP_KERNEL);
+	if (!info_fn)
+		return -ENOMEM;
+	ret = iommu_domain_get_attr(d->domain,
+				    DOMAIN_ATTR_ZPCI_FN, &info_fn->data);
+	if (ret < 0)
+		return ret;
+
+	info_fn->header.id = VFIO_IOMMU_INFO_CAP_QFN;
+
+	ret = vfio_info_add_capability(caps, &info_fn->header, fn_size);
+	if (ret)
+		goto err_fn;
+
+	info_grp = kzalloc(grp_size, GFP_KERNEL);
+	if (!info_grp)
+		goto err_fn;
+	ret = iommu_domain_get_attr(d->domain,
+				    DOMAIN_ATTR_ZPCI_GRP, &info_grp->data);
+	if (ret < 0)
+		goto err_grp;
+	info_grp->header.id = VFIO_IOMMU_INFO_CAP_QGRP;
+	ret = vfio_info_add_capability(caps, &info_grp->header, grp_size);
+
+err_grp:
+	kfree(info_grp);
+err_fn:
+	kfree(info_fn);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -1679,6 +1743,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		}
 	} else if (cmd == VFIO_IOMMU_GET_INFO) {
 		struct vfio_iommu_type1_info info;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+		int ret;
 
 		minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
 
@@ -1688,7 +1754,34 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		info.flags = VFIO_IOMMU_INFO_PGSIZES;
+		if (info.flags & VFIO_IOMMU_INFO_CAPABILITIES) {
+			minsz = offsetofend(struct vfio_iommu_type1_info,
+					    cap_offset);
+			if (info.argsz < minsz)
+				return -EINVAL;
+			ret = vfio_iommu_type1_caps(iommu, &caps,
+						    info.argsz - sizeof(info));
+			if (ret)
+				return ret;
+		}
+		if (caps.size) {
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+				info.cap_offset = 0;
+			} else {
+				if (copy_to_user((void __user *)arg +
+						 sizeof(info), caps.buf,
+						 caps.size)) {
+					kfree(caps.buf);
+					return -EFAULT;
+				}
+
+				info.cap_offset = sizeof(info);
+			}
+			kfree(caps.buf);
+		}
+
+		info.flags |= VFIO_IOMMU_INFO_PGSIZES;
 
 		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
-- 
2.7.4

