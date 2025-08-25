Return-Path: <kvm+bounces-55685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EF6B34E41
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FF231A87421
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317C6298CA7;
	Mon, 25 Aug 2025 21:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iiU/tSOJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD5526290;
	Mon, 25 Aug 2025 21:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756158365; cv=fail; b=mdiv4VveC17YzT9qGhN+RXQikk59MjNHT4D3HjB28ytqpvJMnfCQhmTX6tEIQ5fAkKYV0vUmQ24I/ITPm/yweo4B5kEV/f8c4rDxuoyr5xxmtCGJCqSV1HugotiFr64Nc1jNidgUB4OtiJBvlgGMhv4uzHOmPEpDDzpMjgVsK7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756158365; c=relaxed/simple;
	bh=XGu0MhTQ+Wwe1YePTz5kEeP43rKaDVB7nVT3mFvTZoY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lujEW1eDu6Cmcht6+ByA1gvohjdzuIAF7Zmu9qvNzDUxNpeDifVs4qWq3teImJqbQhOXwikrUT167ZB95ksFgyDtoYbNjJHhEeX3dDxrxlwVmBh2jiciZXlON5cnHcJOPQPGXvrLf94rZeU3GG4AopJIh9oApXGdhoyHbmgAmZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iiU/tSOJ; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JpBs3ziziqBQIGtIDQkvK1KRWwWib2+A5HSo6ODDZriFHFpd7WIpjK6roqmF/07JvLqC1y4k+RW447NWqVd1997+XTeSot3bcx3TaiwLNshSw/AW4RDfBry/2BsByuuM29XHsyRRH/V1bQvbuazExC3YKm9wbYJLSqJ+A29mskF9wb0DjBT1gX13cSGZFmnELrConRAjS4pg/4VgHQbzNsxuoFJUh60C/044LYOtCuxnl6BEIc4xJISDY6d1PAjcJhjMFQg7T8DXHx3uxxfF2rZz3pdA36/DyisKa0g6jvf/BIFYM2JCzFaMykzWHo/JiLzdLL9IXLjZsgfeHWPhbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BflZxWQPbfJqbZBR8mWDYrsXErnjGit1972mUlJhDWs=;
 b=EXMFrfxCvRNCsWdLykGJlPfMG2t4MW/8LxYmGmeCrXbf8u1pnc8yMRLDKDj5yKw3A0SWgtD22eVmZ++s91ZBCg1J3S0oJiFd1JeURHyiMk+twg4m/jpmGtP2yi+4MDrOPXucwzIitLQkKIuv6CaIDd7suASP7UnMfHIXGYz9Rvpkp7t2Aj0QwRkGGkzozUEsN0QktPxK6EHmxG0Iw+OlZh/rm9k5pD88gcKNf4RYwkqAIIW5J8iIKQHj0jHDXpsae80sF3iY+qZkTnTYKKCeUHuVvsjdss7JR1lepheR5FjCkmVcAhVAdmgs+hg8+MiFuIxey5AvlalzGLzMssyGQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BflZxWQPbfJqbZBR8mWDYrsXErnjGit1972mUlJhDWs=;
 b=iiU/tSOJ7Bcwxi4aRyTC9IuyGSKDe8ANS/Dyv0YJIB/wgNZ2ZcBS7YkGqW7o/EgKoa30nrS6BT1GC/fUMU/yBbWE3kYJDtgRkobdP0U9gQZkN78A9wuM+Q+xSO3mrCnGpH0hG6liccqDseZjn+p1EIIq2b4YMDI38jx42m9NUlo=
