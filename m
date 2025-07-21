Return-Path: <kvm+bounces-52985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17970B0C5EF
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:13:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E24A1894BF4
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8EC2DC331;
	Mon, 21 Jul 2025 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RVduJh4b"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BBD2DAFA3;
	Mon, 21 Jul 2025 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107172; cv=fail; b=pFGQsJiQ69qIQF9eUJ8c+gyk1wNYucn82eh8YBNr8z+jYot5pCEGi4Ge/QDL7SfzNWPdTcZlGdSP5WWVWTZD7OJYjLmBJiefVBju8XNYslbpNysEzwdiWOfHQBBSw9T8XzKa7SsxGW0lD4XfsKnwtlAQnZK5AsEE4EV0hYPAXtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107172; c=relaxed/simple;
	bh=SB1wYF+yx0cHIZHraE2D44TLNggMmV9xD/BmgNIDs1s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fu7QQcLWsLnPwqTSDi/7R3QS2jENmlVa0Emvc1mGyLr0St5s3mZureztMBKdqnSsjOLTCU8W2IfFKlIB1qaavP6LRL6RRQaJRleRer5sbRc0azE1oUXld/KzPjEM4ZgCSdPivtlmDfFMG47LdFTZGzzap7nWvVs3lUCfJSZ3YBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RVduJh4b; arc=fail smtp.client-ip=40.107.243.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J86gB9/7056QAH/heOmnhfn2nPhaIiOvGS7cuHug24ERZOfOOFPiSoXdwgvsKMZ1zKwsDXlMRDcRs1wSnxfSZMbHyLJCVLlhlroJc0vyCeQol4pPmvRqbxLJpS2nfup5MFe/lLKLK9azpfRZPo1LUyvnGhGZHcHZ16Eqi6jBUwO/CZ1dh5tX6W6xrD1qTNlbMrTnwyQyZqQuLdTTd4Btlf3W1BYfCQ0wXvRi2N3HdEPZuAt7YdNKc1caak7H5ZuduNjYV6A3ezivC3UwFOtb48xKB+FIivZriOz4zAMBHuw/rOqu/2XQd3zRU4Sj0qa6JTxB2tjkMhFjdVMypHKGQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xkKLJnlF/78OEYVfLA8TArPEL2ti8EssOb2Dwys1WIY=;
 b=LdXOK/lO/EDPU8YBQWlNECLdCwIo8sJ9bGSQwvAWwn/6YDRwkQU4KJW5fqlPr2bKq+WDDUssx1/Nxz5kxF/3gO0h/kcOmO0ny0tY0PtL+Wg017j68ASFXUPBx81pHjgTZCKDaamwlqS/pcxkqRfHxMzaursaxzwN9zDLcBj8FRYUXWnxOoqQgEcd6gtmbk2ca2YhPANOFPsqzQmidb+yZ1EM7uhuYVJYX99NBk/H25wxxHTZFROtwot/2JOqDFybig27YuU9zLJYii+4aUBSzUYZe35ffBtOxbk1Dex1cm/kpxksrS8yyNDhGK3R8020dcg3cdfkPbfo2ty/+7GTig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkKLJnlF/78OEYVfLA8TArPEL2ti8EssOb2Dwys1WIY=;
 b=RVduJh4buhVUikbBFqxpd4hK59Q/frOYrr+dIKGLQR/OygDRLhVZrJ8T2VKLHX8XHm6VllSCQaFZD0URNgfKXzmcRkcBY2NOdUg1YzQJHel2wG0y6Wz5kVGNdEsitN/rFCw/tXEfQWMMbCvR6wj87x/uyc6yDXzAl4KzHas7y1Q=
