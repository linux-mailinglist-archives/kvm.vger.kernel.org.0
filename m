Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D8238F61C
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhEXXMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhEXXMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:12:18 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601BCC061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:10:50 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so12061652pjv.1
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HUZilAVGNi7F7obaReri3w6NijNyqOb7asxhnNccAtk=;
        b=wMM8K0Ran1isBsRpKuIvl5WbzBzgVfL16R8zEU/UKFgeAnCdCYbXxm1keRlvELuwqV
         SfgXaS0JtUbVKrrv8r6/mh64LhyZpd+tmAs59u5UqS5ka6xzroiYkiUdKICxG95ewQrH
         EBXa45zbn6HavfZ0NqQt7njJ5UARYEOJ5rHy3vXzrRV90Fg4+XPdJRqVrLnQZi7HeBJx
         ptKwWUZZEbSog/PO80vnsMQeMlIL4DRbuv/yEtw8pgPD8Io0Ka+8mkIWyhK5a/1o4NxS
         CY0R2avHlmsrgEls2TEyxCy4lciayzRpG7HZut4JeXpLtodOsbdkYu2qKZNEIvxqSCk4
         CzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HUZilAVGNi7F7obaReri3w6NijNyqOb7asxhnNccAtk=;
        b=se4ZLt2TGH9l3soDv+TUhsPR8TtIaZ2Az0UQV6Xme3hyYLeiWGqVDYqMhGcfiQzIMS
         iSsI3bt87hSK+HlwE+6IfBTB3kePNvgp7z8OBFX7kOMM41XssANuDvRD4y5qtn9HqDkM
         WQUhn0NzcGJWRrjCAht3khVPInwnw2dNL8rX06chWu/0hp7XoCVx1Ne2mPy4K5mt7YBt
         kF6fZ0P1HX/IlLL5gsyONGyOrjDcIElKBRdarMyUy7+6puDOyrFBovdkOSn2ERdzggii
         lfOUnZCDUURTH8SHEcKGvxsydpxpeFH1rMBfxySg8R4WgMEH08xAEHMsGBNqsA1bFoS8
         /wFQ==
X-Gm-Message-State: AOAM532F9FflGvwqYZ5OGGPGGwTferuMT29h8vqyuy21zTP5N8YCoHLH
        PwVs7+If7pld93P6Ml+mwkYL6g==
X-Google-Smtp-Source: ABdhPJw5sMHnZ73SJNfjEItFFgzMnoLBQUmZE2wiQiMHiaELPLxnAiLqlIevfSvr+BCtsd8h4Yajew==
X-Received: by 2002:a17:90a:8048:: with SMTP id e8mr8078376pjw.206.1621897849733;
        Mon, 24 May 2021 16:10:49 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s2sm397516pjz.41.2021.05.24.16.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:10:49 -0700 (PDT)
Date:   Mon, 24 May 2021 23:10:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 02/12] KVM: x86: Wake up a vCPU when
 kvm_check_nested_events fails
Message-ID: <YKwydQlAXHeockLx@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
 <20210520230339.267445-3-jmattson@google.com>
 <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com>
 <CALMp9eQ0LQoesyRYA+PN=nzjLDVXjpNw6OxgupmL8vOgWqjiMA@mail.gmail.com>
 <e2ed4a75-e7d2-e391-0a19-5977bf087cdf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2ed4a75-e7d2-e391-0a19-5977bf087cdf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Paolo Bonzini wrote:
> On 24/05/21 18:39, Jim Mattson wrote:
> > Without this patch, the accompanying selftest never wakes up from HLT
> > in L2. If you can get the selftest to work without this patch, feel
> > free to drop it.
> 
> Ok, that's a pretty good reason.  I'll try to debug it.

I don't think there's any debug necessary, the hack of unconditionally calling
kvm_check_nested_events() in kvm_vcpu_running() handles the case where a pending
event/exception causes nested VM-Exit, but doesn't handle the case where KVM
can't immediately service the nested VM-Exit.  Because the event is never
serviced (doesn't cause a VM-Exit) and doesn't show up as a pending event,
kvm_vcpu_has_events() and thus kvm_arch_vcpu_runnable() will never become true,
i.e. the vCPU gets stuck in L2 HLT.

Until Jim's selftest, that was limited to the "request immediate exit" case,
which meant that to hit the bug a VM-Exiting event needed to collide with nested
VM-Enter that also put L2 into HLT state without a different pending wake event.

Jim's selftest adds a more direct path in the form of the -EXNIO when the PI
descriptor hits a memslot hole.

The proper fix is what we discussed in the other thread; get kvm_vcpu_has_events()
to return true if there's a nested event pending.

If I'm right, this hack-a-fix should go to stable.  Eww...

> > On Mon, May 24, 2021 at 8:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > 
> > > On 21/05/21 01:03, Jim Mattson wrote:
> > > > At present, there are two reasons why kvm_check_nested_events may
> > > > return a non-zero value:
> > > > 
> > > > 1) we just emulated a shutdown VM-exit from L2 to L1.
> > > > 2) we need to perform an immediate VM-exit from vmcs02.
> > > > 
> > > > In either case, transition the vCPU to "running."
> > > > 
> > > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > Reviewed-by: Oliver Upton <oupton@google.com>
> > > > ---
> > > >    arch/x86/kvm/x86.c | 4 ++--
> > > >    1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index d517460db413..d3fea8ea3628 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -9468,8 +9468,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
> > > > 
> > > >    static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
> > > >    {
> > > > -     if (is_guest_mode(vcpu))
> > > > -             kvm_check_nested_events(vcpu);
> > > > +     if (is_guest_mode(vcpu) && kvm_check_nested_events(vcpu))
> > > > +             return true;
> > > 
> > > That doesn't make the vCPU running.  You still need to go through
> > > vcpu_block, which would properly update the vCPU's mp_state.
> > > 
> > > What is this patch fixing?
> > > 
> > > Paolo
> > > 
> > > >        return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
> > > >                !vcpu->arch.apf.halted);
> > > > 
> > > 
> > 
> 
