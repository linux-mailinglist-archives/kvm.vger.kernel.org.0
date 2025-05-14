Return-Path: <kvm+bounces-46441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BCCAB642D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 808793BFD67
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFCE21A931;
	Wed, 14 May 2025 07:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k7Z+pmgW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079BD205AA1;
	Wed, 14 May 2025 07:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207420; cv=fail; b=muYAes8ERpkA/i2bZ7aIGly7kvz5jNU8H3/ckSKo5ebviyw95A2grSnYCe+M+4+FQXJggh/Es5sAxsky/qVlgfaPHm3n5sLt2LZoVfwH+l7Hop2G4aSVM2O63CskvphisFs+UvXJy32OJuOUSoA476/homOJKaHIR6LUfx0N+bQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207420; c=relaxed/simple;
	bh=/Wx4pGqjxX277L5vF/GoTkrVCyl5pNSUppT1Z2w0aaE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iKU3mUbXSZH1Q1MLPHXbWl08cSQo450w/r2T0iFPE6uMrUa6RLFK4qxHun+fwGkBePibBDORb3ERJuGM6lAChq6x9bUhHZdKb1mmBH4hpVQacZ3kdNHv+pRQadOdkomHPGl7KoGRPtY5a1DRTFrjV/tRzsoYIK12ZrRtRGsNI5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k7Z+pmgW; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kYy4L9lKAeLBes2Fb4zmXkrvoRM11PQUyIpZwvXWObGMupadx4tiiEax1mUfe4GUWCpbc7448eZGnWoPYZWmDPfy3AVPH1t87dodAEnHJJZH9h7r6xOl0ehj9eiMLr1uS2M8WQQF+bUn79tCuM5WdoSL6TqhKDtBjqfBYDSrgAcMgZI2ZmgAt8iHp0GNNbE0HYfq8rh4h3jZsGnngZLVRp3c42I9ikWX0rjvay0VCz+yfD1Kavwlcnh58yoMCJu0U+KmDn3DbEsMWzbwIlNAlWXkMooP5ootkUywgRKxku1NOyUGAQSHhuiAJ1T5STJqr1fKuiG+c56hp3gLertk4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvEJ8fcuNXz0nGtFYhyXV85tb2yykphAYm3tshLEWYk=;
 b=Oqx8IPD/U6eJedAHYYgaPGIovM+qMmhFLRfAIufHwreCwxk0n0gXwODmp0FL1owYtL0z+Krhe2rOB6LBQZM7+6IdsDRGlzLJLHjqMqRP07m5nvtq9aiiml+RSd57kmrcY4beWwPWjrAg95COuMQfGcJFDvwPDob3uMkUSeAASHqPqUtKhTmzspokVcSLi+EjxTJ/G/RqCaTMfHtpf2iHk6G2RYAP6UhrNC4roW7zvPXfBfUMFjRMwNVYDuI8pEeTEEebY94ri+9poHrmELFCgR+2yDHS0jv+zO4zR4FYnopndSnk4Q032eY5fl2ORX9ZOpIxMQHI72BCjBxxaDixHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvEJ8fcuNXz0nGtFYhyXV85tb2yykphAYm3tshLEWYk=;
 b=k7Z+pmgWP194lkYg6Bk07idg0G5fiS1JyGRB6Fbbbb1SKA6kcJdTBDT5cy4Kygb3Cn5X7HswQta4lHngb+NAUxpRxUtc3iP87h8m/EBAcVW+wNi8juRyFj3LSWtG3mZtm8vBoOUpKP9fMGnY486mO2fYIK91D7zLoYMzdVXLDZw=
