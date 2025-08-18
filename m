Return-Path: <kvm+bounces-54909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7667FB2B1FD
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 21:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2793A4E8A55
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 19:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0D9274B5D;
	Mon, 18 Aug 2025 19:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VyAPSb0r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A40261585;
	Mon, 18 Aug 2025 19:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755547160; cv=fail; b=Ku/qhvdU+MtXelyLriFDX7LlaG2vwEZZMmUzzOW5q+G6aTEY+h1VYh0jFRbd7ACWXQ5a2vGfvHyKXkff8urFopp2TWwtBUDMeT3UHqmvzBI7LloHgpcaZO0m+nhaJKIe/K7aD1R7SVZRy2bEHTrCuQJG+l1DBP/DWnVvZSYxBEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755547160; c=relaxed/simple;
	bh=WkmZ0vJmx5UBafkuiCQCkaBSE98NgoNjnraBc0MPo8U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/4EcLq4DO33P2ir9x/PY3sEmZHZrSAbpVIyHI1yeR36BHsz3LdtTYTC8WSCTZh8gb1mpLHLz5HoQD0vIk6UcBR6AX09C9DbmuqMlhIwfPMVf5+BA248mwFEXedsHwDMUG1BG8/C1XpFFAGIQVMC8yMFWjQnFxgKyBp9XQX5W9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VyAPSb0r; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Prhp8YuRcq3M2jlDYAoLE2lGvUdhfsPRQtLorAI2RYjQhc7ZENkbsXDetFompLf1VdAusSsCWFoow6g//WezZmkIndFjH3sDpGFPCy+OfkNlBadne68+JGu1CE/wBZdGcPiErVAJBRJNG67sQbFYxSHKn0lr5rAKAy5wIkV1soA/j1hjMudXQ3Zhpf1ZrIfAsmsBkOjyHn3YJ4otI684x9AY740ypfGQmF/9F9yVe4hZhrUq+T7V+mGX6j+UxjLvJo2ZDQ1Bs4z6iaox3Ya+X0jP16pHqRVws/M6NPo02gqGA+Wc3cI0BrfxjUh/m2jPdZgb2JYpBY8xuvpqqSrPUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OnrdBhKTRybeptCJp8oBisPBp4RK8bgIJmncAbdjaQ=;
 b=bO263dwxo9f3dIQecwXbTrNwym+LuKAyliRDjU1Yavjc2DeOMAm9NQFSv1bCjn4bb+7UoykKp3QFV/BsEctL6J8vFFX2IK97i46gwdTdrfEAuSiWGtB+40hRPExiJdSHP7oIkDDPLcBSL07qICIg0jbIeHn4qCQ7XM1YcpOLKP66QXfXVfOXo9J6odi1YZg1EohA5y/fQUg6BbcLEpBjpxhwtPU/4Cm1hbLW4OdbAuhb7LRbDq+7mSeLOTyRc1NcA8OmOEfWygWEE/H5NXTS4fxjBdTSw6AxD5sUx72qCellccnLR3UwN6yepmjPm/pq2FPbLJ3X14p6q85L+XYqyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OnrdBhKTRybeptCJp8oBisPBp4RK8bgIJmncAbdjaQ=;
 b=VyAPSb0rcWFGfRByLQTN6zB5TYNlAR9gVV8lta180H8Q0AzicpPqGfrRx3x4KqCxpx0FFvj8VN8fFCDypwsV3fJcHAIORB2Hcs/bBNFPFlfyrrpFNs6KZ36oLesQPYawSGzoWFAYLkRRjv3Jcmhu+MKfayzaQOvuJVF/JUBQuo0=
Received: from BN9PR03CA0773.namprd03.prod.outlook.com (2603:10b6:408:13a::28)
 by SA5PPFD911547FB.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 18 Aug
 2025 19:59:15 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:408:13a:cafe::f6) by BN9PR03CA0773.outlook.office365.com
 (2603:10b6:408:13a::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.21 via Frontend Transport; Mon,
 18 Aug 2025 19:59:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 19:59:15 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 14:59:08 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v2 2/3] crypto: ccp - Add new HV-Fixed page allocation/free API.
