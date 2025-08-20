Return-Path: <kvm+bounces-55137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D9DB2DFF9
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4CFB7AF44A
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 14:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E746D3218A7;
	Wed, 20 Aug 2025 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UsQ7Xi37"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEFC320CC7;
	Wed, 20 Aug 2025 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701493; cv=fail; b=YJt5ZrI58NmU7B+dvwlmljh6nMAcDQpAfjhBJKJGTtweBV/KdCyjmRsas/ORgZ5dX8gikbrwAPG5KY0gL76dXzWniPYHhuibSLYSQmN0dKqcugNjDBnX+ta/nsq1gbadFVGS/QLfSWkFyI2QtZvRUbbureJRPzX0jMCCH/dfhkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701493; c=relaxed/simple;
	bh=2TG4laFLeE8q2Y5lZzuk/3A07v+bnm+uiewKElqR5QM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FB6EPRqKKORSdt8yxmWPzoXW3g4z75INp/fK9x1AYZDQDUG9cGs01Dco9dEeHJByEl/gJLGE9Z81grG1hQenTVRZfL6zGbNpe/nrWfqTEsqGHmn9RLuD9it49NivB8KDo5Nt5lOuCtO4GV9BJfJdVgfvSjNYb7u4TJUCa0O49F4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UsQ7Xi37; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YKEDgXnxXTeLYj4qoGaWQ1XuG6ClvTz7ZnamzJQMXq0qBxpye+NPfaQScVCQyS1aN/tWLYGn0TfdHDJsMkSTijmMtVdXtg1u/6T8WnAGBTQj+0YAv0S08+IbXXb0IX1OATwpJPKFz/qHUrsiHlfK/I3VpmfziDNgJbKTXtCiQ2ATA7qRxXdctzfl8dZX8rMnf4rVnah3NOnOXM5YCNCwbxPR24oUj+LzgLlCEImf1RmkKm82Irfs5leiVO6eanzm9fBhKKBbl2wopwkLydu83X9jXb6xU03AImOKl4DNIjE1nz3hxoZ7ZMLpqDg/kOogWeTp9fq+f6++TGa7m7DRXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuSCBcTITYY8GUukGA0zSCGqL/Ce1seF63WHIuiHQpw=;
 b=QGdjCQbNr995Pv7o9IeBAGKut+Sjo7qe6mccEsjaIPI/KH6P0lNKLA2Df3UsUad4kVDR0M212lKeE/ere5vQT+cfCZsjDzDWJCQktA/h9qiC5v22bDYHJdNhPuhwWSVvceobB3Kk3X9ccfwW/QXY8iYTMjQRInXRkA0wh3/gTDZrhneSlP9pAgxH86Wjdo6uwFQaECo06mtUPs0kIHoSr2jqYR5KcG5uYSqWysrVAjPzUUCQiW8iY7SJ9H4pGysQoIPR66zkI2DkdAJOiQxdY2MKBxKq41gu2qy4k7xjy0+2OxQ3iqTlNfEGoDYSFo8/Mc6XwfVrCvFIBenXKQG6ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuSCBcTITYY8GUukGA0zSCGqL/Ce1seF63WHIuiHQpw=;
 b=UsQ7Xi3708tPq9xKoQO5FQMTYuUeCwzXbnhGvYag2H5P7EcZR6ZslcR5SUv4YkW+veFgPGkn6raT+7gKuvjip7lw+T6NgwQU5IacVj2DLmuas9C/+ws9K8ZnZMySOAs2owMoL0fGW+JYf9Ny70sCU7WQfu/W10r3dsVbVdTEGns=
Received: from BYAPR01CA0060.prod.exchangelabs.com (2603:10b6:a03:94::37) by
 DS0PR12MB7849.namprd12.prod.outlook.com (2603:10b6:8:141::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Wed, 20 Aug 2025 14:51:25 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:a03:94:cafe::93) by BYAPR01CA0060.outlook.office365.com
 (2603:10b6:a03:94::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 14:51:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 14:51:25 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 09:51:23 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <herbert@gondor.apana.org>
CC: <akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>,
	<michael.roth@amd.com>, <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v8 1/2] KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
