Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC2B49881E
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245185AbiAXSR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 13:17:56 -0500
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:44865
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245172AbiAXSRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 13:17:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gostEVAH2DM7xJv2wzL0XjZlXC2JOqDPhBKwekWqj6W422uQps79q7QctxX6M7e7NtxwQzVIUO78M2j631uVRLHqaKiF4to/fuVD87dy28J5BoMYgvU18kZP1t2EjRoamlRmLWaXEfHSQ4N4mkT8i347Jl/LH0StNij2WRbp7Fxhq6UjZEtru3qyEJRDIjHHS4Z4RZggfKjcJOQnXTevdnGGF8IGb5HMI3kvNKKTIBC7JgnCq7eNfPo1w4KO4Z/cKM1akQ/bij1cJiaa7C7xoR5CdOnMqSu5m2udSWp1XOYd45aP0eJbXHV6+uWKX5P5E3i5xg9b2V4BZ2Eyy2mvmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zkVdGMLKC2SYT8bHfypRNDWu6RqXsLY86Q9yCVu6iK4=;
 b=RWlJ+qZvyRBYNUaU5pmIWDSNW3/FQZl6g2dwcFaX4MjjC3XD2chWj+kHPUeEOhxsTaRg52hMqSm7jCnKMrAY/qlkhya36PrkpVl63Iv1ez+AhK1V4g9DCtwgFUNHIcY9XqyW5++aSLsKUlMc/svOB4krPsA86VePjtpObs6QcQDW8F1AOOx2Dfju0S+ryq50ufvTCJh9gTrlqeCbBgUEXm3k/BxyDqAaoMqH5Lp2U/omV8SUc55vdkQPHxuGOaRK2aZkSKWjR6MvejS3yS+HWghSTH4oVS/YZkna4DZYkzhS3aLmJuwZkHb0VZnRDKxOvaEMgXl0iZKKjjiN8OFQgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkVdGMLKC2SYT8bHfypRNDWu6RqXsLY86Q9yCVu6iK4=;
 b=aZJ02EAay1lmQaFtng85QhrAIa8YlO3PjkwZH8QYq32ZcHqYcUNh8CgeSCeYYlTnLiAxLfs10i8bbN7Wxixz2cw9yHSJ5zYFVNDIp3/zZa15HLTeN/CZv5w0u8yYv3PHCqvjVvwkqfaYuQ1ZCZkqUsH+8D5sLEu7JBBUHLDAVyh8V4OXdN3mbh8Z+YnHkSVTgO9Qsy9J150gWVTueeNXWBtrNaNwVJ6z9fpLaYGAE6MizY1k8qzDLFXhF8zfl1ULEy1q68fjT47gPWIH3+M1fXu0/mYbIqgjx4jKSwjPqrQb+E64gdH9ires2Eym2waQCwHbY9ThX5gRA/p/eCy2KA==
Received: from DM5PR06CA0078.namprd06.prod.outlook.com (2603:10b6:3:4::16) by
 DM5PR12MB1913.namprd12.prod.outlook.com (2603:10b6:3:10d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.7; Mon, 24 Jan 2022 18:17:42 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::31) by DM5PR06CA0078.outlook.office365.com
 (2603:10b6:3:4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Mon, 24 Jan 2022 18:17:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 18:17:42 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 18:17:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 10:17:41 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.13) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 24 Jan 2022 10:17:37 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC PATCH v2 1/5] vfio/pci: register vfio-pci driver with runtime PM framework
