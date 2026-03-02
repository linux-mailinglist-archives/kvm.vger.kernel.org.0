Return-Path: <kvm+bounces-72420-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0ITzFhgUpmnlJgAAu9opvQ
	(envelope-from <kvm+bounces-72420-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:50:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E56AA1E5EDE
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C71FE3294FC6
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F83E388E4F;
	Mon,  2 Mar 2026 21:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q2g1P1c9"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B34B388394;
	Mon,  2 Mar 2026 21:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487408; cv=fail; b=CwwuD0LISu49w8ZO+Wxkiih9Y486KVrnxzDykGhzFylzmr9M8hCSFGwLz5hio7HA14jP3UthUWX7EmyaYiPyvHtc23yeKcfPovRIET7UaytlONaYJ07hegZ6CJzwKF8cQk8DhPxGx/Y5aXOqIPMHY2XeHxdo0Ex4jeYZG/wojr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487408; c=relaxed/simple;
	bh=D2AM4OEfCXB067RmXXVJtOhLSF5aAfN08Ql+f38qxhY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fGyQJqr8XVFn7dNRrTbZKW9ZTEVaPxGx4xvBYaWiI9EYbUXoGH5ZJji5yiwwCl7WA5P0E1NUl8g+QXxXsODTpuYSMF66lkIk5SX6ndhkzioySRr7zHXwZKKcrrXnr7kT1ZpWUy+GSygJeE58pLYIdkJJ+oRzzMezZE/tAo9dH2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q2g1P1c9; arc=fail smtp.client-ip=40.93.196.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDtA7K7Wae9Yua0VfnNvABiXEXMGWTG/RKaNEYeqr4sYEMEznhcyO9IgZpfQxr9kg+QrluI/76CPVyIOrGHONe9McV6vjyF1bL95NtGdOjERtwFOsHiXmawY8h+xLpTWJgSvZDui2frYx8qEN2QhUz2S+i+cNYiLGPC0TSU9+1rxPttDM98aB6Wh3Faojyu9VTyjic46mlew/M7fyQImLDToh4aCgzoI9PQIBipEMpf6SKgh5c9TVcLfdBy7cxkjGQOLbD5U4tS9PuaEpNyhUBxRgTaIdjAgrV/CcSplw5yiCEKI+DLYVdvfM6+CSJlgPuEk8c0o7qBfERFe/GHKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdE4GWDxtl6omytINHhFJLNpNoILCgzvjNGbqEX2CY0=;
 b=Y1lIiO67bSnV6ebM64b/sTKynlphix1KmrcUSFvMI+oO+10zUiTliqotwoEc5U3SYL627M2ARweZzf0XbLCVyjPPMrY9pHxJC1sPdRlV004oxL2XsbflK5uwOcejIb/asFvBv5fh6IGil5qktc5PWvVBGh4D5CkU8q5uz+uQmdAodSMT+muw7/WhumCETo8Hv9uj0leEbxc8aGrMWrok3uppLR4Pc9WBEcQXYagf2ebbvFvwGAMK3CbT8UMxCGA8N88fgWlqawli3UKKd2KRjpqpxV2TDiGJJ0K8rIAIDc6A88e07yGuAfaHYzpv5h3tx0fnSkECK7Wq0g+boX8tdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdE4GWDxtl6omytINHhFJLNpNoILCgzvjNGbqEX2CY0=;
 b=Q2g1P1c9iqTVxqOUoGJQGHgpfBTHGnLvpCDC6CRqSrgkrvv1Ic6ImghQRPUvsn46JJRpGt/fB4zH870QIEBzRMW7EYVolYFYLpO//TvR3RAceeGq+uHeKwgHabWnwV3c+adB2jkrNCOJn8zpoWZWccuaYHZ2x5XXPur1wQPKbj0=
Received: from CH0PR03CA0380.namprd03.prod.outlook.com (2603:10b6:610:119::8)
 by IA1PR12MB7519.namprd12.prod.outlook.com (2603:10b6:208:418::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 21:36:41 +0000
Received: from DS2PEPF000061C4.namprd02.prod.outlook.com
 (2603:10b6:610:119:cafe::67) by CH0PR03CA0380.outlook.office365.com
 (2603:10b6:610:119::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 21:36:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF000061C4.mail.protection.outlook.com (10.167.23.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 21:36:40 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 15:36:38 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 4/7] x86/sev: Add interface to re-enable RMP optimizations.
Date: Mon, 2 Mar 2026 21:36:28 +0000
Message-ID: <6ff0a36460268f8325bba4267ed779b8ceb94795.1772486459.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772486459.git.ashish.kalra@amd.com>
References: <cover.1772486459.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C4:EE_|IA1PR12MB7519:EE_
X-MS-Office365-Filtering-Correlation-Id: d9cc0294-e85c-4cce-622e-08de78a3ca8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	WgLSH60yo4nsjZUbhYABMRsfvp9VneMuV8QMx3kUM7Ztiusfzx/4AAb6f4+U+Vy1Nay5J0mE6JEJVYHK7N8T5s2zOg8s1HQkoK3cixMdv7Ugx4zKEQ0l8EP4CFuaxIA9WVVf19iTIo4KA7V/n5j9fjKf8p5hAJCDufsaWd4Wt7WGRZ+ONGJnYvS/FZ8dP+O/jNqIHwV5w/tYTrvsQO+tOrZkB5HpgcIR5RhrQQTRfM/3JLQtSRXAwUI4zmytbtX3pzOZ8k2KtaASZBQDMU1AG1CTKxmIFShhogdSPLY9D7RFZo3G0OHw3wgrfhSi/ZqGZv2f/eQWcfWQWxMYKmvU/G/r9LySgrlcXcXWmI34diG+71t3l+vnIcbrcjeiXMxN5VUvHIP/VhNbL/qS2aSovsZEEI+yP/iRwka8ZwgIdIj6ZBxHjDjiThNeSbzZ1SWV7WbR5PgcUNWq0FP+XAmSSw3K1QRrTqnNjqnTyAAMHRWmUAQb+a5PtJwDAdI34SUQJGJXjPge4iBNSVZgVAVwlFZtUaIPKjz1t1gcGBC/sJloZS0XZV0UswROff/oJS6hha4KFXqDhvaNG2lkXSYvPFH72BE4Ip3CVdW2eBLE2naUjPByjOPuASVoT2htQHmIsn4fqZ0+znccHsIQPkr8F+yY/7IIR5pkEMOpnPBfpzfXGcgLs21VQSM9/wt+5AcwYPcNCqFGoexL0L0aPUVv9veVEy4KG7emhYJy7QmA3wzaMJN0oLqGegQ7GxHZcSLy6ZSIqfJuHPK+sI3DXnv3UgG2Pa7Hio9MUWTRi24oaDCK2QAQnpuRMUfJatgP1rzn1C1mWCo+6pTgvT5e4NJlV7KgPkRNW/b0spg4vucnn/s=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	G2hGdK6wWZEld4xH8nw2DcDt8jF6yC7q0puVEkj+3tjC9TUJ5T+1tIUK/rR4FwCerfp5HnDFxBXLRaaqNYuY2drzimHFNd6IK9Jo16KUeuVEq70YAgRvojJ7JTFNVlUGBGkeOUC0KaijUWJBkl4hCWvNW/3ppz+lid9Sd9F0YpS07r+35PHwCNLNh2hK5F6O1k7Ekbl9dv8Nf62huqX58GfaPVhIUyQD3DiagleH9Nf+m9v/0Y3EIcY7jJChi8BR+97JOcKfd6lfeLRT+5MGw5273WkpSBL6MEcFSHifZLG0wZeoTqpEP4N4niINoG+Hwa93ZGzDg3sqpxJhN92EEvW1rOrToY/t2+4DPZNhEV60MK8uAetHEzVH99qoRf/K4luZ8JfZSOqQzBEsW3AXwtRAv5huaBMb1x5zhodSebSSoHuMgd+A9hL1KvADV8sq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 21:36:40.5997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9cc0294-e85c-4cce-622e-08de78a3ca8f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7519
X-Rspamd-Queue-Id: E56AA1E5EDE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72420-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:email,amd.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

RMPOPT table is a per-processor table which indicates if 1GB regions of
physical memory are entirely hypervisor-owned or not.

When performing host memory accesses in hypervisor mode as well as
non-SNP guest mode, the processor may consult the RMPOPT table to
potentially skip an RMP access and improve performance.

Events such as RMPUPDATE or SNP_INIT can clear RMP optimizations. Add
an interface to re-enable those optimizations.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h   |  2 ++
 arch/x86/virt/svm/sev.c      | 17 +++++++++++++++++
 drivers/crypto/ccp/sev-dev.c |  4 ++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0e6c0940100f..451fb2b2a0f7 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -657,6 +657,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level);
 void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);
 void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
+int snp_perform_rmp_optimization(void);
 static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 {
 	__snp_leak_pages(pfn, pages, true);
@@ -677,6 +678,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
+static inline int snp_perform_rmp_optimization(void) { return 0; }
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index c99270dfe3b3..4dd5a525ad32 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -1144,6 +1144,23 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
 
+int snp_perform_rmp_optimization(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+		return -EINVAL;
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return -EINVAL;
+
+	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED))
+		return -EINVAL;
+
+	rmpopt_all_physmem();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_perform_rmp_optimization);
+
 void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 {
 	struct page *page = pfn_to_page(pfn);
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 096f993974d1..d84178a232e0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1478,6 +1478,10 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	}
 
 	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
+
+	/* SNP_INIT clears the RMPOPT table, re-enable RMP optimizations */
+	snp_perform_rmp_optimization();
+
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
 		data.tio_en ? "enabled" : "disabled");
-- 
2.43.0


