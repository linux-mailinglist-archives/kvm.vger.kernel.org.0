Return-Path: <kvm+bounces-42308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D93A779BC
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EFB17A3A93
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6EB1FAC50;
	Tue,  1 Apr 2025 11:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N0OvwbBt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB101FAC48;
	Tue,  1 Apr 2025 11:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507553; cv=fail; b=Q05P6/uG0PbeWGmYLjP/X3MRoSxI9hOUgVOndQNw9DW/3cLiAt042osG/emIcCzz78pf0y0Jp6oKCd2AYeUjb9dfLLJOjsqd2DCk3I+AwDr697ujDvCmhqJsA20JO0d3Vq45NQaogbiEpBo5UIYxvwLu0V7eGsJEXdN+Ynt0x60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507553; c=relaxed/simple;
	bh=51ZUXKP3AmfBCznIxBo2B5KLs3HtlaS/Jv7jIp1LAao=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdJYiMlABgRB6COL1jc1p+mqaor39WXeI3hbB6XZegZFA7PHV+icEPdzTfkbXnds4y2G+XycNI2fgjxYCqtNyuaOiXDNc4LSVTzW7hNx5bfsyXTT4qUVKlstplp4piBXfzHj9a75s0/PVeyvHqzTdc1pemAhJ7xitMCSV28Gbm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N0OvwbBt; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TzQfz8sRNeRcrepd0JQnc10mIeOZmABk84QD4lQ4s9T3PT7Sfe488QWFI/nnOaZ4Z2GSbpKuA7sMp76vuJC3ESBfL5amn9EE5Fn34S6M+soDQzlTAeqVU2WMChdaVU9CTETuWFWwrtKEB3ndgN5LX6BZn0LGztj+He4CDRQj0ed1iDHFxiDsteAK91U1PYybl7Eq5y+Ebo/z7pLkDGUmwxx3qrWC9vnemI7036RTP2yU1NVVw8O0+DlrvaR581Djk5/ALt5EYbFz4BlUZ1sCIBBFVnwngXwbiVNUkeIOVddXZdlrCk+vm2VC/EQYateDz1wdlSLGv711WOUTVRw//Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFbvPfyXbCcgjq+6/f1aLS+MnqrF759eJP3fL3AAl1I=;
 b=QDZin8/lCtnUsfN7ZdQ8kpv5JrbXsLCJFfsYrqeX+laT4z1qJG6miNf2AVjoDRpk3xicGId5j7wG/qhaIQ9KvpmenH9YCLMpPSdC/tqatwxrkJ/1562JYmMZF4+3R7rL48kV5xtZnhEEqofZruDTU8PIiJfHY0NZYFVmE8oaPmUedPaH7PysbkammDNHPdPAagBra9TM/hwydVDqvFV3TXiuG/uyIoZ+1dZ2e4MfIZTw+r0BjMOebb23yFQC5dZ3xSzlNhwx1E2BBcvf2UIsEhed9t3MkbsOc4dCiFcmLFuweyu2FIMQIKnF4KygztFRoRq03U+LD2HKZEYdB4y4Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFbvPfyXbCcgjq+6/f1aLS+MnqrF759eJP3fL3AAl1I=;
 b=N0OvwbBt1Jmu0F2SrIZxLaY4sHe2BAyg7IAzeaXvoy0zkew09KiS45Ghh1W1KNxAQixHaNh20VpVVQtzkCTuh4XQneEwieywdljZGEs/mfZ75JPO5eq3xvpvEAZZ7C+nr83OfhvUxCeagX7FgEWbZ0T7RDzugmJuqvBmslieqps=
