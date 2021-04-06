Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE11A355EA7
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 00:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243726AbhDFWRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 18:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243653AbhDFWRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 18:17:01 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ABDC06174A
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 15:16:53 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso229644pjb.3
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 15:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bojTtlznyYPCxw+AjA1Z5iDQKyp0kAN0WptY4bExVu4=;
        b=hpOLE67wFT0yf2eHMBO9zLlhNCbFgbPn/GE6fchXDoUiteKDsDS24LBbbCoFslqm6l
         1czPWf3YoZBKM6lBpyXolkgUwIunYZWZ92IynweM45YVG/EkJHjcZxkMLDn9cJngc1GM
         5uKEbVffD8USZzPqD/9FoknfAQrqA9oMow1DlNkxZiOSG8KN9q0O6yaBFvhygm3P+tPq
         ZmcKcKxOTCt4H0KKCdD2OjzgVKzXiEdH4P48iFPBpYMP3zRv4AO+rwm6LMSGX7lq/iY4
         RZ65zmr4r2N7dFng4QYHXdItgh3QIH2GNxwOW9sK1ixMm2+01xCnqrhp0uDQ/TwSKOc1
         EmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bojTtlznyYPCxw+AjA1Z5iDQKyp0kAN0WptY4bExVu4=;
        b=l0bS69Ixgb5Yd0+B13MDOsc/0Ub1bfUuBxEuuDsXgSJ+o/452raHriNGh3Z0y2agmj
         k6kzr+JmaUXlIxjHNK9hLolGaesT5TvRzE1VGrzj8W5vXK4yuuzP4LA9U1gTYBWu8UKr
         gaa1az832KbDxwb8Yh4+Ht4tdGeCoYQ+whG1NQb1ylcDiQXPLyiIaghn7s6kdEvQ+EpW
         UoXh5X4WmS5lRk7bgeFt8+WYX0V3loxhpksWeFUeFbvt0okAYBeSZV9fkht8bDfswBNU
         TfgjgLmOtIN4Ehm+eXVFypXzIoKuTIKFbn5YLzjGjFI6AmlR3hA5jsdxTZYmJRkdgKsT
         0Y1g==
X-Gm-Message-State: AOAM532SyXpPtoYxyf5fCs7xzdVSuCeT2ww8/SOdrqBYI5LBamO3eVJ7
        s7DnXy1PdqYq+x11IVJeHbYAIg==
X-Google-Smtp-Source: ABdhPJzdXP2WsQ4v6Ljr3lRlzQKRqGmdd8eik0Z6HJEYb6vMt9hoAr6+n/QJjUG3kXnkQpCdrmgDxA==
X-Received: by 2002:a17:90a:d3d8:: with SMTP id d24mr297113pjw.166.1617747413006;
        Tue, 06 Apr 2021 15:16:53 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x9sm13515537pfd.158.2021.04.06.15.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 15:16:52 -0700 (PDT)
Date:   Tue, 6 Apr 2021 22:16:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: X86: Properly account for guest CPU time when
 considering context tracking
Message-ID: <YGzd0PndH3ovXD+H@google.com>
References: <1617011036-11734-1-git-send-email-wanpengli@tencent.com>
 <YGILHM7CHpjXtxaH@google.com>
 <CANRm+CxXAt7z5H1v_Zpjg44Ka09eWc7gaJ7HRq9USUurjqrG3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CxXAt7z5H1v_Zpjg44Ka09eWc7gaJ7HRq9USUurjqrG3A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 30, 2021, Wanpeng Li wrote:
> On Tue, 30 Mar 2021 at 01:15, Sean Christopherson <seanjc@google.com> wrote:
> >
> > +Thomas
> >
> > On Mon, Mar 29, 2021, Wanpeng Li wrote:
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 32cf828..85695b3 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -6689,7 +6689,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> > >        * into world and some more.
> > >        */
> > >       lockdep_hardirqs_off(CALLER_ADDR0);
> > > -     guest_exit_irqoff();
> > > +     if (vtime_accounting_enabled_this_cpu())
> > > +             guest_exit_irqoff();
> >
> > This looks ok, as CONFIG_CONTEXT_TRACKING and CONFIG_VIRT_CPU_ACCOUNTING_GEN are
> > selected by CONFIG_NO_HZ_FULL=y, and can't be enabled independently, e.g. the
> > rcu_user_exit() call won't be delayed because it will never be called in the
> > !vtime case.  But it still feels wrong poking into those details, e.g. it'll
> > be weird and/or wrong guest_exit_irqoff() gains stuff that isn't vtime specific.
> 
> Could you elaborate what's the meaning of "it'll be weird and/or wrong
> guest_exit_irqoff() gains stuff that isn't vtime specific."?

For example, if RCU logic is added to guest_exit_irqoff() that is needed
irrespective of vtime, then KVM will end up with different RCU logic depending
on whether or not vtime is enabled.  RCU is just an example.  My point is that
it doesn't seem impossible that there would be something in the future that
wants to tap into the guest->host transition.

Maybe that never happens and the vtime check is perfectly ok, but for me, the
name guest_exit_irqoff() doesn't sound like something that should hinge on
time accounting being enabled.
