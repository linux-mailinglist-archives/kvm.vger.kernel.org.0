Return-Path: <kvm+bounces-32901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 753EC9E18B0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 11:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 117F9B3405E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF601DF982;
	Tue,  3 Dec 2024 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="la9HxfgK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AD81DE3CF;
	Tue,  3 Dec 2024 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216490; cv=fail; b=ey0ZWbeAnLim7H2OrCyTX3clcH5v1P4q8GDswd+1AwnnkkpWgPJ119S0EgzfcR5tSlFyEo/FzZBO6JnxHuc7BICEh+vm/iaPxJZ6lLVeiiI2S3LmuCXxs9bmZxvxNw/BX/OPJl7czrkUuMF5gaTWIotifIdHPPH8I8qfRkx80hI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216490; c=relaxed/simple;
	bh=xD//zptdKAscnlm2Vf8WtRMspIq0l/OHD/3bYxoonP0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9hVEe5U4ryHtMhtCxS5uIJRt66UJKX7fPwrmThotk9LP5SGfawYTkyJEDE9U8daB7FtRX1wPWL8bXvPdc3O2QzpKahgO6ToLH5DU0Ei7JoTf5TK/0ckJUKMtOmtbgrYU9kTNiUKg5gN2hS6QP5MUNM8nT42bQt8kGhfx6fvMJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=la9HxfgK; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2Rplf7Qf/Ong2sJDi8maO1w4NmyW6Ms7+/gPRWukI7V+OJS8zvm56d5bx1K5HNDc/BAc22wuw464gzqFIbDzAXGZwDm4kac51RVJcDklRHIQYF9e/ZuAZErR1+dTTYi/KultR2C3GhCoRw/Xw+tKHRLJz2/n+SJ+nFNYFJIcg5lRM0FjdF5Z9i8hjWF0m4DQiBYJu1tAn74gcczyvgoNLROsPl8jnbSlBu4DDzbg3D0eKnxHnlT7Qj1RCwQRk3dK3wsi/sSjnVCHgUDzj3jrJPhYN1kvfN0pYzYr/IR+UN6LsXMPl0CAaqqSuDoD0joe7Jn/uSbmlaS411O49VX4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UP99uhyNsG10l+T2I2+7VWdX+j6FML3l2skCSpWWdZ8=;
 b=AYa+2KdoKQVMpemHsbnq4fijp060bhttuGZsYDmFXky8SbWKqf5adAD5SYMdJCKDQtzDvHhSlReBrNI3zcid2yIHOiHbN6DCIVPY4V+RgLhMD/pu/WoPCLBC4JIXmfyF8opN6bjWr8HtBxgw+YeHcB0CyKG46WD7mGQ/ndbQYjx/TmIRBxfVxXsP3sBTrntJ8lz9dbMo/gLmYyuJxO8eYQN/VEsBnVfKU6CLiAl1Ptb/G9mFUWOy3NBVW8crcLnN+viqxYQJmWCCOo0Ye1sVtYSDzPFlaa96/HjUGjbnnJz/UbmQGcleNUvCUvc8B3M7g1NUqkf9ZXMlAYnBVXcNQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UP99uhyNsG10l+T2I2+7VWdX+j6FML3l2skCSpWWdZ8=;
 b=la9HxfgKp6MYgRoCS2tFudbdxbFE2YNUMvsh6wzvJRxkPAHshJijbBTuV4MQRwuMxy1B+W9WcWK3+iATf1b7hDM7IfMe1UdW49fGk2MvqvXZo6mMpTJxDjn3TzQMi+O4jWGlCsBmOLrADHEfcQJxpkj+QbnldQcYh/N5b7EaXTo=
