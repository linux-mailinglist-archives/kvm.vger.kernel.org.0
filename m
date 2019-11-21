Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB571056FA
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 17:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKUQZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 11:25:05 -0500
Received: from mail.skyhub.de ([5.9.137.197]:38198 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfKUQZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 11:25:05 -0500
Received: from zn.tnic (p200300EC2F0F070070C4546F98AAB214.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:700:70c4:546f:98aa:b214])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D21C71EC0CE8;
        Thu, 21 Nov 2019 17:24:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1574353500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oJS7So1/quisV3oFSM49q/CepXlYRGWbmLBtGCZ7d5s=;
        b=LzHiiVp2382hxBbqbtKGcmSvPxTGnIGDRNX0wfkbM1hwC4LKf0c4NeO+B1HWju62jNXxOK
        i2cUlInI5CkTHJCsbhJ1mmBPqQPeIhPfOygRM+/vevqcHC7tRsHHX1tWdAwD7nwDCl/lCg
        SoARFDBMzTv9wUhdI2Uid7Y95XbtQLA=
Date:   Thu, 21 Nov 2019 17:24:52 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-edac@vger.kernel.org,
        "linux-kselftest@vger.kernel.org, Jarkko Sakkinen" 
        <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 09/19] x86/cpu: Clear VMX feature flag if VMX is not
 fully enabled
Message-ID: <20191121162452.GJ6540@zn.tnic>
References: <20191119031240.7779-1-sean.j.christopherson@intel.com>
 <20191119031240.7779-10-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191119031240.7779-10-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 07:12:30PM -0800, Sean Christopherson wrote:
> Now that the IA32_FEATURE_CONTROL MSR is guaranteed to be configured and
> locked, clear the VMX capability flag if the IA32_FEATURE_CONTROL MSR is
> not supported or if BIOS disabled VMX, i.e. locked IA32_FEATURE_CONTROL
> and did not set the appropriate VMX enable bit.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/feature_control.c | 28 ++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/feature_control.c b/arch/x86/kernel/cpu/feature_control.c
> index 33c9444dda52..2bd1a9e6021a 100644
> --- a/arch/x86/kernel/cpu/feature_control.c
> +++ b/arch/x86/kernel/cpu/feature_control.c
> @@ -5,15 +5,26 @@
>  #include <asm/msr-index.h>
>  #include <asm/processor.h>
>  
> +#undef pr_fmt
> +#define pr_fmt(fmt)	"x86/cpu: " fmt
> +
> +#define FEAT_CTL_UNSUPPORTED_MSG "IA32_FEATURE_CONTROL MSR unsupported on VMX capable CPU, suspected hardware or hypervisor issue.\n"
> +
>  void init_feature_control_msr(struct cpuinfo_x86 *c)
>  {
> +	bool tboot = tboot_enabled();
>  	u64 msr;
>  
> -	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr))
> +	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr)) {
> +		if (cpu_has(c, X86_FEATURE_VMX)) {
> +			pr_err_once(FEAT_CTL_UNSUPPORTED_MSG);
> +			clear_cpu_cap(c, X86_FEATURE_VMX);
> +		}
>  		return;
> +	}

Right, so this test: is this something that could happen on some
configurations - i.e., the MSR is not there but VMX bit is set - or are
you being too cautious here?

IOW, do you have any concrete use cases in mind (cloud provider can f*ck
it up this way) or?

My angle is that if this is never going to happen, why even bother to
print anything...

>  	if (msr & FEAT_CTL_LOCKED)
> -		return;
> +		goto update_caps;
>  
>  	/*
>  	 * Ignore whatever value BIOS left in the MSR to avoid enabling random
> @@ -28,8 +39,19 @@ void init_feature_control_msr(struct cpuinfo_x86 *c)
>  	 */
>  	if (cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM)) {
>  		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> -		if (tboot_enabled())
> +		if (tboot)
>  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
>  	}
>  	wrmsrl(MSR_IA32_FEATURE_CONTROL, msr);
> +
> +update_caps:
> +	if (!cpu_has(c, X86_FEATURE_VMX))
> +		return;
> +
> +	if ((tboot && !(msr & FEAT_CTL_VMX_ENABLED_INSIDE_SMX)) ||
> +	    (!tboot && !(msr & FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX))) {

Align those vertically like this so that the check is grokkable at a
quick glance:

	if ( (tboot && !(msr & FEAT_CTL_VMX_ENABLED_INSIDE_SMX)) ||
	    (!tboot && !(msr & FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX))) {

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
