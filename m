Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44262492447
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbiARLHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:07:07 -0500
Received: from mail-co1nam11on2045.outbound.protection.outlook.com ([40.107.220.45]:63264
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238725AbiARLHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:07:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbL0xYKaDNAnry1atOMQAxzH+I6X9EBtsicGb5mlmruQTFvgHcaeXD3XV/zoGM4D67cAzodvilfi7dOUGRYCen4I16YHHCtQcc1ubIbXtIiZCbfolHMhqJLhq66fEUCYtApWFG1DlfKUZy6ZMKqr7uzqyAiXk3hRbERTksDGv2hSOvQKj7g4rgqxiu504VBuogDA5GNfwF52CVgigG9Ohtx19Jx3uTfR6cjpWWJv/HcpiCgafw6sRbNiXaD2ohT/lPf6M5YW+os35+ww85hHUopiJcgLTSEdQ9BlWMy3YF+6O0mJSJcz1HaEJUd3E04y6uOkR1zlDRh6opL4NM3e0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HzJFzzY7RK0oQddNpfeGm2SoJJTaCj8YLnyvXw1h84=;
 b=ms2HwZQEeu/yn14s3bbQiwjbqLMDJUAKidk1Gi1G8RA1crFg7Arg5QQ4ZzIBUzbfhwQZjhX5itAePQf8ExEC71HqPFVkmwy1ymJSrGRdKApMsv0kXjqd+py7c1Pi4RBAlW+yI9EnK0y8GxkbjfFM65do9TlUhpnR3tZc0sXi9WK6yF0naaZ5aj9pzg0xdzayKgy512G1hqIIbhJK1IbDwUlI69pkma1gR4nvZx6PkImzpMonMiRjrwWMwmDjszsOpAb5nwDkgGVVLxZk0KsK/lj8tDrEFt2u9oowpd6Tc8q3qWd39w+hF1OKYfkzHCUUdiOoXfEu9OPJGbkHLO4DsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HzJFzzY7RK0oQddNpfeGm2SoJJTaCj8YLnyvXw1h84=;
 b=yyXx6aHjDGVkhWSY005omyApEMzX4DxUxbsPsfUiZYxC+315xHUh6Bxbue+D5f6LRVN8/JS2DmreSFVgkW2nxhOX90CUf8jFYGVxUbnXrkPdMtp3SFHdeHbLKikZlaIINYcF7n3SzGS17r6PhTpE6OYkv7qYigNtIv+/OZZ7eBI=
Received: from CO1PR15CA0077.namprd15.prod.outlook.com (2603:10b6:101:20::21)
 by BN7PR12MB2788.namprd12.prod.outlook.com (2603:10b6:408:30::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 18 Jan
 2022 11:06:58 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::bf) by CO1PR15CA0077.outlook.office365.com
 (2603:10b6:101:20::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Tue, 18 Jan 2022 11:06:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Tue, 18 Jan 2022 11:06:57 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 05:06:53 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
Date:   Tue, 18 Jan 2022 16:36:18 +0530
Message-ID: <20220118110621.62462-4-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118110621.62462-1-nikunj@amd.com>
References: <20220118110621.62462-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d089fb51-c9a4-4ab6-d5ea-08d9da72a51f
X-MS-TrafficTypeDiagnostic: BN7PR12MB2788:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB27888C3E36A0ACF5E43522B3E2589@BN7PR12MB2788.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75qHYO9c/19BQmWGOlpAs0RKb0EzxX6tOCXOeKoDze97mUB3Ns91AYqJNQkQopZjGPTVHTx46Hoo+woVDBLgDNgHLY7OSh6uXc7tqlot5eOeOWGGE2keVn3YgQBRmFw6tAbfI/C4n3xFbqW8ac6tfl8eRbw/Q7wnUj3N9ksbx9TjFg/WQhG2O8C3YhGxi+AtNLzxjzTQMRniMMSQKui55yQYgyEW/EmSk7KYjXlo6gQRjKz1l0bR7UzZ3sIxJqrWCGH61skr+UzSWZuuBo6YARItYDovkmrX8nXDm4u0fVj8LXMjY+uVpvh3hKMkIMCdtdLVXkC6311GRUgtiCsCBl7BPIx/Fq3nIxwg32x/rojHgDdN4ZNloTSO2Wnwk4WiWiksd0pLEcKcXwceIU1GCzvQw6/GilRnwHfSzNWhnRE2yx6bgtdKDRBSQOM14iwFzph6I0IqCMAfH/lG16DuBSZe+67Md34gwnR6LQ+wWG4iPIiWHSIMoisyRwFOwni6/QO4JMfP7pjWzCmlOAJ0eBnfG5diPcgmN/U3eYcEEySCxwuUgZXGwPP+pvJRHJUqUzL2hLOpNk3Riy0EKtQ39kA6/8XlpfnFoYiUQznzAzAz/XnesKg7GzPMKcds74Rty3BbQW3ibEBXIDYArrBW6q0lQEIXZ64bUND3+PZYdBySDYro30xweOJ+UASAA5txn9TTMFLhy01UsX8+43+d/m67dno52enRYiaFOADFQ+8VsdC2HZDJJ4LjT1PAlcA50iToztcWxVA98VFDqgVzbcBpGcfGwX3xk3WbGuZWHuA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(47076005)(5660300002)(356005)(16526019)(82310400004)(508600001)(316002)(186003)(6916009)(6666004)(54906003)(83380400001)(1076003)(8936002)(4326008)(26005)(40460700001)(70586007)(36756003)(7696005)(70206006)(336012)(81166007)(2616005)(36860700001)(8676002)(2906002)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:06:57.9371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d089fb51-c9a4-4ab6-d5ea-08d9da72a51f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2788
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the memslot metadata to store the pinned data along with the pfns.
This improves the SEV guest startup time from O(n) to a constant by
deferring guest page pinning until the pages are used to satisfy nested
page faults. The page reference will be dropped in the memslot free
path.

Remove the enc_region structure definition and the code which did
upfront pinning, as they are no longer needed in view of the demand
pinning support.

Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
since qemu is dependent on this API.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 208 ++++++++++++++++-------------------------
 arch/x86/kvm/svm/svm.c |   1 +
 arch/x86/kvm/svm/svm.h |   3 +-
 3 files changed, 81 insertions(+), 131 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d972ab4956d4..a962bed97a0b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -66,14 +66,6 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
-struct enc_region {
-	struct list_head list;
-	unsigned long npages;
-	struct page **pages;
-	unsigned long uaddr;
-	unsigned long size;
-};
-
 /* Called with the sev_bitmap_lock held, or on shutdown  */
 static int sev_flush_asids(int min_asid, int max_asid)
 {
@@ -257,8 +249,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (ret)
 		goto e_free;
 
-	INIT_LIST_HEAD(&sev->regions_list);
-
 	return 0;
 
 e_free:
@@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
 	src->handle = 0;
 	src->pages_locked = 0;
 	src->enc_context_owner = NULL;
-
-	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 }
 
 static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
@@ -1861,115 +1849,13 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 int svm_register_enc_region(struct kvm *kvm,
 			    struct kvm_enc_region *range)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct enc_region *region;
-	int ret = 0;
-
-	if (!sev_guest(kvm))
-		return -ENOTTY;
-
-	/* If kvm is mirroring encryption context it isn't responsible for it */
-	if (is_mirroring_enc_context(kvm))
-		return -EINVAL;
-
-	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
-		return -EINVAL;
-
-	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
-	if (!region)
-		return -ENOMEM;
-
-	mutex_lock(&kvm->lock);
-	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
-	if (IS_ERR(region->pages)) {
-		ret = PTR_ERR(region->pages);
-		mutex_unlock(&kvm->lock);
-		goto e_free;
-	}
-
-	region->uaddr = range->addr;
-	region->size = range->size;
-
-	list_add_tail(&region->list, &sev->regions_list);
-	mutex_unlock(&kvm->lock);
-
-	/*
-	 * The guest may change the memory encryption attribute from C=0 -> C=1
-	 * or vice versa for this memory range. Lets make sure caches are
-	 * flushed to ensure that guest data gets written into memory with
-	 * correct C-bit.
-	 */
-	sev_clflush_pages(region->pages, region->npages);
-
-	return ret;
-
-e_free:
-	kfree(region);
-	return ret;
-}
-
-static struct enc_region *
-find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
-{
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct list_head *head = &sev->regions_list;
-	struct enc_region *i;
-
-	list_for_each_entry(i, head, list) {
-		if (i->uaddr == range->addr &&
-		    i->size == range->size)
-			return i;
-	}
-
-	return NULL;
-}
-
-static void __unregister_enc_region_locked(struct kvm *kvm,
-					   struct enc_region *region)
-{
-	sev_unpin_memory(kvm, region->pages, region->npages);
-	list_del(&region->list);
-	kfree(region);
+	return 0;
 }
 
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range)
 {
-	struct enc_region *region;
-	int ret;
-
-	/* If kvm is mirroring encryption context it isn't responsible for it */
-	if (is_mirroring_enc_context(kvm))
-		return -EINVAL;
-
-	mutex_lock(&kvm->lock);
-
-	if (!sev_guest(kvm)) {
-		ret = -ENOTTY;
-		goto failed;
-	}
-
-	region = find_enc_region(kvm, range);
-	if (!region) {
-		ret = -EINVAL;
-		goto failed;
-	}
-
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
-
-	__unregister_enc_region_locked(kvm, region);
-
-	mutex_unlock(&kvm->lock);
 	return 0;
-
-failed:
-	mutex_unlock(&kvm->lock);
-	return ret;
 }
 
 int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
