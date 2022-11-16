Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764D362CC3E
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238868AbiKPVH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239220AbiKPVGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF501F2C3
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U360alu32Nj5DZDsMsgktX9JqDHFQsyRZjOR+VA2ijeZ3EfzpPGBzr7U95VddVulVTUE5MYfFe/ZsOb/ILncTaPjSycO7MFhAxVG0JQ+9Nbs5AcI+K0cKDdlI31psCTtzV9Sf4uaDZTpsTZRo9SGgU+OAaCSFIXCV+zHaixxLAzKAnyGjfgBb2RYlSILC/aaqxhylB8ywGa7yXCbpLC9//C61szC1KfrU5CAOgeSVj2SRZX9OnSrYm23r0Jqmaa8gjglgXIg3MmUABdQj/nAWB4FI9T41fmVSj49b9XrLyMIF9nJlfCqp0yYdQE02xOn+80xIfbER41Ffvef22RiZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fwfZJ1XbcrtHYJsFCimOIXZRAfdMKXpTL4comPD8B3o=;
 b=eleMdmo/UX6AARAI5qxRILVE5NIo7sCS1SENRQlIo8KddXBxU5HJIPSA4XSrZ4cCuwP9vCQPRgwMlLDJgVKDZWXFNr4lhmadboJ3z6e3Y/Dqqmd3yv80r7bNOs/BeInLcuwp3KzXghtCiLjAVuColGk7+tzvHHf1q+SxEHfp+TiDv2sWdUoiyt2elQ+fHms6Ic9O9fokbB7ect2iqr2cLLrGGbL1o4nYoyKId+4InKAk1igBOKLfc9ucCXPXNiEAGeXmd1NLVnbfW8LkGdkIKgD1ikRDgJ/pSKt4DC5IV0Gd9IHOG/Kfy58jB03QgvGO94knzYz9IjdfhdQTPNhgJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwfZJ1XbcrtHYJsFCimOIXZRAfdMKXpTL4comPD8B3o=;
 b=kvl0OJOYWH2nIz3Em51DsNlq8V4B5AZoFjX3FOr7NNVeksivcDIn4bQi5QKSjKvTVQGrNi+WKE641hmbq15ojBUHKfj9IQKp0OFKGsdGzdQKouB2szDtGDxIwrsjM3UNS6+ZFEHqc2po1wlBgcDTiep30ODmB5YMiIciKTrx81u0p/fPiAYO8iXyklaX+O4VdJQZ+SMszyxmn2mWuuTM6M6iE7NPhbAX7TdvakqB5qgR94MwafQM2pkkcj4jKx9/WBTKz92gfBUmWtcwGJCP1qxnLGM97KIJwetHmJkbYuYGj2b2yduUrS2OR3p5SJV//EERVW7bDfG9MOdjHGNTrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:43 +0000
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
Subject: [PATCH v3 07/11] vfio-iommufd: Support iommufd for physical VFIO devices
Date:   Wed, 16 Nov 2022 17:05:32 -0400
Message-Id: <7-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0007.namprd20.prod.outlook.com
 (2603:10b6:208:e8::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d71de2-d262-4637-cc45-08dac8165055
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SVZRxKB6orqQpccxsm3Z78DXCOZzn/aOyfmx7YrqQs68qXxDmAvrtPCjc4Y+9wZNKzykgDi2pULDB4Bd02cOIrpbXTciljALPJNnbA3j+QsAEUaNtWtnndj7vMbdLusvSbzU1kj/9ZGTyIk2/dcwglMf9Ja4l42cA4kqCQ/DAqDgWPJqWCvlPDnYz75pQM4ozC5nOgGsVEnN/pvR/1LDC6801AaovcvuYgMwpv2Z6/ot9XFxrSG5BM66jMFs0fnKSUmUProwSCBYYbv/CBdD8hh7PyGYZkgFZR1ar7XDJkIX3o/GLNLjlis1oq8mygTiFJ77PkT+ygn7EnunMtLWsI2JMcUc2T2QmJxOiYIwtFAoAfjlH5U01/Jqo4NSH4C+CPUsFq4CHzfwX7M3mFIeyK+MfzGASwI8/RfGDiSCxvYg6Nuk/3JZUDvCDgZ/8aAKAses94ruPDRsFV23abhfax8dymXVKiWrcVBULW/ZubuhvSgVvbOmRtjhVqaJ9d2TE9X0YGao5I3JndwBawIF7bKqA1jTTXZ0DOaYukrkubWsLdUjnH8XvAZVMmXeeOSz9Qo1moVuyHDh4lv0+Avntb76mauyABn3ic4Ueh3B4hXlGp8JoE+I+yb6NbdNo0aPDRYyccDeXgdCCsrJ03A9fLrVkmzSOrfHM7i6jPYteRW0wmlmbDPNzkW71wJOyBuVy0TAPas4arZ3gs4ZHIer9wjAMSnqohf95XU08xqMXhIHwaxMPEwAQPHRMQAVZNa8xp3RyXBTQ62+E8IwA5X3mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(30864003)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FrDFeBh5/aMXEzA23HhkGnwX7EcdYeEftf5gboF25EV5Q+8UiyCqvBX5KCH0?=
 =?us-ascii?Q?ii/KOcsSjTsqVpd2IZP5qXmaCh3YgolHEKPdVRFRed9txChtCIUK+Sb31Crw?=
 =?us-ascii?Q?RL59denmu8iKTgTv3hVHG9COpxOmYODgtLv9pVCEMJfnn0TS7p8RzjYCS00r?=
 =?us-ascii?Q?uSgP+Sorq5b9NkBypwW0AAjnLJ/uqEshDGEJZ7KiKfncSaJoOQe4niDj7+Ji?=
 =?us-ascii?Q?lpxBjZQ95xOfEQKjSppG6BST7/pcZ/DqaVF7iqWMphqCSN51nCQo5Dj4POq9?=
 =?us-ascii?Q?in9oP/YS2tATV0gyVR0NwwwvMSfXPBN1RpjlwX3afujMdKOYNbx6v37GtRaZ?=
 =?us-ascii?Q?ZKxw2SSNt//suF6lV6Oz7sUx9PrOVXjKSGRQp1sK6fiuee0A3QIzM5J/yWhe?=
 =?us-ascii?Q?Lg6amlEvfjp20KDryCPkVQwM9+8MtCjkV+OqzMBVnP/xSV6qDIgXylvQ6VEC?=
 =?us-ascii?Q?02HZSyr219Rr80947KlMCx3U0mwYnDBuyPe8U6iLKVdUha5v4+kmqf088WbN?=
 =?us-ascii?Q?LF/rHHZzexUWHvmNYS4ItYZxdfO4AnU9p76Vn5ITrF9sZ86CANMLZWV4ycpc?=
 =?us-ascii?Q?MkwcMfoamzgMo31ReHMkTF2oistzyB/AOuih4JAIdS0PbuI5yik9Tx0cHXVD?=
 =?us-ascii?Q?uPmeQllcPmTGVXy9Til1Wlkw8grWbJ73xp1IfCnk7VRVJ3MFNReHi+6Z1iUA?=
 =?us-ascii?Q?Wo8lByCIxq1YSPXAqmG4Yd2p6EvOa+m3toPdPZ0YB7wBcvgqysaFimQfXAJt?=
 =?us-ascii?Q?AbTXbAFlkGYkcu1mtd7Hp5amacaOygywnLJ09IddBMypshd2/THycCHDN07q?=
 =?us-ascii?Q?yrNvM2xJTwuBpZaNcLrMG2MJJPmxFDDRLyRzobkJNe9QSeuRoVhRyMS2Fc+d?=
 =?us-ascii?Q?WfBAZI8GWyKkCJMPr3uC6tzK0Fg0zB8VTnR7UsmmDIwxkd5i//84V0B70Qt8?=
 =?us-ascii?Q?rBiF4nCCZyFn6MM1IBAvc5+CH0j2HB5EGMmRjDEtQYqx200gpWIvp6NoiSxN?=
 =?us-ascii?Q?tbaYu5vIpvdIg7xxX93Szuel/TsMrIQ9fbpwTFeMxgOQSKgVgQ3zm/OMLn7s?=
 =?us-ascii?Q?YTq6ksu9NskzMUV6wH5KfxaxmJSbY4N97Uah9yQgrpK7NE7v6alxGd1Asj/d?=
 =?us-ascii?Q?ddH7cOLOlo00i8ecn0nJtBuw5RbtLeDjmS3uHkVpIA3rdHoYsF6hme7U61At?=
 =?us-ascii?Q?R3Nfij8lX+9wKfdTctrtB5yN7gM9N8w0PnQp39i0qS13OCqEaxrjHGyIgbrV?=
 =?us-ascii?Q?psvbAQUzpTPusg1MQK/QF/v75MU2DHC+Tky6TONwv+px7T8JugFOiXfCIR49?=
 =?us-ascii?Q?lhzTF+wmYK3tWKcx1xfNM9UVHR9Xpqv69WmNmpFBKl3JKEHrF13qMOJcU+sI?=
 =?us-ascii?Q?TJ6kV7hLeN215KUYxkf8IOQIHNTPuSpgCJsGZ1COJKW+2/UPP5UyE8jJRaie?=
 =?us-ascii?Q?t7Seoxp92OMP10lCRwPOrLl7UtzwajMMF39lJh96h8R5gqJAGf+MzzKLZenq?=
 =?us-ascii?Q?0eR3vGoHNWXwXgrXp1xbVhQTP4LPyvcC6BdI2nXwKSQQkfz2dZhRdOpY2b9f?=
 =?us-ascii?Q?KTT1cs/LOW/Xz1U1XT8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d71de2-d262-4637-cc45-08dac8165055
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:39.0700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pISwyJvU8PE/sKSC7sXMwtSUnpVneKLz06ChHaXNftGhKnIKat54+9WdZHGFKswJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
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
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Makefile                         |   1 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   3 +
 drivers/vfio/iommufd.c                        | 103 ++++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   6 +
 drivers/vfio/pci/mlx5/main.c                  |   3 +
 drivers/vfio/pci/vfio_pci.c                   |   3 +
 drivers/vfio/platform/vfio_amba.c             |   3 +
 drivers/vfio/platform/vfio_platform.c         |   3 +
 drivers/vfio/vfio.h                           |  15 +++
 drivers/vfio/vfio_main.c                      |  15 ++-
 include/linux/vfio.h                          |  25 +++++
 11 files changed, 178 insertions(+), 2 deletions(-)
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
index 00000000000000..6d6452072b8dba
--- /dev/null
+++ b/drivers/vfio/iommufd.c
@@ -0,0 +1,103 @@
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
+	unsigned int flags = 0;
+	int rc;
+
+	if (vfio_allow_unsafe_interrupts)
+		flags |= IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT;
+	rc = iommufd_device_attach(vdev->iommufd_device, pt_id, flags);
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
index 985e13d52989ca..809f2e8523968e 100644
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
index 8c124290ce9f0d..e76ffa3ecebfb0 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -528,6 +528,11 @@ static int __vfio_register_dev(struct vfio_device *device,
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
@@ -795,6 +800,10 @@ static int vfio_device_first_open(struct vfio_device *device)
 		ret = vfio_group_use_container(device->group);
 		if (ret)
 			goto err_module_put;
+	} else if (device->group->iommufd) {
+		ret = vfio_iommufd_bind(device, device->group->iommufd);
+		if (ret)
+			goto err_module_put;
 	}
 
 	device->kvm = device->group->kvm;
@@ -812,6 +821,8 @@ static int vfio_device_first_open(struct vfio_device *device)
 	device->kvm = NULL;
 	if (device->group->container)
 		vfio_group_unuse_container(device->group);
+	else if (device->group->iommufd)
+		vfio_iommufd_unbind(device);
 err_module_put:
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
@@ -830,6 +841,8 @@ static void vfio_device_last_close(struct vfio_device *device)
 	device->kvm = NULL;
 	if (device->group->container)
 		vfio_group_unuse_container(device->group);
+	else if (device->group->iommufd)
+		vfio_iommufd_unbind(device);
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 }
@@ -1937,8 +1950,6 @@ static void __exit vfio_cleanup(void)
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