Date:   Mon, 24 Jan 2022 23:47:22 +0530
Message-ID: <20220124181726.19174-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124181726.19174-1-abhsahu@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f7c9dc4-5f45-4318-532c-08d9df65d013
X-MS-TrafficTypeDiagnostic: DM5PR12MB1913:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1913F15FC0247B8B7F71E4D9CC5E9@DM5PR12MB1913.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: On2/JBp3l54X9QuKDHmHZXPt+UL6AI1iYy7XThbn0PLabdHkhl4gPD5egS7tRZZN2zRwkhRrlHk/Hh871/geS/30BdW2lKBW7eajfkELOfSJL6qDwsG2lodQfN5ywAlGlPd82cc+MLTirpd+6rMsagxKzstlTqdxGBkgl+qb8b1SbnPTva6Ve5rIl87QgRzvMzUmtz50lCN0tM1MzjDUtheFSUJOhPh+z0jxdBIm6CjSD3fC+VjkQ195hW1i/q0ZV29qFl9p7VkL0n2cC15CyOgx/veXMEl4e7nwdHEjDcWz5kUueWy7jlEYvSy+d4HqVsbYRNlxf8TqfpOkSksmHlHQNvgUFjXuh+a62uGwMloJQl+hgjU0EGkIWJ9QztrnYjrya4U6a1KiIHEZQpfu2EIHbBll0tXyUenONUtJQ1J26Ws3epaPMqSHgA/5aDjKvCVe8kQgSBAnu0E8HgJEd0DEy0gRDbTUfmy82DLAdZp0xNFxnhL2FgSsezBGEWKvZ6KLiBfUVmSQJkV27H26cmDAyHDonapmqf6SR8g+v/U8syIMc9l6Ugp9HJHZk8F7+ORmQMieUvEM1z7fGHCco7pbE+kK1zytg+IEfHzrsocSFx7cKQG/qK8pdaOftcRxflFwEZ0XGjSRGUR1u6VfjGBX9GbjpyYjiYwner2m0mVbN4/iWoguEw3g/mNk/CIMezOLJqUzWuhb/wUrScNHhdabRR+P/1iulU0L+xSS8g3fHxN8kPoiz5P5EXl78PnN4Tn3FU6WHyqXdwygAblPgEanuj4fS9pzTX1cdyb7SCg=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(2616005)(6666004)(1076003)(5660300002)(110136005)(186003)(356005)(426003)(508600001)(36756003)(54906003)(8676002)(47076005)(107886003)(336012)(316002)(40460700003)(82310400004)(4326008)(36860700001)(81166007)(86362001)(2906002)(70586007)(7696005)(83380400001)(70206006)(26005)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 18:17:42.3223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7c9dc4-5f45-4318-532c-08d9df65d013
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1913
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, there is very limited power management support
available in the upstream vfio-pci driver. If there is no user of vfio-pci
device, then the PCI device will be moved into D3Hot state by writing
directly into PCI PM registers. This D3Hot state help in saving power
but we can achieve zero power consumption if we go into the D3cold state.
The D3cold state cannot be possible with native PCI PM. It requires
interaction with platform firmware which is system-specific.
To go into low power states (including D3cold), the runtime PM framework
can be used which internally interacts with PCI and platform firmware and
puts the device into the lowest possible D-States.

This patch registers vfio-pci driver with the runtime PM framework.

1. The PCI core framework takes care of most of the runtime PM
   related things. For enabling the runtime PM, the PCI driver needs to
   decrement the usage count and needs to register the runtime
   suspend/resume callbacks. For vfio-pci based driver, these callback
   routines can be stubbed in this patch since the vfio-pci driver
   is not doing the PCI device initialization. All the config state
   saving, and PCI power management related things will be done by
   PCI core framework itself inside its runtime suspend/resume callbacks.

2. Inside pci_reset_bus(), all the devices in bus/slot will be moved
   out of D0 state. This state change to D0 can happen directly without
   going through the runtime PM framework. So if runtime PM is enabled,
   then pm_runtime_resume() makes the runtime state active. Since the PCI
   device power state is already D0, so it should return early when it
   tries to change the state with pci_set_power_state(). Then
   pm_request_idle() can be used which will internally check for
   device usage count and will move the device again into the low power
   state.

3. Inside vfio_pci_core_disable(), the device usage count always needs
   to be decremented which was incremented in vfio_pci_core_enable().

4. Since the runtime PM framework will provide the same functionality,
   so directly writing into PCI PM config register can be replaced with
   the use of runtime PM routines. Also, the use of runtime PM can help
   us in more power saving.

   In the systems which do not support D3Cold,

   With the existing implementation:

   // PCI device
   # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
   D3hot
   // upstream bridge
   # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
   D0

   With runtime PM:

   // PCI device
   # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
   D3hot
   // upstream bridge
   # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
   D3hot

   So, with runtime PM, the upstream bridge or root port will also go
   into lower power state which is not possible with existing
   implementation.

   In the systems which support D3Cold,

   // PCI device
   # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
   D3hot
   // upstream bridge
   # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
   D0

   With runtime PM:

   // PCI device
   # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
   D3cold
   // upstream bridge
   # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
   D3cold

   So, with runtime PM, both the PCI device and upstream bridge will
   go into D3cold state.

5. If 'disable_idle_d3' module parameter is set, then also the runtime
   PM will be enabled, but in this case, the usage count should not be
   decremented.

6. vfio_pci_dev_set_try_reset() return value is unused now, so this
   function return type can be changed to void.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      |  3 +
 drivers/vfio/pci/vfio_pci_core.c | 95 +++++++++++++++++++++++---------
 include/linux/vfio_pci_core.h    |  4 ++
 3 files changed, 75 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a5ce92beb655..c8695baf3b54 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -193,6 +193,9 @@ static struct pci_driver vfio_pci_driver = {
 	.remove			= vfio_pci_remove,
 	.sriov_configure	= vfio_pci_sriov_configure,
 	.err_handler		= &vfio_pci_core_err_handlers,
+#if defined(CONFIG_PM)
+	.driver.pm              = &vfio_pci_core_pm_ops,
+#endif
 };
 
 static void __init vfio_pci_fill_ids(void)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f948e6cd2993..c6e4fe9088c3 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -152,7 +152,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 }
 
 struct vfio_pci_group_info;
