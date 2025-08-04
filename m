Return-Path: <kvm+bounces-53892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF13DB19FCA
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CEB81896605
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E268E250BF2;
	Mon,  4 Aug 2025 10:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oxgHohTB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B497242927
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754303908; cv=fail; b=iTGjPxGGMMwP86VRH84fAL4z2+WYDw0uqTFVnw1WTSF01mev7f4J7ZEBtvmYzvTUVREtHHvfaWIjgEsARcOQWkzm0KYB7SG0VDxe9eikv8FulAmtlyWVuk5bSLkvCTDOQWpWQ4g1cYecHzSK4TXFkXet27vqxjXdGDju5dhDOEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754303908; c=relaxed/simple;
	bh=Q9FitB5hKRU1LBUj0K5sjZ1rNzfXLZPKMRWOeNue+gU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FR3a+ByeiaZGKhc54RS3q6ObUeFtC7BHE8eroZFvIw71G0KGMfHz4IxNYYPKuNeASyAgECENyy57+bbNrjl63nRHcbarHY0EZTjfHd4UAD2Qr2JW0rV8MqBOZZjixW0ATYF31z9gyIc10TnSFHJxzASNGID2sXSu5bW3G1ej2oE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oxgHohTB; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b8AwB+tib+NVTTCElsTub5V0RV5CMBT26HrRFpQBf7lZPjgXWxW5n2GfujU38D2LbUYbcSC/M5v5z3AKv2GZIh+v82n+79cpdJ+ST93DO8qhRTWshoPnq6Y5AjFKxfXzGvizXTWrvZ8oc7miVCUNxUYRlSg+MxExeEfv5B7rIVhL3a79PY0wH+Xu2JUCYuq5MhuD1z5/eD64PcXcOoY3Wkts29iBCgStYQWSiH+NqFIa5cl2Ssgg4CZDKiMQgsb0Pr1ozwsBSDaoVq5Iw/Db20NGK0ENHJ9NIt1S6IRD9axPEC5F1+uQ4Xh2ln+xL6BmLSej04LRPx+FJ26Opof32w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TxkNEoxjg2svLmgx0ffRDRB7iyYRjCjNyYk+5zSH6U=;
 b=Upyy6AMlx5uZ5fWyULCuc9pimFShuRe21OTSh0PWIlMYwCwm9kjnzodNBor9P0tJOsXkc6bf7ZLuKTKAW0EOB1XLuA4g2GuTJEZcRWy5MS/ddv3rKMsKevJM4UunXOyNT1YxGES2wpiF4eHhL8K962MvaOfedp9dupj7tgt6/zypOPLg4UQ8TH7vH+cgmbUJxaxR5mYZnROFKd1PaLMsmhLCwdNKSSuIKp6Fwsi6ZFHnVbUDG0J1xQP9wWAQqWMWgE+kgwTxXfNcuKkeNWspHWlRQMPplScjaKKh/k4iOIue5CtDp6RYFFKjzKWKSda4RjKxaEb6J8FZ0xPMx6HKRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TxkNEoxjg2svLmgx0ffRDRB7iyYRjCjNyYk+5zSH6U=;
 b=oxgHohTBtS6ToG7It+Mko8x8Nr7KLLU9nuhFMqH4EHbFAywgmXcsBNPiTealQrgqUFB3N0FGiWxGZXGxypif2tyxFh/KtlJjuejscnkZNtP2BPhse9fITmjsNFxA+zd7mWebgFzAccQ7b51H4Rjl432K6xWMDlLLT17roqXuhBQ=
