Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF7763C966
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbiK2Ud7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbiK2Ud0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:33:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A73931EDA
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NANs7g8Wt24L7QL4dtyaHbcvntG8hXIKpbAyMWjxx0AEcHH8QjHW78as8cHPVv67nQARl6RJP466QvfTyTnndFZw5xiatsmVITVj9uto55f1+LQOk0u1rjqrLnIGoUC1oS/p4xpZ/ZGvrFuuxccu8AMRE1Tvz4R7nOAPBS8QGwhkMoUe9zFPYfVHtO+gvfwlnh1v7YbKk/523/QyGEjh3SzeXsnPGCGFArNuYDghZV6f5nMlj1FdKThTmC9qi7ktKVk6v87FVdclTavtyIbkCNw5W4dyiFa4FWvqW1boqtYHXS9ewKFo0fsOx9Jio4owOm6zQbfZQd84OLvbz8B7sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUfW1tSkQO9h78RuReb9MjD4hPuGM8VM/DaSBEz6mIY=;
 b=Sn0FpyNAZ4AfXT9EFjf0jPq8ENR6Vewh/fvY40pJeevBwr2l+xNdeOZPoTDNC4wrM+pEKuuBeuvGQKKwk4dtq3dBawfPFXtZp7S3oOOqCyrz74KHgu7dseZP8EukWzqkvDIVCZuU44as5GQfxQPlSs7BCC3902B1WjGt5Mwk9w8dnqHCDurGw0hD1xrHiJIWPO8FKQLy3RBvKxs9vOfNzCpMdmk7Q8otE8mWGs3pl+ApvBhlM7E4DlangPyulP2yxBzZnOelbEzem2sG4S7KilwuzeBcrW1iIhDEf/Ft/bPucAv0riLfQ9iuLA2Qop7UKgUa1/Saohl/SdPqQpGmGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUfW1tSkQO9h78RuReb9MjD4hPuGM8VM/DaSBEz6mIY=;
 b=tUATCESAdk0THAHaA60u7c4GnVVdMl5R4sLaW5K+zsuX05MBzQVgATA/6o3S1i3MsLIxk8f78dv/Q1oox3Q5vysRnivKGhG3RNzJt+wL5YUIlBfOQn0cFE6UXIpbCCXqYoHUsOabJaj8yrUMbjg2qBRR+WLCrXt/RboT+87dzsxvBP7W7xuLIg6/3jgcJhxScdWDE0Wpn2msH9YBq9j66FW9IiyuAZ12Tx8gBCV9lbl2xZstZNKzHMY531GXhr91j6SdMBQvATt9wuL9D4y7fnc34JuXFps5RVB0ULzV7Cta2l7WkVYUvQq4Ij+fjD4cd2ek6odw1y588As7ONLAHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:32:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:32:05 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v4 06/10] vfio-iommufd: Support iommufd for physical VFIO devices
