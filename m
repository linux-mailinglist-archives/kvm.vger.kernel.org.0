Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C08249881C
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 19:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245164AbiAXSRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 13:17:55 -0500
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:26401
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235979AbiAXSRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 13:17:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8ti58uCR6gfMCUvdVBq9ucN/fZ1bJocRZe0Bou+m15ukMUlInTp1lJTndyfPeCeKBSRy7zphkYnDYMQ9rLtfpNoPua9qGfEg8Po21agOyDFOmapdN52i5veDCyQIF7h2iUaMXf8Xk62BpKcS5fzTQt3qGJ3G+2GbiTc62128YMtTHZRj9MPpUtWuQTR+zpib7euKzL/fogPg8eX1HH/8gLRB4gKk2iuszy6L+Aqu/bLXSPtOkiArcmhx/m000a1m/FgFYg82pt7x3xH8D1hB3ykvyZ0wb+C1ECQhrCDQNRDn+ZbY8tsHMxt51zcbkxkk4R+oHeXzCL40qIfrTTLVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFvtPRPnEp+41Zbi3/aZszS0oli6S3TWuL1J9gO87r4=;
 b=O1iuHhaXR4Uh+RRhwitNi7eq9a+nR/rBCWc30jISWjrTQkfGfoySEfdGF3jEKVaV2AhruDenhnC5/7gpeLEIOzOWyMke0DQBMn0dSNADyw4N/XhP/IQ8Jz6r/yXVqc9YjL/B7rv8Bteb9lDD8M6SI/gn2pVesiXndTRwBC5iClszsd/urLgT1rPm87+UQEK1zBrhWP1iKxnS6rYU1QCLH8kYipnhgl/vZUQBtspsyMtcw4ufgd8yrPqWBdMSj5DS42VXueYuw5owqpcKqmg5QbpGVm+LGvoHvfFaWskqX1Poc2LTmDtEA2mbb+XtNqIXOBhGFjtnZFrD1eMOs6Xc6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFvtPRPnEp+41Zbi3/aZszS0oli6S3TWuL1J9gO87r4=;
 b=HYjN56F4pVDUaKRRvPRCYhkyT1x6zTHV9O6RfRD4NpPtCaTfICimh5+IbzrNb48uUBv/tGDBFBf1D5s+HgfagijDZEO8L4NcRdfXPb9NJDW827Fev3UA47Y9CstSKNTX3ykkXk95PS3jAasjRGlv7lsLpogb6p3oWzDKH7oQEdacqUHX1zVo2pnIRv0e6QxF7NnH3dYyQFb4oPs1yKlP1UYc3i4mFeQRalPf9nYqFdztA9HLWzVJ6xe5BUlDm+MzekQbGfRNLO11c3K+uJCTJjHDpAzZupLL7L0M7peksDA0ImYzU5SDXRi3S6dP6C1md6Q1Vvo2EkBvzLbdNQpOqw==
Received: from DS7PR03CA0104.namprd03.prod.outlook.com (2603:10b6:5:3b7::19)
 by BN7PR12MB2833.namprd12.prod.outlook.com (2603:10b6:408:27::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Mon, 24 Jan
 2022 18:17:51 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::c3) by DS7PR03CA0104.outlook.office365.com
 (2603:10b6:5:3b7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Mon, 24 Jan 2022 18:17:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 18:17:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 18:17:50 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 10:17:49 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.13) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 24 Jan 2022 10:17:45 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC PATCH v2 3/5] vfio/pci: fix memory leak during D3hot to D0 tranistion
Date:   Mon, 24 Jan 2022 23:47:24 +0530
Message-ID: <20220124181726.19174-4-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124181726.19174-1-abhsahu@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 353910cb-8374-471f-9426-08d9df65d526
X-MS-TrafficTypeDiagnostic: BN7PR12MB2833:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2833C0079D284ED0B64F0D34CC5E9@BN7PR12MB2833.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8gq5TRHkM8cyov4z3Iij87hxvYvQEoYhhCuk2vBgSdmQxuydcY3mTLde9Yw7Qq4Ka91+phIj6uq161EuP+zNDdU7mKXTiOk9vM21IWHFC1GS5yoVeXu9BnlhgXbmAZmamZVr2U2xvHdDIy5fVWnyu9JYeKl++O1S88bOboXFvJbXOxsOiJkkyI49/MlWyCwUEFDyM0oAYYsgDdNZH1skmaz1cpE/VKB2N5AAQeoaM09RrE8Yhpa1b0nzPto/dof9cb9VYfBhOGe2j1LmBC9Cwqa9rG3n9WsMRyTLrpdECdXX/jv1qbLziD8ppfNNkW8NDtBCWUookoIir6dywHQXCtJoUF1T8vraBiYKYl0yor8vt2s6uUBIOPvOUpvQNGQb27gH3ULF8GS4pDiC2IfetXY49DpEidoX4YP8/ri4DVNJ+Y/duAeTWzPYtzKR3w6MMCa/+3OXG5KeOu8bZ/Qq2iI0Um5f1o92+ddeNLmKbjKytLUwRgTc96ovcYHuUSq+13xDFFzghGLJtgZasGE1Ec/qPSwlrXn1xwUkp/h0DaYC6odtYIiBmx3Ex5T8Vbpj9PMdVyHbobeQHqIJYLrfemvU3eSuDjiTuGlpFlA8dDazcvkoA3PDrx1R+kPWerJZrJGrFod6Fi8OyJqXZuQTPlcH2bG8Uu4N0Yh1SNYT/Ph7TLnbR0V7YorE+5i6AyliB2UFUMk4LWQrg3QSfXxVeNRHkXnloQTxZiJKShmG91gbjYz+g6yOoSeF4BFy5wE4Au05SQris4ckbpltcMPcV4qkCNhX8PELQrTOzBMVM62vOMaNLHyJm3suUQMxxynYUP13Fz2sHIfZ7I5zpUDcA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(36860700001)(4326008)(1076003)(70206006)(6666004)(316002)(110136005)(54906003)(107886003)(47076005)(36756003)(8676002)(81166007)(2906002)(26005)(70586007)(336012)(82310400004)(83380400001)(2616005)(356005)(426003)(86362001)(8936002)(40460700003)(508600001)(186003)(7696005)(5660300002)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 18:17:50.9152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 353910cb-8374-471f-9426-08d9df65d526
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2833
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
pm_save will never be freed.

