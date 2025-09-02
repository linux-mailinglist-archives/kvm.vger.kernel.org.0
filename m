Return-Path: <kvm+bounces-56535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A5DB3F787
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CFF57A8600
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C389225A328;
	Tue,  2 Sep 2025 08:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XhBnInmr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508DE2E8B8C;
	Tue,  2 Sep 2025 08:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756800235; cv=fail; b=EX037IMaIQQZKANdYHK88suj63kEGJQLgM5LRADJ9LqUXxTvfijF54eT9/atkKmDHkWNMrH926smKIF1T6H9e9f6Ep6rpdhSH98Q+Q7WLYq4aXy1G0HGG9BHceSu9YVxBygnQPVpCxrsj4Hz6R9WaxRZ7OsoMvIhS8oyZM7M28Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756800235; c=relaxed/simple;
	bh=DTRC8baTVROgYcnW9yQ+xgWwXHi0DAwqI9im0M+sojg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CoAb1X7mV30Quw2z7ZWUZwNSDkmnt5SWS1kJXGwME9i+Xs6KcMaxXqbaFwGBfM6+a723P0WAfb/MdDxLSq+H9LI8k/bN7IWlYBSSxzB3NjYp3BPxu7aUQf2qD1xF/P9Eyv8idTl4s/VmFrwwenxNJY3aVHBWb5E3AZRG2n+9iaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XhBnInmr; arc=fail smtp.client-ip=40.107.95.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QERlz2RLDO/C5/l6IRMffPJeQHUr3mX5ReeaFl699Hc128LD39oyklw/NeOXCEnDBr8U+j1YjHl1cbjT+anFNKkFXsci6J9P4CB9e86rW/4qYE0a+FWDhCFoXxjdABZOQYIID4LXfflnH6ggWYOsPY9PZUQDkN7WBUJuIYvt3Yop0GKq6o6dnFg0uKBIymN0Tj3lWW2nfNUOiOW420Az1MUugjaxJ518X0A6gH5LWxqlmxb8iW6hpOxDPwGtm2FrGX/iSGHC1TR+5Qt3BkIqjChMuW+n7sBxydcPr6LreXKwmcED3hM84rEx1/S4R4NqdV8azgmbmHWanDDqCrEJeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUwRDQuF/MfCItz9I6B/voS4djqL4zjmGk1P4DPB2K4=;
 b=QkbnQ50tGMb5Bi8OzEBpD5hWBmR/6D7oPRP9eJiCygy9Z2m7BD0XOBRGzUe2jVkBpG2uWtVvEwRA4uZQ6IvaR9My8w+vmUwYu2+E+TKF14hIH1cM93vYj2nmubemn5mH1S82L7na6+UX/esH5YuSorpeuxPCa83US06TfoeFgNVnadE2Ijo0+BleRl7+JY2ntATLoD3hhgLutKGkco0TabVzE5f9PfK+zSxdVL/4RE/poMqkjFPAxoiY4heHluOKF2WVlMi0wd0b1Lb540j7HigOfVfLUz2CAcR9pYrk2oriVxjvPoChiIHzOYjgIMsTe3V+6h+Yqmv6eeuZO5suYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUwRDQuF/MfCItz9I6B/voS4djqL4zjmGk1P4DPB2K4=;
 b=XhBnInmrTS5AS1Zk3+QCSaF4dpFv2lyRiXzgSgzPuZh1UuJygVCgpOUU5q4Gwa19GTl2lmePfj+k+SAqBrDCFqy8sCpZ8GvhDJX7hG6A7V4nf0KJ+whKx9gITOgeCBAWZX8HDwDvbnpGwrWSgc/hp2gHZIaIwWIdFNTGa1/5Ps0=
