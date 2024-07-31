Return-Path: <kvm+bounces-22785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E87509432D5
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C8491F21B3D
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B701C2308;
	Wed, 31 Jul 2024 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AYoqh2vH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D621C0DD7;
	Wed, 31 Jul 2024 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438562; cv=fail; b=Yu0QWIgimLyqAh2OsG6DJavodgj0FOarv/NX6OGmxweiHlVGRscaCdyLzIfTW13fi2IiAfz49g9mW98+LKAq78sfn7X7dblrw9kRlHZIfthV0VBwZC0A7UzK9dHLFziA1Ea8CN/+iKZ6nmK1JCwlObpdbU8gmJPW7YoQdXptzww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438562; c=relaxed/simple;
	bh=+CjyfxxWIq/2nT2z+2bGhN5uYpTUeMt9rZ+KekxMMMI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cu7KxoEFy3DiTbekjcH/pBGNbtg+nGnPhz1ejJFHLi2+HvcNiDVOLZ/xOnYHZBnFcsXnyvwwbNFpClmP00y5MT8U5g8yYJrDryAtnfQA4yt32WOc7TkornschxMRsvx12VfFv6T85x1XOdr9HZheeWXnxtb5hnoK0ihWCccMwXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AYoqh2vH; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tr5zQ6r/TpgHtsw4Noz+wxJHI2/7b1FfcFkme4wUZLd9HMoJpFJSr2XGdlpKj9bIBZd2yEHEFfFV7J0HH2Anxk/O+qrUMP7MvoK5BM6d5kNXBFcgIXKXYA9qm4UK8P3sKowfHr0TMt4lorwdxkPk56M+hDgLJU0DdRBXHy54n7RNVI/1azWYHCrsj8T67qfTBLB76OydLG20RbJcg5oOO+iaKdjVlkG7TQlKyPnKm6qbVKNcCvSmvcFBGcqQkMLx2YxVQDHAqrq7hOBC7EePmSRMMJ2ZzhJ5yKZGvkTdyZkqQfe19KnZ9DmnNoaODIXe7UdHs5miBmaDrYych7E2HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjU/yVYwUd+1601e1A45mtNJii9C2k9bMq3+GN4J2kY=;
 b=YA3T87c91qBbvwPV2RtQwQ5lShE8vqzb7mPGLaw+yV5P5MuhGlEVAfwiXPy9tFMsRncgt9f2pv5w3DWOmowDNfcX+Rqi4LKcf+sd5UQMHM8/CuY3prZUjhNNH4dKEhhuWCteMwq3ySX0FyCXHiOm4BEaJcLH0rSrhNKaIRM4IeenaavUYMh16HjzEoJ34aJAYCaMDh6/MYv1csvXsHVcS509O1QbPhA84SGrC3htgflkj0eJlx3oDb8KjVs4z3fpBPPfESuCwnUIK4kbMM7WN+PMK2eaWXfatMvplV+n0JC4b8GP3zY+z+dSk5Jo74/j3RyV+xa5J7OURiS3IHmAvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjU/yVYwUd+1601e1A45mtNJii9C2k9bMq3+GN4J2kY=;
 b=AYoqh2vHfrfRoNNdrNL+qCO9ydWnRXrYdOaLiPqZI2Y3XpxYF1xrWzYnU3DspxLQtC2GGbDIs9GORPMrJFgnHcomxnb03Xw4eeRB3zflmCMLEBHC7d/mUmI4xtJ43vA2Fz+oEfjiP9cbWyLPCJbnp6HC7jzBL+RH7171Rmuh0Gw=
