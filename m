Return-Path: <kvm+bounces-56400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C73B3D887
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF57B178655
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C41A2033A;
	Mon,  1 Sep 2025 05:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Yv5WjgD1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDA633D8;
	Mon,  1 Sep 2025 05:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756703793; cv=fail; b=tFJtjRt1/QHB5g9yEJzxmNgZ7QlRrb67h4CJIeiXauMFYMVEwHK7oijTyLNGHxdzmlFL+fBjuTqnwyGn+DRkXNX6LwDRFC5BxTGxVfVkIqh9gj+TzV6++0CxcklN5eRRa2JdKWCbyN2Uxe+l1+/hN4g2VZcfn+cSIJnH7iMK/kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756703793; c=relaxed/simple;
	bh=r8V4MdJOw8Vk5CuTrgyBgFiqBN1f6YbzBMT5Jhb7Ae4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aK8UZ4rp5dEK8W+Z3HizE3a1jLpl38cyNDiiVQeQRtid+QDdkJfdml/7pjupoKZYdU4ZAiUD+MTFAQvNY5KeQkgjlajXt8vdE8uFpCDmRxZ827DmxU4N5lNXE7/q/CroENrISvEI7h4oOaBHo24Gu1cYE1Rwg8kzfSYGbMPiubI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Yv5WjgD1; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J61o/9C9bcZjhcyp9yrtNFrzpfFHYcCN1IS3YOHOowKVMuqkE84e16EuoMPlMTypHQUiBfsShYQWEesXg7XAzLk1y89zdTNeX7Z7cK9yU7qpLTLxQHzDQY2LEczxPqaLKh/vtMldpHnglM6PBApLzz+nd9xJa4OAj2sFgS48Ce5tLmz1whSmzH11bYVW0B/08t3CNP6pS6hUm4vFLk24bRtgWjLLqWFdbP3qGi/Fnj9fpN1EdUMAIoPnHRNftJ0G3n/jtmi5KNNx38B4B6A/NVNI+JWL04rcBJ0leMitMZ1e4cHmsqfoH0OB+UDhiBmEdbBWcI5CS4Ye9rSfHKUXXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhXfOjQC83Z1bt5svUICR2456jIfocxiPt6obYUFkvE=;
 b=TREhY7Nyw4XJ/HL8jnTPEGy7OLV0GSSitk/vPRuPoZ5INPiDWJOkKyTSUwlaQGRowIZJMyaBEDPbZSFJvJFnH6SjcuPLe57PMq//tyZ9nBCZrRNUOlQjDWyo7yMVwpS9dNs62kBeVce9XdUVYiv1d4LcgkXM5AOloOk7z5rpZrSCH1/VSR35ODy7z3Y8NbLoxangqBs0QzME6JuUYVK4k6set4nP/X5F/84SOY5dfm5W9UMN+1vF9UVaotvprD7TAKthSa/GWfEOzgCeWVO+yT3f0flqynavCcM8AEYx+n9hacQeRTH4jUtceBpAZDRTltW3Wuqn753yMzEkugBlKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhXfOjQC83Z1bt5svUICR2456jIfocxiPt6obYUFkvE=;
 b=Yv5WjgD1Tm8sX0UjsjR7PSE6DwGgoSCk3GuGxJH/tyb6GihfM4grl6Dw09iBYK2JAL3q1fKAwHRRb8lctJbNziFYEOI9e4DIm10WjVxHNDgOZ+8TjHyXeAH/HdBly6mB1DQBvJ8cIK6L+yaNNskjgPV6rl1GPe9g0PVkPk6gATo=
Received: from MW2PR16CA0039.namprd16.prod.outlook.com (2603:10b6:907:1::16)
 by SA5PPF634736581.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8cd) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 1 Sep
 2025 05:16:28 +0000
