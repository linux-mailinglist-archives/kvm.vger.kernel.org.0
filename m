Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4409C70B52B
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 08:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjEVGhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 02:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjEVGhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 02:37:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543B8A1;
        Sun, 21 May 2023 23:37:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PM2s3eAVPAI4b26cAg6yZZg+ReOybDE55Llu+7UXkLlvijKefzPrwXOB6/ZXR9vrbHI5NcOctx3ARJ6UtafBb+ZbtypVmPVlqYGAE+M66wDL9AyR14VDX5SnQrk3IL4X8hPqE1tPIm2ytm89NA2aA02j9nBAYHFg3aY62cCVcXpuYiygxD81AFA2T5zz2B/RM0gxV065Kuz3DnXzXkDAYGbM2ANcLm0laq23RHdCvHx3P1burInHQbGU8ZZvoZvbOYakZof03Oo8pVMcbhU7VPwh4cAY8N4ufi4mf9OrObrllU6lXnTDDO3R/zI02HK43DeYtkPuGVPA4h3uItCvOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PfkTHYIYcsTi/4RaMc7owvRMVyfLOqwG9cIXVoqlZQ=;
 b=l7ZcM6kEqKduVNRfCpVtbZrdJMKRJ25rvSKgF3qzaHZSVqRImFcBd799rnzsgTYmK2pls1ZZa/a+OiY6OByhFanjMvzxyN2qK5SMA7hXADifnsc51o66WpFxHrqHvCZsNdiaSQZr5mquq0NQvDJrlKTS/i7+VwmlP1flMcfEvZKifIRFvdPJJMHR9Azxd38/vjhrRy+5g85DYYN5wjaCQU7w8Pjf2Y2H4ZClV/DqP7rnXxTaEWjEAPXuvKbo/4SPsaZZm7caq9kC+jnpPsglw40Bvc0P7GRc5mW6rzrtF/qUzjYgxA3EZvHUMYLW9WYDtI6ag/0x94AjO8qJmNe/Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PfkTHYIYcsTi/4RaMc7owvRMVyfLOqwG9cIXVoqlZQ=;
 b=dT43PdDlhEHEG11ika6sP+BBTHZEdCd8Fo67R/TaOmTCNkNQxR9iqCq+9BfysA/LqYS5HAwWCp7cet20sNFSUnSsPZOPKu8vj8LzaT7b2qhGyCPC2feXx0H/MJZ7j/Go5I3t9H13UOOYisVwJp0Rj3uD1IMr4AmyM8TuUEN0dqrs43wX6vqYvQAegzX4jQNdmzZYpOP5q5d1P/c/O8v27PuW9Wlx2F1KyJSYbMj8s+xvvSGE+RLdaoiV/RRSwJip1hHkuJ+DkCDeY5fmWbsjJqKJdbfDS0fA2bTLo0fgapflfQHT4+SxLfGMOljJrX+P0OnjRritbzE007wKJJ3e0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by CH3PR12MB7644.namprd12.prod.outlook.com (2603:10b6:610:14f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 06:37:41 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 06:37:40 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        robin.murphy@arm.com, will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>
Subject: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Date:   Mon, 22 May 2023 16:37:25 +1000
Message-Id: <20230522063725.284686-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0041.ausprd01.prod.outlook.com
 (2603:10c6:10:e9::10) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|CH3PR12MB7644:EE_
X-MS-Office365-Filtering-Correlation-Id: a6403dff-ce2f-4dc6-6792-08db5a8f0a47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v8h+86Jvmxgxkz5+mj/rMD93sXIrPOfq067cpa6tQtugDR6Qi+dWaWTGLvMcwPyvyMSWmg1T0fRMEoap1Sv8fpPKfr/LUPJg5I2X6gFgCTldg6q+BZv1E+ZFEUj8hfaxd1jX08AwjFpc3QQ1NpZP8U575G/CysI8g+QpFobAARtmTel4CN/qII1qf3GdzwWGxhn47Hem+X8bMdInCIk+AwFOvJgQYUCRRyGSWqgIcARxQCJOPjNSF6lDKLU3eVqxwhhNcSaCGZcfTYAaUs61BnDOLhcZEimz5NKhEINibE1qaJYYANyRqGtYoDMSIpjrx/CP3PoX0t8Pizz43rM8SVP3YTd+dh6Y1tJJyAC8XwrbASrdKqgG9VoeTxpN42PsPdBQMC+pCeMPYj3PWxjFdSNeTGXD4yG4/u/ECxkhQ1/U2o2gzYaFEhK51ir6jBNSb1lFLhch2aZBXcFWv0nMnurLJFSEGUCufP4zFoK7LSccLv3I3CfMzq+rBXzZGmRF4wft4gcenI+sXMl23I6qMYAapvBofHEvv0tbcAGDNXeU9jLdG44fEm23T3weSseG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199021)(8676002)(8936002)(5660300002)(83380400001)(186003)(26005)(1076003)(6512007)(6506007)(2616005)(86362001)(107886003)(38100700002)(41300700001)(6666004)(6486002)(66476007)(66556008)(66946007)(316002)(6916009)(4326008)(36756003)(478600001)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g9tlTJz87bv56huw01SkODQu6S/HaB+7ZV0aRGWPTlF6xzqWY16udFmpEmGo?=
 =?us-ascii?Q?q9nukNJopAT+1jQYHsZ+1TJ6dFwIw5p2o2aQeNgkEOpNcqjKBDXG/jXa52XY?=
 =?us-ascii?Q?DBzTUfI+PFpAYgSre1h5xKQY848bpgZY8GvRcc60rfhUPhaHsDTv9lEWNRfr?=
 =?us-ascii?Q?bygkwE7uir/M7EB/CEORoWA6DDJ+VHPVnIEz5m5qWK5LWbLBmZ/8cjN8M1z9?=
 =?us-ascii?Q?nZZNeyh/a80DjDO27etvBTI+zzbXFQqb6WqZG0r27hbBxoh6Nf10rfPXIyPt?=
 =?us-ascii?Q?Y7qsOtPxu8L6oYgES0hTwvUGz5ouKAjv+h8VSrjdLkd5sbBlgVtg6hWYfToH?=
 =?us-ascii?Q?FxK/fdpz9DpwOzv/tKgifemM2ApQ7axPdhUWdTZcp7MhbanJJag8u3XRF71p?=
 =?us-ascii?Q?cqTx5mcCMCBWvdlIxgmk5p2pTJoUX2kLQa9cX7donLSRR1VQCJ/0VVqnPYOM?=
 =?us-ascii?Q?fdp8op2xsY0TVlh2cfzu95823TFLIy42UFwat0iiPIBkPB3jQGbamNlayHUV?=
 =?us-ascii?Q?IdrKUPUEF30nWHuKjKa5iQ1fXKc0eoQanq0Q1LAvSGTiPBUArFo4mOZK6JmU?=
 =?us-ascii?Q?tV9duOxAcIwR9EIJlP4+UPb3ECHViq6A74tFqzofYi0KRN3npcW7LdvtTvGK?=
 =?us-ascii?Q?fxwAtObYLjlxQwA02rRSGb3QthmsXZH04z2R3lC8r5BY690R/50UZ3PRD3Zi?=
 =?us-ascii?Q?7/URLtMHB43gNODmQRyE/KaGbaJwPiFK0VHgCTVWj0FTWknz3gm9fW/N+P/r?=
 =?us-ascii?Q?RqZsopqXInoMt4qD+FJx6K/ipCcjMdDWJs7n9cZ3DPxsaEegXGfz403th7cc?=
 =?us-ascii?Q?RJI4TwNWfdPSP2vQDi89DVsK7+ad75yij9I250Awq+Z+69IrZrFaHF0a/A2y?=
 =?us-ascii?Q?JvReBipjBkui6lMlXBYpiDUDX1oyk1hPekuCJARDx2gMAXm6kM8VkVgvqo/s?=
 =?us-ascii?Q?T9OtWVKENsnaHlOGqSEAEeseLmszQja40pBq3yywUHA8mhNLoHSL5KzsS1CA?=
 =?us-ascii?Q?cgc7G6gjkQTvoQ8crcolgryTR+H3QeeznAXRJHv2nXFrMCInzaHcAbz0cH3x?=
 =?us-ascii?Q?nY4dfxdu7YqCsNRxrY/EJWDrkSiLig9p4BhEKvJ2XGe9wLDLWmEikRwJTBWY?=
 =?us-ascii?Q?LLftLcC60ssnexftnAHBUf6ekGfVPCcMSpyWUazz9cXiZEgCv3Rb82r3bn0i?=
 =?us-ascii?Q?cdR2GxIGsHTbmgV4apiIROVD74TSXaIJoaXQ2dsnY6jT6tgHMdu0QYhy5KD/?=
 =?us-ascii?Q?NCdWJf5o4CS+POX1wwRtlx/um0sjVqaIHlWHz+w2BB5IsYzXZeEW9aELmdIg?=
 =?us-ascii?Q?0paFzpMMD+qsKGCTMra54XOxpktRdM/AHNE6vH3qPQIqSfsjcOF146ZZXQ+t?=
 =?us-ascii?Q?+lyRFCjp0z6hV9ZC+L0nOQihMgZRFILK+iiciEzVO2TSl7a1O2SwxD5sMvBb?=
 =?us-ascii?Q?karc5T7wPWTqVPkoAWYq/RTfAIaW77qacRgHZzeSx0SO7j8LVwQzU2v9dLl7?=
 =?us-ascii?Q?vgei6oEjlNHbzMns3Snj3Qo2hRClN+zaE0E3SF1oWEDHGAxdogbLM2btvznv?=
 =?us-ascii?Q?t968QRI3JDY7GtKQkc60K4GK1WpHCBYzeXpIRiZU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6403dff-ce2f-4dc6-6792-08db5a8f0a47
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 06:37:40.4550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BRFJx+OxWTd7rckWLK7hqIRc2sJH0v5ThSfByxmf3UomhdaYNlsLwbRqSnZydy5/SvPiq24wOOczt3e8r9opKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7644
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some architectures, specifically ARM and perhaps Sparc and IA64,
require TLB invalidates when upgrading pte permission from read-only
to read-write.