Date: Mon, 18 Aug 2025 19:58:58 +0000
Message-ID: <60bdb33905fc566be4cfb46904623b8cfbcfc6fa.1755545773.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|SA5PPFD911547FB:EE_
X-MS-Office365-Filtering-Correlation-Id: f1ef8b03-1e1c-46b5-52f8-08ddde91b578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xbuDRhssF82i2exUuVBxcWjFM84pATfZWlMdO1ytuClTG661czAE7gKkIsZ6?=
 =?us-ascii?Q?gAWttzsnKPAWLoNtlb6bpCZ2JTom/bRk1oMNHNmOuyP3kGIknRR62vbD6pkj?=
 =?us-ascii?Q?xext8ZCEC2oZs0WoyCrChzV2cpVky7O+C41hinb2tGFrJob987Nc+Y9eglSk?=
 =?us-ascii?Q?KUCjUuFyQn1mv7qZ8taJgOOKgq3295BnwYgYlvt0eCOPjLGn6qdXVi2oJnDx?=
 =?us-ascii?Q?+T26gn3INEeQuw/fH4fdc+HW8FDJpxprHmmD+GqzSGCJC2mPz1y4mDW9bXfF?=
 =?us-ascii?Q?1DxdHUr60d7I7LQG1Zia4GgeF++HA1ITLpb7hRMuK1RrGq2PyQ7YIDABJcX/?=
 =?us-ascii?Q?q7M/1v3bJcN4C1LbTLQczVCRXLrPEVXi5760DbuR2BHImQkJXn45fkVH9JlP?=
 =?us-ascii?Q?LdIPnJb/MGh8UVeF1JgSifek6C/awZfYalT6WVhIZ2P2nhQCth009WN7wwq3?=
 =?us-ascii?Q?luZHz7GidvYSuZxS5ngh95UzbTU5cnxdBE/krNfW6sb7ukZT+YAp71/JKnki?=
 =?us-ascii?Q?IhUeu2XTQlCgQhG/9C7hKmJObaCsdHGC48z6xW5FEKxhJbHBz05Bxax8PJbo?=
 =?us-ascii?Q?chWxIpIB8RGx7aMvC2ukw4F6a5oNq1lql1lcHTO1Yg75nMmQi5nEmLADEMvD?=
 =?us-ascii?Q?Vp7+Sy3gKaXJNmAzNF6OcRIVSxE6ZmylEO7Gt86zb5TRAOxwykHHJpsKtN+G?=
 =?us-ascii?Q?wiXq1q0F0Pqz+SMGg102zBN916lJaHgMGjV2H0pseIGIzZQEU4VhBBv4F8wD?=
 =?us-ascii?Q?ZhJHLZNwmwR7mL9LtXE43qetlfk81yoBzY1o5S/BKDQ4ALHucfl0FsU1jC6w?=
 =?us-ascii?Q?ewNneL9Fubk2PvHagQIE3SECcZ1eU05o70fINUU7B+J7QneU9e3Pmsr7qZ9q?=
 =?us-ascii?Q?nSvhcjeMEv29nYO/5R9+udG5wBn7STBJvM0nuXGuzsC9K1UDvY17h0GRljAx?=
 =?us-ascii?Q?JGvpeAZSZgXXX2+q10KWWm0Oqz8x1swDv2OnrJrUVaAjCdoJWUCNfvC7zE7s?=
 =?us-ascii?Q?JQk++yD3cwNFyh1+iA0dc2uJhFmOIxQ7l1UC/LpEXYoko+KG0KaHq/nqugjE?=
 =?us-ascii?Q?jYfWmmayHw5eINE9MiYFC/7Nx+lXRJFBNjiuNvlorU0qSOCxgLMsIWYqZYp3?=
 =?us-ascii?Q?i4iyGStkJRiFPzjGs6WArVg1zSbYmF//1eUBbwMMUaWsnkowqLRLciSLg1+I?=
 =?us-ascii?Q?XTiefwJnPPEzxcckJh4yzixWX25NCc82QNnnn/6mw+TcgeBFgh+lWt5aiKsO?=
 =?us-ascii?Q?iav1P9jutVHckZw3PDBE9IenO+UHoo11pfAUzPTPXiRzoKcNucqFbKCX8aRo?=
 =?us-ascii?Q?Q/2QHqPexwaT7TiJl4/kcfNHdarUZUqvKDy8keVFs3tAnf35yYVBKB8rTfAK?=
 =?us-ascii?Q?t1lJy93oQKHYm1V0z6V1TZ5pwWzYBTzL/zuo581n8FOxWA0+WmLyaqcFHvuG?=
 =?us-ascii?Q?DsDrfzaJtUqjR/xgZEiAdnkbY+7kC5d/zUEOH39udcOgACHME7xaa7hJyv92?=
 =?us-ascii?Q?GhCxKCjSKAzdVXMcPSM4IOKOZESQORqEGeWyR1nuhPi76dds8gdokEnzbw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 19:59:15.2224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ef8b03-1e1c-46b5-52f8-08ddde91b578
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFD911547FB

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
 drivers/crypto/ccp/sev-dev.c | 181 +++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |   3 +
 2 files changed, 184 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 203a43a2df63..3617f189a5e9 100644
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
@@ -1157,6 +1172,164 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
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
+			memset(page_address(entry->page), 0, 1 << entry->order);
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
@@ -1247,6 +1420,12 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
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
@@ -1292,6 +1471,7 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return rc;
 	}
 
+	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
@@ -1886,6 +2066,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
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