Date:   Tue, 29 Nov 2022 16:31:51 -0400
Message-Id: <6-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0049.namprd08.prod.outlook.com
 (2603:10b6:a03:117::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: cc83b858-c005-4126-24a3-08dad248c560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jxGTYybCIeVjTfuuI8SAFMZxPFBWtlkvycVG8yBWkWwRxGDW71QCG9+dt4BVw6/g/N4YT5lP+i+Lwn+RglNaAVE1lEP+CXJFHlMZAQfO84s5rW7FrJrPABW/wgmHI/YhU1Ds5psSxskJd/tHXFyoxEN71fqb8QScggxuWJDnTwTRXzvOzUsA6QevHNbufmLEG+6uzhluCMXd3JHTJHDdOSOPCPLsWwRhfXMAOj1X1XDV7uvotphJzH/MNcj6ir9stp8f2eU5XLFudrSK9hhwo+JoRaOCp1HzijLULW9V7FisVZoztn07DTqv9UCmjld6dqo0LV4fCpADKfVfodFjz8wVJFt0i3QmnKu2leWR8y8nVy0ZpTWc2TPLJI2ABzbQBQ/KICD5JWi50n0ktI3S0KZWPxgqaltgZNN05lcTnKig6U9hJpWhZACr6sSXEL2Y4bmYTzQJAu5xR7Hlc1YwO1+U0F3BU3CEJkTG+J+kIZFxWgRepngzo8pY6pSMKmIgB1qGBzdVdGYLY0GJiASPzY0sBfEK8iI+NCy8114f5CsKnpVHqc2t0wXm2bPyXCoCIT9zzySJoopta+LhiAj2BJgAgdmz3isVVVQ+ZGCScGDXAKswrOctJ56T5i9JJvBTmD4H673yp43jUFVEib9nnJh3IiPiu/O8BPmw9GO8xD2mdIRuXgnzJ2+0N4WJXR0RROZ+1QMRvuTK/WHZU8i/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(109986013)(451199015)(30864003)(5660300002)(66946007)(7416002)(38100700002)(54906003)(186003)(6512007)(316002)(8936002)(36756003)(4326008)(8676002)(6666004)(66556008)(26005)(66476007)(6506007)(2616005)(41300700001)(86362001)(478600001)(6486002)(2906002)(83380400001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pICZrEwI1X80Um6r2bJcsDimqe4bA6X1z0FcZrspZM85fNcTHcUdXlHTBUUc?=
 =?us-ascii?Q?LTPKh7XfGQk9DQqv0i/AzdUfJLVDsa9Hmo0jUPCC+U0/MnWPvjGDu+rttE5k?=
 =?us-ascii?Q?lLhGfjPBgpMHvOEcz2jTH4UI9s1GIyJ5QtL7hsWEsN16Pk6kwJcDwWsGCnE3?=
 =?us-ascii?Q?pEjBVkcQy0XvnkverjhElVcvdiZHbQi0s7oeBVdgGZRTLYK5+Gh4BsPlKbTB?=
 =?us-ascii?Q?95Hmxop9mXdxhB97dMesLQLyXCo+u1iN/VoP2j+CZs6mrozjd49nYBjGFWId?=
 =?us-ascii?Q?pI/YIkzSoLiu+QuewurlbOdxLkHHgODtZydDLX1W15+BkqSQ6PQISrPaFkSf?=
 =?us-ascii?Q?xOGGqpv6fK+1iSjcjizUHFJDnnWBlkiVhIF5dRmL/WJ842edeFOdRI8cIiZo?=
 =?us-ascii?Q?XDVEtX9/DwRqi/fhQZZ+HHhRGppBc0UMgeANDPXdEokmELap/1K3S5r6mInf?=
 =?us-ascii?Q?oAnRBrgUcDAdf14n3Pi9340JhW6sR1UWEUs97B/xCh0LKQUp0VTNb/Xz69IX?=
 =?us-ascii?Q?ZsKXf5Ie239yjjmAoTQb20gFZCqA7jt8tLo08YQLItzBxZ3BztmqeZSB3sKR?=
 =?us-ascii?Q?8sruT4XSJAnwhaQqQhFNMM8vcMBG/8Li6rbPG+tQm2ltI1IaO24JDjqU3ZCb?=
 =?us-ascii?Q?HJRaDPPUdTBUMU2raPshDM4WmEn/QXstsbOsQO3GuZSzp/8CD7B2QcCstnhk?=
 =?us-ascii?Q?sE8YSE/CzT1GYY+F2zXuTPWDYj/+iDtWcUvocu3LBzg9WV8sEDcr87bTnNv8?=
 =?us-ascii?Q?P8q98vGaoUcUTLP8G6R3o8BpOtBjZWZShRKMkOYOHIJ5xEJCy0oGxtInqHQi?=
 =?us-ascii?Q?iCVWPVSQ5RMklWJh4vJ7w3iTPV1n9baEQAs0AtDPxfOs5LEyPUnSTU0Qwe+o?=
 =?us-ascii?Q?SvngeZSUXcmWetDQhECVmO/P2oMb8oLjrWPg/aUDMJ5OTGT+NgH6VGEXE897?=
 =?us-ascii?Q?EeIkqQMXI/d78SDZzVM5C2EpiaITR3dNCMguyUR612sQaiGDB3mzrvdDNMeq?=
 =?us-ascii?Q?biRqhb523Jl7oXmYqIJiB7JmqRu8ygN1d0p9UZ5iskHCTeWghD2FrVHwvzmQ?=
 =?us-ascii?Q?cp5iPbiyHx85veVIStj48ol/cnJGj30gGclqaFrXXBedS3D01aDH3CC7F0FQ?=
 =?us-ascii?Q?hkCBmnr6+tS/Rt3bYELgRj3MQ0EpIKwlv2piBEMcF0mWGC1P2ULqv805tBCa?=
 =?us-ascii?Q?jtzYk06u/z4XFdmgoki8yLHkpDFZm4AXVIbv8KsXL9O+f81affR3eJVsLK44?=
 =?us-ascii?Q?+RQ+5XGlHqqXHHrDCnIKfFI1AV+N4ngZAcI9pWw57I78p2su4uEC23RQQDeQ?=
 =?us-ascii?Q?g3m1AB6pFPMjDrlaWeqKNO2nUu+UjhYzOMduCSngE/5Wu1hIGzTMSzTZ5EGr?=
 =?us-ascii?Q?8BHXoGvRCItzQ7qt0mR7Pc3lvErbbzGXVz5ncw1nhcbVYOsu0nsH9uevz2BE?=
 =?us-ascii?Q?QtS1VxGC0R12CxzDOIoumaEeqOK9IokA9TY+m4QQVWNoGOXA+G/7BYQckBli?=
 =?us-ascii?Q?8Y2gUWgQfn9iJ0P04LiYHdcl0EdjAUir20IY8gXTh9dKLOEZof0V/Fe7DO7F?=
 =?us-ascii?Q?UlS7EG3pyjBmb4HlyyvPjVH1U037vfOPIOVKW1zW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc83b858-c005-4126-24a3-08dad248c560
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:32:02.1142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GixLb/aZv8gbBy6bpD0qHkb1d1U9P8yTOqM0NpCgSaQBVmdWu0zXG5b+z5s1u1Ll
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This creates the iommufd_device for the physical VFIO drivers. These are
all the drivers that are calling vfio_register_group_dev() and expect the
type1 code to setup a real iommu_domain against their parent struct
device.

The design gives the driver a choice in how it gets connected to iommufd
by providing bind_iommufd/unbind_iommufd/attach_ioas callbacks to
implement as required. The core code provides three default callbacks for
physical mode using a real iommu_domain. This is suitable for drivers
using vfio_register_group_dev()

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Makefile                         |   1 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   3 +
 drivers/vfio/iommufd.c                        | 100 ++++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   6 ++
 drivers/vfio/pci/mlx5/main.c                  |   3 +
 drivers/vfio/pci/vfio_pci.c                   |   3 +
 drivers/vfio/platform/vfio_amba.c             |   3 +
 drivers/vfio/platform/vfio_platform.c         |   3 +
 drivers/vfio/vfio.h                           |  15 +++
 drivers/vfio/vfio_main.c                      |  15 ++-
 include/linux/vfio.h                          |  25 +++++
 11 files changed, 175 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/iommufd.c

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index b693a1169286f8..3863922529ef20 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_VFIO) += vfio.o
 vfio-y += vfio_main.o \
 	  iova_bitmap.o \
 	  container.o
+vfio-$(CONFIG_IOMMUFD) += iommufd.o
 
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index b16874e913e4f5..5cd4bb47644039 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -592,6 +592,9 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
 	.read		= vfio_fsl_mc_read,
 	.write		= vfio_fsl_mc_write,
 	.mmap		= vfio_fsl_mc_mmap,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
 };
 
 static struct fsl_mc_driver vfio_fsl_mc_driver = {
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
new file mode 100644
index 00000000000000..6e47a3df1a7102
--- /dev/null
+++ b/drivers/vfio/iommufd.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/vfio.h>
+#include <linux/iommufd.h>
+
+#include "vfio.h"
+
+MODULE_IMPORT_NS(IOMMUFD);
+MODULE_IMPORT_NS(IOMMUFD_VFIO);
+
+int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
+{
+	u32 ioas_id;
+	u32 device_id;
+	int ret;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	/*
+	 * If the driver doesn't provide this op then it means the device does
+	 * not do DMA at all. So nothing to do.
+	 */
+	if (!vdev->ops->bind_iommufd)
+		return 0;
+
+	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
+	if (ret)
+		return ret;
+
+	ret = iommufd_vfio_compat_ioas_id(ictx, &ioas_id);
+	if (ret)
+		goto err_unbind;
+	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
+	if (ret)
+		goto err_unbind;
+
+	/*
+	 * The legacy path has no way to return the device id or the selected
+	 * pt_id
+	 */
+	return 0;
+
+err_unbind:
+	if (vdev->ops->unbind_iommufd)
+		vdev->ops->unbind_iommufd(vdev);
+	return ret;
+}
+
+void vfio_iommufd_unbind(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (vdev->ops->unbind_iommufd)
+		vdev->ops->unbind_iommufd(vdev);
+}
+
+/*
+ * The physical standard ops mean that the iommufd_device is bound to the
+ * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
+ * using this ops set should call vfio_register_group_dev()
+ */
+int vfio_iommufd_physical_bind(struct vfio_device *vdev,
+			       struct iommufd_ctx *ictx, u32 *out_device_id)
+{
+	struct iommufd_device *idev;
+
+	idev = iommufd_device_bind(ictx, vdev->dev, out_device_id);
+	if (IS_ERR(idev))
+		return PTR_ERR(idev);
+	vdev->iommufd_device = idev;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_bind);
+
+void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (vdev->iommufd_attached) {
+		iommufd_device_detach(vdev->iommufd_device);
+		vdev->iommufd_attached = false;
+	}
+	iommufd_device_unbind(vdev->iommufd_device);
+	vdev->iommufd_device = NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_unbind);
+
+int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
+{
+	int rc;
+
+	rc = iommufd_device_attach(vdev->iommufd_device, pt_id);
+	if (rc)
+		return rc;
+	vdev->iommufd_attached = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_attach_ioas);
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 39eeca18a0f7c8..40019b11c5a969 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1246,6 +1246,9 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.mmap = hisi_acc_vfio_pci_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
 };
 
 static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
