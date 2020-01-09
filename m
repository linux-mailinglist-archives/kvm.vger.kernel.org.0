Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48DE1362FE
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 23:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgAIWED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 17:04:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:49496 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbgAIWEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 17:04:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:04:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="246804087"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jan 2020 14:04:01 -0800
Date:   Thu, 9 Jan 2020 14:04:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Barret Rhoden <brho@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: squelch uninitialized variable warning
Message-ID: <20200109220401.GA2682@linux.intel.com>
References: <20200109195855.17353-1-brho@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109195855.17353-1-brho@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 02:58:55PM -0500, Barret Rhoden wrote:
> If gfn_to_hva_many() fails, __kvm_gfn_to_hva_cache_init() will return an
> error.  Before it does, it might use nr_pages_avail, which my compiler
> complained about:
> 
> 	virt/kvm/kvm_main.c:2193:13: warning: 'nr_pages_avail' may be
> 	used uninitialized in this function [-Wmaybe-uninitialized]
> 
> 	   start_gfn += nr_pages_avail;

Ugh, this whole flow is funky.  The change is correct, and is certainly the
minimal change if we want to backport this to stable, but IMO it's putting
lipstick on a pig.  I'd rather fix the underlying issues and make the code
more readable in the process.  I'll send a patch.

If we want to take this as a minimal fix,

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> Signed-off-by: Barret Rhoden <brho@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d9aced677ddd..f8249b153d33 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2172,7 +2172,7 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
>  	gfn_t start_gfn = gpa >> PAGE_SHIFT;
>  	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
>  	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
> -	gfn_t nr_pages_avail;
> +	gfn_t nr_pages_avail = 0;
>  	int r = start_gfn <= end_gfn ? 0 : -EINVAL;
>  
>  	ghc->gpa = gpa;
> -- 
> 2.25.0.rc1.283.g88dfdc4193-goog
> 
