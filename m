Return-Path: <kvm+bounces-28219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E11996582
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 517A328672D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A03B19882F;
	Wed,  9 Oct 2024 09:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TUkNedn5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2475D194C96;
	Wed,  9 Oct 2024 09:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466223; cv=fail; b=W4GxFBjb+ciZI/VJexK9Ro7qb0dVMelLsbJiQnt0Ymvj8b9qk+jsP5aoKkAd2SSk84cC8PDQYg8iEo8hAq7/bHTYiMKL6E3AWP3fggpDeFTA9S7wmtE85GpsngjvEn+UnO9gntwhzoAfTLsUQ4YqYpeo/ntiyDotOoqi3WciT7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466223; c=relaxed/simple;
	bh=OB/6ASxdYsnfcl4J0jmZ0yh5aIWCHB0Fx5bvb3/XE7g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DLR0RMw2j4nv28tQj0iH62vWBGgXg4210d7UAv91NbOxKA/qFHytVWGUEbfvBFyPgqfb+hynOGmh54QYWPxRjK81SBoBjVHlUY3wEHbGd7dg/QWAlTveEJtV9rqooR2/upyzye5llumX4v00qr8ySTfN7xC/inhPNK3D74fuX3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TUkNedn5; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QfJX4rAm21oFgdIoCW6pz3G5/8SlRIcCfIZ5bgfytpyHnHIWv//giQUgcAjy1BhDXM+iv3vb5hoJW9e1xsi/+7ZfCM2NFNTtma2ZSYugaxtgcyC8AvbVVHIRib+b2muIfBIrUlbtUa1m2+FtKnKrzTj6LgpQVHX3TEgX+y8H8Dih0g3SZvuIMOtNmlT+j6gzH5Ll15q8tKaVOh0p8DOlz1NpH6hdXgCeulWpjEadmHh8Qe5ygyFwEIkcRHQyF/vMaCYJH7FibAorz90OHqbMqbrPcJqk5V9Qv9da8GtOiIvKtYwMsowfO0Wx2tK0uPdz+n3AZI1sGe1CtgW2zx6zLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYYQW7AgR12vwgxAo6ihnztYZVBXhW9FEUsl9seDdjA=;
 b=I/wI8ZV8DLyYB5vmqZPddXGSK/hHTesmlAEn7TRNhMffqOrLADPSd6S/WsiKpSrF++CJaTdRn571X6KiUv0Ilfsfv0PQROyMwYqdQME3/gNr0IBTYimlCshl6Hcp7BBcSiLtDFbZJQE2g5SAW5L9rbQoYp8yRvJKSP/lFEebF2H7ZOddFUZA/z2+pv5qzvNddQtfLNGSVngLw9twUzkVgVJ06S9kp/MXkCe2y0EnhedFJfXeHRq6Yai5wTI0nGfxmP6gTuomwNDXGxJ14u//xg8n28TD00bCWZDfO1rI7kTlkQeseuLRPnEORkR3lQn8XQnBDAvg9YsbBFG/4MM1fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYYQW7AgR12vwgxAo6ihnztYZVBXhW9FEUsl9seDdjA=;
 b=TUkNedn5GvUX2Vyv4Su3O1aMtDsTac2Ds1waX3iQpINTaGjvtJWEtGrle1rkK74F0679xdwHTaL3xYbwzuD2ALZDoVNrpFbd2nWGmIGgoEpksQmn3xX4WgEC+y4YMD1mfRHEwWtzJzdPokZ6sxuLWwZIGl9jq0LIhjhtnXDwkts=
Received: from BN9PR03CA0103.namprd03.prod.outlook.com (2603:10b6:408:fd::18)
 by IA0PR12MB7532.namprd12.prod.outlook.com (2603:10b6:208:43e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:30:18 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:408:fd:cafe::98) by BN9PR03CA0103.outlook.office365.com
 (2603:10b6:408:fd::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:30:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:30:18 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:30:15 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 18/19] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Wed, 9 Oct 2024 14:58:49 +0530
