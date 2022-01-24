Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50359498822
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 19:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241748AbiAXSSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 13:18:11 -0500
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:16224
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245214AbiAXSSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 13:18:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkLFO/XiXgtOJ7k9co6xl4lWHKtfTlrMwu1QTfSDAuJXWUkkz7Q9YXcQt51h+RQw7sjnDiHn3tBJLuCWfQy7JB7NjjzvFtub37GjkfOIr/75/c+mfMiQEvKt+e8htDa0gICXT9Q30NGufWmUN8DSPBarrjDMvUR7amWrubxC7jxvKDKnkaA/xWD/MLKefnddniszIiW+o7FDtlIF6p9ejl+oCwfzcww/xkU3nhvKpvZ/QsaSt7AR5hGv6wgeZxdNPyQCtOC8Sp/SxwZaPIQBXCzsJ6CkWPd5in2ActzbIfKx6p9JBfYykSdm+k4b4xTrlV3Q5gXjUi2gWp3qIrt6Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kMmK440KY1hsngBEDOmuALB/c01GhuWzXRykEI4+88=;
 b=OkK5WwAHLc2EViVANl9FfsoeA+agsP+mZ+HqHVaDYMgKlnO334pBK7s4AnRaxji9srHbT7ByePbhEv5JgaHXgTKKyW3BCFg7psSgWyUj5lO5zZsOnc5qfqAXuhrxY9E/YX3QdTCM54jm4wABPkxqoZeBAk+Oj3IMDu0d53e2sEiRL8Uv/YEv1eTdQfXVvzvodN5W2EtdppVlVy5wnn9RhUqjapd+9B2Ya/2KX37EDwVrbhNtjVDdoK+0YquTOTqFaOi7LaUJ+8ecex6cHuPgtPqlgiEmSjkpyMWm3+85LpixJksOEpukC292BmR3DOzxO186freVhW2YIBOdOA02Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kMmK440KY1hsngBEDOmuALB/c01GhuWzXRykEI4+88=;
 b=nDnyuxvsmX5sARaZsMor5DwhgpuTrJv8Qsayu0NmrcPnq90dIOp0/b0JIBsOgltSv2bcTQWwM0bArTLAhK9yOUyoVTY3A1nabXDbqm7jBWv0lTAEybWsjs5QPiC0rEFgmgMuBOWoDwGhXMY7uedri3buVqjVTP6Y65JT4cUPimaQxTa7s3ItdwHHxWZ7ZgxALrm7L235E5XZxCrOSJlvEYXkfD1zMOwqjythKXRusJAj1LbMSBdLfBzlPvNcFqn/R4Yd0GUTCvfUs39Z7Ilrx2HpJjtF4bP5uSvrzxrJTWpqD+wJY4lQO4wAWxhnu64Qe60xPNQU7Q/rL7rkMK4ecQ==
Received: from DM5PR19CA0035.namprd19.prod.outlook.com (2603:10b6:3:9a::21) by
 BY5PR12MB3714.namprd12.prod.outlook.com (2603:10b6:a03:1a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 18:18:00 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:9a:cafe::58) by DM5PR19CA0035.outlook.office365.com
 (2603:10b6:3:9a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Mon, 24 Jan 2022 18:17:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 18:17:59 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 18:17:58 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 10:17:58 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.13) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 24 Jan 2022 10:17:54 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC PATCH v2 5/5] vfio/pci: add the support for PCI D3cold state
