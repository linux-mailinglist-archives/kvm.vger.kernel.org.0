Return-Path: <kvm+bounces-26807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10EA7977E9F
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CFA41C24470
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17271D88A6;
	Fri, 13 Sep 2024 11:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HsKGJXaS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA3A1D86C3;
	Fri, 13 Sep 2024 11:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227612; cv=fail; b=BK2vuylyB08hnaZvxQUaKJ1wu5pI75GY45LtYQ3+dFS5ILoZ4p0SC5QyPlqu9U3Kpuw/PlHA/7fbzSQq+Ym23ebrt2HySRZc1C2nTXgjylx7w1aAGA5RtFH/c3AnW9NpsjNWPJaf7+0nENzn/S++Dhg4Y+6rAOOfUcfhrNnmRHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227612; c=relaxed/simple;
	bh=Zj1ZBS0eXXTzwbVm2MXTXm6E9RomlWBOIUf05rVN4TY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CxsYyXllCEms+aTdIRDLq8TjnBhObHoclGpIbq7108hwfcFJwWx2mUuTRyWRiDGFP83szjYOrRQPME+YyKIWrB2pG1JtOsQ3pqUrrBhKxkwMsM8mJhvwp14CQN8BVRRR14INH6+vuZGj2KI0FRsqxk7qjUYSadnO01ldd2h8b9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HsKGJXaS; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GqI2XztLpncQYKnvir4tbYKTC14i3T39ft2Zu8Kr9VRG02hBW5wuXDQKUxkZOWIoPTBlXTzuBruvnxsaO0nTPYlpVTw0q68ODk3LW5xpKM4FjZqT520Lrfb0yzw0rrfksuv+2NYqhHNBgaSxZ1yl7SVkiaL1G+EtkaBySeQqb2lhLn8wOh/E6WYFHEKnJ/NFtnv8lkZaZHZavo6juaqza6tLf0CU4kRGvZBTFimjKWhrkKr9SOE2rpZRfAdnXGMZSWkp5bjOcFbpU5McVQ1Tvh+6OIF0Byjiuv60uyVU99HViv4zVpAG6l7qQBZseawRc/5euYVy7C8T/on7CYmwsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/3y3SrFaMbSPi/DyhjhO3RvzLtokkl0cGjXwzwLaFI=;
 b=DDz5DJTEYO05XmjG8DGh1EZjsImMO4ZBjUhKRstmtXHVMs4RRTr3ps9qWL/628TMy9RahvWYsMgCriY+/ZNyYyle0fUxgX+O0oozwoe6j4pdxkWO/SDWo8ELAfsritCfY+rilLW5HYjMr+IAoddeJRfzGrreKHGww+Y9vkVsmRidYCF1pUde6ahn+9S/Yy1Pv3fUvwC/dDQli4m/QL2IPkpQkSIvEvsQvb75UYirbPX+LeuoC+ODLPx8v8DOreUlm4oBga+1okmIZb7LvxhJcDdoD87A9PLogtg4zr/hLUHGAuFQaP2cyP5NW/9YCbk+HnGZoS/sFnp8AR/siRLF8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/3y3SrFaMbSPi/DyhjhO3RvzLtokkl0cGjXwzwLaFI=;
 b=HsKGJXaSgBjJfFAHafYi0ehr6pzkvqUSqkdqUBeZgI4NaC76CRwvhvmJF1+zlRMttsned2PAYAA8U3DTYUuvOMlpvBYWFNAAMBI4EzQxa0cppFj5q9cC5uGf+x51lIeXtQUtwA6ulG7ZXavmX/rl4AnGGemy1CAlVddnuOqPoek=
Received: from BL0PR1501CA0021.namprd15.prod.outlook.com
 (2603:10b6:207:17::34) by IA0PR12MB8929.namprd12.prod.outlook.com
 (2603:10b6:208:484::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Fri, 13 Sep
 2024 11:40:07 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:207:17:cafe::6d) by BL0PR1501CA0021.outlook.office365.com
 (2603:10b6:207:17::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27 via Frontend
 Transport; Fri, 13 Sep 2024 11:40:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:40:07 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:39:59 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 09/14] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
