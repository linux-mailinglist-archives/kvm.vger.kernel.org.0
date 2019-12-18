Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35177125251
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 20:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfLRTv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 14:51:28 -0500
Received: from mail-eopbgr760049.outbound.protection.outlook.com ([40.107.76.49]:10135
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbfLRTv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 14:51:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpJCBvS1fMMiV0KuE0FqphCgA1wbi6JbyOrRt7DostBuEQpQV059aggdCN7G0qTt4S5RUWrf2kvTjf0qsDk6TtKuCZldNaF0vPdEwPW6gDCXteGsYkdDJyq7Bo+SzQP9UkYR6saSPhpuyc35onytsLKYpO0pFZA5ZsGA9g2D6axjYTW2wZHiD56bwykJZheR89eUjuBTVAv4woHLyxuQ1IxbNymuGLUOS1CI3DCFnYa+fioqmh2hSuO7GllWFUfg0rlBKZCb5VMhxx5Os/I4xf1xQv1QiGGq3D+M223VjNSVCqe0lBF3QI+2EA4rwm7kqwRAFWjsx6Q/m1c02iOsNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMe6M+qzGfMneg8pkhXi4GvQC/efEnhQOBvnKHCC15k=;
 b=MImaw2ZDLDThU+U+RszStxnmhX7Ux3LIwnZT5D0aHuerjmRfrC9GBbArNu3xev2LEMJ9lers2zNvwv4Kl4PIsJdi/Jxr3hjTyCxIQZNZa0o6QYAJfDLahxlnxj+A7MpAMl9rzvinjT78QMYqkHSucOrhLPDgDxnh8vfgGZON9zZtfxAXTAqJvUUMsr8lkIW+OwSJcdgENXcQBJuGXb0H5a7Cv+DUNTY+ZbeHwm6AlvMwzCsaAMvzBx+Nsxip1dfNMwmS6Gm3qy1waLNhb3HvixMKpogsSvsUGBW+jJIXePTxv8zF0kwz8ZBSd5fbvbRUU/zJe/vIrVwUz2Jndtrh9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMe6M+qzGfMneg8pkhXi4GvQC/efEnhQOBvnKHCC15k=;
 b=T+1n+mhxFCrDmA1QdCpXLPyZxfXC9ksqPnfpYW2BsRZ3otpa+DkGE2BC8cenDFPCYHPw8JTirBS6G1Yt+vnq5keKvgz5DBAFsxNaskJphaTs1JnaCGd/mpKlishVsQzosJoJN2jqvcPerkFfk5WJ4wAqC49zW/dMjZ8921wAK7I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3339.namprd12.prod.outlook.com (20.178.30.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Wed, 18 Dec 2019 19:51:25 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 19:51:24 +0000
Subject: Re: [PATCH v1 1/2] KVM: x86/mmu: Allow for overriding MMIO SPTE mask
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1576698347.git.thomas.lendacky@amd.com>
 <10fdb77c9b6795f68137cf4315571ab791ab6feb.1576698347.git.thomas.lendacky@amd.com>
Message-ID: <f0bc54c8-cea2-e574-6191-5c34d1b504c9@amd.com>
Date:   Wed, 18 Dec 2019 13:51:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <10fdb77c9b6795f68137cf4315571ab791ab6feb.1576698347.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR10CA0033.namprd10.prod.outlook.com
 (2603:10b6:5:60::46) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22ed5307-81b2-4384-657f-08d783f3a9d6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3339:|DM6PR12MB3339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB333956AC7C0B9E62351A2AC5EC530@DM6PR12MB3339.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0255DF69B9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(189003)(199004)(31696002)(66556008)(52116002)(6506007)(186003)(8936002)(86362001)(81156014)(81166006)(66946007)(316002)(8676002)(53546011)(6486002)(4326008)(54906003)(5660300002)(2906002)(31686004)(66476007)(6512007)(36756003)(478600001)(2616005)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3339;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/xF8b2w80kLFSCjCfjH8pQOp3Lrk9UnAGajyiEScOWbjk/qXj+NwWnTKyVvScjOUIjBvb+2Z+0XYPXmkxv0KTlLkwmGqKA4dVFqyc5a8+i+KSr59P/8S0sYcIlsVcx8IS1OpB9P5ieed6ODsHLWfBkqa/kDkCs7sqW29fxTZf5c8imCQweaRDkE0XspdpWJiji78DSoA+iQ9xkHsr6j7zDlwrXf2YlU2uZJct6ZmhA8/eiFXf8ydDZVIADU3gDU83LDNteKzH/7T2H1na1qVu656xpdNrcMG9hQSu8jaKA3kkrTfWzMgF0z/0144akWyo14yKhQlasUiMnzyUcvYZUQ2VMyWs2KMmiwuSe5md03ME8VNizUARQyrHi5w51f+rwBR+EtuCUps6kKmsINXXX4ZzyjWkKgkTM8DvnGGg3Ol5cnzTDZNT4Iu3dmfsrQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ed5307-81b2-4384-657f-08d783f3a9d6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2019 19:51:24.8085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8s+EmSIbxhslxicCNC7BWAqzH+v5Cr9ncP087+4ls5IFyjaM5thFws7OUq/CAQ0qwaSxHLfcurT3OWJO481txA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3339
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/18/19 1:45 PM, Tom Lendacky wrote:
> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
> faults when a guest performs MMIO. The AMD memory encryption support uses
> CPUID functions to define the encryption bit position. Given this, KVM
> can't assume that bit 51 will be safe all the time.
> 
> Add a callback to return a reserved bit(s) mask that can be used for the
> MMIO pagetable entries. The callback is not responsible for setting the
> present bit.
> 
> If a callback is registered:
>   - any non-zero mask returned is updated with the present bit and used
>     as the MMIO SPTE mask.
>   - a zero mask returned results in a mask with only bit 51 set (i.e. no
>     present bit) as the MMIO SPTE mask, similar to the way 52-bit physical
>     addressing is handled.
> 
> If no callback is registered, the current method of setting the MMIO SPTE
> mask is used.
> 
> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++-
>  arch/x86/kvm/mmu/mmu.c          | 54 +++++++++++++++++++++------------
>  arch/x86/kvm/x86.c              |  2 +-
>  3 files changed, 38 insertions(+), 22 deletions(-)

This patch has some extra churn because kvm_x86_ops isn't set yet when the
call to kvm_set_mmio_spte_mask() is made. If it's not a problem to move
setting kvm_x86_ops just a bit earlier in kvm_arch_init(), some of the
churn can be avoided.

Thanks,
Tom

> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b79cd6aa4075..0c666c10f1a2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1233,6 +1233,8 @@ struct kvm_x86_ops {
>  
>  	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> +
> +	u64 (*get_reserved_mask)(void);
>  };
>  
>  struct kvm_arch_async_pf {
> @@ -1266,7 +1268,7 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
>  		return -ENOTSUPP;
>  }
>  
> -int kvm_mmu_module_init(void);
> +int kvm_mmu_module_init(struct kvm_x86_ops *ops);
>  void kvm_mmu_module_exit(void);
>  
>  void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f92b40d798c..d419df7a4056 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6227,30 +6227,44 @@ static void mmu_destroy_caches(void)
>  	kmem_cache_destroy(mmu_page_header_cache);
>  }
>  
> -static void kvm_set_mmio_spte_mask(void)
> +static void kvm_set_mmio_spte_mask(struct kvm_x86_ops *ops)
>  {
>  	u64 mask;
>  
> -	/*
> -	 * Set the reserved bits and the present bit of an paging-structure
> -	 * entry to generate page fault with PFER.RSV = 1.
> -	 */
> +	if (ops->get_reserved_mask) {
> +		mask = ops->get_reserved_mask();
>  
> -	/*
> -	 * Mask the uppermost physical address bit, which would be reserved as
> -	 * long as the supported physical address width is less than 52.
> -	 */
> -	mask = 1ull << 51;
> +		/*
> +		 * If there are reserved bits available, add the present bit
> +		 * to the mask to generate a page fault with PFER.RSV = 1.
> +		 * If there are no reserved bits available, mask the uppermost
> +		 * physical address bit, but keep the present bit cleared.
> +		 */
> +		if (mask)
> +			mask |= 1ull;
> +		else
> +			mask = 1ull << 51;
> +	} else {
> +		/*
> +		 * Set the reserved bits and the present bit of a
> +		 * paging-structure entry to generate page fault with
> +		 * PFER.RSV = 1.
> +		 */
>  
> -	/* Set the present bit. */
> -	mask |= 1ull;
> +		/*
> +		 * Mask the uppermost physical address bit, which would be
> +		 * reserved as long as the supported physical address width
> +		 * is less than 52.
> +		 */
> +		mask = 1ull << 51;
>  
> -	/*
> -	 * If reserved bit is not supported, clear the present bit to disable
> -	 * mmio page fault.
> -	 */
> -	if (IS_ENABLED(CONFIG_X86_64) && shadow_phys_bits == 52)
> -		mask &= ~1ull;
> +		/*
> +		 * If reserved bit is not supported, don't set the present bit
> +		 * to disable mmio page fault.
> +		 */
> +		if (!IS_ENABLED(CONFIG_X86_64) || shadow_phys_bits != 52)
> +			mask |= 1ull;
> +	}
>  
>  	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
>  }
> @@ -6301,7 +6315,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  	return 0;
>  }
>  
> -int kvm_mmu_module_init(void)
> +int kvm_mmu_module_init(struct kvm_x86_ops *ops)
>  {
>  	int ret = -ENOMEM;
>  
> @@ -6320,7 +6334,7 @@ int kvm_mmu_module_init(void)
>  
>  	kvm_mmu_reset_all_pte_masks();
>  
> -	kvm_set_mmio_spte_mask();
> +	kvm_set_mmio_spte_mask(ops);
>  
>  	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
>  					    sizeof(struct pte_list_desc),
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3ed167e039e5..311da4ed423d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7234,7 +7234,7 @@ int kvm_arch_init(void *opaque)
>  		goto out_free_x86_fpu_cache;
>  	}
>  
> -	r = kvm_mmu_module_init();
> +	r = kvm_mmu_module_init(ops);
>  	if (r)
>  		goto out_free_percpu;
>  
> 
