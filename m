Return-Path: <kvm+bounces-21843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51AF4934D7C
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 611DDB231B8
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12EAE13C80B;
	Thu, 18 Jul 2024 12:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZETBP/QQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8528154645
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307134; cv=fail; b=jKjNS8DE/fh+HK9wI3r/hK/tYctwFO+gyaOyn7JepAO/k2OZO6TwChkphdC49Lytb4Z6dV5vTyjFQvN+b0aF7Nk0zzro5kqh2dMn508pf8JoiawbIvbEqpWmOUx/P21nfTLqRusiDLwhuFq+U2VBb4HA9vunVm73Qtl9YY+8vRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307134; c=relaxed/simple;
	bh=9Nmtv4CN2bbhb9goSbm0C0wEbs8w5wh1mRHhl2RX6rs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cqvog7ovv9kCBKxzm9vxQiYZygknI+HX8HfDHja2fTcDWHwXR5oKrRowt1rWR6wEp1L0lLOdezYqtfEq4VEvSfcSLX7W8mi0HKQe6Tk+lIxw+zNiwg3td7sELuibazOof47UYQc8NlipymBULyDLN2UmCkrxKHJYvm1LnWTSivk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZETBP/QQ; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xmu0Z62lNwcwYeh0f9360ppHloWVW3UVWtV1nk9gQK121ZYwuTXY7XGHqOKRWjCzVPZ3npuO4uU2T4t7DuOIjVamKpKEez0ANwa8V9uCFLBw/jQ2LEpaPtxzu4eHEixL0pUIm2UtPN41O/uGUAGHjjI0TOapLFpSm5PCqBkaBJ2Y95KNfbF+6+4aOxlvrn67m7sEfBy0MhlWEycGLB+z1wxPAKaFeTtVA+G9o1ZI41d/ZKRHnfxLO3hAtfI5mV9D2KXaKu0dDFBrflcKaeX/lSMZYJOGdL1PMZ2EQ1YKi8LV0DO0MBll/Y2qnc+s4NZwAc12HsN+M+jnWOxCw943bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hqgpw9cO9vKXFwoSx7SfTcP8FMWo0YxqrCLMNfkWAAM=;
 b=E6PSLQ+vbpEAPM1kDzzvWNy9Qkrr33xUjWngrIeAkQhReMZyY9II56G3q3md6zgkCKnlL60jULcUVb5A92M9kBoyYJ9/W767VvNqqkeh5KP+dwwqke/W3CgMuxBhlZ6dn0YEMbWst97Ksoo2SEO99MDTTtEevlkKHruaoYWJnIZtlow6BljnzXnudjVlRR5ZMGiSDaLHA0RTKktxKjCaoxfQTqwi/8lGDhojfv8I2w4FvRwPzW5GFSeoR6jRymwfIN2/a5F9dGtkSXSGcnxPm34Gx2xSqHaSzU7MhbjxPutKFfdHik2v5yFdbZ4AFNaSpIqZr0un7t4KbBq5kwEoeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hqgpw9cO9vKXFwoSx7SfTcP8FMWo0YxqrCLMNfkWAAM=;
 b=ZETBP/QQPHAdhbhd49DL+jqDuaddz3kJ/bbquDCgPqUY7WeCYpw6eHzKKCenJsRrjIblqhLQOgQw00RWrpc30xtBkHEvvm6cqvmFE/ufb2MsHvyHcAZhb0C8Mqcsx0yJuqBzmqDcf/GIfj+p8LvHMw/zg573SBbudPPOESNAxnA=
Received: from CH2PR18CA0025.namprd18.prod.outlook.com (2603:10b6:610:4f::35)
 by DS7PR12MB5934.namprd12.prod.outlook.com (2603:10b6:8:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14; Thu, 18 Jul
 2024 12:52:07 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:4f:cafe::a3) by CH2PR18CA0025.outlook.office365.com
 (2603:10b6:610:4f::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.35 via Frontend
 Transport; Thu, 18 Jul 2024 12:52:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:52:07 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:52:04 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 12/16] x86 AMD SEV-SNP: Change guest pages from Shared->Private using GHCB NAE
