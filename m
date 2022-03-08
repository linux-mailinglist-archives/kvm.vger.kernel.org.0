Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE634D0ECF
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245130AbiCHEli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245315AbiCHEld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:41:33 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB3431504;
        Mon,  7 Mar 2022 20:40:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhAghTPFnC0ICH+dbtsNb+4EHJmDX+K8ri2i3ndcR6y2BQGgUS3vpsSB8ViaAAfGVEO3o7g2sgZSbI5YgiUcgSLOnlFKrIipadN1xmVw3vsYNf8ESArd/IUgYgM6BH7ZO1krnrDJG1Y21Jlt1Q5Kg6ehmaD5ZnSNRdQgfX44vUZpq1T6+3XF60EJNJjnAnSH7DVxxatbUB6uGYgba3vLDXZiEpSLPr4qpHaV/t0BxRrDXWAVbIZuZc4gc3lmy9pC7e9p+fTKaIpoWCBh6O56Svaduh9uWAv3psMkpjEjwCtOiRisWFoRPfT+RIbkaA7/bGA25FNShVzCl/6DHrkLxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O737pXNU3JIqLDkkaKttX9X3S4g+ai2wSj7UWpHiHQY=;
 b=gdZYoziTxA9ulkAPBA0DhNK3SpUOX3/g36+pLu/HXQRr/C7pTYOFqxErKWH2v9TXi/vl80qR1Hz4zdcb0raB1YqdDj239TVzatSXPCnHwl3szObHPJ8GBB/qVU48Zsj8Rpw4PXUmi5T31wnEATDVBbhB951knLrer86aunlhTf/KlY8KPV5fxwjyd6GphFCN9EcZ4R6r3bexxEXKsbdup0revSoB954GNOZUNt4xabx8GWl48kjyM29Ku74KGqZ1dbutudKQliYilIKQkAUaRbq7Tb4KJMGF2ae+BLgzmJknAniG2Iqsh293oBKuiwY4LoHfFGOc7wA/a2COvIAh+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O737pXNU3JIqLDkkaKttX9X3S4g+ai2wSj7UWpHiHQY=;
 b=JoUN7nNvlC3Q90hQwQSx2Z24nKZm5FVpELIr/mHFK6cK0u+mBjrW+Gkb1a3GRQLKWHyINFmPvhAs2y3TBfFqM8Y1SsGFaTIa3rV4Gd76rZTjzEi0CuN0+EqCOsiE1V3q/2KHIsuR/ZVu9mZAG4qjHdNdjLNftMIp/sYKolugAvg=
Received: from DM5PR2201CA0013.namprd22.prod.outlook.com (2603:10b6:4:14::23)
 by BYAPR12MB3013.namprd12.prod.outlook.com (2603:10b6:a03:a9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Tue, 8 Mar
 2022 04:40:28 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::8) by DM5PR2201CA0013.outlook.office365.com
 (2603:10b6:4:14::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:27 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:40:22 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v1 5/9] KVM: SVM: Implement demand page pinning
