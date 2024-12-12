Return-Path: <kvm+bounces-33556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B98789EDF8F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DECB16896F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 06:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A82204C2E;
	Thu, 12 Dec 2024 06:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ihi5b7tt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3587E54723;
	Thu, 12 Dec 2024 06:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733985532; cv=fail; b=YUNNcRNAYaQBIjFGsB7EbDFJ2iiN802r5Te/exPMi0LBt+ZO6bgiQiNBhHLk5bfpnqZt9yAM3nKctoex8DWgt/5dciXQBp/YM2A7q78u7TqxYFhvYKP9WgvqCZv74aJZy3XTQiz9vmXvK8sMyqTgU66Ye63In46kqz0vgYbrqFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733985532; c=relaxed/simple;
	bh=3S4FitfyvHq2biTg8nSnnFWWzhemMZx43KNm5Ur0f9o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+aDEdOnMK8+mkHdJOUBFh3NJT6WmZx24JvExZrqnO+eOdJh6O3QSJMOxKYYxvD8eok7d8GmsPDgKyXR1PVBguMxC1CECUr+hkq8wpiZCXxqCz5+LnmPEZBE3pO79sSGXTjZB2hwbkdjKBUucwUGcAHCxduEN2F9I+4wTSLLT8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ihi5b7tt; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pbKKjn2e0zGLQgpKvShyDRy16+uXktqqPen22PpgC8dL5HxpG7u7XEWsFC6jnamRo7HfdrBox/N5L1xTDc+waNLqLBUOajuPOr5L3C97F+KYmGc73vIIXbb8lzrYYhTtFv4AKIlf4hxxtdVKwJlV+6TymTJeb1HDzgwxeRvUjW30q+Vl4vdggFSw+EuYfQjLhuujJlGPGlBSZ7Z7UI40bUPySE9C8loWxGxCtRzimlZSnuhcCvHn5hGclpptr58LyRZGGDAXOGe/cUID4P7I8OEIuJTDe6w/9IZ+yxlw6P47meCpNbv2T2zcZPVwwu+RzpOv9xJ6NGi0YmJfNrmHvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4eGZxnQBjTodY1JhmVlQdeeW0tmFoosWN4I8NNqgCBw=;
 b=Yx8pzXK3M+9IiMSEolyUYbhytN+QiWGlxhCW3Rr3D22fm3n+iNbjkarh6/lrWniTL3aRcVzLtO1u9/vpcJgtQtV0DPwX9JDStu/MKdBD0IJXCXjyiF4kdl0/xQf/4qQgs2WLfX+kee7rzmxRZy/b4/NB4gtSO40CsG7aTA+qMmbbkJfYgUHrKcCehp5eruk5boNWzeF+YtkRKADOyNgtgv7i57QdOdW/hU2yhjNtufVRRhugnt83KObJlO6FQLJj7nqNX+sIVZceSEUcXaM64I+MHxHM90FOquwuuV8ImyQ7FWW0PF9aEGHEo6+sr2PfbfB29p/Xn1p3J/yPNvzf+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eGZxnQBjTodY1JhmVlQdeeW0tmFoosWN4I8NNqgCBw=;
 b=Ihi5b7tt5yg8MC85K42g3RMjnuiu/a11b/TlSlvfd5ql/uSbiitd5gXhjkhgBU+TIpmj4nLOj9NvMUWi6Hl0V4SLb2u6NnMWefB7zHGHh2HvFnpY9i0vDRi/3z6UqyRaIo1n9QSbJCLw+wQeDKig/A8q0mXwZYJfctijVJR86OE=
