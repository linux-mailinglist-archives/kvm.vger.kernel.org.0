Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76235414E39
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 18:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhIVQku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 12:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhIVQkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 12:40:49 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D30AC061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 09:39:19 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 203so3150469pfy.13
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 09:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3qNsCqzURZinXbLFuQNjiO/gBPpr2R5ooh/l/vdge94=;
        b=Jh+BgeHEYUQm5JD8S0lgCJH8AjskRVQm95/I2liCm0E59kqs6SgZowxQjoM65zOIFC
         aZxuIyhDjOXT9FSiiFEKn4dtSr/T5qPTzgeMTHGZ53vGYN+cZF1cK/Lq6MJS6vhPl/Ig
         Ho/9YS95uU5yUFt0Xa7t0OIqpgue6zaTbcTDwZUjQEoZUgCM/kzAOXRLDaCuxOlL3c+y
         9JC9s9XtXT2H25RD+uqhSDr5OY7AB/S4B6nb2cjQg9VdU6xaWYKmfo2JfaIago437G1y
         WJjI829qcK75/24nyBBm9ZekY+c2dfQ6iGYNw06mUg8RMjeXtrPUSuBFMdtZrY2jOBmj
         1HIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3qNsCqzURZinXbLFuQNjiO/gBPpr2R5ooh/l/vdge94=;
        b=pmLBPEg+2egY+W9dCH0w1/w2spL8vl1/7O9t9P7ix2pSFps4RT5hgMcE9r4Hmg1E7B
         e8i9RdS6t560Kvv8aPXqoevRufO6574MPkClZtRCEIVYQ+y2M/i0qlcS3PaM2grcYZpq
         3FC3vmFDKPGa+Sy/PQvdE8qc27pQ0q6V8JHtazrnn37NN/CdUnr7jUU/Ui4Rb9G61e+o
         zI3dVCLBz7DWF5kUjMM7gYo7KpWRR5yXX+ngDwqxjpHWBI+gBku4RBooWKAABot4WOej
         1LfgaysKVZrUTHYEs+uv3iz2NOrNIsdRkIPrfUu/72xaee+JWcp8K2GraVAjk5RvIPfE
         XJ2w==
X-Gm-Message-State: AOAM530WzcScUteEIzNdi9J6ORZ9cMHhPE4sAKtmt0zfbEespIcHLaRW
        QJMytmhzfIBjaJrK3IGhtL8dUg==
X-Google-Smtp-Source: ABdhPJzYcMN0lGvO315wHJ8OvrVK+OCoXRH7zN/2kOOuU098nIvFhp6HlA9xQUwnkcv2VNK8PDR7tw==
X-Received: by 2002:a63:7447:: with SMTP id e7mr563628pgn.240.1632328758543;
        Wed, 22 Sep 2021 09:39:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d22sm40908pjz.27.2021.09.22.09.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:39:17 -0700 (PDT)
Date:   Wed, 22 Sep 2021 16:39:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] KVM: stats: add stats to detect if vcpu is currently
 halted
Message-ID: <YUtcMi3ft+my2JwF@google.com>
References: <20210817230508.142907-1-jingzhangos@google.com>
 <YRxKZXm68FZ0jr34@google.com>
 <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
 <CAJfu=UcwHWzqCvTjniAMkGj1mmjw9QCy5a-fGJ2mxTK8EFW7Dg@mail.gmail.com>
 <YR7dJflS7yBR52tL@google.com>
 <CAAdAUtj-Y_MuaeqAHKonNTBDR=kjjmWP__Siqjv5=AxvZbe-Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdAUtj-Y_MuaeqAHKonNTBDR=kjjmWP__Siqjv5=AxvZbe-Bw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021, Jing Zhang wrote:
> Hi Sean,
> 
> On Thu, Aug 19, 2021 at 3:37 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Aug 18, 2021, Cannon Matthews wrote:
> > > Since a guest has explictly asked for a vcpu to HLT, this is "useful work on
> > > behalf of the guest" even though the thread is "blocked" from running.
> > >
> > > This allows answering questions like, are we spending too much time waiting
> > > on mutexes, or long running kernel routines rather than running the vcpu in
> > > guest mode, or did the guest explictly tell us to not doing anything.
> > >
> > > So I would suggest keeping the "halt" part of the counters' name, and remove
> > > the "blocked" part rather than the other way around. We explicitly do not
> > > want to include non-halt blockages in this.
> >
> > But this patch does include non-halt blockages, which is why I brought up the
> > technically-wrong naming.  Specifically, x86 reaches this path for any !RUNNABLE
> > vCPU state, e.g. if the vCPU is in WFS.  Non-x86 usage appears to mostly call
> > this for halt-like behavior, but PPC looks like it has at least one path that's
> > not halt-like.
> >
> > I doubt anyone actually cares if the stat is a misnomer in some cases, but at the
> > same time I think there's opportunity for clean up here.  E.g. halt polling if a
> > vCPU is in WFS or UNINITIALIZED is a waste of cycles.  Ditto for the calls to
> > kvm_arch_vcpu_blocking() and kvm_arch_vcpu_unblocking() when halt polling is
> > successful, e.g. arm64 puts and reloads the vgic, which I assume is a complete
> > waste of cycles if the vCPU doesn't actually block.  And kvm_arch_vcpu_block_finish()
> > can be dropped by moving the one line of code into s390, which can add its own
> > wrapper if necessary.
> >
> > So with a bit of massaging and a slight change in tracing behavior, I believe we
> > can isolate the actual wait/halt and avoid "halted" being technically-wrong, and
> > fix some inefficiencies at the same time.
> >
> > Jing, can you do a v2 of this patch and send it to me off-list?  With luck, my
> > idea will work and I can fold your patch in, and if not we can always post v2
> > standalone in a few weeks.

Circling back to this with fresh eyes, limiting the state to "halted" would be
wrong.  I still stand by my assertion that non-halt states such as WFS should not
go through halt polling, but the intent of the proposed stat is to differentiate
between not running a vCPU because of a guest action and not running a vCPU because
the host is not scheduling its task.

E.g. on x86, if a vCPU is put into WFS for an extended time, the vCPU will not be
run because of a guest action, not because of any host activity.  But again, WFS
has very different meaning than "halt", which was the basis for my original
objection to the "halt_block" terminology.

One option would be to invert the stat, e.g. vcpu->stat.runnable, but that has the
downside of needed to be set somewhere outside of kvm_vcpu_block/halt(), and it
would likely be difficult to come up with a name that isn't confusing, e.g. the
vCPU would show up as "runnable" when mp_state!=RUNNABLE and it's not actively
blocking.

Back to bikeshedding the "halted" name, what about "blocking" or "waiting"?  I.e.
switch from past tense to present tense to convey that the _vCPU_ is "actively"
blocking/waiting, as opposed to the vCPU being blocked by some host condition.
