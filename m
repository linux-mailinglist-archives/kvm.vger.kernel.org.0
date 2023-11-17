Return-Path: <kvm+bounces-1900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7B1B7EEA3D
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D2232810D1
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E7B2580;
	Fri, 17 Nov 2023 00:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Rk3oneTD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4C9D6C;
	Thu, 16 Nov 2023 16:12:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5FL8HJnRc3nsRWaHbH5ma4ZmbS/W+dLzo5z+W9i+mW1MeG+svkyDaEJ1QR/Y/eOFG6x2/xMDrTyfQWmBSHvZ0ufy9wkfXSbav4+B9kudRjoTkVwJuFEjLpBRFLSM287Le5pWn87gLVxM8YiwYb1dSyR2m3OQfVRKObX+ES9bacdb4yzK7ctq83egV1heb6LkQWVzWYvaWHf+d3X8UePZyZaZovJjT0gCCrW4fdVKLfoyH+OgKI2HQ8xdaKhGuKD/RreGq7w774xEogPFRnKHT9cjKWUOeVhZr+NoK12rp0cGoGs1vbFLuYsRK2vwqBP3qyW2SAjZWlhFzVF7Wp89g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAc8K6n4VRk6+guLll3nNSoi6EhVEJLHA7ctYlFBhDo=;
 b=nsXI3Rdat2197CNxpm4rMYEt26ya+2TlokhPIlmFtqXXA1ApKtiuXLyUfwvx8tFEX1yZj1Dbo7+iQy63DleMSdFkMtUyJxttMk3FmLpXZWLovqdngzn1RuxoiP3Cc/byaCHhSdOIdRWmD/a3heHoL8jNuXy7JIJbUezicaquZbimSuJFhaPeU3dwhcysiNYz0B52+zG+WFqe/NkRH07OpPEpxAmga6HvNCogFcvz7EygfXUkrBPsp/Ssj0mIR/fRTn+0OrrAKQLNLJVPsPXP3QWCrgqzECPxE5m1N1s9Kev9Yoj0CU/slpZx1KjMKPINAz+zjiVKIw9Mc07lFihfiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAc8K6n4VRk6+guLll3nNSoi6EhVEJLHA7ctYlFBhDo=;
 b=Rk3oneTDCV1zl9zE00l/D+fYCNb2fEMQ5yPCayS1d106vABlLZMU4wlDNP4iV9D2G8vgN0gPaLj3t2sy+GVKApUP0AnsH1hbmARdmOCfwLbsmCLcxzzemWJh3LU1kWsYN5ZIWYECfg1xu07dg3wiYE5a8vr3ybeyvENWekciy5w=
Received: from PA7P264CA0050.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:34a::16)
 by SJ2PR12MB8064.namprd12.prod.outlook.com (2603:10b6:a03:4cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Fri, 17 Nov
 2023 00:12:41 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10a6:102:34a:cafe::ed) by PA7P264CA0050.outlook.office365.com
 (2603:10a6:102:34a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.20 via Frontend
 Transport; Fri, 17 Nov 2023 00:12:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.20 via Frontend Transport; Fri, 17 Nov 2023 00:12:34 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Thu, 16 Nov
 2023 18:12:30 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v2 vfio 6/6] vfio/pds: Add multi-region support
