Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD7410B52E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfK0SHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:07:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:9039 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbfK0SHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:07:32 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 10:07:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="410432346"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 27 Nov 2019 10:07:31 -0800
Date:   Wed, 27 Nov 2019 10:07:31 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christoffer Dall <christoffer.dall@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        James Hogan <jhogan@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v4 1/5] KVM: x86: Move memcache allocation to
 GFP_PGTABLE_USER
Message-ID: <20191127180731.GC16845@linux.intel.com>
References: <20191105110357.8607-1-christoffer.dall@arm.com>
 <20191105110357.8607-2-christoffer.dall@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105110357.8607-2-christoffer.dall@arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 12:03:53PM +0100, Christoffer Dall wrote:
> Recent commit 50f11a8a4620eee6b6831e69ab5d42456546d7d8 moved page table
> allocations for both KVM and normal user page table allocations to
> GFP_PGTABLE_USER in order to get __GFP_ACCOUNT for the page tables.
> 
> However, while KVM on other architectures such as arm64 were included in
> this change, curiously KVM on x86 was not.
> 
> Currently, KVM on x86 uses kmem_cache_zalloc(GFP_KERNEL_ACCOUNT) for
> kmem_cache-based allocations, which expands in the following way:
>   kmem_cache_zalloc(..., GFP_KERNEL_ACCOUNT) =>
>   kmem_cache_alloc(..., GFP_KERNEL_ACCOUNT | __GFP_ZERO) =>
>   kmem_cache_alloc(..., GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO)
> 
> It so happens that GFP_PGTABLE_USER expands as:
>   GFP_PGTABLE_USER =>
>   (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT) =>
>   ((GFP_KERNEL | __GFP_ZERO) | __GFP_ACCOUNT) =>
>   (GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO)
> 
> Which means that we can replace the current KVM on x86 call as:
> -  obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
> +  obj = kmem_cache_alloc(base_cache, GFP_PGTABLE_USER);
> 
> For the single page cache topup allocation, KVM on x86 currently uses
> __get_free_page(GFP_KERNEL_ACCOUNT).  It seems to me that is equivalent
> to the above, except that the allocated page is not guaranteed to be
> zero (unless I missed the place where __get_free_page(!__GFP_ZERO) is
> still guaranteed to be zeroed.  It seems natural (and in fact desired)
> to have both topup functions implement the same expectations towards the
> caller, and we therefore move to GFP_PGTABLE_USER here as well.
> 
> This will make it easier to unify the memchace implementation between
> architectures.

Functionally, this looks correct (I haven't actually tested).  But, it
means that x86's shadow pages will be zeroed out twice, which could lead
to performance regressions.  The cache is also used for the gfns array,
and I'm pretty sure the gfns array is never zeroed out in the current code,
i.e. zeroing gfns would also introduce overhead.

The redudant zeroing of shadow pages could likely be addressed by removing
the call to clear_page() in kvm_mmu_get_page(), but I'd prefer not to go
that route because it doesn't address the gfns issue, means KVM pays the
cost of zeroing up front (as opposed to when a page is actually used), and
I have a future use case where the shadow page needs to be initialized to
a non-zero value.

What about having the common mmu_topup_memory_cache{_page}() take a GFP
param?  That would allow consolidating the bulk of the code while allowing
x86 to optimize its specific scenarios.

> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  arch/x86/kvm/mmu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24c23c66b226..540190cee3cb 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -40,6 +40,7 @@
>  
>  #include <asm/page.h>
>  #include <asm/pat.h>
> +#include <asm/pgalloc.h>
>  #include <asm/cmpxchg.h>
>  #include <asm/e820/api.h>
>  #include <asm/io.h>
> @@ -1025,7 +1026,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>  	if (cache->nobjs >= min)
>  		return 0;
>  	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
> +		obj = kmem_cache_alloc(base_cache, GFP_PGTABLE_USER);
>  		if (!obj)
>  			return cache->nobjs >= min ? 0 : -ENOMEM;
>  		cache->objects[cache->nobjs++] = obj;
> @@ -1053,7 +1054,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
>  	if (cache->nobjs >= min)
>  		return 0;
>  	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +		page = (void *)__get_free_page(GFP_PGTABLE_USER);
>  		if (!page)
>  			return cache->nobjs >= min ? 0 : -ENOMEM;
>  		cache->objects[cache->nobjs++] = page;
> -- 
> 2.18.0
> 
