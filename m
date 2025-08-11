Return-Path: <kvm+bounces-54398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E02D3B20455
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E292A2A0869
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09043232395;
	Mon, 11 Aug 2025 09:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LllLQcyg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2087.outbound.protection.outlook.com [40.107.101.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC161EF36B;
	Mon, 11 Aug 2025 09:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905723; cv=fail; b=mRxOrDEakf236hmPN0Kgv0MDBELS2JxdkbasgbpcN/klGJi2j7D1wB33jCStfryjJ0trCBRQXuB7isVU47qSeRUaW8seR9XKKTtzQOiT0AW86SvEtcKD9u1yuADQ/d94PH1aizAQ9ffBhbXezW11cjJ4HY0Qkgp+EbxEDA3lCvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905723; c=relaxed/simple;
	bh=QcFW9X8PQvWF4S05pRTlu3olpeieYWhGn7EYhGhwzks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dC5u9M3S8ycbrEqoyg2CYPcnxa3PqKnRO3h8CxfgyYCCZ/mjAFxzbz47ViPN7ArT4d+KiDxzCxCFFLEctQeUHxcTytyeFtyXAUdvYZzWnfuxRoAohXoE85XpMgRJjgZCgFnhthkFy5o+xeRkACizdZ1WRYIXlTSjRDCbA41VJO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LllLQcyg; arc=fail smtp.client-ip=40.107.101.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HNdzcgoSX3OquSNDfP75NK4I1O6Sr/etM0Yec8neVoq60PS6kq0HLLosl/uTtFa1vXNVP1POQkBAGtKklvGSC2+aPuTDf1KEkiNk3lPQj8ew/GfTZwlz4o2iaUsmFsdBJeoqZcBBs3XitB4jKwBLu/tv5oIROv6O13Q+rzc2eKxgRzWTcdRC+M5Oh0DzKCsKNFKN6GI1k4lH9bqbvb1mjELu6LH8rf2WaumsYuJgQJvxZem/S9stvfbqHEyRbCpaOVgjPa0w4zwkxGsHg+kI0Mcr7Mh9FVd454RqUJeld5VuWm4re3DjtJce3UiULZCFTk8omaTUIQ6CC5sfL4tQnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mlIhzD3WZX/SzWktFKkCc4iAdE/XDdlKNSoYBUR5R8=;
 b=cX+uLPiktahjsxt6foNNxwT5J/BtNKagUNk7WQnvoPvr0s9yyvRHkSImQQMmh3JLb6tEt2vF2NJHi+fK11TnyGmb4ThZQfza+vhuHR/Nv5MByhosPuggdord73btIRSZdrTW14wgcmGzER7dr1Eg5CvZsMOkyJm8P5ooqvio+p/YPzHm5FCDmXP0h2JEjgTR3dc/3GLIrZ2KzMBruMN/XgStPbaLuPPCemstpnq1Ibly3bKm6Q1f+xeDvKAhGurRxEalKjdfo3vxNmOhlTd1s4AYlIi2uVQdcXKNk/Ccm0RYz7MSFyEEuLCTZtiT0xyz+Ft1mIHABO8073X5oXeEsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mlIhzD3WZX/SzWktFKkCc4iAdE/XDdlKNSoYBUR5R8=;
 b=LllLQcygGTpPprcACp3CiVST6Fkh5G8poOs1aP4WwK1ehh70mXmdYHa0BS8SxsYVHJpHhzOj3fxCn0+KXo84e5EAYp2B9lajN4c8/kWmbNhdo5TCp5dMtlRfvY0ywl+M+3c+HGGNoEneRK2ge9KaiOC7JVzalSchjOysT9GN9Aw=
Received: from CH5PR03CA0009.namprd03.prod.outlook.com (2603:10b6:610:1f1::22)
 by DS5PPF5A66AFD1C.namprd12.prod.outlook.com (2603:10b6:f:fc00::64d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Mon, 11 Aug
 2025 09:48:36 +0000
Received: from CH2PEPF0000013E.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::59) by CH5PR03CA0009.outlook.office365.com
 (2603:10b6:610:1f1::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:48:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000013E.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:48:36 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:48:29 -0500
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
Subject: [PATCH v9 10/18] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:36 +0530
Message-ID: <20250811094444.203161-11-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013E:EE_|DS5PPF5A66AFD1C:EE_
X-MS-Office365-Filtering-Correlation-Id: 545fbfdb-5c36-4602-434c-08ddd8bc3e53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+u+mXbH0IB8tGHUgITUr2S0Tvi0l27WUeLNEf8jptyB2UFX7vA7x45SL4MVY?=
 =?us-ascii?Q?sGO2IgAfpi55o2cR6nVa1+6lv0HU6Oyw2xhTMiH+yke8KkbBckrQ/vKhHbBn?=
 =?us-ascii?Q?4sazQnVZMJN+JrTSXzhP0EwlT6vtcoRQHWJLB4cjkpFaMS2/WnNW2pzFXu1k?=
 =?us-ascii?Q?PjRBWb2vZhXjnRoUJXymghH3X/BiYZScZXB2DmgwgJ1NHIGL3KCFFg28qgvL?=
 =?us-ascii?Q?5Q6ZjOkOaUa9I+FXsiCfW98N0dXUGgHq2KHsxo5Za2VP6p7hqt8es3bT6U/J?=
 =?us-ascii?Q?zbsDrmb475QwbaydGXX9NHBSeH6g6MF5+r2P2tm/lnnD4XTGuI+18J5bbtEe?=
 =?us-ascii?Q?o/SawUNSM02FWXYz9fklYIWGBXZGy4itU50XUPp5TIrL+iTA5LlpiUzSfUn+?=
 =?us-ascii?Q?JU/dvfszYpOyo/T7QeyCMi0D8hl6f8EG0Y9cMFMNGCOG29u5WLlmKNvpbs21?=
 =?us-ascii?Q?1Aa5viyU2+cSr7k8gQig7fSYXBMHUtn8qPhWMu5MKWPiOTniPL+bytO/kIgt?=
 =?us-ascii?Q?0NbRS0RIJf/VDF94xDNLJOJZd4J1d03CY9UWybjckP/t5n8GWJ/6Lg61uyTR?=
 =?us-ascii?Q?MadeNyQZqnKEHkA//HT81DkzeWlF6nDkeyRk64zRUSqyeVwdVR0fvfXMtyA8?=
 =?us-ascii?Q?Onn8VndE4Si0QQ1TuY8iK4nl1l8SAUj+6dTOFAiqguIcZwUB0NWQO2LYBned?=
 =?us-ascii?Q?J+rR/tljFNajRP6AzXhMsp4bQcxl9fxYe4GYWh6IkIVQtZtE/i0EX3BG+hW4?=
 =?us-ascii?Q?EhZ2wMC4YndZf+cTZGoriDjGLAzwZprK7l2g5iQpTN6aK4KceeResX6XYtHx?=
 =?us-ascii?Q?parvATGSu0G/dys7eN70u1uD13g4iIrUF7L0jjBLYxDgBthqxzO0caYXH3R6?=
 =?us-ascii?Q?uDMSHUSs3QbNWV6HTYruxYmEhN15H5HTub/qRblV/UOQa8Vfj6nN5EdZGGJb?=
 =?us-ascii?Q?EH9MaxCOCkj55O7rGG58lDV7WvC57cWTemCasCUXmAEvYzBg0KhrtBlg4C2g?=
 =?us-ascii?Q?DRNDtZt/umMBNd9m5uHChsHVf4iY+aM0lEveOQfZ9HXeITRixyZ4amZOy7Y6?=
 =?us-ascii?Q?GJQDcxQSTGkVVsSs85tYhgdjPSMBRvO6ZqjjIYOAEZWTpVz7Gu2G836IZhoo?=
 =?us-ascii?Q?45QMuOWO8TjzIz8j6nnDHoLaE69hqvwMD+8Upc1dv5D/Dkk4CVI+hG7nXvoK?=
 =?us-ascii?Q?pYI77PLLztn0A/8zRHYZPy4N6iT9HFAj6iejecIxq/n9KyejPuW4EHBGzlA5?=
 =?us-ascii?Q?AfU7vG6eHxdfu387w3vCGrjIsIT9/xrzP6y9twyjX5vNJXFQtjSPRj/PL+Jn?=
 =?us-ascii?Q?2lwZlPIt3BzGKxJ2XBzA03HzgzW9O4VOb+5ivl+KuJpftrAbtZTcivWuIq/O?=
 =?us-ascii?Q?28LJuATeMGldxKR0vIyUK4KynwNjIpdRQ5la07ASqQnlMFv2V95WmQocUWzI?=
 =?us-ascii?Q?cPGc+ItzVcngyy5E29MUzVNfL/lA8tXj56fbkRnQayfvYG4zTjklwdduLdKa?=
 =?us-ascii?Q?xHaWOfXtHbjSBhRJZVq4T/bgFHphewMZt6BB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:48:36.7037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 545fbfdb-5c36-4602-434c-08ddd8bc3e53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5A66AFD1C

Secure AVIC has introduced a new field in the APIC backing page
"NmiReq" that has to be set by the guest to request a NMI IPI
through APIC_ICR write.

Add support to set NmiReq appropriately to send NMI IPI.

Sending NMI IPI also requires Virtual NMI feature to be enabled
in VINTRL_CTRL field in the VMSA. However, this would be added by
a later commit after adding support for injecting NMI from the
hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.

 arch/x86/kernel/apic/x2apic_savic.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 668912945d3b..62681fa4f1a5 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -124,12 +124,15 @@ static inline void self_ipi_reg_write(unsigned int vector)
 	native_apic_msr_write(APIC_SELF_IPI, vector);
 }
 
-static void send_ipi_dest(unsigned int cpu, unsigned int vector)
+static void send_ipi_dest(unsigned int cpu, unsigned int vector, bool nmi)
 {
-	update_vector(cpu, APIC_IRR, vector, true);
+	if (nmi)
+		apic_set_reg(per_cpu_ptr(secure_avic_page, cpu), SAVIC_NMI_REQ, 1);
+	else
+		update_vector(cpu, APIC_IRR, vector, true);
 }
 
-static void send_ipi_allbut(unsigned int vector)
+static void send_ipi_allbut(unsigned int vector, bool nmi)
 {
 	unsigned int cpu, src_cpu;
 
@@ -140,14 +143,17 @@ static void send_ipi_allbut(unsigned int vector)
 	for_each_cpu(cpu, cpu_online_mask) {
 		if (cpu == src_cpu)
 			continue;
-		send_ipi_dest(cpu, vector);
+		send_ipi_dest(cpu, vector, nmi);
 	}
 }
 
-static inline void self_ipi(unsigned int vector)
+static inline void self_ipi(unsigned int vector, bool nmi)
 {
 	u32 icr_low = APIC_SELF_IPI | vector;
 
+	if (nmi)
+		icr_low |= APIC_DM_NMI;
+
 	native_x2apic_icr_write(icr_low, 0);
 }
 
@@ -155,22 +161,24 @@ static void savic_icr_write(u32 icr_low, u32 icr_high)
 {
 	unsigned int dsh, vector;
 	u64 icr_data;
+	bool nmi;
 
 	dsh = icr_low & APIC_DEST_ALLBUT;
 	vector = icr_low & APIC_VECTOR_MASK;
+	nmi = ((icr_low & APIC_DM_FIXED_MASK) == APIC_DM_NMI);
 
 	switch (dsh) {
 	case APIC_DEST_SELF:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		break;
 	case APIC_DEST_ALLINC:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		fallthrough;
 	case APIC_DEST_ALLBUT:
-		send_ipi_allbut(vector);
+		send_ipi_allbut(vector, nmi);
 		break;
 	default:
-		send_ipi_dest(icr_high, vector);
+		send_ipi_dest(icr_high, vector, nmi);
 		break;
 	}
 
-- 
2.34.1


