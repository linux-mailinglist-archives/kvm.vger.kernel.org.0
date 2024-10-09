Return-Path: <kvm+bounces-28212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD92996575
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9722E1F21866
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478031922EE;
	Wed,  9 Oct 2024 09:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CFiYMg+h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DB2191F98;
	Wed,  9 Oct 2024 09:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466197; cv=fail; b=b33kp66toxd3gIIeSbGYwwiNrU7tL3TmjkHvnPSYm6RZXUTWPU0NQWqY3bj5jadSdnIn3y5q+CxR6vDbh194LqCVQpMZL5XO3Ma8Ru1s9aECYpbcoWXmyvAxr3wwJL+CFwKpFcrIF11FEbWHRnYSWnu14m2IZCx0lsA0HVhLzVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466197; c=relaxed/simple;
	bh=cWaXLEhZMcg+PMgTxZCTtsTDebS7z8QHQHKPYBqOoUs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1tLxFXmMfjJgG3SZX94IjqCFda6lkmdPecyFDacyldE9fedvIdLektjba0CY1XVsLPA/wh9H4XzARONK1NVUwmo249lMQQRPWwFVK+oWlogWudi2PI6LgMXmH7+rjhOLAidE+J1+DTxYewyGNItl9WmE4wCB/pj2pzflFN3qOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CFiYMg+h; arc=fail smtp.client-ip=40.107.92.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PskKdzn5XP3P9SGKBV1slxzo1TWcgctWanXvOJ3ItgHqsIrgVl0cPShOTMFEwMpfXzjq1IWSVUJxbk3qjjG6LgiAZBphaq9W0z6SI5UhS2lG7b99lTV/KR4deyZNJxuY0tNS8OwC/fbSW3YWQtyu8mknshzyVd4cbwUZmHAaru6D1fqK4w0Nm25IzlTBE56Uqufk7am3fyvG/gC5+T+76yw1r9XOEOXvli+6RyHokdkoLRquJZzZjashbX49j6yqUHCxnJttVvOzRFB9jSSC3o/sMBwjPgFsD+Lpwjo65juqMYCBvZLvR68lFTG8n4KOtEdIbhCD9pUPvjo6LvpxLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VeTCAzNGbCnsJxKh41jWXb6cwu0VGsWZ/DJ79YvQksw=;
 b=NcxrfceFFKOZXsauK+UEf28SMdctW7g1mGvfEbI5pWQ7tecC++GthYwp+pCpu0/OFXTJl9J/g0D3lb9yP22nZj7bBiJseVJTP55n1U1HFRGqufZ5pBWvZU6ZTQQ04OQVCzVQ4jtiXMauaNQHqU2mjL0n8iT4QSFaLPOPvIYkIrUkTZTTD8EmyClW/mYGcdBK5cBAoJOkpYDH6PCzoMTPP2g8M7k/mOIfaRiG4Tr7bfFyYGiygjklSRhj3sh+Br+1umNEZB6uPu4sxE9LoenrlKWCQz865Vjr0e2gpGr1p0nLPx/KTdx13jcx6CtLEy4azi5HDKuxjs/Y5I5U3tjgyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VeTCAzNGbCnsJxKh41jWXb6cwu0VGsWZ/DJ79YvQksw=;
 b=CFiYMg+h/ePfJDQkUgbeLQ7l7CdDGR5FAotVZaQHIM4y9fL2E+XrY/tTs/Nb5+ufhanMkxycQkSjG85iLWA9Mau/xKyRY/FKyoWPhhg4PNnYPPfzjHsCtQNFgG6vJmytGbBpbdzJfvU05LVZOSd5cEBKz/3Ei9PABTREXkLdloE=
