Return-Path: <kvm+bounces-1897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 405D97EEA34
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:12:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FF8D280F9E
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD891113;
	Fri, 17 Nov 2023 00:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GcFEN28S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D459D4E;
	Thu, 16 Nov 2023 16:12:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlhnFNV6zIvdF6bBS01uQgGOpVYUeiKxz6XJ6ozHGbhx05hogclZRr7W5WXYNTtjXUpsKUPKSY09tVZGlKI99STj9gySV+LoQnF2BVlhHhSTGgH2YosyO5bp8tAjwuiJ85OK3FxKo176NeQ1+nwk7QPSnE6sFREgtYgGzer/f1iphjpl/GMuOqITUTjpOMIafraBwJwjEqBQr95ZDn+fGRxtoN2jKFROi3FvEq0r/fuIn+rO4ZGQhoHIt8Q3ZEJvmQhZ8nSruBlJRv7VulMgasVdSZ2S635znIgdiQnUhvWdGpa8RGUpmG7/Txv189DY+XSRCojvC7uICUAAXfgsNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0aCv5kc1F6lASyim7qqKiLxTtZip4eFuoqfaNaAV1M=;
 b=RIVZ6R4Mev/6vNjeVLxe14Vn9TH36mvyXn/MF7nCev9J/B73Wj6qBOXyxl9fuv9UgmIoKzeqw1AW80JlclAbH0nThAMR3mg3msnIU3ir1q1K6Q+w/xiW0EimS07HgJLO1lZEaUOnYMapkcLy5wiD6102YT6ap2m8UmVBxtP9uvX8UUceOwtW8kdo7hNmTZseT4zEDWgfdichSz9TWd+ORZsR/bta8QVQ7fN7KiP1aFv2+LM9A3rx64uQWxRxIUbUs6G3JLkbb6f4OxqYy8aNpHJjJTEucj0LWEP1XInnv0tTrSYEC0BeklTpsTaTxhLCk0TjdYW7Y0kO/veHgGthxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0aCv5kc1F6lASyim7qqKiLxTtZip4eFuoqfaNaAV1M=;
 b=GcFEN28SDWvsngn0EkXjA1M6uEQs8JIZsCs/rmkH6c0nfhxfur16pJZBeXOfoDmGFmmR7Reij+ONJXXGMJHkE9It6NA2iGDw4TGuKZqvBxK3eC3vlQgE/vpccJYBy8FN4QbldWPbgox5yL+OlqvwEA59XAlJ2D62zyUAEEoJPFc=
Received: from PA7P264CA0051.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:34a::18)
 by BL3PR12MB6452.namprd12.prod.outlook.com (2603:10b6:208:3bb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.20; Fri, 17 Nov
 2023 00:12:27 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10a6:102:34a:cafe::10) by PA7P264CA0051.outlook.office365.com
 (2603:10a6:102:34a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21 via Frontend
 Transport; Fri, 17 Nov 2023 00:12:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.20 via Frontend Transport; Fri, 17 Nov 2023 00:12:27 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Thu, 16 Nov
 2023 18:12:24 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v2 vfio 3/6] vfio/pds: Move and rename region specific info
