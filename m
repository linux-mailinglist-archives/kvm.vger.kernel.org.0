Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AC4339AA3
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhCMA6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbhCMA6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:58:35 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FEEC061761
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 16:58:35 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t26so16938804pgv.3
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 16:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ijwEY5seUvikPHlLtMvsL+UlWO8z6KOmpflRgZnanK4=;
        b=VyNXIQDCws0Uyu/yTLbfUn6na1w2236AdGbJOejDPq5EPnaSBfijUXla5oa1KTvOWf
         HBffDwtWgCd/cthH/3TcHKyNMoNrPmGiCb/Fnr7iF94hqLOpzH/glATtKAnvNMXSre8J
         dF7umvUKIX6vMDxUZxbA8+su8YW9aeNUcqTUadfm6pn0kxgMV4IcBd5vYIZX8KsfeatF
         QqH/Ocd+eEwW1/2cISwZZWAQl2ri9RXheRLiiXDK+SaOEj7talZ8Yy74maCMlz0ELH/k
         eslXdIxFRoW+FthIlosm8Ufz04I8TG6jt7xnQZVDEEKOIipEL/4p2bDxtyBI8sOIRQ3f
         uTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ijwEY5seUvikPHlLtMvsL+UlWO8z6KOmpflRgZnanK4=;
        b=KL5/XK0/53d5vnNgYm7lwFG/YyJJCXrI0SzYWAP8gpW7wDEcdeCASe5z/7D0tAhz5b
         /5GxLe0HWM53aZbmTm1E0qnuj1abXwRpiUYv/qqAXZnZHF7S5JmRf2FzvxuIcGfebSBt
         65B/DwiYgKHhe5LJteeX9ujVIP1OYd9oUrXZhn3l1p1BRAT71nBh5aqK96/uBvO4njQh
         HSDpP0I5oxY7CFGeBRxy+35B2mFz0nW2uP4l3hUNui1vVuMauOb+fjZZafYTXJtOW7vr
         qDyqBKDPdbUiF7JvOXhJI5Us2fUD4P6w38L2z3Z67zuhOT/MmXjKMxEtBCHRdti4mjPT
         j++g==
X-Gm-Message-State: AOAM533dgOLAx3TwAOe1nQ+SvZp9TgETBktxlmvdEjW7bdhUAgRflcJD
        10KDvpk9wRhU4cJWW11baJoGlw==
X-Google-Smtp-Source: ABdhPJwYCcOwiZ8IAICNl2JdLQLbVVB2pdQ0v+KQC1S+EZebMgULWsbiDIA6/wFjLI4gOAUvJJGCyg==
X-Received: by 2002:a63:5924:: with SMTP id n36mr14576824pgb.183.1615597115143;
        Fri, 12 Mar 2021 16:58:35 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id s1sm3200148pjo.36.2021.03.12.16.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 16:58:34 -0800 (PST)
Date:   Fri, 12 Mar 2021 16:58:27 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH] kvm: lapic: add module parameters for
 LAPIC_TIMER_ADVANCE_ADJUST_MAX/MIN
Message-ID: <YEwOM3aTeUjVim/i@google.com>
References: <20210303020946.26083-1-lihaiwei.kernel@gmail.com>
 <03239d81-df56-a6c9-c79d-c14d22f62705@gmail.com>
 <YEgH11nNwdCkF5kT@google.com>
 <CAB5KdOZkdXsLup+58On=LZ6eG4jYdcaK2NCt9U0Q-qy_6dQrfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB5KdOZkdXsLup+58On=LZ6eG4jYdcaK2NCt9U0Q-qy_6dQrfw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021, Haiwei Li wrote:
> On Wed, Mar 10, 2021 at 7:42 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Mar 03, 2021, Haiwei Li wrote:
> > > On 21/3/3 10:09, lihaiwei.kernel@gmail.com wrote:
> > > > From: Haiwei Li <lihaiwei@tencent.com>
> > > >
> > > > In my test environment, advance_expire_delta is frequently greater than
> > > > the fixed LAPIC_TIMER_ADVANCE_ADJUST_MAX. And this will hinder the
> > > > adjustment.
> > >
> > > Supplementary details:
> > >
> > > I have tried to backport timer related features to our production
> > > kernel.
> > >
> > > After completed, i found that advance_expire_delta is frequently greater
> > > than the fixed value. It's necessary to trun the fixed to dynamically
> > > values.
> >
> > Does this reproduce on an upstream kernel?  If so...
> >
> >   1. How much over the 10k cycle limit is the delta?
> >   2. Any idea what causes the large delta?  E.g. is there something that can
> >      and/or should be fixed elsewhere?
> >   3. Is it platform/CPU specific?
> 
> Hi, Sean
> 
> I have traced the flow on our production kernel and it frequently consumes more
> than 10K cycles from sched_out to sched_in.
> So two scenarios tested on Cascade lake Server(96 pcpu), v5.11 kernel.
> 
> 1. only cyclictest in guest(88 vcpu and bound with isolated pcpus, w/o mwait
> exposed, adaptive advance lapic timer is default -1). The ratio of occurrences:
> 
> greater_than_10k/total: 29/2060, 1.41%
> 
> 2. cyclictest in guest(88 vcpu and not bound, w/o mwait exposed, adaptive
> advance lapic timer is default -1) and stress in host(no isolate). The ratio of
> occurrences:
> 
> greater_than_10k/total: 122381/1017363, 12.03%

Hmm, I'm inclined to say this is working as intended.  If the vCPU isn't affined
and/or it's getting preempted, then large spikes are expected, and not adjusting
in reaction to those spikes is desirable.  E.g. adjusting by 20k cycles because
the timer happened to expire while a vCPU was preempted will cause KVM to busy
wait for quite a long time if the next timer runs without interference, and then
KVM will thrash the advancement.

And I don't really see the point in pushing the max adjustment beyond 10k.  The
max _advancement_ is 5000ns, which means that even with a blazing fast 5.0ghz
system, a max adjustment of 1250 (10k/ 8, the step divisor) should get KVM to
the 25000 cycle advancement limit relatively quickly.  Since KVM resets to the
initial 1000ns advancement when it would exceed the 5000ns max, I suspect that
raising the max adjustment much beyond 10k cycles would quickly push a vCPU to
the max, cause it to reset, and rinse and repeat.

Note, we definitely don't want to raise the 5000ns max, as waiting with IRQs
disabled for any longer than that will likely cause system instability.
