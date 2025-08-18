Return-Path: <kvm+bounces-54908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D1D1B2B1F6
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 21:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2CE3188BDC8
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 19:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731A0274B59;
	Mon, 18 Aug 2025 19:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b75WrcUj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7E6253F3A;
	Mon, 18 Aug 2025 19:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755547137; cv=fail; b=N6eXkv0v3/GoyqyEh7g+LELwITfV0gze/caFIA9wApg0k/OkFrbWqvEwFxQwSjMTAmy/rt210dOaKPg1bsI9iFkbbd+B6an0qD0kQROarRiItJacHM6OiGNVSobgQ/fv3BBEyWGqCKG71SOKEPoiFnQJ9xPR2qatsOO7SPtMTGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755547137; c=relaxed/simple;
	bh=IKGHAlhLpzLMeekciyHeTZc64xjJI8gaOUfECOVAQW0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a84g8K4BLVOTmwHb5P+taVjt6HpsnquXiOc3e3d9jAZ/1h3gCkiwh11xnnjdw6geUgFfyLOdMBj1ZfHdNN53pKZrHhBda2WNB04JCkCPi19vj50N1MjkkFefudHCYYThINoeQe5x9vAs3Y/gjKxaCrZc1uHGfVWpfRtAF1p+3w0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b75WrcUj; arc=fail smtp.client-ip=40.107.243.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CDbNiC3JCCjz04BX/l4m8Wc/OKS2i0Kj4jCvWJ/2VAOfToQ4k41AMXo1oA6YZ9NviCQ4wtE+A6sxqXL30a8ja/bHBU8xmpDvj0AelnSR1XqirRcLCe9NREA0k1hxSt/x1L5f/GZUUlKa0DBqVS1I7LnkNlbqlaqPBhb2OIDqcbe+cUGE/7ZNcufyd/ZVH/QU0M3qwVu8b+KncEc9lZ0BOmBkYhB6PLpZnHK6OMe7g2IwV05fAIfNn3BPdtaBtltXhWB09eFJ4UbJJZi4nyoPUQe6LIsxs5gfJ6ZFxLpX6xC0WgOp1E2G+Oq3qun+akgY1+UCooxp70biCmcTbbim8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z3Slit2iamgPUT/QQe6b0vhkqU9d8JUwTbhRQMNXBWM=;
 b=oz4g8ZumpuY6sDtfsyDBWgL5l6HEFwhAstL6ExqGjmiH/m/97bNW6NwqQ+w1o/qoeNqdt/W+taW+aAA5U5SiEUpEKnFiAXNDEk7lj0evw6Pl07kyD2Q4BVZnrpdUTg3mgZGygOkuZGzSlKzxWLmfFiO6hXImBITagh4hYAr7pi8nIVsHYf1DjDdaw4h7qAddWwEQeCw6zz9H1G7Qh/82nCYxG/Av7jdWUzuE2X2qMsJY15JdhsRTDlgAzRRgEl+d1QAoK5gcyt0gzT1bkrt6CjM+d9sAoQicaV6Syxo4c7JWe0o8DhaEZJXVORLyMWzXQA9O6HruvES6nXsKKYfz4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3Slit2iamgPUT/QQe6b0vhkqU9d8JUwTbhRQMNXBWM=;
 b=b75WrcUj2QY8FuYY+Vw6S1QTV6QexvZQ0MU2wdmZ43zY1TTA5sPzMNgSuCcNy8B6vlKN8nGERxfuLeRaQ56odUck99QLGp1Twfe+ZV/oiywV5Cvkmd5HPkl6hFpeWnSasAp4pfZGtrBlix1ZRMIdpy6sJsawcOzlNAJitkgq/Fg=
Received: from BL1PR13CA0127.namprd13.prod.outlook.com (2603:10b6:208:2bb::12)
 by SJ5PPF1394451C7.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 19:58:52 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:2bb:cafe::1c) by BL1PR13CA0127.outlook.office365.com
 (2603:10b6:208:2bb::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.12 via Frontend Transport; Mon,
 18 Aug 2025 19:58:51 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 19:58:50 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 14:58:48 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v2 1/3] x86/sev: Add new quiet parameter to snp_leak_pages() API