Date: Thu, 18 Jul 2024 07:49:28 -0500
Message-ID: <20240718124932.114121-13-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|DS7PR12MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: c0442d3f-8e50-4f82-2a87-08dca7286e6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w+7uBrTGuaptk8z3Y5Pqk3o/DZl5iKjYsRyHTJK7LeRi/ljnrFpgQB8GCGHf?=
 =?us-ascii?Q?zsJfXjiRRxnTr5ZywXySakM4o4uC1bO9g/NtLAJlTdPPMLPbWpJ3gCroIpOj?=
 =?us-ascii?Q?w50AD0K6Ej+0XrDhV9axhndNgH1tRMoP+HHdNLDoICSE3dUL9XpM0xfNatmP?=
 =?us-ascii?Q?msVrP6r0H595RElBdZvXcRpiBZ1loIZ7iqodcpuUYJH/xqG/teoZwok6/4Ck?=
 =?us-ascii?Q?xjR+HprdTT6HSJnS04rqzOmEniYF8UiaCd6LxO/4oxfspsgqE0zdLmAFEA/T?=
 =?us-ascii?Q?gpd7eCdF9qBda+Gs/bPbOKkXSDwRwnM2lwQ5Hhlv6rE4Tj6wH8bt5nCK17di?=
 =?us-ascii?Q?0oFY2pwFPskGvxsWqUD3s+/x16Z6Jbt0AubKI298QsqKPJgKw4415VTRmyuB?=
 =?us-ascii?Q?2YuZKKbZ71VzQrcGj37X5f8Q911dgC+9MWnkq3oXA2jVeQ5nI4zsoxmgyBYP?=
 =?us-ascii?Q?x5QUOI0AoSslonfMTKIU6727P4CSnyxuMeB2RE2ypfhzTP5Gvc0x2MMEZqwy?=
 =?us-ascii?Q?ZC/B76Irgp24c9OT/d7iDNkUhXSdVBYwPT76kk28yscmSo5Ecdyr0Th3+y2+?=
 =?us-ascii?Q?x88qKFUi8ZbTblcPuQRMxBLRbHzfARTsllx+QINWY6/THZlpKYdPEqF2Ru0R?=
 =?us-ascii?Q?rt9GVI/aVJ8JZNOp1kPHk/wlBtMlR/A3poN/VyPbzLIUK+5+skE7F/Z+CdTy?=
 =?us-ascii?Q?qaG9mHB8V2w06jsK7dh9dLbvTAkWWHQ34TnVoSP1zBt+aiN5QBCGPmwUYWyQ?=
 =?us-ascii?Q?5mmruplabUFUyXsw1OvvpsaAQKlMODeSZvZP4k9fTvqed2lMzuBgVrDbCcha?=
 =?us-ascii?Q?GFghqXDe02mdILr1xfZOHmKYh+L+2hkt5DGFm3rLknw7F6Ss7zdWnnSmtfc6?=
 =?us-ascii?Q?GfBrykUwcebW6KQ6sxf+eOi7QMNSBnTTDqXXkraINBzdZ6JCvsCWmAU7bTyv?=
 =?us-ascii?Q?gKAnazACKxTeLwKB6nAHC7E0hfQV/zqUYPiTvH8j0oHR5jN2NVEiqRljEZjJ?=
 =?us-ascii?Q?BghycOZy+k0T/EMQHRSTkcocz3QMMm+XGQkG89WzX6r049DCz5ZTBI3v7zg2?=
 =?us-ascii?Q?sPbb3cEKPPpkvWeEPSfPY5nlVDxSTeFTG8ptY2UXCOQrLj4xDg7qnmNeaScn?=
 =?us-ascii?Q?rUym6Ygb8pQ11Fz0Ewb8ya2F8ySk/AChG4wMtcBjIExDYREUWvbtKOwai64j?=
 =?us-ascii?Q?yR3yI6sWitjUwtH6eVtMOIwTYqoEs/EL5U/72kacuw4WAuci6GES3N3bvD0+?=
 =?us-ascii?Q?Qy1Qiok2IindhKALzO4kBSadUFugtSyxKcug5b5T3XWPdzNiCdFGgsgyQyIZ?=
 =?us-ascii?Q?Syj4lYBkTXd4TM5PamU5X8H9tolZGnMZ0rvW+LwiytMR5CLAFJPL0yz7a6l/?=
 =?us-ascii?Q?OxEEAlTb70E2ckVL1y9YKfT0cPDD2+Jo5dZwsml0Ayc4RCJo6q8njkpp8gqH?=
 =?us-ascii?Q?YJS/InJ0U/tWJcRMjYQNpRp+hLKehbmF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:52:07.1761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0442d3f-8e50-4f82-2a87-08dca7286e6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5934

