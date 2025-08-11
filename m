Return-Path: <kvm+bounces-54397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 30678B20451
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 079E97AE39B
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 763C0228CA9;
	Mon, 11 Aug 2025 09:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iHcd2L0h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCC822652D;
	Mon, 11 Aug 2025 09:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905695; cv=fail; b=LafR8rlDPLmH/+zSllxOAqcurtFMEGEv+BPV2N0oiyICWqRCPbR8jgzO0uSLVPi0bpcsT3CQBgTFmrCj57IwqaAdyfGhM/3ZI8Ejl9kVOs7c00XpDbSQVoPKw8cO2JCg6+lIUoKOj03RblS9dClG7cVSMomhVwt7yYSHh5kB9P4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905695; c=relaxed/simple;
	bh=aueaM9mKf4R6E0+Px1kCeA2GIe7XCHtgiAgT/f7emRA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wr/DtFqrGhG7gfnyI5gNf8QtFlSkj0k52DhRsTjnT82DErhSQE6aOXdaMsbwWgFw0kX2r+LTbS0WL0OfzsMb0HbUhR7iA0ELMOdVCTKeuonMdZvSxMkPjJk5bRntv1OycPXK9MpCIzBcqE5FTpwPrUag/nb7xKOunWZkdcBrCss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iHcd2L0h; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B0Ug9H5XC6OvhwhRR76DCixuaAOji+ahUEOjBZ2rsH3Gr6ZNGYby3Gv/ipQL7XzaaXLJLwZT9qHEgawY6GY0mpaKOW0ocWnqqhUBNZf9t8iqYFZBwuaef+BQb9yhH7WCGccBdKiABe8ey17Yqgk/O+bV0h1z25ZJMS3C3VSMvYZp/DqQ3GB5ykaFRZU/QKmBPtcTjMMMLwil0lTa5sHZ7l6gVbzIKqe40miiy470Pd320lM58ier4pR4g6ybqtQ2LcTGNY66Sm5fhfRIV2bAkm7bG/kyX8Sc2uzq5ih6f6M96oqrhHYqBBqkM5Hg1yYev71PQnsKslisGb6jsnLvsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bU3FFKs1RBndYYCrHLCJvB4FLnudjz9msxgwvGiu/oM=;
 b=a5Ds4smR0TsxhAFDJaa8fv/MGCYgxAHi/5ZDJFreyN4eQLFLeLWLrH2WkVh+EIb4MfYU0hsKeggE961mYT9ImSI+nLkEG35MODom+DxHpPsFel7VGYlV9h9FtLLst7K1bEz4/lzLPc1UWEjEzKyPTLxqygDf1jc1WkpwMCgKq3mnTDsK/KuZnFrfkujVsMj/wwNJspCRr649JLRztnLAuMT3JPMgYNSccA+mDZ+bCM2X6iCoURhM2JBMF6r06D2braJYwGN4VJAtICeScvwNaSR3XKYYNF/7ri4aMSs/FT4ka+UxzD02+9MBpo6WSwJ5NPCrFgOUuxumqBHBH+06YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bU3FFKs1RBndYYCrHLCJvB4FLnudjz9msxgwvGiu/oM=;
 b=iHcd2L0haX1J0MHPuQ/Wg8O5np/81Va86fWKCCLF2spOVowF1n7bvoz2J2iEs9jVJ6d2OZTda0qDeuQ7JIE0zDRMuPD2F28f07SHZYKwf7ADaJ+dnnF8LjLruUWDk3O8K7qGwci5MATTlzDMY7xBs2F7pYfhyFS70rVqDvy0BM0=
Received: from CH5P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::11)
 by IA1PR12MB9529.namprd12.prod.outlook.com (2603:10b6:208:592::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Mon, 11 Aug
 2025 09:48:11 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:1ee:cafe::fa) by CH5P222CA0023.outlook.office365.com
 (2603:10b6:610:1ee::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:48:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:48:10 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:48:04 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v9 09/18] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:35 +0530
