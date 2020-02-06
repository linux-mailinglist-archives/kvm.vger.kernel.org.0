Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83894154F3A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 00:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBFXHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 18:07:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:34047 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgBFXHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 18:07:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 15:07:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="225391166"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 06 Feb 2020 15:07:30 -0800
Date:   Thu, 6 Feb 2020 15:07:30 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: x86/mmu: Fix struct guest_walker arrays for
 5-level paging
Message-ID: <20200206230730.GA24556@linux.intel.com>
References: <20200206220836.22743-1-sean.j.christopherson@intel.com>
 <20200206220836.22743-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206220836.22743-3-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 02:08:31PM -0800, Sean Christopherson wrote:
> Define PT_MAX_FULL_LEVELS as PT64_ROOT_MAX_LEVEL, i.e. 5, to fix shadow
> paging for 5-level guest page tables.  PT_MAX_FULL_LEVELS is used to
> size the arrays that track guest pages table information, i.e. using a
> "max levels" of 4 causes KVM to access garbage beyond the end of an
> array when querying state for level 5 entries.  E.g. FNAME(gpte_changed)
> will read garbage and most likely return %true for a level 5 entry,
> soft-hanging the guest because FNAME(fetch) will restart the guest
> instead of creating SPTEs because it thinks the guest PTE has changed.
> 
> Fixes: 855feb673640 ("KVM: MMU: Add 5 level EPT & Shadow page table support.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 4e1ef0473663..6b15b58f3ecc 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -33,7 +33,7 @@
>  	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
>  	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
>  	#ifdef CONFIG_X86_64
> -	#define PT_MAX_FULL_LEVELS 4
> +	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
>  	#define CMPXCHG cmpxchg
>  	#else
>  	#define CMPXCHG cmpxchg64
> @@ -66,7 +66,7 @@
>  	#define PT_GUEST_ACCESSED_SHIFT 8
>  	#define PT_HAVE_ACCESSED_DIRTY(mmu) ((mmu)->ept_ad)
>  	#define CMPXCHG cmpxchg64
> -	#define PT_MAX_FULL_LEVELS 4
> +	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL

Doh, the nested EPT change belongs in the next patch.  I'll retest tomorrow
and send a v2 when by brain is less mushy.

>  #else
>  	#error Invalid PTTYPE value
>  #endif
> -- 
> 2.24.1
> 
