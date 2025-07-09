Return-Path: <kvm+bounces-51865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32AA9AFDE73
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D58EF189333C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7C621CA02;
	Wed,  9 Jul 2025 03:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GKc8XsYp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35111FDA8C;
	Wed,  9 Jul 2025 03:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032569; cv=fail; b=l5OA5akJ3ODSdqu+ne14pbPdTm7O+J148xGzbaz2w6h/ZxlNXNLLERIZE2eoGE/BNK5RyuZpu8QFAalMqHuTzmtO1xnbB9uKMA6DftzbE7JardlGdimMg2dIomRAsiZzXhchuR8LsCzGjHRBhOn24BqwVUZ8+GkV9Gc1n6t4Tu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032569; c=relaxed/simple;
	bh=ZCvY98KN6J+89bbIcQ6nxuphiv057a4MfEzKd1qKonQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zwkw2C52Wg/98WTR4nNCnfRcVImZ8LUwGLfCagCS1kxnXuJTTzOcJj07MaCrzIJUx45gJODGHWjuhmnSzDIFhYc8rOcb4GuzGsw6pEBC/OgnxIgLTDd8fQFxIF1KquoryW8ZNNZj6NPsy8xAX86WlHprd3GPqGsGx51HoEfe1rA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GKc8XsYp; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MbosEOhk+FqjiSLsk2pbOXQlJMKv8ihz6Vd6XRnj3XrlNSb/H1n2IR7xqB7rJqsAINaoNLsikaEwX9I/t64QEru9uviv+IyDd24X+ylbPzt8nHM74djIVQMQHvGUBXBU+NAMcXeo1K49PGwl7aocy06DefqV4Xg2G5LQ3LdXPdTSraXhHmMPOKTa04dsmH4HjOFKT4jwmcD7TQGfn6Mdb2mLLTQgDQwBk71iRbeEYuRCBIWfv6tgr3bivwEjhh7RVSDlm/KIVv4SxawtZrGdSns34+8BbRk5+VzC90HZZxITMLTvDKWvBr1rTvl5vC2bQESIloC6XkoNeDHExEAmBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNvtuNS7zsax2c0byfUGl/QnHQoNx1FpK9TReb4DC/M=;
 b=Sv4OWQb4EiL9pvJDeEvHNsbsiDYlX3F8q1zQ1r6Ql6EZurYrbmTytNp52OqR+Ei4QY2D5rla7igasrN67l3j1v1xQqRp40HDWBICyqe/zar6sDbuJLV5zVob9oITWydBUmouqJWJ/+5zGdUKoAxSPRbB70bMXWZbk4227IuzXqzSpJV53lmqc+iECNSjqVeMNvdppNyyPYFm0ZHM5qq+ZbD5msz6jzOFBalndhss5vayr0rve6gXFXKA9ShH4yR+jmhc3xsrAANkkOmdj9eRtVhWGxL+gnEZykJgz0NZDhTliZy6rYmNvDdCSMc4d/vNBqZH0SMmCSDrqHTDmOSKBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNvtuNS7zsax2c0byfUGl/QnHQoNx1FpK9TReb4DC/M=;
 b=GKc8XsYpnyD9zMvOt5vCyWGKfk53UcURuPx1LhKXb1+EFxn+Mo8SLcTekjB7zzslQZc8rmT6qDKgamAEx99+S+DU7lczeyhJPjRVxAOoJsY8DCeytKuHNQ00XRCJBMRUMiK3HPbNll1U+b3DBucnpYIUqtnyOi/dFiRKZm6wNIQ=
Received: from BN9PR03CA0391.namprd03.prod.outlook.com (2603:10b6:408:111::6)
 by DS5PPF78FC67EBA.namprd12.prod.outlook.com (2603:10b6:f:fc00::655) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 03:42:42 +0000
