Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C955D2FD79A
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 18:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbhATR46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 12:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730633AbhATRzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 12:55:55 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BF6C061575
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 09:55:15 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b5so2674775pjl.0
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 09:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t8YMo8jRbeIk9ppyijttwVDqnf13nQ8mAexthZe0Ph0=;
        b=vX2AdHF/tB+L02N3dQw2MePoGgrfKQVlQEEL36VWY54kbz5asngW1hrU30IGH+Q27U
         +zaFgLsDxqvBjswgrm5R9HijyCi9NcolBqr4UdN0AifQvXbK9g+MKRe6BdM5JDCPWAwP
         xeypIlrslU+MOtEYVUWxIhWOB7d0CSPdtai9XbqJbbYIDY3sWLAaG6k6HZrwIfdEpOrs
         iCPRhbMEU/h5s81dsqBwfCe0qnpKTAbwQpNBaarTJRRfB+4aDlsapng9O3mvNVlnfnUG
         0/LAj/PQbL0ZzqqkXDD2iFoQx4LYwhY4bFSOgnlsBNf3NTYwuR2rSmAcAytMT9K8W9Yc
         QJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t8YMo8jRbeIk9ppyijttwVDqnf13nQ8mAexthZe0Ph0=;
        b=In6z9vZGBamIs0aVwuqgws2g078rOpoVGp0ekkh7VnBVi6Sg75FipIl2Hq/W9zIJQQ
         vILOfk6zr+nXeVPxCdlm+uG9AR1YJW7e0fyComVbBAuER3TSfC05ueexG3NSb046Qsbq
         5QnapF0xiCJwF3wWmuLUPaoS3tD6SWjZ11U9kbiw/eA8HN4Y3685C3dO0CjkqZrCpuCu
         na0gGkVxSkOGNEsUtfxzdym43fwNvhyt6MioJeGbLtW6dLrzAldr93WnZ4eFhkEwbkyP
         CpEZ48o2p1kF9VSiAS0l9U1KEqvfaHAB5dFKZ2+YcZZ1v+5Abx5Z2B2BhAoH6LRW6ohd
         Lh0Q==
X-Gm-Message-State: AOAM533SNwkMepZjM6cXO8PNjFCm0Gfj7xC1DgGovgorEW5pkpEt5gbn
        gKCWD0Gn8vgB9frVZFKkTthspAKMyRzj/w==
X-Google-Smtp-Source: ABdhPJzVWd2iPLXyzCMR+cxx8zLJ9gX7+bLX2M8JSdBQEIgJelcR9//7gN4DLJjjjO4CrkjbVl9wEw==
X-Received: by 2002:a17:90a:e643:: with SMTP id ep3mr7075449pjb.140.1611165314366;
        Wed, 20 Jan 2021 09:55:14 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w7sm2933767pfb.62.2021.01.20.09.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 09:55:13 -0800 (PST)
Date:   Wed, 20 Jan 2021 09:55:07 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/7] KVM: x86: hyper-v: Always use vcpu_to_hv_vcpu()
 accessor to get to 'struct kvm_vcpu_hv'
Message-ID: <YAhue3GPUDRb8dF/@google.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
 <20210113143721.328594-4-vkuznets@redhat.com>
 <YAdlxE1LYz9NSdq8@google.com>
 <87a6t36bye.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6t36bye.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Jan 13, 2021, Vitaly Kuznetsov wrote:
> >> As a preparation to allocating Hyper-V context dynamically, make it clear
> >> who's the user of the said context.
> >> 
> >> No functional change intended.
> >> 
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >>  arch/x86/kvm/hyperv.c  | 14 ++++++++------
> >>  arch/x86/kvm/hyperv.h  |  4 +++-
> >>  arch/x86/kvm/lapic.h   |  6 +++++-
> >>  arch/x86/kvm/vmx/vmx.c |  9 ++++++---
> >>  arch/x86/kvm/x86.c     |  4 +++-
> >>  5 files changed, 25 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> >> index 922c69dcca4d..82f51346118f 100644
> >> --- a/arch/x86/kvm/hyperv.c
> >> +++ b/arch/x86/kvm/hyperv.c
> >> @@ -190,7 +190,7 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
> >>  static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
> >>  {
> >>  	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
> >> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
> >> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
> >
> > Tangentially related...
> >
> > What say you about aligning Hyper-V to VMX and SVM terminology?  E.g. I like
> > that VMX and VXM omit the "vcpu_" part and just call it "to_vmx/svm()", and the
> > VM-scoped variables have a "kvm_" prefix but the vCPU-scoped variables do not.
> > I'd probably even vote to do s/vcpu_to_pi_desc/to_pi_desc, but for whatever
> > reason that one doesn't annoy as much, probably because it's less pervasive than
> > the Hyper-V code.
> 
> Gererally I have nothing against the idea, will try to prepare a series.

Thanks!  My hope is that cleaning up the Hyper-V code will make it easier for
you to get reviews for Hyper-V patches in the future.

> > It would also help if the code were more consistent with itself.  It's all a bit
> > haphazard when it comes to variable names, using helpers (or not), etc...
> >
> > Long term, it might also be worthwhile to refactor the various flows to always
> > pass @vcpu instead of constantly converting to/from various objects.  Some of
> > the conversions appear to be necessary, e.g. for timer callbacks, but AFAICT a
> > lot of the shenanigans are entirely self-inflicted.
> >
> > E.g. stimer_set_count() has one caller, which already has @vcpu, but
> > stimer_set_count() takes @stimer instead of @vcpu and then does several
> > conversions in as many lines.  None of the conversions are super expensive, but
> > it seems like every little helper in Hyper-V is doing multiple conversions to
> > and from kvm_vcpu, and half the generated code is getting the right pointer. :-)
> 
> I *think* the idea was that everything synic-related takes a 'synic',
> everything stimer-related takes an 'stimer' and so on. While this looks
> cleaner from 'api' perspective, it indeed makes the code longer in some
> cases so I'd also agree with 'optimization'.

Makes sense.  Perhaps the middle ground is to take both @vcpu and @stimer/etc.,
to keep the APIs clean-ish.
