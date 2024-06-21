Return-Path: <kvm+bounces-20266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 593BB9125D3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:47:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CA6D1C2133D
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82EEB17837C;
	Fri, 21 Jun 2024 12:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lIztTgol"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F88176ADA;
	Fri, 21 Jun 2024 12:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973641; cv=fail; b=VjYIndNxH1Vn3NlS+lz0+7sHS+FdLVWuYGiHqSkspih2WfarAxJQfg9onouaTzGuz4TwLxbTgXIrNESN4Q33UioGemljw+pV5iMETnLZXAI25AGrKcQmiwhREHibLYqg4BZUCBY7+Mc6O8axn3uPhOYgmJBZYTi+UAcKO5MEjXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973641; c=relaxed/simple;
	bh=BAQiUc8hjxleJxuGqdwU4sZuRRI3hj0APKiO0k8i6TM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d9Zz2Ij9LZzVvgRSQyudMVi6ezlQXcUyalwCKUAOwvJKoSuDV0qiJlp7uv1PNN4bZb1nTAJLs8FGYTx0PkANh1eEcTRBf4h0ap+KpPwAheXKn49EpQ2P/zEYPYE8pgd1LK24BQgEOJdpe0UqwAjtiWhW0D8g9rXPNteVJNma2Ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lIztTgol; arc=fail smtp.client-ip=40.107.237.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CovGeAbyZVJXONDkJ1Kc5LUHbxTRYyNJF5qwh2wkhagXaE1jgqeKYYFDrcuaufZKDuG4PlsYzP80HgyfR7T6+FoCGQ6ab4RN2Ee30A2nygi8cL9fXe9qb/nIsalxLTgWjyQ0JTS11jGe+wvyc3dMTzplAka4RgyjjfM2cCtKv782Y4j952QxPW8wP9kIpOiqaxykkbyXSaAQ4JP/WYc8PZUHD2mGSatlfYLfqXtWiUUDi6Sgo5kLJb2mU0XX2cqPvZLPQpsqCQ+Aq4ebfb759m0UBO1qqcAQ9QXnaoMxvwFDET+NNOUql87G7nAbhufI856j6javC9oZrCVJbD399g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1UkiuGo1mloJRmOmboZB3VU/DZ+UPBdDSoCvRceymI=;
 b=mvKZx8Lmn968KPqxZ49Oy4iIVxEnC4G4dGh9SUnM8tksNPbyLPJL55MR+EOKWDhOQ2Vq2d0eWOHzMGmA4ecJ30jucOrtbndQLCW37JVYCajkcWq2N81v4fTdTxGexyLZB08GS0PR4QSElVVDgXpDJ1D4VkGyTL8VOejRfbnvua6zI0o+BP6PIlbBuo7A6BrsDbUhcZJqjkGWRlwdn0FYIwGGtMpYFBq1K0pXug2opdsmtDYg3jRioyBfwm0TK7zaAgxNeScOy3sKHXIPVz0pLK0Lc8v8WbGeJ3kAU4QnVSbVx09p2o9VMJmuPsvP/4ZzXFGRcgJKtvUMEXsE3S9oUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1UkiuGo1mloJRmOmboZB3VU/DZ+UPBdDSoCvRceymI=;
 b=lIztTgolw36AdO6jFhu3YLfHwdkVs00hzGZrvlcVHtW2WEtb4GFIpcfj/v/s3+VlzOHnfNo0YcPfFVMJqBKyM54RcD9NCGwOiVy8rBEsq0rmN5QF+f+KaO4GfNoPvVNgDqrtlXuqCGMdbv9VW6KGoMcn3eWpMgQoF/gkT9foMe4=
Received: from DS7PR05CA0006.namprd05.prod.outlook.com (2603:10b6:5:3b9::11)
 by CY8PR12MB8363.namprd12.prod.outlook.com (2603:10b6:930:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Fri, 21 Jun
 2024 12:40:35 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:5:3b9:cafe::ab) by DS7PR05CA0006.outlook.office365.com
 (2603:10b6:5:3b9::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:34 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:30 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 19/24] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Fri, 21 Jun 2024 18:08:58 +0530
