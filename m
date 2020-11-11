Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8113D2AFD55
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgKLBbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:31 -0500
Received: from audible.transient.net ([24.143.126.66]:54908 "HELO
        audible.transient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727480AbgKKW5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 17:57:20 -0500
Received: (qmail 12014 invoked from network); 11 Nov 2020 22:57:15 -0000
Received: from cucamonga.audible.transient.net (192.168.2.5)
  by canarsie.audible.transient.net with QMQP; 11 Nov 2020 22:57:15 -0000
Received: (nullmailer pid 3746 invoked by uid 1000);
        Wed, 11 Nov 2020 22:57:15 -0000
Date:   Wed, 11 Nov 2020 22:57:15 +0000
From:   Jamie Heilman <jamie@audible.transient.net>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: [PATCH] kvm: x86/mmu: Fix is_tdp_mmu_check when using PAE
Message-ID: <20201111225715.GA2910@audible.transient.net>
Mail-Followup-To: Ben Gardon <bgardon@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
        Zdenek Kaspar <zkaspar82@gmail.com>
References: <20201111185337.1237383-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111185337.1237383-1-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ben Gardon wrote:
> When PAE is in use, the root_hpa will not have a shadow page assoicated
> with it. In this case the kernel will crash with a NULL pointer
> dereference. Add checks to ensure is_tdp_mmu_root works as intended even
> when using PAE.

This seems to work in my amd64 case as well.
(https://marc.info/?l=linux-kernel&m=160494962201032&w=2)

> Tested: compiles
> 
> Fixes: 02c00b3a2f7e ("kvm: x86/mmu: Allocate and free TDP MMU roots")
> Reported-by: Zdenek Kaspar <zkaspar82@gmail.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 27e381c9da6c..13013f4d98ad 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -49,8 +49,18 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
>  {
>  	struct kvm_mmu_page *sp;
>  
> +	if (WARN_ON(!VALID_PAGE(hpa)))
> +		return false;
> +
>  	sp = to_shadow_page(hpa);
>  
> +	/*
> +	 * If this VM is being run with PAE, the TDP MMU will not be enabled
> +	 * and the root HPA will not have a shadow page associated with it.
> +	 */
> +	if (!sp)
> +		return false;
> +
>  	return sp->tdp_mmu_page && sp->root_count;
>  }
>  
> -- 
> 2.29.2.222.g5d2a92d10f8-goog
> 

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