Date:   Tue, 8 Mar 2022 10:08:53 +0530
Message-ID: <20220308043857.13652-6-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220308043857.13652-1-nikunj@amd.com>
References: <20220308043857.13652-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6414c5cd-fb29-4eb3-7bdf-08da00bdc4d6
X-MS-TrafficTypeDiagnostic: BYAPR12MB3013:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3013C437CF51F649109FCFE3E2099@BYAPR12MB3013.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mmqvOumGxcAaNjIZbRw3uBTAbVqzK2OTT4xqC5qJbRie70F0lAPw+DpOAJjaKMNSw4R7Z+r1kuoGJTSpqEWCH4levoVLFhQ0TkHTyP2jeY82MSMy6H4fVkXXwX1Z26RugPYBWsEDU6BRi2KAXOFW5WrOBgjIWz921+0/pY6EmNk25dJpezzpvWmUoAhXPZsXi6XzfiAnAeO8AbBESXtAyvwlw45RRGbtwQoOr1Iro6xXoq9PHne492PwfUxXKybpRTFVl7DpxDLRVn5YwXhwfJO17yTZjbt7v7QT0juCfr65toTpPFEd0b22UcDr1bgce9+2+TyaisJLBcpQ9tLgaE0EPHWEVNgD4Vw2JvCnKLcFKufQ1HexKru2vx9MQgMM40HUPZCO/xGpQG48pmOT/btpZF9q2JW1EWJaZHVLUGgB9evp9caj2oAlioAFZ3DxXU+N0QBRkKsjWUTAXCLWkdNXtJQXVqAH0BeyR2HiyNZ/nJ/10w2gmCIwlD7ZasAa/bBOHkBSQfTdCSW5Xvs0vomSxpO7aYb7Htb6UE0T3s+XhuFsiqqbOzI5c4OkCZEhzV3VHGPmacPy4HC4efPgncspYYQLr8CkdCB7VsxqOOEPv/2QCovBMYwqvmvYRBPurHpzOPH5B/ww57g6a0SxIlHBaUB2jFoPLkJE5ZfprXXNHKACklbQSsxWTFj7IhBYlwhoi/szMroKVjGDRoyDoQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(36860700001)(7696005)(36756003)(2616005)(2906002)(83380400001)(40460700003)(7416002)(5660300002)(316002)(54906003)(82310400004)(26005)(8936002)(81166007)(70206006)(30864003)(336012)(426003)(356005)(70586007)(186003)(1076003)(6916009)(8676002)(16526019)(6666004)(4326008)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:27.6462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6414c5cd-fb29-4eb3-7bdf-08da00bdc4d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the memslot metadata to store the pinned data along with the pfns.
This improves the SEV guest startup time from O(n) to a constant by
deferring guest page pinning until the pages are used to satisfy
nested page faults. The page reference will be dropped in the memslot
free path or deallocation path.

Reuse enc_region structure definition as pinned_region to maintain
pages that are pinned outside of MMU demand pinning. Remove rest of
the code which did upfront pinning, as they are no longer needed in
view of the demand pinning support.

Retain svm_register_enc_region() and svm_unregister_enc_region() with
required checks for resource limit.

Guest boot time comparison
  +---------------+----------------+-------------------+
  | Guest Memory  |   baseline     |  Demand Pinning   |
  | Size (GB)     |    (secs)      |     (secs)        |
  +---------------+----------------+-------------------+
  |      4        |     6.16       |      5.71         |
  +---------------+----------------+-------------------+
  |     16        |     7.38       |      5.91         |
  +---------------+----------------+-------------------+
  |     64        |    12.17       |      6.16         |
  +---------------+----------------+-------------------+
  |    128        |    18.20       |      6.50         |
  +---------------+----------------+-------------------+
  |    192        |    24.56       |      6.80         |
  +---------------+----------------+-------------------+

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 304 ++++++++++++++++++++++++++---------------
 arch/x86/kvm/svm/svm.c |   1 +
 arch/x86/kvm/svm/svm.h |   6 +-
 3 files changed, 200 insertions(+), 111 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bd7572517c99..d0514975555d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -66,7 +66,7 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
