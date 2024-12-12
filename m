Return-Path: <kvm+bounces-33555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D968F9EDF8C
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75314283FAC
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 06:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271DB204C31;
	Thu, 12 Dec 2024 06:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Luiq8S4E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77C9204C18;
	Thu, 12 Dec 2024 06:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733985511; cv=fail; b=pCYDWiXfJwYaXXbg8+oqnGJ8xjH9eQavUw6cQYqTxeq5e+viglPaYr1qZ+6baweR6ikHLoOX/S2WIqsbjDc/Ab+jR1VHrPybHf1astc3Q8qHmRpjj3MiVNb2cV0Do3XqWxQ2eTLNvfP6ZmslywgDPpyv8zi7VHAluuChHogpGI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733985511; c=relaxed/simple;
	bh=/U3Z3glLZUhwxfpxBGOK/7Yo6Qft9bQAcmaTSDVigH8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=axj3GT6Sgeh3czjGsJbgSbldO26GXd2OHeEHOY+stv1ia/0Dl7Wo2G7qwTOi36+Ezg3Kilm7ViL8ljLR3pmAd0sFtoaDL0nXoc5/R5cwPm4tE9ABtOVVGro8I9RlPykfUPQ+p5qm3at5BL4iPGiOukKXXoMcJk7DGy0CdvctqeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Luiq8S4E; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xtau7Aqv+u6p3il7C31tUgPiAltOmXOp24rTfwJnaz38Azg2DZLSwJxjdaNm0gMcqWw94zRfxCJJnjP3fQzwRFrbLGN2B0/J8FZNiDIo2p+fbTn3E/Q3KAJzELBThWGeL5wqUxNWuBOEewVRlF8Db4h44WlCpy4VSGKMdXggpXlidfHHk7XOAjViuLsysjHgK6/g4F6PlcV20sKFCLmiMuGLlz/6ITqrYTMSzyOV6WBqrbc9+zfOHbVQF7INwlypY/5/G7czoBBuoiR3DCrBNdnlLt2zIhbPf53unZ81k/HltUsO3pKB97h6r9O7ymakJVrHcVTy4ve6a8WB6hKXsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9XYF0QJO5+ytlz+nk9KzbhWH+1hy5p4tpp3erNpAR4=;
 b=yPJ7wQrsNtWgxPBEzBTLreYoBNt5tA60zxhMQkAMkFCiFfP9hWtGhQMKLaJOcvgJMrmS729xrclmn+k2Ykwd8T56Sxw4EA2tmv4Own37e5CaXZSpAOGv7ZqqD3hyTaYv0CySm18d/6ag337aWHvROooxuoNyBTCCYixTCkpH7NP7WeY6gzdtBeZxMdEecuM5XgPZOBhrCO+tOO3Lq3/vjLqWgopXLPWdoOx22gPJ+4WNuGPsQzKSrU4h7Kqp8gl075LtkMfjAV5Z6cTES4N88/53FqOwLOycfwINq8kS/qNsgfrel12Ue0tOCu0pr5GHE6Ebo3Df2jAsJkLETB85Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9XYF0QJO5+ytlz+nk9KzbhWH+1hy5p4tpp3erNpAR4=;
 b=Luiq8S4EpjzAZbRSNr3OEZ6mYgWZqjTTmBGkkt4i2xaY0+3XY3V5QUY2bKMvW0HEV5brlzlTMOxjBhT+HjUm1EAcSSPRTTD0gWPGgm1sUqCmGcieovqwxDHTLIjna24b0q3bwIbrQPOnl2nWU83lUeNVy6irA997gAwuy1UIulw=
