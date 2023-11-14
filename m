Return-Path: <kvm+bounces-1699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A8F7EB81A
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 22:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E925B20BB7
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 21:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D134B2FC50;
	Tue, 14 Nov 2023 21:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dq4y7NYu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D300B2FC2F
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 21:01:50 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB7D9D;
	Tue, 14 Nov 2023 13:01:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRGbGExAlFaKwqbiHzcDTsV7EsxSGhZH5GQMMpzJ5jtA+l0ZTqAtWZXawxwvEI6jr76cKFT6k/RrNRxxGz+5mgilXrQNhJEOZTju4Q2Q9SCjaHElUOYkRQSEmgKkG+dR8X//UMb0JMLwEIrK2ZddAKJgKLBlsnt7BOE2AKXypsK1kdpOXMxCBxfbxOiZQNtKzww0MOJEPlm9upDm1VB4mM9nR5WBP9QF3T74Ztjpx3F9v8hSkfZ82UzDe/zVQskN2FsK3KGaSnp0rOd9fpnECXqkCiuraWEsxBhOaTErdJAHA6Du0lovu6IDGTz3oScTrLKRUKu1lUpTltAOYAiJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TdLJWDs0moDy/sX72/SzES8ZQqKd0ngOCX8627x6ig=;
 b=MToUSXAXMfkK9Qm1gD+lQa3/Ce+X+fBliBwMGutYZ0JQ5fP3NJlAVHPllkW7eeiQix68DLnXaR91MPXIjUsT9WGiWIGNuO5QLYGkL8K7hcEmxT8hxffJPi6J6Zjpm++Ypts7PvhXz4C7bgFYTQOHZ5Vl8V5K7dGQpFCkaDZol8XSsZAoldPjGqn5HRG+4DccPJL4b5rDRSIiyYWSEyGQzsnZ4ci76FjjZ66Y+InTU74w+AB56KOD/1RjQL3huqWH+GDKTiFUxOLmC422ht65qgnntqrV9cXh8KHpqdsOUZEmDq0wAKO7blPImLiesyzJWYgbSbY7+FS1Y56K+hLUYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TdLJWDs0moDy/sX72/SzES8ZQqKd0ngOCX8627x6ig=;
 b=Dq4y7NYuWJi8jse163OLZbBZDjmJv0bdXJ8r5mUmjtQa0Vh+7FoIaXPBDlQ83diXNZRmjh/L7//iujwbQ0BBhbEvrn7SWIU7h4cmYZ8T1ZpnUOP/aqqP422rRZU9pZjzOcsiPQjxA66Hvru3RZAF+sVL2GbPZhKFqiYJpp0aMbQ=
Received: from BLAPR05CA0017.namprd05.prod.outlook.com (2603:10b6:208:36e::29)
 by SJ2PR12MB9116.namprd12.prod.outlook.com (2603:10b6:a03:557::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.26; Tue, 14 Nov
 2023 21:01:46 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::f2) by BLAPR05CA0017.outlook.office365.com
 (2603:10b6:208:36e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17 via Frontend
 Transport; Tue, 14 Nov 2023 21:01:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.14 via Frontend Transport; Tue, 14 Nov 2023 21:01:46 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Tue, 14 Nov
 2023 15:01:45 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 1/5] pds-vfio-pci: Only use a single SGL for both seq and ack