Date: Mon, 18 Aug 2025 19:58:38 +0000
Message-ID: <7f7cdb3268e95b7dfa924c3da16a201da0b095f3.1755545773.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755545773.git.ashish.kalra@amd.com>
References: <cover.1755545773.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|SJ5PPF1394451C7:EE_
X-MS-Office365-Filtering-Correlation-Id: b5f1a854-af8a-4531-9492-08ddde91a671
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YLxFO6EKKJmX9gGzevR10bW5IVp3hz5p6T57U3AX9ZM0dBBQn6xEiAcvB8sa?=
 =?us-ascii?Q?qSzVW4DePHo7tZXbheTeebJttMK8nBRnKw24eeXpVJP2m2YG2XFTOwAmvAh4?=
 =?us-ascii?Q?PcQPpG/qciOmfkDuj22Jmk2iZjs/9FoWBpNi+KF8sBK8NH+sTgJUejrg4tKQ?=
 =?us-ascii?Q?RIID4BtyrbD2SVPZC+fKmuOdvdM3nMAjyLSVu8aM0yww2MIHP4nq1xfnxM6R?=
 =?us-ascii?Q?HA7NHC9fN8aVFy4V1lvr71t4ASABqDKaOcskVcTZLumLrazT45S6sGzi/rE9?=
 =?us-ascii?Q?OJg52J/MffdrJkzJywIX0CiOIGpGZ73DChUIgdsu488ybEYykJhmTlBwUMue?=
 =?us-ascii?Q?4TH5sF+Gs0i0RebQLLolFDe1PYVc/Vlzl3ATNDugwd7z1J5+6V1kA164UfUC?=
 =?us-ascii?Q?YFWRM+yefYI+Ef7pnxQ5Ja+MQPUc145CPULXLn2X5e9y8CEmJUu52X9wj5rN?=
 =?us-ascii?Q?Gx4WRhZEKXsvmhAB+YuSadyWv4Le/ZJaNzoRUC9fjPK/GudGDkYqoCXNqqDO?=
 =?us-ascii?Q?JuBSqEw6DaqjqWvHEzTk31IQz2jWqRU2Xo1M1SytppW6ivMYYShZ2dImqUME?=
 =?us-ascii?Q?FEIPkuTPEGL39rwYCpCPsXbXAmSPTZIy8buTlpAhk0BYWXFgQs+1flZqSw4b?=
 =?us-ascii?Q?txbUSLkfckUsm8Lzcq7/TjZK4aUax9BC2MdVGfO0SGAREfeKSmHYG65fq9I/?=
 =?us-ascii?Q?XXp6WOIlz/ZYvwh1CmvnlgQ3v2a1XDFUMiSIRdkwjE/s6RncpJJIpIDeU4ig?=
 =?us-ascii?Q?2C7Ghw9PDjUaSVarM7q2KYkUS/pHTWDFem+ktUanvwGsJG4RVGzaUpMGtbb7?=
 =?us-ascii?Q?pH4EUuvx98G32OEPXD5N/fR8GyCIO4i+Z7Nz1/pz3GqfaUobIURmH9zceAS8?=
 =?us-ascii?Q?j2rjh0WDsOFhiURlcGseau2a/LYjvcJvfTNp9tcwm8S0UJJXGlF0EPRRNYs+?=
 =?us-ascii?Q?TWM4mlj0NfIWQrgF0HPNuckkbUdc4L5RmmMSX1OVePOJHC0W298iKruuxfma?=
 =?us-ascii?Q?QTmc9vZuV1yPLARrPfXHHO+iqV3ZXpNTC3wgOhAWy+nx6lZoU5V0vCCYpRm0?=
 =?us-ascii?Q?mGv4uMAOjNQxiWHxtryCYoP6CENpH6yqoRFL8HQFtQycWpJU48cFm8rNjK/W?=
 =?us-ascii?Q?1xw/SY5phqDv95C2FDgkCZWcIZwJYEQM9urENfDQSdqjSQsBEXLScUneStUm?=
 =?us-ascii?Q?D0nsY8T2ICtXiRlVl9cfZxOts9/roQzZo+7jREhF7G0ybEIjpeeaAwcmlI7X?=
 =?us-ascii?Q?a3JbDej1DF3Kz5Zfev7AYcUHo8P6Gv1jd+0xgZnumjPTaFkZNe4jFQqKBtP5?=
 =?us-ascii?Q?fR4zzO6IUhj6NvzX/duFXK60BXxMppZcOhWSmzZ15NmSAB8Be7u7QQ9x0JBx?=
 =?us-ascii?Q?Lqnh3h6gCH2QpG4UfexxrNE5OIis6KDIP37iFmQYlnx20ycUtE4gCewF5f+m?=
 =?us-ascii?Q?FVxpWS5Cli9m4FNNlfjMSCm1D8SLdzOgeogsEEpXo6OJFwPDdgJO0sVdQ0Ai?=
 =?us-ascii?Q?SUUQmU+ki0/Qec4lnSdjeTDNv0JjAh5XqVDs+R73tR8e20amSo47RhmTug?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 19:58:50.0115
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f1a854-af8a-4531-9492-08ddde91a671
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1394451C7

