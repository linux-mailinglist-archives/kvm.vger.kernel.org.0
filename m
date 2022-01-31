Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DAA4A442D
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 12:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377774AbiAaL1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 06:27:07 -0500
Received: from mail-mw2nam10on2070.outbound.protection.outlook.com ([40.107.94.70]:38688
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359203AbiAaLZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 06:25:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFYL/95aMku4FGGWFcgFfl6vL7HFyUG8za1/BfzEk4rgxrFBoVZi3j8sAfH2hLSs9YoRzCiHDoEhnOUeRoxzcCJlo2oEF/OWAGaOZ/XxnAS+cVvsBs+LBQOF4D3qHswtb2zkbbVwMAvpko5BrAxDV2Hz/R5Xs6HGuFh1L9Yf7RF0Ic+2zehMPH2gHvSuemKyEs1YvUilfkWU7++GsQLBCGoxnGqiLeETe0BsRq9DduqYKFvQtilTZ0WbXcX3oSP3apH23Tv4CJhJ3HQ8agZqW8grqSbDACGq5XI1QkYRvOD5PwfYoU/mn9L/jY/Q+5x/5d0vyohWYF40FYCI6B5oVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s876+1dK77BYCktGuTctc+0JcsdTueCtus2V8K21N1E=;
 b=MAfgQH06gpwXkVnf2PqgAdXz4N3afPbrcs4sMfupUf0yyQmqdHOb/Bk/fNst8EYW4zamUhjO2NmQZviB36iE9TEFejUBYUo366qcKX68M5+m96CZMMpFhxSKIHuBAItPq4hpcaLHPxdVDrW57ceoIoJ3qI1cfKJ5FceKL+Mfr9MVh8dFS+q671Ggd/Fv+7DoRMRT9p5dA02lb7Y406vx3M6b5qfU7HRRWXbGAb+PGVtMJP7wItuHm23j8voQNYw3/XM7XpYGfc73E16Iiw8eCJF/Jqo9gkaBQhSPPm1JcdDYyZNOzl1/0MfVrk+XlutxygvusM2RnPdJyiRSpAvGMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s876+1dK77BYCktGuTctc+0JcsdTueCtus2V8K21N1E=;
 b=t+e4XkiZgxYfvVWjMrILDz65ASAqh+MOTOS6SdEsesYoCOCCzzrow5QP+vepZnAhqoE1ulAZv6+gGSPCwrarp9ZIcsQ9i2LRNjSsYwlv6JIc0mntHrHNMRC5wS9JO1/QRC4Failf6WMkAXfbJDwet+3KGpqZDXeEZpU6Nthwzz9M0f2Y4Rqot40gLvYaHRoBSAF36t/VH3MNZRtPQ+HJdfF9gdWSaftkRTeeipqmmz3GVhBflTI+DRr3EEVsTgVjgYOV2DTreU82z/t1au6J+wM5mO7r22J3srSloUC7+2W0gJ85sIPI4trmReGp6V5rOLr4YC+4Kt+Hva/Yfs7mdQ==
Received: from BN9PR03CA0119.namprd03.prod.outlook.com (2603:10b6:408:fd::34)
 by BYAPR12MB2983.namprd12.prod.outlook.com (2603:10b6:a03:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 11:25:01 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::dd) by BN9PR03CA0119.outlook.office365.com
 (2603:10b6:408:fd::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Mon, 31 Jan 2022 11:25:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 11:25:00 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 31 Jan 2022 11:24:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 31 Jan 2022 03:24:59 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 31 Jan 2022 03:24:55 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v2] vfio/pci: fix memory leak during D3hot to D0 transition
Date:   Mon, 31 Jan 2022 16:54:50 +0530
Message-ID: <20220131112450.3550-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c95a13ef-5852-4978-21b9-08d9e4ac51dd
X-MS-TrafficTypeDiagnostic: BYAPR12MB2983:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB298304D9686DE123D9917EEFCC259@BYAPR12MB2983.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDVUmTu0WbnFjxrUa4BiDHDly2NoIeDI53nS2wmAscRgEBpAsBFfyjTh1CS+uJ7dOF5zmPn9eoPEPbSxH8geXvU3h/IkLTAaHS2ZRhe9+F3LLpAiHfWeoJ/Tqwa9/CIyBF16cklvzo8K7q5V5EPdzCKKc1hAxpJX4yEYOHYnWwf3B+niSyBulu50yehytGPpRWiqtVsDU91zU7G8kB8wprQtUOmRP2nQ6UX3QqkL7k5fvbQVyYSYtEv7DYEFZm4OHA3bEyLrRqHJBL2xaED7ZjZCO1/qhJ8Mr4Se8I9s3qKlBCVuYQvdplRXMIY0dSYS1ki+b4T2z7AxHdbvXZ6BTCoOqcGi1/OF/Z0HFmJ2rAMjAzlNEXp3EBLPQH6U9cYBG4kYQT11zuBNqqqOkmP7o7i8919EByeIz8SsXe2MdbRYMG8x7NhOo/poIeuJ25ZbVqYglGyyR5vsUDPDY4k7BjeHUvNZwATfoqloUj5BgeIiWr0Q3u2qDy8AfggTLPao9/38C/A8DTJPGYbFi0DZRcSA9FuEbChcId0f0AMwDw262J5VI0LWK1F3w4qr3ks6kGEWuxatQwy5JyxSL1ESlAcS7v44LTrUvfcf/4b2gYxR5TP968Qx93Nca1W6BIftFm7ayKfPcBp5syMnU/f49nn8GoWqwtcWpwlJ5/pAXlwQ0SwSrOU/pYLR43KB1gaqciab1OwgNT09wEznFK+9wTKHD8VdW3TWEkpAH//xzuoAW3BUWdHi32L2kH+Kp+4khUVWJsLcFwJh3UM3LzJGtvOhkE7BYxy8hIXVr3E0FpaLCNE3LddNXUW+yXB7Wt/F
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(107886003)(356005)(5660300002)(2616005)(81166007)(336012)(36756003)(1076003)(40460700003)(186003)(426003)(2906002)(26005)(8936002)(8676002)(4326008)(70586007)(70206006)(36860700001)(316002)(86362001)(83380400001)(110136005)(82310400004)(508600001)(54906003)(7696005)(6666004)(966005)(47076005)(32563001)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 11:25:00.7027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c95a13ef-5852-4978-21b9-08d9e4ac51dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2983
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If needs_pm_restore is set (PCI device does not have support for no
soft reset), then the current PCI state will be saved during D0->D3hot
transition and same will be restored back during D3hot->D0 transition.
For saving the PCI state locally, pci_store_saved_state() is being
used and the pci_load_and_free_saved_state() will free the allocated
memory.

But for reset related IOCTLs, vfio driver calls PCI reset related
API's which will internally change the PCI power state back to D0. So,
when the guest resumes, then it will get the current state as D0 and it
will skip the call to vfio_pci_set_power_state() for changing the
power state to D0 explicitly. In this case, the memory pointed by
pm_save will never be freed. In a malicious sequence, the state changing
to D3hot followed by VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be
run in a loop and it can cause an OOM situation.

Also, pci_pm_reset() returns -EINVAL if we try to reset a device that
isn't currently in D0. Therefore any path where we're triggering a
function reset that could use a PM reset and we don't know if the device
is in D0, should wake up the device before we try that reset.

This patch changes the device power state to D0 by invoking
vfio_pci_set_power_state() before calling reset related API's.
It will help in fixing the mentioned memory leak and making sure
that the device is in D0 during reset. Also, to prevent any similar
memory leak for future development, this patch frees memory first
before overwriting 'pm_save'.

Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---

* Changes in v2

- Add the Fixes tag and sent this patch independently. 
- Invoke vfio_pci_set_power_state() before invoking reset related API's.
- Removed saving of power state locally.
- Removed warning before 'kfree(vdev->pm_save)'.
- Updated comments and commit message according to updated changes.

* v1 of this patch was sent in 
https://lore.kernel.org/lkml/20220124181726.19174-4-abhsahu@nvidia.com/

 drivers/vfio/pci/vfio_pci_core.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f948e6cd2993..d6dd4f7c4b2c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -228,6 +228,13 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	if (!ret) {
 		/* D3 might be unsupported via quirk, skip unless in D3 */
 		if (needs_save && pdev->current_state >= PCI_D3hot) {
+			/*
+			 * If somehow, the vfio driver was not able to free the
+			 * memory allocated in pm_save, then free the earlier
+			 * memory first before overwriting pm_save to prevent
+			 * memory leak.
+			 */
+			kfree(vdev->pm_save);
 			vdev->pm_save = pci_store_saved_state(pdev);
 		} else if (needs_restore) {
 			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
@@ -322,6 +329,12 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	/* For needs_reset */
 	lockdep_assert_held(&vdev->vdev.dev_set->lock);
 
+	/*
+	 * This function can be invoked while the power state is non-D0,
+	 * Change the device power state to D0 first.
+	 */
+	vfio_pci_set_power_state(vdev, PCI_D0);
+
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
 
@@ -921,6 +934,13 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			return -EINVAL;
 
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
+
+		/*
+		 * This function can be invoked while the power state is non-D0,
+		 * Change the device power state to D0 before doing reset.
+		 */
+		vfio_pci_set_power_state(vdev, PCI_D0);
+
 		ret = pci_try_reset_function(vdev->pdev);
 		up_write(&vdev->memory_lock);
 
@@ -2055,6 +2075,13 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	}
 	cur_mem = NULL;
 
+	/*
+	 * This function can be invoked while the power state is non-D0.
+	 * Change power state of all devices to D0 before doing reset.
+	 */
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
+		vfio_pci_set_power_state(cur, PCI_D0);
+
 	ret = pci_reset_bus(pdev);
 
 err_undo:
-- 
2.17.1