Received: from SJ1PEPF00002317.namprd03.prod.outlook.com
 (2603:10b6:907:1:cafe::9a) by MW2PR16CA0039.outlook.office365.com
 (2603:10b6:907:1::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 05:16:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SJ1PEPF00002317.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:16:27 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:16:26 -0500
Received: from kaveri.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:16:23 -0700
From: Shivank Garg <shivankg@amd.com>
To: <pbonzini@redhat.com>, <david@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <shivankg@amd.com>
Subject: [PATCH kvm-next 1/1] KVM: guest_memfd: Inline kvm_gmem_get_index() and misc cleanups
Date: Mon, 1 Sep 2025 05:15:34 +0000
Message-ID: <20250901051532.207874-3-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002317:EE_|SA5PPF634736581:EE_
X-MS-Office365-Filtering-Correlation-Id: ac333d52-e4ad-44c8-0d0a-08dde916b439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1e8ZP6zxTfmORq0kHNSQJCodna+wS7Wl4Y3dqwiw1kcybdK8pbaZIogC8C23?=
 =?us-ascii?Q?z1HHFtvdyY1A1npUW3yOkdqtsUSvx8l8hkFlyKshN7vDB022ouWcgYc0mO5u?=
 =?us-ascii?Q?vrZA8ihHv9CvCNDo5nrL9V4Ee0VI/NtSW31bvpTQ9Ml1eM5Sper3R5eIuHrt?=
 =?us-ascii?Q?7siutKCRyqzKBeP9TULqPKkRhpFpLOf5T5WdwNC0hyXjwILZYr5XAWDYrqXo?=
 =?us-ascii?Q?gFuC1ZnhB6pHPoLC3uOIEbnd1xm51DprCese6EW5MxngoazDNOd7Hvgvst1W?=
 =?us-ascii?Q?tiinDKAyGmt8O7k+9P9RMCDYrXsvcK+Wfg45tuaCqkTOks/Z+hHXcZpcxIPo?=
 =?us-ascii?Q?MMxMP5O/2yVALsL+ITE9/0bST+rVhQ+NTjRHzBR9fqIS2ophOQE7QxZnshID?=
 =?us-ascii?Q?dYX5siPsavIJFWG7ZpRmW+2n2Jyz/Su3T2yp+5MMh9p4fDxuwn/A9UL3IDJK?=
 =?us-ascii?Q?+NsJ/DFj9068qJMe+vZsJSG0xRRF1uDFElTDdhyeeshhW1wd3uezPtb3zEA0?=
 =?us-ascii?Q?mmv5x/qdQnLK+6DdVt61sbsFt0OyQlQvzdLU1sgzfq7exWgWBSWq/fiFhz/a?=
 =?us-ascii?Q?LSAjPbioItwBYzp6lP3gz9Begk3eH86yPMroK4mJaxcmjClCCYR2bGEp7Rmq?=
 =?us-ascii?Q?gMp8U99xtaknHLcdI2HnO9X1DQ/eYBUOlBJtbiQF+9gZzyGvWwGHY/wWzLnk?=
 =?us-ascii?Q?elGvStNlWm7acle1ioNydpGTG0M7IS+qr9+nilrof1QbKJY+bJkuCjmft0hq?=
 =?us-ascii?Q?r+Pb/QeQwlzx7sM858q5AFZbOGaKI278bssbtgL42JgoUk7VAC+FRuCtc+IE?=
 =?us-ascii?Q?tM7NL3b1JWSi2TEG/NzzjkI4iN+0UApZnEpogsV2IDKrpCV5ARoMhxKPjO8l?=
 =?us-ascii?Q?+YeISYK4yUXGvgn1Cwg4sp7Pt/Mgd0WkfA6/WCN3eK/FRM489/+Fbv0PGdDa?=
 =?us-ascii?Q?TuqNG6IbC6aix27HhWn0qTDdDGPyu200NuMB+kL7LSerEwXdZZRWUloTMjNv?=
 =?us-ascii?Q?A2seAR8yq6B1awj2l9a6vvyEt60PkWwQYMIr5FnA6tz3lvGzfwXxYJOak9O9?=
 =?us-ascii?Q?5GM4ewf4LqemELGh9hLQ3mJGFAILkzV9vm9J7hHYoYpK/U2YoaLGUi5xJuGG?=
 =?us-ascii?Q?Yv6PcspmUPatcNRexaTOZnXHYcEu7zCy2o03W4JPbrdoo6699JUN1hRZ+E3y?=
 =?us-ascii?Q?axl91FDzR89dNNSDiKbKCFmj3kTqZse4Us8CbtNxLZ3yOJvkwc6MacxJOw0V?=
 =?us-ascii?Q?C5T2aS9SxKVIVOM+4wSMUspsuSkwP33To+l8UQosgcZyqvF6tjT5dDHKFJFA?=
 =?us-ascii?Q?ZWy9ezTiKnnX4Eyqe3NaGK8CJxTc5WUl3nfFSUXC8JbP269uMzom/89R9Hb5?=
 =?us-ascii?Q?wcMZ0smGSV8ymO0qFK+0Oiix/pGtr6i6NtHCXz+mKLVmHlEThrge39pqau9c?=
 =?us-ascii?Q?qonSvxHgby9mPfZbIUE9WtwGmGw546dOJeKdHebrilLkfHUMB2rXOi+ZGogf?=
 =?us-ascii?Q?72pedD3QySRrAPBhTnR+XTmk61EmNM0BSen1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:16:27.7310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac333d52-e4ad-44c8-0d0a-08dde916b439
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002317.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF634736581

Move kvm_gmem_get_index() to the top of the file and mark it inline.

Also clean up __kvm_gmem_get_pfn() by deferring gmem variable
declaration until after the file pointer check, avoiding unnecessary
initialization.

Replace magic number -1UL with ULONG_MAX.

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---

Applies cleanly on kvm-next (a6ad54137) and guestmemfd-preview (3d23d4a27).

 virt/kvm/guest_memfd.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 08a6bc7d25b6..537f297a53cd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -25,6 +25,11 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
 	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
 }
 
+static inline pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return gfn - slot->base_gfn + slot->gmem.pgoff;
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -32,6 +37,7 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	kvm_pfn_t pfn = folio_file_pfn(folio, index);
 	gfn_t gfn = slot->base_gfn + index - slot->gmem.pgoff;
 	int rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
+
 	if (rc) {
 		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
 				    index, gfn, pfn, rc);
@@ -78,7 +84,7 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 * checked when creating memslots.
 	 */
 	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
-	index = gfn - slot->base_gfn + slot->gmem.pgoff;
+	index = kvm_gmem_get_index(slot, gfn);
 	index = ALIGN_DOWN(index, 1 << folio_order(folio));
 	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 	if (!r)
@@ -280,8 +286,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
-	kvm_gmem_invalidate_end(gmem, 0, -1ul);
+	kvm_gmem_invalidate_begin(gmem, 0, ULONG_MAX);
+	kvm_gmem_invalidate_end(gmem, 0, ULONG_MAX);
 
 	list_del(&gmem->entry);
 
@@ -307,10 +313,6 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return get_file_active(&slot->gmem.file);
 }
 
-static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	return gfn - slot->base_gfn + slot->gmem.pgoff;
-}
 
 static bool kvm_gmem_supports_mmap(struct inode *inode)
 {
@@ -637,7 +639,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					bool *is_prepared, int *max_order)
 {
 	struct file *gmem_file = READ_ONCE(slot->gmem.file);
-	struct kvm_gmem *gmem = file->private_data;
+	struct kvm_gmem *gmem;
 	struct folio *folio;
 
 	if (file != gmem_file) {
-- 
2.43.0


