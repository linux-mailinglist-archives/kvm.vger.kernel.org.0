Return-Path: <kvm+bounces-40700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B24EA5A496
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 21:16:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC19A1891503
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 20:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7331DE2B2;
	Mon, 10 Mar 2025 20:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bkN/DESx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FA3137E;
	Mon, 10 Mar 2025 20:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741637786; cv=fail; b=Tx6hUVLPhAzpxGH8Ki5EpN1cB62jZoosgWrR6oKZwTHaMJkVlNEWDxCyND2Pt3gzsTgzHg85CfCBTnw6KmxbzjMdiozL092AuBfNZfL1JZ6v5CeLh9pCruMClGJ0JBLmhirZtoRyFdwEatDfXX/T8129gQ70LwYSTgGyakoZTgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741637786; c=relaxed/simple;
	bh=FlfBIlFdvX1yWcnnBzVLo2meShH1hkVNuzyCFYXjO1c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tXLIIdo1CplOzyGWom5rvqvU46aw7uAxqKSyj6YMQ3cdVPhFXV2H0fDFKUPAnBOmlTecOo+vYh7i9VC/BmG4TK9Q8/y+878MlbVnc2dmb2ez8WO65z+NxTP5wMq/aoA1DO8J1na99V/hd2X0JzBY4uGFI73Q1QzHQC0l1bo4KMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bkN/DESx; arc=fail smtp.client-ip=40.107.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lY6lbzfy/m6DxFYWCG/qZK0hw1GHHKYNNNaGRpW0YevJJU8IXmXPNPg/4GKOJZ3qmYY+AimbIZFtEVcNNn0gbd0jjRjDBmcNapWx00KysnZnKhE3YCeCunsT5IA/3TBUuPmpCrW9EUrJfpBoyh+B/OheiIpS7MfnnrbatT0vRMiaekiq9kr9eKhDtdV3gMPJdl2o+V76bMhjjY4bc9LXPuGsSYsYZcn+FZLWEZ/djt5d5j6XVF66qn0avIFkBM0ot8D+0ZRrNh7lokITw73wBALhpY37RpQbkXtr9cye9QRZhhPcEOLn3AjkEgF1OwTCdOblZug9W1iYJAOqQYed5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hvPg7b7mLu+THFfuNVZR4OopxdD9Sjf8aHysGvUqXs=;
 b=f6auvFTtFIl+PcKsMphmgwqtNdCTFN87IJQX+q45d2SXZT6hm9CLYQhSH8gPyLUmFqrxQhMfC7vfMSFAXhrj1hBX8dv2aAR/bHTZ0cC470n2IaCHitaQ09Xo1jmk5F8xoOCenXZ9itgZXO9YGfAMSd07zq3WiDguifEPuq9fAgR2Zpz1YQdHAfaNEKSSJX2uy24XSlqigT29qafJx20Y4eqhEJvy7EDhLZvABb4pXl1C9HGQ+8sba4R1/FCgM+3fp45IvtWzcn7mFGc6A6ayNRkdVdsLKN6Kwct7ZYZM4DpzgMSifXfv96GjoxxqT8Ax2d3+Jw49/qObqSaVvCH6ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hvPg7b7mLu+THFfuNVZR4OopxdD9Sjf8aHysGvUqXs=;
 b=bkN/DESxhwyOcVJjCgR3N+1XVY2E9QUPmPJF+5dc5X1TQPiJ4+L8S2OpzvCg10R/l+unLHcZ3+2NryMV8JwVOMaCPESGCO/yIw4wqiUPabWT3/fQYg2H55GMO0jDan2wrLgRXv0Cj9jfRYv1ccrXPIKBXMf8vJO8KY5lMzpaMxU=
