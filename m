Return-Path: <kvm+bounces-55689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A431CB34E56
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9110A1A87445
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8F329BDB4;
	Mon, 25 Aug 2025 21:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DuCKwCRG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAB01DAC95;
	Mon, 25 Aug 2025 21:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756158432; cv=fail; b=SyriHHufSN+jPL3zJ3YemlFAkUXQh/EEZ9FsyidEtfa70gQC4ZrKTXRKDhwp5OwIZ+6JLnvwkaSiGzZUOjJjR54ihlcgrvhtpoNVswykUdTOHeoIAmMq411UCw2kAOujOe5VZbZ0H9uNAn4wF6D/oUVkIugQ0II84thyLw+Rsew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756158432; c=relaxed/simple;
	bh=jU6ilVy6u8K8SUIYY7ppKZLxuoTh1NpfKfa6E5gkpMw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rf/Q94QlRgbM1kPxuIja340rTnog5oFg+c3l60CQyDxnqV2YGNZduawiEA9uvtACVKIt0Zi1abrSGPbuKElQqmZV9YW0O+h9a+GmoatC3nzcqp/BN8FdKiS+oVRPUY34bR1S7u/n7B2/Fr1S7SxI5H6rNY4DsV+Pfx4D8xm4k/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DuCKwCRG; arc=fail smtp.client-ip=40.107.237.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tApWvmzkYY/+6QYANS4rzR59GuqSGmQiqdIRiEbMtlSUIibk9mRvfHGwpWQeswwJXNaFUs9ZTObPZaCMi3Uy3HKdxDA+iVm12H2Y0V8g9gF0RKgFNP33SUTdVxCYY9DICGVbh/7kaDGoX4ivoy7icIMT/tTW1sRw8zF8LN7r0olC7gwPOdUq6KJNEjwv9kx50Gq02/jDXV5cfKVkQQZwxnwY/eBZ/R88nYDwmJ787uYyDSL0Fw40BiO+RU8cnIu7FElPeXXB3+NXH0J0uBg0PsUe4ncn97sdJ+q+Av5zRzzSPg6YWMdUUhkYsdjx/NFXRVbcsTfgaITRmofd2W8MVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKYujyeim6mX/Yjhu9jaa3uLsemTTTcDM1y/3XuCPX8=;
 b=prsI8cNU+taQ05DuoAy9U542YiZBgMGdOiECO+nfpd9QE6PSzVzajkS1nJS4XXk+DZoaeBE1cLFuwRHYxhXPeluEbO6mxRAusO2wYpKsEPloOUzmDykoeLQydMxs+LqqDkEPfteHBEaYS2Q8N4hkKMut2UBT9HbOFjNr74rbcLIl4RC6t+kBitBuPa5lP3/MvspfXW8fItr4MVMM59+zeaxK7c1n6uD6SE5qM+0oYakfK32PZZgH4uMufjoZ2zcqw5ESn52ib+PIEMUS9sH/itJprJuKXFB6alfywB8HOwsp0bUVd8bYFkPWsDAvmQ9BVh46wLZGZYYo0T5CCA2bRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKYujyeim6mX/Yjhu9jaa3uLsemTTTcDM1y/3XuCPX8=;
 b=DuCKwCRGZGVtxh6t0HuHsq8Yzhj1cZPdlIg+jhiMMkSefGihuQuCyd6+h/1nIHGIlCmLaWsOGegYvShjniayNdBFe3VnVjnQS7TOKa21Qb4b7DdDfIloSx7o6o9U52PvFMGG/s9zwqX05iHoFAb1X3GI0ooE8xk1Qa48bcGozmU=
