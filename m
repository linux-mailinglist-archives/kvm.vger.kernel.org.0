Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70C448B673
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 20:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345855AbiAKTEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 14:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238845AbiAKTEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 14:04:48 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75014C061748
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:04:48 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id h1so175144pls.11
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K0voZAURqPJsMSPgWRWSbzQgUhtAjQkdnnmPm2jJT2w=;
        b=OBsot1EYclSvooVusPEFiHcqQS0tLiqutA1hLvc4Q8dJ1Ly3d4NacG3jUTcwT8b5B0
         yAzAAMtSPazCmF1twB9t7p7OjthaBlEEVkPWyFLjoGrBIC4wlTb5/+rRXf0vM/6rqMCU
         Ragb7afH7stdPZ3KqbuRhWmkPsSooAAmEnsXlw63cnann8b5t+woTMjdUi9ErVLDZadL
         SBMqnGpNjCY4JuVHxg3BCfGS2f1fwERk57a6Mqygc7EBur2rRRWKrn5R3WR0uUengxin
         T+1Z9+vSV6mbJNk442DU5o4tAuCOGgn5t6ttzvE2XufqHuwrPcbXryB0l8VXzxOzfmXG
         EbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K0voZAURqPJsMSPgWRWSbzQgUhtAjQkdnnmPm2jJT2w=;
        b=egVAgXbtIof3B0hkK3NZ2mQkIRX+6RNiG3EFNnhdZ9rJa550dzhaWFhQNzbzaRE+VX
         1CgiZE+i9w+vKQzYUNzoIa8kOgDH4FqPxSy+ow8OBQSKpmaqWFLuUwfGvO+TGwcnIj57
         cFmD/+i1ELutFt/5DpsTaTG3pMSyec0/bXztJysA3XP88H4PXJnbLv4NQRsHqLbq3JLc
         K2aKcQra+9naQMHpwgKRJdoNLPUfDeMTN+d5+RpZNYWgJWdohUou+CIknA6qg1+3sCtF
         N9B7hUHwIqCnXt0A2X1gaY3elx0RB8oQH//xeFRImP8z9s/s7VYsvwbPL+9Lnq0csvWd
         mxrA==
X-Gm-Message-State: AOAM530HsoPwWKaqA29V3uaCGhJJfjVrgtJ5rYIuYsM7wjKxioAYag1M
        gsTLjHd1djNM+Td8XeMFck3B1Q==
X-Google-Smtp-Source: ABdhPJxSyV27y218zwiIgly8FGJNiKN5fGPK6Fudoin6YBhcWN0ZlQZF3CdSOjibQ9Gqz01uCEpKuA==
X-Received: by 2002:a63:7c5e:: with SMTP id l30mr5246852pgn.297.1641927887737;
        Tue, 11 Jan 2022 11:04:47 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l22sm11246197pfc.167.2022.01.11.11.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 11:04:47 -0800 (PST)
Date:   Tue, 11 Jan 2022 19:04:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <Yd3UymPg++JW98/2@google.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <Ydjje8qBOP3zDOZi@google.com>
 <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
 <Yd3AGRtkBgWSmGf2@google.com>
 <CAJHc60w7vfHkg+9XkPw+38nZBWLLhETJj310ekM1HpQQTL_O0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60w7vfHkg+9XkPw+38nZBWLLhETJj310ekM1HpQQTL_O0Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022, Raghavendra Rao Ananta wrote:
> On Tue, Jan 11, 2022 at 9:36 AM Sean Christopherson <seanjc@google.com> wrote:
> > In your proposed patch, KVM_RUN will take kvm->lock _every_ time.  That introduces
> > unnecessary contention as it will serialize this bit of code if multiple vCPUs
> > are attempting KVM_RUN.  By checking !vm_started, only the "first" KVM_RUN for a
> > VM will acquire kvm->lock and thus avoid contention once the VM is up and running.
> > There's still a possibility that multiple vCPUs will contend for kvm->lock on their
> > first KVM_RUN, hence the quotes.  I called it "naive" because it's possible there's
> > a more elegant solution depending on the use case, e.g. a lockless approach might
> > work (or it might not).
> >
> But is it safe to read kvm->vm_started without grabbing the lock in
> the first place?

Don't know, but that's my point.  Without a consumer in generic KVM and due to
my lack of arm64 knowledge, without a high-level description of how the flag will
be used by arm64, it's really difficult to determine what's safe and what's not.
For other architectures, it's an impossible question to answer because we don't
know how the flag might be used.

> use atomic_t maybe for this?

No.  An atomic_t is generally useful only if there are multiple writers that can
possibly write different values.  It's highly unlikely that simply switching to an
atomic address the needs of arm64.

> > > > > +                     kvm->vm_started = true;
> > > > > +                     mutex_unlock(&kvm->lock);
> > > >
> > > > Lastly, why is this in generic KVM?
> > > >
> > > The v1 of the series originally had it in the arm specific code.
> > > However, I was suggested to move it to the generic code since the book
> > > keeping is not arch specific and could be helpful to others too [1].
> >
> > I'm definitely in favor of moving/adding thing to generic KVM when it makes sense,
> > but I'm skeptical in this particular case.  The code _is_ arch specific in that
> > arm64 apparently needs to acquire kvm->lock when checking if a vCPU has run, e.g.
> > versus a hypothetical x86 use case that might be completely ok with a lockless
> > implementation.  And it's not obvious that there's a plausible, safe use case
> > outside of arm64, e.g. on x86, there is very, very little that is truly shared
> > across the entire VM/system, most things are per-thread/core/package in some way,
> > shape, or form.  In other words, I'm a wary of providing something like this for
> > x86 because odds are good that any use will be functionally incorrect.
> I've been going back and forth on this. I've seen a couple of
> variables declared in the generic struct and used only in the arch
> code. vcpu->valid_wakeup for instance, which is used only by s390
> arch. Maybe I'm looking at it the wrong way as to what can and can't
> go in the generic kvm code.

Ya, valid_wakeup is an oddball, I don't know why it's in kvm_vcpu instead of
arch code that's wrapped with e.g. kvm_arch_vcpu_valid_wakeup().

That said, valid_wakeup is consumed by generic KVM, i.e. has well defined semantics
for how it is used, so it's purely a "this code is rather odd" issue.  vm_started
on the other hand is only produced by generic KVM, and so its required semantics are
unclear.
