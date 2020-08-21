Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6511024D722
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 16:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgHUOPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 10:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgHUOPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 10:15:17 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0442CC061573;
        Fri, 21 Aug 2020 07:15:16 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id f75so1213794ilh.3;
        Fri, 21 Aug 2020 07:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xxeM5gPH8yu6tWCUWA1p+lgxDN3K/oRI20zeA1Ye/AM=;
        b=KnVRt/vE7Gs2dug2IuD45cFSjkQWwTvYY56745j/humEhcsfWutRa14n9MbdjyRi16
         mZZLqIG70csF2R8txo+gsW2/2WaMHQOI0THY6qEIBRaf0giypShRsTgqWXbaXfxtrqnS
         fEEVCqfrZ/eFL5WcG4dHc5CPLIRV5ri6J0xN3vtRXlcr5gCbrMLP27ZHCZG3eLNK4/Eo
         tWRwVWrVNBPQE7MOkz3fcC6slrgW3Yu47hfDJqiXAO73rhN6BDcYj9Ljg0oomPfxAfSu
         oKAL1ivvSUW4RikdrSu/1IIt4brxlfJdk7xqim9Pp1+C5z0EuS8Y2JIBQ69idqiCNpy/
         GQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xxeM5gPH8yu6tWCUWA1p+lgxDN3K/oRI20zeA1Ye/AM=;
        b=MC+TOoPhFXCXux77w0IKfNKNainSXUYIhOyGOZsdqTAj6vVHTYN0WfiAQlL2cPXNRz
         ChMITcqg6MTM8F+F7UgYNOJCWKitTt3Fvxpjm204IuGbcrnun9i569OHkJRRheUUpc7h
         C5DBE19Su5X9IVz56Ywm6Gko2Yhlselwwg6p478vwF0TCs/61/MheWKiDZU3sTkcnb+A
         49wKfkd1kEIHhORK/WKmCSRcFEbBpQIHjAQs9gjmnckMS5Meh16ecVgry6SJIy3AjWez
         26tyPQ+raYn5ph1tGzdpEsLGvWLZIr8ZGNYJNbmMd5fy7ouOWTGeOdVFktv5637NTDkf
         Q5dg==
X-Gm-Message-State: AOAM532ADP2bz0GGI7NVjeplD7cuGKcWctbgEccKAzSq7Vbcs72V5OKQ
        J6AGmNy2bWpavG1LedpTWW4Js8878R1p6WCAVA==
X-Google-Smtp-Source: ABdhPJyJUfcxBK680ROxAoGVyv9OizagGjY0D4DfMhVrIVx3Li6gsgsunS6nsQDGSkscpuaVtnT18ZdO0zasYN1N0vI=
X-Received: by 2002:a92:4f:: with SMTP id 76mr2608119ila.11.1598019313716;
 Fri, 21 Aug 2020 07:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200821105229.18938-1-pbonzini@redhat.com>
In-Reply-To: <20200821105229.18938-1-pbonzini@redhat.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Fri, 21 Aug 2020 10:15:02 -0400
Message-ID: <CAMzpN2ixJ_nWMdgnLf9zuDpvuJFZOepWtyX3bxg7OgMTW0j4pA@mail.gmail.com>
Subject: Re: [PATCH v2] x86/entry/64: Do not use RDPID in paranoid entry to
 accomodate KVM
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 6:56 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Don't use RDPID in the paranoid entry flow, as it can consume a KVM
> guest's MSR_TSC_AUX value if an NMI arrives during KVM's run loop.
>
> In general, the kernel does not need TSC_AUX because it can just use
> __this_cpu_read(cpu_number) to read the current processor id.  It can
> also just block preemption and thread migration at its will, therefore
> it has no need for the atomic rdtsc+vgetcpu provided by RDTSCP.  For this
> reason, as a performance optimization, KVM loads the guest's TSC_AUX when
> a CPU first enters its run loop.  On AMD's SVM, it doesn't restore the
> host's value until the CPU exits the run loop; VMX is even more aggressive
> and defers restoring the host's value until the CPU returns to userspace.
>
> This optimization obviously relies on the kernel not consuming TSC_AUX,
> which falls apart if an NMI arrives during the run loop and uses RDPID.
> Removing it would be painful, as both SVM and VMX would need to context
> switch the MSR on every VM-Enter (for a cost of 2x WRMSR), whereas using
> LSL instead RDPID is a minor blip.
>
> Both SAVE_AND_SET_GSBASE and GET_PERCPU_BASE are only used in paranoid entry,
> therefore the patch can just remove the RDPID alternative.
>
> Fixes: eaad981291ee3 ("x86/entry/64: Introduce the FIND_PERCPU_BASE macro")
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Chang Seok Bae <chang.seok.bae@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
> Debugged-by: Tom Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Andy Lutomirski <luto@kernel.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/entry/calling.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
> index 98e4d8886f11..ae9b0d4615b3 100644
> --- a/arch/x86/entry/calling.h
> +++ b/arch/x86/entry/calling.h
> @@ -374,12 +374,14 @@ For 32-bit we have the following conventions - kernel is built with
>   * Fetch the per-CPU GSBASE value for this processor and put it in @reg.
>   * We normally use %gs for accessing per-CPU data, but we are setting up
>   * %gs here and obviously can not use %gs itself to access per-CPU data.
> + *
> + * Do not use RDPID, because KVM loads guest's TSC_AUX on vm-entry and
> + * may not restore the host's value until the CPU returns to userspace.
> + * Thus the kernel would consume a guest's TSC_AUX if an NMI arrives
> + * while running KVM's run loop.
>   */
>  .macro GET_PERCPU_BASE reg:req
> -       ALTERNATIVE \
> -               "LOAD_CPU_AND_NODE_SEG_LIMIT \reg", \
> -               "RDPID  \reg", \
> -               X86_FEATURE_RDPID
> +       LOAD_CPU_AND_NODE_SEG_LIMIT \reg
>         andq    $VDSO_CPUNODE_MASK, \reg
>         movq    __per_cpu_offset(, \reg, 8), \reg
>  .endm

LOAD_CPU_AND_NODE_SEG_LIMIT can be merged into this, as its only
purpose was to work around using CPP macros in an alternative.

--
Brian Gerst
