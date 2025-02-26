Return-Path: <kvm+bounces-39258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 704C6A459A0
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:11:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C02D7178141
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E3D226D16;
	Wed, 26 Feb 2025 09:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V+ptEsS8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8865D207A11;
	Wed, 26 Feb 2025 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560988; cv=fail; b=qMxJASVMdMtdPkNStsSGYSrGIPFJZBnju44+bt1yxmNXIHcgMdLtUEsxT6fiqjsRMZbR7cL42RkpYT3iBdu4l/y/MWdJMxHHkFPuMjtbHNeIlhMeUQ9JIo8hi8nVrV3Pze2xXVifjDzXXPfmtHbA70yhDMgMhF+S7kNBbKdW61k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560988; c=relaxed/simple;
	bh=DKBuCP3bDCUZnZtF2OLDlb3BS9CCOfXehMyTyXb/fsQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqnEUGdyO8OZMjA+bJ6PSGfmDb5WqOJC6dhf2IgOHxiodwf1cSHZu6ilbyhYzY2HpvJVtCsB+FLyGBEdpG/QZwiY99aMLV2MEAs6X82HRzmBMlxWX2gXtxFbuV+w1Gn6M/qunzn9EDtjtU0k6N/tiNwSmJUmCXHDfYS9a1QLE2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V+ptEsS8; arc=fail smtp.client-ip=40.107.236.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SjRywftBA8oWSeE62K+be+iNnMBuKWOfDdoyrrXh2xL4UoHuiebSuZ0Cx7StUqaoIJbLHDFv4WQ4oM87Dj3lbH3rnNALRwMTxtAVfYgnooPgrFmBLhmXkdBsTJKBpr5n1Owm14p9qjVu8TpShDFQ+hgjnKS+cXnUOSPMh9Mzc1RhEiJX1ZdRnTt/PFqpqGbcvkTsRCLFSweHk1lAvfADTFsFe2FSBbVkOkmiLykiMM6loSZblG/AT7t1ECZKk9YJN4iznv77xC6QD++8M0oITdALRiw1vjrnfXLGhkOKZfo1mVwR8/Vl4JWgiB0rP5yYEgkPGdzE0JF9BfmHYi6Qfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzN3awGFI5/Gu3MmR9YvsgM3pFo1Ik1wa0tE3/yUwqI=;
 b=b0i0Ms8euc2Bmyj/esYnqbdq7Wxi82kB++kSoulvWJWPo8yVdNS0YpzDI6dodlgxaZpBZNjct+1XlgXS7D5GDmKq++yqiTqphrMzGwRFqReCoZ19+fmxfFSAy6krcHEOsUIa7veoJRE8ZmT60cs7G+n0nQ/+CGDK7Kp1W8hJcgMx6kIZmjW7jxnNvV4z8eyP1ceuZr6QYsEP8KBdX9sWEItT6kuEdpDA5dh7JA42sQLlRIJLcIa09bxVRKU8wOz8Si4PzbvS8chaRb+WRPK72xcsXF218qbdLHzXZzjqGnErCTvVMFkw3UprLPrdBLWMyBs2BNJAImN70ColMg3W5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzN3awGFI5/Gu3MmR9YvsgM3pFo1Ik1wa0tE3/yUwqI=;
 b=V+ptEsS8TezYhXxHEjTbqh9Uk6/bkEGeRa0ZTeNRqhghKmDhdVbl0X/KGOCzTt0DU9/pxVnZZlu+CRqxZ9fm1uweJZhr70Z+BG17JKJo+3J99jH17jH1dN6UeraOFWm00VVSSXcs0vdYnPdjU/fzz813gzYIz5rhNNFxpIKRhGc=
Received: from BYAPR07CA0020.namprd07.prod.outlook.com (2603:10b6:a02:bc::33)
 by SN7PR12MB7854.namprd12.prod.outlook.com (2603:10b6:806:32b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Wed, 26 Feb
 2025 09:09:42 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a02:bc:cafe::c9) by BYAPR07CA0020.outlook.office365.com
 (2603:10b6:a02:bc::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Wed,
 26 Feb 2025 09:09:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:09:42 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:09:36 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 13/17] x86/apic: Handle EOI writes for SAVIC guests
