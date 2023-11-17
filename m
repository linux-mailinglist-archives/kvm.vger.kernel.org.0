Return-Path: <kvm+bounces-1898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 418E27EEA38
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E701128109D
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E784817C0;
	Fri, 17 Nov 2023 00:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2lmE+1pB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D861A7;
	Thu, 16 Nov 2023 16:12:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNNBjwXLeB3kfSS6YQPlffr3pPfF2XHnOU31JXZyA6U5+L8MaksZ9LMa8j1vawhmGfeDBV/pjIkKTmcIqKH2V/OZg1QsmAatHyLQP1j3tmOFZCchxAs1mPUBIhjhzXLW3MCIiTxXe/zNRb0d7JUYux97atDPyBksu4QRnkc6DQCnS0cO4iCrCHm77g1vrlYcLbf/LUkod+VFhd6ypRKZ+jweGIgVk9vaENTmDlL733iXBe4CPwdUfjN7h7AN8egoD8D5fWCae+SmgwBCuZLbeWQIbF857eUUwHu7nbGGFB8WvfE1WX1CP0WCoQYaFRispkPUwEHCVgzSCOwIHjzGLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3BwvVFwx/VIi6+f8FykGWxjoC13SspXAymFFpi43J8=;
 b=Ndf2wQ5DpKRQGvLHG5Q7VrZZ/oLeOtdPK2raGA8x7ylwuaJHJxy+wtRKHcHtcZcyxUZDQGv3CVd/UPedSNFxhLf2ZfovSkw1ea1QETbw89T69m63CvWWLwmnvYmZ6hYYma2xwuoydksCPgngdgosaqk4qzwQl3TLaXU2EFFdlPoCu9N03Ki4A8CPlYbPQhuhx0yLJH6lfnddwEc/tf7o+SFLS6/pt+0h39lnFiNZjpQZ+Xl+UFq8JrYLeQ2H9LicPneFMeUY7R9zz+qrYacBVw9bx9boDw7l6h71ZvUIDxgVTmpWl0S7KvXwy2eSI8wuwAbK5Vc9D2d2VxWarQK+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3BwvVFwx/VIi6+f8FykGWxjoC13SspXAymFFpi43J8=;
 b=2lmE+1pBwCgWs3M5nHAyibVUTIvvY2zAkcO+ZBAlRvcw/quYEZTAPzKrF6E+PLXKaPRxaP0KUvbzItLzZ3CSvyOCwsbT5XkemdglRauThP5XEt1zuYpDanY3BRxrDLP4x4ua1g0U6QoXl44mu7ea8rXRHHxVr4BiYPxfUaZdMvE=
Received: from PA7P264CA0053.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:34a::17)
 by DS0PR12MB7874.namprd12.prod.outlook.com (2603:10b6:8:141::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Fri, 17 Nov
 2023 00:12:31 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10a6:102:34a:cafe::d3) by PA7P264CA0053.outlook.office365.com
 (2603:10a6:102:34a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21 via Frontend
 Transport; Fri, 17 Nov 2023 00:12:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.20 via Frontend Transport; Fri, 17 Nov 2023 00:12:30 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Thu, 16 Nov
 2023 18:12:26 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v2 vfio 4/6] vfio/pds: Pass region info to relevant functions
Date: Thu, 16 Nov 2023 16:12:05 -0800
Message-ID: <20231117001207.2793-5-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231117001207.2793-1-brett.creeley@amd.com>
References: <20231117001207.2793-1-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|DS0PR12MB7874:EE_
X-MS-Office365-Filtering-Correlation-Id: c11deda2-98a7-4094-e3a7-08dbe701e413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LDqxteOAhu5oV/jtB11uprgPyR13vdDZTXvG41g2DWyGZwZkRlZMJONbwtxthw4uV3/j0BRwkKVyspO+w3KTDC2PDawNuhGh9/a729rONWBDjOgvsx/HI3GalQq1IjtQrFDHVtd1Tu/4vhbf2CkNjG7zg7tnS7tahTK5PYyKq6stWKahz4o8bW4pEqEtq65r0gJ6wDxg+Y/gPyVDHW9HaBIVofxzKZae7rd91Zc5D31DibvsdLQ63jp7G4Hi7wScF0RE4NKYQve8gDL6BXEx+s5e/y2qbNDvPPHS9UGWhT2GhbHbfo3ko6WhN26dqONdPr1yDu/qazi7ghwtqltLvO6XpAB39GxGJJGR2Z20atEQSHysutMzcKocDPSagAgmiz6w7EchBvX0uyjN5OZlXUFxCDafd4X+L4BPurZclqplKc+edHB/KGGkHSEZRANL3Mp65nDt3v5AR2Es1ev3TL7aotyHQDpyyog7x2a68XgqbC0fG7Fcd1eOvf2sfsdqsIC/38oyhzK6grGzrSAy4IMBbfemHoaSIPFev2ywESUo7dHbI3kUubSKCXpspAqaOxvibXDs82B6BHg/p3lfwi7YZ/g1gwZz6GtKG64AuRdERUtg6bhreI16qFN4IbVhQZttlvIQwJpJ8OURj3+tmiQfHQNJ783eXfxcmuqh8jNFyxDz9K4QpiaZyZdIcknHxEuxewfskohDisw3VgYKTWkerj6B1RBhCzTuP/gyh9Zi6gCqxrc+Qw+o/HVp2bjqVeYhbdERqM6HvkmdbTq+Xg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(39860400002)(136003)(230922051799003)(64100799003)(451199024)(82310400011)(186009)(1800799009)(40470700004)(36840700001)(46966006)(2616005)(336012)(40460700003)(426003)(26005)(1076003)(478600001)(110136005)(36756003)(8676002)(4326008)(44832011)(2906002)(41300700001)(86362001)(8936002)(316002)(70206006)(70586007)(54906003)(5660300002)(16526019)(6666004)(356005)(82740400003)(81166007)(40480700001)(47076005)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2023 00:12:30.9924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c11deda2-98a7-4094-e3a7-08dbe701e413
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7874

