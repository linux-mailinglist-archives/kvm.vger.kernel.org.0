Return-Path: <kvm+bounces-63078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A774C5A7A9
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:10:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 318B5355638
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A859C2E4274;
	Thu, 13 Nov 2025 23:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2xEXnTec"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011054.outbound.protection.outlook.com [40.93.194.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14632286A4;
	Thu, 13 Nov 2025 23:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075373; cv=fail; b=r1pKK274dQ/uKgUsBs83NFsRLElcBRyadJ/50SuOf404uMiz8TaIyCIFEwYW9fNAVP2+caN77ZLaipNPrqOcQ7LV7ddZy+MU58b5FM3GrEc02qWivOaTIYIVG2C55G9GwHQGLfuiuXJJeP3TnbuR0I68wq5xgPg+nRHFbrIe2jQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075373; c=relaxed/simple;
	bh=vYxKY+PKHpZafw/ibdQxVrcXsSuCtVM4iZ2iNHIauuM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XJ+fIvIdan/Dw6XAN9SlGBPGV9HGL8vTaZ2OcTAfACyKlwhRB7Upxg2meSQBustQuUnbSovuvYhzxtDjXH4Z1Kj/Cw81AlNqYSifYVTRi40S0PQS8+ZNxe+V3wBswNvhvZh+i7xhjJkFHGb9zozp7vzJy4JFs4yF88MvJTibqQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2xEXnTec; arc=fail smtp.client-ip=40.93.194.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lla1/c91gvX6++UZIBekIlL24rGZ4Ru54LGVt7ARoxSc8td7jHi4DJgIIyRkiAuKy4owqbqBtCHsT3SSKROSHPnjjojFrLdzqu0c7kGgInTVLaIXtenJnQdqaMmP1Q9OQ6E8/Bto0V6E171WyEjWny2b0UX/OBxU7qRB9yzPtm4uc65/FXfoC7R0qC3WMo4YGyxlLFzfVqCpSlKa15dBfbk0kZY6+U+x+SNA0oeq0YE5kOYq+76A5/4xcOTQs51cPxGxQZqmxaDxrjs3ZMVtUWAuRp6rWMSbcWJn9Usrbqa3RcQu79wpXaVTrT2ZWJisZhl4CDnTr4gH7Wpn33hw9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpQSDK9aHEVrpkD7yjKCdEJ5JuhlcCG/Uhbef5nM3n0=;
 b=PAwJg30VtEheFhmnnVrEQPq9MiMPP1yoUizD0t1LQdn2AtjBo2goNjM6v8sxEIFg3GbVLNxd9TvGOgxh7r9KTXW+mWPYSyCl6E6U7Wgvj4NaSjnMDXvi+I026HIyg+B3rEE/UVWIIWvxg+eC4Z3UU++bW9wpiJeA3Pb2zuwaXSzil9GqOf9tC0KUj87uA9syMxWpEF7NXn2+E/2BU9acsB6QRWao8GK1WoJjC3ke8I0Jk/2iZrOFTZNAAgMijhXS8g1r1xLSv1xNf0IN60/PczCCxCEadsu4qWBqfw58/DGcOjCtN3GuK8V50LAM41+TyncYEnXdL8VukTM3eYqAsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpQSDK9aHEVrpkD7yjKCdEJ5JuhlcCG/Uhbef5nM3n0=;
 b=2xEXnTecwszeDPJf5OXQYw4jBY40tAGzlKB7kG/vD/QIRJCmk7Gdi0FTDpXLF9C04X8Q/gLuVFQHz54J7lTW6lXeHaq4WME52G89Fl+89KETjzPIsuyNxuageVCWLWkxUz1KjVPxjKYbNQVqmTfOD86/hklrAyGVEvC1Nq9S3VQ=
