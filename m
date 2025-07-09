Return-Path: <kvm+bounces-51850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B632AFDE48
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA37916D3CC
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A87920C494;
	Wed,  9 Jul 2025 03:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dzX0oLxk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7B82080C8;
	Wed,  9 Jul 2025 03:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032286; cv=fail; b=Ko6p+6g87jE7hRRaXPnQ+N6VOuuS5Ber8jk6HJWVnoemG4+X90gQ3Y9+Av2gbT/Z3BSZChPqASboCWMyxCYULkU+qrD/1joEgyManbGbAQQIpcdASXkLe3GWWxCbhoHehu1mLZxy3oEKBmpAPjBqG+9CrBHDAyqK2v6uAcrARMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032286; c=relaxed/simple;
	bh=Wn6H91KxFL4ccrLUIRWrAM/VBMK9EwltD8KmUIJtxLE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YEhTd+3lMkDBmm/877TcUBmp5Xtf9zvzzTIXIdkRTVdCrOoiaQoWOh3VCdhRIS+2NN4cwwA+9yZijGgnBI2F+Bk+xBo9sU8SVbZ4ITmp68080QqvZCmIPRqmIt8vjIuh5xQwR+YT7wQ6ta1Br+CSH4+o3bsjWvbEvzebw/8038Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dzX0oLxk; arc=fail smtp.client-ip=40.107.92.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OP+uJoNh9zokdJtfb3TblADm3ELyoMK+MGMpuiWUg0rp1GMWeMLpGdisy5AzCbMnvPHRazLhYp+niJmCgWsEBo7WwIDiAznay1GCH0qW1EFyMwwTGNxWTgxhXmkbX6PE2mV+0l2vp0RYRug4k4g1s9UxYDtmRlelyotBF0DjtIbi8y8KlLJOJlldbRxWCz+7LwC1GMdYNlkkZwwtYFE+3mrDJBH9y0JY9iwwbCzTQmCY4JlgR5T1Yq2i6/8XQFLFgMTxdGN8Xgb42RG6IXQHaDlJq6x0FALjGQnZYXWL2Of9LKuID5ta3mx2iwZLjW97nsqKZ5rBz3P0NcSPefQ9Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVHCI35Ho7wrHIWfuPBoxFMi3yV438LtT9GK4XNsXt8=;
 b=TYCNceHJO4VGCQ8xEAoUtpmU+z5J3IxL+kUJR9lH8+wP79q8dRbIfU/CLbVdOzrtlBSIGxPDk54TwjWW3e3JFFNHgptfdzQHpM9iYrzCDPyrccPn8H1S5cVKsVN4NTszuNjNTL2nK8BfEyfflK49pgmkra03Lbvms+bTih/Wg6Et992YFnZqE21IH/Y1i6M9tsbQcpNZPXHIHp4VGzlh654zvq45Sm2QuUW1DfA3e0xMBaqC9IK1n/dOFVBkOTAxGpT5FlW6Y9qKP69462d3dKO3huMwB1vgeHyz8bn4ipqIXmvmKY6+QBAwdVYHssKyYJkNwfbzUhqzhP+F9tQm2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVHCI35Ho7wrHIWfuPBoxFMi3yV438LtT9GK4XNsXt8=;
 b=dzX0oLxkIOpekmlQP9VfA2Wb7+FM1L+HEpVObGnfeJtjIYOH3eTNWYfER3kNb60Sg6HRqHRwHCu+Z6flaJqI13WAgs+z7WyQ+CE7/zC04gqOcTfDxa6JSu1rR/wUwlkiujahCQttwhKR5y82oGJSGAkOmWjrgLE+WkC/SU5OVkM=
