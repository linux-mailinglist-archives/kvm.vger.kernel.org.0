Return-Path: <kvm+bounces-40701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6ED5A5A49A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 21:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D726A170E06
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 20:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB0441CAA6C;
	Mon, 10 Mar 2025 20:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z+vSz7/C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2067.outbound.protection.outlook.com [40.107.101.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804B91DF248;
	Mon, 10 Mar 2025 20:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741637794; cv=fail; b=Zrnw1zDmxHACNGNgkPyan7B67duNtZ6Muw9FFbzDGSXHe+Q6RuAUnluF7PxzY/cBunf+i/DRdPZ5B0aVfy3NuvTo9bOxY3GjKEQ/eBe5K3U8V0fcD4QURxaDY8oM9XpcFj6UpgwD0ou8SI5pbDC712rTwTnDv7z390WjoT2KsA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741637794; c=relaxed/simple;
	bh=dcgDJ3YMDC+Lbo2y8aYvkeoZH0t/Hymt+iHU7cc14GM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vC9lFg8yKA+cK1c1b8d3yZaxe6C4R12vS72XOBKOKLnUGZyO9CN4jCmElZm91f3dvMu1zy+UObrAYcIa5mx3gB/JA3eL7KvVJvvmnNKXEOUK8Nc+O3Ooa+6dhO7bpjkdzT7heqxyMKf9b6h/VEMv+hCX0JLfHMOtv0nkthvUWyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z+vSz7/C; arc=fail smtp.client-ip=40.107.101.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ST5o8y8WT1CpGw/VDk/VDoX87x/91nhnYwpqKBKwIlYqZac2pDiOw6y0qu9ehuM3a4AeIKqj+42dFap9CaJaY/AK0pRpaOImFXKMbAuHO9QdVlc9IYlHVhHkNPkki+hXMXBYDfqtu6lxFkxF5HJZNPjfIdnL4uwunnFvr9H4SuAArcCiAcbz5o5J5FStfDQ++tjZo9VX0tou5YW/c7ohnH5pIDRmiyQhpnqfGYCBUzbpPvy0U1fdnUXtmf0ehbvdMZvdhWt/opkbn3r+CGvgaNcSToMoWwzWgbz8e6Pe174ifrnRVJP5JvqIcCE98DPTBLW7SNBp8dkdnzPTrNsenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQulctxDXCTHyvy5KXTMqNj7eqStByMkHS9kC8yAaj0=;
 b=MrBnmBUf7sUSA3CBKTwpKWEo5jGo8PAdjiFMC2+bXGjsocKScJtxUp3PanVSdcecJSymPUjBXQpjo3XfFeqXqpborelPlVPPGHZlRlSFEB3qRW0KXkt7y/KDQNR4eS0cX953Y6HpVZjE8Y8muf3ho4c1ENHmgEWmMntTbL7tGB9grn83AKp75SYy6q8U/PEZK7d1+Iowv0GdusvWFA+pIGWrYomEKlyLXBJ4aZAtfQhWWVlruNuZOQW9RkFsNkSbzEfk1RSof9P7vLrsqDKukYY6qNXoyy5YwJzSHB7jAAb0I/AwwIjn38XYlJYPdrFYyZdjQR3g+uAgeLzFIZZ96w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQulctxDXCTHyvy5KXTMqNj7eqStByMkHS9kC8yAaj0=;
 b=z+vSz7/CQBUV9NEbaIwtz80t6U44j4bOp1gNnCfFOOe1ICRn3U/K8fBBRGKSOW4zmQrB4BxtyEZTXxfeaVcRng9E6IFR0gJdVbVl9Ll2SSZxctw47IB811vByvSHCrvdWM5ZOHAAHvJ8YRzG0dhUIkzrXQfCGqqO6CfECZ1ckvA=
Received: from BN9PR03CA0122.namprd03.prod.outlook.com (2603:10b6:408:fe::7)
 by IA0PR12MB9045.namprd12.prod.outlook.com (2603:10b6:208:406::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 20:16:28 +0000
Received: from BL6PEPF00020E65.namprd04.prod.outlook.com
 (2603:10b6:408:fe:cafe::b2) by BN9PR03CA0122.outlook.office365.com
 (2603:10b6:408:fe::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26 via Frontend Transport; Mon,
 10 Mar 2025 20:16:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E65.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 20:16:28 +0000
Received: from zweier.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Mar
 2025 15:16:26 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	"Naveen N Rao" <naveen@kernel.org>, Alexey Kardashevskiy <aik@amd.com>,
	"Borislav Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"Sean Christopherson" <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v5 1/2] x86/cpufeatures: Add "Allowed SEV Features" Feature
Date: Mon, 10 Mar 2025 15:16:02 -0500
Message-ID: <20250310201603.1217954-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250310201603.1217954-1-kim.phillips@amd.com>
References: <20250310201603.1217954-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E65:EE_|IA0PR12MB9045:EE_
X-MS-Office365-Filtering-Correlation-Id: 8525db51-a3f2-4891-f065-08dd601070b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jgQNYVipWq4EfILsKLh0tI14G4nRuIgUHO+CSrZySjzDLIgQXHDM8J8gjfVL?=
 =?us-ascii?Q?pq8UyFWt1QU+F0c715HSYa9DtuMX6ofLM949/eT395kEMkCsSfuxeYg7a/5O?=
 =?us-ascii?Q?EpnPAwCS5nGhfUP7tzaTfITrk8giysIOaRg70HhaaRBiD/GkUeXgebvYacZ2?=
 =?us-ascii?Q?7UeRWtQL1DmADh4CL4nyLrvDK4i2/4e3HJNASR1IsmhAjmFpNIhJzGK8Y5/U?=
 =?us-ascii?Q?wR9ZSpA4u7bC4wYR+RYlHx6rhjuTxd/4Nc0Vz04cbiwaiYOdGIpiFrcamAsn?=
 =?us-ascii?Q?JYxLHgx1aIhnVEQiXngsUCO6YIkJhlallFWXDTBEmqY5rlGE+r3LXTLZcUnz?=
 =?us-ascii?Q?ZgTaZbs05AeOUZdCTumNQzy1lsgDwnxBJjZeNmReMQYz25hW4L5TjG2yTMjP?=
 =?us-ascii?Q?c18fqX9Ud7KW7rjmJf9JYUeO+OMjl5CQCLZlfciZyVt7rg8rxBPOlsdmyaS+?=
 =?us-ascii?Q?J+5i+ABv7ProewIE+bLisfwsd9CHO7tFnXct5TSUiJCL/T8HFiKzmLaGiH8g?=
 =?us-ascii?Q?SIMiC8iOZoYny/mxTH99R4ka4Kwbl/536PmElXV5fhY761T4jke8RWu26hza?=
 =?us-ascii?Q?dw71VPZ1LEtKSHxYiq8rGQeo4qgbx4Lkdy6FSSM9skDgPtivPXMZy24Nun2Q?=
 =?us-ascii?Q?LB9ynRbyQsPoOJ6ibqhTVnMh96eqT7tqTnWc1szW8+aHxquI7GvzixsIU8Yq?=
 =?us-ascii?Q?F2ELqW51TdFAhUUGWYdOIE4YmRErBpqXAKbGbLtA32RdnKIIYivulzPOoBfg?=
 =?us-ascii?Q?vxItJd+gwdMBBF4TvZwyo94/WHMMYS4cyA15K/IujChhi954t8CjjID7doVc?=
 =?us-ascii?Q?SAkoLQA77OpBK10/zQp8nHQP9wNSnRKbEdQMHVTnL4wdmAgZNJF5J/YWnj3Z?=
 =?us-ascii?Q?SYL8cwOdD1OLOO7tWf0uZ6RZcGilUDkvLLhC+QwvEVHNBHVZAFglnD53KOIb?=
 =?us-ascii?Q?phVV0VtPwauu9PrHot3j+dAPafncGo6KiOdFhnpjfx4trGeM+zmzLQ75DiuG?=
 =?us-ascii?Q?Ad+2sOJC757dN84j8p6ljOtHPcjKo53qRakXtFk0/rGX/bEjFkS+DfdENHHv?=
 =?us-ascii?Q?B1I9nqWmzHA/8cMkG0ZFhNScCLCtSTxdI+O9wGv9Z4Djy51lUDLoZNkkyWxo?=
 =?us-ascii?Q?FAH1HHQy9mTEYhPcT+d/02eLdKvdkFpPOvVfsL1QHKGqlhETUxvIUlDhEXkc?=
 =?us-ascii?Q?iOzSsqVppYYie0DvwJdbMc3FcjCcC3Mi6AOwBYBthss/LYgSM1ppyBNv65dh?=
 =?us-ascii?Q?CTteSQojw/JCHSKCl57nmsnywM20t4hwx52o2ysF24KpwqCXr9Czz6nIywWR?=
 =?us-ascii?Q?DD8f17gVSVqGwxNaocCe4gy8g+6kQIuAvshO6mwAnQS5XVLMeyEnIpud8SEy?=
 =?us-ascii?Q?ofXUhQwrIIn4Ev05+HNVoLn4/BeWp/mh2ZKFEp24eJAXpoiN67StZUdpix54?=
 =?us-ascii?Q?jwSEAJdvcNHSTfOSUCF3+oUwstsQ93L1HagmfgAKwT3GJssDVA41lycn3Vwm?=
 =?us-ascii?Q?AON6gfidZz2dwxs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 20:16:28.2593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8525db51-a3f2-4891-f065-08dd601070b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9045

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Add CPU feature detection for "Allowed SEV Features" to allow the
Hypervisor to enforce that SEV-ES and SEV-SNP guest VMs cannot
enable features (via SEV_FEATURES) that the Hypervisor does not
support or wish to be enabled.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8f8aaf94dc00..6a12c8c48bd2 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -454,6 +454,7 @@
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
 #define X86_FEATURE_RMPREAD		(19*32+21) /* RMPREAD instruction */
 #define X86_FEATURE_SEGMENTED_RMP	(19*32+23) /* Segmented RMP support */
+#define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
 #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
 
-- 
2.43.0


