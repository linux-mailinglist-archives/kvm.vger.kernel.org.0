Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717E95A4B36
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 14:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiH2MML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 08:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiH2MLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 08:11:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E719352D;
        Mon, 29 Aug 2022 04:56:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCviOnbaemJzcRlO0nPYS0RLqDdUq09raK8zbpErb28uyP11jmdm9AX6yd0oheFZSA7V3hkSejeeCh/flNM7prAgdyiSBlO55HFO4IpWojX/ku4+Zgih/YrRAWIuKzk8TBar4QFpkGixk+oeNFETTo/T5qUycuqmwgY45T7BKzlkqdAWqz5jSiRuYcho1ab6JFb3wQzq9F3tqRsQKU0vqo4hXLDXrkscT9NoEuPTGo9ZTAIycSNdyuoLw2sQIg4R1aWsmQtiQT1a5ulH/vaFLXSwvzsqqjHI7yskpjwKXYwq22oWnLF5wX9ru5sk6GFPXY8InbiyGAfE52THMrF3qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5SFija1pmKheybbWx7egP4rc5NVxvIwNaiRI/uQyj8=;
 b=N97U2VDS7hCZRR1r6JNuuUSWLLeAYqTF66GCeLdpmSdlkJyL5HcJlDdp2kKPNGCDNWQgHAF3xS0mh2MYlyuxlK6ZSebOC4WVO9pQtdn3giHmCzb8Qp618D7pEfH55w2Z3112b6Ubfpx/J/uYak1bwNSiKGy8DtyLd+ZP7tre2Gc7MNA3nDNAWyCtmvUuQZYQydiw+JLXGcsWitQ+grSAO266/Jwq1yRvkkjjON+nPsyQIStpJA92JZUApXdVopnO2B62lrkZXlbEE5384qxSKZkqt7Rv4XzMs9Qhr7YZcy4AYgtY/9p1YOdEr5u2NPaoN20GpMqj4kOcXFHKIXtRfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5SFija1pmKheybbWx7egP4rc5NVxvIwNaiRI/uQyj8=;
 b=PrMSQJcmL/sr3WrVhrGKzqQtzrCEesDNQ4PtUN1dvh167Osq65cP7wt7lve7I7Cnl+cy2cVdWvue3ROa/i9/Y7LM65wCeAhSKnFXxPFi2YqZSjhf/9p3GluCrWEOX9QlIEw4Y2BLfnxBj2UADRVfqDiRzosrXSr1ydRFaIkR+bSnF3e9mDSD5wyGzCw33R63ADxasciZf1iLro4bkz0JPs1eDryIlnoSi5ydbbn1pyin6OGTmWyIyrcew9kdmEdiZdcvzlyyKuOAGblan7Ts1OrL9PHm0YrXm/kkzEFg+qeSa602U4CXsG5XF9waozx+ucmdC2qE3RSF4dC0s8Y56A==
