Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A37C4227F3
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhJENfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:35:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234103AbhJENfd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633440822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4J+axnygUv5fF5brGbtuIHDH+i1VLgtGxuN/wJoj3sg=;
        b=GFgM2WmhaC2oteFhyc5Xp0fozdAW9oIJcPN7Y4gBCj8wpFzGa0k4wcrRFIHOjJsEzeCxrJ
        uPC2tLJWHMSCgux7FB0WWbFBxrwCy3hvvhIYSYJ9uogrejN+DaLlVZdQxDmlQjcmSDK/Dy
        yLT7NjRP1rERFpQbSALkZ1IwaOr1Hng=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-7EOXvBSrPJqP5AwP_qeykg-1; Tue, 05 Oct 2021 09:33:41 -0400
X-MC-Unique: 7EOXvBSrPJqP5AwP_qeykg-1
Received: by mail-ed1-f72.google.com with SMTP id c8-20020a50d648000000b003daa53c7518so20353144edj.21
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4J+axnygUv5fF5brGbtuIHDH+i1VLgtGxuN/wJoj3sg=;
        b=RNdw+7Uid9P2kZwJj5nKycD9ie5Eiu9/nRMC4R+O0hMCx19v5QIlJ3sR8CRlvcsXqQ
         7dgw36MzhQ6XtMvSHBWKSiZ4NsB1L0Eiq5joS86Slmx4LOb2M3fY4vgKkzT45cu5Gnqw
         iPOrJ4ycueWrAEYrgqmFdafBZmfbV4AAeks1VxIJcJ8McQD1Z5DSPdn+rZLzqc9siIlZ
         Al28bjkA1zaAONYeHR/z9sw7wGLNXCKgSoywZ3ftkpFVXvD7R0k4lDGom6UITxkabVd7
         2UKdHAnswsvMPjJ21m8T6rkRaSKr+qDc0Bg+kjfCe7kU0cK7hRHU8esl15YI85IRO0CX
         Sw1Q==
X-Gm-Message-State: AOAM530HV1zSfrty2Sw17PaUh8dpiFYMSLnB9c4OtcjkQvIU5XQ3EFRS
        S2Rl/XRqAAJwSWhQSZ/J905FKYU29fJ6bUaAO4MZz2jouDkbWKJ6wo+vdAbA0OtbWLc7sApQSan
        0mTbxOJEFC3W1
X-Received: by 2002:a17:906:2f94:: with SMTP id w20mr26040590eji.14.1633440819803;
        Tue, 05 Oct 2021 06:33:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMHwad3cgL23xjtin0Sm2zmQR+8u3Q6zxBHQ6APAfDBRLaT2n0pUuIGzRYpxucws9ej8h4VQ==
X-Received: by 2002:a17:906:2f94:: with SMTP id w20mr26040443eji.14.1633440818308;
        Tue, 05 Oct 2021 06:33:38 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id p23sm9282938edw.94.2021.10.05.06.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:33:37 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:33:35 +0200
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
Message-ID: <20211005133335.y4k5qv7d3g74nnzx@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-4-oupton@google.com>
 <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
 <CAOQ_QshHDWWEw5BEu-uudFttP1pfJcKuQ-0D_xAkoHJRqYLq8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QshHDWWEw5BEu-uudFttP1pfJcKuQ-0D_xAkoHJRqYLq8Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 01, 2021 at 09:10:14AM -0700, Oliver Upton wrote:
> On Thu, Sep 30, 2021 at 11:05 PM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > In its implementation of the PSCI function, KVM needs to request that a
> > > target vCPU resets before its next entry into the guest. Wrap the logic
> > > for requesting a reset in a function for later use by other implemented
> > > PSCI calls.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
> > >  1 file changed, 35 insertions(+), 24 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > index 310b9cb2b32b..bb59b692998b 100644
> > > --- a/arch/arm64/kvm/psci.c
> > > +++ b/arch/arm64/kvm/psci.c
> > > @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
> > >         return !(affinity & ~MPIDR_HWID_BITMASK);
> > >  }
> > >
> > > -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> > > +                                       unsigned long entry_addr,
> > > +                                       unsigned long context_id,
> > > +                                       bool big_endian)
> > >  {
> > >         struct vcpu_reset_state *reset_state;
> > > +
> > > +       lockdep_assert_held(&vcpu->kvm->lock);
> > > +
> > > +       reset_state = &vcpu->arch.reset_state;
> > > +       reset_state->pc = entry_addr;
> > > +
> > > +       /* Propagate caller endianness */
> > > +       reset_state->be = big_endian;
> > > +
> > > +       /*
> > > +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > +        * the general purpose registers are undefined upon CPU_ON.
> > > +        */
> > > +       reset_state->r0 = context_id;
> > > +
> > > +       WRITE_ONCE(reset_state->reset, true);
> > > +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > +
> > > +       /*
> > > +        * Make sure the reset request is observed if the change to
> > > +        * power_state is observed.
> > > +        */
> > > +       smp_wmb();
> > > +       vcpu->arch.power_off = false;
> > > +}
> > > +
> > > +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > +{
> > >         struct kvm *kvm = source_vcpu->kvm;
> > >         struct kvm_vcpu *vcpu = NULL;
> > >         unsigned long cpu_id;
> > > @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > >                         return PSCI_RET_INVALID_PARAMS;
> > >         }
> > >
> > > -       reset_state = &vcpu->arch.reset_state;
> > > -
> > > -       reset_state->pc = smccc_get_arg2(source_vcpu);
> > > -
> > > -       /* Propagate caller endianness */
> > > -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> > > -
> > > -       /*
> > > -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > -        * the general purpose registers are undefined upon CPU_ON.
> > > -        */
> > > -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> > > -
> > > -       WRITE_ONCE(reset_state->reset, true);
> > > -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > -
> > > -       /*
> > > -        * Make sure the reset request is observed if the change to
> > > -        * power_state is observed.
> > > -        */
> > > -       smp_wmb();
> > > -
> > > -       vcpu->arch.power_off = false;
> > > +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> > > +                                   smccc_get_arg3(source_vcpu),
> > > +                                   kvm_vcpu_is_be(source_vcpu));
> > >         kvm_vcpu_wake_up(vcpu);
> > >
> > >         return PSCI_RET_SUCCESS;
> > > --
> > > 2.33.0.685.g46640cef36-goog
> >
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> >
> > Not directly related to the patch, but the (original) code doesn't
> > do any sanity checking for the entry address although the PSCI spec says:
> >
> > "INVALID_ADDRESS is returned when the entry point address is known
> > by the implementation to be invalid, because it is in a range that
> > is known not to be available to the caller."
> 
> Right, I had noticed the same but was a tad too lazy to address in
> this series :) Thanks for the review, Reji!
>

KVM doesn't reserve any subrange within [0 - max_ipa), afaik. So all
we need to do is check 'entry_addr < max_ipa', right?

Thanks,
drew

