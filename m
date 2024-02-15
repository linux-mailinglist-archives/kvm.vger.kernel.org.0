Return-Path: <kvm+bounces-8757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F311A8561AF
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA572292961
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98F912FB35;
	Thu, 15 Feb 2024 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k0ogRp6K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FD71EF1D;
	Thu, 15 Feb 2024 11:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996764; cv=fail; b=BeZXVE1mcWQdy6fRx4YWHpzGUOX14hPg/qf83WZn6k2gJzIiTVM71cBkep7xuvlOARi4PQRp+Ty1ZYAo1SLOfiy2e18fyokBPicd86rxxlKyiaNrXlYaL+qRuupVtj9BlXJLTua2L6BmW59x7oMIOtZAPECRmgEBptOWn9edAmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996764; c=relaxed/simple;
	bh=efbtN2Os/fp7sfd2NzeD++h7pYn1n0Hu2Lwra4Wn7Dk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBnnnRAdvr6OB3XvLUV885zxDjb2qGJMx2PnG3nKgn2lf3F9LtTGFdHzQfKBiIl44avPr4kwN6m62PmgHji6IEof1msHiWzMunZcS8lYNRTo6PXYURpIjTk870JHu+RIx8PCEOUbk1l6md1Iz7YD0t7psENflZVuouxlDNAM2OU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k0ogRp6K; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTXvhy66gllcNxkFnS6HmtSa/FcAyKnKRtZNUduJDaWQLxk2KlQUEbc/fTR30Fy3vnCpHvEWObRCZTtqbGg8e9bzKBk0zZNfTrLy/DXWQ+etcWhninv9p9WPZCMV/T5AsZ+Vvqtl5u24FLcfQJsj03LTxgnGQ5jkX3mT0s1euYohX/4NMLo8m8B90s+Fsgf9FmAkd20Ti8BQCdGidf/7yU75+kQY9FlGEF7/m70Cot5qtupCPq78l27NSTEH2giUVMwuMSL7EXgOqBDa/O4P+LX8YoBvWr8s1W7fhyvZAF3X78WCTul+jZcCK5KCElD7f+GFfsyiYOR5WV7Avqc6ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=It5pr17ZdgYlWcG/Xty4ZfLOWkb0bgbdWdegECs9Xe0=;
 b=I1//65HyQoOEQ+3L9YRwkY198BvCGu6+YnwQbOjcFw2hm/QxdV7LNzK4pu2GtwcCSlESLm6hSAwanDW1mPS0EH5Tw5bmkANu/fYDtxl22SkbZwetOUroKsoeHLdurK2N1UCYm6325wkgZxP7JXB85XKMspWn8XpzYkcXQKhLU9DmMOKn/3VPNvdps3q5I7O5SdUFyciStruUZ0jFnDVhN0Hzb18ka+IyFujpmHjjEPFCIJsDrFVLdnNoP4SiFjlTdvlVSkKr3RlTKadDIG4p6TJbqe7d40T2Aihh3mWLBL20c/hTks3SnkBVydJYDW6xwM8mFexXIIrzK+S134mdPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=It5pr17ZdgYlWcG/Xty4ZfLOWkb0bgbdWdegECs9Xe0=;
 b=k0ogRp6KWlARMOkORAFhlHUn5MNTgp5vRA9DHO2qvWBF8BrwAx9+ManNkirrSKkyoqc8YIRFpWzXyktiK6krklWKYUUseyQPN0Q1KMzq6Ea/DEV+1XJuXrMFIt5/7FPKXQYl8ECoxhGGQPbNAVUFcEBa1tOStB1L98r5Jce5BSI=
Received: from PR3P250CA0006.EURP250.PROD.OUTLOOK.COM (2603:10a6:102:57::11)
 by SA0PR12MB4589.namprd12.prod.outlook.com (2603:10b6:806:92::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Thu, 15 Feb
 2024 11:32:39 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10a6:102:57:cafe::5e) by PR3P250CA0006.outlook.office365.com
 (2603:10a6:102:57::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:38 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:34 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 11/16] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Thu, 15 Feb 2024 17:01:23 +0530
Message-ID: <20240215113128.275608-12-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|SA0PR12MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f8ca010-8f40-4168-ccff-08dc2e19d073
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	37vxBE48pH+5PEuUNWm3t3r5z3q3RlGeX/lXggcB3oAJ6LFgA93oplGn3AnHrRszJF96UAHaEeNdxrkpK9D9IV0PjpvpLmQHqD3jV6ytTi0LkVZb9Wh79xCyLYa0EJBHyP5UnGXGzZi/cBTSH9HYRnunnTkWgoUF2/cpkKW2NxyDm3eBsSPRkS1V9WrHc4Xn7XiE0RJM4Hn/6k9PT7BVAfkhCN6ABiM/FOQXj3G54kZ+RrjTiqEwnkrthU40oYg+z4Ao6IiHjzcSozJJke1Zl4U5YKm5Oc1nN2Tp4KfQxTB5FNO7JmfcdvK9pJ945mXFP2Q1Rkw0m0JdHcdj1El9kCzakQG00Fi5rkH4g4uD5OJqdDgu0e4eaCWQufn4wIuJS2o+Awa+OshN5fnFmP0+6VQdSfqvq++uUWDRBGJij/yfIwL4Bl1JM/AnjwL6i016gjusDztT0mb+MKf7Mvz1vVpakcjmaOOOT9IGaHfh3zCKEky4TymQKnmB0AiQMeH/jV4B7v9/qyi9Bx4lPgWUiYaf0r9276oAWus535tFLfqgTlf7Txw1idIAo20jl9OH3XRtSgfxuH6EbQSkpoIoVQuSvfSlWooStyMOUGk5uqito/tc+alhqEDhKkqsKwTW/PRoda/pD+bF8L14pOOALQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(136003)(376002)(230922051799003)(64100799003)(451199024)(82310400011)(186009)(36860700004)(1800799012)(46966006)(40470700004)(6666004)(478600001)(41300700001)(5660300002)(7416002)(4326008)(2906002)(8676002)(8936002)(7696005)(54906003)(70206006)(110136005)(316002)(70586007)(2616005)(83380400001)(1076003)(336012)(426003)(356005)(81166007)(26005)(36756003)(16526019)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:38.5453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8ca010-8f40-4168-ccff-08dc2e19d073
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4589

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
index 20a1e50b7638..64243c44a7d3 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1279,6 +1279,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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
+	if (regs->cx == MSR_IA32_TSC && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC)) {
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