Date: Thu, 16 Nov 2023 16:12:04 -0800
Message-ID: <20231117001207.2793-4-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|BL3PR12MB6452:EE_
X-MS-Office365-Filtering-Correlation-Id: 227289ab-c08e-419b-9c6f-08dbe701e1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d2685/4tvAD0dAhsF2jIcp+PXyNqw83T8D87BnMQANTVbMwmjQ+OXSvH3l2M9u86OBU2Q1+9vg8XYBScPwX2djCgYM3alZ8dDfs8+ivXWoGZFinOc53wmggBjWR6sfBIQLMwe2u5pInMkIwYVF3tjrKnswngTFEY3zxFyQDRw5rJB/H3cn+825rw1qMXpGM6L8dHV4ifRlNCxcCj+FVPJD0hRmwA+qlyJyi7sBTg3SFWHE3fwPIDb3kTwcUzgA4URC4digN1BNjE3EjRLk0fQanF+lKQXdl56CCifhbsF72fOOEEcwOCtSDjj23e8XnjLcHiwMUEUwm+Vte/RT7ITFXoU7vLUd6pMFWl/1IGFlACbZrwJGWIxqxqvMTodR8c5KvQH6AZznuinLOGVkcg7xEMVfOLK1pauzNtcvViEZNLNSbvCp0l3GZhu8srN+PGHQ+U0EfhdJe6r7W1j272GOim2eEvLkIidS9xGlYn9CDWia+RgoHHWgq56ZRJBldbZaCvJ5iQL+RPx+/LOIjuojeXdP8dryv0OtGA9B/536BayNz6S6emrotFjrhCWP2V0rkb0zrTXI+d/9jQNpojTehW57JlUsj6bBByrI4F/9Wink9BtgrCSAEwfa6JVIT+MZuBiA7eDnv1sW9I/lldFx67IN74fSdHteboFfU6XDkXzy3GWIhmRZfK8Y6J/uo4UpDzt8yWb5kqX4OpAkQUVS/S4p5seqoEve0m+MAsaia72ccz1MPdb+EzlAYYnCtz00AR29rx/1vXqdrFVrZrAw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(186009)(451199024)(82310400011)(64100799003)(1800799009)(40470700004)(46966006)(36840700001)(16526019)(2616005)(54906003)(316002)(4326008)(426003)(8936002)(336012)(8676002)(1076003)(36756003)(82740400003)(478600001)(26005)(40460700003)(6666004)(110136005)(70586007)(40480700001)(44832011)(356005)(47076005)(70206006)(5660300002)(2906002)(41300700001)(86362001)(36860700001)(83380400001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2023 00:12:27.1174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 227289ab-c08e-419b-9c6f-08dbe701e1c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6452

An upcoming change in this series will add support
for multiple regions. To prepare for that, move
region specific information into struct pds_vfio_region
and rename the members for readability. This will
reduce the size of the patch that actually implements
multiple region support.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/dirty.c | 83 ++++++++++++++++++------------------
 drivers/vfio/pci/pds/dirty.h | 12 ++++--
 2 files changed, 50 insertions(+), 45 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 4462f6edb0ed..8a7f9eed4e59 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -85,18 +85,18 @@ static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
 		return -ENOMEM;
 	}
 
-	dirty->host_seq.bmp = host_seq_bmp;
-	dirty->host_ack.bmp = host_ack_bmp;
+	dirty->region.host_seq.bmp = host_seq_bmp;
+	dirty->region.host_ack.bmp = host_ack_bmp;
 
 	return 0;
 }
 
 static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
 {
-	vfree(dirty->host_seq.bmp);
-	vfree(dirty->host_ack.bmp);
-	dirty->host_seq.bmp = NULL;
-	dirty->host_ack.bmp = NULL;
+	vfree(dirty->region.host_seq.bmp);
+	vfree(dirty->region.host_ack.bmp);
+	dirty->region.host_seq.bmp = NULL;
+	dirty->region.host_ack.bmp = NULL;
 }
 
 static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
@@ -105,21 +105,21 @@ static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
 
-	dma_unmap_single(pdsc_dev, dirty->sgl_addr,
-			 dirty->num_sge * sizeof(struct pds_lm_sg_elem),
+	dma_unmap_single(pdsc_dev, dirty->region.sgl_addr,
+			 dirty->region.num_sge * sizeof(struct pds_lm_sg_elem),
 			 DMA_BIDIRECTIONAL);
-	kfree(dirty->sgl);
+	kfree(dirty->region.sgl);
 
-	dirty->num_sge = 0;
-	dirty->sgl = NULL;
-	dirty->sgl_addr = 0;
+	dirty->region.num_sge = 0;
+	dirty->region.sgl = NULL;
+	dirty->region.sgl_addr = 0;
 }
 
 static void pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio)
 {
 	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
 
-	if (dirty->sgl)
+	if (dirty->region.sgl)
 		__pds_vfio_dirty_free_sgl(pds_vfio, dirty);
 }
 
@@ -147,9 +147,9 @@ static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
 		return -EIO;
 	}
 
