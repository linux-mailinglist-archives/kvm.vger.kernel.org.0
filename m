Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9671E470E25
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 23:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344707AbhLJWsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 17:48:03 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51380 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239783AbhLJWsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 17:48:03 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639176266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sCD67XmQfgY8eyF5DZcnmqHIPLmPlcqEXhs2oDwpWCg=;
        b=ctjp83lJ0t5QRjhSmgNytxwBVaFdLPzVATqaVRk0SmbeGdG+g+YMd9SNG5kaVgczOOhD1g
        06GayrOEfvSpZUYsKM+OX/lJ1D4kGdVZmTa7Icco9W9edAL5yP1Xx4FvKVKkcI/YgsmaZB
        l+Tjp49NY359JqJk/56lF1EWqPZyUAGXITBRyR+6m2ZroaNLAf3t4WPKl1mYWxvdeIZBRh
        I/5a6rvarEayPX6R9OXP/KuEyEUGQPYc/RAb8a8l33Se43IDpyZdoAiq6rLWf20jS9U3Ns
        yD+Z0OYEZu6OAyzW/e1LsL3LT1NMb2a6r5tF1fmMdm2h7tsygwCX+SH9TizSFQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639176266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sCD67XmQfgY8eyF5DZcnmqHIPLmPlcqEXhs2oDwpWCg=;
        b=OU3jl0IQfp2L2rQsO2mronFCWcYYmWoPyLDNmqYrH1+BkgR2SQR3Gi8gQ/kh7Qj+B3JXgN
        y+3sxUVnVm7ARVBg==
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 08/19] x86/fpu: Move xfd_update_state() to xstate.c and
 export symbol
In-Reply-To: <20211208000359.2853257-9-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-9-yang.zhong@intel.com>
Date:   Fri, 10 Dec 2021 23:44:25 +0100
Message-ID: <874k7gxepi.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07 2021 at 19:03, Yang Zhong wrote:
> From: Jing Liu <jing2.liu@intel.com>
>
> xfd_update_state() is the interface to update IA32_XFD and its per-cpu
> cache. All callers of this interface are currently in fpu core. KVM only
> indirectly triggers IA32_XFD update via a helper function
> (fpu_swap_kvm_fpstate()) when switching between user fpu and guest fpu.
>
> Supporting AMX in guest now requires KVM to directly update IA32_XFD
> with the guest value (when emulating WRMSR) so XSAVE/XRSTOR can manage
> XSTATE components correctly inside guest.
>
> This patch moves xfd_update_state() from fpu/xstate.h to fpu/xstate.c

s/This patch moves/Move/

please. See Documentation/process/submitting-patches.rst and search for
'This patch'

> and export it for reference outside of fpu core.
>
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> ---
>  arch/x86/include/asm/fpu/api.h |  2 ++
>  arch/x86/kernel/fpu/xstate.c   | 12 ++++++++++++
>  arch/x86/kernel/fpu/xstate.h   | 14 +-------------
>  3 files changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
> index 7532f73c82a6..999d89026be9 100644
> --- a/arch/x86/include/asm/fpu/api.h
> +++ b/arch/x86/include/asm/fpu/api.h
> @@ -131,8 +131,10 @@ DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
>  /* Process cleanup */
>  #ifdef CONFIG_X86_64
>  extern void fpstate_free(struct fpu *fpu);
> +extern void xfd_update_state(struct fpstate *fpstate);
>  #else
>  static inline void fpstate_free(struct fpu *fpu) { }
> +static void xfd_update_state(struct fpstate *fpstate) { }

Try a 32bit build to see the warnings this causes. That wants to be
'static inline void' obviously.

>  #ifdef CONFIG_X86_64
> -static inline void xfd_update_state(struct fpstate *fpstate)
> -{
> -	if (fpu_state_size_dynamic()) {
> -		u64 xfd = fpstate->xfd;
> -
> -		if (__this_cpu_read(xfd_state) != xfd) {
> -			wrmsrl(MSR_IA32_XFD, xfd);
> -			__this_cpu_write(xfd_state, xfd);
> -		}
> -	}
> -}
> -#else
> -static inline void xfd_update_state(struct fpstate *fpstate) { }
> +extern void xfd_update_state(struct fpstate *fpstate);

Why? It's already declared in the global header. So all of this has to
be simply removed, no?

Thanks,

        tglx


