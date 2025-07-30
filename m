Return-Path: <kvm+bounces-53759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD92FB1689D
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 23:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBE2318C47AB
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 21:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C22225A47;
	Wed, 30 Jul 2025 21:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eWTlU3Bp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF1B1E1A05;
	Wed, 30 Jul 2025 21:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753912545; cv=fail; b=uWh066SEUEcVzMoYIJQHSCuDVwR6R6ueNuaZI++dhkLkGe+oldY9aKn6kt40SCAES2/iNWom7tTRKiL7C0NPJufG3PelTyEfZFwfMd6d3zLExIcxvDCuypeDvIjIkDO7nhTL1iiO1KoyLazVbUcaraipBtLNFyJEK5Bne/V75kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753912545; c=relaxed/simple;
	bh=KANyxGqFwCv26F8BPVeI/H/GN5961hwyu8180N+sUcE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GXy2VhY6UBz6weMo4yPMwos1oYkCl7lob+SqKrlx7jj/MHXcYX3CAVXsP1MEyW8oqd2QYQyzkcSyzUjK63fyqTZMGkEIW/e9VGbmb9yvks56bn0cbMpDYbKR1q84X7SJKeqc8BC+iHeM9HagbzZ5JsFZO4bgV8I0OKbEyjI4tPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eWTlU3Bp; arc=fail smtp.client-ip=40.107.243.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hcBD0lWuJRiDwRm2CD0YeNPOTKyxAlQn0hgXEdRZXzIg2FGpBnMlJs1I5XpcKHEQYNQD9/lvRCejwqmlLsxxMtXdi6NJHLZYf1303Z1XOnOOSKpdJxnPhst/veGge12IG3o3OXS+bq3AKKURmDImbmtZljUrgPVE9KQq5OKL6RXGH4O5gduPUckx9xo7BBIValFcumgOSgPKHsh8akMqMOdBfZkp0DcvQ3/Av+VuvK3xjx8rpznJflEoxDtv99lehEsiFeYHn+6S6GU1OgfITh72j1vyeLnk4jDVRI5FCTn0GCvFTZ9G70efWl9BgDlICuKqpMGaWlplLYVXEOA0KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuzZmak17hAxYYsyVG2P8tne6TBsjDGPiNfHh+HgtBc=;
 b=K0tmFrGyX+DPzmOlEQOj9wK6zHEUyLufTdUHXZkSXJi35B0AKDi2Fgg6YrEbTlzSeBUQ0Eb/X9/j/iHWPtQxg/fptcKI4DlqAAUHUs5DlFZQLRYKzvjo7lqQD5lekgp9xj4AA/E2DSFDrylOhtLnHvuchdGsSbMMy9V8W+odDQizwt7Iq67fhpNkIKjfsfFWx30iR+cAEVXeR5dG2Zsc9Bo9Hs16gI8QPFP1ZHjXgNXqYNlVJFf3tG6Erlz1xpm49IfIq9NgiP3Kf5hGUQukAlmXIEZNwsBMyx8gBjz1c5Q6YvDqPANlUk3UjUc++J8zOYfVHhEO+8G+UQyqGEqCQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuzZmak17hAxYYsyVG2P8tne6TBsjDGPiNfHh+HgtBc=;
 b=eWTlU3BpNmftHmrSOrk4AtcEed6YeBrhTAfkH/+f9qnPtSLFF2qKPb1CgeLX59a9uUgfGnYJ/0jAFERFW3FJ+3lHu5Lb7km66hUb3rngOl9vknuvBBn/fyH5NT8RFXfqJw+rSmeg0E9npK5jkQmQsHlVcS1BkMrQ2ADG1yC+FuM=
