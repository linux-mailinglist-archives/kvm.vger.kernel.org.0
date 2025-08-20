Return-Path: <kvm+bounces-55216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A63D8B2E80D
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 00:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 611C75A4E0B
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 22:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A84283FD0;
	Wed, 20 Aug 2025 22:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N2+/Ztlz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F45221739;
	Wed, 20 Aug 2025 22:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755728397; cv=fail; b=OIPCEa2mnRsO9jTGcnZjMGpvbgDbAEhzDUIOf+BNDpVmb45CrcTeJqqHTQOn63zgRbppCunGLUAWjDUVflXEaVxVNo6ElfCTcDNOzD6NiPVUgclpFQPIK4ZNKgvlzuP9dSp+epQZDxr2VdO1XT3ebFXlbWlsZt9OUT2CYIBH41w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755728397; c=relaxed/simple;
	bh=qVrH+EIGwt3G7Q5s7dn2hY+4USSQzwDeT9OrABwqiCM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RK5yEsJ2l/P/alTTnbzDj6ieI3KeM1zIIbRZEIvLD1uMjAa8B5+hqkLdLCUJyBCw/5CTpPvNwGGHLU7j3GMKOcHs7Jy04lytwLsSduOu2ozyezKV270XIlY8MhPdNX8Wi+voGVAyh4nNrKcEQiz3NSJo/VBrmbWyWNNZ/ksiXv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N2+/Ztlz; arc=fail smtp.client-ip=40.107.92.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xuTt9gwsh82UE2lEp/bPRjZ5d3Y/TqkgSIpeHJxgeN/qfD42JvWGpX0JwFCpW1nsYtCnPowX2UnSiYM+wIt9staEBKKBIaV4rNAeHrbqUpRTEPw86Z2LD5asK00hyiFsbIe9GWNuDB3uWbQoeOM6fOX4A/ncFztejSEh4iFgYhiHyXjpl1mtgyuAY7Ks5igdad41o7OCStH6A87X/yzRc4iLw/eO7qOyZyJBTkNmYnfsOj9nLgG38Aqkadj0T071ymYOXdGXkZ1djWHxYYNUZvVvTDbguq9OZVWVa7qIy9zVn2owcRO46M2jHKvpBVQb/VAoO9qG0WSbR5kj6VM6ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUZfLcGvVIvhFFNCeolBBg5CkGyHCCGvyLlBwSh0Ty0=;
 b=EGQbv2F6JNOhu8/BGEcXVyEZ1OqeQZshhnQSlT5U3DcU/tdl6jrItEYBYZNEqvHHmpTQnIMah8690SoydwWsyFjBqgQTOW4kLhpilr0I97I1Y3Wd6jauLRnJzFaWswN0C0w5LjgLHsoP6wtvZ1BT8gBpedrrgnQ4jaHdXJzGtOkHhRRwT2F9Ty8W6m4qq8Ig4Gvp8PTbhdZcgWJZMQF3VGaJohvqWE2iu546do7jeyoxvi5cdfrlx07tt7cA98OqsNlX5sFhvCT689xC6Ffi1L6kAE4jQd4hqG6LSK5ygzAU3HUA9HdKxQ+htamVpA3eeCmY8ZFGGsbCD4atYbil+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUZfLcGvVIvhFFNCeolBBg5CkGyHCCGvyLlBwSh0Ty0=;
 b=N2+/ZtlzEM5zykzbbAkxBCpbvQjO1UX9GQO71JgoSrCtkcx/U/vLao9JzaDoDkVxadiXJXXkG9HZId75mhqxvxbt+C8MSsBS4alIFff8vhHSW9ysbJvu3hzVclYKMp5opcmDszRMXVP4VmhdpmWuTu1sKPMFZSJXGPpsIm+vT/I=
Received: from SJ0PR05CA0177.namprd05.prod.outlook.com (2603:10b6:a03:339::32)
 by SA1PR12MB6704.namprd12.prod.outlook.com (2603:10b6:806:254::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 22:19:50 +0000
Received: from SJ1PEPF00001CE1.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::f6) by SJ0PR05CA0177.outlook.office365.com
 (2603:10b6:a03:339::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.13 via Frontend Transport; Wed,
 20 Aug 2025 22:19:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE1.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 22:19:49 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 17:19:47 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v3 2/3] crypto: ccp - Add new HV-Fixed page allocation/free API.
