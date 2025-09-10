Return-Path: <kvm+bounces-57261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EEBFB5244E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 00:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E76F1C28192
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 22:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B3130EF8F;
	Wed, 10 Sep 2025 22:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F529pb4U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE0A306493;
	Wed, 10 Sep 2025 22:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757544965; cv=fail; b=ujcwOTgt4LnBQ7vtUKoTB2FEZoj/GK9OYc9OJwAiTSoqW6tToqS5G1grPGGYNJpBgHHEcK0uoWnSuSuf0m9ZNsdmGINiApE7AisUxIXJrdsu9nTKRv6upzbynXMjkUDlPX3KMkErqQvpaY4kGfALtZyP/dotmfgasphoRvRQlnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757544965; c=relaxed/simple;
	bh=gi0kF1fuH4wGGyXFA6WkV+0V5VHQbPPTBI4XmZeEAn0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EJKln7Wyi25gpa8ikN93+JD9oaGBOk1KLMCcYwng6P5dbStWbpC2E9p/KRh22pK/TTabQqnnnGKqrFvIej98tvq6ZJlSfq8EezR61wSfrm7eAEXpG1VwoUpMx0bVR0nmvdfiAzBpYFaCevxVplh1shD5xkZSEu1OqJ+m8L9QTx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F529pb4U; arc=fail smtp.client-ip=40.107.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjjwS160Xq/IzMGHjt+/7Ayi7+ZZ6/5Nk9RQ7gdNeCBG6Zzh6kmwEPfmA27FhtaNOgakmpepgReRXhH53suf0e/9BZ8TNHNCVR1K8M71XvfOZ6UJHs7CUrp2XgRRUt4Yp1QpmQX7HmxAoVxUqN5qqd6iX2s9hXMIg9H7A41DQGvHkbzhKpHfBffrYrnEUejJrkvuqbIOfdn3fO36jqp2Q/GOkf8Tykw5cOKqOCuxPuNSjA8qNqTYG1V8xeGCZ/Z4A13oJuNEBzkjsbPS1V8Erf0M+lBqMZwyY4FFKtjXEGq9fifAliQU28lA5w2zziyO7qqBEhb/VfgYGsISfgMTAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbHb0bUefiGZ6Ro6A9rpsOyP85vAbqTM80SNLf5nflo=;
 b=F2EJBTbDvKgdFWDb3Zlgdp/7DA6Vzql+Z4ZzaTJ6h9bPPsm3W5UhrnHZvPlZtyIWpt5A68ArGmmEicAQ+d5E8H0H5S1Z6+8YHxs6aCNP+CLaR/Im02A5RLJC2BKeZhMR9B77OWdqw/cixygAXnRVa8L6A274yjgq3d8E18sL0sCXnbF9k6eFiw1Y1+Y6i7zBoCCVoZt+++X1WuTNueyZ79eyCVgFt+dmG9nwJH2FdhU47PY5x9j+KP3qC+DdCyK1AKFPv/oS6qV4I9dlr/tVB8p3BkFRs7az0uTA7f6cqgCZuV9SGU0EdVflVpBfxM0HYfu7hS3z1i8KzUA9uLlbIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dbHb0bUefiGZ6Ro6A9rpsOyP85vAbqTM80SNLf5nflo=;
 b=F529pb4UyOeAvk0nlNsc9g0UdgnouAzjDaXS86m8Uh9NICzRAUDqY7CIZgdG8s2WUAIZFfXI5/vx/z5Bl0uabS5zJEdSBpx9za/5q90ubwxSQGA271XHiM0EvaTog2/TTASSYJvJ1SgPqm95oVacWw5clCmgifAdFXuU/0qIbyg=
Received: from MN2PR18CA0020.namprd18.prod.outlook.com (2603:10b6:208:23c::25)
 by DS4PR12MB9587.namprd12.prod.outlook.com (2603:10b6:8:282::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 22:55:57 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:208:23c:cafe::4) by MN2PR18CA0020.outlook.office365.com
 (2603:10b6:208:23c::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.16 via Frontend Transport; Wed,
 10 Sep 2025 22:55:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 22:55:57 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 15:55:49 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v4 2/3] crypto: ccp - Add new HV-Fixed page allocation/free API.
