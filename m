Return-Path: <kvm+bounces-15436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A258AC088
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:07:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B0811F212C0
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432FA3CF72;
	Sun, 21 Apr 2024 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pMe4/7sB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A783AC16;
	Sun, 21 Apr 2024 18:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722822; cv=fail; b=gmiA05CP0FhXUqkS7o7zUgTn7ADpmdLeO6ThFfKqFHSt/qXt4y7XuYl7zMJQhJhB+PvGozu99OCZ+Kdf9YAIr5gpfcrr1tX0Cl/vAb+umqcUMQXPZ7QKFCyRxeeR4oNNllSo1u/WsoYh8RsHN1sr5FRmDsI+sfWqeZcmwj9JlgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722822; c=relaxed/simple;
	bh=Q+V+nYqBd6POkZspbyLDxUbWczhgLGTzslpKte0/ECk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gm5dyKtuIOgZs32sqU4RRXMraNZEqe8F+Dv2d5bk/2Ox8AGFuQsuqeyrS/G+rmVZtf4DoIo2taoZh76XLguaaYVb7hSHNVbXEtrXHFfdMvUvKQZxwJ+WCKrDXlYQN5tqVWfsyOuRE6YNvR5wYBV3nGinhMZHW+FE/rOFTXlgY1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pMe4/7sB; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lchikEj6lzpwCZPpoc4/RZBVpisku0V/1DsE0zd4ywix1wFeU6PWnczzk+3x/J2C17L8iO1zg34H36cJjC2NMEKVY1qS0vd/NkItEjLiLFpsXbGc4cTMzTdbTj3ultUVOIoJeICnAOfV//jiZzFg6nhBy6CSU+JTS29jKmVIoc3s+Np+OrnbNs3ZPtAattKF/IrMyXz/QoV0VgjPXdarPzgUYY4M/qKZXjforqyevUlHKOSQCChvb+etB+L9JaEy1df5iD59zl3ySJQc6o+X/zLJ7d+2MwsEvPl1rM8oklXEYXjj2DoI44UQ+cTrm9Z/BAKnABCIRwo+B8uAkxZpCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWxiMrBbWnKcm6ydpzx29svDwThWmkLP9QyIGv8efkM=;
 b=ftPXJ+jVxjcfdYzDwxn0noZkhVoHdyjEDmfXYTQnFuZ2nQkT7b5gf2KSPQxcZ/HPRX9kozyyHY982+IIzh4Op4oEUV4HUsku247419wJgeCL7vCkYhEG/x8eA+iP3qbfF0RaHD6VDuDRuhvzzU/2Rmx0yrO4/AtxueXiyOqpO8j9AM1RS1b/LW2sI8NmUYxPdCYWU1Cd05f+VChTl2drZzbj4QytuQ94Vf/mq+5j2eF93XkhwJeI3pkUt2gi3u8Y13qddmzhZNJOfh5s8iPUxtPAMvLOWyIrBuRFCg1VHrR/+pkQ7gxcSlmxJ9eNZMdAYETcZguJADmLgRYZPyPoiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWxiMrBbWnKcm6ydpzx29svDwThWmkLP9QyIGv8efkM=;
 b=pMe4/7sBvEAq0OuZr6MNt6tGtLittwOHovoQ7xaNweolwSFHIfN9VhLCfB648zXg1wuh3umCz5FDrVyaDwlIeXlpruoSv3xYO5iymucWLJEnYTRJ8ju9TJdjuv0IY+jOR5PSWU71oJ5TfW7iuMPxi19o2pJmv5StPDqKDEWZe3g=
Received: from MN2PR14CA0011.namprd14.prod.outlook.com (2603:10b6:208:23e::16)
 by PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.41; Sun, 21 Apr
 2024 18:06:55 +0000