-struct enc_region {
+struct pinned_region {
 	struct list_head list;
 	unsigned long npages;
 	struct page **pages;
@@ -257,7 +257,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (ret)
 		goto e_free;
 
-	INIT_LIST_HEAD(&sev->regions_list);
+	INIT_LIST_HEAD(&sev->pinned_regions_list);
 
 	return 0;
 
@@ -378,16 +378,34 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static bool rlimit_memlock_exceeds(unsigned long locked, unsigned long npages)
+{
+	unsigned long lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	unsigned long lock_req;
+
+	lock_req = locked + npages;
+	return (lock_req > lock_limit) && !capable(CAP_IPC_LOCK);
+}
+
+static unsigned long get_npages(unsigned long uaddr, unsigned long ulen)
+{
+	unsigned long first, last;
+
+	/* Calculate number of pages. */
+	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
+	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
+	return last - first + 1;
+}
+
 static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 				    unsigned long ulen, unsigned long *n,
 				    int write)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct pinned_region *region;
 	unsigned long npages, size;
 	int npinned;
-	unsigned long locked, lock_limit;
 	struct page **pages;
-	unsigned long first, last;
 	int ret;
 
 	lockdep_assert_held(&kvm->lock);
@@ -395,15 +413,12 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	if (ulen == 0 || uaddr + ulen < uaddr)
 		return ERR_PTR(-EINVAL);
 
-	/* Calculate number of pages. */
-	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
-	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
-	npages = (last - first + 1);
+	npages = get_npages(uaddr, ulen);
 
-	locked = sev->pages_locked + npages;
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
-		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n", locked, lock_limit);
+	if (rlimit_memlock_exceeds(sev->pages_to_lock, npages)) {
+		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n",
+			sev->pages_to_lock + npages,
+			(rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT));
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -429,7 +444,19 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	}
 
 	*n = npages;
-	sev->pages_locked = locked;
+	sev->pages_to_lock += npages;
+
+	/* Maintain region list that is pinned to be unpinned in vm destroy path */
+	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
+	if (!region) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	region->uaddr = uaddr;
+	region->size = ulen;
+	region->pages = pages;
+	region->npages = npages;
+	list_add_tail(&region->list, &sev->pinned_regions_list);
 
 	return pages;
 
@@ -441,14 +468,43 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	return ERR_PTR(ret);
 }
 
-static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
-			     unsigned long npages)
+static void __sev_unpin_memory(struct kvm *kvm, struct page **pages,
+			       unsigned long npages)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
 	unpin_user_pages(pages, npages);
 	kvfree(pages);
-	sev->pages_locked -= npages;
+	sev->pages_to_lock -= npages;
+}
+
+static struct pinned_region *find_pinned_region(struct kvm *kvm,
+					     struct page **pages,
+					     unsigned long n)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct list_head *head = &sev->pinned_regions_list;
+	struct pinned_region *i;
+
+	list_for_each_entry(i, head, list) {
+		if (i->pages == pages && i->npages == n)
+			return i;
+	}
+
+	return NULL;
+}
+
+static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
+			     unsigned long npages)
+{
+	struct pinned_region *region;
+
+	region = find_pinned_region(kvm, pages, npages);
+	__sev_unpin_memory(kvm, pages, npages);
+	if (region) {
+		list_del(&region->list);
+		kfree(region);
+	}
 }
 
 static void sev_clflush_pages(struct page *pages[], unsigned long npages)
@@ -551,8 +607,9 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		set_page_dirty_lock(inpages[i]);
 		mark_page_accessed(inpages[i]);
 	}
-	/* unlock the user pages */
-	sev_unpin_memory(kvm, inpages, npages);
+	/* unlock the user pages on error */
+	if (ret)
+		sev_unpin_memory(kvm, inpages, npages);
 	return ret;
 }
 
@@ -1059,7 +1116,8 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		set_page_dirty_lock(pages[i]);
 		mark_page_accessed(pages[i]);
 	}
-	sev_unpin_memory(kvm, pages, n);
+	if (ret)
+		sev_unpin_memory(kvm, pages, n);
 	return ret;
 }
 
@@ -1338,7 +1396,8 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 e_free_hdr:
 	kfree(hdr);
 e_unpin:
-	sev_unpin_memory(kvm, guest_page, n);
+	if (ret)
+		sev_unpin_memory(kvm, guest_page, n);
 
 	return ret;
 }
@@ -1508,7 +1567,8 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, &data,
 				&argp->error);
 
-	sev_unpin_memory(kvm, guest_page, n);
+	if (ret)
+		sev_unpin_memory(kvm, guest_page, n);
 
 e_free_trans:
 	kfree(trans);
