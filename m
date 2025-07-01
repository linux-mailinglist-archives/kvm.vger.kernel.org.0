Return-Path: <kvm+bounces-51221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4C1AF048A
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A904A4A82E5
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 20:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B8F23C51B;
	Tue,  1 Jul 2025 20:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JverPyZ/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6AB1E9B1C;
	Tue,  1 Jul 2025 20:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751400988; cv=fail; b=YVMKfJMJ1/3uv0HhUcUx7l4zM9rrCcUQBNIV3TwgcxWbl8/k+zkbdEjXRES4lZMKGFneXtieILnbAqabTqoaOki779AYzsQFZZajWcP2X2EYhbeuGuufIlliXdgRmKAFXsMzdAZJXROAWZcb0Z/NGJzq6JPlP088KReOR0fYu1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751400988; c=relaxed/simple;
	bh=5pCf4Gb8b6TzFM60kREt4yCseuNtIRvgYfF1P0fiKSs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ivVe8qLzcuel/EiBiiqdMUnxaMBc1kHIBm2Z98+AYbgsjKQBq260XcnE8e3qMLGv/WU7p6myqXDSbwr1+t2z8/VTjiZsV0LFlKIRZFMRmrCofxqzGg6AkbCl2LW/Fc6h+3n0taGhHUNy5C/2mj0WwxA7HBHwd6m1BT1ov80V6zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JverPyZ/; arc=fail smtp.client-ip=40.107.95.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j14OeycT1peYap6o889xFFqRBwhpR218rOtuC5rSMmILi+FFrGq8E0fN6oJEi4G9RrILBQGZOWYDPeJfAO9hn4SQ4FCzzm+oV7eSmpHY5RZMWbcLoy/5VWuuAtyCmc3Nczfqww1UdJT88ufJ4lPYFqS7azo0gPWwh/Mw0BAi3tyvi6Ivzhw3atrePnqhoK3EfJYRn8DeLpGogdK3Tex3Dn745eUDqFKhPwpOC/C/6W8gpExbMJuKAlBQ3BWwcFt32rvRozb0VreUfcOhsqCEJM6oM9AZkPBcVKF+AXLa79m3HBVbaF7Lrifl3NeXnEiU0J/JPAJ8lk2zijVf0M309w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IdWNoaFPCDX5THysnOoYVM7n9Bc1pkUPmtH3ARfPUPE=;
 b=SnWf4EqUilk9VKPiwZC/8MbWs8DGxwVxoHN2WVxh4YNLdi0R57Dwk83dPr1KhUOXxJH7Z4/E6FLM1wdhRSESSdUFzERIQSn/klMxGAbxSWj4EDehuiqBZQ8nUie7PDEmPtkhqsjQApryuvknRK+A6rMeyAw/Am/LEiK4+0L/pdQUEViMtxgin2ogz9dVg+sOL11nb1z+FGSxpA6OIK9TVRhZ+9K7EoZs+gLMoO/4HT5340Ifoq2MM+Ll6MBTOEyeMXtu0ywnn/8s9M190leIQk3wmCHqrT4fOR9VaJWRAE+E3qWCo2JRSEHmZyo+lHYL/9E6nQuPguvCBQlgcl4x8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdWNoaFPCDX5THysnOoYVM7n9Bc1pkUPmtH3ARfPUPE=;
 b=JverPyZ/JAcJE2A9itDIx6FyezvJvmqOUc8kC6518R2L5qWb1lQnuLhW6w7kd6zQuFjcLgC/KKn2aFYhtU6lP5sptKlMilTRxUA1lVObW3KnlXXhfFAGPZd0B4oYKgS8pih5H0iMggY1VsPgspAem7lSQRNS3qNZ5mgUIIRMxuc=
