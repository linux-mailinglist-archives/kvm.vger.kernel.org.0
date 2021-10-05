Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A829423078
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 21:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhJETDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 15:03:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229662AbhJETDt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 15:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633460517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pks3z+IN34uKEcJiugoE2qCaJ8Ch2RkxBo7zygTxWDE=;
        b=eub1MxAGOhbmX2nm9NVT77MyTZVHLM88N3OZK4XvMlle4b3Uh6FibsiU8CEZJSpREFLnsw
        3CSiAgr3QwRXJ7+BzOhGo/UEW4zuNP7NsrqbnGBIk5Yv6kb3KUU1d5EDXwyg2bT6qvBzKZ
        BQUMyViLu/xhJ1QnhlWE4ixgrPmNzSY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-XXNr33UoNaeFtD4hjHLASg-1; Tue, 05 Oct 2021 15:01:57 -0400
X-MC-Unique: XXNr33UoNaeFtD4hjHLASg-1
Received: by mail-ed1-f70.google.com with SMTP id k10-20020a508aca000000b003dad77857f7so110112edk.22
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 12:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pks3z+IN34uKEcJiugoE2qCaJ8Ch2RkxBo7zygTxWDE=;
        b=XIdh3p3v3SYDdNmVat0w2iKiKi//XJm0DAyETOrc3Fcsc5Lv+LB92Q2yZgVuuZsiTX
         SBukDrcc7Oms/xN6SP2iX4UEnfaA2xnAnHSawlfpoW0xzskrG63YteqP+sOPlYYxu3Gn
         E3lc1nRBt1vmZmLLwELCD3v4LQjGkkTOUXkv2wy/+mXO3L57Ah5yIY+5gBSw8hTmE1h1
         LU8VYIC4jidA2rZF8GJPU0LOSlnSJouTndcUvFVAMHW5y26+/0a4CucdbHpB6B7/I5en
         PqTaKMFkUXkauhkCctUXMGwO9WooSySGPPK4MkOhPPvAYqyD2bIkJYv8KhW192CGbgIG
         9CYA==
X-Gm-Message-State: AOAM533/T6gIB6g4WCU/gPGiVzVHkvd8zGIKX2hShgK68oEPU4NG03lt
        1tUY7BiNJBJnu3brTMWtiJd1tvkfPHa8fX6v7Y2wLcowpcA3PYub/NaprK6Pa81LIoQqv6Ki6g4
        epfNkn/GVV+4V
X-Received: by 2002:a50:a402:: with SMTP id u2mr7001806edb.164.1633460515755;
        Tue, 05 Oct 2021 12:01:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwONHgv+rzWdOUDOp3pb03VLVgZb0u2aMFk5wZLbXeJGvkerMM7eHV4Ej3ChBcS+hGx+yWW0Q==
X-Received: by 2002:a50:a402:: with SMTP id u2mr7001789edb.164.1633460515538;
        Tue, 05 Oct 2021 12:01:55 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id 21sm7981028ejv.54.2021.10.05.12.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 12:01:54 -0700 (PDT)
Date:   Tue, 5 Oct 2021 21:01:53 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in
 a helper function
Message-ID: <20211005190153.dc2befzcisvznxq5@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-4-oupton@google.com>
 <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
 <CAOQ_QshHDWWEw5BEu-uudFttP1pfJcKuQ-0D_xAkoHJRqYLq8Q@mail.gmail.com>
 <20211005133335.y4k5qv7d3g74nnzx@gator.home>
 <CAOQ_QsgwK=qyeaUtNJeZ1OWQwaFUAQcy6uopnDuyDA3Qyt7gmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QsgwK=qyeaUtNJeZ1OWQwaFUAQcy6uopnDuyDA3Qyt7gmw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05, 2021 at 08:05:02AM -0700, Oliver Upton wrote:
> Hi folks,
> 
> On Tue, Oct 5, 2021 at 6:33 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Fri, Oct 01, 2021 at 09:10:14AM -0700, Oliver Upton wrote:
> > > On Thu, Sep 30, 2021 at 11:05 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > >
> > > > On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
> > > > >
> > > > > In its implementation of the PSCI function, KVM needs to request that a
> > > > > target vCPU resets before its next entry into the guest. Wrap the logic
> > > > > for requesting a reset in a function for later use by other implemented
> > > > > PSCI calls.
> > > > >
> > > > > No functional change intended.
> > > > >
> > > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
> > > > >  1 file changed, 35 insertions(+), 24 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > > index 310b9cb2b32b..bb59b692998b 100644
> > > > > --- a/arch/arm64/kvm/psci.c
> > > > > +++ b/arch/arm64/kvm/psci.c
> > > > > @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
> > > > >         return !(affinity & ~MPIDR_HWID_BITMASK);
> > > > >  }
> > > > >
> > > > > -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > > +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> > > > > +                                       unsigned long entry_addr,
> > > > > +                                       unsigned long context_id,
> > > > > +                                       bool big_endian)
> > > > >  {
> > > > >         struct vcpu_reset_state *reset_state;
> > > > > +
> > > > > +       lockdep_assert_held(&vcpu->kvm->lock);
> > > > > +
> > > > > +       reset_state = &vcpu->arch.reset_state;
> > > > > +       reset_state->pc = entry_addr;
> > > > > +
> > > > > +       /* Propagate caller endianness */
> > > > > +       reset_state->be = big_endian;
> > > > > +
> > > > > +       /*
> > > > > +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > > +        * the general purpose registers are undefined upon CPU_ON.
> > > > > +        */
> > > > > +       reset_state->r0 = context_id;
> > > > > +
> > > > > +       WRITE_ONCE(reset_state->reset, true);
> > > > > +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > > +
> > > > > +       /*
> > > > > +        * Make sure the reset request is observed if the change to
> > > > > +        * power_state is observed.
> > > > > +        */
> > > > > +       smp_wmb();
> > > > > +       vcpu->arch.power_off = false;
> > > > > +}
> > > > > +
> > > > > +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > > +{
> > > > >         struct kvm *kvm = source_vcpu->kvm;
> > > > >         struct kvm_vcpu *vcpu = NULL;
> > > > >         unsigned long cpu_id;
> > > > > @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > >                         return PSCI_RET_INVALID_PARAMS;
> > > > >         }
> > > > >
> > > > > -       reset_state = &vcpu->arch.reset_state;
> > > > > -
> > > > > -       reset_state->pc = smccc_get_arg2(source_vcpu);
> > > > > -
> > > > > -       /* Propagate caller endianness */
> > > > > -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> > > > > -
> > > > > -       /*
> > > > > -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > > -        * the general purpose registers are undefined upon CPU_ON.
> > > > > -        */
> > > > > -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> > > > > -
> > > > > -       WRITE_ONCE(reset_state->reset, true);
> > > > > -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > > -
> > > > > -       /*
> > > > > -        * Make sure the reset request is observed if the change to
> > > > > -        * power_state is observed.
> > > > > -        */
> > > > > -       smp_wmb();
> > > > > -
> > > > > -       vcpu->arch.power_off = false;
> > > > > +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> > > > > +                                   smccc_get_arg3(source_vcpu),
> > > > > +                                   kvm_vcpu_is_be(source_vcpu));
> > > > >         kvm_vcpu_wake_up(vcpu);
> > > > >
> > > > >         return PSCI_RET_SUCCESS;
> > > > > --
> > > > > 2.33.0.685.g46640cef36-goog
> > > >
> > > > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > > >
> > > > Not directly related to the patch, but the (original) code doesn't
> > > > do any sanity checking for the entry address although the PSCI spec says:
> > > >
> > > > "INVALID_ADDRESS is returned when the entry point address is known
> > > > by the implementation to be invalid, because it is in a range that
> > > > is known not to be available to the caller."
> > >
> > > Right, I had noticed the same but was a tad too lazy to address in
> > > this series :) Thanks for the review, Reji!
> > >
> >
> > KVM doesn't reserve any subrange within [0 - max_ipa), afaik. So all
> > we need to do is check 'entry_addr < max_ipa', right?
> >
> 
> We could be a bit more pedantic and check if the IPA exists in a
> memory slot, seems like kvm_vcpu_is_visible_gfn() should do the trick.
> 
> Thoughts?

Are we sure that all emulated devices, nvram, etc. will always use a
memslot for regions that contain executable code? If there's any doubt,
then we can't be sure about non-memslot regions within the max_ipa range.
That'd be up to userspace.

Thanks,
drew

