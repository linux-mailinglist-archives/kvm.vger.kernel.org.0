Return-Path: <kvm+bounces-24855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF87C95C0C7
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 00:21:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E14BE1C232B4
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 22:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF011D318B;
	Thu, 22 Aug 2024 22:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0YYrRX9v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B2A1D27B8;
	Thu, 22 Aug 2024 22:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365197; cv=fail; b=WTF2OfsYZ37cS2VON5cGfWo/lEI9BcMf3K0AFo144n2IJh4qGkkDq4g6F6qCaRwV2kmwLAYQRmUM24DQ+dHnl7F7Z/W7Qpk3l9+Cwz9vreKCYZNjZRcI0P/fLuUItxrWA53tyxH2QIQYgI8Bp1BuYfB+vnmcA4a4uOrx97Z6CJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365197; c=relaxed/simple;
	bh=xkpZ3xGcPq+4TkZ0y/JlyKd/Ar4T8DF2Co3tpaW+Bm4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=W50cLOY11f7rJGLcQY/fGT2wt280weOZqDBw8i07Ev8QqTAYpsADKhbbk87htcmOCSP5mAz4mxV7x+5t5bHPacg3maXaCRzgOBBpoa19Tscmjf+kwjC0952shht1hjqef4IKgHB964tf1nNKsSC7KtcBNjIfQ88zCo5PMGLP000=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0YYrRX9v; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s89J492HwqReNV86M8Q5MQSC/yPeNVYXYm9cOrMYyz9sBBiMoSVFCCLz6PZWHR7HNVifu868m0cgRUOe54VMP9vsaJxvLoNNrgNSabepHJrrp1Dp9jzrrz/ZVR0nw6RtOB00JIBpsdRa46yd4eYTPkK6hJkqSvDivVOTviGf244UpNnPmTHs3GfJivIvzpyCOsyvSIxfTeJRf0cJfjnE1UvwCAvXLypoUZPy5VunT7ny5alOHFRE754qAaNe42X73pPKlVTAtLqax3zRLdL7BLK5ulyCEJAcjRnMdGog7jsoMbt/bIbM2hoGWBlLHfsHPsDniUP729Mk2zPi2kmrXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNzI5t3OaqpzRtzaScYffYFfkLd7TYNVGgPU+phTIhw=;
 b=CouRn7E6CVWXkMaulNQFWTQSXso52t+ST2F1FGrY60gciGazp9xGXJrO+RbGLgyP1yNQ0NueFUAbtbbgy2ZfTQlgLIdDAXUrGIWhAaMbgNh8Fsn3kPdkZ4thIm0WWWRUOtb0LAe5ChrlCZ7HEEs2xeHsI2iDpL1HP61T9RAeTxFa+LywdDsHkt8dHegR2nKSW62334glPLXD32SCNVrB1TSM9UDwZjGOoVsI2BJyLzsIm/LYVBuUBdHwqZzt95zZlU9Qc1k5hCfkCsMutolvJ+fdtmlwUvZTSju7UsR/ZPc1er7toAO5X6oB7rDkgKzKn5Zqg//huaFFESnGgHWeDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNzI5t3OaqpzRtzaScYffYFfkLd7TYNVGgPU+phTIhw=;
 b=0YYrRX9vibnQPVhxCm05Lvve6TCJO/3zwlaAt2+l3OnB0ZlABQ+YM0Hl6/V2nI0qCGyMpmW+1sSDZe0t9LQtyeifRRvWkryRqelH3rzGGhl2ftzqFqdS77K2mdH4wc3YL8l3SYOim67fqPZPHAzbAO5oIGWHL/bS4vzZedvP0RU=