@@ -2018,7 +1904,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	mirror_sev->fd = source_sev->fd;
 	mirror_sev->es_active = source_sev->es_active;
 	mirror_sev->handle = source_sev->handle;
-	INIT_LIST_HEAD(&mirror_sev->regions_list);
 	ret = 0;
 
 	/*
@@ -2038,8 +1923,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct list_head *head = &sev->regions_list;
-	struct list_head *pos, *q;
 
 	WARN_ON(sev->num_mirrored_vms);
 
@@ -2066,18 +1949,6 @@ void sev_vm_destroy(struct kvm *kvm)
 	 */
 	wbinvd_on_all_cpus();
 
-	/*
-	 * if userspace was terminated before unregistering the memory regions
-	 * then lets unpin all the registered memory.
-	 */
-	if (!list_empty(head)) {
-		list_for_each_safe(pos, q, head) {
-			__unregister_enc_region_locked(kvm,
-				list_entry(pos, struct enc_region, list));
-			cond_resched();
-		}
-	}
-
 	sev_unbind_asid(kvm, sev->handle);
 	sev_asid_free(sev);
 }
@@ -2946,13 +2817,90 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
 
+void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+		  kvm_pfn_t pfn)
+{
+	struct kvm_arch_memory_slot *aslot;
+	struct kvm_memory_slot *slot;
+	gfn_t rel_gfn, pin_pfn;
+	unsigned long npages;
+	kvm_pfn_t old_pfn;
+	int i;
+
+	if (!sev_guest(kvm))
+		return;
+
+	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
+		return;
+
+	/* Tested till 1GB pages */
+	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
+		return;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot || !slot->arch.pfns)
+		return;
+
+	/*
+	 * Use relative gfn index within the memslot for the bitmap as well as
+	 * the pfns array
+	 */
+	rel_gfn = gfn - slot->base_gfn;
+	aslot = &slot->arch;
+	pin_pfn = pfn;
+	npages = KVM_PAGES_PER_HPAGE(level);
+
+	/* Pin the page, KVM doesn't yet support page migration. */
+	for (i = 0; i < npages; i++, rel_gfn++, pin_pfn++) {
+		if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
+			old_pfn = aslot->pfns[rel_gfn];
+			if (old_pfn == pin_pfn)
+				continue;
+
+			put_page(pfn_to_page(old_pfn));
+		}
+
+		set_bit(rel_gfn, aslot->pinned_bitmap);
+		aslot->pfns[rel_gfn] = pin_pfn;
+		get_page(pfn_to_page(pin_pfn));
+	}
+
+	/*
+	 * Flush any cached lines of the page being added since "ownership" of
+	 * it will be transferred from the host to an encrypted guest.
+	 */
+	clflush_cache_range(__va(pfn << PAGE_SHIFT), page_level_size(level));
+}
+
 void sev_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	struct kvm_arch_memory_slot *aslot = &slot->arch;