Received: from BN0PR04CA0192.namprd04.prod.outlook.com (2603:10b6:408:e9::17)
 by CH3PR12MB7619.namprd12.prod.outlook.com (2603:10b6:610:14b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:23:35 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:408:e9:cafe::3c) by BN0PR04CA0192.outlook.office365.com
 (2603:10b6:408:e9::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.25 via Frontend Transport; Wed,
 14 May 2025 07:23:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:23:35 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:23:25 -0500
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
Subject: [RFC PATCH v6 13/32] x86/apic: Simplify bitwise operations on apic bitmap
Date: Wed, 14 May 2025 12:47:44 +0530
Message-ID: <20250514071803.209166-14-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|CH3PR12MB7619:EE_
X-MS-Office365-Filtering-Correlation-Id: 56b1877c-6a47-41a2-9dcc-08dd92b83d23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jCvitLRL8NYnEm9mnClaqMq1xZq1xEe5OQa+lz8cwcsYqg+Vi+2JBmPfYW13?=
 =?us-ascii?Q?ET18HqLkVYBCZKFMrEKwCo4Rc2QmucLJgbbsYg31xaQ7tM2QhnVaW709roKr?=
 =?us-ascii?Q?/nlH0wLBkdR5oW5/QGZ7YloNLtFZ1hrNYFjzdC7/is2ftLD0fyCLyDbt2KWB?=
 =?us-ascii?Q?oa1WpJ5eJrfNdPbioxvNZDjk76oiJeYs75rQUTA3JZq+ee5QNB6w/l7HPQgE?=
 =?us-ascii?Q?3IiBeha+jC7Z7OvM9ByimXO6Se/JmAiV/zD+eE0imRH57ymuVSnRM7xWiRN9?=
 =?us-ascii?Q?bqcBZRInbNUdPxCqzCguG0tlHREqftZ5MZXs2alMb0E8DIzM1NM/v+H6XRiw?=
 =?us-ascii?Q?qLEZ9RZYdkBfceWRb2Nzrj1ePNiFnXS2RNDcO7KnqXYlIAq+mxVMRH4ZS04Z?=
 =?us-ascii?Q?VtsysYXEOWfIUABps3497G6/giHypxBjHapSuN99Gm4jODZrSpdbDbsi8IzS?=
 =?us-ascii?Q?Nh9gTlMjd+ttOcYSChmyw3dKTIjC38HCIh2z177uecRh5gsvvojgIkdAZISv?=
 =?us-ascii?Q?3XrHRrMEG0J3XTPbPAMCsx2CQjcH1Ou6kqJQEbXwjW/qF94a2L2+NVkSAQOS?=
 =?us-ascii?Q?Hu6sFcVYGId6pmygio0rysnJMokE8b0HiXE7w11VNViCDx+MYyGgjgoBhSL8?=
 =?us-ascii?Q?oqsR/wFRrMesvq9AzYtqrUUoLPHUwl0rFaeEvhzxz+HVM6YqQLRVxCq62nG0?=
 =?us-ascii?Q?FCRegoZvDH8tgWIelolWjrVgXk53Ke5rCaObkkqh2g9TGPOE2BfjmwvD+XbX?=
 =?us-ascii?Q?HzAnCPQp04CtEjHXeXSM+ES6jBJQIETMSAG2HO2yQKEMDjQItCyTvRugb9r8?=
 =?us-ascii?Q?mL29p7JFWsy2AIr4utEeBB8Gx1w1oxAiZyyGKTjkkAFrnaI1KRuCo4QhC5Yg?=
 =?us-ascii?Q?9s5Y7CynWyStw2MArrsBv39TSUAioziMoY15fG7t62uUxtBNJ1EwwZ5JafjN?=
 =?us-ascii?Q?zSshaFUXKN8A0nNKXPV9w0pCzqDPlxWR+XQM5vdd0GIfSMspTbAk9gR6mWzp?=
 =?us-ascii?Q?X5fgkdd6hNFefRQ0U/WYgjCh3G0gPYplBokSXvEgFIb7LtfIn0iLQDbrDhIw?=
 =?us-ascii?Q?IFGWiT7r8rGEH7aTnxsmHtlVunJtmN+vujSb70Q6OmbPPJAatmHWPeJsqf/V?=
 =?us-ascii?Q?ViVLMcxLle24raZL5JHCZkmsJuUgoYw6vPUYbW+iX+dwcGs8fEc9HEu41/3N?=
 =?us-ascii?Q?EVLzCVGw9TLDS6A7y+B7JlcartnU3q0R39iH5pCZJwdYwubryjEC2XFT7PXn?=
 =?us-ascii?Q?W4gvQyPVdmvVTOafUZLNb+LHk3Gyhy/6MXrg2eQKTwBVnkVBtFYH38VA9A5T?=
 =?us-ascii?Q?Hu0egs20YacgBHZqa7wI6kDOPi8CQr066+2YocsK9ufvQ3S7r4RxCd+5Ys0Q?=
 =?us-ascii?Q?MefnrjXeKRbcPZeLr/pAe1Vz41wYNxm4kV+/imoHRXd0iIc9cIyHQd4SiUpr?=
 =?us-ascii?Q?BRftjncRxLRyV5l34uiuniawHTS62Y+vAqy7tcccvtYJnhRmntOdiB4/Rsnq?=
 =?us-ascii?Q?Vhi3DvoiXvPnqVQwRwGxVLsHRP1ldE7HkZqy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:23:35.3437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b1877c-6a47-41a2-9dcc-08dd92b83d23
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7619

Use 'regs' as a contiguous linear bitmap in  apic_{set|
clear|test}_vector() while doing bitwise operations.
This makes the code simpler by eliminating the need to
determine the offset of the 32-bit register and the vector
bit location within that register prior to performing
bitwise operations.

This change results in slight increase in generated code size for
gcc-14.2.

* Without change

apic_set_vector:
89 f8             mov    eax,edi
83 e7 1f          and    edi,0x1f
c1 e8 05          shr    eax,0x5
c1 e0 04          shl    eax,0x4
48 01 c6          add    rsi,rax
f0 48 0f ab 3e    lock bts QWORD PTR [rsi],rdi
c3                ret

* With change

apic_set_vector:

89 f8             mov    eax,edi
c1 e8 05          shr    eax,0x5
8d 04 40          lea    eax,[rax+rax*2]
c1 e0 05          shl    eax,0x5
01 f8             add    eax,edi
89 c0             mov    eax,eax
f0 48 0f ab 3e    lock bts QWORD PTR [rsi],rax

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change which is refactored from v5 into common code (apic.h).

 arch/x86/include/asm/apic.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ea43e2f4c1c8..eddcd3c31fef 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -564,19 +564,28 @@ static __always_inline void apic_set_reg64(void *regs, unsigned int reg, u64 val
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
 static inline void apic_clear_vector(unsigned int vec, void *bitmap)
 {
-	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+	clear_bit(get_vec_bit(vec), bitmap);
 }
 
 static inline void apic_set_vector(unsigned int vec, void *bitmap)
 {
-	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+	set_bit(get_vec_bit(vec), bitmap);
 }
 
 static inline int apic_test_vector(unsigned int vec, void *bitmap)
 {
-	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+	return test_bit(get_vec_bit(vec), bitmap);
 }
 
 /*
-- 
2.34.1