Message-ID: <20241009092850.197575-19-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|IA0PR12MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: 399a9f78-22dc-41ee-eaf2-08dce844fd74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z8pBcmUO7jEdJln4sBdqGhocmEFBHbLiMdOiZhfZObzxTLc246Cfi628U3Dw?=
 =?us-ascii?Q?Vy4mLkvpswSquHf7TKYCaFsUaGBQKSQQM62CxIhHIxQC41cM6x27biDMCvl1?=
 =?us-ascii?Q?v6UbxOeyl16LANhH8b4rQ0pL2NsVx8JGV45bzGosno7tsTGEls6rSSQFb1S1?=
 =?us-ascii?Q?E/0LT76+SDvJQH3TuDIuUqTtIrMN0J57cc5NRNwO3su/M1l7TEoYo1VGqW9D?=
 =?us-ascii?Q?9639M3Afj31Nwq1t5d7BydPSwrh8Jsu+wU2sqXW5LEZjRaONPkEuzi4kE0q9?=
 =?us-ascii?Q?yhDL/Mxz48jXdcSIMaoWXT3+PHfPzAp3N8YhkVD9b0ezq6xl6RYtdcaN8eT8?=
 =?us-ascii?Q?5mgJUSvXvmm24zDo1OYyH2BKGS4WCF7iM48IYdYU4ZLn750VIlbSJj510sb1?=
 =?us-ascii?Q?TN12M3dD4lLeSWRFx8q1ZPyLOZiK1P2c6/sFH04pdlMTlxGts6hYQC0V+ujH?=
 =?us-ascii?Q?CSTPdm3p3ekZzkxuweXmZWImEvv/2sfyNWClcyJIVNouqhQL5dadvdMknMmH?=
 =?us-ascii?Q?hNa93UFnzrKNBpgc1G9vcv/tmoetByhOB8NPfqduEJnEaiiR8k7XqkVior+T?=
 =?us-ascii?Q?z7xgUgE2xltjibNaW1samKWkdkygVetsFSXG8e/nKATyvRwVDF8N2SXlOKy8?=
 =?us-ascii?Q?kH0t3bUXqs10AEq0IUo7x3Bvmngqf2w5GxhXTbDoQj++fAZFjfnZBDmkyXCP?=
 =?us-ascii?Q?T08/eY2gUc+iW2N6szzX7DgJ/Ub+N0OLnoWCUlaiKhva5db7mKU43x5N9sjS?=
 =?us-ascii?Q?xBiLK5AkAWKA4pkqhNEh8Tqc5f7C2cCvSh2HwBF5t7SbwZ01YYW9h6OPdZ+M?=
 =?us-ascii?Q?aHKzlafHezQruHYRtEWxCOwIunBOHoJ3z+Buc+pVCxSm881+xBojgYhCrcFz?=
 =?us-ascii?Q?Sgi9Jq/UgwOZ99tnxPU08P64dSu3jXd2X40433hP9zOfRDMni7KdNyUj6Pe+?=
 =?us-ascii?Q?XpyZ+VgA3xcO5/7IBhhcuYFEQEqJy5VZLb/+0CjZAAQfBhFHAGw66fK72VoW?=
 =?us-ascii?Q?yChCYKgMRR3V3ImgGAbwW7wcsn5EqFNDlUhHX62WSYp1EWYhe28IO4ibWfIU?=
 =?us-ascii?Q?yjlbWVsaJxWQA3DXxCkVRreNaBR/epoN5bsSKP1fg2fwh6VrS2SrbegZ3ucI?=
 =?us-ascii?Q?u0R0GqLon+8n2oUv3IZkLyhZrAzE38d/mEy0QE2vGBqXzmVaPTJNfQeQFzAw?=
 =?us-ascii?Q?hGaeUkDDCkIeLpEtbOhbOzCO6wOozRchdJAEYzaSgnaQezKCaT/w0a5orXhb?=
 =?us-ascii?Q?1DJSHRCcFuoiI6fWPn4sqM8ZhF/UMHj3/bcKhY9KSbyoEGinyKdgJtBi9TVv?=
 =?us-ascii?Q?1l90cmo01VJ1yDsXRM1M14WdUUjJ6fOb3uNI0AKt/zzf7DcdCy1cFUm4ZTKn?=
 =?us-ascii?Q?HbpaWZQY4uSMAyJLkuHQZGON3vq/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:30:18.6704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 399a9f78-22dc-41ee-eaf2-08dce844fd74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7532

When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
is set, the kernel complains with the below firmware bug:

[Firmware Bug]: TSC doesn't count with P0 frequency!

Secure TSC does not need to run at P0 frequency; the TSC frequency is set
by the VMM as part of the SNP_LAUNCH_START command. Skip this check when
Secure TSC is enabled

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 015971adadfc..4769c10cba04 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
+	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
 
 		if (c->x86 > 0x10 ||
 		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-- 
2.34.1