Received: from BN9PR03CA0397.namprd03.prod.outlook.com (2603:10b6:408:111::12)
 by PH8PR12MB7350.namprd12.prod.outlook.com (2603:10b6:510:216::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:37:59 +0000
Received: from BL6PEPF0001AB50.namprd04.prod.outlook.com
 (2603:10b6:408:111:cafe::a3) by BN9PR03CA0397.outlook.office365.com
 (2603:10b6:408:111::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:37:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB50.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:37:58 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:37:50 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 16/35] x86/apic: Simplify bitwise operations on APIC bitmap
Date: Wed, 9 Jul 2025 09:02:23 +0530
Message-ID: <20250709033242.267892-17-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB50:EE_|PH8PR12MB7350:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f0592f7-cce9-4e59-8d57-08ddbe99ff93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bcHX8YkapDsiOValpsJ5Xcq01L1bGvNhju4fn6BibRPxRWr4pnJIO+Z+PlsS?=
 =?us-ascii?Q?mpc6nfBY+3TElAZd6aI9Pdrapq6JNNSvbrIGCZdNR6XaF+NOv7Vw6ispw2Va?=
 =?us-ascii?Q?mTldofJf9GisrLSjPQlj7UuV0z+ISLhFP9HbAUDeYT31szfnJ0/hcIgmd4Jy?=
 =?us-ascii?Q?KpEz3zxndSh3sYnAlJevHxYhD9u8B5TGZz6NapvkyEVk6SIXCns7s5PASoVj?=
 =?us-ascii?Q?Hr9gJaF/HBPR66V6cmvJuE5CM6TWFnwQ/nzsQp6/8IT8FHuvtrPU4/11jne/?=
 =?us-ascii?Q?j9yov1jcW8si5w1gBaTyQ3auQuR70lG4CTgWACW30IJYiIj3tY6iIfX1Rf9j?=
 =?us-ascii?Q?SChhD23mHEPxSUr3f6M+XeG5+wNKxSueZsiXLVE2nLifyoMYsU96o9iHVkAR?=
 =?us-ascii?Q?Q3kLcTKU5+xoUJck64U7LGSVK5DS0NmLce4UmA4QyREPNLgOY93YbXmg5b7H?=
 =?us-ascii?Q?1mqaDBxXkQRP3a62XPwi0RZiqvQYIxEO2HDxOJ9MxlfD8X8/CyBKOdMAIP3t?=
 =?us-ascii?Q?fYAuZPCiv0RcOQau8AU+gd7JTv/6q9oOnT8xJLlRxbxnOwhsI9fp3Aixq7hT?=
 =?us-ascii?Q?0m6ODLm9cf3ABAtU88+sdu++mW9joxZp3tgUUw0zZt3CSr0K+VXYydDftTc+?=
 =?us-ascii?Q?vkcumqmDLOdn392LxfMXT8oz6QHwzT0gGDZvELBvGEMT0z9NyVi+bPwSPmc6?=
 =?us-ascii?Q?RaTfiV18GoTeMZP67x8RxjUUUkU4Au2O7CPqdeDkg6DfIzKxmeMf/5Ql7APd?=
 =?us-ascii?Q?nMk1xkBa4DxLsCOASzzCXJXqWyFd8vDrFe/PdwXm1olSpXb4kdrP3GuleH6O?=
 =?us-ascii?Q?+7QVm+4z3hyncuSQx+Buav1nRToMXWQZYjTY3DrlYOMtZXUEpY7ptCibxPri?=
 =?us-ascii?Q?LlGLTUh0mtuJfxijj0/ytpyvN47b0/9nDjm8xlPchJ4BcKfinrlHqOK5CxQ1?=
 =?us-ascii?Q?xl8yyA3rjK/YzIHrXUSpwqQ08h9B0Go5Y7CnNUrlL0hBOo0R976FHx7yjRmR?=
 =?us-ascii?Q?uZOMSTNEjnm0lJ4gg0G7GrnCRVEaog6eQV/OQvq5ATy1jALsHLEGEnMhHB7D?=
 =?us-ascii?Q?d5ALvUwZoRzFDtZw2zbAGA07xrsf94MncA/9o0phhvEwB4SXslWzv6uAyfjG?=
 =?us-ascii?Q?Q0jsnyDE52r6WxpprGqrW3JFW2xxDWU8EkPb3ByFVhDSdbvYONf9Ju7fcRGg?=
 =?us-ascii?Q?NCsa/KGc8BR4Oua3qrRW5W3YrzRBimXdXjq+20rDTRq/rbbbv5MuoVZX5l1J?=
 =?us-ascii?Q?aga5EZzKBp/XqLLCPW9a/DCjVcYqcPHs68PPOJae0LeAmeGiD/hYR8rSiWH2?=
 =?us-ascii?Q?TNJ95dRsq5BLPKXGlEZGmnq64wEjepqv0IM8wEXHSLaEQDiZSCl9Li/+whvK?=
 =?us-ascii?Q?rUbHYCAxpR/m0J6Csz8ROUyI/Wfst+L/5RanExwIcoQuftUa9FXNgiamDPkh?=
 =?us-ascii?Q?XLmytbMHjvsGVMK710K5WyTVCEVIEfgQsfy0LNKva0Yh6zrTiY90Igd9OKTF?=
 =?us-ascii?Q?xPR/G6a2Yf2fWQhhSkxwA80qLErQ7w78VEbo?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:37:58.3180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0592f7-cce9-4e59-8d57-08ddbe99ff93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB50.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7350

Use 'regs' as a contiguous linear bitmap for bitwise operations in
apic_{set|clear|test}_vector(). This makes the code simpler by eliminating
the need to determine the offset of the 32-bit register and the vector bit
location within that register prior to performing bitwise operations.

This change results in slight increase in generated code size for
gcc-14.2.

- Without change

apic_set_vector:

89 f8             mov    %edi,%eax
83 e7 1f          and    $0x1f,%edi
c1 e8 05          shr    $0x5,%eax
c1 e0 04          shl    $0x4,%eax
48 01 c6          add    %rax,%rsi
f0 48 0f ab 3e    lock bts %rdi,(%rsi)
c3                ret

- With change

apic_set_vector:

89 f8             mov    %edi,%eax
c1 e8 05          shr    $0x5,%eax
8d 04 40          lea    (%rax,%rax,2),%eax
c1 e0 05          shl    $0x5,%eax
01 f8             add    %edi,%eax
89 c0             mov    %eax,%eax
f0 48 0f ab 3e    lock bts %rax,(%rsi)
c3                ret

But, lapic.o text size (bytes) decreases with this change:

Obj        Old-size      New-size

lapic.o    28832         28768

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Commit log update.

 arch/x86/include/asm/apic.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b7cbe9ba363e..f91d23757375 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -564,19 +564,28 @@ static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
 	ap->regs64[reg / 8] = val;
 }
 
+static inline unsigned int get_vec_bit(unsigned int vec)
+{
+	/*
+	 * The registers are 32-bit wide and 16-byte aligned.
+	 * Compensate for the resulting bit number spacing.
+	 */
+	return vec + 96 * (vec / 32);
+}
+
 static inline void apic_clear_vector(int vec, void *bitmap)
 {
-	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+	clear_bit(get_vec_bit(vec), bitmap);
 }
 
 static inline void apic_set_vector(int vec, void *bitmap)
 {
-	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+	set_bit(get_vec_bit(vec), bitmap);
 }
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
-	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+	return test_bit(get_vec_bit(vec), bitmap);
 }
 
 /*
-- 
2.34.1


