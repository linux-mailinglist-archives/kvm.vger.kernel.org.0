Return-Path: <kvm+bounces-65978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD27CBEB1D
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 962AD300EDCA
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A7E337B86;
	Mon, 15 Dec 2025 15:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GLODJRBA"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010050.outbound.protection.outlook.com [52.101.56.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3751B336EF4;
	Mon, 15 Dec 2025 15:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765812995; cv=fail; b=A8x4UfLxSa5RPpMKwWfjS3wn//PqTv4hqnqp21iOMUepVhLC+SVabBmWmYvNVvVHBKS2j8OH9BcLEvajA3PiSVKR6rChHCvPgWvXdv6UfpICaEoanrFFRpd/nUI6n+Kh9Z7VIhr2W2J4s3+aUGFgLCrs42TJCYhFXmlcXmr4rxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765812995; c=relaxed/simple;
	bh=iAULoiCvl4T8KeLgcjXG30xwdtU6IpoiSbtll/VkyaA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BghEoiXEA2Z7br/FPqth1Qa+5xNNwpYHQM4kdg63nDOIkJiApObG3AGtSCK4soRHpMH0dbkfvFYrXaPpuCF+mXpNsHbGeTDjjYZKnh2j0eyIDw7OFp6g/BaadAZvfL4mMVHFpxCn9ZTKcsW5eQ9R/mv0gbZgcqpJ3JHT9zYuibk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GLODJRBA; arc=fail smtp.client-ip=52.101.56.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wNjuBGC1K2fGVFchZMNQbCqH1O9GA1bVFdw+O/MPv2TGtyi3ct8pI0a9PNueOjTm+kqvnnWCtp05kG6BKIfxAXSYvvRGHI+rWters2dHPObyezMK8F47Lldjx6we0wzcAQVQEQELL9kDGdcQFOXrws/aHxDjeacjWvVzjCUa1dq49HqDFSZuf23BObzAHc2PM8fyZ7S+tE+ay664ljh/FxwuA5j49su4Ob6wKhFPYHGgo3BS5O/Yz+mT6jhDNVoDvTnL/m7Oz5lN14Oqk1+7bMmui9qeMjJUby08nWJ/gFoASiN9JFJs17la294JH1wScg8DkMWmO8TKW2l2Ro9arw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHXLvpskxx0bRdQ0BUCSb1gmFjPsUkheEL7AmaZm+zo=;
 b=FCYEiISZguDum4VsuPxg4kuxnv0LvyYJP1naFGZhkMcMWW/Si2v1cnsR0l08g3n24aUvTajV4H+5WbVK85R3iRGYq5GaeBqoDu76661WBzdreLOsnM4XquC7ZoIphfA38SDRdDPPzmOPEwJrZOdDqoUu0gptv7/I0pQdlZzMVH4wZjvU7gwel8yg6BKHmItpkKzPwpqmibnSxbfLXPrAMY710V9itay4e4eiDhDym2yhwEzXpTr8ZuTIFc8maiLmeKphCKJKoEKI6a6YbVdzevgPhL6gcBvj7srxBhogsrsZFYwpnEyKbaoXrAwTC7Y+MhToJcQQG8pGZ2dNCXYGGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHXLvpskxx0bRdQ0BUCSb1gmFjPsUkheEL7AmaZm+zo=;
 b=GLODJRBAh/WJ81otuHNjqaWiW0IfuROr5H+Pm9GHMLBiFOxBCT14w+yYmxYjJsezJBHOdv+zPA34Rhtm5f+UfNIqzoSdfnFpb+JwXcU4okyLgaG9Lcc+7Fe11vT+wj9JiEUyyH50jyPDrGDkaj3ZjairvRtWEkHwvFNVSSwihms=
Received: from PH8P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:345::27)
 by CY5PR12MB6552.namprd12.prod.outlook.com (2603:10b6:930:40::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 15:36:22 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:510:345:cafe::89) by PH8P220CA0003.outlook.office365.com
 (2603:10b6:510:345::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 15:36:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 15:36:22 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 09:36:21 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH v2 5/5] KVM: guest_memfd: GUP source pages prior to populating guest memory
