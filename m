Return-Path: <kvm+bounces-52537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9E5B066C8
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C24104E58A8
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2772BEC59;
	Tue, 15 Jul 2025 19:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z1usRd1/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E522BDC26;
	Tue, 15 Jul 2025 19:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752607610; cv=fail; b=Mm9jIQSRXUzA5pBMVTxSFwNSpaYg1LAZVSynu39QgJOGVMjSU+NZCL4Ugk0ZzCSKoCPt344BAKiLhwRZyI8la9ee475jbf38MJUZn+G0REKNuHDHbLrDYft9at4KNnWC/78yQPQ4W9Eie/WawMoXflEpZZlvT1sYsCpxU1bfPh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752607610; c=relaxed/simple;
	bh=7lruqxkuR/sjZuUg6gJ5/Ei7Kt1luItR4buLB+aKnLw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fI9MFX9eW1O/6YFhCosOb4cDWXYQmMPLB0w+S4TAvX9Z1xK/6FbMOydQXVJ4jdhe4nSrR6EFpDsnYC26iRp8g+3LlCyxPv21AerwAlBkmMb5NmW4nsVvzmgd5jQBo7pxctbK5mitDRCiSpDZa07tFLanRN9YBQlhtkLY5PVYqnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z1usRd1/; arc=fail smtp.client-ip=40.107.220.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jtF/q9S0dyh7/LoU8KdEhlOT1ngQ5+7pdvyuCWIxIqrL+5qwvVZZFrUoRhrG6fkSjvAh445Fw4ca9E2lqhU+9uLFE2J0lnx4/lqrerjxP7Lg94E0Rfwk92wLmWYSxdvYWJk0q19OKmN5Q+QEIcLdRyZJUw3ljSrHqiy80HRvgOGZMn8CvWPRnRZyUgX/6g8QATUiuv/krBbAdUki1F7D9c5Ki/p7rX3cxJhNqVn87veScCn8ZLGm3+5oxWifkAUuEVp87cdq+sjSAuDD2MEjei6KjWIqbLgXrWqyC/kwP8J1fNy9FbFav5FVzgZiY9T8AJWWObkjq2qNnvB+0YPgSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKicoRhPorw+MC5TXp1Ro8vrZmkPZfbC+gzmvGgUMwo=;
 b=KtRp/zrn7emSkiaROYNMDBGl1UhHIym622owYDKp4lfdw5ZSIwf2OGInIZLdeObSsHtrvii3LWLCf7c2tCdDiZmwKH6e4fUW5/TkcT223A8yV/f9/q9XEsqhjNZAaQNTFZ4pl55iPlLEiHvWIvSEgmsFHZ4+yf3FQhrGxTzsNfxF0U3EtaXFD1+atMmN7+p2ZegJfpsRV3/J6nDdEXwf9bEL31NYlMEx1eulj5ptloTbWvOn9346vKZsn9KPnuDg829xfJ3nBTM5AfblycQxacMW8ZQAiiSTBdiaGzdGflDcEsQlmVpIgqMF8PdELQ7FTozOMm41h3GZ6R3cCiPzkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKicoRhPorw+MC5TXp1Ro8vrZmkPZfbC+gzmvGgUMwo=;
 b=Z1usRd1/5H+DNavngmVEXIjzBY3H0mAcYCmTHymMpw/ZI3fa1EmgWC1rpXN9R2w/Op3ROKAlm7ziaVSWOjUq77RSTCXLSw4thA3T9DQXky74710gw8QtOzvKTnWMykMyDK4Nhw6GebRt1IzUpEwpXdHc2UveQ8sU1zIrZkMIhvY=
Received: from BY3PR05CA0060.namprd05.prod.outlook.com (2603:10b6:a03:39b::35)
 by LV8PR12MB9270.namprd12.prod.outlook.com (2603:10b6:408:205::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.27; Tue, 15 Jul
 2025 19:26:46 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:39b:cafe::c3) by BY3PR05CA0060.outlook.office365.com
 (2603:10b6:a03:39b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.16 via Frontend Transport; Tue,
 15 Jul 2025 19:26:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Tue, 15 Jul 2025 19:26:45 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Jul
 2025 14:26:44 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<bp@alien8.de>, <michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v3 0/4] iommu/amd: Fix host kdump support for SNP
