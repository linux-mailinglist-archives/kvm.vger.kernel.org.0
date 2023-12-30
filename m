Return-Path: <kvm+bounces-5383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3903E8207CA
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2DEC1F21FAF
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B1AEAE6;
	Sat, 30 Dec 2023 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eIl62lyX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11237F9DB;
	Sat, 30 Dec 2023 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKoupEFHw9HNk1ERxWOBZEEJd7JQZ6EP/1FiZBU8L1C9Tgz1Snj1dm+BvCmsu1gwG8y4SwCMRDOiA6XGljQocSFLSg2++c3fw2zjSUxidWAAkZ+ZxQQo8BtH194HwCiqsbjiaytaWS0UJAasmudSjpA51YJGMDQOGNDTBmbQehKVRV9lIUHABm2NPn6ln5L6fqUNTd4M3wLALlJB5hldct4smknSUate4tBe4Xe2vHX8D0KSMS5anCMuVWDBWluXlZkJn8PAG89Q4nuuzvKObxqPU8mp0F+LFY2xFTbEWD5aDDbSiumf1DQla9hNl+NvjcOj3pswsKSULuRl8p7zoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XgjSbQPuViBerBi3ZrdvpWHtvAvXJLUzH5XOg81cmc=;
 b=iG712rzQSgtlB+zasjSI6q8s9q+6N+DQplaYH+RoJaCpEaJL+WwmTb6Qyv78ymsraZBQxA6SJjKM/Bltx+NfUyv0Wmj4oFZsPhgJV67mg1th+9pGgeSISiRz5BOTORT8+PqY1DBADBNBerqqXAYk93WDfPs+IRWEc5H5KhhK/9BrDpkpLHEFRWgGiQS0DkGi5jUFcgN8PXqpj0fBsE0+ZuUyA2Z9cq9jm2cfZC7TZijBn1oSo0xTW22/Zghr3fGyLr4UpeZZn4R6onZNRkyUnlmw3qCty86ZzXgTGf4CB/bMXuTiRgk8vUeSTlXl8bRtKiojUe5pV9NR2cIh8LIKRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XgjSbQPuViBerBi3ZrdvpWHtvAvXJLUzH5XOg81cmc=;
 b=eIl62lyXzCjwX7bScdsr/3v0XdazjhGMg/MEwGAtc/SNEQqKnGE/qAvZ0mGCj0WXQG6L5RFsV18hrgesJvA1cHMyr0SRBXFZakuP85+bK0uj3LCibc50KLH7rBpk2CEZozKs9niWVaMeI3MfEaM4st184n8pmeOkr0w5CCUgbKM=
Received: from BLAPR03CA0131.namprd03.prod.outlook.com (2603:10b6:208:32e::16)
 by MW4PR12MB6949.namprd12.prod.outlook.com (2603:10b6:303:208::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 17:28:52 +0000
Received: from MN1PEPF0000ECD9.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::cd) by BLAPR03CA0131.outlook.office365.com
 (2603:10b6:208:32e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:28:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD9.mail.protection.outlook.com (10.167.242.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:28:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:28:51 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 01/35] KVM: Add hugepage support for dedicated guest memory
Date: Sat, 30 Dec 2023 11:23:17 -0600
Message-ID: <20231230172351.574091-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD9:EE_|MW4PR12MB6949:EE_
X-MS-Office365-Filtering-Correlation-Id: b446e043-183d-4b45-4fb2-08dc095ccab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nsgunP4MyZ6L889M0EUKCh4TL/cvPT6Vnd1R2Bt9j0U2tNkuY/G8ouNam6BKCGXVS8LdW7VQvvJSGf1gcJrru72KTDOYtMmPv6x+2JZOmAyMe5dvNAgVxWUdLeZ+E4VHP4QvK3myjX7RK9yS9LOXTKDfD09cKU+cahR5F/igrI6tvIWqtAXnDKLS0WjOT0/eiXWuGuqRpNRNeqMpHvE+JWIAe+7Pngm6PX8U5zJjDS5j7R7xqehQ3AL80s7VMTmGFkdTuIUQBFCXq3pZY0a9CFAwOm98/mWZ/Ifq4PE7uo4j2AqkCRq494HYrc9ti+vJAh4uKqyQNMRsNPxlTJTzvCWp7hgLNqpbOuI7iA8H/NzxpzZlrp9MA4fFpt6axPCY3A1yRMP8EiarJcdHwLZaoE8Q7nu5tjQcE1gjJ3s3exgUst/YGBjKXm9iqnpnO58ddOs+KVl5wZZL7WN8yMyc1nKwvHM64yxnqU7U5iKOPbnEdyRl8E3Hkj8tiUwenReefjSpXWTSDVGrcyUJ6ys5/xB0MRsgtje52O/Lj4XG/bkxgYLVYWkofZItDw7mvd+ibFGAlI+sYaOvh6tuvgcusuXhiaodoAc8dVcXw2i9M/gaehZbD54y8EUiNSDsy+qf7ENKV3gWdkuVfTxR116cyNCN386z0WYJL3qtMIXCxOhqdYAnSloyE/cbtMFqqV9r1Qu15dxHgDO/KiMrktuHFKklzQkrCtuFT2GTCqmrgJqtkL7NuZcMH+L1xsBhAy84Na/hjGSPd/8LZ8ke+2jOfA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(451199024)(1800799012)(82310400011)(186009)(64100799003)(36840700001)(46966006)(40470700004)(336012)(426003)(16526019)(26005)(1076003)(83380400001)(2616005)(6666004)(36860700001)(47076005)(7406005)(7416002)(5660300002)(4326008)(44832011)(41300700001)(2906002)(966005)(478600001)(316002)(8676002)(8936002)(54906003)(70586007)(70206006)(6916009)(86362001)(36756003)(81166007)(356005)(82740400003)(40480700001)(40460700003)(66899024)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:28:52.1401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b446e043-183d-4b45-4fb2-08dc095ccab1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6949

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
        that they'll get hugepages. It's better at least than the
        current guarantee that they will get 4K pages every time. A more
        proper opt-in interface can then improve on things later.
      - Pass GFP_NOWARN to alloc_pages() so failures are not disruptive
        to normal operations
      - Drop size checks during creation time. Instead just avoid huge
        allocations if they extend beyond end of the memfd.
      - Drop hugepage-related unit tests since everything is now handled
        transparently to userspace anyway.
      - Update commit message accordingly.]
