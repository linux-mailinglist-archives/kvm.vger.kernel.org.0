Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990755A4B05
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 14:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiH2MGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 08:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiH2MGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 08:06:05 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2051.outbound.protection.outlook.com [40.107.95.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DD58C02E;
        Mon, 29 Aug 2022 04:51:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eccUwO146pp9KMpFXqLXs7E1QjqzJupJIU8rHZrH+hyxtp8D3N31wqFVvlyyWiYletUohBrQK8HRMFOPgVs1lSlhkTLLuHpa2tDPksD835tgBKZjUljcjI7ylUoYItIvObrwpYpojJJvLewgZ5rCaxho6Owgfl42UlG7AHKkae/4TQ8re6a9hIc7u/DqipqKHbouTZ717GRHgMQ38IIru9IE4WZdYGMnf8SAnowaDRLtGQylOMusGjE/xerRXQ+4gLiN7mKhoEDjFHLlCFJfWTZPmRFtJmQQCxzAb92zrHGvV8hM8EHVt/FiYNq1Zm5KyyOzbrw6RbkCcnqptQT2gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZ/zwXj4y/6VfaxgkC+vhiLKBJuygzeOHfNXVpjH/eY=;
 b=nSyvqoUE5uBGWh40Pyb3q1Gx8tJDAJ080Na0KF/GNS7E/YLKPAXT3kGiUTbeNeJuzwyPqSzkRJtgDqJwma98ZxuBKKzDQBzwlE5NblPzPZ6KKhkVMAWyAs/8W2k9Z76sz4TtQoto1L1kWrI2zJHyI1bguEy0tkpQNFqS4AHwneGj76dLh0qCgWG1ffwQlUISRzqZrO8oGCc3Oz2+wlcm6BYKyPuunOt4FL64uUBU57o5PKRESQxMC9ULNDSvC4FuQPUbB6BbOaGlF8CuQFEpOXb9avFmbd9e2C0a3Z0vD4B7Zb7EYfbFnN7L7VZVw4bzWT8bq/fhSwQiwFpJa43JyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZ/zwXj4y/6VfaxgkC+vhiLKBJuygzeOHfNXVpjH/eY=;
 b=t9CEtW7aCqKa0ZRa2Fu3TsUBST7e7SJwgyftSCUyjMA0O3Yx9pFopItB5nqRzR8U75wDwEfLsNWRiECICeYuh48Z/Wq5tyGyEB9PF7K7Jv1x53tksmVF8/PmPrdOXzekjLqk9iDj2rrBfclwXzJKQfJ9jEbOdmA97CuNgI4syFyYWt2qMVzjY9bDphNWj+Igf+W9K+xY3b9EuTJmUWVHTrR2OLs/WNjsDVd1J+e2zLuCMPHpuP4CBl8UhKF4Nztr3labTqvYHtajw9/qzkky+KXLTPDTEhlMtpjfUXTOZ+jzAIHc6PE/ATLVr02CHG/KOEyhZU/YnbzuX1CospdJIQ==
Received: from BN9PR03CA0854.namprd03.prod.outlook.com (2603:10b6:408:13d::19)
 by CH2PR12MB4876.namprd12.prod.outlook.com (2603:10b6:610:67::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 11:49:31 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::e5) by BN9PR03CA0854.outlook.office365.com
 (2603:10b6:408:13d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Mon, 29 Aug 2022 11:49:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 11:49:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 29 Aug
 2022 11:49:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 04:49:28 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 29 Aug 2022 04:49:23 -0700
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
Subject: [PATCH v7 5/5] vfio/pci: Implement VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
Date:   Mon, 29 Aug 2022 17:18:50 +0530
Message-ID: <20220829114850.4341-6-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220829114850.4341-1-abhsahu@nvidia.com>
References: <20220829114850.4341-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5cdc856-2fae-428e-ad24-08da89b488e9
X-MS-TrafficTypeDiagnostic: CH2PR12MB4876:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8utr+yg0pZi7JCGTaZlDK2oRfp35QtiWFg8Tb3TxFFaLOgBzU/YfqHP6Np7WWfdmRgrRpGRadlLipUliTo6lW+xabS1istGLxvzfZdqd2YjvLJW5EpdNddBiXuaWK/UjuGjZn/whdGdHqgxoWYL3NILCKHwZxWX6VdnR8LN8hoqOBAw1m7j+dUONwGrr6rpiey/eEgQuvI8raIGZ9YUnHObKEV2k229EgvIcgiPWS+ZMsvxhnsMmjlpfACljLovF0T7OSJFr1xNexaINmvEBWBs6JExkY0+bEhACErmvXGMg/C3eovZrJ8yGe4R3LZJIrBMXJg7KB5AxrlliSZ7X5svbwVJb3QLD8AByY+vWriaSFdg1XJwCyOei0b/FihSxOVQX2CBeibceacP0AgpoRZw8+AlIiRtksLALBNrmVVMNH5zVPkCiwxHpVFYE1G7kFqctM4Cax15JeOL3Gm63H1mWYpy7zhuvOF3a/c3T+u9zUVgy/UJBS4tgiKIjY5x4FaCe0USWuzd/4BCMaWHJzNhiAUJVuYhwTopOtsQZWuYRAT0eOqfg0lFABDiP/ZC0hTUNAQWnWp5XNnnlH8V2k6nfjocmHEYzIWZMGXr2sjT37FCC+Yr3vWMIkCVYrO7P4Dp/wZPsctVptW2VgqbwyAuqmKZrcuMX8KeG/DQ+x1JMqaMOXyXie8q/L9pJHuxnhus03BNbmYMvVXt39h87QZrPnrcMhMXe30C8fOrpqHbOKK/4zDLak9oFXzVuCZxwsw2/FNA8sQKUieVuoXT1AwUcspBc4clTHOy+Pz/fQiCJtg4gy2hKQSmbYp+1m6I
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(40470700004)(46966006)(36840700001)(2906002)(107886003)(26005)(82740400003)(6666004)(2616005)(82310400005)(426003)(40460700003)(40480700001)(336012)(47076005)(186003)(1076003)(36860700001)(83380400001)(110136005)(8676002)(54906003)(4326008)(70206006)(70586007)(7696005)(41300700001)(7416002)(5660300002)(81166007)(86362001)(8936002)(316002)(356005)(36756003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:49:30.8762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5cdc856-2fae-428e-ad24-08da89b488e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4876
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
device feature. In the VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY, if there is
any access for the VFIO device on the host side, then the device will
be moved out of the low power state without the user's guest driver
involvement. Once the device access has been finished, then the host
can move the device again into low power state. With the low power
entry happened through VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP,
the device will not be moved back into the low power state and
a notification will be sent to the user by triggering wakeup eventfd.

vfio_pci_core_pm_entry() will be called for both the variants of low
power feature entry so add an extra argument for wakeup eventfd context
and store locally in 'struct vfio_pci_core_device'.

For the entry happened without wakeup eventfd, all the exit related
handling will be done by the LOW_POWER_EXIT device feature only.
When the LOW_POWER_EXIT will be called, then the vfio core layer
vfio_device_pm_runtime_get() will increment the usage count and will
resume the device. In the driver runtime_resume callback, the
'pm_wake_eventfd_ctx' will be NULL. Then vfio_pci_core_pm_exit()
will call vfio_pci_runtime_pm_exit() and all the exit related handling
will be done.

For the entry happened with wakeup eventfd, in the driver resume
callback, eventfd will be triggered and all the exit related handling will
be done. When vfio_pci_runtime_pm_exit() will be called by
vfio_pci_core_pm_exit(), then it will return early.
But if the runtime suspend has not happened on the host side, then
all the exit related handling will be done in vfio_pci_core_pm_exit()
only.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 63 ++++++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h    |  1 +
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 9c612162653f..0d4b49f06b14 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -277,7 +277,8 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
-static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
+static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
+				     struct eventfd_ctx *efdctx)
 {
 	/*
 	 * The vdev power related flags are protected with 'memory_lock'
@@ -290,6 +291,7 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
 	}
 
 	vdev->pm_runtime_engaged = true;
+	vdev->pm_wake_eventfd_ctx = efdctx;
 	pm_runtime_put_noidle(&vdev->pdev->dev);
 	up_write(&vdev->memory_lock);
 
@@ -313,7 +315,40 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
 	 * while returning from the ioctl and then the device can go into
 	 * runtime suspended state.
 	 */
-	return vfio_pci_runtime_pm_entry(vdev);
+	return vfio_pci_runtime_pm_entry(vdev, NULL);
+}
+
+static int vfio_pci_core_pm_entry_with_wakeup(
+	struct vfio_device *device, u32 flags,
+	struct vfio_device_low_power_entry_with_wakeup __user *arg,
+	size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	struct vfio_device_low_power_entry_with_wakeup entry;
+	struct eventfd_ctx *efdctx;
+	int ret;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
+				 sizeof(entry));
+	if (ret != 1)
+		return ret;
+
+	if (copy_from_user(&entry, arg, sizeof(entry)))
+		return -EFAULT;
+
+	if (entry.wakeup_eventfd < 0)
+		return -EINVAL;
+
+	efdctx = eventfd_ctx_fdget(entry.wakeup_eventfd);
+	if (IS_ERR(efdctx))
+		return PTR_ERR(efdctx);
+
+	ret = vfio_pci_runtime_pm_entry(vdev, efdctx);
+	if (ret)
+		eventfd_ctx_put(efdctx);
+
+	return ret;
 }
 
 static void __vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
@@ -321,6 +356,11 @@ static void __vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
 	if (vdev->pm_runtime_engaged) {
 		vdev->pm_runtime_engaged = false;
 		pm_runtime_get_noresume(&vdev->pdev->dev);
+
+		if (vdev->pm_wake_eventfd_ctx) {
+			eventfd_ctx_put(vdev->pm_wake_eventfd_ctx);
+			vdev->pm_wake_eventfd_ctx = NULL;
+		}
 	}
 }
 
