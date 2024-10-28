Return-Path: <kvm+bounces-29805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A45669B2467
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0ABBAB21D32
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A481922CB;
	Mon, 28 Oct 2024 05:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="48XA1GLJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8A31917E4;
	Mon, 28 Oct 2024 05:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093731; cv=fail; b=uNMkvl9RajD5SQarfpXu3jebK7BC8T21UdSFiNUY1gJrjAYLDlo3I/bR2tROY/YsQAjQBVCN9zoExQC2StNlVRyYtomiQAHNP/mT0s4Qp8AqWF33HLElkKasMowF2OZ5lb2XSAVqxCUSYfsfx1fONvU6yOZSX+GgOSzr1y2Xmgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093731; c=relaxed/simple;
	bh=AEr5Ri+xaiOZYfOIJW+1r5+kemaLI6PLPTJcqjdAAIQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jvxxPVvI/Y/F/aAx/C8kYj5RvioQh4oZ/nA8kJyhWs7icFHGseXd4vr7AsVCTrkqqFZxKdW844EUj0X/E2+VST7ND9JiXj8zV3bMRtLw46eH/DbhftNhn/q04GULfX7OjUVwPfS9rz2N0OJmsciJW2zwp7lNMSRnoUNDYrx7gb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=48XA1GLJ; arc=fail smtp.client-ip=40.107.92.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JSnrr8UJY2X0aHwJckBaxXqeF/zq6bt/uTp25/TejdLEJOUksjqN3nkdck0xpQxsmHLEYKVP3pSNJWqAT2+9x0NaOVOqNJZXWw5fGSzJuT1sIrmq3UfraKW1dDmIV9i9xI966TgYH7v8YfUpkqxw/dTaHLIeP99PW3DnnlicCglruNhdulfy+FaPuFZBeYm6eEzBgTu+MrbDIcCN+3P65FE9ebSlboyfwEn31yoNYdEJDLlWRS6Mrh10a3T5yZl3KN8NYlHDI3G3vfAqirHwaca3qse82c+5yoaa9gFoayqDcV1nA8CsRdsbYMnCdXARUffnPM1Mef9u/z8YxvYLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QH4/9vcAmKmjNGsFX/8gyVKe4ilMnHswTQTnRodhqkQ=;
 b=lqyXzay7JPDPsi6JZQTp7u9aDRAdCK/Feh5H3BhXCDbWq2SFKh3kxFdQ7sLo+z4a5VvndhlAmcxUKM51mk8DA7zNfQa1BgkGVgmtoIye7SNrMhCiJ3sFnaYM93FTuWTA2I0eD2SXJXoAG1On/E6S7lxbXBmuefXs6yKX6+5radTTdAtfObhnSbPfx3oSfY3W8xUMSVAYuDgq8o5GxIYLgMrO7iedZBL4P8C6WfzQYf3Sb7If26qjE0JMM6grOXdsBtINJkhFzUZQJ2Zq2guB0A9FD7XB8cHCmOZBgnLquAcjB+RePx7WxY/vi28MIpTGk0pjEdgwTBkmunenYb+IPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QH4/9vcAmKmjNGsFX/8gyVKe4ilMnHswTQTnRodhqkQ=;
 b=48XA1GLJAboEfdOyNwD5H32MAwVIRAq1NvTaKGrNxGeW0eY06UNwKxoyikT7yXPVMSHTOLdoBZAW0hUjMLIEkuRSt0hsnnTUeUzX3fQQmfuhn03mwMiuPBnReLcfnKh/Aqp875VTx7q86nvMyvmRNYC/SjPzC9pVYh+9po6HTTM=
Received: from BN9P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::18)
 by MW6PR12MB7072.namprd12.prod.outlook.com (2603:10b6:303:238::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Mon, 28 Oct
 2024 05:35:24 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:408:10c:cafe::6f) by BN9P222CA0013.outlook.office365.com
 (2603:10b6:408:10c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:23 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:19 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 04/13] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Mon, 28 Oct 2024 11:04:22 +0530
