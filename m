Return-Path: <kvm+bounces-27058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A48F97B481
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 22:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B0591F233CB
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 20:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5164118BC04;
	Tue, 17 Sep 2024 20:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WjxggxtP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB6E3B1A1;
	Tue, 17 Sep 2024 20:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604188; cv=fail; b=uww1MgbUOS3NU9Jh2A7eff/06OFqUiYCall5lE/uv1eYQgfl4LmhlLKmIaD2+8A9kShsdq2A//Ty/jdoOre0nQIiZM5SunWpuLh89Wg2kSgC4B4EOrhWiutdA2Sx2jNiku9hhSBBL4bMSmdS4rhoh4eNn6BATpyY84YaG32rfOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604188; c=relaxed/simple;
	bh=EEuTcsTlwaSykvRrJtGC26gbdXYScsBvDfS2uujoAWQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQKqtIroxR177gpgInqL1/YqcVNnvAXsMxXrJIAarbh0OSBSJcyUOM9W4+5uNPO7P34rXiUc63JWvlb1T86tpwJmdVDi79hvmcpqtT+EDXag9LZ3QBNrxu09W35DgfSZF+eUma/2BYXKxrH5K8cy35imDu5YtYKhvJ04Q7qdn/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WjxggxtP; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8RqbU0QYVCZeshQS74nWJA6RuIKEH5Hnr98xe6X95Tt7PCIeVRc3GIVigf/DDnQL2UytVQiobTcFBFlWcKDry/Sv2RVzQW4AVmFK1H7GMjupLlS5/X2hZkvsZrXHbecx9pYT0w8++v5c7GFh2yUwcr+kU5Y6cYOe4Eup/iIwdkChlnULulm+Valo7CdzXMMmEh60HeroA3onYxVanwbnBsI26To6M6YYzqZRaefMgigqVR2xt33ULZSKdPGR8368WCHXu/GGJZenMI4Ts3slod9bJ4QtYFPi8E17Lo6Nwa6+TJBoKt0S9ZrOemBBqKfMgITFDn7YbsGNlcrK0cviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdSzXhpqmfbfNm+ES6/XesEs8SHjShUHY1kK+WyFWHk=;
 b=jq0rIJS2HGFBH9OaTh4CcLUhMSJPuhuY2NI92qAzVh4yn3e9qMJgo34Ixa1vTIJwMa7ykmYFYj2jLMUPcJDFPyKdyWJ73po1oYvmAqhCfkjPKZ5e9WlhNu7cS1eOiMhZizHmXWzx/RFEVOPSyoS+NO282kg9Sv5Mx+7sCeNjEFwrp6MxjRTyRXbEVYAmWDJgkC/eO5i8o5iQtE3O5z4CdrSI6FStzlg0Jj2u+UTjsKnNpnaYoPkTzveF6i3iNPC3hbKEgIJbcjpsO9M/06sDxQETEqOeXLTaZZebK+NM4j/cU7ZdjrOO3C6RaVSqwRZWaPNWA4ootVntOXJQTQWC6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdSzXhpqmfbfNm+ES6/XesEs8SHjShUHY1kK+WyFWHk=;
 b=WjxggxtP8OONCfnkuo0vGYyweyoa8U5fs+nvxdsCIHuosPMa8laDa9meb5afafLdBtSv5F76DV8Z7qYt4MlwwWek/bOyMy8rGDpvI9lm8j1HRW4/8UTTEMMBLdRPM0yIT7TD1aEOQanYMY1+FsFhl5r3Y7v9Lj23wBOHeqaWZyA=
Received: from SJ0PR13CA0141.namprd13.prod.outlook.com (2603:10b6:a03:2c6::26)
 by CH3PR12MB8481.namprd12.prod.outlook.com (2603:10b6:610:157::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Tue, 17 Sep
 2024 20:16:21 +0000
Received: from SJ5PEPF00000205.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::a8) by SJ0PR13CA0141.outlook.office365.com
 (2603:10b6:a03:2c6::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.16 via Frontend
 Transport; Tue, 17 Sep 2024 20:16:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000205.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 17 Sep 2024 20:16:20 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 17 Sep
 2024 15:16:18 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v2 1/3] crypto: ccp: New bit-field definitions for SNP_PLATFORM_STATUS command
