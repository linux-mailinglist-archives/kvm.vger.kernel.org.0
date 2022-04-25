Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE47550DC95
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbiDYJbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiDYJav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:30:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF4D24BD6;
        Mon, 25 Apr 2022 02:27:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKBzcS1RuUC86l/gLM1W8Zy16YprI72azC1QpNc/roveBcLLKJ32BMVHSy10e6Fg+YC4q1QMjpg5ZeHPz2fgH7sbtlOD2hPlASnUdiWZO52pNqGpXr5VV/0APVSCH4ag67CoiklE+9m8AtDiB6LxQtnMJxszDZTigSilACwZZZJfwva6jVbnKTIV5wOWJRSBqED3qL7chVLQhr6xmz7UuhQ+tdZ9NBClYqJgyIMRphZiwObnmgTq3+dQAixK9hJgTL/MTaT1wnEh4KPXWjCRH1xQqYKEZ7wKn3jPFekcEZb6zRphf3rtyaCiORCyu2I7cu/rPf7mgdGTExPJfI45gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TPIPnQZa5SH/TIfHRA7ehZxHeGjHAWMLvX5fSqLB50=;
 b=gqCwVZyHjkdzm2ayAXob5iZVQF/Zoh+5yZZyJECDKUNfMmmwX9hgVdtQe7KXAiN0c8m/bMkLy+S+LBn29Ghsw+gMlMPP1XH9sq3afuGdHUwg6CNITAt2Cricfb0l6kJSKVn30H2ASWPOTHb2zz+tbpmjsHHhlyU43/s+nPTUfIVuN/lA3lPurmAj6JiZnZuZn8go2cxJUBpObVyZqc9I6zC6oteH1iyBb+0yYcIyAvcjmU5BnBQD7fur4E6OAfZlA5JrapwEgvK5W/oNoHdnHJ9qTFAqbxHTWageZGYYTjAG1/xp7ymytVXRlltwQRHg1sBtDku5jt4YCxAPmt831g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TPIPnQZa5SH/TIfHRA7ehZxHeGjHAWMLvX5fSqLB50=;
 b=s6PlEkE8EZ6PEFYxWJwo2uugplUbBszfjScbqSsAjfp59x/keRxvyIDTT/BmW6Tq+fmyFguSXcERp9aOOMnQWjEhoEyyxrq4n2N0QmoO904w6tfuEZ9TtaOIBCAjAGE8pKhUybin8CNPr/l/f+hnNV8O5Q0jo/5DYNvWA6nDBksBYdiG/iIFrgBD9EprmvoYuy5hgO04KX9l+Z3dU6nJR8BY9bBJ+7gwqExJlCH/ouKibPxVSWzumuv33KAiDVl4AyRsEKNN/LF5xmZZn5KiQTqTIy3NmDOHMwyFunWZcv7znIMAZyV5P+MXOY440p0ntYjUU4xQP1pzEjL4gJEk0g==