Received: from CH2PR19CA0013.namprd19.prod.outlook.com (2603:10b6:610:4d::23)
 by PH8PR12MB6747.namprd12.prod.outlook.com (2603:10b6:510:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 08:03:51 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::a8) by CH2PR19CA0013.outlook.office365.com
 (2603:10b6:610:4d::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Tue,
 2 Sep 2025 08:03:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 08:03:51 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 03:03:50 -0500
Received: from kaveri.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 01:03:48 -0700
From: Shivank Garg <shivankg@amd.com>
To: <pbonzini@redhat.com>, <david@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <shivankg@amd.com>
Subject: [PATCH V2 kvm-next] KVM: guest_memfd: use kvm_gmem_get_index() in more places and smaller cleanups
Date: Tue, 2 Sep 2025 08:03:08 +0000
Message-ID: <20250902080307.153171-2-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|PH8PR12MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: bb6397a1-acb7-4ec6-0152-08dde9f74136
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vMzDU8A/UXWinBg0rsG6W4yjJbN8Se04U+7vakPDPnDWDZjW17jGHZm90ij+?=
 =?us-ascii?Q?GiyBLQB5+rRQ7SKOtSwgoOgFTvbCxU3oXGrlZT5RdkhmGIE+gPenI+YM7ErZ?=
 =?us-ascii?Q?/9FZGVOQ59iKlnEHBQBx9lWWS7fdPjzdsWqFmrlyKQr9yufyB88X2QRm1gst?=
 =?us-ascii?Q?6sabpwoVLtokm/Nwrci6cQxR19Y6MXjrQ++LoOBR04z1rwM7IXXvo9DWAwPU?=
 =?us-ascii?Q?BlAGOVcEv3MWWz3dyXYPvNBgdP91eREOHpB50oXMZG5sKSQN82jvSQESxAzu?=
 =?us-ascii?Q?mWn7joUvqhDfdhycUR3TwlD2yeB37tyjPpnLtKOUqL4eSzjMNDiY2rTqrVzL?=
 =?us-ascii?Q?bOj6wSvFkOdS6q/sk4mjPSr/ma4nBXWZiXvjswaIg7g1YA9K7W8IH3G/eExt?=
 =?us-ascii?Q?REjlmP7ROxrymnfRK3Qvg8ImV35qHnznOTx6kGZ0OGtgEHV7aLFQR+H/y/w6?=
 =?us-ascii?Q?MenVg2Kn+auohLGWFW2yQsu+xaSnXfLRCR4TSFDcnaP1Mk3PwtzhT/MgY1nA?=
 =?us-ascii?Q?AlFu5bImNt9CbuUtsO4QhJ61GDMj102OuWPK1dYqFgvy9vumyL185LgR8Gcw?=
 =?us-ascii?Q?SrCkEqwu3ZcCjmK+lNvzeoUqwAAeMaPYrKm3vz2CTggYeC2aYn+ncW4iq25Y?=
 =?us-ascii?Q?vsK3He6/BwXNkzJ2P5ZqwL0aKC92pf/QTtkaSsyzkYWS45aZMJZXV82dYrdG?=
 =?us-ascii?Q?8jh9kXgnX9cWYXg4aCDxLnM6hT+2rP5c0RCx5VldjpxSxYNQ45bw/qVRuMqM?=
 =?us-ascii?Q?/Z7uyS8XlC2t8upwqijZjbAZF5fx1iClq0EFLEoL0K6sw4ZU/U6AI17wPjMI?=
 =?us-ascii?Q?NKqbW9KQ0kpQcra8SoJGwcxja2yEzQM3oKZi5acRrbi3cFxnIFJADnSiTm/u?=
 =?us-ascii?Q?e2wATmx35bhQAAavrje3Pc1Ga/ATRqHE4WXH0lW/uv+KXp7FgGXT6SvrdT6d?=
 =?us-ascii?Q?bLUlEgtwkgJrRANfhHW83OvCA1/xnheyCBxWx6095t290bSl/wKVukET7pIt?=
 =?us-ascii?Q?gwld/9CYeO1p9edywajfnjay2ZhQ2TVprbuqJftJJOpfCgCDw+CT/XLXdKm1?=
 =?us-ascii?Q?0czls0hxaGZSDb1Bt0dSxzgVxc8RxmwA/SIZumcMRuaky4QSAvjlR2iIkHHl?=
 =?us-ascii?Q?uyQ7Bvpn/OS0hwOnPJd81JonH8qF3cJKrSErvSS6o/nwi2gRKW+TP2QFwEQv?=
 =?us-ascii?Q?5XlHLLVW6Klu2E2Lamvog/pHQBOYZ4mE4QSnjK5rsMAkj7Yoxnzhg667Obh/?=
 =?us-ascii?Q?CKb+RKzG91SyCiZSho/7//WTwphHRpUiV/HA3E9GBYoYDPUbKzsQWu7fEXiC?=
 =?us-ascii?Q?pLw1DVBfk4tNKDFAewdUegBfN7E41JIUSPDNZSOSby5d1tR2FPQUXibcPKwx?=
 =?us-ascii?Q?ZNiSXEspDYfC3YmhRez3SwGP+vLxUJtCkJT/xWpBiU8tTUMd9U3RhBtBH7MG?=
 =?us-ascii?Q?HwwonsEIhImjqr/hmi+OJFcpQQnpoBglfsTEZpsR0uotRKvQFSMtlOINCaYX?=
 =?us-ascii?Q?0xtg4Fwz9IJIJfVq4RsgoYDgDnTM2Lg7iGs18QeNtMXCxLJjnkDsl0Ak2w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:03:51.6192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb6397a1-acb7-4ec6-0152-08dde9f74136
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6747

Move kvm_gmem_get_index() to the top of the file and make it available for
use in more places.

Remove redundant initialization of the gmem variable because it's already
initialized.

Replace magic number -1UL with ULONG_MAX.

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Applies cleanly on kvm-next (a6ad54137) and guestmemfd-preview (3d23d4a27).

Changelog:
V2: Incorporate David's suggestions.
V1: https://lore.kernel.org/all/20250901051532.207874-3-shivankg@amd.com


 virt/kvm/guest_memfd.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2d6ad80f54c..1299e5e50844 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -44,6 +44,11 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
 	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
 }
 
+static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return gfn - slot->base_gfn + slot->gmem.pgoff;
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -51,6 +56,7 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	kvm_pfn_t pfn = folio_file_pfn(folio, index);
 	gfn_t gfn = slot->base_gfn + index - slot->gmem.pgoff;
 	int rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
+
 	if (rc) {
 		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
 				    index, gfn, pfn, rc);
@@ -107,7 +113,7 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 * checked when creating memslots.
 	 */
 	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
-	index = gfn - slot->base_gfn + slot->gmem.pgoff;
+	index = kvm_gmem_get_index(slot, gfn);
 	index = ALIGN_DOWN(index, 1 << folio_order(folio));
 	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 	if (!r)
@@ -327,8 +333,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
-	kvm_gmem_invalidate_end(gmem, 0, -1ul);
+	kvm_gmem_invalidate_begin(gmem, 0, ULONG_MAX);
+	kvm_gmem_invalidate_end(gmem, 0, ULONG_MAX);
 
 	list_del(&gmem->entry);
 
@@ -354,10 +360,6 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return get_file_active(&slot->gmem.file);
 }
 
-static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	return gfn - slot->base_gfn + slot->gmem.pgoff;
-}
 
 static bool kvm_gmem_supports_mmap(struct inode *inode)
 {
@@ -940,7 +942,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 		return ERR_PTR(-EFAULT);
 	}
 
-	gmem = file->private_data;
 	if (xa_load(&gmem->bindings, index) != slot) {
 		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
 		return ERR_PTR(-EIO);
-- 
2.43.0


