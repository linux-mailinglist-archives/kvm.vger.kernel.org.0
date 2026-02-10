Return-Path: <kvm+bounces-70697-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KF/YBMLDimm+NgAAu9opvQ
	(envelope-from <kvm+bounces-70697-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:36:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA2811720B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED59C302AE13
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 05:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E364B257851;
	Tue, 10 Feb 2026 05:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BFRlaZ9f"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010008.outbound.protection.outlook.com [52.101.61.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BB82868B5;
	Tue, 10 Feb 2026 05:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770701733; cv=fail; b=JHkqmr3LS9/aJhYN7er557hgLiJHwXDy0OYKQfCq/+UDB0rzIi/uXXdquQQ1Kh6D1oWYaXidW4TqyggLHlVGOat2G5e185tcSTzWC8rw6K1eyMwr2DetFpwflNtsm+UIsP5za9K5bRXtJUTlY7Vi/78ahR2T+dravdOpIkOQvKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770701733; c=relaxed/simple;
	bh=rUcLkqvYIfAXp2dwZnI+sl0VqvgGQ1kI+BHRbPEQWcI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Oi/828GJMMcGlXG1yiyZZGsHATAfYHX0aMFoxeHL1nBRAmOZRh82QWGsL1clM1WGXj5c31e53OB2vWSGBvOYD0YM+hDt155UMljLDAYs0kl8rg2o99NFxJkb194iagEDr8ODaERg72kyyxayPEcI1mzm0oZeRFP9JtfZAq5zofQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BFRlaZ9f; arc=fail smtp.client-ip=52.101.61.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wbcFRiTkWlel4xaZhEVSvdxzYkGwwmg5vviQeZiiAwH+RP6ANTBXiFBD3jQKpyQvvOn0/MKo+kCB2s3e0z8fEi9Q8rD0kYwPvV0z7Gg1PTMBenCF9wQxg2Y9M6I00Y7BdJ1kD/sl/zn8z4MFr5a+L3yJvf/+4KacCsfjO5mCC2IKD+UUu872ad/LWkB8V0tt5Yj4UH5d01sNVMHo+VLgkvrgaogpwaZb9Uu5UfTeYdBuE1m1ipKZfmwBwid1ASKI4RqtTNwEsEK1iatBw1w4fyqbmj6oELQZrdN2u0MBTraax4FMTBgC0DwXTiZciblNvVrkaYKkmHUnySy8J4xOQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xk52t3MWixDYCFrSQ8r3twbEdcWvJRHU/tVLCdUHDcQ=;
 b=iwXB19bSkFzcls3e+GH9L9HmmoUMjDoUoTaOxwL1cG8w/Y0SO0Il4NvEdxLrsMJEfHf+hv8EH14qymPXZY9AdRQWSvuTqjOhFQhDqYKm9U9eIrVVR4WLdIyOfdKZOh7vBdNeq89gKqIVEakU7IWN5SWR7fcDvc+m1ZnFJkP6wk6x2uvaM/U9EO96Cal2bH/7VEHqbpZJCSdVnEfjcj+VR8sRDxwK8/hUKPr/8oVXuqosJp6PhP0jC7Q4yiqnypti+NieOGgFHaBRCGPeXuF9y2yQF6DuyQnwCE6ja/B5Jk4tVs1rIUlXAbjqyxcc77baLZcKYB+H3bx5X5ewVgHfIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xk52t3MWixDYCFrSQ8r3twbEdcWvJRHU/tVLCdUHDcQ=;
 b=BFRlaZ9fvzGUTpbcRPYLPW0hT4M/xLhBms8UVg2wl8vl0csm26dClbyu4GWeBn40nNZf+OCXW61ZYzLuJ9ZTBq1Oym5TOy3+4H8DEr45TIkfHuTKOg1FHlsIiuXqGRXHXRZhgnz9APOx5PSNZnn63LQLWZXz25tqxlFN3aGCyWo=
Received: from SN7PR04CA0033.namprd04.prod.outlook.com (2603:10b6:806:120::8)
 by IA0PR12MB9047.namprd12.prod.outlook.com (2603:10b6:208:402::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 05:35:28 +0000
Received: from SA2PEPF00003F63.namprd04.prod.outlook.com
 (2603:10b6:806:120:cafe::59) by SN7PR04CA0033.outlook.office365.com
 (2603:10b6:806:120::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Tue,
 10 Feb 2026 05:35:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF00003F63.mail.protection.outlook.com (10.167.248.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Tue, 10 Feb 2026 05:35:28 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Feb
 2026 23:35:24 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <bp@alien8.de>
CC: <x86@kernel.org>, <babu.moger@amd.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>,
	<nikunj@amd.com>
Subject: [PATCH v2] KVM: x86: Advertise AVX512 Bit Matrix Multiply (BMM) to userspace
Date: Tue, 10 Feb 2026 05:35:11 +0000
Message-ID: <20260210053511.1612505-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb08.amd.com
 (10.181.42.217)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F63:EE_|IA0PR12MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: 61267278-1c5c-458f-ebe6-08de68663305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zGu3GtGgHuubR0iPSh4J1Iy/EtF4S2yQQkX2QftHntdNzTZFyd/DxvFW5wyP?=
 =?us-ascii?Q?RWXvI2tUdb6+SU+0WYzpLqILii5hphKcRrRzNp1A1tBC1ZlxDeL7iq+/PGZJ?=
 =?us-ascii?Q?eVXn1ikXcU9ZeJDLpH8PFJ+1F50WsZkuqXB4FgTwtL48iJ/nhldptom5phZ/?=
 =?us-ascii?Q?enq7uErN1FpZ1/0f2C/E5OKj+xh41JxC8kZFkL8LoeFWm8cBFL4dlSt0ML8f?=
 =?us-ascii?Q?dzRwEQUqdrfh9992B1tnoA7P9yNx7SL2HOvZEg2TGsseZJOgKS/0Tc/BN6fF?=
 =?us-ascii?Q?c3xi9Kf4YhzHHLm3pgccJMoZBhL6+Mv/akWVKf0ibw4FwVmLxrscRgHqVvo4?=
 =?us-ascii?Q?qQfmIy1xIvndicDdfo3dmxa1TQrTcefN58qo/0NLMTETPpOMEWb1Xi+5Qkof?=
 =?us-ascii?Q?2tVseoSbyjOQnxw7nO+mI05Mt1GRakStos50HkiHciSCqGKtrvXgVLl1x6J3?=
 =?us-ascii?Q?r3RzAswM1q8wGDaFXOR07x6bzpEss3zZfj7T9ZVq+ud2tG0/lqo04tVIygk8?=
 =?us-ascii?Q?3xN6mXMTATYS3+hBmLp2yt+i+iKv7oQ8aZErow/OcYz9S444nPEX2stxZU7P?=
 =?us-ascii?Q?eybShqitwYsaDNO+IR1t+XVC44Fhp2I7HYsAlEfW6vAvYxm6CWAIY8cMv+Dl?=
 =?us-ascii?Q?/VIuxeNHBnZlL+yhbtoMfGgBZwyTnB04hEkxScackl1zcHIKzthDDlbHPJDw?=
 =?us-ascii?Q?nnk0i2JNwZN3+yQjK1hJtp5Z3o9+QVltympXn8x/Z1/vqLRpB2O/NtnSBTfV?=
 =?us-ascii?Q?hBEt/VBcsxZDz9RVr0fToWmsuqvHMegkcIWahcBnbrVJOTv5ej/jho1RNlhW?=
 =?us-ascii?Q?/fR8s/2lPdsrUhUhP7ctoGhyy9QHBr3t6MeaQvmGjRosilDLwTXP5udo+r1k?=
 =?us-ascii?Q?rrT/U1Ycz5I5Ctac6TTnr5TerH3uZvU0lTtvhEAOIA5o/4HBAZK0FA5QDi1B?=
 =?us-ascii?Q?kamq/66IM0oBzEEHtV5XvLIYnWr3U3T5e31CXoM9f83bsBx+g/L9Jj6BF3D5?=
 =?us-ascii?Q?PEAqEJDNYzmhbiaAydq9kXxvYQnFIwNzu1KiahmWZt8dA4EyomeAk6HCBsUN?=
 =?us-ascii?Q?3j8+XswwcJNp7UKmp4tZ7/RgVpMPITJKJYxzna8qDRur22QhsNiEbwn253Hx?=
 =?us-ascii?Q?q4sCBZSbjAh1z/QA8VzL4SXZ87zOJyyXx8rg7+KS4o3U84AMPMErrc74DbKV?=
 =?us-ascii?Q?XVVmPavOarg7rq3ai/bwO6e8fXwYcjWfROHh5VIXnqVvTnbJRd8B4ZJtuc/h?=
 =?us-ascii?Q?2Wzo1az4jVdCQrQChNf8wPLmrGjiw/NdImRjyK9Iaqa8yJwQTCxKIlWc4meV?=
 =?us-ascii?Q?mQ7K7NkGG+RRiP/wg7pq2I8Oz/catEzoWZSF7oGwEsnbF1uBIzvcuB1wscAV?=
 =?us-ascii?Q?1N3s/J1Fdc3nop+GOj/+1RFeSrW7CNBhT8fBDyML6voI0WiWwyDmPMI4+jVY?=
 =?us-ascii?Q?1Rj0mNccaVlNiWefOAWqrMGj5IsZ6sr/11Kofuo4q9zdVNQ4/UHcsfOVy3zb?=
 =?us-ascii?Q?tUkGg2V2b46M3ga3X6l+rdunvOtp1ISJn8hlv7xCsBhrfcbdYzIM9kHfcgNz?=
 =?us-ascii?Q?/iMzNVan1fk83BZDEdo1uVHfffdca0tr5dF/NHulAskDkJw/V2wDJFZuN61w?=
 =?us-ascii?Q?AhqpNQGeVNi5AlkU8gyDiusOZYYbcHjmx413V1FwrFUMNiiWAznN9A/9UAF4?=
 =?us-ascii?Q?Uz5eHA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7Xp+hh5k7LdVZ+/LBROuN9v2mY/tpSlto61eW4dsWeWYVG2hDI8HnHRz0dNiovyCzaa0cVDvi9RC53o/mmFqJH1IV8n5mgRoBoaeY1WnHdEDhCIX9ijD80GHQKJwqgsitg8aojlVePMKLN/DzP7qHqFfWI2eAYuVGRHZuK4IlG873mIEdbKkhiE5I6+zMhlGxS6+Bvyk2xbsio7SBiq37PycqNG6LA6AVHf/HyGnup3iHxK4OaT7jwbR19xFCHYajfOCB44OVsTIjVgANXhkZ8kf/9LHpA8j3/xAN0vS6xdXWBtY/7L0ahCVIrqxvZETeKhFVIR+Q1OYN7qZAVRQV3B/jKiByHXVQUbU0UghStE3w6TdueORJoXxdjsS4QGDc4kNPeq6OPEde3SBQlFnqM70VVvq5mwSaRsWGj69DD0a5IIIcIKNnsxCfywL70CD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 05:35:28.4540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61267278-1c5c-458f-ebe6-08de68663305
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9047
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	TAGGED_FROM(0.00)[bounces-70697-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:url,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9EA2811720B
X-Rspamd-Action: no action

Advertise AVX512 Bit Matrix Multiply (BMM) and Bit Reversal instructions to
userspace via CPUID leaf 0x80000021_EAX[23]. This feature enables bit
matrix multiply operations and bit reversal.

While at it, reorder PREFETCHI to match the bit position order in CPUID
leaf 0x80000021_EAX for better organization.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---

AMD64 Bit Matrix Multiply and Bit Reversal Instructions
Publication #69192 Revision: 1.00
Issue Date: January 2026

https://docs.amd.com/v/u/en-US/69192-PUB
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c3b53beb1300..2f1583c4bdc0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -472,6 +472,7 @@
 #define X86_FEATURE_GP_ON_USER_CPUID	(20*32+17) /* User CPUID faulting */
 
 #define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction to Cache Level */
+#define X86_FEATURE_AVX512_BMM		(20*32+23) /* AVX512 Bit Matrix Multiply instructions */
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88a5426674a1..b36e8f10f509 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1218,11 +1218,12 @@ void kvm_set_cpu_caps(void)
 		F(NULL_SEL_CLR_BASE),
 		/* UpperAddressIgnore */
 		F(AUTOIBRS),
-		F(PREFETCHI),
 		EMULATED_F(NO_SMM_CTL_MSR),
 		/* PrefetchCtlMsr */
 		/* GpOnUserCpuid */
 		/* EPSF */
+		F(PREFETCHI),
+		F(AVX512_BMM),
 		SYNTHESIZED_F(SBPB),
 		SYNTHESIZED_F(IBPB_BRTYPE),
 		SYNTHESIZED_F(SRSO_NO),

base-commit: 0de4a0eec25b9171f2a2abb1a820e125e6797770
-- 
2.48.1


