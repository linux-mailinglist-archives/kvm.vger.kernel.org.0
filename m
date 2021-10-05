Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC09422BC7
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhJEPHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 11:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbhJEPHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 11:07:10 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8A9C061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 08:05:19 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id i4so88431551lfv.4
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 08:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HqqxFqGpoPg5UsnQOH2LSR3rMJcXiVCZ/CJeT8HveYE=;
        b=RY1wIjfDq9+SAd96CHn57dURL6ZXbL4I2NbPQrvjfUP9h5tmxq45G6s/GKSWlnr6ja
         0otKi37tmc8H1pG7JxuwNjafSUDZz4YY5HG7U/sGgGHDlYHXPjc0QlBnZctuW4XxFVIK
         q8F2uzbo4imvEmYV1QnCbhr/b0RE9lh7ApZ/YKS8ayP/atoarrH/gl2wLzaoQepQgplN
         nv6BC20DtSoH+hvAdPPY191guRmfGV8LX16fpG5YdFXU4x2GFLsZ+rVXeCWehdctVBnu
         Md08GkhtO8ZhpzMYfThwCesnfNJCjQfb7tst02QgWlO8qY0DLnq/Ng/WXK69Ce5k0Q92
         /IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HqqxFqGpoPg5UsnQOH2LSR3rMJcXiVCZ/CJeT8HveYE=;
        b=Q+knhHiU4j853WSoRmQK51jWEavtvbJp82C0t1jdv0ktYZkR6xHSlzWcob8ea3s6MV
         JREwCAWOiLCWzs8g+AZvcsI9lhsXy2rLCEHNR3zHfhc5KOSE+lw94Exy4vTHAZzzQn6M
         TZsCLBWx7nUGzT86UCTaWSClo6yV4gBFRRrzXicvgd6T8L6dAHTKyfWFjbR1N7wLraiP
         KL8Xt9wJD/e2vXw5mNpoNzqeGwLMQP3tQQnmUO0NS8Mz01ZWNerqjF3NCBSukz1crVU5
         gecYeDgOfRLHa+XA4J/ESDz3B8GnmidKWYMDngujtawAf6VEitZpEYWldOvXTLGtyn3Z
         tl6Q==
X-Gm-Message-State: AOAM530WwhxiUS1XGxW/HVTFkVSWQsZNOCSS33TS6JPNr2LcRnCsckoc
        ZH1tE6BJYC/MDNXPDm84B5QgVzvlNkfvutWUb3Lfqw==
X-Google-Smtp-Source: ABdhPJxX8U4W/cLaz3K2FSVqDERDSyCaRKhLNGtRzddkM6nSSebMuNQDwRkMdCq8atcRNjsbnnH2tHHq2sX5yk5qrA4=
X-Received: by 2002:ac2:4ecf:: with SMTP id p15mr3985703lfr.669.1633446316476;
 Tue, 05 Oct 2021 08:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-4-oupton@google.com>
 <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
 <CAOQ_QshHDWWEw5BEu-uudFttP1pfJcKuQ-0D_xAkoHJRqYLq8Q@mail.gmail.com> <20211005133335.y4k5qv7d3g74nnzx@gator.home>
In-Reply-To: <20211005133335.y4k5qv7d3g74nnzx@gator.home>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 5 Oct 2021 08:05:02 -0700
Message-ID: <CAOQ_QsgwK=qyeaUtNJeZ1OWQwaFUAQcy6uopnDuyDA3Qyt7gmw@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in a
 helper function
To:     Andrew Jones <drjones@redhat.com>
Cc:     Reiji Watanabe <reijiw@google.com>, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

