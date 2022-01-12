Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ED648C968
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 18:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343735AbiALRaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 12:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242291AbiALRax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 12:30:53 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F22C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:30:53 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id h1so4924252pls.11
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vFQ0QfKt8ga37QIIvqNsjSNZkD24gXDN5WUMAyYwg18=;
        b=LksUgVYeBE1Cl74FXYb8lodhHdMq8VqPCV67Fe/s9SuyiVeDviP/Nut0lKrSEwe37E
         z9qODeZagA27DH7WQNStmuxlaMF1Rhjek6j1JDBWGjn9TwZWSDDxaxYt6MuEichiHu4A
         BB+qms4E7R0qAB0Y3msZkPZUlS4M8XsCFS6wE1OrKhoDJ5xDyrZNqj9jKrqMw7IkEbi2
         d0FO35HWf9uiE94XILcYeKSvDAKtGmrra+qqkzN5KQZYBA3zNBza/XeGGfVkFoq505rU
         Da9TeVLekEO044jm3R7wst3RR7fLqv6350hzZe5vNy/t6AsGUFwxjxBI7EwTSemOOYLO
         FB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vFQ0QfKt8ga37QIIvqNsjSNZkD24gXDN5WUMAyYwg18=;
        b=eIReh483KQfrql3z3EHHtOnNgFG2yjN37KJ/hkEF1qmUSv2dvTOpkpYVHHj1XVfALU
         0p9XIhazY3BmvlKKClnyB2+BjAA6cDJtfofvXrRwLyMRBsBuqgLhHdFZcnUO/mx77Zkq
         ttb2kjcbhwKo73X9MoYP+js8uYFa3U4PY7m21wDAAwlT5z4RaLBkdshb30ZtuQ1JQPLB
         I9IqRAodyQ8Lnm5GmfHZ6GeX7mVZ0kPIZDM8VZvN7yghWkkaGRkeJHNghOLRqYCnRp/L
         iiAYpisEJjubdGlFealnijJTsB/2s8ckeHAMS39AQacBWQEgwAwJN2J3z+UCuqW3wFJN
         yBiQ==
X-Gm-Message-State: AOAM532WKcfeQ1l3AWiB0g7DdTNui7vMIX+yD4bIDCGJKK3ddtMaYaU2
        txNBHNn0NcTPT/1d60hpC1w3y8a1NgBIcw==
X-Google-Smtp-Source: ABdhPJz+/WR3lOjrCDTbyNTcM10aBzmlw8n5hH5CUMO101s7Qn6Vz0GDYvAsKfZFePNN7Y8xgmn3ig==
X-Received: by 2002:a17:90a:3fc1:: with SMTP id u1mr603334pjm.141.1642008652379;
        Wed, 12 Jan 2022 09:30:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c11sm231468pfv.85.2022.01.12.09.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 09:30:51 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:30:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Message-ID: <Yd8QR2KHDfsekvNg@google.com>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Peter Zijlstra wrote:
> On Wed, Jan 12, 2022 at 08:02:01PM +0800, Li RongQing wrote:
> > vcpu can schedule out when run halt instruction, and set itself
> > to INTERRUPTIBLE and switch to idle thread, vcpu should not be
> > set preempted for this condition
> 
> Uhhmm, why not? Who says the vcpu will run the moment it becomes
> runnable again? Another task could be woken up meanwhile occupying the
> real cpu.

Hrm, but when emulating HLT, e.g. for an idling vCPU, KVM will voluntarily schedule
out the vCPU and mark it as preempted from the guest's perspective.  The vast majority,
probably all, usage of steal_time.preempted expects it to truly mean "preempted" as
opposed to "not running".

The lack of a vcpu->preempted check has confused me for a long time.  I assumed
that was intended behavior, but looking at the original commit, I'm not so sure.
The changelog is somewhat contradictory, as the the last sentence says "is running
or not", but I suspect that's just imprecise language.

 commit 0b9f6c4615c993d2b552e0d2bd1ade49b56e5beb
 Author: Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>
 Date:   Wed Nov 2 05:08:35 2016 -0400

    x86/kvm: Support the vCPU preemption check

    Support the vcpu_is_preempted() functionality under KVM. This will
    enhance lock performance on overcommitted hosts (more runnable vCPUs
    than physical CPUs in the system) as doing busy waits for preempted
    vCPUs will hurt system performance far worse than early yielding.

    Use struct kvm_steal_time::preempted to indicate that if a vCPU
    is running or not.

vcpu->preempted will be set if KVM schedules out the vCPU to service _TIF_NEED_RESCHED,
but not in the HLT case because KVM will mark the vCPU as TASK_INTERRUPTIBLE.  The
flag also won't be set if KVM puts the vCPU when exiting to userspace to handle I/O
or whatever, which is also desirable from the guest's perspective.

There might be potential for false negatives, but any damage there is likely
far outweighed by getting false positives, especially in the HLT case.

So somewhat tentatively...

Reviewed-by: Sean Christopherson <seanjc@google.com>

> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > Signed-off-by: Wang GuangJu <wangguangju@baidu.com>
> > ---
> >  arch/x86/kvm/x86.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9f5dbf7..10d76bf 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4407,6 +4407,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
> >  	if (vcpu->arch.st.preempted)
> >  		return;
> >  
> > +	if (!vcpu->preempted)
> > +		return;
> > +
> >  	/* This happens on process exit */
> >  	if (unlikely(current->mm != vcpu->kvm->mm))
> >  		return;
> > -- 
> > 2.9.4
> > 