Date: Tue, 14 Nov 2023 13:01:25 -0800
Message-ID: <20231114210129.34318-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231114210129.34318-1-brett.creeley@amd.com>
References: <20231114210129.34318-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|SJ2PR12MB9116:EE_
X-MS-Office365-Filtering-Correlation-Id: 187e3639-7e59-410b-38c2-08dbe554e9e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Xfo6EZPNHlhDW65WquUogT5+FUhO0V0RT7b0QvPbJrXfO5219UJ6pURjSLWuYy8Q8HP2tftaLnU0ddstHCAvFWRPBXOO9i668IKKP67YR7jZzbOGxgPy7fOQCKavY9tXTF5ieR6HoyCDz4vlmqXnDvQj3l2u37f++FPiDZBF5dWGkmVj46PPeSI/HAg6BbYhMPKw76JC28NWsHbCC/93Y6k1rsiPcEk5nO4dNDWqwAN/9w14o1WPK+JXjfRUNJaD5pfuWoAtj1ut8dagdHDgSOK4lMZR39xDqjHFvQMJOayGjn4g0LxX/PVJIMcNhq7AvCwbe5HbAxRH231PITyCM3V0cBahnF0ukTBInR/5OE9dREuRtmPl2YK5BzFKNM4pKIrqfWQ9nN0L85S2rb3aBVHj314Pt7p8eiYtrU4klcXJYW7dhpZWw46f6XsDEuUyJ+twF8F7O2gJ9vrtr/5OI3rPGJMiZ7axd4RwszPbv0R95h9fn8iOWw06ldMIsvi5y0b0XYuloxrgVJzs5HvBZJzl1mxUh2M3nkwL3I9tG65FOzmRviz9RiN32sHeyqwhOmv2/RILS2khH85FrYzSHsdGoB6AQbOKZ6HM1j0oA2mP9Sg/MW1apAg6t0O03Nz7gijnBvrEV/I+Ka8UcfSJwboPuU7JI7q414XciFUJqKax/d7APrBNR7anIKN2x1ltyjU2dl9KcENkFYyn4CJwHbdo8SZ3jY1Tnd4z0x3ENelZvfXMcnYhKgcUnBs/b3Yp/6lW3KiG7KyiF3q9RXL3UQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(186009)(82310400011)(1800799009)(64100799003)(451199024)(40470700004)(36840700001)(46966006)(478600001)(81166007)(36756003)(6666004)(356005)(336012)(426003)(47076005)(316002)(70206006)(70586007)(54906003)(110136005)(41300700001)(40480700001)(83380400001)(8676002)(44832011)(4326008)(8936002)(40460700003)(5660300002)(16526019)(82740400003)(2616005)(86362001)(2906002)(26005)(36860700001)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 21:01:46.5359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 187e3639-7e59-410b-38c2-08dbe554e9e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9116

Since the seq/ack operations never happen in parallel there
is no need for multiple scatter gather lists per region.
The current implementation is wasting memory. Fix this by
only using a single scatter gather list for both the seq
and ack operations.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/dirty.c | 68 +++++++++++++-----------------------
 drivers/vfio/pci/pds/dirty.h |  6 ++--
 2 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index c937aa6f3954..b6f517bc5667 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -100,35 +100,35 @@ static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
 }
 
 static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
-				      struct pds_vfio_bmp_info *bmp_info)
+				      struct pds_vfio_dirty *dirty)
 {
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
 
-	dma_unmap_single(pdsc_dev, bmp_info->sgl_addr,
-			 bmp_info->num_sge * sizeof(struct pds_lm_sg_elem),
+	dma_unmap_single(pdsc_dev, dirty->sgl_addr,
+			 dirty->num_sge * sizeof(struct pds_lm_sg_elem),
 			 DMA_BIDIRECTIONAL);
-	kfree(bmp_info->sgl);
+	kfree(dirty->sgl);
 
-	bmp_info->num_sge = 0;
-	bmp_info->sgl = NULL;
-	bmp_info->sgl_addr = 0;
+	dirty->num_sge = 0;
+	dirty->sgl = NULL;
+	dirty->sgl_addr = 0;
 }
 
 static void pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio)
 {
-	if (pds_vfio->dirty.host_seq.sgl)
-		__pds_vfio_dirty_free_sgl(pds_vfio, &pds_vfio->dirty.host_seq);
-	if (pds_vfio->dirty.host_ack.sgl)
-		__pds_vfio_dirty_free_sgl(pds_vfio, &pds_vfio->dirty.host_ack);
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+
+	if (dirty->sgl)
+		__pds_vfio_dirty_free_sgl(pds_vfio, dirty);
 }
 
-static int __pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
-				      struct pds_vfio_bmp_info *bmp_info,
-				      u32 page_count)
+static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
+				    u32 page_count)
 {
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
 	struct pds_lm_sg_elem *sgl;
 	dma_addr_t sgl_addr;
 	size_t sgl_size;
@@ -147,30 +147,9 @@ static int __pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
 		return -EIO;
 	}
 
