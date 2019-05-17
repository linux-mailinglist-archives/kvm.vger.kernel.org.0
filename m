Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8BB21B5E
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 18:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbfEQQRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 12:17:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729481AbfEQQRC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 May 2019 12:17:02 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4HG7mwu117171
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 12:17:01 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2shxy9up3d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 12:17:00 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 17 May 2019 17:16:58 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 May 2019 17:16:55 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4HGGsMT44302506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 16:16:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 012E452059;
        Fri, 17 May 2019 16:16:54 +0000 (GMT)
Received: from morel-ThinkPad-W530.boeblingen.de.ibm.com (unknown [9.145.153.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 644E85206B;
        Fri, 17 May 2019 16:16:53 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     sebott@linux.vnet.ibm.com
Cc:     gerald.schaefer@de.ibm.com, pasic@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
Subject: [PATCH v2 4/4] vfio: vfio_iommu_type1: implement VFIO_IOMMU_INFO_CAPABILITIES
Date:   Fri, 17 May 2019 18:16:50 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
References: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051716-4275-0000-0000-00000335E465
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051716-4276-0000-0000-0000384570A6
Message-Id: <1558109810-18683-5-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=635 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement the capability interface for VFIO_IOMMU_GET_INFO.

When calling the ioctl, the user must specify
VFIO_IOMMU_INFO_CAPABILITIES to retrieve the capabilities and
must check in the answer if capabilities are supported.

The iommu get_attr callback will be used to retrieve the specific
attributes and fill the capabilities.

Currently two Z-PCI specific capabilities will be queried and
filled by the underlying Z specific s390_iommu:
VFIO_IOMMU_INFO_CAP_QFN for the PCI query function attributes
and
VFIO_IOMMU_INFO_CAP_QGRP for the PCI query function group.

Other architectures may add new capabilities in the same way
after enhancing the architecture specific IOMMU driver.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/vfio/vfio_iommu_type1.c | 122 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 121 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index d0f731c..9435647 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1658,6 +1658,97 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 	return ret;
 }
 
+static int vfio_iommu_type1_zpci_fn(struct iommu_domain *domain,
+				    struct vfio_info_cap *caps, size_t size)
+{
+	struct vfio_iommu_type1_info_pcifn *info_fn;
+	int ret;
+
+	info_fn = kzalloc(size, GFP_KERNEL);
+	if (!info_fn)
+		return -ENOMEM;
+
+	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_ZPCI_FN,
+				    &info_fn->response);
+	if (ret < 0)
+		goto free_fn;
+
+	info_fn->header.id = VFIO_IOMMU_INFO_CAP_QFN;
+	ret = vfio_info_add_capability(caps, &info_fn->header, size);
+
+free_fn:
+	kfree(info_fn);
+	return ret;
+}
+
+static int vfio_iommu_type1_zpci_grp(struct iommu_domain *domain,
+				     struct vfio_info_cap *caps,
+				     size_t grp_size)
+{
+	struct vfio_iommu_type1_info_pcifg *info_grp;
+	int ret;
+
+	info_grp = kzalloc(grp_size, GFP_KERNEL);
+	if (!info_grp)
+		return -ENOMEM;
+
+	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_ZPCI_GRP,
+				    (void *) &info_grp->response);
+	if (ret < 0)
+		goto free_grp;
+	info_grp->header.id = VFIO_IOMMU_INFO_CAP_QGRP;
+	ret = vfio_info_add_capability(caps, &info_grp->header, grp_size);
+
+free_grp:
+	kfree(info_grp);
+	return ret;
+}
+
+int vfio_iommu_type1_caps(struct vfio_iommu *iommu, struct vfio_info_cap *caps,
+			  size_t size)
+{
+	struct vfio_domain *d;
+	unsigned long total_size, fn_size, grp_size;
+	int ret;
+
+	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
+	if (!d)
+		return -ENODEV;
+
+	/* First compute the size the user must provide */
+	total_size = 0;
+	fn_size = iommu_domain_get_attr(d->domain,
+					DOMAIN_ATTR_ZPCI_FN_SIZE, NULL);
+	if (fn_size > 0) {
+		fn_size +=  sizeof(struct vfio_info_cap_header);
+		total_size += fn_size;
+	}
+
+	grp_size = iommu_domain_get_attr(d->domain,
+					 DOMAIN_ATTR_ZPCI_GRP_SIZE, NULL);
+	if (grp_size > 0) {
+		grp_size +=  sizeof(struct vfio_info_cap_header);
+		total_size += grp_size;
+	}
+
+	if (total_size > size) {
+		/* Tell caller to call us with a greater buffer */
+		caps->size = total_size;
+		return 0;
+	}
+
+	if (fn_size) {
+		ret = vfio_iommu_type1_zpci_fn(d->domain, caps, fn_size);
+		if (ret)
+			return ret;
+	}
+
+	if (grp_size)
+		ret = vfio_iommu_type1_zpci_grp(d->domain, caps, grp_size);
+
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -1679,6 +1770,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		}
 	} else if (cmd == VFIO_IOMMU_GET_INFO) {
 		struct vfio_iommu_type1_info info;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+		int ret;
 
 		minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
 
@@ -1688,7 +1781,34 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
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

