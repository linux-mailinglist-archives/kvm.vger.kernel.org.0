Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC5A48CAA6
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 19:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356055AbiALSKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 13:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356071AbiALSJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 13:09:29 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E797C03327B
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:08:44 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id h14so7873158ybe.12
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eLoe+yCOLX8twUoVnJSmKEThBpM9HQQFjJ/YCsOmEqo=;
        b=sM2pOGw+VpV9fEIP1NjSY4EwV7AcQhlq5kQpevs1vpJUY1/wqvZGO14UsjVSIGi4KO
         0xFyyWnKF8RnRiQ9QTjCBqspBtCwUaJMbb1JnyobjHfOw7HAOB45fyPrbx6ULMES3QfA
         1K+5NVv6/9/HPmtYoPxk7tPP+UAka3Gns3nyHc7K3xrpJHSngSgARkxqZMQ47npXn644
         DE9+7odqYt8BstnTgUifJbQ7/R9av7njwqtwSCbDdmjN753efTawRlUW5KocyfCemjeW
         pPHXtnlznKcgGaSD30YnQph+Ju3ocJHis1S1NlIQFcHPcVRynTbi1J386LRNrmp+S+zE
         ukWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eLoe+yCOLX8twUoVnJSmKEThBpM9HQQFjJ/YCsOmEqo=;
        b=tPGAonxGQVhlR3LM6066wYB5HlnuspHzHkB0K7HyoevgL39yCzSnGrNwvGd0+3WEs3
         LVsnz4U6uO4DfmWg1hfsYnhcbb99PjU+q6iCHMqNOBEqFU9cSvRxchJh1KiVnAkxCIkh
         pFbai5AxgskdXPwC3kNj0m9S9I3PQyMtR4olN2dJD962COQEFdtRmdsT+nk2564xEbEA
         Z+eeBSWgjr052OEffZkj/spHIdf4IeQ5STdD1e3nWCgvQ10BJQR1As7cTKHT1+SwShoX
         xKG+eXrGKS34tgWhNztTZmGS9Uahddvw6PnuJv695c7utXJXJf+Li11+fxuKtA2EZS90
         5ViA==
X-Gm-Message-State: AOAM533lEASbNFMfRhSMCA6KGd96+90IarMvBvmVNdW+bg3O1FyloVS+
        bbUdPl9Jk8z1EY5b9YIAkfCuNfp8CNOx4sZFaqd9Jw==
X-Google-Smtp-Source: ABdhPJyOENQ36F72MCUSVYL6GkdmncC92a9wV1s6msf5ZpTvvHnphmMhSYKEkA/XtQw4bc2lP+lyOA6otSG7YAZ1iDM=
X-Received: by 2002:a25:d750:: with SMTP id o77mr1052699ybg.543.1642010923523;
 Wed, 12 Jan 2022 10:08:43 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
 <Ydjje8qBOP3zDOZi@google.com> <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
 <Yd3AGRtkBgWSmGf2@google.com> <CAJHc60w7vfHkg+9XkPw+38nZBWLLhETJj310ekM1HpQQTL_O0Q@mail.gmail.com>
 <Yd3UymPg++JW98/2@google.com>
In-Reply-To: <Yd3UymPg++JW98/2@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 12 Jan 2022 10:08:32 -0800
Message-ID: <CAJHc60yPmdyonJESHPHvXJR+ekugZev4XzsZc2YV2mnfBdy-bw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 11:04 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 11, 2022, Raghavendra Rao Ananta wrote:
> > On Tue, Jan 11, 2022 at 9:36 AM Sean Christopherson <seanjc@google.com> wrote:
> > > In your proposed patch, KVM_RUN will take kvm->lock _every_ time.  That introduces
> > > unnecessary contention as it will serialize this bit of code if multiple vCPUs
> > > are attempting KVM_RUN.  By checking !vm_started, only the "first" KVM_RUN for a
> > > VM will acquire kvm->lock and thus avoid contention once the VM is up and running.
> > > There's still a possibility that multiple vCPUs will contend for kvm->lock on their
> > > first KVM_RUN, hence the quotes.  I called it "naive" because it's possible there's
> > > a more elegant solution depending on the use case, e.g. a lockless approach might
> > > work (or it might not).
> > >
> > But is it safe to read kvm->vm_started without grabbing the lock in
> > the first place?
>
> Don't know, but that's my point.  Without a consumer in generic KVM and due to
> my lack of arm64 knowledge, without a high-level description of how the flag will
> be used by arm64, it's really difficult to determine what's safe and what's not.
> For other architectures, it's an impossible question to answer because we don't
> know how the flag might be used.
>
> > use atomic_t maybe for this?
>
> No.  An atomic_t is generally useful only if there are multiple writers that can
> possibly write different values.  It's highly unlikely that simply switching to an
> atomic address the needs of arm64.
>
> > > > > > +                     kvm->vm_started = true;
> > > > > > +                     mutex_unlock(&kvm->lock);
> > > > >
> > > > > Lastly, why is this in generic KVM?
> > > > >
> > > > The v1 of the series originally had it in the arm specific code.
> > > > However, I was suggested to move it to the generic code since the book
> > > > keeping is not arch specific and could be helpful to others too [1].
> > >
> > > I'm definitely in favor of moving/adding thing to generic KVM when it makes sense,
> > > but I'm skeptical in this particular case.  The code _is_ arch specific in that
> > > arm64 apparently needs to acquire kvm->lock when checking if a vCPU has run, e.g.
> > > versus a hypothetical x86 use case that might be completely ok with a lockless
> > > implementation.  And it's not obvious that there's a plausible, safe use case
> > > outside of arm64, e.g. on x86, there is very, very little that is truly shared
> > > across the entire VM/system, most things are per-thread/core/package in some way,
> > > shape, or form.  In other words, I'm a wary of providing something like this for
> > > x86 because odds are good that any use will be functionally incorrect.
> > I've been going back and forth on this. I've seen a couple of
> > variables declared in the generic struct and used only in the arch
> > code. vcpu->valid_wakeup for instance, which is used only by s390
> > arch. Maybe I'm looking at it the wrong way as to what can and can't
> > go in the generic kvm code.
>
> Ya, valid_wakeup is an oddball, I don't know why it's in kvm_vcpu instead of
> arch code that's wrapped with e.g. kvm_arch_vcpu_valid_wakeup().
>
> That said, valid_wakeup is consumed by generic KVM, i.e. has well defined semantics
> for how it is used, so it's purely a "this code is rather odd" issue.  vm_started
> on the other hand is only produced by generic KVM, and so its required semantics are
> unclear.

Understood. I'll move it to arm64 and we can refactor it if there's a
need for any other arch(s).

Thanks,
Raghavendra