Received: from DS7PR06CA0030.namprd06.prod.outlook.com (2603:10b6:8:54::22) by
 CY8PR12MB7290.namprd12.prod.outlook.com (2603:10b6:930:55::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.21; Wed, 31 Jul 2024 15:09:18 +0000
Received: from DS3PEPF0000C37F.namprd04.prod.outlook.com
 (2603:10b6:8:54:cafe::82) by DS7PR06CA0030.outlook.office365.com
 (2603:10b6:8:54::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37F.mail.protection.outlook.com (10.167.23.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:18 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:14 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 13/20] x86/cc: Add CC_ATTR_GUEST_SECURE_TSC
Date: Wed, 31 Jul 2024 20:38:04 +0530
Message-ID: <20240731150811.156771-14-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37F:EE_|CY8PR12MB7290:EE_
X-MS-Office365-Filtering-Correlation-Id: b3ef1bc8-e0e7-4b83-5057-08dcb172bfeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iFFi+Ugd+YrM+YeKQ0j1VXj8QSQzLdmUFqYZve91dEdtYxq1jBU/fQ/Le4HS?=
 =?us-ascii?Q?T+0QK/4u0pf3ZLSB3LBRjvIwPchQ0H9JbCWTNqP4du1MabmbrnswMm6pOgZd?=
 =?us-ascii?Q?t4cdQF0gVk3xR/X6cJqrLAiVS3xZrLOo+0z3AqwV+gE7tPguu+RqR6LVaNmQ?=
 =?us-ascii?Q?G3kxyJamv5CeBiS0ieLGHMlRe2GXAAKKhFfeiNjR/YbQu8cCzXjKZIflJJgq?=
 =?us-ascii?Q?BfD2z437xaGCfaajN9fjiwrAydmlttlhxheZSzteEf/Ml17VL3bMkFcdiU9e?=
 =?us-ascii?Q?hAF8sT54Buuf+BzUGPp8al4VuoaHEepUURLtxbbcOOQjkn/Cx30k1oBjhTTi?=
 =?us-ascii?Q?XNtvm/5W2JSCIoJLMDEFmYDJy8R6snhL72cx2f5zcq20y7DG0Oh0p6JO/Cwh?=
 =?us-ascii?Q?DH1S7j3uKewccagHmbDjQGLPVypvDw5L1qOTbTvRx212Xxp7fypSuncrYCnk?=
 =?us-ascii?Q?eS+7Ksa+3VHZo1QXGOIac/50pdwAI8yG4Onk+aCgfZ16D4vLjiiN4E15pAj7?=
 =?us-ascii?Q?cyu3kJgA/yd6K6UKAUBQ1LBbl2ThnrYWfDYFZI2MfHx5Z+0Q0RU8mhoXBGlH?=
 =?us-ascii?Q?DnwyIsJHdpg4mYr8D8OUXnNS9KLkArlmNRPP1k3RmMr1VpX5vw6SOAFRMBSc?=
 =?us-ascii?Q?RnvTV7kPh5F0Q4SRPF7mJCSwTVeeRjJLH6PnPH8aOmWy23xVtL0v/GpOGKT4?=
 =?us-ascii?Q?SxdCDRRKQbCfcQt2QYq0koAtlH1BgRvp/tGpOYglf78txzVh8Eem8tTmfLiB?=
 =?us-ascii?Q?y482RBk6LuRHrs38DrDlamFEpI8iU7+g8asTthWca0oBvPaa7s/0NQAFrGad?=
 =?us-ascii?Q?4W+vlxS9yGDEMCK/BXWophoC4gaIXJkwdmBOOGkyuPGa8JcPgUZk6Hij7KLs?=
 =?us-ascii?Q?aIrg4LgLNIo1rOzpELAW5YharI/DnLNVbrF7I0eKAYG+NoRo44psRL4ti9h8?=
 =?us-ascii?Q?HyU6DFh3PATRZo/rnbK8CSjQvB/OvMHnA+4raknP2umCLen8ZKMhT9f3KfsS?=
 =?us-ascii?Q?elXAOrmjwKCjZdsXtphqv1EjxyY7EOpNAZndfbcX4mA5hjxu2Maj5ErnYnTq?=
 =?us-ascii?Q?lC+fsRs4qE9p4SMG0N4qHWmsFZXKO4flJ/5QgXMvMzrE7ACpOijA8gI6cacY?=
 =?us-ascii?Q?ag9sCx8yLCPzz4PVeSjN76ABjCV+T/XEMs8t3DMElOaAPh8ZYDx/ZLkIyPEo?=
 =?us-ascii?Q?Sj6nfC2pyimgenqD7ijfS4HdiDrKO+Yg03Q1/pCmvYSaZ98G4/Ukbv0/+g0t?=
 =?us-ascii?Q?jAHlzSO+67OoQ2BF+QQ49wbWq+uX4NPy/J/DC4N2eldbGWK7eC4poEgjF0hH?=
 =?us-ascii?Q?aFlFppqTV7QwwSY7Lf8H1prj9bTBr3pLgIxbD5oGHLTUXdEIP5tsopxNBMYn?=
 =?us-ascii?Q?rgZtEjC8EHo9ooB454yHD5Xh2RhyM7eag83i+yqSNTiW8pISEI+cMYxgNvn+?=
 =?us-ascii?Q?ihjR8DWJ7/wwWAALcBNq2ljt7vOdpcOK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:18.3244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ef1bc8-e0e7-4b83-5057-08dcb172bfeb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7290

Add confidential compute platform attribute CC_ATTR_GUEST_SECURE_TSC that
can be used by the guest to query whether the Secure TSC feature is active.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 include/linux/cc_platform.h | 8 ++++++++
 arch/x86/coco/core.c        | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index caa4b4430634..96dc61846c9d 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -88,6 +88,14 @@ enum cc_attr {
 	 * enabled to run SEV-SNP guests.
 	 */
 	CC_ATTR_HOST_SEV_SNP,
+
+	/**
+	 * @CC_ATTR_GUEST_SECURE_TSC: Secure TSC is active.
+	 *
+	 * The platform/OS is running as a guest/virtual machine and actively
+	 * using AMD SEV-SNP Secure TSC feature.
+	 */
+	CC_ATTR_GUEST_SECURE_TSC,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 0f81f70aca82..00df00e2cb4a 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -100,6 +100,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
 
+	case CC_ATTR_GUEST_SECURE_TSC:
+		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
+
 	default:
 		return false;
 	}
-- 
2.34.1


