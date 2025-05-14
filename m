Return-Path: <kvm+bounces-46456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D375BAB6461
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10D6E865F08
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9975221C18C;
	Wed, 14 May 2025 07:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5lyvSuXz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4762921A447;
	Wed, 14 May 2025 07:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207768; cv=fail; b=VGzGolK01T/W49AOLUzN+LmgwOf84udnbpyAo2zN4CwNoOAEIZkDUqEsEniiftA2rq9KfSJucErzm70Hcbeu7P9WJtQv03Qd4iyEtd3Dl9gq0kBDG7y+q7hHzrwkuSSRocIebikcCWRfmy8EbUxSljXCA9MIxgELRE4aQ02n1yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207768; c=relaxed/simple;
	bh=MsjLYf9ia2Dd1pLtHXf5akyxV5N155EFw+TL/VfYo+Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WPLYFtg/1+jHfxMpdQJxX+4XrZS5E588Br29WC50fJW2jB5jASZumnmLU+ulmug0/Eo+DvOWz5Lsoyu/lQ8o3I6f0KxVY4GREoxfT6a2WcOZoTWoVFVkVf7WL5aRp1EfBdPtdQqxtXCFF58n5kKWEoRI1q5wjeCBh2CyPLkrOnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5lyvSuXz; arc=fail smtp.client-ip=40.107.244.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oCezBtYM0tddjz2y6RJ/+8S9NCDx3tK895qWuBb7bCDCauc5tdVA3//DC4OIXKPvrCLyzkuAp0YhYpmAGDuet1IMMWlHSTe9eS5jRi2Zz4ybI/SAWJu2USxy71ArpH+XN+fVrqkxM+ejanPuLL5EfqlO6w0LXJCFu6Wx2J4z6OCfam8jUAG/q7+wUoY+fdANy7JT5kcpxZ+sEhflmyYMLY0JqpEhf+/ze0vqKoIpiEu5A/QXQcj7G2E+EM3gA6FdvpaBOuUfkRUNG2BfZIVs7Wb7fw3mRpHrOP05yzl7sMYR8wKiyHSVxeY0QH8HnvHeJ9idQ3Sc1VJUJjH4j9/EsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8llopQluqzrlHjC++y5WtT/qwdxyjM7lYCjXr9MMCzY=;
 b=OgkjMMsEGzXwTzu9dexOZuiqNnfiertDFzscgTY+gmpRVHcIftUL+szrgKHSICkakp+49JMQU6OafzSYI7ed5MKrL/36ijSSx8YEkDVkz4gp4adJkFeX6Mddu9RK4twQvoYGYUW4e865u/cDCeJqoBHcBCGxSSwKJEzrcwSK0QLizs2PDdV7hpGQggbD51qYPJ92YVwza+14thEu4BWE/3kr4tJ3ktyP9g5j+ln7yqwD5STIJfXwniSf4R/X1m9Kspfwk/5h3dgehQYTBa1G7oDn/edayXyZYWaapQ08eDeT12mxGpwdegFL9t8Wi+t0M0pmGqPXCeJuNb2AYRhXag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8llopQluqzrlHjC++y5WtT/qwdxyjM7lYCjXr9MMCzY=;
 b=5lyvSuXzfPGKsl6dPgmvKzozNiSK7KRqcccV9siT8jkdTDH4eeOEbt37wRhOlr01rYjWYnN1aTGWUH7u7vm+3/k32X3LO+dPZyt70p7Fa+XbOYKmSWoILIOxjLXA975frwFN0T99WWEZPmfIj6Z06ZhZS7FkRzGKbvgT8nEZVGU=