@@ -1261,6 +1264,9 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
 };
 
 static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index fd6ccb8454a24a..32d1f38d351e7e 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -623,6 +623,9 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
 };
 
 static int mlx5vf_pci_probe(struct pci_dev *pdev,
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 1d4919edfbde48..29091ee2e9849b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -138,6 +138,9 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.mmap		= vfio_pci_core_mmap,
 	.request	= vfio_pci_core_request,
 	.match		= vfio_pci_core_match,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
 };
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
index eaea63e5294c58..5a046098d0bdf4 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -117,6 +117,9 @@ static const struct vfio_device_ops vfio_amba_ops = {
 	.read		= vfio_platform_read,
 	.write		= vfio_platform_write,
 	.mmap		= vfio_platform_mmap,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
 };
 
 static const struct amba_id pl330_ids[] = {
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 82cedcebfd9022..b87c3b70878341 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -106,6 +106,9 @@ static const struct vfio_device_ops vfio_platform_ops = {
 	.read		= vfio_platform_read,
 	.write		= vfio_platform_write,
 	.mmap		= vfio_platform_mmap,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
 };
 
 static struct platform_driver vfio_platform_driver = {
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index a9dd0615266cb9..9766f70a12c519 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -124,6 +124,21 @@ void vfio_device_container_unregister(struct vfio_device *device);
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
 
+#if IS_ENABLED(CONFIG_IOMMUFD)
+int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
+void vfio_iommufd_unbind(struct vfio_device *device);
+#else
+static inline int vfio_iommufd_bind(struct vfio_device *device,
+				    struct iommufd_ctx *ictx)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_iommufd_unbind(struct vfio_device *device)
+{
+}
+#endif
+
 #ifdef CONFIG_VFIO_NOIOMMU
 extern bool vfio_noiommu __read_mostly;
 #else
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f11157d056e6cc..a74c34232c034b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -525,6 +525,11 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
+	if (WARN_ON(device->ops->bind_iommufd &&
+		    (!device->ops->unbind_iommufd ||
+		     !device->ops->attach_ioas)))
+		return -EINVAL;
+
 	/*
 	 * If the driver doesn't specify a set then the device is added to a
 	 * singleton set just for itself.
@@ -794,6 +799,10 @@ static int vfio_device_first_open(struct vfio_device *device)
 		ret = vfio_group_use_container(device->group);
 		if (ret)
 			goto err_module_put;
+	} else if (device->group->iommufd) {
+		ret = vfio_iommufd_bind(device, device->group->iommufd);
+		if (ret)
+			goto err_module_put;
 	}
 
 	device->kvm = device->group->kvm;
@@ -811,6 +820,8 @@ static int vfio_device_first_open(struct vfio_device *device)
 	device->kvm = NULL;
 	if (device->group->container)
 		vfio_group_unuse_container(device->group);
+	else if (device->group->iommufd)
+		vfio_iommufd_unbind(device);
 err_module_put:
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
@@ -829,6 +840,8 @@ static void vfio_device_last_close(struct vfio_device *device)
 	device->kvm = NULL;
 	if (device->group->container)
 		vfio_group_unuse_container(device->group);
+	else if (device->group->iommufd)
+		vfio_iommufd_unbind(device);
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 }
@@ -1936,8 +1949,6 @@ static void __exit vfio_cleanup(void)
 module_init(vfio_init);
 module_exit(vfio_cleanup);
 
-MODULE_IMPORT_NS(IOMMUFD);
-MODULE_IMPORT_NS(IOMMUFD_VFIO);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e7cebeb875dd1a..a7fc4d747dc226 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -17,6 +17,8 @@
 #include <linux/iova_bitmap.h>
 
 struct kvm;
+struct iommufd_ctx;
+struct iommufd_device;
 
 /*
  * VFIO devices can be placed in a set, this allows all devices to share this
@@ -54,6 +56,10 @@ struct vfio_device {
 	struct completion comp;
 	struct list_head group_next;
 	struct list_head iommu_entry;
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	struct iommufd_device *iommufd_device;
+	bool iommufd_attached;
+#endif
 };
 
 /**
@@ -80,6 +86,10 @@ struct vfio_device_ops {
 	char	*name;
 	int	(*init)(struct vfio_device *vdev);
 	void	(*release)(struct vfio_device *vdev);
+	int	(*bind_iommufd)(struct vfio_device *vdev,
+				struct iommufd_ctx *ictx, u32 *out_device_id);
+	void	(*unbind_iommufd)(struct vfio_device *vdev);
+	int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
 	int	(*open_device)(struct vfio_device *vdev);
 	void	(*close_device)(struct vfio_device *vdev);
 	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
@@ -96,6 +106,21 @@ struct vfio_device_ops {
 				  void __user *arg, size_t argsz);
 };
 
+#if IS_ENABLED(CONFIG_IOMMUFD)
+int vfio_iommufd_physical_bind(struct vfio_device *vdev,
+			       struct iommufd_ctx *ictx, u32 *out_device_id);
+void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
+int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
+#else
+#define vfio_iommufd_physical_bind                                      \
+	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
+		  u32 *out_device_id)) NULL)
+#define vfio_iommufd_physical_unbind \
+	((void (*)(struct vfio_device *vdev)) NULL)
+#define vfio_iommufd_physical_attach_ioas \
+	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
+#endif
+
 /**
  * @migration_set_state: Optional callback to change the migration state for
  *         devices that support migration. It's mandatory for
-- 
2.38.1

