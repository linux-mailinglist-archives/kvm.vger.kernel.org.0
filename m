Return-Path: <kvm+bounces-53763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB2FB168AA
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 23:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2C8D583B53
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 21:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53CCE2264D3;
	Wed, 30 Jul 2025 21:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tmSYqtMr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1512253A5;
	Wed, 30 Jul 2025 21:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753912618; cv=fail; b=hoExGDbLQm2lp7w3U4ZSh4KnetysYvk1CnLMDF0F8+QfmiwnBvEzt9FNKCDymZrVBrfhMo8+SoaZj4fT+fXoglrthYZiSgpcpRMMr0sDsmTfj8vlWCBbysJR3ycj6/CcqvQe73w6rPMTLfy6Lx1jxTzvIIuA9CWggq++1NV4RtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753912618; c=relaxed/simple;
	bh=jD80cfeyDdfMkUOf12qhy4DK91Ob+1Sr40vtozTC3hg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I04t3M7jAC7whCNlEl9VstiB/JIAunhMqnXTbDfVY2KcUIbvR27u1/1LpsI29oI/2mz2poPaTzB2akoUFQGbQIh6fVaPS1FJVASJ/aYlTdKR53wrVMr7tJuSUC8EapbwW5p2Lc3ViIsKx5+Gd+XDrEEleq+8J0K6dAd7Y0wCrdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tmSYqtMr; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6V3DeQ2+PhZoGYgn63ZO8ux3p0n/Sb/TRyonsn39D+si4EBNAasLIsy6D4QJRhuyFrRMQwX08bUMHQ8HSIhKm9xbBrq3yeIZ+0giU8/gqSSZmtJKzNSrB+8y2ChZWW+nbzSMG3dhLVeMwoEhOhxpyIDz0mOMfP9ZJpwNg6w/YajXq7Fj2FSyklxDPRNjA4GRNJNxGzaY80qGvrcZ/RFj+sNxCxbeuYtWQ8LD1os5QkquMpH1e/rh0CQiBzzoZiTVfhgD0gMWWHUeaRbOKGHs92CKtod3C517mkZFq5fZnaTheQ6zJhJbvxIT8VhLfiTfopVwqz4BvmXqmmzH+WKfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lEx0hoEubJC858v5cvGzNdq9jtTc+gVAF7L8ksbVhB8=;
 b=Vm8HtQEFn83mFVgLnJQvOprJvxNWofAOsFEBOCKXk4kr7KyxsxuNbbsz6Kwl9CqhD7KFKnFbRS0GhaE+5aEtJxJzM+irJnsfRg4jp2xQU3EWTsgrs2KnxG52bEumKMaGllpja6G4UT5LKIuUkxc2lIcwuHTjEgrJs+USHpmtZZrAOJaLMT8a1ac7z98pTvJMQZEzChe4myegyiptkNb8CUtYWWWbbGQQtoLdX7GDifXlpS581k60mhYAhK8AEWISXbX6OaJBUl0fxjMeAJwKlMy7vSHjV5u9XxRRM4ePor0mty/afnCLUvYmZNteAZeAZA4CybJ/G2Gicx8+9y4ppw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEx0hoEubJC858v5cvGzNdq9jtTc+gVAF7L8ksbVhB8=;
 b=tmSYqtMr6qseWy9plFF/hY+ECBruR08ZkOKHgge12ifO06AW2TjqZVQDrVlzN0/u07TQxRjAykIuYRA/vFk5dWy4VQOsBhA/sg1Ew9lQpZxJoBVugZIGmfUd95umcOfHumWvdMK0dgXkipiXw5lh1xqcGAgnNrHYvLZzXjO0lnY=
Received: from BN1PR14CA0018.namprd14.prod.outlook.com (2603:10b6:408:e3::23)
 by SA1PR12MB7444.namprd12.prod.outlook.com (2603:10b6:806:2b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 21:56:52 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:408:e3:cafe::c6) by BN1PR14CA0018.outlook.office365.com
 (2603:10b6:408:e3::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.11 via Frontend Transport; Wed,
 30 Jul 2025 21:56:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.10 via Frontend Transport; Wed, 30 Jul 2025 21:56:50 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 30 Jul
 2025 16:56:49 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v5 4/4] iommu/amd: Skip enabling command/event buffers for kdump
