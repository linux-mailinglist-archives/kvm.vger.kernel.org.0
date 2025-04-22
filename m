Return-Path: <kvm+bounces-43736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EEDA3A95A25
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 02:25:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B82AF18969EE
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 00:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2577218A6AD;
	Tue, 22 Apr 2025 00:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Nou5/P7A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EED7BAEC;
	Tue, 22 Apr 2025 00:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745281480; cv=fail; b=GEgKmzFlklGgNneXTNCL2UtrlZJhyGIY4QbzJLnfH0rjitro6FG+elUVEYjl9qC7K/C448ZmuzvH5e/KVoxJlq8zom8a+Ovh2tTtd5xG6ReW1TO79d8QUOXDOHF25q8+ikrcRzxDGdsT3/1HJNvKYc0xur/MQonbyoIre2gwdvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745281480; c=relaxed/simple;
	bh=iuvp7QQTCzbzbu2ifNUJ1n7IhP2Pi92rStx7EM4kNoU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tEGwlKmNQhKGNz4ODM1yybtjzzUrgL0jEb47IR0uvOs9+c60iWU7ySEU+ZilXee+OO1UD/j1ADoAPD8wZCc0BuTJPM0EDYkjDz/P3AJrBLfvTLtf4K6wGefo2EWQYw+DmuDubN4RNZVyzPpgndfCLbLEbEUKBPUhEHyDERb7OBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Nou5/P7A; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XHSJc7xJYlvNFMeVcJvrJR/EYyV7mnreWhXXo43DjHKorsUL/mxUMMKDe2+migf0TfjhM1iS3vo3/0CnX2uifUwnylR/AszUt6cWf905aD0n+aMEbtTzTGvIoAGM5vhcwMeyi7FzN+oHE+Zs5fYE4rViouWdtueyjWWfCRK11OSHUyx0a9WspmsTKr8OTmUqxnmScPe+YmWHNl1qWoEKsqPa4gCChJOoMIbgkE/3p7/pGR12bhMBaLdF6LETdmKlXwTyEb+ALMnQsxgwgErNd9At9d6lcXLOFGAg6KBeCv/tmJUb4g9+BSCMKmGrtK4/ekU3IGM/qh7RiMP/rT6r0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYvwT5PreAuiHG1s1zbDu9qyWoPPUxadVhJp/06e0Vg=;
 b=UFTmVhP70ILqoYBtrJCtqlmrN+LUnEDAmKvBpO5cY+39+VqfRrbKJcwbQo9uKWFvtj5+wG3X4ogFCYYZbLWkbx6FLcSpigGscEo52rTyGgXqmtcOlKiQuaEMyh6rFZabB/Af4anC8eEONtAQsoEVvX3n+WyOAp+dpAtwzXzwFmRefaLsdHFFmkZdqzBRmhaGrTL92kwE7GO/jUCpPdtbtItQq9MEQOOrttfLCB0B9k+SSZNj+3Y4i4XZa+bCZY9QfIKrXZnoMW9MPNPt3OUX2xCIsI0xoy0bf+e2VfooiXj5R+SgSq0du88UQA+uaAEtRMnX14xebYdHQn6WbqjHAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYvwT5PreAuiHG1s1zbDu9qyWoPPUxadVhJp/06e0Vg=;
 b=Nou5/P7AUnsMHtvqCo/Fv9N/VW6ML9R+W8lsUKlsSG8NI2zEe8giy96f1irUgAD7dRjpj1KRPYg8QY8X9qiS/81qi6LVr+d2XdmGalSQ/CrxUmxeJ88uHQqDHu01uV2Cv1EoSFx61kiXTLM6RFQS8kKvFtyjtIL9inHt8to7S2Y=
