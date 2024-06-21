Return-Path: <kvm+bounces-20264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4C39125CF
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A8761C2017C
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CD7176AA5;
	Fri, 21 Jun 2024 12:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="25MA3j/3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4985D176223;
	Fri, 21 Jun 2024 12:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973631; cv=fail; b=QWbS2HQPF9yrGEuwItQuIsxxtGlPkmofYyh8l59H6pLLyrwjqBlUbyZUTL1WXj0/rRYmt0sRFlhk/JjNgbxTtEn1ww6koK7D0ZXpWiTjiWq7thqSbHSvyCNku0ydNvUb2SYJL6Bdk8OXgAcEabY5KKNtD96X4v+4ekVcc/U6xxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973631; c=relaxed/simple;
	bh=vLrKq49G5EtzXifK3qXve/+xABeDSStTWEiwGb0yu/0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ft0kWFDWvXtlX4sP8/Y1tr9bDSOIuT2pQXdsAajxbSE/0MYsYHlzTShdpHvp1lW9FxaETUQZ7lDWJj56ykL1hGlKaaX9IR/9GLWyusaDc55oa7erN08PWqwa0NDfsymx1drHS85xVQIZdPzwp00qB7/Ejs3BZjebby9WM3tRhfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=25MA3j/3; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwKZLv1o/T35XmmoDn8GZixU0RrVFApIiIOcFjlt0F8RbmzDalsY5/03MTx+33NPffONHo2tVCCTFbCSdW7pCxJXIcXJ3nPpjNaJn6cvku88J/UmulilUDm7/JLbV3bfeLuDClRUhQLg8i6j6JiiinmQzRzsqy2Lh6IUlIAU/MiFwEnFBl2Ph/ZjjvTd0jveNRO8w9EXaWlq5j3cw30qhKs+Yhjnl+ihIZJLzfldSPs4TuTCmtS4EkpODPmTo8LAhWqpxvAG7o3PDOW5Uyy7M+8b92QSumiCuHsivJHmpdVum+9zt/GpZ5wre/Zmx5RdJgMn3ZqV6QrTbxfFODH2qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VI9Q6jL4aJyvI91x+hBzrKswrSdPdeIgmfBHMt4oUSY=;
 b=dtHXVcdYQUXQEbMxMTnP9kUUMM4WJU6MjdxNz7s2PIQ8u9adLNzj2NrFYC1O14X2X84NcYUNyUhk4k7wll/wyjkdfLjsuiruSsRIfozzvLq2LP+M1cFyq1HbmNP/69qtJ0BfGJVQGakA/I7rdC5uVAoUnLra97IvllcGaJPIRvmiLgN+XT3rkGyuBCtZMldqRn60ys9V0V2JPgHpL82Pjz7iq2Y189+Mpqqt8X8kFaKlLv7QbcfLeaYHK6ycvdsKHUxFh4geUEqO2ON464aGN4G/h6HJ4GA6xkn8oUa9He3tipk5BzGlnSmRrZS2q8UgRuURiUZoQVvhXnkR0TNlMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VI9Q6jL4aJyvI91x+hBzrKswrSdPdeIgmfBHMt4oUSY=;
 b=25MA3j/38L6BQEc9dVA7bVo1Eb1Mjh6RbrDILZJz1dbreBK4BxN9ksvZRcQpK8S20Qa/rb+a/mvZFJWbH9iTfRCVsyy1SJzrigkvlICaizb/JcFP8shXk6WNp1k80Uq7n9D5ENz0kisEjntoNa87Ox7qZvWi9JvxeRzfq+KKGMQ=
Received: from DS7PR05CA0010.namprd05.prod.outlook.com (2603:10b6:5:3b9::15)
 by SJ2PR12MB8033.namprd12.prod.outlook.com (2603:10b6:a03:4c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Fri, 21 Jun
 2024 12:40:27 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:5:3b9:cafe::38) by DS7PR05CA0010.outlook.office365.com
 (2603:10b6:5:3b9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:27 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:23 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 17/24] x86/cc: Add CC_ATTR_GUEST_SECURE_TSC