Date: Wed, 20 Aug 2025 22:19:38 +0000
Message-ID: <52ae3debd194536afcc0173e562cebb60eaef13f.1755727173.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE1:EE_|SA1PR12MB6704:EE_
X-MS-Office365-Filtering-Correlation-Id: ad631f0a-e462-4d2e-9c17-08dde037add2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NNyrRx/7vmI/SwWvWKf8XMraNjw3CveCdJ5kEUil2bE2NG+Zyhm6Gb6liNNB?=
 =?us-ascii?Q?6tgxazC9I2CtlpS/nJdreKxVVexBiSQSooW9S8ADF59SWNFC4NJ/TNaMwuyR?=
 =?us-ascii?Q?txnl3CtHiQIjKToiMqhzXygxiR4NCIdubnAf0Om6bcVOhUTz6iZ6V0rUsA2O?=
 =?us-ascii?Q?CXCNYpB5i5fLTfr8gCwrzxQxFWEybJqBcAghmyKXv+lwAZUmY6b9Xcv18/qw?=
 =?us-ascii?Q?owk/VbP/EfA96xaMYv3RIiZr2GzucJH7TChuWlxioX1YDWZTuveBuCRIzd+s?=
 =?us-ascii?Q?cFR22gevIxUqDdEcZKLGAFLDSKa8eaWCf/2f+DIw67j/uNiV19kJh37lq8Ki?=
 =?us-ascii?Q?QopFOofkKxNftTVHiqHohhjThuIJ/qb0KoXU4KeRrWS+HGODgFK3MpG7gLE+?=
 =?us-ascii?Q?Z7Ma8MXax6JVeEDuh6q5whzBHUUmM12MlXjQP02Zchay6/B7xUhjji2/tH6H?=
 =?us-ascii?Q?iPKsKRyGKr3QGtGvnh8o9RJPgxHRdXiN14yVO0xiM9LoNzMw8Zs2EAUAe2z/?=
 =?us-ascii?Q?F934uAUOLoYyfeJenR09HJYNGz7BEhdRbvONRcDRT4Ae4YYCEMSgdKTaBr4q?=
 =?us-ascii?Q?pzAqQavzKq8mk7DfpCKpP47sB7XCA/zx/7o1RUcsumy5E5LEDP4ldh/UZIPH?=
 =?us-ascii?Q?KuSszmjQZJQpZSZBZUFeGeYjf+VcJzxhviIdJ8dkG7rqGsmL3iV60o2Wdsc2?=
 =?us-ascii?Q?hM6trMOvDGkHESGceuVMjlCecUBlB7/QRfnOno+bjvd4cys/2I6Yn/oGCMH0?=
 =?us-ascii?Q?w8UZHCVUy+l38y6/oPqWwSveS1wGAfF+N0Dm4gyIL/rxH/pY1Cf5dkQ/IgcM?=
 =?us-ascii?Q?DRMbRhANWEtmIq0zZ4jJECr5A4v8oneqWMbYMcWku++WsY/CTiX+Cwu4HvJy?=
 =?us-ascii?Q?UveQF/igIWaHT/hAAnhSW9yjxRhQoNhDOYt3eeUoRLBPNNmdXR7sI5FHti8S?=
 =?us-ascii?Q?4qkexkMvvOE8KBkYISBniA74Yryj8yGbWBCFowvI38J3Yt9W18ndCAbC3JQi?=
 =?us-ascii?Q?0t5a7D4XQStO77plN/KxwbfIEf8O/9VZovSQmCtr9vdhcDW51cB6cQCny5Nx?=
 =?us-ascii?Q?zHTc2HDbfV0QcmQYsIy4guviyt1h3tufwD+gr1hz79Ee9A7sKF9ANh9QwlAl?=
 =?us-ascii?Q?evpXkukWPyyU+ZuLbz0aXGdCsxtUzy8yOj9dG0aQV+Oyx5bAusrSzIf2FtQ+?=
 =?us-ascii?Q?mv8DmXqaQE8jCRpm3PyndHlQ0fr7Exp+/4oCuvePv3evEhcX800XjFw25AoN?=
 =?us-ascii?Q?tDhc1tkeFQ8HANNlfIBRKOHIfG1YrxXjJUJbwCoRyYVm2Q56YLYPOU6gqHKG?=
 =?us-ascii?Q?rZIEEkBLaWTjkL+p1T0ZkEpkku4F9IPMdIAsTwxH+xvifQsCTo0ZXyCtEGPw?=
 =?us-ascii?Q?21BIwvM91lmzkVRyVHVdB7AMikht58dTxb/ge2PI7dPfcEqqvWXu6mdJzEX3?=
 =?us-ascii?Q?1jShJDy6ZEeVCUosFnjHWC6zbhhrkEkTkzpHvrMO5sXpr600NTSiJzgT0err?=
 =?us-ascii?Q?ZzDdRpETOpbD+ALcfgzXcpTp98fLul6bUT9Nbwfyb93yDZ6KqGfoRXqqlQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 22:19:49.9207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad631f0a-e462-4d2e-9c17-08dde037add2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6704

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
index 4f000dc2e639..1560009c2f18 100644
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
+			__snp_leak_pages(page_to_pfn(entry->page),
+					 1 << entry->order, false);
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


