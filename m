Return-Path: <kvm+bounces-18488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7698D5985
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC28E1F25014
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A81884DEC;
	Fri, 31 May 2024 04:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RSci858z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB18582D75;
	Fri, 31 May 2024 04:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130089; cv=fail; b=YV5Iwss8GazGMnd5xCF8p6DQ+pIAA0MhU2Du1zV3tbKsbEShvJ5RP1iy8AgRdja2xWmFmZu1gCTNpkDtrmGpQ8zpLB14Z/Vjw/7T04NOKdzwSlzs4n0AtyP5SSjn5GZIZhKu6wAW4WAyzWO9wkZi11aBXkJQ1m1O9lJ7+R3KkHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130089; c=relaxed/simple;
	bh=KsIMJLJ6CQpyeDM/RXcWA6TadtVbGCuait48LQRKyZ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m6Tff/XcbWWFxrDOOMfVHD00dwEF1YJfiam49sfwRGkbTO0+RQUb3P6AtFJavfZyfJqYTwQnzt7YUkz54kzpPjg+oJX+8Om++JjYwBW02dGkPowoy9x4D+CZK26+HrYuALk6+/Nt+KACbqtx2QVbaVN1dQ8fUatG+kdFTFXj4mI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RSci858z; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikIfu/R/IcMYO5A6qlHcZteYUq63yxendsAROh4u4xyg1IZYnrf7LtOzNQ58+7aO7Nj5GzaP9u5AaMPD4yKngZqkOX3BAO1RZ2w8kpqrl6k0XYfwOcvCJ+7/AhSCLOPYzq8S7cqdJXn0zi0+IdHtqzCIly42VGxOXaXWSYUGitpzsK7O4qc0eqZsVbYhh/uXZPg3YfC6wwTfV0ax+AWzgju035MMqFou9WFYGBK/ecF7204Mk2NWqH8ZgI3yRb/ZpFr6CIE6nq4cqIN3vau3KdLBhhgEax8piY3tKGr7qhLpz/NMD8vr7H6A+ibMkiEsNpp2wWN4o+jbyQJkZQHLZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUqWOlsFxSY/Iq1jJTOUQHjey9t23YQnLfGpxy2azLQ=;
 b=OT3ofulVWMOO0ECB9/At+VdFp2n3MdVh736Nm/f/voUpFsFqFKgk+ectV5USoNQ0bnbEYPQwkGJtvc/US2VS/ye+8jM+R4evBXVfE0rtMJrIV3QErt+OFsRzjXpGm8sDNPDYe0VCA9ykfsiDM3v4bA29Jjox0rw/9Blfn4yTQru1B5oPD5NQZlgL2Oq2fx26W4bSyud0KABaqz3D39d7fRQz8x8uxP6VtXgF1JoqHyDNXW+GvARt1Enl9JP6zb2jbvWyNGaX+HAmRYyVnyHz38mHJlaNZEy35BAIt4S4UeFJPT7/ks2z2jL142HcwDHXPYexyEgAMk0l7HjNDy+z7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUqWOlsFxSY/Iq1jJTOUQHjey9t23YQnLfGpxy2azLQ=;
 b=RSci858zlSeqrhs6UBu0qdjckzMqrsbM4ny2+EES0JQTiFxtx6m9TTFOjMNtH1q5a/2BMtSDeHlm4Mw2hI/5uVmbI8MYxP/SmUMAr9mKn7/Mbk4eRBnCTnt9HkXolNX98Kc/l2UBWYeBy9fxGq88ls9aesgz2IUKG6fJOH5bbVI=
Received: from DM6PR17CA0036.namprd17.prod.outlook.com (2603:10b6:5:1b3::49)
 by SJ0PR12MB7035.namprd12.prod.outlook.com (2603:10b6:a03:47c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 31 May
 2024 04:34:43 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:5:1b3:cafe::c0) by DM6PR17CA0036.outlook.office365.com
 (2603:10b6:5:1b3::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Fri, 31 May 2024 04:34:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:34:43 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:34:39 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 19/24] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Fri, 31 May 2024 10:00:33 +0530