@@ -1629,16 +1689,17 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
 	dst->active = true;
 	dst->asid = src->asid;
 	dst->handle = src->handle;
-	dst->pages_locked = src->pages_locked;
+	dst->pages_to_lock = src->pages_to_lock;
 	dst->enc_context_owner = src->enc_context_owner;
 
 	src->asid = 0;
 	src->active = false;
 	src->handle = 0;
-	src->pages_locked = 0;
+	src->pages_to_lock = 0;
 	src->enc_context_owner = NULL;
 
-	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
+	list_cut_before(&dst->pinned_regions_list, &src->pinned_regions_list,
+			&src->pinned_regions_list);
 }
 
 static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
@@ -1862,8 +1923,7 @@ int svm_register_enc_region(struct kvm *kvm,
 			    struct kvm_enc_region *range)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct enc_region *region;
-	int ret = 0;
+	unsigned long npages;
 
 	if (!sev_guest(kvm))
 		return -ENOTTY;
@@ -1875,101 +1935,35 @@ int svm_register_enc_region(struct kvm *kvm,
 	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
 		return -EINVAL;
 
-	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
-	if (!region)
+	npages = get_npages(range->addr, range->size);
+	if (rlimit_memlock_exceeds(sev->pages_to_lock, npages)) {
+		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n",
+		       sev->pages_to_lock + npages,
+		       (rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT));
 		return -ENOMEM;
-
-	mutex_lock(&kvm->lock);
-	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
-	if (IS_ERR(region->pages)) {
-		ret = PTR_ERR(region->pages);
-		mutex_unlock(&kvm->lock);
-		goto e_free;
 	}
+	sev->pages_to_lock += npages;
 
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
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long npages;
 
 	/* If kvm is mirroring encryption context it isn't responsible for it */
 	if (is_mirroring_enc_context(kvm))
 		return -EINVAL;
 
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
+	if (!sev_guest(kvm))
+		return -ENOTTY;
 
-	__unregister_enc_region_locked(kvm, region);
+	npages = get_npages(range->addr, range->size);
+	sev->pages_to_lock -= npages;
 
-	mutex_unlock(&kvm->lock);
 	return 0;
-
-failed:
-	mutex_unlock(&kvm->lock);
-	return ret;
 }
 
 int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
@@ -2018,7 +2012,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	mirror_sev->fd = source_sev->fd;
 	mirror_sev->es_active = source_sev->es_active;
 	mirror_sev->handle = source_sev->handle;
-	INIT_LIST_HEAD(&mirror_sev->regions_list);
+	INIT_LIST_HEAD(&mirror_sev->pinned_regions_list);
 	ret = 0;
 
 	/*
@@ -2038,8 +2032,9 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct list_head *head = &sev->regions_list;
+	struct list_head *head = &sev->pinned_regions_list;
 	struct list_head *pos, *q;
+	struct pinned_region *region;
 
 	WARN_ON(sev->num_mirrored_vms);
 
@@ -2072,8 +2067,14 @@ void sev_vm_destroy(struct kvm *kvm)
 	 */
 	if (!list_empty(head)) {
 		list_for_each_safe(pos, q, head) {
-			__unregister_enc_region_locked(kvm,
-				list_entry(pos, struct enc_region, list));
+			/*
+			 * Unpin the memory that were pinned outside of MMU
+			 * demand pinning
+			 */
+			region = list_entry(pos, struct pinned_region, list);
+			__sev_unpin_memory(kvm, region->pages, region->npages);
+			list_del(&region->list);
+			kfree(region);
 			cond_resched();
 		}
 	}
@@ -2951,13 +2952,96 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
 
