Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6963050A3E2
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 17:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389981AbiDUPXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 11:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389977AbiDUPXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 11:23:23 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1BD39BB1
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 08:20:33 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t13so4905758pgn.8
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 08:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Iud4fOAzWyfKnps8mbbXMcHFSwOzQ8oquSRtMdXbWM0=;
        b=RVlUnhRPDVleloKx3GonNS9W3wbfR4nOfN1Qi4MwjZsFPBgZifrs0G0aLJXD+dBgDm
         O8h6kOxXShzBMRgduy+ihXePIjnCPoC3SrMLONvOPjG9PbDF64JmLutk+PTc6Tx57o5u
         9gwZvChwpxPJmzhWcWXrt4CHvBL1m091O+ujbgrrnCy0XC5smCLpFGhC7/xWrwDb++ZT
         9vFIZ/Skq8uL/j2x91awlfLVM86RXUXILISx7R+BHxKsZqgvyNf+s09Z4jRTmSuZtzgk
         eSMKlZAeakixDDKHnRRgJ5+Tqyqwkk7ef02W+IFc7uMb7ZOMkiQ53zNKz5X9+/DMX73I
         FZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iud4fOAzWyfKnps8mbbXMcHFSwOzQ8oquSRtMdXbWM0=;
        b=dlcN8ffy8xtt5YxbWA6++gsl0BvywbVITfkay1qnevYIOYVKEq8t2C0zBua+XecWRe
         ++gojI2qH5/rsfJ0xTi3GC+UUMuWmePx5xWqoIssn1AR7G2T5i0QTBV6jpfFOAsT0A6P
         i3xz+IXiLHBsANJqSlWRaXtUMyPxyaKXfxBjlYG9SVfwwc+Hz3yCU4Xy4a1vaOOh8aHP
         bsTrEVKpC/j/Tt2nlHkbSg2W1VkqQ4hvQZl1/qsyLtBGlFq6uTo/AIQbArDMI7826/qu
         28+LItktoCi6ZABSnOMYOp2zataP6ANfK4tB1r1sFTQbICbrYtLIddbhBzrC1z4LdbNO
         uxcw==
X-Gm-Message-State: AOAM530K6t3aYfQXTAB3zRMFiiGZm6QK7GNsHXNyi3LE0dY70wVQcPuR
        hHhx9nH7wInZk/PnGS3NZjX5lQ==
X-Google-Smtp-Source: ABdhPJyUzVcFfpUNGpi8Xh0hVPgueNV87Co6K1e5CotdwUKyd6tE3Okm73hzs3/OVHoKfvNzeLmk2A==
X-Received: by 2002:a05:6a00:894:b0:4fe:25d7:f59e with SMTP id q20-20020a056a00089400b004fe25d7f59emr172514pfj.58.1650554432948;
        Thu, 21 Apr 2022 08:20:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b6-20020a17090a550600b001cd4989ff48sm3060760pji.15.2022.04.21.08.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 08:20:32 -0700 (PDT)
Date:   Thu, 21 Apr 2022 15:20:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <YmF2PRDi12KPsFOC@google.com>
References: <20220419020011.65995-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419020011.65995-1-jon@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 18, 2022, Jon Kohler wrote:
> On vmx_vcpu_load_vmcs and svm_vcpu_load, respect user controlled
> configuration for conditional IBPB and only attempt IBPB MSR when
> switching between different guest vCPUs IFF switch_mm_always_ibpb,
> which fixes a situation where the kernel will issue IBPB
> unconditionally even when conditional IBPB is enabled.
> 
> If a user has spectre_v2_user mitigation enabled, in any
> configuration, and the underlying processor supports X86_FEATURE_IBPB,
> X86_FEATURE_USE_IBPB is set and any calls to
> indirect_branch_prediction_barrier() will issue IBPB MSR.
> 
> Depending on the spectre_v2_user configuration, either
> switch_mm_always_ibpb key or switch_mm_cond_ibpb key will be set.
> 
> Both switch_mm_always_ibpb and switch_mm_cond_ibpb are handled by
> switch_mm() -> cond_mitigation(), which works well in cases where
> switching vCPUs (i.e. switching tasks) also switches mm_struct;
> however, this misses a paranoid case where user space may be running
> multiple guests in a single process (i.e. single mm_struct).
> 
> This paranoid case is already covered by vmx_vcpu_load_vmcs and
> svm_vcpu_load; however, this is done by calling
> indirect_branch_prediction_barrier() and thus the kernel
> unconditionally issues IBPB if X86_FEATURE_USE_IBPB is set.