-	bmp_info->sgl = sgl;
-	bmp_info->num_sge = max_sge;
-	bmp_info->sgl_addr = sgl_addr;
-
-	return 0;
-}
-
-static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
-				    u32 page_count)
-{
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
-	int err;
-
-	err = __pds_vfio_dirty_alloc_sgl(pds_vfio, &dirty->host_seq,
-					 page_count);
-	if (err)
-		return err;
-
-	err = __pds_vfio_dirty_alloc_sgl(pds_vfio, &dirty->host_ack,
-					 page_count);
-	if (err) {
-		__pds_vfio_dirty_free_sgl(pds_vfio, &dirty->host_seq);
-		return err;
-	}
+	dirty->sgl = sgl;
+	dirty->num_sge = max_sge;
+	dirty->sgl_addr = sgl_addr;
 
 	return 0;
 }
@@ -328,6 +307,8 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 	u8 dma_dir = read_seq ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	struct pds_lm_sg_elem *sgl;
 	unsigned long long npages;
 	struct sg_table sg_table;
 	struct scatterlist *sg;
@@ -374,8 +355,9 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 	if (err)
 		goto out_free_sg_table;
 
+	sgl = pds_vfio->dirty.sgl;
 	for_each_sgtable_dma_sg(&sg_table, sg, i) {
-		struct pds_lm_sg_elem *sg_elem = &bmp_info->sgl[i];
+		struct pds_lm_sg_elem *sg_elem = &sgl[i];
 
 		sg_elem->addr = cpu_to_le64(sg_dma_address(sg));
 		sg_elem->len = cpu_to_le32(sg_dma_len(sg));
@@ -383,15 +365,15 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 
 	num_sge = sg_table.nents;
 	size = num_sge * sizeof(struct pds_lm_sg_elem);
-	dma_sync_single_for_device(pdsc_dev, bmp_info->sgl_addr, size, dma_dir);
-	err = pds_vfio_dirty_seq_ack_cmd(pds_vfio, bmp_info->sgl_addr, num_sge,
+	dma_sync_single_for_device(pdsc_dev, dirty->sgl_addr, size, dma_dir);
+	err = pds_vfio_dirty_seq_ack_cmd(pds_vfio, dirty->sgl_addr, num_sge,
 					 offset, bmp_bytes, read_seq);
 	if (err)
 		dev_err(&pdev->dev,
 			"Dirty bitmap %s failed offset %u bmp_bytes %u num_sge %u DMA 0x%llx: %pe\n",
 			bmp_type_str, offset, bmp_bytes,
-			num_sge, bmp_info->sgl_addr, ERR_PTR(err));
-	dma_sync_single_for_cpu(pdsc_dev, bmp_info->sgl_addr, size, dma_dir);
+			num_sge, dirty->sgl_addr, ERR_PTR(err));
+	dma_sync_single_for_cpu(pdsc_dev, dirty->sgl_addr, size, dma_dir);
 
 	dma_unmap_sgtable(pdsc_dev, &sg_table, dma_dir, 0);
 out_free_sg_table:
diff --git a/drivers/vfio/pci/pds/dirty.h b/drivers/vfio/pci/pds/dirty.h
index f78da25d75ca..9de5aac58190 100644
--- a/drivers/vfio/pci/pds/dirty.h
+++ b/drivers/vfio/pci/pds/dirty.h
@@ -7,9 +7,6 @@
 struct pds_vfio_bmp_info {
 	unsigned long *bmp;
 	u32 bmp_bytes;
-	struct pds_lm_sg_elem *sgl;
-	dma_addr_t sgl_addr;
-	u16 num_sge;
 };
 
 struct pds_vfio_dirty {
@@ -18,6 +15,9 @@ struct pds_vfio_dirty {
 	u64 region_size;
 	u64 region_start;
 	u64 region_page_size;
+	struct pds_lm_sg_elem *sgl;
+	dma_addr_t sgl_addr;
+	u16 num_sge;
 	bool is_enabled;
 };
 
-- 
2.17.1