Signed-off-by: Michael Roth <michael.roth@amd.com>

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 63 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4aa23b01aa98..784690a664ac 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -13,14 +13,46 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+static struct folio *kvm_gmem_get_huge_folio(struct inode *inode, pgoff_t index,
+					     unsigned int order)
 {
+	pgoff_t npages = 1UL << order;
+	pgoff_t huge_index = round_down(index, npages);
+	struct address_space *mapping  = inode->i_mapping;
+	gfp_t gfp = mapping_gfp_mask(mapping) | __GFP_NOWARN;
+	loff_t size = i_size_read(inode);
 	struct folio *folio;
 
-	/* TODO: Support huge pages. */
-	folio = filemap_grab_folio(inode->i_mapping, index);
-	if (IS_ERR_OR_NULL(folio))
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
 		return NULL;
+	}
+
+	return folio;
+}
+
+static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+{
+	struct folio *folio;
+
+	folio = kvm_gmem_get_huge_folio(inode, index, PMD_ORDER);
+	if (!folio) {
+		folio = filemap_grab_folio(inode->i_mapping, index);
+		if (IS_ERR_OR_NULL(folio))
+			return NULL;
+	}
 
 	/*
 	 * Use the up-to-date flag to track whether or not the memory has been
@@ -361,6 +393,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_mode |= S_IFREG;
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+	mapping_set_large_folios(inode->i_mapping);
 	mapping_set_unmovable(inode->i_mapping);
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
@@ -486,7 +519,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
-	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
+	pgoff_t index, huge_index;
 	struct kvm_gmem *gmem;
 	struct folio *folio;
 	struct page *page;
@@ -499,6 +532,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	gmem = file->private_data;
 
+	index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot)) {
 		r = -EIO;
 		goto out_fput;
@@ -518,9 +552,24 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	page = folio_file_page(folio, index);
 
 	*pfn = page_to_pfn(page);
-	if (max_order)
-		*max_order = 0;
+	if (!max_order)
+		goto success;
+
+	*max_order = compound_order(compound_head(page));
+	if (!*max_order)
+		goto success;
 
+	/*
+	 * The folio can be mapped with a hugepage if and only if the folio is
+	 * fully contained by the range the memslot is bound to.  Note, the
+	 * caller is responsible for handling gfn alignment, this only deals
+	 * with the file binding.
+	 */
+	huge_index = ALIGN(index, 1ull << *max_order);
+	if (huge_index < ALIGN(slot->gmem.pgoff, 1ull << *max_order) ||
+	    huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages)
+		*max_order = 0;
+success:
 	r = 0;
 
 out_unlock:
-- 
2.25.1