Date: Wed, 10 Sep 2025 22:55:40 +0000
Message-ID: <e7807012187bdda8d76ab408b87f15631461993d.1757543774.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757543774.git.ashish.kalra@amd.com>
References: <cover.1757543774.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|DS4PR12MB9587:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aa13753-1ff3-4460-e249-08ddf0bd3458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wzpmidvMNJXO80EtU/SK1AQtQtNrGHVDQUT1GSexNVZcdQovg40EgPALeTR4?=
 =?us-ascii?Q?EvX/b/ILcQtqYkwjYNqydKfcp9GmjZ8dISMcAeyC6nHgg8LfNpKNDVVbGZqu?=
 =?us-ascii?Q?SDrnLyaKV1OQPL7efuDzpYtTFgm8H9OqCkLBRwFqL4eUQ1zRS29yn3BhcliY?=
 =?us-ascii?Q?8iBRq5inhsszTKT2Xcn1iLlIzHGWnqNbSt1qpHvVgSBSCMmKC7yDnFPiBEGx?=
 =?us-ascii?Q?vQWfR4mv1mOEKxOv0PoX+BBrvxPMqORahxUbPTx2qFffU5unCMBv5BRjMuXy?=
 =?us-ascii?Q?3NlAD39g9MTtCIDbmWDSuQN0XkVCM1ph/nQLjcP4bDf5+yjIDN2ZTvpzAQpH?=
 =?us-ascii?Q?X87H7JKMABGVzgBY7s0LaS3Y58x60wMUl3PuqYptsnYYkpNK/utKtM1Cc0bw?=
 =?us-ascii?Q?wkWMucaQyHccZ1pvhy65ymHaxRJiGWYydDCbyP5OW3WNJ2YB+4/FLDqzanMC?=
 =?us-ascii?Q?6y7vMywltnlNsXUh2Lvpt1RErtjMGTaaZ0yL/myz+FNzSq3RQK8YLe0we7KA?=
 =?us-ascii?Q?o/D6eS6EJV91vmpgnwOLYLQ2Ba5xEU8fhhWQJ4Qi1mJ5wWfyUnJ6IW+Mo0xZ?=
 =?us-ascii?Q?M8oeFw7IEBMACAyYae0XiHmmJrsXxEWcU0QVLuZzNbuEcnYulfYEcMcBlfBJ?=
 =?us-ascii?Q?46Y6Xgwz8DwbnpnYoygd1fQ4+OkWGZVKUyDeThhg5W6wAG3IRMIxHWKFlcXN?=
 =?us-ascii?Q?97IW1/LUMov5qc66BCIXfDklDr8qMFDH/hbz14mheHtByeE+7nrsA7W81+Qj?=
 =?us-ascii?Q?DnDC15xq3D9roN0j9ICXsSv6vLPnBTLxJ+TjA1JXVbiuPzle7MudZ34t7zfQ?=
 =?us-ascii?Q?QkyDYLibS+Cf45xgtTinODmeMiqj07xcUsL1dlHW3dJpzvvkEtgmsb/RmX70?=
 =?us-ascii?Q?DWK1zIvErOYV0RFzBgx+WpnrqIgg2pQjXyVfK/W9VPPDQI4CvYqPFc2wNmEr?=
 =?us-ascii?Q?UtsMj7O9YcaN8UHNFld1UBaQw1myAw5gM9rwFuusyk5UA6ebYrkA39pLJXkV?=
 =?us-ascii?Q?FfMKFR0qLQC18hEoyDMCIJRTjvQNlW9jpiyk15IwSixG/2DYWjgteiosX38N?=
 =?us-ascii?Q?DjfO1vT0fqLO2lWmxDn04xUgC7zH6AFzaj6/749Toebkz+bi9vTTlk//JNuj?=
 =?us-ascii?Q?SfIsjJMxBlq6KkmJ+6hYkShcVkt6yGu7+qCkS3m16lLvcssdveHtgFWe5vQE?=
 =?us-ascii?Q?mPT5UDvN52PC3zy5tvNSvT45meBy50B81OePD7FFW+iML1Ksku2azrYQL9X+?=
 =?us-ascii?Q?N0XEfpmU+WTHyvrwrJ5kUEjVV+4Tr06WrhD7A+o0mvJBmz1WcfadOypT8JFZ?=
 =?us-ascii?Q?JoF3FWgN92PhM6/VogJFn7Cu6lYLATLwRvyPTiZbpvKd08mHsJGozjWrde54?=
 =?us-ascii?Q?FYQEmeXEYZysn/zUMoexyZbcbqVb4nZW0wQg9mKZ+T8hzK1ZwJnX+EIPscUq?=
 =?us-ascii?Q?LBvqk0TQv+1h6vBp+sJup1LtaqL63bfpD8opxZ3f0my6oABuxyKJT3nRAEWq?=
 =?us-ascii?Q?DMzyRC1ui2XefCmOIEZa9+uEKlDnClNdgw49bk5/lqUWSVqmfAVvhReqnw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 22:55:57.3758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa13753-1ff3-4460-e249-08ddf0bd3458
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9587

