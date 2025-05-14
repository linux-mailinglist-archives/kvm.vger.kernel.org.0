Return-Path: <kvm+bounces-46460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C661AB6474
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFDC78662DF
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14547216386;
	Wed, 14 May 2025 07:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MsFLzbWH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A920C201004;
	Wed, 14 May 2025 07:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207869; cv=fail; b=KGtaukGBl4A3CDnFBjZgWdRUr0Wd16kV5GSTTLjV/itrNI7jHswbrSke3hSKWtsxWaKhsdiNRP9C4kjdoZy4kALN1idOgY2pOnf4omsZQsH2eBqonp44xd0AWGQ/ckjs9ORS83AnUJxU4Pd6joLAOFbK3EXdUNZoP/2Aed93LiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207869; c=relaxed/simple;
	bh=Kxked6GpdNjQn6w56wlfZiQ02LPP9HEViKJBP7VlHWQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TBvNQ7iDJ8Hd7r/v1dbBUmfS8Je+wc1K0brHroYWXZkIru6UXxaNPyx9Ocj+FAFJXGMPS5GEduMBkr0UsyTQMcry4qIA7/7uZAdcHOpXA/sHGTzEpy4ghw9ZmkrDu0fNKvRvxuBVLlsvzZTnY/DJONIZ3OMWG7/vxS9Ylr14+Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MsFLzbWH; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=olPkuZHd69sRcTK2707cStU4xv/0688EJ1sRX2femXYsO9O3vqJ1sGbTD2tuAkZtS39qpPyce/+pJD5+eqMo0OoF/vgbTWm0nAp4XF2b29a+TX3GEf4PCNqFTi04k3AkCGFxnOKhz6BjftGMKvTpv5rrVOeHrtJdJMDJhkMYjviCQCwn29sXddILq+5y6pvCq/ChCUZouFcaTzTjA/pfC6kL+48yHR5iz27hJYwl2b4PAVW9AI1vhTXruuPfzd9DZCyH0LsHS8vpJ+HkV6Kkfm93oJn5hQV4LE1GOFANJwY2HUfx5asKgwmmW+IVlz48VX8VEH/cfMf8IfMuct4tlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+8nxB3oRsXJgCaa+VM4P4ej1KjBvuIu98JVPnl27ZQ=;
 b=KLD4YthmsQF1V/W1IhrOF27KiBc1buPU59TWZJDhWuuWU5yLE8mYwt/aafeLGAeg/p/tQqzS+lmTFqtkEJJkgsPeZ1AR6L36y6G2Y26Bo167L0Qvpp8lJvAY/CfjPL2KdwfwodP1B2pQ3eKxgcxMApDovDj0PwXVymMxeXodcB3HnXt8gH8NHe2Aq4wI9rgHcjQibjK+jcLKmAW5JuPhKBDnBn6T9Aqf1iCYuejPDCzJduVic9SPwentEnKF4SVDtMctq7p0nBYXfWs5nXvWJUT/Db4dry+qZ8T3fMRABkrzlfIajbiguODTKkcHw1ZbuQFaeSxetnzLnUsHpxKp7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+8nxB3oRsXJgCaa+VM4P4ej1KjBvuIu98JVPnl27ZQ=;
 b=MsFLzbWHQAhzJdKbnram1E6z6zCE90xf0cKU02IIumASB4vCB8EpttJzx+yoIi8UwJKu+d0UNHPG1KvKSkM+YvDDG28l/3d/qp+aeg9xCu9M4g1jQyrGjzhPVuaoxQ0XK0ZOumxm+b9+lDiHY+4BE81H34T0Lfz+JtekvalGaGU=
