Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5855A45E1EA
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 22:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhKYVK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 16:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbhKYVIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 16:08:24 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B58C061748;
        Thu, 25 Nov 2021 13:05:09 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637874308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YNmPmUoFAxppOmBMYLIuVqNX0F602oVcaNqwhbaiy3w=;
        b=Tn/FIXi09j4ilV5LHyGKcmCOym19CT7NJno5pR+DNNM7F1p5ld/DRVpXecO5863YhmwFCh
        wrir6Iui24FgfwmSTxz0FeixrHJZLihtQEiM2kZnKgBd1qZPw35KcgOlEC8vrMP6/xJ111
        0F/lARlqjJg6C24vuStz8wJEfPaFV4cX+NOEK8EdsGNS8pcw8hH9p60dALOWxQmPQuJC+2
        4bj8Do2u5FR/9qcAhrprx6wXYvOdQFv5yrLL7MQQ30zY2sL4IjqKVyzWy57BAytI3s/cFK
        ZrPGNO71+t0pEatqjdSFJKRHJNdEsa10KiHtqEDCRrBZChuQKd62tCcVQVGpIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637874308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YNmPmUoFAxppOmBMYLIuVqNX0F602oVcaNqwhbaiy3w=;
        b=ygoL6+hsUkV5ODhLi1TowwlyURPzmHTdByQx3+54q/C3yWGUvwrKJGbKveRx3DUtwaenzb
        LmRBVtkL5+X3yABA==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 54/59] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
In-Reply-To: <5ba3573c8b82fcbdc3f3994f6d4d2a3c40445be9.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <5ba3573c8b82fcbdc3f3994f6d4d2a3c40445be9.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 22:05:07 +0100
Message-ID: <875ysghrp8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> Introduce a per-vm variable initial_tsc_khz to hold the default tsc_khz
> for kvm_arch_vcpu_create().
>
> This field is going to be used by TDX since TSC frequency for TD guest
> is configured at TD VM initialization phase.

So now almost 50 patches after exporting kvm_io_bus_read() I have
finally reached the place which makes use of it. But that's just a minor
detail compared to this:

>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/vmx/tdx.c          | 2233 +++++++++++++++++++++++++++++++

Can you pretty please explain how this massive pile of code is related
to the subject line and the change log of this patch?

It takes more than 2000 lines of code to add a new member to struct
kvm_arch?

Seriously? This definitely earns an award for the most disconnected
changelog ever.

>  arch/x86/kvm/x86.c              |    3 +-
>  3 files changed, 2236 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kvm/vmx/tdx.c
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 17d6e4bcf84b..f10c7c2830e5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1111,6 +1111,7 @@ struct kvm_arch {
>  	u64 last_tsc_write;
>  	u32 last_tsc_khz;
>  	u64 last_tsc_offset;
> +	u32 initial_tsc_khz;
>  	u64 cur_tsc_nsec;
>  	u64 cur_tsc_write;
>  	u64 cur_tsc_offset;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> new file mode 100644
> index 000000000000..64b2841064c4

< SNIP>

Yes, the above would be the patch which would be expected according to
the changelog and the subject line.

And no. Throwing a 2000+ lines patch over the fence which builds up the
complete infrastructure for TDX in KVM is not how that works. This patch
(aside of the silly changelog) is an unreviewable maze.

So far in this series, there was a continuous build up of infrastructure
in reviewable chunks and then you expect a reviewer to digest 2000+
lines at once for no reason and with the most disconneted changelog
ever?

This can be done structured and gradually, really.

     1) Add the basic infrastructure

     2) Add functionality piece by piece

There is no fundamental dependency up to the point where you enable TDX,
but there is a fundamental difference of reviewing 2000+ lines of code
at once or reviewing a gradual build up of 2000+ lines of code in small
pieces with proper changelogs for each of them.

You can argue that my request is unreasonable until you are blue in
your face, it's not going to lift my NAK on this.

I've mopped up enough half baken crap in x86/kvm over the years and I
have absolutely no interest at all to mop up after you again.

x86/kvm is not a special part of the kernel and neither exempt from
general kernel process nor from x86 specific scrunity rules.

That said, I'm stopping the review right here simply because looking at
any further changes does not make any sense at all.

Thanks,

        tglx
