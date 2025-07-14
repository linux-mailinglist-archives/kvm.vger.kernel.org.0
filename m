Return-Path: <kvm+bounces-52371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B03E8B04AE8
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 063AC4A547D
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93556277807;
	Mon, 14 Jul 2025 22:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3IasiAKm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBF523AB88;
	Mon, 14 Jul 2025 22:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532870; cv=fail; b=AuPUwvZLCWSdP7AP4Jy59C38iTKGtkTf/bSqnNgcEzPU6VTdWoFm89jPzitMcuwVwcmuWk6yOAE3tdLZOFALs7pODF2SrNvx0eOtffdogCUXVrnA0F1gDdrumMVJzaYHyeOT4ovrwhQsj5PLEQIyzmH13rIoLvh4z53GGC/Fruo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532870; c=relaxed/simple;
	bh=k3b3Kwl4w+k8mCBNRiH/whks0Y+Q0o/aDRxhlmx/92Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDy2WKJSt1bqBLyKTGdJo03NeUXml9BlaKE22l9dRFg4/kFYBgGrQ2i2pqgs4h6QJ8NviAsg2ely+3WsoWyacjv/wWpAISGF4lgNyEp8BR71h49QZktjZEotqFn1eoPG+3YZW2Dh3g3I15QKwpKqbSe5o1aDMwsioAK0UXM2aBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3IasiAKm; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kiafzn67VqTT3aU+FlJZjUBUdIGZRvz8eCbUuUdacqXtUZqv63m65VkoLy0QxokGE7qgHs4/rmfHAG/G527LViyWKN3KOUVcp/NKjNAGhifiecxmkzbX1J4icYFHcIphzraaeiCwCA4KMXu6iAhUxmJkwqvsgcFbfLjTOVU4EcDml6V079AqPsdWBMrofw8GHFNlV/KnQGCc0Knf+ahbIBuzsfhpaYaeTnI5ItzxltvLhUOjo85XWd2sew+YTVnntIQqViO896MBSSDzCh/ptMmlVuulHKkl13P0OBcgpeL3Jt4Jdb1Fvo+sMhDN31qljg4cyLE1sHPEeM2u35Vr/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLk1Y0waLJHmC1DyGlS8nXASij51QxXm174IApykxg4=;
 b=GaI0POQtHAM8ymAJAxTWa0jNmWX8OA75cZzxP7DAcJr3QNCGzXbtfwvREMPTB1ULddWbLAW4VAAw4lEmy/N8GvkqIdOE25dytXykfcy/2+JCMiiR0OSKfIgFL2hZEQt5jAMmFA7DEkex848sct2PmLwGYwy+LFM0YVJdhoTAkO6RAp7B5OUK9HMJZh3oJIbQHcnfOhVrjKOJMFDTBNQyls3A71JHRGomt1aODHAOQPIHlwaBtbkoNduIK1OUCbS6BdTeGFWrrD90gM26IoyWqooIpyAO7xGea5Ao+tGKQCXh1tUp8EU9mOkqc3Vt23+7ukFEXn3o8VQPjzK7Adjg7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLk1Y0waLJHmC1DyGlS8nXASij51QxXm174IApykxg4=;
 b=3IasiAKmDortwS+oenqKNu/iBWGSsO9iiOHTWOIFjTXIYlprIVRMhCBPQQN7TI3LZ02wmn39pyMXRthpWAyR5yukt9+T8MM4ONxi7xZk5bqQeSSCkE8LcW04t8fYwpXI2nJYHSMzpowltCkTdSqHdJkhIbG/LJnCKClxDRH151k=
Received: from SA1P222CA0077.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::24)
 by CH3PR12MB7524.namprd12.prod.outlook.com (2603:10b6:610:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 14 Jul
 2025 22:41:05 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:806:2c1:cafe::4d) by SA1P222CA0077.outlook.office365.com
 (2603:10b6:806:2c1::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.32 via Frontend Transport; Mon,
 14 Jul 2025 22:41:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Mon, 14 Jul 2025 22:41:04 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 14 Jul
 2025 17:41:01 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v6 6/7] KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
