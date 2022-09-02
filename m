Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1225AB917
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 21:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiIBT7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiIBT7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:41 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6000324F32
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoOFCs68TFmQWvl9sXilncrMGq2D4v9rB8IfjVFLsfRBbIntAgkgo7HK3ia7/rEaUKmaCqiI3mh51rFGdnSpKsW4j0ulCSXNlFqg84k/tl+aakgQDP9Uln9gjrgMPNBW+DPZkDKRYnf3y3c5Ts6kp99IxmGEPX7icKzkG+mDyMRO+aoDtO4pDQJ2hcH9UFcB9/6qGz9duQ211tj9Zpih5s+MiR2mtCn6i8SDI2FjTMhW8mi4mRAOemjmR5emn6I9e8wXolbwRZd9/2MQhCauBPrVHnoVzMvz6gKPsrFENTb9P265rfLRHBbR344y9fV9JXnUiHxXZKlI3L/JKNG6vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFr20X3/WZIR2s6pGclhRuugabjIACsjZ1gs5EYpZ/s=;
 b=QeTK5BS3q9xv7bdQwhCCAL7lkFXyfaJTJSBqcDxheU8xbl0mObi856NIWsXtM6j5CHtt0eh58Cjd09vFwl4L8QIlcp7K/S5q/HiNWIp5aYnN6yDL/hZeU4vrqobExqJitY/vEgXzKwB40DQEibkgT68QB/gI/i4Y+DJjsYG4sAzFrHFwQKewEKxD0zxdthn1DGCsI9ONODybL+s2qf7+TBDErqAsWatrAsOJaaTWj/vFpTp8y7EVed5uSWmO217EoZ17MEYoyyqP1fxnBDLvyPnBLqy0Zyx4cYgZ3Ydfh+C43TuL4VHdh03WlLA6cn6I8u/4abrGCdCPCRMkh6NZ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFr20X3/WZIR2s6pGclhRuugabjIACsjZ1gs5EYpZ/s=;
 b=dHIPlCfvzUpYCdvQj7aGlxWbnpbIA29xd/+f2T5PUCu/+ua7vJYue7YMRCT5HQqA9TaZgxJvwhTLn9GuhilDTWOFMDXbHe7Yy2tnmc0+gFN7uKTWZVwgA8dIMVT5QQbRpSD9B54sB5C2U7YHjoUF2rdevCYcxdK7MFKwQr4vWVaBlLF3V4jzkOWrqu/5eFyQ+7Cdx3A+jMALgn960qPyHrjPTIlLFfxaV/liqglxpQasthQwcD7yfzG64KszYEng4EstPGRAdSZqAyZttlWGhlf7scpw3to2dcOgggzEUq0j8Q1cNYdJlTO8gB2+fgkWLruOmP8BM9v3D4CVFeZaEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:32 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH RFC v2 10/13] iommufd: Add kAPI toward external drivers for physical devices