Received: from SJ0PR03CA0105.namprd03.prod.outlook.com (2603:10b6:a03:333::20)
 by DS0PR12MB7899.namprd12.prod.outlook.com (2603:10b6:8:149::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 23:09:23 +0000
Received: from SJ5PEPF00000207.namprd05.prod.outlook.com
 (2603:10b6:a03:333:cafe::54) by SJ0PR03CA0105.outlook.office365.com
 (2603:10b6:a03:333::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 23:09:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000207.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 23:09:20 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 13 Nov
 2025 15:09:19 -0800
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to populating guest memory
Date: Thu, 13 Nov 2025 17:07:59 -0600
Message-ID: <20251113230759.1562024-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251113230759.1562024-1-michael.roth@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000207:EE_|DS0PR12MB7899:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f22bad5-2012-491e-894c-08de2309ad78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v4yK1gf9VQPiCD6O3xQ0fwLuSI0Aevv7L7i+uzeruq5RLE9zO3uzzjbNSFIL?=
 =?us-ascii?Q?rpI9R3DihqaSiZg2zMB28JpZPjUvdN/KSCRajuM0zuHjtbP0lGQWM0dClFwz?=
 =?us-ascii?Q?uujebrzaGPPyiH5qgPypnH6CPp1BZSUF61G+CBLb3QhKFkVloh5zeg89CKX+?=
 =?us-ascii?Q?KhVEbig5I9PNAJWO9hh587jE9JF1pp82PVehZuYxFec6+2C1d+acU/672IGY?=
 =?us-ascii?Q?DebnxMvuCJfoxWskrH73rgKMPrOO10aqBn9rOmIzZqA3N9y5PKwd+2p3m0Zc?=
 =?us-ascii?Q?oaH2d0ewFoWZoHX/V3aZfCigZUZhhpZa/toLjp1DjNapjif5pGAmfgt9XUX1?=
 =?us-ascii?Q?8/iRoNeTxdqYAwlVRi5g/+yCwaqkWtRaydl3n9FoRAXPTpu33eUawcI7wLLs?=
 =?us-ascii?Q?XsBAv3GZMJxFe8RV+ZaOaCdgacEpQ1ACWFbcezY6NzixtAQTIi+nKN4BL1Gg?=
 =?us-ascii?Q?4LnQxGyfOmo9CCmh82+cTKMDEqqRcJezcmqn6IVXCiSABBcXiCb8AYTzTPNh?=
 =?us-ascii?Q?arSVaigpxGPdK9lkbxdcNENJRD/an+GsOcqmESsMJGgP7VbQQd8oqxLZuGDd?=
 =?us-ascii?Q?ZCdbGeRqkWCbCI88Qnj8MwtxWQQEDk//aeYm87IMe71Sbzclo8c4cCSjc1IN?=
 =?us-ascii?Q?CrDRYkyPQb29mqGivEtL76wOxT3YpPAP42xfPzv/CFt1ygYAyleMXoSbF6iP?=
 =?us-ascii?Q?ZQIiZLkIGkXXGTDRB3YdAcB0VkZUvCyDYiwkFucMDPU05D7SwHAOo4h3LDhP?=
 =?us-ascii?Q?l582zZGEJB2DjQ94M6egCZ/vkArGLXy8PhXjTaWceUt+y3YF1ohJXkPaFDWy?=
 =?us-ascii?Q?RyvYLmRZPE5uGlZwhlXQk2gcZ9qlSui5GxIH0SliU3ZCQtUBG2YKIdSFbPNY?=
 =?us-ascii?Q?w+7vW+EByPGFJVMuZGG7tCC/n4qRx5oepT0X9gtBUqMGkRW1fe1QbyoBR2yQ?=
 =?us-ascii?Q?QjPL3gNFRDEINWMnItHofGUYtF7NCEBhgJbYYxrAnnLVoV8020kkbJQyMRTc?=
 =?us-ascii?Q?Ipzks9ezz08L6GQEvaPKR3gK+xuYWSoHZdBD3Hy4oe65CoSeZrFf6uZyto2a?=
 =?us-ascii?Q?gRk6ICE8YYW0B8BmvXFXhWJT7zc6kMKAONjjZe+Ed1Z/Wtq6Xrrf6qiQChW2?=
 =?us-ascii?Q?W+OlV2uEeBpmLnvrNTpYPM6gNYUfqmUNkO8d9sl3dclfYcoZl5vmEoZcfJnD?=
 =?us-ascii?Q?Qso7cVZPz1mrGk16zh5KTnwLhrJOyvrMGol3grebeW5RSpJoPWqgsyHCqZ5c?=
 =?us-ascii?Q?0BznFYuLduK4YDzILIPbnq2DdXgToqvM6Lb4KIfZGctiYL42IJT33nUWIhqS?=
 =?us-ascii?Q?ULj/53moJ0fe8G6xTTVZQ9a7A119L3bRfN1AQy8cq0fmmafyquqpTjH8XUHY?=
 =?us-ascii?Q?rh9N/3j59Rbz+szx2C0JzXEBR1nhNZSj9GTMAvzpKPeu6M4b25zwIrW4QJVA?=
 =?us-ascii?Q?d7D52EiDjFmBVvvGZ9fxpMkkCmqC/KuyvSp7CVMWlTib8tFlPxFJza2CvbsO?=
 =?us-ascii?Q?CWLxuW0fr7Hs/3DdexQdqXrOV2hL7iTj6n/KyVgwYkemG4s1G+09QI1bO5lx?=
 =?us-ascii?Q?jCV8ufNYL6Azmw93W9s=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:09:20.3887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f22bad5-2012-491e-894c-08de2309ad78
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7899

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

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 40 ++++++++++++++++++++++++++------------
 arch/x86/kvm/vmx/tdx.c   | 21 +++++---------------
 include/linux/kvm_host.h |  3 ++-
 virt/kvm/guest_memfd.c   | 42 ++++++++++++++++++++++++++++++++++------
 4 files changed, 71 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0835c664fbfd..d0ac710697a2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2260,7 +2260,8 @@ struct sev_gmem_populate_args {
 };
 
 static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
-				  void __user *src, int order, void *opaque)
+				  struct page **src_pages, loff_t src_offset,
+				  int order, void *opaque)
 {
 	struct sev_gmem_populate_args *sev_populate_args = opaque;
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
@@ -2268,7 +2269,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 	int npages = (1 << order);
 	gfn_t gfn;
 
-	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
+	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_pages))
 		return -EINVAL;
 
 	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
