Return-Path: <kvm+bounces-46453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C56BFAB6459
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D752464684
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7415C21A433;
	Wed, 14 May 2025 07:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p22d/81J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F383D205AB8;
	Wed, 14 May 2025 07:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207696; cv=fail; b=c4kQfCu2nD6kCZOQp9vVEZfJ7K6Dcniy6gKjDhJovhVhibR61VCbSc+qnleSVmQSc1P3JFUZl0EHGg+GwGALlA9mDltZT8MlTdGDqivD+svV7KjpaCsKj8V2D1SevtpLwHUCvNfKb0ybTyk4lz89Qf0HKyqmN6SAa0U4pFoGgYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207696; c=relaxed/simple;
	bh=ec2oYbOoxMlApCoHMHlnP3v0IXPiO6MhmbviWaoHyvs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KEVtgYo4/yAFFGXLBFBw5c2OlHo2tcK/eH3kJDfmuAAHPt9fEkACJGV3N/rVxq7GXEvDeaacf8r4k9ri+A0tLBzC5OzJw2lkq783u3Mhn7AnlsFOq5SlTwbSvxe0diJMhjNRvRpc3aiH7x4zGoPawjW0R4CjmyAeiVNZP4/b/sU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p22d/81J; arc=fail smtp.client-ip=40.107.212.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xvu8sD7Zv1HvPih9lHoIUDZeBvK0nX7MYOIMVdUiJiWB011cXdfHJj6qNzpekq5ZSUW+XFZTSoIiY4CrmwNaWxaI+/rLq79cAnT1yiYylHrnUzzE4zvGvmBPwi0lA72NJNXlH13H0LPD/Bq3VtmQSDmuh6Z7/1RhbCCMhT3BPOfs/c8gCYRvMmjvq7H6pytQGweaYnu9o6LFUxH8fmyae3QxBMUu8HSXJwV9Ubhc4wCgqtNUfMt0d9bx9xqBG5FWlv8gtWjJNGmNcDed3OwxFMYiQxXgQzTbDRsOKBgFpnFjJmQZbLl0RiZy6jbzE2TV4dW6GojCQxcLfJSnHlt0Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ontSd48A8TNkTX8/HrnNfWhXb5OM2MBAU0NGzIjUkzw=;
 b=TyLVkc1mFFX1JvB6k+C87NSzi3RoVtCe/t6Eu6xAdjC+JgaK6fvX/vh70/EqxkmrP2NCqdOtxGjkibTRhV6rt9ydugsV+n4SVX68ETIUzmDB9H6h6FnC7HASl/2NU0WtSMikcLgX914uTfH9J0KL+eO59H+8+EOXGsdaD9eB1lnBVD2+pR5GjTesBY0uL4CBUtkWEfENsq0dSaWVgxwzQTDaZou6VKJuGUZBE0jTEeMnQj9l8S6VoUtdnLmEahjklqmh/z1Zag3NMYkFR8aNc58UKx2ZCWR0qlB9M6aNlnAIFUugnTKXZXqMbM7oGU8T2Nb5l/0J2eJyoEPUAqtrjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ontSd48A8TNkTX8/HrnNfWhXb5OM2MBAU0NGzIjUkzw=;
 b=p22d/81JnUXfN4IHk+qMmqzM5ZjqLv5FT3xsgqqDx4F1tVDRUQSwJGVacFt/rY+R/cqEtjYpQq796OD8XW/6i4PrezvaKefCWOwwxggP7rd/KV0uUlqgg3gQKSaTy5cmfx8Tw6HwlnoSKtgRab68vXQFTAbc9O8gKRV76z5oJqs=
