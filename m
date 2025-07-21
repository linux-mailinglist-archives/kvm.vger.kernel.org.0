Return-Path: <kvm+bounces-53033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B019CB0CCE4
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D02E51AA7510
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7F623D2B6;
	Mon, 21 Jul 2025 21:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HU7C3IqR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2B71B4242;
	Mon, 21 Jul 2025 21:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753134774; cv=fail; b=s3eQna+PSBb+e73+BgM9Cl/A6YRUFs8HZctINghJvqrWx+U3I7WDp/bOKkDKfSNOsrChEMF1dAhkjkQ0VAj4UlD8xtgGU0PBcvq4SGaS3bahtH8eRnIzw8ZDpnOqC/ScVJu00+bifhwDnAJ0cPRQnxT5i4Nh7kKzDRRQ5YLf2eY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753134774; c=relaxed/simple;
	bh=N72i+1uMzbAtdoDQ0E151RY26KXyobAblMHJSL9u470=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ipip+HtB04Vtkqp88Cqdbrj7wqqupjQ3N6h7fiZi4/ZhkVodFVUMcaqCgTb7V46o2x4b+Nbv7MeMWeeqlJb2xLFwOAVdZXysjHSHzCmEhdUBFRCwae0THqpz50m0c6CuYs71dHI0LwdtDty9d4VkQjMIK36QSvY5Dae6x8RnQ5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HU7C3IqR; arc=fail smtp.client-ip=40.107.243.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tvaGpA/S71mz4oeThr2AUvWBBxAew9PquxnenPHX4dEPO0Av3UFb98ziiJ1pqX/rPC1QDu5skHCAm5EGpE6Ec6hy9hcXpk4JqnJWg3t1vDK1R+Bc5UD1ZK2kYRw0HqiOkvVe7adgPPtQ1fRjKAottq9AED+ElOl3QlOuHZ0wl9fyTmtOuy92+WOtw/ErWga3kMx1iCRXBC0DHxwv7uUnSf+ztDRjLIMgDybFOmKmyKhct1AIQA/hpnGoiJv+gv/jpnEQafk3mN3VD//oovRCSNLvhA+K45BK3tsFOCCL3ufjqtyyRxggYZHCTd+exbDGE9fsu0PgJXgrTITyB5w5kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tk0qNHv5rCxphVkjwd4UxqJm8xb9D/Viy9L9Td67YHQ=;
 b=MSvrxh6BJv7MsJDt1AJzutNnzjuhYzIbwDtN0fg1HkMsGorkpEXiyO3NTylRwbKR2f71AbyXU7GsOKtJOaXD5ccJ/28/5KuCg0gVBYWt/RUCH3oDzQH6npUU+qZUc1IveZqzqk+7vwTCxJdRAMlixDooQ9ZjyKjiFMLUI0pTG/A2BKp+DD6Ka+ytrtAC3zr5IDGS0QnkWUeXpiqzutuuLJenbYo53Iqc/+Asl017vadAGKxprby7NSKBll1bm+ao5Y7k751VNaqtw1WihMH+Ntg7VzzB3s6XaTjyApGrMk1FgN96n15cYVNpMMGkS0ZkmY2GG+MOUuo4zXeuQI/FjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tk0qNHv5rCxphVkjwd4UxqJm8xb9D/Viy9L9Td67YHQ=;
 b=HU7C3IqR+EwHlsFJdo5p7I4kIC5S4D7De2SQy+z3aH0ue6uYNhOTqlEq1cdFVCULLeHky87XKiYwrpduSTrM0huR714hBl4NxtBNaljau9k9iYVZpUOVjg29C7TJuD92afBjP3PO4uw488q8g/3+RksdEID3HUrKb374ZLgGaJY=
Received: from SJ0PR13CA0233.namprd13.prod.outlook.com (2603:10b6:a03:2c1::28)
 by PH8PR12MB6890.namprd12.prod.outlook.com (2603:10b6:510:1ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 21:52:47 +0000
Received: from SJ1PEPF000023D8.namprd21.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::ae) by SJ0PR13CA0233.outlook.office365.com
 (2603:10b6:a03:2c1::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Mon,
 21 Jul 2025 21:52:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D8.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.1 via Frontend Transport; Mon, 21 Jul 2025 21:52:46 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 16:52:45 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v4 0/4] Add host kdump support for SNP