Received: from MW4P223CA0015.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::20)
 by SA1PR12MB7269.namprd12.prod.outlook.com (2603:10b6:806:2be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 14:12:45 +0000
Received: from MWH0EPF000A6735.namprd04.prod.outlook.com
 (2603:10b6:303:80:cafe::1d) by MW4P223CA0015.outlook.office365.com
 (2603:10b6:303:80::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.29 via Frontend Transport; Mon,
 21 Jul 2025 14:12:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6735.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Mon, 21 Jul 2025 14:12:44 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 09:12:42 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v7 1/7] crypto: ccp - New bit-field definitions for SNP_PLATFORM_STATUS command
Date: Mon, 21 Jul 2025 14:12:32 +0000
Message-ID: <47061b1e0bf8ca10aa6a7ca76ba60ceb913653bb.1752869333.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752869333.git.ashish.kalra@amd.com>
References: <cover.1752869333.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6735:EE_|SA1PR12MB7269:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c0f7bfe-87dd-4818-407c-08ddc860a9fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k95GyeJQpJb3GxPiyuMn/V+w8aZYBTWWy2l19XC0ftTCLiqFjAnjqmXb5jW9?=
 =?us-ascii?Q?I2ZCx1RYVnGOckMflxdhgvLKkMnNSJz4usINQYE+vEuxGk8B4J/YBXRT8zoC?=
 =?us-ascii?Q?8GEYd9bLY83t3yKKi+MmNdUhZnjB7igzU4pry3d73X2Vs7Qjq52eteUvVvTZ?=
 =?us-ascii?Q?wpH4XaCq3Nbm7WwBmcAeCQo1FUJ4dZd6ubouVGN/jwuEh3eEk4TedOnjo8Rb?=
 =?us-ascii?Q?F9gMU4x2X7t6PgCF39MS76hNqSuyjP93hexGBFGIJECD2HRq4Mbz6pM0qOuv?=
 =?us-ascii?Q?UBerIiSjkSsKAPj/7Kq7fyiTukCrtQ9QCJ79WP4ANhsYb9K23v0Ug/3AoHwk?=
 =?us-ascii?Q?B4mbtktigFreuQdsqVcWkKHXWxM0TzjnPj5K7yqs/M/99LG2TaVC+/1cf1Dr?=
 =?us-ascii?Q?41G0HoJp2rGCdpqGKXrQlG7M+KJFIxdHkA8UydQBUPSxYxrTzo/tMUxM4akf?=
 =?us-ascii?Q?Bz+LDnveNS9/vGvxquYqQZtqyWBGDS2pOiJez/IK1AKE+soKCp/zSZus/mas?=
 =?us-ascii?Q?VikZNS4QfC3bxcvJraLECHtwzfAkqPx0NjpZfJeDUDKXJ6kZGu4rlAtkbzEV?=
 =?us-ascii?Q?L5025LKb4yKWbUXdxspcspgUiCwGuzAYKwb3+hmoKFNh+EhWEhp/71wTglDh?=
 =?us-ascii?Q?82+GHwOYJ/TOCVlVAkHWToY7OsZWFGCBl9FLc5B8TCBDqKP0pdmhX8j6LhoN?=
 =?us-ascii?Q?c53B7VMhL6L85Jlow2fKUrCFJlbs9CQgc7e6c0aIKLIeoVFndazXGDLdfISM?=
 =?us-ascii?Q?4tC4JbbO6jXQdM4B41RVWzq6Tm/XFuQCzJ6lRmMDY9aG0F8OsyANbqztTTIr?=
 =?us-ascii?Q?jgEn60P482Rk8UuV6OwGd3Naho79PDK7+E/ltXaIaqzve0v3MpeJk1v1zBmP?=
 =?us-ascii?Q?GgbGHW4LHjo1eHfgcEyWGas+i2enjap/PF5FBNxiTQnWje2oLpreyca+UmTP?=
 =?us-ascii?Q?nkHayBwIRNBo8X1WnDH3AfGBgaul6iB6IvzkInNsl4feG/wQVf/c+xOvRbjd?=
 =?us-ascii?Q?3uCq/fRjQkzLlaHzZR9eKO/n0g4kNaGVkOBa7K6//2vtIat6JKdKuh+YVGI7?=
 =?us-ascii?Q?pZF8Jq25pmwotkRc8OLP6zEibgmIkl03QWDH+iZynKnt3Zg5rHuNcA/Z5J8i?=
 =?us-ascii?Q?FOTtkZQ/SSCFPZUqv4hkaMV9XX2Mwu4WEyYhhaaKPdLP1NpfbqW4W5U36SI1?=
 =?us-ascii?Q?+YzfbiCzizy6vFEXGm0UujqE7d8gdpiQJHNuxz1+ABkyZ9cibgnk1Zdvn+ZH?=
 =?us-ascii?Q?pPAAv8gJ1A7N4itm3iJ6QCWwRIXEyosFDVDnrRblnB0IRIp6/eXCdDoqpMRC?=
 =?us-ascii?Q?DAy7f9RrecGAzIgwdz0OClhCURB/E9YnWxSEM4EYGxCT6qNrLV72CxUYjbIx?=
 =?us-ascii?Q?AY/bsYJz3t2xyJ40D8qdm3aU405/4Smme8BO/3AyTNOvWLnKC4JIF+QFEquS?=
 =?us-ascii?Q?8ttzHIbDjfkr9L3lmdRR2IB5+O1B0K6l8wmYMR7wHEwiGNg/D3JWn+HMPfhm?=
 =?us-ascii?Q?qTbSt/FGNHhXMfDIqpSr3z438l/fN1AsuPqly+Z0f0Dd/AVSGJTV1gmx3A?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:12:44.9528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0f7bfe-87dd-4818-407c-08ddc860a9fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6735.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7269

From: Ashish Kalra <ashish.kalra@amd.com>

Define new bit-field definitions returned by SNP_PLATFORM_STATUS command
such as new capabilities like SNP_FEATURE_INFO command availability,
ciphertext hiding enabled and capability.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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


