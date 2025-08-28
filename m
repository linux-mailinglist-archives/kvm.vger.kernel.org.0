Return-Path: <kvm+bounces-56098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 363E6B39B41
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BB301C80E87
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76B430DEC0;
	Thu, 28 Aug 2025 11:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1QEZs8Y3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0E030DD19;
	Thu, 28 Aug 2025 11:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379622; cv=fail; b=BFd5O/eIzAcwCMH88LVcEpm0dQcrIksvnvlR6VWyZlSTMnkDcJ1B3qqefsXfiA/Dd6JrybuzDSHuMh67poFnXE2GOukkTZJe/wDteUu9JNODt4nH7ju/3w/yXCyaS33r5bKZM6rOKw8e8oBcgnbtw5hBvh93+MR11A1tgkiOhdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379622; c=relaxed/simple;
	bh=DSdMs4N+Gw+VS3WGSAPPF1MU2bfTe06HZnhCK7sLhb0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i+euXb4jytEpDQ5BDVYhruF0zY62gfr7AQrp94eD477lqVoCHWigHHUkiQR64ifMLoxQTD01k4p0L3Tdw8M+MUBUhTBhZeQidGQBx0gHEjtbUVr1mG0amfYmSOrr1kWb7T2E2+5qI+LLtx+SurdOy9eejHDtPiiRE/FUEoRy64I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1QEZs8Y3; arc=fail smtp.client-ip=40.107.93.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U1QyYIq5SpJcc5o6LaqMVQfjbTCp7jXhXy8KcFX5VZe8mSnROUCoOZppqKP146oBBcpMFEfAQEgqehvqBvSaEJ8kRbW0jRwv0UmmzF8coPuAjWso8aa57Lkj43lxk0wFgYLJlk4wlPT6kuNY2ZwFKDH1N02Q3PRADRRBNUdljr0qSyx0wY5ySWE9wbO/ZqBhuSl0NXdq+Co9mHNTxH6MzzGQuTwhIxgZNj1/LmItLy7KntrobgMrp0xC9GCKLegBeCJLljUg89vuiTrZ811hRCFGSp47pdFMzW/vhQ0twkHQIOTCVdJSDhKhxHf1M+9Zf0ZEcXfnCkm+re4ROA0Nbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egHe4oAploHMfOVAfaOLRB8c+8URuSUICtnFYwuJW6c=;
 b=Eqi3t+/YgEJZ1ShK4j84VSIDeTAK8kYNXz3+jVc7eJcPWEvNpS817dBc60jBGhLZBPsB9wKUfiXqeIUWursOTwGtIxGU3cgsGmgNISU3xHYa+Sf+a1JwXQ9QLUUDqd5qTNeJAbeXnH9Nk21mmuOrOUl6KHxiwgm8sXQl59gWakGZuMFzhxUu2ddTVE+IA7TMN+mfBXDh+XX6dQEKX/ISIH+hX/4SN8lkl5Bi9EBOXivphu0hy8MVmJlx/L1/iol7fT7/SVn4PLQEzJVdk+CRRQFGH4/ovoAwoNVwjnD+WzAYge1FC0OQ6/WFUrv3u/Qp0aLLiMu96qt3BVRiccQAVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egHe4oAploHMfOVAfaOLRB8c+8URuSUICtnFYwuJW6c=;
 b=1QEZs8Y3tDUEnAruSr5Ue+wgUeRca9D//Nf7XP+gcHcSelBJ4mvsddmwCuteZY8sqP+LX7Kw8jBc879c+5YRbHPkrPm9bnUY/bVE0pFLwDmodpTToq72lY+UM/CoQjiD9PLQWFkXLWiYm2b3cBKbWKn6y/Xr+veO54VVo7tZ4QQ=
Received: from BL1PR13CA0148.namprd13.prod.outlook.com (2603:10b6:208:2bb::33)
 by SN7PR12MB7297.namprd12.prod.outlook.com (2603:10b6:806:2ad::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 11:13:37 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:2bb:cafe::a6) by BL1PR13CA0148.outlook.office365.com
 (2603:10b6:208:2bb::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.6 via Frontend Transport; Thu,
 28 Aug 2025 11:13:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 11:13:36 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:13:36 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:13:28 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 12/18] x86/sev: Enable NMI support for Secure AVIC
