Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBE17A97AF
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjIUR06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjIUR0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:26:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61E3E79
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:01:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvNbD6ifnX1MS323COsH2yopHxL2g8uPfu7twWdVuGH0qpdjIU/FL5TxJhBw1IEn71PFFsL3vmxwJrfj0nHKmKawM6PeUoUJbnq13ZEclixj7BhAiHBXx1/fGE68Gk3cHEHGAkHD8sWkkBMCDsucNUOOdkVNItDG4TI+WrCc948B4hp/kpBKtn8+jI5YLjt45tq2ztIyzJMgRbxUrsEvUuf3gHz2qLBR+/k2cRhNtthiWMMUx2yru1PzXlvVV4Zj7brvaQqRgo88HHu6yp+BCF7tZnt730Q90O53gevm2N3Gmb31Vnm6Cwq9PYaODWWzDzBi5dkt+CCvC5W39o8hAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EB2UvYTxW9xlyOHlPqx5ftuoz9voE97yJ7MC6k+z6uI=;
 b=a7tHbKrSEtS2lvf7kkS+HOVrB3E2m2mHeF49tsSHl19wwu3SVt46Qr9GeIa12yvRMQYKlhtZSmyWRGDgXKOClRqSnd4pdtM00U5pNd+oG3suZ7EO/oGmk1L+yWAtr7C1oZRFLJhZm36MntCw6JcLYxViPg4i8CYLfXffWwKioiL9gQCAwQci19mHK61cWAqIit6YqkmzzyEdkQHbnrPvy3GJBnQmYCAfEGOQrcIz4TaxfKnB6t0FEVpfQiDQKpon5LOfmLXeVpuN/dMtYs7VzW8Lfvoc3WwWCgwbt1GG0SMPBezYS4VfDgJq5QFni0UU1rF7vnkmjNj1c7jXHvK6Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EB2UvYTxW9xlyOHlPqx5ftuoz9voE97yJ7MC6k+z6uI=;
 b=lhdPQ3XHUPnTeE6UmI1sEpFYmxQRYb/vO6XnHvj/+k8N6jxVupt6sXbLukHRf0G7ul7FKabm58wGoU0eANzIn7I1qcYPHmnDlY3MAeQattGJlckzCwGtDUZdhu+zfixCDdiPeZxWWiqlw53eQ7K+y1jE2qxs7aDQA2eOiDJNlQ/L0yr+MfCDpBN9HS2FZcDIOqZCuIesVvAg7DTnjJsvCk+JYwlintW5r4/Wb6bGICArONltFq1dcl05p3RZRbumRHisk3EDEHs9HdJD4auRoi3GTnNgabs5SkSSyWyeqNX3oMCV20MCIBkgqnFFYzy7YHp9BBx4BWaNqJ3zTngIeQ==
