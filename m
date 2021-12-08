Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C506046CF99
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 09:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhLHJCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 04:02:06 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:39287 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhLHJCF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 04:02:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuyu@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Uzrn5-M_1638953910;
Received: from 30.225.28.56(mailfrom:xuyu@linux.alibaba.com fp:SMTPD_---0Uzrn5-M_1638953910)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Dec 2021 16:58:31 +0800
Message-ID: <b955c5c4-bc4b-9f43-be1c-3a45973de259@linux.alibaba.com>
Date:   Wed, 8 Dec 2021 16:58:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v2 07/14] x86/clear_page: add clear_page_uncached()
Content-Language: en-US
To:     Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
 <20211020170305.376118-8-ankur.a.arora@oracle.com>
From:   Yu Xu <xuyu@linux.alibaba.com>
In-Reply-To: <20211020170305.376118-8-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/21 1:02 AM, Ankur Arora wrote:
> Expose the low-level uncached primitives (clear_page_movnt(),
> clear_page_clzero()) as alternatives via clear_page_uncached().
> Also fallback to clear_page(), if X86_FEATURE_MOVNT_SLOW is set
> and the CPU does not have X86_FEATURE_CLZERO.
> 
> Both the uncached primitives use stores which are weakly ordered
> with respect to other instructions accessing the memory hierarchy.
> To ensure that callers don't mix accesses to different types of
> address_spaces, annotate clear_user_page_uncached(), and
> clear_page_uncached() as taking __incoherent pointers as arguments.
> 
> Also add clear_page_uncached_make_coherent() which provides the
> necessary store fence to flush out the uncached regions.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
> 
> Notes:
>      This patch adds the fallback definitions of clear_user_page_uncached()
>      etc in include/linux/mm.h which is likely not the right place for it.
> 
>      I'm guessing these should be moved to include/asm-generic/page.h
>      (or maybe a new include/asm-generic/page_uncached.h) and for
>      architectures that do have arch/$arch/include/asm/page.h (which
>      seems like all of them), also replicate there?
> 
>      Anyway, wanted to first check if that's the way to do it, before
>      doing that.
> 
>   arch/x86/include/asm/page.h    | 10 ++++++++++
>   arch/x86/include/asm/page_32.h |  9 +++++++++
>   arch/x86/include/asm/page_64.h | 32 ++++++++++++++++++++++++++++++++
>   include/linux/mm.h             | 14 ++++++++++++++
>   4 files changed, 65 insertions(+)
> 
> diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
> index 94dbd51df58f..163be03ac422 100644
> --- a/arch/x86/include/asm/page_32.h
> +++ b/arch/x86/include/asm/page_32.h
> @@ -39,6 +39,15 @@ static inline void clear_page(void *page)
>   	memset(page, 0, PAGE_SIZE);
>   }
>   
> +static inline void clear_page_uncached(__incoherent void *page)
> +{
> +	clear_page((__force void *) page);
> +}
> +
> +static inline void clear_page_uncached_make_coherent(void)
> +{
> +}
> +
>   static inline void copy_page(void *to, void *from)
>   {
>   	memcpy(to, from, PAGE_SIZE);
> diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
> index 3c53f8ef8818..d7946047c70f 100644
> --- a/arch/x86/include/asm/page_64.h
> +++ b/arch/x86/include/asm/page_64.h
> @@ -56,6 +56,38 @@ static inline void clear_page(void *page)
>   			   : "cc", "memory", "rax", "rcx");
>   }
>   
> +/*
> + * clear_page_uncached: only allowed on __incoherent memory regions.
> + */
> +static inline void clear_page_uncached(__incoherent void *page)
> +{
> +	alternative_call_2(clear_page_movnt,
> +			   clear_page, X86_FEATURE_MOVNT_SLOW,
> +			   clear_page_clzero, X86_FEATURE_CLZERO,
> +			   "=D" (page),
> +			   "0" (page)
> +			   : "cc", "memory", "rax", "rcx");
> +}
> +
> +/*
> + * clear_page_uncached_make_coherent: executes the necessary store
> + * fence after which __incoherent regions can be safely accessed.
> + */
> +static inline void clear_page_uncached_make_coherent(void)
> +{
> +	/*
> +	 * Keep the sfence for oldinstr and clzero separate to guard against
> +	 * the possibility that a cpu-model both has X86_FEATURE_MOVNT_SLOW
> +	 * and X86_FEATURE_CLZERO.
> +	 *
> +	 * The alternatives need to be in the same order as the ones
> +	 * in clear_page_uncached().
> +	 */
> +	alternative_2("sfence",
> +		      "", X86_FEATURE_MOVNT_SLOW,
> +		      "sfence", X86_FEATURE_CLZERO);
> +}
> +
>   void copy_page(void *to, void *from);
>   
>   #ifdef CONFIG_X86_5LEVEL
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 73a52aba448f..b88069d1116c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3192,6 +3192,20 @@ static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
>   
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
>   
> +#ifndef clear_user_page_uncached

Hi Ankur Arora,

I've been looking for where clear_user_page_uncached is defined in this
patchset, but failed.

There should be something like follows in arch/x86, right?

static inline void clear_user_page_uncached(__incoherent void *page,
                                unsigned long vaddr, struct page *pg)
{
         clear_page_uncached(page);
}


Did I miss something?

> +/*
> + * clear_user_page_uncached: fallback to the standard clear_user_page().
> + */
> +static inline void clear_user_page_uncached(__incoherent void *page,
> +					unsigned long vaddr, struct page *pg)
> +{
> +	clear_user_page((__force void *)page, vaddr, pg);
> +}
> +
> +static inline void clear_page_uncached_make_coherent(void) { }
> +#endif
> +
> +
>   #ifdef CONFIG_DEBUG_PAGEALLOC
>   extern unsigned int _debug_guardpage_minorder;
>   DECLARE_STATIC_KEY_FALSE(_debug_guardpage_enabled);
> 

-- 
Thanks,
Yu