Date:   Mon, 24 Jan 2022 23:47:26 +0530
Message-ID: <20220124181726.19174-6-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124181726.19174-1-abhsahu@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95bf5bc7-0111-4245-456a-08d9df65da17
X-MS-TrafficTypeDiagnostic: BY5PR12MB3714:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB371461A16E6ABA496DF57692CC5E9@BY5PR12MB3714.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWaEARxNJt4PGCQX9UND3JnFkm80lqTfbpbOFpg3Lf+dt9q01Zlob2z+42wY7ECvuJNQPp+cEaz6pY5yKsjoKyeRpPISdAK3ycatH2Io3AgcHZ44TbPZfFx96LvDQ6FU59AFUPSONZecXCazSAIimDiCWICQsj5CWBQe8bPSwhqmSavhcjr5w7pUBXbhc1H26GkWUaOR0TRKF2fdW+0AlbLLGSi19UbwvMmet3tzJdAZvQ4wgB/u77VLgXRVI/qNeHPcs1hUfe1aOF0Kbzwow2b0Q1GEtmOFei92I3G5YB0i2eEFRcOnTCerfFuY0rPqSV2OAJ1ZAv4YVRhoMV2CDklhFLexDq58cxjwRxBLVwrt3qceQXpjTERlXn/bv4jwhCKw8ggXPXvVyFo92RrP4Rl/wgv/ZiRVNYWpJ6KBuEjbBzoLfBDQhY4X+/XKDTB59LbeMyqiNp4rbBlGQUCgp3dtYbcNK+Kw7EEjF2G304AWp2T2QgbQ+bxbZ53rXO24QV4EwoN/khG6rruRZ+vOsj9YqUOvfKGUl0OWPUnHGa3tN07lu2G5Ne+DnfINsIDO46bxtoySNDI7MIVwt0RAQ5IeCcirOiLjfWtvdNr+O3fRaMcc0Rp6m7X2ttgfkweBl8YPSA4oDyb6u2XZW9JbBRdmG72SqypwtovDTaW5J1P1Go3lkOk0dinSNPrSBaaK6Y06qsrMTMKLkAZQbwK/YZPHNJ2AG5oL1+tzqHZgTBbcUJdTiikrUmcHxXEsiazQF6F59BgIX+q1ya5z8enL0HZNM0dToebnhkzDGxc7D5dS1D6rbg4fQWHfVv3JCaeetDQNiX8hqBXvq/Wu3Hxoxw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700004)(46966006)(2906002)(40460700003)(107886003)(508600001)(8676002)(426003)(30864003)(5660300002)(86362001)(4326008)(36860700001)(7696005)(26005)(81166007)(82310400004)(2616005)(356005)(83380400001)(6666004)(1076003)(336012)(36756003)(316002)(70206006)(70586007)(47076005)(8936002)(110136005)(186003)(54906003)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 18:17:59.1566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95bf5bc7-0111-4245-456a-08d9df65da17
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3714
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, if the runtime power management is enabled for vfio-pci
device in the guest OS, then guest OS will do the register write for
PCI_PM_CTRL register. This write request will be handled in
vfio_pm_config_write() where it will do the actual register write
of PCI_PM_CTRL register. With this, the maximum D3hot state can be
achieved for low power. If we can use the runtime PM framework,
then we can achieve the D3cold state which will help in saving
maximum power.

1. Since D3cold state can't be achieved by writing PCI standard
   PM config registers, so this patch adds a new IOCTL which change the
   PCI device from D3hot to D3cold state and then D3cold to D0 state.

2. The hypervisors can implement virtual ACPI methods. For
   example, in guest linux OS if PCI device ACPI node has _PR3 and _PR0
   power resources with _ON/_OFF method, then guest linux OS makes the
   _OFF call during D3cold transition and then _ON during D0 transition.
   The hypervisor can tap these virtual ACPI calls and then do the D3cold
   related IOCTL in the vfio driver.

3. The vfio driver uses runtime PM framework to achieve the
   D3cold state. For the D3cold transition, decrement the usage count and
   during D0 transition increment the usage count.

4. For D3cold, the device current power state should be D3hot.
   Then during runtime suspend, the pci_platform_power_transition() is
   required for D3cold state. If the D3cold state is not supported, then
   the device will still be in D3hot state. But with the runtime PM, the
   root port can now also go into suspended state.

