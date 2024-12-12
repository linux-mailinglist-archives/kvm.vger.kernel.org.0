Return-Path: <kvm+bounces-33554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFBD29EDF8A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B25B28437B
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 06:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CFF2204C2E;
	Thu, 12 Dec 2024 06:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VmjHKYGi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D642D204C18;
	Thu, 12 Dec 2024 06:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733985488; cv=fail; b=Q2VFyrpV0445h1UrJ7IKtzfpCsqqI0ymJhKadCrKJ5IwJxYig6cwVkI8z9IVjNmC/T0E5OLPqG9+DwqZ7eCYZ6WVz0KNkm1HSYZh8qktaPzAR5MTycuGRKXdQv/UH1mXfzUEiUFua+CZC742g1XB0n8p8I6U7puvqcCYk4GFWD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733985488; c=relaxed/simple;
	bh=LbEpoVZlO1THU1oztBjmWykLJELBpnTrQEoy5MrNh/4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RsiQHwDpAMq3IG/vytUZBMU0v9NLIA9NVTFDf7bFuX7+5Fc4UI5WfcbqH91wjBSE74FCYHXwXeWPFTN2o17eVK0JioORPP7HsHTP9BLuLS9WsGrgm5P1sVXEjFy1P8TB8pGchYIng2lbuiOUuOF3XsBFux02nS40jXun3J8huwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VmjHKYGi; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Id3ARw30xNEMlQeAv10M5MQlyaiQm7r+QD6bEykBdKXPnCGw8rEt9Rv2Dckw7r0pO0zUR9ALNkRSOEcdUg4NBy+mjfq/MD9VMwhcJO6Y4vIHV4/t4pajBZAjGcYVJqqleLLB8nDo7HUsncs+MpmvMz6+bIoV9g7J+JZximo1p10UIwSXZBJUTwpRqoWxM22mgcOCttGyZixrKWbqoyTEAxFWbKZkKiW/s6b5gr7ImzVzJI4T0ZKss0PKGffJleps1J1ZF2sf1CnQGt/dx0UJKEG2fIKzmg5DZ8CEv8y4i1uhQ+qE/CekABfb3XUP1zX8bkeM0z0sFljPjLfDIaGcAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8++FbLT1BPaInNzV16tlPtGo1oawpAnxszWg7chPq8=;
 b=yviNpo/hFpCoFUW+Qybyo0GtcZ9nvQ63x3fy6dknBQkxOArEHNI3+fUZUv+l0IB0FiZvehlArZb0lThaE8zzpRK1/wy+6W44LdfdUOfIxqGmOgjF55ZkX9LP56eRh06PL/32ZqBAb8iWzt9SbP1QgERDqb90qutXOtUY2dlyNMr5qu12MCgJk+V7zU5uQOMQrSpX91+VK8sunSVM1oSmEyIkC1cXJOsgHN3WHEhV4IXXghXLSnDMcbxpg/YMRLW4dJgQdG94ehbbPEUxHcSCMyl+cD5nNXVCYXvw6H6P3+rlFRgF+NBFZD89BO0H94MHg9PFJ8QIUGGpyKnUWPMazg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8++FbLT1BPaInNzV16tlPtGo1oawpAnxszWg7chPq8=;
 b=VmjHKYGiRJ+9+pehpQxYEPWkUCTD2N5yLBa3soa2zhe9MSRjbWV8VDKUCO76XUD1RAi1gFZAxtbyCwOv1Jmmn001aUZoXjCE0azJsKKVdC2nSzm1f/L/2KNyqqCFcxghU/mKM8ZQg46jKFhZLucXjGV5mgNIpcWElo9gQvtaPlk=