Received: from MN1PEPF0000ECD5.namprd02.prod.outlook.com
 (2603:10b6:208:23e:cafe::d9) by MN2PR14CA0011.outlook.office365.com
 (2603:10b6:208:23e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:06:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD5.mail.protection.outlook.com (10.167.242.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:06:55 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:06:54 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v14 18/22] KVM: SVM: Add module parameter to enable SEV-SNP
Date: Sun, 21 Apr 2024 13:01:18 -0500
Message-ID: <20240421180122.1650812-19-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD5:EE_|PH7PR12MB9066:EE_
X-MS-Office365-Filtering-Correlation-Id: b56e8a82-40cd-4e50-ebe2-08dc622dd439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AiLufHETMZV2o/iR+DNIPiYIdRlsvMk0NENoITWX0b3Pl54nf9gTBXTHbRoA?=
 =?us-ascii?Q?x4p/8Awr3ADafvwT6V4eCRpjL23hFeoVImkSDwSHc6VIeg3e8xETTpFAzvFh?=
 =?us-ascii?Q?FKgzDAAGs4+r8tZtOdchm3aACrdtu1qIrb7DGtNjjLaMaKF2t6szw61+QMtI?=
 =?us-ascii?Q?7HJxLhsH81AJ8kaimpoIYgDR6QCQLUr7ql6CqaeR9MTeyCAllsstCwb+O74N?=
 =?us-ascii?Q?IiH1Hxh/l0ITXCrjRUju3ZgDjVj3pVm4KopU5wkNn4hTzxNhsy4WbNU3mmBQ?=
 =?us-ascii?Q?N0idc5WlXz5YxE144KkFvLfG74ZzbvnGCUCZMz5+wYAp2he8lEvXL/MIjlgm?=
 =?us-ascii?Q?AnTcxkvMrxbwjCXCXGmrg5N1eqn2rLqwyZ5ehqBYY+hhcb1BlM6MR/J0utJs?=
 =?us-ascii?Q?AiancBA1RQEx4yUfkP4S3UynZ1Nh1WjpzsFjHQXz8A5zjI1xJLTf+VtlVMOd?=
 =?us-ascii?Q?vlnPuYbwyR2T3uv2eMWkSzO6DdJHKyPDbSbkCB4N2ks/HlylOshZuBVuflzL?=
 =?us-ascii?Q?mUDF3sQDOcCBCm1RhhomsxWmuAM7Sw7uepEu/cNizKjDfkX8CpVjw8llUcnH?=
 =?us-ascii?Q?PqJ6i/sll+veZbbEkX7qNFLAojMuNu79qj+ebO9aQrmnFYaC2ZUkINWwGMGC?=
 =?us-ascii?Q?21gCSRjfFo0txZmeI8A//0rvouUt/+7MnClWWAZISOLf0TyP85V1bbtWkTmA?=
 =?us-ascii?Q?8KOwr+WN/CAF+ayTc1WKsadl4iGN9b5u5NcGfzyJlPERBXG+1LwOO5T3X05+?=
 =?us-ascii?Q?mLuFnuUFBDDMAWxi4fF8F41TPdDuwGV9XOwYSRmxjmWR2JF25+0Mwrr/nDxb?=
 =?us-ascii?Q?fIhqr1SLOF02UBi9OYwFb+yDWWT+iq/WigAfVyoeEuDgFP1l+vEnBPbbOd4/?=
 =?us-ascii?Q?F1p5ci+rwgzuWVokR4Wr+d0ZFDg/8KBbbL492dcJ28RywvsSH4zlJfMdIp+W?=
 =?us-ascii?Q?OiJOsxHuI2kUX59JIF/moJcTk+4ZNyZwSN8NMojBtscu0zIbpV0Ku8vt2Y5O?=
 =?us-ascii?Q?vy8D4PbwwyW6a0acgcKq6fr9T+j0Y8aGivQAzZEd6LXBUNv+JvAKzD14K6ON?=
 =?us-ascii?Q?gBL9m2c1mwa+N/GWb+vpXeQRAJ/mqR/4o5440/bQ62tDfVHgxwPp5/2EHLVn?=
 =?us-ascii?Q?6LvIR97h2CS6R36I7AfQn6+HKkIVKRad7KZCCzCeOfRI8hlvdHctiJGy4ukk?=
 =?us-ascii?Q?28QLQlza1uJXo6M6bLo1kjZlMBs63CyLNqqp3OSr+/VS4+Go1cXyc5Epbmew?=
 =?us-ascii?Q?Co0RbETE7YBhBPqBruiCBriwsweINhqRdWbMQg8N2YZeG4Iw3g0fQucjGO67?=
 =?us-ascii?Q?i0xJgObXZCjN/Tl29jfyJ02fazDdr3/MFKpFJm2lslGonIfOyZvdjL5lvFG1?=
 =?us-ascii?Q?WSm/89M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:06:55.2758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b56e8a82-40cd-4e50-ebe2-08dc622dd439
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9066

From: Brijesh Singh <brijesh.singh@amd.com>

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cf00a811aca5..c354aca721e5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -48,7 +48,8 @@ static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-SNP support */
-static bool sev_snp_enabled;
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
-- 
2.25.1