Date: Fri, 21 Jun 2024 18:08:56 +0530
Message-ID: <20240621123903.2411843-18-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|SJ2PR12MB8033:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bb6f1f5-2361-42d1-819d-08dc91ef5459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|36860700010|376011|7416011|82310400023;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yA+ZEyzauTsZv3hDlLjV2D1od8eDMFhRVm6SEk/INWEl2WoxMCWZiIMtbzHt?=
 =?us-ascii?Q?tjySR9T5lg2gv24yVHNSJP6FcdxHeK2K4S1ZeuegyPE8bwlG3EJhN5M6L5Ls?=
 =?us-ascii?Q?xPEJ7mUQSsGjCSFFNigiCQgmAckQEmA9d3X259e/MGlyGVAi8TuUaX/lQsRN?=
 =?us-ascii?Q?yInt500nXxVEBpM8hM/ZsLJJqlQwTEbeZw7iw75GOTTdPQgLnG/Q3AlZN7y8?=
 =?us-ascii?Q?2jFqsy8BVVXhqmZr2M+YqNHQ222ixCcJ68ixCY0qlPCwuwgurv/SbZ/nnMvc?=
 =?us-ascii?Q?qqRUEhXit3dESAT/CdJ4gENe5fMeMml3QxQGqvDROPU9wuqFCwDG8FC+9ifk?=
 =?us-ascii?Q?hR4NskKr5p8cchOLOWRpZQe3g6TjR6Zdd4p4mw6fDLuOJMwFJdUuByhuJ0BR?=
 =?us-ascii?Q?OGLrBrAiyAKAbRC9KUqXFVTe6UjA1APuIYqhP4TSeI9V+jvrtT2VWpc2nnzM?=
 =?us-ascii?Q?NMOZJjsvPpOS3fwYxAKnTosRrds55ZeThU7AtvyiLgcjC3cLwES3c8xRsO9X?=
 =?us-ascii?Q?mufGaFQTXDKkZ4LS/dkJzPCbbRNigeXgSL51hduCtfH0afE3Aw/rrbSXvkMB?=
 =?us-ascii?Q?5/2LN98EW1uf6SLUCtWitBwnvTjWyQQ18hnlhlyRvC9FuHUcRTdcy3sBM9tj?=
 =?us-ascii?Q?0iw6+tohF4TIhzbc7hSAoibo1YzJ3+bMsqjUVDoPSSSDW4PJU8QAp0EOi2bU?=
 =?us-ascii?Q?X82sVkwJ6yR7ngJKo15B9jesNz/NwFMHGBAyIs2h0p0NNAX3TFWDu55w/cJC?=
 =?us-ascii?Q?TOn9gC6rDyhLIDDOv4wA20PEEooMuTCyomACyYv/7K63tPTOMzBB+0KTcb2e?=
 =?us-ascii?Q?lsg1ULoqnISReIxgh86xvxi+hVF9pfh+89RQFixUTI0TAUctMp3aX0EHg/lj?=
 =?us-ascii?Q?aIm8NIUihS9rY3SCZ7SsJKJxStVaV2rP0BqwK9piutSk7IvEFk3ixiT8uz1G?=
 =?us-ascii?Q?sOFUOgoVOVLs9kPhIWbCR/SzZbT/uAeCRmexv1vKiTFvEtAUAqse6Ogm79FO?=
 =?us-ascii?Q?jnXDF8/kMbYdot+eIYdaKxzHhZ2KMBGvSn5eQP9fcsz+0OuewH/gmRq5Nc5d?=
 =?us-ascii?Q?onaN0XvrZtdYnzT+/HMhXshF9B0Ys0BGyAQ210WK/dxhiGy2X2sTkIXCd77j?=
 =?us-ascii?Q?FmggD3iZGuD12YBx67TiRCld32Ftu71vAVdgv5yQ7ZH30hNvfNgt4Y8vRWvu?=
 =?us-ascii?Q?1b0Zdw7vN0PoXnfa7mT28Bk/qpHiE6TU/hpAQOUvHQUF7DZeFEToqxlRp3FG?=
 =?us-ascii?Q?SfIrnyHTaVb4mLIBlC++1j7klOBOBHoLfxb3KtWiJ4vQmPCEj/VQ8MTGnQpv?=
 =?us-ascii?Q?dZTG+SOFqy5otad3d/9L+7yZxbplLrBvAEA5tphqGxJeRlZhGdHoR4OaLJi+?=
 =?us-ascii?Q?H1ujfMI3ZEGOla+k3kk815h9M4gyn95FXyaYJokH8Kude5jdlA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(1800799021)(36860700010)(376011)(7416011)(82310400023);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:27.7193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb6f1f5-2361-42d1-819d-08dc91ef5459
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8033

Add confidential compute platform attribute CC_ATTR_GUEST_SECURE_TSC that
can be used by the guest to query whether the Secure TSC feature is
active.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 include/linux/cc_platform.h | 8 ++++++++
 arch/x86/coco/core.c        | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index 60693a145894..57ec5c63277e 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -98,6 +98,14 @@ enum cc_attr {
 	 * enabled to run SEV-SNP guests.
 	 */
 	CC_ATTR_HOST_SEV_SNP,
+
+	/**
+	 * @CC_ATTR_GUEST_SECURE_TSC: Secure TSC is active.
+	 *
+	 * The platform/OS is running as a guest/virtual machine and actively
+	 * using AMD SEV-SNP Secure TSC feature.
+	 */
+	CC_ATTR_GUEST_SECURE_TSC,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index b31ef2424d19..df981e3ba80c 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -101,6 +101,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
 
+	case CC_ATTR_GUEST_SECURE_TSC:
+		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
+
 	default:
 		return false;
 	}
-- 
2.34.1