Date: Tue, 15 Jul 2025 19:26:34 +0000
Message-ID: <cover.1752605725.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|LV8PR12MB9270:EE_
X-MS-Office365-Filtering-Correlation-Id: d72736b0-50dc-4429-3eda-08ddc3d58969
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWQvRm1Jb1FlQUF4TXRiZVZob1hzbnE1YUFCVlhaWVp2SEtEMTZadlVZQ0Uv?=
 =?utf-8?B?QWZoRHF3NXBmOEhrN1FHNUYvc01oTFZjTnBMNVdWTWYzeUJoK2JabHFCTU83?=
 =?utf-8?B?M2R6TTBiOWtyZkpJUDA3WExwNExsM1NNRWdUNHJFWEJIKy9KNElydGtid01u?=
 =?utf-8?B?SVlWWURZei9HS2k4K0dJY0R6U0JPMWFTWVVRcEhJMXkrQ0R2emVjdXcwSXJR?=
 =?utf-8?B?Z0YyOTU1ZmF5VWwra2tOYk1MbmZCVUJkNEllU1hHUlp3aHdQWGl2TWQzblI1?=
 =?utf-8?B?NUJkTUtvL2FsQXluSTczZ2ZVMnhaQ2owcnRNdmFvQzBqY2dzNjRuSGF5c0ZQ?=
 =?utf-8?B?R09ZUjJweHdROXQwOE9ZdzMyWXhOQlN0YW90bEgrcHRuRnUyOVk5VVNzQ3NC?=
 =?utf-8?B?a0NyTTBtbUFqaFhlbThrRHJaRlg3K0dGRnUxaGY3WUd0YXc1S2gxYWlNbnpM?=
 =?utf-8?B?VTVRUlJIRVloVVpFcXJlNW05RDRZYUZxemp4MzNkVUdXUFRhQVE0Y1FuU20x?=
 =?utf-8?B?QW5CcnQ2ODVnQ3FoUEx3SjVzd2tWR3A2NDRMVm8zOHJqeGJNMmdnUkFoalc0?=
 =?utf-8?B?b0wxcEREdFFpQzJuZno1ZWc1S2pDUHdaN21NbkM4WW12aWZXWDNkajJzOTJT?=
 =?utf-8?B?M09hZERmOTZzQ21sdC9MaCtwdnU3VEYrZkF2WWlvU2llYnEyNUg5alhLYmpI?=
 =?utf-8?B?bHFtSmJLdmJSTEE5dXFtcitxRUN2dzVtRW1BVkZFWDI5NFIwTWZSMERGQTBo?=
 =?utf-8?B?OXRqditCTnROLzB5a054ZW54REVaN1FybU9qWUJ1SzN5NllLLzM5ZjJqUUhz?=
 =?utf-8?B?cks4N2ZOcW1CazZPQTZzdkU1eUNPZzh5NDgzZ3ZMaHdXN0NaYmtuMW4rR00r?=
 =?utf-8?B?cTZYNE1uaEtSZm1MK21iUlQvYUd6aXgwelEyRVFZOEJuWmNyN2FlOXBPbU5J?=
 =?utf-8?B?dGVtZ2JoNzFpRXNTYVQrNndLNXBRQnRJeHJBcEFIeXdvWlRuSUNyM0lDSUht?=
 =?utf-8?B?ME11Z1gyZUc1QlRJSmVTL2l5UG55RXdLQ2cxMnFNRmRPMG5mL2V6NWxZYzFW?=
 =?utf-8?B?VVlSRFRzZUJUWDNRMFpZcGZzaENIZnpISUpVSzlWRldLNjc4ZFdCTDV0V3Fr?=
 =?utf-8?B?WktTRm16M3NvRnh0MXVQbnAwaFk5eHAvc2ozZmt2Wit4T01IMTRoWWJtUlpO?=
 =?utf-8?B?dnhuanpCNGRDTktScGd0RDBaRkt6L2NtZ2xWNXM5WTlaMjBnV3YrNHpaZE9a?=
 =?utf-8?B?UVNVRlNPUlVTVjlWSVNzNVVTaEovTDZHNGhUeDkwODFpc3NycFJKcXRpQ2lE?=
 =?utf-8?B?UnVUMjhVci9qL004Q0hjVHFacXc0MjJiTUsxbXZmR1JOeVlTak5rb2FKbU9u?=
 =?utf-8?B?L01sRUhDclV3Mm1ycmZjNFc0a2NwSGtNMlgwb2tMaTJ4NmEyTTN5d2FRR2NN?=
 =?utf-8?B?NktzNnk3aEFINURPOGFUOEN5SUFoZjZOcWNMRFA0cTdPc1pndjNzVGUxSWFz?=
 =?utf-8?B?L3BFdVh1L0x3b0tud09XSVBZdlkyektob3g0b1FkZ29ZcGtnMVhTaDFJWVZZ?=
 =?utf-8?B?blhMeHdpLzlFNzNoTGtCUTVmSUMrQkVXOGJzM2Y1RnZjZzlXb0wzWlVhRlVH?=
 =?utf-8?B?Q1VUNVlTS3JTYUVuN3RCa2pPS2ppNkFyQ25jT1dNNUlRalB5Q2JVcTF0Qm9a?=
 =?utf-8?B?Ym5ENyt4YjZFdFJiS2VJdWE5ZmlYV0F5ZnJzNGZHUnZ5cit5N2s1anh0dFNK?=
 =?utf-8?B?TGxFTmFSbVJhZEV0MTgzY1FLK3puTTI5Y0pQNVlaZGtzSVdMbzdHNks5cWlu?=
 =?utf-8?B?MTM1ZmM3Wk5mM0hMMTBLWm5OWXZ3UFRMU3BkaTJrWll4blRKLzdCUWlhNzRy?=
 =?utf-8?B?UTJ5bXRTZmR5SEFoSFBpTk1VbjNJMFFBTDFiRVZPd1R2MnpjUDhYRXdNWkVV?=
 =?utf-8?B?MXd5NFlRcFk3dmo5UWFYMnFiMFkxTTlBbTFqNkF5ODFGOGhSV3I0NXlhSTNZ?=
 =?utf-8?B?dURxV3hUVGd1SzhOYWpSS1EzS085Y25FdVpnMERpOUVSMmJORVRuZEVZSlJp?=
 =?utf-8?Q?+fRZJx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 19:26:45.5961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d72736b0-50dc-4429-3eda-08ddc3d58969
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9270

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

The following MMIO registers are locked and ignore writes after failed
SNP shutdown:
Device Table Base Address Register
Command Buffer Base Address Register
Event Buffer Base Address Register
Completion Store Base Register/Exclusion Base Register
Completion Store Limit Register/Exclusion Range Limit Register

Instead of allocating new buffers, re-use the previous kernel’s pages
for completion wait buffers, command buffers, event buffers and device
tables and operate with the already enabled SNP configuration and
existing data structures.

This approach is now used for kdump boot regardless of whether SNP is
enabled during kdump.

The fix enables successful crashkernel/kdump operation on SNP hosts
even when SNP_SHUTDOWN_EX fails.

Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")

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
  crypto: ccp: Skip SNP INIT for kdump boot
  iommu/amd: Fix host kdump support for SNP

 drivers/crypto/ccp/sev-dev.c        |   8 +
 drivers/iommu/amd/amd_iommu_types.h |   5 +
 drivers/iommu/amd/init.c            | 288 +++++++++++++++++++---------
 drivers/iommu/amd/iommu.c           |   2 +-
 4 files changed, 212 insertions(+), 91 deletions(-)

-- 
2.34.1