Message-ID: <20240531043038.3370793-20-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|SJ0PR12MB7035:EE_
X-MS-Office365-Filtering-Correlation-Id: 8609ff7f-fb54-45fb-bb36-08dc812afe65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C2mmlB6iQoYkg6qptsHFkqh42fHGGQde9GUg8OkJBS51jt3kjzgKEy9qFWmo?=
 =?us-ascii?Q?1QvepYzdN5LMxlPNdeB5usvNElMhU93GEa2BquDDUA03tJy2JXr5kTlB7OVg?=
 =?us-ascii?Q?o2lQEl/wAoRecWmgggAFaP7XlDyAntA33oqYkTHVR6DJeTBNJBWXr72g+FGH?=
 =?us-ascii?Q?2ePMSpmJgbnIV0+80IrMywSGX3MlfeTl4Q4ktXi+Q4XavIxqb4g+l/nYzu5F?=
 =?us-ascii?Q?bjW1pxHpcpsrd9U+JjhMerEG7pwwtXHLK6gQ4xJMRLcVz7XtKy1XH3wy6a9Y?=
 =?us-ascii?Q?1ggu+bdNqdBWtjMNAicTwwxkMPPa6K2L5B5SC8tAKc/5HPvAaxzsMgSQON5W?=
 =?us-ascii?Q?X2ocM2wBt8Wyq0jVdJl1pRP7o7Vj+2qcGp78gkNeuiDdubkSWqAU64DjtiXf?=
 =?us-ascii?Q?xxdfzIOZFUlcR42CIVi4eS0cWvFp5oKS+piqJP96wApLu20gBE4lrXEq1pyf?=
 =?us-ascii?Q?t0AapQCJp0PLMP1aqY+hKd+Z+2JUQ/4NH7TL0hJc9KwJTiH3Xj1GCoqWdov8?=
 =?us-ascii?Q?GSCA/Ks2NqFLoLtocugP2I0ha4834Q1SJaNegHCW41yP3GK2PPqiZOP6qto7?=
 =?us-ascii?Q?+yrEl3eTpgx0H5oQb8ybs3jYDC6i/2pZeC7sHqxarRxFn97AY7ELmgzjCeEm?=
 =?us-ascii?Q?rPizI/bT8KaHKpmPwgGV3NmBbVP8ty937GiI8NxuLJ2tCdunz5NZC7Vt2V0l?=
 =?us-ascii?Q?9gM3gtJaMQSLRqRTU5WkBK8yTpWrJncLDyLjKjF5Aq4K4fVFOZ9kgUMk//bj?=
 =?us-ascii?Q?vRxvxlHyQlFqkgWOsG5ayUHR7Wi3xa/QDFbpMmIMfRDcVTg+7aLc3HBUk4uD?=
 =?us-ascii?Q?UBJ8jtKnfJnWH2cpDfTjF33ZAoLmKktXIdNvH29p+WfFUtDmzwftbHULqFqv?=
 =?us-ascii?Q?vfPsS2Bsm+Xu+ZCgnNinBmxWRuYYrdrePXJS10wJRBrM3DEMzX5zYHgEXqFZ?=
 =?us-ascii?Q?pTqj0Pe3jgUbR0I3C4Ddfb3FtKJ4c6tFz4YtSxBU2FE42QNo7SmLqjSRdI9o?=
 =?us-ascii?Q?DW9hh5NfaSpP0KhJl7hudhTq8KKcByn7yaJRw3plqqW+Pl3jlSbMQThkGijK?=
 =?us-ascii?Q?U0NteSG3QzF3naNow4Zn8bZBCLED0yP1JyGP5I6BfJ3Hx8MYPn+r6OgoLxMW?=
 =?us-ascii?Q?s6Y8rURbonSx5Kd73U1bfs36w8UOlINVtemP+5YwNq0htmSbOyFVNgPFn2nw?=
 =?us-ascii?Q?MzhyZOSi8BeW/d/8eNWki1ufPDGXo3qRAk73XgiJg66N4sT6dCbjxscE3AHq?=
 =?us-ascii?Q?q1uSbTd+Avf7hsszevd81Ji6HSxvdI3SIv+t41iJ85YAVN+dNzJ8M1csFbv6?=
 =?us-ascii?Q?wKqx9nTnMI1Sv5PkBmOhGZhiQeVjcDoh/B91C5vhVOOTnd2CcQ5dpxgJP8zX?=
 =?us-ascii?Q?C9ESRd0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:34:43.5519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8609ff7f-fb54-45fb-bb36-08dc812afe65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7035

Secure TSC enabled guests should not write MSR_IA32_TSC(10H) register
as the subsequent TSC value reads are undefined. MSR_IA32_TSC related
accesses should not exit to the hypervisor for such guests.

Accesses to MSR_IA32_TSC needs special handling in the #VC handler for
the guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be
ignored, and reads of MSR_IA32_TSC should return the result of the
RDTSC instruction.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/sev.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index b4458af92a73..1f6a8d85c816 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1191,6 +1191,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	/* Is it a WRMSR? */
 	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
 
+	/*
+	 * TSC related accesses should not exit to the hypervisor when a
+	 * guest is executing with SecureTSC enabled, so special handling
+	 * is required for accesses of MSR_IA32_TSC:
+	 *
+	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
+	 *         of the TSC to return undefined values, so ignore all
+	 *         writes.
+	 * Reads:  Reads of MSR_IA32_TSC should return the current TSC
+	 *         value, use the value returned by RDTSC.
+	 */
+	if (regs->cx == MSR_IA32_TSC && cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
+		u64 tsc;
+
+		if (exit_info_1)
+			return ES_OK;
+
+		tsc = rdtsc();
+		regs->ax = UINT_MAX & tsc;
+		regs->dx = UINT_MAX & (tsc >> 32);
+
+		return ES_OK;
+	}
+
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (exit_info_1) {
 		ghcb_set_rax(ghcb, regs->ax);
-- 
2.34.1


