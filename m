Return-Path: <kvm+bounces-40201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 822D7A53F34
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 01:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B49C53AF696
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 00:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D051F95C;
	Thu,  6 Mar 2025 00:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LWeamPK8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FD918B0F;
	Thu,  6 Mar 2025 00:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741221500; cv=fail; b=UOuqQlwjf66owNG5h8wgRssEas6HcMXffVZQ4bwtOh4VFZosoe7K/lQomwSVKT0MYAFRHgvcVT1Lhh/RkdDtQSSKE4NAPlOKZOvYtR7os+6YTGP5taOKAa7gZjinYARCXULerPVrJcprJO4r27kQrFFV4sDNBuNjeU30q4SfvQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741221500; c=relaxed/simple;
	bh=oqp+O5/JJl+nrEF07v8f8bBnFK1pd7N0IRy0ZYIOBJQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HQWA6AK0j9+fhU4rvSSjzqVCGfJOP9kHPvtD8lCqsDTREyjucmkKLwSI5RpfxnmIfvNoiVlkL4i/Q1w/0cj3PhVSeRrl3ioaM9VhtzwFQyjyXqo4SPDVAYdv8ffY+BlKsdkMiw1lN2MDPRayG3gTEwKF8jg9AsexA8pT0U7GneQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LWeamPK8; arc=fail smtp.client-ip=40.107.236.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mnc7qZjc6UsY51dXEZ9zB2GOCag/HrHSjuk+K5+pC242HDas6BaO1KfiLn/N6Db8SrvDlS2Znny+a5LLZ0Irv+UcjKCArG0zodmtz7Lcy63+gIJbE90ohvh7afDLA2+I3YLj0tMYAmaLnbH6iR4JGf7HZjtJUr0FZxqQfNEUosRgkH5ro4+WwMQr9DeovzEk55W4TOCT7rbOexp7QJ7R8VQPVsJbG8d92zysXjDxfYGF1veOrEhsV08QdWwPWxhyaSZyrhAmr515T0wls2F8sHhFZFyZ5V5mjIBDFSNwzh26olNlmYm/asxnw5UiCn25yenDjzOuIZGOjykKbquSQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ml3hS+OvqzZ+jyPpvfsvlBxL7I8HKTWzOcjyLHUHpPQ=;
 b=EiZ4loQJhcMr6Skx7QDFAmL3dXlInqUVHfSU1MchD63W8WphwUO/DatMMODwsesYbacddgci8Gc8MZTQgvaiy6oMKM0jXHQ7SeVY75vXdhBWKVDm8+LZem4w1TXwNmzn5SpjtqLFYGsJoPW2iqkHFdlFEukhvoelM/F3/lSNBZqiKCbrcpLadupOJ5LIUJe8vvOoufkd/Em68TRPst6737oUCxZCbfh7k/+Q9Og2Bp5F9thSChYgdqlqcawnaWeiuGf3XEt5GxlfCPpTQLIKV2bGRzzy4PBVDbP2ew+cQWOIrQvMESDZaftFRf6nbxxWF/n78Pt2jeT6WDWZ2f8X2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ml3hS+OvqzZ+jyPpvfsvlBxL7I8HKTWzOcjyLHUHpPQ=;
 b=LWeamPK8/e+OBhOaMrcPkzOx8IcpLlb5/bP/myYlJBpSlQUUjN7LwyjVtNAPiF7rXnTsPodORKw6t2m1jbwVwEW8oBTSX3wEzFSJa61kAW4J3zTxLXQ+Cx1Xkh1kI28LcGQM4+paqZSLHZOqajcmoDfDRMhbptZkfIabk1QoQYU=
Received: from BN0PR04CA0083.namprd04.prod.outlook.com (2603:10b6:408:ea::28)
 by DS0PR12MB7779.namprd12.prod.outlook.com (2603:10b6:8:150::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Thu, 6 Mar
 2025 00:38:13 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:408:ea:cafe::86) by BN0PR04CA0083.outlook.office365.com
 (2603:10b6:408:ea::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.28 via Frontend Transport; Thu,
 6 Mar 2025 00:38:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 00:38:13 +0000
Received: from zweier.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 5 Mar
 2025 18:38:11 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v4 0/2] KVM: SEV: Add support for the ALLOWED_SEV_FEATURES feature
