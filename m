Return-Path: <kvm+bounces-33660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C1429EFDA8
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 21:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34E47188C23A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69231BD504;
	Thu, 12 Dec 2024 20:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="znF+a0eh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CAD54723
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 20:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036669; cv=fail; b=ALTAtpMb4V1amDG97GJ54HV36HlPmQ+YiRPZRFslSFnUrfOooe3i895eNgEkhe2dLM3FmaLdT0HSe60lWGCdZPsAgOKbTTskI250Uh7u1tnN86VYii93BkSpDy+eEUD12z7t4e3KcDj2fLOyvbUdJBrliD7RbATXY5efqGBAyqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036669; c=relaxed/simple;
	bh=jg9Css73brpAivk0n+zyndzSf9gxjE03DtOQt71PcOc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MHO052pPv+B54529YgwroezRs6Do8o65hFnFiJmn+jCbgRBAighEIbJG8ul2LyWv9Vm8MUxkHBLOjFfvRor9b5aMgQ9HfuL1LX8R0RlVa5xgxOJxcRaNcEjjmlK8QY+rbVUJ42/NolNzdwTpNTlDuSfimjqom+ppga8FBIP6lL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=znF+a0eh; arc=fail smtp.client-ip=40.107.92.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U6hS5O+A3ysKqyN0w58p6r8XmSVapkWVQm93wBckJj1FMLq4df0g1rT2hmDV72/zvZ2Q7OZRywbHuTfJbUsqOD+W5OBcTVV6ZNzrdUT29supLJ1gI1U7xzOJm+j0nqjTOvCvuNf9gh+XCraYcBIJz8Kx4LqFVHkzLuFxNA4g1in5vp0NfJbCwnVB32mbNwnntCUi8Qf6yK8kG9C8z9RVnjzfmOLzMWnptCcreMU3BpzweVK67it5H1Vj+RwZFu4BxQdm2R9fJciFNgQk4L3jwsbPYaWa1ygnDh2uOUo+rJ1cxMjfdFy3a51e0jT2v3KcUrk2MJJ6kmr6Ww0tOfoxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbWIdA6Gn1hu9PQX1yy5RmNAU7KB4ZAMR1IwRQs8CI4=;
 b=AYfwuVphVuCb27PnmWtGD8qhTseXlIHJYuQO/O48aArcpWNnvU3pVQuybNaP4TWRaa7H/aFY3oarKYqrMp6S0F1IHdvY0W13C05CFe8o2mRObG1Ea8vRiUx0dcx26ziqXCEVn378tqaqkiloN76PYl30JzHnGjwpU5cIkH1981/TiIsgRL1i796o0IUv76Di9nA73n/t+KEap9rbVKd4xH6eqjBMHddVZi5a5iTUOQVr7f6MfjV+8j5OzTp98L5LKc++OsNvCBuXumVg05IbSHLDX8FOrhZ3fDJok45L0Q3WXH3zPCNcIto0uOGFDZt8zvlim1Tr/KAG+EiY9P1c1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbWIdA6Gn1hu9PQX1yy5RmNAU7KB4ZAMR1IwRQs8CI4=;
 b=znF+a0ehjxaRWnt9HlimvEI8f24Im5IfZew5uHB/kB9aUHLFAKA6InOh9bG657WLnvj9xi72E9zSL2S6Zy+uE/ZdMbAfT9esY4JUgyUkJDbsnhigWTbQnrL5xQepQnRj8QZ3L1U+/5c0g3ME/Vn7MaUVarHMDdynSueUGQLmSr4=
