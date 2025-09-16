Return-Path: <kvm+bounces-57791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB749B5A3F6
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76E18582448
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 21:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9900E2EA735;
	Tue, 16 Sep 2025 21:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SmXZHNlN"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010052.outbound.protection.outlook.com [40.93.198.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A76274FEF;
	Tue, 16 Sep 2025 21:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758058191; cv=fail; b=ZNfkOqqI60AGuqCU2YVQVwu75Jw/qxM9qGXwPrmkqWXJSsWFYIbVjALdzm8tDNoAz5baGf7/Cry5XGbZkuX5w9aOeBHSAHJGq5z5MeqvtQ6JpDwk4coZaA/byjekmKgHUFbcs7XlLiRDgQn4NAKseFgshqOZ+ExX1Oc34fmWlCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758058191; c=relaxed/simple;
	bh=YrMW2aOJo142Lz/TWYTO2jzuNs1yNUJlYD1Hth/qu7s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C7O6vL4LMsJth283cr+ma68YXWsBgvfxsucpndz5uv4RQMWHm+Mo9cr2Lbgml1ikzHz7N4gxD4BrHY1z7q8GIdhiW7OkmU/7yHlM2yVJIA1RnSPXAfCtN1sjNoKwtQ9A5xV8s6/fHLbknsqqObsBTwYXJxz4gvoiYb05RqYlcrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SmXZHNlN; arc=fail smtp.client-ip=40.93.198.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYCDB9ynarKrN7ab1FEDly6cvk0KwH2b3ur80y1DQE0E1xGRL4RzX7FzqrBJdFI6pGx3EJpLUmu3I0ZR6YNWxD/2EaqfJz7jNypEK3s4e/Lo7Z8JO1zo3SFkP00+IN7n28S9esqg/V8mO3s5JkmoPat213fmQAbWQWI+eBHjitXOcVT9MF6iwbGPcQHeZE/e/BanfD5c15kwytlxXZP1pxPxkv1pqZiJpu1VsEfR0C9CnxOXlhGW3vWBbLYV06gSUeO74uZGtvXOPB71W7+Vo+iQ5W+WZpSkLI4H9y7qMDaDwqRMIw9qPAQ/e5iez9mmYNHIKZL9tv6ps5J0NDPAtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7S5x1cS8qdhddbB1G/gA0Nm6IYdnGzSw0yMn60LX3Gw=;
 b=GSwBK2JRZiIXqmgLNUIDZHIY59lgpn04FupKdDrS+RJPdoeJKCQnC0meimo8P7VgqeNlbPDOU8K9F2pYRHp++UjaO8Kg/h0u7afNP0Ht66Uv5bSO21na/lh1zP8RboWkVvzs+05O9+daqiZ13Af7R2wqLUQEBVmgvA+N92cKgDOobobKXO9sSYtAQuEa/qfR/Bf12BXLXcFKqM+u4n5QSqhWeRVVh0RMiryiofqOZE9+8MczK0h1v3tjy2y+HBE7KIjeBq2fRbnn6O8mdF7GNg3LA5nMv4PKNwTvkvdW+G0+dRlPa7u/Au6MZSjigCUNmbcH7BW8Pt4LUSMT9it39w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7S5x1cS8qdhddbB1G/gA0Nm6IYdnGzSw0yMn60LX3Gw=;
 b=SmXZHNlNY2y00SxxngCHJnJ5wOEmEDj6VYV73/6m9LJWDdPgcK+WTlwfZG4qoQZ2OLQQyTpBmIpFQlQKDmNhhmU+XONWHzznM9rq1Cxc+hdqoLRKMnAypqCvqo7Vm3VupRzdraafhZ7BMRGisJQYZSKuQxlVg/Exdxsw6CX/CIU=
Received: from PH7PR17CA0029.namprd17.prod.outlook.com (2603:10b6:510:323::23)
 by CH2PR12MB4247.namprd12.prod.outlook.com (2603:10b6:610:7c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 21:29:45 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:510:323:cafe::45) by PH7PR17CA0029.outlook.office365.com
 (2603:10b6:510:323::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12 via Frontend Transport; Tue,
 16 Sep 2025 21:29:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 16 Sep 2025 21:29:44 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 16 Sep
 2025 14:29:42 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v6 2/3] crypto: ccp - Add new HV-Fixed page allocation/free API.
