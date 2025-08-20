Return-Path: <kvm+bounces-55215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3BDB2E80A
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 00:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9ED147B5177
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 22:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1C3286409;
	Wed, 20 Aug 2025 22:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sqpGWYmw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2076.outbound.protection.outlook.com [40.107.101.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBC3266565;
	Wed, 20 Aug 2025 22:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755728376; cv=fail; b=hE+QC1nvNFGwDYMPY12sc0gQY3ZOxz6KZEUv7ciDQC3Pxx77l1OyHPbxpPLaEsYSENvQR1pGsmwdKtzcrF/CbW0jw3Bf9/VlzFEyN3bKV4xGWoHIwE6kNiArQiz08k+ysAR9PEtnzfdwTfniTEUsmGijGfKEH49wvhErYH1BAwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755728376; c=relaxed/simple;
	bh=aoHCC8fSa8ds/2Tq1wdzx440GKedCvrPISdeKZdOfGc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+eGmSVzropg1BV4PcAGd1aQUD/pWiNOTCsRVJ3OgtDybeCfb59VQXeu1TNPQHelaR8gxyTlMF40n9WcJ7wvfDorCLEUZQGAZY89Ya2H+aV+ifwXuJhfgeCNa6oTXuk3xtDJJbQzJ9jIuNUI1OocBf0cs7cLUM6c/vMz9F7dRoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sqpGWYmw; arc=fail smtp.client-ip=40.107.101.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IuTo8LCLNCz0WcRWO3NJdpx7csEqJLR26KcXii1CwQ71+CYlnMFXcvCeTY6LhxvdNifc9HQkPunMFNBvLlAiEIYtQgZTqLz3CcpsLxlJjw80s5EyJ0yB7nteFzcaolRJKTjVn804HlyIJ/lgT3RHxvGGZl/ac9qhqUMUgWFgSDNxjL8xhaudeo1U1GtQ5z7G3MU/tgGLSiy2hAb2QacHFoAOvEDWFBfcLfD6dhVSPqXY1hFJXTxmvXPM6hCAj5kckz22bY2YJvPs7jWp4MVRJxEFnLzgTUQCyWUTA2xT18TWgiC/bXw5tLLRjYcid0uSuE3FLn6zc1uwVxyKP0UgKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2Aqwr+LcP1dbEdKTw5EgizjML+yp87J7mR7dCsNKPs=;
 b=B7w4oYm8+v37ocukJr6stijDp31cuIX604u61aczSFsbmQd4lqWtwJaT5wDuhp0UEbwIsBTuNzEJWBCcHat9zV5LNU7W0RC7TvJKhbv7cqWcOevdTRy53FSEbF6VSQCon209MWU+DYyrIvNiA2Ki9MwE3Mc53yKyV/CLPANZxm7unhqVEMMWCMn+rVLCGgq8pW424HxZjwWmGQaPTqFCyLiXFKX3w5jvbP1JgbPg5dJBgeOIpu6pk1dLSrHzIZ+lLyz0+hJB6EsG8WCC/IjCG1xB9Cmiviw8PfSsDdHVYYfGXZODEf2cJk4bJUjh4MpAxkmVGRN75wfR2v3uIjzbuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2Aqwr+LcP1dbEdKTw5EgizjML+yp87J7mR7dCsNKPs=;
 b=sqpGWYmwc8jF3SB2I8oUBzJDy4KEAvwJpdAM2cfmdLa7JxUtmbuYkIWqGxkPAd30+Mihn33odHcNyQtz6G1eN6uklDGj+RjpmuByGJijskBCUMpgfd2iUDwtJWUKJcTcobQkGB7cFD//H+TesZ4ov8AKolqiQiajhT1MreQmHnk=
Received: from BY3PR05CA0021.namprd05.prod.outlook.com (2603:10b6:a03:254::26)
 by SJ2PR12MB9240.namprd12.prod.outlook.com (2603:10b6:a03:563::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 22:19:28 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:254:cafe::c2) by BY3PR05CA0021.outlook.office365.com
 (2603:10b6:a03:254::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.13 via Frontend Transport; Wed,
 20 Aug 2025 22:19:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 22:19:28 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 17:19:26 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v3 1/3] x86/sev: Add new dump_rmp parameter to snp_leak_pages() API
Date: Wed, 20 Aug 2025 22:19:16 +0000
Message-ID: <b5ed57029ae3d5c5eeac57faf4de9b95ae7af0b5.1755727173.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755727173.git.ashish.kalra@amd.com>
References: <cover.1755727173.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|SJ2PR12MB9240:EE_
X-MS-Office365-Filtering-Correlation-Id: 24e64bbe-a597-4f4c-76c3-08dde037a100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cfYsGSm9crGuAjveBgQIjwKOdM6JJZwVBsdj7Q6KqGeHvEzuWssqEgZBDTWt?=
 =?us-ascii?Q?LPNrvILReehtPXpmwE8aceCTeJJjJ8NdtwWqBWKaVJmHUSaFnTy3L/+B4mjL?=
 =?us-ascii?Q?rQceEj7ACov9YOGvjli1KkHIur9BidP01gmJX6hnrQ8p5q3foII2LLi9moZU?=
 =?us-ascii?Q?ugOnLjv+BXj6Stcb6l0FX3C37oKvfe/A8eXYToz9o7k+DOhMqwhLmPM7Xm0R?=
 =?us-ascii?Q?8hSAa6zVAWXyxfBDegmVezldvGU5luzBrekIs6xEc970rwqQRgMtnognLEIz?=
 =?us-ascii?Q?cnNqzjo2TiH0FrKdeKG7JwAk+6GiSctamoIoXfDrT5YBTCdgTRdDWJTh5pr+?=
 =?us-ascii?Q?t9YAlwk5JRpyWOT6m77vnv7rBua9LGnSL8PGeu8wwEC7ul4VggrGP/4hh6Q7?=
 =?us-ascii?Q?E/YOlFymgSgby87dXMX+o5NiWRyNcUS/HJvcyFmvTv4CO7qS+Ib7yf+lw+9x?=
 =?us-ascii?Q?ODFSL09xp+MjasbQaxd3FdNYbX1jsPz+0PruNIZfS0U9TGBszowrbXX8coFB?=
 =?us-ascii?Q?XDca3HohOWJKVJlpRtFj0o785rJgIhNNQJ8O7vo508vx1eMo0zbyqU40dDZ3?=
 =?us-ascii?Q?FioN/AjiXrX9e6o/HXJ5sIY90Gx9YR/fjfCgBbcHY2P24SL0CIk8QFKAaVEa?=
 =?us-ascii?Q?3mJaE3XUem8m9KyzzVLTgc2Lfd/8kfkUk3Xe0WGDTgPCC12g8peNS188bnNJ?=
 =?us-ascii?Q?k72jZVaKVfN2aCSCNHwTf1+ZAw/hhQPhTV/CBQLM6qvxVIY+5wQPMLOZ8Z1U?=
 =?us-ascii?Q?PDGChoUhJs+b2R6jrTanE7u9LVQQcTEdy+1RKLQe1WUMEuFOtC4qH9J8X1jM?=
 =?us-ascii?Q?aH3e2UG91NW1A3dC242jpJCI3n4tAEOWdlOWVdf8Bwt7h/W4LLaWRF1EM53b?=
 =?us-ascii?Q?X6oVA659hohnWPr//wvDTw91x1dSfE2LENfTnCGA/YEHOP3sXfRhQFvxU/Wc?=
 =?us-ascii?Q?cQAkSFtxmem/79bHyeqbjS9Q54Q4E9hq8RKnjREfmqb3DdDjqYQ+bkTkKvXx?=
 =?us-ascii?Q?VySlHENebBdtNJzkIyeafNugCw38AaMqdp4xZxCozly2uPzmb/oGYVeNYKX7?=
 =?us-ascii?Q?ePKzkYAEpdv7b6mkcWms4Z/Q6geynwatU+XALg/b/7hlfIrbc5MgCg+1/VC7?=
 =?us-ascii?Q?mu0lwr6o7VtTph2k1UbFomml/54EKPbrMQn7DVPPgwbyu4f1gDBaYW49o/bc?=
 =?us-ascii?Q?v3aP5fvJqSHlJtJpO98+YdyUfG/y3npPb6+Y5Tzg1vSq8OyNnXeCf0zKy8GV?=
 =?us-ascii?Q?YC8a6dMVgWlvJlR0PAiio+nnyyyFYKcNNN8zcdvZvAjhCUTqPJnVXuR6757b?=
 =?us-ascii?Q?NNEirlzJSkMj7sBDPfJW2v/5v262k5RrFOkwsTbZ3Ntw87CTpt2RT2QAEA6o?=
 =?us-ascii?Q?9ZHpskXW/mnO9+u+vMobiYS5DiPX5qpNV5wkzmYLov2gVNbmfPawllruS0oV?=
 =?us-ascii?Q?AIDpuFMiA8WIcH+oxausrBL5+Gx/QmEQfkERv3uOYCVcY+Be7tJ4tb8rNIlx?=
 =?us-ascii?Q?kx8beHXbJY0QkrTcXCTgIpU1V7WOEztOMbzKxpGkVu5n0kyhc6jlyWQp8g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 22:19:28.4122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e64bbe-a597-4f4c-76c3-08dde037a100
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9240

From: Ashish Kalra <ashish.kalra@amd.com>

When leaking certain page types, such as Hypervisor Fixed (HV_FIXED)
pages, it does not make sense to dump RMP contents for the 2MB range of
the page(s) being leaked. In the case of HV_FIXED pages, this is not an
error situation where the surrounding 2MB page RMP entries can provide
debug information.

Add new __snp_leak_pages() API with dump_rmp bool parameter to support
continue adding pages to the snp_leaked_pages_list but not issue
dump_rmpentry().

Make snp_leak_pages() a wrapper for the common case which also allows
existing users to continue to dump RMP entries.

Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h | 8 +++++++-
 arch/x86/virt/svm/sev.c    | 7 ++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 02236962fdb1..0d14bc955a0a 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -616,10 +616,15 @@ void snp_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
-void snp_leak_pages(u64 pfn, unsigned int npages);
+void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);
 void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
 
+static inline void snp_leak_pages(u64 pfn, unsigned int pages)
+{
+	__snp_leak_pages(pfn, pages, true);
+}
+
 static inline void sev_evict_cache(void *va, int npages)
 {
 	volatile u8 val __always_unused;
@@ -649,6 +654,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
 	return -ENODEV;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
+static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp) {}
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 942372e69b4d..ee643a6cd691 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -1029,7 +1029,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
 
-void snp_leak_pages(u64 pfn, unsigned int npages)
+void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 {
 	struct page *page = pfn_to_page(pfn);
 
@@ -1052,14 +1052,15 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
 		    (PageHead(page) && compound_nr(page) <= npages))
 			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
 
-		dump_rmpentry(pfn);
+		if (dump_rmp)
+			dump_rmpentry(pfn);
 		snp_nr_leaked_pages++;
 		pfn++;
 		page++;
 	}
 	spin_unlock(&snp_leaked_pages_list_lock);
 }
-EXPORT_SYMBOL_GPL(snp_leak_pages);
+EXPORT_SYMBOL_GPL(__snp_leak_pages);
 
 void kdump_sev_callback(void)
 {
-- 
2.34.1