Received: from BN9PR03CA0388.namprd03.prod.outlook.com (2603:10b6:408:f7::33)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Thu, 12 Dec
 2024 20:51:01 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:f7:cafe::74) by BN9PR03CA0388.outlook.office365.com
 (2603:10b6:408:f7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.15 via Frontend Transport; Thu,
 12 Dec 2024 20:51:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 20:51:01 +0000
Received: from MKM-L10-YUNXIA9.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 14:51:00 -0600
From: Yunxiang Li <Yunxiang.Li@amd.com>
To: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>
CC: <kevin.tian@intel.com>, <yishaih@nvidia.com>, <ankita@nvidia.com>,
	<jgg@ziepe.ca>, Yunxiang Li <Yunxiang.Li@amd.com>
Subject: [PATCH 2/3] vfio/pci: refactor vfio_pci_bar_rw
Date: Thu, 12 Dec 2024 15:50:49 -0500
Message-ID: <20241212205050.5737-2-Yunxiang.Li@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241212205050.5737-1-Yunxiang.Li@amd.com>
References: <20241212205050.5737-1-Yunxiang.Li@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: a1f7a539-7e9b-4b0c-0920-08dd1aeeaff9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jguzQv7oAeVfjv8cT8PbnJlExLrSoSS9sSZ93uZdJS8iQeJ1IKxb9tzSTLe/?=
 =?us-ascii?Q?3ID4Tvlsr0H5ymYK6a5RKLv+XmlPT0eQyxKOoDVMVTaWNz95b4x3TA7Rg+sW?=
 =?us-ascii?Q?Rq3DFeQJazi4boWYAE05e+NHYOEwG43E0p+G3z1FZ4GvjW6/JyJOuWggrBtM?=
 =?us-ascii?Q?jgnViMDQrsBzAVD6Q9TLm1a1kjEGaPGe3r4lD3kJj0m0dgaFqBLEggJVvIux?=
 =?us-ascii?Q?I4bEXVrwecrYAFiWvPNYctSyqCmsSdiY1UzUXyCJySBd1PS4DIKoS3HUpqlM?=
 =?us-ascii?Q?hnUzGggE6UH9+w9vwAY10Lr3ODEw1ZGClRsQ7eHwodDKUukwV3dSdoARSoZM?=
 =?us-ascii?Q?2mjxpwZRLF0o4Iy5wRnGtfW5NyVvak3lcEvNZ7kzbHe4yy+kdvtPjG8FzUrz?=
 =?us-ascii?Q?g5q3wH5+WsJzyHk5/ZJR5CgZJx9Jh8WTBkGjbNRDDj0e4kCUtzja40VJ0zk9?=
 =?us-ascii?Q?4R4sukL3q9p6USL68bYTqLxkvc1TynuTGtgdyxra1w9/1XpPwh+tz2n4rGNY?=
 =?us-ascii?Q?636Jfi8G4nvpSQqvFNNHtXxlfCrNYxsaD+8QguDXSmd62gvX0+xeWZmdEP+K?=
 =?us-ascii?Q?PIC0OBtccBSXy7FTusPusZONrrPbZCmNJl9o+1nu50h1zrVXoDIf19l1ZfEJ?=
 =?us-ascii?Q?4F8nM8RPmmYykGhv+vL1yX2+UfUKrzeLr4g+kv6RBJB2Mpcw5k5GKumuuIpG?=
 =?us-ascii?Q?+fVrN7NUkYBQGkVnCncHTne3ehUBPJ//EvNr6q1t6CqGHlKBuFG3AnP4mXpF?=
 =?us-ascii?Q?cUrkjJX93rNDHRPo6gcDomawUgoTtEfC9r6AOQgDqrwCjFhh+unl2yRfJpRE?=
 =?us-ascii?Q?Pd5jx+/GpegZhkpgRLxoN5wRo0i+2Ht/dQqDA5t8kjX8x6rlNa40yJuIBFS8?=
 =?us-ascii?Q?Vzwq/eeyNvBvpCtR9Fz0kT7ic5VwOKNQGScUf3F3BAqBHvjPeEOfvr83tIo7?=
 =?us-ascii?Q?e+KyerHAe9KUQ6uzUvu+SS1Pfa3lmVUjoP+JdTQ8R6URjZOTO2AKbFcunXiq?=
 =?us-ascii?Q?xLG/8zEGYY1j5UieIXhC6lp7QvIZwPpp6gzf3e81s0zipjdEReaHMwnWfr0D?=
 =?us-ascii?Q?HrUwsB5NNyZupZGun1PhLuwL+eyMzebQ94wQZ1cFzxqKqMqjsjIZl+pFyhfq?=
 =?us-ascii?Q?H27M0n7r/D3vYnJxe7VSHtnwMSrO2hxCYo7743WIZIK6aktFF5x2rgSz4wRp?=
 =?us-ascii?Q?xoOdwMuCp9jFc+TFjhruuF+yk1y1QMsY1rew8V2ZjnQUJ/0/OclzkDRFdzY3?=
 =?us-ascii?Q?2GFB0KfXotYcOaJWifs1BBkpaZ89bUerBUCGkXcPmrrWpydlzwBfiNJNCcV8?=
 =?us-ascii?Q?4NC8fT6S7O8q96ciYkg3Wr/g5Z5L4SrQP4P/mfcQDaleoUhPgvs0xsBS84qt?=
 =?us-ascii?Q?2nSgeqJ1VO/O+U+Sx4+L8KSqnAXlLbMRBxyr6qlqrouhayHNwwt6ptPJVoUO?=
 =?us-ascii?Q?tMrywMrvDgq/3COkECPURIpTLoAGh53l?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 20:51:01.2725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f7a539-7e9b-4b0c-0920-08dd1aeeaff9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

In the next patch the logic for reading ROM will get more complicated,
so decouple the ROM path from the normal path. Also check that for ROM
write is not allowed.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 47 ++++++++++++++++----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a1eeacad82120..4bed9fd5af50f 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -236,10 +236,9 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	struct pci_dev *pdev = vdev->pdev;
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	int bar = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	size_t x_start = 0, x_end = 0;
+	size_t x_start, x_end;
 	resource_size_t end;
 	void __iomem *io;
-	struct resource *res = &vdev->pdev->resource[bar];
 	ssize_t done;
 
 	if (pci_resource_start(pdev, bar))
@@ -253,41 +252,43 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	count = min(count, (size_t)(end - pos));
 
 	if (bar == PCI_ROM_RESOURCE) {
+		if (iswrite)
+			return -EINVAL;
 		/*
 		 * The ROM can fill less space than the BAR, so we start the
 		 * excluded range at the end of the actual ROM.  This makes
 		 * filling large ROM BARs much faster.
 		 */
 		io = pci_map_rom(pdev, &x_start);
-		if (!io) {
-			done = -ENOMEM;
-			goto out;
-		}
+		if (!io)
+			return -ENOMEM;
 		x_end = end;
+
+		done = vfio_pci_core_do_io_rw(vdev, 1, io, buf, pos,
+					      count, x_start, x_end, 0);
+
+		pci_unmap_rom(pdev, io);
 	} else {
-		int ret = vfio_pci_core_setup_barmap(vdev, bar);
-		if (ret) {
-			done = ret;
-			goto out;
-		}
+		done = vfio_pci_core_setup_barmap(vdev, bar);
+		if (done)
+			return done;
 
 		io = vdev->barmap[bar];
-	}
 
-	if (bar == vdev->msix_bar) {
-		x_start = vdev->msix_offset;
-		x_end = vdev->msix_offset + vdev->msix_size;
-	}
+		if (bar == vdev->msix_bar) {
+			x_start = vdev->msix_offset;
+			x_end = vdev->msix_offset + vdev->msix_size;
+		} else {
+			x_start = 0;
+			x_end = 0;
+		}
 
-	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
+		done = vfio_pci_core_do_io_rw(vdev, pci_resource_flags(pdev, bar) & IORESOURCE_MEM, io, buf, pos,
 				      count, x_start, x_end, iswrite);
-
-	if (done >= 0)
-		*ppos += done;
-
-	if (bar == PCI_ROM_RESOURCE)
-		pci_unmap_rom(pdev, io);
+	}
 out:
+	if (done > 0)
+		*ppos += done;
 	return done;
 }
 
-- 
2.47.0


