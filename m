Return-Path: <kvm+bounces-48822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DDE1AD4156
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:57:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98C9F16620C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866F8247283;
	Tue, 10 Jun 2025 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LoT4prj4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A01F239E9C;
	Tue, 10 Jun 2025 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578220; cv=fail; b=osGmhvW2rtSw+qTfcumeOGDxQPPwq/ra1Et/JLJwRrXZPgSf/sooLv+Kcj/KdPaUNglhHeFCwadRyabdhdpSJFa3y6q3XqUH71e+hlMhB1d1Io4h3cdHzbzgt10UoyjeMDH6cS24pH+v9wZNNCTXmgx8R3IKUYGB+y0nly9nrxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578220; c=relaxed/simple;
	bh=rnnWcM9BSBf98ggPp5LKIjr1qaHvUIoXysni+KR75rA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIgWgR2IcSN7NRSXWODJf8ybdQFUgkwxL3UD5U1FVJm53MRZghVm3qYZbPTtA8exWm2M+xefeby8WS+X7yj7yGzVSeICNSOOLLZuqZWtkqm3xTWNdgY6HrC/9Ydk+yJcQKJZEgybCQ3k2F+1VmpA1y3xatq5mnJamYiJP/t4Hcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LoT4prj4; arc=fail smtp.client-ip=40.107.220.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZUGx0XqlDp+9F8Mf9cj9VDd7FG2xQRpy/xje5Lz+qhaIpGn7CKdknMbg5EUX7Zzevik9UKXdG3TXdX1zOkg2dOeTWOLHOZ5qF3zXpDqjQcoYQpDXKe37sJbfUG+ai1V7BOU3vjKR0aTZwy/KJ+hneopUBH74tSzpG/dSlnbTsJgMgE6S5iVVmJ984btXAztkFi3jsSe4ZDig3TS390rlBQ2/wgcW+d5n+rvuF4ETb8E3jhwqkmfw99LnyPngaE43RQGFrJqeE1NIjDaKw+jyZT0MeDIV/kzo9QJ6MMU4+ufjKT2xmTpOLm8TOKObdvs5BGlDWkLYv3qupBq0YlIn+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4T7Yzah1vQZPCeayMP28M4iN3sYiFOKN+jNH67d86tE=;
 b=pm/5nc3aQvDYuO5LdiXJCceg7qJLmuljU+wJz6xzEyGWrVWipo1GjZL4vYAwmX8Fnyrz7ShAcurzc2Z2tgOZvXGGML2j5ij5sdDAn1AqOA7jhL/nDRVeQ35ceaaIVmCs+SJku0Z8UhgZXFz94BoKSHVc8c3TYvWnehFhp3XJobSq7JpQ+NpbP92hrjjETrtOKNmgMgj+dwEJUyJezWCKjiPi4hEHFIQ8neZjY3+V2SNUiJehFvKfBHqnGaKqjFWw0XHUrNkW95ayEz/9H5CNhjGzZkdwJ/nyrw0TeEODFa7lE0vtv4sstb0ntlHjvbAPPBccON1uOOLqdF+vUu/j0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4T7Yzah1vQZPCeayMP28M4iN3sYiFOKN+jNH67d86tE=;
 b=LoT4prj4IkZV5ccBDZ0c3CWXvoWY4IJVP3OP4oDYo3Yv1xyRE5WJMPP9dlziFtVHLORwk1OGrqi9McU6mxCxTWb4Tm4HGEUqP/zDAsHiwbnRDGcMY0NtD/pnipJxzHZRW05dc+uOWBHJeFMoUqDtdPScSZ2pnt6L1QOQl80Ee1Y=
