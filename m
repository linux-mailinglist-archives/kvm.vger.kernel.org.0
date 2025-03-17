Return-Path: <kvm+bounces-41161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E80C0A63F84
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 06:23:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5F8018902E1
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 05:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB7B8218AD1;
	Mon, 17 Mar 2025 05:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LHOnWMIJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45286218AB3
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 05:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189011; cv=fail; b=Ao+4dtiwL9pRFMwGOiKWVQibr+1L0ZrRL2qUjhoO9UVPJcMIH9NGK/x/I0D2YjbosWZewVldd/5Amj70jg2cy/GFXFSQ9iFrrtHgVRSE3DH+HJdn2zEtKwwqlOaF7bsw8tIcNIWHrZQL+So/s3exj/bZv6Vfy9B/P9P/RRoopoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189011; c=relaxed/simple;
	bh=RvJeBBEIimdeJW27KD86TenZCjA6GyTtbfVqkGTrp0c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JCuR8V7HyBJVWIm1TNGYS9Ua73JFypZVdvKR83PulMNgA4C8R4fWL0ecWjRxMyTbvl1eQbpmzHwpamhMzA6ovuoVCh4T0zpxEFQrn7to7QJKVepc8RPbVIQrv/3ZIibPhPizgMXgQWKZxO3OzKK1hYruYmjC35jeTGyetrGXdeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LHOnWMIJ; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYQeIMEVvAZAPTsCwK5Wdjke5FudfUveZZZFY6mn9BWsXc8FzE5uQgpPf/2a3KZpVFjzByDJWitxCqTs1EoqxKmaMbN/5KqcAAjnOPCsS73ygKSUKbemr5YonIEV1y0KWMR8MaUQtqk42n38wK6L59DzSQHosB/z8GePn+JAfkhMr26Jr3e+faiEET2F+wKckqUHH++QOiHZAhpUyhX9OfgbTN12/X4WZQcdVs5+KeQyzmYstQbCn0X2RLdMk+Lq2bZ9DnKt40VHnpyFImMapDyPBtR4K3WdqiNIaxUpZ1o6POgU+CwihuP46iY1upu/36gPMZAieIeWUwn92/JOjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9F+ObCITeBxAhkHqiY9udqbTIcQldIiGI3QvnJge+uk=;
 b=M2zXvX0AOaPNUIxAKn6MpJ1Yp97ESTNoKA32RoCBZWG8Uqineqro8nuEzdBf9FkebXvbk97fjO6WZ5ChHbOF96CfcGHYJLOeHYIVg0W9QR5PRxbB+ei5I4NLHccB8//awmvb6jzZ8h1jVLC7VLighyt4cPbHwWUMNtv5ZPiBXvxt0veumGlVLiAlTssQoIPFKtv+XdNXGUTBLSB9liZRldeeyJ25VwR7mMaLViAzVSYxCXfvYCSZyaycIMK+qkTFzulUC8Ygv+Od7XTxJlK931WDwTbhiF0nUqVJsi/okbcoNA9wVAs4lTyCfjlmqK9dpbV3O0evy7O8f8flEha1zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9F+ObCITeBxAhkHqiY9udqbTIcQldIiGI3QvnJge+uk=;
 b=LHOnWMIJ7Mmy+HLMPbMPiKQ6x4BZkB0CfmgW1vVBR9ujvH/ECrRd151GRL9kAKlNOhLgEBHutgG5zvupoBOmJq9XvT4u8LOCY+Pa79aeWlO5zxAh5mWYXiwMLzq+C8KguG9lFXupaN5h58Lv3160Rp3CgayEo2oDNXtxNAxwP1g=
Received: from MN2PR16CA0042.namprd16.prod.outlook.com (2603:10b6:208:234::11)
 by IA0PR12MB8304.namprd12.prod.outlook.com (2603:10b6:208:3dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 05:23:26 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:208:234:cafe::95) by MN2PR16CA0042.outlook.office365.com
 (2603:10b6:208:234::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.31 via Frontend Transport; Mon,
 17 Mar 2025 05:23:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 17 Mar 2025 05:23:26 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Mar
 2025 00:23:22 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v5 1/4] x86/cpufeatures: Add SNP Secure TSC
