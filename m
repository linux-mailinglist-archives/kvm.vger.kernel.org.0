Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01364498820
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 19:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245244AbiAXSSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 13:18:06 -0500
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:3809
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245189AbiAXSR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 13:17:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbL28qvhxzhNCaRTt6uyY+j8hxieFcEM2Rqy+jjPZFTjCu3/VR4fkVSHbbVneFcvQri+iCklSWdyLWBFo9yH9RMloR+J+qIwloYnCBf9Cxxqtpb819ZUe2G4jMFEwTtGJOsfuK0SgOeVGqQ24LbW5hBgUmlodIdhhS7jHeh71BpZeSHwMgPSFRP3eJN6iEneSlt7aMgEe5LA+cZRRqz3W2tabHaOdAK1NzylXMJqZz/1+CkSLI/C6KTjjXlFmvBk1mb6vFpbkMJKqTBuEVyY+xZMKfIck7e0sy1L7O4l6clZxOP4aM3BDtT1j7QzT8iPT0mUwNHxlT+pODif9lehIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rth0ZEyC9MBUtXH7RdAXZkShOSCjkgmWq8Wps9loBDY=;
 b=nYTbfjP7n5F0dHq/3dDLHYR7HQPoAAAMmPgQkHthoJ56hsfu9I0tkhdaQVAV//5sZ/uj1ZEjdFSgNkMWerJiSApHyeLztqWQwicc+584ChK9YmM+U5lXinWGumgchvT0tM6vB3NaF0wPueFIadF9rh0G1Cz0zEBbN6Bs3IPpfTt+F3nhJ2xphDnGf3kmmx5QCHpKXVleas3EI5/byfRUc+zFFTTwflnoAt8x812QpA9isdJUbVk+W1ZYSlWlnmV+zbamiYn+tzz29XPfgkdHi0mlvnI/aq7whuh1iKoXXbZog6mteCrx9qlo9rh+Mj8u9H4YKP0dfKVn4GtoCJJ/uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rth0ZEyC9MBUtXH7RdAXZkShOSCjkgmWq8Wps9loBDY=;
 b=LHnMwVnLJXdHkKemrPUJXqXexcJXR85edcSYNo9l9LjMxtAjlIhUY1X2MPPURbZohpSD4Hvl5kCGTRK2jRgqaw/VcjJyT6BOdZVzzHWUrQZcBhVMDsS1GbQ5GYlRyFKcSYTcj0YEj3f3ZaicU6JOLUgUNnJ0qjJCqayc5wlhN1S3IX5FgJ0mrmutHDR8lm61lvevpVrwnyr+DBiuxxGmIZp4xO/xXlKsyvhrnw98uXM/5fyJa2cJgIE/fyp7zVVNZR9pE+w+Yf+xIB56BQi4qbWIKekE1CGPTZyCPLWkT9FIDymKdF5MoVvFmqg9ijj40bV9A1OCft62IvWQG++u9w==
Received: from DM6PR08CA0027.namprd08.prod.outlook.com (2603:10b6:5:80::40) by
 SA0PR12MB4381.namprd12.prod.outlook.com (2603:10b6:806:70::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.7; Mon, 24 Jan 2022 18:17:55 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::30) by DM6PR08CA0027.outlook.office365.com
 (2603:10b6:5:80::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Mon, 24 Jan 2022 18:17:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 18:17:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 18:17:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 10:17:54 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.13) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 24 Jan 2022 10:17:50 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC PATCH v2 4/5] vfio/pci: Invalidate mmaps and block the access in D3hot power state
