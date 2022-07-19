Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D0D579C9B
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 14:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241086AbiGSMlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 08:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241403AbiGSMjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 08:39:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D545545E7;
        Tue, 19 Jul 2022 05:15:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INNYXnIAxXAUuGih59h8Fnt6cIBnAswmEG5Dq1BifgwTNmVSYvLgxy+fRLKeOPk+Ycy6XnZ2Y9mpfVqfVpyzQM3zyeHZxf2IS3ycII0arAJ8e3wR4fjy0DWwu/0oA0yqwmKVLBHzbEL06aPiUAuqc/sCBdhs0dktYpX9f9pYpfNXU64PTKhchxZgrE8QhKfinPTgehwMbehIum37nhRw3zAcPA53G1E1uUR1CtaSD+Ic8bSo+E7i+QaY2l0Wx0bcYMeuyDxBKSEM70EnJ+Do2nLYMHCbp3va8CP5cT1g7tjBsD5dEM9MKypH39R/m9vaeTQD9Std3FQ6ZJH7xx4g1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUBeeaLGxq/Xwo/lBPoSj+vhPbYiJD+Zg7S1FgXRUt0=;
 b=XCnwYs7HWvQvbA052+jkcN+ZI2S/tj+EvknMDy1k7CUEDaT9cVmZ66idROfKnGC2xmiAwHP5alLjjeYOl/o0xKGa4HErDfvZz7r9p5y2As8PYRdrPVtOcSP7fQicq0JMSQaZF9s0sW9PozCbrP1s63ij/FNoBwOxfYJLwaGs36h5t4DhF3sGs2Ei64OZrluPxqK24rlSk4ODNmFUe8elghYQ1KUx+869OrsktEokOsxp6190/+wlPF+bP7yMptRV8uJi0kRFcAsbH1MPfd1ZoB5vOyuS8kqjEPn4E3D2nZvsOm9RaNQdiNzehzc/P4TOV6BBKCfmPoxYuaK8jglNJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUBeeaLGxq/Xwo/lBPoSj+vhPbYiJD+Zg7S1FgXRUt0=;
 b=MICFkjDhFG37numaYWu8PQe04CKpJaf1YJWufJl1aN4Ukudz+n0KQNEgrYMEMtyvqDvr4yD7MBhv8E202ZT9cYT3XdO8gr4QqQ9Ue32o/fuMpKZbMKFfSi0Pod6qDhI6/s/cFKppDM2m1NcrXg5nP6sYh85654rnLKiyjpUXqjJHIUYzesRuIp6GMoPjosBeGnGa3uMSyA8ZGA5YJV57D9ZZSiRqKw9Kh52Cu00e4vJxJbp0EHV14dZHuxdGLS3zThsROIhCc0PSOkVsyc2Wm0/tyfbmWuH8K2VWGHplJqFNl2i87gx6SxdOjZZYvOM7So8jKod0n8SMm+MiMMhrSg==