Received: from MW4PR04CA0312.namprd04.prod.outlook.com (2603:10b6:303:82::17)
 by MW6PR12MB8898.namprd12.prod.outlook.com (2603:10b6:303:246::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 11:39:07 +0000
Received: from CO1PEPF000044F9.namprd21.prod.outlook.com
 (2603:10b6:303:82:cafe::cc) by MW4PR04CA0312.outlook.office365.com
 (2603:10b6:303:82::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.53 via Frontend Transport; Tue,
 1 Apr 2025 11:39:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:39:06 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:39:00 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v3 08/17] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:07 +0530
Message-ID: <20250401113616.204203-9-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F9:EE_|MW6PR12MB8898:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c332fb1-067c-468a-5a95-08dd7111cfbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xD7ajO9UGRQ2AIlrR5VQvG/4+0rOS1CeY4TM7ef3XZi2I/Ozkr+wsfhqFSGo?=
 =?us-ascii?Q?5/opQ/jDmCZLFO1dqlmFVTcNJloVciKFEg6fVJ66kWrToV+yb9zhHvEL+PIX?=
 =?us-ascii?Q?ntks5zPJYt+7KYYGhAjoxBqpdqe18MSdUp/msisRZ8nXqYC+7B/eAVdNA6t0?=
 =?us-ascii?Q?5BzxKanYKxiTVz7LxCC0R4Dry99ELrWurx+rDKKImZapdRa/l83qJqzVXrZ2?=
 =?us-ascii?Q?5jDqaQoOTiI/r+JmmasYI1Psccg8znakj7QvLvf3NnWA6HFfdPXsodNkzYiV?=
 =?us-ascii?Q?Y2a1XIWHBGHcIcPfTmjehvKaxYTFuZFvf+wfIqx+QtioaRLSkVFSGVtBXqqg?=
 =?us-ascii?Q?aOokkfYw4lll5GdpqcvGKuPiS4DVotNk7MVdEysmZwrlyyRp8josHghUagY3?=
 =?us-ascii?Q?OCuhTLpvlz3qQAEmgD5X5j/04ynS5RD3o0TtyS5P3bkiUWY1WetkkmSQRgXO?=
 =?us-ascii?Q?vajIasqu8ndjws4TiBznkjnUxnv7jQ9DPw1o9f1uA2mhdb/Y+qBfQl2Ez33H?=
 =?us-ascii?Q?F/1dQ4Sr7sgOgcfxhEBK1xFADgOH0djl9KtiggQZLKdmlJacN985DMkPz33L?=
 =?us-ascii?Q?OMfMMozSL1Gl9lSKOy19U4U98To81Q0WnlaDttPBXgqrZ0SJCiTcfkvX6Evy?=
 =?us-ascii?Q?gtD+ic0Bwz1O0CMfcvIqiP732eqcUuMLDoWUAa/NHhOo2LNNFYOPOvBR3Lzr?=
 =?us-ascii?Q?MByQvw7wldGMYZ9eWyn5TUACqSP4Peae4ICpCrsfyDc8iV2STCKEjP22C2fk?=
 =?us-ascii?Q?iiBpgJ9iWs6uTVrMnjCe9y8paEg6Bd0VaxGQ5IG87T+ylXdJWkgMz1jw/9k3?=
 =?us-ascii?Q?L8lPjWRgpoUxtgG6hP4v37cpGfXxhJgy/MX8JZnmT18uWt24/cVlNQAIWKDz?=
 =?us-ascii?Q?U/dWpLPg6LMRhI7XZIKgsg9mC5crNoZEnLMO8tOsXDuUFn1Q53kZGscliacr?=
 =?us-ascii?Q?9Ao+nV8mWANnTbYZBT7V5k32CySe1O/jwWtrv1Z3Y4HxPmFtGYWag8E7LFKt?=
 =?us-ascii?Q?2KJYNVygK/mbZ2d4BNWEFaQnIdqK/owlHHJ+MILL+qtFBjPF+zyBYJzfuVsu?=
 =?us-ascii?Q?m9E+XD12glqP64kymbJTt6K2Uf1M7cyLJBECQISWROQl25aETbEqX4LV3kjK?=
 =?us-ascii?Q?cPD7l5t6D8gfy6AOSmAFlwRB7VSv8/K7XJ5MVDUeFYNaf/o9WxGk3qbwnpue?=
 =?us-ascii?Q?8anx8XnDgCobSfkTeH2zMArFBk0vBWSFSOaujgb6acm65jKwclhpnp3ab/UL?=
 =?us-ascii?Q?EG0nj4fz/Nh5oa4e7mRpUa1BDSE4U//mbbzwAXM5s/alQZHEzQIkd6g2m+b7?=
 =?us-ascii?Q?1xWoDYxCvnBTSOa6wdN/qicyx+jIqf9dc/rbAj3XSK7S6nB+J+71RsTuU9u8?=
 =?us-ascii?Q?BIa9lG0EgdZMl/Y7su8q4oJ391GgyU4WWF/6Me+7zE6veitmJYJz354Ci0Rh?=
 =?us-ascii?Q?tU8VuFEFAp8MfMiWVkS3XvVUatXs++92Ow5aBuGvku3vZx0FU2Y9HKRTk7pL?=
 =?us-ascii?Q?wUDJrk7Pxtsn1fk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:39:06.8608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c332fb1-067c-468a-5a95-08dd7111cfbd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8898

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires VGIF to be configured in VMSA. Configure
for secondary vCPUs (the configuration for boot CPU is done by
the hypervisor).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - No change

 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 1122cf93983d..bc8c3b596dd1 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1270,6 +1270,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