Received: from MN2PR06CA0021.namprd06.prod.outlook.com (2603:10b6:208:23d::26)
 by MN0PR12MB5932.namprd12.prod.outlook.com (2603:10b6:208:37f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 20:16:16 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:23d:cafe::f1) by MN2PR06CA0021.outlook.office365.com
 (2603:10b6:208:23d::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.24 via Frontend Transport; Mon,
 10 Mar 2025 20:16:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 20:16:15 +0000
Received: from zweier.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Mar
 2025 15:16:14 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	"Naveen N Rao" <naveen@kernel.org>, Alexey Kardashevskiy <aik@amd.com>,
	"Borislav Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"Sean Christopherson" <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v5 0/2] KVM: SEV: Add support for the ALLOWED_SEV_FEATURES feature
Date: Mon, 10 Mar 2025 15:16:01 -0500
Message-ID: <20250310201603.1217954-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|MN0PR12MB5932:EE_
X-MS-Office365-Filtering-Correlation-Id: d07fe43e-1dd7-4f1f-4562-08dd6010695f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lb+xJ0Pco49DhCnuLrdZazOC/2RBdtVWu/6groF+qqgE2NPTeYUz4ipH6Yrs?=
 =?us-ascii?Q?zIAHl9VOI2Ap88ObP83RFU82mivYakKiE3hva7dQphCy/ErGsFsGFr/DPWtW?=
 =?us-ascii?Q?fBdGRzIf4Bg1zGq4JOQEHj+lujkMEFHuN2K58VlQ/hUBB4Htd3EOdTfCGzVn?=
 =?us-ascii?Q?K9pYfvIFet+8wJx+lICK8LcGBQAYlS1NanFro8IC/GjLjFz+rzMlsWZEfy/9?=
 =?us-ascii?Q?zzlx/DmZ88dewzU2suQYsBgOBfLcJI7mHkimxUQab5lGku08IeXwUVTJpADV?=
 =?us-ascii?Q?hofgt6+vfaxY2LqmhooIRNReNGIWBGTIZUS2ohpFi9RbFkzl+s4+kGekL3gL?=
 =?us-ascii?Q?2C+dzSu4/UGyIKEr6CMpU/6HTG+io5khilVeychtRY8OkdqWAegfI1Qud43p?=
 =?us-ascii?Q?cC7frj+6AtvwPYbpXtZxZSZlX1Xskfa5Cb7bMz/AU+YhRiyK8CDzvLRv6j1U?=
 =?us-ascii?Q?2PaZzerSkctYL3gnlTARup0DYG50rdi9ltetYF5OOVUT0grmNJH6a0PaoMLZ?=
 =?us-ascii?Q?HLFitMWq8kkDEYf42DuTZSPEd3g+KymLAcczWiDUZf3v0U/3iZQd9oaro4h3?=
 =?us-ascii?Q?ZTf8A5uV7iYL2g+X/Xx2+RPi3ijkc1r0bmtQeWlYEKLXUCdeklVGgrUl/oCX?=
 =?us-ascii?Q?yKSM4ifriEKCKje/H+VUtHipS7xo46nNhMUcQpCfQvyZklcr1X8REIKjXIHt?=
 =?us-ascii?Q?sTFp9rPNZU3YJpfSu43Az1iplctxBeHR9ivH/jIc/IeZuMUC2petFzeoeFr2?=
 =?us-ascii?Q?RgIB1qwtAOQGg/LH8wOZZQVVAxRVMYfi3yCgE8amWtDPqG26YmldnRH0coox?=
 =?us-ascii?Q?TGaqBynVFP/VowYC1QvFrskoaxE7RCnQFQdA7XmNpR08Hs/hHHze0DIlopxE?=
 =?us-ascii?Q?740xteGBoKr1hovDii+Eb95nvzb8oYb1wkgbGja3/zIj3pJ7HXX0m8hQwnRe?=
 =?us-ascii?Q?/L0v6O83Yd+hvIHMYS8IYQSEvUf/dchIDBFZWpSChS+O4Dl4nja86iyg7FAX?=
 =?us-ascii?Q?GY7z2w5nKS4p66YCZDMjXGla+mOIeNyTuhVCV3wUrgOitzW/9JDgJYFOBy+Q?=
 =?us-ascii?Q?jav5qkGqdJgBwp+3FJYC2qwKz+zjlthQ4GIiUESnR/kyZtDLmo9nd3omDRMp?=
 =?us-ascii?Q?AaQv5D6Orzj2FxpvhggmCIZ2E0ks8mTgFRh66lfRai21Cb+LzZadUMTvvhW2?=
 =?us-ascii?Q?rkLAn1YKB/mIvCICNVmZzMJ8TJR+P/rvcOCV1/o2Jqztu10EREoL/rBIDjfB?=
 =?us-ascii?Q?pIVwTQnzL1AtyRV6NNHuDJ+SGLGPKBHYTVoz0Qgu8De9GV3vPEJU0bKNoMDo?=
 =?us-ascii?Q?sN++tL/Jmzrof68o1ZCi+gkVHuPx51sa/yproLv1mWJgVjdXGH/sh272lZv4?=
 =?us-ascii?Q?6PaT8fsy/k9tvGmgFXzR1cu09kiYjh9KwXIIOZ+iPlAUGUUHh+08KLPJbA8k?=
 =?us-ascii?Q?YNgdExi9z+TNE6LEAL6fwV+WmoVITXIc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 20:16:15.9604
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d07fe43e-1dd7-4f1f-4562-08dd6010695f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5932

AMD EPYC 5th generation processors have introduced a feature that allows
the hypervisor to control the SEV_FEATURES that are set for, or by, a
guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
that SEV-ES and SEV-SNP guests cannot enable features that the
hypervisor does not want to be enabled.

Patch 1/2 adds support to detect the feature.

Patch 2/2 configures the ALLOWED_SEV_FEATURES field in the VMCB
according to the features the hypervisor supports.

Tested SNP by setting random feature bits to the sev_features
assignment in wakeup_cpu_via_vmgexit() (but not its ghcb_set_rax).

Tested SEV-ES by manipulating the save->sev_features assignment
in sev_es_sync_vmsa().  Note that SEV-ES "allows" operation only
works on features available in SEV-ES, i.e., it ignores SNP-only
features.  Zen5 SEV-ES features are DEBUG_SWAP, PREVENT_HOST_IBS,
VMGEXIT_PARAMETER, PMC_VIRTUALIZATION, and IBS_VIRTUALIZATION.

Based on x86-kvm/next.

[1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
    Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
    https://bugzilla.kernel.org/attachment.cgi?id=306250

v5:
 - Add reviews-by
 - Add the two new vmcb fields to dump_vmcb() output (Pankaj)
 - Address comment by Tom and put single assignment in sev_es_init_vmcb

v4: https://lore.kernel.org/kvm/20250306003806.1048517-1-kim.phillips@amd.com/
 - Revert the user-opt in (Sean, sorry for the misunderstanding)
 - this basically undoes v3 uAPI changes and makes the feature
   always-on, if available
 - rebased on top of x86-kvm/next

v3: https://lore.kernel.org/kvm/20250207233410.130813-1-kim.phillips@amd.com/
 - Assign allowed_sev_features based on user-provided vmsa_features mask (Sean)
 - Users now have to explicitly opt-in with a qemu "allowed-sev-features=on" switch.
 - Rebased on top of 6.14-rc1 and reworked authorship chain (tglx)

v2: https://lore.kernel.org/lkml/20240822221938.2192109-1-kim.phillips@amd.com/
 - Added some SEV_FEATURES require to be explicitly allowed by
   ALLOWED_SEV_FEATURES wording (Sean).
 - Added Nikunj's Reviewed-by.

v1: https://lore.kernel.org/lkml/20240802015732.3192877-3-kim.phillips@amd.com/

Kim Phillips (1):
  KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field

Kishon Vijay Abraham I (1):
  x86/cpufeatures: Add "Allowed SEV Features" Feature

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/svm.h         | 7 ++++++-
 arch/x86/kvm/svm/sev.c             | 5 +++++
 arch/x86/kvm/svm/svm.c             | 2 ++
 4 files changed, 14 insertions(+), 1 deletion(-)


base-commit: c9ea48bb6ee6b28bbc956c1e8af98044618fed5e
-- 
2.43.0