Received: from MN2PR05CA0047.namprd05.prod.outlook.com (2603:10b6:208:236::16)
 by DS7PR12MB8231.namprd12.prod.outlook.com (2603:10b6:8:db::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 21:45:55 +0000
Received: from BN3PEPF0000B370.namprd21.prod.outlook.com
 (2603:10b6:208:236:cafe::42) by MN2PR05CA0047.outlook.office365.com
 (2603:10b6:208:236::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Mon,
 25 Aug 2025 21:45:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B370.mail.protection.outlook.com (10.167.243.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 21:45:55 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 16:45:54 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v6 0/4] Add host kdump support for SNP
Date: Mon, 25 Aug 2025 21:45:45 +0000
Message-ID: <cover.1756157913.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B370:EE_|DS7PR12MB8231:EE_
X-MS-Office365-Filtering-Correlation-Id: e93be029-53e9-4800-4267-08dde420c537
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjZMcThqWlhEamc0ajY5NFN4cHo4dlB3cnVjSjh4NnJZMHVteGd3Y0lHaW9Q?=
 =?utf-8?B?VlVvc3MvcHlvV0dRQ1RpU3F5ZWlnbXY1NnBjUnR3Z1ZpMC9uSmZoaTcrS3hD?=
 =?utf-8?B?NGVueWRFMjhJU3RoMk0yVm9FRjc3QU9xL3F5M2VESDlzeTRDc0VEc2VSNjFG?=
 =?utf-8?B?MC9qSTFua1piYzlOcTJyTDdCWnpnMExVWXZTcWxyRlFmNzdHT0NTRWl5RzVZ?=
 =?utf-8?B?RGZ0Q3FHL0NGY1F3cEdjczB0ZENKZTdDbFNvdzFjSTl3aUlZV2Vhay9zQ3Ay?=
 =?utf-8?B?cC8zMytCWDNDYzQ4WHN1OWYxYWlZYW45eTVCbXpWUnFTdXNrVGJPTHluWlRE?=
 =?utf-8?B?VmlBemd4Z1pUZWo5WmdRbENaRnJhYlVkd3FDTFRiOEwwb2NOYmdMb2YvWVFq?=
 =?utf-8?B?Tnp3MVZKVTlZZlV0WXBaTzZwU1dLa21tNUZ2dExNUnBUT24vZlI0aFNGREhJ?=
 =?utf-8?B?c3pMRUp4amZBZldHWFhXaXFSN0o5cmdKUEJ4ZWpVWWp5UUlzZnBJWmZQQlVJ?=
 =?utf-8?B?MEhuTXFrS0ZuZkFxYUVUSERHMW05b3Vkd0E0Tlc1RnllT1lzdExWT2NkRjVZ?=
 =?utf-8?B?bkxkUitnOHQ3YWJyL1l0ejNwTnhMQjZYTzI0MFQwZUw5dUNCWnhGdUU2S0Np?=
 =?utf-8?B?dkhTMXhNb3QxcEJKenlURmpzS2VsMW1KNzVlMmR1T0t2bWFialVNek5ndjMz?=
 =?utf-8?B?enl2cmFQaWhNYllDMklnMEtxNEV2ZUtwVG03SUd0dWVHTHFvUnBiTEJjc3ZU?=
 =?utf-8?B?OWd5VE5yNHJxL3BZcllic3R5YURkVTRjMUpncUw3dDRqemNaWjFCazk5WGkw?=
 =?utf-8?B?NVlpTzBZcld4eWduUnk1WS9PRHpxUnRHMmE3MkF2ZVRWZExCU1kvcFdzWWJE?=
 =?utf-8?B?cElTZDVMeUhtZjlKOUhXUWl0cUxuWHZnTW9NM2FTZTczMEErUlByeFd1MGNk?=
 =?utf-8?B?WE5IMTh1VlI3bFNrclhCT1dlR3VGSjBlTlpwQmhUSlNtaDMva0dKUE9INEYy?=
 =?utf-8?B?VTVidnFpRE1XMnhqeWxDcFJieWVoLzVVU0d3L1ArMHlNSnJCTmVXRGpJVXFZ?=
 =?utf-8?B?Q3FxS2h3emFDaEx4bzhvNW1pZ3RIVGJxdklLV1J2dWpYdkhnQUhUQitOOTJw?=
 =?utf-8?B?SkcxMUNLMEFPWDF3bHlwQURoNlpOQ0F6OERMMzlJTXV4VFk1ZVhFVEhBRW5a?=
 =?utf-8?B?MEJwWmg5U0t6RTI4RmZBODdSTkpvMnZtcGg4TGk1L2hNM1JEdEtHbDJjcVFS?=
 =?utf-8?B?Slc0VUEwYm5vdkhoSzFjcXVUWjRhUE9Gd0JUV1p3UFVtRjFzUDJ6YVhZWHNR?=
 =?utf-8?B?UkRZY3VwS3hxdERNalJoUXUyNHo3YkJ0ZEZLZHJUYWtjWEtzNWFwY1ljMWw4?=
 =?utf-8?B?R3I5bnltZFFxRXh3cGNsYmsrUmYyL2cwRkxuM0FJVXgzMWxxd3hhRVZXSHV3?=
 =?utf-8?B?eEtIc1lUc1BmZFVHWDVFdEtNdzJ1QzA2L3pLVmkvS2N0Tm1DT3R1NkhMVGJ1?=
 =?utf-8?B?OTBHY2cyMGpLRkNreWhyd0VINEpyVWUvZHc0VkJvd1Z1cXhsL3lhK3RtQjZ6?=
 =?utf-8?B?TFNlaTVVKzA5YWpOZHh3RjdxQ1dzUWgyZjg2Q0NKQ3luSkFYMlVvQW1wVzQw?=
 =?utf-8?B?TEEvK1J2a2JKb0QvY3pTSFkzczIxakZRV29iMFhWVk5FYmFiQTM3VFdZNks1?=
 =?utf-8?B?VDNKL2VVZVVpbEV6MXAveWY0N3NNWkpoNWMwanptVzVqVDR1RVlpb2hUNUto?=
 =?utf-8?B?T2tmc0swcTM3bFM3SmhFRzE1WE1MOHlBMzZVQm5aV29MUFJpNmpodVdnRTNT?=
 =?utf-8?B?eWVZaGJYSG5oS0psQ0FhVHZyeHRBbnk5MnFjOWhwNGxLRk5WeUN4UUFtWEc5?=
 =?utf-8?B?S2ZwR3A1WXJSTVNSTDJTNk5FN1JmSjl4cGZTQVFFSFBzZ3VkRzhBZ2Rxa0kw?=
 =?utf-8?B?eTJxaHI2c05TUG1kdVJQOTZwNDRUUUtpVVF6SmpTWG1iOUVzbGtBcmQ3Szdk?=
 =?utf-8?B?TU15ckdqc3g1L1orUE01aWQ0aDRnYmJ0NGtQYTNqK2xhd21CMHVySnFQOXVr?=
 =?utf-8?B?U1prVWZ1YkFMUGNTZTc5K0dHN1ViZ1ZYRmpDZz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 21:45:55.4876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e93be029-53e9-4800-4267-08dde420c537
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8231

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

v6:
- Fix commit logs and inline comments.
- Add Reviewed-by tags.

v5:
- Fix sparse build warnings, use (__force void *) for
  fixing cast return of (void __iomem *) to (void *) from ioremap_encrypted()
  in iommu_memremap().
- Add Tested-by tags.

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

 drivers/crypto/ccp/sev-dev.c        |  10 +
 drivers/iommu/amd/amd_iommu_types.h |   5 +
 drivers/iommu/amd/init.c            | 284 +++++++++++++++++++---------
 drivers/iommu/amd/iommu.c           |   2 +-
 4 files changed, 209 insertions(+), 92 deletions(-)

-- 
2.34.1