+bool sev_pin_pfn(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
+		 kvm_pfn_t pfn, hva_t hva, bool write, enum pg_level level)
+{
+	unsigned int npages = KVM_PAGES_PER_HPAGE(level);
+	unsigned int flags = FOLL_LONGTERM, npinned;
+	struct kvm_arch_memory_slot *aslot;
+	struct kvm *kvm = vcpu->kvm;
+	gfn_t gfn_start, rel_gfn;
+	struct page *page[1];
+	kvm_pfn_t old_pfn;
+
+	if (!sev_guest(kvm))
+		return true;
+
+	if (WARN_ON_ONCE(!memslot->arch.pfns))
+		return false;
+
+	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
+		return false;
+
+	hva = ALIGN_DOWN(hva, npages << PAGE_SHIFT);
+	flags |= write ? FOLL_WRITE : 0;
+
+	mutex_lock(&kvm->slots_arch_lock);
+	gfn_start = hva_to_gfn_memslot(hva, memslot);
+	rel_gfn = gfn_start - memslot->base_gfn;
+	aslot = &memslot->arch;
+	if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
+		old_pfn = aslot->pfns[rel_gfn];
+		if (old_pfn == pfn)
+			goto out;
+
+		/* Flush the cache before releasing the page to the system */
+		sev_flush_guest_memory(to_svm(vcpu), __va(old_pfn),
+				       npages * PAGE_SIZE);
+		unpin_user_page(pfn_to_page(old_pfn));
+	}
+	/* Pin the page, KVM doesn't yet support page migration. */
+	npinned = pin_user_pages_fast(hva, 1, flags, page);
+	KVM_BUG(npinned != 1, kvm, "SEV: Pinning failed\n");
+	KVM_BUG(pfn != page_to_pfn(page[0]), kvm, "SEV: pfn mismatch\n");
+
+	if (!this_cpu_has(X86_FEATURE_SME_COHERENT))
+		clflush_cache_range(__va(pfn << PAGE_SHIFT), npages * PAGE_SIZE);
+
+	WARN_ON(rel_gfn >= memslot->npages);
+	aslot->pfns[rel_gfn] = pfn;
+	set_bit(rel_gfn, aslot->pinned_bitmap);
+
+out:
+	mutex_unlock(&kvm->slots_arch_lock);
+	return true;
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
+	 * Ensure that all guest tagged cache entries are flushed before
+	 * releasing the pages back to the system for use. CLFLUSH will
+	 * not do this, so issue a WBINVD.
+	 */
+	wbinvd_on_all_cpus();
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
+			unpin_user_page(pfn_to_page(pfns[i]));
+		}
+	}
+
+out:
 	if (aslot->pinned_bitmap) {
 		kvfree(aslot->pinned_bitmap);
 		aslot->pinned_bitmap = NULL;
@@ -2992,6 +3076,8 @@ int sev_alloc_memslot_metadata(struct kvm *kvm,
 		return -ENOMEM;
 
 	aslot->pinned_bitmap = kvzalloc(pinned_bytes, GFP_KERNEL_ACCOUNT);
+	new->flags |= KVM_MEMSLOT_ENCRYPTED;
+
 	if (!aslot->pinned_bitmap) {
 		kvfree(aslot->pfns);
 		aslot->pfns = NULL;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ec06421cb532..463a90ed6f83 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4661,6 +4661,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.alloc_memslot_metadata = sev_alloc_memslot_metadata,
 	.free_memslot = sev_free_memslot,
+	.pin_pfn = sev_pin_pfn,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f00364020d7e..2f38e793ead0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -75,8 +75,8 @@ struct kvm_sev_info {
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
-	unsigned long pages_locked; /* Number of pages locked */
-	struct list_head regions_list;  /* List of registered regions */
+	unsigned long pages_to_lock; /* Number of page that can be locked */
+	struct list_head pinned_regions_list;  /* List of pinned regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
@@ -621,5 +621,7 @@ int sev_alloc_memslot_metadata(struct kvm *kvm,
 			       struct kvm_memory_slot *new);
 void sev_free_memslot(struct kvm *kvm,
 		      struct kvm_memory_slot *slot);
+bool sev_pin_pfn(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
+		 kvm_pfn_t pfn, hva_t hva, bool write, enum pg_level level);
 
 #endif
-- 
2.32.0

