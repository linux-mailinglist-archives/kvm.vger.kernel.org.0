Return-Path: <kvm+bounces-56405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A30BB3D8A0
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D81A63AB5FE
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F2A213E9C;
	Mon,  1 Sep 2025 05:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JumOM0BA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5178922836C;
	Mon,  1 Sep 2025 05:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704155; cv=fail; b=E55Ynt6lL5FGgzJcJFuBqk6XRA1P5s/p+ogezvJeb/J0Tx502qH5OZflwJ84I1jGLy2uH8p73yd2kW/zLAK3hBtNtrYmzTl/hKTUtWh4/TjBXv0QPWiwpquICG+AJaCcVSaEMm88njlzfCreVioi6Y60SVDDih0n0rVfg2cgbRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704155; c=relaxed/simple;
	bh=golw/MdU3B11ZL70NEyNTa0wDdcmYyAgCR9MdzE2Edw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6VaS46Q7WM+lzWJCdrkGWlOGj7TZ8jGbFeh2DB8rBcFPEpcPuCQdarMbbOAJkB3COiuQfrW3Ziiyi2mzfmNy6afc3mXO0fjEuO+j8/Rhtwxf89+kM1g7xIQJFkJuU4Ef833XeaWNa9UIvnv3eI85oJ82VWcQbzgKMkI2H1qZ5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JumOM0BA; arc=fail smtp.client-ip=40.107.244.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gwu1LkESR36nXT9JhQYCv/IClGBgxd0FeyHsMXc/m098ZNKtz1lEgNIVmhofYBQRHfQjsvHjHzke1S0bv2+aXemlcf5IITy+a148IY3mnWilZWLmJrwExu50IF3SaUENbuBorjssOHM65KVxkdCgQ8ajmsdrPSr6Oat2nruXwEJBZXm7ZLXLEUJvZCItrpHiE2ydbsX3T/2G2gbtfNc9h4A0bJU2qQejM6oWX9xPjqLNuuYQ9T1h6AhhQeOHG9Bq6Ze0PjyJZ21BBQchV7OlZWtrzoi01Jt3QXRM26UWMBlcW/9I5sP7+Wzmsw96eMuhPj6E/MG733IyiQv67wsBQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoDaYOYlobo2EClU7HlBok1W5natDwvaintz5IqgWV4=;
 b=X/sZ+pzDNlFC3VklwoMqERcye3c//JkQ4uMBi2meeBBrsNvnTS2K7b/7xCAJAsT6fNuBEYhKpuZhW7uOSoBqo0jVWIa1MrfguSv66RfexIKHOOq86ZjZZNiWgu2g0mQvuIf3sRq3NozPsH1u847IUJxju07cmIUxDRpBJzi9fclPkAM53sXjVFSH2iwSwhl36W9QMkmciVivxnh2FcRDg8lKEB/O5oniInnbdIL6ZV+veGEj5lZIBmAAPcTyD5pYFwSnFBEike0MsMG8lAok+C+DOY8/kPG5lhuqcewR9hrJFBO9k67yTCIa3cKOVnGcTAwp7+5r6n4MjaDAImGjhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoDaYOYlobo2EClU7HlBok1W5natDwvaintz5IqgWV4=;
 b=JumOM0BAj/jhMsDRnQfCP6bVQb21bOfjL8uFIEP8ma1w5c1kjtl9Tqzwxwo4fOwOZgFoHCQpzADNEEmNGceLD2WlyW2/zOyMGLDMpQ1Oz8qrX2jj+0OEPQBsaf+cIz1lCPRgjPJp0caFdjDYZ+evzmUOj8p/QfZjU0IJioU139Y=
Received: from SJ0PR03CA0259.namprd03.prod.outlook.com (2603:10b6:a03:3a0::24)
 by DS7PR12MB8417.namprd12.prod.outlook.com (2603:10b6:8:eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Mon, 1 Sep
 2025 05:22:31 +0000
Received: from SJ5PEPF000001D2.namprd05.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::a9) by SJ0PR03CA0259.outlook.office365.com
 (2603:10b6:a03:3a0::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 05:22:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D2.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:22:30 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:22:30 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:22:26 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 04/12] x86/cpufeatures: Add CPUID feature bit for Extended LVT