Received: from DS0PR17CA0021.namprd17.prod.outlook.com (2603:10b6:8:191::16)
 by SA3PR12MB9130.namprd12.prod.outlook.com (2603:10b6:806:37f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Tue, 1 Jul
 2025 20:16:23 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:8:191:cafe::f8) by DS0PR17CA0021.outlook.office365.com
 (2603:10b6:8:191::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.19 via Frontend Transport; Tue,
 1 Jul 2025 20:16:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Tue, 1 Jul 2025 20:16:23 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Jul
 2025 15:16:21 -0500
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
Subject: [PATCH v5 6/7] KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
Date: Tue, 1 Jul 2025 20:16:12 +0000
Message-ID: <d950b7bf35c3b5492f5f2d9c4c50a70efeac856b.1751397223.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1751397223.git.ashish.kalra@amd.com>
References: <cover.1751397223.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|SA3PR12MB9130:EE_
X-MS-Office365-Filtering-Correlation-Id: b99bef41-ae26-45ce-9596-08ddb8dc2673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+QIlXYhA/TA/QC1EVGHr0RUqH10hPUvgrjL0Q9IzaSNs4pHYDYRjEXms4UTv?=
 =?us-ascii?Q?TIOs9EXIgauDa0sogeri6K+gdpLbRbXAZgAcNFIIRii2b3hsrgY1tNi9e80t?=
 =?us-ascii?Q?IAcGTqZzbsmtH8+G/nESiMtJDvU9+LazXMRNIJQ5WaIi/0udD/Ja+DWIjdRj?=
 =?us-ascii?Q?+JwQCTf+wKUBZIF6ofJR44af2hSUYE0aSvzUYQ+Ez8t1vK1iDLR/7fFCYWhh?=
 =?us-ascii?Q?ro+iU7MuVkzJUPD186R2sigkxUA+/QjBUgHato2TVtCQUBzcdT+dfiqDNyay?=
 =?us-ascii?Q?4l2XKvHvlSKDgWiZ89895L61DLIOv3MYSu5aicdQ9r2yfqPW84wVMsvFEVDb?=
 =?us-ascii?Q?0xRluqkM6a9oZ5vZY0sTG2ZK68s6ixocjij6xh5W0MEvnJLOn9KvqXvaUIJ9?=
 =?us-ascii?Q?KIl4K0ARLVDzp8Qf00+2sJvor6A71mBK8kbtulAM1Zc0BYcbaE7hPPBHf7Gs?=
 =?us-ascii?Q?rkhR0eseppsQjVSEAwhipfsaptwQnDhXkGdSHch5iXxfUM/AqF2Mu8rnqZAx?=
 =?us-ascii?Q?V8drPVVQoYFDiRhrcrU8AlJKhl/qizNWk5l9Ut+Kav4wCS0lVotqWs44zya7?=
 =?us-ascii?Q?R9Hwt//pz6X1oFnnH4N8KVvoKwU3Eexu4PqJSu5+V3jeedL8qYnblgmgRN6a?=
 =?us-ascii?Q?XG80Z9CereTsGWjIt4c9zhW+hmRDcoT9ZxYgUDs5S8UutTKd2sU8+MLhdx7q?=
 =?us-ascii?Q?tSG/mghGAQKtLHHoTNpeHmVtbNJZCGDVjvt7r3ZvZraquhSzhTOYiKnRUZjp?=
 =?us-ascii?Q?ZSjiwRstZC5HxzOrbXudzbJ293JXL0ru65b7j6fTlw4YL6gGjZPj8sQxCNR3?=
 =?us-ascii?Q?aOcIP9lPVO5wmQl2/nDm33W74Lbua/Ppg6f33nAwEx0yrpyvHyza4RrtAmV1?=
 =?us-ascii?Q?iwG46vsM9JrPDQVLQ6r1+PesqGdIDj33/5BK+O/AZ+W6bn0ergQGEh1805X/?=
 =?us-ascii?Q?hN0hFv9twLox3pIJihRcVekbAyKGzN3q4NWxdyrYWkRPAkDr5xFat/XeEOGj?=
 =?us-ascii?Q?NaAVgDIu4rgjZCuZ51kfvSozJpyEKvO+eGm1aN0Zvo7faGncx3DRvAu07imG?=
 =?us-ascii?Q?nV6+Sa+gtHhEQ8lDaLej+vTaSKHsn41vIB9xlXSv7bKZ47zgEmdYp8PYJXAp?=
 =?us-ascii?Q?QnLymull7fbvgsjz6VhH6rewBYpDkM6gaC03EXr6XNJ+fjXhwSN3LMam2odx?=
 =?us-ascii?Q?9XEKYE5KrjP7EkLjg0p60vsrjxGypcMSBA/3oAXBQebWbOV8iTyVCTxIHYg5?=
 =?us-ascii?Q?sqZ5V4IanaDFSQpq+qAfoNvKdjRKo9APSRlYUZBv+bZpzaLihzbIrTdKYOY6?=
 =?us-ascii?Q?vs4b0LroARlNtvIXYKEWUXSXZ3AoWiW/9AEP0pV+wB6YYqr3zV9s98NsutlO?=
 =?us-ascii?Q?C3EObRNO57ScQWaw/GhBTPOQoo0r+5hXYXRm4uvZS2rSQ+UykMzady1bItTQ?=
 =?us-ascii?Q?cgWYyzB2C39eS2VD1VOxWqZpO7q7V8o/V4FGtRIfEvnCpcR0Rdy8PTFGZvHd?=
 =?us-ascii?Q?PZYbMqqp+08GAZ9N3ca0FY7G6v4JfvfwIRy/6sJqTUZsbvSxyEBVSH91Ag?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 20:16:23.3113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b99bef41-ae26-45ce-9596-08ddb8dc2673
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9130

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce new min, max sev_es_asid and sev_snp_asid variables.

The new {min,max}_{sev_es,snp}_asid variables along with existing
{min,max}_sev_asid variable simplifies partitioning of the
SEV and SEV-ES+ ASID space.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fde328ed3f78..89ce9e298201 100644
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
@@ -172,20 +176,31 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
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
 
@@ -439,7 +454,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-	ret = sev_asid_new(sev);
+	ret = sev_asid_new(sev, vm_type);
 	if (ret)
 		goto e_no_asid;
 
@@ -2996,6 +3011,9 @@ void __init sev_hardware_setup(void)
 	if (min_sev_asid == 1)
 		goto out;
 
+	min_sev_es_asid = min_snp_asid = 1;
+	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
+
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
@@ -3019,11 +3037,11 @@ void __init sev_hardware_setup(void)
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


