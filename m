Return-Path: <kvm+bounces-51839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5919CAFDE2E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63406581D9E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA5E20C477;
	Wed,  9 Jul 2025 03:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hIBeHRcF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BDA20458A;
	Wed,  9 Jul 2025 03:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032081; cv=fail; b=ZasQzffaF1rZJ/h60CKnjTJxcW+wSBptrZmIrM8okN3U+jp6/SGdF8TCKxhBycv0isTGXuWCD1/ZfP/YyE2d730KXrqDKP52F0a3K4bCmiZUsbUb7Qk/fLAKmRAEQhKYnO9OeLKdjORf05e3v8xMCGiw5HMt3SYyK7WNsmIR/uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032081; c=relaxed/simple;
	bh=ld56DKkbc1sCtOLiIgC5ZKda6CCmaW19KGsI+nl9XGE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NT0lHrT0HK3068/4UhMD63TUZn5wyJzf5zQrBPrnzsTvQBm71dwvv3gQY9ETTLWmY8FR1beQ0Uj9GyIsLDmlaj5f1qOgOtay+e3GfVrilj7AdXtxJiXQ1F2tzEj7jo9pXYUr0ZlhMP1umTKzSPp2vKBKmxFx2/aTBeerOPsvFTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hIBeHRcF; arc=fail smtp.client-ip=40.107.220.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DvJbQwiiRYlaJiZvPqF+WcS2bYVs92OWOSde/62Ziz6ZJ3EeNBnrDDlpRLax5gHUHSGxIWe21UssesBJB453iScc+kPZViL+/x4Q8o3T/iCJZjXEnw0Ob/fkHzzn0+jbX3i0nx5WpSRP6FZPkcmMZUDu1TEMaRZumRlKveHm+J2NrVkwNvOBZx5UV4ffjfmJgjKCyNSVZ5uvD55B0jbDgb8fz5goMQCJr8b7z0xcK4GxiXZ/IfCXmJQvAsFAkhi/fbp19gLv/DT2kcn4Hg0jpqTwco7o+HMSqrJBpeMnRoOlC5LkuT/aMhe2YlArkkwSPI6QOrfRNKPNtTbq1yOz0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2Y8tKBHaD6rzie9nKksMpUhMc7MRiayVkcbJrPBqok=;
 b=t6CBilKWuKZwB6WKhl9tcMeeNxQCRf9HCaOeRV33U3x265EPkiIc5Wd8fzi8XhxbdAleoT9dBM2SjuODLXYOwtQ7tpAFMq+f9u8M0/0DuSSfgEc4n2Hew3IBUafXqg/Q1Ld7ejxkFxu7zWfMSIyqpy2p/jEdmHmrtzkByVYQMyyE2jITJO96SpTfLaDmq15Z3h1moWPBPRiPohtl58Rikj8wjOryd59KS4O+b2+PmVjlNStUSb2Q4WSa9QosdtEuLWwEUb2Yg1d3uqpRJuYJsv/a9E5+nBwwmHBzi1C60RlmpvAG6C8Kv4JT3CoJpDcsR59Y3+M9Tm6BP4OJpVgxpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2Y8tKBHaD6rzie9nKksMpUhMc7MRiayVkcbJrPBqok=;
 b=hIBeHRcFCDJU1MfZXY7wZVuhQXSEuIUEyWkZx/zXMhu0lhIyxaOKFixl0vd4qm1YF+3wpSXU28g3q3M9Eui7tKmyqvmhZyCOMNHdsRgQdG8jFtM6UeJSOlBZsQyU8H3TsXZhA3JTg1Ac5iavDMNkYSlHiimVkI6awmTXM6z6p0E=
