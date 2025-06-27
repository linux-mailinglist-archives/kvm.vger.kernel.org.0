Return-Path: <kvm+bounces-51015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C9DAEBD52
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35A131899E8D
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760412E9EB5;
	Fri, 27 Jun 2025 16:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FrS/ZnlI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2067.outbound.protection.outlook.com [40.107.100.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A62D2EA758;
	Fri, 27 Jun 2025 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041591; cv=fail; b=nDPzNAR0D8PGPKyDDiyue68HqxrxIKfjNLif15/YOYD4onS0hMWZfWVGw2s5YJNKVRsTaixGUIvdS8jctOgxd9RczmMoT3bXP8c4tJVsyc2C7EB5MBIzT6YpX4dRgPYArGv4dUszw3eaqqZa/XG12XPRY3qHMUTRHA0o4a+5mcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041591; c=relaxed/simple;
	bh=bOCuOsz77BGRpVIEP7OfOEnx6yU6l7WC1xFUlkMMPWQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nK/7QtqwXA6ewENGCXZZ28MqSrA1HsdxXuP/oBuKdt0iqJXOT4gwdwhV78kFsmrS56V0RZu5cQudjSAJQbxYI1KrBYDEX9+IQaZ/FBqlB9CDUNLLi0aALHs9G6Cy5T5oCQKz50QFtlfbC3K/HyOKcXlZDJh8abyVkQbOcALaXoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FrS/ZnlI; arc=fail smtp.client-ip=40.107.100.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ex4m5heC5ahNRpox/OLJ4x6MuxeacYMB1ENGWPncJ84aMm6R2FA6+snCl5XU+2VuvxDLImx4iBVSDHTC89wnIsVoE7ImkZp5qAjj8X/GQjRybDdOHTbVSqYlRSO4gdOFD26xENY+ez+9RFvjmf4tsfYlJgRplk3C3Y56XRj9bIjo3pZoWiHzhzsizA1q2SoPfPzfzS/Z+ZQmbneh46KNQT3G7yKDhJsmOiiTQ/Hw5jiVDFmJFhEwhV54l31dSaIjYGpTl4N+0NsNkTbKUSEIi2rz6M4cOIfUX5YYfK7GZeBfWt5PPTaSeGnvrtZC4QXGvdLCXHy97nkS4L7fmTmQWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oITKMvQD5TpRmTmwjahRqw6kRQanyWQu5MmGh2evWBg=;
 b=scZAotx+sNI+HyKxX/4ukj5LxhirlOz1wJX9qVelWuqOxYFY9qAE2H49fNx/QVUy/mmAJ7oKeJp2KH+t2CY4LUe1Oer1uFH5RiYDv2tvNaiQMWo4DH2MZtWY7IY7Ju8hwAyaxf77KKr4NbLsRaGPmjCa5V2xsdMQtuIEBwzpZjGY+2FTDWNXT69F0h14hCjv6F/WQoxdoKTc8w8q16ucXGZs8nnPsoi5J64iEXk2lJYOodW9Jy09Dj4O5YmAza/KoXRLiXEPeotrROqWs1GSNwzaMvXjmhyl2T9Qko+LluZKlkb66zmDThJ/gpkptOppsGJS0kOw+uWF7+E9rjuX8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oITKMvQD5TpRmTmwjahRqw6kRQanyWQu5MmGh2evWBg=;
 b=FrS/ZnlISfGLPj+jaWWCJ2MH4/yDN5Ccr2nnNrxnpT+kbcI/qdLcwjUhGWV9YuiMFLcx2CHTNvIRdHQSQw4oaZE+V4lQox2HSA78OsmuZQSj2DJCMaV9PctaW0U4QlSTOkD9lFZuT3K4WLcEFWMSUt6RKM0gRHXt3mO1AMzW9lI=
Received: from SN6PR05CA0008.namprd05.prod.outlook.com (2603:10b6:805:de::21)
 by DS7PR12MB8289.namprd12.prod.outlook.com (2603:10b6:8:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.38; Fri, 27 Jun 2025 16:26:27 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::39) by SN6PR05CA0008.outlook.office365.com
 (2603:10b6:805:de::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.10 via Frontend Transport; Fri,
 27 Jun 2025 16:26:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:27 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:22 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 03/11] x86/cpufeatures: Add CPUID feature bit for Extended LVT
Date: Fri, 27 Jun 2025 16:25:31 +0000
Message-ID: <20250627162550.14197-4-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|DS7PR12MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f91f16a-4a4b-4a64-91ce-08ddb5975d9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H0b2jpVqjSFTRcGIbm+STwHnIWiYTC4nwZP4rP6yeh6cgBAoi5wwgKODDKSZ?=
 =?us-ascii?Q?dF8BmisPG6qi7AbV/gOI8a4rf4BeUaMswpujSpccxJWpdW4q+dx/eMis+yuV?=
 =?us-ascii?Q?0aXI430STP3QnuXJFFMH+F7IOZyrhdCB8H5xP0bzl46pEtLtcHGY6cvTwTxw?=
 =?us-ascii?Q?GP88iKrGzZwdjVBysR5z2EZWxfN1pDbcn4SPMAfY4pv4X3Vpjir3jG6Pi5Ro?=
 =?us-ascii?Q?G2EGEiQqNGlG6HMQ58xj3nPiBcpVRDx5khlJ5XYPv59ddECsZKDpKfQiCU+R?=
 =?us-ascii?Q?Jt9pnUK77zQzuRHWFRw/hjNHiW/l9e9woDbaqKTrj8rL91G2fTW/YNlMjISI?=
 =?us-ascii?Q?f8fXXlyaZcZjonH7x3e8RieTv0A2Ndxv7pxR/hwIVaKhbFm3KJgEH8r8YMIN?=
 =?us-ascii?Q?wht/CFLrLKBl835WrdHCwxLqGAZdc7+mFS3lvbs0F0reh4THM/0QnNPicnKI?=
 =?us-ascii?Q?UbiLU2z49jHOAQjJ+FeMGTy0HXdVTjHGC3IU9tmzEBitF9PFZ5blVbFO8m1O?=
 =?us-ascii?Q?+7PTNMgCXHUSe2gkWidcbIdRsvJOyajJ5PV7CdIZiBdyNMYQsnFzoirQT4oR?=
 =?us-ascii?Q?qtmQZHmGj/SgQsMoe7F+MNbChh32O5NJ801Tavm2z3OhtIaozv0FaTkoH+2U?=
 =?us-ascii?Q?Vh5hd4tM5AMXhIJ0QC/OW37iV4VcK7GZSYH25sm7bdF2TX8uTT6vbM0GPFjx?=
 =?us-ascii?Q?PTWLm95UA9WlSGLLmJkwJMcHU0fAWAkfvTjCyyQimYcg/2vdaYqgnyHNcl82?=
 =?us-ascii?Q?SvGA9RVf+aWPN80VdF1w+xEVkuYdrgCOQO5naeAUZqT4NJJ96FRHrgJ3TGAO?=
 =?us-ascii?Q?vpr1xxUHpJtU0f08JmxLQRLnQCejMixJ2Mc5xlsw4I1hqf8+MR0X8KBKPmmi?=
 =?us-ascii?Q?UDSsI/7DFH6SBKpNSqiaiYGO1XaXA4PL4JA+43J6rAF7WR7i40lTKy+K7IeC?=
 =?us-ascii?Q?C97s8o10fry2cAWXO9NKVCTaHd9e0uEHYzOsx9NN/JKvlSChIPIuy5arG+9D?=
 =?us-ascii?Q?HiaIbG2u/vH+7GRknT53r8GnppOtXqbZbcdbYgfcxNx3SDZNe60hDl2XN3VV?=
 =?us-ascii?Q?Rv8IoFbq2TsvWLprMV/eNFnBwhf5fYUCN7YgAYCRqRqss1S2+SQsl+qTIFr4?=
 =?us-ascii?Q?UJlnkxpwq/QPF1g9909iThgJO0rGN0lWUaO0Z2QMeVGw0ttg3rN2AAtZEQHV?=
 =?us-ascii?Q?pMXBfM02aHNnnghZnFWWNrqbf/EUYeQ02D5iDtY8DZmci6W1Bcl5BkfyoPgM?=
 =?us-ascii?Q?wphiyt6UkY9EnT8sRaDh/1HW8xVHBEMyio8AUCVrEanqLETN1TAQW/STIKTW?=
 =?us-ascii?Q?NglyTpsNHxQ7Elck8iutvfBFkfESNAfGVrQkfSiGNN5fLXd/mjD7OCZm7XTl?=
 =?us-ascii?Q?VIu0w1iylwkILPeQS43tcYzrqH/KdJSUflNl2khnQF1hr6hRz5mU8sSv39zM?=
 =?us-ascii?Q?w+ixLM4mBxP5308PPoZcSgEkOv87GVi9YdU8+lJ2mf12PEarpqT4UPOrG7hS?=
 =?us-ascii?Q?Xy1BG1rbXlnyM+F7iPpucM5yjx0UbDu1p7tvUgkLXjc97nLAnyuVooJC4Q?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:27.1132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f91f16a-4a4b-4a64-91ce-08ddb5975d9d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8289

From: Santosh Shukla <santosh.shukla@amd.com>

Local interrupts can be extended to include more LVT registers in
order to allow additional interrupt sources, like Instruction Based
Sampling (IBS).

The Extended APIC feature register indicates the number of extended
Local Vector Table(LVT) registers in the local APIC.  Currently, there
are 4 extended LVT registers available which are located at APIC
offsets (400h-530h).

The EXTLVT feature bit changes the behavior associated with reading
and writing an extended LVT register when AVIC is enabled. When the
EXTLVT and AVIC are enabled, a write to an extended LVT register
changes from a fault style #VMEXIT to a trap style #VMEXIT and a read
of an extended LVT register no longer triggers a #VMEXIT [2].

Presence of the EXTLVT feature is indicated via CPUID function
0x8000000A_EDX[27].

More details about the EXTLVT feature can be found at [1].

[1]: AMD Programmer's Manual Volume 2,
Section 16.4.5 Extended Interrupts.
https://bugzilla.kernel.org/attachment.cgi?id=306250

[2]: AMD Programmer's Manual Volume 2,
Table 15-22. Guest vAPIC Register Access Behavior.
https://bugzilla.kernel.org/attachment.cgi?id=306250

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 77a265e0672e..d2ad0dd1e8db 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -378,6 +378,7 @@
 #define X86_FEATURE_X2AVIC		(15*32+18) /* "x2avic" Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
 #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
+#define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* SVME addr check */
 #define X86_FEATURE_BUS_LOCK_THRESHOLD	(15*32+29) /* Bus lock threshold */
 #define X86_FEATURE_IDLE_HLT		(15*32+30) /* IDLE HLT intercept */
-- 
2.43.0