Received: from BN9PR03CA0569.namprd03.prod.outlook.com (2603:10b6:408:138::34)
 by BL3PR12MB6642.namprd12.prod.outlook.com (2603:10b6:208:38e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 21:55:39 +0000
Received: from BL6PEPF0001AB71.namprd02.prod.outlook.com
 (2603:10b6:408:138:cafe::96) by BN9PR03CA0569.outlook.office365.com
 (2603:10b6:408:138::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.25 via Frontend Transport; Wed,
 30 Jul 2025 21:55:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB71.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.10 via Frontend Transport; Wed, 30 Jul 2025 21:55:39 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 30 Jul
 2025 16:55:38 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v5 0/4] Add host kdump support for SNP
Date: Wed, 30 Jul 2025 21:55:23 +0000
Message-ID: <cover.1753911773.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB71:EE_|BL3PR12MB6642:EE_
X-MS-Office365-Filtering-Correlation-Id: 5958452f-ec5b-445f-02a7-08ddcfb3d2ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUZJUzNKV1dBVEZ0VDJRVzF2NlZnYS9uakhISjBxalhjS1BicGxLZGNXLzhF?=
 =?utf-8?B?R3ZDdmZUZGNSTUdLeTJkaG0vb0FBdmJrczVVRnRES01FbG5tNlN2alc0dVNI?=
 =?utf-8?B?TTRDM012YmU1Vkc0eU9GaFBxZHY2YmFON1duZDlYTGFxNjZvaGZTQkEzM012?=
 =?utf-8?B?cTNRdERLVGc5S3hFeGk0bkVXSzJTY01oa2RNZEFnRzVFY2VyN1RaS0FURWhD?=
 =?utf-8?B?aTIvaVBYdks5UkpMUTAvSDVOdHllZzVsd3FUb09wMk13MWh0dm5JRGI3S1Zy?=
 =?utf-8?B?dWVuQk1EVzVWTmF3MldTeUw0andmOU5lVURkbVlRaWdueERpQWJSSTk1d2Ux?=
 =?utf-8?B?bGFSck82K2NoODNJTXl1Um5OMHo3cWJHY0twSkFHVXBralNBMUludjZlU1lj?=
 =?utf-8?B?T0F4dTYxN2Ezc0RVYlZNY0luSm5VWDVWa2l2aDZBVnBOVnROWUNzTlQzSkk1?=
 =?utf-8?B?ZXdjS3ZXZXE0WTArK0JwSGgrSlVid1B6QVl0Yml4UTBidFhBb1B2bTN4RVpI?=
 =?utf-8?B?RnFyUy9jU1ZLS1JuMDU0YzZJU0R1VXovQll4MlIrWTd4TER0OFlRaXJkbW9Y?=
 =?utf-8?B?NzA3eGY1ZUkrcGJSNU1yaFdPaGxRSWtac3NLSU8vdElFUWhnMVdNKzZPNnVv?=
 =?utf-8?B?TXZCWjhHMkdDYmhaQWROckl5OFUxV1ZRb1FRWTZPb3hOUTJqdjJkWTVlRmNE?=
 =?utf-8?B?YjVjVGdOZG1FbmtLZVJpekJFRTRjNDhwcWtySjMxMVBWQ1lLeGhrOGdhaENC?=
 =?utf-8?B?TUxNUE9xSjdSaFluSU1TWFdJdVV6b0hwUHNYVThiazdMZm5mNlhnSnNhd3h6?=
 =?utf-8?B?T290Vkx0bG5yemkrb2dTejZUZzFyc0k2bktSTEJwaDZrUFVxSVNpUTRuaEJS?=
 =?utf-8?B?SXAwdGRlNjA0NmdrcUNHN3J5RkVTcFcyY2xZUW9VUVFNTjJ6cVB2S3FJMXVJ?=
 =?utf-8?B?SkJ1dlFXdUlTRnV1aVRuY3h6L0JwWUp2cG83b01MVk02Mm5Hc0tTSnY1TTJV?=
 =?utf-8?B?V2pSMmxPY3BVRVdTVWVHL1JMK3JaTkRTYjUrMytBeXQwRnQxWUxycFVKNGQ2?=
 =?utf-8?B?eXJxYU9tWVBuZVdyeWdsbGpyQVdKYkdQTkdDcmJOSjZVS1lTaXJxczhpUFNz?=
 =?utf-8?B?S2ovbEFCSk5PS2lVZ1VkSHlTNVE5elJreGZIaXNCYXo0NXV0VGpIUXEvZmg4?=
 =?utf-8?B?NHgreDJ1WVlYUlBwR1JNc2VJRjlmZkwrbkdpb1BsV1Y0bnZ3N3BiUmNlUUgz?=
 =?utf-8?B?NUFGNm5la09UVWF4ZGNMSGNVbWpsMVE2TlFqUkxqUXNUWi9ZMWxKVXpob0Jj?=
 =?utf-8?B?VWhXZldNUjNrWGhsOE9pRmk3NFFnY1hYMkpTNHFtOWpjR2dUL29jZHhjbEQ3?=
 =?utf-8?B?ditYNXJKTkhvTDNhTTYxcmNhUVNSODltN2RwdkJCRGlQeDdHdmJ1N1VhdXFM?=
 =?utf-8?B?a2phc2lSQ2twQm1ZR1J5YzFqZGF2K2d3RUNFQ3RJQzBjUGJxVnh4OUJ3eGxR?=
 =?utf-8?B?Z2RSb3ladVFRTHZSMGpuZDk3VnlKV0ZPWFdRUmJnMzIyNndvMmVHMytjdVpP?=
 =?utf-8?B?c2RvdU1wWDM1WHd0eitwQk54dno0TldyRnVPMlZsdEZ6YTN3NTRPek8xREhz?=
 =?utf-8?B?Szd3UHluRDZUdU1DRWc3ZXZ2THJwZEcrekZka2dQUWFBdTMyU2Z0TUo0RnF3?=
 =?utf-8?B?UDdTVzA2SkVxWmJVQWxWN0lCamZlcTZpaFMwZFBhT2ZRakJNaDZYN25zTXFo?=
 =?utf-8?B?Z2s4RUlnYlNScmdqM2FsUTRUSWRncFNYSTJYRUczNHcvUmNDWWplU2ovOU1J?=
 =?utf-8?B?RFV5VHpGbCtxdzFyZ1Z3VFZLSGtkeDNsTTRaTm9UL25rOEpJdEk3cml3NEo4?=
 =?utf-8?B?UW5JV3pRb3EwUk43MFNJdUxINExXNkplRVUyVVRYR0pFZ2VDbEQ0RFoyMlpO?=
 =?utf-8?B?NE1qU0VraCtNZ2Z6eFZiNHJNUFV5Z2J4NDNUdkpiOTkyZ3Rvb1dRUzYzQVFE?=
 =?utf-8?B?S0dXYWhVcUJURFBNdkd0amJPS1FoYUJRbDhrL2xrMVcrWVNneWg0SGJDUERF?=
 =?utf-8?B?Y3UxQ21yMUplR3hhWEpXaWQ2L2JPc2ZMTjFsZz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 21:55:39.6753
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5958452f-ec5b-445f-02a7-08ddcfb3d2ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB71.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6642

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

 drivers/crypto/ccp/sev-dev.c        |   8 +
 drivers/iommu/amd/amd_iommu_types.h |   5 +
 drivers/iommu/amd/init.c            | 298 +++++++++++++++++++---------
 drivers/iommu/amd/iommu.c           |   2 +-
 4 files changed, 221 insertions(+), 92 deletions(-)

-- 
2.34.1