Message-ID: <20250811094444.203161-10-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|IA1PR12MB9529:EE_
X-MS-Office365-Filtering-Correlation-Id: fa5fe2ce-c853-4271-08ec-08ddd8bc2f01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8ixn/clvGxW7QJQy+eCiF0Cq+garqPO+HmvxzUe93WEb9blzHzif+YYsmHkD?=
 =?us-ascii?Q?SI5pCm4S3NtuJBEZTjTfn98kI0i6kSmosY98gBoGRwXeeZq3t8HS/bS6Anl5?=
 =?us-ascii?Q?Qqb5H+pnNQI5h6FD1jyKuSLIc9fMvvbWd4RtNXKxgJJ/rUcgtpqEWJ5fs5ry?=
 =?us-ascii?Q?ZT0BwG56i345kPRYwtNEaHDq65LPyoWq8cPwxCU3xUS64PorG/XUlECWAgF2?=
 =?us-ascii?Q?5ha2z+iJcnQ44q5dJYRTH0KpLlzdqiuuVdQ+L8KLrlZdEmly1hKb7M0SUe99?=
 =?us-ascii?Q?mjo3CTeLQTnEQwSk4w8D98DW5WY/bzmLcXX9ivBwaSVURWuqZp4/NNS8vzoL?=
 =?us-ascii?Q?SsjTbbMlhz7Q5g/Olce0/zJV2eyToUrSpZmKmoDTnOz7lnOjw6RJusnstWDy?=
 =?us-ascii?Q?M5jprVYy0udA28A9VvOq3mC1E7hUwhBLgvF5J6jMWogBVQVgzCbjAuqeRGpl?=
 =?us-ascii?Q?1HWkFyKMkzVcKKNDzzc1KGouCVxJhC5oGH+dmzt/Q23hSiyaOU0WQmDtNH/U?=
 =?us-ascii?Q?PMPQJK3di/3HnYCDgSquUX+KupHSkTRSAReNPHBSJfbU9fgE6j4pGH/ErZhb?=
 =?us-ascii?Q?8FQt3+EV893Tym3O5rd2LeYrXiEG60oxANEBuL7gA5LIxjOaGzxh/GcpLiC0?=
 =?us-ascii?Q?+RuAOx54iNkDBfxvc7yOt9kW7eS5RgGJPfLGOGMo4uCoL/etgAQUFZ8K6Ujn?=
 =?us-ascii?Q?D2LX790VrbbuujKDWSD6ypZyQwLYMw3GOcfxe20chnJeJ4vcqedf8kH7K7Hl?=
 =?us-ascii?Q?EVVfGthgWk5TpfwFyNofnTiGRNCbJDGA7/xTlsDZbrvw2FR7/tn9s2MD+xub?=
 =?us-ascii?Q?If30mpHBga6gHHLDKgF5rrzdpCufXf9hF9YLtXjfmSO7mIQCQAJLGEyqkipP?=
 =?us-ascii?Q?hq9/7+w7DSPd90vqLcEXXg3jvxmmf8qXsfndhzuY2LWepMBvkwyR7pt4fMFA?=
 =?us-ascii?Q?F2rysB4c0xyOFtc4nGeI+hR4YYvxDnBS5X3V6LnjwDCwSwt/MZk5aYzDh0TX?=
 =?us-ascii?Q?uI+suVzMaB4HW5sJoqF6xo6nOVzTPa4alMf/XEWXS/9rjSN7ZCEQA50nhSZa?=
 =?us-ascii?Q?pLHfvzD6FRAjQfpLCI+ibnVmTu306Qe+iO69vRphLe3TufnrfVHzXv/k2MWM?=
 =?us-ascii?Q?3LtzOz0JIXlF4u3ZJS25abjA7uF+80n2vyxR6+a4/JewuS2hYFt45637cxmJ?=
 =?us-ascii?Q?GsFneVRhInwV6TK4wcXI29AvR2eqToZPSUK8uabZvQJnCR6ITS6Uf8MmZlX0?=
 =?us-ascii?Q?/49T3SKq+w2/Y1RB6mYfvU1H30S/RpDbkTUCIU0+wtRm3xPY644zb0kQGuXH?=
 =?us-ascii?Q?9k0e+MhoF2mS7zfKpwVYh6v+FE5ilbEyuBt6gJLGR/CZnAQOXbw5IcFatf88?=
 =?us-ascii?Q?GHbtgsDe/6YeGQD5GQUZL/zEq4tKvpOXnWVpmjRPgTRdekqOIyQc7opWrAe3?=
 =?us-ascii?Q?fNNy7+K4csJ0gn6kSyqYsAWQ66FvqUUE6S59sffH47sv+rSjufM2CRHI5/F+?=
 =?us-ascii?Q?h2ISxlYPVcET50jVjGDoaRCzWQxaapz/X/Nj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:48:10.9937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa5fe2ce-c853-4271-08ec-08ddd8bc2f01
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9529

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires VGIF to be configured in VMSA. Configure
for secondary CPUs (the configuration for boot CPU is done by
the hypervisor).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.

 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 3f64ed6bd1e6..e341d6239326 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -951,6 +951,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip, unsigned
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