Date: Tue, 17 Sep 2024 20:16:09 +0000
Message-ID: <afd7d4c5192109519ada49885e9585a1699820bc.1726602374.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1726602374.git.ashish.kalra@amd.com>
References: <cover.1726602374.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000205:EE_|CH3PR12MB8481:EE_
X-MS-Office365-Filtering-Correlation-Id: fe388317-fc21-4321-ce31-08dcd7559873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qAt+V+PjLX/qbx+GlCqjHTJjOpMPxAA+uJhbbRd9KhCJDw1OGvFtgA/UxFWk?=
 =?us-ascii?Q?Vh7lWRisyBnvT00CifRWSBG1aXxdiR0aJ9Y/k8zNXl5HgwjUNZYGJQASaLFf?=
 =?us-ascii?Q?NqnfjANXmS/Um5BN/VTcsVyz649F/Tsmp4eepAgc7DxjxHp4MEcjduCgIbPq?=
 =?us-ascii?Q?vkLXiVGMrztPazq1BUTxXH1ecNI9YHak5Gg68dkULuW2x65THbBkRsNOEQzn?=
 =?us-ascii?Q?Ev4RVTC1zq4ilTgam3IGOpT4Ag57QWu+PA3p+Jvdzy+berJ5CW13q7pIhRqu?=
 =?us-ascii?Q?AS6SnfU/XosfJ/DWmnsHRBfoBiuDe/J/HGDCu1b6CRU5jk7VokcRMWCoBG53?=
 =?us-ascii?Q?GJiZ0riUL/If1wz/sztMNtpKQzbQppmls1P2mWRNdRps62wiDC2x6ASO4+iQ?=
 =?us-ascii?Q?RYqIB36vaTU/REJmifcKpNfdUduvuowPU2Oy/0anQJvu39Op7kWm4a8tezcz?=
 =?us-ascii?Q?O/XX/qwtveAxEseRikNolV9O70h6jvBQ3x4yslwcamfiEZ9QXAsSLeGEG/8q?=
 =?us-ascii?Q?GrKtX7A1JjGDYKv7mn3i7ijxVvkWBPofCvCrrTa1XNhv83cxlpXQQspG73KE?=
 =?us-ascii?Q?RVF+WzNSsoHNRmr5eutco6ZOKbg75zRtpgiNFjpGd7zSpLev1prar9vVLpYj?=
 =?us-ascii?Q?ZrXsPzNm3ZdE/F9FfJM7xsUKBawhq4qQa5ExiHouhdGLk5bSLpFoqgMsDUW0?=
 =?us-ascii?Q?KmvA1dFADnYbP3GmRirdppg5DnMJLK3RuHelOiRmZyHBMBzaEc5sYyMQlpGW?=
 =?us-ascii?Q?F2PlE55N06wB1KnaEKCEZTQhSQw7Jklx5aXwceDV+rAcPkXb1qXSXilCUmni?=
 =?us-ascii?Q?3VIUywi+OEfKgnh1wKnxJsBcUj6Y36dprihBTpP3kqI+eiYW8TxYaU377Q//?=
 =?us-ascii?Q?XBIi84ORiSs30mSotTzvX5wdpQ8qtqJvWbeIJBgeAsC0nNOFuWvUhGNlHAaf?=
 =?us-ascii?Q?+BQadSddBgaMsjj76QW2niXm/RPQ1LkilAiQkFcivrCcKmGcOUGdOPiT2xok?=
 =?us-ascii?Q?Sp0i98TTwtcyB9cMzWPbz2jUHK4ic2kuGkrLPdLPgStM9gb5QhncvG0Vu7Xq?=
 =?us-ascii?Q?8aYr0l5T7zmDNIJDpvGF14TpTvKq0MZNie8NCL81rj/42gkuIZn2Na7lDhKx?=
 =?us-ascii?Q?D1M7iUMcE1T7IqatyfTpnHlMxsJQOLPCijNXkpGu6lMFF94/y+Pwn9Tv1u3O?=
 =?us-ascii?Q?EYgX27XYQ/PkTTrfdMvgQe6L6l8GAwDBW9cODGgHfmOEqTuejpp4ywdBI/pw?=
 =?us-ascii?Q?G85L71BIKDneZMU7R7kBRouZ5LmCiRopi+D47xMXpDqd2PpJho1+3HjlPF7J?=
 =?us-ascii?Q?vc5FOovx9438CKr/Ixw1bYvxZqqIDEXfq361N5G3ckrK90UxBBcGwFuutRYH?=
 =?us-ascii?Q?Qs6IGlCfRxMqt5Pyx8mjBykCMm9ZvJjaf2dO3ejXynCMnbXco1Fqaoaptjyy?=
 =?us-ascii?Q?J9F9L0gME43uOEbMYx0nHM7uL+IFwbtQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 20:16:20.7967
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe388317-fc21-4321-ce31-08dcd7559873
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000205.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8481

From: Ashish Kalra <ashish.kalra@amd.com>

Define new bit-field definitions returned by SNP_PLATFORM_STATUS command
such as new capabilities like SNP_FEATURE_INFO command availability,
ciphertext hiding enabled and capability.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/uapi/linux/psp-sev.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 832c15d9155b..dd7298b67b37 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -178,6 +178,10 @@ struct sev_user_data_get_id2 {
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
@@ -193,7 +197,11 @@ struct sev_user_data_snp_status {
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


