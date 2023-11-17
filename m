Return-Path: <kvm+bounces-1895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA2FA7EEA2D
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:12:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26D861C208A3
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3375803;
	Fri, 17 Nov 2023 00:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u3DD+Wtx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB4FEA;
	Thu, 16 Nov 2023 16:12:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxMBcehIMsBREnFp+uVlJG95RpaMlzyFnLO1fs2mc0RLS6t8iqDZTsPF3UcdI5w8HS2Sby7K3uV/p+kzhdFgV9Es4szZPBJ/JBvJ6RI0lgLVqLPZmuutyp8bBL5wFAh3HykLhS6d6Nb8U7nVfIPDJ5SdmuekBHk1LnG7uKB+w6hhxT8Rh1oy4aPzCM9yisVhZWsPmYWLe6SPR4aHdpCh/D4dm5hOJQrRQsbTfrf1UOYwnF4nzsJLgSkO76yQnCnIISBnVcBk/t2mPsp4voakSKTWDxqVczcTRg4JMeqQXX9Ps7zhbYTzrpkczQxI6o5262ZEJnxubkMYAfSHbvEW7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ABcmSbNxy9A0u52Zl8pEP47nEwiegt+gejaihor616s=;
 b=C8xaBx6vT5ZaoXiv449N02mb0YynKdj8KItGq79aP7AHJbQUW+I/7AoHIjkvkeacBNhxCPo5Etl6UnECYc8U//zPUkVkZbNqcKKZYKMczRkpilTZ8T39Pl47RCy4Wb+c7+fMNOngZdbs8k7LEsMuBKLywqEQPK9iMt5+sCnEdGb1SsGe2NNZUkKcFg/ESLiknmapWO3VsjBD0rvy1aItcHuk4+h4ZwWebltAcVzw5X4YyX1XDfmnz2S0A9zlAy2lIwJPDV4g4mtPYiH4f1i7s8IoWVbwK9FvEHgSTnpvPe+GfMyS4TqwVzcPYCat7SZBQCGRMM+LIYU6NYYtlYXTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABcmSbNxy9A0u52Zl8pEP47nEwiegt+gejaihor616s=;
 b=u3DD+WtxpXNeau8ZFPPHmlWZRCUH2lySZp30jqc7h2DnhqeAPeX3r+yraHpOXAQ0iC4kAdM3JAcT68O0Pbxvov7RD7LMP+lnApAkugLju0VVRUZuczmtLpUEqUz4pHMkxlliPh/hEIt8C7NRVTQcWw7N+EYJRCFxiBB6Bae4f2E=
Received: from PA7P264CA0049.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:34a::7)
 by SJ2PR12MB8064.namprd12.prod.outlook.com (2603:10b6:a03:4cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Fri, 17 Nov
 2023 00:12:26 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10a6:102:34a:cafe::ef) by PA7P264CA0049.outlook.office365.com
 (2603:10a6:102:34a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21 via Frontend
 Transport; Fri, 17 Nov 2023 00:12:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.20 via Frontend Transport; Fri, 17 Nov 2023 00:12:25 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Thu, 16 Nov
 2023 18:12:22 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v2 vfio 2/6] vfio/pds: Only use a single SGL for both seq and ack
Date: Thu, 16 Nov 2023 16:12:03 -0800
Message-ID: <20231117001207.2793-3-brett.creeley@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4f77ca3e-faf6-4953-59c3-08dbe701e0be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	p8wm1Untcr8SD4T+qXkoLYp2lp5aT125iDjHwIAY6YGrTYKHZOYaLQoBTiay9wONd6/kJBD1/eu/YeJD5IyBkBzzYaG/0xsQZc07ZpfgTMflN220TjWCutE7NmYQ6CmthRhYVnuYgCni/ZDJe4kQw/klPgHzSKQYzD5thLlliYH/OKtjLyMfQVaSkk8lrR9pX+ANmRwcS3GGJpXNLqSe5W1iVYLeHyMekUfAKSge8bqX2+hasFzhkuprGfkZDUqFI0vVq+5tu4hNIWmOR0BaSYAKHCqAB7lb9pXxJqEBo2ikXiT3UhCui2/hMPsSUK4Cgqg/s4qqfpg09DauGKK+IenmZEx3YpsQHaP5bggXyumywGbOJg8TI6gmnmUdJEwRtyu9/bJB+eNSJrHSu3NI3z3KlIcz94RATgg4K03bItsddNdK8uboLvhla5LPYXkuxbkf0F3JC6KnyTChp2OEmhWqA6DoiAHNWc4R8r9sGg3Gm8uF9XwOZQpoAqKu2ACC39Eru5bZzS8/sKohRzPufixcMp3xkOuSCToj/QvTiUeXOZ0+l5upb58kYw6UOnyvw4xKm4CGPXeWnbxllRYW80PpB5Jh40uWmgnQ6IpXCM93H5fnmT1Tx+yneSUgq85R9jnv+QF3yIMgmyU7n2Z1XMlfLCwgROEQ1+RxRGfF/YuojEL7Sv7ZV/sOciAJzyznZJuy1ySKpk+4XHfJkukGYtuSkswgtLEYoJEa4lY5zdznMVWRUqwvbr+I7h/KfLeNalrt0ZaMl2UOkl9vdmO3Iw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(39860400002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(82310400011)(36840700001)(40470700004)(46966006)(110136005)(40480700001)(41300700001)(47076005)(2906002)(36860700001)(2616005)(1076003)(70206006)(70586007)(54906003)(6666004)(316002)(36756003)(478600001)(426003)(336012)(40460700003)(83380400001)(8936002)(26005)(8676002)(44832011)(5660300002)(16526019)(356005)(4326008)(86362001)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2023 00:12:25.4143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f77ca3e-faf6-4953-59c3-08dbe701e0be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8064

Since the seq/ack operations never happen in parallel there
is no need for multiple scatter gather lists per region.
The current implementation is wasting memory. Fix this by
only using a single scatter-gather list for both the seq
and ack operations.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/dirty.c | 68 +++++++++++++-----------------------
 drivers/vfio/pci/pds/dirty.h |  6 ++--
 2 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 27607d7b9030..4462f6edb0ed 100644
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