Received: from CH0PR03CA0234.namprd03.prod.outlook.com (2603:10b6:610:e7::29)
 by CH2PR12MB4184.namprd12.prod.outlook.com (2603:10b6:610:a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Thu, 12 Dec
 2024 06:38:25 +0000
Received: from CH2PEPF0000009F.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::b8) by CH0PR03CA0234.outlook.office365.com
 (2603:10b6:610:e7::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.14 via Frontend Transport; Thu,
 12 Dec 2024 06:38:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009F.mail.protection.outlook.com (10.167.244.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 06:38:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 00:38:24 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while allocating/preparing folios
Date: Thu, 12 Dec 2024 00:36:33 -0600
Message-ID: <20241212063635.712877-4-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009F:EE_|CH2PR12MB4184:EE_
X-MS-Office365-Filtering-Correlation-Id: be83d3cd-20d5-40b0-210f-08dd1a7794df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oN/MTV2i7zVlEcCb9zpOOX8bxmXnV/KyZYy70+wWj9RvacoX2P0g1wHrEllM?=
 =?us-ascii?Q?09A4GWQENKNvqdoowKL5HXi8y/SY0y5ihia/j2anghIYALZIs8xq3ZHgp31I?=
 =?us-ascii?Q?At+0W0D8fIyjVc747STmbSrrPLNs9W/OE42NMrsR6lUWOfp21OHxwHSPtqud?=
 =?us-ascii?Q?YpBf1jYwpi/e53TzVvqO+N3EsUkq08JGiB51lWZiYkLZFp0S4fuewQo/2BZ5?=
 =?us-ascii?Q?EEQR3sZ/Qa/YYBFAAHzQaTQ7XBzfeiM7CX7NGQu2DCscdtqAWkYO4TxxeAja?=
 =?us-ascii?Q?2mhIAzdJ/eZo03Cvz7NKOvmZ3E973IisafCtPBFgz4VoEgLFvBFZZH3eODXe?=
 =?us-ascii?Q?4h240dPs95ppYgfxNY3acEJjyoZyPIcm/FRxlTLc08LGAQvvFiEXM1Vb14i+?=
 =?us-ascii?Q?bh623cEcW/Bz3zuY+HZYoAu5HikcJIVlDXTghNEd73CBc0RqKALHKImDRddV?=
 =?us-ascii?Q?FmC0kd9mVGb9dhxLytQRwTG+9zkBVR4KYX2EJXLwLa2y/ShE6AWqcsmb04kG?=
 =?us-ascii?Q?Tvh7IRe+cBNrw4MKrIRV49RYwcc6ZMcFnnYLO0Tq5oH3TiJjV0ig6NExCwGy?=
 =?us-ascii?Q?4HIMI9e0DyrlM9bhKmSFDHYX+Hts1e8iT6nHtxwduxrQJoNuH+UjDHALjoL/?=
 =?us-ascii?Q?lfs9TqRwtNMRIx/RoZSdeW+r1S7HCJbescChOSArYg1U1GigAjCfomo6wcEi?=
 =?us-ascii?Q?ImJ9iUTRPkeuhfq163FDRT2IhClAGKLzy0fPSnIUzE3GBi2E+gkWihLEYqSj?=
 =?us-ascii?Q?sS6jcJJs/FAWwn1kDFzHN3zrt+v0jGtdDUPHnT/CbWvXOybYu3tbHSJKN+Zs?=
 =?us-ascii?Q?hCZGP5tKy4rkelz5Zjvr1n+7b2MdmC4e5oapIS+Ho+i85MyzhvYLFty7MGB5?=
 =?us-ascii?Q?hlXeI+Gg+qOsBMMaoWYjGcA57KRjbpmE8KrsGyuim90+sYnZnhlnnQNEQo7c?=
 =?us-ascii?Q?8SglhyP+XnZSWMy07WD9dmm6yxSFGcEEhXzqy4tBclswBmYI/hrJdnUNrNYW?=
 =?us-ascii?Q?yyjNIgOiPgD71YC0181y7/0xI5c+B7BBDfv4kDTOMwHEe8+FEM4AblU918nb?=
 =?us-ascii?Q?Lrd1rb6XjE9wjwJJZTwIQCgD21/jE902nOVjjmGDL05bnkw/UziXSZfLBN2N?=
 =?us-ascii?Q?YaCjdjk6KXuf4KwJbcU0gEJzw/APwBa8UZEIwRZ8h6Gvy/iEOS8kXgTnSZ/C?=
 =?us-ascii?Q?l5UWj4NmwhOZzT45MVxHU8G9jGaPbPVjzD524RPe4g2hMr7NHFkDn4CvzRtm?=
 =?us-ascii?Q?fbr7hKK0QH1qrqySchBtYTIUS/wtdI3NKrRCb2d4Ok5X0jvfScyLkCKrSQBu?=
 =?us-ascii?Q?5d0GtkJQEYUrKVA5btLGAJ/1BFGuhcv6V8qd9DN3AFjGAg+AGuJ4T0Nw64fV?=
 =?us-ascii?Q?ZyEqfydpebW/P1gNLhHu1sBtIowl8jJ9aN0kv0sPv+Sg04am68eGrWOuGprU?=
 =?us-ascii?Q?91sLgW86Lrtsny/LVdrRljTRd5l3eYdl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 06:38:25.6309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be83d3cd-20d5-40b0-210f-08dd1a7794df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4184

Currently the preparedness tracking relies on holding a folio's lock
to keep allocations/preparations and corresponding updates to the
prepared bitmap atomic.

However, on the invalidation side, the bitmap entry for the GFN/index
corresponding to a folio might need to be cleared after truncation. In
these cases the folio's are no longer part of the filemap, so nothing
guards against a newly-allocated folio getting prepared for the same
GFN/index, and then subsequently having its bitmap entry cleared by the
concurrently executing invalidation code.

Avoid this by ensuring that the filemap invalidation lock is held to
ensure allocations/preparations and corresponding updates to the
prepared bitmap are atomic even versus invalidations. Use a shared lock
in the kvm_gmem_get_pfn() case so vCPUs can still fault in pages in
parallel.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6907ae9fe149..9a5172de6a03 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -154,6 +154,8 @@ static void kvm_gmem_mark_prepared(struct file *file, pgoff_t index, int order)
 	unsigned long npages = (1ul << order);
 	unsigned long *p;
 
+	rwsem_assert_held(&file->f_mapping->invalidate_lock);
+
 	/* The index isn't necessarily aligned to the requested order. */
 	index &= ~(npages - 1);
 	p = i_gmem->prepared + BIT_WORD(index);
@@ -174,6 +176,8 @@ static void kvm_gmem_mark_range_unprepared(struct inode *inode, pgoff_t index, p
 	struct kvm_gmem_inode *i_gmem = (struct kvm_gmem_inode *)inode->i_private;
 	unsigned long *p = i_gmem->prepared + BIT_WORD(index);
 
+	rwsem_assert_held(&inode->i_mapping->invalidate_lock);
+
 	index &= BITS_PER_LONG - 1;
 	if (index) {
 		int first_word_count = min(npages, BITS_PER_LONG - index);
@@ -200,6 +204,8 @@ static bool kvm_gmem_is_prepared(struct file *file, pgoff_t index, int order)
 	unsigned long *p;
 	bool ret;
 
+	rwsem_assert_held(&file->f_mapping->invalidate_lock);
+
 	/* The index isn't necessarily aligned to the requested order. */
 	index &= ~(npages - 1);
 	p = i_gmem->prepared + BIT_WORD(index);
@@ -232,6 +238,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct file *file,
 	pgoff_t index, aligned_index;
 	int r;
 
+	rwsem_assert_held(&file->f_mapping->invalidate_lock);
+
 	index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	nr_pages = (1ull << max_order);
 	WARN_ON(nr_pages > folio_nr_pages(folio));
@@ -819,12 +827,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct file *file = kvm_gmem_get_file(slot);
 	int max_order_local;
+	struct address_space *mapping;
 	struct folio *folio;
 	int r = 0;
 
 	if (!file)
 		return -EFAULT;
 
+	mapping = file->f_inode->i_mapping;
+	filemap_invalidate_lock_shared(mapping);
+
 	/*
 	 * The caller might pass a NULL 'max_order', but internally this
 	 * function needs to be aware of any order limitations set by
@@ -838,6 +850,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &max_order_local);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
+		filemap_invalidate_unlock_shared(mapping);
 		goto out;
 	}
 
@@ -845,6 +858,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio, max_order_local);
 
 	folio_unlock(folio);
+	filemap_invalidate_unlock_shared(mapping);
 
 	if (!r)
 		*page = folio_file_page(folio, index);
-- 
2.25.1