Received: from CH0PR13CA0006.namprd13.prod.outlook.com (2603:10b6:610:b1::11)
 by DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:28:11 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:b1:cafe::da) by CH0PR13CA0006.outlook.office365.com
 (2603:10b6:610:b1::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:28:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:28:10 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:28:02 -0500
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
Subject: [RFC PATCH v6 24/32] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Wed, 14 May 2025 12:47:55 +0530
Message-ID: <20250514071803.209166-25-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: 89f2af87-2b11-4c13-0335-08dd92b8e169
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fjV8La7o9alWlTqDLXsainBxe9SfvRu2Y0dkJsohKu8yjeCXZRKUeY+NxbnK?=
 =?us-ascii?Q?liM1C/q20FNajippcXhnlRJYW4cEF7QBWReoPJ2JOx2JfyzCZQjwSueDMEkC?=
 =?us-ascii?Q?acg4X1lj7VQbi0EqTwrq7EcaqPXTVqI956NnZp0jDFtAYst9E/yJOhjrkIED?=
 =?us-ascii?Q?HP/XAdHohMxUCmPrxjxFNDS/GPozjXdrenJUUfEHs5ENVvBRS1j735d6GXjl?=
 =?us-ascii?Q?oO6UTeiWKb28agqEDPWATBkAeys4/iv/fkRvut2JRXzpYJvIAE8GV2o/dUoL?=
 =?us-ascii?Q?NaXkco3sYYzpXLphROfOzviFD37J7zA8YZpKggpe+uCMGq5GmJG50dwbzPDe?=
 =?us-ascii?Q?+VBSol0vFg+8uvN6DZBkf5H/6OLhORApFu3ITCb5i8f+Z/TtZfJqXZ3jpIja?=
 =?us-ascii?Q?ccpu5Bfo5FA5Sjv97w8XGs+uZOdUKt7tRL1PWt7m1w6p67ItOAV0fJ87teU2?=
 =?us-ascii?Q?0US+NUvFS8ssyDl6/WKHBigS7M4COxspknNWughtGHEbeR0EqWAHIND89ywL?=
 =?us-ascii?Q?9gcA45bBBI9nZFthR8TrEW9ZC6hkCQ7RYSjST2SThkij3iQB2QtZqIn6XAHo?=
 =?us-ascii?Q?1a0Q03jbMa5goN1Wm1fzIKNW0g+fuuMWzwJBsOvpW31sPx4sijnQA0AioNYw?=
 =?us-ascii?Q?GnJ1HQVC1r5U9r2fxqnTjdSLPIWVqWcm+HG1gt0afr+ynVQ/ruaAbNZBrE4U?=
 =?us-ascii?Q?uA0NMtJliUDRlDTRx7lG4eP7RZe9hZFhhMbzUWI7wJJKfHMid2XmnxJ3Pdz7?=
 =?us-ascii?Q?xDPQhVpDpA57wtUuDaqB7Vv0HBfBecIos1/mWKb+c5O8J46VghlJVoQnvqUe?=
 =?us-ascii?Q?u/psbOc0E7LeEYzFNzWsmmJzBoo59mLq+PUxiaMxhhfpg4sEBDadIEWh1ZNF?=
 =?us-ascii?Q?2LNlYHsnJ4MTUd4126qJNxzhL54McZTfIp1WbC1JZQGp8j/6AVfvopdctaSm?=
 =?us-ascii?Q?Slinw7W1990YczliLrkqNeexS+NwoP5gcY508ZmwAi1ND9YrMzx2iImqp/Xv?=
 =?us-ascii?Q?r/ChrsX3KxoXDuxSGCcWtA/TqEPaGA2a6Lyyk0dng5EOfBrdFOriXahPBUn7?=
 =?us-ascii?Q?JjFY//4Vf6BzPpyvehk6iTBN5Bj78ZsI2xE/MLjSzp8IlLioYMx+lwE/w0G0?=
 =?us-ascii?Q?KFCe4ztERZt+Fv/Eup9V23bzWGtoixAfRqdEN1VQEykoDsIp9iGw6r5Ypucl?=
 =?us-ascii?Q?2nEia3Ez5cec3pPIyP2MDdeIdDgHbD4yNsRmoHGd6eeIw3o8KmJ6ky76Cp0K?=
 =?us-ascii?Q?FUamshvOgiSh/eIAysEwVEk6JYn+Jc42LePeL0Iu3VpMDtYsuSyBJmFLF9KJ?=
 =?us-ascii?Q?BURNw2ZcooTw+QW8l+vQuXnZDgQXGTeAxE8iJcUQ3Ovs3vvxxL/k6LdL5Ndn?=
 =?us-ascii?Q?YFJMKY/rVV1BgLHWsyz8H79i4GD8VZY/5NOmusK7hVRQS1OJFXQ22AaIlY37?=
 =?us-ascii?Q?eizycwoCHGuppOmYJE2y2g6GxekZ/3joQxK3Nn6bWo6kfGEpSbnBWMhbTllV?=
 =?us-ascii?Q?eHrbQjpN1xzAMv/hzfmzgijlkCrxvLQdiiS2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:28:10.9323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f2af87-2b11-4c13-0335-08dd92b8e169
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020

Secure AVIC has introduced a new field in the APIC backing page
"NmiReq" that has to be set by the guest to request a NMI IPI
through APIC_ICR write.

Add support to set NmiReq appropriately to send NMI IPI.

Sending NMI IPI also requires Virtual NMI feature to be enabled
in VINTRL_CTRL field in the VMSA. However, this would be added by
a later commit after adding support for injecting NMI from the
hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - Set NmiReg using apic_set_reg().

 arch/x86/kernel/apic/x2apic_savic.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index e5bf717db1bc..66fa4b8d76ef 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -122,12 +122,19 @@ static inline void self_ipi_reg_write(unsigned int vector)
 	native_apic_msr_write(APIC_SELF_IPI, vector);
 }
 
