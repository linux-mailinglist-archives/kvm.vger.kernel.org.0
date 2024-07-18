Return-Path: <kvm+bounces-21842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C85934D7B
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9A121C229EE
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B669013C9CF;
	Thu, 18 Jul 2024 12:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EldbBecx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2077.outbound.protection.outlook.com [40.107.102.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0249613C669
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307121; cv=fail; b=O4Vy/C/qZBW/Byi5jhCzP5mhEUdXNGhayN+W8/CiMM890psvrenGAAPgFx9Og+Vq/DvWecRoFlXgDJz9aQjAtfdcRp0R27ZlJXOzBuElOFwtql460OTBl4ouAgwCq9IHAvVch8XDenmIeedQP+YaZjNkYxERqZInJhv3pgth7U0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307121; c=relaxed/simple;
	bh=FqciU3lm3vEsfcF/kgpoBgUUU98pFHbhhxqCZaC2sdY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHp3Tki+Oi49zQzGs+Ki1lAGWy45xXCzpJpbW5NWEUpoLCI1SQlhqmWhqEx8ROmpAG/xnInSyvG5Y+mMos+zEkvRYYpxiW868jwPqTjZepdKBrpNZVamhotLyiAe952h+HAXoMamUQ4RvUaOd5l8ETztb4hKD0nEOFFR75X678g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EldbBecx; arc=fail smtp.client-ip=40.107.102.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nFLwLrhQouQwkYK8v7bwZuN1/eMKzC91GQyzbayQG/KXNXHQxJWQQjts1a6WWGXK4swtzyfURI/67NSjFlya181EvWreEYZSKg5DEvfy++lEbyhwpZCjpalgGotCUVp7pHkftGfcZa7LUo0H/4MeUk9Ig0C/j55zeY04vFJnY+5FIKx24Uh6sDvclRP7PclAutwzEN4RjG0EjBRfcFXR+7eBsh6du3wnE6AB/K+ydAl+KGvlO38wn5Vcz3lqqo/eFggw9EaV6XwjrtihLsvBHP5NSCxLhkipl77F/Tj7BxvTEhzRi/XwPtNq2W01sn1f56fnvDk8Wt/bxq0uDlb5cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFwLcjD+oiNKYGb9ggHtwnnd8z2zN9F3Zb9lowGkePo=;
 b=mmc/bUmmOWLOIC4yufOfYBEbFxPDFCB7K6zHNAVjloEoTCI7EIUKOo0DWJFum9MyU7KvNaFttSai39Oyln6fUpkWq3vlgiWG4ns+DS7mrM5jxDz+v+BpCaTrlJ9jSjHllopzRFgRL4RhweLVYh2Vd+oXmOButMJhDvy3eLbf6bmJ+6IqQk/FdjR6zMTVvAdvdfqKNi5x8awXn+zDW928gEVwrRRjdA2rnBLSfNEf0f2yXegzYLWr7xqCHD9cALfvxuKk3/HWEjI8HmXhWMEiq9iWjWQ3/WNnFmVCRyY9/Z6sX8RXQrlJhhg/FX5VW+NUSAI4KOlJ+9hwbrCFwc/ZMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFwLcjD+oiNKYGb9ggHtwnnd8z2zN9F3Zb9lowGkePo=;
 b=EldbBecxi7n2AP4ZqsMDYmR5+wl/GYiEohrHvPLbZ052cbV9iLwLdJiRjNfLxil9OnmgtCrIVXmghGiAkypEtkRqOzfms5v6xuHyuQIaZm+30QoidCiIdCfwYb1LFhHMc6EXB0o3/phHz8V8neU6ydyFLRWQy0LuQayypakH2IM=
Received: from CH0PR13CA0033.namprd13.prod.outlook.com (2603:10b6:610:b2::8)
 by DS0PR12MB8341.namprd12.prod.outlook.com (2603:10b6:8:f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Thu, 18 Jul
 2024 12:51:55 +0000
Received: from CH3PEPF00000018.namprd21.prod.outlook.com
 (2603:10b6:610:b2:cafe::9e) by CH0PR13CA0033.outlook.office365.com
 (2603:10b6:610:b2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17 via Frontend
 Transport; Thu, 18 Jul 2024 12:51:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000018.mail.protection.outlook.com (10.167.244.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:51:54 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:51:54 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 11/16] x86 AMD SEV-SNP: Change guest pages from Private->Shared using GHCB NAE
Date: Thu, 18 Jul 2024 07:49:27 -0500
Message-ID: <20240718124932.114121-12-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000018:EE_|DS0PR12MB8341:EE_
X-MS-Office365-Filtering-Correlation-Id: b59e1ac9-cfd7-4357-111a-08dca7286720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yxt6Qih2RTHm/iq6ibJSW+86LM/mp1meNLTKQ7gFdXVnnFDrTcdic1Et5zRm?=
 =?us-ascii?Q?6FItZUjBaVopUJj/mHW7yWZZfvOjQXOoAlqBKDekIUtm9KbonlVT+sPowEep?=
 =?us-ascii?Q?LktYOOEGssWhas9NLDdvCjIkMr4C0QZ3afsi1y1ejapU4V8ZAkkuLef4bq3x?=
 =?us-ascii?Q?OC0Pfey9a+Qv7i6WwPXAGR3KjRZAONo6KA/G15vLnoPlCoukkgJUTeHKn6Fx?=
 =?us-ascii?Q?GMRtOv8TIaXR6ykRo7Sn4z23WQPZKaP/luxCWqVlLBDwUL5WpTSjr8TowvhP?=
 =?us-ascii?Q?b/97lalQ1aYoKbpIRYOnJ6Sg5OGHKiJ51HASGtqwLSz6BkAlNL5TI2kKLpfg?=
 =?us-ascii?Q?1ZhWi+H/t84QJMMy7eVeXmaGhTeMyTLCjK2+Vrzl5UAstt0Gh/V/CVaYwhmv?=
 =?us-ascii?Q?d4dmDWwVUReDSWpLQnR1My0rfw0kEELM6Wk2lgtFLYfF2hqkruI31EIqGa/F?=
 =?us-ascii?Q?GgcoGhU4Pns5uyo4UybfP8HpIQPbN8P9GIkwp2NiyQQ8HYMZLElE5Ttlo1ip?=
 =?us-ascii?Q?fS2cQhH9BCbuqIt3Riudv3KX277MlP7Z4ZYS695biE/Zd51OcFU9kmacBZk9?=
 =?us-ascii?Q?x6ajpXt5ViCgFK1EZMncDpu9Lk62TvOU8pPK9diP4C5RNTA42gheWsCdSYD7?=
 =?us-ascii?Q?NKh4XDDzVoezwVlddJoXcR1Girej7/fCYXjit7RNSaJTwbqgGWBUyzRuvCXZ?=
 =?us-ascii?Q?I86myCO1yBhAoqRP14NovIV6/eYgjf7Eli+6zR8z3jJ72uZZZT0V+UKD4dlv?=
 =?us-ascii?Q?3jVSSsvaZrH3qN/cyBYskSCWBLmZBntatcUILREeFVdI3pGUr56STohgQWHv?=
 =?us-ascii?Q?fCeSK/B4Wf/Ifn19Yw/U3/A3hd2E70ysbwRilzSxmus07QO3vQVNnElmLTeL?=
 =?us-ascii?Q?MvEG+C2XcHFdCjC+NHkbZ42Cn4foxEYHGigb3PEeJH/Ahp1c/juiZ8btIK3j?=
 =?us-ascii?Q?YBwz4KtSXkF+yg0QCVQR3y3VxfZ4xKfJUh9/XmAjmjgdGDM1LHBrdyeilDtU?=
 =?us-ascii?Q?miJfWgW4LPRr7gDIe3ot3EVeIvV5u0K7sV8bSkWA5heG9erueUv88Z6gsp2N?=
 =?us-ascii?Q?UL9yextyT9eP7yaA6dYzd3L2m44vs1B4Ias8QcOUlXWDh4tRuP0XsQL9tFCq?=
 =?us-ascii?Q?H0rg+ZHQOC8DGqhWLvibZVK4YPWKAG5fp5BOk7e4UQxO1lPmFjGlNQ4XNtsw?=
 =?us-ascii?Q?HgkuLJFIREEAznCitVrBgzHVgZSFz9LJTz/d4Mq1AFGQr9veAgtR+6lRSDXB?=
 =?us-ascii?Q?64mJSixl9jS1VoWWHzf5SP36IJQ9mhOyO0vsLBEIdpPFBy8POe0fsOYMt3uv?=
 =?us-ascii?Q?0XbewAk6ZOfA9cVxrlwVl3mIu6TTxUNzc2zOKdT1T3KwtC/QmLm6G/5sF2by?=
 =?us-ascii?Q?ypK310m5lbXwbH78Tx8j3AGqOk+fkEJoiepEq4gcSuddVz+HRFFWuqF+jj1s?=
 =?us-ascii?Q?h7iwSAvksXpuKPQrFwC1XCteBvIEAquI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:51:54.9515
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b59e1ac9-cfd7-4357-111a-08dca7286720
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000018.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8341

As mentioned in the GHCB spec (Section 4 GHCB protocol, Table-5 SNP page
state change), perform page state change conversions on a user inputted
number of pages from private to hypervisor-owned. The page state change
NAE event allows for SEV-SNP guest to request page state changes to
hypervisor using GHCB protocol.

The test handles both 4K pages and 2M large pages, depending on the
order specified and whether the address of the page is 2M aligned or
not. If 2M range is backed by a 4K page, 'pvalidate' fails with
FAIL_SIZEMISMATCH error. In such a case, the guest tries to pvalidate
all the 4K entries in this 2M range.

Conduct a test to re-validate the private page before conversion to
ensure PVALIDATE_FAIL_NOUPDATE is met, indicating that expected page
state is met. Then, perform the page state conversions, unset the C-bits
on these pages and write data to the shared guest pages post page state
conversions with C-bits unset appropriately to ensure pages are in
expected shared state.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/amd_sev.c    | 168 +++++++++++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h    |  27 +++++++
 lib/x86/amd_sev_vc.c |   2 +-
 lib/x86/svm.h        |   1 +
 lib/x86/vm.c         |  26 +++++++
 lib/x86/vm.h         |   1 +
 x86/amd_sev.c        |  78 +++++++++++++++++++-
 7 files changed, 301 insertions(+), 2 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 5cbdeb35bba8..e2f99bc8eded 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -346,3 +346,171 @@ enum es_result __sev_set_pages_state_msr_proto(unsigned long vaddr, int npages,
 
 	return ES_OK;
 }
+
+static void pvalidate_pages(struct snp_psc_desc *desc, unsigned long *vaddr_arr)
+{
+	struct psc_entry *entry;
+	int ret, i;
+	unsigned long vaddr;
+	bool validate;
+
+	for (i = 0; i <= desc->hdr.end_entry; i++) {
+		vaddr = vaddr_arr[i];
+		entry = &desc->entries[i];
+		validate = entry->operation == SNP_PAGE_STATE_PRIVATE ? true : false;
+
+		ret = pvalidate(vaddr, entry->pagesize, validate);
+		if (ret == PVALIDATE_FAIL_SIZEMISMATCH) {
+			assert(entry->pagesize == RMP_PG_SIZE_2M);
+			unsigned long vaddr_end = vaddr + LARGE_PAGE_SIZE;
+
+			for (; vaddr < vaddr_end; vaddr += PAGE_SIZE) {
+				ret = pvalidate(vaddr, RMP_PG_SIZE_4K, validate);
+				if (ret)
+					break;
+			}
+		}
+		assert(!ret);
+	}
+}
+
+static int verify_exception(struct ghcb *ghcb)
+{
+	return ghcb->save.sw_exit_info_1 & GENMASK_ULL(31, 0);
+}
+
+static int sev_ghcb_hv_call(struct ghcb *ghcb, u64 exit_code,
+			    u64 exit_info_1, u64 exit_info_2)
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
+	/* Ensure end_entry is within bounds */
+	assert(desc->hdr.end_entry < VMGEXIT_PSC_MAX_ENTRY);
+
+	vc_ghcb_invalidate(ghcb);
+
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
+		if (ret) {
+			report_info("SNP: PSC failed with ret: %d\n", ret);
+			ret = 1;
+			break;
+		}
+
+		if (cur_entry > data->hdr.cur_entry) {
+			report_info("SNP: PSC processing going backward, cur_entry %d (got %d)\n",
+				    cur_entry, data->hdr.cur_entry);
+			ret = 1;
+			break;
+		}
+
+		if (data->hdr.end_entry != end_entry) {
+			report_info("End entry mismatch: end_entry %d (got %d)\n",
+				    end_entry, data->hdr.end_entry);
+			ret = 1;
+			break;
+		}
+
+		if (data->hdr.reserved) {
+			report_info("Reserved bit is set in the PSC header\n");
+			ret = 1;
+			break;
+		}
+	}
+
+	/* Copy the output in shared buffer back to desc */
+	memcpy(desc, ghcb->shared_buffer, GHCB_SHARED_BUF_SIZE);
+
+	return ret;
+}
+
+static void add_psc_entry(struct snp_psc_desc *desc, u8 idx, u8 op, unsigned long vaddr,
+			  bool large_entry, u16 cur_page_offset)
+{
+	struct psc_hdr *hdr = &desc->hdr;
+	struct psc_entry *entry = &desc->entries[idx];
+
+	assert_msg(!large_entry || IS_ALIGNED(vaddr, LARGE_PAGE_SIZE),
+		   "Must use 2M-aligned addresses for large PSC entries");
+
+	entry->gfn = pgtable_va_to_pa(vaddr) >> PAGE_SHIFT;
+	entry->operation = op;
+	entry->pagesize = large_entry;
+	entry->cur_page = cur_page_offset;
+	hdr->end_entry = idx;
+}
+
+unsigned long __sev_set_pages_state(struct snp_psc_desc *desc, unsigned long vaddr,
+				    unsigned long vaddr_end, int op,
+				    struct ghcb *ghcb, bool large_entry)
+{
+	unsigned long vaddr_arr[VMGEXIT_PSC_MAX_ENTRY];
+	int ret, iter = 0, iter2 = 0;
+	u8 page_size;
+
+	memset(desc, 0, sizeof(*desc));
+
+	report_info("%s: address start %lx end %lx op %d large %d",
+		    __func__, vaddr, vaddr_end, op, large_entry);
+
+	while (vaddr < vaddr_end && iter < ARRAY_SIZE(desc->entries)) {
+		vaddr_arr[iter] = vaddr;
+
+		if (large_entry && IS_ALIGNED(vaddr, LARGE_PAGE_SIZE) &&
+		    (vaddr_end - vaddr) >= LARGE_PAGE_SIZE) {
+			add_psc_entry(desc, iter, op, vaddr, true, 0);
+			vaddr += LARGE_PAGE_SIZE;
+		} else {
+			add_psc_entry(desc, iter, op, vaddr, false, 0);
+			vaddr += PAGE_SIZE;
+		}
+
+		iter++;
+	}
+
+	if (op == SNP_PAGE_STATE_SHARED)
+		pvalidate_pages(desc, vaddr_arr);
+
+	ret = vmgexit_psc(desc, ghcb);
+	assert_msg(!ret, "VMGEXIT failed with ret value: %d", ret);
+
+	if (op == SNP_PAGE_STATE_PRIVATE)
+		pvalidate_pages(desc, vaddr_arr);
+
+	for (iter2 = 0; iter2 < iter; iter2++) {
+		page_size = desc->entries[iter2].pagesize;
+
+		if (page_size == RMP_PG_SIZE_2M)
+			assert_msg(desc->entries[iter2].cur_page == 512,
+				   "Failed to process sub-entries within 2M range");
+		else if (page_size == RMP_PG_SIZE_4K)
+			assert_msg(desc->entries[iter2].cur_page == 1,
+				   "Failed to process 4K entry");
+	}
+
+	return vaddr;
+}
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 04c569be57eb..bf065ef613b7 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -208,6 +208,29 @@ enum psc_op {
 	/* GHCBData[63:32] */					\
 	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
 
+struct psc_hdr {
+	u16 cur_entry;
+	u16 end_entry;
+	u32 reserved;
+};
+
+struct psc_entry {
+	u64 cur_page	: 12,
+	    gfn		: 40,
+	    operation	: 4,
+	    pagesize	: 1,
+	    reserved	: 7;
+};
+
+#define VMGEXIT_PSC_MAX_ENTRY					\
+	((GHCB_SHARED_BUF_SIZE - sizeof(struct psc_hdr)) /	\
+	 sizeof(struct psc_entry))
+
+struct snp_psc_desc {
+	struct psc_hdr hdr;
+	struct psc_entry entries[VMGEXIT_PSC_MAX_ENTRY];
+};
+
 bool amd_sev_es_enabled(void);
 efi_status_t setup_vc_handler(void);
 bool amd_sev_snp_enabled(void);
@@ -219,6 +242,10 @@ void set_pte_encrypted(unsigned long vaddr, int npages);
 bool is_validated_private_page(unsigned long vaddr, bool rmp_size);
 enum es_result  __sev_set_pages_state_msr_proto(unsigned long vaddr,
 					        int npages, int operation);
+unsigned long __sev_set_pages_state(struct snp_psc_desc *desc, unsigned long vaddr,
+				    unsigned long vaddr_end, int op,
+				    struct ghcb *ghcb, bool large_entry);
+void vc_ghcb_invalidate(struct ghcb *ghcb);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 77892edd4678..cdbd7c0bc39c 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -11,7 +11,7 @@
 
 extern phys_addr_t ghcb_addr;
 
-static void vc_ghcb_invalidate(struct ghcb *ghcb)
+void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
 	ghcb->save.sw_exit_code = 0;
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
diff --git a/lib/x86/svm.h b/lib/x86/svm.h
index e0aafe80a290..77061c0a1980 100644
--- a/lib/x86/svm.h
+++ b/lib/x86/svm.h
@@ -372,6 +372,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXIT_NPF  		0x400
 
 #define SVM_EXIT_ERR		-1
+#define SVM_VMGEXIT_PSC		0x80000010
 
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index cfca452bb110..3547a1c26869 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -370,3 +370,29 @@ unsigned long pgtable_va_to_pa(unsigned long va)
 
 	__builtin_unreachable();
 }
+
+void *vmalloc_pages(int num_pages, int order, bool large_page)
+{
+	unsigned long length = num_pages * PAGE_SIZE;
+	pgd_t *cr3 = (pgd_t *)read_cr3();
+	void *vaddr, *paddr;
+
+	/* Allocate physical pages */
+	paddr = alloc_pages(order);
+	assert(paddr);
+
+	/* Allocate virtual pages */
+	vaddr = alloc_vpages_aligned(num_pages, large_page ? ORDER_2M : ORDER_4K);
+	assert(vaddr);
+
+	/*
+	 * Create pagetable entries that map the newly assigned virtual
+	 * pages to physical pages
+	 */
+	if (!large_page)
+		install_pages(cr3, __pa(paddr), length, vaddr);
+	else
+		install_large_pages(cr3, __pa(paddr), length, vaddr);
+
+	return vaddr;
+}
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index 0216ea1f37f9..dc77d3fcaa1c 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -61,6 +61,7 @@ static inline void *current_page_table(void)
 void split_large_page(unsigned long *ptep, int level);
 void force_4k_page(void *addr);
 unsigned long pgtable_va_to_pa(unsigned long vaddr);
+void *vmalloc_pages(int num_pages, int order, bool large_page);
 
 struct vm_vcpu_info {
         u64 cr3;
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 3b1593e42634..15281835d0ef 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -173,6 +173,37 @@ static int test_write(unsigned long vaddr, int npages)
 	return 0;
 }
 
+static void sev_set_pages_state(unsigned long vaddr, int npages, int op,
+				struct ghcb *ghcb)
+{
+	struct snp_psc_desc desc;
+	unsigned long vaddr_end;
+	bool large_entry;
+
+	vaddr &= PAGE_MASK;
+	vaddr_end = vaddr + (npages << PAGE_SHIFT);
+
+	if (IS_ALIGNED(vaddr, LARGE_PAGE_SIZE))
+		large_entry = true;
+
+	while (vaddr < vaddr_end) {
+		vaddr = __sev_set_pages_state(&desc, vaddr, vaddr_end,
+					      op, ghcb, large_entry);
+	}
+}
+
+static void snp_free_pages(int order, int npages, unsigned long vaddr,
+			   struct ghcb *ghcb)
+{
+	set_pte_encrypted(vaddr, SEV_ALLOC_PAGE_COUNT);
+
+	/* Convert pages back to default guest-owned state */
+	sev_set_pages_state(vaddr, npages, SNP_PAGE_STATE_PRIVATE, ghcb);
+
+	/* Free all the associated physical pages */
+	free_pages_by_order((void *)pgtable_va_to_pa(vaddr), order);
+}
+
 static void test_sev_psc_ghcb_msr(void)
 {
 	void *vaddr;
@@ -210,6 +241,44 @@ static void test_sev_psc_ghcb_msr(void)
 	free_pages_by_order(vaddr, SEV_ALLOC_ORDER);
 }
 
+static void init_vpages(void)
+{
+	/*
+	 * alloc_vpages_aligned() allocates contiguous virtual
+	 * pages that grow downward from vfree_top, 0, and this is
+	 * problematic for SNP related PSC tests because
+	 * vaddr < vaddr_end using unsigned values causes an issue
+	 * (vaddr_end is 0x0). To avoid this, allocate a dummy virtual
+	 * page.
+	 */
+	alloc_vpages_aligned(1, 0);
+}
+
+static void test_sev_psc_ghcb_nae(void)
+{
+	unsigned long vaddr;
+	struct ghcb *ghcb = (struct ghcb *)rdmsr(SEV_ES_GHCB_MSR_INDEX);
+
+	report_info("TEST: GHCB Protocol based page state change test");
+
+	vaddr = (unsigned long)vmalloc_pages(SEV_ALLOC_PAGE_COUNT,
+					     SEV_ALLOC_ORDER, RMP_PG_SIZE_2M);
+
+	report(is_validated_private_page(vaddr, RMP_PG_SIZE_2M),
+	       "Expected page state: Private");
+
+	sev_set_pages_state(vaddr, SEV_ALLOC_PAGE_COUNT, SNP_PAGE_STATE_SHARED,
+			    ghcb);
+
+	set_pte_decrypted(vaddr, SEV_ALLOC_PAGE_COUNT);
+
+	report(!test_write((unsigned long)vaddr, SEV_ALLOC_PAGE_COUNT),
+	       "Write to %d unencrypted 2M pages after private->shared conversion",
+	       (SEV_ALLOC_PAGE_COUNT) / (1 << ORDER_2M));
+
+	snp_free_pages(SEV_ALLOC_ORDER, SEV_ALLOC_PAGE_COUNT, vaddr, ghcb);
+}
+
 int main(void)
 {
 	int rtn;
@@ -221,8 +290,15 @@ int main(void)
 
 	/* Setup a new page table via setup_vm() */
 	setup_vm();
-	if (amd_sev_snp_enabled())
+	if (amd_sev_snp_enabled()) {
+		/*
+		 * call init_vpages() before running any of SEV-SNP
+		 * related PSC tests.
+		 */
+		init_vpages();
 		test_sev_psc_ghcb_msr();
+		test_sev_psc_ghcb_nae();
+	}
 
 	return report_summary();
 }
-- 
2.34.1


