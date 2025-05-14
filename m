Return-Path: <kvm+bounces-46437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D3BAB6413
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B27AC7B4638
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766D4219A93;
	Wed, 14 May 2025 07:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kuYiIywe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11736215075;
	Wed, 14 May 2025 07:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207334; cv=fail; b=fcswHKdX0C4KnV6jk9HCkt97m6jq2RXOAFPT2NCSPHLHe99f6sGF+IxRpnmdZgE8O3inBsYdjVus/pi5q31lfAahGaYTn4+fw48ZeVsGHmVCOvD0rc5myvjOcsexFStt2Ww/RAdGSiTRuD6czeM31HDPhmYUWPksl0P953NwkDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207334; c=relaxed/simple;
	bh=czO76iWY47hWx3B+NYgkj2rMP2CaNKi0ipfccbjam7k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EkeRZEgO5qh4eJebFmImR/+uCw4OUUlSmeXkhSuhNViBjM35A2ETodOhBYHFQjNGnnPI9hUbrq24eFuYzZYh+AcYiAaB2nXQmH1aFt3j+zVF7FAfH+4QglO86RnPOCEKDDsUs7qtfIA7wcxhtMJ1uVbxOd8VoqteSNxesEQJORY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kuYiIywe; arc=fail smtp.client-ip=40.107.237.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y4QWCvsRjmxC6j17rhn5St0rTrcawADYm32b5/iDYoEip8/apEHBqGinusQpWHkcYflcxY/FstFWlUKZm7ea30TEUA7g2UZ70RtDNHaQtUxPkx90X8Em2NOGZocPUyrdS9fH16muGZE2SNtm1ldrO6PZAeYEG5jBT+QaZagzojNToDrUCIGiWsiS2wWARpJwblhwFy9h5tTWfwzeyothasX4HP5qyh7rZOHLlDD/Qnr8LvayOV7j9md9ndFGWw7zq66tHhSypL/sNUqiYIcx7criQtrwqV0oRahfrz+cgpXyapEDsIs+Z2Ol1BLD5LeFQ0eZ6sF0FAHw9gDQ8momOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=neJ3GCY5YlqoKJyr+3QB1JziGWx6Lt81umoneFvI8XA=;
 b=opd1QeF/W9qW6+o8pT5Ok4uC6kyAPc6AaX2eMDTJAnmvDyjQmyAksdXg1ScR8i0LR4pxq2sBdm9IIP5i+ohneUrIG5rLj4I+K5rLxl898gteUSWfHoS74morX+ZvYANr1XCYdg1dPsEnS3Ea8n9a/52dA1m2x35Lm0MBB7P3B34nokDlmL2Fk+Fbt9+MivPU1xC8r+HH96/1nMrBjRMNoCuXIvq4XEKSI+ecsCCq3utPk8KZO+7HhHcybN/KZGkcmzV/r1ZwNWetYoBGmmpLV4WuONOqGcMcHoaT5YG4Gqd/hA1ZLS/5pr2QNEiX4TyPaxNudavrtVodlSwHqonvew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neJ3GCY5YlqoKJyr+3QB1JziGWx6Lt81umoneFvI8XA=;
 b=kuYiIyweHIN1gDolhRsxuKayBN7ZBKYBcLOzEJ2Ab3oI7hQpNEZNEy4bztlTgzBLZhjbR8C+Uo1nIrcvGiDTrHrgp9Moxec5CeGfEluEdR3sVVh5P6glm4HF9BEGFsPioqfETXJuabmpEwXX/YOR5LqmWgbGvkr80udH3H+nHxY=