Received: from CH2PR19CA0027.namprd19.prod.outlook.com (2603:10b6:610:4d::37)
 by DS7PR12MB9528.namprd12.prod.outlook.com (2603:10b6:8:252::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:31:04 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::29) by CH2PR19CA0027.outlook.office365.com
 (2603:10b6:610:4d::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.29 via Frontend Transport; Wed,
 14 May 2025 07:31:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:31:04 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:30:51 -0500
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
Subject: [RFC PATCH v6 31/32] x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC guests
Date: Wed, 14 May 2025 12:48:02 +0530
Message-ID: <20250514071803.209166-32-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|DS7PR12MB9528:EE_
X-MS-Office365-Filtering-Correlation-Id: c796e2c0-071a-4f51-af8d-08dd92b94909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J0nDbLDLwbJrfKTgzOyhAVnH9rtM/rZFwkdrSKhv3txHtwyEqm21Ol7EueZp?=
 =?us-ascii?Q?bh+bRKDHHmhBHLJvkJIfDikHlgMS0NsfR2hXufnuX+3R9PzOXYGAtEs9ikgY?=
 =?us-ascii?Q?c496xEMX2FxiE3b6L6Pg3L5hx/42Xl+4cQAFyRPFeiC+HWGogwJ5lU+X3U/W?=
 =?us-ascii?Q?Y2WUvxsdgGHTNw+qyYMPAnETbPRxLZJlx8iv4NwLx1TKcG4SMUbFG2SZjS3H?=
 =?us-ascii?Q?6i0/EisknZNgngCick0CI8RRdtaQXsi/8k0UBf+QuxgLD3udlpiXvNhoxqcy?=
 =?us-ascii?Q?3vV44j6KowNGuSb8JjwIMfFpcBy1SvHYSgb78Ul6ddYQkPIq3WVIGgI2LPC1?=
 =?us-ascii?Q?hVWST3gP/8d0S9Jpm0bPm6Wv/ZxWGREXul0yW/XS9JS6oqso3RMr+px0XfQp?=
 =?us-ascii?Q?hCmKzYXCIoLeioxJA4S2xJJEspG3n5IbXiWFxll6aAk5otjlM1QWMgoTI72F?=
 =?us-ascii?Q?OamRVUAwqMpt0QsqkZxNro438+V/ib3h8ftMBfQY+k+x/r0Z3xXt1fvWBnsJ?=
 =?us-ascii?Q?Si5zUE5lVdO45Q0YFq/sk4+ah0Nz2f8ZPdwlDZHefO2aCNcytN9k9qqHnh5U?=
 =?us-ascii?Q?cChIrhNYe8qqfj9xYfw8RUBxuN2WrfKTwM62ShPL4gVC/Cpt0Lu395hdjUnK?=
 =?us-ascii?Q?cRARhAn0cMCb0FsyuJ2muy3i2iyLkuhgQU+m7Sne3J5NlOJg4qSLtiqePK8T?=
 =?us-ascii?Q?0SeRkMP9oQiX8f7HRtEf8EJH/DnT/fDHE5bIPZ1S3IjTQtMvxC0JkW/cPFmq?=
 =?us-ascii?Q?4SmoQhw+5q5dMAqL5GNhXiKjYHrORat83xAB47sufOkoGtG2xcdoZRmbIzVq?=
 =?us-ascii?Q?BRDS5XJ+t/9skEkhrS8h7sLRFaHPsR9wThoY7Ll0cqzMnkxZrtLHP+TrHf6x?=
 =?us-ascii?Q?QCWJfvBheasBacXPmNo2YjbKgOmq+38BYTYuZYU5xb5yF43VVa9+t+hl3zbt?=
 =?us-ascii?Q?qBOcwQYbHe+TbTUJBs5pHI5PrOoYZNNT2U/7Og2tjvJZE2EhWIdEdmRYDkgQ?=
 =?us-ascii?Q?gDap6WO0Ry9ZNnD/DTCoKrFNAUdOVVoyOHTbnKp+pQBLaF3N4DIKjOEbxA2/?=
 =?us-ascii?Q?DgMok6rk3PFHr7YS1lIuByr0C/EFTyv6RF7pvjMzuk2NcQCmWhXZLJv0mE9d?=
 =?us-ascii?Q?KubiU7lANV5+1AI3C3Mx9SH33xWB9qwYFj8TyjCDquLbnva+kjBOvv4rfS5R?=
 =?us-ascii?Q?VZYuJ2RZZUGOsQFi8dUiwxycXNJ8Z9vctXxI53wg680YfL2aHPyih36odPhl?=
 =?us-ascii?Q?yR16QmRhsgkcijUtRshyB5tTQ0VzQX9c8SFyw3nTB0LDg5bioF5Ji5iRgNAn?=
 =?us-ascii?Q?xR2Yibsk/zC4YBq0W7XSfA+i/LUVH49wFVKneCegdceREQStHxELpOhOnAxK?=
 =?us-ascii?Q?sib8dSELqE5H1QfqMulfyCAGH9yXkNSCGOBnF4oEeQvRhLjylClbAxrEG/To?=
 =?us-ascii?Q?hzDjmtTXhdfT0/ITSM/sIsc+rz0gg/FZegT1Yl2rQJSucGuQTUgOdiN0WMXI?=
 =?us-ascii?Q?IXIVky5BiFwbnM9jXpZd7YLN6jLa0Kpb9bxV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:31:04.7894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c796e2c0-071a-4f51-af8d-08dd92b94909
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9528

The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
page and bitfields to control enablement of Secure AVIC and NMI by
guest vCPUs. This MSR is populated by the guest and the hypervisor
should not intercept it. A #VC exception will be generated otherwise.
If this occurs and Secure AVIC is enabled, terminate guest execution.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - No change.

 arch/x86/coco/sev/vc-handle.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index b6cfa18939d8..7a531aeeca99 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -407,6 +407,15 @@ enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
 		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
 			return __vc_handle_secure_tsc_msrs(regs, write);
 		break;
+	case MSR_AMD64_SECURE_AVIC_CONTROL:
+		/*
+		 * AMD64_SECURE_AVIC_CONTROL should not be intercepted when
+		 * Secure AVIC is enabled. Terminate the Secure AVIC guest
+		 * if the interception is enabled.
+		 */
+		if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+			return ES_VMM_ERROR;
+		break;
 	default:
 		break;
 	}
-- 
2.34.1


