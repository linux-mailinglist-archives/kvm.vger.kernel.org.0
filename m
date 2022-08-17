Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D567859687E
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 07:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238537AbiHQFOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 01:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238392AbiHQFOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 01:14:19 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB43D5AA39;
        Tue, 16 Aug 2022 22:14:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScTYQrAvggkpDQ16JiDDZgjD3qJ4Mr2NtooPFYX5lNxJKkHEpzZA169BTfw9x0nR2AoJqZn9hH8xyFXgsukuUmgymVEHxDVKkLC69n5jgM9LuMonQ9AI5J/P6CbBrR55NXp668/whh8WuqIZUGf6n5RwTt2e95i/H6ABFxlulB1RHdBh/Mhv7lZMXNmtWGMgbCjMulgSoulWY8BtvySMAFbNHaj2UXlddu71tos3j7UOj35tvNv0IGDpH5+oWzU09auZbpbbGcgPPEtttYfA0XwWUXnSY23l7qIrSdTpvuKZ0ZfDpd30YjjrtwaYM4Er1CEEFPAAxoldNk02U/aOrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Cqa1WVtFLUgzdX+8KLrc/mOw6T7FU/y/cnLOT32F0c=;
 b=Ts0398ByGNbFn417a8KBLmfpw1v9cn71LQV+1DotmeXP9h7AqGva7fexYhxRuWP8iIwfROETParXrxwq1F4ErwojbSb5wLk51v4gcDZaSFmVDQKS6B7j/8kqFqmgJKrCYwpJUn2dNf/5q1afAsL675jGMlStXut0y0CDg9Qi+oriW0QvvCs1te0lNf2A+Z9YrPBWyuawLJ7h0HagSZXKoEC7TPP/9uxe/WPSwS0lka6wgtV1zQ+SQGFSkNsF8cWVeM41Jex8PJ2Q7Sm7DHMD5PKPHhoehWWPmJrD8MKSbEn2C1ywrcwC3+BDAxoxk6rrQO67wOuXorBWbjAdXGlRXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Cqa1WVtFLUgzdX+8KLrc/mOw6T7FU/y/cnLOT32F0c=;
 b=KIJt5gO8LIB1w9hMSWqfzxRhAlQG9EPQTtmx90ZQEKwHbQw9dZkwsjNWlmMlDJ8lXtPGLhGSGAcA/xVWZhgFka/pidjbUc2CG2nwWjCr0NWARcdpuythQBJBoL8JLELKjkfRRH0CTtrgXE/zDzRKaZtI2H+mFYe0oK+A7oendVUySNTqFsIrLFqdlYg7nZO8Ys8ij+VTzgcrUXrlQgafuB0vnxR+lLm9Z8Mcf+bBMUoZ7pF46qmgOjh5yDW0CPeDPPw45yZ3KEQ/nDZa3rMmSPpj+HDgQgDcMfdLZlL84yvfWneQfwHVHBWmGcR3ZAhvbBf/+2K+qLGgEMNY3EPUHA==
