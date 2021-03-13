Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E9F339ADE
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 02:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhCMBcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 20:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbhCMBbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 20:31:44 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE7AC061574;
        Fri, 12 Mar 2021 17:31:44 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id g185so26341466qkf.6;
        Fri, 12 Mar 2021 17:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcdWXT4DUSERFdCyIHni/dU5TOl337k8AbBTDnppu4s=;
        b=d3VqIfDTLnYkueX6Rid21rbGUxSKtoqSU5Zo+j9YBtKoKrQ0OHsZG8EWKCDYlS14ld
         ibBtT5zzl1hpz4SBX00VrqbMtFAV4dK4kXneYrJQL7p17FHFt+UVIFWT2MWv329RcG4v
         l6+BzqHKLCQ0R7Cq5A8QMS1cjfmyNw3bB+txAmeR0WQ9PmoGFxqHe4H6j9bHJGeDWLKh
         k6o8K/9Y3cVeRJy8xspI7Yi26gUyOgETwO52OTBqYNih2uFAeai4m8EMzfdsFJu0Suf1
         ElLKt+JWz8VFZqIa+Kb7imAYbXvAqNerZigkEv2B5CK8jLZ+0Ur2LkaOxAAhOOAN+/fH
         eXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcdWXT4DUSERFdCyIHni/dU5TOl337k8AbBTDnppu4s=;
        b=nJOBb+PojT28r0Ke5mimiWpUbpTx8roS2HUqrAZ1ckMDIwy+22L/DEVTDBIYTrEFrO
         VpgGvi8ywyhOfDs/n9tGOm9SJ3B6mT+6qjv/r23gDYPqNuuFlO+o6Fno/EybMVSwgtWS
         km7US1NFnlp/FlH9cGWmzXE2Wi/4jXtpav9zhbt7baiwEBLQiPmGdLLnHT5M51dtKYqK
         Lmnp82dfYOl6U+KsHoLDAdrUxA1QlcEZsFtP/Qr2lfLUg7/W2VI3xvBSmrWrdox3GqzL
         b79BJx4asop/V9Ij8aJIRa7uIHA2i4rck5Ta9w79+D77yMdlouf92nLr+S+K9stkhTB4
         yAFw==
X-Gm-Message-State: AOAM532Qof49+Rd+cRxvoN1AouJcmbLz3H6ygOYK/keNglikS+cGItSv
        DlDg9cVp0OMh6E+1RIPE9zV0UjHFxOqdoO86nQ==
X-Google-Smtp-Source: ABdhPJyUHUiomSU45S++Qo5fCAi6av+Az3AajTeL4LdcuKjyjSt61H9/LYxnHeeLrSWshd4MAWMHlTGclwn+Efs58Yc=
X-Received: by 2002:a37:8185:: with SMTP id c127mr15396870qkd.275.1615599103512;
 Fri, 12 Mar 2021 17:31:43 -0800 (PST)
MIME-Version: 1.0
References: <20210303020946.26083-1-lihaiwei.kernel@gmail.com>
 <03239d81-df56-a6c9-c79d-c14d22f62705@gmail.com> <YEgH11nNwdCkF5kT@google.com>
 <CAB5KdOZkdXsLup+58On=LZ6eG4jYdcaK2NCt9U0Q-qy_6dQrfw@mail.gmail.com> <YEwOM3aTeUjVim/i@google.com>
In-Reply-To: <YEwOM3aTeUjVim/i@google.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Sat, 13 Mar 2021 09:31:17 +0800
Message-ID: <CAB5KdObBa2oiPZpHx_S6V+=TFqb_zet=7tdaqU0y3cVJk2UZuQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: lapic: add module parameters for LAPIC_TIMER_ADVANCE_ADJUST_MAX/MIN
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 13, 2021 at 8:58 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 10, 2021, Haiwei Li wrote:
> > On Wed, Mar 10, 2021 at 7:42 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Wed, Mar 03, 2021, Haiwei Li wrote:
> > > > On 21/3/3 10:09, lihaiwei.kernel@gmail.com wrote:
> > > > > From: Haiwei Li <lihaiwei@tencent.com>
> > > > >
> > > > > In my test environment, advance_expire_delta is frequently greater than
> > > > > the fixed LAPIC_TIMER_ADVANCE_ADJUST_MAX. And this will hinder the
> > > > > adjustment.
> > > >
> > > > Supplementary details:
> > > >
> > > > I have tried to backport timer related features to our production
> > > > kernel.
> > > >
> > > > After completed, i found that advance_expire_delta is frequently greater
> > > > than the fixed value. It's necessary to trun the fixed to dynamically
> > > > values.
> > >
> > > Does this reproduce on an upstream kernel?  If so...
> > >
> > >   1. How much over the 10k cycle limit is the delta?
> > >   2. Any idea what causes the large delta?  E.g. is there something that can
> > >      and/or should be fixed elsewhere?
> > >   3. Is it platform/CPU specific?
> >
> > Hi, Sean
> >
> > I have traced the flow on our production kernel and it frequently consumes more
> > than 10K cycles from sched_out to sched_in.
> > So two scenarios tested on Cascade lake Server(96 pcpu), v5.11 kernel.
> >
> > 1. only cyclictest in guest(88 vcpu and bound with isolated pcpus, w/o mwait
> > exposed, adaptive advance lapic timer is default -1). The ratio of occurrences:
> >
> > greater_than_10k/total: 29/2060, 1.41%
> >
> > 2. cyclictest in guest(88 vcpu and not bound, w/o mwait exposed, adaptive
> > advance lapic timer is default -1) and stress in host(no isolate). The ratio of
> > occurrences:
> >
> > greater_than_10k/total: 122381/1017363, 12.03%
>
> Hmm, I'm inclined to say this is working as intended.  If the vCPU isn't affined
> and/or it's getting preempted, then large spikes are expected, and not adjusting
> in reaction to those spikes is desirable.  E.g. adjusting by 20k cycles because
> the timer happened to expire while a vCPU was preempted will cause KVM to busy
> wait for quite a long time if the next timer runs without interference, and then
> KVM will thrash the advancement.
>
> And I don't really see the point in pushing the max adjustment beyond 10k.  The
> max _advancement_ is 5000ns, which means that even with a blazing fast 5.0ghz
> system, a max adjustment of 1250 (10k/ 8, the step divisor) should get KVM to
> the 25000 cycle advancement limit relatively quickly.  Since KVM resets to the
> initial 1000ns advancement when it would exceed the 5000ns max, I suspect that
> raising the max adjustment much beyond 10k cycles would quickly push a vCPU to
> the max, cause it to reset, and rinse and repeat.
>
> Note, we definitely don't want to raise the 5000ns max, as waiting with IRQs
> disabled for any longer than that will likely cause system instability.

I see. Thanks for your explanation.

--
Haiwei Li
