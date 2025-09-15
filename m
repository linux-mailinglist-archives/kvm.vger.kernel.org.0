Return-Path: <kvm+bounces-57625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20728B5869E
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79CB51AA7CB8
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE2D2C028E;
	Mon, 15 Sep 2025 21:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E85i0MWA"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011043.outbound.protection.outlook.com [40.107.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305F629C339;
	Mon, 15 Sep 2025 21:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757971359; cv=fail; b=FgscAvfkTe4Ff0Xe2N+NLp62KV+h5ZBsLOAUTtNTNZdsbrHOErUy3t6mQ4jY+36AYKMt2vHGvG0gNtz753PPLNiGDkS6Icxu/CaLErGHyDnmJ1VTdKYMg/7Q1WfiNqrgerq+TXyq3ycCIQDcVNG1JtI5oqw+ZLDPK0i5vY2E+uw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757971359; c=relaxed/simple;
	bh=OZufYWjC6S4RJH12PX/WyurYOI7HFNbIowEovaNPcbs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hX1GTyBAT+S+TXYumdQ2kAF/UPOduvIo8bpYLaPe82I9z0pEhdtVv14KE07woM3L2LpUtC2GFt+k4avvkxzdO+4dTrUXZaCM6QL0b8nM8YRFolpJSrh1Qi/B/fkMmm7gUPg6grTEyL8fgpo+2aULzLWJzb87lTK7rROOwa9TJh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E85i0MWA; arc=fail smtp.client-ip=40.107.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eCBPXGHBo4CybRD2C0X8jMFPcKfFsRYqoLC0GAGhTQkMtddb0w0XAUPxygjNY8R4CyI78elZJsuKVdJ+tvdpeqTco0tGEuZTtJh/tIoJmdA3dvmnP8gbeq5+5o/FNSRuz1St5K5IyYkcDZ0qL5uansYPX/TwaZk14JJ6sbgzan81jPNvDA1f4glz9F+fbGg6aw5sm5WXxqUF+yFTMAZe6BP+g5cphIl5B3Pp3H5+h2FA35dZ7bc1cgrVXfIV82vRKO7L3RQ/gl7hWzK2bZUzD3zWO85V1/6J1My408B8UArr/X5yrGiDSpRIXJq0I+BM7lRZ67Fhg/qMyFIKRvlKhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcH5EeT0ujFaCSaWvX71LEjs8Z/Xk4/QWnTKzAwLS2g=;
 b=xODSBMrUdoNEZw5GHgadCsO5KZbhiwN7Xn3NSfA1nHfHBleLFZ3SOWekpHrumwsXUDGvHEyZIhk/AkcrAYc6FauvKRnGG6OjiUSe0f+4parS2lsosBqB0tTuyAh8Fdx0+0PklkCm18Jf7KGR69Qam3vBlwiA9kP7ChDGJQLQPDwkmalphqKmFdTld8krxn4v2tBnChk4g7ryywbPHDU2iq9376EYVXC0v7FebnyrN8U6KiXxvdhaUowWbe43nGaZV6tUIFxD8bncYK8iZmTstpZR/OLxWfYSOGzUbSix3NgTKaBWx+eaqyNTn8359q9YFDSywAkgRXIyouBpL5uevA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcH5EeT0ujFaCSaWvX71LEjs8Z/Xk4/QWnTKzAwLS2g=;
 b=E85i0MWA37js/hvgEjCCqjQbqTa/A2Tw4sLqPcfZmFF6QZZ5WEtlJYVObVwewpbRr5Vs5V9KG6V3ETs19sUC9TTbiW68mbeX7J68zlFqpq8KLr+akSMbqJeMH9u6R95Ri4TAGVav/XtZ5OEA87s7I9PLVWppvic0TtkWLEmnhe8=
Received: from MN0PR02CA0002.namprd02.prod.outlook.com (2603:10b6:208:530::29)
 by CH3PR12MB8902.namprd12.prod.outlook.com (2603:10b6:610:17d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 21:22:27 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:208:530:cafe::ee) by MN0PR02CA0002.outlook.office365.com
 (2603:10b6:208:530::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Mon,
 15 Sep 2025 21:22:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Mon, 15 Sep 2025 21:22:27 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 14:22:25 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v5 2/3] crypto: ccp - Add new HV-Fixed page allocation/free API.
