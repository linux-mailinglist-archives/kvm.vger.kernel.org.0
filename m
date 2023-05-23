Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C3370CFE7
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 03:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjEWBAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 21:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbjEWA7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:59:50 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84292170F;
        Mon, 22 May 2023 17:57:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXPN6ckhDq1n08tuQ+/WB8uTYQ7FkHTbjAbuEkoLKivBJbviYQBlmjlIqSmuhOqLsDk78b5o9propMhwHy7EMVBZINDYOlKVnpE+/2i649mrMQEIOQHqu0TAf8GgC6EWcRBzcQeX8AOa9A9otCXtzB1KWUfEQNfnTQORCVl1pgK/R1ZZY9yKSsitkaLb07Uara4D+hC628Q0zm3qg+QPzJoXo2HdQry4FPzWBUS5wcGRscwnFYBdIGi4KvdoIwmESWwrjS4Vz4Meta0srD9GG1ZddRMY3oN90urxBtvBsxEUddTw6xcedJcZRgWBu38h75RwOZxDWfA9BRwt2v/cVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8j+EGeKZ1V1VlPfnDrcSeysYDfdm28yYDR5BZNZnEx0=;
 b=KoAWaTvQE57ZhxhYcsb62UCguM6jlwZRFbXj5ODoFOv9Xuo9b5Mnc4kY79QJRdGNbXLvd1pTVWIVV5nF2qq0e1q3aB0mK1Cfci/FSuX/c5+mN5T12eKkwjDXw6iEA6uwp1DwpIWKgV3xPM7BUdGIjgOksHAkCPKdNwZrO+qKCJnA824mriS7eTe4aJDoGoxMiLHcSJdRCEC4kMxR8nLpKbKWHg5cByN3CnV0Jd+hgTUS2md4m4WtwyNEx/XTrzfyVooNeUMmkd6pN2WE00pjHQUvsT3B7rW+Nt2+aSEEllUCrM+g3HttZ3Kmajq3pFWhyRmYY7AicFJWuuWL/ANXDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8j+EGeKZ1V1VlPfnDrcSeysYDfdm28yYDR5BZNZnEx0=;
 b=ZmWSyj54Ipl7AYnpJaGW2KCS98HT/R+Cx5r6iYYayTvA4c9pjU7NdsebeBXAKhGi/JRKBtDKhSgiqNOFXAFHw7JyDov+36MG5kDRV6T1jW4LZIPh+9K4SW0EFisuUWsudsSYxVrTZLhwuM3HS+cDo+zrGCfZrua4GfGssZoO+D2GXip55NTUZf7XIr+RICFKM+PCl6TE7BToWXqTPJmKinW63HlLilR7ydn+skYFqjaEKQWdmJDGesuvK1/IK8sUyBp37tWPsZjaThE4bdnXIOVr2RYqcI6vgNdcVsVUSfnP7iq3BtQAVbK4GfjDkmtbFCRezbofwqu/4i+Nmczj8A==
