Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877F14D0EBC
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245213AbiCHElH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245130AbiCHElE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:41:04 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6762C647;
        Mon,  7 Mar 2022 20:40:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1/KvOIV5bax8ukHSBSCrZ0PBG26Fixc1yXdUfEvMFQHvRfgk0igxCVRb7TCR3jcF+aeiPoKc59VS+VlS3hbTsU8MOMTbtUGjFQVD8p3bUIgd3tduONXTTj+ceZXxvBkZ3+ANqJM2AO8qs3ByXBceAFR/C92VP8MoQOesrIQ6R9KbFN2sa1Dcc8Ik22Rea26zp5T+FKt1LFsYmPUZsHcdZt2OwOIrRGYfnt6E9+z2xZQfCFbWBtTc5QXbshvwl069+R2lqwczdYAwoDJyDzEs8EThX1OA432ln8Q9ox2ZN3peCHB/r5BDG2Be+lcegOfcL94O9j6WCpIiDfdfFQZCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uqz3I+koh45aexq7CPsIKKTkBL0kzdnWB4RnzMSqJek=;
 b=H2FvyUCSj+CbbTxTzsptmrxaarvHJ38tyHKb3NgltBzF9A7GBLndPRyvTdd/kcK8m6OGCbdAkzcwf4aUbIC/PZC04P0oPFEHhYE05ruByksq2nU89GC8KOcBSm206KVq+9TrB9XKaaaXQsKiAwJPpU/aDtOfANhfmEXDoKUqj3784kTeknjKCJ1ZujbR41rfn75i4O5uHrEdQtV0ZNr466aMGV89oZKlkb7nGZmr+EpVqv1RU8Go4UWceblVujurCCjy/pcdYjE6rOSWhPmx685RGh+32XEXwtcjpGSEnRPpgGDJcMDkXTBlwVbzGParjfVrtlJSdcivWZ67lqovzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uqz3I+koh45aexq7CPsIKKTkBL0kzdnWB4RnzMSqJek=;
 b=4e+5Ws3rYoy0DxW/1AjrvgnRZfWSiXo8Fq8dRW7OpikBwZinEvD2BDOhhgttTN6CpPwmK6tEXD7HdUgLzF1UcwmVCNybEdwDHgQi/IfTibH+rcu7U4wc17hQnxLkleY+pUVQpOHz1j+CV3ph2FfDoj6Wq2HTL0c64UVB/2cXbXc=
Received: from DS7PR03CA0006.namprd03.prod.outlook.com (2603:10b6:5:3b8::11)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 04:40:07 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::a5) by DS7PR03CA0006.outlook.office365.com
 (2603:10b6:5:3b8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:07 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:40:01 -0600
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
Subject: [PATCH RFC v1 1/9] KVM: Introduce pinning flag to hva_to_pfn*
Date:   Tue, 8 Mar 2022 10:08:49 +0530
Message-ID: <20220308043857.13652-2-nikunj@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: f147d715-128d-46b5-8825-08da00bdb893
X-MS-TrafficTypeDiagnostic: DM6PR12MB4042:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4042BE0A05CB2F3AF685A3FDE2099@DM6PR12MB4042.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HGWU0fx3tvPn6Hm/1uhX+EuF+n3eq5s8qzeJHUK85cVFNoDReAOg6hqv4TirInRNaRcSMjiEnME18N0g6EHyQywi/D7MvQsFaX70DZdjU95Ae6p8fylWvMVXS/IZcO/vpA3FjSTLUx4caK1tfqEKzsGwJKGQLJmjZVI4S2cbtuyLNgVfikE7mm2Pn8o0bLoVkfsC6Q7rqC34tegmJRPZXlUagR7P7BXBjcJze+Pe2eQyqeQISw1JEiwfDb8Ld2BDspLe3Dne61BLXMxDffD7+L0ckKUdjTq5GeYZpaMnKkOIrjW9Isuw3uFvIQ16WNGApy8UgYu5JwlTTkjshhZUBJDCpfhZZ8aL8LBl5AB0/5MadHCLs1rGax/67h6fGXS/581JN4stZ9aTkZf1acAmDNnf4/h4F9TIwtj3rjIW8v6XRpXFNDAaqUuowfO5eUdJ+dBV0KA9onLVL5DL54S1pZYQFXc3rc9WNcBKRA2UA8bdPRlYP71lwvftv0I92suXJzsnb3EAtq0Sv2nDBOznE6kjGpb0xZVEe87KIKqmmUii1akVkTICwfmoE6wulaDAmjIwQ2q7+CWAyszmK4JXeBGsNGYKNqRdKpRu0jSJUGGOjmQtJ4xoWgwa2seT2zW612rXiqm52K+GxMU1mgPXc1I3If37lOwB61XnmAKKsxGKdfKyXhITjPVfw5GnpM5W0STjWAUlyTMfx3Rzp8jSwQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7696005)(36860700001)(16526019)(6916009)(54906003)(2906002)(26005)(186003)(316002)(82310400004)(356005)(40460700003)(81166007)(336012)(426003)(47076005)(8936002)(2616005)(508600001)(6666004)(83380400001)(1076003)(7416002)(36756003)(8676002)(4326008)(70206006)(5660300002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:07.0904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f147d715-128d-46b5-8825-08da00bdb893
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM allocates pages with get_user_pages_* (that use FOLL_GET). For
long term pinning of guest pages pin_user_pages_* (that use FOLL_PIN)
need to be used. Add a flag to hva_to_pfn* to allocate pinned pages
when the memslot represents encrypted memory.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 include/linux/kvm_host.h |  6 ++++
 virt/kvm/kvm_main.c      | 63 ++++++++++++++++++++++++++++++----------
 virt/kvm/kvm_mm.h        |  2 +-
 virt/kvm/pfncache.c      |  2 +-
 4 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..c23022960d51 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -55,6 +55,7 @@
  * include/linux/kvm_h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
+#define KVM_MEMSLOT_ENCRYPTED   (1UL << 17)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -583,6 +584,11 @@ static inline unsigned long *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
 	return memslot->dirty_bitmap + len / sizeof(*memslot->dirty_bitmap);
 }
 
