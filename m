Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE2654DFE3
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 13:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376623AbiFPLTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 07:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiFPLTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 07:19:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542E75C766;
        Thu, 16 Jun 2022 04:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nXUsXgY5i7Ezqqhvun+T3Zy77Nd5fHsC/2wg/MAxPB8=; b=umvO/C5CkeaRRXsHsov5abbjK/
        Lpz0GWJn3PgOlQz6CdJ4fZOOFVKAvKY9Yut6QJqpY5zlVclBvE5vX3TKpDF4joPwDxJiFt1H4yQjB
        o+bVXG0YtLKDHDt7vaoLpLws1c0ni0HBem1gH4AmAA/KZc1xNhdf/nrxuhOOqAOm9Wd+LABU33yoN
        M1x6C/4J75NZjqKzo9JheGb19976ElPw9WrjGAXTitYiJFnml3KK9qOjOJ1exYZTbwjsL9mLe8kho
        tGjjoQEeqiCSlDOJxtt4sBAaspCwyT8HIt4IYGQKfTiTOEPVBttcrbKUgL2Dcj9Fsg42nlrHSR1NX
        n6hdcXsw==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1nWy-001teM-JH; Thu, 16 Jun 2022 11:19:20 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 95744980DD0; Thu, 16 Jun 2022 13:19:18 +0200 (CEST)
Date:   Thu, 16 Jun 2022 13:19:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Subject: Re: [PATCH 19/19] KVM: x86: Enable supervisor IBT support for guest
Message-ID: <YqsRttmgmbthHWVR@worktop.programming.kicks-ass.net>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <20220616084643.19564-20-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616084643.19564-20-weijiang.yang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 04:46:43AM -0400, Yang Weijiang wrote:
> Mainline kernel now supports supervisor IBT for kernel code,
> to make s-IBT work in guest(nested guest), pass through
> MSR_IA32_S_CET to guest(nested guest) if host kernel and KVM
> enabled IBT. Note, s-IBT can work independent to host xsaves
> support because guest MSR_IA32_S_CET can be stored/loaded from
> specific VMCS field.


> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe049d0e5ecc..c0118b33806a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1463,6 +1463,7 @@ static const u32 msrs_to_save_all[] = {
>  	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
>  	MSR_IA32_XSS,
>  	MSR_IA32_U_CET, MSR_IA32_PL3_SSP, MSR_KVM_GUEST_SSP,
> +	MSR_IA32_S_CET,
>  };


So much like my local kvm/qemu hacks; this patch suffers the problem of
not exposing S_SHSTK. What happens if a guest tries to use that?

Should we intercept and reject setting those bits or complete this patch
and support full S_SHSTK? (with all the warts and horrors that entails)

I don't think throwing this out in this half-finished state makes much
sense (which is why I never much shared my hacks).


> @@ -11830,7 +11835,13 @@ int kvm_arch_hardware_setup(void *opaque)
>  	/* Update CET features now as kvm_caps.supported_xss is finalized. */
>  	if (!kvm_cet_user_supported()) {
>  		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> -		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		/* If CET user bit is disabled due to cmdline option such as
> +		 * noxsaves, but kernel IBT is on, this means we can expose
> +		 * kernel IBT alone to guest since CET user mode msrs are not
> +		 * passed through to guest.
> +		 */

Invalid multi-line comment style.

> +		if (!cet_kernel_ibt_supported())
> +			kvm_cpu_cap_clear(X86_FEATURE_IBT);
