Return-Path: <kvm+bounces-60845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 641DFBFDA10
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 19:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D6B91A07FEB
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBC02D97B8;
	Wed, 22 Oct 2025 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wjhVwD7F"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013017.outbound.protection.outlook.com [40.93.196.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96A32D73B1;
	Wed, 22 Oct 2025 17:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154716; cv=fail; b=NBnYwTWHebOPprsMhCTyv/hdIeHBAfB6DKrYA+iOk/CHl6gR9jwyRxGq2zDkBwjtyel9qeWgt/eOTjs/3Ity12urIovEJBwfqmuCsalxkhKCatetEZ0/zMIfN0GPxnraPrptKENKflAeIjsKQGdapQ7DY75VIvQ/Ew6kDncjNUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154716; c=relaxed/simple;
	bh=2S/3hIS3mWxG7KWWoLghWB+oB0Yw/n8TecyS04LzMkI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKJYC2juPLd4lQc5S0Lwgdw6dhiXuZJYYG4OtGirdENX3K1ijQeXhL62l3NDVQjBY6jIvy8C0tkRVtoUavSV1AjBO2wveT1U0gI/DOYFc8aR53xTUJqrAAPTWKOkqaNNBad19j/kUJcqQ7v/G1TruVWO/Co9+rO+IpMMz7QAGVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wjhVwD7F; arc=fail smtp.client-ip=40.93.196.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qqu7Y1OqP2KnpX21vWInMEez2ssKATbrNx/1GBL3FZ1qdVpVejrTzQHiCKB5axw8EUce2AjjzhGPe5sqUVXmliO/p06IpzVxIScmFgwPLD686M2Xu5Y6aBSJ6drIFW5sqQMHGjnOyIAA3xRhhOXWkeToIBIbshZMHpaW+J7xVnZJ1+xVKLkXV6ya9/FVE6b11nmrp0hsszI2XlIi0R90VTUULuNJQ7UatzXnmADvlDWFLtZY3lxP//wyzv/9sMKwseX7nKdRBRX8GHrgotFdGxTOXGlwxER2+4D6bot6isjxO6WpZBoglS2jKphX+eqY5G0kKgp08EUocIpcqNiZNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzWx4c/xpRWt+W8cD5JFXtsltygRSfej9WV13jqYI6Y=;
 b=f/m9LnhPX0O7uTSInXr7M+Ps8mMEmQCo/26Y6EYefSKFxwKvab+UntjKgkAoY6Gpl6/9Jit9bVmdwAWKXC4MJxvuUVOyaKExxReUTBhIjE2xvY0/LSsufwXLUkWahwU5ogdsLiuA5TVm6fVn/8jS89V/ROfuSTzfhpbM+YdCygzcTrQ4c8c8+Zk3CCLlpdYKbRRaoORwb89ZCAR9Z31bgW6EdpG9Y/7y6YqRuyaZrMkky3skOWa7csnqVw+cJsRZZEpV4mP+bh3nMm8j0WqFdWOg2kEqBjgH2tlAZTEsRhn1jvhKUfJ7ybHbIY1sN9AWH4Ex6LytKBJH9qLtVHAxgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzWx4c/xpRWt+W8cD5JFXtsltygRSfej9WV13jqYI6Y=;
 b=wjhVwD7F5LZM+0S5qLv4nO7LIjSi6gNU8wI8hFF3dhUhXKRgYGbKGbCWQ5zgr6hjUEihwOCAYbW5un7JcVSMffoS8cBTRatvbmbnWSsMfSZsp8n4JGf9NbSTO/aoVbJrGlO9eKAykFJ7YzWT8ASixwvydPe/igVJyKOvjVeVWR8=
Received: from SJ0PR03CA0131.namprd03.prod.outlook.com (2603:10b6:a03:33c::16)
 by IA0PR12MB7700.namprd12.prod.outlook.com (2603:10b6:208:430::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 17:38:29 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:a03:33c:cafe::53) by SJ0PR03CA0131.outlook.office365.com
 (2603:10b6:a03:33c::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.17 via Frontend Transport; Wed,
 22 Oct 2025 17:38:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Wed, 22 Oct 2025 17:38:28 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 22 Oct
 2025 10:38:27 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v3 4/4] KVM: SEV: Add known supported SEV-SNP policy bits