Date: Thu, 16 Nov 2023 16:12:07 -0800
Message-ID: <20231117001207.2793-7-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|SJ2PR12MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: dc2f5366-a0c1-4798-92d8-08dbe701e5e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xhPxB7p7eDzmz0bPZaFu91g+ly7sQoJOQ4MaWLeuDB4gp0APXZwCnBiC0jN12qsK8frv/ykh9rGuTfJfR+UnGIF+i0II4f8k2qr+cuKXsVQOnS8XGVlCnAgR+OKe6vdOuW3NxjSWbGA8Fjaup6iq919AipKAPl+QqRBpDZ+UpU6cRhrBAeLWTWIqg8WuinFketRf+HxwmmoEBud8qLZVeXGoJ1m2pKliCAmlnSWWyooc0ev/WhMw2TjDsUP/4YOxZ35A4Lc36n7AKPMgMXjL/CwKsQ2itrH4eGGuEhAm+lZTdasEOKIBAqampLZPXknBQpGw6vxfBXvfoBpRfAgwTb5H16cw2soBNYcnEXnFUKDPP3G95neQvZ6kXd8HXcB1KAdQAHWzaX0swe+nNBk6rTG/Mkm1afFfWlNV4KCbgTMnwmYAqZk7iBhB+F+cQLligmj1VfLLilWKsITrRqihdc8tjqt/FuuKhyuBmT2bpEvbYy5JjRF/vK4kkaAmEUXN3zfmp4WkTfVL0kXZXDxHyRIok8uDzJ6Ptwhh+lYnNHnA11RxOTp1sS1S9NZwvrcvji2eKKv7RStIpKGOFLb7giJuhCpPaaSz1QSC2KB28auIw6zax/B3dQku5ywo5GMT/Lo1ANzNTWIMB3zuFONZVJIoffQrpctGLpH+ofnaV7rgq5GMs+Qpmi3r5C7Euew0wCMkoiuE/AmRrD6nNBEl43PzarAv3MzePhmYisojIJuTuzMydDfQm+v2iRQy9wicQIVy1O3/3BsK4DC0BtRDIw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(39860400002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(82310400011)(36840700001)(40470700004)(46966006)(110136005)(40480700001)(41300700001)(47076005)(2906002)(36860700001)(2616005)(1076003)(70206006)(70586007)(54906003)(6666004)(316002)(36756003)(478600001)(426003)(336012)(40460700003)(83380400001)(8936002)(26005)(8676002)(44832011)(5660300002)(30864003)(16526019)(356005)(4326008)(86362001)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2023 00:12:34.0705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2f5366-a0c1-4798-92d8-08dbe701e5e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8064

Only supporting a single region/range is limiting,
wasteful, and in some cases broken (i.e. when there
are large gaps in the iova memory ranges). Fix this
by adding support for multiple regions based on
what the device tells the driver it can support.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/dirty.c | 220 ++++++++++++++++++++++++-----------
 drivers/vfio/pci/pds/dirty.h |   4 +-
 2 files changed, 156 insertions(+), 68 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 4824cdfe01ed..8ddf4346fcd5 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -70,7 +70,7 @@ pds_vfio_print_guest_region_info(struct pds_vfio_pci_device *pds_vfio,
 	kfree(region_info);
 }
 
-static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
+static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_region *region,
 					unsigned long bytes)
 {
 	unsigned long *host_seq_bmp, *host_ack_bmp;
@@ -85,20 +85,27 @@ static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
 		return -ENOMEM;
 	}
 
-	dirty->region.host_seq = host_seq_bmp;
-	dirty->region.host_ack = host_ack_bmp;
-	dirty->region.bmp_bytes = bytes;
+	region->host_seq = host_seq_bmp;
+	region->host_ack = host_ack_bmp;
+	region->bmp_bytes = bytes;
 
 	return 0;
 }
 
 static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
 {
-	vfree(dirty->region.host_seq);
-	vfree(dirty->region.host_ack);
-	dirty->region.host_seq = NULL;
-	dirty->region.host_ack = NULL;
-	dirty->region.bmp_bytes = 0;
+	if (!dirty->regions)
+		return;
+
+	for (int i = 0; i < dirty->num_regions; i++) {
+		struct pds_vfio_region *region = &dirty->regions[i];
+
+		vfree(region->host_seq);
+		vfree(region->host_ack);
+		region->host_seq = NULL;
+		region->host_ack = NULL;
+		region->bmp_bytes = 0;
+	}
 }
 
 static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
