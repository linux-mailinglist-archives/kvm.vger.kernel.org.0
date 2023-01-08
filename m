Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D554C661643
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 16:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjAHPpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 10:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbjAHPpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 10:45:34 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386F2FD34
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 07:45:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLyn39NHeR72n73R6cyy8ENrwFXH31AF/fv3NxZfWPV0Q16bJk/CiAn2U3h/z/seHeLOI7J23NovbNkGFhaKc2LqhdhdRKaEo0MzWBEROjpHaI+1yAViL+PItlJhLAQ435utbgeKsjwAQjR4Pqg0f2wjFc4ve3V2WkRAIwL9D9Zwr/ghTLDyp4C0G28QzVkPa2BCGm5rEwHVD3nwt8KNYcsLOMu5wM47r5Bw/ARvLs+nmd4H4Byb683xiiesRLM18CQqbxum7SpThIPbbixRCFsYDH5Oi3RoyijBRlfIcBT5H6V+2jVrWpoMqVes0U6jANTYHArSaMPBQHuH5s9aMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iB+wwZESLnJeV0tnBePwfhYaT1OSc27ioTbYMJScf8g=;
 b=OxuFA9Kmu5eS/qJz+/bnfhBowEd9rKDAwz/WFhouclpa1hRSqBW+3gIVeNgY8oL6YMwffetl0tKZsEfNSrhKOm0e6wfOJd2r50fYrBCjd6OCnECRAsN24razPJQYL+JgmPS5uF3/X6gZMdGw3QTHXj8XphVAxSXq31XztJTF6ftv7Ot5vs0cpy4d6obnIlcAigkcoBjI4IJ6pjCQFhxfIYYb/C6dpKWt25jWPVlA/7PgFCGUqavNekyizVS5zQeiiyTV+KJpNW6mUvyyeLlfnkDG9MXm8kkZYithR2D4IHQsLt2NnJYrIkVMr/bv7FToHQKu+acyTqw9Ic0vOhuHcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iB+wwZESLnJeV0tnBePwfhYaT1OSc27ioTbYMJScf8g=;
 b=PV/d7LecH7YEtJGumGziabD6bdUp5L76fQfuoRqH/MwxqTd1nLPLRUbN4UjeFuNbioV4uyzlYi9NpVt1OLbNK1SSvmh8f0VrZyddPd9AptFI3lTLwB1MQg9kStW127XUQdM14tMaL8Ag5LuGXzgBqHW0j9LzVglcZtLMfSvLXzg4IG6Sh4AU4fS3OfFdYfQrcD+TAM1ykB4L/pYO9D+6VSAh/xs7sekrEcOS1SmXHimIvLmED0Afn84ETqd39F7U4YUGGAo29kl0iWMd9tpV1bJfX2yG6zd4EZcxXAX6TjoVnuNVKotBxp6gCUxE316mFXrgyHyIrBeOU50ddoDSmw==
Received: from BN9PR03CA0582.namprd03.prod.outlook.com (2603:10b6:408:10d::17)
 by MW4PR12MB5603.namprd12.prod.outlook.com (2603:10b6:303:16a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Sun, 8 Jan
 2023 15:45:30 +0000
Received: from BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::a5) by BN9PR03CA0582.outlook.office365.com
 (2603:10b6:408:10d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Sun, 8 Jan 2023 15:45:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT091.mail.protection.outlook.com (10.13.176.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Sun, 8 Jan 2023 15:45:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:17 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:17 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Sun, 8 Jan
 2023 07:45:13 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V1 vfio 3/6] vfio: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
Date:   Sun, 8 Jan 2023 17:44:24 +0200
Message-ID: <20230108154427.32609-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230108154427.32609-1-yishaih@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT091:EE_|MW4PR12MB5603:EE_
X-MS-Office365-Filtering-Correlation-Id: 76409af9-ae94-401a-f75a-08daf18f5ec0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XaZ9KzSK70aSqmghTGJGTrfeo0msTacIUu2rsXoQnq6wElxkX5BR4eo0OovEYH37aNWvZmjBebxdHMek8+fFBKxAxv7g1yfE8Vn9lQPfjQt6l5y5OcoW93OUYePI2PhFiQPXVmCLTlS5yAG6MNoHTWSPhb7wNGfQg2J64u9Deqml8W/RIEIyxQ3ZhS9PEk0D/d6zLqBT5zstKhqj1yipzszFG17P55xjGKs+iPU9H+D98U+nUaXSwms5jkt1QTQBkZniM4Y2begJditEVw7F54L6z+/8mL6hf0WmG8B4nb4wpFpT5O6UURUR6/2CDpLBZ54SvFpwqPb9XgNGXNQLIlLZewImAECdCCxCa6rcYc8HUGSTfUj5796UF8BAWlL6DvoGori542yOpWNsx+4JDHFNo5EgA1kmmxCFzpFBZHtUlaDN5zM7AkhWhurnRUQnpjo/OQYFd4iBdpgMZSst/7dS1tmCegFwedwAzFJ8Y+S5ARygJvd3Neolco1JIvXiloGCufa0DiK9IAKF0SVos/akH15zp4AK2JDw8toTS2ZnF+KoNKE9QemhXlaFdGZAd1lu0LCkt9EEGfzXDmOA0Yr/avDdnQA3KEdH4qfQRnIXA4esORZy6MG/HkcidMZWdNcLFt+YRm7tHw3a9qcA/+qQG3AhZbYChbifmTHKKmeUR1JnR0R9IxS+iMyc9P5DUbp5EF+e2QA9bEQqGder9g==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(36840700001)(40470700004)(46966006)(6666004)(316002)(110136005)(186003)(26005)(6636002)(54906003)(4326008)(336012)(2616005)(70586007)(1076003)(70206006)(7636003)(7696005)(8676002)(478600001)(426003)(83380400001)(41300700001)(356005)(8936002)(47076005)(5660300002)(2906002)(36860700001)(82740400003)(36756003)(86362001)(40460700003)(82310400005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:45:29.6637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76409af9-ae94-401a-f75a-08daf18f5ec0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5603
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

