Return-Path: <kvm+bounces-53037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5660B0CCF1
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:54:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B47C16FC91
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A79224167C;
	Mon, 21 Jul 2025 21:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0gQSx8vN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A0922F164;
	Mon, 21 Jul 2025 21:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753134836; cv=fail; b=CuP4Zg+CGqqdjbV85ox+SrqwoS/qtKiIH1XfzU5s/VNRNMysJIkAJ11FT5vbv3coHoYUkExNwbr+sbCtiUlkGEMzoF7MN62xDSsZWxr7uVh/zvY6INlKNsIPF9eA+OZsp+tdDnEtgqJzwXuQ7nph/W2CsXUesRhh5vZzrdvGTGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753134836; c=relaxed/simple;
	bh=j/Y/zppPgniR7c/1ru3sncmxHkYxNrn8eIOyYhIWXi0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jimH2JG0KCxqbJvmewZsq8noEPSDAuMno9EYgwNWwdelZ3Nq2kVyq50CDOEvVYW1xoKrV0Zto6cFpEyxBSqbiHTvFRpUNny//oe9potTP+mZkPhbwqTKvPF3dDAwoj3s6bltcUgUGAksFgPH4YN5WdvhRCmyQC1/euDLJa56YNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0gQSx8vN; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NbczhDDyi0G6RPlo/HSj5gTy7cr6QzPiNTLMcFuqBwZhNaBNabbj1cbcR2yc3uBNX3JbyOabre3gbDCDUSgYOaBtej4gR/4Xc/mSuPu4FDZ/rwPhmuwIZ1ENsU3ufu5GDearwtEeFNFCbF24914Fu/JClrj7slDkO58GdFOXNYRZBjxTv2hteC3VEAsvjLzyTdRjt7vLBJmx4mE+N5YJgI1z5TeEcvDyLeBsqiJKEtHWXhu5PhYlHZ6HEpWcFNikpuIJcTmbFHZt66y6MPFLViI/oYiErCyHdH/RlQz4qQ2TjJL8VoLaruoMif/AxxUnWHz+2+gSnnj59F1hg6o/Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tndTXAmwnD9/UwL0CSWSRacm71qIICFWpP9NlzdDMoU=;
 b=aIf3XMngE1/6viegAVzdUsC5XZqNhCyKNOcAhVb8Xpe2AO85bEpgk+Xyp8nCp8R2LN5ACNZZfkV4rZFnmvKF7LyDod6CMELpUmhirv/uNTuVM9+zBrc3BNEn64HYh5R96rUFHo+bOXXF6+xf5WH8RMbPPAlSk8tgd4iGxW34nhRyQESWaIAhVTkK9W4b6nuMJwIl3et+8RNhDZJiJ47ukD8+MmJL+Pn+xDSK8kyLWD9RvAaa1by0FN0Xnd0GCQKfH4z0KD4mmzrlY6xvtCqHKMVzQH8voZBkldD7FsrSFT55jDZ65vwn1IRMj5qYnri0XGlfinRkxRDnpl/rNL8EqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tndTXAmwnD9/UwL0CSWSRacm71qIICFWpP9NlzdDMoU=;
 b=0gQSx8vNmvRDq2bdJYQJMp6IZweI5nW3dT6YcDtzF46HgqpNI3CSfyIqfYceHMz+1BWA2faR1UYK5SFXH+d93rnSZiKQAPDDi7sEhd025RIFWqSfAPCNKIm94DcHMZoUZgWV2PObtta9VfMbJPTF4lj+OLn7TloPQ8TY4zaGX5o=