Received: from CH2PR04CA0019.namprd04.prod.outlook.com (2603:10b6:610:52::29)
 by CH3PR12MB7524.namprd12.prod.outlook.com (2603:10b6:610:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Thu, 12 Dec
 2024 06:38:46 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:52:cafe::42) by CH2PR04CA0019.outlook.office365.com
 (2603:10b6:610:52::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.15 via Frontend Transport; Thu,
 12 Dec 2024 06:38:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 06:38:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 00:38:45 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: [PATCH 4/5] KVM: SEV: Improve handling of large ranges in gmem prepare callback
Date: Thu, 12 Dec 2024 00:36:34 -0600
Message-ID: <20241212063635.712877-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241212063635.712877-1-michael.roth@amd.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|CH3PR12MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: 01d338c7-cd1d-4308-e71a-08dd1a77a10e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iGMrAeweamXYwcYa/wSFB3TvgYzZ1Q8Sh/QVkAlLUy378wr74Bw2eQWHWH8i?=
 =?us-ascii?Q?TiC6ici9NqVou7upkkerZQOxD3KBiOhCf62ApTK7yFiJEVzQPwkVC1xdTMkK?=
 =?us-ascii?Q?1vDA3jlHgYi4XyKvI0Y97UOw0kMQDDe6jYh/T79xbpCSj0mc9A8NWIX59Dow?=
 =?us-ascii?Q?qJrTfIMNHlhhIuXS8QVirFFSSXiVrekLdFkW+Y/wH0KAdI0EyVAO/NHSqxxN?=
 =?us-ascii?Q?csdx98JrWr4LWGL6qwCYUVE2Q/xdCXVhj+mBRK7CoBKQntaFOuizWMEAi+PT?=
 =?us-ascii?Q?bgkN3joYO1n9uGrRuys4OybsmRF2tC3Mtl67gfO9V+B/zXtQzt5fVtNHTJTW?=
 =?us-ascii?Q?9O2BZAQuPGslN1nu6tqjO804NLHwQdjJpWbj+84HYdCurWz9lcZksgcrjhKZ?=
 =?us-ascii?Q?rG0OlFCd/Yh/Tk+60UBzlEqDW4Jcp/FCZvpgHd3Xo6qR/lxFP9HbPAZ2nWSq?=
 =?us-ascii?Q?lTtFWcnrvpoBpEnejQDa6N7Xc5coHXsfxgSK0ZvuvP9hrO8W/F+AZodAvq5R?=
 =?us-ascii?Q?IjlvLKNKU0E90BPlmTINHfWbLxuRFj7kkylHmA4r1OLHAOY30VJ922aF8gPD?=
 =?us-ascii?Q?bRrLYaK3qd3Sqhl33EEUEmyn8oFZnizz056w7/Up2P9rXWU1E3MMpTWysuuE?=
 =?us-ascii?Q?jQK+mkSh0aid16CVdH0JQM2S5F9SdADpGQWSIHlp/ICN5qW+kBOvlef/P14p?=
 =?us-ascii?Q?27txOOprNGo03se4+76FHxd/aAnb9/Y+h0PqB3HRUZjhkz8Bzl3+lcRtVNLC?=
 =?us-ascii?Q?l+6oMW1ICa83qqKYFTz3o5lxE38ZBdVoVqItXqTwoC13lImEtOoYPi9VbeX+?=
 =?us-ascii?Q?/c/6TpI12/tLmcPeaCMVJcxCrzk/7ppWn6axG76uOkdl1mMuF80V7EfbG4G7?=
 =?us-ascii?Q?mAmUnA7UCVQwteFyuHV90ZbhHGHZS2ZWBfwskx0ym5cJ0MpU+XHzpMd3Hs1u?=
 =?us-ascii?Q?1hD+rp9m5zKegU81+gN0w/K6hHCIsLzBwobZ+wxiKM1WDdK7Dq0oiLCTQZDM?=
 =?us-ascii?Q?VQTkF0oZiwY1vat93YOAA0pCq0yNuut5Fls+0VVc6jcOFvQFBEAsSl8dkf6o?=
 =?us-ascii?Q?obOB9Hhw6SMcbWNq4uX7AJCSjj7TW8gnyMiE40YcZIb0+tkJWBO1GJWRjjA6?=
 =?us-ascii?Q?pia6Mv44Pup4GYPfhklmoUWsqGbDkSqQwgrf9r2rmWDhrQIPhtXvF/1GceMs?=
 =?us-ascii?Q?I2+DfdU2nMER8eF5JT29TeJ2MI5LtpcSW/JNaYoIph7UT/IZIUJ1cA9VMy4U?=
 =?us-ascii?Q?YN0zZhqQmqkCMs/1WjpRkUWdPPB2Ph9YyvSRBV+2SC9yf9MjA0N9aY2Tjbms?=
 =?us-ascii?Q?IlVhjxzpAg/LjzvwJ+7OMAt8/gUEJW1KwJNx5hL5cb0alrC7cpzdF1ESKVyd?=
 =?us-ascii?Q?efkxDap8/CgkKlDwxHU7bI+cgBKOesME4LdxKK6lrl4tKgb4gGetmzMirTOe?=
 =?us-ascii?Q?Rma61f9W8kGWYSfoXojaNimosDH6JWkw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 06:38:46.1079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d338c7-cd1d-4308-e71a-08dd1a77a10e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7524

The current code relies on the fact that guest_memfd will always call
sev_gmem_prepare() for each initial access to a particular guest GFN.
Once hugepage support is added to gmem, sev_gmem_prepare() might only
be called once for an entire range of GFNs. The current code will handle
this properly for 2MB folios if the entire range is currently shared and
can be marked as private using a 2MB RMP entry, but if any sub-ranges
were already in a prepared state (e.g. because they were part of the
initial guest state prepared via kvm_gmem_populate(), or userspace
initially had the 2MB region in a mixed attribute state for whatever
reason), then only the specific 4K GFN will get updated. If gmem rightly
decides it shouldn't have to call the prepare hook again for that range,
then the RMP entries for the other GFNs will never get updated.

Additionally, the current code assumes it will never be called for a
range larger than 2MB. This obviously won't work when 1GB+ hugepage
support is eventually added.

Rework the logic to ensure everything in the entire range gets updated,
with care taken to avoid ranges that are already private while still
maximizing the RMP entry sizes used to fill in the shared gaps.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 163 ++++++++++++++++++++++++-----------------
 1 file changed, 96 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 418767dd69fa..40407768e4dd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4777,100 +4777,129 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	kvm_release_page_unused(page);
 }
 