Date: Wed, 26 Feb 2025 14:35:21 +0530
Message-ID: <20250226090525.231882-14-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|SN7PR12MB7854:EE_
X-MS-Office365-Filtering-Correlation-Id: de6c52a3-aad6-49bd-5790-08dd56454ea0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9m/EGpEDQm+772382gtmkZC+rEL6GkB3galLZwk+BBxk+TvptoBAxOrt6oGG?=
 =?us-ascii?Q?xpz28XxMfp8u1EwYktv4YjTeIcjVyYx+5hyDCCVcPQ61NGp2edZEvQFabuyb?=
 =?us-ascii?Q?hYfcjXy9L59S3rGjko1VoXxIsM/JR//uI7N32PRLRGH7pyLci8MhZWe47ItJ?=
 =?us-ascii?Q?NWRIXQIzdHQRvPd8geHl2t/S2lPaYKCvgENIitU0HEH6r5hKK8s/JFHE5aUd?=
 =?us-ascii?Q?t4QgVNi7/bg59ycFjnEYmP721KEU9wQmKtUz12k/Kqym/AWV6IC5ofQNIsWZ?=
 =?us-ascii?Q?COgCG5Xev/e1JmxChK6slW7CC9fjoy+jZra+lQALv4M/VFJEW3SaqPSYGDxo?=
 =?us-ascii?Q?X4YyOil3NV1PRHfyxzgt788GBvML6xZApVmQ+6k9VyNhWbSbjl4GP2bZIm+/?=
 =?us-ascii?Q?r1CbYoyL6fPxApoU9MRS2j+gZmM8fa+Kgu76LF+58u5eppMiQ/fmpRCf8lBj?=
 =?us-ascii?Q?9IZb5bUZgT24afhCJiKM2Uw4DQjWeqWTLKNp/bSLX4nXp7zBAmjruy5mEO8t?=
 =?us-ascii?Q?7z3tvOjVjoqbtMIFjS7+JKpz6sJ81L73NwxL9vXwvsoOXvDn5KUq8reoNmWQ?=
 =?us-ascii?Q?TNpWJ4kxvTFnJYqERzH1u2MuGqODyh6UJcweMWNJvDlQL2GPkmSkO6tCkTyU?=
 =?us-ascii?Q?SuMRTYTxBiEIOOY375sL2qB+d/4B92f9WM20kHiVWzT7M5wMH5FxImjagkhQ?=
 =?us-ascii?Q?oqS8tHUtYSKOOgbczFjjIh0Ab6dtTah3xrY5Qj2uvLmQl+jORG7HOVqfGzfG?=
 =?us-ascii?Q?lUT00B18XbJIeZaVd7fwUrIgYM4lnolRpcVcWo96K3bH64uWK0qRKRpdmH/Q?=
 =?us-ascii?Q?6Ajj5pf+b2mpIvmyyaa3qWAJHBNVFPAj+ILBsSFjvOGSwfsiOvjVZhKSSMmS?=
 =?us-ascii?Q?dbciWPWAzAvvsc3+EwboSC9npyeqv1vIYvHVrPxn3/V3U8KZiuOrydG3Xc10?=
 =?us-ascii?Q?zFkPH2O9yvOYT8zxOdtFmAI+vIL8EK6u5eTJ3dvOf1TDY/S5cxkzFwkdRuUr?=
 =?us-ascii?Q?A9SmK0LMB7hbCTEqRcSa3vhj1e1hPnFB/UaTH9oZiLw6k4CnxcGnFh+iwsY9?=
 =?us-ascii?Q?zirL//BHN1nCC9se5axLHoncQgNrYJqRGgdUwENHIyX4ZkhLN5ZnbcG8cZw9?=
 =?us-ascii?Q?QjbqHD7vPrM1aYaEFSqRB9wWB69RmGgBHECf9n5AYC+Q8WJWMYrDw3V0czZM?=
 =?us-ascii?Q?YY1TNl2YDmnZZhl8aAd1Yk+6Hs0v8qGuBJduXWViqibYLT7qc9mmVsxu//Mr?=
 =?us-ascii?Q?ZAqeKQh96CaomwTv662iEoerhKAdLb6XAPmu8sQdDA8K9rSSK2wQhsw94HRn?=
 =?us-ascii?Q?iaPOMteFiTV4LxhQABtEOcj/NfUn/QFgsceyf7lH12Y0HyLCHeFOcH9DZnps?=
 =?us-ascii?Q?Tc9LFM/lrKCtQME23OkzLMjAEngLWQFVUuCY55B5kT5HP9fcPwSxOeQAAIoC?=
 =?us-ascii?Q?9CWPU+wMYz8+DXL/3+upW2AyAWsxyB5GPhGJ4yzJDkATa3vfUO5rj0eqbJnu?=
 =?us-ascii?Q?5cOpa1NtluobpT4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:09:42.6779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de6c52a3-aad6-49bd-5790-08dd56454ea0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7854