5. For most of the systems, the D3cold is supported at the root
   port level. So, when root port will transition to D3cold state, then
   the vfio PCI device will go from D3hot to D3cold state during its
   runtime suspend. If root port does not support D3cold, then the root
   will go into D3hot state.

6. The runtime suspend callback can now happen for 2 cases: there
   is no user of vfio device and the case where user has initiated
   D3cold. The 'runtime_suspend_pending' flag can help to distinguish
   this case.

7. There are cases where guest has put PCI device into D3cold
   state and then on the host side, user has run lspci or any other
   command which requires access of the PCI config register. In this case,
   the kernel runtime PM framework will resume the PCI device internally,
   read the config space and put the device into D3cold state again. Some
   PCI device needs the SW involvement before going into D3cold state.
   For the first D3cold state, the driver running in guest side does the SW
   side steps. But the second D3cold transition will be without guest
   driver involvement. So, prevent this second d3cold transition by
   incrementing the device usage count. This will make the device
   unnecessary in D0 but it's better than failure. In future, we can some
   mechanism by which we can forward these wake-up request to guest and
   then the mentioned case can be handled also.

8. In D3cold, all kind of BAR related access needs to be disabled
   like D3hot. Additionally, the config space will also be disabled in
   D3cold state. To prevent access of config space in the D3cold state,
   increment the runtime PM usage count before doing any config space
   access. Also, most of the IOCTLs do the config space access, so
   maintain one safe list and skip the resume only for these safe IOCTLs
   alone. For other IOCTLs, the runtime PM usage count will be
   incremented first.

9. Now, runtime suspend/resume callbacks need to get the vdev
   reference which can be obtained by dev_get_drvdata(). Currently, the
   dev_set_drvdata() is being set after returning from
   vfio_pci_core_register_device(). The runtime callbacks can come
   anytime after enabling runtime PM so dev_set_drvdata() must happen
   before that. We can move dev_set_drvdata() inside
   vfio_pci_core_register_device() itself.

10. The vfio device user can close the device after putting
    the device into runtime suspended state so inside
    vfio_pci_core_disable(), increment the runtime PM usage count.

11. Runtime PM will be possible only if CONFIG_PM is enabled on
    the host. So, the IOCTL related code can be put under CONFIG_PM
    Kconfig.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c        |   1 -
 drivers/vfio/pci/vfio_pci_config.c |  11 +-
 drivers/vfio/pci/vfio_pci_core.c   | 186 +++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h      |   1 +
 include/uapi/linux/vfio.h          |  21 ++++
 5 files changed, 211 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index c8695baf3b54..4ac3338c8fc7 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -153,7 +153,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = vfio_pci_core_register_device(vdev);
 	if (ret)
 		goto out_free;
-	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_free:
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index dd9ed211ba6f..d20420657959 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -25,6 +25,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/vfio_pci_core.h>
 
@@ -1919,16 +1920,23 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
 ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
+	struct device *dev = &vdev->pdev->dev;
 	size_t done = 0;
 	int ret = 0;
 	loff_t pos = *ppos;
 
 	pos &= VFIO_PCI_OFFSET_MASK;
 
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
 	while (count) {
 		ret = vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put(dev);
 			return ret;
+		}
 
 		count -= ret;
 		done += ret;
@@ -1936,6 +1944,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		pos += ret;
 	}
 
+	pm_runtime_put(dev);
 	*ppos += done;
 
 	return done;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 38440d48973f..b70bb4fd940d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -371,12 +371,23 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	lockdep_assert_held(&vdev->vdev.dev_set->lock);
 
 	/*
-	 * If disable has been called while the power state is other than D0,
-	 * then set the power state in vfio driver to D0. It will help
-	 * in running the logic needed for D0 power state. The subsequent
-	 * runtime PM API's will put the device into the low power state again.
+	 * The vfio device user can close the device after putting the device
+	 * into runtime suspended state so wake up the device first in
+	 * this case.
 	 */