Received: from MW4PR03CA0106.namprd03.prod.outlook.com (2603:10b6:303:b7::21)
 by DM5PR12MB1481.namprd12.prod.outlook.com (2603:10b6:4:e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.19; Mon, 29 Aug 2022 11:49:13 +0000
Received: from CO1NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::18) by MW4PR03CA0106.outlook.office365.com
 (2603:10b6:303:b7::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19 via Frontend
 Transport; Mon, 29 Aug 2022 11:49:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT112.mail.protection.outlook.com (10.13.174.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 11:49:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 29 Aug
 2022 11:49:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 04:49:11 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 29 Aug 2022 04:49:06 -0700
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
Subject: [PATCH v7 2/5] vfio: Increment the runtime PM usage count during IOCTL call
Date:   Mon, 29 Aug 2022 17:18:47 +0530
Message-ID: <20220829114850.4341-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220829114850.4341-1-abhsahu@nvidia.com>
References: <20220829114850.4341-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6f273b9-a010-4273-d1f4-08da89b47e2b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1481:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cjpb2VWc1ZAjQUDcIrs/67Z+4TYZI/R5A2WnxvAt7hq7+ieSrME4XfGdg6LgOJw9woG03xwwfNfJ9F+Ru5SXLZKNg36o9yxzViWr0T6R1oERYpclfF5u+/TLoMCNEB1JGwX3NNQZetpgPKOaMH8fc/e8V24ecL2ztpPVEQzQ7YZOVSLVNkQMjZFKc7/lQPKDgpvI0w6QtLJyaDx3tVG4X4ZhsQ++dgx/xRW+3j8sfNejtVflxQhayL3bf2BYqhCjchq5VGCQNpjUMEFhYFydkrjmalUYmjyr7Z4JGvlZlqiiRtmOEGjIOGeNsIhZ9KmnlJuaKbkowYXTcu7m5OJxNX5baXHy/c7EJ0G+VEXwb0q5VPnovIP1bCjOHLl+ANVb1B239LTKRdVs/V9wwWi/snthVEv3/DHCMKUFk34hLBwozk78EwFVQGWm2BUxElH9ed9kqlez9DISMVgygsf6AcW6HhTFqOZh4x4ZErqzu6+Vyt9tT1LeEBRHUGxStQSho91GnWx3xGkGHdnt+9vhFHZkEDGU6DhXTmPE0Wiwuz7tGN2SVAXyU7lMr39YzJ+6xVQYDWj8sZ9bDWQOZ78uJJZOKzZK8B70uXke6zMpw//VeBCdztLoaIBDgdx1lF5ZscYc+A90GsPXnPehT45cWtTTn712aHP6o1WBiHnjbdVj9Xm3JD+XXwKFX6Z4S68fbUAiINqs+VeKlcPuwH5llyAuMy82ZmoNfEH0QoHaXK0006juLwZdRBhwRbbFC6T7KY3Lq2RZJxolaIWGDh1dDhC7okY5RhpHRpygBMDT9vfD4BaRjuRpAIf50IEHUxAu
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(39860400002)(346002)(40470700004)(36840700001)(46966006)(107886003)(26005)(7696005)(41300700001)(478600001)(1076003)(6666004)(83380400001)(426003)(47076005)(186003)(336012)(2906002)(2616005)(8936002)(5660300002)(110136005)(40460700003)(40480700001)(82310400005)(316002)(54906003)(4326008)(8676002)(70586007)(70206006)(356005)(7416002)(81166007)(86362001)(82740400003)(36756003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:49:12.9172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f273b9-a010-4273-d1f4-08da89b47e2b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1481
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio-pci based drivers will have runtime power management
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
to increment and decrement the usage count. In the vfio-pci drivers also,
the variant drivers can opt-out by incrementing the usage count during
device-open. The pm_runtime_resume_and_get() checks the device
current status and will return early if the device is already in the
ACTIVE state.

Taking this usage count incremented while servicing IOCTL will make
sure that the user won't put the device into the low power state when any
other IOCTL is being serviced in parallel. Let's consider the
following scenario:

 1. Some other IOCTL is called.
 2. The user has opened another device instance and called the IOCTL for
    low power entry.
 3. The low power entry IOCTL moves the device into the low power state.
 4. The other IOCTL finishes.

If we don't keep the usage count incremented then the device
access will happen between step 3 and 4 while the device has already
gone into the low power state.

The pm_runtime_resume_and_get() will be the first call so its error
should not be propagated to user space directly. For example, if
pm_runtime_resume_and_get() can return -EINVAL for the cases where the
user has passed the correct argument. So the
pm_runtime_resume_and_get() errors have been masked behind -EIO.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/vfio_main.c | 52 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6f96e6d07a5e..ee189ff015a4 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -32,6 +32,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include <linux/pm_runtime.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -1348,6 +1349,39 @@ static const struct file_operations vfio_group_fops = {
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
+		if (ret) {
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
@@ -1668,15 +1702,27 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
 	struct vfio_device *device = filep->private_data;
+	int ret;
+
+	ret = vfio_device_pm_runtime_get(device);
+	if (ret)
+		return ret;
 
 	switch (cmd) {
 	case VFIO_DEVICE_FEATURE:
-		return vfio_ioctl_device_feature(device, (void __user *)arg);
+		ret = vfio_ioctl_device_feature(device, (void __user *)arg);
+		break;
+
 	default:
 		if (unlikely(!device->ops->ioctl))
-			return -EINVAL;
-		return device->ops->ioctl(device, cmd, arg);
+			ret = -EINVAL;
+		else
+			ret = device->ops->ioctl(device, cmd, arg);
+		break;
 	}
+
+	vfio_device_pm_runtime_put(device);
+	return ret;
 }
 
 static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
-- 
2.17.1