Date: Tue, 16 Sep 2025 21:29:33 +0000
Message-ID: <ea9dc045267d0e5925476e0410914e3a5da4e3e0.1758057691.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1758057691.git.ashish.kalra@amd.com>
References: <cover.1758057691.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|CH2PR12MB4247:EE_
X-MS-Office365-Filtering-Correlation-Id: b1a78348-73a5-4d2d-eabf-08ddf56827a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nDWq7W952NJyYr3alE3g0oGb+JU5sGzCpn/R2tevZYVi9CVNyBHdgzx5PFvP?=
 =?us-ascii?Q?P5yTrk3RRTrm91K7X3L6BsKWykZuOf+sVUljOwYD1Z2gYJ1sZEQIt1KIkSEG?=
 =?us-ascii?Q?N32u+JMfEPbMXKaRAeKbYaGkKLzdA+lg63N4h0s9EgRsDD2wvNAOl/rXf+GW?=
 =?us-ascii?Q?bRTAjrb7Nrbnu6kFVz01EBo5maXiXwoviafkW51PjdEUQV9afs5EdhlD7e+O?=
 =?us-ascii?Q?Rekqa0CDNiTZM17R6Y2IguGHfzhnXKqPmPbOTrNV/XGR80yXyznk7eosMIT+?=
 =?us-ascii?Q?viuk27AV/8kRtn8vC4QG9ygGRm2ZSwYjPotdisuhAcWNLnuTRs7PJCQTuoqY?=
 =?us-ascii?Q?Jh6LIvUlRZP8sPXtQIS3AKjRMLY8azQJynPed0VnIVFfY8zoK1jM+3MXUK5E?=
 =?us-ascii?Q?eu9IAoMhSWFqdWeYRlKgC3ahqMHVZb5A1wFMCLlR6Mra2z7XKHDH85dg8nBk?=
 =?us-ascii?Q?e8g2RbSUz5+uf7mYS+zjOE9DKES3rbT1JAiYAKVL7kqrJjFh+x4UnjJsMxXQ?=
 =?us-ascii?Q?l8iM7hkapIUQOAkNICb7Hv+28GC3Ta0+bjV41zmBQFSoEYdfTJxDyT7YRl5W?=
 =?us-ascii?Q?BPGTjRdIOobIrMAghuBlyKZHeHCEfEggz2dSXsayUxsu1dutU8sWpSZ+HdCU?=
 =?us-ascii?Q?jNcZqDwb3zpnmuatzCqutaeJ8V301Hx0xnTlE5BB4a4Z8SM95vhhGXdx/+xm?=
 =?us-ascii?Q?GrTzSZvJctvIZ1xRekyyHXb+x42wa99/CH1SiqZo+JJ2sLQ6vbxZIMAw4MH7?=
 =?us-ascii?Q?yU3unvGU4KAeboxnNDr3KTjArk1ys7sS6cH8XIp0XB5WV8QTew1M5guY4SGW?=
 =?us-ascii?Q?e54B7u6xpC0sonHktJqv+Ipqa6F5JgIYaTZGytLMcZvoWzz5FVltZI+l02dn?=
 =?us-ascii?Q?L47wb18xsa9q//+Nh5/H2sfKgs/2muVBujYq4NT+La1qUv7RVhsHpLJyWLRx?=
 =?us-ascii?Q?KxKPhHlIJO6vFh72YFx7IYYJtmjBzOhEYgCfqQMh2Ab/j2rvPU2kt7Dwv6dZ?=
 =?us-ascii?Q?HXH7Sg0UcoW7OZK2L9q2aiRzfmty6VPsiz9BD0M8OrSNgNoY8NZpqNrrV6dV?=
 =?us-ascii?Q?+iewlA5iFKcbO9Acaxdt+BUhxbZJv7Pk+s4rVa2c3SBP5TBp6pszc/2BXNBM?=
 =?us-ascii?Q?Le91oPMvtptHX9OFaU6e8mR+6xhzg4rVydkGoXrxnKxMnQNmMGQjc2/iBH3M?=
 =?us-ascii?Q?9AM8Od1re/EHozN7ZLG42zGuCHI87mzcRea4vOSTk0eyDQniugyKONW4KGR4?=
 =?us-ascii?Q?e5lsF35OZGKnxC/a9vyiYVhyiqQh8+WswR0NZRqjv3a0u2jBMTORVTdY3f9A?=
 =?us-ascii?Q?yzeOPASwL/pa+e61f2Iz8WnYSZr20VpmCoKVxTWCeYJt2cKdqAYn+BR1TsGF?=
 =?us-ascii?Q?a8GnQ+jBDTUWzMtZfqXbeRYSc4z5VUB4WoxJz7KzptJsn68lPUogo2Avwmq8?=
 =?us-ascii?Q?mFEvicxsgMRIoHB7MehDse3+aTXlJsfFOO4z/K57DQkN/+Pkr6wUDLVvs+sn?=
 =?us-ascii?Q?NsatiLalTbw1O4JqCWas1KifNO6WSW+vhgUojsR5+qnmdZ5OF7Peixuutw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 21:29:44.6043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a78348-73a5-4d2d-eabf-08ddf56827a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4247

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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 182 +++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |   3 +
 2 files changed, 185 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e058ba027792..f7b9c6547e18 100644
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
@@ -1073,6 +1088,165 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
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
@@ -1163,6 +1337,12 @@ static int __sev_snp_init_locked(int *error)
 			return rc;
 		}
 
+		/*
+		 * Add HV_Fixed pages from other PSP sub-devices, such as SFS to the
+		 * HV_Fixed page list.
+		 */
+		snp_add_hv_fixed_pages(sev, snp_range_list);
+
 		memset(&data, 0, sizeof(data));
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
@@ -1202,6 +1382,7 @@ static int __sev_snp_init_locked(int *error)
 		return rc;
 	}
 
+	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
@@ -1784,6 +1965,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 		return ret;
 	}
 
+	snp_leak_hv_fixed_pages();
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a..28021abc85ad 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -65,4 +65,7 @@ void sev_dev_destroy(struct psp_device *psp);
 void sev_pci_init(void);
 void sev_pci_exit(void);
 
+struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages);
+void snp_free_hv_fixed_pages(struct page *page);
+
 #endif /* __SEV_DEV_H */
-- 
2.34.1