Received: from CH2PR03CA0028.namprd03.prod.outlook.com (2603:10b6:610:59::38)
 by SJ1PR12MB6147.namprd12.prod.outlook.com (2603:10b6:a03:45a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Tue, 10 Jun
 2025 17:56:55 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::81) by CH2PR03CA0028.outlook.office365.com
 (2603:10b6:610:59::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.31 via Frontend Transport; Tue,
 10 Jun 2025 17:56:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:56:54 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:56:47 -0500
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
Subject: [RFC PATCH v7 06/37] KVM: lapic: Rename find_highest_vector()
Date: Tue, 10 Jun 2025 23:23:53 +0530
Message-ID: <20250610175424.209796-7-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|SJ1PR12MB6147:EE_
X-MS-Office365-Filtering-Correlation-Id: d8bb476a-ce3f-498e-d058-08dda8482fd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8W/Xj3v54ULgm8fvwilWCfp/Kk+x91jit/p/9CMYIeDhPWS5yHFvtq4aTOiI?=
 =?us-ascii?Q?5apTOarp/6CJ58nBw1/Q8UWVc2EEfDfLm7lnx7US4by0XXMrp58BkhMJvs0k?=
 =?us-ascii?Q?serXVXEXJ0tepo1bHe/XeRszJFK7J9dBrBVwCIWt1q0f/o+rkwDgiVi4EZcg?=
 =?us-ascii?Q?O2j28gpkKkvy7WwjICm5DhfJhH0ocbAucnb0aQsJLDwgn112IhJemIZi6sOb?=
 =?us-ascii?Q?12PgYR64MSwLNvf2KN0r440W9yjjqOyKLgt/Y7vEhr8CUltoiojXTKTiczPa?=
 =?us-ascii?Q?e0CUEUBqkwplpLQDAhpgvxMf1Cd5qjN0yMQAKvM2FT+wvqVTjP7TAYvCzGom?=
 =?us-ascii?Q?Tf5zPYsnLWII0B4KZLS4pDsPyP8SKi6urDcIfoiNLz4l8eUosCbAyrhWlIkT?=
 =?us-ascii?Q?xDhliJ6cTXTShbbqTTY67KpInQm/pug8YhVQ685f+3OISxJW4nqfeiwl3Opl?=
 =?us-ascii?Q?slfqgCy5vw1WLUbdashbjqRiKlVz1p1E3mjkzW28CWGjbxcch1LhwkkJIPMm?=
 =?us-ascii?Q?8old7C0IJofoX5o59ieWhuVL17FTI992rGzKUlw1SPF4sfEBU2ALnX5OJrMm?=
 =?us-ascii?Q?HpQfTHw1v7gDKQ+8OaBic6PpoVILeq+V5s+wPAQ42H9MRkbsy8yTjqao61v5?=
 =?us-ascii?Q?CpVIuosPyWlIg/MEV9dJFqtk3puVZS14DrM1+GEzL91zETURirloiYtxoMij?=
 =?us-ascii?Q?zKp7VGc0D3ysesvpmKFhzjkuHVomAJaQDHI7jWXLBzKWjv4XdpfNACpKb+YJ?=
 =?us-ascii?Q?OIIflZcX2CB3lfyqKHnDgusAVlK6uZcYSZwpTorCDNPt+8yzQoBXs4wt3Yz8?=
 =?us-ascii?Q?kIVNSAvpEfX3xpDMthtU93y49/MSmBo787EjsF/ehS/9cGgVjSJTSGacTsOr?=
 =?us-ascii?Q?yPtfRa1mMmqeN6AYN1bzN/QR73So4FEcj26GFyyeDTk6G895CCst50MOOfna?=
 =?us-ascii?Q?Ali7dAmXeBE5+V+aMFj5dDfizhnUdyW9SIxg+cbeBXEilOMerLtBn9Ut0Jvg?=
 =?us-ascii?Q?ODsI/+y3lv1hhdodHosVIEqgolvZ58DgVc7Q1nbtuqv1dGMXgr874Ef6pcGU?=
 =?us-ascii?Q?RaunYm03G8bV7U0NT2N7TboRjI9i/bL15alnIoPcBIeI0eFevH15JBLHq6bk?=
 =?us-ascii?Q?MfFSbMmvR3oPNVUKJlF+sOmGZJJShR33s1ie0hmZYdf56ITy0lbXp4I/VaZS?=
 =?us-ascii?Q?/IAWXTmY/pg8Rygpqu6zpC43GqkqPTHQuSBirFMWC/OMqUUSnBC0ps1uu6Pj?=
 =?us-ascii?Q?CoU/xIO6XZqT7C8UWEX9tZ/j2bQr7Od5xroR5c8J8YoduDDcBKCOCtB33ory?=
 =?us-ascii?Q?OXxdGoqY3pJ5H7cbYef7oIDJ3GAPpEh5a4rZ4S8QNxdJ/HvEWQp62oCCgTid?=
 =?us-ascii?Q?isHrrPZGw/7EDxw3Jnh1GKYqRKgJDNzs5xvBQQPM3+5bWfE5j3iP0y5oQuM8?=
 =?us-ascii?Q?NveuRgCsHtUULiXBsiboPpKbekuNQY4s851j9hnt5J9VIBWxtgsbkAzPWjsI?=
 =?us-ascii?Q?Oh53F3poTAoX1LWzu/yRtsVPvsACXfhP1Nca?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:56:54.9605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8bb476a-ce3f-498e-d058-08dda8482fd6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6147

In preparation for moving kvm-internal find_highest_vector() to
apic.h for use in Secure AVIC apic driver, rename find_highest_vector()
to apic_find_highest_vector(), to signify that it is part of apic api.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - New change.

 arch/x86/kvm/lapic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 27b246ee3ada..d168b5659a4f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -616,7 +616,7 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
-static int find_highest_vector(void *bitmap)
+static int apic_find_highest_vector(void *bitmap)
 {
 	int vec;
 	u32 *reg;
@@ -695,7 +695,7 @@ EXPORT_SYMBOL_GPL(kvm_apic_update_irr);
 
 static inline int apic_search_irr(struct kvm_lapic *apic)
 {
-	return find_highest_vector(apic->regs + APIC_IRR);
+	return apic_find_highest_vector(apic->regs + APIC_IRR);
 }
 
 static inline int apic_find_highest_irr(struct kvm_lapic *apic)
@@ -775,7 +775,7 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 	if (likely(apic->highest_isr_cache != -1))
 		return apic->highest_isr_cache;
 
-	result = find_highest_vector(apic->regs + APIC_ISR);
+	result = apic_find_highest_vector(apic->regs + APIC_ISR);
 	ASSERT(result == -1 || result >= 16);
 
 	return result;
-- 
2.34.1


