Return-Path: <kvm+bounces-34592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6557FA025EC
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64BF53A56A4
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E02F1DE8B8;
	Mon,  6 Jan 2025 12:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1/8GSJUm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2065.outbound.protection.outlook.com [40.107.100.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A4F1DD885;
	Mon,  6 Jan 2025 12:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167654; cv=fail; b=HqUkohaUQNSHHj/s0Cwk8ftGqrWiiqBxYV+amxlHGygcgUfix9GtWMMSs/B0oQl6F62hyaggV5bp9NunqDQTMapcwvTH3vxO/92S/BlP/AZ39b0QdJ1OYThRBQTKIeNK3zA36y7M7WOYWyN8NCy3icS6l561PZz4nc1PlkuDceQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167654; c=relaxed/simple;
	bh=+Mt4Xo4gq8YF5s5PTqxV7Wv8SJjh8nDI0ios4yKNSgY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M49vI8AsHpFtefhhXoNxATqQtoRphECtTthszmwS30tivdP770k2Zn6Wq+j6M4mkcgg0F0P1A+IX5NdKuYdcQ6wkTa6aOIU6tHb1Ete7mxDrcu4LJiUU6bbbixBxXy72fuNCc6XKpHPE27u/EM894k/dKmgf72zhfyHyjsxM/so=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1/8GSJUm; arc=fail smtp.client-ip=40.107.100.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EwUf8VA95M6SrsIUL9sGwrVYzPTwatZK//qA02syxytYsmPIQ+oaJJKpraCx9f8SubDN348nqtA7xe/eKHUQp+458QdX0TEj1bwau3lTPWJ7uholhaBzNLB5LMFsSeNBB93g0FjAa+JQZGYHk/OBdskXBFqKkWO5geWb4HmfmWH4D8Yy5enGyMY20mbW6oyVqbHRBXqljVeeO4NErLOUq/YIXTCf2tviHGXjiPMk/lmRyz4SCp5p7rb78wPTWNVU3fHfWoSY8qibgxY6CrhkuDiJ0Z+QeXMJxldv16t7/td9Aaco1NP5+oelV4H2Ahj7j87CyyjVyLLbNij89CKOqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pqoswnoX0/qe+gUbJAMNlCMH29+ydjopKLUifvQLc8=;
 b=vg0AP5n22mUrdwYp8W6fFv865SdJbM+QxRxkHPsLvrDdneaIHPnXjXnzDxUVRhBsH+9tzgg+J2sdVkIuWYQQu5EfFgPjjYoq3xlmC+qFybQNhJydy/QZZcfGhmux038fnPr+t0Xl3AXS3qNX+PO31i3FBrdaKbsAMsn/j73WxPHsUaKVM0/Hcff9PFnVD7vYaMSNIdMSIkQr5R9XnEmp9mnvjlC9MMl3VjtNxiG3NmWq52sp274wruBpBZviXu+YDxbVT8BItFrKmcWkbbDErZbhhTvYlj2UfYRHMOlySmTy7rwm7XaPUxrDiJyKl1ZsHSv52GEWi7ziOD/b2V6Q9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pqoswnoX0/qe+gUbJAMNlCMH29+ydjopKLUifvQLc8=;
 b=1/8GSJUmf9E2e1IdVQ2nClQUk3GrYISeaXTmLwVBrAPpEyeRjTc24jNttV9hDK7uqSZIuKCOP180ITmlupgT4fHdcqSnqJxEduWiNLNNgOdufc2e8Yba6Cw3+H2mYQcv3mTYYNFmv+pLRSZcBIebE0Xo0syE138lLV6leklAtvc=
Received: from PH7P221CA0001.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::7)
 by PH0PR12MB7837.namprd12.prod.outlook.com (2603:10b6:510:282::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Mon, 6 Jan
 2025 12:47:22 +0000
Received: from CY4PEPF0000EDD6.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::3f) by PH7P221CA0001.outlook.office365.com
 (2603:10b6:510:32a::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD6.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:22 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:17 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 06/13] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Mon, 6 Jan 2025 18:16:26 +0530