Received: from BN8PR15CA0015.namprd15.prod.outlook.com (2603:10b6:408:c0::28)
 by SA3PR12MB9130.namprd12.prod.outlook.com (2603:10b6:806:37f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:29:51 +0000
Received: from BL02EPF00021F6A.namprd02.prod.outlook.com
 (2603:10b6:408:c0:cafe::3) by BN8PR15CA0015.outlook.office365.com
 (2603:10b6:408:c0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6A.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:51 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:47 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 11/19] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Wed, 9 Oct 2024 14:58:42 +0530
Message-ID: <20241009092850.197575-12-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6A:EE_|SA3PR12MB9130:EE_
X-MS-Office365-Filtering-Correlation-Id: f4392129-2812-469c-07a5-08dce844ed49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xF2sWa+4kqqX54rbAmzF+moguYPFTnakF2kvC2HZNxItBy5SbYzpGCUTi75e?=
 =?us-ascii?Q?Kw2+xmbG+7+VdaQysAz7DJ7qcvoMC6T0L6CLcyEQbnqefNwF1ou5kLzx6xrv?=
 =?us-ascii?Q?B19pW0qmTze/+CKDC/CFf7bdRi1gS2O8jeldkDbb4GWDkbrbhl2CVf6stg20?=
 =?us-ascii?Q?SJT8YxLtUQuZ5LjfLwfkZA/fHHvMxyaqOitNfBLu4E+yrvEthREpN+ZDJcDE?=
 =?us-ascii?Q?SnIbCHg+6WiL4KBDVEG7UZVW+EBKgYwecgzMhdCErOqygRZPrrqyUkJpO5ad?=
 =?us-ascii?Q?TIUK6N3tm47wvIk/QKM1oX14oPxRJ0DuSkrq+ZEG+JBgPfuNKjjp1cLTsEIJ?=
 =?us-ascii?Q?u3kyP+oGXvWWoX58Rt0PoNc8vHXa7xEGwVNPBMNMU7TacuPaPVnXZqcMc9jJ?=
 =?us-ascii?Q?IkScIpexwROiJSkAFSlRvnnZxSI6KnNErgRnVdWJJvmEbCnbOMVBF6Lc05wK?=
 =?us-ascii?Q?sLuLMeRVdWk2xx0boOGdg9hO8Mz3dIdtEKjCLSlR+JHvvBT+hLobEKCfeWN7?=
 =?us-ascii?Q?DkGEuCTeoN7eToAXjPAhD4lCl7y76KLPXL8t/v9+vej5ixf/tuovRY/h6AyT?=
 =?us-ascii?Q?3ikIuH7BIw1zL2BedMyXuRK4wNjQcbF+c2oiy75KjBXTL8mjqnCvVktdIGKy?=
 =?us-ascii?Q?9txJpZOwyu5d3EHodFCZo36zpNB0ig5s9xKz1vWFr2ubVvHw1qq9g36uFe+H?=
 =?us-ascii?Q?XA5hBJxB6pXwADFzdAUEpIyCUJZnh7Sj5xPb3jqpHT1OwHylfK2Dm2H0JkIH?=
 =?us-ascii?Q?fA2p2zEDQwcuTghcHKj7E8bQyYoRTw/AEg1EfjW6LjraSnusNRbfGOei0Um5?=
 =?us-ascii?Q?Zr4QdOJW9y6DD0P3k1ccygsA50zq9bjn9imR1xLOvI8CGoNZRgrKmlqVB/Cn?=
 =?us-ascii?Q?imJC0EAuHv62Pc19FHcOBh9eOsPkkc4d+RZ/H5OqR+qYY0K7A0vB3zn2kZpW?=
 =?us-ascii?Q?RQDSpahck7K2r5Sv/k1cEcSR26j0topXSY48xuN6F4Dow0GXsnLMfA0rZbfy?=
 =?us-ascii?Q?MeAtnYYJcOgnPcuYDND9Inf/NtqgsfWO5gugys3a/u/OscP9VOzqLUWq3Ahr?=
 =?us-ascii?Q?kcvVpsxQocrgSd3SemJz8FCpR6rKnToRPdGj0cQg6A0yYC5VLwxpstt8BnXj?=
 =?us-ascii?Q?r6cAF7f0nOzN0+cieGgn458CkrelESBCRB/dAfAYkPTFilY7Fpu6FMp2mmGq?=
 =?us-ascii?Q?JPrHwHWpzHHS2kIbRcs/nuXU30Q7MJzQaeA5dIHIIOua0Hrfv7EIod630Cv3?=
 =?us-ascii?Q?5Ey+3MEMMIeBDDL6Jipd9O8HMWcgL2C+3ueknztZeAWpQREKwYfymmAB8Jfx?=
 =?us-ascii?Q?sURwjhlajUI7xgYa9Rclhx+dXQkcPscVaHV1ObeUJwkZLanSkbr1NFRMhIKu?=
 =?us-ascii?Q?mLNfEGw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:51.5236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4392129-2812-469c-07a5-08dce844ed49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9130

Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
the subsequent TSC value reads are undefined. MSR_IA32_TSC read/write
accesses should not exit to the hypervisor for such guests.

Accesses to MSR_IA32_TSC needs special handling in the #VC handler for the
guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be ignored,
and reads of MSR_IA32_TSC should return the result of the RDTSC
instruction.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/coco/sev/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index d7e92fa1f6ff..5f555f905fad 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1335,6 +1335,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ES_OK;
 	}
 
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
+	if (regs->cx == MSR_IA32_TSC && cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
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


