Return-Path: <kvm+bounces-15277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F03C08AAEF1
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A35E9283B7B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424A586640;
	Fri, 19 Apr 2024 13:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LTVqB+Bi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF084D137
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531635; cv=fail; b=CkR/Yrxr1NCDNWN1Ni+ds7BSrQxTCSBFXAPmmnmaJ24zdcS7RlAikOBlUec1mCyVeZHzWHac3eDH8mkHKF49xGgmb5UE4SiIJ08RGiIvA5PbPRwt3yrb2sUUZWx99n27yt04aFNLqTPfjKaBxN54iUf3wjIjP8v7q+zTPpdZp2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531635; c=relaxed/simple;
	bh=gCVtws/J1e1xkiqygtjlqfH65oz0PbFIIhhyuPinXYo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLTX7Ovaya2E0X0eVoIb7f15PUkMEGmVrr2ddKa6fDk4q5pTGZJj7saO7hpva7cTURy1EBi03D4JigAmzEx55ApxlhbeheAi/FGAjiAJBMnD7xUyjatN2L3bg6Pn3SdJmEN18329h+VMv7C2W1G7CwVe+rC3c5ehQOqPY8+a9sU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LTVqB+Bi; arc=fail smtp.client-ip=40.107.100.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iem35ThBzA+PYfSDfikUhV6HytbZuSZHqoCa7wHz13COr+JSB4BTunkAZts9o+459b8nnNeDweeDCipaccQRQbwQBFKAxTabOo/UgFeC9chFdABNJoVuQSl5TStVnaeTgsL3+4AEIL8sIMY0J4pizkf8UunzPq+kR1col5bjPGQzxc1MzS6WOBlUH3o6m6HSvBYpo5u39y63pms4+OVxmRHqI4uurwH1nkPIkB444wQvqKM/oA8c4JXOr+9LX6sJnjwj6jaEqPMSHDO42K5XN2sV1EqR/oKmFhq+HFdjYmS5gAumdTWwLWwjAfxyQHDOkRbH/fIXrFHP/KSu8KYVWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFAzf2wWvgUrwlF4rNj5uIM3ZLP7SXl1uKULfaWv6oo=;
 b=TxwfvVxyAyF7CGoDeD8LpCm/DdE0qDy8pQM82RHxo/mdLRF7VKRyuuGUmySPbiIoUDV1o5RXX8DYpzUXzQZkPzILuwpjftu+T1NBU3569FhDOGoV6BvAYDEseizIUn49YW6LkJmlrPoQKd090yZw9ip/q62v1FB2uYMQn4Ah5k4NwG3nmEswFlfKo7lnIBO/MZiJqVfnfIQo2UHfZYRbYTD5VqZrTAnvEbgWcmvyjlDBTUTyOH855qCJLNzyxHV8Wbjh6hahobwx+dGb7r+ZzWWiZwywtNciWKqm0/WGMP5lcqtJAC3yhvUudjrA4KODtDcQtMOUVkuHtuK3WrkW6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFAzf2wWvgUrwlF4rNj5uIM3ZLP7SXl1uKULfaWv6oo=;
 b=LTVqB+Bil8pnbMtNaoh3DkVRLIcryDLP28k92j2IDbdyUsSlDUQU5EWEAgbXFn054rXt7htE1JZnMZXdpx+DOKJMWDBiJAB0gA6aZ/rz6mV3x/J1BhaKR77Tdo5Mflqtk1JX6WGB7mHB/btGup1x1Cx4N0CE38i+nHfnbGObZ3k=
Received: from PH0PR07CA0018.namprd07.prod.outlook.com (2603:10b6:510:5::23)
 by MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.42; Fri, 19 Apr
 2024 13:00:30 +0000