@@ -119,10 +126,17 @@ static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
 
 static void pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio)
 {
-	struct pds_vfio_region *region = &pds_vfio->dirty.region;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
 
-	if (region->sgl)
-		__pds_vfio_dirty_free_sgl(pds_vfio, region);
+	if (!dirty->regions)
+		return;
+
+	for (int i = 0; i < dirty->num_regions; i++) {
+		struct pds_vfio_region *region = &dirty->regions[i];
+
+		if (region->sgl)
+			__pds_vfio_dirty_free_sgl(pds_vfio, region);
+	}
 }
 
 static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
@@ -156,22 +170,90 @@ static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
 	return 0;
 }
 
+static void pds_vfio_dirty_free_regions(struct pds_vfio_dirty *dirty)
+{
+	vfree(dirty->regions);
+	dirty->regions = NULL;
+	dirty->num_regions = 0;
+}
+
+static int pds_vfio_dirty_alloc_regions(struct pds_vfio_pci_device *pds_vfio,
+					struct pds_lm_dirty_region_info *region_info,
+					u64 region_page_size, u8 num_regions)
+{
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	u32 dev_bmp_offset_byte = 0;
+	int err;
+
+	dirty->regions = vcalloc(num_regions, sizeof(struct pds_vfio_region));
+	if (!dirty->regions)
+		return -ENOMEM;
+	dirty->num_regions = num_regions;
+
+	for (int i = 0; i < num_regions; i++) {
+		struct pds_lm_dirty_region_info *ri = &region_info[i];
+		struct pds_vfio_region *region = &dirty->regions[i];
+		u64 region_size, region_start;
+		u32 page_count;
+
+		/* page_count might be adjusted by the device */
+		page_count = le32_to_cpu(ri->page_count);
+		region_start = le64_to_cpu(ri->dma_base);
+		region_size = page_count * region_page_size;
+
+		err = pds_vfio_dirty_alloc_bitmaps(region,
+						   page_count / BITS_PER_BYTE);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to alloc dirty bitmaps: %pe\n",
+				ERR_PTR(err));
+			goto out_free_regions;
+		}
+
+		err = pds_vfio_dirty_alloc_sgl(pds_vfio, region, page_count);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
+				ERR_PTR(err));
+			goto out_free_regions;
+		}
+
+		region->size = region_size;
+		region->start = region_start;
+		region->page_size = region_page_size;
+		region->dev_bmp_offset_start_byte = dev_bmp_offset_byte;
+
+		dev_bmp_offset_byte += page_count / BITS_PER_BYTE;
+		if (dev_bmp_offset_byte % BITS_PER_BYTE) {
+			dev_err(&pdev->dev, "Device bitmap offset is mis-aligned\n");
+			err = -EINVAL;
+			goto out_free_regions;
+		}
+	}
+
+	return 0;
+
+out_free_regions:
+	pds_vfio_dirty_free_bitmaps(dirty);
+	pds_vfio_dirty_free_sgl(pds_vfio);
+	pds_vfio_dirty_free_regions(dirty);
+
+	return err;
+}
+
 static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 				 struct rb_root_cached *ranges, u32 nnodes,
 				 u64 *page_size)
 {
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
-	u64 region_start, region_size, region_page_size;
 	struct pds_lm_dirty_region_info *region_info;
 	struct interval_tree_node *node = NULL;
+	u64 region_page_size = *page_size;
 	u8 max_regions = 0, num_regions;
 	dma_addr_t regions_dma = 0;
 	u32 num_ranges = nnodes;
-	u32 page_count;
-	u16 len;
 	int err;
+	u16 len;
 
 	dev_dbg(&pdev->dev, "vf%u: Start dirty page tracking\n",
 		pds_vfio->vf_id);
@@ -198,39 +280,38 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 		return -EOPNOTSUPP;
 	}
 