-static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
+/*
+ * Find the offset of the next contiguous shared PFN range within the bounds of
+ * pfn_start/npages_max. If no shared pages are present, 'offset' will correspond
+ * to the end off the range and 'npages_shared' will be 0.
+ */
+static int next_shared_offset(struct kvm *kvm, kvm_pfn_t pfn_start, long npages_max,
+			      kvm_pfn_t *offset, long *npages_shared)
 {
-	kvm_pfn_t pfn = start;
+	kvm_pfn_t pfn = pfn_start;
+	int ret;
 
-	while (pfn < end) {
-		int ret, rmp_level;
+	*offset = 0;
+	*npages_shared = 0;
+
+	while (pfn < pfn_start + npages_max) {
 		bool assigned;
+		int level;
 
-		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+		ret = snp_lookup_rmpentry(pfn, &assigned, &level);
 		if (ret) {
-			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GFN start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
-					    pfn, start, end, rmp_level, ret);
-			return false;
+			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx error %d\n",
+					    pfn, ret);
+			return -EINVAL;
 		}
 
 		if (assigned) {
-			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
-				 __func__, pfn, start, end, rmp_level);
-			return false;
+			/* Continue if a shared range hasn't been found yet. */
+			if (*npages_shared)
+				break;
+		} else {
+			if (!*npages_shared)
+				*offset = pfn - pfn_start;
+			*npages_shared += PHYS_PFN(page_level_size(level));
 		}
 
-		pfn++;
-	}
-
-	return true;
-}
-
-static u8 max_level_for_order(int order)
-{
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
-		return PG_LEVEL_2M;
-
-	return PG_LEVEL_4K;
-}
+		pfn += PHYS_PFN(page_level_size(level));
 
-static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
-{
-	kvm_pfn_t pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+		/*
+		 * Only possible if RMP entry size is larger than the folio,
+		 * which kvm_gmem_prepare() should never allow for.
+		 */
+		WARN_ON_ONCE(pfn > pfn_start + npages_max);
+	}
 