The changelog should call out that switch_mm_cond_ibpb is intentionally "ignored"
for the virt case, and explain why it's nonsensical to emit IBPB in that scenario.

> Fix by using intermediary call to x86_virt_guest_switch_ibpb(), which
> gates IBPB MSR IFF switch_mm_always_ibpb is true. This is useful for
> security paranoid VMMs in either single process or multi-process VMM
> configurations.

Multi-process VMM?  KVM doesn't allow "sharing" a VM across processes.  Userspace
can share guest memory across processes, but that's not relevant to an IBPB on
guest switch.  I suspect you're loosely referring to all of userspace as a single
VMM.  That's inaccurate, or at least unnecessarily confusing, from a kernel
perspective.  I am not aware of a VMM that runs as a monolithic "daemon" and forks
a new process for every VM.  And even in such a case, I would argue that most
people would refer to each process as a separate VMM.

If there's a blurb about the switch_mm_cond_ibpb case being nonsensical, there's
probably a good segue into stating the new behavior.

> switch_mm_always_ibpb key is user controlled via spectre_v2_user and
> will be true for the following configurations:
>   spectre_v2_user=on
>   spectre_v2_user=prctl,ibpb
>   spectre_v2_user=seccomp,ibpb
> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> ---
> v1 -> v2:
>  - Addressed comments on approach from Sean.
> 
>  arch/x86/include/asm/spec-ctrl.h | 15 +++++++++++++++
>  arch/x86/kernel/cpu/bugs.c       |  6 +++++-
>  arch/x86/kvm/svm/svm.c           |  2 +-
>  arch/x86/kvm/vmx/vmx.c           |  2 +-
>  4 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-ctrl.h
> index 5393babc0598..1ad140b17ad7 100644
> --- a/arch/x86/include/asm/spec-ctrl.h
> +++ b/arch/x86/include/asm/spec-ctrl.h
> @@ -85,4 +85,19 @@ static inline void speculative_store_bypass_ht_init(void) { }
>  extern void speculation_ctrl_update(unsigned long tif);
>  extern void speculation_ctrl_update_current(void);
> 
> +/*
> + * Issue IBPB when switching guest vCPUs IFF if switch_mm_always_ibpb.

Extra "if" there.

> + * Primarily useful for security paranoid (or naive) user space VMMs
> + * that may run multiple VMs within a single process.
> + * For multi-process VMMs, switching vCPUs, i.e. switching tasks,

As above, "multi-process VMMs" is very confusing, they're really just separate VMMs.
Something like this?

 * For the more common case of running VMs in their own dedicated process,
 * switching vCPUs that belong to different VMs, i.e. switching tasks, will also
 * ...

> + * will also switch mm_structs and thus do IPBP via cond_mitigation();
> + * however, in the always_ibpb case, take a paranoid approach and issue
> + * IBPB on both switch_mm() and vCPU switch.
> + */
> +static inline void x86_virt_guest_switch_ibpb(void)
> +{
> +	if (static_branch_unlikely(&switch_mm_always_ibpb))
> +		indirect_branch_prediction_barrier();
> +}
> +
>  #endif
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 6296e1ebed1d..6aafb0279cbc 100644