Also, in malicious sequence, the state changing to D3hot followed by
VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be run in loop and
it can cause an OOM situation. This patch stores the power state locally
and uses the same for comparing the current power state. For the
places where D0 transition can happen, call vfio_pci_set_power_state()
to transition to D0 state. Since the vfio power state is still D3hot,
so this D0 transition will help in running the logic required
from D3hot->D0 transition. Also, to prevent any miss during
future development to detect this condition, this patch puts a
check and frees the memory after printing warning.

This locally saved power state will help in subsequent patches
also.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 53 ++++++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h    |  1 +
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c6e4fe9088c3..ee2fb8af57fa 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -206,6 +206,14 @@ static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
  * restore when returned to D0.  Saved separately from pci_saved_state for use
  * by PM capability emulation and separately from pci_dev internal saved state
  * to avoid it being overwritten and consumed around other resets.
+ *
+ * There are few cases where the PCI power state can be changed to D0
+ * without the involvement of this API. So, cache the power state locally
+ * and call this API to update the D0 state. It will help in running the
+ * logic that is needed for transitioning to the D0 state. For example,
+ * if needs_pm_restore is set, then the PCI state will be saved locally.
+ * The memory taken for saving this PCI state needs to be freed to
+ * prevent memory leak.
  */
 int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t state)
 {
@@ -214,20 +222,34 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	int ret;
 
 	if (vdev->needs_pm_restore) {
-		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
+		if (vdev->power_state < PCI_D3hot && state >= PCI_D3hot) {
 			pci_save_state(pdev);
 			needs_save = true;
 		}
 
-		if (pdev->current_state >= PCI_D3hot && state <= PCI_D0)
+		if (vdev->power_state >= PCI_D3hot && state <= PCI_D0)
 			needs_restore = true;
 	}
 
 	ret = pci_set_power_state(pdev, state);
 
 	if (!ret) {
+		vdev->power_state = pdev->current_state;
+
 		/* D3 might be unsupported via quirk, skip unless in D3 */
-		if (needs_save && pdev->current_state >= PCI_D3hot) {
+		if (needs_save && vdev->power_state >= PCI_D3hot) {
+			/*
+			 * If somehow, the vfio driver was not able to free the
+			 * memory allocated in pm_save, then free the earlier
+			 * memory first before overwriting pm_save to prevent
+			 * memory leak.
+			 */
+			if (vdev->pm_save) {
+				pci_warn(pdev,
+					 "Overwriting saved PCI state pointer so freeing the earlier memory\n");
+				kfree(vdev->pm_save);
+			}
+
 			vdev->pm_save = pci_store_saved_state(pdev);
 		} else if (needs_restore) {
 			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
@@ -326,6 +348,14 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	/* For needs_reset */
 	lockdep_assert_held(&vdev->vdev.dev_set->lock);
 
+	/*
+	 * If disable has been called while the power state is other than D0,
+	 * then set the power state in vfio driver to D0. It will help
+	 * in running the logic needed for D0 power state. The subsequent
+	 * runtime PM API's will put the device into the low power state again.
+	 */
+	vfio_pci_set_power_state(vdev, PCI_D0);
+
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
 
@@ -929,6 +959,15 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
 		ret = pci_try_reset_function(vdev->pdev);
+
+		/*
+		 * If pci_try_reset_function() has been called while the power
+		 * state is other than D0, then pci_try_reset_function() will
+		 * internally set the device state to D0 without vfio driver
+		 * interaction. Update the power state in vfio driver to perform
+		 * the logic needed for D0 power state.
+		 */
+		vfio_pci_set_power_state(vdev, PCI_D0);
 		up_write(&vdev->memory_lock);
 
 		return ret;
@@ -2071,6 +2110,14 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 err_undo:
 	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
+		/*
+		 * If pci_reset_bus() has been called while the power
+		 * state is other than D0, then pci_reset_bus() will
+		 * internally set the device state to D0 without vfio driver
+		 * interaction. Update the power state in vfio driver to perform
+		 * the logic needed for D0 power state.
+		 */
+		vfio_pci_set_power_state(cur, PCI_D0);
 		if (cur == cur_mem)
 			is_mem = false;
 		if (cur == cur_vma)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index aafe09c9fa64..05db838e72cc 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -124,6 +124,7 @@ struct vfio_pci_core_device {
 	bool			needs_reset;
 	bool			nointx;
 	bool			needs_pm_restore;
+	pci_power_t		power_state;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
-- 
2.17.1