-static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
+static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 				      struct vfio_pci_group_info *groups);
 
@@ -245,7 +245,11 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	u16 cmd;
 	u8 msix_pos;
 
-	vfio_pci_set_power_state(vdev, PCI_D0);
+	if (!disable_idle_d3) {
+		ret = pm_runtime_resume_and_get(&pdev->dev);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Don't allow our initial saved state to include busmaster */
 	pci_clear_master(pdev);
@@ -405,8 +409,11 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 out:
 	pci_disable_device(pdev);
 
-	if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D3hot);
+	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
+
+	/* Put the pm-runtime usage counter acquired during enable */
+	if (!disable_idle_d3)
+		pm_runtime_put(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
@@ -1847,19 +1854,20 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 
 	vfio_pci_probe_power_state(vdev);
 
-	if (!disable_idle_d3) {
-		/*
-		 * pci-core sets the device power state to an unknown value at
-		 * bootup and after being removed from a driver.  The only
-		 * transition it allows from this unknown state is to D0, which
-		 * typically happens when a driver calls pci_enable_device().
-		 * We're not ready to enable the device yet, but we do want to
-		 * be able to get to D3.  Therefore first do a D0 transition
-		 * before going to D3.
-		 */
-		vfio_pci_set_power_state(vdev, PCI_D0);
-		vfio_pci_set_power_state(vdev, PCI_D3hot);
-	}
+	/*
+	 * pci-core sets the device power state to an unknown value at
+	 * bootup and after being removed from a driver.  The only
+	 * transition it allows from this unknown state is to D0, which
+	 * typically happens when a driver calls pci_enable_device().
+	 * We're not ready to enable the device yet, but we do want to
+	 * be able to get to D3.  Therefore first do a D0 transition
+	 * before enabling runtime PM.
+	 */
+	vfio_pci_set_power_state(vdev, PCI_D0);
+	pm_runtime_allow(&pdev->dev);
+
+	if (!disable_idle_d3)
+		pm_runtime_put(&pdev->dev);
 
 	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
@@ -1868,7 +1876,9 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 
 out_power:
 	if (!disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
+		pm_runtime_get_noresume(&pdev->dev);
+
+	pm_runtime_forbid(&pdev->dev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 	return ret;
@@ -1887,7 +1897,9 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	vfio_pci_vga_uninit(vdev);
 
 	if (!disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
+		pm_runtime_get_noresume(&pdev->dev);
+
+	pm_runtime_forbid(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
@@ -2093,33 +2105,62 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
  *  - At least one of the affected devices is marked dirty via
  *    needs_reset (such as by lack of FLR support)
  * Then attempt to perform that bus or slot reset.
- * Returns true if the dev_set was reset.
  */
-static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
+static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
 {
 	struct vfio_pci_core_device *cur;
 	struct pci_dev *pdev;
 	int ret;
 
 	if (!vfio_pci_dev_set_needs_reset(dev_set))
-		return false;
+		return;
 
 	pdev = vfio_pci_dev_set_resettable(dev_set);
 	if (!pdev)
-		return false;
+		return;
 
 	ret = pci_reset_bus(pdev);
 	if (ret)
-		return false;
+		return;
 
 	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
 		cur->needs_reset = false;
-		if (!disable_idle_d3)
-			vfio_pci_set_power_state(cur, PCI_D3hot);
+		if (!disable_idle_d3) {
+			/*
+			 * Inside pci_reset_bus(), all the devices in bus/slot
+			 * will be moved out of D0 state. This state change to
+			 * D0 can happen directly without going through the
+			 * runtime PM framework. pm_runtime_resume() will
+			 * help make the runtime state as active and then
+			 * pm_request_idle() can be used which will
+			 * internally check for device usage count and will
+			 * move the device again into the low power state.
+			 */
+			pm_runtime_resume(&pdev->dev);
+			pm_request_idle(&pdev->dev);
+		}
 	}
-	return true;
 }
 
+#ifdef CONFIG_PM
+static int vfio_pci_core_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int vfio_pci_core_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+const struct dev_pm_ops vfio_pci_core_pm_ops = {
+	SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
+			   vfio_pci_core_runtime_resume,
+			   NULL)
+};
+EXPORT_SYMBOL_GPL(vfio_pci_core_pm_ops);
+#endif
+
 void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
 			      bool is_disable_idle_d3)
 {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..aafe09c9fa64 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -231,6 +231,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
 
+#ifdef CONFIG_PM
+extern const struct dev_pm_ops vfio_pci_core_pm_ops;
+#endif
+
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
-- 
2.17.1

