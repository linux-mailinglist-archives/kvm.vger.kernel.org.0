Return-Path: <kvm+bounces-56409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FB3B3D8B3
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FE2B1886EAD
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D562417F2;
	Mon,  1 Sep 2025 05:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jkFZmzTz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061.outbound.protection.outlook.com [40.107.95.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B13236453;
	Mon,  1 Sep 2025 05:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704282; cv=fail; b=B9jowu3Q9jN9A8rxpVRTFuilFw9xougOQFBHiziNlU2wRou8ybe5enp5NE5Z4Yxzk+he+b/l7pce/yTMDt6fN1Ot5dDufBAsUrwYTMi9zOKpCIt1J/7y/pMT9FKhsAMjfn6oOs32Um1J6SR5bH6RaO8Ug5q0FQYtn725u94Iyj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704282; c=relaxed/simple;
	bh=EN9AMlv689m4BSbXs4q/cm6ssXKQ9orPixeEp1kr3rc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Of0df/9IucUS2iv1lrCAuxr+GTdbt+JuVstxVF/x/Hp8lHtiyqVz7wUyo4VjbrtCnkbavxLVWUAJzybtzb5pzMLjPMHZ+C+QQS1ixSnWa8GGB2J73VbJyIPv8X0cspvC7g6PLcM1sXd4LkXr3dXLGKOR6JNWaHc/ZzjgE6Ufdcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jkFZmzTz; arc=fail smtp.client-ip=40.107.95.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AuioCMs4jv4DFccbUu1OCkmx0aCDAa9jhQnkDyZLR93STn3WSOiVOYdRl095i3Z3+dbTOwz+i6vjVnZHqbatIM+AefPWm/qKIF2vhVtXGuwg/QztoNCcZwqpPiPKB87weWfVi/eJmygHMXB9D3hGZpBuhQR20ZhCHFaxGnqMxMK88b4T0ReljNYm/5wW4RTmAZsZfUIu/GC4CVLWODoMP8C27fBX7Sw4TVmhAIJPkrr8kw86HwFaYGdLYcV0c//kPUpMmqy9FwdP5L+0l1WNlQxkot7oMobx/SjUi9gNrR+zzgkVfLCkBhweD42Ti5zOKEq/N/aZd5u1025+B/ql3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoJ1FuMnmmdnm7ouFNFa5teg4koEz4QbtXmNP6AZ/fY=;
 b=lrQGauUnAzZUpCskMas94h3NnuBE8+IrnwfQm9aoB8g471Z7r0Sm9Uq/5/+7rhOHd1QSYkfT2XytNqmdixrsC371+Ahumccm3rpOwHTTkECaspGbcII2I8SBMJmyclQv+7B9LXLbyZM5KUprUmGJNuBYFIsi5+mpSVTe1jCMbfXYq6O1Wntcb1V4rcHtSet6xltnk1dGnwz1V8R/yQrD/7dNFIqPkpnkmevgbiHMZexzeTMZqlpPbE+GK6tDnyzbFdFJhURmGrginEJU99IVKjJ+9Q51BUS/tAG9UdNjiDx3KxSUahOo/6nJXQ8V1E5NiMsy/6F01vqkRF+BnYl0dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoJ1FuMnmmdnm7ouFNFa5teg4koEz4QbtXmNP6AZ/fY=;
 b=jkFZmzTzsar9fZDEfThSvGMUXvwuInhXGpoHFGG4/GJUmzISQnnGdlzzuHvXPxWSt4/YDsGYKUgEskoIHG+X2WD4QZGfj6AOglytjhFfgc5mUUmnp4/bNflDNkk+DYZk5yrsNv6OOj99j+Bw7wUuJ97Dc57I4j19MpkkKrIJqIw=
Received: from DS7PR03CA0200.namprd03.prod.outlook.com (2603:10b6:5:3b6::25)
 by CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 05:24:36 +0000
Received: from DS3PEPF000099DA.namprd04.prod.outlook.com
 (2603:10b6:5:3b6:cafe::7f) by DS7PR03CA0200.outlook.office365.com
 (2603:10b6:5:3b6::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 05:24:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS3PEPF000099DA.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:24:36 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:24:35 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:24:31 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 08/12] KVM: x86: Extend CPUID range to include new leaf
Date: Mon, 1 Sep 2025 10:54:18 +0530
Message-ID: <20250901052418.209225-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DA:EE_|CH2PR12MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: 81bdb2fc-c41a-46c8-1dc1-08dde917d760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KaqgAXu4ERHiRG4EZtfcGvu+E7NLMP/QitItosNuiiJ5/5L3O5iaJE5hxNjI?=
 =?us-ascii?Q?9YDs9kJmgBRvKHvsMPGvWSYHNBqp3xm/hYNJGlOgdFw8g+4+1hwa0yk7fe7b?=
 =?us-ascii?Q?5dfA+w7+pSM1jalIKvjAknfVwj+IkTIjTzDQD1wVI3K6X7TbSf8F5cNmWvF1?=
 =?us-ascii?Q?yElqj1e2PmUVHqZJAVOzx2MjzFidywCMD45FLctFqVr3mwwbIylvUMoHoM4f?=
 =?us-ascii?Q?PJ6sx2kJvxeOCUcodA/H5nGAj5odrvR45O9Qnr7c7jLE/OnXFR7tpn/nz0GQ?=
 =?us-ascii?Q?DRy/5+GwH7EcPdr1MyI0XfALTL7cQEyHHwdqVoVJkJUbQwIsYH0ejBqQtoK9?=
 =?us-ascii?Q?RXpsVNfytHG2IFZLrNs94YK/nHUTDeF8LMMcl7e/jEeAe7nf6wHa+Z82frfO?=
 =?us-ascii?Q?jz8eL02JGFy7UdbR04z6Vr0yOF3nmWHJAH3FGZSebRiOgMFVBBWaEBpcTiMD?=
 =?us-ascii?Q?6Zf0Dpvm9+0ggy4JcQSUl+LZYvaGjhw79R44PGBJ170PJ5hrO58Nco8O3+4k?=
 =?us-ascii?Q?jiHIbxLQTmqEInZVE31vQK3/xql347ouZCCIOU0LfRx4QlHbAjDAHEu2lelL?=
 =?us-ascii?Q?bpJ20VEwhc16rzQRuPywtyg7JwnfBqZUzm9vBlR8GopGaBSoBLy7S5dq1f5V?=
 =?us-ascii?Q?vMrvXlffDMDNfiHJS8nQc/fe83dDSUSDorIuMnckd08DAN9PTTQnzCGQhmfQ?=
 =?us-ascii?Q?ZNhH1NPnJw8xbfPe8MAzh8TxDf8g8hv5Jgt4vaw5UvzsonUmkA0OeeofZyP0?=
 =?us-ascii?Q?oxNtbrW0+fTpBtH4CYTVsfb/HD5VZVCYgSEW7kNT0sWjBkbII7OZAmw3lpP+?=
 =?us-ascii?Q?05BLx1bjSyT0PIKLFgI4QJWQXbggoEN6OOfRnbxXvSp63wwfhl+7tcB2OgIt?=
 =?us-ascii?Q?Vhrl9+uoSTuBntvEwGNbipBFhw78rokBE79HHNecesQ3WDpSL2QXu4PKOWko?=
 =?us-ascii?Q?DwFzEzXxtMnHf1hVZO44vZayv3CWP5/5TwdXNLzLL1aBKkOCXxziPdNVLSKL?=
 =?us-ascii?Q?6QwOf2Z7Z0N9UnLxEPFHlCBkR8WHYaIieUbID4uHa9Zk0sRzAR02Cf7bOd33?=
 =?us-ascii?Q?mDU/JHHjLp3aBj700WKL9spkyMHjmFF5KkBQDsHpBRbKaZoNhnRIWlXGH2wa?=
 =?us-ascii?Q?xizEPu0iL2B0ScgHgtLEWaQq/YH6c7AccenlJoTxxZheUV+/tsEsA+pKzsbL?=
 =?us-ascii?Q?OGMDtCqkhNnOlcD9q1z5iIeaQBWk/1HPfjtOvBFh4dX62sGRX2dIX3uQyk2T?=
 =?us-ascii?Q?ua6Xh9dwcFEP5BxevBuWjqVMOwZRVmbYvIsbWz9zDzMXTMeAbsOCybjMMfHF?=
 =?us-ascii?Q?fM9wvYNJ1i82GV3n/VtYYKHbpxymwpUs5ZW5BI6G/BzIoiyIJ1pc/jSUrlIF?=
 =?us-ascii?Q?f5L9SqX8dbXBgXJgkYTqtmEc8ldW70CkdfmqZ1SP8isfGk02K72fp4FCjlG1?=
 =?us-ascii?Q?UhLlucYbf97dJGQ8XOwYyBZBkYT+hnWBD8MY5dVP1bPyHSKj/b25p/smaLKr?=
 =?us-ascii?Q?UkWaNbJE7fYJc/cREX9DW0f1wNKiwY7819NC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:24:36.2582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81bdb2fc-c41a-46c8-1dc1-08dde917d760
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230

CPUID leaf 0x8000001b (EAX) provides information about Instruction-Based
sampling capabilities on AMD Platforms.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/cpuid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fd97000ddd13..55ce7d86b0f0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1746,6 +1746,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = 0;
 		entry->edx = 0; /* reserved */
 		break;
+	/* AMD IBS capability */
+	case 0x8000001B:
+		if (!kvm_cpu_cap_has(X86_FEATURE_IBS))
+			entry->eax = 0;
+
+		entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	case 0x8000001F:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
-- 
2.43.0