Date:   Mon, 24 Jan 2022 23:47:25 +0530
Message-ID: <20220124181726.19174-5-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124181726.19174-1-abhsahu@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9f547c5-af1f-456b-46f9-08d9df65d78d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4381:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB438109AB3221E0E8A39664DECC5E9@SA0PR12MB4381.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0R6n4/tdOCQPsXn187VIvpBLZXia2kjzvlQagZ1s87u7nuAKKgPNBl14ZPnbHC/11fvxVe4MC+t3lA20C/PZed7agUElabfysYQL5DS7iKVFAT6BfnVfJ2xjeojlwIG2DOEBMyumi9CVCo71V/ius3xVGaSuXF5qlFgiw6lA+8Uh5AANaFj+q261yChhd5iEAS7j2wIMyvHc1Bhd/eWxRVtHpaEVMEeVVRWq2Ibmgw+7b4jg6aEJ6f35aOzVjSxQ0akr1+ZuvxWuZ6gMmE0tJTV/gZLT4CZuO1HK/yGXM8yyjSAQnnMTFBNq1vnKJs/2F/6U8AoslnuX+hCvL3ZyFc3xup3ge490hKVi5sS3tVt1VEacrU0O4qs1Y7YeX3QmdRQUyTpZHgo7vvvemrFcJ+FfNr6OJHkEKNUs0T/JjtIHgekXRv/sQCAq3guCSE3YuLBgg4Y+gYTkuSNXR/hnjH5E2MPAJU7PIGQdTqpXI9R68PxjoVnYH5p5gG+9P39T0IQlYIWXu7GhxkZUcpv8pWjcvRFSHby4/vN1zwrSigb6j5heFF5gn7ophLdUkeNJf5KNCZxqgtuJSkmkyt0+wvnalD2MQrODvQ5wzutqIZlmM4qL9lG0Cl8Q4r3z41RXo05IrSkDEK3dBmJdVjI1NQt+tSEpg4K7rODYUvgr6KgvF8zSVQ2gduPUGyz50RN8q4Uhw9o3nBbTJjdRPxIFBUJt1I+Duq42/GtfoZpqJfxFh+Ql3ZULvFHR8sMcfNactgIVxwOqRx78/9Hd1CjKGSGGBjBsC6Vgt7XZazWkiR2DyW4+TAD+7AcPgSAKdgSR9mPl8V3czLXCTpAB3UTQng==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700004)(36840700001)(40460700003)(426003)(336012)(186003)(36860700001)(508600001)(47076005)(4326008)(82310400004)(70206006)(2616005)(1076003)(70586007)(8936002)(110136005)(54906003)(7696005)(6666004)(356005)(83380400001)(5660300002)(81166007)(86362001)(26005)(36756003)(107886003)(2906002)(8676002)(316002)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 18:17:54.9593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f547c5-af1f-456b-46f9-08d9df65d78d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4381
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to [PCIe v5 5.3.1.4.1] for D3hot state

 "Configuration and Message requests are the only TLPs accepted by a
  Function in the D3Hot state. All other received Requests must be
  handled as Unsupported Requests, and all received Completions may
  optionally be handled as Unexpected Completions."

Currently, if the vfio PCI device has been put into D3hot state and if
user makes non-config related read/write request in D3hot state, these
requests will be forwarded to the host and this access may cause
issues on a few systems.

This patch leverages the memory-disable support added in commit
'abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on
disabled memory")' to generate page fault on mmap access and
return error for the direct read/write. If the device is D3hot state,
then the error needs to be returned for all kinds of BAR
related access (memory, IO and ROM). Also, the power related structure
fields need to be protected so we can use the same 'memory_lock' to
protect these fields also. For the few cases, this 'memory_lock' will be
already acquired by callers so introduce a separate function
vfio_pci_set_power_state_locked(). The original
vfio_pci_set_power_state() now contains the code to do the locking
related operations.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 47 +++++++++++++++++++++++++-------
 drivers/vfio/pci/vfio_pci_rdwr.c | 20 ++++++++++----
 2 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ee2fb8af57fa..38440d48973f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -201,11 +201,12 @@ static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
 }
 
 /*
- * pci_set_power_state() wrapper handling devices which perform a soft reset on
- * D3->D0 transition.  Save state prior to D0/1/2->D3, stash it on the vdev,
- * restore when returned to D0.  Saved separately from pci_saved_state for use
- * by PM capability emulation and separately from pci_dev internal saved state
- * to avoid it being overwritten and consumed around other resets.
+ * vfio_pci_set_power_state_locked() wrapper handling devices which perform a
+ * soft reset on D3->D0 transition.  Save state prior to D0/1/2->D3, stash it
+ * on the vdev, restore when returned to D0.  Saved separately from
+ * pci_saved_state for use by PM capability emulation and separately from
+ * pci_dev internal saved state to avoid it being overwritten and consumed
+ * around other resets.
  *
  * There are few cases where the PCI power state can be changed to D0
  * without the involvement of this API. So, cache the power state locally
@@ -215,7 +216,8 @@ static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
  * The memory taken for saving this PCI state needs to be freed to
  * prevent memory leak.
  */