Date: Mon, 1 Sep 2025 10:52:12 +0530
Message-ID: <20250901052212.209171-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D2:EE_|DS7PR12MB8417:EE_
X-MS-Office365-Filtering-Correlation-Id: ff4a5617-a249-4f86-4509-08dde9178cb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PXUeJ4jI6V0HGnidLHncsO36MS5qY3c/rCIJC5ZGfK1Jc755UFZI1Z/bvLDR?=
 =?us-ascii?Q?72Sbyy1bVP2ilPl0zo0lw2kKVbDFEEN9JML69bESTMEfqUgGJv3nzsngYlwY?=
 =?us-ascii?Q?pGVO3XhWoc0xYlFIfMoaVSSwRIbzK3nsbSaK2XuoBV/CPOnWXhCDE/n8MhcX?=
 =?us-ascii?Q?IzQYZGXzddvnUpFfe1KuZ0VA6Jfi/Lev7FbjsCy+RWdzacDaTqG56pBoObra?=
 =?us-ascii?Q?upmtZ7q5ClR05k3IOlZ6AtjPoulgqadldy17YgYbM6J3hYDNhPnW0hl7bvK3?=
 =?us-ascii?Q?KMqb9G+WkkztwvXX9fzCnNZVzPh0PlGFMrCK/fKTtMHdj4jF4lzbv3liqgJk?=
 =?us-ascii?Q?GsHwTrmgwZRSRJYTOwoMd5M4YluAPPnUlF1PwdG0uekakGfCj4SiDyh8n4YC?=
 =?us-ascii?Q?cfbceN5TiYQN4gaikE1iiqgF3QTl1pXglgC93VC89LpTfx08yzO72k1uqln7?=
 =?us-ascii?Q?q+8qsO4j069OhSRDMCNyRyjU3xJg5fm6k5RVjXkR8uHJwTPJTDQeQ9S253ki?=
 =?us-ascii?Q?eMpSROKXqVvVjWni8gwD5xacoRCuB513JZqHPbwA1HvwV1CNXOimSl0QK2ho?=
 =?us-ascii?Q?0wL7BM357VQPD3A4GY9SZIPTqdDvG4mQT0d/2VgZSORJwhWSrMJ0BoHtsDiL?=
 =?us-ascii?Q?5k7C8Sf3TFseiuTzvNQZFUxMoInS8MzjUPbIdWMIab/dbXFhXCh3PitHykwI?=
 =?us-ascii?Q?qpUN+xeDujD467tXVuWkYWde+KRFsz7yQeQGZ709W6e2ShHrbtHT4gYga/wB?=
 =?us-ascii?Q?DTj+VcGNSDulQxxWHQCG45J7Ni6kVzKbjb1YDECrN9+lp9wpG0v2OPd6qtsn?=
 =?us-ascii?Q?NdWPKOZ37K/6YNRyvBaaaMao6PPJTmPMX5wj1pc0w44+kRoVNMDIzVDPu358?=
 =?us-ascii?Q?ZyoCxpBkbfNUVfkffjdDPnUspAjlfCcvRXjmkR/uCvvyUir4Ney19eYXWoCi?=
 =?us-ascii?Q?LFdapHyS0nOkPWWJTuNfi8X17kgwNnbK8FX/2VNM2rug52mLCpYd4uTwo4LX?=
 =?us-ascii?Q?dcegFW4IrPTAMbQP9xqfVcVRy3dNbhTWw+UF4mJCoCE9dIcgqZ1mTZMZ428q?=
 =?us-ascii?Q?t6Yhdv3y1uGsSkWYqYSJ2MQgQxEr/Wz6Nr4aAM4QUcixk3CaY1QIq4EROIyM?=
 =?us-ascii?Q?yCojzn1EYJAkYFyHQ42aTH0PEUlcUjXqnU3E1w816S5aNiYFL6/aE1Subha0?=
 =?us-ascii?Q?ZBs+AvCIqehnVNne2fP+BgIVcoBJhzXUQyGMxm5RICm0Bq10f50BFV8UWUZ8?=
 =?us-ascii?Q?tDp9rCMIrdJKeeEdd/40EhRRVd10VTjpZ06t+eZINgZ894xi3nvDaIvb1Lom?=
 =?us-ascii?Q?Iq/g6MYYyjvgyXNCFtxDm1rSRP1yFPlCqxw3p66+1LRyF64ZZ3OXc2DiOfbs?=
 =?us-ascii?Q?TqtTfvPgw9Se+RKfrcjaqBOztCsirYqVhxDQeBdoqRcNFQssCN9mSFkAq7IV?=
 =?us-ascii?Q?lsPDD8tPefCEVuk1khxLZhYzI89cjk/YTQ623FLCy8WT06FKXDPKMXvjRtIs?=
 =?us-ascii?Q?Drm8wExxDp8TNIpUstzQW1SriSL7hgViEk/C?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:22:30.9406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4a5617-a249-4f86-4509-08dde9178cb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8417

From: Santosh Shukla <santosh.shukla@amd.com>

Local interrupts can be extended to include more LVT registers in
order to allow additional interrupt sources, like Instruction Based
Sampling (IBS).

The Extended APIC feature register indicates the number of extended
Local Vector Table(LVT) registers in the local APIC.  Currently, there
are 4 extended LVT registers available which are located at APIC
offsets (400h-530h).

The EXTLVT feature bit changes the behavior associated with reading
and writing an extended LVT register when AVIC is enabled. When the
EXTLVT and AVIC are enabled, a write to an extended LVT register
changes from a fault style #VMEXIT to a trap style #VMEXIT and a read
of an extended LVT register no longer triggers a #VMEXIT [2].

Presence of the EXTLVT feature is indicated via CPUID function
0x8000000A_EDX[27].

More details about the EXTLVT feature can be found at [1].

[1]: AMD Programmer's Manual Volume 2,
Section 16.4.5 Extended Interrupts.
https://bugzilla.kernel.org/attachment.cgi?id=306250

[2]: AMD Programmer's Manual Volume 2,
Table 15-22. Guest vAPIC Register Access Behavior.
https://bugzilla.kernel.org/attachment.cgi?id=306250

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 286d509f9363..0dd44cbf7196 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -378,6 +378,7 @@
 #define X86_FEATURE_X2AVIC		(15*32+18) /* "x2avic" Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
 #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
+#define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* SVME addr check */
 #define X86_FEATURE_BUS_LOCK_THRESHOLD	(15*32+29) /* Bus lock threshold */
 #define X86_FEATURE_IDLE_HLT		(15*32+30) /* IDLE HLT intercept */
-- 
2.43.0


