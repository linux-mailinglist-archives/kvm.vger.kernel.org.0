Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F776658B8B
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 11:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiL2KQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 05:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiL2KNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 05:13:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02045DE8E
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 02:08:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1KzeAZGubVzFzf/mzZZAu3N0UfUNytUtL9Rl1z5vbUNdxe0ayKbIAS4q4oibsA+jezjs7KX7wVrFsFGi4p+jk0EeCl5cQ2l+V7+DGCnKcNnZx8Rn76c2gvd5beVU8OHo6sx+feeTLgcU3yvVhJ4HaD15Br31F+RAFoYQtSxONlMU0YoEmMD9mCC1nJQD/5ysTwABmLzmWfsNGioVJGOnJyeqWL6Y0x4+OyXTsvbL5lbjh6ukAmFyECDgau9e5ZcIsTde0iCiOYDnxzk70CUTWF4EXaPsRNkSfpjnGFspOMT6hvqLgMSA2eNy6GcTbFSMT1Z6M0N1yEusYP5E7TX8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iB+wwZESLnJeV0tnBePwfhYaT1OSc27ioTbYMJScf8g=;
 b=l4qWBsgSRtbxGLvhlTRR4w2qLJVQgP+uyyoZZgVnF4BFan7ORlcX1HFp83LcoJ0FqBMUcghwonnmHMDHIEq5a44Y1quXJQba33HdDgz6JPttc0PYFxYbyuBHpQCHdRUE6n1vyNkXDgwaVkUJFWu3mT+QNreSLRnlpBRpeYssg0J1/WWIj4zo/Biau6NPX3kJxORCWQqQezqKIVXMGjbslcHLoWJsj6GiE+DApD8LuPeByt9/qdfgYMDwCtsZzRTtzxKtJ6jqEXVfmm6i/N7abuNtyvgcQd7AlyKaClznVYBqMCnIf+IO1hh7J29l6m5uk33ZYRdwul0tPo1lOYSVJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iB+wwZESLnJeV0tnBePwfhYaT1OSc27ioTbYMJScf8g=;
 b=Q/dVHW4BguFTb+mTDC5SHGq/94k5FugYmsXHEhde4HPn2bhgz+7jhsr2pRlNgbyxNEbsXOiGPT9by0VFL06N5iYGaieu7RGxr2Yp4rowCDgyso91KUxXF42RIauDnDh65fPq09As5oN5AOwGtqiOt7N/vIxjDs1aF9XQlvYmCQvOMdwS4JvLU2euVYUNsM/a4RWJlu5QRJbiJ5Jy8nU3Yp1dbI28F7q1pQRmTEDc86MCM8CWSs4Miokc8W/ughPk04xKYu7VlwD2jkcfwoAn2/QBckmZl9vsTe2Z1XHX5sRPbPkKRaj76W+M+FgA3LFP0uU5LHBLWKnU72rbw0GNSg==
