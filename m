Return-Path: <kvm+bounces-28213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09271996577
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CB061C23C95
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13880192B69;
	Wed,  9 Oct 2024 09:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RBDTwyM2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56A31925AC;
	Wed,  9 Oct 2024 09:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466203; cv=fail; b=fX/HVa0Wdo5ik30CTgdHthid4pvX5p/lQ/0iX1UeJeH5/wscUV/oF6ri1MfjNPdmKj6BOPC39GrvTXssj2jqPPl15aE+ceiZlUnKC3wivUB1R2dacjfciOeFwr4GtG1QSXdXN4CSdHn9hcdhZrslMzq32nzirPPnkAIznSXTNSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466203; c=relaxed/simple;
	bh=wTiiW3zg+ZEXEs6HyoUwSSwd2a1sEJVoTxWCh49OUQg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WjaDAFZP4AIFljP/GpOQZ6yE+sYtHPU+jPLAIx6Rtpq3cwtX7D0Va0IL9JCivbJTroIN+iX2r2NxM5Nke3q3TahWRmnlA7cev2kIyRVzgJwl9HUqY5EZojMiCm41AKuCgy6jkhYRSHfVo9RAeBcFRl0bMnFf53N74uqwBE1qInw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RBDTwyM2; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DYPhSj5sNm0WFcrSSUT23pdYeDbSRdzpbPHDOdw1rGsrs+UTAzGyv1M5xFD1tOwuMbKzLq8Br3ingCqh3jabJyc5737ELC4Zjvicp3EjZO4ZygWAupYSeEjWK75HNW1Rl/XKpU+vdQQTtrW14CCpVYslN6lHRrJPVX68EQ9Sgio6voXII9k1XJ3GaoKWtacx0qyOpkEwawqaEUwhhE91u0KbCSYmnzGQ9qZjWJ+Z0jlJcZyyur1syVEf7p+pbwjnfIm8i+7QT3NbKI3mlsFSmFFs840ITj9wpQfMLdTFniI+dhmU6vUpR25zbCHBTb9Pa62YE9JnQHSeDHwNZKwRLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJbrswFKIOzOu5VNK+d/iLVqlwq3bvmZy+UUG5Gjm70=;
 b=ptI+nwE+eR9ghcpoMxpYn3mTnE4FVsqfR7zI9UkmAJtVKWnGyov7J3BG/OO1YMKAkZ19uZ5G5ousipY8LtwAHNpBxW2d70dEkbYtibU3g/f2ToArkofFMj5xlLKjIXvBQTGzPCIde2xgJN69G4yo1PDgd07vzBZ/fz7yrerIDyQJCWvBp+/vLyqmxwMXcJFVBW563bj3bK5Xu4frZMFNn610l1F9neqZ7fLCTImD4xE3SK8/JpQChE7w7DoDuC8fMe9vs1MkwtoDEAQYpPLPata/fDx01cZofYdVZLT4lIdygkJRETHBa96SHXRd86rSNwfCw4QSeMPTEJedjO0H8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJbrswFKIOzOu5VNK+d/iLVqlwq3bvmZy+UUG5Gjm70=;
 b=RBDTwyM2xrHB8+1k+DyQjyTmPvmXRFWKJOJduILd9XpHZuf3v81fRgkApCumiaVKYLoulVQY9A6o/j0p2GKTIkn8zCXEVjhY+kBZv+1eCQYwqH+yZhpniaHPXPzgQbY5IP8XkkYHe3Kq03v063SWp6KHLAjmO03O8wlQDc5eUjE=
Received: from BN9PR03CA0296.namprd03.prod.outlook.com (2603:10b6:408:f5::31)
 by DM6PR12MB4355.namprd12.prod.outlook.com (2603:10b6:5:2a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:29:59 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:408:f5:cafe::86) by BN9PR03CA0296.outlook.office365.com
 (2603:10b6:408:f5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:58 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:55 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 13/19] x86/sev: Mark Secure TSC as reliable clocksource
