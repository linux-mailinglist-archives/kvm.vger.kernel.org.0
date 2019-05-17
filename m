Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A952721B61
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 18:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfEQQRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 12:17:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729464AbfEQQRB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 May 2019 12:17:01 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4HG7mKg117153
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 12:17:00 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2shxy9up2x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 12:17:00 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 17 May 2019 17:16:57 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 May 2019 17:16:55 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4HGGrbY42139690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 16:16:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B7E852057;
        Fri, 17 May 2019 16:16:53 +0000 (GMT)
Received: from morel-ThinkPad-W530.boeblingen.de.ibm.com (unknown [9.145.153.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BE01E52076;
        Fri, 17 May 2019 16:16:52 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     sebott@linux.vnet.ibm.com
Cc:     gerald.schaefer@de.ibm.com, pasic@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
Subject: [PATCH v2 3/4] s390: iommu: Adding get attributes for s390_iommu
Date:   Fri, 17 May 2019 18:16:49 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
References: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051716-0012-0000-0000-0000031CCC95
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051716-0013-0000-0000-000021557328
Message-Id: <1558109810-18683-4-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add the "get attributes" callback to the S390 iommu operations
to retrieve the S390 specific attributes through the call of zPCI
dedicated CLP functions.

The caller can use the following attributes and retrieve:
DOMAIN_ATTR_ZPCI_FN_SIZE: the size of the Z-PCI function attributes
DOMAIN_ATTR_ZPCI_GRP_SIZE: the size of the Z-PCI function group attributes
DOMAIN_ATTR_ZPCI_FN: the Z-PCI function attributes
DOMAIN_ATTR_ZPCI_GRP: the Z-PCI function group attributes

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/iommu/s390-iommu.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iommu.h      |  4 +++
 2 files changed, 81 insertions(+)

diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 22d4db3..98082f0 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -363,6 +363,82 @@ void zpci_destroy_iommu(struct zpci_dev *zdev)
 	iommu_device_sysfs_remove(&zdev->iommu_dev);
 }
 
+struct zpci_dev *get_zpci(struct s390_domain *s390_domain)
+{
+	struct s390_domain_device *domain_device;
+
+	domain_device = list_first_entry(&s390_domain->devices,
+					 struct s390_domain_device, list);
+	if (!domain_device)
+		return NULL;
+	return domain_device->zdev;
+}
+
+static int s390_domain_get_fn(struct iommu_domain *domain, void *data)
+{
+	struct zpci_dev *zdev;
+	struct clp_req_rsp_query_pci *rrb;
+	int rc;
+
+	zdev = get_zpci(to_s390_domain(domain));
+	if (!zdev)
+		return -ENODEV;
+	rrb = (struct clp_req_rsp_query_pci *)
+	      __get_free_pages(GFP_KERNEL, get_order(CLP_BLK_SIZE));
+	if (!rrb)
+		return -ENOMEM;
+	rc = zdev_query_pci_fn(zdev, rrb);
+
+	if (!rc && rrb->response.hdr.rsp == CLP_RC_OK)
+		memcpy(data, &rrb->response, sizeof(struct clp_rsp_query_pci));
+	else
+		rc = -EIO;
+	free_pages((unsigned long) rrb, get_order(CLP_BLK_SIZE));
+	return rc;
+}
+
+static int s390_domain_get_grp(struct iommu_domain *domain, void *data)
+{
+	struct zpci_dev *zdev;
+	struct clp_req_rsp_query_pci_grp *rrb;
+	int rc;
+
+	zdev = get_zpci(to_s390_domain(domain));
+	if (!zdev)
+		return -ENODEV;
+	rrb = (struct clp_req_rsp_query_pci_grp *)
+	      __get_free_pages(GFP_KERNEL, get_order(CLP_BLK_SIZE));
+	if (!rrb)
+		return -ENOMEM;
+
+	rc = zdev_query_pci_fngrp(zdev, rrb);
+	if (!rc && rrb->response.hdr.rsp == CLP_RC_OK)
+		memcpy(data, &rrb->response,
+		       sizeof(struct clp_rsp_query_pci_grp));
+	else
+		rc = -EIO;
+
+	free_pages((unsigned long) rrb, get_order(CLP_BLK_SIZE));
+	return rc;
+}
+
+static int s390_domain_get_attr(struct iommu_domain *domain,
+				enum iommu_attr attr, void *data)
+{
+	switch (attr) {
+	case DOMAIN_ATTR_ZPCI_FN_SIZE:
+		return sizeof(struct clp_rsp_query_pci);
+	case DOMAIN_ATTR_ZPCI_GRP_SIZE:
+		return sizeof(struct clp_rsp_query_pci_grp);
+	case DOMAIN_ATTR_ZPCI_FN:
+		return s390_domain_get_fn(domain, data);
+	case DOMAIN_ATTR_ZPCI_GRP:
+		return s390_domain_get_grp(domain, data);
+	default:
+		return -ENODEV;
+	}
+}
+
 static const struct iommu_ops s390_iommu_ops = {
 	.capable = s390_iommu_capable,
 	.domain_alloc = s390_domain_alloc,
@@ -376,6 +452,7 @@ static const struct iommu_ops s390_iommu_ops = {
 	.remove_device = s390_iommu_remove_device,
 	.device_group = generic_device_group,
 	.pgsize_bitmap = S390_IOMMU_PGSIZES,
+	.domain_get_attr = s390_domain_get_attr,
 };
 
 static int __init s390_iommu_init(void)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ffbbc7e..ebdcac4 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -125,6 +125,10 @@ enum iommu_attr {
 	DOMAIN_ATTR_FSL_PAMUV1,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
+	DOMAIN_ATTR_ZPCI_FN_SIZE,
+	DOMAIN_ATTR_ZPCI_GRP_SIZE,
+	DOMAIN_ATTR_ZPCI_FN,
+	DOMAIN_ATTR_ZPCI_GRP,
 	DOMAIN_ATTR_MAX,
 };
 
-- 
2.7.4