Date: Mon, 21 Jul 2025 21:52:36 +0000
Message-ID: <cover.1753133022.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D8:EE_|PH8PR12MB6890:EE_
X-MS-Office365-Filtering-Correlation-Id: c39b4a3c-71d6-488c-b7fa-08ddc8a0edf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnQ3UVRnanBxSjA3NWIrU3NUNzRUK05nNHVVazFNSGZPY0gzUVpFeVlpcFFn?=
 =?utf-8?B?UnMrOHNIRUFmRXBsTURzUWVrVWdYMVM0eWZxUGVvcHZuRlFNd2hrY3VWMjNH?=
 =?utf-8?B?dHJRUHplay9aak03ZXRlRVlJNG9FSjcvUjYyNUgzekFTZGpvRmhMOUhMWjFx?=
 =?utf-8?B?eXNhR0phL1VpZWJ0T3pYTm12SlZCME5hcFF6aDRpbmVZS042WDl2ZXM5SWNZ?=
 =?utf-8?B?NFJxNDZRZmk0NG5FOTc4ZkpOY3VoTWwxMkFhdktGK1BtVU1qZ2haeVVsaEtX?=
 =?utf-8?B?aFg1YTNqUTh1MEJPMDE3U2duY2dSeWNHVTNlcE9FcUx5OG1xQ3JidHczNjl6?=
 =?utf-8?B?eExGVHkwdktHcEFjejByQ2svSVhGSys4b2JwRDJtcmhaK295dFV6eXhoUEJO?=
 =?utf-8?B?RXd0WTI4bXFwVllqSlZTckNjdWduR2lzY0R1eHBaYldaSTBLd00ySVlKOVBB?=
 =?utf-8?B?aDQ1MHBMbkUvWTBPbVQrc2RlTXB5T1hKWlNRVFRqcWdhZVV6RnZGaHZ0QjRp?=
 =?utf-8?B?TW84S2ZJaWxVQWpjNG95ejRHS1NFbXdkMzc4N2grZXlTdVZtMUZaenNIcHFi?=
 =?utf-8?B?QVJNODhZMnVCTTUyUEpZaFNNcW5qUEJXOU1LUlQzeEdORTZ1bDBwWFVxeUtq?=
 =?utf-8?B?OVI2NEt4aUl1dzZSTkowNklyWUJTSko1ZzV3WE90V3NNMmR0VHJ2UFZUSzZl?=
 =?utf-8?B?NUJldkdjWnVPYTROS3Ezc3hLRDVIbm9JY0pPQnlzTy9XbHlrZC9EVXBXd1Fo?=
 =?utf-8?B?U3MvZm1tbUZrZ2hwd1BqUTJOdEJhT3Z0S2dhNi9XcFZwV2ZPNktub3V4aEJr?=
 =?utf-8?B?RU41ZHM1d1RoN0RxK2pXM2ZmcllYZU9xQWRqV3ZzZXRXSkRQWHpRZUVyamNL?=
 =?utf-8?B?S21hd0ZsSHV2c05WMHZReGx2RkRGNC9VWVQ3cHRpbS94NENpam1zbGxCWUxF?=
 =?utf-8?B?NzdYTDFEMlI3NzRNVjl3SDdHY3NhaFM5VEI3OTQ1SW5VYWhHNlh2dFh1d25Q?=
 =?utf-8?B?SWdmbUkxSUVhOVo2ajJJUURaYzIyQnBRbkU1ZmM1R3VpUXowRVZtalkyclRi?=
 =?utf-8?B?WjVFeHRlYUs4dDFsd0JsdW8vcU1sb1BXZ3I5R2N3TWMxaTZFdjRuZkhKcjdX?=
 =?utf-8?B?eHhPekQzalVVelBuOFpPVzJyVGQ1dDNueUZ4Y0J0WTFiNGd2SFJrQVF5RnJI?=
 =?utf-8?B?T05LQmJBOXRmbmt1cHFwK3JZWm9BMFJYM0hOOUppNXhKallKWXdURytScWRQ?=
 =?utf-8?B?UThWS1RoMHlpaDM5Sk84OUVkVVZBQ1V2RG5mL1UxUkpWMUhBNHNwazFCZGh1?=
 =?utf-8?B?eXJwZkRScC9JZ2llc0Z5MkRhQ2ZhRCtUcU5NVnhCY2hJdDIwcEpZUGE5ZGlS?=
 =?utf-8?B?dHA1aXF5d25wMmJ5dktGQU1NRmlqZW45UzNISlJubHRvT3FhVmQwMENBYllE?=
 =?utf-8?B?dldmUFFSUERkT1JDd0FWZEJsaXZjbEV1MytqME56a2Y0V0lOSjdVMW5GUU1N?=
 =?utf-8?B?azIxUDlmVEh1UCsvQ29hRlFubGwwK3NQUXh2RjY3TVNYQzlUa204d0NWWlpS?=
 =?utf-8?B?cjZiUUNBOS9ZNGJ0T21HUU5pUHlYY05zT2FkUjZqK2pmUGo2akVRdXFjSFFi?=
 =?utf-8?B?M0NsMVVMcTg5UWp4bFpaNVM1dWV3b3hFWEZwdUMzOWNYWit2WVV6MWJWMUE5?=
 =?utf-8?B?SE1sNWg3NXhrNTUycDR2T0pmUkJjS0h5ODZXY05XZk5ick9qOE13b1E4bWph?=
 =?utf-8?B?bTExVnhsby8rcWxkVDNOeXdmWXVsZVYrZ0ZkTnRkTmgwSDExVG13MWNTeW0y?=
 =?utf-8?B?UDhyOXQvMTI4VUpGY2toTmQzL1cxMThoYWZSWWZDdGxKa3BDU0FtWVFmUkQ4?=
 =?utf-8?B?VWo3bllDUElMQ3NORFB1aWFrMk9NSjM0SVBYKytyb0JpQy9nS0NlSi9aQjFr?=
 =?utf-8?B?d3UxZTdhVFVzTWxYbE5FYnJqbU9jZGhCYzZDVG8xRjU0Ukkrc0dWNGtTRktZ?=
 =?utf-8?B?ODMzaTBWSEsrOHp2T3BGRjJTQ2x3WDFBWC9FRFpEWTFPdzBaajRPK1BuN3My?=
 =?utf-8?B?cEFpaWlDVHNHSG0zbXlaKzZvNFB0SVlGc2psUT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 21:52:46.7947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c39b4a3c-71d6-488c-b7fa-08ddc8a0edf8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D8.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6890

