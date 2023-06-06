Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D0D723533
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjFFCVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbjFFCVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:21:04 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E680131;
        Mon,  5 Jun 2023 19:20:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WC9vIg2K4d6lRA7xTKcYOZD+uskxaDZUyCPpT1Ry4Ug+IVF1qQYjbB23EXTBGokVbAh9rRuSVU9afD9BPtIBlmpR2FJBahj1ZsEuaLX9VYgV6NrUcpTbfWo1UAx93ZOyvLa3ldCar4FLMdzF7qhJ7CdltXzp1cAI6RzEBeG2MLqHbZ8oLsIUoePMMn/d0Ue7OzW9OyjzDfpOXWzXTqQS5DKlGf+BpVKyieajo5v7d6qsmCEGI7ypO/JGL5hOG7YkKQwMxcQ0ErKzZ2Z8Kh5xG+xpRgEuYrEdiwnIx6GFZfCqSOzxmImnfM9SCUU35kzrxGb/4y4WfTXeCepPVi6EyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79yIJlZnYLDT9kS2nI0gvbZWMXfDRudqX0qMmxKLfqs=;
 b=IsnEu6n/Wr7yq3+VBNVp13fDgU0PXzvPBYf9Lc5CqI/0xgnh6xOKu63KBM9rklJy0OTz+bWNQ1INlsS8LwPlBs2ZNll2ymF3xzmN0A/vjwvtq7lnbYs7DTARi2srvRevpUbVGm7+voq58qx+9BnMnmpMCEFWFzHd7JyKx5V7z2AwLpIyneRT+UBSoIP0NTLvnIYh5cEvKjjTOlraATSUWRzMRnY4dlN50wRK0ged46EIBb3PfvfZ2xoOrC8g+lNea2LpMHd8Z+rFAHVpyXoKvwMbsbKhv9dXTxP2nfLcu7Ek8IOx3s8Wv4FzK8NFq6s62KM11+LeHfelTO4z7tjRoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79yIJlZnYLDT9kS2nI0gvbZWMXfDRudqX0qMmxKLfqs=;
 b=pTMb/48N9CqDqGGTDQIG3JT+j8HiAp2Wh7IiE/Mzlkhva1Y/2Cz/+Bowb2hzub5ShxRvZMPi1pz/Xwxuc1QJtJV91AARdHpw83f239vYHtFkjZvBrMreQcNs2E1+j+0pPoXAElGIQ8u8PXiaXsCWeZmhqWIsxFi69vrTFgrweF6VcpJxYA5zwKxxqtjc59QoGv+7DMPvbZRcbWO2kJgOGUkKDT9OfiBxoYfHA/g6DWeQ9RHfPSYRsrWv/0pYSao3vQGrwENJ/VNSxQIl/eN0sdhw3jd3P8x7TigDLnwF8X7cqALLo6A+qGLhTCLn8Ay4mcUwDjm6fZ5zAHRsrNiwlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3179.namprd12.prod.outlook.com (2603:10b6:5:183::18)
 by BL0PR12MB4914.namprd12.prod.outlook.com (2603:10b6:208:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 02:20:57 +0000
Received: from DM6PR12MB3179.namprd12.prod.outlook.com
 ([fe80::dc79:d410:23d3:f718]) by DM6PR12MB3179.namprd12.prod.outlook.com
 ([fe80::dc79:d410:23d3:f718%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 02:20:57 +0000
References: <20230602011518.787006-1-seanjc@google.com>
 <20230602011518.787006-3-seanjc@google.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 2/3] KVM: x86: Use standard mmu_notifier invalidate
 hooks for APIC access page
Date:   Tue, 06 Jun 2023 12:20:04 +1000
In-reply-to: <20230602011518.787006-3-seanjc@google.com>
Message-ID: <87sfb5nxfe.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::23) To DM6PR12MB3179.namprd12.prod.outlook.com
 (2603:10b6:5:183::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:EE_|BL0PR12MB4914:EE_
X-MS-Office365-Filtering-Correlation-Id: 48e1a2ea-a108-4d98-d305-08db6634a96d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yymqPwGmPiQ9m+D5ES8SwnTUGJSztJfOb4YMzIdwLrBp7nkhpr3G12cH8q1huLNmHYXyT/bEGM9g1Qr0Fs0iSFW/pvYoqLArHiwbOwXGvQR4Xzl945GFDBaLnU3aC2JElROIjhTCFoAVtnEvzpJh0Wr7WjPBwF53JQtm8psvAhnsXWQGy6Mwb4IJbGF+kioN5jvyqBj7J5rt9fQzV4b4Wetj5iGpkqeUcZC0p7l+2IUG2EyeBBjoR4JN0YDm8NAtnAjq6eT/AzzKDGfxEzwkbfHNXJ2Jw7MMs1DDWrUqCCNmb4IL6Q4nn9NRHQEG8HxIOPLyc7puMhDcRm9XFVgZH2ymXZdK0N6BwhtzVl3nox0SQiB5uSNEwptKknWNeGjHAkeZg2TfbJcR6csvfVUcwKHn8qp8+LHIznl+rNP3RsozuPhms/Xp0KrfuTJt+ErZJ5BANeQa0fzJ1rEH2HOvPU19f0vKvfY1RmV9VbPvTWuDpRu33h5MgiVheekavBa8TNjDKuqDjjn/HVERrZ/gXkgVNySgla03R+H4vBHmkc0KcvZaJnjS5b2lpkFGjMC3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199021)(478600001)(2906002)(6486002)(36756003)(6666004)(2616005)(83380400001)(6506007)(26005)(86362001)(186003)(6512007)(38100700002)(5660300002)(316002)(8676002)(8936002)(66946007)(6916009)(4326008)(66556008)(66476007)(54906003)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mz6Zid6qjU7/elsZiSbiy7LzTEJaMo5mnFqxl365ttKw4illGpfuByaqc353?=
 =?us-ascii?Q?paL9eZ5r7YNYTiqAWkTxhPGiLhfC2Si5CWDPIzS3rj0ObfHBXmtWFEbpwMO8?=
 =?us-ascii?Q?JqoLza7ME9LbncYCZl3KbuPLusGx3xlYaidnc1cRJcWBO0C1bYfCI8KjT+M0?=
 =?us-ascii?Q?ppErR3d/XGYzp1FFoq3FV/nxmjy6WkVZktpWwtNmknD/rf1N+hWHuYLKQ9wW?=
 =?us-ascii?Q?+d2wt1CXNCNhhFtxHemqDv+F+Np/XFAf1WMaxEgZk/KZHn9fupWofb3EjRbM?=
 =?us-ascii?Q?LpDM0ojDfB4Jix6D/jbm7xM6qEHBV1tfcfG/jz8U7Abh1XMnqm+mK1DP15Fu?=
 =?us-ascii?Q?gNtCRt+fNdKMopivgB7vfvoxmf3E6XyJBcgUvPJGLfuRZibi1yWPf/wqy7l0?=
 =?us-ascii?Q?1k7usotqsAQ3W9c+WWZalMKiRS/lNwfMtxJeyCQt+1UQ6s4qHTgeOonmDxP9?=
 =?us-ascii?Q?cMkYnSXyEku2q9wrOHIitw2UOZmMo3av9riHUh++l0svBkGZQObA6VwfGslA?=
 =?us-ascii?Q?6xqx6CYijJTj09uIXckBhVWgTC/6qHWewq5YcL7/8epd7R/nDyGWc4W2KHZ9?=
 =?us-ascii?Q?4G2rus1tieCGyL3VciQlJZIqUAbAxM5lpP0HS8FSSdk7zVWEOZzWoU1buDE/?=
 =?us-ascii?Q?ZnyF9Wb42gChfzE9y6CxzP5jCCmUQl1xhodKLaaNBJjW1ZphOB+kdMN00FYh?=
 =?us-ascii?Q?mRE5vy0aomE0mE0smJWJRsgUMgZwaLbG4ONpYGMo1mF4mFb7wTglbhOtB6b7?=
 =?us-ascii?Q?Q9pKqv4a4l4msHL5S0oX6Orpu1vgzY5DLyevbzsiS79uXgNAXQnk0kaWho0W?=
 =?us-ascii?Q?67G/Z0LtoB389uvDKYucXVP1w4dQGPokAjDPZ2HARB8fudQeRSTMWa1B2gn4?=
 =?us-ascii?Q?aK3aTrDl4DDJ/z7k5Oemnwnh9hOeOVgYQr/gdp1kzMaWmqTQogNIkfqP2pv+?=
 =?us-ascii?Q?fr7TqhZvVP7Ika0AjvgfFM+w1reBHPsiC+uj1bs4Ry+Kss9bTLqpQ4to95Sh?=
 =?us-ascii?Q?1KrKlltNnID3KHiktF399o5I+/rqWsHu9dM2uRD9Y+YG6mxV/ToM77h9VlbK?=
 =?us-ascii?Q?AI9mUguPoqKw3afAZqm48LElJibkUhCoIW9il2g0NLR/GAAv/71eStQ3XQaW?=
 =?us-ascii?Q?whXs4phMg+XB6bbU7Nxfppy4H8jeAOCaQxMnLlr9w3cxvz0vZeH3hySGKp4k?=
 =?us-ascii?Q?5N9sGM06lFYxO44kNCGMiOGSdW0Jk1T4Dg7Tit/QkpetsT9bPVsH/4VIB8+7?=
 =?us-ascii?Q?2bMUFTQzXClO6P8gZcRNaqdwOiA1lThsKoqcWjepnQQ4KuCQtt+qri/Z9oOw?=
 =?us-ascii?Q?zXh+yExwnIid2Dcdf6/Eoz9pksj3rtAYWkfEGH+n32YHtJrougPj6ojUJXrg?=
 =?us-ascii?Q?y614BWvcVGQ5oFrVi9kNifuA4Qonbu8NHIanPIsHmVdFFLDsgXp04ZwWu0Nj?=
 =?us-ascii?Q?Hc/h7uI3a4BUWXAqcJ22UcSWxdrTJ7hNgfR61YlJgKk0kcwoozLD05vUU2/G?=
 =?us-ascii?Q?+YiPY3w2AYYuU7rxHHBPx5pk3AXPU3aZVungvSKgSS34KxPo7+amqdgsctsV?=
 =?us-ascii?Q?uD+0ExcnHXuNtJM8U+9D11IuYHqou7N1W4ClKDBr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e1a2ea-a108-4d98-d305-08db6634a96d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 02:20:57.2452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgnJrIhOiWHzmcSN+rONPgcjf9s40n4NDf2UaXD2DbteM6gPhF/gXJdCIoOk5gmXb54YusNtjZ/JVcDLxSpy/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4914
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Again I'm no KVM expert but read through this and it all looked correct
and made sense so feel free to add:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

Sean Christopherson <seanjc@google.com> writes:

> Now that KVM honors past and in-progress mmu_notifier invalidations when
> reloading the APIC-access page, use KVM's "standard" invalidation hooks
> to trigger a reload and delete the one-off usage of invalidate_range().
>
> Aside from eliminating one-off code in KVM, dropping KVM's use of
> invalidate_range() will allow common mmu_notifier to redefine the API to
> be more strictly focused on invalidating secondary TLBs that share the
> primary MMU's page tables.
>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   |  3 +++
>  arch/x86/kvm/x86.c       | 14 --------------
>  include/linux/kvm_host.h |  3 ---
>  virt/kvm/kvm_main.c      | 18 ------------------
>  4 files changed, 3 insertions(+), 35 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8961f45e3b1..01a11ce68e57 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1600,6 +1600,9 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (tdp_mmu_enabled)
>  		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
>  
> +	if (range->slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT)
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
> +
>  	return flush;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ceb7c5e9cf9e..141a62e59d2b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10431,20 +10431,6 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
>  		vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
>  }
>  
> -void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> -					    unsigned long start, unsigned long end)
> -{
> -	unsigned long apic_address;
> -
> -	/*
> -	 * The physical address of apic access page is stored in the VMCS.
> -	 * Update it when it becomes invalid.
> -	 */
> -	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> -	if (start <= apic_address && apic_address < end)
> -		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
> -}
> -
>  void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
>  {
>  	static_call_cond(kvm_x86_guest_memory_reclaimed)(kvm);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0e571e973bc2..cb66f4100be7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2237,9 +2237,6 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  }
>  #endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
>  
> -void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> -					    unsigned long start, unsigned long end);
> -
>  void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
>  
>  #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cb5c13eee193..844ff6b0b21d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -154,11 +154,6 @@ static unsigned long long kvm_active_vms;
>  
>  static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
>  
> -__weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> -						   unsigned long start, unsigned long end)
> -{
> -}
> -
>  __weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
>  {
>  }
> @@ -521,18 +516,6 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
>  	return container_of(mn, struct kvm, mmu_notifier);
>  }
>  
> -static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
> -					      struct mm_struct *mm,
> -					      unsigned long start, unsigned long end)
> -{
> -	struct kvm *kvm = mmu_notifier_to_kvm(mn);
> -	int idx;
> -
> -	idx = srcu_read_lock(&kvm->srcu);
> -	kvm_arch_mmu_notifier_invalidate_range(kvm, start, end);
> -	srcu_read_unlock(&kvm->srcu, idx);
> -}
> -
>  typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
>  
>  typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
> @@ -892,7 +875,6 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
>  }
>  
>  static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
> -	.invalidate_range	= kvm_mmu_notifier_invalidate_range,
>  	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
>  	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
>  	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,