-	vfio_pci_set_power_state_locked(vdev, PCI_D0);
+	if (vdev->runtime_suspend_pending) {
+		vdev->runtime_suspend_pending = false;
+		pm_runtime_resume_and_get(&pdev->dev);
+	} else {
+		/*
+		 * If disable has been called while the power state is other
+		 * than D0, then set the power state in vfio driver to D0. It
+		 * will help in running the logic needed for D0 power state.
+		 * The subsequent runtime PM API's will put the device into
+		 * the low power state again.
+		 */
+		vfio_pci_set_power_state_locked(vdev, PCI_D0);
+	}
 
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
@@ -693,8 +704,8 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
-long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
-		unsigned long arg)
+static long vfio_pci_core_ioctl_internal(struct vfio_device *core_vdev,
+					 unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1241,10 +1252,119 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		default:
 			return -ENOTTY;
 		}
+#ifdef CONFIG_PM
+	} else if (cmd == VFIO_DEVICE_POWER_MANAGEMENT) {
+		struct vfio_power_management vfio_pm;
+		struct pci_dev *pdev = vdev->pdev;
+		bool request_idle = false, request_resume = false;
+		int ret = 0;
+
+		if (copy_from_user(&vfio_pm, (void __user *)arg, sizeof(vfio_pm)))
+			return -EFAULT;
+
+		/*
+		 * The vdev power related fields are protected with memory_lock
+		 * semaphore.
+		 */
+		down_write(&vdev->memory_lock);
+		switch (vfio_pm.d3cold_state) {
+		case VFIO_DEVICE_D3COLD_STATE_ENTER:
+			/*
+			 * For D3cold, the device should already in D3hot
+			 * state.
+			 */
+			if (vdev->power_state < PCI_D3hot) {
+				ret = EINVAL;
+				break;
+			}
+
+			if (!vdev->runtime_suspend_pending) {
+				vdev->runtime_suspend_pending = true;
+				pm_runtime_put_noidle(&pdev->dev);
+				request_idle = true;
+			}
+
+			break;
+
+		case VFIO_DEVICE_D3COLD_STATE_EXIT:
+			/*
+			 * If the runtime resume has already been run, then
+			 * the device will be already in D0 state.
+			 */
+			if (vdev->runtime_suspend_pending) {
+				vdev->runtime_suspend_pending = false;
+				pm_runtime_get_noresume(&pdev->dev);
+				request_resume = true;
+			}
+
+			break;
+
+		default:
+			ret = EINVAL;
+			break;
+		}
+
+		up_write(&vdev->memory_lock);
+
+		/*
+		 * Call the runtime PM API's without any lock. Inside vfio driver
+		 * runtime suspend/resume, the locks can be acquired again.
+		 */
+		if (request_idle)
+			pm_request_idle(&pdev->dev);
+
+		if (request_resume)
+			pm_runtime_resume(&pdev->dev);
+
+		return ret;
+#endif
 	}
 
 	return -ENOTTY;
 }
+
+long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+			 unsigned long arg)
+{
+#ifdef CONFIG_PM
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct device *dev = &vdev->pdev->dev;
+	bool skip_runtime_resume = false;
+	long ret;
+
+	/*
+	 * The list of commands which are safe to execute when the PCI device
+	 * is in D3cold state. In D3cold state, the PCI config or any other IO
+	 * access won't work.
+	 */
+	switch (cmd) {
+	case VFIO_DEVICE_POWER_MANAGEMENT:
+	case VFIO_DEVICE_GET_INFO:
+	case VFIO_DEVICE_FEATURE:
+		skip_runtime_resume = true;
+		break;
+
+	default:
+		break;
+	}
+
+	if (!skip_runtime_resume) {
+		ret = pm_runtime_resume_and_get(dev);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
+
+	if (!skip_runtime_resume)
+		pm_runtime_put(dev);
+
+	return ret;
+#else
+	return vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
+#endif
+}
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
 static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
@@ -1897,6 +2017,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		return -EBUSY;
 	}
 