Date: Wed, 5 Mar 2025 18:38:03 -0600
Message-ID: <20250306003806.1048517-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|DS0PR12MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b1db463-41f4-4546-a66b-08dd5c472d85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9C19G3Oq4X9J0ebHyFQfXIvFSn5CYuFj7go3e1GQiMbJR6AGk54wWNFqCbTG?=
 =?us-ascii?Q?edImpU+1SwdAU9sZ0rNpBiPvCVyqf1VlmjvFCmiVyWtsDSRt4Nd0w9aqg5N2?=
 =?us-ascii?Q?ziARXVtuK998f9RAU7G0oQjGZ6FHKf5igRov3WSU2v4NaMy0VsR9KKqyF9MK?=
 =?us-ascii?Q?gqwPiPKwT9Wz7QoYtqJYiDOCo5lOxKGy7wczCAGaL++t3tYE1KdmCrPlB+6K?=
 =?us-ascii?Q?yt31iA7biw3SgyPGI0B3SSKsqG+uDLKN1LaHzkyLlYyaTu8oPd8H8lA86m4b?=
 =?us-ascii?Q?FjqF/r1V+sLHIRUuxjheFH9nugbKczvxlRZjSFDGhCgTRbknxhq5eQmx2sRT?=
 =?us-ascii?Q?GgirwqpGj8cG90ckNpgWKi6j3YnarXa3gjg/ComcvTtUy1QMtYlZOchBCQkm?=
 =?us-ascii?Q?pc5W5F5X4Sk4JAafW3YPvfN9hDSGesg1SNdkIlWdmNFw7XwM+5fW2sJ7N/Em?=
 =?us-ascii?Q?wKUahFLBtpAVeQLRgOCLnidKmB7sqP+x5J1OKy4OSyShwSB25P5BtkkkZTGt?=
 =?us-ascii?Q?qhrpL8iW9wLZIYqIUPu7oeiwe9B18TnF2uVr9VKro7xWzMpKUWrhMqEZG8tU?=
 =?us-ascii?Q?ub1dq/ny1okmOduTURvQed7khONAZpIjjTywjZydlmMDNeUHbyXed6fxZ1kL?=
 =?us-ascii?Q?IpE4cJSaG9JldoKgX/Pv1BYf1ZM9bo/1dXaINUDa8FU6D3JtkiJ4rdJ7BPZh?=
 =?us-ascii?Q?EXcnj1fsLIpAD8nqb8vKXquTuGLPtji4CvI2YBH46J2fbvhjawPt21GcSIA9?=
 =?us-ascii?Q?496q4iC+RjLWKsw+sWywsbkh9vIkb4s9NPgEjqQZYAyYnD7C4WmySdpZgEnf?=
 =?us-ascii?Q?YpcNeqpxOmeNedKk0+Rka4QDx2gTL9YLwmCkwbheEujlYV8MW80CLwPQNsg9?=
 =?us-ascii?Q?gy8ijo0Mns+QGtGPTxv36ye0QD8uLeTB7ZY6uPVv+zemDa/4+2BnButBoF4Z?=
 =?us-ascii?Q?y3mjf5IKIt6zFOlroWdq3QAHqEAVRnhNn56dFdYCNI9BmBlbpOfHQ4RUO8sW?=
 =?us-ascii?Q?xl9ZDNzODGhSf6k3ZziApccqtCv9FTH/hUOQ14LBnDJ2DZLJSz/X6fgTrH+2?=
 =?us-ascii?Q?kLVTt/Cl35vZvU1fLezifRY/P0pagm7fF1cQ50KSZoi6ea2xPBgdJlxNhs0G?=
 =?us-ascii?Q?UA28ItQBCR3Z+an+wxXlfEQ827unB/ON4tDKL3AQUSg8OD9HtmPpNXiBFNyx?=
 =?us-ascii?Q?jypOXYB9YDeLkAUwvlMQ2kwhtvqUsI73CWQ5TH3GHgbUlZZXRhRFYBQGwmt2?=
 =?us-ascii?Q?thYRXHZzP9FdrbflDlID+qRnfP0ew8PalDzDA/j4lmrTSDKhM7Rs+vzviAbT?=
 =?us-ascii?Q?22AHJ4w03qpi898AYJysYdq4AcOd1lcqJ+wyn3Jomps3yJA56Xf4HHUUVcxu?=
 =?us-ascii?Q?V4fjSo1KU+Jr/hvdEPlx1kIydagUIh1E8qpY4ust6roieSSHqI8J78BJGgsr?=
 =?us-ascii?Q?EMe7snrndjtdctFihSSx4kK21miMPXlR?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 00:38:13.2176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b1db463-41f4-4546-a66b-08dd5c472d85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7779

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

v4:
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

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  7 ++++++-
 arch/x86/kvm/svm/sev.c             | 13 +++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)


base-commit: 7d2154117a02832ab3643fe2da4cdc9d2090dcb2
-- 
2.43.0


