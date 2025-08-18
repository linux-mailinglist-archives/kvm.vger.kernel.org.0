Return-Path: <kvm+bounces-54914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A71B2B240
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73F527AFED8
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD7C157A48;
	Mon, 18 Aug 2025 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rWkHsFtw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C233451CE;
	Mon, 18 Aug 2025 20:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548339; cv=fail; b=RsCtLnlfn4yees6ZIpG0/nTPw3JJZID7Vph+ZuJLFb1lChyjwspXtiBhccJ0hK0v2a+svBCuh/lLFENYu+pUS3OA0ZXpKl38iLtHBlWSvrB/kr7qk4vp6jmuyKRVeMdqTzN5wzIQBezteqPGSsd8USklBQq5D/kyuxP3hKI2n1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548339; c=relaxed/simple;
	bh=qlIkYOkCYEjcKogxRP5oGXBvcFUEtGJQuxhp9pJE638=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lldGH/esPnMsuTKVoscNR+Kdlquw7pgPA7v84+RH4MxAKQqYXlmzhdLq4bxczlNyXc40cmCrpxGnLbbKO6jvQHfbf9YymjvBgXnxLz8354oin4bdGdj1dsICRb6vU6X4Qxtp+RZtHLGA4gaLn5e/pwdBJAuhNjIX9TnobgbgsSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rWkHsFtw; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ViWe4HWFXqfOhJisvZju5js8VTqMObPPNtaAFRMOq2n2mCkY16YP/uxpB0ixXc+zAPhsuo9WOVDQdKN45jWtv9C+8ppIbr1S6QkJnCZYLTEBaNIWU73LHJet+TD04BkQQACiAtxrKIER6ABP1XZRDfWJxhDeWz+VOUwrepI9ZA05B8SmMWy0qhZ+XhRKI47BP3MzgWvZiiSUv+lVJK4qUV2Con8e9FHWQX6G4SzH3VK7ewKCEaWmQAbDB2ducG1RjM5/rTfBDz6aRYLn70IgI9h0795tCe87NHLcP8NUgrTPLu7yuYyrEODFk4VePlI9UpdwZrISRVFxByKOwbIP1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sh+7RxIA38KPF88P6S1XVSbECY7dF8T8T+eGHJm4/4c=;
 b=x2KGha68iCf+ZZo3vj+IwkPqxXubdc5K7kUT6VG3lQh6cqvwjw0mRpAW3846sR8yvGJGawYQ1x76xbHvp9AvBrmHGUZqEGPmRRMLb9H826bVaJmubSmXsoThGcp2KmlZclleLct1P+EsybzfTxMn9dowvbCNTcX0TA2TWIw8H0xhDvgWiomiIJ4OBh//L2k7s14Lh3gONIurNjgTdjSPAreQYUs3gGZ7HT50uhaapZgqr+E4SXWZfodc9Xp1H11L5CIVSwsLYJKkc8TkTj5n/dQQiIMTUh83JbrqG9PmW+YFMvNzEeAwX7LXfoWuFcri3m4iP8kIyfXduh9ciLW1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sh+7RxIA38KPF88P6S1XVSbECY7dF8T8T+eGHJm4/4c=;
 b=rWkHsFtwSNMgMTKpBul23bsqAeQVy6LModwt64kvzSnaEBMnDv429gVkWPJBWANmqLxX3fKwCa+BwsRsZ5IPFQ4SsuVNWadj7tb/HeNqUjVC+wI6NAb7yE5YeqXmW2c9yU4L8wUald9wypSqz/bkn9hlWApszZiYACShPuHtSfU=
