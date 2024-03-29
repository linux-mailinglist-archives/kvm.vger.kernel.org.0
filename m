Return-Path: <kvm+bounces-13130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 850E6892791
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F16DE1F26916
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F3E13E6D3;
	Fri, 29 Mar 2024 23:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CiYljdty"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9983813E03C;
	Fri, 29 Mar 2024 23:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753523; cv=fail; b=ir4hSifu5fey34lNG6NQVVdeNpOeFcEieUmPjx+JWXGmM0fLCR2jkDcFWocnQ0Z6UHZpsszZ2KA8JyFaZLzuirGC38oTD91vtzYlUtwO1YYexA37kRiieHAemsCTGZGg/Gr0liS2SQMaXWi3QaN4RPkNJrGquvuCYeSsoSOUonY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753523; c=relaxed/simple;
	bh=t6UieSJ5aHrhTKRlb53VzznFZ/qXUrkgaE7o8gZE/+c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h8gGo4IU5fOxYESYjlWb2admmJFHoqHe36L/ScJFzXvuicCfSIkoZP7l7dGnL3kCDVhC93IFhMiS/GZr9EkEocAP7E8ClmR0dsnq7DqG43Aijf66EXCXkquImRK+gGS+fQBoATTlU4WvXhS1V7gRJZ2INkWuJ5HUwkFWgZUYNec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CiYljdty; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frzmtRSMgBkKrfJWtOOGtMYpWeHXByzvQMnImIaM/Y7Zn2imPqws5JlYj9amuUF7FI5lNiyklssDg+ARrRLBuS8lQIqA7fbe6NeMhLebUIhL9B0KslGoGwkSI8w26HbYXtNH99ifjXXv5HNWbojwJeBChDiY1OiTTPeVm9z0CkCG2F9296ifulu89PAJU6Q4HA3p7MYj7ijD1xJNvf4pVrEl/p6jS2TBFLnBdLg7VcZLRheUe889qDpg9wjBd4oKfsj2IOMDjSBUhxrosv5TkBITL9bt0vlljnX9SNcY0gSk+8Z5xw5HfzhpnzZfWHV4Qer+cYmDLSRjTXMWut1SoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xHhkTg8VzVvhSodYJrNf6IBU64g70xsxalqoGKfNNU=;
 b=D7IP749sueI1loeTEp2KDxvWwsRo1KaWTArhoRats/5kCwSB08YbUFMmM9uulAxh8iaLUUhpa/pniwdbLIYcT7p1OfsIR4/nyn9w61eyC6YyeD1ph0ZxIjN2oeMBoYQzuPGmlsyo8xJlk1vVynWpXobaKAw/QPiIfjP5HqWPvaKMezBEfvK+TbnrGCThTjNISgOH9j1oNwVFgiTIAsWELpWKyqPH8uLWXGDtLT+FrHRXGm0dnEr//8Eex+iA5UUrxsXSdPnGtd69hN6inbsiaeQFh0FyYfjIjUl5UKr6VkobpNu+a5dtDGFxvea5t7H3Os8SDzfb34a1RvuQ6+3OAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xHhkTg8VzVvhSodYJrNf6IBU64g70xsxalqoGKfNNU=;
 b=CiYljdty2T47vksPxtji3WbPU/xydwrQM2lT5uTskQZ1tii/+okgoDkLLcgrK4p0Lsrrpjvg2vJP4VZhHeJF4ETfzd2mdmQNAO9ucswMvvX1T8rF5ZmwXySmiyJHov8Ym/YLqG0SuRVH2JWw9Jecy0MTSCWiJEiXZlEmkU71gno=
Received: from DM6PR02CA0089.namprd02.prod.outlook.com (2603:10b6:5:1f4::30)
 by IA0PR12MB7578.namprd12.prod.outlook.com (2603:10b6:208:43d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 23:05:19 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:1f4:cafe::aa) by DM6PR02CA0089.outlook.office365.com
 (2603:10b6:5:1f4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 23:05:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:05:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:05:18 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 25/29] KVM: SVM: Add module parameter to enable the SEV-SNP
Date: Fri, 29 Mar 2024 17:58:31 -0500
Message-ID: <20240329225835.400662-26-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|IA0PR12MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f21ff6f-1ba8-4cea-c97a-08dc5044b406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TErQZmUWz8PNTqKamo3Yb/KtS5bP5C+DzeoqPvFzYaHaPgGp/+cFm0scDCZxRhB/3DroiSZcjmtpx+l3xjfNxR9fivC8wp0QMnJPparxBfI8JvJLNAhoVHlMXlvaJ9GIAjUIpST1uyFpE2JfH2c0aYE/WyNVnCjUNRVCnxrWd5xsGSMbLETue1UvmW9RwG8L7cRKWCBjpm+uG6FHqfO1inVFVFTIVlkOuoM6GCxblaAQM4xjgi4nphzgT1mmhr679S4kL6r0zfwUNQCE2SU0X2CQJsRmDhwARrW0BoHaWhugAHRT4j+vu2sE34XAVtwlJufMehNZVcCSZCmkMqAxoHpcmi86S+Un0hB7xvehd34avgQnHcB2xyp+WkoWJJgcF1ZKeGZrQFf8yAcBwZtE5qUvSr07P26kKxUjNB3ykesyyjIzLyWrmdYjdOzB3MRhCoNhbrPuaelfzF/qgnEAFtagqxy9dcRN0D7eZO21LwOBUuwMOekFV/I1iaIzA0RlaXcCOa7waSjDkvu/YZxPBmym/Arhs1TUhyL1bYRq5pem/rXvYpIwA0f+YazF/mOyHwQuXyfVnaEtEwDrZpTdM1bryyKx/oG7Nz2T6dzVwVd9FxHBKHQ+gLYbn1Ex/YuRavTBp7ATxNx5eMNywmxbcvTDGjxOMwSiIt6C4EhQGK8qTkBilCN1VDJDxFTI+NsSUCLvqviql9KZNELVgmdvNEq4szxbj4YZjDyWzeHcNLxxgmgkVy6XQ9rY2xZz9p06
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:05:18.7328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f21ff6f-1ba8-4cea-c97a-08dc5044b406
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7578

From: Brijesh Singh <brijesh.singh@amd.com>

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3e8de7cb3c89..658116537f3f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -48,7 +48,8 @@ static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-SNP support */
-static bool sev_snp_enabled;
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
-- 
2.25.1