Received: from MW2PR16CA0061.namprd16.prod.outlook.com (2603:10b6:907:1::38)
 by PH7PR12MB5782.namprd12.prod.outlook.com (2603:10b6:510:1d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 21 Sep
 2023 12:42:17 +0000
Received: from MWH0EPF000989EB.namprd02.prod.outlook.com
 (2603:10b6:907:1:cafe::19) by MW2PR16CA0061.outlook.office365.com
 (2603:10b6:907:1::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.30 via Frontend
 Transport; Thu, 21 Sep 2023 12:42:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000989EB.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Thu, 21 Sep 2023 12:42:16 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:42:07 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:42:06 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 21 Sep
 2023 05:42:03 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over virtio devices
Date:   Thu, 21 Sep 2023 15:40:40 +0300
Message-ID: <20230921124040.145386-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230921124040.145386-1-yishaih@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EB:EE_|PH7PR12MB5782:EE_
X-MS-Office365-Filtering-Correlation-Id: 24cc4425-8fa0-4ff7-be0d-08dbbaa03052
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWNItZj+prBjw4OSMhMHflBUaoUbxhMKLn/92aXt//rzjiuUw+UZkvGvDcG8zsDXSt+gjT4oyODn8TqmtrgeMikhEzSTH9D4QA5DcC5+AfUZWx3EtWWXF6BoXMdaikuherc/2e1oTPCDf2EAHLGN4MQ69PNhgNOA7ewdUxgwenHJMJuDR7b91LRf7D5N+peJeWDnGTgvaq7lLTPZt++SQFRWVs0qt7XTKp9hco5bdvpF3Jrrp1xK23e8JQMheJVz3ao7nEc+6eIG1s3PvEC7dLNVtgYvNWaJpuK+YqKfMOp1wX9gvRNGNsSiGFHIkqdLav38xJLNbUwiZxs/L8vpwEgGe/ZJcNvDwXlTcaFTQ7V9L+yf+m/TjTql247cI6zRmRN2SpoOTVKUOIoX6/Eu7XS9jToo8KMi9fnZ1L92I41KskBCMUO3pH++4ti9v0ZPtd+MA6OMuEhEboqIbLnve0HV87l7oh/9nlsX5cx2rSNa9zWbZopBDjjveBzWHUXZlmYwP4WgBJg6mSAyVq2k/69RYqfbbQvoGa8E6L/67jyb6pnQjoVOm8U8/kbDpAvkQYa8X1x2sMQv/xDMhk4KjNZfT1asezT4zxybOFYtZVWFANxgJlNZU5aq0NgeBpq2in4ekFgjCVFCTIqc6WxmrIN4xNu7s3GlG4M71EqujPH9dVjYCnfs4UzR+OJ0aDItqIidvzJ5ZBiCAAboKkEbkQYIFbSQRx6tLlQ1Rmlq5DyBVt/AmdABHXOisOAbvv0cnnakdSJGx2Hxwx2bubAzs6swLfoPUHbAzhZ0gKMKCYeIclDl/bCyKBvX3f+yEASv
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(396003)(346002)(186009)(1800799009)(82310400011)(451199024)(36840700001)(40470700004)(46966006)(41300700001)(26005)(47076005)(8676002)(4326008)(70586007)(54906003)(110136005)(70206006)(30864003)(7636003)(356005)(82740400003)(5660300002)(6636002)(36860700001)(8936002)(316002)(336012)(2906002)(426003)(40460700003)(86362001)(966005)(6666004)(478600001)(36756003)(40480700001)(83380400001)(2616005)(7696005)(107886003)(1076003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 12:42:16.9913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24cc4425-8fa0-4ff7-be0d-08dbbaa03052
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989EB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5782
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a vfio driver over virtio devices to support the legacy
interface functionality for VFs.

Background, from the virtio spec [1].
--------------------------------------------------------------------
In some systems, there is a need to support a virtio legacy driver with
a device that does not directly support the legacy interface. In such
scenarios, a group owner device can provide the legacy interface
functionality for the group member devices. The driver of the owner
device can then access the legacy interface of a member device on behalf
of the legacy member device driver.

For example, with the SR-IOV group type, group members (VFs) can not
present the legacy interface in an I/O BAR in BAR0 as expected by the
legacy pci driver. If the legacy driver is running inside a virtual
machine, the hypervisor executing the virtual machine can present a
virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
legacy driver accesses to this I/O BAR and forwards them to the group
owner device (PF) using group administration commands.
--------------------------------------------------------------------

Specifically, this driver adds support for a virtio-net VF to be exposed
as a transitional device to a guest driver and allows the legacy IO BAR
functionality on top.

This allows a VM which uses a legacy virtio-net driver in the guest to
work transparently over a VF which its driver in the host is that new
driver.

The driver can be extended easily to support some other types of virtio
devices (e.g virtio-blk), by adding in a few places the specific type
properties as was done for virtio-net.

For now, only the virtio-net use case was tested and as such we introduce
the support only for such a device.

Practically,
Upon probing a VF for a virtio-net device, in case its PF supports
legacy access over the virtio admin commands and the VF doesn't have BAR
0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
transitional device with I/O BAR in BAR 0.

The existence of the simulated I/O bar is reported later on by
overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
exposes itself as a transitional device by overwriting some properties
upon reading its config space.

Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
guest may use it via read/write calls according to the virtio
specification.

Any read/write towards the control parts of the BAR will be captured by
the new driver and will be translated into admin commands towards the
device.

Any data path read/write access (i.e. virtio driver notifications) will
be forwarded to the physical BAR which its properties were supplied by
the command VIRTIO_PCI_QUEUE_NOTIFY upon the probing/init flow.

With that code in place a legacy driver in the guest has the look and
feel as if having a transitional device with legacy support for both its
control and data path flows.

[1]
https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 MAINTAINERS                      |   6 +
 drivers/vfio/pci/Kconfig         |   2 +
 drivers/vfio/pci/Makefile        |   2 +
 drivers/vfio/pci/virtio/Kconfig  |  15 +
 drivers/vfio/pci/virtio/Makefile |   4 +
 drivers/vfio/pci/virtio/cmd.c    |   4 +-
 drivers/vfio/pci/virtio/cmd.h    |   8 +
 drivers/vfio/pci/virtio/main.c   | 546 +++++++++++++++++++++++++++++++
 8 files changed, 585 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index bf0f54c24f81..5098418c8389 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22624,6 +22624,12 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/pci/mlx5/
 
+VFIO VIRTIO PCI DRIVER
+M:	Yishai Hadas <yishaih@nvidia.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/pci/virtio
+
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	Yishai Hadas <yishaih@nvidia.com>
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 8125e5f37832..18c397df566d 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
 
 source "drivers/vfio/pci/pds/Kconfig"
 
+source "drivers/vfio/pci/virtio/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 45167be462d8..046139a4eca5 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
 
 obj-$(CONFIG_PDS_VFIO_PCI) += pds/
+
+obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
new file mode 100644
index 000000000000..89eddce8b1bd
--- /dev/null
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config VIRTIO_VFIO_PCI
+        tristate "VFIO support for VIRTIO PCI devices"
+        depends on VIRTIO_PCI
+        select VFIO_PCI_CORE
+        help
+          This provides support for exposing VIRTIO VF devices using the VFIO
+          framework that can work with a legacy virtio driver in the guest.
+          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
+          not indicate I/O Space.
+          As of that this driver emulated I/O BAR in software to let a VF be
+          seen as a transitional device in the guest and let it work with
+          a legacy driver.
+
+          If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
new file mode 100644
index 000000000000..584372648a03
--- /dev/null
+++ b/drivers/vfio/pci/virtio/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
+virtio-vfio-pci-y := main.o cmd.o
+
diff --git a/drivers/vfio/pci/virtio/cmd.c b/drivers/vfio/pci/virtio/cmd.c
index f068239cdbb0..aea9d25fbf1d 100644
--- a/drivers/vfio/pci/virtio/cmd.c
+++ b/drivers/vfio/pci/virtio/cmd.c
@@ -44,7 +44,7 @@ int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
 {
 	struct virtio_device *virtio_dev =
 		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
-	struct virtio_admin_cmd_data_lr_write *in;
+	struct virtio_admin_cmd_legacy_wr_data *in;
 	struct scatterlist in_sg;
 	struct virtio_admin_cmd cmd = {};
 	int ret;
@@ -74,7 +74,7 @@ int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
 {
 	struct virtio_device *virtio_dev =
 		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
-	struct virtio_admin_cmd_data_lr_read *in;
+	struct virtio_admin_cmd_legacy_rd_data *in;
 	struct scatterlist in_sg, out_sg;
 	struct virtio_admin_cmd cmd = {};
 	int ret;
diff --git a/drivers/vfio/pci/virtio/cmd.h b/drivers/vfio/pci/virtio/cmd.h
index c2a3645f4b90..347b1dc85570 100644
--- a/drivers/vfio/pci/virtio/cmd.h
+++ b/drivers/vfio/pci/virtio/cmd.h
@@ -13,7 +13,15 @@
 
 struct virtiovf_pci_core_device {
 	struct vfio_pci_core_device core_device;
+	u8 bar0_virtual_buf_size;
+	u8 *bar0_virtual_buf;
+	/* synchronize access to the virtual buf */
+	struct mutex bar_mutex;
 	int vf_id;
+	void __iomem *notify_addr;
+	u32 notify_offset;
+	u8 notify_bar;
+	u8 pci_cmd_io :1;
 };
 
 int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
new file mode 100644
index 000000000000..2486991c49f3
--- /dev/null
+++ b/drivers/vfio/pci/virtio/main.c
@@ -0,0 +1,546 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/virtio_pci.h>
+#include <linux/virtio_net.h>
+#include <linux/virtio_pci_modern.h>
+
+#include "cmd.h"
+
+#define VIRTIO_LEGACY_IO_BAR_HEADER_LEN 20
+#define VIRTIO_LEGACY_IO_BAR_MSIX_HEADER_LEN 4
+
+static int virtiovf_issue_lr_cmd(struct virtiovf_pci_core_device *virtvdev,
+				 loff_t pos, char __user *buf,
+				 size_t count, bool read)
+{
+	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
+	u16 opcode;
+	int ret;
+
+	mutex_lock(&virtvdev->bar_mutex);
+	if (read) {
+		opcode = (pos < VIRTIO_PCI_CONFIG_OFF(true)) ?
+			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ :
+			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ;
+		ret = virtiovf_cmd_lr_read(virtvdev, opcode, pos,
+					   count, bar0_buf + pos);
+		if (ret)
+			goto out;
+		if (copy_to_user(buf, bar0_buf + pos, count))
+			ret = -EFAULT;
+		goto out;
+	}
+
+	if (copy_from_user(bar0_buf + pos, buf, count)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	opcode = (pos < VIRTIO_PCI_CONFIG_OFF(true)) ?
+			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE :
+			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE;
+	ret = virtiovf_cmd_lr_write(virtvdev, opcode, pos, count,
+				    bar0_buf + pos);
+out:
+	mutex_unlock(&virtvdev->bar_mutex);
+	return ret;
+}
+
+static int
+translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
+			    loff_t pos, char __user *buf,
+			    size_t count, bool read)
+{
+	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
+	u16 queue_notify;
+	int ret;
+
+	if (pos + count > virtvdev->bar0_virtual_buf_size)
+		return -EINVAL;
+
+	switch (pos) {
+	case VIRTIO_PCI_QUEUE_NOTIFY:
+		if (count != sizeof(queue_notify))
+			return -EINVAL;
+		if (read) {
+			ret = vfio_pci_ioread16(core_device, true, &queue_notify,
+						virtvdev->notify_addr);
+			if (ret)
+				return ret;
+			if (copy_to_user(buf, &queue_notify,
+					 sizeof(queue_notify)))
+				return -EFAULT;
+			break;
+		}
+
+		if (copy_from_user(&queue_notify, buf, count))
+			return -EFAULT;
+
+		ret = vfio_pci_iowrite16(core_device, true, queue_notify,
+					 virtvdev->notify_addr);
+		break;
+	default:
+		ret = virtiovf_issue_lr_cmd(virtvdev, pos, buf, count, read);
+	}
+
+	return ret ? ret : count;
+}
+
+static bool range_contains_range(loff_t range1_start, size_t count1,
+				 loff_t range2_start, size_t count2,
+				 loff_t *start_offset)
+{
+	if (range1_start <= range2_start &&
+	    range1_start + count1 >= range2_start + count2) {
+		*start_offset = range2_start - range1_start;
+		return true;
+	}
+	return false;
+}
+
+static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
+					char __user *buf, size_t count,
+					loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	loff_t copy_offset;
+	__le32 val32;
+	__le16 val16;
+	u8 val8;
+	int ret;
+
+	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
+	if (ret < 0)
+		return ret;
+
+	if (range_contains_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
+				 &copy_offset)) {
+		val16 = cpu_to_le16(0x1000);
+		if (copy_to_user(buf + copy_offset, &val16, sizeof(val16)))
+			return -EFAULT;
+	}
+
+	if (virtvdev->pci_cmd_io &&
+	    range_contains_range(pos, count, PCI_COMMAND, sizeof(val16),
+				 &copy_offset)) {
+		if (copy_from_user(&val16, buf, sizeof(val16)))
+			return -EFAULT;
+		val16 |= cpu_to_le16(PCI_COMMAND_IO);
+		if (copy_to_user(buf + copy_offset, &val16, sizeof(val16)))
+			return -EFAULT;
+	}
+
+	if (range_contains_range(pos, count, PCI_REVISION_ID, sizeof(val8),
+				 &copy_offset)) {
+		/* Transional needs to have revision 0 */
+		val8 = 0;
+		if (copy_to_user(buf + copy_offset, &val8, sizeof(val8)))
+			return -EFAULT;
+	}
+
+	if (range_contains_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
+				 &copy_offset)) {
+		val32 = cpu_to_le32(PCI_BASE_ADDRESS_SPACE_IO);
+		if (copy_to_user(buf + copy_offset, &val32, sizeof(val32)))
+			return -EFAULT;
+	}
+
+	if (range_contains_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
+				 &copy_offset)) {
+		/* Transitional devices use the PCI subsystem device id as
+		 * virtio device id, same as legacy driver always did.
+		 */
+		val16 = cpu_to_le16(VIRTIO_ID_NET);
+		if (copy_to_user(buf + copy_offset, &val16, sizeof(val16)))
+			return -EFAULT;
+	}
+
+	return count;
+}
+
+static ssize_t
+virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
+		       size_t count, loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct pci_dev *pdev = virtvdev->core_device.pdev;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret;
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
+
+	if (index != VFIO_PCI_BAR0_REGION_INDEX)
+		return vfio_pci_core_read(core_vdev, buf, count, ppos);
+
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret) {
+		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
+				     ret);
+		return -EIO;
+	}
+
+	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
+	pm_runtime_put(&pdev->dev);
+	return ret;
+}
+
+static ssize_t
+virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct pci_dev *pdev = virtvdev->core_device.pdev;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret;
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
+		loff_t copy_offset;
+		u16 cmd;
+
+		if (range_contains_range(pos, count, PCI_COMMAND, sizeof(cmd),
+					 &copy_offset)) {
+			if (copy_from_user(&cmd, buf + copy_offset, sizeof(cmd)))
+				return -EFAULT;
+			virtvdev->pci_cmd_io = (cmd & PCI_COMMAND_IO);
+		}
+	}
+
+	if (index != VFIO_PCI_BAR0_REGION_INDEX)
+		return vfio_pci_core_write(core_vdev, buf, count, ppos);
+
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret) {
+		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
+		return -EIO;
+	}
+
+	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
+	pm_runtime_put(&pdev->dev);
+	return ret;
+}
+
+static int
+virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
+				   unsigned int cmd, unsigned long arg)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+	void __user *uarg = (void __user *)arg;
+	struct vfio_region_info info = {};
+
+	if (copy_from_user(&info, uarg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	switch (info.index) {
+	case VFIO_PCI_BAR0_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = virtvdev->bar0_virtual_buf_size;
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+static long
+virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+			     unsigned long arg)
+{
+	switch (cmd) {
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+static int
+virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
+{
+	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
+	int ret;
+
+	/* Setup the BAR where the 'notify' exists to be used by vfio as well
+	 * This will let us mmap it only once and use it when needed.
+	 */
+	ret = vfio_pci_core_setup_barmap(core_device,
+					 virtvdev->notify_bar);
+	if (ret)
+		return ret;
+
+	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
+			virtvdev->notify_offset;
+	return 0;
+}
+
+static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	if (virtvdev->bar0_virtual_buf) {
+		/* upon close_device() the vfio_pci_core_disable() is called
+		 * and will close all the previous mmaps, so it seems that the
+		 * valid life cycle for the 'notify' addr is per open/close.
+		 */
+		ret = virtiovf_set_notify_addr(virtvdev);
+		if (ret) {
+			vfio_pci_core_disable(vdev);
+			return ret;
+		}
+	}
+
+	vfio_pci_core_finish_enable(vdev);
+	return 0;
+}
+
+static void virtiovf_pci_close_device(struct vfio_device *core_vdev)
+{
+	vfio_pci_core_close_device(core_vdev);
+}
+
+static int virtiovf_get_device_config_size(unsigned short device)
+{
+	switch (device) {
+	case 0x1041:
+		/* network card */
+		return offsetofend(struct virtio_net_config, status);
+	default:
+		return 0;
+	}
+}
+
+static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
+{
+	u64 offset;
+	int ret;
+	u8 bar;
+
+	ret = virtiovf_cmd_lq_read_notify(virtvdev,
+				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
+				&bar, &offset);
+	if (ret)
+		return ret;
+
+	virtvdev->notify_bar = bar;
+	virtvdev->notify_offset = offset;
+	return 0;
+}
+
+static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct pci_dev *pdev;
+	int ret;
+
+	ret = vfio_pci_core_init_dev(core_vdev);
+	if (ret)
+		return ret;
+
+	pdev = virtvdev->core_device.pdev;
+	virtvdev->vf_id = pci_iov_vf_id(pdev);
+	if (virtvdev->vf_id < 0)
+		return -EINVAL;
+
+	ret = virtiovf_read_notify_info(virtvdev);
+	if (ret)
+		return ret;
+
+	virtvdev->bar0_virtual_buf_size = VIRTIO_LEGACY_IO_BAR_HEADER_LEN +
+		VIRTIO_LEGACY_IO_BAR_MSIX_HEADER_LEN +
+		virtiovf_get_device_config_size(pdev->device);
+	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
+					     GFP_KERNEL);
+	if (!virtvdev->bar0_virtual_buf)
+		return -ENOMEM;
+	mutex_init(&virtvdev->bar_mutex);
+	return 0;
+}
+
+static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+
+	kfree(virtvdev->bar0_virtual_buf);
+	vfio_pci_core_release_dev(core_vdev);
+}
+
+static const struct vfio_device_ops virtiovf_acc_vfio_pci_tran_ops = {
+	.name = "virtio-transitional-vfio-pci",
+	.init = virtiovf_pci_init_device,
+	.release = virtiovf_pci_core_release_dev,
+	.open_device = virtiovf_pci_open_device,
+	.close_device = virtiovf_pci_close_device,
+	.ioctl = virtiovf_vfio_pci_core_ioctl,
+	.read = virtiovf_pci_core_read,
+	.write = virtiovf_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+};
+
+static const struct vfio_device_ops virtiovf_acc_vfio_pci_ops = {
+	.name = "virtio-acc-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
+	.open_device = virtiovf_pci_open_device,
+	.close_device = virtiovf_pci_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+};
+
+static bool virtiovf_bar0_exists(struct pci_dev *pdev)
+{
+	struct resource *res = pdev->resource;
+
+	return res->flags ? true : false;
+}
+
+#define VIRTIOVF_USE_ADMIN_CMD_BITMAP \
+	(BIT_ULL(VIRTIO_ADMIN_CMD_LIST_QUERY) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LIST_USE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
+
+static bool virtiovf_support_legacy_access(struct pci_dev *pdev)
+{
+	int buf_size = DIV_ROUND_UP(VIRTIO_ADMIN_MAX_CMD_OPCODE, 64) * 8;
+	u8 *buf;
+	int ret;
+
+	/* Only virtio-net is supported/tested so far */
+	if (pdev->device != 0x1041)
+		return false;
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return false;
+
+	ret = virtiovf_cmd_list_query(pdev, buf, buf_size);
+	if (ret)
+		goto end;
+
+	if ((le64_to_cpup((__le64 *)buf) & VIRTIOVF_USE_ADMIN_CMD_BITMAP) !=
+		VIRTIOVF_USE_ADMIN_CMD_BITMAP) {
+		ret = -EOPNOTSUPP;
+		goto end;
+	}
+
+	/* confirm the used commands */
+	memset(buf, 0, buf_size);
+	*(__le64 *)buf = cpu_to_le64(VIRTIOVF_USE_ADMIN_CMD_BITMAP);
+	ret = virtiovf_cmd_list_use(pdev, buf, buf_size);
+
+end:
+	kfree(buf);
+	return ret ? false : true;
+}
+
+static int virtiovf_pci_probe(struct pci_dev *pdev,
+			      const struct pci_device_id *id)
+{
+	const struct vfio_device_ops *ops = &virtiovf_acc_vfio_pci_ops;
+	struct virtiovf_pci_core_device *virtvdev;
+	int ret;
+
+	if (pdev->is_virtfn && virtiovf_support_legacy_access(pdev) &&
+	    !virtiovf_bar0_exists(pdev) && pdev->msix_cap)
+		ops = &virtiovf_acc_vfio_pci_tran_ops;
+
+	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
+				     &pdev->dev, ops);
+	if (IS_ERR(virtvdev))
+		return PTR_ERR(virtvdev);
+
+	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
+	ret = vfio_pci_core_register_device(&virtvdev->core_device);
+	if (ret)
+		goto out;
+	return 0;
+out:
+	vfio_put_device(&virtvdev->core_device.vdev);
+	return ret;
+}
+
+static void virtiovf_pci_remove(struct pci_dev *pdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(&virtvdev->core_device);
+	vfio_put_device(&virtvdev->core_device.vdev);
+}
+
+static const struct pci_device_id virtiovf_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
+
+static struct pci_driver virtiovf_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = virtiovf_pci_table,
+	.probe = virtiovf_pci_probe,
+	.remove = virtiovf_pci_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(virtiovf_pci_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
+MODULE_DESCRIPTION(
+	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO device family");
-- 
2.27.0

