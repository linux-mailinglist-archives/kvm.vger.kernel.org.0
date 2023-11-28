Return-Path: <kvm+bounces-2608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 45BEC7FBAC7
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:02:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C95D5B21F4A
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0885E56B91;
	Tue, 28 Nov 2023 13:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T8N+xtDi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15BF1FD2;
	Tue, 28 Nov 2023 05:02:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8UuGaQfQWqney150YzxeKhC0Wws6BUd+ARV8GF/4EJ5MZU2px8qU7hy0AUQ/TdLAL4DGDb6L3V/SEyfKcY29g/KyyYhbGiqN6ZatpklbWYEcJJz3Ir1vf7b8CxBmqvflSUf72O0Jj7b0CFXliDsD2YKWDbcZ2IzqUDJv3Nx67aLAll7DX57zK+M3w4+aQ+9LqUiwbRJzpYKisDcSlEBJzg8h4sWM6JAURbqvDOjBxKTqB989at3aRpz1fZp+VuWrfNEYSdS3TwOJUHMe8XFvKrrK6Cf/G2Kj5Fo0Rqplf4z1XsTLRXzS+1lS0wygk1WP8MJl2z1zrC3xkNW5wkniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hR8xMH3B+4y8EU6wKzYPGyYnefPaPYEhI/SuucyjN+8=;
 b=X1a8ksImGj6a9MivhBXVxyyFowxAHnpUvUC7eis80PHvF2isQjAJMMJiQ35myRF6Vf66QUEcCa1C2EeJYcXw7ViOAG947hJ3B1yBeC5uC+WGNZv2s7zYdB6+zrGNWmyYxgKx3ypNYy40CIpGvUMMc45oyIUW1Kp+yDN8dG1qZcJEyVSRGDQuYG2/hFLIgD7Ank2Lpdi5cWlemhbGRsKyaYUS62swbWjWcHtQpre87PU1l5JtzYCuG5ojK5/zWYI2DVYl/HsMnpDFN4QVJKsCmEpUlUUBp6W02q9UKZzyID4QcF8T7ibcmReyxeygdgcOgNYE3fbf0SK1U57g/RSDqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR8xMH3B+4y8EU6wKzYPGyYnefPaPYEhI/SuucyjN+8=;
 b=T8N+xtDipE/SsP5+7hgG+jWQa9yJ00qTo1/JXvPWqs5VOGKtDn37q6/qwFeeZPW8nHPSofQitAindswWQY95lqbmapFwrhKG01YEXIGYKDtp83ey+s5WW5/pdwjhpG1IpeTTPfooNl65z6tQwpu/q+RrVVeSyQWaI9TGvs94csA=
Received: from DM6PR07CA0121.namprd07.prod.outlook.com (2603:10b6:5:330::33)
 by PH7PR12MB6695.namprd12.prod.outlook.com (2603:10b6:510:1b2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 13:01:57 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:5:330:cafe::8f) by DM6PR07CA0121.outlook.office365.com
 (2603:10b6:5:330::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Tue, 28 Nov 2023 13:01:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:01:57 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:01:34 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 11/16] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Tue, 28 Nov 2023 18:29:54 +0530
Message-ID: <20231128125959.1810039-12-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
References: <20231128125959.1810039-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|PH7PR12MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: 99410a82-0b75-4e04-d9c2-08dbf01233f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VPminX5M31Ozexp7rhI8/WM0m1GOFxnBRevHR6+oc8wWe2nrr+GXzh7W8byLAuTxxErhUwiSWNj0RRoHczPJ1i9MVX7dBRcp/eiq57ZC2gs8mJ7ECmbdoNwznpkT8C57vYUt7CjmQDXSulnaZVW6q+9ykyeRMc2giGDI8QLS1QlDxNXtxyL3VCOa29/BO0XyXkl5n4Y4krWxcpJ5sbLIAozGbYtFrv+gmMIN1VHF09G7Lx1HYGkB1EqEjz39VUo4dkDmUZchX2KRzrr21L/kMlqU/fa8cBh4iRPIZ10mj44GrF70FAf2WfcQwE++59g3qKBNLLH2zCQGoaL2V8dJ50dLNBznr27ptxECoIiSt2tA5at5UKH2uOdFcBo6YwuUPaYHGAIA2+rBFGKzdywKEqwFKHS6MKKIhjIwSXu4JuPCn2bcSSEy+UmWLPRH1uCp9aRd0i4eeoE2LExTJruAzNMxUAUkCzXOXNxWx8A761lBP8XGzQXkpF+Ix+lO+R6WS4zDRp7DrjYYniLfg+HMC/rdXbBH2eHL4VZ99uJONE4SZrfQbly4eKdm+81ushOnoinf71rDhl0Cp3VQ294felvulMBWkJ/sllmW+g2P+33hnJXuTSR1I/mKFI2Ha367MgYfd2KXjyNBTCveLgsAjITfarYi97kpE9sowGScR5lG3mVesBAvwwGwtBFkEg7lcUA9KD97OYp/vvanxO1sxu/csO832wLuYxQ4A2aKbg8tNlDOAlhjsSX2WbXN2p9sFhFQ4+eMl4Z8s6bJAnsXqA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(136003)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(82310400011)(40470700004)(46966006)(36840700001)(6666004)(8936002)(4326008)(8676002)(7696005)(54906003)(110136005)(70586007)(70206006)(316002)(478600001)(40460700003)(81166007)(356005)(47076005)(36756003)(41300700001)(1076003)(26005)(2906002)(16526019)(36860700001)(2616005)(40480700001)(83380400001)(336012)(426003)(7416002)(5660300002)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:01:57.3725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99410a82-0b75-4e04-d9c2-08dbf01233f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6695

Secure TSC enabled guests should not write MSR_IA32_TSC(10H) register
as the subsequent TSC value reads are undefined. MSR_IA32_TSC related
accesses should not exit to the hypervisor for such guests.

Accesses to MSR_IA32_TSC needs special handling in the #VC handler for
the guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be
ignored, and reads of MSR_IA32_TSC should return the result of the
RDTSC instruction.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/sev.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 1cb6c66d1601..602988080312 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1266,6 +1266,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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