Date: Fri, 13 Sep 2024 17:07:00 +0530
Message-ID: <20240913113705.419146-10-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|IA0PR12MB8929:EE_
X-MS-Office365-Filtering-Correlation-Id: 6332868d-7f2d-440b-ccd5-08dcd3e8d143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?annqvCskbHoq49ZMH+OoRM0MVZ8CHTgSuQdV/3c0RvYY3h/LL/hgjyPiW7N9?=
 =?us-ascii?Q?3YYD78Zm7Ukm6Uw/uBcY0GRm3iZCv03xUQSTSyOz+yNO8snRTwdW/UiEnR07?=
 =?us-ascii?Q?TmBOYn3qXTm4QR/OnfJUitDaHYQAXWIh+28VZbVttkbhtHI1TPjhya0XK2X7?=
 =?us-ascii?Q?Ff+3O44OwrZaeHRT75KXQjXd0ZNQNgv+EzFmf1cEmseDTwK+iH+7FVrnZ8Mk?=
 =?us-ascii?Q?00LKpJlIeq5Vv3mM9shELJKyUHzlRFFN3dXEptJFhX1oYV7W8FRbZjiZnrtz?=
 =?us-ascii?Q?klIxlHEAx+EfucaYkM3V8cRZs3ZwLmaNeHBquOHcABH13z09WkN3fjpwwDpz?=
 =?us-ascii?Q?v0dZoyFBxzOExqpv84Uy16C80pHo55aFvuyvZaCgeofyQjyW2A7QY8+PplYQ?=
 =?us-ascii?Q?UH9i0DlJmCmXhS/sbl4GTa2PiM79t0lB8IPXyt5lggn59w9t3kI2jBjUN1u4?=
 =?us-ascii?Q?DdudPVOyRQaoaabggYuNYiPStlU6vfhXiZggPau3KCqQ2+clvtmJ95xIB4rA?=
 =?us-ascii?Q?nxz065zijSJHTFPUlrbLh7tCL1ddszuvO81ihgo+m/vIqzYYt6unhZyFfVqz?=
 =?us-ascii?Q?MlwyVLNLpw1eFaqRuGZNgQ4eGv/UdemX202dlI0UiTe4XzIkqqCz5gI0NY//?=
 =?us-ascii?Q?LZrQoyX0p8xznAuy+CuqJVYxUv8DJ/tloZYFdRzVb/JitBIfXwTWBhUJeXDN?=
 =?us-ascii?Q?wlk7/phWfU6sAmx2q7SFFJVvr0WmNVHp/jnQ28P9BhJDLmWV9PA2nefhr19J?=
 =?us-ascii?Q?uM5ppIu/Gmo2CfVEFZNKWtL+iCp5tgjpNgcrWCxnrgo1dVApEptaxKKlVc7g?=
 =?us-ascii?Q?1g+aLADu8Gz9EyNt9QPFdWpGQR0OjwFU7K7qx6XCyNJqfTLTHWDUd4OWNvcL?=
 =?us-ascii?Q?c5+y5iw0D8/GkAst92ttZ4FmoFzBBYD2cHaYkXE9sDL5W7XXCcUhFbh59TgX?=
 =?us-ascii?Q?tTor0GMSU+aWpmhOOKrL8COXEKuqffoYNxtPRuIr5mWrRzfDMO46oKj8UgVX?=
 =?us-ascii?Q?PdoPCrS6nQafpkEZ9YPzo+z3t2lyLnZx7q4Fw+6Ucf1DohIuk4Z/0UWjahCl?=
 =?us-ascii?Q?5GUsKPriaGOB8z5pC4Jjcpky+ZIZypYqaJpNYqIuxpP6iZrPtHAdGTqBDYmr?=
 =?us-ascii?Q?EkuqSTLBt+vle+q/FJCHa2mJlISfN33BDgzfDUJdgXG71j5vyDBsbMb3CGWE?=
 =?us-ascii?Q?j0uMki3HQ35K8rUWYReVfqaH5Q/gYPdokB6WAwfee+t7PFSyCK647ZXFbZs5?=
 =?us-ascii?Q?M+zsOfdljDL5YAed07FaAv8UxwatKyZB3dYMQoZDn1gdVi7aBJ+WAE65crNv?=
 =?us-ascii?Q?9LyZdBQ8Dkgv22j1u/Ig1wdpa715NTSv95rjtbyrtAeKc1Y0780z35E6D36Z?=
 =?us-ascii?Q?XTUyIfFong5xNy1wf/5VgfmwgNYfUNMrGuqNMjmMvb0WuVfRg165FcUZfNrR?=
 =?us-ascii?Q?C31Y6rkZ/lAUsH0bUm29ScvZeeT3hPIZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:40:07.5428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6332868d-7f2d-440b-ccd5-08dcd3e8d143
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8929

From: Kishon Vijay Abraham I <kvijayab@amd.com>

VINTR_CTRL in VMSA should be configured for Secure AVIC. Configure
for secondary vCPUs (the configuration for boot CPU is done in
hypervisor).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 63ecab60cab7..3c832c9befab 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1190,6 +1190,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


