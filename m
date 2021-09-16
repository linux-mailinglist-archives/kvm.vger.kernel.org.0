Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57BA40ECB6
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 23:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhIPVjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 17:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbhIPVjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 17:39:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C65C061574
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 14:37:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v2so4769128plp.8
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 14:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HRmclIUd+IXQYZmIP/8HeB41v2sSRX/lMU3hqPZHzVc=;
        b=Y5uK5usJpzBqYTtETIZzqzrlpEcCGhV1j72nBokzqPxRHfzfqcv9p8/VHqtByMLMa0
         7qnKk2mXRWZ/QVGLWlLUF5fmAtrANk6SVsEq1yvp8Onbj0l+EW2VdhbQ4ssaqq3XvXG+
         UIKM1VSQcdm2YELLCqHTNz0YRbJwYR+FmuDGCbuEaAumq4dsS2jCwrqpahV4jYDPFBXn
         +EFOprbkB9HNvtLDp/UkAPEYfLhp0RIxcvNz5Sev+mrGTECnwFfzaEXBv/uyDuKWSXl9
         MKEl69zQIthFjeiLPFYtD50iSHjTDfTtVEJ8PfVuNwd6e3VXHqiBdyMOjirUU+xrvFcM
         TwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HRmclIUd+IXQYZmIP/8HeB41v2sSRX/lMU3hqPZHzVc=;
        b=hZP7qcyGNKt3LoMaAso2M/9IhsYH4UkhVivpNgt/U3kxEVbnxdQx3E8UgrcTWysNtm
         GpqddYvkyW+uR21XtcLrObv6MbfvWXaRn5JjDQWUDFSkKTf9piCN22aFAFSbXo/ewUgf
         DEn9zjL2fsZEw0R7SWvrg6TJvXNZ37Kbl/+AfhX5ActNTySvjPKE0iWDm6wUec8xtfyR
         dXmb6P2HBysdUiZ1kpVZdiIIlL0wUSzsQl63vNvFSCizylqBHyEuMq/OsJ2LmNE4rYDg
         /yvdLWMHst3sB/78Ak6fnXMmfDFn6esNT8J4qPHXOS/4oKmkElTQYsdu/DBMhQAF5T4T
         ak5Q==
X-Gm-Message-State: AOAM5302D9oKMfuLDjR9sTuXHNeLV16piNVab8R936jAP2XjgQ7NTI0h
        oXjaOP1l5Sn1MbZE5GJw+cvhyQ==
X-Google-Smtp-Source: ABdhPJxrNs7jIZy34jmkRTyON4Y+9pNnsbkx7GECTLo7e1rXLwAWohi0Xxo5Jb11PEVRFoL9wO4HSQ==
X-Received: by 2002:a17:90b:1291:: with SMTP id fw17mr6609537pjb.135.1631828268138;
        Thu, 16 Sep 2021 14:37:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t15sm4013977pgk.13.2021.09.16.14.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 14:37:47 -0700 (PDT)
Date:   Thu, 16 Sep 2021 21:37:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH v2 00/13] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <YUO5J/jTMa2KGbsq@google.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828201336.GD4353@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828201336.GD4353@worktop.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 28, 2021, Peter Zijlstra wrote:
> On Fri, Aug 27, 2021 at 05:35:45PM -0700, Sean Christopherson wrote:
> > Like Xu (2):
> >   perf/core: Rework guest callbacks to prepare for static_call support
> >   perf/core: Use static_call to optimize perf_guest_info_callbacks
> > 
> > Sean Christopherson (11):
> >   perf: Ensure perf_guest_cbs aren't reloaded between !NULL check and
> >     deref
> >   KVM: x86: Register perf callbacks after calling vendor's
> >     hardware_setup()
> >   KVM: x86: Register Processor Trace interrupt hook iff PT enabled in
> >     guest
> >   perf: Stop pretending that perf can handle multiple guest callbacks
> >   perf: Force architectures to opt-in to guest callbacks
> >   KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu
> >     variable
> >   KVM: x86: More precisely identify NMI from guest when handling PMI
> >   KVM: Move x86's perf guest info callbacks to generic KVM
> >   KVM: x86: Move Intel Processor Trace interrupt handler to vmx.c
> >   KVM: arm64: Convert to the generic perf callbacks
> >   KVM: arm64: Drop perf.c and fold its tiny bits of code into arm.c /
> >     pmu.c

Argh, sorry, I somehow managed to miss all of your replies.  I'll get back to
this series next week.  Thanks for the quick response!

> Lets keep the whole intel_pt crud inside x86...

In theory, I like the idea of burying intel_pt inside x86 (and even in Intel+VMX code
for the most part), but the actual implementation is a bit gross.  Because of the
whole "KVM can be a module" thing, either the static call and __static_call_return0
would need to be exported, or a new register/unregister pair would have to be exported.

The unregister path would also need its own synchronize_rcu().  In general, I
don't love duplicating the logic, but it's not the end of the world.

Either way works for me.  Paolo or Peter, do either of you have a preference?

> ---
> Index: linux-2.6/arch/x86/events/core.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/events/core.c
> +++ linux-2.6/arch/x86/events/core.c
> @@ -92,7 +92,7 @@ DEFINE_STATIC_CALL_RET0(x86_pmu_guest_ge
>  
>  DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
>  DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
> -DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
> +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, unsigned int (*)(void));

FWIW, the param needs to be a raw function, not a function pointer. 