Date:   Fri,  2 Sep 2022 16:59:26 -0300
Message-Id: <10-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:208:32a::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ff74659-5814-4716-9968-08da8d1da5fc
X-MS-TrafficTypeDiagnostic: DM4PR12MB6566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dnqylIG7AusKSQ+0dySP+M3Mpu+Jain3KK4bHVwA4ReV45Bq1BItFtGsqcwuX+eqFlVhNKBidTX9UUh1+jOsn+DzHDyjf5tIEafpwtBNltOKs5F4xJsXwI/rDHk1lnsJZEbtqplgRQ2k+zWBq+f/KUea9SJHngFiU4ZHYNSdUBSVCcOm97rYj2otDJ2VqFOxx9vVukvCwKN9NMIsNPwBFZcTtg5rLBVO0d5HTYOCkc8Pq7XEDjBXw7+YAlRyoZuJgxUdnos9VVAQUEJMVkPRT1TaKOwaplFx8w94krWj7ztILe+FIOa0lVienzp3lAkdKoDr44OIaGS6dd6TLYnc48WlYtg47YZa7u/0e+kNevCWVBE1pm1fYXEnOZDh17pxfLwsx7EFZ6S2Sa6HLXBv7DHAcquhp5HQo+F2q6b+SKw07/ukW2tkmXaHoLkbhTxLY9iuxi/pImgLGr760n6VH6HeYlAc/MHSXTvUjP2BDQCZKulLO5Wg8K6aLUrjUIUqhQSgFOgL0TKwoDWHq6mrjmn8s3ksxib1eEEQ3Z7e6MbaImS8nw+lyFr6yQ7uZSs/u5V9HJryq6FaARhsiomF36y+hmsL6NgbfqarX/3YTIFPxL90lzmNpzyZstnrW/czBijeDU/aYWtjz91MDE3FXT592fQt/a+CQZYE8EKt3ApABB4btlL+z/diUfppz4gG7fqCHL1pjPXsakvYVUkKbkdoLWCGe7SK0pXlisxjmU+MZhgWBYCr9e0bhb9ikHTE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(30864003)(5660300002)(109986005)(6506007)(36756003)(83380400001)(41300700001)(8936002)(6666004)(6486002)(478600001)(2906002)(38100700002)(66476007)(8676002)(66946007)(66556008)(4326008)(86362001)(54906003)(7416002)(26005)(6512007)(186003)(2616005)(316002)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d9t6sc+v6dFdpW0Wj4bcIrj5VXulzB/epQSymlA4vsMwQcHETys0aO++PlKK?=
 =?us-ascii?Q?9seVxkPV5mtnW3oTqHBhKnVms5d6x98o+Ud6Kz1yv+K4TnRPdJ5zsRLurgM1?=
 =?us-ascii?Q?t9a4w/Sof4WKKH5yUqgzGB7U2FJTFP9zwNIqkx0su9gB7CxNEoh9rYjNP+xg?=
 =?us-ascii?Q?E553EShXtFBw51msAURsyWD3HHV6X/BaVSHzv7CaYssqNYFF0oz4w0Vp4J43?=
 =?us-ascii?Q?dTMEtCRCrjz2nHaXwklAoh3de6BfZfy4pBgeOfxuOoFEhzIEa1PpInVcaoHK?=
 =?us-ascii?Q?9fypDJi8TlGOL8KM4tGl6mD0xnDUmqvgzTkbUYeQ2YsR6CNggXMa0GIOGPOp?=
 =?us-ascii?Q?xQFKiIbWjnm3WPcYZmC0Gg3gPjrzSuVMSWBQi/WfJZWnHaTlQbnULoNiZZxV?=
 =?us-ascii?Q?Jd7w/v/+EqcRF9+TUxnynFpufMWPmeoafZQEU69bD7F7+HR6Y248zL2K+Vdy?=
 =?us-ascii?Q?p0ukCpDhFivBCNYQxboWF/PXeoxoqnA53AI+RmSUcPBIGQVf+44pNzTQqx7t?=
 =?us-ascii?Q?zyvJ+8hCoEtUZg/g1qz5dfH2HBS5aS6RDOSL3wse84k+/HB2Zuf3T9MHEo2u?=
 =?us-ascii?Q?4ZMlGNzJlUJJxQhvU7yN/MAPQmabLMgJNqigHAedXETMI8hwTxrYGjk8SOFc?=
 =?us-ascii?Q?hNAAFNoX/H2F05uBeylDedtne7ONnHDHM15duW8Trss77wI+wAxX1W2q95+g?=
 =?us-ascii?Q?A3Q8yznsF9EnDqQG8FPfeJ1k5RyZ2oWjJG/nxQa6oX1cJtbc5GRwbs69J/mc?=
 =?us-ascii?Q?4Me0RVpDUdtJsYMZly7saCFa3TukIzcuRj2g3I382MGPEGhbzC/Bt/YECF/n?=
 =?us-ascii?Q?L2kddUZSRxUKj8+MjT5vXeVqGtAh1iQTMSSID7MCOuRq39u9GvvJGlwtlmri?=
 =?us-ascii?Q?O1bp8QTTi123uUt5FVJMqIT11nCZ1XYLwv192HomhVkMC6rtUlsB8vzs/7+6?=
 =?us-ascii?Q?dJ6P/QYwCDHgBEENnfZYUthldYsAfKeQXWyzPWBjJML/ccrarKCCmFfeX5H9?=
 =?us-ascii?Q?z6JWGruCXvpoU5ORNtHyAXmigw5xVhQgZEhXtRCB6SwH3b6Pmqx62iDwQMXF?=
 =?us-ascii?Q?x/Sv8YzFWz13z99VKFMgEYFMSaYnB6nnQC6rqmp+Zjzax3v+oKK9LPdNGACn?=
 =?us-ascii?Q?v8OGtq2tY+EBU79AaEMWu1vTeXIoDuT+knlO1O0c4BknS5go7x9QvE3dH7ZE?=
 =?us-ascii?Q?3CmLg9MnUxtVVRh5I5uIZGeWaHDsNMjm5K6eo4MSPF3f6p9MQjfjyhYpoXhT?=
 =?us-ascii?Q?p4bfCWF4/TFVjlshjghfAc/oEYTVGROFUc+CKZFlC1arJEQkV1JAj2N7+Nb3?=
 =?us-ascii?Q?IzByiBTkH/Mk82Tjw+tavSTehPeW9QHscGMmVndnsdU2HwLMpcU1YPUMxCZw?=
 =?us-ascii?Q?036lDgd2JYGaLPZeGaqyUf4CwPDItcUiD7kgyEbBtYfhGdsJ0bs42qdMPG/w?=
 =?us-ascii?Q?rOtTqY7I6eN2UYsrncwiYLe38cOeWN6PkHzI5boPETZ4Guhcc5c0K9JU6inx?=
 =?us-ascii?Q?6R0ViCpzYnGtglOqjaK6WfmyAO4hT1I3FqX/c1y1yPH4J1FKOP1rS7Y7dUqI?=
 =?us-ascii?Q?3H1zmgy5F2EUdIDm9GQEOr4ST3NsP0Y6Vrd3roSm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff74659-5814-4716-9968-08da8d1da5fc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:30.6740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evJ+dksiGzDYpyi3pPeltIMgPIqNnOvdMLmNL6A7keVQ9qLUl4B9DrCXAINAAv+o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the four functions external drivers need to connect physical DMA to