Date: Wed, 9 Oct 2024 14:58:44 +0530
Message-ID: <20241009092850.197575-14-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|DM6PR12MB4355:EE_
X-MS-Office365-Filtering-Correlation-Id: 913b1f5d-f601-4d1d-4bd2-08dce844f19d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4v1li6dCsqb+9EpkdHDKFmnBuydq3PPjjULafyRbv891W/w7iUucj0aDhTes?=
 =?us-ascii?Q?YqALkYp70rlUEhIe/B5IpZDX35RT0m7wUenjnPTzgLgCeSCX7YTCDnHJ97mU?=
 =?us-ascii?Q?KmKJdYbxRBCgFMVInWtM1bPYzwuDdgIFl6RljobyStlLDNmZ6AJkrG5iWgNr?=
 =?us-ascii?Q?TEJr9T3URtxgQLUcNfDk9aUCsNmTABAJ/WW+pqLIhWcQqWzOqq9ky+4Rc/1/?=
 =?us-ascii?Q?jcXON2JX7IaRPTILdplstQRPyElLJK8kcGmkRqan/f0GYBUS6TzN6+n1fxuP?=
 =?us-ascii?Q?59SI1jKP8nY4naHXdC/4S0de/ITPVii+GkUv9cojB77IT+XXdP9/TJXO/rOR?=
 =?us-ascii?Q?nlmVMvsdSi9cpsnYOdDu1D9dsat3olQEWxFdNtFV5Laq6MX/PHEcC/aXJfzY?=
 =?us-ascii?Q?/xVAwuyNXRY9YTGB+42VFn47Bg8ZXiuc7yPEo12dgqa0x5B7QoOEX9etMmEa?=
 =?us-ascii?Q?nxglTHj0COnwJ1wP/uZzEV4d6H0H8oSpjCpg8PDBs2OjlhWEhiSYNgolv/ls?=
 =?us-ascii?Q?j/gaLPWtV5JeeYXP0Bt9TCv8J4aWeVShPcXHnDBUFMkBC0pP631Ap8ESuDOq?=
 =?us-ascii?Q?00yOkXR/zscggEmfl+9buocIuM1xncsHqwM+QkuQLYNfO6W9s2yXRbchJJoU?=
 =?us-ascii?Q?SfV2RBLYb/MbYdKghKL7RxZjpXnAj/mFv6Ww924OK1M6KoE+w3yhJm1bRExX?=
 =?us-ascii?Q?MRSyUsq03QMO7WOikwPl9dLEdclSJ1vKdH8Dc0uzbFJf3S9t6lFLzdxOk5vQ?=
 =?us-ascii?Q?hqNp3f/b9XsVMBuWl9upCrVl5gOzDuLywBIuXrV83KeDEJUFFS/tHx0gfMu/?=
 =?us-ascii?Q?MJI4YqyUdiGkXngNSrQpCGIUXpIK3YU0S1i4gzRGIIT7Jr2d6f7fvBN7bVSv?=
 =?us-ascii?Q?h8If0c825D1PBBI24fnpK+ffvl4DBA4eyZkyFkNp+uthzhhqwt5dGpoWL7G1?=
 =?us-ascii?Q?eMFJa6dUnXNVUwqz8VScIIZeVMXzoOykXqCuiEpTugK2YXYgHA820TyAYJXI?=
 =?us-ascii?Q?hPnmDrjk/QUHyZsAtlMohvfVIMpIist6xAVtCAqVS2itsjhdWTrt6P20Qi5Y?=
 =?us-ascii?Q?g7S6nWntNg80A3X5JesvYG94vbxeryCwQ4bTPMqBuv77TAsmlMnXaivaHwZY?=
 =?us-ascii?Q?0GiJKrq+tBCkrRUXrqjJm3lFl+jEN+vm/fPMZrALtv7j84XtJnVmwKVJxwqo?=
 =?us-ascii?Q?QBbzU+v5mBhM9i12dNhCwXNcDsKNZ5A7pgtjrwmGdtVvcCPeJ1T+V2+a2Fnq?=
 =?us-ascii?Q?B4UFeScIQnjUZmzANC8HwXq3SpLFDJUcWXw2rLW3OgsCsYw9PvJjHaVnwGV0?=
 =?us-ascii?Q?Ode/ICzcJrJrXmvJl4VOuhSqpsITgdKIbO5LC6M0rjFl3EMN2vSaiqnqlPBS?=
 =?us-ascii?Q?obkhxo3a6wPJ76N7RqmEMfHJGJw2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:58.8180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 913b1f5d-f601-4d1d-4bd2-08dce844f19d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4355

In SNP guest environment with Secure TSC enabled, unlike other clock
sources (such as HPET, ACPI timer, APIC, etc.), the RDTSC instruction is
handled without causing a VM exit, resulting in minimal overhead and
jitters. Hence, mark Secure TSC as the only reliable clock source,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 86a476a426c2..e9fb5f24703a 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -516,6 +516,10 @@ void __init sme_early_init(void)
 	 * kernel mapped.
 	 */
 	snp_update_svsm_ca();
+
+	/* Mark the TSC as reliable when Secure TSC is enabled */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


