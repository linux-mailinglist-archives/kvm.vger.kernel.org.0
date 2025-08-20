Return-Path: <kvm+bounces-55209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ACE9B2E6FB
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 22:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E34F1189E3E9
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 20:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45ED32D6E60;
	Wed, 20 Aug 2025 20:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4GYbQlFp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF452D24A5;
	Wed, 20 Aug 2025 20:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755723024; cv=fail; b=I/7K9wu3kAcMoYsORlk2sWOOzNdjxs53yzcu0MhxFfRL6AHdUDHEYnKzv38YRZfvQN34ad87TzEgXKNG9B6OyFz5t4QG8bHgFpaneyXJSuxjEZHnY3NYaQZkU/OCFVwZ6hHMJI8NGbZgm14IJ8wk7gfWfpBfCzRKmnb8KckUQNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755723024; c=relaxed/simple;
	bh=2TG4laFLeE8q2Y5lZzuk/3A07v+bnm+uiewKElqR5QM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lae7YXahhJQcGfNXSyonHCzoiXuoOh9tjMgswspUyhEeGcFgcFITgfchzck9FQXYcpBb1GaNxCzRe+YjjNb5ycd7fcfx7YFgqywfzoJDA+iFVREI9Oov478Qcx8Mq8losA9GkM8M0hvgJMErsHz1Eo8MkGOX5c5CzQF06iJCwpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4GYbQlFp; arc=fail smtp.client-ip=40.107.236.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VksXL8T+XKJ2DmMZntJxdAsGcsKdNmyPap6XBGSvMfwKaYOdycsJc4QrEFvAdq+tO+NXHKe/EhnMKsNoJboHRCRB1Zj1s1yEbcegR3f+VhpP9kBwhnqbwhId0ZYuxvZ5AcOCqjYkVHUJfCO1vu0Rvcvqf8Fb+cPkJx2UtNuaHzae9jZnpb36kGCixLReoPB/MSM7G34F84yKv8Cx5S2X0MbM0+xFU50B7+IxPlJVDMl1MYRP69gIVzQgPGvSz1L0PAl7POQ41T2qEK8pUDEkINc4nAJElgIEkv76MTjk7NyrQWGbsZdMSo9iRlIFLqRHawLayPu1uvTMx+GOZV/7eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuSCBcTITYY8GUukGA0zSCGqL/Ce1seF63WHIuiHQpw=;
 b=QEfXac/QWkV4YTqfNnP79v/HPUpc/1E3qvZmtaTF065P41CkqvFyBIU13D3oaZT0mnlNOGY8KtJxcyZmpuqvLQiC+FW5PpLP1S8vl2cx4GhlCsb4Dz4IHZyGzvQWP+ZIbEcj98lLKBI1ZyAtxcFgiCjM6OepXIqE6Z+6NRDXAB7EgBcOZJsl26sWJ0bxbut/UPkGjou0BHO3f6rc0/47vmNVgdnTC9Q2SH9S900ry9gf71M08WxLBsgHxJYZ3nPppZugjEav+a1ffpWWPke3IztvTAYtWmOUCro9GZiO2rG/S26VftOUR5eiM3lFH96xwYM5m/2ictG4rJTSzBGOBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuSCBcTITYY8GUukGA0zSCGqL/Ce1seF63WHIuiHQpw=;
 b=4GYbQlFp6N0vZ48c718bK/ypqh6rLML3XgrUj6w4iTlXBCDI2iIbocavX2lvl8qvjXInU9crkm+6+yB7Jq7dUhstwNj4Y9Cr4XsKmSak0JIx7X60tNUC2GbGG8zcH03M3dIALviHsAT72lXZV8EecOLyfcm6Fqt+tMy3WO/0oQ0=
