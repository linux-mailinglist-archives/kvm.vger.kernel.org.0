Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE650414E3F
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 18:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbhIVQn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 12:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbhIVQn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 12:43:29 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D527C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 09:41:59 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r2so3276341pgl.10
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 09:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w/1nIjS1pR/BMa2LK65yEOi3Hq5xS/P5gB9o8jgpYKw=;
        b=KZDbB3RxQ0VMOwovNaGjl7RLqI9ZnTIb1VHkL3kAlZuqRVowwmH3pX977W7rGiI1HI
         fwLvziArfQygO6wW88DP4K1jGzRCpyJCOLyZVoIrOJ7G9NiJR7NhROEEq9GiBoTmdwvT
         uSEByw4ih4N12zVGeuwXj+DCMSEs4MjzTeqXm1iNCKMperBKc0c5UhSZfjrtRXqUlRQI
         JyByTzYvbXO495cpph7STzk0ZskVBe0EMq+OrZFMeFoxIrFnJ19FUSKdZfQKLn5Gllaq
         NRilLlyJBshEgZ1DYLTuikwfwbnWx4k5nuJRpgYFYCWaEuPGCr4CcoWW8pCF+0oO7PBA
         t9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w/1nIjS1pR/BMa2LK65yEOi3Hq5xS/P5gB9o8jgpYKw=;
        b=K1WF2tYIOs4ujroa+1T5kKv2sTOrlH670IaauvYcl1iOFYRyFyrqFZztnGYppszB1F
         cx9YWOrnms4dF/pPNdlwduR436OOEi7dqonBcBWjRDJZa5hcL1jXVQNkDWPgGtgrTSfC
         FeO866Ej7tC4cBrp4IwuARbBU7rT+QXZ/UlAdeGONqmemfAmRCqHqgd/heC53ow5XPuN
         oqKANlielUNQc3hZgnvzxqrdt4P/LVoM73k540iJW5cI6FzB/XNrkxDDVeANFEAu+D4h
         pXfRjbFyoZDtP2atOOinmxFMzS/ePCGLtxbyg3BGFrFZh0R7XIz3I16Fu7C2LP7+LnqQ
         5JZQ==
X-Gm-Message-State: AOAM532ZKF284wLj3pynvx22Ln+ifs6F6lSI0i0LU7q0l1r+OFejjZYS
        P3uhTSklCySzTz97iBXAxabWYA==
X-Google-Smtp-Source: ABdhPJxoK5oxChA4gyYS9Ip12fecq2p82dmYchM1qSIZQAwFHN+ayp4BFIQ2kL3XYQmuXtCrQm0xbQ==
X-Received: by 2002:aa7:9f5e:0:b0:447:baeb:bc4e with SMTP id h30-20020aa79f5e000000b00447baebbc4emr360687pfr.64.1632328918469;
        Wed, 22 Sep 2021 09:41:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p48sm3044765pfw.160.2021.09.22.09.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:41:58 -0700 (PDT)
Date:   Wed, 22 Sep 2021 16:41:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] KVM: stats: add stats to detect if vcpu is currently
 halted
Message-ID: <YUtc0ptnxDx8ti9v@google.com>
References: <20210817230508.142907-1-jingzhangos@google.com>
 <YRxKZXm68FZ0jr34@google.com>
 <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
 <CAJfu=UcwHWzqCvTjniAMkGj1mmjw9QCy5a-fGJ2mxTK8EFW7Dg@mail.gmail.com>
 <YR7dJflS7yBR52tL@google.com>
 <CAAdAUtj-Y_MuaeqAHKonNTBDR=kjjmWP__Siqjv5=AxvZbe-Bw@mail.gmail.com>
 <YUtcMi3ft+my2JwF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUtcMi3ft+my2JwF@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021, Sean Christopherson wrote:
> On Fri, Aug 20, 2021, Jing Zhang wrote:
> > Hi Sean,
> > 
> > On Thu, Aug 19, 2021 at 3:37 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Wed, Aug 18, 2021, Cannon Matthews wrote:
> > > > Since a guest has explictly asked for a vcpu to HLT, this is "useful work on
> > > > behalf of the guest" even though the thread is "blocked" from running.
> > > >
> > > > This allows answering questions like, are we spending too much time waiting
> > > > on mutexes, or long running kernel routines rather than running the vcpu in
> > > > guest mode, or did the guest explictly tell us to not doing anything.
> > > >
> > > > So I would suggest keeping the "halt" part of the counters' name, and remove
> > > > the "blocked" part rather than the other way around. We explicitly do not
> > > > want to include non-halt blockages in this.
> > >
> > > But this patch does include non-halt blockages, which is why I brought up the
> > > technically-wrong naming.  Specifically, x86 reaches this path for any !RUNNABLE
> > > vCPU state, e.g. if the vCPU is in WFS.  Non-x86 usage appears to mostly call
> > > this for halt-like behavior, but PPC looks like it has at least one path that's
> > > not halt-like.
> > >
> > > I doubt anyone actually cares if the stat is a misnomer in some cases, but at the
> > > same time I think there's opportunity for clean up here.  E.g. halt polling if a
> > > vCPU is in WFS or UNINITIALIZED is a waste of cycles.  Ditto for the calls to
> > > kvm_arch_vcpu_blocking() and kvm_arch_vcpu_unblocking() when halt polling is
> > > successful, e.g. arm64 puts and reloads the vgic, which I assume is a complete
> > > waste of cycles if the vCPU doesn't actually block.  And kvm_arch_vcpu_block_finish()
> > > can be dropped by moving the one line of code into s390, which can add its own
> > > wrapper if necessary.
> > >
> > > So with a bit of massaging and a slight change in tracing behavior, I believe we
> > > can isolate the actual wait/halt and avoid "halted" being technically-wrong, and
> > > fix some inefficiencies at the same time.
> > >
> > > Jing, can you do a v2 of this patch and send it to me off-list?  With luck, my
> > > idea will work and I can fold your patch in, and if not we can always post v2
> > > standalone in a few weeks.
> 
> Circling back to this with fresh eyes, limiting the state to "halted" would be
> wrong.  I still stand by my assertion that non-halt states such as WFS should not
> go through halt polling, but the intent of the proposed stat is to differentiate
> between not running a vCPU because of a guest action and not running a vCPU because
> the host is not scheduling its task.
> 
> E.g. on x86, if a vCPU is put into WFS for an extended time, the vCPU will not be
> run because of a guest action, not because of any host activity.  But again, WFS
> has very different meaning than "halt", which was the basis for my original
> objection to the "halt_block" terminology.
> 
> One option would be to invert the stat, e.g. vcpu->stat.runnable, but that has the
> downside of needed to be set somewhere outside of kvm_vcpu_block/halt(), and it
> would likely be difficult to come up with a name that isn't confusing, e.g. the
> vCPU would show up as "runnable" when mp_state!=RUNNABLE and it's not actively
> blocking.
> 
> Back to bikeshedding the "halted" name, what about "blocking" or "waiting"?  I.e.
> switch from past tense to present tense to convey that the _vCPU_ is "actively"
> blocking/waiting, as opposed to the vCPU being blocked by some host condition.

Doh, forgot to say that "blocking" would be my first choice as it would match KVM's
internal "block" terminology.
