Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8D95706E1
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 17:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiGKPW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 11:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGKPW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 11:22:58 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1C45C9C5
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 08:22:57 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f11so4134260pgj.7
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 08:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rIXkilLQfgOtYP5k9HiwJCc9d8sCaA9fTRl5ayd2YSU=;
        b=oeRT2pv5AEhh1wGL8y0oDKKzorx5yHv43t0Sgjd9q8R/C7iaG9Y19Jj1kcyIz6Uc87
         7zWboOGTmnx4k6fgHqwUheXR12fXtVNHmZQJe4P/zf2hlUgHvu8Y0WbhEBpnO5RBcnp/
         CezdnHbdBvVV+A5ZKTnyKUInqz03eCw8xtgfopQOpiYxWFNrl0E2Eh8wYhFLWEEhJba9
         jI4dqMNm2jUAZGFM7/Dng++crAgg1uvMRUmmkuEUGAuFiuOk9uk5UxDUB2TNpJSfyyRd
         YXZyivdkHGCKWvUOWyW/tUrPXMc7uHjrJO39KWSLaJ4BH1Lr0iGHnN1nTaZvfb3CAi+L
         z2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rIXkilLQfgOtYP5k9HiwJCc9d8sCaA9fTRl5ayd2YSU=;
        b=kPP2WogXPpHldR8d7kEudVph7eduspKUDVH5UzKVe4x3Ly8hSr2uX8veLNRjkb/3ul
         5FCQ2Ul/y0izU7GQsU7dKfXb9GxZ0WfCyCTWiG0XwJRf32zMWM0CfHpkYueqMrNAE3G0
         svXI3/+YaztL6ka7hUK89bJMLDiK4EKqkagOqT1T5o4LP5jT223LV3cfEhsSzXXNLpWp
         PG2tNfmXpWuTYe0ZQFQIk+nqeba3MJdT3RaAg7rQp22SvdUs5gzhMvONowzi8vvtvjFD
         msF/B+HwQkOeJ7ZvcA7Vsq6fRcEY14yD9zYbef0Z2RTIB1sTiAWJfND/riglVWy8/bY8
         BN6A==
X-Gm-Message-State: AJIora/mRKUNiy4heh+A893poQXBB8rdTmXgIpMYNktrmJzFYj++ztcC
        NHPBxTiT3soxoOIhD1CQHIfM7A==
X-Google-Smtp-Source: AGRyM1uE4KGa7kyqDXzFm8D0UcGEJEKZug+68fWnZi8mRNj5u1umxmG99NPR4HdgrlHuYs+5fQTfXw==
X-Received: by 2002:a05:6a00:1501:b0:525:79a7:aa4 with SMTP id q1-20020a056a00150100b0052579a70aa4mr19083236pfu.44.1657552976720;
        Mon, 11 Jul 2022 08:22:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id 129-20020a630787000000b00415e89dd738sm3189922pgh.77.2022.07.11.08.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 08:22:56 -0700 (PDT)
Date:   Mon, 11 Jul 2022 15:22:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 17/21] KVM: x86: Morph pending exceptions to pending
 VM-Exits at queue time
Message-ID: <YsxATIxJjYrrg7nc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
 <20220614204730.3359543-18-seanjc@google.com>
 <5eaf496d71b2c8fd321c013c9d1787d4c34d1100.camel@redhat.com>
 <YsY1ud2ZaZq9wvfI@google.com>
 <6fad40967afa4a7ed74c0f4158c8e841b1384318.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fad40967afa4a7ed74c0f4158c8e841b1384318.camel@redhat.com>
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

On Sun, Jul 10, 2022, Maxim Levitsky wrote:
> On Thu, 2022-07-07 at 01:24 +0000, Sean Christopherson wrote:
> > On Wed, Jul 06, 2022, Maxim Levitsky wrote:
> > > Other than that, this is a _very_ good idea to add it to KVM, although
> > > maybe we should put it in Documentation folder instead?
> > > (but I don't have a strong preference on this)
> > 
> > I definitely want a comment in KVM that's relatively close to the code.  I'm not
> > opposed to also adding something in Documentation, but I'd want that to be an "and"
> > not an "or".
> 
> Also makes sense. 
> 
> I do think that it is worthwhile to also add a comment about the way KVM
> handles exceptions, which means that inject_pending_event is not always called on instruction
> boundary. When we have a pending/injected exception we have first to get rid of it,
> and only then we will be on instruction boundary.

Yeah, though it's not like KVM has much of a choice, e.g. intercepted=>reflected
exceptions must be injected during instruction execution.  I wouldn't be opposed
to renaming inject_pending_event() if someone can come up with a decent alternative
that's sufficiently descriptive but not comically verbose.

kvm_check_events() to pair with kvm_check_nested_events()?  kvm_check_and_inject_events()?  

> And to be sure that we will inject pending interrupts on the closest instruction
> boundary, we actually open an interrupt/smi/nmi window there.
> > This is calling out something slightly different.  What it's saying is that if
> > there was a pending exception, then KVM should _not_ have injected said pending
> > exception and instead should have requested an immediate exit.  That "immediate
> > exit" should have forced a VM-Exit before the CPU could fetch a new instruction,
> > and thus before the guest could trigger an exception that would require reinjection.
> > 
> > The "immediate exit" trick works because all events with higher priority than the
> > VMX preeemption timer (or IRQ) are guaranteed to exit, e.g. a hardware SMI can't
> > cause a fault in the guest.
> 
> Yes it all makes sense now. It really helps thinking in terms of instruction boundary.
> 
> However, that makes me think: Can that actually happen?

I don't think KVM can get itself in that state, but I believe userspace could force
it by using KVM_SET_VCPU_EVENTS + KVM_SET_NESTED_STATE.

> A pending exception can only be generated by KVM itself (nested hypervisor,
> and CPU reflected exceptions/interrupts are all injected).
> 
> If VMRUN/VMRESUME has a pending exception, it means that it itself generated it,
> in which case we won't be entering the guest, but rather jump to the
> exception handler, and thus nested run will not be pending.

Notably, SVM handles single-step #DBs on VMRUN in the nested VM-Exit path.  That's
the only exception that I can think of off the top of my head that can be coincident
with a successful VM-Entry (ignoring things like NMI=>#PF).

> We can though have pending NMI/SMI/interrupts.
> 
> Also just a note about injected exceptions/interrupts during VMRUN/VMRESUME.
> 
> If nested_run_pending is true, then the injected exception due to the same
> reasoning can not come from VMRUN/VMRESUME. It can come from nested hypevisor's EVENTINJ,
> but in this case we currently just copy it from vmcb12/vmcs12 to vmcb02/vmcs02,
> without touching vcpu->arch.interrupt.
> 
> Luckily this doesn't cause issues because when the nested run is pending
> we don't inject anything to the guest.
> 
> If nested_run_pending is false however, the opposite is true. The EVENTINJ
> will be already delivered, and we can only have injected exception/interrupt
> that come from the cpu itself via exit_int_info/IDT_VECTORING_INFO_FIELD which
> we will copy back as injected interrupt/exception to 'vcpu->arch.exception/interrupt'.
> and later re-inject, next time we run the same VMRUN instruction.