Convert the same pages back to private that were converted to shared.

The test handles both 4K and 2M large pages depending on the order and
the page size specified.

While at it, make changes to pvalidate_pages() to not treat
PVALIDATE_FAIL_NOUPDATE as an error when converting the already private
pages as a part of cleanup process.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/amd_sev.c | 22 ++++++++++++++++------
 lib/x86/amd_sev.h |  3 ++-
 x86/amd_sev.c     | 23 +++++++++++++++++------
 3 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index e2f99bc8eded..c2f2a3f43193 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -347,7 +347,16 @@ enum es_result __sev_set_pages_state_msr_proto(unsigned long vaddr, int npages,
 	return ES_OK;
 }
 
-static void pvalidate_pages(struct snp_psc_desc *desc, unsigned long *vaddr_arr)
+static bool pvalidate_failed(int result, bool allow_noupdate)
+{
+	if (result && (!allow_noupdate || result != PVALIDATE_FAIL_NOUPDATE))
+		return true;
+
+	return false;
+}
+
+static void pvalidate_pages(struct snp_psc_desc *desc, unsigned long *vaddr_arr,
+			    bool allow_noupdate)
 {
 	struct psc_entry *entry;
 	int ret, i;
@@ -366,11 +375,11 @@ static void pvalidate_pages(struct snp_psc_desc *desc, unsigned long *vaddr_arr)
 
 			for (; vaddr < vaddr_end; vaddr += PAGE_SIZE) {
 				ret = pvalidate(vaddr, RMP_PG_SIZE_4K, validate);
-				if (ret)
+				if (pvalidate_failed(ret, allow_noupdate))
 					break;
 			}
 		}
-		assert(!ret);
+		assert(!pvalidate_failed(ret, allow_noupdate));
 	}
 }
 