Received: from BN7PR02CA0023.namprd02.prod.outlook.com (2603:10b6:408:20::36)
 by DM4PR12MB5215.namprd12.prod.outlook.com (2603:10b6:5:397::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 09:27:08 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::df) by BN7PR02CA0023.outlook.office365.com
 (2603:10b6:408:20::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Mon, 25 Apr 2022 09:27:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 09:27:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 25 Apr
 2022 09:27:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 25 Apr
 2022 02:27:06 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 25 Apr 2022 02:27:01 -0700
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
Subject: [PATCH v3 7/8] vfio/pci: Mask INTx during runtime suspend
Date:   Mon, 25 Apr 2022 14:56:14 +0530
Message-ID: <20220425092615.10133-8-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220425092615.10133-1-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7a846fe-0ebf-4cc3-2540-08da269dc4d5
X-MS-TrafficTypeDiagnostic: DM4PR12MB5215:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5215C98F54ABC56499D49F48CCF89@DM4PR12MB5215.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rlTI9xvDQIDBDqXGcPDP5jmgGBC3qoj7fKL45kWYtZmkvr2X9yXMt1VUD9hG7UbAuDH9CCceIUsvGjUMFsRGTrhtPnvinNxLEDwGjb/K59y8M7yNWG7aCdiHXNaZlhh8O7hmrPCT4YLiGv51llPs6rdtRXdHPYrihzGqkjmCtewoiqB27uP/lXgLxWJG4r+Wshc/TrVJ4JoKI4rQ1kRajowMfzZGDLeIVUL0HD3uq+Ycb5eM4rNJnaW5GVURSaO3Fr7v4POV+bbmvkBQ9C4vUFSmEuv/CzCgcF8t5OeJCX5x8TV+POpriBGCOFA1oCjUozdboze5AlqCMa51c+Jpfa1CA3rESDp7a8KrFeOZ6v5rwuYeXe9hTJoEi/WVE0ILzDOdkRgOOgYCQpgLjoQH/CxaP+dCcorigHA1fh6i5HM/6gGlbw4+qgfE+mk7JnxrreeieUKLXqUT0/anK2pTWPgyT+DF9QdCaBosXGylfLf8nZUvakKljJ88jiREErRmOyULYqPlosbXpzVKPqu34O+YSTOOAaETKACBpf4LhBfIAQirdgf+H1TM6zZ4dMP+NtziUXwGixoSoIQvEG/QW2E7GubjO82uieh3o1TOIgDKUdDTN1BokYdCBEHKErKSLbK9NVW3VoPMdPCMqlpuqfcmsPCvbJWlN9OpiClVcLWbnbcPMl7QjfrygyVjR2JwPoNGUWUh3hVh4A2oN+A7oA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2906002)(83380400001)(7696005)(7416002)(316002)(110136005)(107886003)(2616005)(356005)(426003)(47076005)(336012)(81166007)(6666004)(1076003)(5660300002)(186003)(36860700001)(508600001)(86362001)(26005)(8936002)(15650500001)(82310400005)(40460700003)(36756003)(54906003)(70206006)(4326008)(8676002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 09:27:07.8651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a846fe-0ebf-4cc3-2540-08da269dc4d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5215
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch just adds INTx handling during runtime suspend/resume and
all the suspend/resume related code for the user to put device into
low power state will be added in subsequent patches.

The INTx are shared among devices. Whenever any INTx interrupt comes
for the vfio devices, then vfio_intx_handler() will be called for each
device. Inside vfio_intx_handler(), it calls pci_check_and_mask_intx()
and checks if the interrupt has been generated for the current device.
Now, if the device is already in D3cold state, then the config space
can not be read. Attempt to read config space in D3cold state can
cause system unresponsiveness in few systems. To Prevent this, mask
INTx in runtime suspend callback and unmask the same in runtime resume
callback. If INTx has been already masked, then no handling is needed
in runtime suspend/resume callbacks. 'pm_intx_masked' tracks this and
vfio_pci_intx_mask() has been updated to return true if INTx has been
masked inside this function.

For the runtime suspend which is triggered for the no user of vfio
device, the is_intx() will return false and these callbacks won't do
anything.

The MSI/MSI-X are not shared so no handling should be needed for
these. vfio_msihandler() triggers eventfd_signal() without doing any
device specific config access and when user receives this signal then
user tries to perform any config access or IOCTL, then the device will
be moved to D0 state first before servicing any request.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 35 +++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_intrs.c |  6 +++++-
 include/linux/vfio_pci_core.h     |  3 ++-
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index aee5e0cd6137..05a68ca9d9e7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -262,16 +262,43 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 }
 
 #ifdef CONFIG_PM
+static int vfio_pci_core_runtime_suspend(struct device *dev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
+
+	/*
+	 * If INTx is enabled, then mask INTx before going into runtime
+	 * suspended state and unmask the same in the runtime resume.
+	 * If INTx has already been masked by the user, then
+	 * vfio_pci_intx_mask() will return false and in that case, INTx
+	 * should not be unmasked in the runtime resume.
+	 */
+	vdev->pm_intx_masked = (is_intx(vdev) && vfio_pci_intx_mask(vdev));
+
+	return 0;
+}
+
+static int vfio_pci_core_runtime_resume(struct device *dev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
+
+	if (vdev->pm_intx_masked)
+		vfio_pci_intx_unmask(vdev);
+
+	return 0;
+}
+
 /*
- * The dev_pm_ops needs to be provided to make pci-driver runtime PM working,
- * so use structure without any callbacks.
- *
  * The pci-driver core runtime PM routines always save the device state
  * before going into suspended state. If the device is going into low power
  * state with only with runtime PM ops, then no explicit handling is needed
  * for the devices which have NoSoftRst-.
  */
-static const struct dev_pm_ops vfio_pci_core_pm_ops = { };
+static const struct dev_pm_ops vfio_pci_core_pm_ops = {
+	SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
+			   vfio_pci_core_runtime_resume,
+			   NULL)
+};
 #endif
 
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6069a11fb51a..1a37db99df48 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -33,10 +33,12 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 		eventfd_signal(vdev->ctx[0].trigger, 1);
 }
 
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+/* Returns true if INTx has been masked by this function. */
+bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
+	bool intx_masked = false;
 
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
@@ -60,9 +62,11 @@ void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 			disable_irq_nosync(pdev->irq);
 
 		vdev->ctx[0].masked = true;
+		intx_masked = true;
 	}
 
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	return intx_masked;
 }
 
 /*
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 3c7d65e68340..e84f31e44238 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -125,6 +125,7 @@ struct vfio_pci_core_device {
 	bool			nointx;
 	bool			needs_pm_restore;
 	bool			power_state_d3;
+	bool			pm_intx_masked;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
@@ -148,7 +149,7 @@ struct vfio_pci_core_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
-extern void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
+extern bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 extern void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
 extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
-- 
2.17.1

