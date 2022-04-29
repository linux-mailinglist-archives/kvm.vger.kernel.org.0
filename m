Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46D6515136
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 18:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379360AbiD2RCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiD2RCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:02:40 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFA4AF1F8;
        Fri, 29 Apr 2022 09:59:21 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A0AEB1EC04AD;
        Fri, 29 Apr 2022 18:59:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651251555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ryz6qe26SSjFGkG1Tf8msJ+uFH2uRt70jwrl4EWJsSQ=;
        b=p6pYff/QEvvu2vvG6CwN73BewKdNeL9a+iRQLsZjnLDrG9MSlayGHsCZdZn6tKts7qdW/U
        SzsAIeO77jM9tcI0SUyUL9g/q8CPwxRP1P3RbyiZM/uBphYykzRL20V471BXxBtEDE+wTR
        exBW9prOi1AaKwlkIf02zMp6q4T3660=
Date:   Fri, 29 Apr 2022 18:59:12 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <YmwZYEGtJn3qs0j4@zn.tnic>
References: <20220422162103.32736-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220422162103.32736-1-jon@nutanix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 22, 2022 at 12:21:01PM -0400, Jon Kohler wrote:
> Both switch_mm_always_ibpb and switch_mm_cond_ibpb are handled by
> switch_mm() -> cond_mitigation(), which works well in cases where
> switching vCPUs (i.e. switching tasks) also switches mm_struct;
> however, this misses a paranoid case where user space may be running
> multiple guests in a single process (i.e. single mm_struct).

You lost me here. I admit I'm no virt guy so you'll have to explain in
more detail what use case that is that you want to support.

What guests share mm_struct?

What is the paranoid aspect here? You want to protect a single guest
from all the others sharing a mm_struct?

> +/*
> + * Issue IBPB when switching guest vCPUs IFF switch_mm_always_ibpb.
> + * For the more common case of running VMs in their own dedicated process,
> + * switching vCPUs that belong to different VMs, i.e. switching tasks,
> + * will also switch mm_structs and thus do IPBP via cond_mitigation();
> + * however, in the always_ibpb case, take a paranoid approach and issue
> + * IBPB on both switch_mm() and vCPU switch.
> + */
> +static inline void x86_virt_guest_switch_ibpb(void)
> +{
> +	if (static_branch_unlikely(&switch_mm_always_ibpb))
> +		indirect_branch_prediction_barrier();

If this switch is going to be conditional, then make it so:

static void x86_do_cond_ibpb(void)
{
	if (static_branch_likely(&switch_mm_cond_ibpb))
		indirect_branch_prediction_barrier();
}

and there's nothing "virt" about it - might as well call the function
what it does. And I'd put that function in bugs.c...

> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 6296e1ebed1d..6aafb0279cbc 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -68,8 +68,12 @@ u64 __ro_after_init x86_amd_ls_cfg_ssbd_mask;
>  DEFINE_STATIC_KEY_FALSE(switch_to_cond_stibp);
>  /* Control conditional IBPB in switch_mm() */
>  DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
> -/* Control unconditional IBPB in switch_mm() */
> +/* Control unconditional IBPB in both switch_mm() and
> + * x86_virt_guest_switch_ibpb().
> + * See notes on x86_virt_guest_switch_ibpb() for KVM use case details.
> + */
>  DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
> +EXPORT_SYMBOL_GPL(switch_mm_always_ibpb);

... so that I don't export that key to modules.

I'd like to have the big picture clarified first, why we need this, etc.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
