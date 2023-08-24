Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7AC78717E
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 16:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbjHXO0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 10:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241699AbjHXO00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 10:26:26 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496771BC6
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 07:26:22 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59294c55909so557417b3.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 07:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692887181; x=1693491981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GOEC2gL2vPMfrimKnsUeWbRBTwKLQLkp/XAmV7mc+hM=;
        b=zThywn62QCEc2gE7/6qdBaDq9/1rKpLx6RFn/awFe4rXfJOV6KKFcgLLeDA1RQnWKp
         9HSRtKRV90dPkRW3JDaAB3SP/eAtxDVdsHY8i4GiuFObziA0Dsdz7Z6O1gKlANCN/dD0
         SruoR9Wenx6/YuF5BTQQNs4qC7gcr4rTJqfCLexSNOOiH20ad5vvWFFPspbwLx8GFAT5
         KP5A3bUNK2KlJwmzUrKcA5/TNXfo1G1rk8v5qJr1Us6VB86XUPOrmp+D0gTrVXhqIUWZ
         UCwdB0kJjGx1TOOnzY2Z1kLLH3GBrZFCR+HrK95SIMb+ltKBIoc6Cd3gXaMbqYfc2Byk
         1Mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692887181; x=1693491981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GOEC2gL2vPMfrimKnsUeWbRBTwKLQLkp/XAmV7mc+hM=;
        b=KJvJuiip3JIuEjtvwEtsBGe7Ek7blmT3xH2r4NVWqLcwyHSsM8UvVJvKjbNvKw0qme
         lQjiwJvsnXcpztljjggUD36FZ7M0kiiwF4UamaqsTUn1heUl9kIAflEpknpbDSU8rC2Q
         iTpwZ1cm40xUSRkmKIMawcr5yjlBzvRRdNs2SbL+JaVwsqSCUG26omUc0I+AQTwcrfpZ
         ODfHlWGAD8f3G/Qewqh39QRpzvXaK0LQiwG0+iYQN4LRNJ2NEo7dE5sSGfFSasiqt3a3
         NmL0YdYayI57uG75+gzp+B3nZ2kppeyNvzB/WpzGyZRqG/GSV0+QcvmJ5OKs2rlagCYh
         t6VA==
X-Gm-Message-State: AOJu0YwMIbpnQvTvEYec0PnXj3vcC6BfWONBfTx870INdE9rqjgNPTm+
        WL4wtzEREtXOtow9TPiEQ38LzHaekxw=
X-Google-Smtp-Source: AGHT+IGRA8onYtETZ5TVTvLafV/wVwLQi13rt/bL96OuVKnHFmkFCsfsn/0KnssV9bbTzeqokJkvsPqXgwQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af0e:0:b0:58c:6ddd:d27c with SMTP id
 n14-20020a81af0e000000b0058c6dddd27cmr233466ywh.6.1692887181634; Thu, 24 Aug
 2023 07:26:21 -0700 (PDT)
Date:   Thu, 24 Aug 2023 07:26:20 -0700
In-Reply-To: <ZOdmPqq6uXMSWOnV@google.com>
Mime-Version: 1.0
References: <20221213060912.654668-1-seanjc@google.com> <20221213060912.654668-8-seanjc@google.com>
 <e91f562b-ecdf-6745-a9b1-52fe19126bad@gmail.com> <ZOdmPqq6uXMSWOnV@google.com>
Message-ID: <ZOdojKCxPMV8KNo3@google.com>
Subject: Re: [PATCH 7/7] KVM: VMX: Handle NMI VM-Exits in noinstr region
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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

On Thu, Aug 24, 2023, Sean Christopherson wrote:
> On Thu, Aug 24, 2023, Like Xu wrote:
> > @@ -7389,6 +7382,13 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > 
> >  	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> > 
> > +	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
> > +	    is_nmi(vmx_get_intr_info(vcpu))) {
> > +		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
> > +		vmx_do_nmi_irqoff();
> > +		kvm_after_interrupt(vcpu);
> > +	}
> 
> No, the whole point of doing NMI handling in vmx_vcpu_enter_exit() is so that NMIs
> are serviced before instrumentation is enabled.
> 
> I think the below is sufficient (untested at this point).  Not quite minimal, e.g.
> I'm pretty sure there's (currently) no need to snapshot IDT_VECTORING_INFO_FIELD
> so early, but I can't think of any reason to wait.
> 
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 24 Aug 2023 06:49:36 -0700
> Subject: [PATCH] KVM: VMX: Refresh available regs and IDT vectoring info
>  before NMI handling
> 
> Reset the mask of available "registers" and refresh the IDT vectoring
> info snapshot in vmx_vcpu_enter_exit(), before KVM potentially handles a
> an NMI VM-Exit.  One of the "registers" that KVM VMX lazily loads is the
> vmcs.VM_EXIT_INTR_INFO field, which is holds the vector+type on "exception
> or NMI" VM-Exits, i.e. is needed to identify NMIs.  Clearing the available
> registers bitmask after handling NMIs results in KVM querying info from
> the last VM-Exit that read vmcs.VM_EXIT_INTR_INFO, and leads to both
> missed NMIs and spurious NMIs from the guest's perspective.

Oof, it's not just from the guest's perspective, NMIs that are destined for host
consumption will suffer the same fate. 