Received: from SN1PEPF00036F3C.namprd05.prod.outlook.com
 (2603:10b6:510:5:cafe::c8) by PH0PR07CA0018.outlook.office365.com
 (2603:10b6:510:5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.30 via Frontend
 Transport; Fri, 19 Apr 2024 13:00:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3C.mail.protection.outlook.com (10.167.248.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 13:00:29 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 08:00:26 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 10/13] x86 AMD SEV-SNP: Change guest pages from Private->Shared using GHCB NAE
Date: Fri, 19 Apr 2024 07:57:56 -0500
Message-ID: <20240419125759.242870-11-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419125759.242870-1-papaluri@amd.com>
References: <20240419125759.242870-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3C:EE_|MN2PR12MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c4e82ea-2c5b-4e60-8bc1-08dc6070b090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NIUevlf+lCKmbZWIY6zYhOlquf4EBFUvLtiUPJsVJ4LQ/10kMD33A+DQ8RpO?=
 =?us-ascii?Q?FIgyool7vttmCX3Sw3aAbP3ajQRxOGhpMHzwFCx72KQ2zOtgfQC0/tVIQng3?=
 =?us-ascii?Q?NYrsPBWF1a2f4UqFy6n07Gr3n6PPFqOT+7Txjv7YAmerxXku84aUhq86vIAy?=
 =?us-ascii?Q?hUZOq1EjXKuA3N6mEvo2Sd53W2whAAgCRXVawv7KQu4/QL6IYJqItSsySU98?=
 =?us-ascii?Q?EyyPyD/FMrcU+8Ovofa/SynbexYuvhtjh4+Wy/Bukofmu3roEcvhOS11qygP?=
 =?us-ascii?Q?44EN0V/6tIMfG+/8+KQ3IOmMvyQABfLoSBaotrOUa+RO+01xYiBHt8PxG8eR?=
 =?us-ascii?Q?VQ7/YTEaDTG6/pD605E9TeV6aHm5ClWBhvSoMxxFf5cnGUY60MGCu5ougapE?=
 =?us-ascii?Q?lIT3nJXUdrCj1+8dPRH9+nPXd1XOgF1wvshej+LqbxHLAkzvmm+wunMxq8Um?=
 =?us-ascii?Q?gbOPYUriQlCs7FaLbscQ+kRmny3FTJPRX1hb+zhGe2uWJxDwdeR7mBoRDyRB?=
 =?us-ascii?Q?xYlKRkXAHAeTJ2S+fXOo9MfreXATlXkTGehEUVfspVYFOAlcp13eIwGWFBJt?=
 =?us-ascii?Q?jef/Tx3IF/uzrJHvgpbWptsqBHwJedJT5bdrK3h21gtqZWk9/f0cFWCI0Fm2?=
 =?us-ascii?Q?a/jdXV4LzccH/kVG6SV+3e6eap++FOiojzARlhzVr1zZi9Z49SFowKVztkWS?=
 =?us-ascii?Q?ov7+L9o8gp7Y7l3vTcxVir9/DBp9CV57+mTRtZX2qJVlCklAQ+4cy3MWQMgk?=
 =?us-ascii?Q?7O5eQXh32GsviRKHzHz5i6qKOKAjazKFZ9w09y2xPG9jOJICQWeJCaadhTrX?=
 =?us-ascii?Q?GO0JXa8WJIm9g7ZpLkmbtelbrFBocr8JCTnwENVNUUDJ7OXe59zJCpgSoD1J?=
 =?us-ascii?Q?js0m4pbGRNinzSpeW1tDc9ixk+xAA+9wqtXeCE86JWIrmsRMZrA6k8pYNKnG?=
 =?us-ascii?Q?Jxeu+UtnnJ6aizCFPEZRZOcL38rA2tQcfChOJB/MMoY0cqft6G1RbNNr1yU+?=
 =?us-ascii?Q?WUknbjvGUCsAxUX6yZJePbT7DrIA4BhjRjhmX7rrv0gjeStkh+tFmzihwnCk?=
 =?us-ascii?Q?/l1/Ef6MB7KlxjgbC9ANgRlKONKag1+4yWiE9bj2eODIYBBzz8l1DS4isxMH?=
 =?us-ascii?Q?LHkkKpmdtzo+x2hlVwEWcDFdNLhlk+5yc8uw/Pg99ddujxPLLbYRbU1GejYM?=
 =?us-ascii?Q?o72JKd2NWXweVJKtaA5314RUl7nCb2/BbEsrn8JOZ+colK31T6KyJ25cIyyR?=
 =?us-ascii?Q?nMCm3NLdhlczZo/86YKQFENTSEmxVjuy0wUAwDyw51nI/zDrpWo/Wx8tHRxw?=
 =?us-ascii?Q?6QL2jugPrOi6K35e35rxy7vJ8rZaMKq4CzSOwht5aSTHIQWf8hG6GnWEAApu?=
 =?us-ascii?Q?qIgpEknFZaaNkbuVPoblLqUeRWuO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 13:00:29.2134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4e82ea-2c5b-4e60-8bc1-08dc6070b090
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440

As mentioned in the GHCB spec (Section 4 GHCB Protocol, Table-5 SNP
Page state change), perform page state change conversions on
a user inputted number of pages from private to hypervisor-owned. The
page state change NAE event allows for SEV-SNP guest to request page
state changes to hypervisor using GHCB protocol.

The test introduces support for both 4K pages as well as 2M large pages,
depending on the order specified and whether the address of the page is
2M aligned or not. If 2M range is backed by a 4K page, 'pvalidate' fails
with FAIL_SIZE_MISMATCH error. In such a case, the guest tries to
pvalidate all the 4K entries in this 2M range.

Conduct a test to re-validate the private page before conversion to
ensure PVALIDATE_FAIL_NOUPDATE is met, indicating that expected page state is
met. Then, perform the page state conversions, unset the C-bits on these pages,
and write data to the un-encrypted pages after private->shared conversions to
confirm we can write data to the shared guest pages post page state conversions
with C-bits unset appropriately.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/amd_sev.h    |  22 +++++
 lib/x86/amd_sev_vc.c |   2 +-
 lib/x86/svm.h        |   1 +
 x86/amd_sev.c        | 216 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 239 insertions(+), 2 deletions(-)

diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index b648fb0e7873..a596f8d334ba 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -92,6 +92,7 @@ struct ghcb {
 
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
+#define RMP_PG_SIZE_2M			1
 
 enum es_result {
 	ES_OK,			/* All good */
@@ -165,6 +166,7 @@ efi_status_t setup_amd_sev(void);
  *   - Section "GHCB"
  */
 #define SEV_ES_GHCB_MSR_INDEX 0xc0010130
+#define VMGEXIT_PSC_MAX_ENTRY 253
 
 #define GHCB_DATA_LOW		12
 #define GHCB_MSR_INFO_MASK	(BIT_ULL(GHCB_DATA_LOW) - 1)
@@ -196,11 +198,31 @@ enum psc_op {
 	/* GHCBData[63:32] */					\
 	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
 
+struct psc_hdr {
+	u16 cur_entry;
+	u16 end_entry;
+	u32 reserved;
+};
+
+struct psc_entry {
+	u64 cur_page	: 12;
+	u64 gfn		: 40;
+	u64 operation	: 4;
+	u64 pagesize	: 1;
+	u64 reserved	: 7;
+};
+
+struct snp_psc_desc {
+	struct psc_hdr hdr;
+	struct psc_entry entries[VMGEXIT_PSC_MAX_ENTRY];
+};
+
 bool amd_sev_es_enabled(void);
 efi_status_t setup_vc_handler(void);
 bool amd_sev_snp_enabled(void);
 void setup_ghcb_pte(pgd_t *page_table);
 void handle_sev_es_vc(struct ex_regs *regs);
+void vc_ghcb_invalidate(struct ghcb *ghcb);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index aca549b369b1..03286146fb13 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -12,7 +12,7 @@
 
 extern phys_addr_t ghcb_addr;
 
-static void vc_ghcb_invalidate(struct ghcb *ghcb)
+void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
 	ghcb->save.sw_exit_code = 0;
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
diff --git a/lib/x86/svm.h b/lib/x86/svm.h
index 36fbf4559643..582420cc2836 100644
--- a/lib/x86/svm.h
+++ b/lib/x86/svm.h
@@ -362,6 +362,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXIT_NPF  		0x400
 
 #define SVM_EXIT_ERR		-1
+#define SVM_VMGEXIT_PSC		0x80000010
 
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 31d15b49fc7a..1723a235166b 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -115,6 +115,121 @@ static inline int pvalidate(u64 vaddr, bool rmp_size,
 	return result;
 }
 
+static void pvalidate_pages(struct snp_psc_desc *desc)
+{
+	struct psc_entry *entry;
+	unsigned long vaddr;
+	int pvalidate_result, i;
+	bool validate;
+
+	for (i = 0; i <= desc->hdr.end_entry; i++) {
+		entry = &desc->entries[i];
+
+		vaddr = (unsigned long)__pa(entry->gfn << PAGE_SHIFT);
+		validate = entry->operation == SNP_PAGE_STATE_PRIVATE;
+
+		pvalidate_result = pvalidate(vaddr, entry->pagesize, validate);
+		if (pvalidate_result == PVALIDATE_FAIL_SIZEMISMATCH &&
+		    entry->pagesize == RMP_PG_SIZE_2M) {
+			unsigned long vaddr_end = vaddr + LARGE_PAGE_SIZE;
+
+			for (; vaddr < vaddr_end; vaddr += PAGE_SIZE) {
+				pvalidate_result = pvalidate(vaddr, RMP_PG_SIZE_4K,
+							     validate);
+				if (pvalidate_result)
+					break;
+			}
+		}
+
+		if (pvalidate_result) {
+			assert_msg(!pvalidate_result, "Failed to validate address: 0x%lx, ret: %d\n",
+				   vaddr, pvalidate_result);
+		}
+	}
+}
+
+static int verify_exception(struct ghcb *ghcb)
+{
+	return ghcb->save.sw_exit_info_1 & GENMASK_ULL(31, 0);
+}
+
+static inline int sev_ghcb_hv_call(struct ghcb *ghcb, u64 exit_code,
+				   u64 exit_info_1, u64 exit_info_2)
+{
+	ghcb->version = GHCB_PROTOCOL_MAX;
+	ghcb->ghcb_usage = GHCB_DEFAULT_USAGE;
+
+	ghcb_set_sw_exit_code(ghcb, exit_code);
+	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
+
+	VMGEXIT();
+
+	return verify_exception(ghcb);
+}
+
+static int vmgexit_psc(struct snp_psc_desc *desc, struct ghcb *ghcb)
+{
+	int cur_entry, end_entry, ret = 0;
+	struct snp_psc_desc *data;
+
+	/*
+	 * If ever sizeof(*desc) becomes larger than GHCB_SHARED_BUF_SIZE,
+	 * adjust the end_entry here to point to the last entry that will
+	 * be copied to GHCB shared buffer in vmgexit_psc().
+	 */
+	if (sizeof(*desc) > GHCB_SHARED_BUF_SIZE)
+		desc->hdr.end_entry = VMGEXIT_PSC_MAX_ENTRY - 1;
+
+	vc_ghcb_invalidate(ghcb);
+
+	/* Copy the input desc into GHCB shared buffer */
+	data = (struct snp_psc_desc *)ghcb->shared_buffer;
+	memcpy(ghcb->shared_buffer, desc, GHCB_SHARED_BUF_SIZE);
+
+	cur_entry = data->hdr.cur_entry;
+	end_entry = data->hdr.end_entry;
+
+	while (data->hdr.cur_entry <= data->hdr.end_entry) {
+		ghcb_set_sw_scratch(ghcb, (u64)__pa(data));
+
+		ret = sev_ghcb_hv_call(ghcb, SVM_VMGEXIT_PSC, 0, 0);
+
+		/*
+		 * Page state change VMGEXIT passes error code to
+		 * exit_info_2.
+		 */
+		if (ret || ghcb->save.sw_exit_info_2) {
+			printf("SNP: PSC failed ret=%d exit_info_2=%lx\n",
+			       ret, ghcb->save.sw_exit_info_2);
+			ret = 1;
+			break;
+		}
+
+		if (cur_entry > data->hdr.cur_entry) {
+			printf("SNP: PSC processing going backward, cur_entry %d (got %d)\n",
+			       cur_entry, data->hdr.cur_entry);
+			ret = 1;
+			break;
+		}
+
+		if (data->hdr.end_entry != end_entry) {
+			printf("End entry mismatch: end_entry %d (got %d)\n",
+			       end_entry, data->hdr.end_entry);
+			ret = 1;
+			break;
+		}
+
+		if (data->hdr.reserved) {
+			printf("Reserved bit is set in the PSC header\n");
+			ret = 1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
 static efi_status_t __sev_set_pages_state_msr_proto(unsigned long vaddr, int npages,
 						    int operation)
 {
@@ -261,6 +376,66 @@ static efi_status_t sev_set_pages_state_msr_proto(unsigned long vaddr,
 	return ES_OK;
 }
 
+static unsigned long __sev_set_pages_state(struct snp_psc_desc *desc,
+					   unsigned long vaddr, unsigned long vaddr_end,
+					   int op, struct ghcb *ghcb, bool large_entry)
+{
+	struct psc_hdr *hdr;
+	struct psc_entry *entry;
+	unsigned long pfn;
+	int iter, ret;
+
+	hdr = &desc->hdr;
+	entry = desc->entries;
+
+	memset(desc, 0, sizeof(*desc));
+	iter = 0;
+
+	while (vaddr < vaddr_end && iter < ARRAY_SIZE(desc->entries)) {
+		hdr->end_entry = iter;
+		pfn = __pa(vaddr) >> PAGE_SHIFT;
+		entry->gfn = pfn;
+		entry->operation = op;
+
+		if (large_entry && IS_ALIGNED(vaddr, LARGE_PAGE_SIZE) &&
+		    (vaddr_end - vaddr) >= LARGE_PAGE_SIZE) {
+			entry->pagesize = RMP_PG_SIZE_2M;
+			vaddr += LARGE_PAGE_SIZE;
+		} else {
+			entry->pagesize = RMP_PG_SIZE_4K;
+			vaddr += PAGE_SIZE;
+		}
+
+		entry++;
+		iter++;
+	}
+
+	if (op == SNP_PAGE_STATE_SHARED)
+		pvalidate_pages(desc);
+
+	ret = vmgexit_psc(desc, ghcb);
+	assert_msg(!ret, "VMGEXIT failed with return value: %d", ret);
+
+	if (op == SNP_PAGE_STATE_PRIVATE)
+		pvalidate_pages(desc);
+
+	return vaddr;
+}
+
+static void sev_set_pages_state(unsigned long vaddr, unsigned long npages,
+				int op, struct ghcb *ghcb, bool large_entry)
+{
+	struct snp_psc_desc desc;
+	unsigned long vaddr_end;
+
+	vaddr = vaddr & PAGE_MASK;
+	vaddr_end = vaddr + (npages << PAGE_SHIFT);
+
+	while (vaddr < vaddr_end)
+		vaddr = __sev_set_pages_state(&desc, vaddr, vaddr_end, op,
+					      ghcb, large_entry);
+}
+
 static void test_sev_snp_activation(void)
 {
 	efi_status_t status;
@@ -407,6 +582,43 @@ static void test_sev_psc_ghcb_msr(void)
 	free_pages_by_order(vaddr, SNP_PSC_ALLOC_ORDER);
 }
 
+static void test_sev_psc_ghcb_nae(void)
+{
+	pteval_t *pte;
+	bool large_page = false;
+	unsigned long *vm_pages;
+	struct ghcb *ghcb = (struct ghcb *)(rdmsr(SEV_ES_GHCB_MSR_INDEX));
+
+	vm_pages = alloc_pages(SNP_PSC_ALLOC_ORDER);
+	assert_msg(vm_pages, "Page allocation failure");
+
+	pte = get_pte_level((pgd_t *)read_cr3(), (void *)vm_pages, 1);
+	if (!pte && IS_ALIGNED((unsigned long)vm_pages, LARGE_PAGE_SIZE)) {
+		report_info("Installing a large 2M page");
+		/* Install 2M large page */
+		install_large_page((pgd_t *)read_cr3(),
+				   (phys_addr_t)vm_pages, (void *)(ulong)vm_pages);
+		large_page = true;
+	}
+
+	report(is_validated_private_page((unsigned long)vm_pages, large_page, true),
+	       "Expected page state: Private");
+
+	report_info("Private->Shared conversion test using GHCB NAE");
+	/* Private->Shared operations */
+	sev_set_pages_state((unsigned long)vm_pages, 1 << SNP_PSC_ALLOC_ORDER,
+			    SNP_PAGE_STATE_SHARED, ghcb, large_page);
+
+	set_pte_decrypted((unsigned long)vm_pages, 1 << SNP_PSC_ALLOC_ORDER);
+
+	report(!test_write((unsigned long)vm_pages, 1 << SNP_PSC_ALLOC_ORDER),
+	       "Write to %d un-encrypted pages after private->shared conversion",
+	       1 << SNP_PSC_ALLOC_ORDER);
+
+	/* Cleanup */
+	free_pages_by_order(vm_pages, SNP_PSC_ALLOC_ORDER);
+}
+
 int main(void)
 {
 	int rtn;
@@ -417,8 +629,10 @@ int main(void)
 	test_stringio();
 	setup_vm();
 
-	if (amd_sev_snp_enabled())
+	if (amd_sev_snp_enabled()) {
 		test_sev_psc_ghcb_msr();
+		test_sev_psc_ghcb_nae();
+	}
 
 	return report_summary();
 }
-- 
2.34.1