Date: Thu, 28 Aug 2025 16:43:15 +0530
Message-ID: <20250828111315.208959-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|SN7PR12MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: a558b3c6-a320-407f-9811-08dde623ef2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y5m1r+4gMQFJWH4r4QNbCdaeUwmakbiNPWSlFEGOV2FAHJESFOrOqPWprOQR?=
 =?us-ascii?Q?m0vVy7BnZh3otOa/DPGS98+q4dEpETTZDYaQ0BxxcHLLz7UW9QiConWYA3Wd?=
 =?us-ascii?Q?FAbQ3PtFGq+y2vVq1hzsBdGlkCQc+Gz8jszyamCSHrcIoU0i06LIIya22ADt?=
 =?us-ascii?Q?gI/HNeCtZ88PoCcII21nt0zrs+1A9vuIVX8M07MBdRoCMwVL2PH6N4yb4Nsv?=
 =?us-ascii?Q?z5NoISbdM81sJ29wvKfx2Oc4NM9WLgZzwkrCRv+sba67SXYsxGApSG9Jec9P?=
 =?us-ascii?Q?V7JETqL3qOUSyBLG9arBqGQqt+qORBC9adDndFCrU0GbDhtee5fL1qD6Kiqw?=
 =?us-ascii?Q?zIub7o6RFpIC4R6+I38ofwhVknIycnMlP5/I7ecRQcGm3c8YqCkbqKHDuIPn?=
 =?us-ascii?Q?h+F1x7v9TLqLUJBEJcvKHA1zqe0SXWISyonC/9tsfhh/Ee7K0DLPAb9EX9qA?=
 =?us-ascii?Q?DZoXWbQeQr5GCX06b+R7bYxgdJajWZudosqtCW/dD3U5lyWNfJHGFJSyyZMg?=
 =?us-ascii?Q?+SuJuxJvNu+VG2D+iTJ9mBDi8Jiu7LKlB2dbBDMIlR8A6EGurYhBO99xWcaV?=
 =?us-ascii?Q?pFH+t6uXMM3TBt7Z92PUTZHtH2nM3UK+6g72m0DxZVPuqT49clEWSL93cxa0?=
 =?us-ascii?Q?h7tXkjc2+8XFNnKSwjKt9LEnItHEcrg3P07dhutRb9iv20sUEsshXYu4DJua?=
 =?us-ascii?Q?mq5kgeR1DFDzVxeC5NGgXP94Leivp3zcNpV2pH6Ar8l+iySrujvTGh0jHuE7?=
 =?us-ascii?Q?D3lNNw3EoD98yabjxV/Gc/dx1DymZb4F+SDWgIe1fA0LuY5Gt3sLxu9FP18a?=
 =?us-ascii?Q?vwFKRExjCFDjmXtezV3P/6tyHvqKHoZOhB/9Wp9QrRvxblLtriKpBGIGMb3A?=
 =?us-ascii?Q?TVI6gcdMGGviDkXoiJytDKhIPjk3LXOFLSt9ELfbDLNvBkrpkLeodocRceV3?=
 =?us-ascii?Q?WaRDJgmTCZ4l+KIKf9t5u9oO5t2FlFlRWQqTzkfa7lEZpgJlYhm4YPMHUJZC?=
 =?us-ascii?Q?dkBWr2hq7j8WE2W3MABshaAAiTLxeVEwgKOdWcQswREPTOxvrwvCrEuTxFwH?=
 =?us-ascii?Q?PuxOF31dKyuF27MC42FFc2AVk7W8eKyJTr4y7lbA7Txg1B8JGppFYzzTaVSc?=
 =?us-ascii?Q?Tj330U1ndXiaL1h3Of5vRvK58ax3DIUjmmEGUiH1PaPwgXlsJc08+c0ruTul?=
 =?us-ascii?Q?dbHqVfVA0vbY5GrqG5x80CphUJlr0GTlQ98iY76VxnoS1dzgapw1YTCRfwXB?=
 =?us-ascii?Q?0EsoLMNfwDdk9+i1bmtHTOZVX1hu5QCe8i0mE4Y4Z8d8ZlBc3ixNnfwRcpDS?=
 =?us-ascii?Q?7tqVqDNv7trVhyAi3ZzAS+kNa80I9+ALb6Zp6bvUBuxLVLNduZ5v8BP1JSZf?=
 =?us-ascii?Q?AJThDTUkOxOFeISAdN5cq0b3qsJbFNMzzd2XqLGTSfdwD0GxJQaokPAyZcHx?=
 =?us-ascii?Q?yRlknox44hKXOcpAhz/fNlpnU3E+yG8nHCkawgLerAkV3iAl+6khhypvaPV3?=
 =?us-ascii?Q?DzHOSDEWlXndZG+AubWMPWvxfDGqKCnRWabZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:13:36.7038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a558b3c6-a320-407f-9811-08dde623ef2d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7297

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
the hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL
field of VMSA to enable NMI for Secure AVIC guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - No change.

 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 37b1d41e68d0..08f9a9ef2c19 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -975,7 +975,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip, unsigned
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1