From: Ashish Kalra <ashish.kalra@amd.com>

When SEV-SNP is active, the TEE extended command header page and
all output buffers for TEE extended commands (such as used by Seamless
Firmware servicing support) must be in hypervisor-fixed state,
assigned to the hypervisor and marked immutable in the RMP entrie(s).

Add a new generic SEV API interface to allocate/free hypervisor fixed
pages which abstracts hypervisor fixed page allocation/free for PSP
sub devices. The API internally uses SNP_INIT_EX to transition pages
to HV-Fixed page state.

If SNP is not enabled then the allocator is simply a wrapper over
alloc_pages() and __free_pages().

When the sub device free the pages, they are put on a free list
and future allocation requests will try to re-use the freed pages from
this list. But this list is not preserved across PSP driver load/unload
hence this free/reuse support is only supported while PSP driver is
loaded. As HV_FIXED page state is only changed at reboot, these pages
are leaked as they cannot be returned back to the page allocator and
then potentially allocated to guests, which will cause SEV-SNP guests
to fail to start or terminate when accessing the HV_FIXED page.

Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 182 +++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |   3 +
 2 files changed, 185 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9e797cbdf038..2300673c6683 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -83,6 +83,21 @@ MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
 static bool psp_dead;
 static int psp_timeout;
 
