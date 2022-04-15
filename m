Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBD8502BE0
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354430AbiDOObC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353098AbiDOObA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:31:00 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CEBA66CB
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:28:31 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 12so7221598pll.12
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SkWhd1w1XgTgSoYIPFvieD6plMkmAZPzoFXpxG29s14=;
        b=lIfnA7JBAJ7VT/Fh5NCrc0DP+j+ZLe9da/9GAXMeWWEEMXXkXO4cUE0E5TVQhR+VNh
         7SRnw+/wbDUmPCpV0SHzUe0j1EygxDBiJPtQ2cCv0G9tiaRxed070RqHCaW47ZkSAaso
         eFmzz53dg3b5dcLLmjAXA5k2zMyGcBu5ClRdNqBYf06rhySud5O7pWAdaGCw/YtgIS8f
         peIMmjJ9tFp4EAna1kRBSWWrjTzAecZY3W9OYf8kLlkZqc0Tl8ghc5yyNojnJu7b4/IJ
         0uhtZKZIGy2y6is+xQ3BklA0EwjmZ8kk/yyF2QvzJ5MHw48RT4IWwijdXk/ycEFc6Nay
         4qpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SkWhd1w1XgTgSoYIPFvieD6plMkmAZPzoFXpxG29s14=;
        b=hgBruOMD8uSCxYzo65XFJUoU+Kcw0WFgvaeeGlyjg5RTxea1AUlEWVoo5SXT1JsHIb
         jf94K/O9FQhNkOhXeAdD5LXt33ED++aXJuO3H5dq0dXDTD68W/ROHQJb5+nzsH71I91/
         k8aB4Hnvam+sb+iMctoiwyGrVHDe+4AA91+WZ/VRvoO/QWPzw3K8VbzqoCRUM9xOLcVz
         j92zMsn9M39BkFV1dTw2p6waIcugU/E8s2rl2MBcgbnvm8tPWyQwd1I5mZCLkFT1H9wW
         AmxfJLaE/mTMmX2569w2tiFYs0W5I6MiszTqsAiuboFvv31ydp1EJNTD1gSrX9iFCphZ
         L5nA==
X-Gm-Message-State: AOAM531up3HJlv6UCX1ZAkOJehXhRmCaw9BMYHEvRooRarrEjfXw9b/I
        l3ObfCWNXrtLP6xZxjsJaJjmE+98z/a0tA==
X-Google-Smtp-Source: ABdhPJysqR7BXz7dScXPpvkTMvMDWuU2xWf13iuXwXbtrTgmDnwZmHwiYZM3sNr8ErWzUKXZfdJPEA==
X-Received: by 2002:a17:902:8608:b0:158:c532:d8b2 with SMTP id f8-20020a170902860800b00158c532d8b2mr5767172plo.46.1650032911094;
        Fri, 15 Apr 2022 07:28:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6-20020a63b606000000b003808b0ea96fsm4535558pgf.66.2022.04.15.07.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 07:28:30 -0700 (PDT)
Date:   Fri, 15 Apr 2022 14:28:27 +0000
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
Subject: Re: [PATCH] x86/speculation, KVM: respect user IBPB configuration
Message-ID: <YlmBC6gaGRrAZm3L@google.com>
References: <20220411164636.74866-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411164636.74866-1-jon@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022, Jon Kohler wrote:
> On vmx_vcpu_load_vmcs and svm_vcpu_load, respect user IBPB config and only
> attempt IBPB MSR if either always_ibpb or cond_ibpb and the vcpu thread
> has TIF_SPEC_IB.
> 
> A vcpu thread will have TIF_SPEC_IB on qemu-kvm using -sandbox on if
> kernel cmdline spectre_v2_user=seccomp, which would indicate that the user
> is looking for a higher security environment and has workloads that need
> to be secured from each other.
> 
> Note: The behavior of spectre_v2_user recently changed in 5.16 on
> commit 2f46993d83ff ("x86: change default to
> spec_store_bypass_disable=prctl spectre_v2_user=prctl")
> 
> Prior to that, qemu-kvm with -sandbox on would also have TIF_SPEC_IB 
> if spectre_v2_user=auto.
> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> ---
>  arch/x86/include/asm/spec-ctrl.h | 12 ++++++++++++
>  arch/x86/kernel/cpu/bugs.c       |  6 ++++--
>  arch/x86/kvm/svm/svm.c           |  2 +-
>  arch/x86/kvm/vmx/vmx.c           |  2 +-
>  4 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-ctrl.h
> index 5393babc0598..552757847d5b 100644
> --- a/arch/x86/include/asm/spec-ctrl.h
> +++ b/arch/x86/include/asm/spec-ctrl.h
> @@ -85,4 +85,16 @@ static inline void speculative_store_bypass_ht_init(void) { }
>  extern void speculation_ctrl_update(unsigned long tif);
>  extern void speculation_ctrl_update_current(void);
>  
> +/*
> + * Always issue IBPB if switch_mm_always_ibpb and respect conditional
> + * IBPB if this thread does not have !TIF_SPEC_IB.
> + */
> +static inline void maybe_indirect_branch_prediction_barrier(void)

I think it makes sense to give this a virtualization specific name, e.g.
x86_virt_cond_indirect_branch_prediction_barrier() or x86_virt_cond_ibpb(),
to follow x86_virt_spec_ctrl().  Or if "cond" is misleading in the "always" case,
perhaps x86_virt_guest_switch_ibpb()?

> +{
> +	if (static_key_enabled(&switch_mm_always_ibpb) ||
> +	    (static_key_enabled(&switch_mm_cond_ibpb) &&
> +	     test_thread_flag(TIF_SPEC_IB)))

The cond_ibpb case in particular needs a more detailed comment.  Specifically it
should call out why this path doesn't do IBPB when switching from a task with
TIF_SPEC_IB to a task without TIF_SPEC_IB, whereas cond_mitigation() does emit
IBPB when switching mms in this case.

But stepping back, why does KVM do its own IBPB in the first place?  The goal is
to prevent one vCPU from attacking the next vCPU run on the same pCPU.  But unless
userspace is running multiple VMs in the same process/mm_struct, switching vCPUs,
i.e. switching tasks, will also switch mm_structs and thus do IPBP via cond_mitigation.

If userspace runs multiple VMs in the same process, enables cond_ipbp, _and_ sets
TIF_SPEC_IB, then it's being stupid and isn't getting full protection in any case,
e.g. if userspace is handling an exit-to-userspace condition for two vCPUs from
different VMs, then the kernel could switch between those two vCPUs' tasks without
bouncing through KVM and thus without doing KVM's IBPB.

I can kinda see doing this for always_ibpb, e.g. if userspace is unaware of spectre
and is naively running multiple VMs in the same process.

What am I missing?