Date: Mon, 15 Dec 2025 09:34:11 -0600
Message-ID: <20251215153411.3613928-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251215153411.3613928-1-michael.roth@amd.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|CY5PR12MB6552:EE_
X-MS-Office365-Filtering-Correlation-Id: bfb4c022-dcb2-48fe-39bb-08de3befb326
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZKDEzTVxE7kBfkBWkswbp6mMEbXXENfKmkjzGW+m7elk9dOyT64UmXxksOPU?=
 =?us-ascii?Q?pTC9C/T9b2pHEkh4jrT63AAfFgvI/9F//p4bPi+/Dk8welpkdrTVrCCMg1Mt?=
 =?us-ascii?Q?Z8uyLDzoSFhbZj8z54qwb65U+3V2XzGeqQaKhYp6CX4QN5jehajGyh4mSi+1?=
 =?us-ascii?Q?C6OK5wzjfhShQbbbgIZQN9zJTNT1B2MDr1xKen88Q0x8B4d17S1upQ7U36A6?=
 =?us-ascii?Q?1AC+GUZVIbnongzEfLMXjHyX2uQBq2JMdkSwdPKTKBAytBBRfgmxowD70H9T?=
 =?us-ascii?Q?MaTOuQ0JZ8xOK41lOOrsE6K/ks6ZVpj3mOlHEDAYhNghCC+V8eZhfmhKSPvY?=
 =?us-ascii?Q?i7JlFqXskQlOvzthdcpVnILylhkXPL7wJu80E+aQS2HAiDsxLtPxl5PWKZC9?=
 =?us-ascii?Q?ijoZDPV5Ix0QF13eFVRCQK6zlnw1FgXXEAxcc1ye49ly9XjFhjHxgrnh798k?=
 =?us-ascii?Q?sQwNUNRerm612+gEvGV462koPm/NhQ5IIU3xpq7kChPc7HwsP7Zwc2ObLFvG?=
 =?us-ascii?Q?U3bsHnvSsATkPpHxs6IJtFr73Mq1nYtyZaOvEGG5KBuh0qqPTaf2oN1SMVxW?=
 =?us-ascii?Q?E0pcJ2LvudEgDKpvN4ldURFPcsndJmlOE2iuTJsfm4C7TbKPYya0DfNBzSPt?=
 =?us-ascii?Q?8N+/RKw3J9j9FkcIALvQ7pOrZBfjM2uwf/msib8mluKV55HD5lXzRJqGz2kZ?=
 =?us-ascii?Q?BNcyt00z4MV/mvI7Smf0ykWI8pdOhWbXRi7cVW3qK+56XUiO6QV4ZeRqu7O9?=
 =?us-ascii?Q?EMrKQr4LKx3kG2+x3WS+w/b9kg/W0z5b/6ozl1SC2Wl4Ej6nToiHHV6HbBUv?=
 =?us-ascii?Q?PgTDOzi/oKcf8WSVW+8iBytzV7iT/6LgVWyeLK43rsXuF3YRdh1DFUDAc3Ur?=
 =?us-ascii?Q?CkVKkeGCH56Ltzjv4SOX6QodLE+aTGBGB8pqSbccP6QjetETKHwysu8cY/iO?=
 =?us-ascii?Q?hERSkTHxFDZ/8Yc+VsvTukEbYWLEIGzJwXvWgwXj6AO+TCfGMY1lQadjFxSQ?=
 =?us-ascii?Q?8ZB5d0kBWAOfPNInaaIbi9ShwXfiid3q+7li0llfJNrRm8Nu2lGMX5Hexqdy?=
 =?us-ascii?Q?v+OlAuOQ0amjTZqhOrbv7JXBr+JxwIWrMMyfsdlCkEL0/pgNnzeWLVP5W415?=
 =?us-ascii?Q?aW4bZIjl95YQ3ojU2xuJ0OrA38lz4aBKlwg44EzgQbegVR7g2881CiiX+Hr6?=
 =?us-ascii?Q?U7HThuwgKWw97vbPk5xXRQ1dADRGYdLFosocPeMMThSpo8zMSzgUZM1cPfvV?=
 =?us-ascii?Q?SkXPTsdAsPMz8nhqtIaj4MLq7+rRzWpxz175RqIw34mnE3FtOWPNh8rDG9f7?=
 =?us-ascii?Q?IiUBzz0Rgk3x4xJ1P+UbIqNm0T3XES28wFzPfha+QXV5E9EGidr3QXx0sMnh?=
 =?us-ascii?Q?NTSn0F08hRL2oXSeR7DWU/36XD6kezt60UF8w62xzLuLFAw+q+7XHiYxeSeW?=
 =?us-ascii?Q?w2EOVNYdANgtrdF4J3hvbFP9LAzvFog5vAezJOR7Asfjs1gRMdsibx28mFTe?=
 =?us-ascii?Q?S2IOrAR1DWID+d2B8mjXhMoIvD8gG3K7XRjaQB9bDxC7tJoTDEu3wrEa0V7q?=
 =?us-ascii?Q?nJzpYMj6O1EAJCENN8U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 15:36:22.1407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb4c022-dcb2-48fe-39bb-08de3befb326
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6552