+enum snp_hv_fixed_pages_state {
+	ALLOCATED,
+	HV_FIXED,
+};
+
+struct snp_hv_fixed_pages_entry {
+	struct list_head list;
+	struct page *page;
+	unsigned int order;
+	bool free;
+	enum snp_hv_fixed_pages_state page_state;
+};
+
+static LIST_HEAD(snp_hv_fixed_pages);
+
 /* Trusted Memory Region (TMR):
  *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
  *   to allocate the memory, which will return aligned memory for the specified
@@ -1158,6 +1173,165 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 	return rc;
 }
 
+/* Hypervisor Fixed pages API interface */
+static void snp_hv_fixed_pages_state_update(struct sev_device *sev,
+					    enum snp_hv_fixed_pages_state page_state)
+{
+	struct snp_hv_fixed_pages_entry *entry;
+
+	/* List is protected by sev_cmd_mutex */
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	if (list_empty(&snp_hv_fixed_pages))
+		return;
+
+	list_for_each_entry(entry, &snp_hv_fixed_pages, list)
+		entry->page_state = page_state;
+}
+
+/*
+ * Allocate HV_FIXED pages in 2MB aligned sizes to ensure the whole
+ * 2MB pages are marked as HV_FIXED.
+ */
+struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages)
+{
+	struct psp_device *psp_master = psp_get_master_device();
+	struct snp_hv_fixed_pages_entry *entry;
+	struct sev_device *sev;
+	unsigned int order;
+	struct page *page;
+
+	if (!psp_master || !psp_master->sev_data)
+		return NULL;
+
+	sev = psp_master->sev_data;
+
+	order = get_order(PMD_SIZE * num_2mb_pages);
+
+	/*
+	 * SNP_INIT_EX is protected by sev_cmd_mutex, therefore this list
+	 * also needs to be protected using the same mutex.
+	 */
+	guard(mutex)(&sev_cmd_mutex);
+
+	/*
+	 * This API uses SNP_INIT_EX to transition allocated pages to HV_Fixed
+	 * page state, fail if SNP is already initialized.
+	 */
+	if (sev->snp_initialized)
+		return NULL;
+
+	/* Re-use freed pages that match the request */
+	list_for_each_entry(entry, &snp_hv_fixed_pages, list) {
+		/* Hypervisor fixed page allocator implements exact fit policy */
+		if (entry->order == order && entry->free) {
+			entry->free = false;
+			memset(page_address(entry->page), 0,
+			       (1 << entry->order) * PAGE_SIZE);
+			return entry->page;
+		}
+	}
+
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	if (!page)
+		return NULL;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		__free_pages(page, order);
+		return NULL;
+	}
+
+	entry->page = page;
+	entry->order = order;
+	list_add_tail(&entry->list, &snp_hv_fixed_pages);
+
+	return page;
+}
+
+void snp_free_hv_fixed_pages(struct page *page)
+{
+	struct psp_device *psp_master = psp_get_master_device();
+	struct snp_hv_fixed_pages_entry *entry, *nentry;
+
+	if (!psp_master || !psp_master->sev_data)
+		return;
+
+	/*
+	 * SNP_INIT_EX is protected by sev_cmd_mutex, therefore this list
+	 * also needs to be protected using the same mutex.
+	 */
+	guard(mutex)(&sev_cmd_mutex);
+
+	list_for_each_entry_safe(entry, nentry, &snp_hv_fixed_pages, list) {
+		if (entry->page != page)
+			continue;
+
+		/*
+		 * HV_FIXED page state cannot be changed until reboot
+		 * and they cannot be used by an SNP guest, so they cannot
+		 * be returned back to the page allocator.
+		 * Mark the pages as free internally to allow possible re-use.
+		 */
+		if (entry->page_state == HV_FIXED) {
+			entry->free = true;
+		} else {
+			__free_pages(page, entry->order);
+			list_del(&entry->list);
+			kfree(entry);
+		}
+		return;
+	}
+}
+
+static void snp_add_hv_fixed_pages(struct sev_device *sev, struct sev_data_range_list *range_list)
+{
+	struct snp_hv_fixed_pages_entry *entry;
+	struct sev_data_range *range;
+	int num_elements;
+
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	if (list_empty(&snp_hv_fixed_pages))
+		return;
+
+	num_elements = list_count_nodes(&snp_hv_fixed_pages) +
+		       range_list->num_elements;
+
+	/*
+	 * Ensure the list of HV_FIXED pages that will be passed to firmware
+	 * do not exceed the page-sized argument buffer.
+	 */
+	if (num_elements * sizeof(*range) + sizeof(*range_list) > PAGE_SIZE) {
+		dev_warn(sev->dev, "Additional HV_Fixed pages cannot be accommodated, omitting\n");
+		return;
+	}
+
+	range = &range_list->ranges[range_list->num_elements];
+	list_for_each_entry(entry, &snp_hv_fixed_pages, list) {
+		range->base = page_to_pfn(entry->page) << PAGE_SHIFT;
+		range->page_count = 1 << entry->order;
+		range++;
+	}
+	range_list->num_elements = num_elements;
+}
+
+static void snp_leak_hv_fixed_pages(void)
+{
+	struct snp_hv_fixed_pages_entry *entry;
+
+	/* List is protected by sev_cmd_mutex */
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	if (list_empty(&snp_hv_fixed_pages))
+		return;
+
+	list_for_each_entry(entry, &snp_hv_fixed_pages, list)
+		if (entry->page_state == HV_FIXED)
+			__snp_leak_pages(page_to_pfn(entry->page),
+					 1 << entry->order, false);
+}
+
 static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 {
 	struct sev_data_range_list *range_list = arg;
@@ -1248,6 +1422,12 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 			return rc;
 		}
 
+		/*
+		 * Add HV_Fixed pages from other PSP sub-devices, such as SFS to the
+		 * HV_Fixed page list.
+		 */
+		snp_add_hv_fixed_pages(sev, snp_range_list);
+
 		memset(&data, 0, sizeof(data));
 
 		if (max_snp_asid) {
@@ -1293,6 +1473,7 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return rc;
 	}
 
+	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
@@ -1896,6 +2077,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 		return ret;
 	}
 
+	snp_leak_hv_fixed_pages();
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 5aed2595c9ae..ac03bd0848f7 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -69,4 +69,7 @@ void sev_dev_destroy(struct psp_device *psp);
 void sev_pci_init(void);
 void sev_pci_exit(void);
 
+struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages);
+void snp_free_hv_fixed_pages(struct page *page);
+
 #endif /* __SEV_DEV_H */
-- 
2.34.1


