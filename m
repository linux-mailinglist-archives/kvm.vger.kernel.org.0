Return-Path: <kvm+bounces-62978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D88F0C55E8C
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:19:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90AC33A5E9C
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3073203AF;
	Thu, 13 Nov 2025 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ifokkwBs"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011047.outbound.protection.outlook.com [40.107.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8D4433A6;
	Thu, 13 Nov 2025 06:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763014760; cv=fail; b=knsvtwzpSA4CMVDNm/ODZVdzw3mRwCErtN/9/HC9ns2FZGp1xmlhkfutGmr6RPD9r0a3+mmBmg/AKGpk+AAf+43xeGseppjspwaPYuq7je8VRFoDMOjkGjUIsidc7H/bMINc1PQK3S2JhC+vNdSLvTTfgD+iVPgkqG+UYEaG1IU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763014760; c=relaxed/simple;
	bh=B9cF8QSDa0Iut3H7DEJ50eUVCc42gpcXHjnlriivOHI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O+XYxg8VqTSROX4V9yoxe8m6oqpOyTa1ZmEiTxP16NpgHlk16wKxxc3zgdBK3Z02eCLYWOnsO8xfnJM2ffTMhG3NBog+xd89fKVNomNrx+Kul10dQyJadgy/SmOqtf7DUujNRPfu+66jq0XjMw8LUswPrjLoCuh0e1aHosYpVdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ifokkwBs; arc=fail smtp.client-ip=40.107.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bH3onnTmYoBjZwx/fGC+pdIGXw3AzadiszUASXB/gzSB9BJ/x4qwaOuzuUoBLnu8R9hh2IUcuXcZdpBSNasOVt4EKzw9AyPfO/w+xVwpGSZYS/EZU/YKeg0/m+N6dprTDebzqdde17s1I7p4k8WCLjgAtUP16FtpPNqVotRItaUwpt1XrU8JvgXbBN43+nOmMb+DCB9GJo5nq2CIQ/W8AVMxOR+G2OA/zR6+t2zluvPEWbS3mjSwc4/y7cDQB9u+wNc2Nro7UTirnrEYKwzoOTx+4sHGzujlrDT7pbOpQx86vyTrq6uL0tTuKZg6RaxLUpCyBvs8R9Kbhic3tL50PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yutt0XD99GENWUGDpg6xoGXlzQ3q+A1LyDm0FbtEDK4=;
 b=fY39gn69Fy1TFcnZ0+U8MiAkbtN/GxUvD+YlclGbUqsEf1AnlVch+ieiuwVhWblZr1xMaHngZW0gJcwvPnw12/ZOzrk2yS+2IP9Bf+8DHgIwnJofl0y6QwQto+KiTBc1olHEyEUR5TogBJ9r0SU2gnHqZyLZsz7uco8ULv5+aUFtl6qcTMcxd1qJgvEPYekFOQYt7nDSkwObAFjEPmGVDV1zL+kgpOF7KmUdS9rkh8fVaU5Rn13GV/3qSEdfaN38Zaw2fAtrCzW45A3YP7j4xn66qLZg0xxBVx/zgND2zY7fAmBcUCe4TYvg9lwRBvSo+ROD2v1Rq9g3kzXiDFPeEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yutt0XD99GENWUGDpg6xoGXlzQ3q+A1LyDm0FbtEDK4=;
 b=ifokkwBsr9SHFSYaT1fsYA4cxOrzIXJ5pyy6AzmLArWL7lXobjOcnQsWCehSQkn5NAmjyj1FGv1dGou4KjFYkd6ejsNqPIjsbjtrtkHKNwXY+04dSGBbS0E80dlezO1EMYthOw0mYjKqrJJ0sytf+7GTZ6vVB2ThfNp2e6UfEAI=