Received: from MW4PR03CA0021.namprd03.prod.outlook.com (2603:10b6:303:8f::26)
 by DM6PR12MB3833.namprd12.prod.outlook.com (2603:10b6:5:1cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Wed, 17 Aug
 2022 05:13:57 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::2d) by MW4PR03CA0021.outlook.office365.com
 (2603:10b6:303:8f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Wed, 17 Aug 2022 05:13:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 05:13:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 05:13:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 22:13:54 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Tue, 16 Aug 2022 22:13:50 -0700
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
Subject: [PATCH v6 4/5] vfio/pci: Implement VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY/EXIT
Date:   Wed, 17 Aug 2022 10:43:22 +0530
Message-ID: <20220817051323.20091-5-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817051323.20091-1-abhsahu@nvidia.com>
References: <20220817051323.20091-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bec075a7-2fd4-4657-c274-08da800f491c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3833:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m9iyC21swLDC1KYTYri/TbEYzWZzNJBQAW4zLAUnNjqiDNZxbgaR886vD4SRCQSs8YPbGaBnEyZj0dnQcokffkZk5NutV/LtxvKeYoAkDwfTIIsQYY/aHUL5V3HwOiq0DVa3iH+pcsIL2J94FPgqQO37Gv1F6rgwbJ1zaRo24vGRO/tp7wnVCZJkHJOCIBGo02pNZAD9PaXOnE0cWnn1VZDj6smDquUbhIe+mlfGuCSFUKr3z7lgd8pJ2Mi51Gx1+TefT/8N90duGNYSrv4iZoov2CIEVC/CfBv1gOeRuNrnuvVpHSI/e/AFoSUzaVmDT2b2kmVCzsa/F23x5/73NpRScGXzufN5pA+qNDH6eWwDz37TjNRAOy4DHzZn9Csk75iQlalyc7vI9mX1B2WKeONsc4a8iG9LjugGQDocLKNrdiwPhNYcTA9HcaehQfZQqwcLoLLXtZylJrsY3IynQ0U6lqF8/zkgZNZMLuybijyqX5desSOWI9bTp5NLFrJbJ/cQTuZ2Zom+gRmNTEcF+8ASNhV+1RJ/sbdHR1db3dILOuoo0yY6BAmfRCBbMsZlNzzHwOt5Aihaltey6CtCQyoobVXFJQjG4WVsWMXcLF4xc8mjAkHsdddg4WpvZmPIi/FKSI7AN0ajNkF3m4Hv95iEZAIy8FlVfph4lgto/j5aoU/2j0Nw33LJ8MoNixZlj56HzEZ7ErUskj449S0ZtE/xxYORs24ZWznAa+OCoSb2gdHbFU3qMUGQLtcW9u3Oeb0sDKBO4zEbwhdtiroFuWwD/OqH3hEoLhu07TGJSgnmWUyo6zr0hQ1Gs5kiNwXV9TuUTbC3Rj2IJa3DobUSKw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(40470700004)(36840700001)(46966006)(426003)(478600001)(186003)(54906003)(336012)(81166007)(40460700003)(82740400003)(47076005)(83380400001)(86362001)(1076003)(8676002)(36756003)(70206006)(4326008)(70586007)(316002)(110136005)(6666004)(5660300002)(8936002)(2906002)(7696005)(356005)(2616005)(107886003)(36860700001)(40480700001)(82310400005)(26005)(7416002)(41300700001)(30864003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 05:13:56.4739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bec075a7-2fd4-4657-c274-08da800f491c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3833
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, if the runtime power management is enabled for vfio-pci
based devices in the guest OS, then the guest OS will do the register
write for PCI_PM_CTRL register. This write request will be handled in
vfio_pm_config_write() where it will do the actual register write of
PCI_PM_CTRL register. With this, the maximum D3hot state can be
achieved for low power. If we can use the runtime PM framework, then
we can achieve the D3cold state (on the supported systems) which will
help in saving maximum power.

1. D3cold state can't be achieved by writing PCI standard
   PM config registers. This patch implements the following
   newly added low power related device features:
    - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
    - VFIO_DEVICE_FEATURE_LOW_POWER_EXIT

   The VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY feature will allow the
   device to make use of low power platform states on the host
   while the VFIO_DEVICE_FEATURE_LOW_POWER_EXIT will prevent
   further use of those power states.

2. The vfio-pci driver uses runtime PM framework for low power entry and
   exit. On the platforms where D3cold state is supported, the runtime
   PM framework will put the device into D3cold otherwise, D3hot or some
   other power state will be used.

   There are various cases where the device will not go into the runtime
   suspended state. For example,

   - The runtime power management is disabled on the host side for
     the device.
   - The user keeps the device busy after calling LOW_POWER_ENTRY.
   - There are dependent devices that are still in runtime active state.

   For these cases, the device will be in the same power state that has
   been configured by the user through PCI_PM_CTRL register.

3. The hypervisors can implement virtual ACPI methods. For example,
   in guest linux OS if PCI device ACPI node has _PR3 and _PR0 power
   resources with _ON/_OFF method, then guest linux OS invokes
   the _OFF method during D3cold transition and then _ON during D0
   transition. The hypervisor can tap these virtual ACPI calls and then
   call the low power device feature IOCTL.

4. The 'pm_runtime_engaged' flag tracks the entry and exit to
   runtime PM. This flag is protected with 'memory_lock' semaphore.

5. All the config and other region access are wrapped under
   pm_runtime_resume_and_get() and pm_runtime_put(). So, if any
   device access happens while the device is in the runtime suspended
   state, then the device will be resumed first before access. Once the
   access has been finished, then the device will again go into the
   runtime suspended state.

6. The memory region access through mmap will not be allowed in the low
   power state. Since __vfio_pci_memory_enabled() is a common function,
   so check for 'pm_runtime_engaged' has been added explicitly in
   vfio_pci_mmap_fault() to block only mmap'ed access.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 153 +++++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h    |   1 +
 2 files changed, 146 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a97fb8cbf903..d7d3c4392f70 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -260,11 +260,100 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
+static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
+{
+	/*
+	 * The vdev power related flags are protected with 'memory_lock'
+	 * semaphore.
+	 */
+	vfio_pci_zap_and_down_write_memory_lock(vdev);
+	if (vdev->pm_runtime_engaged) {
+		up_write(&vdev->memory_lock);
+		return -EINVAL;
+	}
+
+	vdev->pm_runtime_engaged = true;
+	pm_runtime_put_noidle(&vdev->pdev->dev);
+	up_write(&vdev->memory_lock);
+
+	return 0;
+}
+
+static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
+				  void __user *arg, size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	int ret;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
+	if (ret != 1)
+		return ret;
+
+	/*
+	 * Inside vfio_pci_runtime_pm_entry(), only the runtime PM usage count
+	 * will be decremented. The pm_runtime_put() will be invoked again
+	 * while returning from the ioctl and then the device can go into
+	 * runtime suspended state.
+	 */
+	return vfio_pci_runtime_pm_entry(vdev);
+}
+
+static void __vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
+{
+	if (vdev->pm_runtime_engaged) {
+		vdev->pm_runtime_engaged = false;
+		pm_runtime_get_noresume(&vdev->pdev->dev);
+	}
+}
+
+static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
+{
+	/*
+	 * The vdev power related flags are protected with 'memory_lock'
+	 * semaphore.
+	 */
+	down_write(&vdev->memory_lock);
+	__vfio_pci_runtime_pm_exit(vdev);
+	up_write(&vdev->memory_lock);
+}
+
+static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
+				 void __user *arg, size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	int ret;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
+	if (ret != 1)
+		return ret;
+
+	/*
+	 * The device is always in the active state here due to pm wrappers
+	 * around ioctls.
+	 */
+	vfio_pci_runtime_pm_exit(vdev);
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int vfio_pci_core_runtime_suspend(struct device *dev)
 {
 	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
 
+	down_write(&vdev->memory_lock);
+	/*
+	 * The user can move the device into D3hot state before invoking
+	 * power management IOCTL. Move the device into D0 state here and then
+	 * the pci-driver core runtime PM suspend function will move the device
+	 * into the low power state. Also, for the devices which have
+	 * NoSoftRst-, it will help in restoring the original state
+	 * (saved locally in 'vdev->pm_save').
+	 */
+	vfio_pci_set_power_state(vdev, PCI_D0);
+	up_write(&vdev->memory_lock);
+
 	/*
 	 * If INTx is enabled, then mask INTx before going into the runtime
 	 * suspended state and unmask the same in the runtime resume.
@@ -400,6 +489,18 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 
 	/*
 	 * This function can be invoked while the power state is non-D0.
+	 * This non-D0 power state can be with or without runtime PM.
+	 * vfio_pci_runtime_pm_exit() will internally increment the usage
+	 * count corresponding to pm_runtime_put() called during low power
+	 * feature entry and then pm_runtime_resume() will wake up the device,
+	 * if the device has already gone into the suspended state. Otherwise,
+	 * the vfio_pci_set_power_state() will change the device power state
+	 * to D0.
+	 */
+	vfio_pci_runtime_pm_exit(vdev);
+	pm_runtime_resume(&pdev->dev);
+
+	/*
 	 * This function calls __pci_reset_function_locked() which internally
 	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
 	 * fail if the power state is non-D0. Also, for the devices which
@@ -1233,6 +1334,10 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
 		return vfio_pci_core_feature_token(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
+		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
+		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
 	default:
 		return -ENOTTY;
 	}
@@ -1243,31 +1348,47 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	int ret;
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
 
+	ret = pm_runtime_resume_and_get(&vdev->pdev->dev);
+	if (ret) {
+		pci_info_ratelimited(vdev->pdev, "runtime resume failed %d\n",
+				     ret);
+		return -EIO;
+	}
+
 	switch (index) {
 	case VFIO_PCI_CONFIG_REGION_INDEX:
-		return vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
+		ret = vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
+		break;
 
 	case VFIO_PCI_ROM_REGION_INDEX:
 		if (iswrite)
-			return -EINVAL;
-		return vfio_pci_bar_rw(vdev, buf, count, ppos, false);
+			ret = -EINVAL;
+		else
+			ret = vfio_pci_bar_rw(vdev, buf, count, ppos, false);
+		break;
 
 	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
-		return vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
+		ret = vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
+		break;
 
 	case VFIO_PCI_VGA_REGION_INDEX:
-		return vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
+		ret = vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
+		break;
+
 	default:
 		index -= VFIO_PCI_NUM_REGIONS;
-		return vdev->region[index].ops->rw(vdev, buf,
+		ret = vdev->region[index].ops->rw(vdev, buf,
 						   count, ppos, iswrite);
+		break;
 	}
 
-	return -EINVAL;
+	pm_runtime_put(&vdev->pdev->dev);
+	return ret;
 }
 
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
@@ -1462,7 +1583,11 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	mutex_lock(&vdev->vma_lock);
 	down_read(&vdev->memory_lock);
 
-	if (!__vfio_pci_memory_enabled(vdev)) {
+	/*
+	 * Memory region cannot be accessed if the low power feature is engaged
+	 * or memory access is disabled.
+	 */
+	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev)) {
 		ret = VM_FAULT_SIGBUS;
 		goto up_out;
 	}
@@ -2177,6 +2302,15 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		goto err_unlock;
 	}
 
+	/*
+	 * Some of the devices in the dev_set can be in the runtime suspended
+	 * state. Increment the usage count for all the devices in the dev_set
+	 * before reset and decrement the same after reset.
+	 */
+	ret = vfio_pci_dev_set_pm_runtime_get(dev_set);
+	if (ret)
+		goto err_unlock;
+
 	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
 		/*
 		 * Test whether all the affected devices are contained by the
@@ -2232,6 +2366,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		else
 			mutex_unlock(&cur->vma_lock);
 	}
+
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
+		pm_runtime_put(&cur->pdev->dev);
 err_unlock:
 	mutex_unlock(&dev_set->lock);
 	return ret;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 98c0af5b5bba..d31cc9cc9c70 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -125,6 +125,7 @@ struct vfio_pci_core_device {
 	bool			nointx;
 	bool			needs_pm_restore;
 	bool			pm_intx_masked;
+	bool			pm_runtime_engaged;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
-- 
2.17.1