Message-ID: <20240621123903.2411843-20-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|CY8PR12MB8363:EE_
X-MS-Office365-Filtering-Correlation-Id: 484ede7a-b5a2-4db3-0157-08dc91ef58a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|82310400023|36860700010|376011|7416011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?olapYLXME1sm5hb3srjcsFmESS++BhPCT9EYIhHcS0IRw3NB7ZmIiwn+IqL7?=
 =?us-ascii?Q?uN6LXRBIflBG2cDleEroO7lsgcmXhoKhbjBzPL7cOzfJdVPQOF9lRYl7zWl+?=
 =?us-ascii?Q?QdLw93oxsMD1OhVyfAYhA5YblXKIssIYyPb4aEWaV/wiWTnSlXbsvy+uxzkT?=
 =?us-ascii?Q?VjtMTKKFUbs5JxHtxMsgKDjdOKu8AnImM+ixSagSFluvFzx5neS2lg+Zecsn?=
 =?us-ascii?Q?op18jwdlwdqGrVYJOQ80uXfAH2C1qP7/57pkLBfgiOc+xIm41ayEf1PKh/hL?=
 =?us-ascii?Q?iZhsHx7kR1ucOJOWpaCjDFqbmZyyA6aKCi7lv1iAnRR/CHVrlpjkDURe4I0V?=
 =?us-ascii?Q?tzzD4K/KHnvlvcqFrnEq93MGQwsnqO7MUbx7ussEe6/00mTpRTcPE9rQEXFw?=
 =?us-ascii?Q?RUj8Q2sJqSE0lzc1M+nX4aaQirpKAsX355oZ5gQj93q0O1idzo8vwPgDOghk?=
 =?us-ascii?Q?ulV1WIUTBzo+0aIAUUw0WfzJG/dYgk1T4XQEdyen++efVBAN1D6Ga6wnR4Mt?=
 =?us-ascii?Q?KRAUUGdeYLXPvH0fIFmUcGErrdKjytCRUlowOaDqI4c9qEL3Eot8Q/4yz3Im?=
 =?us-ascii?Q?NWwDrMKH5ojWLu4UwOZ7ilx/mRgTYSipcY6/p45M+N2leCcDwlLOsE0PYAWG?=
 =?us-ascii?Q?p/VIoOHh+8R5MM5NvBxUbjlx7iokgSMzQmrBTOBo8USkqygFdA5HfWKsYp9Z?=
 =?us-ascii?Q?uVU7RXLbvI+64pWZbhXIdSq4cfXDQrqAY2rc41EcuHo6E5u4Fgimg3rOkQSa?=
 =?us-ascii?Q?g6zqa1bVV8i8oo3i6nq54WYdi2pw7wDVdS8n9VEb87Uj0gAtKDv3qHIxnQTA?=
 =?us-ascii?Q?2jA7bVo9I21Nq6Wd1rPpysZHDE9KCVWOXhFalX9oFwB8HwcKfa+/EOYgd2Hp?=
 =?us-ascii?Q?mioTilvzm39z7YSp5j/PL+gdnl1PTLBqA2Yc3tYkmhAIMGZWQajBORPdr4r5?=
 =?us-ascii?Q?BRDQgKFmco0GvlJAWktRSObtYHNKrwh12wyCNsZpMjgoM+iR4NpPlJx6reCa?=
 =?us-ascii?Q?LBjFo8Pnhk9+5F7Hm5BUD7ZDopiERQRbXpdLIOWqWNyvntKw0lWRoGuukqNF?=
 =?us-ascii?Q?q5t+pfZtDmc4s7RXkvRdEkv4vdT0KhzPRKhVpIjPBoZZQV6oLYjV6qxvH6+D?=
 =?us-ascii?Q?SReKSp4394uuE3kZX2Vnbnsag5t/7jWlrP3a2WJyId634yy620aOv/SUmZSY?=
 =?us-ascii?Q?XjQMjBmIl/B+Wk8pTBnphSuo0t5Qbs/XUueHMDli2tt7pikO4GFEJ7wBsauE?=
 =?us-ascii?Q?Jtqp4VPOCt3DqXCNWmyb1o/S08Cng7lGT0H0sA+TMpqNCNtlsaBBWlZOO2Xp?=
 =?us-ascii?Q?n54OdswAovQhdYSS6+LfQ6QJE0U5wHAKnmNLDC7D/gBzHH5LkYVHwootBRu6?=
 =?us-ascii?Q?PLH9Q+pMcF2Wde8G08TK5Q93bbmIsQnJMHs6tYJUU1NBLJ5sbw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(82310400023)(36860700010)(376011)(7416011)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:34.9381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 484ede7a-b5a2-4db3-0157-08dc91ef58a7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8363

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
 arch/x86/coco/sev/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 7aed6819930b..fda40794317e 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1333,6 +1333,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ES_OK;
 	}
 
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


