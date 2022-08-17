Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C2D596879
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 07:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbiHQFOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 01:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbiHQFOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 01:14:19 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2069.outbound.protection.outlook.com [40.107.95.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B7D5F9AC;
        Tue, 16 Aug 2022 22:14:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLokerqDKB+N+TkiDUznX9u0xBuHMwP+WgaSUX4dRWCh5IpLfnBDEN2aHBOC0PzPjt/G3uLd/cXUMhQqp3wFAFzsLNjBkOEyNE1q8OQ1RhtldlmXRl/IbikSJpHass/uVEOQMSwtbGN9tXcu0+KmBln926S6h+mQB7JAecWWwnZ0BIm/+VDfFHVvGvwuVYN+DgLH4XJfrgU8j15pq+sYIGaUtgEXyiS4BvW1y74ew3alEHha5cTeSEujiR17ysiYOrLXkqYrjzew9MB0OBlZtDuRyn89oKirkawPMCu9TaMkI3wdctLkjZCB52TerlGAS2wXvuxEzRog2RlEx8MGOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIO9PjhHh1krEmGmOGxgIXksTnnmw9+s2zW89SduBB0=;
 b=c+FEW18WWh1u059131gsUBw8F8swu92ZtvMCr7St0gaPx7UjDhsinIzlJpOJ1E4cZ7V9zl6CBoXFlhOxSgGYMz4cCAhyXgyX0bVL0xCMTPuzZy79lAueGbIpvOEUMhGgN0BmuXKIdc3DEfgrw+j/VW4bTjWDTK8zQBvOA9f1glVWg6IHQMnx+l/7+mgARvKzZvq9ej3tJ8XKeqtPehLac566ajlBoCVD4t8hZ6Bi0sBpkZei1+0Q0x7ZSK87lFG3kG6z6VUddfbkhf/oXrP3AbeQpO8qsI0zzxS4PjHpuHP77PmUfr9orfijjPRMft/3MCtEqECtDy6KzpJ66JqGSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIO9PjhHh1krEmGmOGxgIXksTnnmw9+s2zW89SduBB0=;
 b=pz5Pf+nIMywFvTFOo0JaKZXASKCjWAC4bmFYFVqn04u4HBF8k7lyIDwafDIkHZD5kiRqVQWNR8EOlunyELNfYdftvW9PdBPfKwhO+RBhYo/b6UpehM9s32hxwfqwS58ovWuProxELSXy6GKOw9glXsSUnwJyJ4f+bDN9mR+ci8FqoadsB4uK2IXjeqsznFL+2ft8LORQuCcH0kzbcRQ0SW0T5TW4CXuAK1u6DW+pZY/+L+td0IaWpA5arlLuACWaET+Pt7/yZI2jUUty6w4UKdfRaOd0gOgiukm35zzxykDLqF5Kvnait5+uSxmCy/VPNafiTNJ9j70oQ5zkiqi0Yg==
Received: from DM6PR13CA0050.namprd13.prod.outlook.com (2603:10b6:5:134::27)
 by BYAPR12MB2901.namprd12.prod.outlook.com (2603:10b6:a03:138::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 17 Aug
 2022 05:14:03 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::6d) by DM6PR13CA0050.outlook.office365.com
 (2603:10b6:5:134::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.12 via Frontend
 Transport; Wed, 17 Aug 2022 05:14:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 05:14:03 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 05:14:02 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 22:14:01 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Tue, 16 Aug 2022 22:13:55 -0700
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
Subject: [PATCH v6 5/5] vfio/pci: Implement VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
Date:   Wed, 17 Aug 2022 10:43:23 +0530
Message-ID: <20220817051323.20091-6-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817051323.20091-1-abhsahu@nvidia.com>
References: <20220817051323.20091-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bed82e95-dcdd-4bdb-cc38-08da800f4d07
X-MS-TrafficTypeDiagnostic: BYAPR12MB2901:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L6x4t6dX4Ny27YhT/utgmh0lNugzwFiYwExkFqQDN3nd5tfLxTtGumISNaoXuDUodrlfqPBB+vCaly+nZkhDixdt+FLi6XkVBxnOSidTNLDs2zIl4iva198SB5Qi98P2Xv9RjXxwQx8Jun6u7DUixB0NBLnOeN6JWEqA1Yz859+alnAMiMqXa/B/rUdWd96mTVEbv0kopoU45CZcy0u0k36b6ORF6UYXkOCyzyzguL57xZ03BCYKG9U3JGptIEb9vjCmVbO/twnz50xZ6qrOQMhboBwY1Cvw4I7moYwhPy1zE2IAAHs1w3xmU2rWqPGgrhWCoGlwk1dTJ7Vh761HpPVxO67XTPrZLHoFezID8R8NkpGe7Sil/bp/c70jZdCtMjZmX7sepPJkAFQid9xyCm/p8NFr+pe0KDPapxkh/SuDBMkh/jwULKhwQC18RXTVd8pirFQb6UN2gH35LK1TkhiMB2Cqigb7CompNYZ25MmIqZWw/4eRb4pHcDTuEjD5YotFWC3+9Asyi866E79yvl9+6DedOamsQ0k+u+FOSqKT/wwXg+/33E9qdGWkvWnz6EXSlD3beeRaSwxP2kAT5TfJvTAlab1leclX+7t/sZpWkocm+w1wOBGVRmsWQggVGMV8m6KCgu9qAtHGQigrOnxUMMIeRLBwWoP3BIX+ma9/jt+eJWgmxm2HZQ6KSf2tmJHsGEPYhXLHP8V3ioVV1o6bCJ11nwgR7OkxgJYYOL7efTO78ESRWaafTew9oGb9FHoS3NAHXx5c3ZqxFhIZOidA+VgGfgSmfi2kmedNlTXuY3YXTWSlUrd+VPcXhqg83q4DNhIIx4EooguGppbANA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(136003)(39860400002)(46966006)(40470700004)(36840700001)(107886003)(8676002)(70586007)(26005)(82310400005)(4326008)(82740400003)(110136005)(316002)(54906003)(40460700003)(81166007)(478600001)(40480700001)(70206006)(6666004)(356005)(7696005)(2616005)(86362001)(83380400001)(8936002)(41300700001)(36756003)(1076003)(5660300002)(7416002)(36860700001)(336012)(2906002)(426003)(47076005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 05:14:03.0318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bed82e95-dcdd-4bdb-cc38-08da800f4d07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2901
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
 drivers/vfio/pci/vfio_pci_core.c | 62 ++++++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h    |  1 +
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d7d3c4392f70..00d24243b89e 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -260,7 +260,8 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
-static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
+static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
+				     struct eventfd_ctx *efdctx)
 {
 	/*
 	 * The vdev power related flags are protected with 'memory_lock'
@@ -273,6 +274,7 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
 	}
 
 	vdev->pm_runtime_engaged = true;
+	vdev->pm_wake_eventfd_ctx = efdctx;
 	pm_runtime_put_noidle(&vdev->pdev->dev);
 	up_write(&vdev->memory_lock);
 
@@ -296,7 +298,39 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
 	 * while returning from the ioctl and then the device can go into
 	 * runtime suspended state.
 	 */
-	return vfio_pci_runtime_pm_entry(vdev);
+	return vfio_pci_runtime_pm_entry(vdev, NULL);
+}
+
+static int
+vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
+				   void __user *arg, size_t argsz)
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
@@ -304,6 +338,11 @@ static void __vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
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
 
@@ -331,7 +370,10 @@ static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
 
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
@@ -370,6 +412,17 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
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
 
@@ -1336,6 +1389,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 		return vfio_pci_core_feature_token(device, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
 		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP:
+		return vfio_pci_core_pm_entry_with_wakeup(device, flags,
+							  arg, argsz);
 	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
 		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
 	default:
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index d31cc9cc9c70..8bdf20cd94a9 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -131,6 +131,7 @@ struct vfio_pci_core_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	struct eventfd_ctx	*pm_wake_eventfd_ctx;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
-- 
2.17.1

