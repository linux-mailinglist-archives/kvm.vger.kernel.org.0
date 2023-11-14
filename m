Return-Path: <kvm+bounces-1702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 68FC77EB81F
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 22:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B389B20D99
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 21:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C4C33070;
	Tue, 14 Nov 2023 21:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YmfKEEE0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70D52FC3F
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 21:01:59 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFA510D;
	Tue, 14 Nov 2023 13:01:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuW+snMoHlOBmFgWAqyzpY1j78Rv5naLAJgFuZp20VDku85yivJzOWCS2h6jiDgKCDTkMN8Nr20jequMdPfxlrOJGe3/AMMXdCjJUc7ojwmg2IlQ6fvxSMhf2FgyjQQEpFTWXYketcY3vi8Fs0AO78M7abb5E8T73clYCD341mK0897ONr4Xn4D8JA41MXkKzXo3tmJNEkkFyuzfg/zmeXy3ig3PPHEQIvgfxY6WQo0HF7gncBmBYivioxaEsiQs24LdkTGNHCOjhuVwMcTPLLSO1uMunZoid6A+qOj0mrzcj2AoUiKgLyrpXrxCYRw6woaiuEBYFfAG/PYVP02TtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/+dBYlEr/Y+R2M6Rfxkw9s9PGAW5PiypbL/ANGu1kg=;
 b=UdEzzI4b4wSTdPy2I55xBNB+MFiYVkTrRHPXWOnDLXWjI9lkCSp0VCvl/zhSG356GVKW2KWSTAcrMw8cSF0ysoCqTWrDs8orhjjApuUZzKJ3B7Z0qfaIEjJ83ZwaZ+TpAEf04kskbtXxiAWn2Zn43c8lTXx8CVkk+APENC6yf9Brpv5SnaGZf1hzq37fnozu4qZYNglL3rRabri5n7D+dlrPu+N6X2XQ6PNQ+G215KqePrhgY23MB22h6LT9BssgblwXCMOEi9sXUD7etpwt4ZNGSWPaUzs2i52XuENOGrFj5zRSnymLbMuSTkEayO1g5itW0UMkALYEp7xjzn+KLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/+dBYlEr/Y+R2M6Rfxkw9s9PGAW5PiypbL/ANGu1kg=;
 b=YmfKEEE0G3FFRgwDSjGE/6DsfgEVXyXARzpWI1+u7P3QZnyQktZXec8E0JuxyPIgTNwibefL/OKKzTJc/wuE5gajYa6kudCYkk0lZy2RCzKuq4VdvMkWmiu/Z63Ph20r3V5wGIqvCEVVTvvKY5mCPY6KXhzV48mx4yPAa6fuPgc=
Received: from BL0PR05CA0004.namprd05.prod.outlook.com (2603:10b6:208:91::14)
 by CY5PR12MB6081.namprd12.prod.outlook.com (2603:10b6:930:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Tue, 14 Nov
 2023 21:01:54 +0000
Received: from MN1PEPF0000F0DE.namprd04.prod.outlook.com
 (2603:10b6:208:91:cafe::bd) by BL0PR05CA0004.outlook.office365.com
 (2603:10b6:208:91::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.14 via Frontend
 Transport; Tue, 14 Nov 2023 21:01:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0DE.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.13 via Frontend Transport; Tue, 14 Nov 2023 21:01:53 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Tue, 14 Nov
 2023 15:01:51 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 4/5] pds-vfio-pci: Move seq/ack bitmaps into region struct
Date: Tue, 14 Nov 2023 13:01:28 -0800
Message-ID: <20231114210129.34318-5-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DE:EE_|CY5PR12MB6081:EE_
X-MS-Office365-Filtering-Correlation-Id: a2978f0f-78b6-4a8f-c317-08dbe554ee3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WQ02BRUD1OWKCsIqPmkyFdnGF+LAnPm5pt10j9q2setE7c/7We8a9B1zS7r+bHtmYE23Sq0c3/xw+beyFYfwxEAKd1SIjCtAMZHgyGPlo7c9Qma0TMyDwEvkGW4+xcAfygkhg5fzWsGJ88LDsp7CMGD38qM9FtNb/JGzn5up3cjgoXEfqF50gGwYBIsfldE3pWOJVteFzWzsv04kfAFwtU2xyHSVXOIMKOHZkm9M4S9+2jfFpIfKmFbfx1gU+1FDG37pOyf4gE6XI7KzvQqv75Z8rDIlcisk3BxlRsFQIL5oidnM8dghMcNWwzyyGqxDEAdWhmqguElYgzrRwzc1j11oKqa6ge0xfRDmSXP+tE2bgWSevy25vO2BIsndDhGrRZPRaUjsJivxKZat5sHB829NOou5zopCJtSoQZo3YpVNcrf2ZgrDVeZZ4teZgT5OpuGjiiO1I+vJI4kz00rvJuB5kutBMJKhCRfd17GLB3zjIsnIQZorhcNeK2EmOslaBrjuKmf2H8S2WBpPxsnxjLl/PigJhJknrehgUvWYF6hVyzV1hFgcRMp9V716eCvcWWQi+1gt7LPe3DmW8TpccP0jLG7cfk6oafDnEDJ6Ub6Maqm6azk4y6GNrbOwyzCcGbGjUV1d7CTg9Y2YLfJWIUt0NGBwsayolim4oixt4csjonBfWjKsPJ/rRWnyJFiqr+zjQOk0TujRDVJz0hYiiC4Nr7VlaMRYx+RtUBoqCvkAgaxW9uBCqxzCUfaauivgzA3kYLMZhBAk4+B5kz5gRA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(39860400002)(376002)(230922051799003)(82310400011)(64100799003)(451199024)(1800799009)(186009)(46966006)(40470700004)(36840700001)(70206006)(54906003)(70586007)(316002)(83380400001)(16526019)(110136005)(82740400003)(8676002)(40480700001)(8936002)(4326008)(81166007)(478600001)(36756003)(6666004)(356005)(44832011)(40460700003)(86362001)(5660300002)(2616005)(1076003)(36860700001)(2906002)(26005)(426003)(336012)(47076005)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 21:01:53.6905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2978f0f-78b6-4a8f-c317-08dbe554ee3c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6081

Since the host seq/ack bitmaps are part of a region
move them into struct pds_vfio_region. Also, make use
of the bmp_bytes value for validation purposes.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/dirty.c | 35 ++++++++++++++++++++++-------------
 drivers/vfio/pci/pds/dirty.h | 10 +++-------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 50df526a5ccc..d4ab97e39d3f 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -85,18 +85,20 @@ static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
 		return -ENOMEM;
 	}
 