Received: from BL6PEPF0001AB4C.namprd04.prod.outlook.com
 (2603:10b6:408:111:cafe::35) by BN9PR03CA0391.outlook.office365.com
 (2603:10b6:408:111::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:42:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4C.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:42:42 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:42:36 -0500
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
Subject: [RFC PATCH v8 31/35] x86/apic: Handle EOI writes for Secure AVIC guests
Date: Wed, 9 Jul 2025 09:02:38 +0530
Message-ID: <20250709033242.267892-32-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4C:EE_|DS5PPF78FC67EBA:EE_
X-MS-Office365-Filtering-Correlation-Id: fa048399-5285-4a87-6dcb-08ddbe9aa8c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S0rV95lVsl91e92JET64YpBieoNVE1Z8TEYeQwJAfbO2dksySm7ztYwZmTSF?=
 =?us-ascii?Q?QqTI7Je+YDpzpMD4/GRu1H91bCXMplq9TDTTYq3pgAj7Yxk+6a+gqBZk1iMF?=
 =?us-ascii?Q?p3hBh+xOMegnd3tHx13NNzXMdbVOMtHZ6UebIskV1QvyQKicr9fM8Bpeqzb4?=
 =?us-ascii?Q?qnl/5Lx+fGqr+96xknvLYE98AIryrXevx5aRNH9JhH7sGdhWv5CKhVHeyabr?=
 =?us-ascii?Q?h+nBMpHOkXZMija2Igz7XGtyFWLLKBgPDN9j/Lkc6YZBYNGTsLzCdDEpfjB4?=
 =?us-ascii?Q?GBG1khbu49ceeS2dMC5LxoU+TSCXCvgSQzIJ+AFX+REk8VQpe1MqYLLfQ6hO?=
 =?us-ascii?Q?0IF2wP5S66q63LDzbvZt8Wgf+8ybm+vEo+lv0t/DGKxAvH2thbK2mF9kpEVX?=
 =?us-ascii?Q?CjkltVYFWzlxP1MQWLSGlffGW+lXaT+dRXPxyYELUVPz/scljSita5OlCK2g?=
 =?us-ascii?Q?yBKIFtoB7BezXQwS0gMXoSQHdQEfhwZ0wWyoTMHx0xTCEsCdkeZZe24siKkG?=
 =?us-ascii?Q?A+/eCwjTeeScNNpltuvGj1uZy+9sUrepEKNlifd1pl48q6M0U2GYDKw6Uje5?=
 =?us-ascii?Q?8HpOXXSQf0FP0AYzmID0qVfuSoSBM3zccj9UIe2Zco5/oHCt0FDwNYuJ6E33?=
 =?us-ascii?Q?JZD92Ju9V7a8RnTa3ckAkHW4LVAvFovmCz+9/EKHCIcOVlVSxtNFLGqsHt/z?=
 =?us-ascii?Q?yYWK9hSxRcIYPsJ8g7h4FWUXREdmH8va/CsUeDTM+AX7w6fm+ihew1S2Ut96?=
 =?us-ascii?Q?bI+5dvkWNf6xG91jmnSZPbNlXR37s2Sjf2/jbqppPRAozml8eOyt0qjHKYF1?=
 =?us-ascii?Q?YXo9y7qGRWcKiHWiIT8NFdvZMPEGSv6zAg1FyYRGb3t8HTGCfM8QsKIXt9CC?=
 =?us-ascii?Q?iTzAh2GJGwwvBDfr5foiQPgUx2Y3TB6GeoGH/3Jm2eaZzw18Zqr3dvNPKabw?=
 =?us-ascii?Q?FKywyGvBfkWggBJSvXsp4KUefSJgUqZOXM0Ein69ZWQAqqKxBkAHLhf3om3s?=
 =?us-ascii?Q?jJ8xYj6cKNEjDodasycHwS4/GbenmoIx27lKYa1QrJTkbT2C+lU7cKln+Ix0?=
 =?us-ascii?Q?BRnGg6YSfJOTqA31D4UzM0XHUL+pkAYRbRzeTrqbOF1tu8mhQGbG2tCpaA4M?=
 =?us-ascii?Q?YzqLmF4zIiGhXfKxWrAwagAuEezPjC9qdpMh4VNnuox3Lau2ju4ZN8J+VbnR?=
 =?us-ascii?Q?JbE8Lo0lI00p1s1naaoLuOpY31USwi7oTPWT7OwzX34ud8FHr1tUwB/wuN0l?=
 =?us-ascii?Q?lD6qFjmutlGLHkQH8RemIl0ZMPGypF7ZYSyDDK1sBw8j5l21DQM+rdALQgiO?=
 =?us-ascii?Q?fbZ6qhpEHoA0qpyCk4h4drkuu+sl5y5zSe6FWBzdER6rVn+byB2KpCSVoXLU?=
 =?us-ascii?Q?k8uyV1goWj9gEO8v+wlwpNoxuqbNzhjbchHEx7hKC0DmHA+naEP9sJ7ynyqU?=
 =?us-ascii?Q?rw+lS9ylX1ycBEpuqWDZhLjLiSNo9TErnqiLCbCLBrsjCVfBlL+UE8641mpa?=
 =?us-ascii?Q?ih7uWQBB0fbsP/JYyBTebDouSfWTdh/wfJqh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:42:42.1991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa048399-5285-4a87-6dcb-08ddbe9aa8c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF78FC67EBA

Secure AVIC accelerates guest's EOI msr writes for edge-triggered
interrupts.

For level-triggered interrupts, EOI msr writes trigger VC exception
with SVM_EXIT_AVIC_UNACCELERATED_ACCESS error code. To complete EOI
handling, the VC exception handler would need to trigger a GHCB protocol
MSR write event to notify the hypervisor about completion of the
level-triggered interrupt. Hypervisor notification is required for
cases like emulated IOAPIC, to complete and clear interrupt in the
IOAPIC's interrupt state.

However, VC exception handling adds extra performance overhead for
APIC register writes. In addition, for Secure AVIC, some unaccelerated
APIC register msr writes are trapped, whereas others are faulted. This
results in additional complexity in VC exception handling for unacclerated
APIC msr accesses. So, directly do a GHCB protocol based APIC EOI msr write
from apic->eoi() callback for level-triggered interrupts.

Use wrmsr for edge-triggered interrupts, so that hardware re-evaluates
any pending interrupt which can be delivered to guest vCPU. For level-
triggered interrupts, re-evaluation happens on return from VMGEXIT
corresponding to the GHCB event for APIC EOI msr write.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 35 ++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 0fecc295874e..a527d7e4477c 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -300,6 +300,39 @@ static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
 	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
 }
 
+static void savic_eoi(void)
+{
+	unsigned int cpu;
+	void *bitmap;
+	int vec;
+
+	cpu = raw_smp_processor_id();
+	bitmap = get_reg_bitmap(cpu, APIC_ISR);
+	vec = apic_find_highest_vector(bitmap);
+	if (WARN_ONCE(vec == -1, "EOI write while no active interrupt in APIC_ISR"))
+		return;
+
+	bitmap = get_reg_bitmap(cpu, APIC_TMR);
+
+	/* Is level-triggered interrupt? */
+	if (apic_test_vector(vec, bitmap)) {
+		update_vector(cpu, APIC_ISR, vec, false);
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
 static void init_apic_page(struct apic_page *ap)
 {
 	u32 apic_id;
@@ -386,7 +419,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.read				= savic_read,
 	.write				= savic_write,
-	.eoi				= native_apic_msr_eoi,
+	.eoi				= savic_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= savic_icr_write,
 
-- 
2.34.1