The current mmu_notifier implementation assumes that upgrades do not
need notifications. Typically though mmu_notifiers are used to
implement TLB invalidations for secondary MMUs that comply with the
main CPU architecture.

Therefore if the main CPU architecture requires an invalidation for
permission upgrade the secondary MMU will as well and an mmu_notifier
should be sent for the upgrade.

Currently CPU invalidations for permission upgrade occur in
ptep_set_access_flags(). Unfortunately MMU notifiers cannot be called
directly from this architecture specific code as the notifier
callbacks can sleep, and ptep_set_access_flags() is usually called
whilst holding the PTL spinlock. Therefore add the notifier calls
after the PTL is dropped and only if the PTE actually changed. This
will allow secondary MMUs to obtain an updated PTE with appropriate
permissions.

This problem was discovered during testing of an ARM SMMU
implementation that does not support broadcast TLB maintenance
(BTM). In this case the SMMU driver uses notifiers to issue TLB
invalidates. For read-only to read-write pte upgrades the SMMU
continually returned a read-only PTE to the device, even though the
CPU had a read-write PTE installed.

Sending a mmu notifier event to the SMMU driver fixes the problem by
flushing secondary TLB entries. A new notifier event type is added so
drivers may filter out these invalidations if not required. Note a
driver should never upgrade or install a PTE in response to this mmu
notifier event as it is not synchronised against other PTE operations.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 include/linux/mmu_notifier.h |  6 +++++
 mm/hugetlb.c                 | 24 ++++++++++++++++++-
 mm/memory.c                  | 45 ++++++++++++++++++++++++++++++++++--
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d6c06e140277..f14d68f119d8 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -31,6 +31,11 @@ struct mmu_interval_notifier;
  * pages in the range so to mirror those changes the user must inspect the CPU
  * page table (from the end callback).
  *