A later patch in the series implements multi-region
support. That will require specific regions to be
passed to relevant functions. Prepare for that change
by passing the region structure to relevant functions.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/dirty.c | 71 ++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 8a7f9eed4e59..09fed7c1771a 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -100,35 +100,35 @@ static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
 }
 
 static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
-				      struct pds_vfio_dirty *dirty)
+				      struct pds_vfio_region *region)
 {
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
 
-	dma_unmap_single(pdsc_dev, dirty->region.sgl_addr,
-			 dirty->region.num_sge * sizeof(struct pds_lm_sg_elem),
+	dma_unmap_single(pdsc_dev, region->sgl_addr,
+			 region->num_sge * sizeof(struct pds_lm_sg_elem),
 			 DMA_BIDIRECTIONAL);
-	kfree(dirty->region.sgl);
+	kfree(region->sgl);
 
-	dirty->region.num_sge = 0;
-	dirty->region.sgl = NULL;
-	dirty->region.sgl_addr = 0;
+	region->num_sge = 0;
+	region->sgl = NULL;
+	region->sgl_addr = 0;
 }
 
 static void pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio)
 {
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	struct pds_vfio_region *region = &pds_vfio->dirty.region;
 
-	if (dirty->region.sgl)
-		__pds_vfio_dirty_free_sgl(pds_vfio, dirty);
+	if (region->sgl)
+		__pds_vfio_dirty_free_sgl(pds_vfio, region);
 }
 
 static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
+				    struct pds_vfio_region *region,
 				    u32 page_count)
 {
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
 	struct pds_lm_sg_elem *sgl;
 	dma_addr_t sgl_addr;
 	size_t sgl_size;
@@ -147,9 +147,9 @@ static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
 		return -EIO;
 	}
 
-	dirty->region.sgl = sgl;
-	dirty->region.num_sge = max_sge;
-	dirty->region.sgl_addr = sgl_addr;
+	region->sgl = sgl;
+	region->num_sge = max_sge;
+	region->sgl_addr = sgl_addr;
 
 	return 0;
 }
@@ -260,7 +260,7 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 		goto out_free_region_info;
 	}
 
-	err = pds_vfio_dirty_alloc_sgl(pds_vfio, page_count);
+	err = pds_vfio_dirty_alloc_sgl(pds_vfio, &dirty->region, page_count);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
 			ERR_PTR(err));
@@ -300,11 +300,11 @@ void pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio, bool send_cmd)
 }
 
 static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