Received: from CH0PR03CA0225.namprd03.prod.outlook.com (2603:10b6:610:e7::20)
 by PH8PR12MB7159.namprd12.prod.outlook.com (2603:10b6:510:229::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Thu, 12 Dec
 2024 06:38:00 +0000
Received: from CH2PEPF0000009F.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::17) by CH0PR03CA0225.outlook.office365.com
 (2603:10b6:610:e7::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.22 via Frontend Transport; Thu,
 12 Dec 2024 06:37:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009F.mail.protection.outlook.com (10.167.244.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 06:37:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 00:37:59 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: [PATCH 2/5] KVM: gmem: Don't clear pages that have already been prepared
Date: Thu, 12 Dec 2024 00:36:32 -0600
Message-ID: <20241212063635.712877-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009F:EE_|PH8PR12MB7159:EE_
X-MS-Office365-Filtering-Correlation-Id: 190b7953-7f2e-4952-8c9e-08dd1a778532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q7h4Ei+ypi9ZG5dGc9Ulaqwy7Vct82PWUyievis5K3KHBFsqe1UGe3AA6fpm?=
 =?us-ascii?Q?Q2qtk8Zw18rXDw8BVnYZ9Nlsvja+iXxPegrCbQr+e8DN5grycsV9l596Gh1z?=
 =?us-ascii?Q?tjF55WkRr8kwZFx3/Xgf0xBTmPoQS9JAlUg3wyd/uhza1qIIsQdlbyfxgoNW?=
 =?us-ascii?Q?9WD4CslzVIfQSa4whptlvLjP/TOTvNLzulBQxUfd1odWuBOxmPplZiUyMy6B?=
 =?us-ascii?Q?5UCFdWdN25FfyUb4jEDPfLN5gHyBQqdLi8ekemjFM7DJlI9PW4jVGNTzTJWa?=
 =?us-ascii?Q?rcEWE3Hq0Yhq0NR3TxxMfBGJbZ6+89CCTJeF3t7CROO643uCG6rPHyTPXYOA?=
 =?us-ascii?Q?HjzAX28CJPv2S0HgnYcf5u1OJkZYzc/4oQp10WsP84z8Phf7YsWbsHl4U7mM?=
 =?us-ascii?Q?MbdV+PNBuwier3WPJx7AeKrvEcrSlbwqo/r+eHwj1MBzmIzK+OJEq2ZJfZVy?=
 =?us-ascii?Q?OpJwRMrIghoUVsSinI7GV1PALtKYU+5Rbv8u4BpwYCg+gBMnaOus076E/KT4?=
 =?us-ascii?Q?CitA51pEtu/iXO6CNF1n715qfT/P1BektGL0vAe5bHKCHlRahpagAZ2bQWpJ?=
 =?us-ascii?Q?P40o4hZwFAaukAy6ZEvCzByWEMsw7n6m6MP9vvny2VOPgPnR/ultv6Cutcq6?=
 =?us-ascii?Q?cG5cNiahoePWmKuLGGhVytyPKulcxfQ3lRlH4O8rfc/FYur+cfJIBwSp63Er?=
 =?us-ascii?Q?ZviX8gwBV7mtQHlDD0mgslHpzI9/1uGKNv9EGvIml8oE4WcYLTOYo5MpQXm0?=
 =?us-ascii?Q?lA5CkAd/KNuoc/YXMezBxSRpJQSvF7kK+UykYt+xroGQLDaIRff8i/DBQt9g?=
 =?us-ascii?Q?1jDote1soQrwDozKfBMpl64MlFVEyopMHlrBtDY/LwIGrGDGWId9anQRZlLA?=
 =?us-ascii?Q?flF0hJaWYwL1AiFfQhVqxIr/pBW8GxsR4HmKO0ap92nM1PO1G/1mxqC6U+UQ?=
 =?us-ascii?Q?3zHSBfOPCcjkGDi8WcAXJwNmJJ1G3QD99JplgWVmlqxQ68H9ztr956ID5S7j?=
 =?us-ascii?Q?QX3wEWotwkC9LC163g+zAdmdRIdpvptqand0OEd6a/R9J5isFAwsfU4dwpId?=
 =?us-ascii?Q?jYVhiwj+d8ujj1AqROXBElKh9++Mx8KpgYrrm1Ai0Rq+wGLIZUlLHWOyoNw1?=
 =?us-ascii?Q?reHxkJ326XSGJmSCNF3JDIZqNvzodaVDttdJU/lTtdT0NPbr77caUOqeLgMO?=
 =?us-ascii?Q?/APRUD8Icj3+M/HK0vmYDRiFSIGiPyzReEeZTogY2wupc4doYsrohIgAbwj5?=
 =?us-ascii?Q?Nbadxe/vr6Ar/dR7macufRnY66QbSG6LZf3+WwzL09IatbMsK1ud9UIUwT5p?=
 =?us-ascii?Q?opLyZfafJtdd7Yrric8RXg02rZktpURP4l9EXJx7z1fj0kmL8yzt6GhgxDEP?=
 =?us-ascii?Q?iu/ztEwPxL9PnycaURGc/uah7oCSBehf+Z75PhDuMGyv3NCl9vsMSf2vWAR/?=
 =?us-ascii?Q?5PucwZC9HxZkBgsGPjUA/7FXkIDpaotc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 06:37:59.3810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 190b7953-7f2e-4952-8c9e-08dd1a778532
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7159

Currently kvm_gmem_prepare_folio() and kvm_gmem_mark_prepared() try to
use the folio order to determine the range of PFNs that needs to be
cleared before usage and subsequently marked prepared. There may however
be cases, at least once hugepage support is added, where some PFNs may
have been previously prepared when kvm_gmem_prepare_folio() was called
with a smaller max_order than the current one, and this can lead to the
current code attempting to clear pages that have already been prepared.

It also makes sense to provide more control to the caller over what
order to use, since interfaces like kvm_gmem_populate() might
specifically want to prepare sub-ranges while leaving other PFNs within
the folio in an unprepared state. It could be argued that
opportunistically preparing additional pages isn't necessarily a bad
thing, but this will complicate things down the road when future uses
cases like using gmem for both shared/private guest memory come along.

Address these issues by allowing the callers of
kvm_gmem_prepare_folio()/kvm_gmem_mark_prepared() to explicitly specify
the order of the range being prepared, and in cases where these ranges
overlap with previously-prepared pages, do not attempt to re-clear the
pages.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 106 ++++++++++++++++++++++++++---------------
 1 file changed, 68 insertions(+), 38 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index aa0038ddf4a4..6907ae9fe149 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -96,15 +96,15 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
 }
 
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
-				    pgoff_t index, struct folio *folio)
+				    pgoff_t index, struct folio *folio, int max_order)
 {
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 	kvm_pfn_t pfn = folio_file_pfn(folio, index);
 	gfn_t gfn = slot->base_gfn + index - slot->gmem.pgoff;
-	int rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
+	int rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, max_order);
 	if (rc) {
-		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
-				    index, gfn, pfn, rc);
+		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx max_order %d error %d.\n",
+				    index, gfn, pfn, max_order, rc);
 		return rc;
 	}
 #endif