Received: from DS0PR17CA0007.namprd17.prod.outlook.com (2603:10b6:8:191::14)
 by SA1PR12MB8947.namprd12.prod.outlook.com (2603:10b6:806:386::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 00:56:04 +0000
Received: from DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:191:cafe::16) by DS0PR17CA0007.outlook.office365.com
 (2603:10b6:8:191::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Tue, 23 May 2023 00:56:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT076.mail.protection.outlook.com (10.13.173.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29 via Frontend Transport; Tue, 23 May 2023 00:56:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 22 May 2023
 17:55:53 -0700
Received: from [10.110.48.28] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 22 May
 2023 17:55:52 -0700
Message-ID: <cf2d7d64-8872-2b22-0b2e-8db96135d3ef@nvidia.com>
Date:   Mon, 22 May 2023 17:55:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <robin.murphy@arm.com>, <will@kernel.org>, <nicolinc@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <jgg@nvidia.com>
References: <20230522063725.284686-1-apopple@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20230522063725.284686-1-apopple@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT076:EE_|SA1PR12MB8947:EE_
X-MS-Office365-Filtering-Correlation-Id: 38b32752-0fba-463f-d22b-08db5b287bdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uDazVzaRxG4xP6E28zZKketTehKskfELxIoQBHGo3sdu3ig25vysjtjLl+79X7rfYVJv23Hn/JOuR+fwUTwksoo/1w/XzBmmPlpTk2NPNRYOn0PFapssOOp924x82ze7dmMoSlrAQlCx/KiweVwJjCq1o+LOsSqO4LrB+qZaGWDJZxCF38XPy1DBZLZDfzNqys8AF8yNMUYEKtbKaAz9TnnU02E0lwfOUrAbtsntiCcQLmEhPRbqVzuzZuMALwqWCS93HQI6gj0HWyFfQWCzxZXi5oYN0EM2lqBgp8xBBvb4K3wl2lwLfvD3EgVbnBAA6Xn26jJWajOyYVTE/e2g8ybKr5NARhMtlXiKnjv4MqKTg1Ajfd3mTrC9CLqNcpXtkxvskQcImj7/GDJYBGQdX1FSksvK/JEpgOOzqDLzaOk504oX3Ybw1ICXt7JW8U/wxSfze7T7DioBi1gJd9TqEr3B/gHx9rcxXQ0ii2+uLwB3/ezHAMmTEtgrjEHjzOl0TvBhMNvwMOaaea2vn8NgZFLeFy9Y0iH6AD9d6D+F+tFOr1iMDNB9Z5fxXkColpIkU3KHYYGO81XKFoVuzCnjOsB+Y5nR+AtTncieNbSM0YpJ/F6TnD10KbvwyBQAO1f9cgvVkPQbnzBxwfV7JmxtfqFkIHIx0Mx138qu9ZIN0uKugGGAJ6n/X8RKnvmJ4L8vja8Y1S3CpkSLe9kX7jUkUF/cAa+ciquhiQ4C8O/us/Wm7Eh4CR0Uolxv+rVNLFRHh4s6d2LfKP0/y3gEuPfjgg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199021)(46966006)(40470700004)(36840700001)(2906002)(82310400005)(7636003)(2616005)(426003)(336012)(53546011)(356005)(47076005)(40480700001)(186003)(107886003)(83380400001)(26005)(36860700001)(16526019)(8936002)(40460700003)(8676002)(86362001)(36756003)(4326008)(316002)(5660300002)(82740400003)(41300700001)(70586007)(110136005)(31696002)(70206006)(16576012)(54906003)(478600001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 00:56:03.6449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38b32752-0fba-463f-d22b-08db5b287bdd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8947
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/23 23:37, Alistair Popple wrote:
> Some architectures, specifically ARM and perhaps Sparc and IA64,
> require TLB invalidates when upgrading pte permission from read-only
> to read-write.
> 
> The current mmu_notifier implementation assumes that upgrades do not
> need notifications. Typically though mmu_notifiers are used to
> implement TLB invalidations for secondary MMUs that comply with the
> main CPU architecture.
> 
> Therefore if the main CPU architecture requires an invalidation for
> permission upgrade the secondary MMU will as well and an mmu_notifier
> should be sent for the upgrade.
> 
> Currently CPU invalidations for permission upgrade occur in
> ptep_set_access_flags(). Unfortunately MMU notifiers cannot be called
> directly from this architecture specific code as the notifier
> callbacks can sleep, and ptep_set_access_flags() is usually called
> whilst holding the PTL spinlock. Therefore add the notifier calls
> after the PTL is dropped and only if the PTE actually changed. This
> will allow secondary MMUs to obtain an updated PTE with appropriate
> permissions.
> 
> This problem was discovered during testing of an ARM SMMU
> implementation that does not support broadcast TLB maintenance
> (BTM). In this case the SMMU driver uses notifiers to issue TLB
> invalidates. For read-only to read-write pte upgrades the SMMU
> continually returned a read-only PTE to the device, even though the
> CPU had a read-write PTE installed.
> 
> Sending a mmu notifier event to the SMMU driver fixes the problem by
> flushing secondary TLB entries. A new notifier event type is added so
> drivers may filter out these invalidations if not required. Note a
> driver should never upgrade or install a PTE in response to this mmu
> notifier event as it is not synchronised against other PTE operations.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   include/linux/mmu_notifier.h |  6 +++++
>   mm/hugetlb.c                 | 24 ++++++++++++++++++-
>   mm/memory.c                  | 45 ++++++++++++++++++++++++++++++++++--
>   3 files changed, 72 insertions(+), 3 deletions(-)

Point of order:

What is this based on? It would really help if you would either use --base
with git-format-patch, or else just mention the base somewhere. Otherwise,
actually applying the patch takes some hunting around...in particular for
older stuff. This is from Feb, 2023, before hugetlb.c got converted to
folios, right?

thanks,
-- 
John Hubbard
NVIDIA

> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d6c06e140277..f14d68f119d8 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -31,6 +31,11 @@ struct mmu_interval_notifier;
>    * pages in the range so to mirror those changes the user must inspect the CPU
>    * page table (from the end callback).
>    *
> + * @MMU_NOTIFY_PROTECTION_UPGRAGE: update is due to a change from read-only to
> + * read-write for pages in the range. This must not be used to upgrade
> + * permissions on secondary PTEs, rather it should only be used to invalidate
> + * caches such as secondary TLBs that may cache old read-only entries.
> + *
>    * @MMU_NOTIFY_SOFT_DIRTY: soft dirty accounting (still same page and same
>    * access flags). User should soft dirty the page in the end callback to make
>    * sure that anyone relying on soft dirtiness catch pages that might be written
> @@ -53,6 +58,7 @@ enum mmu_notifier_event {
>   	MMU_NOTIFY_CLEAR,
>   	MMU_NOTIFY_PROTECTION_VMA,
>   	MMU_NOTIFY_PROTECTION_PAGE,
> +	MMU_NOTIFY_PROTECTION_UPGRADE,
>   	MMU_NOTIFY_SOFT_DIRTY,
>   	MMU_NOTIFY_RELEASE,
>   	MMU_NOTIFY_MIGRATE,
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bdbfeb6fb393..e5d467c7bff7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5987,6 +5987,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   	vm_fault_t ret;
>   	u32 hash;
>   	pgoff_t idx;
> +	bool changed = false;
>   	struct page *page = NULL;
>   	struct page *pagecache_page = NULL;
>   	struct hstate *h = hstate_vma(vma);
> @@ -6122,6 +6123,9 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   		if (!huge_pte_write(entry)) {
>   			ret = hugetlb_wp(mm, vma, address, ptep, flags,
>   					 pagecache_page, ptl);
> +			if (!ret)
> +				changed = true;
> +
>   			goto out_put_page;
>   		} else if (likely(flags & FAULT_FLAG_WRITE)) {
>   			entry = huge_pte_mkdirty(entry);
> @@ -6129,8 +6133,11 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   	}
>   	entry = pte_mkyoung(entry);
>   	if (huge_ptep_set_access_flags(vma, haddr, ptep, entry,
> -						flags & FAULT_FLAG_WRITE))
> +						flags & FAULT_FLAG_WRITE)) {
>   		update_mmu_cache(vma, haddr, ptep);
> +		changed = true;
> +	}
> +
>   out_put_page:
>   	if (page != pagecache_page)
>   		unlock_page(page);
> @@ -6138,6 +6145,21 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   out_ptl:
>   	spin_unlock(ptl);
>   
> +	if (changed) {
> +		struct mmu_notifier_range range;
> +		unsigned long hpage_mask = huge_page_mask(h);
> +		unsigned long hpage_size = huge_page_size(h);
> +
> +		update_mmu_cache(vma, haddr, ptep);
> +
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
> +					0, vma, mm, haddr & hpage_mask,
> +					(haddr & hpage_mask) + hpage_size);
> +		mmu_notifier_invalidate_range_start(&range);
> +		mmu_notifier_invalidate_range_end(&range);
> +	}
> +
> +
>   	if (pagecache_page) {
>   		unlock_page(pagecache_page);
>   		put_page(pagecache_page);
> diff --git a/mm/memory.c b/mm/memory.c
> index f526b9152bef..0ac78c6a232c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2098,6 +2098,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>   	struct mm_struct *mm = vma->vm_mm;
>   	pte_t *pte, entry;
>   	spinlock_t *ptl;
> +	bool changed = false;
>   
>   	pte = get_locked_pte(mm, addr, &ptl);
>   	if (!pte)
> @@ -2120,8 +2121,10 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>   			}
>   			entry = pte_mkyoung(*pte);
>   			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> -			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
> +			if (ptep_set_access_flags(vma, addr, pte, entry, 1)) {
>   				update_mmu_cache(vma, addr, pte);
> +				changed = true;
> +			}
>   		}
>   		goto out_unlock;
>   	}
> @@ -2142,6 +2145,17 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>   
>   out_unlock:
>   	pte_unmap_unlock(pte, ptl);
> +
> +	if (changed) {
> +		struct mmu_notifier_range range;
> +
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
> +					0, vma, mm, addr & PAGE_MASK,
> +					(addr & PAGE_MASK) + PAGE_SIZE);
> +		mmu_notifier_invalidate_range_start(&range);
> +		mmu_notifier_invalidate_range_end(&range);
> +	}
> +
>   	return VM_FAULT_NOPAGE;
>   }
>   
> @@ -2820,6 +2834,7 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
>   	struct vm_area_struct *vma = vmf->vma;
>   	struct mm_struct *mm = vma->vm_mm;
>   	unsigned long addr = vmf->address;
> +	bool changed = false;
>   
>   	if (likely(src)) {
>   		if (copy_mc_user_highpage(dst, src, addr, vma)) {
> @@ -2858,8 +2873,10 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
>   		}
>   
>   		entry = pte_mkyoung(vmf->orig_pte);
> -		if (ptep_set_access_flags(vma, addr, vmf->pte, entry, 0))
> +		if (ptep_set_access_flags(vma, addr, vmf->pte, entry, 0)) {
>   			update_mmu_cache(vma, addr, vmf->pte);
> +			changed = true;
> +		}
>   	}
>   
>   	/*
> @@ -2897,6 +2914,16 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
>   		}
>   	}
>   
> +	if (changed) {
> +		struct mmu_notifier_range range;
> +
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
> +					0, vma, vma->vm_mm, addr & PAGE_MASK,
> +					(addr & PAGE_MASK) + PAGE_SIZE);
> +		mmu_notifier_invalidate_range_start(&range);
> +		mmu_notifier_invalidate_range_end(&range);
> +	}
> +
>   	ret = 0;
>   
>   pte_unlock:
> @@ -4877,6 +4904,7 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
>   static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>   {
>   	pte_t entry;
> +	bool changed = false;
>   
>   	if (unlikely(pmd_none(*vmf->pmd))) {
>   		/*
> @@ -4957,6 +4985,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>   	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
>   				vmf->flags & FAULT_FLAG_WRITE)) {
>   		update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
> +		changed = true;
>   	} else {
>   		/* Skip spurious TLB flush for retried page fault */
>   		if (vmf->flags & FAULT_FLAG_TRIED)
> @@ -4972,6 +5001,18 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>   	}
>   unlock:
>   	pte_unmap_unlock(vmf->pte, vmf->ptl);
> +
> +	if (changed) {
> +		struct mmu_notifier_range range;
> +
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
> +					0, vmf->vma, vmf->vma->vm_mm,
> +					vmf->address & PAGE_MASK,
> +					(vmf->address & PAGE_MASK) + PAGE_SIZE);
> +		mmu_notifier_invalidate_range_start(&range);
> +		mmu_notifier_invalidate_range_end(&range);
> +	}
> +
>   	return 0;
>   }
>   


