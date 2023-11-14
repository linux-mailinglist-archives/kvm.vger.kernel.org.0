Return-Path: <kvm+bounces-1700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1827C7EB81D
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 22:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B5801C20AED
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 21:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818DF2FC59;
	Tue, 14 Nov 2023 21:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R5M+vNXC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF472FC21
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 21:01:56 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276F89F;
	Tue, 14 Nov 2023 13:01:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqMdfp7ZmNr83AJ8heIAqAI2cD52t59a0QbGxi4rZ/lnr3pyVHTo3/oJZ5sYHXls8eN29aJP0VjIUABeAND23NcxnRCCnLuZglPozozVQ9MDaWxxd/qrmnhzCnZpZ+X3o7MBi/GBndE+GSTEW9ZBxgIpmPFhBsumwcOfwdhhkU1BWq9Koi7uBnI/akQOAYxWoZquVCjUeqWLuV7Fi8pTQei0TBkJZDq8mIjh+SRyDcz4fdPROTMAUyDwxGr++wMURDksogCY/VTxm4S8m10S1y7IAd9bPC58TFwZNML9aEFyCuBuO2EX73jRhcDA3vr8QuwK95LaFQ9UMIkkFjQVow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmBVAmLQJTYgIixOa4zDj5CeJPC5bPKtdSLc2+w/WTY=;
 b=R8Vo9JAwEToIhToktH/V3icmPLhoMfMXXvtmqs8jPY3Lf0nKLfs3sycyZKXCLsVF3UykCJjGo5Fb4s4y0fkGtUZrzcehfwOOrv27cN8JDRg3IHvaxk4TPyN50gHkwAz+P4QR+MRZ2gLaBeARpjpVLpdAhyoPmU0O4xBULF2LOfUkYRiyM2J6/nA0q8LC8Rj9XERRkn+cuw9DiDDw3PB5U7f4pPear07UDabQknhMBYI0JGSloYXEqU2dzYfbMyep64X8U2PNQ3O8M7piER4fdc6AqrKxDu+hiu2oPXzkO3kJ6uqmlVLAr1PP5WAdWWkLLzFXh5A5pn9oyg2eANME9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmBVAmLQJTYgIixOa4zDj5CeJPC5bPKtdSLc2+w/WTY=;
 b=R5M+vNXCYEEhyo2MNMHNGQ9VzzQvDrifDeCcdnL4Uu6YXlqEZ8384myuzjUGNoUpIdINVB3PbzvKxbSHtefhs8K31NtkhOBRz1yX4zV3165Urw/1qEL/78EWDLTwy6mhQzLJveWalWhdzEuDY94gMmgR1bVj76DNohV07e+Ji2A=
Received: from BL1PR13CA0291.namprd13.prod.outlook.com (2603:10b6:208:2bc::26)
 by MW4PR12MB7029.namprd12.prod.outlook.com (2603:10b6:303:1ef::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 21:01:51 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2bc:cafe::cb) by BL1PR13CA0291.outlook.office365.com
 (2603:10b6:208:2bc::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.15 via Frontend
 Transport; Tue, 14 Nov 2023 21:01:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.13 via Frontend Transport; Tue, 14 Nov 2023 21:01:50 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Tue, 14 Nov
 2023 15:01:47 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 2/5] pds-vfio-pci: Move and rename region specific info
Date: Tue, 14 Nov 2023 13:01:26 -0800
Message-ID: <20231114210129.34318-3-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 14e4ded7-7d5b-4a14-15aa-08dbe554ec54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	S/eAuoUzx+xCmnkys/k6w/vQC/a1Xplx1E/Vz7rOd6irVOQ5cFtbh9+Lm2nHV00fKhVTPRFzDFYc2wp3V9AiMvH4wvR8+2v20Z3Uf1gNozTskoqP+ZuSN+Vnw5kydkSpCXzkR0jqT2+jMLKQXo3ZNHrWiHE7/2eR2IVUDv/ow6lp7GPcrvKrsQPKHDzeYpYm2aImah7aFZBEZ7M3+b7MZ46SCLs2MQ6svVroQ75ttqfahsvmsrcbEoDl2/r0QZRmK/X9LCuvpZLfom6s2f3BIiW7MC/wJ6A6E9M/F1hPk9lE52SLLgypntwncDNCtETkEs5rk7uJ65iUDQ/DmnzlGcKfV8jnfh1/9AWbJhzgBceJp/RWODsV70q8CXSV3GG4CCpLDPcYRb8XaGKetIol0rh144P7HWHfX2unw7FJ9gyD8K+DqwAbyEUj6f79fSsAo3SqVjfW0X2wEglCRSaNMAZIMxLfT76CE/hRBykGzjG4XwhT4B6MuqBWy9FLeN7N8oTRXEKZsIt7CNc4u0IwDMBSGef1ENnEj2rJP+W3Debd8CD3cYm5L4XvaPNZcGczn+ad/wjVx7VEWLGDMyKiH0dRbVXyy+2vp6K8JItpWe8MKk41XRf63IVVBKu/3ayye1TBD4pFT8EbGgqpo0BNiUZTvj+6WSmCGRsVeZ3Lga4dDf2rvUSeiscKJROS5h+5UI6OfkuHhnn99Y/RMVfubGAhKpzIwXRWhY6SGncvsUF70YCIakqD9xjPAO2Z2Krj6TnKaz4addBKSsy23MEPxA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(136003)(346002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(82310400011)(36840700001)(46966006)(40470700004)(36756003)(40460700003)(86362001)(426003)(26005)(2906002)(16526019)(336012)(83380400001)(54906003)(44832011)(1076003)(2616005)(5660300002)(47076005)(316002)(478600001)(6666004)(8676002)(8936002)(4326008)(81166007)(356005)(40480700001)(82740400003)(110136005)(70206006)(70586007)(36860700001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 21:01:50.4722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e4ded7-7d5b-4a14-15aa-08dbe554ec54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029

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
index b6f517bc5667..bee1bfdcbda9 100644
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
@@ -451,26 +453,25 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
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
 
-	if (!length || ((dirty->region_start + iova + length) >
-			(dirty->region_start + dirty->region_size))) {
+	if (!length || ((dirty->region.start + iova + length) >
+			(dirty->region.start + dirty->region.size))) {
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
@@ -478,7 +479,7 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	bmp_offset = DIV_ROUND_UP(iova / dirty->region_page_size, sizeof(u64));
+	bmp_offset = DIV_ROUND_UP(iova / dirty->region.page_size, sizeof(u64));
 
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