Received: from MN2PR05CA0063.namprd05.prod.outlook.com (2603:10b6:208:236::32)
 by DS7PR12MB5886.namprd12.prod.outlook.com (2603:10b6:8:79::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Mon, 25 Aug 2025 21:47:06 +0000
Received: from BN3PEPF0000B370.namprd21.prod.outlook.com
 (2603:10b6:208:236:cafe::f5) by MN2PR05CA0063.outlook.office365.com
 (2603:10b6:208:236::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Mon,
 25 Aug 2025 21:47:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B370.mail.protection.outlook.com (10.167.243.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 21:47:06 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 16:47:03 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v6 4/4] iommu/amd: Skip enabling command/event buffers for kdump
Date: Mon, 25 Aug 2025 21:46:53 +0000
Message-ID: <576445eb4f168b467b0fc789079b650ca7c5b037.1756157913.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1756157913.git.ashish.kalra@amd.com>
References: <cover.1756157913.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B370:EE_|DS7PR12MB5886:EE_
X-MS-Office365-Filtering-Correlation-Id: 86d8131e-90a7-43d0-ec8f-08dde420ef90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sZKjWWJUncN0GeBQ8tH3ugFzvtzfy4Dm8kDjO+Ie5Omdd8GL4aStLhyBeeXY?=
 =?us-ascii?Q?yTLSsz6afBtUhiePmTTF5j0oMnTWEZGP1rAgdx8lQdOiNYJrIUz/SBsML9pv?=
 =?us-ascii?Q?AsnfJ+MoK51GpNjXDBsuJwFAbyFFm6b73bMKN2bGwgfvg8JpHQvtt5IGSJ5A?=
 =?us-ascii?Q?fzdFy8UMYdA+ed+UvLECl7ZxrMp2+0LRRTLSpXs0IcA0puevcEEZ43Q3IxUl?=
 =?us-ascii?Q?wclO/KWwDReqHaTTJeYcWCJfLRh322Fi6QI5ew5ZQpxgaxbsyg0SrxI9pLJL?=
 =?us-ascii?Q?4y+OgVbir+ubmmxHuDCMmphasNQdM7O2VjnccqymqJkuus9k45aS7FRSllvt?=
 =?us-ascii?Q?bYATobIld6yXqkIbMYUT8I0wBrwhfkIdVePmoiD3FKdd3iedaC89WCY6ze9F?=
 =?us-ascii?Q?+ZHe5F0t8tmoFSZBMSfGCpK1E3Nk+csgtPkh3qScJkUjmW1Vka1vmA6MMweQ?=
 =?us-ascii?Q?rsoQ5OBMyYFBDlzzGici0tqFAZ0DkmRVgDZtu6E+pmRJZZX43nxg7v3wW88Y?=
 =?us-ascii?Q?LdRfQ35R6xOOSLcf5hYZ+On2/aoBO9A8GNWNVHnF83DCA+fPMB5KheD1LxqR?=
 =?us-ascii?Q?yG67T8yRodZraqQr31kbEGNVTkc03PjRy8+skvy0YmkWKovqWrrlbrFOxaAU?=
 =?us-ascii?Q?V9Zw2Nd9+1zzjdnKUtHvsPNGGZWgfKHzTDTHCqLdRCiHGWRWqKvdcqwa11BX?=
 =?us-ascii?Q?tLraEPWV+qqb4sLqLEBWrDAXev3cjt9zLul+D6qyTMeIEZQPISw3MSwp8qrS?=
 =?us-ascii?Q?BnCvcRVZ6suEwO/HQdtevcbXIy7f3Ajc7G/I5Ej5LjKykNzG79j9Nv/mb0V9?=
 =?us-ascii?Q?68GwYWGbOow4V3amO2LnH+2KPfTpYZ08rAHfeWeeYUjkA22CbUt0/ymFugNu?=
 =?us-ascii?Q?nTFw6VeewOUrJ9GucHXxdWO23wr+6yR+R87+WiQZH20xKajqe+ziSPQ4GWsH?=
 =?us-ascii?Q?4TCiiDj6Mo9VL4iu1M96Q9iiNsGZMGj7A/mJMWydFkPUHheqQOws3z69uVOI?=
 =?us-ascii?Q?OsoVUzCKPzrIX1VVFfaypGWE7agqh8bBRmCIq5pQm03oUpFaqAILl+kOucqf?=
 =?us-ascii?Q?SpBSFB+as/xn4oNnQLLWh/Qx2jIjXVoCu14QxEooixf82LzHGq31xC7FSJJ2?=
 =?us-ascii?Q?AvHnvV/xDiuJN2ajjkQoXfcCqybGDce8P3YAvkCteGn5eMtdflqyzycbnuDt?=
 =?us-ascii?Q?tmWHtj4FdV5upQjD/I2R9Ad4qvmd7PWhvLj7ZHvMojPl0THGupv5mv3KdGCR?=
 =?us-ascii?Q?iksTo7x3WQb35WRiWuwMDGoUVVXnctUYyNXguNjh2agS54msuT+30qCLXCZJ?=
 =?us-ascii?Q?pkNkyYdbMRahdLr4f6pLB5u8cj6d19Nzl04xe7D3NYjFjFS6BEftnxsz9Omo?=
 =?us-ascii?Q?/axYjgHNmBm8FM70YJipLsRwUEqbAAw2/CUcFd7aO5hsQItYJjcnbpDMizIt?=
 =?us-ascii?Q?MLafc0RkJwwnf1ZkfuYVBDqtr3UhzjuiE+THeAIPFU/TU9Ipz/Yj9gNl50mS?=
 =?us-ascii?Q?/GfboX+NPUjWRg874WNWU0Y/36Rn7/LrjA1X?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 21:47:06.5387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d8131e-90a7-43d0-ec8f-08dde420ef90
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5886

From: Ashish Kalra <ashish.kalra@amd.com>

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU command buffers and event buffer registers remain locked and
exclusive to the previous kernel. Attempts to enable command and event
buffers in the kdump kernel will fail, as hardware ignores writes to
the locked MMIO registers as per AMD IOMMU spec Section 2.12.2.1.

Skip enabling command buffers and event buffers for kdump boot as they
are already enabled in the previous kernel.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/init.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index dac6282675da..d179344ad598 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -821,11 +821,16 @@ static void iommu_enable_command_buffer(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->cmd_buf == NULL);
 
-	entry = iommu_virt_to_phys(iommu->cmd_buf);
-	entry |= MMIO_CMD_SIZE_512;
-
-	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-		    &entry, sizeof(entry));
+	if (!is_kdump_kernel()) {
+		/*
+		 * Command buffer is re-used for kdump kernel and setting
+		 * of MMIO register is not required.
+		 */
+		entry = iommu_virt_to_phys(iommu->cmd_buf);
+		entry |= MMIO_CMD_SIZE_512;
+		memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
+			    &entry, sizeof(entry));
+	}
 
 	amd_iommu_reset_cmd_buffer(iommu);
 }
@@ -876,10 +881,15 @@ static void iommu_enable_event_buffer(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->evt_buf == NULL);
 
-	entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
-
-	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
-		    &entry, sizeof(entry));
+	if (!is_kdump_kernel()) {
+		/*
+		 * Event buffer is re-used for kdump kernel and setting
+		 * of MMIO register is not required.
+		 */
+		entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+		memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+			    &entry, sizeof(entry));
+	}
 
 	/* set head and tail to zero manually */
 	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
-- 
2.34.1