@@ -148,15 +148,15 @@ static bool bitmap_test_allset_word(unsigned long *p, unsigned long start, unsig
 	return (*p & mask_to_set) == mask_to_set;
 }
 
-static void kvm_gmem_mark_prepared(struct file *file, pgoff_t index, struct folio *folio)
+static void kvm_gmem_mark_prepared(struct file *file, pgoff_t index, int order)
 {
 	struct kvm_gmem_inode *i_gmem = (struct kvm_gmem_inode *)file->f_inode->i_private;
-	unsigned long *p = i_gmem->prepared + BIT_WORD(index);
-	unsigned long npages = folio_nr_pages(folio);
+	unsigned long npages = (1ul << order);
+	unsigned long *p;
 
-	/* Folios must be naturally aligned */
-	WARN_ON_ONCE(index & (npages - 1));
+	/* The index isn't necessarily aligned to the requested order. */
 	index &= ~(npages - 1);
+	p = i_gmem->prepared + BIT_WORD(index);
 
 	/* Clear page before updating bitmap.  */
 	smp_wmb();
@@ -193,16 +193,16 @@ static void kvm_gmem_mark_range_unprepared(struct inode *inode, pgoff_t index, p
 		bitmap_clear_atomic_word(p++, 0, npages);
 }
 
-static bool kvm_gmem_is_prepared(struct file *file, pgoff_t index, struct folio *folio)
+static bool kvm_gmem_is_prepared(struct file *file, pgoff_t index, int order)
 {
 	struct kvm_gmem_inode *i_gmem = (struct kvm_gmem_inode *)file->f_inode->i_private;
-	unsigned long *p = i_gmem->prepared + BIT_WORD(index);
-	unsigned long npages = folio_nr_pages(folio);
+	unsigned long npages = (1ul << order);
+	unsigned long *p;
 	bool ret;
 
-	/* Folios must be naturally aligned */
-	WARN_ON_ONCE(index & (npages - 1));
+	/* The index isn't necessarily aligned to the requested order. */
 	index &= ~(npages - 1);
+	p = i_gmem->prepared + BIT_WORD(index);
 
 	if (npages < BITS_PER_LONG) {
 		ret = bitmap_test_allset_word(p, index, npages);
@@ -226,35 +226,41 @@ static bool kvm_gmem_is_prepared(struct file *file, pgoff_t index, struct folio
  */
 static int kvm_gmem_prepare_folio(struct kvm *kvm, struct file *file,
 				  struct kvm_memory_slot *slot,
-				  gfn_t gfn, struct folio *folio)
+				  gfn_t gfn, struct folio *folio, int max_order)
 {
 	unsigned long nr_pages, i;
-	pgoff_t index;
+	pgoff_t index, aligned_index;
 	int r;
 
-	nr_pages = folio_nr_pages(folio);
+	index = gfn - slot->base_gfn + slot->gmem.pgoff;
+	nr_pages = (1ull << max_order);
+	WARN_ON(nr_pages > folio_nr_pages(folio));
+	aligned_index = ALIGN_DOWN(index, nr_pages);
+
 	for (i = 0; i < nr_pages; i++)
-		clear_highpage(folio_page(folio, i));
+		if (!kvm_gmem_is_prepared(file, aligned_index + i, 0))
+			clear_highpage(folio_page(folio, aligned_index - folio_index(folio) + i));
 
 	/*
-	 * Preparing huge folios should always be safe, since it should
-	 * be possible to split them later if needed.
-	 *
-	 * Right now the folio order is always going to be zero, but the
-	 * code is ready for huge folios.  The only assumption is that
-	 * the base pgoff of memslots is naturally aligned with the
-	 * requested page order, ensuring that huge folios can also use
-	 * huge page table entries for GPA->HPA mapping.
+	 * In cases where only a sub-range of a folio is prepared, e.g. via
+	 * calling kvm_gmem_populate() for a non-aligned GPA range, or when
+	 * there's a mix of private/shared attributes for the GPA range that
+	 * the folio backs, it's possible that later on the same folio might
+	 * be accessed with a larger order when it becomes possible to map
+	 * the full GPA range into the guest using a larger order. In such
+	 * cases, some sub-ranges might already have been prepared.
 	 *
-	 * The order will be passed when creating the guest_memfd, and
-	 * checked when creating memslots.
+	 * Because of this, the arch-specific callbacks should be expected
+	 * to handle dealing with cases where some sub-ranges are already
+	 * in a prepared state, since the alternative would involve needing
+	 * to issue multiple prepare callbacks with finer granularity, and
+	 * potentially obfuscating cases where arch-specific callbacks can
+	 * be notified of larger-order mappings and potentially optimize
+	 * preparation based on that knowledge.
 	 */
-	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
-	index = gfn - slot->base_gfn + slot->gmem.pgoff;
-	index = ALIGN_DOWN(index, 1 << folio_order(folio));
-	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
+	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio, max_order);
 	if (!r)
-		kvm_gmem_mark_prepared(file, index, folio);
+		kvm_gmem_mark_prepared(file, index, max_order);
 
 	return r;
 }
@@ -812,20 +818,31 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct file *file = kvm_gmem_get_file(slot);
+	int max_order_local;
 	struct folio *folio;
 	int r = 0;
 
 	if (!file)
 		return -EFAULT;
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
+	/*
+	 * The caller might pass a NULL 'max_order', but internally this
+	 * function needs to be aware of any order limitations set by
+	 * __kvm_gmem_get_pfn() so the scope of preparation operations can
+	 * be limited to the corresponding range. The initial order can be
+	 * arbitrarily large, but gmem doesn't currently support anything
+	 * greater than PMD_ORDER so use that for now.
+	 */
+	max_order_local = PMD_ORDER;
+
+	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &max_order_local);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
 		goto out;
 	}
 
