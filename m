Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3F61D3DD9
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgENTq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:46:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:64955 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgENTq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 15:46:26 -0400
IronPort-SDR: 7ohElgzrERaYD5cL4ZsH66kypUVifQqRSj5fOT7yh9sQCLbYwY2IHif76utv9JDSLRddW81NC5
 NdOPEGl03Ljg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 12:46:25 -0700
IronPort-SDR: flsIJHe9UI6UCiP5a+x7YBC+A6tXzkxifMrWzGrk8lM66Gxh34vkP5RWv/UrwXOzigfoh2gPDJ
 pQ2qVTf+3KUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="307200453"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 14 May 2020 12:46:25 -0700
Date:   Thu, 14 May 2020 12:46:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 4/5] KVM: x86: aggressively map PTEs in
 KVM_MEM_ALLONES slots
Message-ID: <20200514194624.GB15847@linux.intel.com>
References: <20200514180540.52407-1-vkuznets@redhat.com>
 <20200514180540.52407-5-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514180540.52407-5-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 08:05:39PM +0200, Vitaly Kuznetsov wrote:
> All PTEs in KVM_MEM_ALLONES slots point to the same read-only page
> in KVM so instead of mapping each page upon first access we can map
> everything aggressively.
> 
> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 20 ++++++++++++++++++--
>  arch/x86/kvm/mmu/paging_tmpl.h | 23 +++++++++++++++++++++--
>  2 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3db499df2dfc..e92ca9ed3ff5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4154,8 +4154,24 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  		goto out_unlock;
>  	if (make_mmu_pages_available(vcpu) < 0)
>  		goto out_unlock;
> -	r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
> -			 prefault, is_tdp && lpage_disallowed);
> +
> +	if (likely(!(slot->flags & KVM_MEM_ALLONES) || write)) {

The 'write' check is wrong.  More specifically, patch 2/5 is missing code
to add KVM_MEM_ALLONES to memslot_is_readonly().  If we end up going with
an actual kvm_allones_pg backing, writes to an ALLONES memslots should be
handled same as writes to RO memslots; MMIO occurs but no MMIO spte is
created.

> +		r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
> +				 prefault, is_tdp && lpage_disallowed);
> +	} else {
> +		/*
> +		 * KVM_MEM_ALLONES are 4k only slots fully mapped to the same
> +		 * readonly 'allones' page, map all PTEs aggressively here.
> +		 */
> +		for (gfn = slot->base_gfn; gfn < slot->base_gfn + slot->npages;
> +		     gfn++) {
> +			r = __direct_map(vcpu, gfn << PAGE_SHIFT, write,
> +					 map_writable, max_level, pfn, prefault,
> +					 is_tdp && lpage_disallowed);

IMO this is a waste of memory and TLB entries.  Why not treat the access as
the MMIO it is and emulate the access with a 0xff return value?  I think
it'd be a simple change to have __kvm_read_guest_page() stuff 0xff, i.e. a
kvm_allones_pg wouldn't be needed.  I would even vote to never create an
MMIO SPTE.  The guest has bigger issues if reading from a PCI hole is
performance sensitive.

Regarding memory, looping wantonly on __direct_map() will eventually trigger
the BUG_ON() in mmu_memory_cache_alloc().  mmu_topup_memory_caches() only
ensures there are enough objects available to map a single translation, i.e.
one entry per level, sans the root[*].

[*] The gorilla math in mmu_topup_memory_caches() is horrendously misleading,
    e.g. the '8' pages is really 2*(ROOT_LEVEL - 1), but the 2x part has been
    obsolete for the better part of a decade, and the '- 1' wasn't actually
    originally intended or needed, but is now required because of 5-level
    paging.  I have the beginning of a series to clean up that mess; it was
    low on my todo list because I didn't expect anyone to be mucking with
    related code :-)

> +			if (r)
> +				break;
> +		}
> +	}