+ * @MMU_NOTIFY_PROTECTION_UPGRAGE: update is due to a change from read-only to
+ * read-write for pages in the range. This must not be used to upgrade
+ * permissions on secondary PTEs, rather it should only be used to invalidate
+ * caches such as secondary TLBs that may cache old read-only entries.
+ *
  * @MMU_NOTIFY_SOFT_DIRTY: soft dirty accounting (still same page and same
  * access flags). User should soft dirty the page in the end callback to make
  * sure that anyone relying on soft dirtiness catch pages that might be written
@@ -53,6 +58,7 @@ enum mmu_notifier_event {
 	MMU_NOTIFY_CLEAR,
 	MMU_NOTIFY_PROTECTION_VMA,
 	MMU_NOTIFY_PROTECTION_PAGE,
+	MMU_NOTIFY_PROTECTION_UPGRADE,
 	MMU_NOTIFY_SOFT_DIRTY,
 	MMU_NOTIFY_RELEASE,
 	MMU_NOTIFY_MIGRATE,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bdbfeb6fb393..e5d467c7bff7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5987,6 +5987,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	vm_fault_t ret;
 	u32 hash;
 	pgoff_t idx;
+	bool changed = false;
 	struct page *page = NULL;
 	struct page *pagecache_page = NULL;
 	struct hstate *h = hstate_vma(vma);
@@ -6122,6 +6123,9 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (!huge_pte_write(entry)) {
 			ret = hugetlb_wp(mm, vma, address, ptep, flags,
 					 pagecache_page, ptl);
+			if (!ret)
+				changed = true;
+
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
 			entry = huge_pte_mkdirty(entry);
@@ -6129,8 +6133,11 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 	entry = pte_mkyoung(entry);
 	if (huge_ptep_set_access_flags(vma, haddr, ptep, entry,
-						flags & FAULT_FLAG_WRITE))
+						flags & FAULT_FLAG_WRITE)) {
 		update_mmu_cache(vma, haddr, ptep);
+		changed = true;
+	}
+
 out_put_page:
 	if (page != pagecache_page)
 		unlock_page(page);