-	dirty->region.host_seq.bmp = host_seq_bmp;
-	dirty->region.host_ack.bmp = host_ack_bmp;
+	dirty->region.host_seq = host_seq_bmp;
+	dirty->region.host_ack = host_ack_bmp;
+	dirty->region.bmp_bytes = bytes;
 
 	return 0;
 }
 
 static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
 {
-	vfree(dirty->region.host_seq.bmp);
-	vfree(dirty->region.host_ack.bmp);
-	dirty->region.host_seq.bmp = NULL;
-	dirty->region.host_ack.bmp = NULL;
+	vfree(dirty->region.host_seq);
+	vfree(dirty->region.host_ack);
+	dirty->region.host_seq = NULL;
+	dirty->region.host_ack = NULL;
+	dirty->region.bmp_bytes = 0;
 }
 
 static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
@@ -301,8 +303,8 @@ void pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio, bool send_cmd)
 
 static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 				  struct pds_vfio_region *region,
-				  struct pds_vfio_bmp_info *bmp_info,
-				  u32 offset, u32 bmp_bytes, bool read_seq)
+				  unsigned long *seq_ack_bmp, u32 offset,
+				  u32 bmp_bytes, bool read_seq)
 {
 	const char *bmp_type_str = read_seq ? "read_seq" : "write_ack";
 	u8 dma_dir = read_seq ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
@@ -319,7 +321,7 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 	int err;
 	int i;
 
-	bmp = (void *)((u64)bmp_info->bmp + offset);
+	bmp = (void *)((u64)seq_ack_bmp + offset);
 	page_offset = offset_in_page(bmp);
 	bmp -= page_offset;
 
@@ -387,7 +389,7 @@ static int pds_vfio_dirty_write_ack(struct pds_vfio_pci_device *pds_vfio,
 				    u32 offset, u32 len)
 {
 
-	return pds_vfio_dirty_seq_ack(pds_vfio, region, &region->host_ack,
+	return pds_vfio_dirty_seq_ack(pds_vfio, region, region->host_ack,
 				      offset, len, WRITE_ACK);
 }
 
@@ -395,7 +397,7 @@ static int pds_vfio_dirty_read_seq(struct pds_vfio_pci_device *pds_vfio,
 				   struct pds_vfio_region *region,
 				   u32 offset, u32 len)
 {
-	return pds_vfio_dirty_seq_ack(pds_vfio, region, &region->host_seq,
+	return pds_vfio_dirty_seq_ack(pds_vfio, region, region->host_seq,
 				      offset, len, READ_SEQ);
 }
 
@@ -411,8 +413,8 @@ static int pds_vfio_dirty_process_bitmaps(struct pds_vfio_pci_device *pds_vfio,
 	int dword_count;
 
 	dword_count = len_bytes / sizeof(u64);
-	seq = (__le64 *)((u64)region->host_seq.bmp + bmp_offset);
-	ack = (__le64 *)((u64)region->host_ack.bmp + bmp_offset);
+	seq = (__le64 *)((u64)region->host_seq + bmp_offset);
+	ack = (__le64 *)((u64)region->host_ack + bmp_offset);
 	bmp_offset_bit = bmp_offset * 8;
 
 	for (int i = 0; i < dword_count; i++) {
@@ -481,6 +483,13 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
+	if (bmp_bytes > region->bmp_bytes) {
+		dev_err(dev,
+			"Calculated bitmap bytes %llu larger than region's cached bmp_bytes %llu\n",
+			bmp_bytes, region->bmp_bytes);
+		return -EINVAL;
+	}
+
 	bmp_offset = DIV_ROUND_UP(iova / region->page_size, sizeof(u64));
 
 	dev_dbg(dev,
diff --git a/drivers/vfio/pci/pds/dirty.h b/drivers/vfio/pci/pds/dirty.h
index 07662d369e7c..a1f6d894f913 100644
--- a/drivers/vfio/pci/pds/dirty.h
+++ b/drivers/vfio/pci/pds/dirty.h
@@ -4,14 +4,10 @@
 #ifndef _DIRTY_H_
 #define _DIRTY_H_
 
-struct pds_vfio_bmp_info {
-	unsigned long *bmp;
-	u32 bmp_bytes;
-};
-
 struct pds_vfio_region {
-	struct pds_vfio_bmp_info host_seq;
-	struct pds_vfio_bmp_info host_ack;
+	unsigned long *host_seq;
+	unsigned long *host_ack;
+	u64 bmp_bytes;
 	u64 size;
 	u64 start;
 	u64 page_size;
-- 
2.17.1