Message-ID: <20250106124633.1418972-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106124633.1418972-1-nikunj@amd.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD6:EE_|PH0PR12MB7837:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cc5a2e8-e4fe-4a34-15b4-08dd2e5043d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5142mRJq4/A1mQ45XovChaIg1/kzKoqMPeqTf9ffv5S4cwS4VdZVvIkfmJaO?=
 =?us-ascii?Q?F+WOYUFXUMM7IKyTxqg51MoS2vEXvforSpGOC2hzy+xGgkKwvqydfv7U+R3g?=
 =?us-ascii?Q?A5CdYD1+/yaFtN6mMP38d9sFSaxbPh7/u5LjJEtxMfkbIxDknHt4pAtQqL82?=
 =?us-ascii?Q?7MZQ71PlUA8U7C0w0TeqHF6dSIZugM8SPdZsQ6h/OXPuApZfzgHuS5c2neYX?=
 =?us-ascii?Q?pjoqnYJyzVppDKHtEIg6Yp84PQnBx10Vm5Q+bBfxSkpUNBc7qdqWB4fj34my?=
 =?us-ascii?Q?c2n3NtWlfUtRT52vqz+agEzXgI7batH7Qz6gS8/F4CvrzZNhzZfKEi/5nk+j?=
 =?us-ascii?Q?QTwAgRgxCtT4VBYhz2I0l9wKPG0U84YQ3EvpKaKxCyxZYlVzJrY2MSkgQDlL?=
 =?us-ascii?Q?enJx3KVS9I7+b8Yjcfq/wQmUg4y6frY3NDDUoFtjhQbFK5Kxkip74S9RJY8r?=
 =?us-ascii?Q?HOp4min4dsdd16ebPCWZsfQXHUxeFuHsAuQ8ZVshuhrwlVIV3otlZSprYA32?=
 =?us-ascii?Q?gl8ImHaNGwagyb4GkPJMYcN4DAM1l6oYB7lG85yny+xBIDGyxyG1wN32tZpD?=
 =?us-ascii?Q?G8wJw7Cw8Xit1ChHngiGqEU+C/qbCtM7vNVyNrNJyP0KV0HMToIP8BUCYFsr?=
 =?us-ascii?Q?YkH+574ap1vxgSpfWf7uYkcAToFlkwDCI5yFxfprYwRqyCq6SFmUXgI8B7PH?=
 =?us-ascii?Q?3pRU5BcWCmJlflkzGzG0UmxYJr8YlSLMUK9v/pjASC1j5s4ZQHtyEaJFdq65?=
 =?us-ascii?Q?tP44RdtgGnR9Z27EZACc5TivGsi3KJ18tJf1cxFVJ/y7Qn/giKx98h1z+FUo?=
 =?us-ascii?Q?o/8zA2d+ooYEqPqah/GNGJ32eeAyIc1KjupBFmg9RYwF+grkAyhj1k80jWUA?=
 =?us-ascii?Q?oWa+W5CaQ7fERi3eo2ckiDecThYw1cptPT9QsH7OaP7nvczLi6pRis16m6ER?=
 =?us-ascii?Q?31i+CHy29oSRugCbwPOYvYRoSgiABY4QbEjUVR6nkd5iJFZ59jZXv6AC7Hr4?=
 =?us-ascii?Q?E6yvGoYEBFZ8+PpRdnn7o/08AMHOCuZ93+PSQ453dNME81n1blVytbzm6hnP?=
 =?us-ascii?Q?OnO1YR3exDM1+EmtX5/tBWw14hAX0aflQ7xYoAqNHYwvsNv2wlmgiI1YnAXT?=
 =?us-ascii?Q?7evNju/zQ05TMTU1NTQvZouAamxPMk36OdXrc+dBJsmvSoT9aVNhuMT0kgvw?=
 =?us-ascii?Q?wrhFC6edV/CyrORjY3JnZAAOxb8FpVdl78bRSaSazeozNGkoI0ThEiaguZWP?=
 =?us-ascii?Q?2Td0h5Fc0idMoCfWGfrxBHZLtRqY4esDg6/bLk23xf+P0UiwyJINUAirvb+e?=
 =?us-ascii?Q?UaKBI+IE7RCNDcIgsUaq+8J5gkYAzlD1U6tPTOHwS6pnAEQQIPieR5h+0v2i?=
 =?us-ascii?Q?ezpNcw2w9BU27ONLAEsFh+eJS6JpL1p4sfcoeFv5JofsItx8OZb4VacgMXO0?=
 =?us-ascii?Q?FqnVRBC0EaVe/smUcUGrALCu0nPRfvwQqD5wLOdvt31vJe2ViDRD6+J6HhsR?=
 =?us-ascii?Q?iYtXhP4/HsAEhkg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:22.4928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc5a2e8-e4fe-4a34-15b4-08dd2e5043d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7837

Secure TSC enabled guests should not write to the MSR_IA32_TSC(10H)
register as the subsequent TSC value reads are undefined. For AMD platform,
MSR_IA32_TSC is intercepted by the hypervisor. MSR_IA32_TSC read/write
accesses should not exit to the hypervisor for such guests.

Accesses to MSR_IA32_TSC needs special handling in the #VC handler for the
guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be ignored
and flagged once with a warning, and reads of MSR_IA32_TSC should return
the result of the RDTSC instruction.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/coco/sev/core.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 00a0ac3baab7..f49d3e97e170 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1428,6 +1428,34 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
 	return ES_OK;
 }
 
+/*
+ * TSC related accesses should not exit to the hypervisor when a guest is
+ * executing with Secure TSC enabled, so special handling is required for
+ * accesses of MSR_IA32_TSC.
+ */
+static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool write)
+{
+	u64 tsc;
+
+	/*
+	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads of the TSC
+	 *         to return undefined values, so ignore all writes.
+	 *
+	 * Reads: Reads of MSR_IA32_TSC should return the current TSC value, use
+	 *        the value returned by rdtsc_ordered().
+	 */
+	if (write) {
+		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
+		return ES_OK;
+	}
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
@@ -1437,8 +1465,17 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	/* Is it a WRMSR? */
 	write = ctxt->insn.opcode.bytes[1] == 0x30;
 
-	if (regs->cx == MSR_SVSM_CAA)
+	switch (regs->cx) {
+	case MSR_SVSM_CAA:
 		return __vc_handle_msr_caa(regs, write);
+	case MSR_IA32_TSC:
+		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+			return __vc_handle_secure_tsc_msrs(regs, write);
+		else
+			break;
+	default:
+		break;
+	}
 
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (write) {
-- 
2.34.1


