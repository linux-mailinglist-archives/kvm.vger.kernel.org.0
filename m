Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10FF2EFCA6
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 02:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbhAIBUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 20:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAIBUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 20:20:22 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE871C061573;
        Fri,  8 Jan 2021 17:19:41 -0800 (PST)
Received: from zn.tnic (p200300ec2f0a31002d28d593016b8c5a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:3100:2d28:d593:16b:8c5a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5A9361EC04CC;
        Sat,  9 Jan 2021 02:19:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610155180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=CFrCvmLh0QxnlTvwTjbIqnbyBw3zF45rv41UWBEPge4=;
        b=CHOdcpFV+4hQLdWlyX8mGglWpXyY1OIll7sXvcqTg/5IcMGJYFgGP7ZbA+104ipzhSilLu
        tO52tDZqZrP0NmD6CBY/1vccbu6EhOZfDxGONVTbNxOZ0lqjWDNb1ftw4YLtTqKZ+AKpp5
        xCaDqCs4za1JDhVLQqlmkmiP6YGENP8=
Date:   Sat, 9 Jan 2021 02:19:39 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210109011939.GL4042@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
 <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
 <20210106221527.GB24607@zn.tnic>
 <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
 <20210107064125.GB14697@zn.tnic>
 <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X/jxCOLG+HUO4QlZ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 08, 2021 at 03:55:52PM -0800, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index dc921d76e42e..21f92d81d5a5 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -7,7 +7,25 @@
>  #include <asm/processor.h>
>  #include <uapi/asm/kvm_para.h>
> 
> -extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
> +/*
> + * Hardware-defined CPUID leafs that are scattered in the kernel, but need to
> + * be directly by KVM.  Note, these word values conflict with the kernel's
> + * "bug" caps, but KVM doesn't use those.

This feels like another conflict waiting to happen if KVM decides to use
them at some point...

So let me get this straight: KVM wants to use X86_FEATURE_* which
means, those numbers must map to the respective words in its CPUID caps
representation kvm_cpu_caps, AFAICT.

Then, it wants the leafs to correspond to the hardware leafs layout so
that it can do:

	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);

which comes straight from CPUID.

So lemme look at one word:

        kvm_cpu_cap_mask(CPUID_1_EDX,
                F(FPU) | F(VME) | F(DE) | F(PSE) |
                F(TSC) | F(MSR) | F(PAE) | F(MCE) |
		...


it would build the bitmask of the CPUID leaf using X86_FEATURE_* bits
and then mask it out with the hardware leaf read from CPUID.

But why?

Why doesn't it simply build those leafs in kvm_cpu_caps from the leafs
we've already queried?

Oh it does so a bit earlier:

        memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
               sizeof(kvm_cpu_caps));

and that kvm_cpu_cap_mask() call is to clear some bits in kvm_cpu_caps
which is kvm-specific thing (not supported stuff etc).

But then why does kvm_cpu_cap_mask() does cpuid_count()? Didn't it just
read the bits from boot_cpu_data.x86_capability? And those bits we do
query and massage extensively during boot. So why does KVM needs to
query CPUID again instead of using what we've already queried?

Maybe I'm missing something kvm-specific.

In any case, this feels somewhat weird: you have *_cpu_has() on
baremetal abstracting almost completely from CPUID by collecting all
feature bits it needs into its own structure - x86_capability[] along
with accessors for it - and then you want to "abstract back" to CPUID
leafs from that interface. I wonder why.

Anyway, more questions tomorrow.

Gnight and good luck. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
