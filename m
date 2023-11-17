Return-Path: <kvm+bounces-1899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C7447EEA3A
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:13:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 103CC281168
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857851C16;
	Fri, 17 Nov 2023 00:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oMaDh7b0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD583D53;
	Thu, 16 Nov 2023 16:12:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjiQ3BOqEpGVVA2VFpdb+ANkMyJHE25n6AM74DJJLdR3l5/d2SL6dBKme8g1j+0B/3qHOK4lqIx6A9Pnmv5cb8ipW9TUOc7K5nLCqQYoBCy1irTqQIcpegPj90TFJzCINu3lScM8zPbk1RjmJURJLuYylA4Qh7e/eCr99uXgs1qSg/qu+uiyfk+OVv5pqsxT/IWvwkgf0wlOWGwaHxmpOxD+vrBMzeuA7pv0oJSblaujNhpAkkrs6QnfPwr4EdC0lyXSVCiZiJl1j7jPcX+mxBUHEzdF1BO6ppSiu/92Aw7gUaspXmsum7P1i52THEKgjyMH7vOFgszrej9QsYS2Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8UqkfEjGjWJP3Sz/PdcwDGyFdh1CHUzlPmQQ0Sqwfk=;
 b=F4T2Qb2FvD7XVX6FwnDo5U1TPs/CfXTLywBJ3tEnWxA1wiIpwJRP7wknrzQTzvTaKXgB2+bLBhsOqlJTjGHoeeMhwFB8fZmtvIEsSNllLp8H/PAMoadzjSaO6Sl2+ahtL7PgGBprSeeehqU89sgvodrDbpEqba4mJ6rsEGrcr0c0kBPdnbTuyVf5kuYR524uV7TbUA5H00pcsruFcRr5gmcIcwh5Ip/h68IdgCO0iohf6JvH4cER4f8fFpgZc3osJGyFuNShZcq2pCXDt0hbT6g/a+ZZGtRU3LwzHBFRZJvZuLXIIN93HrTxopMQURmsZ9FWPBw5sAW8c9E0rVYtlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8UqkfEjGjWJP3Sz/PdcwDGyFdh1CHUzlPmQQ0Sqwfk=;
 b=oMaDh7b0lCxwr0fkZK2Kl9rGMx6Jtoxj801GT8ygW4VlscvrnEJtdm3VgEpvxlICfh7Lc1vGLOF/ryqevi+L9+iVDftDLr+5LXxlwmcUOCU/d77aA3otYQolc++TnygXuU+/zmOvDZ9hSao0FrUNtjQVKa94vKpBr0Od5Wm29iw=
Received: from PA7P264CA0053.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:34a::17)
 by CO6PR12MB5412.namprd12.prod.outlook.com (2603:10b6:5:35e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Fri, 17 Nov
 2023 00:12:33 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10a6:102:34a:cafe::12) by PA7P264CA0053.outlook.office365.com
 (2603:10a6:102:34a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21 via Frontend
 Transport; Fri, 17 Nov 2023 00:12:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.20 via Frontend Transport; Fri, 17 Nov 2023 00:12:32 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Thu, 16 Nov
 2023 18:12:28 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v2 vfio 5/6] vfio/pds: Move seq/ack bitmaps into region struct
Date: Thu, 16 Nov 2023 16:12:06 -0800
Message-ID: <20231117001207.2793-6-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|CO6PR12MB5412:EE_
X-MS-Office365-Filtering-Correlation-Id: 74365d1b-862f-4ac0-7746-08dbe701e4ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NFMUEJF4BpZCa05XEW1+gX6tTlk/OzDEQt+ou7FDxjtR1ajzTiAtSmckDVzMXvhmt1lOLrIoodn6rTGhc/xzYVVeZrGRShOCF67jYSpq3RBeKrNSdj6psDqqoXmnBdFnpgtKdoAfyNnRA2lFvmFlM1tRJy+lZdY3GRaxUY7vHyrPyjdP1DjTa9X5zf66w1o7Yqqj15dOMD2ouDmq0gCAm4tu50kIwfx+Q5c9GjkMhkVc4F5UrwX1Gf9SUuQ6bDq/x/in7l8oH0LbAUEz4euSmducwuhR3oj6H4v4BAhJll9C7pKqOeBL4yN6TWcCKgMQ7m1abVhoKohofrQU0rjTm5xZuQr3XLIpHwyK9gbbmk9RYoniofpCiHJVFusgYJEIu0duqvaomW49A1NAvjSUbofV8SnuJRAo/1DWgEgMKC2Uab/Bn3S0+zLeKLNp7IPBN2u+yv9zltxphrolIQRAW3azyhgh3n8EgT5pCgXT+DzpX1Igl74VJ9d2/DIwUo/K7kYbgZpCt2z082newaxA1tn4bue9NY1DdNPxi8OlTmBfzTYgG9bt39ST4+cR+xcyHftdg5bJgUUS6nQ3xVDJBbFPO1vjTzxrpeXbFVxZCU+zKW2IvNiUtp8HhQ3ojkdmGYAMBGY4hSKhR+LHAwXF4OAgqQxhPWOPITLNip/ItW5MHFNSfFz4+TeaUPTkIMWbl6goW5c2fgdKEd+gbX3lVEf3UfJn6DWFxsWBLU4EFXopyC6zi62Xg5BK5EaZMnZEzMBV8BcA0g+Z34w7wy1amA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(230922051799003)(82310400011)(451199024)(1800799009)(186009)(64100799003)(36840700001)(40470700004)(46966006)(2906002)(5660300002)(36860700001)(1076003)(44832011)(40460700003)(2616005)(86362001)(41300700001)(26005)(426003)(47076005)(336012)(16526019)(110136005)(82740400003)(316002)(70206006)(70586007)(83380400001)(54906003)(478600001)(6666004)(36756003)(81166007)(8676002)(356005)(4326008)(40480700001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2023 00:12:32.4143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74365d1b-862f-4ac0-7746-08dbe701e4ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5412

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
index 09fed7c1771a..4824cdfe01ed 100644
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
@@ -479,6 +481,13 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
+	if (bmp_bytes > region->bmp_bytes) {
+		dev_err(dev,
+			"Calculated bitmap bytes %llu larger than region's cached bmp_bytes %llu\n",
+			bmp_bytes, region->bmp_bytes);
+		return -EINVAL;
+	}
+
 	bmp_offset = DIV_ROUND_UP((iova - region->start) /
 				  region->page_size, sizeof(u64));
 
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


