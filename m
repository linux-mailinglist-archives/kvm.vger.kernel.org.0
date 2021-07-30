Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6743DBDF7
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 19:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhG3Rwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 13:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhG3Rwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 13:52:36 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB3EC061765
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 10:52:30 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id h2so19485406lfu.4
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 10:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w74FCyABGqlKztmmT/szhNY9h5zAocpT2ax3CC8sfng=;
        b=DMrMZW03lBg/IWAb0IutYWMvCcEgS9xE5oJAt+jb+XBSyYmWnF1bbfCrZjz7dswIwD
         3v09mJ2EWLLHzJdjDf1awDYZg7EXnIFc+cImRm3dt9ORzBzqc6NkD+G5XTaI0Zcen3XU
         4cCh5vSyAZ7M/7ch8OPmEQSoGVBqGVkmlSuoAz2i+3aMHhE16KOplP7P7310dJvFMc7r
         473AiUM6s5r/ikkrJBXsLg/dLLccX9P/NPC+CEdOheJvLrqF2WWEkzYeBpo55NGME49y
         5MFHPpccGBKyttRw8SZHiN1GNbFcg1Rwcwr0J/jQi6dJrksfxK2UQM3qkKKIKTimvKSi
         4mKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w74FCyABGqlKztmmT/szhNY9h5zAocpT2ax3CC8sfng=;
        b=sjw2PWT0WrXY/BjzFw7/V2LF7fNJfO388BjLM+fgxHETBvLyWZkg61P3iFidq9L0+h
         C2jWyZIIUQnyFllBdT3CXeClRlQthuN5MwKQ4XGusaxdQusC8pSCuogjIAssBGx2+sVz
         o3+2eBH1LMjBa6caAmxiMn513dKsrAs4WEAefkQcuBKMWpHb/Zcg5vNw7LrUTi3yG/Ly
         9qhloUtJEvRnhtB84TKzHY7k/3i+FEYkBsdBoAelxH+hrTBZQ+HRj+fLDBmgYdj7vqD9
         dw2Ek+Bi6bK4DwEpdeQ2xUbHTGPnBCSB0vwKdMvv+003TddBnMjJmg8j2PFcfcKmpZ+A
         PXYg==
X-Gm-Message-State: AOAM530jwhHcRtq8zKTk1Px/7Z1pDpyCwQ5/Q5qWO4jxn9IqiE9FCAQv
        /5S62oa0tj1sMcQz785wNPYKTtdlKUa/e1iD/su6ug==
X-Google-Smtp-Source: ABdhPJz0PS/v5uJNj45dAFVPDlHbQva1oT/iA2HWlKW9EoPtntJYtcQmwoF/lTYfoxBt8w02Z4/+/RsU10oVF052rmE=
X-Received: by 2002:a05:6512:3d26:: with SMTP id d38mr2541587lfv.411.1627667548598;
 Fri, 30 Jul 2021 10:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210729220916.1672875-1-oupton@google.com> <20210729220916.1672875-4-oupton@google.com>
 <878s1o2l6j.wl-maz@kernel.org> <CAOQ_QsjFzdjYgYSxNLH=8O84FJB+O8KtH0VnzdQ9HnLZwxwpNQ@mail.gmail.com>
 <YQQvT7vAnRrcAcx/@google.com>
In-Reply-To: <YQQvT7vAnRrcAcx/@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 30 Jul 2021 10:52:17 -0700
Message-ID: <CAOQ_Qsjzp785QCnu9rzkuEMH9Q7tee-edJpKNgD_14t3NpaS5w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Use generic KVM xfer to guest work function
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 9:56 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jul 30, 2021, Oliver Upton wrote:
> >
> > On Fri, Jul 30, 2021 at 2:41 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 29 Jul 2021 23:09:16 +0100, Oliver Upton <oupton@google.com> wrote:
> > > > @@ -714,6 +715,13 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
> > > >               static_branch_unlikely(&arm64_mismatched_32bit_el0);
> > > >  }
> > > >
> > > > +static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +     return kvm_request_pending(vcpu) ||
> > > > +                     need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
> > > > +                     xfer_to_guest_mode_work_pending();
> > >
> > > Here's what xfer_to_guest_mode_work_pending() says:
> > >
> > > <quote>
> > >  * Has to be invoked with interrupts disabled before the transition to
> > >  * guest mode.
> > > </quote>
> > >
> > > At the point where you call this, we already are in guest mode, at
> > > least in the KVM sense.
> >
> > I believe the comment is suggestive of guest mode in the hardware
> > sense, not KVM's vcpu->mode designation. I got this from
> > arch/x86/kvm/x86.c:vcpu_enter_guest() to infer the author's
> > intentions.
>
> Yeah, the comment is referring to hardware guest mode.  The intent is to verify
> there is no work to be done before making the expensive world switch.  There's
> no meaningful interaction with vcpu->mode, on x86 it's simply more convenient
> from a code perspective to throw it into kvm_vcpu_exit_request().

Yep, the same is true for ARM as well, doing it the way it appears in
this patch allows for the recycling of the block to enable irqs and
preemption.

--
Thanks,
Oliver