-int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t state)
+static int vfio_pci_set_power_state_locked(struct vfio_pci_core_device *vdev,
+					   pci_power_t state)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	bool needs_restore = false, needs_save = false;
@@ -260,6 +262,26 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
+/*
+ * vfio_pci_set_power_state() takes all the required locks to protect
+ * the access of power related variables and then invokes
+ * vfio_pci_set_power_state_locked().
+ */
+int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
+			     pci_power_t state)
+{
+	int ret;
+
+	if (state >= PCI_D3hot)
+		vfio_pci_zap_and_down_write_memory_lock(vdev);
+	else
+		down_write(&vdev->memory_lock);
+
+	ret = vfio_pci_set_power_state_locked(vdev, state);
+	up_write(&vdev->memory_lock);
+	return ret;
+}
+
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -354,7 +376,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	 * in running the logic needed for D0 power state. The subsequent
 	 * runtime PM API's will put the device into the low power state again.
 	 */
-	vfio_pci_set_power_state(vdev, PCI_D0);
+	vfio_pci_set_power_state_locked(vdev, PCI_D0);
 
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
@@ -967,7 +989,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		 * interaction. Update the power state in vfio driver to perform
 		 * the logic needed for D0 power state.
 		 */
-		vfio_pci_set_power_state(vdev, PCI_D0);
+		vfio_pci_set_power_state_locked(vdev, PCI_D0);
 		up_write(&vdev->memory_lock);
 
 		return ret;
@@ -1453,6 +1475,11 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 		goto up_out;
 	}
 
+	if (vdev->power_state >= PCI_D3hot) {
+		ret = VM_FAULT_SIGBUS;
+		goto up_out;
+	}
+
 	/*
 	 * We populate the whole vma on fault, so we need to test whether
 	 * the vma has already been mapped, such as for concurrent faults
@@ -1902,7 +1929,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	 * be able to get to D3.  Therefore first do a D0 transition
 	 * before enabling runtime PM.
 	 */
-	vfio_pci_set_power_state(vdev, PCI_D0);
+	vfio_pci_set_power_state_locked(vdev, PCI_D0);
 	pm_runtime_allow(&pdev->dev);
 
 	if (!disable_idle_d3)
@@ -2117,7 +2144,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 * interaction. Update the power state in vfio driver to perform
 		 * the logic needed for D0 power state.
 		 */
-		vfio_pci_set_power_state(cur, PCI_D0);
+		vfio_pci_set_power_state_locked(cur, PCI_D0);
 		if (cur == cur_mem)
 			is_mem = false;
 		if (cur == cur_vma)
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 57d3b2cbbd8e..e97ba14c4aa0 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -41,8 +41,13 @@
 static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size val, void __iomem *io)	\
 {									\
+	down_read(&vdev->memory_lock);					\
+	if (vdev->power_state >= PCI_D3hot) {				\
+		up_read(&vdev->memory_lock);				\
+		return -EIO;						\
+	}								\
+									\
 	if (test_mem) {							\
-		down_read(&vdev->memory_lock);				\
 		if (!__vfio_pci_memory_enabled(vdev)) {			\
 			up_read(&vdev->memory_lock);			\
 			return -EIO;					\
@@ -51,8 +56,7 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 									\
 	vfio_iowrite##size(val, io);					\
 									\
-	if (test_mem)							\
-		up_read(&vdev->memory_lock);				\
+	up_read(&vdev->memory_lock);					\
 									\
 	return 0;							\
 }
@@ -68,8 +72,13 @@ VFIO_IOWRITE(64)
 static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size *val, void __iomem *io)	\
 {									\
+	down_read(&vdev->memory_lock);					\
+	if (vdev->power_state >= PCI_D3hot) {				\
+		up_read(&vdev->memory_lock);				\
+		return -EIO;						\
+	}								\
+									\
 	if (test_mem) {							\
-		down_read(&vdev->memory_lock);				\
 		if (!__vfio_pci_memory_enabled(vdev)) {			\
 			up_read(&vdev->memory_lock);			\
 			return -EIO;					\
@@ -78,8 +87,7 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 									\
 	*val = vfio_ioread##size(io);					\
 									\
-	if (test_mem)							\
-		up_read(&vdev->memory_lock);				\
+	up_read(&vdev->memory_lock);					\
 									\
 	return 0;							\
 }
-- 
2.17.1