Received: from MW4P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::20)
 by DM6PR12MB4091.namprd12.prod.outlook.com (2603:10b6:5:222::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 10:08:34 +0000
Received: from CO1NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::db) by MW4P220CA0015.outlook.office365.com
 (2603:10b6:303:115::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.17 via Frontend
 Transport; Thu, 29 Dec 2022 10:08:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT081.mail.protection.outlook.com (10.13.174.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17 via Frontend Transport; Thu, 29 Dec 2022 10:08:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:27 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:27 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 29 Dec
 2022 02:08:24 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH vfio 3/6] vfio: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
Date:   Thu, 29 Dec 2022 12:07:31 +0200
Message-ID: <20221229100734.224388-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221229100734.224388-1-yishaih@nvidia.com>
References: <20221229100734.224388-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT081:EE_|DM6PR12MB4091:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ff366ef-0d0a-439e-1f1c-08dae984a534
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mtJgBeEiC0U3BYOgb1R3FTAac88Y/+z7mncDuABm1+xi9mfge7Z56vLSI3ZpOPALqYJlaHnw7ROzQvA+1Um6Mr/8DK4AdeTDSWZmtZvp/E642FV+alb7vj9dYYuVQMeDOLarUrpr7tDq3OflIzkGg9B1kU2rhufl1GjCQN8NOvUhf6eFvME+PNeCGNV+Ez8owdoSzYJlT7fLydtRoFrr9BmFr5mBbbz+hSgisb3uLPDZzN4MSkJ9bdbfX60mHwGpho9nJ5+wpVPyZ2mVNr/hcup2GQ2RMP3W0dVNtPcQrkpor/NsdPrzasxCQxY28LJiJ7lp+Zzd6cnNnYDeuqkHXnu0FZ9e0nTL+wRxA5qT1hShYM5zBxWxDCXoCENCv9eKJP3TY0GRb8asAEy1JsIuvEPbyy8LUzP8Zh4M0Ta6/oZvM8kUtEO6f9UycDHIz/TygeBx9VLMVZyxEMv911lDdIHCCQipD5+hUtmeEScigo2v+B7HV7cPgA2AUYSpiCOY/cxv+Mx3GX0ePQBHFIHhrq2/ILrgAS7tBs03pbPlBPzgdqoiboksu13uZUMyGxzNA/gn9CGaaG4gbN26Qpestu68+wsIIDOLkblLEzNAk0IofAQmkuXFPcPSxks9bw8Z2hHUUyfk7hvGRE1AI6NZbNaFNZkZnigr/rO9e2nMOcB5H81/ntgLQxd8PX09JGKG2xmpmEY5+Qt6TeRUeGo0RQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(36840700001)(40470700004)(46966006)(426003)(83380400001)(36860700001)(47076005)(336012)(86362001)(8936002)(356005)(2906002)(41300700001)(5660300002)(70206006)(82740400003)(40460700003)(82310400005)(7696005)(40480700001)(6666004)(478600001)(1076003)(26005)(2616005)(4326008)(186003)(70586007)(54906003)(6636002)(316002)(110136005)(7636003)(8676002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 10:08:34.2020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff366ef-0d0a-439e-1f1c-08dae984a534
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4091
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

Use GFP_KERNEL_ACCOUNT for userspace persistent allocations.

The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
is untrusted allocation triggered from userspace and should be a subject
of kmem accountingis, and as such it is controlled by the cgroup
mechanism.

The way to find the relevant allocations was for example to look at the
close_device function and trace back all the kfrees to their
allocations.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/container.c           |  2 +-
 drivers/vfio/pci/vfio_pci_config.c |  6 +++---
 drivers/vfio/pci/vfio_pci_core.c   |  7 ++++---
 drivers/vfio/pci/vfio_pci_igd.c    |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c  | 10 ++++++----
 drivers/vfio/pci/vfio_pci_rdwr.c   |  2 +-
 drivers/vfio/virqfd.c              |  2 +-
 7 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index b7a9560ab25e..5f398c493a1b 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -367,7 +367,7 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 {
 	struct vfio_container *container;
 
-	container = kzalloc(sizeof(*container), GFP_KERNEL);
+	container = kzalloc(sizeof(*container), GFP_KERNEL_ACCOUNT);
 	if (!container)
 		return -ENOMEM;
 
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 4a350421c5f6..523e0144c86f 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1244,7 +1244,7 @@ static int vfio_msi_cap_len(struct vfio_pci_core_device *vdev, u8 pos)
 	if (vdev->msi_perm)
 		return len;
 
-	vdev->msi_perm = kmalloc(sizeof(struct perm_bits), GFP_KERNEL);
+	vdev->msi_perm = kmalloc(sizeof(struct perm_bits), GFP_KERNEL_ACCOUNT);
 	if (!vdev->msi_perm)
 		return -ENOMEM;
 
@@ -1731,11 +1731,11 @@ int vfio_config_init(struct vfio_pci_core_device *vdev)
 	 * no requirements on the length of a capability, so the gap between
 	 * capabilities needs byte granularity.
 	 */
-	map = kmalloc(pdev->cfg_size, GFP_KERNEL);
+	map = kmalloc(pdev->cfg_size, GFP_KERNEL_ACCOUNT);
 	if (!map)
 		return -ENOMEM;
 
-	vconfig = kmalloc(pdev->cfg_size, GFP_KERNEL);
+	vconfig = kmalloc(pdev->cfg_size, GFP_KERNEL_ACCOUNT);
 	if (!vconfig) {
 		kfree(map);
 		return -ENOMEM;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 26a541cc64d1..a6492a25ff6a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -144,7 +144,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 			 * of the exclusive page in case that hot-add
 			 * device's bar is assigned into it.
 			 */
-			dummy_res = kzalloc(sizeof(*dummy_res), GFP_KERNEL);
+			dummy_res =
+				kzalloc(sizeof(*dummy_res), GFP_KERNEL_ACCOUNT);
 			if (dummy_res == NULL)
 				goto no_mmap;
 
@@ -863,7 +864,7 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 
 	region = krealloc(vdev->region,
 			  (vdev->num_regions + 1) * sizeof(*region),
-			  GFP_KERNEL);
+			  GFP_KERNEL_ACCOUNT);
 	if (!region)
 		return -ENOMEM;
 
@@ -1644,7 +1645,7 @@ static int __vfio_pci_add_vma(struct vfio_pci_core_device *vdev,
 {
 	struct vfio_pci_mmap_vma *mmap_vma;
 
-	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
+	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL_ACCOUNT);
 	if (!mmap_vma)
 		return -ENOMEM;
 
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 5e6ca5926954..dd70e2431bd7 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -180,7 +180,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_core_device *vdev)
 	if (!addr || !(~addr))
 		return -ENODEV;
 
-	opregionvbt = kzalloc(sizeof(*opregionvbt), GFP_KERNEL);
+	opregionvbt = kzalloc(sizeof(*opregionvbt), GFP_KERNEL_ACCOUNT);
 	if (!opregionvbt)
 		return -ENOMEM;
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 40c3d7cf163f..bffb0741518b 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -177,7 +177,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	if (!vdev->pdev->irq)
 		return -ENODEV;
 
-	vdev->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
+	vdev->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL_ACCOUNT);
 	if (!vdev->ctx)
 		return -ENOMEM;
 
@@ -216,7 +216,7 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 	if (fd < 0) /* Disable only */
 		return 0;
 
-	vdev->ctx[0].name = kasprintf(GFP_KERNEL, "vfio-intx(%s)",
+	vdev->ctx[0].name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)",
 				      pci_name(pdev));
 	if (!vdev->ctx[0].name)
 		return -ENOMEM;
@@ -284,7 +284,8 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
-	vdev->ctx = kcalloc(nvec, sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
+	vdev->ctx = kcalloc(nvec, sizeof(struct vfio_pci_irq_ctx),
+			    GFP_KERNEL_ACCOUNT);
 	if (!vdev->ctx)
 		return -ENOMEM;
 
@@ -343,7 +344,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (fd < 0)
 		return 0;
 
-	vdev->ctx[vector].name = kasprintf(GFP_KERNEL, "vfio-msi%s[%d](%s)",
+	vdev->ctx[vector].name = kasprintf(GFP_KERNEL_ACCOUNT,
+					   "vfio-msi%s[%d](%s)",
 					   msix ? "x" : "", vector,
 					   pci_name(pdev));
 	if (!vdev->ctx[vector].name)
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e352a033b4ae..e27de61ac9fe 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -470,7 +470,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 		goto out_unlock;
 	}
 
-	ioeventfd = kzalloc(sizeof(*ioeventfd), GFP_KERNEL);
+	ioeventfd = kzalloc(sizeof(*ioeventfd), GFP_KERNEL_ACCOUNT);
 	if (!ioeventfd) {
 		ret = -ENOMEM;
 		goto out_unlock;
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 497a17b37865..29c564b7a6e1 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -112,7 +112,7 @@ int vfio_virqfd_enable(void *opaque,
 	int ret = 0;
 	__poll_t events;
 
-	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL);
+	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL_ACCOUNT);
 	if (!virqfd)
 		return -ENOMEM;
 
-- 
2.18.1

