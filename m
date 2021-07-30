Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9133DBD66
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 18:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhG3Q46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 12:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhG3Q45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 12:56:57 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5BFC061765
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 09:56:52 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ca5so16053695pjb.5
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 09:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NHmczmIzJufSB3Li/LucyxkDOJfl+luasFO2GMfh3i8=;
        b=EwcggOYo/KbZsqbv7CnLQji1AaGLnOh5sUY2NEpMi13aXZro2JK54VQT6EA0LGqEhp
         1dUrc+sHK5QUBLJMqWCOkVhRORDMasbGc+TOD24B7tNkfpzuGSMo8PWaKmEy1U7xtHUx
         q2Tra7+g6UGs9nC/2zTwsRW3ZjjJMQUqLUuu86eJdfpsqEdwAhNF1wbUviE7h7v3e4No
         ZhEeZbFW48Wecy/exed5zVehY2v7yXNhQFiz7UAWuLehu8RXOsgutb5gJvvx4xh51f0m
         ch4nma24ljAdFeNIidkVIV4YCjh9zTv7Sz9NEIs3gib/XxkJ9DakVPEgZNpUgkRMS3f3
         pmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NHmczmIzJufSB3Li/LucyxkDOJfl+luasFO2GMfh3i8=;
        b=CFc3j6ezUrpjSyseJtr7ele92S+zoHndWRbpw698a1g+7G9aUB7Re6e/Gx8cVi18K1
         mxjEaIxiFUl/j4tS3+ssLPzJ/z+p5qz5fKOd/u4G/urUkVY+xkTvtXDP84a/3w9kuBZA
         PzJWe2EanHED4bNoeKyVwHVLkU4KEhRjzxQWVf5xt0NXnmNedJFgrnI123QzKTGuYQjJ
         dJJnkUWRNa+sdVxxIsYQbSCXFEtRSBRqeMb6YzA2P56ez3nM21X5eyWbrjmCMohvSla4
         5kL7Jcx1zKCBCVVSFqm+oXN2asJ236cO843wqSMqAKb4uzyL3drrGzcs6hajKLInyWve
         cXRA==
X-Gm-Message-State: AOAM530WKIr5Qi63QAhYfiojGXlJtG3ZXl0tdTj3lzYBIjUHVqI7qwOJ
        z6/Snnd17wtTr6sGgkzRi7BYkw==
X-Google-Smtp-Source: ABdhPJzWI6FoTcaZNj62M9u9nn73qB7KjElQlQVRB3Sn9a2CCf11QZlLRjOgsi/YapsBA2ELYgUCvw==
X-Received: by 2002:a63:4e11:: with SMTP id c17mr3123982pgb.54.1627664212050;
        Fri, 30 Jul 2021 09:56:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f3sm2904882pfe.123.2021.07.30.09.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 09:56:51 -0700 (PDT)
Date:   Fri, 30 Jul 2021 16:56:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
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
Subject: Re: [PATCH v2 3/3] KVM: arm64: Use generic KVM xfer to guest work
 function
Message-ID: <YQQvT7vAnRrcAcx/@google.com>
References: <20210729220916.1672875-1-oupton@google.com>
 <20210729220916.1672875-4-oupton@google.com>
 <878s1o2l6j.wl-maz@kernel.org>
 <CAOQ_QsjFzdjYgYSxNLH=8O84FJB+O8KtH0VnzdQ9HnLZwxwpNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QsjFzdjYgYSxNLH=8O84FJB+O8KtH0VnzdQ9HnLZwxwpNQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021, Oliver Upton wrote:
> 
> On Fri, Jul 30, 2021 at 2:41 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Thu, 29 Jul 2021 23:09:16 +0100, Oliver Upton <oupton@google.com> wrote:
> > > @@ -714,6 +715,13 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
> > >               static_branch_unlikely(&arm64_mismatched_32bit_el0);
> > >  }
> > >
> > > +static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
> > > +{
> > > +     return kvm_request_pending(vcpu) ||
> > > +                     need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
> > > +                     xfer_to_guest_mode_work_pending();
> >
> > Here's what xfer_to_guest_mode_work_pending() says:
> >
> > <quote>
> >  * Has to be invoked with interrupts disabled before the transition to
> >  * guest mode.
> > </quote>
> >
> > At the point where you call this, we already are in guest mode, at
> > least in the KVM sense.
> 
> I believe the comment is suggestive of guest mode in the hardware
> sense, not KVM's vcpu->mode designation. I got this from
> arch/x86/kvm/x86.c:vcpu_enter_guest() to infer the author's
> intentions.

Yeah, the comment is referring to hardware guest mode.  The intent is to verify
there is no work to be done before making the expensive world switch.  There's
no meaningful interaction with vcpu->mode, on x86 it's simply more convenient
from a code perspective to throw it into kvm_vcpu_exit_request().
