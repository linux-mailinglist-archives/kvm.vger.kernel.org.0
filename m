Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6182ACFBF
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 07:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbgKJGcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 01:32:01 -0500
Received: from mail.skyhub.de ([5.9.137.197]:33612 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730520AbgKJGcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 01:32:00 -0500
Received: from nazgul.tnic (unknown [78.130.214.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1884B1EC036E;
        Tue, 10 Nov 2020 07:31:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1604989919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=DbPzFD8ocADSeV0o8zIHgtkE0g19VhGWZQrcUWattEg=;
        b=NF7Hb8OOJrdOKerg7Qh7vYnZk0Yhj5SSyahwpktISeLTD33gEccKEuaoh26lnk6cBRcDWl
        qFqM7Zy8363qpSYHk64rOlcre49J0n4nGdKIxH4Qk82DQv4s9izB8+WuigLDA1d2W258gM
        ibxzwfEm+hPuO5+euAZ335R3wucO/dQ=
Date:   Tue, 10 Nov 2020 07:31:51 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, x86 <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/mce: Check for hypervisor before enabling additional
 error logging
Message-ID: <20201110063151.GB7290@nazgul.tnic>
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
 <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 03:24:02PM -0800, Luck, Tony wrote:
> Booting as a guest under KVM results in error messages about
> unchecked MSR access:
> 
> [    6.814328][    T0] unchecked MSR access error: RDMSR from 0x17f at rIP: 0xffffffff84483f16 (mce_intel_feature_init+0x156/0x270)
> 
> because KVM doesn't provide emulation for random model specific registers.
> 
> Check for X86_FEATURE_HYPERVISOR and skip trying to enable the mode (a
> guest shouldn't be concerned with corrected errors anyway).
> 
> Reported-by: Qian Cai <cai@redhat.com>
> Fixes: 68299a42f842 ("x86/mce: Enable additional error logging on certain Intel CPUs")
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mce/intel.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
> index b47883e364b4..7f7d863400b7 100644
> --- a/arch/x86/kernel/cpu/mce/intel.c
> +++ b/arch/x86/kernel/cpu/mce/intel.c
> @@ -517,6 +517,9 @@ static void intel_imc_init(struct cpuinfo_x86 *c)
>  {
>  	u64 error_control;
>  
> +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> +		return;
> +

Frankly, I'm tired of wagging the dog because the tail can't. If
qemu/kvm can't emulate a CPU model fully then it should ignore those
unknown MSR accesses by default, i.e., that "ignore_msrs" functionality
should be on by default I'd say...

We certainly can't be sprinkling this check everytime the kernel tries
to do something as basic as read an MSR.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
