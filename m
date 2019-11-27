Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA4F10B5CB
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfK0Scu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:32:50 -0500
Received: from mga17.intel.com ([192.55.52.151]:42807 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfK0Sct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:32:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 10:32:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="221065689"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 27 Nov 2019 10:32:49 -0800
Date:   Wed, 27 Nov 2019 10:32:48 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 03/28] kvm: mmu: Zero page cache memory at allocation
 time
Message-ID: <20191127183248.GC22227@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-4-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:17:59PM -0700, Ben Gardon wrote:
> Simplify use of the MMU page cache by allocating pages pre-zeroed. This
> ensures that future code does not accidentally add non-zeroed memory to
> the paging structure and moves the work of zeroing page page out from
> under the MMU lock.

Ha, this *just* came up in a different series[*].  Unless there is a hard
dependency on the rest of this series, it'd be nice to tackle this
separately so that we can fully understand the tradeoffs.  And it could be
merged early/independently as well.

[*] https://patchwork.kernel.org/patch/11228487/#23025353

> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 7e5ab9c6e2b09..1ecd6d51c0ee0 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1037,7 +1037,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
>  	if (cache->nobjs >= min)
>  		return 0;
>  	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>  		if (!page)
>  			return cache->nobjs >= min ? 0 : -ENOMEM;
>  		cache->objects[cache->nobjs++] = page;
> @@ -2548,7 +2548,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
>  			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
>  	}
> -	clear_page(sp->spt);
>  	trace_kvm_mmu_get_page(sp, true);
>  
>  	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
> -- 
> 2.23.0.444.g18eeb5a265-goog
> 