Currently the post-populate callbacks handle copying source pages into
private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
acquires the filemap invalidate lock, then calls a post-populate
callback which may issue a get_user_pages() on the source pages prior to
copying them into the private GPA (e.g. TDX).

This will not be compatible with in-place conversion, where the
userspace page fault path will attempt to acquire filemap invalidate
lock while holding the mm->mmap_lock, leading to a potential ABBA
deadlock[1].

Address this by hoisting the GUP above the filemap invalidate lock so
that these page faults path can be taken early, prior to acquiring the
filemap invalidate lock.

It's not currently clear whether this issue is reachable with the
current implementation of guest_memfd, which doesn't support in-place
conversion, however it does provide a consistent mechanism to provide
stable source/target PFNs to callbacks rather than punting to
vendor-specific code, which allows for more commonality across
architectures, which may be worthwhile even without in-place conversion.

As part of this change, also begin enforcing that the 'src' argument to
kvm_gmem_populate() must be page-aligned, as this greatly reduces the
complexity around how the post-populate callbacks are implemented, and
since no current in-tree users support using a non-page-aligned 'src'
argument.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 32 ++++++++-------
 arch/x86/kvm/vmx/tdx.c   | 15 +------
 include/linux/kvm_host.h |  4 +-
 virt/kvm/guest_memfd.c   | 84 +++++++++++++++++++++++++++-------------
 4 files changed, 77 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 90c512ca24a9..11ae008aec8a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2268,7 +2268,7 @@ struct sev_gmem_populate_args {
 };
 
 static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, void *opaque)
+				  struct page *src_page, void *opaque)
 {
 	struct sev_gmem_populate_args *sev_populate_args = opaque;
 	struct sev_data_snp_launch_update fw_args = {0};
@@ -2277,7 +2277,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	int level;
 	int ret;
 
-	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
+	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
 		return -EINVAL;
 
 	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
@@ -2288,14 +2288,14 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		goto out;
 	}
 
-	if (src) {
-		void *vaddr = kmap_local_pfn(pfn);
+	if (src_page) {
+		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_page));
+		void *dst_vaddr = kmap_local_pfn(pfn);
 
-		if (copy_from_user(vaddr, src, PAGE_SIZE)) {
-			ret = -EFAULT;
-			goto out;
-		}
-		kunmap_local(vaddr);
+		memcpy(dst_vaddr, src_vaddr, PAGE_SIZE);
+
+		kunmap_local(src_vaddr);
+		kunmap_local(dst_vaddr);
 	}
 
 	ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, PG_LEVEL_4K,
@@ -2325,17 +2325,19 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (ret && !snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
 	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
-		void *vaddr = kmap_local_pfn(pfn);
+		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_page));
+		void *dst_vaddr = kmap_local_pfn(pfn);
 
-		if (copy_to_user(src, vaddr, PAGE_SIZE))
-			pr_debug("Failed to write CPUID page back to userspace\n");
+		memcpy(src_vaddr, dst_vaddr, PAGE_SIZE);
 
-		kunmap_local(vaddr);
+		kunmap_local(src_vaddr);
+		kunmap_local(dst_vaddr);
 	}
 
 out:
