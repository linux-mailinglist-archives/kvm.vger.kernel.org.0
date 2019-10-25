Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB13E516D
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440697AbfJYQjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 12:39:05 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53250 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387769AbfJYQjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 12:39:05 -0400
Received: from zn.tnic (p200300EC2F0D3C00114ACBE854FF623C.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:3c00:114a:cbe8:54ff:623c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E83AA1EC0CEB;
        Fri, 25 Oct 2019 18:39:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1572021544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9whrUKOu/cQM6js+s/XPN62a2gFnvwagzZcPuYNVrk=;
        b=FHMFRg+IKlqz+vo4lJnYkEH+QlYYbu/1XsG3KckzzQoCa7hIJRA7rEnZdV9MAxpP5kNLJa
        TNeyt8s/z0vMa0B1fcRl8s7eNyuKmO7s+sZGvL6fH3A8kC4AcakBR750javHqNpdkOqywE
        vjbglTo0umB6pJB3jNXzqCBCVSV8ghE=
Date:   Fri, 25 Oct 2019 18:38:58 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 06/16] x86/cpu: Clear VMX feature flag if VMX is not
 fully enabled
Message-ID: <20191025163858.GF6483@zn.tnic>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000836.1907-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191022000836.1907-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 05:08:36PM -0700, Sean Christopherson wrote:
> Now that the IA32_FEATURE_CONTROL MSR is guaranteed to be configured and
> locked, clear the VMX capability flag if the IA32_FEATURE_CONTROL MSR is
> not supported or if BIOS disabled VMX, i.e. locked IA32_FEATURE_CONTROL
> and did not set the appropriate VMX enable bit.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/feature_control.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/feature_control.c b/arch/x86/kernel/cpu/feature_control.c
> index 57b928e64cf5..74c76159a046 100644
> --- a/arch/x86/kernel/cpu/feature_control.c
> +++ b/arch/x86/kernel/cpu/feature_control.c
> @@ -7,13 +7,19 @@
>  
>  void init_feature_control_msr(struct cpuinfo_x86 *c)
>  {
> +	bool tboot = tboot_enabled();
>  	u64 msr;
>  
> -	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr))
> +	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr)) {
> +		if (cpu_has(c, X86_FEATURE_VMX)) {
> +			pr_err_once("x86/cpu: VMX disabled, IA32_FEATURE_CONTROL MSR unsupported\n");
				     ^^^^^^^^

pr_fmt

But, before that: do we really wanna know about this or there's nothing
the user can do? If she can reenable VMX in the BIOS, or otherwise do
something about it, maybe we should say that above... Otherwise, this
message is useless.

> +			clear_cpu_cap(c, X86_FEATURE_VMX);
> +		}
>  		return;
> +	}
>  
>  	if (msr & FEATURE_CONTROL_LOCKED)
> -		return;
> +		goto update_caps;
>  
>  	/*
>  	 * Ignore whatever value BIOS left in the MSR to avoid enabling random
> @@ -23,8 +29,19 @@ void init_feature_control_msr(struct cpuinfo_x86 *c)
>  
>  	if (cpu_has(c, X86_FEATURE_VMX)) {
>  		msr |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
> -		if (tboot_enabled())
> +		if (tboot)
>  			msr |= FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX;
>  	}
>  	wrmsrl(MSR_IA32_FEATURE_CONTROL, msr);
> +
> +update_caps:
> +	if (!cpu_has(c, X86_FEATURE_VMX))
> +		return;

If this test is just so we can save us the below code, I'd say remove it
for the sake of having less code in that function. The test is cheap and
not on a fast path so who cares if we clear an alrady cleared bit. But
maybe this evolves in the later patches...

> +
> +	if ((tboot && !(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX)) ||
> +	    (!tboot && !(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX))) {
> +		pr_err_once("x86/cpu: VMX disabled by BIOS (TXT %s)\n",
> +			    tboot ? "enabled" : "disabled");
> +		clear_cpu_cap(c, X86_FEATURE_VMX);
> +	}
>  }

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