From: Ashish Kalra <ashish.kalra@amd.com>

When a crash is triggered the kernel attempts to shut down SEV-SNP
using the SNP_SHUTDOWN_EX command. If active SNP VMs are present,
SNP_SHUTDOWN_EX fails as firmware checks all encryption-capable ASIDs
to ensure none are in use and that a DF_FLUSH is not required. 

This casues the kdump kernel to boot with IOMMU SNP enforcement still
enabled and IOMMU completion wait buffers (CWBs), command buffers,
device tables and event buffer registers remain locked and exclusive
to the previous kernel. Attempts to allocate and use new buffers in
the kdump kernel fail, as the hardware ignores writes to the locked
MMIO registers (per AMD IOMMU spec Section 2.12.2.1).

As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
remapping which is required for proper operation.

This results in repeated "Completion-Wait loop timed out" errors and a
second kernel panic: "Kernel panic - not syncing: timer doesn't work
through Interrupt-remapped IO-APIC"

The list of MMIO registers locked and which ignore writes after failed
SNP shutdown are mentioned in the AMD IOMMU specifications below:

Section 2.12.2.1.
https://docs.amd.com/v/u/en-US/48882_3.10_PUB

Instead of allocating new buffers, re-use the previous kernel’s pages
for completion wait buffers, command buffers, event buffers and device
tables and operate with the already enabled SNP configuration and
existing data structures.

This approach is now used for kdump boot regardless of whether SNP is
enabled during kdump.

The patch-series enables successful crashkernel/kdump operation on SNP
hosts even when SNP_SHUTDOWN_EX fails.

v4:
- Fix commit logs.
- Explicitly call ioremap_encrypted() if SME is enabled and memremap()
otherwise if SME is not enabled in iommu_memremap().
- Rename remap_cwwb_sem() to remap_or_alloc_cwwb_sem().
- Fix inline comments.
- Skip both SEV and SNP INIT for kdump boot.
- Add a BUG_ON() if reuse_device_table() fails in case of SNP enabled.
- Drop "Fixes:" tag as this patch-series enables host kdump for SNP.

v3:
- Moving to AMD IOMMU driver fix so that there is no need to do SNP_DECOMMISSION
during panic() and kdump kernel boot will be more agnostic to 
whether or not SNP_SHUTDOWN is done properly (or even done at all),
i.e., even with active SNP guests. Fixing crashkernel/kdump boot with IOMMU SNP/RMP
enforcement still enabled prior to kdump boot by reusing the pages of the previous 
kernel for IOMMU completion wait buffers, command buffer and device table and
memremap them during kdump boot.
- Rebased on linux-next.
- Split the original patch into smaller patches and prepare separate
patches for adding iommu_memremap() helper and remapping/unmapping of 
IOMMU buffers for kdump, Reusing device table for kdump and skip the
enabling of IOMMU buffers for kdump.
- Add new functions for remapping/unmapping IOMMU buffers and call
them from alloc_iommu_buffers/free_iommu_buffers in case of kdump boot
else call the exisiting alloc/free variants of CWB, command and event buffers.
- Skip SNP INIT in case of kdump boot.
- The final patch skips enabling IOMMU command buffer and event buffer
for kdump boot which fixes kdump on SNP host.
- Add comment that completion wait buffers are only re-used when SNP is
enabled.

Ashish Kalra (4):
  iommu/amd: Add support to remap/unmap IOMMU buffers for kdump
  iommu/amd: Reuse device table for kdump
  crypto: ccp: Skip SEV and SNP INIT for kdump boot
  iommu/amd: Skip enabling command/event buffers for kdump

 drivers/crypto/ccp/sev-dev.c        |   8 +
 drivers/iommu/amd/amd_iommu_types.h |   5 +
 drivers/iommu/amd/init.c            | 298 +++++++++++++++++++---------
 drivers/iommu/amd/iommu.c           |   2 +-
 4 files changed, 221 insertions(+), 92 deletions(-)

-- 
2.34.1