Received: from SN7PR04CA0032.namprd04.prod.outlook.com (2603:10b6:806:120::7)
 by PH8PR12MB7303.namprd12.prod.outlook.com (2603:10b6:510:220::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:22:06 +0000
Received: from SN1PEPF00036F40.namprd05.prod.outlook.com
 (2603:10b6:806:120:cafe::6) by SN7PR04CA0032.outlook.office365.com
 (2603:10b6:806:120::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.30 via Frontend Transport; Wed,
 14 May 2025 07:22:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F40.mail.protection.outlook.com (10.167.248.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:22:05 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:21:50 -0500
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
Subject: [RFC PATCH v6 09/32] x86/apic: Rename 'reg_off' to 'reg'
Date: Wed, 14 May 2025 12:47:40 +0530
Message-ID: <20250514071803.209166-10-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F40:EE_|PH8PR12MB7303:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ce16f9b-c554-4a3a-4f4a-08dd92b807dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SGwxFm6XOU72xqOGTiLpXY3cV6OaFPyxiuqmuLjqG0RC2j1WoUYkmHgDwPnc?=
 =?us-ascii?Q?6DTS7BD2uH9HpDkneGeguEpC3QvJJ2FpnJW019DVyswUHoUpden4xfPYpzwl?=
 =?us-ascii?Q?Owbu5yi3kGhFJmwiSGx6V561tM8WZJyzO8DQrgKmBVqH8+JQIKhF+rNsiQJQ?=
 =?us-ascii?Q?yv7DiTfbrTAKd9Ph/dZbqo3KgflALqT2plRpmE/T8Np2drWj2CLSITs28Y1y?=
 =?us-ascii?Q?Yt1kKIn/hm99S9YIGqYaf43mjZQ363ARGqRiqsYbd5rijgKewX6W9hr/Au4v?=
 =?us-ascii?Q?SamlcOlfZn8HTmBzctvFoVs76KR4R+X/i0FptJv8R6j4dskHx2rTK511Cddm?=
 =?us-ascii?Q?DnRObL93W7k8ysTkSSqf43eBPOeJQ5vw/BdMSi/BXuJBvWF+jkNqYE527zOS?=
 =?us-ascii?Q?LrOTjjC5Syr3YzxQPuBjk3czm9K8t0FkBZkzwmcAvBEqHQMLAKNBxFgXYayM?=
 =?us-ascii?Q?o7L2Wfou3UiVcO8rZfi7f9+NiPHeMHcv2E1eV6qBhhwtLfUkDEqLe/YZqX5j?=
 =?us-ascii?Q?txgP88qg2sNWe5vE0K+3bqKIHEmLpwF5EN8woyMUVRRQ7b/yVHGhHXyF84bp?=
 =?us-ascii?Q?NcRsGhfyny/nfd1JrQ08VZjcNG7JOi5DZzr4HpnYnD19yQzLL08iWOo+JAhP?=
 =?us-ascii?Q?2ykeB5jC5FWt+AYtMEML4CYaQIIamlmJSUVtjTsEDKpfXSKfivTKQU9aO3FL?=
 =?us-ascii?Q?9wuPmRQg992XCMYkAzRvWimHIessWVq7huiJBar5dqSy8y6h1H4yyQ/r2SIw?=
 =?us-ascii?Q?hNxyCvV91ZbaxWqJSI11WbS9TE/BraeG5M9H9HaMkYsMCiBHV+3m9fCz0C/k?=
 =?us-ascii?Q?YH42wt0J730wBVGU881zEw8kaM+5SmKQUyYORwAmankDV+jteGLipJuAGARL?=
 =?us-ascii?Q?IRBIbgYcHy3Ju7PChP8WZEF2WoXwej4EwgbD2AOOOSuq4ewEBhXGGWALBT7q?=
 =?us-ascii?Q?Koc8n2nGvdPZ+1+tbphtVx7DUVNNV9fbTpr9j5Jkmh3gHLxZsF97KRpG67U2?=
 =?us-ascii?Q?NRuZWiIzjeJt1KlMZr3dZeRH8MvtGCbc2kQ3Rmg0Kti0hwVL26DIbJrVFDtn?=
 =?us-ascii?Q?KNV4lFXca8sqiUWzD9B3/vV9NRTIm8OTIifkyR64fqgPVgSl9cP9emo0KUwf?=
 =?us-ascii?Q?FvUHCuY0ce7odg3wcCKiDY8gmaAtjC7rT3Q8m7sl6BRrBV7ziiLw4TQfrdjD?=
 =?us-ascii?Q?pj1RIcZnXc5L4vrZpKRWlbdj+kuesr4RXAF64xYxNvqSIgkNkJb10zYmfOWR?=
 =?us-ascii?Q?DAR1xnLCl/eduEAeTjckyZBNchvZutUJ9yeh0A/Hpm4NwGZAPoRFNqZYiz4f?=
 =?us-ascii?Q?SdSNIRy8VilL9CFURupEhfYVb9Pxa/ajHK6OG7H+uDxJmUI/veLMqJ0ehrR9?=
 =?us-ascii?Q?c9rM4iQBW/Iw44Dzx78G0cVzS+V0Y10Q0HGM8yjWmaxH7QD4lXd045lkF+1n?=
 =?us-ascii?Q?1KnfVRPUMurUsXLwoG+pwlAdkRi1aQSPZkI8pMU1uP+nyulXn5zoEzULN0Cs?=
 =?us-ascii?Q?wC7SSW3AvowduN7s1IrZMCZHuh8yYSpX0eFd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:22:05.9341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce16f9b-c554-4a3a-4f4a-08dd92b807dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F40.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7303

Rename the 'reg_off' parameter of apic_{set|get}_reg() to 'reg' to
match other usages in apic.h.

No functional changes intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change.

 arch/x86/include/asm/apic.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index fb0efd297066..1f9cfb5eb54e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -525,14 +525,14 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
-static inline u32 apic_get_reg(char *regs, int reg_off)
+static inline u32 apic_get_reg(char *regs, int reg)
 {
-	return *((u32 *) (regs + reg_off));
+	return *((u32 *) (regs + reg));
 }
 
-static inline void apic_set_reg(char *regs, int reg_off, u32 val)
+static inline void apic_set_reg(char *regs, int reg, u32 val)
 {
-	*((u32 *) (regs + reg_off)) = val;
+	*((u32 *) (regs + reg)) = val;
 }
 
 static __always_inline u64 apic_get_reg64(char *regs, int reg)
-- 
2.34.1