Date: Mon, 17 Mar 2025 10:53:05 +0530
Message-ID: <20250317052308.498244-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250317052308.498244-1-nikunj@amd.com>
References: <20250317052308.498244-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|IA0PR12MB8304:EE_
X-MS-Office365-Filtering-Correlation-Id: a28f2924-cec8-4c3d-ac7f-08dd6513d83c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EkciBR0QazPM2FuXqxBbR5lBs6FLyC/QaUvlueATifZudW82490qyhylpFW6?=
 =?us-ascii?Q?u+cFFfDEkFKp72oMjVoieiRp4j9CAyd+vEh4klR4xZ93EQbRn9sspm+8/ooN?=
 =?us-ascii?Q?R7ujjCh+teSIIxJYqXK/KUGNrrfmXYvXIEmN5p+GG22PZFHcTm1zT4BPgsnT?=
 =?us-ascii?Q?kp+F9tU+o9fh6vMHemf/onA5//wV6Xhw7k2wHgPoXjcaJE5fx7W3iNm1TSKZ?=
 =?us-ascii?Q?t8ayvBdzj9OqNtFCQt31P+ND9LUuQkMLNJVq4ZHGv7jpYBdR4ky1q/jc4pFP?=
 =?us-ascii?Q?gU2N398A6dD0aTNDx4eUIBQ3Yh0L2PjEVy3/jA6ww0ueJUtTfFoFO9wHEwut?=
 =?us-ascii?Q?+iK7zFCTVK+E6ToD7d3jnTHN2aKVi1OnT9b0mwCIOF+zEwS6ahbhgrhTKZSr?=
 =?us-ascii?Q?BWX9UuteTwCxe2DLSB+x+5wRVf0PG1Akk2vM3Ya4Zy5LwZFgrgytQv7d/yOF?=
 =?us-ascii?Q?BWENycVkCCWpjDKSKcmD+6ZFW6idN4YUjJ3MBd6h1dUrY0hqeV97jExH5zyo?=
 =?us-ascii?Q?9S19rrV61B08UD1YOA9GaZkbW/VPyZCAjQ3Os66gn8OFGuVfBl4lwsiNfPu9?=
 =?us-ascii?Q?zVaT3VK2zjrT8y+0sFutYzkSR1I+zF3mJ9Jc24AiWDmHU52o9aDEN/3LMxtP?=
 =?us-ascii?Q?wiqp6Njm8oKwv8rFCPxMrQ1qfMiGbprUG8ddzsasdDzgO3qNYxV+XTejFsj8?=
 =?us-ascii?Q?Tmd8PG2QhAhMLEYiJsxuzi+F67sO6sMAOWd8FIt3dOArmNxmIUNsDOiWuVrS?=
 =?us-ascii?Q?2acO4NgtA+CIaVruQ7bls2XbhX5W13UpVhbFu0e8QJDz1UmB/ttvgecdCDAq?=
 =?us-ascii?Q?gCfad1OCE8jUsvTevAl0bfVCT/MhcM+HNUbdwW1G54pYmVPnKB/Ttnr2G6tk?=
 =?us-ascii?Q?PBLQnC4HPBBTHqvRDLUT2kRZr7uCjXKiO0N9SzKkvbvZYdIuQlgxmReQcNaj?=
 =?us-ascii?Q?9o7OkpvqMuL1QrE3cBM7I8fP5ALX/+Wcb0ogFOeUQ81p0aEnQ8txYqxe+NBz?=
 =?us-ascii?Q?2DOpBkNO+Uj4DnjjVSzckx7BWbjAlrOUCjXd0khnvbKFl+dUzKGIfMAOlP23?=
 =?us-ascii?Q?oDIHqWxORtK3ECd/a67zKA5aDyJaGiJ3fjcXp2E5Lz5XhmK7uGQelwveUCAQ?=
 =?us-ascii?Q?HiERTA3VTSJ5Nf9XIuUQiX4nskldZAOgpJwf7dzb9pT+Hg8wvslhibGBBy8W?=
 =?us-ascii?Q?ukeSYBstOKMELIMUvhQ6fYrDwG4Yn+49Cf4kIuan9A2wiLLOmDnPLE1jglcZ?=
 =?us-ascii?Q?bNPRYHaBU25F1x6cKK/7T1p4SvCGwgXfRJtprQ4LvkZgPbMdIMhWF9+1juhV?=
 =?us-ascii?Q?NWprI6JE8K8HQon0lAPN5m6WRoDiSiEHUxkBJHMVbPEHyaJExpzthREl9z+p?=
 =?us-ascii?Q?MMDFcMExjnFmy/J6BV7V6HGDeoWlqNQ/jBCqIQ383ZQDWbQ20CQsbUpAqU/m?=
 =?us-ascii?Q?Plgk/2RqBzENjmmi8u0UH/sFVKBARz2UfMzfNfm+9Diaxtrt2DJI/iCd2tLC?=
 =?us-ascii?Q?4xGHfPfAi5XpPzk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 05:23:26.2648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a28f2924-cec8-4c3d-ac7f-08dd6513d83c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8304

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. For more details,
refer to the AMD64 APM Vol 2, Section "Secure TSC".

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 508c0dad116b..921ed26b0be7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -448,6 +448,7 @@
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
+#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
-- 
2.43.0


