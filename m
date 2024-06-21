Return-Path: <kvm+bounces-20268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 28DCF9125D8
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA8C31F20CC4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2C617A93C;
	Fri, 21 Jun 2024 12:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QVBTFJR7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2268179658;
	Fri, 21 Jun 2024 12:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973646; cv=fail; b=ZOy/RdgWejTiM9CAW1v+q4ZhblJpInZtSkWmivRTPbtXmFn+xAiIMNkNmAnrncpR7Q7zl8SeWahgRRa775vm92RdoFBKF1LxPnKlP6mC8NBGSvtSqrwNQlL2TJY/QijRH9XidPzBsV3QK2Ud0SneqXo18yKJjLXMq2WCnoargO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973646; c=relaxed/simple;
	bh=wjgsaMYeT1GD78TxdoMUeB43JDwnow8CRuB1a5G31SY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DwftWGr7aFMnDV/3Vxp9obPrr3oT7927IIL+cIRSdA0Lz8o5zR8QEcHJh/gsClElPeRSmYfch1F3HNGlI4D5QKsDpLoOiRZxwKOETjOfBEJEZYXuEcAJrCzeyS6QiW/o+e1tBP+EAeVv2zvPYMU+HyWRXK4d39Em+LmTWRdj7ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QVBTFJR7; arc=fail smtp.client-ip=40.107.243.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbZ7NDcs8GVwmMnWJUY4psXXHcFwPJE/YeK7yNs+ClYXLt4lS9MWmt1yo0zcXmf+gB9p73nJtoTw0JkjWvR4SvJfiMjl5BgM9B32nX0wJ0lYLOSyFjxo4JS1yKrfkt9p4FjqNHnaMVbC/SMZjqWezncFujFXAYQdDfTDOIPBhxsdXyOLWpwQ2ENnCFMeEnWuYKc5KaG3UhFescMF23Y9vO6hMAQfH9zTd9QQRGOh2EFJxupMlCN8gPwM2QiJqP52oO4dZ0sPBReC81hBb4ODO19zN3kJBA7zpy4Rkvlm01RTJZcAXMpSOFJkV5WGwbwsN6teIU4ekZ0p/8sxpWfavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAaAbe3aro4EM2xBQdGp/o69Ah/mnZD76EyvwIMZKr0=;
 b=AdxgKUEKvICemKZ5Kk+T3VP19mplZ0jGSNrGVXTe4ZFRYD67TGsBNuRrruMppKtv3dNEUYyOog/mhBM6QB9ISLRvc82bfi+rtivga1NjVxBuSbI3wnjSG6bKyUq9rDsE3x6Ymc3KZZVJw9BKAVTmf7/vqGocEqJPD8ftC/uCieWUq3mCATzlfqrguzj6oEQEt815ZGz1iDH2zOUgCkY7ODal+tUkiaGVfgOXcN2iGk+VYCf0vlsa1KguaUfCUjelOUueKhuixru9KRQ2rBt4BUcThuNVdlX0d5gXIYEBbMFDbWpeLgfeb8rXtA6BoB/a3xSVtigNiiH7d/ExfvYobg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAaAbe3aro4EM2xBQdGp/o69Ah/mnZD76EyvwIMZKr0=;
 b=QVBTFJR70SqAG4sSG8iHKhyYXm3E0u9TDnEnUN3wJ1LqhJqPERe9rLtsLEfe3CGLThW0PavKQ0xd2D98b1sR5Ov4agDhVQNrLYLw7quruNBHsOoPB7mbD8xt6Z6C4/WHNJ8SmDE20NyBXya0JoN2JtGQK8C8suObFUckYGIXfYY=
