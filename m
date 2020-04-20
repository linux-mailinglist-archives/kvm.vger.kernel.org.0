Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB561B12D5
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgDTRSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 13:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726751AbgDTRSy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 13:18:54 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3882C061A0C
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 10:18:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i3so11828956ioo.13
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 10:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2yYQlajUgoPYm5+zy+bVD+SB8XFq0reLziiAJrB2J80=;
        b=IH/7IBlQ5QXy6cBXip4X62wGccLAKcy35JGY955yj6MOVOLrHeFfDRCoAFGI8d8QMl
         abFGr7CcGVvnNiNNXwxIjT7oZp05Jc0+ysl8ZalRfuA3it4+wZrfmXhz5Le8OL1eCZky
         VpS7HHvNT+249MMF5CyMvk7g3/pcFRlw6D4KWP/5p2+W9F7pH8jJvuTucr4KrVyFhhIm
         8v6et+hiAxBI/a5Fu4Wb3qnIDGNjeBdwIG/m8WwsriroVOpSMp1rm3H28mwmCA7KEpOR
         1taDzuOWrKUI4XNsp4Z2KEwgwrCaABt81c9s8Ct+fNV91EBrz8hFuigRBbT1iRrDRmfv
         I9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2yYQlajUgoPYm5+zy+bVD+SB8XFq0reLziiAJrB2J80=;
        b=s5svYVFO2jR3fIs36m90YJLeBMm8MFqftZEPj7RAhiji1/767HGdMhmbOuOlVqOOVR
         MtmXTA1t8O9Mmmg46CuZLaK6NIJyQeNLVYJVDiK0HOeHT+ET2GjCzQvachGSpW13N0pN
         BWND/21VZF//77zDYNrP8GLJsxKwQf03y5V3E+4/Pr7spMT3s0BKCCF+zeuhhTL7yN5w
         QomNXvX17lxRid2p3wn4jMjdfyVzYUKMdHH73qwknM8AekQA7CrjsGsj57Omjlgb7NST
         PmIp4zBGUjj4v2sEQswvphMl/dK6Ku0HWCH+f5lLWmSzFTXALM9C0MrK2J3SN9JgLQUC
         fP4Q==
X-Gm-Message-State: AGi0Pua/nIoY9CAia6al/4ltwI5zePXBLRxV3rpgY+dHBy+0NCDfi9Cd
        259+83IQwmLVqzK69H2poQV/7VLZgGbtCafhviEnfQ==
X-Google-Smtp-Source: APiQypK6pmdlGaDyrlJblLJ+gLZRKYPdpGTkx3GZX1f6uqrpH17ziF/9To/AN9OJf2m3pYl/OK7DJruldv+HAW+66OU=
X-Received: by 2002:a02:b09:: with SMTP id 9mr9355668jad.24.1587403133734;
 Mon, 20 Apr 2020 10:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200414000946.47396-1-jmattson@google.com> <20200414000946.47396-2-jmattson@google.com>
 <20200414031705.GP21204@linux.intel.com> <CALMp9eT23AUTU3m_oADKw3O_NMpuX3crx7eqSB8Rbgh3k0s_Jw@mail.gmail.com>
 <20200415001212.GA12547@linux.intel.com> <CALMp9eS-s5doptTzVkE2o9jDYuGU3T=5azMhm3fCqLJPcABAOg@mail.gmail.com>
 <20200418042108.GF15609@linux.intel.com>
In-Reply-To: <20200418042108.GF15609@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 20 Apr 2020 10:18:42 -0700
Message-ID: <CALMp9eQpwnhD7H3a9wC=TnL3=OKmvHAmVFj=r9OBaWiBEGhR4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 9:21 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Apr 15, 2020 at 04:33:31PM -0700, Jim Mattson wrote:
> > On Tue, Apr 14, 2020 at 5:12 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Tue, Apr 14, 2020 at 09:47:53AM -0700, Jim Mattson wrote:
> > > > Regarding -EBUSY, I'm in complete agreement. However, I'm not sure
> > > > what the potential confusion is regarding the event. Are you
> > > > suggesting that one might think that we have a #DB to deliver to L1
> > > > while we're in guest mode? IIRC, that can happen under SVM, but I
> > > > don't believe it can happen under VMX.
> > >
> > > The potential confusion is that vcpu->arch.exception.pending was already
> > > checked, twice.  It makes one wonder why it needs to be checked a third
> > > time.  And actually, I think that's probably a good indicator that singling
> > > out single-step #DB isn't the correct fix, it just happens to be the only
> > > case that's been encountered thus far, e.g. a #PF when fetching the instr
> > > for emulation should also get priority over the preemption timer.  On real
> > > hardware, expiration of the preemption timer while vectoring a #PF wouldn't
> > > wouldn't get recognized until the next instruction boundary, i.e. at the
> > > start of the first instruction of the #PF handler.  Dropping the #PF isn't
> > > a problem in most cases, because unlike the single-step #DB, it will be
> > > re-encountered when L1 resumes L2.  But, dropping the #PF is still wrong.
> >
> > Yes, it's wrong in the abstract, but with respect to faults and the
> > VMX-preemption timer expiration, is there any way for either L1 or L2
> > to *know* that the virtual CPU has done something wrong?
>
> I don't think so?  But how is that relevant, i.e. if we can fix KVM instead
> of fudging the result, why wouldn't we fix KVM?

I'm not sure that I can fix KVM. The missing #DB traps were relatively
straightforward, but as for the rest of this mess...

Since you seem to have a handle on what needs to be done, I will defer to you.

> > Isn't it generally true that if you have an exception queued when you
> > transition from L2 to L1, then you've done something wrong? I wonder
> > if the call to kvm_clear_exception_queue() in prepare_vmcs12() just
> > serves to sweep a whole collection of problems under the rug.
>
> More than likely, yes.
>
> > > In general, interception of an event doesn't change the priority of events,
> > > e.g. INTR shouldn't get priority over NMI just because if L1 wants to
> > > intercept INTR but not NMI.
> >
> > Yes, but that's a different problem altogether.
>
> But isn't the fix the same?  Stop processing events if a higher priority
> event is pending, regardless of whether the event exits to L1.

That depends on how you see the scope of the problem. One could argue
that the fix for everything that is wrong with KVM is actually the
same: properly emulate the physical CPU.
