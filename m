Return-Path: <kvm+bounces-28218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC27996581
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C84EB2243E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99791957FF;
	Wed,  9 Oct 2024 09:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mnecRulG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871CB194138;
	Wed,  9 Oct 2024 09:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466222; cv=fail; b=GZ5S43QmkVhKwWjZAKHBNfs+ev9wWktWmkGTFJeYqMZ2RRMYhv7eMd6IbuDhfFfoLVWG/w8FvzQxiVrDjElVUt3ugAfaOzEURFmfpYJKA++kKD7rhXTlJHAO2mBl9k0Szdu0s5No+YvmsQolAgwVXchO7hZi5QkbQzq811YZ6fY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466222; c=relaxed/simple;
	bh=ZGihhFRGncL7DFI7XpsY/vkD4mTqvXHLagNHFWxg6sE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uEosOj/DitrwRriJ52uuXW5PQihsLhrFuoQ1Q62q2yx5XnwoGWIUXr/K9bMEogkYernjKzdeNCShYxO/K+Q6+Mf/miaCpwrcumcNjnriO9I25WWc8oGP0Tz9QVtrZiNMzxTaQFNgLyzmXynfgZ3GRMOJWqqKt9ei3QdY3KxmFP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mnecRulG; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gY3Om0cxr1C9Gywwp7S35311PnSFXc7jiyYozefjBfwB8kgzR9yQOUnfZv4Sn7RR/CU+FbSFHSZUhkmdS19581z1h4R/7wQJw5BGRxeArKlrjIiUodtoroSkMM7QBP7qd9Rg4E5blLasyHw/rqdqcCuDPcm2K2cENF6HfqsxiH5nC7YQlOHj3M4FXeDp9hcMxVoAGvqlyDWE1NuE3M/EZWt54ZUoKDXVlSPTaau5dS+LL0XmMS62b09Jy2k0YqzSl1MMWpJA2Lf4rUvg1aOyA1z2vfpHTWgxbTmN5ec1AX8ZhCP9zZ2BcnXAqN5J/EfZkc+fmLVIZoB1UZ+HchIGqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TYyWpeF2mRpMbYOXrm8LibhPrX88FgF0N9J+31V1M/M=;
 b=o2v0pAypAdI9U7DItnCvn3sIYa1JDpU30Kk0Imcl8rmDFvUbinDHvaRNf61NeBmjzIXHN6/z0Ow9zNUd63Oc4JykUC7Q86IRYX3UI1L7q5fkMC7B541IJRIUWZNu9YZ8Kx7GcwJHoJmtVfd9A0vybzKpChYKE3dQuQyYo93An8fZVj6k72DZDFH9cC4WSsncHU1QEzzZN7TEiBzEsi2ampTWfz10b90QfBthJxIQW0voRe8loHPAdsAQSKrs3kmGFV12qEzskB1ANUqA7GzqXspEWyppuaSJgl4kvKurBU/Yu7w5NJgvhNB7W/BQ6SahFOSrWNLioYxv7NokXbqyYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYyWpeF2mRpMbYOXrm8LibhPrX88FgF0N9J+31V1M/M=;
 b=mnecRulGDOi9yju+wuYiX011ooh+MNV87j6XYw0eTm8jbEuzwIB+AD0e1n4n2VJovIQ9DYUTraxbSTDehKkQU+pw/JqZ1BVOvptg4+cqjIh+xkBWjJi88HTSt6RCW+qbgTTJEfPQcIoR73x91/Umr8QyN/h7CmoUIFn4Jae0PPU=
Received: from BN9PR03CA0106.namprd03.prod.outlook.com (2603:10b6:408:fd::21)
 by PH7PR12MB7307.namprd12.prod.outlook.com (2603:10b6:510:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:30:16 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:408:fd:cafe::75) by BN9PR03CA0106.outlook.office365.com
 (2603:10b6:408:fd::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:30:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:30:16 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:30:11 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 17/19] x86/kvmclock: Abort SecureTSC enabled guest when kvmclock is selected