-	/*
-	 * Only support 1 region for now. If there are any large gaps in the
-	 * VM's address regions, then this would be a waste of memory as we are
-	 * generating 2 bitmaps (ack/seq) from the min address to the max
-	 * address of the VM's address regions. In the future, if we support
-	 * more than one region in the device/driver we can split the bitmaps
-	 * on the largest address region gaps. We can do this split up to the
-	 * max_regions times returned from the dirty_status command.
-	 */
-	max_regions = 1;
 	if (num_ranges > max_regions) {
 		vfio_combine_iova_ranges(ranges, nnodes, max_regions);
 		num_ranges = max_regions;
 	}
 
+	region_info = kcalloc(num_ranges, sizeof(*region_info), GFP_KERNEL);
+	if (!region_info)
+		return -ENOMEM;
+	len = num_ranges * sizeof(*region_info);
+
 	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
 	if (!node)
 		return -EINVAL;
+	for (int i = 0; i < num_ranges; i++) {
+		struct pds_lm_dirty_region_info *ri = &region_info[i];
+		u64 region_size = node->last - node->start + 1;
+		u64 region_start = node->start;
+		u32 page_count;
 
-	region_size = node->last - node->start + 1;
-	region_start = node->start;
-	region_page_size = *page_size;
+		page_count = DIV_ROUND_UP(region_size, region_page_size);
 
-	len = sizeof(*region_info);
-	region_info = kzalloc(len, GFP_KERNEL);
-	if (!region_info)
-		return -ENOMEM;
+		ri->dma_base = cpu_to_le64(region_start);
+		ri->page_count = cpu_to_le32(page_count);
+		ri->page_size_log2 = ilog2(region_page_size);
 
-	page_count = DIV_ROUND_UP(region_size, region_page_size);
+		dev_dbg(&pdev->dev,
+			"region_info[%d]: region_start 0x%llx region_end 0x%lx region_size 0x%llx page_count %u page_size %llu\n",
+			i, region_start, node->last, region_size, page_count,
+			region_page_size);
 
-	region_info->dma_base = cpu_to_le64(region_start);
-	region_info->page_count = cpu_to_le32(page_count);
-	region_info->page_size_log2 = ilog2(region_page_size);
+		node = interval_tree_iter_next(node, 0, ULONG_MAX);
+	}
 
 	regions_dma = dma_map_single(pdsc_dev, (void *)region_info, len,
 				     DMA_BIDIRECTIONAL);
@@ -239,39 +320,20 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 		goto out_free_region_info;
 	}
 
-	err = pds_vfio_dirty_enable_cmd(pds_vfio, regions_dma, max_regions);
+	err = pds_vfio_dirty_enable_cmd(pds_vfio, regions_dma, num_ranges);
 	dma_unmap_single(pdsc_dev, regions_dma, len, DMA_BIDIRECTIONAL);
 	if (err)
 		goto out_free_region_info;
 
-	/*
-	 * page_count might be adjusted by the device,
-	 * update it before freeing region_info DMA
-	 */
-	page_count = le32_to_cpu(region_info->page_count);
-
-	dev_dbg(&pdev->dev,
-		"region_info: regions_dma 0x%llx dma_base 0x%llx page_count %u page_size_log2 %u\n",
-		regions_dma, region_start, page_count,
-		(u8)ilog2(region_page_size));
-
-	err = pds_vfio_dirty_alloc_bitmaps(dirty, page_count / BITS_PER_BYTE);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to alloc dirty bitmaps: %pe\n",
-			ERR_PTR(err));
-		goto out_free_region_info;
-	}
-
-	err = pds_vfio_dirty_alloc_sgl(pds_vfio, &dirty->region, page_count);
+	err = pds_vfio_dirty_alloc_regions(pds_vfio, region_info,
+					   region_page_size, num_ranges);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
-			ERR_PTR(err));
-		goto out_free_bitmaps;
+		dev_err(&pdev->dev,
+			"Failed to allocate %d regions for tracking dirty regions: %pe\n",
+			num_regions, ERR_PTR(err));
+		goto out_dirty_disable;
 	}
 