+	kvm_pfn_t *pfns;
+	gfn_t gfn;
+	int i;
 
 	if (!sev_guest(kvm))
 		return;
 
+	if (!aslot->pinned_bitmap || !slot->arch.pfns)
+		goto out;
+
+	pfns = aslot->pfns;
+
+	/*
+	 * Iterate the memslot to find the pinned pfn using the bitmap and drop
+	 * the pfn stored.
+	 */
+	for (i = 0, gfn = slot->base_gfn; i < slot->npages; i++, gfn++) {
+		if (test_and_clear_bit(i, aslot->pinned_bitmap)) {
+			if (WARN_ON(!pfns[i]))
+				continue;
+
+			put_page(pfn_to_page(pfns[i]));
+		}
+	}
+
+out:
 	if (aslot->pinned_bitmap) {
 		kvfree(aslot->pinned_bitmap);
 		aslot->pinned_bitmap = NULL;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3fb19974f719..22535c680b3f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4743,6 +4743,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.alloc_memslot_metadata = sev_alloc_memslot_metadata,
 	.free_memslot = sev_free_memslot,
+	.pin_spte = sev_pin_spte,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b2f8b3b52680..c731bc91ea8f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -77,7 +77,6 @@ struct kvm_sev_info {
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
-	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
@@ -648,5 +647,7 @@ int sev_alloc_memslot_metadata(struct kvm *kvm,
 			       struct kvm_memory_slot *new);
 void sev_free_memslot(struct kvm *kvm,
 		      struct kvm_memory_slot *slot);
+void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+		  kvm_pfn_t pfn);
 
 #endif
-- 
2.32.0

