Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8876678D2A
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 02:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjAXBO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 20:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjAXBO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 20:14:57 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1E46E90
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:14:56 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id a18so701444plm.2
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=70xdsOEHAveqye/Jur5if/nOX8gXKvDXgJeMv3ZrfA4=;
        b=mkjxM6wwi/KTaBjYdQqu7iDPLKbJWQMh+nAD6L9YOIM7lqJ8aPLDFLzuOjPX8nMzAK
         lbYsoX14WtWmR2c//JOwqiMxoy8FzGzKtWRkXw43o9AYW8L4GCkx2LoXGrjN4IsEmRcW
         8E4+f8UcQGLrP6ZyjXvR2Di+hm/hm8+SWQVvU/pBtautyucKzVkpA6ZNmFQiq/E35hZy
         NPM1dRWrJY3DFfjcvWWZ0S1JpvCON5ArMcqvkYJW2uABw9IDa2YT4lkMOo4EhUvCOBrD
         V1pNyXiMsiNXVYO8q44g815MMYIU/Cz77Kh2i6hAmEehUv575E3rDImHYgCVEnpHo4Fc
         GbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=70xdsOEHAveqye/Jur5if/nOX8gXKvDXgJeMv3ZrfA4=;
        b=bMZoF424hG7UX5XQ0cQJLkJp1DoH7TTCqyVmErpa+Iq7SITnQ4ioq5g9EsnkCEK8JY
         M17UeC0BRZApNGQYJcBVmxNxfypdwdNx6dcsCbrfYHk8q82ZnOp86Bi+a0ey32VhJ1Lk
         9PpQY9Qb/uR8oreL1yZp4IhJkKpOMiRPD72Gkp8bsKNCIVoED5SHxsqHJ2Ff6exX8oPv
         8ve5M+akZXB4aUJ4C/N8jzpJTW769PL3mmxrzL5KiEMUW7f2maMXh9HOn99UxS9m5aJe
         Q0YE6Q3kxvF/eQMV5g6PYGex/69OJu9UBO4QT8/AzHqVxE5wlL/RjJXovZb/FLlqrqST
         K1Og==
X-Gm-Message-State: AO0yUKXUn8rrKMcv8wR/e4aXU7mCtUc+dOrrScpX4Bxev5YVIyB2fCPu
        B3RBfih5WbrUF64aATwIL2iv8w==
X-Google-Smtp-Source: AK7set/x3Ypl61MzTS/rqvKmF2ePi9547FHE+Ei0q/V919hGCzgGRyzY1k/iXxGxOOrwrbEBTFI2CQ==
X-Received: by 2002:a17:902:9894:b0:189:b910:c6d2 with SMTP id s20-20020a170902989400b00189b910c6d2mr3688plp.1.1674522895863;
        Mon, 23 Jan 2023 17:14:55 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ij18-20020a170902ab5200b001947982eb8fsm346525plb.60.2023.01.23.17.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:14:55 -0800 (PST)
Date:   Tue, 24 Jan 2023 01:14:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/8] x86/cpu, kvm: Move open-coded cpuid leaf
 0x80000021 EAX bit propagation code
Message-ID: <Y88xDAhW+hiMeWSU@google.com>
References: <20230123225700.2224063-1-kim.phillips@amd.com>
 <20230123225700.2224063-3-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123225700.2224063-3-kim.phillips@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, shortlog for this should be

  KVM: x86:

since this touches only KVM code.

On Mon, Jan 23, 2023, Kim Phillips wrote:
> Move code from __do_cpuid_func() to kvm_set_cpu_caps() in preparation
> for adding the features in their native leaf.

Huh, this wasn't why I was expecting, but this is better than what I had in mind.
Moving everything all at once wouldn't work well because of the kernel dependencies.

> Also drop the bit description comments as it will be more self-
> describing once the individual features are added.
> 
> Whilst there, switch to using the more efficient cpu_feature_enabled()
> instead of static_cpu_has().

One more nit/request.  Can you add a blurb about the synthetic features?  That
part is easy to miss and will be confusing after the fact.  E.g.

 Note, LFENCE_RDTSC and "NULL selector clears base" are is currently
 synthetic, Linux-defined feature flags as Linux tracking of the features
 predates AMD's definition.  Keep the manual propagation of the flags from
 their synthetic counterparts until the kernel fully converts to AMD's
 definition, otherwise KVM would  stop synthesizing the flags as intended.
 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  arch/x86/kvm/cpuid.c | 30 +++++++++++-------------------
>  1 file changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 596061c1610e..3930452bf06e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -741,6 +741,16 @@ void kvm_set_cpu_caps(void)
>  		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
>  		F(SME_COHERENT));
>  
> +	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
> +		BIT(0) /* NO_NESTED_DATA_BP */ | 0 /* SmmPgCfgLock */ |

Uber nit, to make this a bit closer to pure code movement, this should include
BIT(2) as well.  Mainly because BIT(6) is also kept even though it too may be
synthesized by KVM.

> +		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
> +	);
> +	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
> +		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(2) /* LFENCE Always serializing */;
> +	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
> +		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
> +	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
> +
>  	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
>  		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
>  		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