Received: from MW4PR03CA0230.namprd03.prod.outlook.com (2603:10b6:303:b9::25)
 by MW3PR12MB4555.namprd12.prod.outlook.com (2603:10b6:303:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Tue, 19 Jul
 2022 12:15:57 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::62) by MW4PR03CA0230.outlook.office365.com
 (2603:10b6:303:b9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20 via Frontend
 Transport; Tue, 19 Jul 2022 12:15:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 12:15:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Jul 2022 12:15:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 19 Jul 2022 05:15:54 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 19 Jul 2022 05:15:49 -0700
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
Subject: [PATCH v5 3/5] vfio/pci: Mask INTx during runtime suspend
Date:   Tue, 19 Jul 2022 17:45:21 +0530
Message-ID: <20220719121523.21396-4-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719121523.21396-1-abhsahu@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45286d23-8b18-4455-0d1e-08da69806f61
X-MS-TrafficTypeDiagnostic: MW3PR12MB4555:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXAEQoH0/V329zeHLQ09Ydn5C4YeZZDpSnu5vOUvQIAL58z6+3iGyTCXlIszEly1N9trGq2SpmQ4QVty0AFFisXRGULqM0lme7OLh4tAhG2mu3WwLdXYJK/3XUvdb+IW9yXCPupmNJYRC1xirLUiFsrfaZnkMoP/ZvCVDpoetA65cO37IL2bZoEilCP07HRWAiPD0pjkT9SjMMid1qMmDn59FWiAXHIXCnj9gV6/xhdIaRvllAAcpYnjtEPsdZS7kXMyEqJrR8rSA9a0bvY79JG0KeUHqrt9r5S5xgZ5yg3ARYLGNBzGGJWW+/B2ARbFokBOvUwIbG2deOnileZQK/G+gpsIqw9GEIIsIF67pChDlXWH4GmNIPEdJsD8GXRrXAp9oU5dTSY8qNrdEZXTplDz0XWdwAsdiub0OkF8zoE3wfH3CHsz/EXt+C6xdLnd3iI4pn3XFycLilKEIs6T0bh476J7xVqlpjEbuJC7kuqJBbVv3ZgUceVKLAKL+TWwL4zRpA+xslI3NFL2LxY6f98Za9xEcsZdKT36gIoWOxr7jJAw+enfCXbH3QCLeHR0qzzoBS2ysonaJ1V7H4SLATS5A4mAPcVnRbAbA/JPHZyItaum01YU9lUW92JaSrW6HZQl4YQ1kaz5GZcqkxUHs8zF4xKREz0+OgbSYyUb9t3fLvf4aaeFpigUioYPFgG735cfUD/Dy44gs261fXT4DFGMNOPhV9QAnhD1u/sh2XhPvM/if+1Dxhd6SI2m7P73n5PpnHy22IiGeXQ9QY4hPqGB7FLaXGmBkUBhq0on7BE4WzjLAM7sVzeDyIyjbFUlfBImYyu45vTnHI6Y4mZM3g==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(396003)(346002)(36840700001)(46966006)(40470700004)(70206006)(15650500001)(70586007)(26005)(8676002)(40460700003)(4326008)(83380400001)(478600001)(82740400003)(40480700001)(7416002)(36860700001)(356005)(8936002)(5660300002)(7696005)(41300700001)(2906002)(81166007)(1076003)(86362001)(6666004)(107886003)(316002)(36756003)(186003)(54906003)(82310400005)(47076005)(110136005)(426003)(336012)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 12:15:57.0614
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45286d23-8b18-4455-0d1e-08da69806f61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4555
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds INTx handling during runtime suspend/resume.
All the suspend/resume related code for the user to put the device
into the low power state will be added in subsequent patches.

The INTx lines may be shared among devices. Whenever any INTx
interrupt comes for the VFIO devices, then vfio_intx_handler() will be
called for each device sharing the interrupt. Inside vfio_intx_handler(),
it calls pci_check_and_mask_intx() and checks if the interrupt has
been generated for the current device. Now, if the device is already
in the D3cold state, then the config space can not be read. Attempt
to read config space in D3cold state can cause system unresponsiveness
in a few systems. To prevent this, mask INTx in runtime suspend callback,
and unmask the same in runtime resume callback. If INTx has been already
masked, then no handling is needed in runtime suspend/resume callbacks.
'pm_intx_masked' tracks this, and vfio_pci_intx_mask() has been updated
to return true if the INTx vfio_pci_irq_ctx.masked value is changed
inside this function.

For the runtime suspend which is triggered for the no user of VFIO
device, the is_intx() will return false and these callbacks won't do
anything.

The MSI/MSI-X are not shared so similar handling should not be
needed for MSI/MSI-X. vfio_msihandler() triggers eventfd_signal()
without doing any device-specific config access. When the user performs
any config access or IOCTL after receiving the eventfd notification,
then the device will be moved to the D0 state first before
servicing any request.

Another option was to check this flag 'pm_intx_masked' inside
vfio_intx_handler() instead of masking the interrupts. This flag
is being set inside the runtime_suspend callback but the device
can be in non-D3cold state (for example, if the user has disabled D3cold
explicitly by sysfs, the D3cold is not supported in the platform, etc.).
Also, in D3cold supported case, the device will be in D0 till the
PCI core moves the device into D3cold. In this case, there is
a possibility that the device can generate an interrupt. Adding check
in the IRQ handler will not clear the IRQ status and the interrupt
line will still be asserted. This can cause interrupt flooding.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 37 +++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_intrs.c |  6 ++++-
 include/linux/vfio_pci_core.h     |  3 ++-
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 2efa06b1fafa..9517645acfa6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -259,16 +259,45 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static int vfio_pci_core_runtime_suspend(struct device *dev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
+
+	/*
+	 * If INTx is enabled, then mask INTx before going into the runtime
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
+#endif /* CONFIG_PM */
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
 
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6069a11fb51a..8b805d5d19e1 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -33,10 +33,12 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 		eventfd_signal(vdev->ctx[0].trigger, 1);
 }
 
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+/* Returns true if the INTx vfio_pci_irq_ctx.masked value is changed. */
+bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
+	bool masked_changed = false;
 
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
@@ -60,9 +62,11 @@ void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 			disable_irq_nosync(pdev->irq);
 
 		vdev->ctx[0].masked = true;
+		masked_changed = true;
 	}
 
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	return masked_changed;
 }
 
 /*
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 22de2bce6394..e96cc3081236 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -124,6 +124,7 @@ struct vfio_pci_core_device {
 	bool			needs_reset;
 	bool			nointx;
 	bool			needs_pm_restore;
+	bool			pm_intx_masked;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
@@ -147,7 +148,7 @@ struct vfio_pci_core_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
+bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
-- 
2.17.1