@@ -348,7 +388,10 @@ static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
 
 	/*
 	 * The device is always in the active state here due to pm wrappers
-	 * around ioctls.
+	 * around ioctls. If the device had entered a low power state and
+	 * pm_wake_eventfd_ctx is valid, vfio_pci_core_runtime_resume() has
+	 * already signaled the eventfd and exited low power mode itself.
+	 * pm_runtime_engaged protects the redundant call here.
 	 */
 	vfio_pci_runtime_pm_exit(vdev);
 	return 0;
@@ -388,6 +431,17 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
 {
 	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
 
+	/*
+	 * Resume with a pm_wake_eventfd_ctx signals the eventfd and exit
+	 * low power mode.
+	 */
+	down_write(&vdev->memory_lock);
+	if (vdev->pm_wake_eventfd_ctx) {
+		eventfd_signal(vdev->pm_wake_eventfd_ctx, 1);
+		__vfio_pci_runtime_pm_exit(vdev);
+	}
+	up_write(&vdev->memory_lock);
+
 	if (vdev->pm_intx_masked)
 		vfio_pci_intx_unmask(vdev);
 
@@ -1376,6 +1430,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
 	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
 		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP:
+		return vfio_pci_core_pm_entry_with_wakeup(device, flags,
+							  arg, argsz);
 	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
 		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 1025d53fde0b..089b603bcfdc 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -85,6 +85,7 @@ struct vfio_pci_core_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	struct eventfd_ctx	*pm_wake_eventfd_ctx;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
-- 
2.17.1