Received: from MW4PR03CA0234.namprd03.prod.outlook.com (2603:10b6:303:b9::29)
 by SA1PR12MB8888.namprd12.prod.outlook.com (2603:10b6:806:38a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 20:50:20 +0000
Received: from SJ5PEPF00000205.namprd05.prod.outlook.com
 (2603:10b6:303:b9:cafe::ac) by MW4PR03CA0234.outlook.office365.com
 (2603:10b6:303:b9::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 20:50:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000205.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 20:50:19 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 15:50:16 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <herbert@gondor.apana.org>
CC: <akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>,
	<michael.roth@amd.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v9 1/2] KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
Date: Wed, 20 Aug 2025 20:50:01 +0000
Message-ID: <1db48277e8e96a633d734786ea69bf830f014857.1755721927.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755721927.git.ashish.kalra@amd.com>
References: <cover.1755721927.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000205:EE_|SA1PR12MB8888:EE_
X-MS-Office365-Filtering-Correlation-Id: 826b314c-66ca-46f0-7547-08dde02b2cc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xsAhCxWJacAtmkg3jAKwUUkwVBkPc7oQSoRHlH/5DkF/2HDFRoMOU1bIE4hT?=
 =?us-ascii?Q?Jwp62DrbjeTxNpxWeBv9zbWUZ/5kXBWzG6syTVtZhOk0pImYGSydVzK4YMJx?=
 =?us-ascii?Q?xEH0weR8MszhzDDRspXFwGMkZtEk2Ntt6/GIdT7aZuDCP/qQfUmaeUKka5F/?=
 =?us-ascii?Q?hNTkwQnqz2FNW9GUjCFySfEJrOsSQm+WUyLmRRgf61FdDziU6xQ7kKQ/byH4?=
 =?us-ascii?Q?z+TWK230f0V9o+0mV5fLqDEqThVmiNB8KWfFZBwvCPGkewSZ/cAg8LaF/1qG?=
 =?us-ascii?Q?jSKsc0lg93qJ2kTuWZ7iSsup44Y8cQEOIQduJoQ4ahWfS8FMqIhUzO6/UoTj?=
 =?us-ascii?Q?MNm6AtMNbyack5nt4c9oEuk6z0q+c9QGsE/fH3gF+9/k15nolaD/uK/ETATB?=
 =?us-ascii?Q?o9wKf2SzuCSJmj5CeldfcYIjN9k4tayZuZWSSkWuBPyk5emmBB1MWbsFtrJG?=
 =?us-ascii?Q?UrIx51TdzUGk09cXlg0MnXXkleZOcKMH0UQe6sXeZpGJZt+YBiDkqE+kc4N/?=
 =?us-ascii?Q?ItOtNst2upFp+iGQq/tmXh8S0dUR9SKmlEOqMw6RDo7iFT+2iEzFhWE8YBau?=
 =?us-ascii?Q?ClzZS9PurclgHaMgob/mJwMa6oilRvlIuHSYaJNNxMVO2vrG2LV3E/obygih?=
 =?us-ascii?Q?bwdyK+9O3pZFBSyUOLieuFVpTP0IZmx3eXt9VCNjytcBzQDkbqNP5BPkiTrU?=
 =?us-ascii?Q?HSd1XF0ccqmLnz0I6Y9foLmoZl2EFqdR4pEIln8jMKFEiRIig1PluyO21GyY?=
 =?us-ascii?Q?LKgJYjphpCkUSLLELkw0MCnu60Z/C80N+VYMHdYpuX/AAmVJSgsjrH5T+77a?=
 =?us-ascii?Q?zV3gnaIf6igu7atUH2xHGl6f532Pk2+fA9OWBfbl5bOcPeYcoVMvjPm2P+8M?=
 =?us-ascii?Q?z210HO8Xo5X/NdDlDq7+VI/2vMU7Y/5qFD02g3vc1NnWohN+t+kBGlCIYYxO?=
 =?us-ascii?Q?56UXju8EL+oSFakj63s37ua0yRo3DcuNsfq9kn8Zsr/CyFpiHcdnZsxLaiNE?=
 =?us-ascii?Q?mCXeY33+zryDegv5ZNi/qg6cXL5rGfPimMjGTuO5cQbeSw0Ky5JkWxxmQtrS?=
 =?us-ascii?Q?ktF/V2n9SJdKW0IrzDDRGvR4OSfz+w1PNlY+t8tJdCG0jgo7LqOLdYKpIEc9?=
 =?us-ascii?Q?uLiCDnVC2vDTePIbfYa3uuRTpgdFnsYgSGfXRR1EsNPv6qJvPvuqpnYHV+dy?=
 =?us-ascii?Q?9Qbah06nibkG79dS2of4LGpYvoqZu558ch6hfWymiz/xx0WeUCdoQ4gvYcbx?=
 =?us-ascii?Q?Vc0n5N+aSbkRXfgu/AWwYHqL4o1S2b5uZUe3bX1Vkki5ejvRqxF8F0VVMUhd?=
 =?us-ascii?Q?l12RgGVVIKW6kAisZRSWMuiFPzbBT2Ci4D/EjacO4yzsTM0FZMU0MLhY8qZ6?=
 =?us-ascii?Q?pRryur91BCq0XA6CZFmbu+w66vP/cNjImyxSSTn+G6yqcd5vX7uzCKBB5IYW?=
 =?us-ascii?Q?QY4NvEZGbn6fXY8FOhNz6AzKmCnXBxoqrj9qUjTTkm4rEohMcAMVHl5UbX2x?=
 =?us-ascii?Q?PqycNkuVsZ7sT8wkCReqM+ZTXqoCkZ+fN/3P8OlzigyI2uuUY1qbSvcLEQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 20:50:19.4549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 826b314c-66ca-46f0-7547-08dde02b2cc6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000205.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8888

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