Date: Mon, 14 Jul 2025 22:40:51 +0000
Message-ID: <7f36b17d23fab99d101de62ed2145af88d1a7273.1752531191.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752531191.git.ashish.kalra@amd.com>
References: <cover.1752531191.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|CH3PR12MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: 917c421d-0fa0-42d1-007c-08ddc3278420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iTU3peXxOhix/7vGR0JK0Z3iLU6XPNo3KZ4QSHFaPNrZFr/J1NccwmKNLtfK?=
 =?us-ascii?Q?km2b8Rarn3x6RWaEPsy8MVuVLZmfOk2d+UR2tqaTFcEv11VOavkDjcf5Ytj7?=
 =?us-ascii?Q?b1AvLgROgrrI9FDYMK9QNcW05zwMGW6IiJfAbsSLzC6IBawreQ4wb60NwUuD?=
 =?us-ascii?Q?QduQg87F/vFYsWbBt3XPZlweN6YXMLDwcRXIIYe4eYi1SinFMqxeorTHckxG?=
 =?us-ascii?Q?V5QDAvG+0hbyHFTJFEuFPe9k8XWPVHDSkASnlxLTggg9hKdrFxrpYYoLgfe0?=
 =?us-ascii?Q?ELmrdAfWGZ2vupJAjIEzswwk0FCU/o+hB0QSHnEaKwBrWZxQDrLveFuYk6FB?=
 =?us-ascii?Q?wzVs/ynfxM2WRlY3+lOvaM5U9zrzHXp7Wk6PIfOvP/My//DtUNoZ1tpo62Qr?=
 =?us-ascii?Q?9EF7Ulp/hyKlovWTKv9Qp4AuKqxWZfMGGO8bTF92KekIcW+eFWgSIQOBJ0wJ?=
 =?us-ascii?Q?wfIVYRfoIaKDm0FxkBM0JpPZiO8hooHAjm6+iTq6n5WG6trUw8sQXJEhh4dt?=
 =?us-ascii?Q?LM5RSxmT/HlxCEl1BAVTwIEdYogkrhPm1NrLlYM8JjObg9t5bfGjH1WK7DTK?=
 =?us-ascii?Q?iuHLTl9DNJ2Vrqe8K3ifVNQeIDTL2gxFwn/NaBUHFzxudKA2tk3DqRHqiOIa?=
 =?us-ascii?Q?DyPTEwsYtNoLcd3U2fdP3J5/jN/RJE2X9uVCJEvGT7/7tvRUa51lCw0Y+sHP?=
 =?us-ascii?Q?BSCdgxdC7vUHOVUHUfnqTARkGCadJwjWdgf3URtLN/5FUWoMWF/NCTaiGzT/?=
 =?us-ascii?Q?xI+qFmCPTICjNko6ET904tDvamJEHYT24pg/199P1DW9R7u1/a1H7L4bcENr?=
 =?us-ascii?Q?tP1mfbg2RExJG0S6+qI7YJePDYl4VSJAcbAc8dB/DIiNsx46OtVQD7Nd8c72?=
 =?us-ascii?Q?lD9UQJydD9eilWaY9GpTnblLgd7wRbLpHEwsuUqeBnAO7fY49h6+CKgyaBr3?=
 =?us-ascii?Q?cvr+AC3mc4RtzvNa5jG6VVVPGhwnhcvfMar9LJ4Cl1bJ4qK46wHHwU6B/SwD?=
 =?us-ascii?Q?nBUZaXP5ivg7evSpWbMycd4Vb1oDkdXIki+49JIF3BgyN49APhFwsPXHstew?=
 =?us-ascii?Q?Ao2C2t4w9fc8LHR8Y2bsEuHkR7qdoLHn/NztSOigBqDx3jHtL/EJYgaB453o?=
 =?us-ascii?Q?Vi0XHXC4OALrPWurm6d0e2logz29EIGr9SLdlXzxclgm84cS4TpYSXD1uN0s?=
 =?us-ascii?Q?oiFa/TONC6U08VHp9uQdtLi6O29txilZIW+xb22WWWgE98yui0rl/a/zIlI/?=
 =?us-ascii?Q?IbVmo26gnUvD9rgXEKUFiaqO0UItyx7g+9qIwyMpMaM91K942GO8Y10GDWr1?=
 =?us-ascii?Q?OIO4Dh5BPwV05N0fP2d1NhBMyGKNafOX2AXYZl2zdEm4FT7Hd738eqZndjOn?=
 =?us-ascii?Q?/n8LeMwCFFzHvTxQ0Iw0+2iiOSI8UjIUiAO6KKtxxcYRgnbi2IyCa2ZQyHXe?=
 =?us-ascii?Q?y99MMagXh4A7ItHcBRTnH8HrgDDKe7t7lLp/gQzWg2xMHdteI5Qd+zqlkrOe?=
 =?us-ascii?Q?2+D5G+g3meIW4cKo/WS4jAhxqf3DvH0VTolhdAz22UY1WD/WMLZoi+1Jfw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 22:41:04.3669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 917c421d-0fa0-42d1-007c-08ddc3278420
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7524

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce new min, max sev_es_asid and sev_snp_asid variables.

The new {min,max}_{sev_es,snp}_asid variables along with existing
{min,max}_sev_asid variable simplifies partitioning of the
SEV and SEV-ES+ ASID space.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 95668e84ab86..77f7c103134e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -85,6 +85,10 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned int max_sev_es_asid;
+static unsigned int min_sev_es_asid;
+static unsigned int max_snp_asid;
+static unsigned int min_snp_asid;
 static unsigned long sev_me_mask;
 static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
@@ -173,20 +177,31 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 	misc_cg_uncharge(type, sev->misc_cg, 1);
 }
 
-static int sev_asid_new(struct kvm_sev_info *sev)
+static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 {
 	/*
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
 	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
-	 * Note: min ASID can end up larger than the max if basic SEV support is
-	 * effectively disabled by disallowing use of ASIDs for SEV guests.
 	 */
-	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
-	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
-	unsigned int asid;
+	unsigned int min_asid, max_asid, asid;
 	bool retry = true;
 	int ret;
 
+	if (vm_type == KVM_X86_SNP_VM) {
+		min_asid = min_snp_asid;
+		max_asid = max_snp_asid;
+	} else if (sev->es_active) {
+		min_asid = min_sev_es_asid;
+		max_asid = max_sev_es_asid;
+	} else {
+		min_asid = min_sev_asid;
+		max_asid = max_sev_asid;
+	}
+
+	/*
+	 * The min ASID can end up larger than the max if basic SEV support is
+	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 */
 	if (min_asid > max_asid)
 		return -ENOTTY;
 
@@ -440,7 +455,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-	ret = sev_asid_new(sev);
+	ret = sev_asid_new(sev, vm_type);
 	if (ret)
 		goto e_no_asid;
 
@@ -3021,6 +3036,9 @@ void __init sev_hardware_setup(void)
 	if (min_sev_asid == 1)
 		goto out;
 
+	min_sev_es_asid = min_snp_asid = 1;
+	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
+
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
@@ -3044,11 +3062,11 @@ void __init sev_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_es_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_es_asid, max_sev_es_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_snp_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_snp_asid, max_snp_asid);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
-- 
2.34.1