On Tue, Oct 5, 2021 at 6:33 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Oct 01, 2021 at 09:10:14AM -0700, Oliver Upton wrote:
> > On Thu, Sep 30, 2021 at 11:05 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > In its implementation of the PSCI function, KVM needs to request that a
> > > > target vCPU resets before its next entry into the guest. Wrap the logic
> > > > for requesting a reset in a function for later use by other implemented
> > > > PSCI calls.
> > > >
> > > > No functional change intended.
> > > >
> > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > ---
> > > >  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
> > > >  1 file changed, 35 insertions(+), 24 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > index 310b9cb2b32b..bb59b692998b 100644
> > > > --- a/arch/arm64/kvm/psci.c
> > > > +++ b/arch/arm64/kvm/psci.c
> > > > @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
> > > >         return !(affinity & ~MPIDR_HWID_BITMASK);
> > > >  }
> > > >
> > > > -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> > > > +                                       unsigned long entry_addr,
> > > > +                                       unsigned long context_id,
> > > > +                                       bool big_endian)
> > > >  {
> > > >         struct vcpu_reset_state *reset_state;
> > > > +
> > > > +       lockdep_assert_held(&vcpu->kvm->lock);
> > > > +
> > > > +       reset_state = &vcpu->arch.reset_state;
> > > > +       reset_state->pc = entry_addr;
> > > > +
> > > > +       /* Propagate caller endianness */
> > > > +       reset_state->be = big_endian;
> > > > +
> > > > +       /*
> > > > +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > +        * the general purpose registers are undefined upon CPU_ON.
> > > > +        */
> > > > +       reset_state->r0 = context_id;
> > > > +
> > > > +       WRITE_ONCE(reset_state->reset, true);
> > > > +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > +
> > > > +       /*
> > > > +        * Make sure the reset request is observed if the change to
> > > > +        * power_state is observed.
> > > > +        */
> > > > +       smp_wmb();
> > > > +       vcpu->arch.power_off = false;
> > > > +}
> > > > +
> > > > +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > +{
> > > >         struct kvm *kvm = source_vcpu->kvm;
> > > >         struct kvm_vcpu *vcpu = NULL;
> > > >         unsigned long cpu_id;
> > > > @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > >                         return PSCI_RET_INVALID_PARAMS;
> > > >         }
> > > >
> > > > -       reset_state = &vcpu->arch.reset_state;
> > > > -
> > > > -       reset_state->pc = smccc_get_arg2(source_vcpu);
> > > > -
> > > > -       /* Propagate caller endianness */
> > > > -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> > > > -
> > > > -       /*
> > > > -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > -        * the general purpose registers are undefined upon CPU_ON.
> > > > -        */
> > > > -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> > > > -
> > > > -       WRITE_ONCE(reset_state->reset, true);
> > > > -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > -
> > > > -       /*
> > > > -        * Make sure the reset request is observed if the change to
> > > > -        * power_state is observed.
> > > > -        */
> > > > -       smp_wmb();
> > > > -
> > > > -       vcpu->arch.power_off = false;
> > > > +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> > > > +                                   smccc_get_arg3(source_vcpu),
> > > > +                                   kvm_vcpu_is_be(source_vcpu));
> > > >         kvm_vcpu_wake_up(vcpu);
> > > >
> > > >         return PSCI_RET_SUCCESS;
> > > > --
> > > > 2.33.0.685.g46640cef36-goog
> > >
> > > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > >
> > > Not directly related to the patch, but the (original) code doesn't
> > > do any sanity checking for the entry address although the PSCI spec says:
> > >
> > > "INVALID_ADDRESS is returned when the entry point address is known
> > > by the implementation to be invalid, because it is in a range that
> > > is known not to be available to the caller."
> >
> > Right, I had noticed the same but was a tad too lazy to address in
> > this series :) Thanks for the review, Reji!
> >
>
> KVM doesn't reserve any subrange within [0 - max_ipa), afaik. So all
> we need to do is check 'entry_addr < max_ipa', right?
>

We could be a bit more pedantic and check if the IPA exists in a
memory slot, seems like kvm_vcpu_is_visible_gfn() should do the trick.

Thoughts?

--
Thanks,
Oliver