-	pr_debug("%s: exiting with return code %d (fw_error %d)\n",
-		 __func__, ret, sev_populate_args->fw_error);
+	if (ret)
+		pr_debug("%s: error updating GFN %llx, return code %d (fw_error %d)\n",
+			 __func__, gfn, ret, sev_populate_args->fw_error);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4fb042ce8ed1..3eb597c0e79f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3118,34 +3118,21 @@ struct tdx_gmem_post_populate_arg {
 };
 
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, void *_arg)
+				  struct page *src_page, void *_arg)
 {
 	struct tdx_gmem_post_populate_arg *arg = _arg;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	u64 err, entry, level_state;
 	gpa_t gpa = gfn_to_gpa(gfn);
-	struct page *src_page;
 	int ret, i;
 
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	/*
-	 * Get the source page if it has been faulted in. Return failure if the
-	 * source page has been swapped out or unmapped in primary memory.
-	 */
-	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
-	if (ret < 0)
-		return ret;
-	if (ret != 1)
-		return -ENOMEM;
-
 	kvm_tdx->page_add_src = src_page;
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
 	kvm_tdx->page_add_src = NULL;
 
-	put_page(src_page);
-
 	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
 		return ret;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1d0cee72e560..49c0cfe24fd8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2566,7 +2566,7 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
  * @gfn: starting GFN to be populated
  * @src: userspace-provided buffer containing data to copy into GFN range
  *       (passed to @post_populate, and incremented on each iteration
- *       if not NULL)
+ *       if not NULL). Must be page-aligned.
  * @npages: number of pages to copy from userspace-buffer
  * @post_populate: callback to issue for each gmem page that backs the GPA
  *                 range
@@ -2581,7 +2581,7 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
  * Returns the number of pages that were populated.
  */
 typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				    void __user *src, void *opaque);
+				    struct page *page, void *opaque);
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8b1248f42aae..18ae59b92257 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -820,12 +820,48 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+
+static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
+				struct file *file, gfn_t gfn, struct page *src_page,
+				kvm_gmem_populate_cb post_populate, void *opaque)
+{
+	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct folio *folio;
+	kvm_pfn_t pfn;
+	int ret;
+
+	filemap_invalidate_lock(file->f_mapping);
+
+	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
+		goto out_unlock;
+	}
+
+	folio_unlock(folio);
+
+	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+		ret = -EINVAL;
+		goto out_put_folio;
+	}
+
+	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
+	if (!ret)
+		folio_mark_uptodate(folio);
+
+out_put_folio:
+	folio_put(folio);
+out_unlock:
+	filemap_invalidate_unlock(file->f_mapping);
+	return ret;
+}
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	struct kvm_memory_slot *slot;
-	void __user *p;
-
 	int ret = 0;
 	long i;
 
@@ -834,6 +870,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (WARN_ON_ONCE(npages <= 0))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(src)))
+		return -EINVAL;
+
 	slot = gfn_to_memslot(kvm, start_gfn);
 	if (!kvm_slot_has_gmem(slot))
 		return -EINVAL;
@@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock(file->f_mapping);
-
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
 	for (i = 0; i < npages; i++) {
-		struct folio *folio;
-		gfn_t gfn = start_gfn + i;
-		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		kvm_pfn_t pfn;
+		struct page *src_page = NULL;
+		void __user *p;
 
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
-		if (IS_ERR(folio)) {
-			ret = PTR_ERR(folio);
-			break;
-		}
+		p = src ? src + i * PAGE_SIZE : NULL;
 
-		folio_unlock(folio);
+		if (p) {
+			ret = get_user_pages_fast((unsigned long)p, 1, 0, &src_page);
+			if (ret < 0)
+				break;
+			if (ret != 1) {
+				ret = -ENOMEM;
+				break;
+			}
+		}
 
-		ret = -EINVAL;
-		if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-						     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-						     KVM_MEMORY_ATTRIBUTE_PRIVATE))
-			goto put_folio_and_exit;
+		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, src_page,
+					  post_populate, opaque);
 
-		p = src ? src + i * PAGE_SIZE : NULL;
-		ret = post_populate(kvm, gfn, pfn, p, opaque);
-		if (!ret)
-			folio_mark_uptodate(folio);
+		if (src_page)
+			put_page(src_page);
 
-put_folio_and_exit:
-		folio_put(folio);
 		if (ret)
 			break;
 	}
 
-	filemap_invalidate_unlock(file->f_mapping);
-
 	return ret && !i ? ret : i;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
-- 
2.25.1