Received: from BN8PR12CA0006.namprd12.prod.outlook.com (2603:10b6:408:60::19)
 by SJ2PR12MB8783.namprd12.prod.outlook.com (2603:10b6:a03:4d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Mon, 4 Aug
 2025 10:38:23 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:408:60:cafe::67) by BN8PR12CA0006.outlook.office365.com
 (2603:10b6:408:60::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.20 via Frontend Transport; Mon,
 4 Aug 2025 10:38:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Mon, 4 Aug 2025 10:38:22 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 4 Aug
 2025 05:38:19 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
Subject: [PATCH v10 1/2] x86/cpufeatures: Add SNP Secure TSC
Date: Mon, 4 Aug 2025 16:07:50 +0530
Message-ID: <20250804103751.7760-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250804103751.7760-1-nikunj@amd.com>
References: <20250804103751.7760-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|SJ2PR12MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a35149-873d-49dc-f916-08ddd34308f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L5wwwfzXIuCx0Ls7Ff9i3fcsaSmCLiT5WZ0sYUMo39O+R94RFTy2oPi02nXv?=
 =?us-ascii?Q?k1eLfMkcJsC5j3s3l0IZLv/XmLD8lDCCrAzo/KcifZwii2XxOniOhrbQdIFe?=
 =?us-ascii?Q?LmizBfC6Nqa4ZRnMsrTCv1srw+HzPSYeHuLHfBN6BidM6EUkTVVSxJJRWMzY?=
 =?us-ascii?Q?s86d40UPye4Ewu44zANw/ni79c7EfrQQPlXZBrCGcvvFqm2LCj5Kl2qUTQgn?=
 =?us-ascii?Q?q4LkeV4xJ16xCf+Fruc53Jb2Iq6zJWWxgzq5CJNMLQD7/mAC6Fr/AUIaemNw?=
 =?us-ascii?Q?2RuxzJVonh2L0SUeOglaWbe1GYOFL4xqciWPPk2lKjfPVWwUOHm6Xr3pFxjf?=
 =?us-ascii?Q?shnyet++ut5mcbagCxppikkCLWOZTpaDRhRWS4Rzz7Yiqw+qCgIkqhvxz09x?=
 =?us-ascii?Q?BbBmePHbLBnIKZ0xT+ciS5MDGFAWdFtjAzJUHY+PpqrNzFDU7rCHEbnbcJXQ?=
 =?us-ascii?Q?7/Lg7qqJj9+Sg4KWBvWygp1bSMP3MRp+jOwJ59rF2UKSslGxa/qvY549f335?=
 =?us-ascii?Q?mo1VcjnmI//QVP0tZ8J+upedj01VYNU7ilttuEHLSF2HVXF34O8fHWQqrVA6?=
 =?us-ascii?Q?bwFnFLpxuTLscLuHuOEDReLjL7MPWTZqeexnJVUCGYQHxvkTPvuC2lIWWAz6?=
 =?us-ascii?Q?M6giwSLSmXSI4LVnKMeZULbxbjwhWcZbzD1nlcXguOEGrvxJqCJ8aokmmbHo?=
 =?us-ascii?Q?Ys9FExd7LWqlBhcJE1hwg/XAWnHu54AHe/ymSk5xUhyB8+vPuXPjFy+s7fK8?=
 =?us-ascii?Q?WVZ3gObT+WJmpIdecY+GMjOJ0CKFZwcGfBzjxfEuwlTzOavcenqG1Nm6zjiM?=
 =?us-ascii?Q?tuOIWgqP1bWbKdEWqcPqkAFNOYbKpXLBQ/ZYd8n824WuFhvNAPkA+wdra0Ec?=
 =?us-ascii?Q?Y3EoSKnTpPDtrql5GH5f2JI4axwR5XzkCnQDEvfyj6ilgjH89uRNsa9Pnzh6?=
 =?us-ascii?Q?/OXSob1dHbExi8I9gkrvPCgPbcdjbigknhXl+qI7enxh2XwMGkq6BQGkgqtW?=
 =?us-ascii?Q?/QVzMbmapaItcazWM0tw+xSKcOiJpzlgzQqLnBmBc87KeD4K53n6FIFyRKeh?=
 =?us-ascii?Q?G/B7WuhlOYfTT/CLeK6xXvlBTZeGX2iW0fOMkLbpYI7bNgyDBDW5S4BXIFGr?=
 =?us-ascii?Q?9NPogdZxBjiUBbWiXrB1r/8MMwz/45P/lZa2GxuAqbrcqy7n5A9GgPvFEp33?=
 =?us-ascii?Q?xp1FXnanraC1Ooso1a750vbyd6fKIoht3DGiTMxMWE5k1ua/9V4w8uoy5WbQ?=
 =?us-ascii?Q?UDXjLdTXHwzbqUS5fdF84dC2hrB2DvCvs0uIVyVcCBeZQf49E3nelRtccm5l?=
 =?us-ascii?Q?5411HA5hOeG32jW4kQlsqAq3Iuuz47ZMdlX/+7czPJmiBmtgNAg6PXcTOfF8?=
 =?us-ascii?Q?GidwcSCxwy0Zx6B7NCmHQ4IDptyywH40BQ1OvcaxeL/xsAIM4OThL7MtJhP1?=
 =?us-ascii?Q?4i1SlkzdG1hSZheGojQcmrYVJGOAtJANKAIFz5/L0XL56ZVTAqKYW86I4RH5?=
 =?us-ascii?Q?6LZCVh713yTCkduN0KkhTUYiJGZZ5lPKwtj0?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 10:38:22.2915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a35149-873d-49dc-f916-08ddd34308f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8783

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. For more details,
refer to the AMD64 APM Vol 2, Section "Secure TSC".

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 286d509f9363..28dd83afb09b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -443,6 +443,7 @@
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
+#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
-- 
2.43.0