@@ -6138,6 +6145,21 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 out_ptl:
 	spin_unlock(ptl);
 
+	if (changed) {
+		struct mmu_notifier_range range;
+		unsigned long hpage_mask = huge_page_mask(h);
+		unsigned long hpage_size = huge_page_size(h);
+
+		update_mmu_cache(vma, haddr, ptep);
+
+		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
+					0, vma, mm, haddr & hpage_mask,
+					(haddr & hpage_mask) + hpage_size);
+		mmu_notifier_invalidate_range_start(&range);
+		mmu_notifier_invalidate_range_end(&range);
+	}
+
+
 	if (pagecache_page) {
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
diff --git a/mm/memory.c b/mm/memory.c
index f526b9152bef..0ac78c6a232c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2098,6 +2098,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, entry;
 	spinlock_t *ptl;
+	bool changed = false;
 
 	pte = get_locked_pte(mm, addr, &ptl);
 	if (!pte)
@@ -2120,8 +2121,10 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			}
 			entry = pte_mkyoung(*pte);
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
+			if (ptep_set_access_flags(vma, addr, pte, entry, 1)) {
 				update_mmu_cache(vma, addr, pte);
+				changed = true;
+			}
 		}
 		goto out_unlock;
 	}
@@ -2142,6 +2145,17 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 
 out_unlock:
 	pte_unmap_unlock(pte, ptl);
+
+	if (changed) {
+		struct mmu_notifier_range range;
+
+		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
+					0, vma, mm, addr & PAGE_MASK,
+					(addr & PAGE_MASK) + PAGE_SIZE);
+		mmu_notifier_invalidate_range_start(&range);
+		mmu_notifier_invalidate_range_end(&range);
+	}
+
 	return VM_FAULT_NOPAGE;
 }
 
@@ -2820,6 +2834,7 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = vmf->address;
+	bool changed = false;
 
 	if (likely(src)) {
 		if (copy_mc_user_highpage(dst, src, addr, vma)) {
@@ -2858,8 +2873,10 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
 		}
 
 		entry = pte_mkyoung(vmf->orig_pte);
-		if (ptep_set_access_flags(vma, addr, vmf->pte, entry, 0))
+		if (ptep_set_access_flags(vma, addr, vmf->pte, entry, 0)) {
 			update_mmu_cache(vma, addr, vmf->pte);
+			changed = true;
+		}
 	}
 
 	/*
@@ -2897,6 +2914,16 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
 		}
 	}
 
+	if (changed) {
+		struct mmu_notifier_range range;
+
+		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
+					0, vma, vma->vm_mm, addr & PAGE_MASK,
+					(addr & PAGE_MASK) + PAGE_SIZE);
+		mmu_notifier_invalidate_range_start(&range);
+		mmu_notifier_invalidate_range_end(&range);
+	}
+
 	ret = 0;
 
 pte_unlock:
@@ -4877,6 +4904,7 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
 static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 {
 	pte_t entry;
+	bool changed = false;
 
 	if (unlikely(pmd_none(*vmf->pmd))) {
 		/*
@@ -4957,6 +4985,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
 				vmf->flags & FAULT_FLAG_WRITE)) {
 		update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
+		changed = true;
 	} else {
 		/* Skip spurious TLB flush for retried page fault */
 		if (vmf->flags & FAULT_FLAG_TRIED)
@@ -4972,6 +5001,18 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	}
 unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
+
+	if (changed) {
+		struct mmu_notifier_range range;
+
+		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
+					0, vmf->vma, vmf->vma->vm_mm,
+					vmf->address & PAGE_MASK,
+					(vmf->address & PAGE_MASK) + PAGE_SIZE);
+		mmu_notifier_invalidate_range_start(&range);
+		mmu_notifier_invalidate_range_end(&range);
+	}
+
 	return 0;
 }
 
-- 
2.39.2