Date: Wed, 30 Jul 2025 21:56:39 +0000
Message-ID: <e66b75e126fa245e126fe81ed73baffdf603369a.1753911773.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753911773.git.ashish.kalra@amd.com>
References: <cover.1753911773.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|SA1PR12MB7444:EE_
X-MS-Office365-Filtering-Correlation-Id: 15def575-a883-4091-9e01-08ddcfb3fcb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1sgl3UXkS3UF7bueEfjevyTYEk4PhYtBPyh+TQdKHnr4gmxxexnD35lzg4a7?=
 =?us-ascii?Q?0xKK3QiJOr4YXaAxsrNsY/7KETVRRQAOwQXeuyOh2vJ0PTktvfTjfv+EXeUp?=
 =?us-ascii?Q?pALQg3fu62JOZB37+ruiPq6iqi+Eq3zg0OM+WegczIJ4+syZ9WJhiv7eMEb7?=
 =?us-ascii?Q?qYB2PrPGz9TbfoNLBd4aoiE6Gm+bu/zQUECAelmzS3vVolTrDKPJ9Wp1x5YF?=
 =?us-ascii?Q?41MY9xWptJ1fK8E4aQLszMFT++sClJZviWR2fFTFa8lFSBA+ieGSZ4VM1rDE?=
 =?us-ascii?Q?X77pM087sbPAB4vxjCN9LPx6y8MHO8T523Im0cS5vx1VTV8jmjVnX9biLTX6?=
 =?us-ascii?Q?XYe/NL9YwwabYHtXJkXStAXy4dP+M0Hn3mVMDx1shlSCa1/tXK7tRVyKW4wL?=
 =?us-ascii?Q?bTMQBLeejjRniKbzy2bE6hY+jW1csBiptdnPU8IWp5SMyVUr5ltIAicLbOAh?=
 =?us-ascii?Q?lHWFhHLA1i7TW/fDsLe2AlXoNoNngo/FrPscYM3aBP+UJntnWg6Xmg//LoWD?=
 =?us-ascii?Q?PUYjnfrDgRAkz9LXm93M6aXieZGBn9Phu2MkcgEzWTAIN3dtShzohFw6lo2g?=
 =?us-ascii?Q?J9y2nlm/GgPbS9Zf64sPqTFmB8+/V+sOkQVNExDdcdbFL3/F4W1B3u4vKJRm?=
 =?us-ascii?Q?QTjXw+g/DKfjO5hE3/tWYsYXBR+2utMsavnwCAiNGgkUpFJzCRCnc/CbhfTq?=
 =?us-ascii?Q?9Pm04Er+m1YW5Ljw5But1Fdh7Hu4bM4QXpeFobdZbBAdDjVJ6FyLLQGAEPZF?=
 =?us-ascii?Q?adV+PE0Isc+/FdFa8f9PC4DWNE0xJeBgEK5BJeuwt/EmiV/OG8eZI9h4QcDl?=
 =?us-ascii?Q?SajKcL1rch6D2q2+51o8C9L2YTKFRpwaCGF2UG3hlUZL7GyJqAucCS4aw4F7?=
 =?us-ascii?Q?pyjH0iqXxBsYXBfTlBglr5oz0+lJ5s4FWKlF94Pr+ruU8CBUocScsTSfjKz5?=
 =?us-ascii?Q?+kS/oo0EO/qNHBvrMq4QUm0rxfTYqfiWSh0WXFV0S9/XPFBJx5HbNrIVghy+?=
 =?us-ascii?Q?avdXZmhMWOSgkNxFaTw0hMH3QN7pvwcmGpkJqS4ZzCw8NClGq9umySPv46o4?=
 =?us-ascii?Q?OmOL90pE78FOTjqMH5eZNN+SNIrlNXSum6eB9+eY+Ew0ltMPyWjXriZdN7Wp?=
 =?us-ascii?Q?PRC08YoII3BeWBraUNGndS9wjtSLOFVG8OsXtGhQ/sk9L6x1buGVS/e04bQq?=
 =?us-ascii?Q?CpBBNdgoa2w45eb2g1LKv6UmV3shgAf6MMyt7So32kb/kL0K81cLJPcm/NgZ?=
 =?us-ascii?Q?7pbtb7cFSsG4Ic+00tczJA+oOuKFdDWumaElxkRmHyE3On1nvwLCYzwDKO7D?=
 =?us-ascii?Q?j5qmWVir8hLf+9MGSeIcLzHfQkK7ut1Q4/q326LFXgrN6ToBUdTys59FtDxA?=
 =?us-ascii?Q?Qg8p+hka+Uuq1nTAPlpcasHjB2GuZevUAx5yUyqRhTuXwE8PL27v2pzAVopJ?=
 =?us-ascii?Q?2MPOSKJ57BxOh6cAKhweQDRF0FNEmdDyoCbZ9cTO2s5O5M9zolUdRvsuyAop?=
 =?us-ascii?Q?bKqo/nMOKJpNXDLDvXx8QN9GJhUzuUA2EvbR?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 21:56:50.1766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15def575-a883-4091-9e01-08ddcfb3fcb3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7444

From: Ashish Kalra <ashish.kalra@amd.com>

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU command buffers and event buffer registers remain locked and
exclusive to the previous kernel. Attempts to enable command and event
buffers in the kdump kernel will fail, as hardware ignores writes to
the locked MMIO registers as per AMD IOMMU spec Section 2.12.2.1.

Skip enabling command buffers and event buffers for kdump boot as they
are already enabled in the previous kernel.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/init.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 05d9c1764883..4e792a112b48 100644
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