Received: from BN9PR03CA0183.namprd03.prod.outlook.com (2603:10b6:408:f9::8)
 by PH0PR12MB5648.namprd12.prod.outlook.com (2603:10b6:510:14b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.32; Tue, 22 Apr
 2025 00:24:32 +0000
Received: from BN3PEPF0000B06D.namprd21.prod.outlook.com
 (2603:10b6:408:f9:cafe::c5) by BN9PR03CA0183.outlook.office365.com
 (2603:10b6:408:f9::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Tue,
 22 Apr 2025 00:24:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06D.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.1 via Frontend Transport; Tue, 22 Apr 2025 00:24:32 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Apr
 2025 19:24:30 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v3 1/4] crypto: ccp: New bit-field definitions for SNP_PLATFORM_STATUS command
Date: Tue, 22 Apr 2025 00:24:21 +0000
Message-ID: <0e0bda59404ab36c6bd7067ea13b8020e62dab11.1745279916.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1745279916.git.ashish.kalra@amd.com>
References: <cover.1745279916.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06D:EE_|PH0PR12MB5648:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b929943-1fab-43bf-fb75-08dd81340d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?81ULuNjQ/PSeWGbkpdGOoo6ex0IwLkCX19MoF/rVdLb56kaEuD7hAU4tJGNV?=
 =?us-ascii?Q?Tse2gq0due1N9MW43Iynfb6308n8Tr2PzWDuXOOc7auzfgwSXsavC49RfsK1?=
 =?us-ascii?Q?zJSjIiuvuBDi09x02xUSpLH2u3JkVh2zxGc5hWczeRFSEiBPDs9TB8wqnOgL?=
 =?us-ascii?Q?L4NMVLiA7rF+EC61b4BUNbH02GJ9hFa3kEYNLAAGz+/vDao3ip16/H306xyw?=
 =?us-ascii?Q?RtWGKEhkSu6bjl1vbm6afFwONwDr0xPjjvk6URPcL9DC5fcf5raxY/tURHj9?=
 =?us-ascii?Q?rsDllq8LM3CUHGtjKKtSINfBd7J/RbbxsfpNraekLdQJnY0FPpha4yT2EVol?=
 =?us-ascii?Q?D9j2kMBt1GrlPiLlWlvvjRb4dZREUpTkmKaxFuAIG9m99KEaqsFgbbYW/geK?=
 =?us-ascii?Q?i4puO4bqAPptAseOjPgSDb5CsvH1KHu9XamuJYwFqLYS48zzmIkZd5OXisiI?=
 =?us-ascii?Q?yc7Rd1t891r00WU41CVjgd2UR44bTK4ZEFWFEAFD9I/97ahg1TrDRQuMCa4j?=
 =?us-ascii?Q?HiDi9JkyaxXa3Fls4dweX3cs9lrr9rxTv8ANpQJ3l0/WkgXIFSEPTNmgDdl8?=
 =?us-ascii?Q?jPg7aOfoMAwUM79I75Nn0+YuFZS871laC5g07v42sOnj+4I1dA6h/MATZ0hw?=
 =?us-ascii?Q?TWlzTGFRze9EGEN6CoHVxPzImX/W1YWF3pGIvMztyUC+cxiPVINamoAcZzH2?=
 =?us-ascii?Q?InLpRzmnq+luYYusMiaYMrpLUSveju7olGoi/DYZyofSKuu51ZYZeD0Czwxe?=
 =?us-ascii?Q?Ma+/u7nTqTOeo1dlv/SjmMVpIp/6IUqa4wYQW/AOpUuj3SvIZBAbmWc8icAd?=
 =?us-ascii?Q?04DFajbk5FGSeYI/f9NN/dwgsqZgJyVt71w2FixVN8HkU8fIOyy9o59g1+gj?=
 =?us-ascii?Q?I4qjklBKL6D298dsBY7MTBo0CkN9Apzjuv9E49SZNyShp0Us6cBHh2ZBtwUs?=
 =?us-ascii?Q?E/QIRm0Dk2X9Y5xhhaWiNJN8SuiNaQhOQ594SK4WVBSMX7clfryWS+j491So?=
 =?us-ascii?Q?6roYrfqzaxHj8m/T+Y7ammKZGOWJEqDCQuCSzz1nN8zJ7yalGbmmT7bm8K+l?=
 =?us-ascii?Q?rdBiapjgBpRZxFc76yunJAhNZt8547cfzjfiKIh5n3YSAnE+2+aKBLsnnQBC?=
 =?us-ascii?Q?+6Eg7HEjQriig7qp2/mT2dySnz4+uKiwAIpP9haJ43UpjfPaCdQ/1KZyUdHx?=
 =?us-ascii?Q?G9f139/AxxwUyLwIdUNG3VxuOYV1vtzWx1E72sfFiilDqu96mnY/J6ZS3FIn?=
 =?us-ascii?Q?PG8m6X4ylegAyMZ8cvbdVkXEfaTtlZGmdh1/aKdgYkDn5DkCP4mbnyF2GSoy?=
 =?us-ascii?Q?T7gEUTzSNABLyIODr1QySE9/LvcR+wK3F0IRvtavGZrlvExXsnbQ0cxeQBAA?=
 =?us-ascii?Q?o6ND0iO+GFGRIXVz9Ku7bmj4Obb7qK9djwz69dlvrzp8MVn6W2bdmrcS6VxJ?=
 =?us-ascii?Q?aNcv//vmsnRrkBXT4PQ9L0f25OPsnmYXMCHSO0/d9H190KWNn7hfsyhUT9KJ?=
 =?us-ascii?Q?pDp3XGhPnMeD71784n90LLwrTRURAhogOiee?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 00:24:32.2582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b929943-1fab-43bf-fb75-08dd81340d9a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5648

From: Ashish Kalra <ashish.kalra@amd.com>

Define new bit-field definitions returned by SNP_PLATFORM_STATUS command
such as new capabilities like SNP_FEATURE_INFO command availability,
ciphertext hiding enabled and capability.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/uapi/linux/psp-sev.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index eeb20dfb1fda..c2fd324623c4 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -185,6 +185,10 @@ struct sev_user_data_get_id2 {
  * @mask_chip_id: whether chip id is present in attestation reports or not
  * @mask_chip_key: whether attestation reports are signed or not
  * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
+ * @feature_info: whether SNP_FEATURE_INFO command is available
+ * @rapl_dis: whether RAPL is disabled
+ * @ciphertext_hiding_cap: whether platform has ciphertext hiding capability
+ * @ciphertext_hiding_en: whether ciphertext hiding is enabled
  * @rsvd1: reserved
  * @guest_count: the number of guest currently managed by the firmware
  * @current_tcb_version: current TCB version
@@ -200,7 +204,11 @@ struct sev_user_data_snp_status {
 	__u32 mask_chip_id:1;		/* Out */
 	__u32 mask_chip_key:1;		/* Out */
 	__u32 vlek_en:1;		/* Out */
-	__u32 rsvd1:29;
+	__u32 feature_info:1;		/* Out */
+	__u32 rapl_dis:1;		/* Out */
+	__u32 ciphertext_hiding_cap:1;	/* Out */
+	__u32 ciphertext_hiding_en:1;	/* Out */
+	__u32 rsvd1:25;
 	__u32 guest_count;		/* Out */
 	__u64 current_tcb_version;	/* Out */
 	__u64 reported_tcb_version;	/* Out */
-- 
2.34.1