-static void send_ipi_dest(unsigned int cpu, unsigned int vector)
+static void send_ipi_dest(unsigned int cpu, unsigned int vector, bool nmi)
 {
+	if (nmi) {
+		struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+
+		apic_set_reg(ap, SAVIC_NMI_REQ, 1);
+		return;
+	}
+
 	update_vector(cpu, APIC_IRR, vector, true);
 }
 
-static void send_ipi_allbut(unsigned int vector)
+static void send_ipi_allbut(unsigned int vector, bool nmi)
 {
 	unsigned int cpu, src_cpu;
 
@@ -138,14 +145,17 @@ static void send_ipi_allbut(unsigned int vector)
 	for_each_cpu(cpu, cpu_online_mask) {
 		if (cpu == src_cpu)
 			continue;
-		send_ipi_dest(cpu, vector);
+		send_ipi_dest(cpu, vector, nmi);
 	}
 }
 
-static inline void self_ipi(unsigned int vector)
+static inline void self_ipi(unsigned int vector, bool nmi)
 {
 	u32 icr_low = APIC_SELF_IPI | vector;
 
+	if (nmi)
+		icr_low |= APIC_DM_NMI;
+
 	native_x2apic_icr_write(icr_low, 0);
 }
 
@@ -154,22 +164,24 @@ static void savic_icr_write(u32 icr_low, u32 icr_high)
 	struct apic_page *ap = this_cpu_ptr(apic_page);
 	unsigned int dsh, vector;
 	u64 icr_data;
+	bool nmi;
 
 	dsh = icr_low & APIC_DEST_ALLBUT;
 	vector = icr_low & APIC_VECTOR_MASK;
+	nmi = ((icr_low & APIC_DM_FIXED_MASK) == APIC_DM_NMI);
 
 	switch (dsh) {
 	case APIC_DEST_SELF:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		break;
 	case APIC_DEST_ALLINC:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		fallthrough;
 	case APIC_DEST_ALLBUT:
-		send_ipi_allbut(vector);
+		send_ipi_allbut(vector, nmi);
 		break;
 	default:
-		send_ipi_dest(icr_high, vector);
+		send_ipi_dest(icr_high, vector, nmi);
 		break;
 	}
 
-- 
2.34.1