Message-ID: <20241028053431.3439593-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|MW6PR12MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: ebe52921-5914-4835-9b96-08dcf7125216
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0IySgieLjVSyekFG4LwTehUqAhqV+SMmcSZH/bE0D5laKOXR2aYp8p8OYzaS?=
 =?us-ascii?Q?jh+O8dqyIl0Gekg0PmCiHACnI3iz2K+IDGsryvhZ7Waxm+weLDs0pHfhd01T?=
 =?us-ascii?Q?FuK0P5NZ2RftGp2+Qbm3re4/JEakke4T63OTUdAaBNqPv/nObNrbUVyDSfPy?=
 =?us-ascii?Q?5u/dH8OkyDqG91wGxYsuitoqpAV6smeuRxbWma7Ws7kmsH+nyHDZG1jyR6b/?=
 =?us-ascii?Q?ehceo1DBHvjyA7D+EPGgFMDdJoDw415p8WNCG9kE3JalBOTvGJzCnML+v2c2?=
 =?us-ascii?Q?l9fYXWg3R/SDz+GC8veihG24ONkKA2qjqmF7SIHWqppj14sjarjqFQFq7zUD?=
 =?us-ascii?Q?4SX2Q+Q5H0Fw7dw7feBLlRHkECGm/vTSlqL0xvsguFvDVumwwvtFbXxbhxKo?=
 =?us-ascii?Q?ViwEtm27FVHQLtFbEL2QByD3FJKEc4kZVG3dYouvN9vuva767/vijAQEejm2?=
 =?us-ascii?Q?4NzOgBrgN1orOyk8V/e2sdOo9aOADzdh2AvZGl42g++A5p5cHPUzKiGGxsL7?=
 =?us-ascii?Q?CJVWgYsyQwN7tBkPAnWE8zHlePgYOyabYboSh9PjkisRhSEk0lZu3j2Uh7nj?=
 =?us-ascii?Q?e/kY24EGHlYZLxS+fHU8vL+Yf2Y1xxW3n6wV64/jSceQjIlHETKmP1DvC9rB?=
 =?us-ascii?Q?ZQCnNRs0tiOyZO9RgLLD19KFYdj3PAyZfCYA6UJBPe3onACVKEzFsF49wfAx?=
 =?us-ascii?Q?2EYvmPks4n6aqcXg22QifAVZgk5nkgiqXrgMK7bnJMgPyHJyb0UVhPCyyGg0?=
 =?us-ascii?Q?OXekaLsIMXkk64jV29QaSHfjY5AjdkEnJt0CXq4+0tUlDjqgfTCFQ+oHmkNX?=
 =?us-ascii?Q?P6MpA77mdb9bpT/xJtpX+Ww1fyB3cmnCrOPJWTs2kTFhqpgMYeARM2RZ3Xyf?=
 =?us-ascii?Q?32Q+2LKLSvoAAEVkIZPfAf04XKdkoL5cJsdqIunXsrejDjreUVjfIO5Obbje?=
 =?us-ascii?Q?adT5XRQkwst6uDis4psbVj+K3jVZl2x5uTB/BylQ02UahcFth35vdp25S4jj?=
 =?us-ascii?Q?Y/NL7sCGWXcVnOS0/rgoe/PV7AsSDz8qFnQrpSVfRK+f0HPvD8S1/QiPOvVb?=
 =?us-ascii?Q?dk+AfRrxofhTawQk9Q9cdM8b6AHlMgxlM3mWEzV7suJKE2pgNpYpPQcW9NX/?=
 =?us-ascii?Q?rB3c6wrGr78enuESn150plGwY/wd20sPAN8MtnQGCmdf5xOuQA5b01+UW+Wk?=
 =?us-ascii?Q?wjOh+9neeQ5ZdepiNBqza4z8tJK5EywqMmix8hZzIyE8Gal0Cx1ZymjBPJaP?=
 =?us-ascii?Q?yBvXRCHxuMtcYVyCFp2b1g5hOIEM0AtcXKiK8WQYZkWYgYiFX6ZpyWn81CYR?=
 =?us-ascii?Q?j1BbB4AVno0Ud4poPdSwo3MHxw0ROcswShOyF7z1okJPiVZFM5Z16wlTgZQe?=
 =?us-ascii?Q?KLuD0TEhWK0odgX4c8iRd6+3fMzE+dM1+oRJPX4ruH6VWFRy0g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:23.7671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebe52921-5914-4835-9b96-08dcf7125216
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7072

Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
the subsequent TSC value reads are undefined. For AMD platform,
MSR_IA32_TSC is intercepted by the hypervisor, MSR_IA32_TSC read/write
accesses should not exit to the hypervisor for such guests.

Accesses to MSR_IA32_TSC needs special handling in the #VC handler for the
guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be ignored,
and reads of MSR_IA32_TSC should return the result of the RDTSC
instruction.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/coco/sev/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 88cae62382c2..585022b26028 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1308,6 +1308,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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
+	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC)) {
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