Received: from CH2PR12CA0024.namprd12.prod.outlook.com (2603:10b6:610:57::34)
 by DM4PR12MB6183.namprd12.prod.outlook.com (2603:10b6:8:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Tue, 3 Dec
 2024 09:01:23 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::1d) by CH2PR12CA0024.outlook.office365.com
 (2603:10b6:610:57::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:23 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:19 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Tue, 3 Dec 2024 14:30:36 +0530
Message-ID: <20241203090045.942078-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|DM4PR12MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: ac567751-33ad-4c27-b633-08dd13790fc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B6ICRwRIFnJPoylZMebXYTnUexwnvg4g/hwPvtNWw7Pw2PVjjedaUeDsk/xf?=
 =?us-ascii?Q?fl67IZEbadAuEV/3gvbFpJCcKsW+utxlzpo0vgUSxM5S9oUm+bHSAztkP1kd?=
 =?us-ascii?Q?9RQQwkEcL+neCcL//8HmVpU9XIOn02bDxY2UWx6wzRG/ujnucbILBJbtys8U?=
 =?us-ascii?Q?X7z189iAdhCZ1okU9tAHkkjr8obIs2EEmdDWnFQmFIen0J54DfKA21FVkH6G?=
 =?us-ascii?Q?voCXIVlhR31CdPNYo1D41uGN1g3wowu5vJeXznTZv4TZfotK4QKnD6nj0GUy?=
 =?us-ascii?Q?qd61bcmqMyaBy2BdDVCYIfnNmtJ6FpmcEKm7oIlLm58XHLudm5K/NlEzwm+h?=
 =?us-ascii?Q?xMO8cLDm5giGubau6e0oFHFoH/HJeQDB1ryMhDFHxThYjptIMCNzDjS6/f7v?=
 =?us-ascii?Q?dU4QlMuBiqwQejBYEsUMCpDOneCCrh4FMUu9ZOLj9I+Mo0tfHlqAkQF6djYD?=
 =?us-ascii?Q?N2dLbq0XYPuCa6N8vBiyRW9DHhhGeCR13qykZIIEENF6MTZgIKG8MWT5Mt/f?=
 =?us-ascii?Q?ywVEud2Dfte4wKRuzKzWzQHYGZL0i6jKjbCQfB0wypD1r6ZRqF6x3B7qVjf1?=
 =?us-ascii?Q?VJ8N0NiGrPq9Bz6ThR4vPkh9Ji4hKD55A4ZoHO9UsOjGReMmhQ3dT1PHu7wP?=
 =?us-ascii?Q?2q/IiB0zflLbOg6xfTcKyBKGbDdVxIdb0f2wt26TgyudiK9qEoMgc5uNIp2s?=
 =?us-ascii?Q?hVb62rVIPeNDIHmJFSxWan3FN37DH4uEdq/SMpg+nbB01+LLkPeAfjQoh0mn?=
 =?us-ascii?Q?TqsI9IfF2WghdS9QyAVImcEmLObTTzhIDASOfdp7OBh98ZWWkn3xsVWlTk+Q?=
 =?us-ascii?Q?gjmljKAMC9M/tLiBf9FyjApD8wjJ2k9IgaKY4C25jMZCV6ftTv6wkWc3NRtQ?=
 =?us-ascii?Q?MrVyp3phkKUqfKFvbPbAcO/EaAqFrUoBgEIqNqsYRs6LGfgwvxkrAiCGfyNQ?=
 =?us-ascii?Q?WBl/qYnXp0Dp+IIRFkXoi7+vEwzMF/vFFwdazhkh0ZTP9KCSoByHZ2PRclne?=
 =?us-ascii?Q?qNQp+nZpT8Lide9AxcaVO5WMpPSM/4osQdvYpiQZ99/oo1Qwm+BBu1rUSSxL?=
 =?us-ascii?Q?HRtBHumpEJ1zFxJ4pImpUR/0ZAEn1ucUw5rBMHVWXWM1Laj2HncvwM48DiHI?=
 =?us-ascii?Q?MxPd2flVZWhUJfFuGCH8FwYIWDAslFRLHUfYeuSTDhfHcGqg2MS4rj/3MOnT?=
 =?us-ascii?Q?xuHlXzW0e56gwKgJW5ncCoRFW9xVe8eOa88abjPqL53VHy/m9+EWsmUY7Qss?=
 =?us-ascii?Q?30uUjP0hnxki2p6jIi/GYi1yVcSZWuq1DEPYrIwzuLu2cru6WBvljcV24z06?=
 =?us-ascii?Q?f58k6IzYdba2lnSIz/yYirSFEeAQVDCz9wlrtORkNs0dYEtm+7QcwWeJEmro?=
 =?us-ascii?Q?3saYCRAqvpDRMvSs4QjwerGGfBvO4xmZSuaSK709e79EKIshOQ6MxTzQF37l?=
 =?us-ascii?Q?73hA+409v7/Rucqr4GtxmEYF/U4pmzLu?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:23.2126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac567751-33ad-4c27-b633-08dd13790fc5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6183

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
 arch/x86/coco/sev/core.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 39683101b526..af28fb962309 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1433,6 +1433,31 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
 	return ES_OK;
 }
 
+/*
+ * TSC related accesses should not exit to the hypervisor when a guest is
+ * executing with SecureTSC enabled, so special handling is required for
+ * accesses of MSR_IA32_TSC:
+ *
+ * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
+ *         of the TSC to return undefined values, so ignore all
+ *         writes.
+ * Reads:  Reads of MSR_IA32_TSC should return the current TSC
+ *         value, use the value returned by RDTSC.
+ */
+static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
+{
+	u64 tsc;
+
+	if (write)
+		return ES_OK;
+
+	tsc = rdtsc_ordered();
+	regs->ax = lower_32_bits(tsc);
+	regs->dx = upper_32_bits(tsc);
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
@@ -1445,6 +1470,9 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	if (regs->cx == MSR_SVSM_CAA)
 		return __vc_handle_msr_caa(regs, write);
 
+	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
+		return __vc_handle_msr_tsc(regs, write);
+
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (write) {
 		ghcb_set_rax(ghcb, regs->ax);
-- 
2.34.1


