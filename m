Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE260563246
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbiGALIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236783AbiGALIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:08:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051D513D0D;
        Fri,  1 Jul 2022 04:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbySsJhoVYa/GOYzoq8JMcYExG7SqA+G8rHk3KHxweEckDzfFY43qxA+/mXgE2ytoocF1ABcvWe+S4cnp3Snl4nu60hVUZ0syvk4B2faIukb/+lfklWNtImTSimuQcSIr8qRYTakUOihzS6/mHEVYis9KmHD9RubG3bJzlxN6xkkWYuGy5UDFJOf6b5cMKfN4FgW7HvPOUjiiV+abjJFH3L0K0ZuKCVCFFurVUjNmGmljYUFyxKu/yuwqpI6MirOBQEnibePDb4+YTFUzOO3trEF7qaTrpDVxkCZEMcsV6ABNb8rJNr5kP+KWbrJc9lIOBna4UaRuv9fVK65JsGVIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tIOwQ7/Ik5bHfhQ1/UX0zekzI4be3QJ60AX0V2gCJ4=;
 b=jO5xBHCx59Vugag4nWn7E2qGysJzJrN/DOfAGVwMeC5HkMGyz2BAuuq4jk5IWmC11peyqYmB28DiAdbkf4St0LlH+HeHqkMBskTi/xfFLZQKDBU3tqOEkZ8QHwKecjvHArRg/WTUqVSsSVmADBiFyOfftVSaEyMgeu8T8p5PjrElz6d+MQk1PRiWFfPjdDa5I6BLNm1vG7w1ChR8T1x7FzImB88nrUJwpVH3s1ouaaXg7aIw3XVvfSrjKdIueFMQbZJUoCdCJV3r6B0zL12oXDPIKgN53kfE/pAmwZpiraaUVHpT91W2YlD861l4iIHXVX2Zk4OQYtRSw923g/9hsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tIOwQ7/Ik5bHfhQ1/UX0zekzI4be3QJ60AX0V2gCJ4=;
 b=gSi4V48BJMxHwGSUO1HZkbV/3Vlbj32fl58bRQukI64IhO2ZT1EFmCuXxSesfgB+mDUi9/Wk7M6mHBcuV8hhULyskNyFDvjrr12Yvc6Iav0DdsmYQeoo/+mkG7kknJqoKhb+6NvAdU1kqaD8ZPXshVrs5czHfuxYcgmRR4arUvGv3mrtuPudxtLBGIItY1fxh7nNWs/dmoZbOstqRVDvOrb41tNtFyNQTLaF81ZLO3Kmv9XWcfOMwVhvu6u1E11Cl+URoH8WV3kCSu9Ib49X1PQMUlDoVYVhTsBJXbcerRqsxf5VKP6A8Aow9lF558OL2aCUllA6sM/gCSL8+ArRtQ==