Secure AVIC accelerates EOI msr writes for edge-triggered interrupts.
For level-triggered interrupts, EOI msr writes trigger #VC exception
with SVM_EXIT_AVIC_UNACCELERATED_ACCESS error code. The #VC handler
would need to trigger a GHCB protocol MSR write event to the Hypervisor.
As #VC handling adds extra overhead, directly do a GHCB protocol based
EOI write from apic->eoi() callback for level-triggered interrupts.
Use wrmsr for edge-triggered interrupts, so that hardware re-evaluates
any pending interrupt which can be delivered to guest vCPU. For level-
triggered interrupts, re-evaluation happens on return from VMGEXIT.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - New change.

 arch/x86/kernel/apic/x2apic_savic.c | 53 ++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index f6c72518f6ac..1d6f30866b5b 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -432,6 +432,57 @@ static int x2apic_savic_probe(void)
 	return 1;
 }
 
+static int find_highest_isr(void *backing_page)
+{
+	int vec_per_reg = 32;
+	int max_vec = 256;
+	u32 reg;
+	int vec;
+
+	for (vec = max_vec - 32; vec >= 0; vec -= vec_per_reg) {
+		reg = get_reg(backing_page, APIC_ISR + REG_POS(vec));
+		if (reg)
+			return __fls(reg) + vec;
+	}
+
+	return -1;
+}
+
+static void x2apic_savic_eoi(void)
+{
+	void *backing_page;
+	int reg_off;
+	int vec_pos;
+	u32 tmr;
+	int vec;
+
+	backing_page = this_cpu_read(apic_backing_page);
+
+	vec = find_highest_isr(backing_page);
+	if (WARN_ONCE(vec == -1, "EOI write without any active interrupt in APIC_ISR"))
+		return;
+
+	reg_off = REG_POS(vec);
+	vec_pos = VEC_POS(vec);
+	tmr = get_reg(backing_page, APIC_TMR + reg_off);
+	if (tmr & BIT(vec_pos)) {
+		clear_bit(vec_pos, backing_page + APIC_ISR + reg_off);
+		/*
+		 * Propagate the EOI write to hv for level-triggered interrupts.
+		 * Return to guest from GHCB protocol event takes care of
+		 * re-evaluating interrupt state.
+		 */
+		savic_ghcb_msr_write(APIC_EOI, 0);
+	} else {
+		/*
+		 * Hardware clears APIC_ISR and re-evaluates the interrupt state
+		 * to determine if there is any pending interrupt which can be
+		 * delivered to CPU.
+		 */
+		native_apic_msr_eoi();
+	}
+}
+
 static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.name				= "secure avic x2apic",
@@ -461,7 +512,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.read				= x2apic_savic_read,
 	.write				= x2apic_savic_write,
-	.eoi				= native_apic_msr_eoi,
+	.eoi				= x2apic_savic_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= x2apic_savic_icr_write,
 
-- 
2.34.1


