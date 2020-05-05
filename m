Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D389B1C4B96
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 03:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgEEBja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 21:39:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:28211 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbgEEBja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 21:39:30 -0400
IronPort-SDR: 7T0tBktg9CI+U4fNudMEIvRJaod0c1HYF7s5sqFlA3zG5x6i7L7dG3S5XLhwELh2a1hZWFEAAl
 a5WzzlSXCzHw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 18:39:29 -0700
IronPort-SDR: 7v+jAV3mtNe04YW45Uakla87AwnPe3mwPUCOOLI2a50cSMJTltL9q2uPvnJJSO8JcoW6/SJiNd
 7p19bD0h36hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="263000817"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 04 May 2020 18:39:29 -0700
Date:   Mon, 4 May 2020 18:39:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Fix a warning in __kvm_gfn_to_hva_cache_init()
Message-ID: <20200505013929.GA17225@linux.intel.com>
References: <20200504190526.84456-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200504190526.84456-1-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 03:05:26PM -0400, Peter Xu wrote:
> GCC 10.0.1 gives me this warning when building KVM:
> 
>   warning: ‘nr_pages_avail’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   2442 |  for ( ; start_gfn <= end_gfn; start_gfn += nr_pages_avail) {
> 
> It should not happen, but silent it.

Heh, third times a charm?  This has been reported and proposed twice
before[1][2].  Are you using any custom compiler flags?  E.g. -O3 is known
to cause false positives with -Wmaybe-uninitialized.

If we do end up killing this warning, I'd still prefer to use
uninitialized_var() over zero-initializing the variable.

[1] https://lkml.kernel.org/r/20200218184756.242904-1-oupton@google.com
[2] https://bugzilla.kernel.org/show_bug.cgi?id=207173

> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 74bdb7bf3295..2da293885a67 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2425,7 +2425,7 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
>  	gfn_t start_gfn = gpa >> PAGE_SHIFT;
>  	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
>  	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
> -	gfn_t nr_pages_avail;
> +	gfn_t nr_pages_avail = 0;
>  
>  	/* Update ghc->generation before performing any error checks. */
>  	ghc->generation = slots->generation;
> -- 
> 2.26.2
> 