Date: Wed, 20 Aug 2025 14:51:13 +0000
Message-ID: <1db48277e8e96a633d734786ea69bf830f014857.1755700627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755700627.git.ashish.kalra@amd.com>
References: <cover.1755700627.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|DS0PR12MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: 53b74d2f-f609-4431-229b-08dddff90942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SO+FozLKs0cSQ3oyTjYzcdFHjb9Rx/LYHAtsRFC4kUKToBfG6ALbuj75qqpT?=
 =?us-ascii?Q?33AM27sgiizYcgSKtFy45gSmDYV5VxYyDWk+sfrkPy3G/JJ9iZptF97U1vM8?=
 =?us-ascii?Q?vyN3o3uKTeirtzF//HyWDp08QL0VGTDSaLBB2kEj/ePk7KVGY70lXbuHnWkI?=
 =?us-ascii?Q?ADRC00Mh9cp5iOgR3zGfDFqaz8ci/lCPV5T8F0K4uUjH/2NG/TJSqItVgNmB?=
 =?us-ascii?Q?1uQB2yWepihoNAu66UT/pK3L+E/eMhg5Z1o9X6xhD9Wi4bqAw9keLhzYk4os?=
 =?us-ascii?Q?krhHtWggoJMCrKdheAHApZHQsIecZT8r20U9Zvi0kuFJUs6ggaNxMu5KTrPV?=
 =?us-ascii?Q?5x4wuelk8+xwQSh9SgpXkbwzkOkmPfWAssv635qZmzyjghzgUPsR7D4rCs6H?=
 =?us-ascii?Q?3Ywhot7bQCfTKUu0NaLFZUGSQGBn5Fg7MhBf6Ukl5tsBuyBX4IbSwx6GlEon?=
 =?us-ascii?Q?GCcjauYSE2S9tlYOKK40A24Zvarpld8MMbKvJi/of9AzRLll84MLxZzvtnLN?=
 =?us-ascii?Q?pOxH8BROfJYRBuoHMh/MDi/P2+Jk2X9SSRq5YSEXVq8/pStzA03TqNBHlaB4?=
 =?us-ascii?Q?CfYxtB+BSljOl95dVvfXBJN830KeG4Db+4iB4G04ayQvVhCePR4IYKTRGz7x?=
 =?us-ascii?Q?eXhVoHHhJRSI10+59r+OE8aN413sFkhf3bY+LGH58rxA1c8GwiKJTsstOS57?=
 =?us-ascii?Q?VK/d0m3E9U7jAQRpR73bgmoqyzQUVrot8ceEBLQ5PXs2W3OUYGTm5Q2OMPZZ?=
 =?us-ascii?Q?SUv6ElxD99YnC9NSglvhOg4eG5/K2Jxh4OKtSpmVXc0TMgGWU1cCl8rp//V2?=
 =?us-ascii?Q?zpEnRAKbZBg4AMhBoJlQD9AgRPM6tMvzNbV055AJoMKwiykz6s6vODLaglV6?=
 =?us-ascii?Q?5UNI5V8Y9PI3tYr8fXtVL9VOhtHO4UWkdel0vzvF/plaWA+Ku+XIGTWMi1Fd?=
 =?us-ascii?Q?Pt3G33IY0nSBzFTWKn0GQegWFsdhV1iQZitBKV4JUdHnYbMUTc8tsUmrl+2X?=
 =?us-ascii?Q?9mCpEXDj5mdmhH6H9a2TaTBcO/zxWdDvgA0jwpLw/I61xpl5FWMHodGglDvp?=
 =?us-ascii?Q?BwcNYhBDru9WzPqEU3iqXASGwHu2N+SyFrz748uenS3ZOjETVvkoCs4Z9oVJ?=
 =?us-ascii?Q?9DIDp16NjYf8k3C9iXQ8Y8MerV/5Brf+JYGPLn44Xjr2esWCvEAkgesBd0Uz?=
 =?us-ascii?Q?a33E4c2MlNc1fTA3ab3bVxcB2jFkrj9u/TXiBadvEZmDugDSQUxb1T3vUp6R?=
 =?us-ascii?Q?QffSndG7KWbuYPdeO54Pw7NXcFewDWzB9SQ37jaAsed4656v3lLEuYCNe1fr?=
 =?us-ascii?Q?Ga04w5+WrLwtQrAeNSWcapQXlG2UI/kJaFRncbuQ/5ewdF9B3vqlIyWGwOpC?=
 =?us-ascii?Q?ml6B83cn5fvYVgIB6dkrwN+c2WCssBq4XSaD0gUnCSUHFVdAfJguxwSvgvKY?=
 =?us-ascii?Q?jJVE2kCQ4B34F4YZFqzgfLXzm+ULZKDcXFLuyqi+50h0tNmRJrmvzw55q3x2?=
 =?us-ascii?Q?30dK+3BUWKeLejuCD0tAX7WZqMKjHrHovRAO+l8696GO4H4XjPLqZZN4/g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 14:51:25.0316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b74d2f-f609-4431-229b-08dddff90942
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7849

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce new min, max sev_es_asid and sev_snp_asid variables.

The new {min,max}_{sev_es,snp}_asid variables along with existing
{min,max}_sev_asid variable simplifies partitioning of the
SEV and SEV-ES+ ASID space.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0635bd71c10e..cd9ce100627e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -85,6 +85,10 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned int max_sev_es_asid;
+static unsigned int min_sev_es_asid;
+static unsigned int max_snp_asid;
+static unsigned int min_snp_asid;
 static unsigned long sev_me_mask;
 static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
@@ -173,20 +177,31 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 	misc_cg_uncharge(type, sev->misc_cg, 1);
 }
 
-static int sev_asid_new(struct kvm_sev_info *sev)
+static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 {
 	/*
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
 	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
-	 * Note: min ASID can end up larger than the max if basic SEV support is
-	 * effectively disabled by disallowing use of ASIDs for SEV guests.
 	 */
-	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
-	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
-	unsigned int asid;
+	unsigned int min_asid, max_asid, asid;
 	bool retry = true;
 	int ret;
 
+	if (vm_type == KVM_X86_SNP_VM) {
+		min_asid = min_snp_asid;
+		max_asid = max_snp_asid;
+	} else if (sev->es_active) {
+		min_asid = min_sev_es_asid;
+		max_asid = max_sev_es_asid;
+	} else {
+		min_asid = min_sev_asid;
+		max_asid = max_sev_asid;
+	}
+
+	/*
+	 * The min ASID can end up larger than the max if basic SEV support is
+	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 */
 	if (min_asid > max_asid)
 		return -ENOTTY;
 
@@ -440,7 +455,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-	ret = sev_asid_new(sev);
+	ret = sev_asid_new(sev, vm_type);
 	if (ret)
 		goto e_no_asid;
 
@@ -3038,6 +3053,9 @@ void __init sev_hardware_setup(void)
 	if (min_sev_asid == 1)
 		goto out;
 
+	min_sev_es_asid = min_snp_asid = 1;
+	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
+
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
@@ -3061,11 +3079,11 @@ void __init sev_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_es_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_es_asid, max_sev_es_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_snp_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_snp_asid, max_snp_asid);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
-- 
2.34.1


