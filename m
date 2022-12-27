Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC6665699C
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 11:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiL0KwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 05:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiL0KwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 05:52:05 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E548AA479;
        Tue, 27 Dec 2022 02:52:02 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 262641EC02FE;
        Tue, 27 Dec 2022 11:52:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672138321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7wsM9e/T5jFmAKOSFCalMkh4dI5J+2K4eCkXRgsYmo8=;
        b=C+4r1rC5FKIlTfYqTx3bdvejoL3qLxrMNBIyYEuO3uBoFG22UeJfL25ny1lFyFMDG0mxaH
        bkFGlloegp21piRKOmH03lLE4GVVoJ3BYxx5+qlBbzJDYRmfjLfw6eGHU/eGsExFzPeklb
        9vImevDL8aT0AYPt2Zse5Kk+mj3ko7s=
Date:   Tue, 27 Dec 2022 11:51:56 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@amd.com>,
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
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/7] x86/cpu: Make X86_FEATURE_LFENCE_RDTSC a
 scattered feature bit
Message-ID: <Y6rOTM6Q7AZekpoc@zn.tnic>
References: <20221205233235.622491-1-kim.phillips@amd.com>
 <20221205233235.622491-4-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221205233235.622491-4-kim.phillips@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022 at 05:32:31PM -0600, Kim Phillips wrote:
> It's a part of the CPUID 0x80000021 leaf, and will be grouped
> with other feature bits to being propagated via kvm_set_cpu_caps()
> instead of open-coding them in __do_cpuid_func().
> 
> Unlike the other CPUID 0x80000021 EAX feature bits,
> X86_FEATURE_LFENCE_RDTSC already had an entry in cpufeatures.h.
> 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  arch/x86/kernel/cpu/scattered.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
> index d0734cc19d37..caa03466cd9e 100644
> --- a/arch/x86/kernel/cpu/scattered.c
> +++ b/arch/x86/kernel/cpu/scattered.c
> @@ -46,6 +46,7 @@ static const struct cpuid_bit cpuid_bits[] = {
>  	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
>  	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
>  	{ X86_FEATURE_NO_NESTED_DATA_BP,CPUID_EAX,  0, 0x80000021, 0 },
> +	{ X86_FEATURE_LFENCE_RDTSC,	CPUID_EAX,  2, 0x80000021, 0 },

Hmm, so this patchset keeps growing and growing with new bits.

Perhaps my initial suggestion to make it a scattered one doesn't make
a whole lot of sense anymore.

/me goes and looks at CPUID_Fn80000021_EAX [Extended Feature 2 EAX] (Core::X86::Cpuid::FeatureExt2Eax)

Yah, judging by what's there in that leaf, we are likely to use a lot
more bits in the future I think you should go back to

https://lore.kernel.org/lkml/20221104213651.141057-2-kim.phillips@amd.com/

But please state in that commit message that the majority of the feature
bits in CPUID_Fn80000021_EAX will be used in the kernel and thus a
separate leaf makes sense.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