+	dev_set_drvdata(&pdev->dev, vdev);
 	if (pci_is_root_bus(pdev->bus)) {
 		ret = vfio_assign_device_set(&vdev->vdev, vdev);
 	} else if (!pci_probe_reset_slot(pdev->slot)) {
@@ -1966,6 +2087,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 		pm_runtime_get_noresume(&pdev->dev);
 
 	pm_runtime_forbid(&pdev->dev);
+	dev_set_drvdata(&pdev->dev, NULL);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
@@ -2219,11 +2341,61 @@ static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
 #ifdef CONFIG_PM
 static int vfio_pci_core_runtime_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
+
+	down_read(&vdev->memory_lock);
+
+	/*
+	 * runtime_suspend_pending won't be set if there is no user of vfio pci
+	 * device. In that case, return early and PCI core will take care of
+	 * putting the device in the low power state.
+	 */
+	if (!vdev->runtime_suspend_pending) {
+		up_read(&vdev->memory_lock);
+		return 0;
+	}
+
+	/*
+	 * The runtime suspend will be called only if device is already at
+	 * D3hot state. Now, change the device state from D3hot to D3cold by
+	 * using platform power management. If setting of D3cold is not
+	 * supported for the PCI device, then the device state will still be
+	 * in D3hot state. The PCI core expects to save the PCI state, if
+	 * driver runtime routine handles the power state management.
+	 */
+	pci_save_state(pdev);
+	pci_platform_power_transition(pdev, PCI_D3cold);
+	up_read(&vdev->memory_lock);
+
 	return 0;
 }
 
 static int vfio_pci_core_runtime_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
+
+	down_write(&vdev->memory_lock);
+
+	/*
+	 * The PCI core will move the device to D0 state before calling the
+	 * driver runtime resume.
+	 */
+	vfio_pci_set_power_state_locked(vdev, PCI_D0);
+
+	/*
+	 * Some PCI device needs the SW involvement before going to D3cold
+	 * state again. So if there is any wake-up which is not triggered
+	 * by the guest, then increase the usage count to prevent the
+	 * second runtime suspend.
+	 */
+	if (vdev->runtime_suspend_pending) {
+		vdev->runtime_suspend_pending = false;
+		pm_runtime_get_noresume(&pdev->dev);
+	}
+
+	up_write(&vdev->memory_lock);
 	return 0;
 }
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 05db838e72cc..8bbfd028115a 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -124,6 +124,7 @@ struct vfio_pci_core_device {
 	bool			needs_reset;
 	bool			nointx;
 	bool			needs_pm_restore;
+	bool			runtime_suspend_pending;
 	pci_power_t		power_state;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..7b7dadc6df71 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1002,6 +1002,27 @@ struct vfio_device_feature {
  */
 #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
 
+/**
+ * VFIO_DEVICE_POWER_MANAGEMENT - _IOW(VFIO_TYPE, VFIO_BASE + 18,
+ *			       struct vfio_power_management)
+ *
+ * Provide the support for device power management.  The native PCI power
+ * management does not support the D3cold power state.  For moving the device
+ * into D3cold state, change the PCI state to D3hot with standard
+ * configuration registers and then call this IOCTL to setting the D3cold
+ * state.  Similarly, if the device in D3cold state, then call this IOCTL
+ * to exit from D3cold state.
+ *
+ * Return 0 on success, -errno on failure.
+ */
+#define VFIO_DEVICE_POWER_MANAGEMENT		_IO(VFIO_TYPE, VFIO_BASE + 18)
+struct vfio_power_management {
+	__u32	argsz;
+#define VFIO_DEVICE_D3COLD_STATE_EXIT		0x0
+#define VFIO_DEVICE_D3COLD_STATE_ENTER		0x1
+	__u32	d3cold_state;
+};
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.17.1

