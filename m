Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3BE27F5E2
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 01:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbgI3XVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 19:21:00 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:3553
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbgI3XU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 19:20:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djiZzmqGKHpur0JBVGpRVrH/YR+Y3iR4CBjvW02vA/tZpUwsdVAolBQtUFT27Yr6yEYSquzPsI9h3zOJtE0eZbcCNX5mAf0fWrybaCei3eBGCR7w9Q9Ok8w/Ic7o6SzIPn+9ZpX/7a9Eagey1AUPkVkqv8ij0kwkVT/SXCj/AWbMub21VU2vsAdRmNOhmhaeINm+8GA4oOf8E0JIpA1/TiiWXG9/XOapk+VlQROW66LN9+nhzMxyIrKbGztv0CM/dVx82E6+/IA5syAg94Ri7pi4OrbLiBBJYLGUZogMxIIH84rli1H+t4DptBHneukafNc/nzxr1UOTmvipHuKM4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MN7izmxcj1EKm5bZqTLBcGj/pO2xAPOA6Rt+OeawAxA=;
 b=YdFOXyPPoDtC3hNNP7DOYXwAobxLlcvGu9AdUNV0eXn/Jd3UoJQP7dHLPDpyilmIU3/zLWZwOT4+oggAO8xcNKW2FbZwSXC9fPM/T3lgwFrJQQ2nu4LUoNqyprozFoH1O8WKR/WfRXItJEnDY3A/EjtDQKAk1Qr08gvxhwxIZ2pA62nfBtZ9fkqIbj799Ti8Ons92d1lXj7WFAruNfIzKIRh31KTfmkP7uBZvPKnUkd8/RNIHPtdPPPGUYyg8evhl5sS66aI2gOv2CzbShJaSuzT5c7Ueqb+cVeVk+CaFD2wmKom5maax7R++dg+nvk6YyS352DaonQ6mkrnbYCLzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MN7izmxcj1EKm5bZqTLBcGj/pO2xAPOA6Rt+OeawAxA=;
 b=PZyS+XVarQNuJgZdO0nk6fO/fZDW22e7mutbVsXTfR+IqCibgGyU94A33eDYAogcE9sYUjEZzM0ju3tc160+VRL42PD1KzwCHnX0WE3BWkzORTSpQpGZCCu/e6FqBJKOJ5DNzW0+weVkiUMPo+urZtRkSb9l59Y816Wgb6dV4NI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM5PR12MB1561.namprd12.prod.outlook.com (2603:10b6:4:b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.26; Wed, 30 Sep 2020 23:20:55 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3412.029; Wed, 30 Sep
 2020 23:20:54 +0000
Subject: Re: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-3-bgardon@google.com>
From:   Eric van Tassell <evantass@amd.com>
Message-ID: <4a74aafe-9613-4bf2-47a1-cad0aad34323@amd.com>
Date:   Wed, 30 Sep 2020 18:20:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200925212302.3979661-3-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.78.25]
X-ClientProxiedBy: SN4PR0601CA0022.namprd06.prod.outlook.com
 (2603:10b6:803:2f::32) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.128.53] (165.204.78.25) by SN4PR0601CA0022.namprd06.prod.outlook.com (2603:10b6:803:2f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Wed, 30 Sep 2020 23:20:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a1aab85f-53e8-4d1e-467b-08d865977a84
X-MS-TrafficTypeDiagnostic: DM5PR12MB1561:
X-Microsoft-Antispam-PRVS: <DM5PR12MB15616D8DDF8A1DE7D043B1DCE7330@DM5PR12MB1561.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4JL18DjvWwtbPxxLnV3STK2C7McoY+poG/vZKiNMoz1iH2f3SRbLRIgGFH+yrU8EZmjZi+yJ7d2t8GVyqH6uZ/NLwljw0VfjGhQOcv4fhSx+9D5XmJ4s6Xk0L795ZJ7+tYyT6J0QHaVIhQReIRdsZ3bMwnrzFPTJMYMjjG7euli5WI4Fiog9NW6d1HDCncyCwZc3rI+FcbvfUyNybev5Ltj5cgNodKy9gC+Iikhiqq72uvfzEUi6ib4wiaEXF8z73JzAXagjV7iiFDPTCUg4SWIJfUFmRIvsFknQrko+2f+j5CoN6MC9mRMg7K6oMhgTAKFLEo0eN2QuSc/ItRwa3hWmIczs0Ns7w+aL6KAvEzeRk3QCDlDTGi6FJ18gQ0cqowuDPpwO3oE1/FRWrknCgM2l8ieyMo6BMI0U6BVWjjT13llkOIAH/8WXb61onPZXJqiCZkauaYnsnkAfa5xS6U/ZHGkg8YtLv4iZqFx7c1eVjgMhsm7eUB4u0bm01pF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(186003)(16526019)(8936002)(478600001)(66946007)(966005)(54906003)(26005)(8676002)(83380400001)(45080400002)(316002)(4326008)(31696002)(6486002)(16576012)(956004)(31686004)(2616005)(7416002)(66556008)(2906002)(66476007)(53546011)(30864003)(36756003)(5660300002)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aPTosssypG1a6KVGr4nPuUcESY65znoj2x6dJjDw+TDoPzW4rJwPISEARuixmhSNTXUFggTp6uxozMMdWgknrzSA8yzqrT9PyehZKrTUzI9YuuPjQWyBioIP4kNuo4UG8inNVs/QodyVCY4YmVoLyY/PGNtlI9yjYt03AvzcN5jqQ4mVNoM2EObqDrDXXJX5yOHQUVPR6r/zIeczuJp/9o8yIL7SZeDtKuSy4bemP/DgRBhYZPP2WZKBOk8Fs+LHpVbtlpLhd4Ka99si7SZKLFvZtjNykjdWq/Uaf6IcdiQHLfmXaYeIBUk93Z0PryU0qTTm6CwfTsWUVG7MM8aSbgeaEIBCTEdY57W3Nv7Xa5tkMqnIa08SaItTfVpqQzMr/+Nr8j4ZO9/qZLWT8AHXNs8V0xo1pWhxOEFSWQxQ05hJ9Wgzm8mS+erp+EYXr7y+nvRz4diXs+ZkeO2wHkTDz0JgzxESLxx0dvi/S3eAjE3p8wJIMUeNPezs0e5yii2IqToBXyF7yHYAvH5cuFwCJbhhrrFTpl0yG5Map74e9tZA1dyAEsc2eY0cu3aGZlY3e2ebWeTuheChPm7QH1W6Tr0CFigeBJpBXKnM+6wNyVkrKzg7Pb7y8VfeMNd2ggTm3SczPsC+X9K+REaVciod8Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1aab85f-53e8-4d1e-467b-08d865977a84
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 23:20:54.9108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qekv0whA6hkpaP2cA/hn7ApzNAuI+qzrA9rlh1hrbrHtpOP6glIE23I35uPHdf+SDk//AsgMcinqO7WGE7J/TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1561
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/25/20 4:22 PM, Ben Gardon wrote:
> The TDP iterator implements a pre-order traversal of a TDP paging
> structure. This iterator will be used in future patches to create
> an efficient implementation of the KVM MMU for the TDP case.
> 
> Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
> machine. This series introduced no new failures.
> 
> This series can be viewed in Gerrit at:
> 	https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flinux-review.googlesource.com%2Fc%2Fvirt%2Fkvm%2Fkvm%2F%2B%2F2538&amp;data=02%7C01%7CEric.VanTassell%40amd.com%7C08ae391c1b9a4da5eb1e08d861997899%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637366659084240984&amp;sdata=pVD8B%2BoNGf1fN18y%2Bjrwyuhlu7TbP1DhUIg%2BbP8KP2s%3D&amp;reserved=0
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/Makefile           |   3 +-
>   arch/x86/kvm/mmu/mmu.c          |  19 +---
>   arch/x86/kvm/mmu/mmu_internal.h |  15 +++
>   arch/x86/kvm/mmu/tdp_iter.c     | 163 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/mmu/tdp_iter.h     |  53 +++++++++++
>   5 files changed, 237 insertions(+), 16 deletions(-)
>   create mode 100644 arch/x86/kvm/mmu/tdp_iter.c
>   create mode 100644 arch/x86/kvm/mmu/tdp_iter.h
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 4a3081e9f4b5d..cf6a9947955f7 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -15,7 +15,8 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
>   
>   kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
>   			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
> -			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
> +			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
> +			   mmu/tdp_iter.o
>   
>   kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
>   kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 81240b558d67f..b48b00c8cde65 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -134,15 +134,6 @@ module_param(dbg, bool, 0644);
>   #define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
>   #define SPTE_MMIO_MASK (3ULL << 52)
>   
> -#define PT64_LEVEL_BITS 9
> -
> -#define PT64_LEVEL_SHIFT(level) \
> -		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
> -
> -#define PT64_INDEX(address, level)\
> -	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
> -
> -
>   #define PT32_LEVEL_BITS 10
>   
>   #define PT32_LEVEL_SHIFT(level) \
> @@ -192,8 +183,6 @@ module_param(dbg, bool, 0644);
>   #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
>   #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
>   
> -#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
> -
>   /* make pte_list_desc fit well in cache line */
>   #define PTE_LIST_EXT 3
>   
> @@ -346,7 +335,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
>   }
>   EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
>   
> -static bool is_mmio_spte(u64 spte)
> +bool is_mmio_spte(u64 spte)
>   {
>   	return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
>   }
> @@ -623,7 +612,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
>   	return vcpu->arch.efer & EFER_NX;
>   }
>   
> -static int is_shadow_present_pte(u64 pte)
> +int is_shadow_present_pte(u64 pte)
>   {
>   	return (pte != 0) && !is_mmio_spte(pte);
 From <Figure 28-1: Formats of EPTP and EPT Paging-Structure Entries" of 
the manual I don't have at my fingertips right now, I believe you should 
only check the low 3 bits(mask = 0x7). Since the upper bits are ignored, 
might that not mean they're not guaranteed to be 0?
>   }
> @@ -633,7 +622,7 @@ static int is_large_pte(u64 pte)
>   	return pte & PT_PAGE_SIZE_MASK;
>   }
>   
> -static int is_last_spte(u64 pte, int level)
> +int is_last_spte(u64 pte, int level)
>   {
>   	if (level == PG_LEVEL_4K)
>   		return 1;
> @@ -647,7 +636,7 @@ static bool is_executable_pte(u64 spte)
>   	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
>   }
>   
> -static kvm_pfn_t spte_to_pfn(u64 pte)
> +kvm_pfn_t spte_to_pfn(u64 pte)
>   {
>   	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
>   }
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 3acf3b8eb469d..65bb110847858 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -60,4 +60,19 @@ void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
>   bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>   				    struct kvm_memory_slot *slot, u64 gfn);
>   
> +#define PT64_LEVEL_BITS 9
> +
> +#define PT64_LEVEL_SHIFT(level) \
> +		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
> +
> +#define PT64_INDEX(address, level)\
> +	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
> +#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
> +
> +/* Functions for interpreting SPTEs */
> +kvm_pfn_t spte_to_pfn(u64 pte);
> +bool is_mmio_spte(u64 spte);
> +int is_shadow_present_pte(u64 pte);
> +int is_last_spte(u64 pte, int level);
> +
>   #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> new file mode 100644
> index 0000000000000..ee90d62d2a9b1
> --- /dev/null
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -0,0 +1,163 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include "mmu_internal.h"
> +#include "tdp_iter.h"
> +
> +/*
> + * Recalculates the pointer to the SPTE for the current GFN and level and
> + * reread the SPTE.
> + */
> +static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
> +{
> +	iter->sptep = iter->pt_path[iter->level - 1] +
> +		SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
> +	iter->old_spte = READ_ONCE(*iter->sptep);
> +}
> +
> +/*
> + * Sets a TDP iterator to walk a pre-order traversal of the paging structure
> + * rooted at root_pt, starting with the walk to translate goal_gfn.
> + */
> +void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
> +		    gfn_t goal_gfn)
> +{
> +	WARN_ON(root_level < 1);
> +	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
> +
> +	iter->goal_gfn = goal_gfn;
> +	iter->root_level = root_level;
> +	iter->level = root_level;
> +	iter->pt_path[iter->level - 1] = root_pt;
> +
> +	iter->gfn = iter->goal_gfn -
> +		(iter->goal_gfn % KVM_PAGES_PER_HPAGE(iter->level));
> +	tdp_iter_refresh_sptep(iter);
> +
> +	iter->valid = true;
> +}
> +
> +/*
> + * Given an SPTE and its level, returns a pointer containing the host virtual
> + * address of the child page table referenced by the SPTE. Returns null if
> + * there is no such entry.
> + */
> +u64 *spte_to_child_pt(u64 spte, int level)
> +{
> +	u64 *pt;
> +	/* There's no child entry if this entry isn't present */
> +	if (!is_shadow_present_pte(spte))
> +		return NULL;
> +
> +	/* There is no child page table if this is a leaf entry. */
> +	if (is_last_spte(spte, level))
> +		return NULL;
> +
> +	pt = (u64 *)__va(spte_to_pfn(spte) << PAGE_SHIFT);
> +	return pt;
> +}
> +
> +/*
> + * Steps down one level in the paging structure towards the goal GFN. Returns
> + * true if the iterator was able to step down a level, false otherwise.
> + */
> +static bool try_step_down(struct tdp_iter *iter)
> +{
> +	u64 *child_pt;
> +
> +	if (iter->level == PG_LEVEL_4K)
> +		return false;
> +
> +	/*
> +	 * Reread the SPTE before stepping down to avoid traversing into page
> +	 * tables that are no longer linked from this entry.
> +	 */
> +	iter->old_spte = READ_ONCE(*iter->sptep);
> +
> +	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
> +	if (!child_pt)
> +		return false;
> +
> +	iter->level--;
> +	iter->pt_path[iter->level - 1] = child_pt;
> +	iter->gfn = iter->goal_gfn -
> +		(iter->goal_gfn % KVM_PAGES_PER_HPAGE(iter->level));
> +	tdp_iter_refresh_sptep(iter);
> +
> +	return true;
> +}
> +
> +/*
> + * Steps to the next entry in the current page table, at the current page table
> + * level. The next entry could point to a page backing guest memory or another
> + * page table, or it could be non-present. Returns true if the iterator was
> + * able to step to the next entry in the page table, false if the iterator was
> + * already at the end of the current page table.
> + */
> +static bool try_step_side(struct tdp_iter *iter)
> +{
> +	/*
> +	 * Check if the iterator is already at the end of the current page
> +	 * table.
> +	 */
> +	if (!((iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) %
> +	      KVM_PAGES_PER_HPAGE(iter->level + 1)))
> +		return false;
> +
> +	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
> +	iter->goal_gfn = iter->gfn;
> +	iter->sptep++;
> +	iter->old_spte = READ_ONCE(*iter->sptep);
> +
> +	return true;
> +}
> +
> +/*
> + * Tries to traverse back up a level in the paging structure so that the walk
> + * can continue from the next entry in the parent page table. Returns true on a
> + * successful step up, false if already in the root page.
> + */
> +static bool try_step_up(struct tdp_iter *iter)
> +{
> +	if (iter->level == iter->root_level)
> +		return false;
> +
> +	iter->level++;
> +	iter->gfn =  iter->gfn - (iter->gfn % KVM_PAGES_PER_HPAGE(iter->level));
> +	tdp_iter_refresh_sptep(iter);
> +
> +	return true;
> +}
> +
> +/*
> + * Step to the next SPTE in a pre-order traversal of the paging structure.
> + * To get to the next SPTE, the iterator either steps down towards the goal
> + * GFN, if at a present, non-last-level SPTE, or over to a SPTE mapping a
> + * highter GFN.
> + *
> + * The basic algorithm is as follows:
> + * 1. If the current SPTE is a non-last-level SPTE, step down into the page
> + *    table it points to.
> + * 2. If the iterator cannot step down, it will try to step to the next SPTE
> + *    in the current page of the paging structure.
> + * 3. If the iterator cannot step to the next entry in the current page, it will
> + *    try to step up to the parent paging structure page. In this case, that
> + *    SPTE will have already been visited, and so the iterator must also step
> + *    to the side again.
> + */
> +void tdp_iter_next(struct tdp_iter *iter)
> +{
> +	bool done;
> +
> +	done = try_step_down(iter);
> +	if (done)
> +		return;
> +
> +	done = try_step_side(iter);
> +	while (!done) {
> +		if (!try_step_up(iter)) {
> +			iter->valid = false;
> +			break;
> +		}
> +		done = try_step_side(iter);
> +	}
> +}
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> new file mode 100644
> index 0000000000000..b102109778eac
> --- /dev/null
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __KVM_X86_MMU_TDP_ITER_H
> +#define __KVM_X86_MMU_TDP_ITER_H
> +
> +#include <linux/kvm_host.h>
> +
> +#include "mmu.h"
> +
> +/*
> + * A TDP iterator performs a pre-order walk over a TDP paging structure.
> + */
> +struct tdp_iter {
> +	/*
> +	 * The iterator will traverse the paging structure towards the mapping
> +	 * for this GFN.
> +	 */
> +	gfn_t goal_gfn;
> +	/* Pointers to the page tables traversed to reach the current SPTE */
> +	u64 *pt_path[PT64_ROOT_MAX_LEVEL];
> +	/* A pointer to the current SPTE */
> +	u64 *sptep;
> +	/* The lowest GFN mapped by the current SPTE */
> +	gfn_t gfn;
> +	/* The level of the root page given to the iterator */
> +	int root_level;
> +	/* The iterator's current level within the paging structure */
> +	int level;
> +	/* A snapshot of the value at sptep */
> +	u64 old_spte;
> +	/*
> +	 * Whether the iterator has a valid state. This will be false if the
> +	 * iterator walks off the end of the paging structure.
> +	 */
> +	bool valid;
> +};
> +
> +/*
> + * Iterates over every SPTE mapping the GFN range [start, end) in a
> + * preorder traversal.
> + */
> +#define for_each_tdp_pte(iter, root, root_level, start, end) \
> +	for (tdp_iter_start(&iter, root, root_level, start); \
> +	     iter.valid && iter.gfn < end;		     \
> +	     tdp_iter_next(&iter))
> +
> +u64 *spte_to_child_pt(u64 pte, int level);
> +
> +void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
> +		    gfn_t goal_gfn);
> +void tdp_iter_next(struct tdp_iter *iter);
> +
> +#endif /* __KVM_X86_MMU_TDP_ITER_H */
> 