Date: Wed, 22 Oct 2025 12:37:24 -0500
Message-ID: <93045a3b8941e5b58f03a4d27945b523f5a9b8a2.1761154644.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1761154644.git.thomas.lendacky@amd.com>
References: <cover.1761154644.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|IA0PR12MB7700:EE_
X-MS-Office365-Filtering-Correlation-Id: b95e657e-d07b-4591-0272-08de1191d001
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iDqkAU7HAY6Ebkz8i3p/ADHroEMZNJBZr0p2qkF1jlLEty9yLYvyhQNHhu+F?=
 =?us-ascii?Q?KaJPJx1qwEHDejTNszwTkw0CDz/+5WmMwF6d8PaK59QMJEFPbdY55kVyQz05?=
 =?us-ascii?Q?x7+P6GPWXKQzdz4+sirjWSi8qMCTjZnDFSRxSmp897c8n6h4rVhF9WD4yBdx?=
 =?us-ascii?Q?Vsc4sEIoyTci8DWDLlK0D2MOTqv4j+d5efJdfN2Pelgu/5moGV8apxPUYNCz?=
 =?us-ascii?Q?u5clpxWaqEgIfSuFbK4FH+vsHDI1DOBub9PT9QRNI6pq85C9Lbf8lGQ5R/95?=
 =?us-ascii?Q?1DtI5EslKKvowBd/DAtCTkKTXxDCmUpwNKQM1moec4OpSmfFYn6PGl+nk7Xm?=
 =?us-ascii?Q?t8akUnFgYCUEM5xQZybOB2XcU3HssdCURFFM7Vi+1EfwBC0hADlPAjlT6x6M?=
 =?us-ascii?Q?hszIkm+Cu7f2ILL+gPf1+XzD0wXmEcVM3J5lBfvYcTvwqNy3/gmT8d9Iz6vT?=
 =?us-ascii?Q?nhHMN0P23Sfp9RERfHFR4eZ6w3XvmEGafBVUKJaaH46f5S5kvUb3DNorINOI?=
 =?us-ascii?Q?JFVEzR7Gea3M6PSAzQkkYRgLTywsHjAH+WVE7tWP22FwNbtG971j8meNnFZ9?=
 =?us-ascii?Q?zfOQygWi3egbfC+fdvKvMyaSDlaWvOCCnIhx1KBKv7rdR7O0/u00YIdaJQip?=
 =?us-ascii?Q?WXymFhDHCYUmwBDRJ+nEa5Dqrlkte6shE0UvFdAiVjLfd3e+NEirxHq+iDNg?=
 =?us-ascii?Q?1TdO3Iwj/ZcfophyKgE8WXYmRQ+rMdqHbmPSooIPu4Vust57cw1/HNA5h0qU?=
 =?us-ascii?Q?PlICruNr1eRTGqXhHK5M3a0AXBVptH64g94fE8I7jLtUSK9LN5Yd/EH4iUwL?=
 =?us-ascii?Q?pmSTJr6GLDRw9wWA4yMHCL/BergRrW9uWRBN11BoKq3XoaOre59TaQVsbfMr?=
 =?us-ascii?Q?oMl0EP8yCqEkfa3BtqTa0zhXNm31mKemF+AwlSkGpkFb56oBIcIBP5Xy4OGo?=
 =?us-ascii?Q?poUfWHJKIJZvwvbzGhzumuNjjaoJeZ/ARYUMNsxuaW0mHTSrbXG5bfJUHojT?=
 =?us-ascii?Q?XcdMqXJVBdY7DdneFsjtYVNhCSE74nRduZ833ak6wsQRsrH0RXKcMW6UawqI?=
 =?us-ascii?Q?yFJ/EcnGf1176j76wHYGXdDVD72H2W6flz+2mSh7qf5IZSeyhtASWTfg7psS?=
 =?us-ascii?Q?yQZt1iK82ZxdGxivwZbRBbvHLZrtvCRx3cZfpT5+1KSA7cao0iCfPY/GXYh2?=
 =?us-ascii?Q?dNYuhSR2N5oSlRcDXqn3Ywd0RG8KPPoFCIXGm5ebcR9lgG2hOxDBCQX5beqn?=
 =?us-ascii?Q?TYpU3SYgfOm7kbNZFedHjuiqU0AewNSpa1TZuIcvMOa37D1xNjje+KCBMZX8?=
 =?us-ascii?Q?jpbswKKDsUnBpQN/mSd/Zb+qsIXyyREXoxjjo5ZddSx8j3Plw/ZmZelpwSiv?=
 =?us-ascii?Q?tXNhvZZMhSNWB8lDVdwfMcwZP9plHvpdYHBummk8sFVxFPx4s7hJwO/Io5Bl?=
 =?us-ascii?Q?2rb8fgq18deQD1ybvk8S86bMQBy+n3plRejS5ilHTICOHdyrjJbGtoKR3+rw?=
 =?us-ascii?Q?0NVHvsJWBI0gowrYjcMU3ylEbv7o/EpazfTO08xOqKYqksjBYvUoyxxkQ/fy?=
 =?us-ascii?Q?zB6HqgIaS8aw9SpKU6M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 17:38:28.9491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b95e657e-d07b-4591-0272-08de1191d001
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7700

