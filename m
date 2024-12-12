Return-Path: <kvm+bounces-33557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E65269EDF91
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87EA2168802
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 06:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A399D204C2E;
	Thu, 12 Dec 2024 06:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tUcvn5dW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1054204C20;
	Thu, 12 Dec 2024 06:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733985553; cv=fail; b=pYs1qAxJTTG73MtjpdCcobm0c3mEZ8jbnoD+PZjRTzH9ohcQjz6QTzbNewD8NJbsqk8K9EgsQICelcZr6a8j46hj0ImXJH0iCMRgl3RJdoNQ0prDa6cAjqUYZW+7HpMyHv//lNlLViQ7u8gkwP6cokqis9saOyx7/l6GkIJrdAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733985553; c=relaxed/simple;
	bh=3SfUG1MDWOSWweOT3pfen8IPZ8hKxMCrGnREfsrnDUM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WzrbWLej/f4eCDJYfTXWvs5TqVYq0yKNnxOW5afIAJaFQFAkIzxO+x8bi3uXG+T1GLY2B4VMHWtFBJ5lcYqeY/fqT2T2T70+1MQF0uAlRKc4zs117FyaUoO63h94W47QbknMKdTDR0dxUMZKqYvMuSiwsR8q6iZdYlwC0Sc1AiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tUcvn5dW; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l0c4LgrtlT7seVsQ1V2WcukgzUiNn3PSGJBuoU6v29WRePjU00rc/E5Eg5+XLEwhh4OX8vZHoR+biaxthFCC/5ySFgQC440FkK26PGhTLakUgWP9rZUoyNQPYAzq9kTSvGsG+e7an3q8ayus/qhD6AE/Lr0EMHNwkVOt8jp7zJonn3BuzbUys5w5FSU0QAD9viambCaSXsyydCPTe/WLGi7PdiUkNtOji2oIVOtVeZuik85OGJRi3jc46n3UZqmEoKsigkXyGO/Q1/HroQSvvlo7pwCsCNcW2x4dJwxvqFlrY4mMGons2+V1BVCYMMU9OnSKtDJ+tGUqWPonP5oGaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJko6VK/4yYa1/Q3u/SX/rr6ao4Sfll0k5Fjriv+GgI=;
 b=EnsTcXsP5hnOgeNWnHfUAoZp043pdAESWAGaHvDGOmiCbgGzM/Wh1vTxuR4Foc6U3lWfqnlS0I5X7y9mx/W5JPDOM8wJW6orIV2Np5k9abouHYtiKA2mR2kXUAlHWPc2vgujYTz/IiFDvIfg4qiB/TK9He2/XmVrsNOIHhZJZV5moFA3VN53SeGTyk0tFSigZeQg3G7VfgDByDSjBLsRTobm47H5nE6wCYMlBXxQTuXxzW6OeZycoGB2RJAQdLuSfmvHBx2bGbHKiFFrlLQHI5Lt0aUs20dHtB5Nlh9qweRYO9DWzBFpH3GUYN7r4OrXXysq97FCga0pETyUI/mdsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJko6VK/4yYa1/Q3u/SX/rr6ao4Sfll0k5Fjriv+GgI=;
 b=tUcvn5dWpaQvyaZ91gqAKnNvBURBo/Mx0U4MvN76crk0JB3a6leiJPmG315xUSvHwTG9wampK1VTgxBLSO8DHDgX6yHoMOyEciEE5vLEBPi3vbGXMb70wvnDPXVXWLKLkSv4qZ4eK7LSiLNeSmXuzy56WwZ7/oXAezckUimbItw=