-	if (kvm_gmem_is_prepared(file, index, folio))
-		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio);
+	if (!kvm_gmem_is_prepared(file, index, max_order_local))
+		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio, max_order_local);
 
 	folio_unlock(folio);
 
@@ -835,6 +852,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_put(folio);
 
 out:
+	if (max_order)
+		*max_order = max_order_local;
 	fput(file);
 	return r;
 }
@@ -877,13 +896,24 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
+		/*
+		 * The max order shouldn't extend beyond the GFN range being
+		 * populated in this iteration, so set max_order accordingly.
+		 * __kvm_gmem_get_pfn() will then further adjust the order to
+		 * one that is contained by the backing memslot/folio.
+		 */
+		max_order = 0;
+		while (IS_ALIGNED(gfn, 1 << (max_order + 1)) &&
+		       (npages - i >= (1 << (max_order + 1))))
+			max_order++;
+
 		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
 		}
 
-		if (kvm_gmem_is_prepared(file, index, folio)) {
+		if (kvm_gmem_is_prepared(file, index, max_order)) {
 			folio_unlock(folio);
 			folio_put(folio);
 			ret = -EEXIST;
@@ -907,7 +937,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
 		if (!ret) {
 			pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
-			kvm_gmem_mark_prepared(file, index, folio);
+			kvm_gmem_mark_prepared(file, index, max_order);
 		}
 
 put_folio_and_exit:
-- 
2.25.1