Received: from BY3PR10CA0008.namprd10.prod.outlook.com (2603:10b6:a03:255::13)
 by CH3PR12MB9395.namprd12.prod.outlook.com (2603:10b6:610:1ce::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 21:53:50 +0000
Received: from SJ1PEPF000023D7.namprd21.prod.outlook.com
 (2603:10b6:a03:255:cafe::90) by BY3PR10CA0008.outlook.office365.com
 (2603:10b6:a03:255::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.29 via Frontend Transport; Mon,
 21 Jul 2025 21:53:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D7.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.1 via Frontend Transport; Mon, 21 Jul 2025 21:53:48 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 16:53:47 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v4 4/4] iommu/amd: Skip enabling command/event buffers for kdump
Date: Mon, 21 Jul 2025 21:53:38 +0000
Message-ID: <eeecb08fee542b36713769a16e31532537de0727.1753133022.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753133022.git.ashish.kalra@amd.com>
References: <cover.1753133022.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D7:EE_|CH3PR12MB9395:EE_
X-MS-Office365-Filtering-Correlation-Id: fb9f59c8-cef7-4ff6-c144-08ddc8a112f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jA89qs8oBLzWMBrxF/6T3BybSTcInB06nUmjdtDftefJ72PqMQGijPFCLQbD?=
 =?us-ascii?Q?K0ZfJDmsNHnBJTWk/d4ANEOMGUMlD57KLtiKKCyb5naZUhipUDO+CyVdS3rE?=
 =?us-ascii?Q?7MJESxw1It7iQzcb9BlX0ohmO25pcaIJTmDHvvPaqDJkLGjaxFwgVTzFAZmw?=
 =?us-ascii?Q?9kCvYzOk3CiHn+uvO8oH6kpMws8DN2bJSWPPbETt0VyyNJToCCtbWPLP/uW2?=
 =?us-ascii?Q?5kA0sVhzBuzbi7uDA8V7PWan/DmMACRRPw+gPhMDE6FK3sTCIbVRB3DQ0hcc?=
 =?us-ascii?Q?eR5bfTjPmBA86YUgwMYn0Coj9cx3TPynat7pIfrvPbMZ657XpDqt+X/FJ3e8?=
 =?us-ascii?Q?QEKbNaUMoE87VAaWJmQjFDAOmJasllabj0RbbHJ+WoYQ/80cwuVyLJcB71C/?=
 =?us-ascii?Q?5swfJgHrm4O8VtzRc860DSaSMLdNZEwLwBPqn1ELKUojEHhr6EmX7XO3q+i/?=
 =?us-ascii?Q?/JC+x/XNROJGVAhA+/1ipblNvACD26fQyoESIr/VDhRk1L3AKmfTzU1cEy6B?=
 =?us-ascii?Q?3eW+wRtajoUSq1QmPT/ut5cKDRbWdaiKO+eC63asp1xfX5WowtOQnZOH7xjt?=
 =?us-ascii?Q?4Gyr4TgFXGO4gFutwBZO4a6WjawSO8GYYJN0s8tf+fY82wm0ayXy/ECr+wwk?=
 =?us-ascii?Q?+U3LpdTcepqxnx5wl5kLVK/qdmEG6rPbC7BU7DFlAlrl7DtqTzIWIcWT7mwV?=
 =?us-ascii?Q?R64BS3Vm4y/QqRqnksmgjvqmxJtpWvOOo+kkn8xchFYhW42JWVRS1PDgZFwT?=
 =?us-ascii?Q?oucMqK31PE9idam0ax5o6tDjk0Y7IAevyMWAYt3tORbOFLFsTEH5l1RaMRwA?=
 =?us-ascii?Q?zqr/HaO9DsG/LwJj8kukiJUh9stJavmiZBBXVm9p9ONQYezPooINjAImOKmj?=
 =?us-ascii?Q?FWr4kRfJeVC/+7wE4qr6/RRKS+44HGNDlF/aU1a9j8OorMvu8mzeOLMwdViN?=
 =?us-ascii?Q?4BBSgQmeZpPYqmL9Tn1KkZ/iLYFTIQSHoQ92aOSujb2ko0HEmY6ftV0q5Aq5?=
 =?us-ascii?Q?nc8EprbGJ89AOJ52HPDm0bfHCkdoboUhqn5y2/DdGdjVrW4XiRPPHNDcKzBv?=
 =?us-ascii?Q?WDIkzxpmEBfkV3JKWM3Reyzyh1JH2QPdOpm2xQ5NR6ZsvX83epXsjQ/1vKAv?=
 =?us-ascii?Q?ILcIBGCXkQa/TmxJAhvjpSnn57cm2+98bMBNaEyeD00V+oio+8I+z7P6MQdE?=
 =?us-ascii?Q?K+7ZDNoVpIAo3l2svCDZeoaoTHGUoZ4hKk9OLYx+9tMWZiVHvSiFfQ1enM4t?=
 =?us-ascii?Q?SX2D4KOPeQaEnE4aWDQnRmBPh3g4pRQevAjkE4YVwDWujohty/2L3YYUs8OA?=
 =?us-ascii?Q?smJD0+PTf+kodtIIHGPTeHgXP8ZDQ7SLrevTt3JQ0EX+nsj4Bp0Na0SKXrTN?=
 =?us-ascii?Q?aer+pYP0XhKIK96a9RxzRtD1rUSKnkbBduRy7PwY/T7ScKrStqEHapKTbeIw?=
 =?us-ascii?Q?6iW4j5OXXZdgw+83O7MkvgliUAmyetxNNqwhfIVS4QRUQxt1ydf88MLgssqC?=
 =?us-ascii?Q?tasRKQnZ9VjBcgZgh6UcPe1IEweufNdx6w9x?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 21:53:48.8585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9f59c8-cef7-4ff6-c144-08ddc8a112f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9395

From: Ashish Kalra <ashish.kalra@amd.com>

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU command buffers and event buffer registers remain locked and
exclusive to the previous kernel. Attempts to enable command and event
buffers in the kdump kernel will fail, as hardware ignores writes to
the locked MMIO registers as per AMD IOMMU spec Section 2.12.2.1.

Skip enabling command buffers and event buffers for kdump boot as they
are already enabled in the previous kernel.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/init.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 4ba2281e06f2..8a2e3e96fe69 100644
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