Received: from DM6PR02CA0119.namprd02.prod.outlook.com (2603:10b6:5:1b4::21)
 by MWHPR12MB1824.namprd12.prod.outlook.com (2603:10b6:300:113::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Fri, 1 Jul
 2022 11:08:41 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::90) by DM6PR02CA0119.outlook.office365.com
 (2603:10b6:5:1b4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17 via Frontend
 Transport; Fri, 1 Jul 2022 11:08:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.17 via Frontend Transport; Fri, 1 Jul 2022 11:08:40 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 1 Jul 2022 11:08:40 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 1 Jul 2022 04:08:39 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 04:08:34 -0700
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v4 3/6] vfio: Increment the runtime PM usage count during IOCTL call
Date:   Fri, 1 Jul 2022 16:38:11 +0530
Message-ID: <20220701110814.7310-4-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220701110814.7310-1-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9d343ed-8593-489d-b16e-08da5b520e1e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1824:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0TMRd/RSF/wyqGloh/OpMKKy/SAeHXFWTyUtfy0Ajk6Jkrq45gcka8/h08Tmg8wW8BqP/Htig8C92d83VK2pkC0X+aA9Q0612rKP5DPQXeBZaB7o3RxBFO3TQpcEx1ex7tRNVHV1qWDXeOEn89K0eu0lETeXCcaNwG9an/QhWZsxrUScXBz7CRfxbLWpVS2n3GPaM5OzMoW7kEAFgUI1uWDcwxJTjJfQFDEvEq239b3S0+2YMtGfT5PQ89zuTeWucQmNCOrVTKc5hLzvNWu0pfsPUEoZv50sSVO7xurWsKDIcwZlWczfW6+Jrz8xMVzgBfjjapTm4SnyC0WExuD9Bq+KeqKVkT/egUze60BPj5UTW+6i0PV0aX9F43CGu3rTpOsGVq1ms8R5BqEJmWaPwad6v1rJ8TsPmJ9QiS2QON3uUbLW93p/nSXj/GfWLttYLGKz6X3qs50H7uvXm1gZTvXlmvhLii/PoImsrgocfl6uogbNXDRZPjpid8/RG/QO+Rm/JKHB6M04naa9g4QPz7qG4lpw7Kv9i0vhTV1zXfXVq785Lv6sAOYp/q85SgG0x6wvKadctlG+ekBYjlovI30rra4MblG06ll29a19U+KTRpogsVDZj81knMeyh7+1srEIuxPeHZcZ881UNt9kWoSVv1fwOgEAkliV+sBd6vs6OIWklgQLONnQdMj30s1N+fIA/YdJng7FKKXK2hnNFTCEHgA8jvHsuJSl59hOXEJCfZWuHv8Cr2TU1hv88ZoXpk8OhWwwZ2DT9kq20i2PSE8sZust0xP0CXYudEX+lvdap7fsntaPBVOILQSlmPciAaA3u53iepCZYNZxey4WWd7anhYNnvvE3gnkCN+s9w=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966006)(40470700004)(36840700001)(336012)(426003)(36860700001)(316002)(5660300002)(8936002)(83380400001)(7416002)(4326008)(47076005)(70586007)(356005)(40480700001)(40460700003)(8676002)(86362001)(41300700001)(7696005)(70206006)(36756003)(107886003)(1076003)(81166007)(26005)(82740400003)(82310400005)(186003)(6666004)(54906003)(2616005)(2906002)(110136005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 11:08:40.7591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d343ed-8593-489d-b16e-08da5b520e1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1824
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio-pci based driver will have runtime power management
support where the user can put the device into the low power state
and then PCI devices can go into the D3cold state. If the device is
in the low power state and the user issues any IOCTL, then the
device should be moved out of the low power state first. Once
the IOCTL is serviced, then it can go into the low power state again.
The runtime PM framework manages this with help of usage count.

One option was to add the runtime PM related API's inside vfio-pci
driver but some IOCTL (like VFIO_DEVICE_FEATURE) can follow a
different path and more IOCTL can be added in the future. Also, the
runtime PM will be added for vfio-pci based drivers variant currently,
but the other VFIO based drivers can use the same in the
future. So, this patch adds the runtime calls runtime-related API in
the top-level IOCTL function itself.

For the VFIO drivers which do not have runtime power management
support currently, the runtime PM API's won't be invoked. Only for
vfio-pci based drivers currently, the runtime PM API's will be invoked
to increment and decrement the usage count.

Taking this usage count incremented while servicing IOCTL will make
sure that the user won't put the device into low power state when any
other IOCTL is being serviced in parallel. Let's consider the
following scenario:

 1. Some other IOCTL is called.
 2. The user has opened another device instance and called the power
    management IOCTL for the low power entry.
 3. The power management IOCTL moves the device into the low power state.
 4. The other IOCTL finishes.

If we don't keep the usage count incremented then the device
access will happen between step 3 and 4 while the device has already
gone into the low power state.

The runtime PM API's should not be invoked for
VFIO_DEVICE_FEATURE_POWER_MANAGEMENT since this IOCTL itself performs
the runtime power management entry and exit for the VFIO device.

The pm_runtime_resume_and_get() will be the first call so its error
should not be propagated to user space directly. For example, if
pm_runtime_resume_and_get() can return -EINVAL for the cases where the
user has passed the correct argument. So the
pm_runtime_resume_and_get() errors have been masked behind -EIO.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/vfio.c | 82 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 74 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 61e71c1154be..61a8d9f7629a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -32,6 +32,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include <linux/pm_runtime.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -1333,6 +1334,39 @@ static const struct file_operations vfio_group_fops = {
 	.release	= vfio_group_fops_release,
 };
 
+/*
+ * Wrapper around pm_runtime_resume_and_get().
+ * Return error code on failure or 0 on success.
+ */
+static inline int vfio_device_pm_runtime_get(struct vfio_device *device)
+{
+	struct device *dev = device->dev;
+
+	if (dev->driver && dev->driver->pm) {
+		int ret;
+
+		ret = pm_runtime_resume_and_get(dev);
+		if (ret < 0) {
+			dev_info_ratelimited(dev,
+				"vfio: runtime resume failed %d\n", ret);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Wrapper around pm_runtime_put().
+ */
+static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
+{
+	struct device *dev = device->dev;
+
+	if (dev->driver && dev->driver->pm)
+		pm_runtime_put(dev);
+}
+
 /*
  * VFIO Device fd
  */
@@ -1607,6 +1641,8 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 {
 	size_t minsz = offsetofend(struct vfio_device_feature, flags);
 	struct vfio_device_feature feature;
+	int ret = 0;
+	u16 feature_cmd;
 
 	if (copy_from_user(&feature, arg, minsz))
 		return -EFAULT;
@@ -1626,28 +1662,51 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 	    (feature.flags & VFIO_DEVICE_FEATURE_GET))
 		return -EINVAL;
 
-	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
+	feature_cmd = feature.flags & VFIO_DEVICE_FEATURE_MASK;
+
+	/*
+	 * The VFIO_DEVICE_FEATURE_POWER_MANAGEMENT itself performs the runtime
+	 * power management entry and exit for the VFIO device, so the runtime
+	 * PM API's should not be called for this feature.
+	 */
+	if (feature_cmd != VFIO_DEVICE_FEATURE_POWER_MANAGEMENT) {
+		ret = vfio_device_pm_runtime_get(device);
+		if (ret)
+			return ret;
+	}
+
+	switch (feature_cmd) {
 	case VFIO_DEVICE_FEATURE_MIGRATION:
-		return vfio_ioctl_device_feature_migration(
+		ret = vfio_ioctl_device_feature_migration(
 			device, feature.flags, arg->data,
 			feature.argsz - minsz);
+		break;
 	case VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE:
-		return vfio_ioctl_device_feature_mig_device_state(
+		ret = vfio_ioctl_device_feature_mig_device_state(
 			device, feature.flags, arg->data,
 			feature.argsz - minsz);
+		break;
 	default:
 		if (unlikely(!device->ops->device_feature))
-			return -EINVAL;
-		return device->ops->device_feature(device, feature.flags,
-						   arg->data,
-						   feature.argsz - minsz);
+			ret = -EINVAL;
+		else
+			ret = device->ops->device_feature(
+				device, feature.flags, arg->data,
+				feature.argsz - minsz);
+		break;
 	}
+
+	if (feature_cmd != VFIO_DEVICE_FEATURE_POWER_MANAGEMENT)
+		vfio_device_pm_runtime_put(device);
+
+	return ret;
 }
 
 static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
 	struct vfio_device *device = filep->private_data;
+	int ret;
 
 	switch (cmd) {
 	case VFIO_DEVICE_FEATURE:
@@ -1655,7 +1714,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	default:
 		if (unlikely(!device->ops->ioctl))
 			return -EINVAL;
-		return device->ops->ioctl(device, cmd, arg);
+
+		ret = vfio_device_pm_runtime_get(device);
+		if (ret)
+			return ret;
+
+		ret = device->ops->ioctl(device, cmd, arg);
+		vfio_device_pm_runtime_put(device);
+		return ret;
 	}
 }
 
-- 
2.17.1