Add to the known supported SEV-SNP policy bits that don't require any
implementation support from KVM in order to successfully use them.

At this time, this includes:
  - CXL_ALLOW
  - MEM_AES_256_XTS
  - RAPL_DIS
  - CIPHERTEXT_HIDING_DRAM
  - PAGE_SWAP_DISABLE

Arguably, RAPL_DIS and CIPHERTEXT_HIDING_DRAM require KVM and the CCP
driver to enable these features in order for the setting of the policy
bits to be successfully handled. But, a guest owner may not wish their
guest to run on a system that doesn't provide support for those features,
so allowing the specification of these bits accomplishes that. Whether
or not the bit is supported by SEV firmware, a system that doesn't support
these features will either fail during the KVM validation of supported
policy bits before issuing the LAUNCH_START or fail during the
LAUNCH_START.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 24167178bf05..83beddc52715 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -65,12 +65,22 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
-#define KVM_SNP_POLICY_MASK_VALID	(SNP_POLICY_MASK_API_MINOR	| \
-					 SNP_POLICY_MASK_API_MAJOR	| \
-					 SNP_POLICY_MASK_SMT		| \
-					 SNP_POLICY_MASK_RSVD_MBO	| \
-					 SNP_POLICY_MASK_DEBUG		| \
-					 SNP_POLICY_MASK_SINGLE_SOCKET)
+/*
+ * SEV-SNP policy bits that can be supported by KVM. These include policy bits
+ * that have implementation support within KVM or policy bits that do not rely
+ * on any implementation support within KVM.
+ */
+#define KVM_SNP_POLICY_MASK_VALID	(SNP_POLICY_MASK_API_MINOR		| \
+					 SNP_POLICY_MASK_API_MAJOR		| \
+					 SNP_POLICY_MASK_SMT			| \
+					 SNP_POLICY_MASK_RSVD_MBO		| \
+					 SNP_POLICY_MASK_DEBUG			| \
+					 SNP_POLICY_MASK_SINGLE_SOCKET		| \
+					 SNP_POLICY_MASK_CXL_ALLOW		| \
+					 SNP_POLICY_MASK_MEM_AES_256_XTS	| \
+					 SNP_POLICY_MASK_RAPL_DIS		| \
+					 SNP_POLICY_MASK_CIPHERTEXT_HIDING_DRAM	| \
+					 SNP_POLICY_MASK_PAGE_SWAP_DISABLE)
 
 static u64 snp_supported_policy_bits __ro_after_init;
 
-- 
2.51.1