-	/*
-	 * If this is a large folio, and the entire 2M range containing the
-	 * PFN is currently shared, then the entire 2M-aligned range can be
-	 * set to private via a single 2M RMP entry.
-	 */
-	if (max_level_for_order(order) > PG_LEVEL_4K &&
-	    is_pfn_range_shared(pfn_aligned, pfn_aligned + PTRS_PER_PMD))
-		return true;
+	if (!*npages_shared)
+		*offset = npages_max;
 
-	return false;
+	return 0;
 }
 
+/*
+ * This relies on the fact that the folio backing the PFN range is locked while
+ * this callback is issued. Otherwise, concurrent accesses to the same folio
+ * could result in the RMP table getting out of sync with what gmem is tracking
+ * as prepared/unprepared, likely resulting in the vCPU looping on
+ * KVM_EXIT_MEMORY_FAULTs that are never resolved since gmem thinks it has
+ * already processed the RMP table updates.
+ *
+ * This also assumes gmem is using filemap invalidate locks (or some other
+ * mechanism) to ensure that invalidations/hole-punches don't get interleaved
+ * with prepare callbacks.
+ *
+ * The net affect of this is that RMP table checks/updates should be consistent
+ * for the range of PFNs/GFNs this function is called with.
+ */
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	kvm_pfn_t pfn_aligned;
-	gfn_t gfn_aligned;
-	int level, rc;
-	bool assigned;
+	unsigned long npages;
+	kvm_pfn_t pfn_start;
+	gfn_t gfn_start;
 
 	if (!sev_snp_guest(kvm))
 		return 0;
 
-	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
-	if (rc) {
-		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %llx error %d\n",
-				   gfn, pfn, rc);
-		return -ENOENT;
-	}
+	npages = (1ul << max_order);
+	pfn_start = ALIGN_DOWN(pfn, npages);
+	gfn_start = ALIGN_DOWN(gfn, npages);
+
+	for (pfn = pfn_start, gfn = gfn_start; pfn < pfn_start + npages;) {
+		long npages_shared;
+		kvm_pfn_t offset;
+		int rc;
+
+		rc = next_shared_offset(kvm, pfn, npages - (pfn - pfn_start),
+					&offset, &npages_shared);
+		if (rc < 0)
+			return offset;
+
+		pfn += offset;
+		gfn += offset;
+
+		while (npages_shared) {
+			int order, level;
+
+			if (IS_ALIGNED(pfn, 1ull << PMD_ORDER) &&
+			    npages_shared >= (1ul << PMD_ORDER)) {
+				order = PMD_ORDER;
+				level = PG_LEVEL_2M;
+			} else {
+				order = 0;
+				level = PG_LEVEL_4K;
+			}
 
-	if (assigned) {
-		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
-			 __func__, gfn, pfn, max_order, level);
-		return 0;
-	}
+			pr_debug("%s: preparing sub-range: gfn 0x%llx pfn 0x%llx order %d npages_shared %ld\n",
+				 __func__, gfn, pfn, order, npages_shared);
 
-	if (is_large_rmp_possible(kvm, pfn, max_order)) {
-		level = PG_LEVEL_2M;
-		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
-		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
-	} else {
-		level = PG_LEVEL_4K;
-		pfn_aligned = pfn;
-		gfn_aligned = gfn;
-	}
+			rc = rmp_make_private(pfn, gfn_to_gpa(gfn), level,
+					      sev->asid, false);
+			if (rc) {
+				pr_err_ratelimited("SEV: Failed to update RMP entry: GFN 0x%llx PFN 0x%llx order %d error %d\n",
+						   gfn, pfn, order, rc);
+				return rc;
+			}
 
-	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
-	if (rc) {
-		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
-				   gfn, pfn, level, rc);
-		return -EINVAL;
+			gfn += (1ull << order);
+			pfn += (1ull << order);
+			npages_shared -= (1ul << order);
+		}
 	}
 
-	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
-		 __func__, gfn, pfn, pfn_aligned, max_order, level);
+	pr_debug("%s: updated: gfn_start 0x%llx pfn_start 0x%llx npages %ld max_order %d\n",
+		 __func__, gfn_start, pfn_start, npages, max_order);
 
 	return 0;
 }
-- 
2.25.1


