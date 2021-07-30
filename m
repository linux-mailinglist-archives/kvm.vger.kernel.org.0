Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E443DBD4E
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 18:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhG3Qs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 12:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhG3Qsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 12:48:52 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD19C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 09:48:45 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id r17so19119728lfe.2
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HSpyjj2q59p3JnLbqxdGu1wbl5OCmoAl/PXe1KwPZFU=;
        b=jW7212u6qaToexTXRrnITb/f5YiTnaF4LgQPUS3FTRc9TklaeoKZmrbMIuHzbX2+fm
         IFLaPAZzT+BuXdjSnhln0I4HuDW/Fzq/qO3F0fs9P2xohbtR8mp/YyQ+b331WUgB4vAA
         8Z2+Qc2fVZpm+ttWUY+3iDDZi4N5oV08xvocvEj5SfS2rkbbMEnPi3b82v6N3QgKprM2
         Il0Oc16Aqg6BHrPliQDlX56bf9x9b15JTfF4uCQYujXjIeOcRW2EL8nIKJ42JLj8199R
         NnBYCesY1WLyV4Ojr0G5z+yn6CNLWHPvEDH11+QTMsybChnoLQVA3uzDiVMqX1ZK1SFJ
         YpqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HSpyjj2q59p3JnLbqxdGu1wbl5OCmoAl/PXe1KwPZFU=;
        b=VxKq0e3tf9XC7n7efLCaAqSwte6ybOJyC1c7lx+Wiyiw/QQAlG1K5G0T6q7oVAqVCe
         2s3/X/VS8+Dfp+0R23Lx8eRIpnSG5eRcXSeMDEolVObSV6q1K0b4pIGlZH9bL9gunbe2
         5s5eCyHR1aLd9VS6SVng+Z1nsy6rhhY3TYAr4tXhPEKgJFj1p3bWjiW43DkcK1Auyx5r
         xoAIkld5NTA3ScB+nIg8k/yEGpoGFVXJWiqqtZzocHC/I7Yo6PoH4F3zl7XywDOQIhjN
         ymHFDqsopeoAv8EExLUZWFZsA/s8CQiNUQaFz8YWX16xzb9Miv0MAtzaotd23SET/y90
         meKA==
X-Gm-Message-State: AOAM531Pk5pkFtevShyn3QzhxwGDJOHf7yhHitsgeP4TbvPeezVM4Ljw
        psI37Hpr/3B8T2b1vVIG8zz5Gp3+RAKvpgqhALVauQ==
X-Google-Smtp-Source: ABdhPJz4i34C7e+Mzo+QI82IG1ULBhvTaO+2wTi9MxMbMPfkAjMEWJ3veRwIHG5RuIcvKrQLGSTFnFXPHku+pVxS+zI=
X-Received: by 2002:a05:6512:3b94:: with SMTP id g20mr2577501lfv.0.1627663723073;
 Fri, 30 Jul 2021 09:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com> <20210729173300.181775-12-oupton@google.com>
 <875yws2h5w.wl-maz@kernel.org> <CAOQ_QsgCrEWQqakicR3Peu_c8oCMeq8Cok+CK8vJVURUwAdG0A@mail.gmail.com>
 <87wnp722tm.wl-maz@kernel.org>
In-Reply-To: <87wnp722tm.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 30 Jul 2021 09:48:31 -0700
Message-ID: <CAOQ_QsiwuancUsFEVr3TBeP6yLZMfAqNRv3ww2H+hcUGfxs9LA@mail.gmail.com>
Subject: Re: [PATCH v5 11/13] KVM: arm64: Provide userspace access to the
 physical counter offset
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 9:18 AM Marc Zyngier <maz@kernel.org> wrote:
> You want the ARM FVP model, or maybe even the Foundation model. It has
> support all the way to ARMv8.7 apparently. I personally use the FVP,
> get in touch offline and I'll help you with the setup.
>
> In general, I tend to trust the ARM models a lot more than QEMU for
> the quality of the emulation. You can tune it in some bizarre way
> (the cache modelling is terrifying), and it will definitely do all
> kind of crazy reordering and speculation.

Awesome, thanks. I'll give this a try.

>
> >
> > > I really dislike the fallback to !vhe here. I'd rather you
> > > special-case the emulated ptimer in the VHE case:
> > >
> > >         if (has_vhe()) {
> > >                 map->direct_vtimer = vcpu_vtimer(vcpu);
> > >                 if (!timer_get_offset(vcpu_ptimer(vcpu)))
> > >                         map->direct_ptimer = vcpu_ptimer(vcpu);
> > >                         map->emul_ptimer = NULL;
> > >                 } else {
> > >                         map->direct_ptimer = NULL;
> > >                         map->emul_ptimer = vcpu_ptimer(vcpu);
> > >                 }
> > >         } else {
> >
> > Ack.
> >
> > > and you can drop the timer_emulation_required() helper which doesn't
> > > serve any purpose.
> >
> > Especially if I add ECV to this series, I'd prefer to carry it than
> > open-code the check for CNTPOFF && !ECV in get_timer_map(). Do you
> > concur? I can tighten it to ptimer_emulation_required() and avoid
> > taking an arch_timer context if you prefer.
>
> Sure, whatever you prefer. I'm not set on one way or another, but in
> the above case, it was clearly easier to get rid of the helper.

Agreed, it made sense to prune before.

> There has been a trap, so that already was a context synchronisation
> event. but it would be pretty common for the counter to be speculated
> way early, when entering EL2. That's not the end of the world, but
> that's not an accurate emulation. You'd want it to be as close as
> possible to the reentry point into the guest.

Cool, I'll add the barrier to kick the can closer to guest entry.

--
Thanks,
Oliver
