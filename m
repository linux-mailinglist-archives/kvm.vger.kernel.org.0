Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFB61A859B
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440261AbgDNQsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440012AbgDNQsI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 12:48:08 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B80C061A0E
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 09:48:05 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s18so10576962ioe.10
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 09:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q8Ck4hl4OJdZJ207CgwIdwKLJA2rve9JgZyBndXCjLk=;
        b=C6lKtFXa+3PZ4mDEkiHdFhUuIfhw9kBaURBl6+ldjScXgWUtgTexfOUxUj4Vp3dNaK
         DNQO/ieqjGTsbca2qb6xHDzgshsdlSaC6DYYXNGoehkEMErpQK7XIGBfLoxS/3oYWMEZ
         LRFz9yAfGf+3Xudg/nJpPnXnx7e57/cW9beH7h6lc+GCXWq8Unw45Ey8DO4DtaOLwmI9
         4WsFsQtCdpk2kCeVgQP8Qx13V2UlU3p72e2uoF+fj0sRFuwsg/LrEntwAzqfWGrlkjgQ
         Yx/hrspJ2kR0/kpuPfOnDsjabe/4AYNt0UixUz7gtDxDV0PUMIDJUIz3IwPtOpbNtRld
         +9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q8Ck4hl4OJdZJ207CgwIdwKLJA2rve9JgZyBndXCjLk=;
        b=M0Da339nTDt0OyN5oR3KiOY2/ELMmgI2WBqzynNzPCmQQPKdUbE5hl7wpICFaMG3T6
         Ex/XdTCQ7fEr8ZZ2QmzNGCQj3CfN8ri9tgpdSLS9hQINbKsyOxYQ/P4S2jP4hRSi71vI
         REWoAV4CXYdHUodR3j4T2ss9iZhqHy6KoonqOLXLuUMG3Y3Ntix9XJOLqrY036eNwNSZ
         t6NGWxXbSSqIRepq23XuxOptmtMhbot7GnQdaW8xU7mQYF0xVlV6YmD5kF+MKA3ypaCE
         inbiLNe2FT7waaC8xvme+oflxnfL9YjKX8gXWgxcShB0L39QDyko8tRoe13Tm1t3kgqj
         MlrQ==
X-Gm-Message-State: AGi0PuZVuz1lDllELiMCvduTOgXDijLyB7TLyIfE5jdy1TLJi61vlBeC
        IMQdHQDrdTDXZLtitC8X5PBsHb4Yqe2nBjKz3twOmA==
X-Google-Smtp-Source: APiQypIjnaHRApNsTxubTGGk0T6gKisYDbZgSJJIhICT6gonlgzeyY79bVIQtRn88c4jx1bwupS44CP8pzkQo+lQN9U=
X-Received: by 2002:a6b:91d4:: with SMTP id t203mr4164472iod.70.1586882884120;
 Tue, 14 Apr 2020 09:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200414000946.47396-1-jmattson@google.com> <20200414000946.47396-2-jmattson@google.com>
 <20200414031705.GP21204@linux.intel.com>
In-Reply-To: <20200414031705.GP21204@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 14 Apr 2020 09:47:53 -0700
Message-ID: <CALMp9eT23AUTU3m_oADKw3O_NMpuX3crx7eqSB8Rbgh3k0s_Jw@mail.gmail.com>
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

On Mon, Apr 13, 2020 at 8:17 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Apr 13, 2020 at 05:09:46PM -0700, Jim Mattson wrote:
> > Previously, if the hrtimer for the nested VMX-preemption timer fired
> > while L0 was emulating an L2 instruction with RFLAGS.TF set, the
> > synthesized single-step trap would be unceremoniously dropped when
> > synthesizing the "VMX-preemption timer expired" VM-exit from L2 to L1.
> >
> > To fix this, don't synthesize a "VMX-preemption timer expired" VM-exit
> > from L2 to L1 when there is a pending debug trap, such as a
> > single-step trap.
> >
> > Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index cbc9ea2de28f..6ab974debd44 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3690,7 +3690,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >           vmx->nested.preemption_timer_expired) {
> >               if (block_nested_events)
> >                       return -EBUSY;
> > -             nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER, 0, 0);
> > +             if (!vmx_pending_dbg_trap(vcpu))
>
> IMO this one warrants a comment.  It's not immediately obvious that this
> only applies to #DBs that are being injected into L2, and that returning
> -EBUSY will do the wrong thing.

Regarding -EBUSY, I'm in complete agreement. However, I'm not sure
what the potential confusion is regarding the event. Are you
suggesting that one might think that we have a #DB to deliver to L1
while we're in guest mode? IIRC, that can happen under SVM, but I
don't believe it can happen under VMX.

> > +                     nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER,
> > +                                       0, 0);
>
> I'd just let the "0, 0);" poke out past 80 chars.

Oh, you rascal, you!

> >               return 0;
> >       }
> >
> > --
> > 2.26.0.110.g2183baf09c-goog
> >
