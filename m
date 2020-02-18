Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B919162F61
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 20:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgBRTHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 14:07:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:3353 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgBRTHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 14:07:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 11:07:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; 
   d="scan'208";a="235633600"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 18 Feb 2020 11:07:29 -0800
Date:   Tue, 18 Feb 2020 11:07:29 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Suppress warning in __kvm_gfn_to_hva_cache_init
Message-ID: <20200218190729.GD28156@linux.intel.com>
References: <20200218184756.242904-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218184756.242904-1-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 10:47:56AM -0800, Oliver Upton wrote:
> Particularly draconian compilers warn of a possible uninitialized use of
> the nr_pages_avail variable. Silence this warning by initializing it to
> zero.

Can you check if the warning still exists with commit 6ad1e29fe0ab ("KVM:
Clean up __kvm_gfn_to_hva_cache_init() and its callers")?  I'm guessing
(hoping?) the suppression is no longer necessary.

commit 6ad1e29fe0aba843dfffc714fced0ef6a2e19502
Author: Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu Jan 9 14:58:55 2020 -0500

    KVM: Clean up __kvm_gfn_to_hva_cache_init() and its callers

    Barret reported a (technically benign) bug where nr_pages_avail can be
    accessed without being initialized if gfn_to_hva_many() fails.

      virt/kvm/kvm_main.c:2193:13: warning: 'nr_pages_avail' may be
      used uninitialized in this function [-Wmaybe-uninitialized]

    Rather than simply squashing the warning by initializing nr_pages_avail,
    fix the underlying issues by reworking __kvm_gfn_to_hva_cache_init() to
    return immediately instead of continuing on.  Now that all callers check
    the result and/or bail immediately on a bad hva, there's no need to
    explicitly nullify the memslot on error.

    Reported-by: Barret Rhoden <brho@google.com>
    Fixes: f1b9dd5eb86c ("kvm: Disallow wraparound in kvm_gfn_to_hva_cache_init")
    Cc: Jim Mattson <jmattson@google.com>
    Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>


> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70f03ce0e5c1..dc8a67ad082d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2219,7 +2219,7 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
>  	gfn_t start_gfn = gpa >> PAGE_SHIFT;
>  	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
>  	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
> -	gfn_t nr_pages_avail;
> +	gfn_t nr_pages_avail = 0;
>  
>  	/* Update ghc->generation before performing any error checks. */
>  	ghc->generation = slots->generation;
> -- 
> 2.25.0.265.gbab2e86ba0-goog
> 