Received: from DM6PR21CA0017.namprd21.prod.outlook.com (2603:10b6:5:174::27)
 by SJ5PPF0C60B25BF.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 06:19:14 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:5:174:cafe::1c) by DM6PR21CA0017.outlook.office365.com
 (2603:10b6:5:174::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.6 via Frontend Transport; Thu,
 13 Nov 2025 06:19:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 06:19:13 +0000
Received: from sindhu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 22:19:08 -0800
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Kan Liang
	<kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
	"Ananth Narayan" <ananth.narayan@amd.com>, Sandipan Das
	<sandipan.das@amd.com>
Subject: [RFC PATCH 2/7] x86/cpufeatures: Add PerfCtrVirt feature bit
Date: Thu, 13 Nov 2025 11:48:22 +0530
Message-ID: <c056b4c5abc7b0ffa7a4579aa6503fc99fa51fc1.1762960531.git.sandipan.das@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762960531.git.sandipan.das@amd.com>
References: <cover.1762960531.git.sandipan.das@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|SJ5PPF0C60B25BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b008823-2d3c-42ae-4ca8-08de227c90b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PgFpXebOEXtmHxnJ2ueobiCzxH0Z1u0KeOUDcFd/jks6/AcZBLuSfE6V5O5s?=
 =?us-ascii?Q?xxAPaZEA+4QieWLi2Ge34uZ8j7/b5WaJYG4eMlUsCJ7sIjf0s/ocBKkPcgLe?=
 =?us-ascii?Q?hVqayDzRj/C7EugUH8dTTkF1Er9XV8DL10SJdCY5bZBdA1km8354tOV3MVZn?=
 =?us-ascii?Q?a/K6LCdSULUx5N32YjxCrfMHWBQEML/dfDpU0bn+PYryJCZlEUwKoAY4m5ru?=
 =?us-ascii?Q?ct/Nb8jihZ9FuuFIAbGLW2yOgCV8jdYuKtGbi0MdhLrj6jDcl9K3CLsLWI2y?=
 =?us-ascii?Q?puUcoJhuGe2dNi3MoJee30fldQDYhVeXtFd07j16DLS+LmiyVoBjzjNoyO64?=
 =?us-ascii?Q?Qu+qFQhKwkceO73mL4adeV0RxPGfrKtCyayyqeabfNfi/oTupyhIDJ9vU/Qp?=
 =?us-ascii?Q?M2gBdzz8AqcvyIM9V2Qz6hI2NNSXXu3EonyOFS3foQufn9kCJNC7u59wIxHL?=
 =?us-ascii?Q?8xxQ0xnIilKeCDjwqZbxcKXMivdkNbI0X/VO2mlxEW5wq5/r/W1NPzzifLDa?=
 =?us-ascii?Q?LQI59BTUpHseyfaz14nGjKKxZzOsZ9atoFNkEbQm/fMeB9MRDJmhkrLYrOlT?=
 =?us-ascii?Q?TrA95qYjLTcHBrHvbY/2vzIffRnFLoEYEHYmd9j6fPAsShBNk3ahzcCvlZ4r?=
 =?us-ascii?Q?X7QeKNfDKR/zK5crVoOC3PaVgTPcVWgIcg9CA1G/ng4/EkyClRsfQmplNjIk?=
 =?us-ascii?Q?1CgsC5D64xX1ZBWWPBhMxTQzVs/uH2rSdlQ/cwtehv464w+5+yuqw5Jj92ut?=
 =?us-ascii?Q?yPGI5X9y20J3tFIeTz+vdKfGIo0zyG5cGuMSwkWz29Dq/MJNo8qnJ7LrbMwC?=
 =?us-ascii?Q?rHVLoKJQcnsBwatgHok9xU/LaH4a38Pf4LnBHUw52zB7au86Gfm386JxgLWT?=
 =?us-ascii?Q?g09h0J9bGucaABoxyfhb2WNMaT0UKTMQUP6omF9Qbi+BBNt9UYFDaYYTjo0L?=
 =?us-ascii?Q?xD3Oc5ICJDFWF1YG+0FCz/8KUC35sKJspUkoVzaWvgaOD7++omlw3Bg8bqnQ?=
 =?us-ascii?Q?oisl5U5iXxpWrvBZo4Qb5eVT8p5j9xHeywVErP0mRvFvADM97D3y8o9/ggcX?=
 =?us-ascii?Q?PH1ug0KFUQSSEX6Y9pr8+9qTCs0MOZcsM2ciHP31mFKlAXWztnTKrm3Z8T5x?=
 =?us-ascii?Q?0vtMXk6IcZ007OahEc11GHLiLEj0G1I5H0GOqyKDvjVyR+VGED4Y21bEuPNH?=
 =?us-ascii?Q?ag8SMW5MZrt8dLY1/vYnmX8SEMAQLRG6ajUfApfhyzC+1EinO8IAmiPm9U1i?=
 =?us-ascii?Q?k01fKtjYR+7ZStYb7YOPLpqbEUMOXbofhQlF9QZ91qpMOjeGuNJte7nNQ9T0?=
 =?us-ascii?Q?TE4RvsZe6Lmk9hq1vlweZrD0hWKTIOfu4gLaExL30ydTVoI4SfIwLt6HWhzI?=
 =?us-ascii?Q?nhzRjPS79aT5I6NImmL6ND2vKwsj+Bjtu/VpQljD9Oaw71af+iDYraVzZ2EU?=
 =?us-ascii?Q?GzSwxUOCW7EKelCvi2FYXcKmwnIGEXKAw/MjKxWVQZb9mc7P3FN1KeIlv/Do?=
 =?us-ascii?Q?qB5a0mY5Dco9Y/IzT5PZr6m3W8ZBWRWLrHNxHYIM9ko5KufmG8fNmWJbrH78?=
 =?us-ascii?Q?JyzHZn3rHM7Hi8AAzqM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 06:19:13.1402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b008823-2d3c-42ae-4ca8-08de227c90b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0C60B25BF

Define a feature flag for bit 8 of CPUID leaf 0x8000000A EDX which
indicates support for virtualization of core performance monitoring
counters.

When this feature is available, a hypervisor can rely on hardware to
restore and save guest counter state when entering or exiting from
guest context.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 286d509f9363..0a81e9631234 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -370,6 +370,7 @@
 #define X86_FEATURE_VMCBCLEAN		(15*32+ 5) /* "vmcb_clean" VMCB clean bits support */
 #define X86_FEATURE_FLUSHBYASID		(15*32+ 6) /* "flushbyasid" Flush-by-ASID support */
 #define X86_FEATURE_DECODEASSISTS	(15*32+ 7) /* "decodeassists" Decode Assists support */
+#define X86_FEATURE_PERFCTR_VIRT	(15*32+ 8) /* "perfctr_virt" PMC virtualization support */
 #define X86_FEATURE_PAUSEFILTER		(15*32+10) /* "pausefilter" Filtered pause intercept */
 #define X86_FEATURE_PFTHRESHOLD		(15*32+12) /* "pfthreshold" Pause filter threshold */
 #define X86_FEATURE_AVIC		(15*32+13) /* "avic" Virtual Interrupt Controller */
-- 
2.43.0