Date: Wed, 9 Oct 2024 14:58:48 +0530
Message-ID: <20241009092850.197575-18-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|PH7PR12MB7307:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d8e2200-6401-48fd-84ca-08dce844fc0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8LdRaG3hFmonnzKr2Kboumqdj9XxhPDKea/l8TVEq+yUJwywMkX6VoQp9QH9?=
 =?us-ascii?Q?F441yVN4t93DsNK3WHb5oW2DQaZlmAEeJe/6h0Xh8majPCstCkfgf/cIme43?=
 =?us-ascii?Q?uCbVnJvG0hnFy1+np6d6HpDENRCNm9i4AVZAvw/JC/DtCuM+RzG3gKagj3mT?=
 =?us-ascii?Q?mn+yS5ccs3O/1xDhauBEYuk5z6CtZrg4M/dL4C5Q4TwCa1B2HxibtYsd3lEm?=
 =?us-ascii?Q?ebX/TOuhylldNNht+dcp/Bd/85sGx9mQw/QmvZ2DrVAXaJwt66QAPSFZ5te9?=
 =?us-ascii?Q?ANcaS51HLfn4MJsiEu+8y9I2ivloLxQhqQCqQ0bBYg3qXVV3PXegcJMLTPWZ?=
 =?us-ascii?Q?NdIuJfou/LkOFs7778D3t5uj75QWk/v930X0CR0nnCCOt2eG36k7nVsGnPpQ?=
 =?us-ascii?Q?06TEhffBzRK47aKtjih6lEeKPtAV5/Z45WY8OcR6Un9pyKo4WZBJwHYY/rt/?=
 =?us-ascii?Q?mXQ3OUJhsC9LunboRMKQMRAoK7fo4lwnlL5FIQ4QAKozCqgNZPZlA9Nk1ZjE?=
 =?us-ascii?Q?pAj05N60za+IN2HnH57Fp8zcVMmk9Rzd/0gGi7b4iw/2fbT96CPbZEZ3OMYq?=
 =?us-ascii?Q?RRMVu3MUzmPC1Q1dy6+N2OfSuEfUxoFmEc6t451/tPUf9Xb2UUww3iPmJ+94?=
 =?us-ascii?Q?mVo8qt6yUe/02VhwDUfUjSLCtLsXsVvOAds7dqUvNHwFa4iBFeSfpFxe9iUK?=
 =?us-ascii?Q?4af6PWgFUkzB32SkplI8Tm2JgvhtAJtGIvfQGKLz4CQ0dR+JQqFk064dQLVG?=
 =?us-ascii?Q?d4ywSFli/XZdmoWO+bLU38nY/SrowlKPV9taDI0D5BuW1RBDnrmA2oz4u1+l?=
 =?us-ascii?Q?fir2Gy2V4mrJCkTCWJZnM3wR/imgXcQpoI+Bu23P4n8lagiWWtbQQKEkExbb?=
 =?us-ascii?Q?RrEhiGjIw5Azp8PTUfc/+74wGSMl4MnPMWmLHEW4ThCjbQZj5r5SCSV66Tar?=
 =?us-ascii?Q?5LXQ9qd+w8G2Sdjy+X7A9o8iuSqimKUAB2FQ3JGqEMEvIEG0q1jedodncCFx?=
 =?us-ascii?Q?hVvc8I3iEC+xWt3Ss8Z/IcegalbRD5KYEpCofLiSYhVlttoQy9MhtS/2beeW?=
 =?us-ascii?Q?19U+6KMUaKxBoYlQjvLYN1aOCk/SaXGfiCStNlmx5cgXHq2/aYFRkl2ziBBv?=
 =?us-ascii?Q?CogFUiKb3wn1of3F7JGePpHvLVvzLs8Gzz31/Hcdgu0gZ0qv52V06HkjNLgO?=
 =?us-ascii?Q?6fB9fAn51hBTHuf5yaqqFRP7wMY3QZi9++rbNF39cldkIC+tDaFiE2gSpzIK?=
 =?us-ascii?Q?PsWuAoUcDNvX0H0CzM/2Tciwpc9v68/LoHPGUwpD5dc3nIqtBQ8KIncvFwid?=
 =?us-ascii?Q?K83schdbvEYOsk2+gShzPYkqAYT3siKS32nADYZdy2f/3psO4WtWQdy2aorF?=
 =?us-ascii?Q?5B7S+n6Y814BkEYAfMLlZs+YABt4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:30:16.2954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8e2200-6401-48fd-84ca-08dce844fc0a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7307

SecureTSC enabled guests should use TSC as the only clock source, abort
the guest when clock source switches to hypervisor controlled kvmclock.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/kvmclock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5cd3717e103b..552c28cda874 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -22,6 +22,7 @@
 #include <asm/x86_init.h>
 #include <asm/kvmclock.h>
 #include <asm/timer.h>
+#include <asm/sev.h>
 
 static int kvmclock __initdata = 1;
 static int kvmclock_vsyscall __initdata = 1;
@@ -155,6 +156,13 @@ static void enable_kvm_sc_work(struct work_struct *work)
 {
 	u8 flags;
 
+	/*
+	 * For guest with SecureTSC enabled, TSC should be the only clock source.
+	 * Abort the guest when kvmclock is selected as the clock source.
+	 */
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		snp_abort();
+
 	old_pv_sched_clock = static_call_query(pv_sched_clock);
 	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
 	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
-- 
2.34.1