Received: from DS7PR03CA0235.namprd03.prod.outlook.com (2603:10b6:5:3ba::30)
 by SJ2PR12MB8652.namprd12.prod.outlook.com (2603:10b6:a03:53a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.23; Fri, 21 Jun
 2024 12:40:42 +0000
Received: from DS3PEPF0000C37C.namprd04.prod.outlook.com
 (2603:10b6:5:3ba:cafe::d7) by DS7PR03CA0235.outlook.office365.com
 (2603:10b6:5:3ba::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.37 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37C.mail.protection.outlook.com (10.167.23.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:42 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:38 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 21/24] x86/kvmclock: Skip kvmclock when Secure TSC is available
Date: Fri, 21 Jun 2024 18:09:00 +0530
Message-ID: <20240621123903.2411843-22-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37C:EE_|SJ2PR12MB8652:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cc17967-9b74-43d4-8c04-08dc91ef5d1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|82310400023|1800799021|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JZ0sD6fVARQcAC6F3gzl0tY3V0VWoKDrp9sZr/JKNrs4DGyRv/1UAFbiP8UO?=
 =?us-ascii?Q?IgCuA89MxoYm9B7hTvvoLK5TRwXzPNPYpx0NcrcskXCKRrHAe793KPfOzZ+a?=
 =?us-ascii?Q?0jdr3xjANRNiG+j77K5TOebxPN8Jsk3vPh/iX/ytIu9IcYpDSk9RoK35iktS?=
 =?us-ascii?Q?NY9KDG+1yddGCzTZpi+8bDUBj1/AniJx3b/N/yNccQHecKG3fNhE88cS1SXV?=
 =?us-ascii?Q?2Pi382KTZtM0fap+xyA5Hv9qqqqXOD3T6l+wCvdiNRHjaD00a186B4jU/JUN?=
 =?us-ascii?Q?Z3S1An1tK0rsxx5lmLwmfpph/yZhl06QRLQ5ifgU15ss9WCmr1GFXSx7aAmP?=
 =?us-ascii?Q?DnCBsrw5by63KMrG8lqQUWY304miIGGX6n/roPrWtAtaFiepBJyxtZiyqWNh?=
 =?us-ascii?Q?OCQphgIV+EJT9xYfbm3m4zCrfa4/7h9dKb2xWBBVnKEyIp2/f+IEFVtLWBac?=
 =?us-ascii?Q?gkiKvtPmjkDb+T0xmy8knYzu2sv4nTRO7Iay6PCrBjtj6htWtsFD/xH8TrYM?=
 =?us-ascii?Q?/fAWhdUD6xBoHvczi5hqetx0VMrS3HZSRviHyseTW9ADM2hcxFI1k9f0qfu4?=
 =?us-ascii?Q?07nnu2oO98+dFG/RutLFvUH+hi58x4tPcn8zkT3KrBeEfwcaLzZPBxdY6imL?=
 =?us-ascii?Q?TFMtwuJSJ/C/7Sb2IDxKQR/xMabmY/foTSfG2UoF2G80B0CNn6gdPguF8W5G?=
 =?us-ascii?Q?T7Vck99CuYq+ClEkwOp8YynAlT1lKzYe+qbHK/coltwn6BBFMjb733PXRZKe?=
 =?us-ascii?Q?CGh6+du+cShL9uUJwkZNHYrvfqgdDZZUNx/YT3ZkLBTiSEjKmSw7MOl35OIu?=
 =?us-ascii?Q?KGlbFDvgU4131IueCkCVu7ymi5Twn3tBWTJkhzHcA4Bj28L+MtQRo9DqL4uh?=
 =?us-ascii?Q?dBsbGFAHKMDj0uviZIy0ocLxmy6+ekC/856H+MEyOZTj2GmC4NUStjjG8+9l?=
 =?us-ascii?Q?A9y8sFnazIJyn86boqtgHjTPKGxIc8nLeBbiVURec2gd3832JTvUkiWSx8CQ?=
 =?us-ascii?Q?na0LzexFm7ziWj5lapZopjL3R1Yo9sNBSwbnuUHTuUDdgsexkllLmV0WbyAz?=
 =?us-ascii?Q?1ZfBcGsmvklM/+3AyQ5RwYAY6oqXorxNbisciq5lsx54RNr+x9KOrAn7WKYQ?=
 =?us-ascii?Q?7T9dhKwcAwrvFa5gqvit0nKOVScb+WVJ+FoZKqvrdvYkm9C/EGkwQxUNkzmR?=
 =?us-ascii?Q?2ZFtIkXl6trO83cb0Xe5GZsyjKtjh4XhJ9+ae7Patxaf0tdBkTLVUFDfrAkI?=
 =?us-ascii?Q?uh+qIoLeAcoi8SEqswrVDCYgQlVwzTGDRkh7GW/w8EQOsj+qmjIeS8LIeA7Y?=
 =?us-ascii?Q?Nq8nfoxHqXsQgnNZrE+DpBglW8hNbU8AtZjjSuOT9qp7wA06YEBFyKihw0mP?=
 =?us-ascii?Q?g5az3V3N5YEQKFNyOz0btREbpK4YzLyZEfo62+Ae3UlGlSzJ1g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(82310400023)(1800799021)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:42.3765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc17967-9b74-43d4-8c04-08dc91ef5d1f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8652

For AMD SNP guests having Secure TSC enabled, skip using the kvmclock.
The guest kernel will fallback and use Secure TSC based clocksource.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..3d03b4c937b9 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -289,7 +289,7 @@ void __init kvmclock_init(void)
 {
 	u8 flags;
 
-	if (!kvm_para_available() || !kvmclock)
+	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
-- 
2.34.1