-	dirty->region.start = region_start;
-	dirty->region.size = region_size;
-	dirty->region.page_size = region_page_size;
 	pds_vfio_dirty_set_enabled(pds_vfio);
 
 	pds_vfio_print_guest_region_info(pds_vfio, max_regions);
@@ -280,8 +342,8 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 
 	return 0;
 
-out_free_bitmaps:
-	pds_vfio_dirty_free_bitmaps(dirty);
+out_dirty_disable:
+	pds_vfio_dirty_disable_cmd(pds_vfio);
 out_free_region_info:
 	kfree(region_info);
 	return err;
@@ -295,6 +357,7 @@ void pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio, bool send_cmd)
 			pds_vfio_dirty_disable_cmd(pds_vfio);
 		pds_vfio_dirty_free_sgl(pds_vfio);
 		pds_vfio_dirty_free_bitmaps(&pds_vfio->dirty);
+		pds_vfio_dirty_free_regions(&pds_vfio->dirty);
 	}
 
 	if (send_cmd)
@@ -365,6 +428,7 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 
 	num_sge = sg_table.nents;
 	size = num_sge * sizeof(struct pds_lm_sg_elem);
+	offset += region->dev_bmp_offset_start_byte;
 	dma_sync_single_for_device(pdsc_dev, region->sgl_addr, size, dma_dir);
 	err = pds_vfio_dirty_seq_ack_cmd(pds_vfio, region->sgl_addr, num_sge,
 					 offset, bmp_bytes, read_seq);
@@ -437,13 +501,28 @@ static int pds_vfio_dirty_process_bitmaps(struct pds_vfio_pci_device *pds_vfio,
 	return 0;
 }
 
+static struct pds_vfio_region *
+pds_vfio_get_region(struct pds_vfio_pci_device *pds_vfio, unsigned long iova)
+{
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+
+	for (int i = 0; i < dirty->num_regions; i++) {
+		struct pds_vfio_region *region = &dirty->regions[i];
+
+		if (iova >= region->start &&
+		    iova < (region->start + region->size))
+			return region;
+	}
+
+	return NULL;
+}
+
 static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 			       struct iova_bitmap *dirty_bitmap,
 			       unsigned long iova, unsigned long length)
 {
 	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
-	struct pds_vfio_region *region = &dirty->region;
+	struct pds_vfio_region *region;
 	u64 bmp_offset, bmp_bytes;
 	u64 bitmap_size, pages;
 	int err;
@@ -456,6 +535,13 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
+	region = pds_vfio_get_region(pds_vfio, iova);
+	if (!region) {
+		dev_err(dev, "vf%u: Failed to find region that contains iova 0x%lx length 0x%lx\n",
+			pds_vfio->vf_id, iova, length);
+		return -EINVAL;
+	}
+
 	pages = DIV_ROUND_UP(length, region->page_size);
 	bitmap_size =
 		round_up(pages, sizeof(u64) * BITS_PER_BYTE) / BITS_PER_BYTE;
diff --git a/drivers/vfio/pci/pds/dirty.h b/drivers/vfio/pci/pds/dirty.h
index a1f6d894f913..c8e23018b801 100644
--- a/drivers/vfio/pci/pds/dirty.h
+++ b/drivers/vfio/pci/pds/dirty.h
@@ -13,11 +13,13 @@ struct pds_vfio_region {
 	u64 page_size;
 	struct pds_lm_sg_elem *sgl;
 	dma_addr_t sgl_addr;
+	u32 dev_bmp_offset_start_byte;
 	u16 num_sge;
 };
 
 struct pds_vfio_dirty {
-	struct pds_vfio_region region;
+	struct pds_vfio_region *regions;
+	u8 num_regions;
 	bool is_enabled;
 };
 
-- 
2.17.1