Received: from BLAPR03CA0130.namprd03.prod.outlook.com (2603:10b6:208:32e::15)
 by MW5PR12MB5600.namprd12.prod.outlook.com (2603:10b6:303:195::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 20:18:54 +0000
Received: from BN2PEPF0000449D.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::d5) by BLAPR03CA0130.outlook.office365.com
 (2603:10b6:208:32e::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.21 via Frontend Transport; Mon,
 18 Aug 2025 20:18:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449D.mail.protection.outlook.com (10.167.243.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 20:18:52 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 15:18:51 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [RESEND PATCH v2 2/3] crypto: ccp - Add new HV-Fixed page allocation/free API.
Date: Mon, 18 Aug 2025 20:18:42 +0000
Message-ID: <1dbc6382373e9fe1124be6acab23ecdd7fc7629b.1755548015.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755548015.git.ashish.kalra@amd.com>
References: <cover.1755548015.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449D:EE_|MW5PR12MB5600:EE_
X-MS-Office365-Filtering-Correlation-Id: 863c9ada-5495-4c26-ff5c-08ddde947370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WVTWFOsJxjOkABTGebtcWwGrXxI27SNA5bcmRy26LnPAxqUuI1etkx/7CYwm?=
 =?us-ascii?Q?yTH+s27+87Fg8k008qrfRbGXBqZbiRjpzGqPNRHmfjA12zt1wmRPhkv9VKUr?=
 =?us-ascii?Q?0Z0heKN6EE0MMnxhUBi8El2oEe/v3QqKshInePsVb8ihLEn4oE79FVqTRB3p?=
 =?us-ascii?Q?+HLhmNg+C0xMvPtKmJduIEREL5zUgcbhsdzoO6na/JRTpdV52OkPaFTAldt5?=
 =?us-ascii?Q?0clIuTXM3NZq8e6K7aawfhbuA7mZbznzNk6cqAvP/YmDtPbhy+UBYp8nONi1?=
 =?us-ascii?Q?/+elOxjUPw+NpSN+/Xzk+IF1WPIsjjM+P9onkVcdKP4CeYd5S8ie/RFfUNcF?=
 =?us-ascii?Q?zVjwSCHM0BOf9zB7HnvXlFW64OctXbMcTlIDRtGgQxcWbrFTXyuZbuYbCKWN?=
 =?us-ascii?Q?I2YayaTlKp85gQ63UjfQmlVdawNaoR0HXxkYqb1YKet89S8hfAuLrqpW2g7/?=
 =?us-ascii?Q?STnR7anNcqXPt/hCdzH9grJ+T/7I2Wr7RI2if0+1yBDYZxnMf1kHImMgaOx4?=
 =?us-ascii?Q?b95s7f6XgOQAAfyIaD/etSm1d3Vs6uv5CqDrkbEW+SvVDmJesZqZJRg6qpI+?=
 =?us-ascii?Q?eJjnvAHU7q8GECV+2bwnrYTtuGexxXM+AEBqa20bjcPOGJ1eMfHhpGPhFAeC?=
 =?us-ascii?Q?8gzLseBkQTC9VHquuIrtHbWLGefUphIyxkpthnE1VhibgWxhNCLwN7EC6Q1o?=
 =?us-ascii?Q?a+2ebhFz0YkesOBl/uPZA1IhZOtX6/gWR9H8cqy3A/xFm72/Z0V1A7YmJejv?=
 =?us-ascii?Q?kK+ij1JOs7X0YRw4g43LWC7Pmal9Qoo0bGy3/bRWl49app8Vuz/uVmVgA6gl?=
 =?us-ascii?Q?JZMM3FF4GerDjo3rZC2FG0RkVOq0z6bbSXDZdZkT8Nsbrdmw2IPqp+SMO4AY?=
 =?us-ascii?Q?27WUV3K2htti32qSL2vC6zG6L8HaIQbkC0pznr0qBFylZpfWVO5LQQvDPDPl?=
 =?us-ascii?Q?JZ/OwKz+mpDAKCkFTgHENPx3C3rtBPkQ3+LMpGfKoNK3T45Eh/wvJ+l5RDLR?=
 =?us-ascii?Q?8+fo0XiiIvp6NeBaJog9Z/2zVlW01W1s1mIDdHQ6fqJpBkxDp7hx4/LRHhhb?=
 =?us-ascii?Q?6VgzQo92/51WQpYqmtcLemKmdQqM8eHcDVsOgQTJJxQNQKM3B6PzWL0EA9IV?=
 =?us-ascii?Q?kCwE308k5ERSRPzs+6XkxqHfxeC0H2gxbEY2NhMRu88iJolsRHXeavbzU5jp?=
 =?us-ascii?Q?ta49ncL7+mNshiKew1dy3i5ifXS7sc0R9ZP+xIThipFk6SGVR5G5fjASI4pI?=
 =?us-ascii?Q?YpySaZTDV3oISWec0DJHN3JiUzw2/p0NZDLcjr+xFijzZL8VHeFiYpuDn1bn?=
 =?us-ascii?Q?56UvrM3pIkuPekrbN6PNuStidD6CBKOeDv5USoZstEHkVeJoPxzpKYogc9GZ?=
 =?us-ascii?Q?eNuA1NG8pmmo0DQtOgk2JwjPgqNl+7jk+gPFau+mQIvrqK3qCiBnXsCwISNN?=
 =?us-ascii?Q?7jNM9R1bBmO29Nhbt/exwBgLWHwkAedrZG/tv/QmP/yNpCcaksoOuqxxlDGD?=
 =?us-ascii?Q?6kNgqOYkJ3RvCjSNNHAMHGeP39CoEaK0jUDu/YPoakVw5AE7vbzkwkicng?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 20:18:52.9358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 863c9ada-5495-4c26-ff5c-08ddde947370
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5600

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
index 203a43a2df63..69aa029be4b7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -82,6 +82,21 @@ MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
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
@@ -1157,6 +1172,165 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
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
+	/*
+	 * This API uses SNP_INIT_EX to transition allocated pages to HV_Fixed
+	 * page state, fail if SNP is already initialized.
+	 */
+	if (sev->snp_initialized)
+		return NULL;
+
+	order = get_order(PMD_SIZE * num_2mb_pages);
+
+	/*
+	 * SNP_INIT_EX is protected by sev_cmd_mutex, therefore this list
+	 * also needs to be protected using the same mutex.
+	 */
+	guard(mutex)(&sev_cmd_mutex);
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
+			snp_leak_pages(page_to_pfn(entry->page),
+				       1 << entry->order, true);
+}
+
 static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 {
 	struct sev_data_range_list *range_list = arg;
@@ -1247,6 +1421,12 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
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
@@ -1292,6 +1472,7 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return rc;
 	}
 
+	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
@@ -1886,6 +2067,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
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