Received: from CH0PR04CA0053.namprd04.prod.outlook.com (2603:10b6:610:77::28)
 by IA0PR12MB8304.namprd12.prod.outlook.com (2603:10b6:208:3dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 07:29:23 +0000
Received: from CH1PEPF0000AD74.namprd04.prod.outlook.com
 (2603:10b6:610:77:cafe::51) by CH0PR04CA0053.outlook.office365.com
 (2603:10b6:610:77::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.31 via Frontend Transport; Wed,
 14 May 2025 07:29:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD74.mail.protection.outlook.com (10.167.244.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:29:23 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:29:13 -0500
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
Subject: [RFC PATCH v6 27/32] x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
Date: Wed, 14 May 2025 12:47:58 +0530
Message-ID: <20250514071803.209166-28-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD74:EE_|IA0PR12MB8304:EE_
X-MS-Office365-Filtering-Correlation-Id: 00c0ba7b-0440-400e-8246-08dd92b90cc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ukyhEMjn4mbALaol+IHunHEPFibyWgXIWv37cpkbj6gZcTssIKNDjviSBnay?=
 =?us-ascii?Q?bFVFVVQez+wqNJnrMuxAIL6J50Ys58O3VpQ1KUS1h5AlX+dOYsPIRHC+/5yK?=
 =?us-ascii?Q?cmOFR2twYr1e/Q1kWDFRkA4hrbLn4DPolHe3Ck5xRlMOXjrJZ2Bq63gWqgLM?=
 =?us-ascii?Q?+nQRYE63miARGXC8I8PqXvjYilv8H4Z8yEyScvo91UFQo+XKu0/THlrAG+VJ?=
 =?us-ascii?Q?pSd1VgNAaeAX9o+eNevBD4cYUOC7DGyDBW8S3Lkx98vYT7HqkUNhCpjj/o43?=
 =?us-ascii?Q?asV6RLB4jIDfB/jtP4oMwLKMnB7kFUqvLlIAkc4TjTlwLlaz0ajWAMUa4Crw?=
 =?us-ascii?Q?v5gn8jeFNdx5fcK69phn/7zaXMNJsW6wWGLRFcdm9rUDBDfTMDVnamqvXYoq?=
 =?us-ascii?Q?9XJjG9/aEcNBYwivawhtP/tj/lOP+QRPqrHl9hKf71FZlZUbRQX0P30THFzu?=
 =?us-ascii?Q?XimDZY1ibr9BDf4lLycYkiGNcmrRhxZHX5IQ5J7EeounrkLDeoht+j6TjIYL?=
 =?us-ascii?Q?UcC+ONGABRIAFWxOmHK5ZVQoaOSbT8d7VvVITAobA6dGWDJ8ldquMakDFVlZ?=
 =?us-ascii?Q?jXKyj9pzJ07VnAKNpjKe3C9L79cg+valFyVcNA7tdvDYGisW5O1AIZ3O2L0X?=
 =?us-ascii?Q?tUuYv4zz2tfcw0WjryGwuDwC6rO2xgdcDfu9L37aGAB2YwiFeVtf0cNcbPTX?=
 =?us-ascii?Q?tdNAkK+h4MzwXOOdroIUiAxpsbj2mav9LpyII7cFKR3oIBskuEBxbd3uK8ti?=
 =?us-ascii?Q?hLHU874DbROdlos5YOZmdf21DByovueIPJqArzse5S+ahKwWxr5ijalGwOMI?=
 =?us-ascii?Q?lqvgKxFGYsXtNM7m/IXgWy9DSEzkJCIj/t07ggupFCMusv1qtVRIxCeHx2xp?=
 =?us-ascii?Q?oSWWVh3M3Ot82+JtTupXp3UMyvqzMJrpkKn5tZnf4KfSk1Vzp6vcWqj+fhFJ?=
 =?us-ascii?Q?NOOaiYVQf0Ms4zAgMUc0z7lLt4BBy81BQMXRsaD8i/ikwkF52UzeBbS/hwX2?=
 =?us-ascii?Q?dY1jxrgS8yoThqQPK8xgZsue51FLpOQmzvg/Q3Bk0zWmAxd/YuEn6fFohbaD?=
 =?us-ascii?Q?geErjxT543Vms2B0YboEC+NCsoGdckX/2LkCaHwSf8S3Q2SrYjgnqDmb919a?=
 =?us-ascii?Q?Kw0Ubl1YAHdV/xauqBjCLVKH+z5Y/qBRpve11zhfbhE3tm4nLbPVKk1vmu1+?=
 =?us-ascii?Q?8BOAzPJxgNSZ8yYlL4DU19EupwAHLG7DrtPh4lhBPgFyzFrYaEFKWShoKh/l?=
 =?us-ascii?Q?z/I+d6DAbcar84z4b1L6bCcPm/sbxihdEelX523mgeQURFzCKzb4E/j02HP6?=
 =?us-ascii?Q?Ic3gZH9smtwxfINIc0e9OFqbdG4wZiiiawvOr4OYm3Gi43jWtyk8NCfMn4WP?=
 =?us-ascii?Q?xqQYDwJcSCXObKx+Iz/i+hEepGi0puBoDxydNfkitY71bcthjx4Dj/AlPjci?=
 =?us-ascii?Q?XZtptphGlOT6JtZPVO+JdyHYfkUX2d4zBmbGuoipV2lm0x5L0gx1yhxDx6e+?=
 =?us-ascii?Q?5A3pcsK8BXAbNDh8nAdCU3eSvR/pprB/pQL7?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:29:23.6934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c0ba7b-0440-400e-8246-08dd92b90cc7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD74.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8304

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the hypervisor for Secure AVIC enabled guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 583b57636f21..0fecc295874e 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -69,6 +69,11 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
 		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
@@ -78,11 +83,6 @@ static u32 savic_read(u32 reg)
 	case APIC_LDR:
 	case APIC_SPIV:
 	case APIC_ESR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVT0:
-	case APIC_LVT1:
-	case APIC_LVTERR:
 	case APIC_EFEAT:
 	case APIC_ECTRL:
 	case APIC_SEOI:
@@ -204,18 +204,18 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVTT:
 	case APIC_TMICT:
 	case APIC_TDCR:
-		savic_ghcb_msr_write(reg, data);
-		break;
 	case APIC_LVT0:
 	case APIC_LVT1:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+		savic_ghcb_msr_write(reg, data);
+		break;
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
 	case SAVIC_NMI_REQ:
 	case APIC_ESR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVTERR:
 	case APIC_ECTRL:
 	case APIC_SEOI:
 	case APIC_IER:
-- 
2.34.1


