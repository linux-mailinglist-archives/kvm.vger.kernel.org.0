Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584C648B41E
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 18:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344368AbiAKRgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 12:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242490AbiAKRgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 12:36:31 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE56C06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 09:36:30 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id h1so18297853pls.11
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 09:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kmqD567CtlmXllpc1rQayweyZNMIGqk+RZtPJBuYT90=;
        b=sivzBEkWVy1S0pf5Z71owP5T4t13Zyykw7vqCCakVV0L1ZomD5pSrWWdeOgJuBAzWL
         zFUHh31Ym7mqCNUa7K4JxPVQhFbPy4N3qrzqt5roRk7BcHeqGnIc2hOgv6DFtWK5tTy2
         WdWZCAOQdakcQ38IpcuCVuoEK9rwgLOE50yRhvkZiFuadJGbVSlIPWXMc7yIFrHCMtIG
         bTt98MWR4oDq6HIq7Y/sVn7MmFX9CS1xFwzTO6bvb1DR9JWIcoX/Hrrl/rCckOdh5LoP
         mdC2nr6t5awVklH9vDGx4GBF7LvyiGNU3Chu6orbgSoWmiYl0jqTamZ/7yzMNKGRgmwF
         24Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kmqD567CtlmXllpc1rQayweyZNMIGqk+RZtPJBuYT90=;
        b=2LKsP8tQTts4q6tx0ilvERHDRsOOjzvEZNWLgYf+LzR8Gpa/M4nv9rVKK6PhExfzmj
         EVIcBkvHtqK03RLnv7Nh4zPzBOiSs3MnamDbAv01pkPKEuh4BIv8BA+gkvAsKh7JNqK0
         dmNN79OAh47xNn/9w7aL644BjFzrK6YnT+fwHLSRJUjca9/VlLSsqFuen2hUrUrUb7br
         ajbOrPbVgHYwelMnyBOHKL/YbS3UC7jMzikTxNYDHBGyXqnYiy7kohl9oqJVXLBRPOG+
         59dBPGHDQyoRo7qe7T6+NF9Rrz6hTr47xng9wmKvNFLoCLj9jGwfaESx9ooP8FMUsMVp
         hmTg==
X-Gm-Message-State: AOAM5304VwkJf6F+KCzHkDTWdBeLw7E/6tp78poTQtSdYu7o1SvBeYhm
        dKO+2M4/N1Op9BhnWNV4iRDDgQ==
X-Google-Smtp-Source: ABdhPJyi/ql3rEX/0G3ckRnHJKB6twfx7NB9W6on7gUjJywSRrz2rhGBuYgadAJVOgr9Cf/e9+m1Mg==
X-Received: by 2002:a62:79c2:0:b0:4bd:e9da:c173 with SMTP id u185-20020a6279c2000000b004bde9dac173mr5462897pfc.65.1641922590326;
        Tue, 11 Jan 2022 09:36:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id qe10sm3488021pjb.5.2022.01.11.09.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:36:29 -0800 (PST)
Date:   Tue, 11 Jan 2022 17:36:25 +0000
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
Message-ID: <Yd3AGRtkBgWSmGf2@google.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <Ydjje8qBOP3zDOZi@google.com>
 <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022, Raghavendra Rao Ananta wrote:
> On Fri, Jan 7, 2022 at 5:06 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Jan 04, 2022, Raghavendra Rao Ananta wrote:
> > > +#define kvm_vm_has_started(kvm) (kvm->vm_started)
> >
> > Needs parantheses around (kvm), but why bother with a macro?  This is the same
> > header that defines struct kvm.
> >
> No specific reason for creating a macro as such. I can remove it if it
> feels noisy.

Please do.  In the future, don't use a macro unless there's a good reason to do
so.  Don't get me wrong, I love abusing macros, but for things like this they are
completely inferior to

  static inline bool kvm_vm_has_started(struct kvm *kvm)
  {
  	return kvm->vm_started;
  }

because a helper function gives us type safety, doesn't suffer from concatenation
of tokens potentially doing weird things, is easier to extend to a multi-line
implementation, etc...

An example of when it's ok to use a macro is x86's

  #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)

which uses a macro instead of a proper function to avoid a circular dependency
due to arch/x86/include/asm/kvm_host.h being included by include/linux/kvm_host.h
and thus x86's implementation of kvm_arch_vcpu_memslots_id() coming before the
definition of struct kvm_vcpu.  But that's very much an exception and done only
because the alternatives suck more.

> > > +                      */
> > > +                     mutex_lock(&kvm->lock);
> >
> > This adds unnecessary lock contention when running vCPUs.  The naive solution
> > would be:
> >                         if (!kvm->vm_started) {
> >                                 ...
> >                         }
> >
> Not sure if I understood the solution..

In your proposed patch, KVM_RUN will take kvm->lock _every_ time.  That introduces
unnecessary contention as it will serialize this bit of code if multiple vCPUs
are attempting KVM_RUN.  By checking !vm_started, only the "first" KVM_RUN for a
VM will acquire kvm->lock and thus avoid contention once the VM is up and running.
There's still a possibility that multiple vCPUs will contend for kvm->lock on their
first KVM_RUN, hence the quotes.  I called it "naive" because it's possible there's
a more elegant solution depending on the use case, e.g. a lockless approach might
work (or it might not).

> > > +                     kvm->vm_started = true;
> > > +                     mutex_unlock(&kvm->lock);
> >
> > Lastly, why is this in generic KVM?
> >
> The v1 of the series originally had it in the arm specific code.
> However, I was suggested to move it to the generic code since the book
> keeping is not arch specific and could be helpful to others too [1].

I'm definitely in favor of moving/adding thing to generic KVM when it makes sense,
but I'm skeptical in this particular case.  The code _is_ arch specific in that
arm64 apparently needs to acquire kvm->lock when checking if a vCPU has run, e.g.
versus a hypothetical x86 use case that might be completely ok with a lockless
implementation.  And it's not obvious that there's a plausible, safe use case
outside of arm64, e.g. on x86, there is very, very little that is truly shared
across the entire VM/system, most things are per-thread/core/package in some way,
shape, or form.  In other words, I'm a wary of providing something like this for
x86 because odds are good that any use will be functionally incorrect.
