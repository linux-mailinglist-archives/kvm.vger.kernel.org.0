Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A556BBF35
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 22:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCOVih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 17:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCOVig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 17:38:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87C22CC44
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 14:38:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l10-20020a17090270ca00b0019caa6e6bd1so11006220plt.2
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 14:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678916314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=17FwLFWdQiR1VYab7un9+S1vvzYQFaeJL0pOXU3AT7k=;
        b=hu9hUloADcly+RV/r01SUQSuSRN4l6zDp0ru74uehocwbLYMpdVm2MEt9ao2SDVcaV
         u2zXq1wA0BHYVuhdifOE3d8OzuFpW0k1GbGK1DZK+M+1sT4ZYaunrGetx7w6YTHmIonE
         woUKkOA3gBPItmEq5n+XtCWSBcJ9hkUFs6By04SbBMtEz7HvmzF73V5cOvn8BgwUrXrO
         DmTZqhlIFuKRVQ3LEOOOAYJFAvM6AiIAZ9X0DpB11HgvLtBbDxrH4K1yUu8fm4uBEx7v
         aTQqQBC7dUMoWbT0TRs+YrxfnCD+Hrd9/B9yvGiDi+4ZzXdC+k31pqi1/6spNjdH4+k4
         LcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678916314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=17FwLFWdQiR1VYab7un9+S1vvzYQFaeJL0pOXU3AT7k=;
        b=uGg5DXXjG5t+UlhUYtKHl72taeurMlvwYCnuexIsAf+Z/OoLciz5F3gDl4Q/YQ83Ia
         yiyw+q8JkW8fyh3UNDhia1LLyA51aqzCDEcPx1kKzBjDqXXTpzUIjr1N345H0K2TOdxS
         G0dQkSdH2f8/oj6RuoooLQ+P2IHO0zuCGd2Gcn2yXQT5T78Q6mzAbSAhVHKXkEIIOl/6
         orTZ8NHwPEZY2qJWMkhTGNWnOsL02QXVuOrxBNPKpjup4gS/Iq9UwJfOcy9cS7ZR0ta7
         f6n1CopNubdocwgSWLYYA0YHRwJailkLGgGMCdjMqcOls7IStFbpfKPWhUYu1k+ZI/5w
         aLsA==
X-Gm-Message-State: AO0yUKULzRcQbm8XsR9JBGz8GOTQ8Iy9KqMuqvnD9/m9778+kKQC1eDs
        0XNizSNRBm33AwBxwK23qGEjlfnES3I=
X-Google-Smtp-Source: AK7set8Y5rLJ2c5prUD3VByMG5Z756K9IInJTv0Hhc2VG2bUyh3AXuAyMkdgiaMNgGGQ6rZa4n9afBdg5rM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c7:b0:1a0:763d:6c2a with SMTP id
 n7-20020a170902d2c700b001a0763d6c2amr396848plc.10.1678916314471; Wed, 15 Mar
 2023 14:38:34 -0700 (PDT)
Date:   Wed, 15 Mar 2023 14:38:33 -0700
In-Reply-To: <20230201194604.11135-3-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230201194604.11135-1-minipli@grsecurity.net> <20230201194604.11135-3-minipli@grsecurity.net>
Message-ID: <ZBI62RUnMB3ppRqO@google.com>
Subject: Re: [PATCH v3 2/6] KVM: VMX: Avoid retpoline call for control
 register caused exits
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023, Mathias Krause wrote:
> Complement commit 4289d2728664 ("KVM: retpolines: x86: eliminate
> retpoline from vmx.c exit handlers") and avoid a retpoline call for
> control register accesses as well.
> 
> This speeds up guests that make heavy use of it, like grsecurity
> kernels toggling CR0.WP to implement kernel W^X.

I would rather drop this patch for VMX and instead unconditionally make CR0.WP
guest owned when TDP (EPT) is enabled, i.e. drop the module param from patch 6.

> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
> 
> Meanwhile I got my hands on a AMD system and while doing a similar change
> for SVM gives a small measurable win (1.1% faster for grsecurity guests),

Mostly out of curiosity...

Is the 1.1% roughly aligned with the gains for VMX?  If VMX sees a significantly
larger improvement, any idea why SVM doesn't benefit as much?  E.g. did you double
check that the kernel was actually using RETPOLINE?

> it would provide nothing for other guests, as the change I was testing was
> specifically targeting CR0 caused exits.
> 
> A more general approach would instead cover CR3 and, maybe, CR4 as well.
> However, that would require a lot more exit code compares, likely
> vanishing the gains in the general case. So this tweak is VMX only.

I don't think targeting on CR0 exits is a reason to not do this for SVM.  With
NPT enabled, CR3 isn't intercepted, and CR4 exits should be very rare.  If the
performance benefits are marginal (I don't have a good frame of reference for the
1.1%), then _that's_ a good reason to leave SVM alone.  But not giving CR3 and CR4
priority is a non-issue.

>  arch/x86/kvm/vmx/vmx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c788aa382611..c8198c8a9b55 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6538,6 +6538,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  		return handle_external_interrupt(vcpu);
>  	else if (exit_reason.basic == EXIT_REASON_HLT)
>  		return kvm_emulate_halt(vcpu);
> +	else if (exit_reason.basic == EXIT_REASON_CR_ACCESS)
> +		return handle_cr(vcpu);
>  	else if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG)
>  		return handle_ept_misconfig(vcpu);
>  #endif
> -- 
> 2.39.1
> 