Received: from BYAPR06CA0013.namprd06.prod.outlook.com (2603:10b6:a03:d4::26)
 by SN7PR12MB7106.namprd12.prod.outlook.com (2603:10b6:806:2a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Thu, 22 Aug
 2024 22:19:51 +0000
Received: from SJ1PEPF000023CC.namprd02.prod.outlook.com
 (2603:10b6:a03:d4:cafe::24) by BYAPR06CA0013.outlook.office365.com
 (2603:10b6:a03:d4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Thu, 22 Aug 2024 22:19:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CC.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Thu, 22 Aug 2024 22:19:50 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 22 Aug
 2024 17:19:49 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 0/2] KVM: SEV: Add support for the ALLOWED_SEV_FEATURES feature
Date: Thu, 22 Aug 2024 17:19:36 -0500
Message-ID: <20240822221938.2192109-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CC:EE_|SN7PR12MB7106:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0471ef-e009-4c6a-103e-08dcc2f88a16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?16YE2sjNZXDww/FVGTbd4X/T6M7Wyox/XBK88aAO+gs/0XLvEd4Dxod6wLaW?=
 =?us-ascii?Q?uPWuSUAhv8rBE9sZVae4AbpkrBuDajkIFwZoA8su8uxMtrTVaTwet7zzcGXh?=
 =?us-ascii?Q?tY2M2h4QlhZUtYdD/hqnj+GdgHuJsPEJ+Qc3jagi8KO8HHD+fYIr9hPRrZ4e?=
 =?us-ascii?Q?3g/YfV2qiO97c5J44ifASvnynlxuGMIggLcQh3gsCdC4bpg+rtugXtyYRV35?=
 =?us-ascii?Q?gPVQD5gBH4+vAwy5+99PbSUzFEgDMH0Es0A3L0/9JYcRXrO/HCzexxlY0roI?=
 =?us-ascii?Q?LP8XFRNZs37Tk3BuMXyqrR/dfxEt6L9w+DxSXec+o4xREfAVhKudKslnMS+a?=
 =?us-ascii?Q?LE7NMnjQ9mLo09I/gHehqv0RawdjM4QFa9ts37yyJNTf6rFpbsEybKNz+BTI?=
 =?us-ascii?Q?o1zwVEyOqd6pPPy9R91bfCDOfFO5CSHI3BxRFdzl5Q+67ks0pQRJYA4N20Ew?=
 =?us-ascii?Q?tktNBEDlK0X2GYUic3EmsRPa8vgjrzhxwjHPZvB+PZKKDIhETA0cSyVV6jap?=
 =?us-ascii?Q?dJPfrLDO9vOxFvItcyaEztiLndtbB2x58DcHZYPgKjK1d9lofKRbkrQLvmfD?=
 =?us-ascii?Q?L7lW1lkj/Qq0EFt4cYbpmDI2ks5ajLaegnoKZdZagFjwzfpXP+Wd30IFJv8W?=
 =?us-ascii?Q?rfp8dNJKXQwQ9fBD7c78yn/imTzqn12cKrg1kFD6w17PCr2GeOS0xQoAT1rz?=
 =?us-ascii?Q?YV5asXQHFJggVL6IICEE4Uv4zzFKPD3JJLWc/9D+tr85XbM4LDldpbdxF3zi?=
 =?us-ascii?Q?ojHblPktBT6tvoBHnN+N/HlLNdQ4h2NUI4Cff+UeU4MNDjGbIO0wWb83fmt4?=
 =?us-ascii?Q?00oKCAp+3K0a0DcUgde1cyg4kl5ylvI8JVvgyEyX1F97NuaRTQrpDKYS7OKv?=
 =?us-ascii?Q?HeT9zTsgTh9hsIzP+8amyH1xlv4rvjFqpyCm6hJnuT86lNqS7x63z3AjQCbg?=
 =?us-ascii?Q?m2WCQqLL2DRJvdpNg8u/4/Na2gSLZ23WOsXUFCwr14itatxd/smUVxYtQx+K?=
 =?us-ascii?Q?oqIE4ii6vcO0Qb9QECGJ1AEhHMP4BId/s/nWl7Vfc0XDRFCC2yD7vXxzymYP?=
 =?us-ascii?Q?HPvA1cuUynNfKhdEqkO5KocfMce9uHC3AgjWh4lz12ENxE+OqCaV52UtvcTu?=
 =?us-ascii?Q?HPfCJVGp43iW4nQN7da4nSEnZjV7mLkuG9b2ppZGWyf3X5eQTEYqJUleGjf0?=
 =?us-ascii?Q?UaVTuS3o0N/vxKXwFVNXW2m+h2x2+TjMG5ZcspIVXaVOIAAA2EPng7bnxzm4?=
 =?us-ascii?Q?HJnYCFLl61RaHa3JB13NVXR7uYFa9QjXRpJVmYSf6u/mcVUiHsJPUTVD4G5C?=
 =?us-ascii?Q?weEXe6zAGaUdVTzV0RdyPKUfUwyEYFYrWecghIoKatxYdLp64r0b6OfRnYck?=
 =?us-ascii?Q?zGu7s1AaIDmFG7Fb+iNWMTNYZoj8ImrFmnevlOzHy722X4VPZQyZqaw30VCr?=
 =?us-ascii?Q?/Snu441f26hXDXqS5QdwUla1WA8ID3bT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 22:19:50.2741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0471ef-e009-4c6a-103e-08dcc2f88a16
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7106

AMD EPYC 5th generation processors have introduced a feature that allows
the hypervisor to control the SEV_FEATURES that are set for, or by, a
guest.  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
that SEV-ES and SEV-SNP guests cannot enable features that the
hypervisor does not want to be enabled.

Patch 1/2 adds support to detect the feature.

Patch 2/2 configures the ALLOWED_SEV_FEATURES field in the VMCB
according to the features the hypervisor supports.

Based on tip/master commit a2767e7f31ad ("Merge branch into tip/master: 'x86/timers'")

v2:
 - Added some SEV_FEATURES require to be explicitly allowed by
   ALLOWED_SEV_FEATURES wording (Sean).
 - Added Nikunj's Reviewed-by.

v1:
 https://lore.kernel.org/lkml/20240802015732.3192877-1-kim.phillips@amd.com/

Kim Phillips (2):
  x86/cpufeatures: Add "Allowed SEV Features" Feature
  KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/svm.h         | 6 +++++-
 arch/x86/kvm/svm/sev.c             | 5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.34.1


