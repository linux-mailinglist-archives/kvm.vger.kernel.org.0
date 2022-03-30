Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA32C4EB7B3
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 03:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241564AbiC3BTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 21:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiC3BTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 21:19:24 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13721834C4;
        Tue, 29 Mar 2022 18:17:39 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id x20so34394664ybi.5;
        Tue, 29 Mar 2022 18:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+auWAaaXDrREYfp0+uPJGdCvwYVXP44tqQxqfAd+cgo=;
        b=X71DNyCINi+0JPbYeBTS4tUImx30j46+5aCRFnWS1u9WGqxQfGpdzrp+pIXQZGSCdy
         sh/DiHGdyEUrr4ktJbN99Eh46I8rn/IHK2uspnC9xgy85548JnP8Yd0G9FBTIYkIfPdB
         26mZV4q+EHkpWXrIzWnTu2i4tR/URK3kQwWBxAfJ0qPtzs1bLAKFvhmQAdoHYmxxtYEb
         ljnex5cSaNPlrpBeCj0YEM2XZ8bE3M1zDtpZcv8NW5+kssUASpkyqsmcVsVyM3REjT7T
         Wun3IpWBLE+z9/Dxoyc7cCu00vt27BpMDzsbq05JoOeyiyfoIG1oVqE+oIx2bhojvh1+
         RcqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+auWAaaXDrREYfp0+uPJGdCvwYVXP44tqQxqfAd+cgo=;
        b=1BWAOmj4FTRjms4iyhKD1tXkP+pty0pltIW8uKgVoYFrpPf1Y9FG6Ni/MNJHHCQ836
         cJo7V8Surpt/fB7h1fnWFXCw+46xsqulvO+J0mDmpbZtl2AJTloimM+vggnL527hP+Vu
         QfTXHZouYo7q8OWSuDWNzctw0zS1XkJ0gEshOadA35KuJaaMz4lKg4vPc/prBSs26nt5
         ijveNvyeCnWCrXxshs8/shhN+ft0k2HXbfEzi1hF0YoNG25IgdyhriQfN5wIJCXNfWqD
         XSGl9CbEZTCLZTJkKkqeG6pR0iZQ64vp2ntAzvlXUMfQFJvvawAtyKaoerxCdw8q//z5
         ZvUg==
X-Gm-Message-State: AOAM532YXZzKIdmN+9ukCR6tTipp4mQggtuaIxkhKhjCiHIn2KBMTcAp
        7BQTDSkCqi4VlkKw/z2a8TmkkJgx9QC7YG0Liys=
X-Google-Smtp-Source: ABdhPJyy3yNnpOH1ab4d9pboTeQl4RSeOC4263olQr/oATED++YSuSXXpQK/QfpDMfSH8qkWPxqx6rfuPYZDfcEhsAM=
X-Received: by 2002:a25:3cc7:0:b0:634:568:a950 with SMTP id
 j190-20020a253cc7000000b006340568a950mr29608729yba.138.1648603059116; Tue, 29
 Mar 2022 18:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
 <1648216709-44755-3-git-send-email-wanpengli@tencent.com> <YkOembt1lvTEJrx0@google.com>
In-Reply-To: <YkOembt1lvTEJrx0@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 30 Mar 2022 09:17:28 +0800
Message-ID: <CANRm+Cy66YAyRp0JJuoyp3k-D9HSZbYF3hYO3Vjxz5w1Rz-P3g@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/5] KVM: X86: Add guest interrupt disable state support
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 30 Mar 2022 at 08:04, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Mar 25, 2022, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Let's get the information whether or not guests disable interruptions.
>
> This is missing critical information for _why_.  It took me some staring to
> understand that this allows querying IRQs from a _different_ vCPU, which needs
> caching on VMX due to the need to do a VMREAD.

Yes.

>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/x86.c              | 3 +++
> >  2 files changed, 4 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 50f011a7445a..8e05cbfa9827 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -861,6 +861,7 @@ struct kvm_vcpu_arch {
> >               bool preempt_count_enabled;
> >               struct gfn_to_hva_cache preempt_count_cache;
> >       } pv_pc;
> > +     bool irq_disabled;
>
> This is going to at best be confusing, and at worst lead to bugs  The flag is
> valid if and only if the vCPU is not loaded.  I don't have a clever answer, but
> this needs to have some form of guard to (a) clarify when it's valid and (b) actively
> prevent misuse.

How about renaming it to last_guest_irq_disabled and comments as /*
Guest irq disabled state, valid iff the vCPU is not loaded */

    Wanpeng