Received: from CH2PR10CA0026.namprd10.prod.outlook.com (2603:10b6:610:4c::36)
 by SA1PR12MB7222.namprd12.prod.outlook.com (2603:10b6:806:2bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Thu, 12 Dec
 2024 06:39:07 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:610:4c:cafe::e6) by CH2PR10CA0026.outlook.office365.com
 (2603:10b6:610:4c::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.17 via Frontend Transport; Thu,
 12 Dec 2024 06:39:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 06:39:06 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 00:39:06 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: [PATCH 5/5] KVM: Add hugepage support for dedicated guest memory
Date: Thu, 12 Dec 2024 00:36:35 -0600
Message-ID: <20241212063635.712877-6-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|SA1PR12MB7222:EE_
X-MS-Office365-Filtering-Correlation-Id: f5f751d0-e858-4d15-9e61-08dd1a77ad6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SiaS4GNlI+RLVI429LgqSGFS34du03p+2TsX/lTyCsSkonO5oW3QpJ/PCPjX?=
 =?us-ascii?Q?tMaKSGEduA0PM+goNqbQZUIERXvuCp6W2qo8Di3DQyENxfxwbxPxQQuj/jSS?=
 =?us-ascii?Q?URtSViQXINedtVd7baUt8ylf2g8tqxTrR9zEmQGeJlJHlaxoV3X9P5dkmjgQ?=
 =?us-ascii?Q?UgGfSySK3klRKTagyzZcpM1eMoL5LcJca7Fgk+9XxPFwZrbVpekH78ezs240?=
 =?us-ascii?Q?oIfVv17MmILBA4LK7OMXGXADKHGGgchmQLDUGlq37KWhgxMpFrjCZsilZBJB?=
 =?us-ascii?Q?1+HO4gT03hRjjqQp1WPbn6Mfxake4QK6e7wPMFX8kvauj04vqgjXkihRmlYc?=
 =?us-ascii?Q?gl9l88ISNB6JYlIRH1fI28vxZdI8Mjl0nwEnz+IZ3UjIILqbq3FC467uWRp9?=
 =?us-ascii?Q?1cQ9tTNzliwz4lWRYGh03/25C7yxxNgRn5xHwvvEBMpXxfqCFCM7kgDUgIHP?=
 =?us-ascii?Q?x2mmHld6JoQ77dAWkednspOXBQKhO769a7tyclzslXelOl64kLj8QbNF/yMG?=
 =?us-ascii?Q?eLR8NhPRU3QenyNuQMSEfZTeXrvDQN/u21F3CeMqgn+YkC5WnerGT/voJIZv?=
 =?us-ascii?Q?lW+erh0j2uDt6s7qn2uHdzykG6VSSu9mxSxxBZ4ds1BLIhSPMnKBrgrWahrR?=
 =?us-ascii?Q?S9Mri+5S5l3Y5mE/28v7oki+qX/kcPUQ0UmFmRtg8GT3mkWp4cFpv40mbLJJ?=
 =?us-ascii?Q?8SjFclpobTfPwzqzlB5OI81UvZgeVSs+1xFmi3GJDh/b0t0VDK4d5nsELtxS?=
 =?us-ascii?Q?O/32L81CW16Bsndsc0DV2qYYfKtvY3kBMhn3vqkk7xKTppo/bLjW+pvQfnlX?=
 =?us-ascii?Q?MDDv9fT+PeOntecaeCjJ0EZQ/3bL9/YFN7crnfpSW4OXpwBOHLsswxfdBZLB?=
 =?us-ascii?Q?RVs+1B3fZRlrLnvF7aDaJu7QHKbNTWo2UEQOxSIFymwrcwDgrlfhNQPLm9iv?=
 =?us-ascii?Q?rxGF36oUKHIzLF4I5EOEY3PIpeSKGxYKXQwhTUg2BHM72QS3zdsEEaZMZ9+V?=
 =?us-ascii?Q?kHgnhfXAKdizWdq4NUlHPQJsb4kYuWk/nvSqhNpYFvoqnIuhRn3pRbo3uhYJ?=
 =?us-ascii?Q?PLcs/xkEebOtS2DRgQ9kYpIKw2CFLGpgwZSNqBRNI10UkbQoOISg68Dx0MlN?=
 =?us-ascii?Q?i2PBqXB6W994Wfm6Ef+kVEBoZW9hjRe2VKYYNGAuMgXobgk7nwX2+OZKss3E?=
 =?us-ascii?Q?xLUCZEs0ptMb90Q4mjkADdyFUF1DRuiZ3kQ9Z+VgV8Ifsa61q6TJWND6PFeG?=
 =?us-ascii?Q?x55X5soCIZA5+wMQaUD1QK33Ph2bcQfTns/f9uEVP1qfchdy5jlACJpYl83r?=
 =?us-ascii?Q?l8EAEClbHmdA52/TC/ksKITxh58lYPJVaLHDtvQfoeVWGXuq6r7vUPLxop0X?=
 =?us-ascii?Q?arvNO9kGVtlDROR83fm+xfPV1WJPbxy+DITzYst/nHvC8mNv6A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 06:39:06.8704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f751d0-e858-4d15-9e61-08dd1a77ad6c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7222

From: Sean Christopherson <seanjc@google.com>

Extended guest_memfd to allow backing guest memory with hugepages. This
is done as a best-effort by default until a better-defined mechanism is
put in place that can provide better control/assurances to userspace
about hugepage allocations.

When reporting the max order when KVM gets a pfn from guest_memfd, force
order-0 pages if the hugepage is not fully contained by the memslot
binding, e.g. if userspace requested hugepages but punches a hole in the
memslot bindings in order to emulate x86's VGA hole.

Link: https://lore.kernel.org/kvm/20231027182217.3615211-1-seanjc@google.com/T/#mccbd3e8bf9897f0ddbf864e6318d6f2f208b269c
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20231027182217.3615211-18-seanjc@google.com>
[Allow even with CONFIG_TRANSPARENT_HUGEPAGE; dropped momentarily due to
 uneasiness about the API. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[mdr: based on discussion in the Link regarding original patch, make the
      following set of changes:
      - For now, don't introduce an opt-in flag to enable hugepage
        support. By default, just make a best-effort for PMD_ORDER
        allocations so that there are no false assurances to userspace
        that they'll get hugepages. Performance-wise, it's better at
        least than the current guarantee that they will get 4K pages
        every time. A more proper opt-in interface can then improve on
        things later.
      - Pass GFP_NOWARN to alloc_pages() so failures are not disruptive
        to normal operations
      - Drop size checks during creation time. Instead just avoid huge
        allocations if they extend beyond end of the memfd.
      - Drop hugepage-related unit tests since everything is now handled
        transparently to userspace anyway.
      - Update commit message accordingly.]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/guest_memfd.c   | 68 +++++++++++++++++++++++++++++++---------
 virt/kvm/kvm_main.c      |  4 +++
 3 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c7e4f8be3e17..c946ec98d614 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2278,6 +2278,8 @@ extern unsigned int halt_poll_ns_grow;
 extern unsigned int halt_poll_ns_grow_start;
 extern unsigned int halt_poll_ns_shrink;
 
+extern unsigned int gmem_2m_enabled;
+
 struct kvm_device {
 	const struct kvm_device_ops *ops;
 	struct kvm *kvm;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9a5172de6a03..d0caec99fe03 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -273,6 +273,36 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct file *file,
 	return r;
 }
 
+static struct folio *kvm_gmem_get_huge_folio(struct inode *inode, pgoff_t index,
+					     unsigned int order)
+{
+	pgoff_t npages = 1UL << order;
+	pgoff_t huge_index = round_down(index, npages);
+	struct address_space *mapping  = inode->i_mapping;
+	gfp_t gfp = mapping_gfp_mask(mapping) | __GFP_NOWARN;
+	loff_t size = i_size_read(inode);
+	struct folio *folio;
+
+	/* Make sure hugepages would be fully-contained by inode */
+	if ((huge_index + npages) * PAGE_SIZE > size)
+		return NULL;
+
+	if (filemap_range_has_page(mapping, (loff_t)huge_index << PAGE_SHIFT,
+				   (loff_t)(huge_index + npages - 1) << PAGE_SHIFT))
+		return NULL;
+
+	folio = filemap_alloc_folio(gfp, order);
+	if (!folio)
+		return NULL;
+
+	if (filemap_add_folio(mapping, folio, huge_index, gfp)) {
+		folio_put(folio);
+		return NULL;
+	}
+
+	return folio;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -284,8 +314,15 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct file *file,
  */
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 {
-	/* TODO: Support huge pages. */
-	return filemap_grab_folio(inode->i_mapping, index);
+	struct folio *folio = NULL;
+
+	if (gmem_2m_enabled)
+		folio = kvm_gmem_get_huge_folio(inode, index, PMD_ORDER);
+
+	if (!folio)
+		folio = filemap_grab_folio(inode->i_mapping, index);
+
+	return folio;
 }
 
 static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
@@ -660,6 +697,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_inaccessible(inode->i_mapping);
+	mapping_set_large_folios(inode->i_mapping);
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
@@ -791,6 +829,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 {
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
+	pgoff_t huge_index;
 
 	if (file != slot->gmem.file) {
 		WARN_ON_ONCE(slot->gmem.file);
@@ -803,6 +842,17 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 		return ERR_PTR(-EIO);
 	}
 
+	/*
+	 * The folio can be mapped with a hugepage if and only if the folio is
+	 * fully contained by the range the memslot is bound to.  Note, the
+	 * caller is responsible for handling gfn alignment, this only deals
+	 * with the file binding.
+	 */
+	huge_index = ALIGN_DOWN(index, 1ull << *max_order);
+	if (huge_index < slot->gmem.pgoff ||
+	    huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages)
+		*max_order = 0;
+
 	folio = kvm_gmem_get_folio(file_inode(file), index);
 	if (IS_ERR(folio))
 		return folio;
@@ -814,8 +864,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	}
 
 	*pfn = folio_file_pfn(folio, index);
-	if (max_order)
-		*max_order = 0;
+	*max_order = min_t(int, *max_order, folio_order(folio));
 
 	return folio;
 }
@@ -910,17 +959,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		/*
-		 * The max order shouldn't extend beyond the GFN range being
-		 * populated in this iteration, so set max_order accordingly.
-		 * __kvm_gmem_get_pfn() will then further adjust the order to
-		 * one that is contained by the backing memslot/folio.
-		 */
-		max_order = 0;
-		while (IS_ALIGNED(gfn, 1 << (max_order + 1)) &&
-		       (npages - i >= (1 << (max_order + 1))))
-			max_order++;
-
 		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5901d03e372c..525d136ba235 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -94,6 +94,10 @@ unsigned int halt_poll_ns_shrink = 2;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+unsigned int gmem_2m_enabled;
+EXPORT_SYMBOL_GPL(gmem_2m_enabled);
+module_param(gmem_2m_enabled, uint, 0644);
+
 /*
  * Allow direct access (from KVM or the CPU) without MMU notifier protection
  * to unpinned pages.
-- 
2.25.1