+static inline bool memslot_is_encrypted(const struct kvm_memory_slot *slot)
+{
+	return slot && (slot->flags & KVM_MEMSLOT_ENCRYPTED);
+}
+
 #ifndef KVM_DIRTY_LOG_MANUAL_CAPS
 #define KVM_DIRTY_LOG_MANUAL_CAPS KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0afc016cc54d..c035fe6b39ec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2381,9 +2381,10 @@ static inline int check_user_page_hwpoison(unsigned long addr)
  * only part that runs if we can in atomic context.
  */
 static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
-			    bool *writable, kvm_pfn_t *pfn)
+			    bool *writable, kvm_pfn_t *pfn, bool use_pin)
 {
 	struct page *page[1];
+	bool ret;
 
 	/*
 	 * Fast pin a writable pfn only if it is a write fault request
@@ -2393,7 +2394,12 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 	if (!(write_fault || writable))
 		return false;
 
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (!use_pin)
+		ret = get_user_page_fast_only(addr, FOLL_WRITE, page);
+	else
+		ret = pin_user_pages_fast_only(addr, 1, FOLL_WRITE | FOLL_LONGTERM, page);
+
+	if (ret) {
 		*pfn = page_to_pfn(page[0]);
 
 		if (writable)
@@ -2409,9 +2415,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * 1 indicates success, -errno is returned if error is detected.
  */
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
-			   bool *writable, kvm_pfn_t *pfn)
+			   bool *writable, kvm_pfn_t *pfn, bool use_pin)
 {
-	unsigned int flags = FOLL_HWPOISON;
+	unsigned int flags = 0;
 	struct page *page;
 	int npages = 0;
 
@@ -2422,20 +2428,41 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 
 	if (write_fault)
 		flags |= FOLL_WRITE;
-	if (async)
-		flags |= FOLL_NOWAIT;
 
-	npages = get_user_pages_unlocked(addr, 1, &page, flags);
+	if (!use_pin) {
+		flags |= FOLL_HWPOISON;
+		if (async)
+			flags |= FOLL_NOWAIT;
+
+		npages = get_user_pages_unlocked(addr, 1, &page, flags);
+	} else {
+		/*
+		 * FOLL_LONGTERM is not supported in pin_user_pages_unlocked,
+		 * use *_fast instead.
+		 */
+		flags |= FOLL_LONGTERM;
+		npages = pin_user_pages_fast(addr, 1, flags, &page);
+	}
+
 	if (npages != 1)
 		return npages;
 
 	/* map read fault as writable if possible */
 	if (unlikely(!write_fault) && writable) {
 		struct page *wpage;
+		bool ret;
+
+		if (!use_pin)
+			ret = get_user_page_fast_only(addr, FOLL_WRITE, &wpage);
+		else
+			ret = pin_user_pages_fast_only(addr, 1, FOLL_WRITE | FOLL_LONGTERM, &wpage);
 
-		if (get_user_page_fast_only(addr, FOLL_WRITE, &wpage)) {
+		if (ret) {
 			*writable = true;
-			put_page(page);
+			if (!use_pin)
+				put_page(page);
+			else
+				unpin_user_page(page);
 			page = wpage;
 		}
 	}
@@ -2541,7 +2568,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  *     whether the mapping is writable.
  */
 kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-		     bool write_fault, bool *writable)
+		     bool write_fault, bool *writable, bool use_pin)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn = 0;
@@ -2550,13 +2577,13 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	/* we can do it either atomically or asynchronously, not both */
 	BUG_ON(atomic && async);
 
-	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
+	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn, use_pin))
 		return pfn;
 
 	if (atomic)
 		return KVM_PFN_ERR_FAULT;
 
-	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn, use_pin);
 	if (npages == 1)
 		return pfn;
 
@@ -2616,7 +2643,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	}
 
 	return hva_to_pfn(addr, atomic, async, write_fault,
-			  writable);
+			  writable, memslot_is_encrypted(slot));
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
@@ -2788,8 +2815,14 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
-	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
-		put_page(pfn_to_page(pfn));
+	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn)) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (page_maybe_dma_pinned(page))
+			unpin_user_page(page);
+		else
+			put_page(page);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 34ca40823260..b1a5e379949b 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -25,7 +25,7 @@
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
 kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-		     bool write_fault, bool *writable);
+		     bool write_fault, bool *writable, bool use_pin);
 
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index ce878f4be4da..44384f06c81b 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -135,7 +135,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva)
 		smp_rmb();
 
 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
+		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL, false);
 		if (is_error_noslot_pfn(new_pfn))
 			break;
 
-- 
2.32.0