Date: Mon, 15 Sep 2025 21:22:15 +0000
Message-ID: <d30f6ac63f1a7b261fc547e38eb2376217817026.1757969371.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757969371.git.ashish.kalra@amd.com>
References: <cover.1757969371.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|CH3PR12MB8902:EE_
X-MS-Office365-Filtering-Correlation-Id: a1427b6a-563c-410d-31ae-08ddf49df875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G6STDHS2xXtiBQ+UkGm7t3lG/AylwNrVVAdzw14VNZlWBXq2mps4irz6kEH9?=
 =?us-ascii?Q?7Z8ZxX/nWWhVDvK7i4d91RgVaaXSHBAYgS8GXUGiO+gu4lsgpxLlzOzEhpCF?=
 =?us-ascii?Q?Yt9GUKv0ExoEdbxRjekzAjOJVFSppuPV85JYC2BKnyKl08STisXG6/4669la?=
 =?us-ascii?Q?s0owRZISeythcrDgA6UuqaC/K/gI030Tm6pODZqvmfWYnG6nL4OepEpEMJev?=
 =?us-ascii?Q?j0ZlLOfMMtV/3KQQjCDXeZr6ZBd/pONJNjzCyVX4BOQRZsW3s+k+gK0GMfMq?=
 =?us-ascii?Q?RI6MnKnugNF2xoJ9vEFshqPt2yrhKPrrE4AYxHnFuY1COOM7iKuWZzAX+Qpv?=
 =?us-ascii?Q?g5S+SCLJ7FQHASgRfiKYPQd7aC8q/SK5D+ncLIxhQMDNsQT2W1leGwek/PxY?=
 =?us-ascii?Q?zctlEbOE0l9XtuuZm+z3yZ4VHEQmsKd/ObJ9AB09GzoaFbpVGbBg36SKQPcB?=
 =?us-ascii?Q?eB8k40D9VaPFOjxKN4Vb6X8AM7Z8eY62CoGG3smkpNcqSNCXrcP4ceFGPdJJ?=
 =?us-ascii?Q?2hg/8ipQa/D4t/4/RpFrvVxlAjRvfJwAvMe28rGdX0r0d4jdjROOeO9ND/v4?=
 =?us-ascii?Q?1LSEu/dwHz3pWyqWYnB0ZcG1ToOVUaTpnKo1q/VqB35pbS7YMw3TAXr+TZO+?=
 =?us-ascii?Q?vS8TZ/DI2kY5di562faYKSU+XUIgRrKeQIsRrA4285b/8v3RIjcLS9h89bTN?=
 =?us-ascii?Q?yc4Mpg3kv/XCgwziMrJJYhdDurdQp5BV3j0auDNLJrV0iJgsBUBf3joz6XEJ?=
 =?us-ascii?Q?c2A34R9rRYw1m6wWqSDuR1lTktd/9hoh4Jck1BSTD1Vr+n2T4t/f6Izez0Lo?=
 =?us-ascii?Q?k7ocp+qRwSg1kVOnVTWn4AFJX2C7JvYXjeL5W+NbFAxI86/bJfegjdO3GAVs?=
 =?us-ascii?Q?ghSWzm89Gta+cC19uOMx/VnAfR8mLrejqru57zdWR78VMvfJt2SFcg8bsRnC?=
 =?us-ascii?Q?y+OLfuZgV0OXuTUry+MRMTJePXtisWX4DBS7BEY9mFGHcq9F7yPWnypNYc6P?=
 =?us-ascii?Q?ye4FBfdNHH5wQENjmHYOAP9NXw1kSO79M0Uw0RQnqJzaPf55Nb2OeIUY6dnH?=
 =?us-ascii?Q?8riOvd3NADDUhHY64/3pEg6VVcL7OqsYva+4d0trBnsyl1+SW7sOMJ/RzkfT?=
 =?us-ascii?Q?v5fwr23XtlmePOryqucYsG02KeG6uxniRQRPSP623xhy6hN6P8//IjcDHqgE?=
 =?us-ascii?Q?qa6ARKxv99Yc3Ioi2Vsn62L0QWaBgvxLvRyz6PtmN3m2QdPOO/mAdPTLshRS?=
 =?us-ascii?Q?62TbFMo3+ByQPK/tuD3+5vaHZOfuUzi+O/pSQ7pBUtOWg20HFsMDGFhTlR+9?=
 =?us-ascii?Q?8BqRbxdWXRHJYpP3Zy7gK50zkejVvuIqDvSBdCdywZLv/+p2LR6MF3eBry7q?=
 =?us-ascii?Q?eA28cAQ32E76ua1oLTKAmMXiCNjtK95Ol407nYuVhNhtKrLRQYB6m1DuX52t?=
 =?us-ascii?Q?Wrp48f81ZhahOT6rOkY1RG1I8WmOkW4GpNjBD07bFavIHqpccrOn+r0lccex?=
 =?us-ascii?Q?8XF5skEEIhmv2IULg3qPtCKgsJuE9uIfHCuKfpyY8An59qJ6UgVvwr4cwA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 21:22:27.1525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1427b6a-563c-410d-31ae-08ddf49df875
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8902

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