@@ -466,7 +475,8 @@ static void add_psc_entry(struct snp_psc_desc *desc, u8 idx, u8 op, unsigned lon
 
 unsigned long __sev_set_pages_state(struct snp_psc_desc *desc, unsigned long vaddr,
 				    unsigned long vaddr_end, int op,
-				    struct ghcb *ghcb, bool large_entry)
+				    struct ghcb *ghcb, bool large_entry,
+				    bool allow_noupdate)
 {
 	unsigned long vaddr_arr[VMGEXIT_PSC_MAX_ENTRY];
 	int ret, iter = 0, iter2 = 0;
@@ -493,13 +503,13 @@ unsigned long __sev_set_pages_state(struct snp_psc_desc *desc, unsigned long vad
 	}
 
 	if (op == SNP_PAGE_STATE_SHARED)
-		pvalidate_pages(desc, vaddr_arr);
+		pvalidate_pages(desc, vaddr_arr, allow_noupdate);
 
 	ret = vmgexit_psc(desc, ghcb);
 	assert_msg(!ret, "VMGEXIT failed with ret value: %d", ret);
 
 	if (op == SNP_PAGE_STATE_PRIVATE)
-		pvalidate_pages(desc, vaddr_arr);
+		pvalidate_pages(desc, vaddr_arr, allow_noupdate);
 
 	for (iter2 = 0; iter2 < iter; iter2++) {
 		page_size = desc->entries[iter2].pagesize;
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index bf065ef613b7..e180a269fb63 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -244,7 +244,8 @@ enum es_result  __sev_set_pages_state_msr_proto(unsigned long vaddr,
 					        int npages, int operation);
 unsigned long __sev_set_pages_state(struct snp_psc_desc *desc, unsigned long vaddr,
 				    unsigned long vaddr_end, int op,
-				    struct ghcb *ghcb, bool large_entry);
+				    struct ghcb *ghcb, bool large_entry,
+				    bool allow_noupdate);
 void vc_ghcb_invalidate(struct ghcb *ghcb);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 15281835d0ef..12fe25dcdd0a 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -174,7 +174,7 @@ static int test_write(unsigned long vaddr, int npages)
 }
 
 static void sev_set_pages_state(unsigned long vaddr, int npages, int op,
-				struct ghcb *ghcb)
+				struct ghcb *ghcb, bool allow_noupdate)
 {
 	struct snp_psc_desc desc;
 	unsigned long vaddr_end;
@@ -188,17 +188,19 @@ static void sev_set_pages_state(unsigned long vaddr, int npages, int op,
 
 	while (vaddr < vaddr_end) {
 		vaddr = __sev_set_pages_state(&desc, vaddr, vaddr_end,
-					      op, ghcb, large_entry);
+					      op, ghcb, large_entry,
+					      allow_noupdate);
 	}
 }
 
 static void snp_free_pages(int order, int npages, unsigned long vaddr,
-			   struct ghcb *ghcb)
+			   struct ghcb *ghcb, bool allow_noupdate)
 {
 	set_pte_encrypted(vaddr, SEV_ALLOC_PAGE_COUNT);
 
 	/* Convert pages back to default guest-owned state */
-	sev_set_pages_state(vaddr, npages, SNP_PAGE_STATE_PRIVATE, ghcb);
+	sev_set_pages_state(vaddr, npages, SNP_PAGE_STATE_PRIVATE, ghcb,
+			    allow_noupdate);
 
 	/* Free all the associated physical pages */
 	free_pages_by_order((void *)pgtable_va_to_pa(vaddr), order);
@@ -268,7 +270,7 @@ static void test_sev_psc_ghcb_nae(void)
 	       "Expected page state: Private");
 
 	sev_set_pages_state(vaddr, SEV_ALLOC_PAGE_COUNT, SNP_PAGE_STATE_SHARED,
-			    ghcb);
+			    ghcb, false);
 
 	set_pte_decrypted(vaddr, SEV_ALLOC_PAGE_COUNT);
 
@@ -276,7 +278,16 @@ static void test_sev_psc_ghcb_nae(void)
 	       "Write to %d unencrypted 2M pages after private->shared conversion",
 	       (SEV_ALLOC_PAGE_COUNT) / (1 << ORDER_2M));
 
-	snp_free_pages(SEV_ALLOC_ORDER, SEV_ALLOC_PAGE_COUNT, vaddr, ghcb);
+	/* Convert pages from shared->private */
+	set_pte_encrypted(vaddr, SEV_ALLOC_PAGE_COUNT);
+
+	sev_set_pages_state(vaddr, SEV_ALLOC_PAGE_COUNT, SNP_PAGE_STATE_PRIVATE,
+			    ghcb, false);
+
+	report(is_validated_private_page(vaddr, RMP_PG_SIZE_2M),
+	       "Expected page state: Private");
+
+	snp_free_pages(SEV_ALLOC_ORDER, SEV_ALLOC_PAGE_COUNT, vaddr, ghcb, true);
 }
 
 int main(void)
-- 
2.34.1