From: Ashish Kalra <ashish.kalra@amd.com>

When leaking certain page types, such as Hypervisor Fixed (HV_FIXED)
pages, it does not make sense to dump RMP contents for the 2MB range of
the page(s) being leaked. In the case of HV_FIXED pages, this is not an
error situation where the surrounding 2MB page RMP entries can provide
debug information.

Add new quiet parameter to snp_leak_pages(), to continue adding pages
to the snp_leaked_pages_list but not issue dump_rmpentry().

All existing users pass quiet=false parameter maintaining current
behavior. No functional changes.

Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h   | 4 ++--
 arch/x86/kvm/svm/sev.c       | 4 ++--
 arch/x86/virt/svm/sev.c      | 5 +++--
 drivers/crypto/ccp/sev-dev.c | 2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 02236962fdb1..8fc03f6c3026 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -616,7 +616,7 @@ void snp_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
-void snp_leak_pages(u64 pfn, unsigned int npages);
+void snp_leak_pages(u64 pfn, unsigned int npages, bool quiet);
 void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
 
@@ -649,7 +649,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
 	return -ENODEV;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
-static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
+static inline void snp_leak_pages(u64 pfn, unsigned int npages, bool quiet) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline void sev_evict_cache(void *va, int npages) {}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..a7db96a5f56d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -271,7 +271,7 @@ static void sev_decommission(unsigned int handle)
 static int kvm_rmp_make_shared(struct kvm *kvm, u64 pfn, enum pg_level level)
 {
 	if (KVM_BUG_ON(rmp_make_shared(pfn, level), kvm)) {
-		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
+		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT, false);
 		return -EIO;
 	}
 
@@ -300,7 +300,7 @@ static int snp_page_reclaim(struct kvm *kvm, u64 pfn)
 	data.paddr = __sme_set(pfn << PAGE_SHIFT);
 	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &fw_err);
 	if (KVM_BUG(rc, kvm, "Failed to reclaim PFN %llx, rc %d fw_err %d", pfn, rc, fw_err)) {
-		snp_leak_pages(pfn, 1);
+		snp_leak_pages(pfn, 1, false);
 		return -EIO;
 	}
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 942372e69b4d..d75659859a07 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -1029,7 +1029,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
 
-void snp_leak_pages(u64 pfn, unsigned int npages)
+void snp_leak_pages(u64 pfn, unsigned int npages, bool quiet)
 {
 	struct page *page = pfn_to_page(pfn);
 
@@ -1052,7 +1052,8 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
 		    (PageHead(page) && compound_nr(page) <= npages))
 			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
 
-		dump_rmpentry(pfn);
+		if (!quiet)
+			dump_rmpentry(pfn);
 		snp_nr_leaked_pages++;
 		pfn++;
 		page++;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 4f000dc2e639..203a43a2df63 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -408,7 +408,7 @@ static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool lock
 	 * If there was a failure reclaiming the page then it is no longer safe
 	 * to release it back to the system; leak it instead.
 	 */
-	snp_leak_pages(__phys_to_pfn(paddr), npages - i);
+	snp_leak_pages(__phys_to_pfn(paddr), npages - i, false);
 	return ret;
 }
 
-- 
2.34.1


