Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2E1637977
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiKXM6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiKXM6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:58:06 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CB82EF43;
        Thu, 24 Nov 2022 04:57:59 -0800 (PST)
Received: from zn.tnic (p200300ea9733e75b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e75b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A7FA01EC0495;
        Thu, 24 Nov 2022 13:57:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669294677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XS1Zj+fDTSMukHO6d5oREAO1GUpF937b38YW4uIlrPA=;
        b=eujz4I/2hdVKKFYVtLJwqYg8iDfZDv2AvM+cA0Tw+bL86B0iQPrTvM5B6H65Z7+YylM7YL
        ubDUL3l9D1eMe64NUMJOE6cwZGS6d4s4/VgZxAtwbC3PSit2fs5QawUq4Z13kM8+bQBnNf
        fmWxy//AJzEcOSnS/BggzWnBR+HOB+8=
Date:   Thu, 24 Nov 2022 13:57:54 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/cpu, kvm: Use CPU capabilities for
 CPUID[0x80000021].EAX
Message-ID: <Y39qUnlRx05eaGeb@zn.tnic>
References: <20221124000449.79014-1-kim.phillips@amd.com>
 <20221124000449.79014-2-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221124000449.79014-2-kim.phillips@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 06:04:48PM -0600, Kim Phillips wrote:
> The AMD Zen4 Automatic IBRS feature bit resides in the 0x80000021 leaf,
> for which there is already support for exposing Zen3 bits to the guest.
> 
> Add AMD AutoIBRS feature bit support, including for the other bits,
> using scattered/synthetic bits.
> 
> Add the corresponding word to KVM's feature machinery so that AutoIBRS
> gets advertized into the guest too.
> 
> Co-developed-by: Babu Moger <Babu.Moger@amd.com>

verify_tags: WARNING: Co-developed-by Babu Moger <Babu.Moger@amd.com> hasn't signed off on the patch!

> Co-developed-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

...

> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c92c49a0b35b..61cd33a848cc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -730,6 +730,25 @@ void kvm_set_cpu_caps(void)
>  		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
>  		F(SME_COHERENT));
>  
> +	/*
> +	 * Pass down these bits:
> +	 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
> +	 *    EAX      2      LAS, LFENCE always serializing
> +	 *    EAX      6      NSCB, Null selector clear base
> +	 *    EAX      8      Automatic IBRS
> +	 *
> +	 * Other defined bits are for MSRs that KVM does not expose:
> +	 *   EAX      3      SPCL, SMM page configuration lock
> +	 *   EAX      13     PCMSR, Prefetch control MSR
> +	 */
> +	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX,
> +				   SF(NO_NESTED_DATA_BP) | SF(LFENCE_RDTSC) |
> +				   SF(NULL_SEL_CLR_BASE) | SF(AUTOIBRS));
> +	if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
> +		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
> +	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
> +		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);

So this looks backwards:

if X86_FEATURE_NULL_SEL_CLR_BASE is set, then X86_BUG_NULL_SEG should
not be.

Which means, you'd have to update check_null_seg_clears_base() too.

Which means, you should make the X86_FEATURE_NULL_SEL_CLR_BASE bit
addition a separate patch because this one is clearly doing too many
things at once.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