Received: from CY5PR19CA0094.namprd19.prod.outlook.com (2603:10b6:930:83::20)
 by DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:34:34 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:930:83:cafe::ce) by CY5PR19CA0094.outlook.office365.com
 (2603:10b6:930:83::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:34:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:34:34 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:34:27 -0500
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
Subject: [RFC PATCH v8 05/35] KVM: x86: Change lapic regs base address to void pointer
Date: Wed, 9 Jul 2025 09:02:12 +0530
Message-ID: <20250709033242.267892-6-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|DM4PR12MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: e24d2cdf-715b-4685-c470-08ddbe9985fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|30052699003|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DIWwM+1zFWZNuGzFiP43A3RMSyS71PZFTNIP4RFhujQd/WomDsXRso84TZfq?=
 =?us-ascii?Q?0OcAwvLjcLwh0vP/aN3OXTPdo4aRKYiRLxKpDNrlOWvxsHepO/QGX2vJtl5t?=
 =?us-ascii?Q?Do7438yXxkCjywjSf0C+rdR/wb51PlzTxEI/9GKCPs9u+FApBoWmM+WrxIJF?=
 =?us-ascii?Q?NH+4NO5LLazj8gi5325sadvvGoZjdTu5cWL9uQWU1jX727mdjk4II+nvpMSV?=
 =?us-ascii?Q?gSj2JTju+dUNQdjpuv5+LAsOki6RmwQucbGPacze6xVdYYzGBHgLjC8S6XSN?=
 =?us-ascii?Q?S/H3QCP7f9uNk2uJt7gumgfzu5xyfQHCkFX7WzRGMZd9+OyZyK9dvhrKV9sV?=
 =?us-ascii?Q?fA62y8GQw8ZsRV2J/3WBJXn+s8/Zx/xn6qvtIrPIniVWiQ0ex3p7WBNfST2D?=
 =?us-ascii?Q?9+NEgTnC2oCPG5X3cdbm/QBFYDcji3kqpnwBr9pG08v3kK7LcIkc8JUMbFtF?=
 =?us-ascii?Q?zcdwI23fHVUxCDr4I1bIq2HF8HVXVVGEYnpU/2L74wFuaGRqHsuryrw5XUh7?=
 =?us-ascii?Q?8sCs6KkPV+mdzrhU5QBBk56NpZpvXUaprkGlBSWuQxdHAb2nG0NaDIsWHB2J?=
 =?us-ascii?Q?4nntHv1I2U47x/R4ogb4nkons9u+gUfN7/6h0i9eAUTt19kxywBmetqaJOAf?=
 =?us-ascii?Q?7BZlMZ7Om8lOxqq+m6fDaANXosjfHsondFjyL7qPqtNh2cewIZOlZ2iudkFB?=
 =?us-ascii?Q?9Oh4yqsp+39I1ASGTCLx780Iy7hF9qXnJCfGCaCGLhRIYsX+e6UFJKkGjqJy?=
 =?us-ascii?Q?ho7tO46AjpK5E9TyFuKy+mFlTCTqGwY73OT03uuOY1DwF5gQFAjWi11++0LD?=
 =?us-ascii?Q?fhvDIGrbNfiSOuLtKn936ERrUntgVQ0wyy9eCtjMTJysf3o9XBExLwnHzw1P?=
 =?us-ascii?Q?o3owlP58GUUxSTlVDrjmvbsd48LjVpPHH8rzpAj1n/MbRoJOXvUBO03s/Pk4?=
 =?us-ascii?Q?zEHlMwZq/f2ABHpire9mmFlb3wQwwwnN1RttBElOBUJK0YLpfj5DgmJvaHWl?=
 =?us-ascii?Q?tgdhUEoS6/te68CcQvxUhj/DoGzvgxwwTcuv7+w9DZrKPyRHY+VcWIwZnjI/?=
 =?us-ascii?Q?M3vArdUbOA8eoeJbbXgxSD0GfHNNPTyDZEqBVUC0jazW67vJ+2cjYzIrLzpR?=
 =?us-ascii?Q?qMJaJoNvStrqNQKdXB5SuvTfcdJ4hr1/RrQbOFhQx3PIifx+SI7SQ/UHQmPW?=
 =?us-ascii?Q?bk3Umg/TsGNWy1rCkQRYB/50M8FABDadRjiBcw35sc4DhfA6ofMzg7opvCN8?=
 =?us-ascii?Q?xI/Tgm8nDlZhsPNGS7cLgZjglrKQA9cs9X7unEJc7UE6uoGWsOC5ak9UwIt1?=
 =?us-ascii?Q?wNYLMKUIaD7Zktqw+uZ1Nf5gBo+Vlw4Yl6Gqs3daWQ92laP3SY1E5c2Q5XAl?=
 =?us-ascii?Q?164UwBFmQnTK0woz57O+kyAoKpCenJWLWP+WD976VjwYVNb5h0RaYyEOt8kN?=
 =?us-ascii?Q?l4A2/Vh3DYmvZm3UjJ23S3B7vI+L3eTqnkemGo4QSwie3Ny7FwtY27Yn2c91?=
 =?us-ascii?Q?ii5ZY4jOnCBZmV3XXVUqqasUc9ldXj/EowiT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(30052699003)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:34:34.2868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e24d2cdf-715b-4685-c470-08ddbe9985fd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6302

Change APIC base address from "char *" to "void *" in KVM
lapic's set/get helper functions. Pointer arithmetic for "void *"
and "char *" operate identically. With "void *" there is less
of a chance of doing the wrong thing, e.g. neglecting to cast and
reading a byte instead of the desired APIC register size.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Commit log update.

 arch/x86/kvm/lapic.c | 6 +++---
 arch/x86/kvm/lapic.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1dbc1643c675..3be5f0db892c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -79,7 +79,7 @@ module_param(lapic_timer_advance, bool, 0444);
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
-static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
+static inline void __kvm_lapic_set_reg(void *regs, int reg_off, u32 val)
 {
 	*((u32 *) (regs + reg_off)) = val;
 }
@@ -89,7 +89,7 @@ static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 va
 	__kvm_lapic_set_reg(apic->regs, reg_off, val);
 }
 
-static __always_inline u64 __kvm_lapic_get_reg64(char *regs, int reg)
+static __always_inline u64 __kvm_lapic_get_reg64(void *regs, int reg)
 {
 	BUILD_BUG_ON(reg != APIC_ICR);
 	return *((u64 *) (regs + reg));
@@ -100,7 +100,7 @@ static __always_inline u64 kvm_lapic_get_reg64(struct kvm_lapic *apic, int reg)
 	return __kvm_lapic_get_reg64(apic->regs, reg);
 }
 
-static __always_inline void __kvm_lapic_set_reg64(char *regs, int reg, u64 val)
+static __always_inline void __kvm_lapic_set_reg64(void *regs, int reg, u64 val)
 {
 	BUILD_BUG_ON(reg != APIC_ICR);
 	*((u64 *) (regs + reg)) = val;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index eb9bda52948c..7ce89bf0b974 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -165,7 +165,7 @@ static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 	apic->irr_pending = true;
 }
 
-static inline u32 __kvm_lapic_get_reg(char *regs, int reg_off)
+static inline u32 __kvm_lapic_get_reg(void *regs, int reg_off)
 {
 	return *((u32 *) (regs + reg_off));
 }
-- 
2.34.1