the IOMMUFD:

iommufd_device_bind() / iommufd_device_unbind()
  Register the device with iommufd and establish security isolation.

iommufd_device_attach() / iommufd_device_detach()
  Connect a bound device to a page table

Binding a device creates a device object ID in the uAPI, however the
generic API provides no IOCTLs to manipulate them.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/device.c          | 396 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |   4 +
 drivers/iommu/iommufd/main.c            |   3 +
 include/linux/iommufd.h                 |  14 +
 5 files changed, 418 insertions(+)
 create mode 100644 drivers/iommu/iommufd/device.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index e13e971aa28c60..ca28a135b9675f 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
+	device.o \
 	hw_pagetable.o \
 	io_pagetable.o \
 	ioas.o \
diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
new file mode 100644
index 00000000000000..23b101db846f40
--- /dev/null
+++ b/drivers/iommu/iommufd/device.c
@@ -0,0 +1,396 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/iommufd.h>
+#include <linux/slab.h>
+#include <linux/iommu.h>
+#include <linux/file.h>
+#include <linux/pci.h>
+#include <linux/irqdomain.h>
+#include <linux/dma-iommu.h>
+#include <linux/dma-map-ops.h>
+
+#include "iommufd_private.h"
+
+/*
+ * A iommufd_device object represents the binding relationship between a
+ * consuming driver and the iommufd. These objects are created/destroyed by
+ * external drivers, not by userspace.
+ */
+struct iommufd_device {
+	struct iommufd_object obj;
+	struct iommufd_ctx *ictx;
+	struct iommufd_hw_pagetable *hwpt;
+	/* Head at iommufd_hw_pagetable::devices */
+	struct list_head devices_item;
+	/* always the physical device */
+	struct device *dev;
+	struct iommu_group *group;
+};
+
+void iommufd_device_destroy(struct iommufd_object *obj)
+{
+	struct iommufd_device *idev =
+		container_of(obj, struct iommufd_device, obj);
+
+	iommu_group_release_dma_owner(idev->group);
+	iommu_group_put(idev->group);
+	iommufd_ctx_put(idev->ictx);
+}
+
+/**
+ * iommufd_device_bind - Bind a physical device to an iommu fd
+ * @ictx: iommufd file descriptor
+ * @dev: Pointer to a physical PCI device struct
+ * @id: Output ID number to return to userspace for this device
+ *
+ * A successful bind establishes an ownership over the device and returns
+ * struct iommufd_device pointer, otherwise returns error pointer.
+ *
+ * A driver using this API must set driver_managed_dma and must not touch
+ * the device until this routine succeeds and establishes ownership.
+ *
+ * Binding a PCI device places the entire RID under iommufd control.
+ *
+ * The caller must undo this with iommufd_unbind_device()
+ */
+struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
+					   struct device *dev, u32 *id)
+{
+	struct iommufd_device *idev;
+	struct iommu_group *group;
+	int rc;
+
+       /*
+        * iommufd always sets IOMMU_CACHE because we offer no way for userspace
+        * to restore cache coherency.
+        */
+	if (!iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY))
+		return ERR_PTR(-EINVAL);
+
+	group = iommu_group_get(dev);
+	if (!group)
+		return ERR_PTR(-ENODEV);
+
+	/*
+	 * FIXME: Use a device-centric iommu api, this won't work with
+	 * multi-device groups
+	 */
+	rc = iommu_group_claim_dma_owner(group, ictx);
+	if (rc)
+		goto out_group_put;
+
+	idev = iommufd_object_alloc(ictx, idev, IOMMUFD_OBJ_DEVICE);
+	if (IS_ERR(idev)) {
+		rc = PTR_ERR(idev);
+		goto out_release_owner;
+	}
+	idev->ictx = ictx;
+	iommufd_ctx_get(ictx);
+	idev->dev = dev;
+	/* The calling driver is a user until iommufd_device_unbind() */
+	refcount_inc(&idev->obj.users);
+	/* group refcount moves into iommufd_device */
+	idev->group = group;
+
+	/*
+	 * If the caller fails after this success it must call
+	 * iommufd_unbind_device() which is safe since we hold this refcount.
+	 * This also means the device is a leaf in the graph and no other object
+	 * can take a reference on it.
+	 */
+	iommufd_object_finalize(ictx, &idev->obj);
+	*id = idev->obj.id;
+	return idev;
+
+out_release_owner:
+	iommu_group_release_dma_owner(group);
+out_group_put:
+	iommu_group_put(group);
+	return ERR_PTR(rc);
+}
+EXPORT_SYMBOL_GPL(iommufd_device_bind);
+
+void iommufd_device_unbind(struct iommufd_device *idev)
+{
+	bool was_destroyed;
+
+	was_destroyed = iommufd_object_destroy_user(idev->ictx, &idev->obj);
+	WARN_ON(!was_destroyed);
+}
+EXPORT_SYMBOL_GPL(iommufd_device_unbind);
+
+/**
+ * iommufd_device_enforced_coherent - True if no-snoop TLPs are blocked
+ * @idev: device to query
+ *
+ * This can only be called if the device is attached, and the caller must ensure
+ * that the this is not raced with iommufd_device_attach() /
+ * iommufd_device_detach().
+ */
+bool iommufd_device_enforced_coherent(struct iommufd_device *idev)
+{
+	return iommufd_ioas_enforced_coherent(idev->hwpt->ioas);
+}
+EXPORT_SYMBOL_GPL(iommufd_device_enforced_coherent);
+
+static int iommufd_device_setup_msi(struct iommufd_device *idev,
+				    struct iommufd_hw_pagetable *hwpt,
+				    phys_addr_t sw_msi_start,
+				    unsigned int flags)
+{
+	int rc;
+
+	/*
+	 * IOMMU_CAP_INTR_REMAP means that the platform is isolating MSI,
+	 * nothing further to do.
+	 */
+	if (iommu_capable(idev->dev->bus, IOMMU_CAP_INTR_REMAP))
+		return 0;
+
+	/*
+	 * On ARM systems that set the global IRQ_DOMAIN_FLAG_MSI_REMAP every
+	 * allocated iommu_domain will block interrupts by default and this
+	 * special flow is needed to turn them back on.
+	 */
+	if (irq_domain_check_msi_remap()) {
+		if (WARN_ON(!sw_msi_start))
+			return -EPERM;
+		/*
+		 * iommu_get_msi_cookie() can only be called once per domain,
+		 * it returns -EBUSY on later calls.
+		 */
+		if (hwpt->msi_cookie)
+			return 0;
+		rc = iommu_get_msi_cookie(hwpt->domain, sw_msi_start);
+		if (rc && rc != -ENODEV)
+			return rc;
+		hwpt->msi_cookie = true;
+		return 0;
+	}
+
+	/*
+	 * Otherwise the platform has a MSI window that is not isolated. For
+	 * historical compat with VFIO allow a module parameter to ignore the
+	 * insecurity.
+	 */
+	if (!(flags & IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT))
+		return -EPERM;
+	return 0;
+}
+
+static bool iommufd_hw_pagetable_has_group(struct iommufd_hw_pagetable *hwpt,
+					   struct iommu_group *group)
+{
+	struct iommufd_device *cur_dev;
+
+	list_for_each_entry (cur_dev, &hwpt->devices, devices_item)
+		if (cur_dev->group == group)
+			return true;
+	return false;
+}
+
+static int iommufd_device_do_attach(struct iommufd_device *idev,
+				    struct iommufd_hw_pagetable *hwpt,
+				    unsigned int flags)
+{
+	int rc;
+
+	mutex_lock(&hwpt->devices_lock);
+	/*
+	 * FIXME: Use a device-centric iommu api. For now check if the
+	 * hw_pagetable already has a device of the same group joined to tell if
+	 * we are the first and need to attach the group.
+	 */
+	if (!iommufd_hw_pagetable_has_group(hwpt, idev->group)) {
+		phys_addr_t sw_msi_start = 0;
+
+		rc = iommu_attach_group(hwpt->domain, idev->group);
+		if (rc)
+			goto out_unlock;
+
+		/*
+		 * hwpt is now the exclusive owner of the group so this is the
+		 * first time enforce is called for this group.
+		 */
+		rc = iopt_table_enforce_group_resv_regions(
+			&hwpt->ioas->iopt, idev->group, &sw_msi_start);
+		if (rc)
+			goto out_detach;
+		rc = iommufd_device_setup_msi(idev, hwpt, sw_msi_start, flags);
+		if (rc)
+			goto out_iova;
+
+		if (list_empty(&hwpt->devices)) {
+			rc = iopt_table_add_domain(&hwpt->ioas->iopt,
+						   hwpt->domain);
+			if (rc)
+				goto out_iova;
+		}
+	}
+
+	idev->hwpt = hwpt;
+	refcount_inc(&hwpt->obj.users);
+	list_add(&idev->devices_item, &hwpt->devices);
+	mutex_unlock(&hwpt->devices_lock);
+	return 0;
+
+out_iova:
+	iopt_remove_reserved_iova(&hwpt->ioas->iopt, idev->group);
+out_detach:
+	iommu_detach_group(hwpt->domain, idev->group);
+out_unlock:
+	mutex_unlock(&hwpt->devices_lock);
+	return rc;
+}
+
+/*
+ * When automatically managing the domains we search for a compatible domain in
+ * the iopt and if one is found use it, otherwise create a new domain.
+ * Automatic domain selection will never pick a manually created domain.
+ */
+static int iommufd_device_auto_get_domain(struct iommufd_device *idev,
+					  struct iommufd_ioas *ioas,
+					  unsigned int flags)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	int rc;
+
+	/*
+	 * There is no differentiation when domains are allocated, so any domain
+	 * that is willing to attach to the device is interchangeable with any
+	 * other.
+	 */
+	mutex_lock(&ioas->mutex);
+	list_for_each_entry (hwpt, &ioas->hwpt_list, hwpt_item) {
+		if (!hwpt->auto_domain ||
+		    !refcount_inc_not_zero(&hwpt->obj.users))
+			continue;
+
+		/*
+		 * FIXME: if the group is already attached to a domain make sure
+		 * this returns EMEDIUMTYPE
+		 */
+		rc = iommufd_device_do_attach(idev, hwpt, flags);
+		refcount_dec(&hwpt->obj.users);
+		if (rc) {
+			if (rc == -EMEDIUMTYPE)
+				continue;
+			goto out_unlock;
+		}
+		goto out_unlock;
+	}
+
+	hwpt = iommufd_hw_pagetable_alloc(idev->ictx, ioas, idev->dev);
+	if (IS_ERR(hwpt)) {
+		rc = PTR_ERR(hwpt);
+		goto out_unlock;
+	}
+	hwpt->auto_domain = true;
+
+	rc = iommufd_device_do_attach(idev, hwpt, flags);
+	if (rc)
+		goto out_abort;
+	list_add_tail(&hwpt->hwpt_item, &ioas->hwpt_list);
+
+	mutex_unlock(&ioas->mutex);
+	iommufd_object_finalize(idev->ictx, &hwpt->obj);
+	return 0;
+
+out_abort:
+	iommufd_object_abort_and_destroy(idev->ictx, &hwpt->obj);
+out_unlock:
+	mutex_unlock(&ioas->mutex);
+	return rc;
+}
+
+/**
+ * iommufd_device_attach - Connect a device to an iommu_domain
+ * @idev: device to attach
+ * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
+ *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
+ * @flags: Optional flags
+ *
+ * This connects the device to an iommu_domain, either automatically or manually
+ * selected. Once this completes the device could do DMA.
+ *
+ * The caller should return the resulting pt_id back to userspace.
+ * This function is undone by calling iommufd_device_detach().
+ */
+int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
+			  unsigned int flags)
+{
+	struct iommufd_object *pt_obj;
+	int rc;
+
+	pt_obj = iommufd_get_object(idev->ictx, *pt_id, IOMMUFD_OBJ_ANY);
+	if (IS_ERR(pt_obj))
+		return PTR_ERR(pt_obj);
+
+	switch (pt_obj->type) {
+	case IOMMUFD_OBJ_HW_PAGETABLE: {
+		struct iommufd_hw_pagetable *hwpt =
+			container_of(pt_obj, struct iommufd_hw_pagetable, obj);
+
+		rc = iommufd_device_do_attach(idev, hwpt, flags);
+		if (rc)
+			goto out_put_pt_obj;
+
+		mutex_lock(&hwpt->ioas->mutex);
+		list_add_tail(&hwpt->hwpt_item, &hwpt->ioas->hwpt_list);
+		mutex_unlock(&hwpt->ioas->mutex);
+		break;
+	}
+	case IOMMUFD_OBJ_IOAS: {
+		struct iommufd_ioas *ioas =
+			container_of(pt_obj, struct iommufd_ioas, obj);
+
+		rc = iommufd_device_auto_get_domain(idev, ioas, flags);
+		if (rc)
+			goto out_put_pt_obj;
+		break;
+	}
+	default:
+		rc = -EINVAL;
+		goto out_put_pt_obj;
+	}
+
+	refcount_inc(&idev->obj.users);
+	*pt_id = idev->hwpt->obj.id;
+	rc = 0;
+
+out_put_pt_obj:
+	iommufd_put_object(pt_obj);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(iommufd_device_attach);
+
+void iommufd_device_detach(struct iommufd_device *idev)
+{
+	struct iommufd_hw_pagetable *hwpt = idev->hwpt;
+
+	mutex_lock(&hwpt->ioas->mutex);
+	mutex_lock(&hwpt->devices_lock);
+	list_del(&idev->devices_item);
+	if (!iommufd_hw_pagetable_has_group(hwpt, idev->group)) {
+		if (list_empty(&hwpt->devices)) {
+			iopt_table_remove_domain(&hwpt->ioas->iopt,
+						 hwpt->domain);
+			list_del(&hwpt->hwpt_item);
+		}
+		iopt_remove_reserved_iova(&hwpt->ioas->iopt, idev->group);
+		iommu_detach_group(hwpt->domain, idev->group);
+	}
+	mutex_unlock(&hwpt->devices_lock);
+	mutex_unlock(&hwpt->ioas->mutex);
+
+	if (hwpt->auto_domain)
+		iommufd_object_destroy_user(idev->ictx, &hwpt->obj);
+	else
+		refcount_dec(&hwpt->obj.users);
+
+	idev->hwpt = NULL;
+
+	refcount_dec(&idev->obj.users);
+}
+EXPORT_SYMBOL_GPL(iommufd_device_detach);
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 4f628800bc2b71..0ede92b0aa32b4 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -92,6 +92,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_DEVICE,
 	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
 };