-	dirty->sgl = sgl;
-	dirty->num_sge = max_sge;
-	dirty->sgl_addr = sgl_addr;
+	dirty->region.sgl = sgl;
+	dirty->region.num_sge = max_sge;
+	dirty->region.sgl_addr = sgl_addr;
 
 	return 0;
 }
@@ -267,9 +267,9 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 		goto out_free_bitmaps;
 	}
 
-	dirty->region_start = region_start;
-	dirty->region_size = region_size;
-	dirty->region_page_size = region_page_size;
+	dirty->region.start = region_start;
+	dirty->region.size = region_size;
+	dirty->region.page_size = region_page_size;
 	pds_vfio_dirty_set_enabled(pds_vfio);
 
 	pds_vfio_print_guest_region_info(pds_vfio, max_regions);
@@ -304,11 +304,10 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 				  u32 offset, u32 bmp_bytes, bool read_seq)
 {
 	const char *bmp_type_str = read_seq ? "read_seq" : "write_ack";
+	struct pds_vfio_region *region = &pds_vfio->dirty.region;
 	u8 dma_dir = read_seq ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
-	struct pds_lm_sg_elem *sgl;
 	unsigned long long npages;
 	struct sg_table sg_table;
 	struct scatterlist *sg;
@@ -355,9 +354,8 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 	if (err)
 		goto out_free_sg_table;
 
-	sgl = pds_vfio->dirty.sgl;
 	for_each_sgtable_dma_sg(&sg_table, sg, i) {
-		struct pds_lm_sg_elem *sg_elem = &sgl[i];
+		struct pds_lm_sg_elem *sg_elem = &region->sgl[i];
 
 		sg_elem->addr = cpu_to_le64(sg_dma_address(sg));
 		sg_elem->len = cpu_to_le32(sg_dma_len(sg));
@@ -365,15 +363,15 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 
 	num_sge = sg_table.nents;
 	size = num_sge * sizeof(struct pds_lm_sg_elem);
-	dma_sync_single_for_device(pdsc_dev, dirty->sgl_addr, size, dma_dir);
-	err = pds_vfio_dirty_seq_ack_cmd(pds_vfio, dirty->sgl_addr, num_sge,
+	dma_sync_single_for_device(pdsc_dev, region->sgl_addr, size, dma_dir);
+	err = pds_vfio_dirty_seq_ack_cmd(pds_vfio, region->sgl_addr, num_sge,
 					 offset, bmp_bytes, read_seq);
 	if (err)
 		dev_err(&pdev->dev,
 			"Dirty bitmap %s failed offset %u bmp_bytes %u num_sge %u DMA 0x%llx: %pe\n",
 			bmp_type_str, offset, bmp_bytes,
-			num_sge, dirty->sgl_addr, ERR_PTR(err));
-	dma_sync_single_for_cpu(pdsc_dev, dirty->sgl_addr, size, dma_dir);
+			num_sge, region->sgl_addr, ERR_PTR(err));
+	dma_sync_single_for_cpu(pdsc_dev, region->sgl_addr, size, dma_dir);
 
 	dma_unmap_sgtable(pdsc_dev, &sg_table, dma_dir, 0);
 out_free_sg_table:
@@ -387,14 +385,18 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 static int pds_vfio_dirty_write_ack(struct pds_vfio_pci_device *pds_vfio,
 				    u32 offset, u32 len)
 {
-	return pds_vfio_dirty_seq_ack(pds_vfio, &pds_vfio->dirty.host_ack,
+	struct pds_vfio_region *region = &pds_vfio->dirty.region;
+
+	return pds_vfio_dirty_seq_ack(pds_vfio, &region->host_ack,
 				      offset, len, WRITE_ACK);
 }
 
 static int pds_vfio_dirty_read_seq(struct pds_vfio_pci_device *pds_vfio,
 				   u32 offset, u32 len)
 {
-	return pds_vfio_dirty_seq_ack(pds_vfio, &pds_vfio->dirty.host_seq,
+	struct pds_vfio_region *region = &pds_vfio->dirty.region;
+
+	return pds_vfio_dirty_seq_ack(pds_vfio, &region->host_seq,
 				      offset, len, READ_SEQ);
 }
 
@@ -402,15 +404,15 @@ static int pds_vfio_dirty_process_bitmaps(struct pds_vfio_pci_device *pds_vfio,
 					  struct iova_bitmap *dirty_bitmap,
 					  u32 bmp_offset, u32 len_bytes)
 {
-	u64 page_size = pds_vfio->dirty.region_page_size;
-	u64 region_start = pds_vfio->dirty.region_start;
+	u64 page_size = pds_vfio->dirty.region.page_size;
+	u64 region_start = pds_vfio->dirty.region.start;
 	u32 bmp_offset_bit;
 	__le64 *seq, *ack;
 	int dword_count;
 
 	dword_count = len_bytes / sizeof(u64);
-	seq = (__le64 *)((u64)pds_vfio->dirty.host_seq.bmp + bmp_offset);
-	ack = (__le64 *)((u64)pds_vfio->dirty.host_ack.bmp + bmp_offset);
+	seq = (__le64 *)((u64)pds_vfio->dirty.region.host_seq.bmp + bmp_offset);
+	ack = (__le64 *)((u64)pds_vfio->dirty.region.host_ack.bmp + bmp_offset);
 	bmp_offset_bit = bmp_offset * 8;
 
 	for (int i = 0; i < dword_count; i++) {
@@ -451,25 +453,24 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	pages = DIV_ROUND_UP(length, pds_vfio->dirty.region_page_size);
+	pages = DIV_ROUND_UP(length, pds_vfio->dirty.region.page_size);
 	bitmap_size =
 		round_up(pages, sizeof(u64) * BITS_PER_BYTE) / BITS_PER_BYTE;
 
 	dev_dbg(dev,
 		"vf%u: iova 0x%lx length %lu page_size %llu pages %llu bitmap_size %llu\n",
-		pds_vfio->vf_id, iova, length, pds_vfio->dirty.region_page_size,
+		pds_vfio->vf_id, iova, length, pds_vfio->dirty.region.page_size,
 		pages, bitmap_size);
 
-	if (!length || ((iova - dirty->region_start + length) > dirty->region_size)) {
+	if (!length || ((iova - dirty->region.start + length) > dirty->region.size)) {
 		dev_err(dev, "Invalid iova 0x%lx and/or length 0x%lx to sync\n",
 			iova, length);
 		return -EINVAL;
 	}
 
 	/* bitmap is modified in 64 bit chunks */
-	bmp_bytes = ALIGN(DIV_ROUND_UP(length / dirty->region_page_size,
-				       sizeof(u64)),
-			  sizeof(u64));
+	bmp_bytes = ALIGN(DIV_ROUND_UP(length / dirty->region.page_size,
+				       sizeof(u64)), sizeof(u64));
 	if (bmp_bytes != bitmap_size) {
 		dev_err(dev,
 			"Calculated bitmap bytes %llu not equal to bitmap size %llu\n",
@@ -477,8 +478,8 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	bmp_offset = DIV_ROUND_UP((iova - dirty->region_start) /
-				  dirty->region_page_size, sizeof(u64));
+	bmp_offset = DIV_ROUND_UP((iova - dirty->region.start) /
+				  dirty->region.page_size, sizeof(u64));
 
 	dev_dbg(dev,
 		"Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu bmp_bytes %llu\n",
diff --git a/drivers/vfio/pci/pds/dirty.h b/drivers/vfio/pci/pds/dirty.h
index 9de5aac58190..07662d369e7c 100644
--- a/drivers/vfio/pci/pds/dirty.h
+++ b/drivers/vfio/pci/pds/dirty.h
@@ -9,15 +9,19 @@ struct pds_vfio_bmp_info {
 	u32 bmp_bytes;
 };
 
-struct pds_vfio_dirty {
+struct pds_vfio_region {
 	struct pds_vfio_bmp_info host_seq;
 	struct pds_vfio_bmp_info host_ack;
-	u64 region_size;
-	u64 region_start;
-	u64 region_page_size;
+	u64 size;
+	u64 start;
+	u64 page_size;
 	struct pds_lm_sg_elem *sgl;
 	dma_addr_t sgl_addr;
 	u16 num_sge;
+};
+
+struct pds_vfio_dirty {
+	struct pds_vfio_region region;
 	bool is_enabled;
 };
 
-- 
2.17.1