+				  struct pds_vfio_region *region,
 				  struct pds_vfio_bmp_info *bmp_info,
 				  u32 offset, u32 bmp_bytes, bool read_seq)
 {
 	const char *bmp_type_str = read_seq ? "read_seq" : "write_ack";
-	struct pds_vfio_region *region = &pds_vfio->dirty.region;
 	u8 dma_dir = read_seq ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
@@ -383,36 +383,36 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 }
 
 static int pds_vfio_dirty_write_ack(struct pds_vfio_pci_device *pds_vfio,
+				   struct pds_vfio_region *region,
 				    u32 offset, u32 len)
 {
-	struct pds_vfio_region *region = &pds_vfio->dirty.region;
 
-	return pds_vfio_dirty_seq_ack(pds_vfio, &region->host_ack,
+	return pds_vfio_dirty_seq_ack(pds_vfio, region, &region->host_ack,
 				      offset, len, WRITE_ACK);
 }
 
 static int pds_vfio_dirty_read_seq(struct pds_vfio_pci_device *pds_vfio,
+				   struct pds_vfio_region *region,
 				   u32 offset, u32 len)
 {
-	struct pds_vfio_region *region = &pds_vfio->dirty.region;
-
-	return pds_vfio_dirty_seq_ack(pds_vfio, &region->host_seq,
+	return pds_vfio_dirty_seq_ack(pds_vfio, region, &region->host_seq,
 				      offset, len, READ_SEQ);
 }
 
 static int pds_vfio_dirty_process_bitmaps(struct pds_vfio_pci_device *pds_vfio,
+					  struct pds_vfio_region *region,
 					  struct iova_bitmap *dirty_bitmap,
 					  u32 bmp_offset, u32 len_bytes)
 {
-	u64 page_size = pds_vfio->dirty.region.page_size;
-	u64 region_start = pds_vfio->dirty.region.start;
+	u64 page_size = region->page_size;
+	u64 region_start = region->start;
 	u32 bmp_offset_bit;
 	__le64 *seq, *ack;
 	int dword_count;
 
 	dword_count = len_bytes / sizeof(u64);
-	seq = (__le64 *)((u64)pds_vfio->dirty.region.host_seq.bmp + bmp_offset);
-	ack = (__le64 *)((u64)pds_vfio->dirty.region.host_ack.bmp + bmp_offset);
+	seq = (__le64 *)((u64)region->host_seq.bmp + bmp_offset);
+	ack = (__le64 *)((u64)region->host_ack.bmp + bmp_offset);
 	bmp_offset_bit = bmp_offset * 8;
 
 	for (int i = 0; i < dword_count; i++) {
@@ -441,6 +441,7 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 {
 	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
 	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	struct pds_vfio_region *region = &dirty->region;
 	u64 bmp_offset, bmp_bytes;
 	u64 bitmap_size, pages;
 	int err;
@@ -453,23 +454,23 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	pages = DIV_ROUND_UP(length, pds_vfio->dirty.region.page_size);
+	pages = DIV_ROUND_UP(length, region->page_size);
 	bitmap_size =
 		round_up(pages, sizeof(u64) * BITS_PER_BYTE) / BITS_PER_BYTE;
 
 	dev_dbg(dev,
 		"vf%u: iova 0x%lx length %lu page_size %llu pages %llu bitmap_size %llu\n",
-		pds_vfio->vf_id, iova, length, pds_vfio->dirty.region.page_size,
+		pds_vfio->vf_id, iova, length, region->page_size,
 		pages, bitmap_size);
 
-	if (!length || ((iova - dirty->region.start + length) > dirty->region.size)) {
+	if (!length || ((iova - region->start + length) > region->size)) {
 		dev_err(dev, "Invalid iova 0x%lx and/or length 0x%lx to sync\n",
 			iova, length);
 		return -EINVAL;
 	}
 
 	/* bitmap is modified in 64 bit chunks */
-	bmp_bytes = ALIGN(DIV_ROUND_UP(length / dirty->region.page_size,
+	bmp_bytes = ALIGN(DIV_ROUND_UP(length / region->page_size,
 				       sizeof(u64)), sizeof(u64));
 	if (bmp_bytes != bitmap_size) {
 		dev_err(dev,
@@ -478,23 +479,23 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	bmp_offset = DIV_ROUND_UP((iova - dirty->region.start) /
-				  dirty->region.page_size, sizeof(u64));
+	bmp_offset = DIV_ROUND_UP((iova - region->start) /
+				  region->page_size, sizeof(u64));
 
 	dev_dbg(dev,
 		"Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu bmp_bytes %llu\n",
 		iova, length, bmp_offset, bmp_bytes);
 
-	err = pds_vfio_dirty_read_seq(pds_vfio, bmp_offset, bmp_bytes);
+	err = pds_vfio_dirty_read_seq(pds_vfio, region, bmp_offset, bmp_bytes);
 	if (err)
 		return err;
 
-	err = pds_vfio_dirty_process_bitmaps(pds_vfio, dirty_bitmap, bmp_offset,
-					     bmp_bytes);
+	err = pds_vfio_dirty_process_bitmaps(pds_vfio, region, dirty_bitmap,
+					     bmp_offset, bmp_bytes);
 	if (err)
 		return err;
 
-	err = pds_vfio_dirty_write_ack(pds_vfio, bmp_offset, bmp_bytes);
+	err = pds_vfio_dirty_write_ack(pds_vfio, region, bmp_offset, bmp_bytes);
 	if (err)
 		return err;
 
-- 
2.17.1