@@ -216,6 +217,7 @@ struct iommufd_hw_pagetable {
 	struct iommu_domain *domain;
 	bool auto_domain : 1;
 	bool enforce_cache_coherency : 1;
+	bool msi_cookie : 1;
 	/* Head at iommufd_ioas::hwpt_list */
 	struct list_head hwpt_item;
 	struct mutex devices_lock;
@@ -227,4 +229,6 @@ iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			   struct device *dev);
 void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
 
+void iommufd_device_destroy(struct iommufd_object *obj);
+
 #endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 2a9b581cacffb6..b09dbfc8009dc2 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -327,6 +327,9 @@ void iommufd_ctx_put(struct iommufd_ctx *ictx)
 EXPORT_SYMBOL_GPL(iommufd_ctx_put);
 
 static struct iommufd_object_ops iommufd_object_ops[] = {
+	[IOMMUFD_OBJ_DEVICE] = {
+		.destroy = iommufd_device_destroy,
+	},
 	[IOMMUFD_OBJ_IOAS] = {
 		.destroy = iommufd_ioas_destroy,
 	},
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 9c6ec4d66b4a92..477c3ea098f637 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -9,12 +9,26 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/device.h>
 
 struct page;
+struct iommufd_device;
 struct iommufd_ctx;
 struct io_pagetable;
 struct file;
 
+struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
+					   struct device *dev, u32 *id);
+void iommufd_device_unbind(struct iommufd_device *idev);
+bool iommufd_device_enforced_coherent(struct iommufd_device *idev);
+
+enum {
+	IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT = 1 << 0,
+};
+int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
+			  unsigned int flags);
+void iommufd_device_detach(struct iommufd_device *idev);
+
 int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
 		      unsigned long length, struct page **out_pages,
 		      bool write);
-- 
2.37.3