@@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 			goto err;
 		}
 
-		if (src) {
-			void *vaddr = kmap_local_pfn(pfn + i);
+		if (src_pages) {
+			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
+			void *dst_vaddr = kmap_local_pfn(pfn + i);
 
-			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
-				ret = -EFAULT;
-				goto err;
+			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
+			kunmap_local(src_vaddr);
+
+			if (src_offset) {
+				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
+
+				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
+				kunmap_local(src_vaddr);
 			}
-			kunmap_local(vaddr);
+
+			kunmap_local(dst_vaddr);
 		}
 
 		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
@@ -2331,12 +2339,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 	if (!snp_page_reclaim(kvm, pfn + i) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
 	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
-		void *vaddr = kmap_local_pfn(pfn + i);
+		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
+		void *dst_vaddr = kmap_local_pfn(pfn + i);
 
-		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
-			pr_debug("Failed to write CPUID page back to userspace\n");
+		memcpy(src_vaddr + src_offset, dst_vaddr, PAGE_SIZE - src_offset);
+		kunmap_local(src_vaddr);
+
+		if (src_offset) {
+			src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
+
+			memcpy(src_vaddr, dst_vaddr + PAGE_SIZE - src_offset, src_offset);
+			kunmap_local(src_vaddr);
+		}
 
-		kunmap_local(vaddr);
+		kunmap_local(dst_vaddr);
 	}
 
 	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 57ed101a1181..dd5439ec1473 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3115,37 +3115,26 @@ struct tdx_gmem_post_populate_arg {
 };
 
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, int order, void *_arg)
+				  struct page **src_pages, loff_t src_offset,
+				  int order, void *_arg)
 {
 	struct tdx_gmem_post_populate_arg *arg = _arg;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	u64 err, entry, level_state;
 	gpa_t gpa = gfn_to_gpa(gfn);
-	struct page *src_page;
 	int ret, i;
 
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
+	/* Source should be page-aligned, in which case src_offset will be 0. */
+	if (KVM_BUG_ON(src_offset))
 		return -EINVAL;
 
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
-	kvm_tdx->page_add_src = src_page;
+	kvm_tdx->page_add_src = src_pages[i];
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
 	kvm_tdx->page_add_src = NULL;
 
-	put_page(src_page);
-
 	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
 		return ret;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..7e9d2403c61f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2581,7 +2581,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
  * Returns the number of pages that were populated.
  */
 typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				    void __user *src, int order, void *opaque);
+				    struct page **src_pages, loff_t src_offset,
+				    int order, void *opaque);
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9160379df378..e9ac3fd4fd8f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -814,14 +814,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+
+#define GMEM_GUP_NPAGES (1UL << PMD_ORDER)
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	struct kvm_memory_slot *slot;
-	void __user *p;
-
+	struct page **src_pages;
 	int ret = 0, max_order;
-	long i;
+	loff_t src_offset = 0;
+	long i, src_npages;
 
 	lockdep_assert_held(&kvm->slots_lock);
 
@@ -836,9 +839,28 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (!file)
 		return -EFAULT;
 
+	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
+	npages = min_t(ulong, npages, GMEM_GUP_NPAGES);
+
+	if (src) {
+		src_npages = IS_ALIGNED((unsigned long)src, PAGE_SIZE) ? npages : npages + 1;
+
+		src_pages = kmalloc_array(src_npages, sizeof(struct page *), GFP_KERNEL);
+		if (!src_pages)
+			return -ENOMEM;
+
+		ret = get_user_pages_fast((unsigned long)src, src_npages, 0, src_pages);
+		if (ret < 0)
+			return ret;
+
+		if (ret != src_npages)
+			return -ENOMEM;
+
+		src_offset = (loff_t)(src - PTR_ALIGN_DOWN(src, PAGE_SIZE));
+	}
+
 	filemap_invalidate_lock(file->f_mapping);
 
-	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
 	for (i = 0; i < npages; i += (1 << max_order)) {
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
@@ -869,8 +891,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			max_order--;
 		}
 
-		p = src ? src + i * PAGE_SIZE : NULL;
-		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
+		ret = post_populate(kvm, gfn, pfn, src ? &src_pages[i] : NULL,
+				    src_offset, max_order, opaque);
 		if (!ret)
 			folio_mark_uptodate(folio);
 
@@ -882,6 +904,14 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 
 	filemap_invalidate_unlock(file->f_mapping);
 
+	if (src) {
+		long j;
+
+		for (j = 0; j < src_npages; j++)
+			put_page(src_pages[j]);
+		kfree(src_pages);
+	}
+
 	return ret && !i ? ret : i;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
-- 
2.25.1


