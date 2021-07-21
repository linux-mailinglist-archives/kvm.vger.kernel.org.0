Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485653D09D8
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 09:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbhGUG5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 02:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbhGUG5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 02:57:21 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48F2C061762
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 00:37:58 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so1320225otl.0
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 00:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sbDE9nuiwcCGzXXq+7fSJ8S51kGTOjsBAbq4AfxevII=;
        b=jGy1guoPkgxKAm1XQU1WLRIEQZY1AD4aitTaSIidCU3rRsvKa7nxuBID74o4MsS/bj
         4qXadR3io6HZi6HOnEdXWMjqn8bNkMukr9HhK5Zf9izRcFc+1b4yPdGDsHGvxaqAoLhR
         xibE1txj9oMAoU+2XyKy0BCoNvYyFfxbU3oh1bNDNJkIFiL0VxTxbMyipjkZSbIZg6fB
         Fukma3U+Q6MCJLGluVxLjsadF5PTSATyatjQ9hAZJMnzdT4ioLG+cAIEJrJ8RL1LcQ9c
         3Ka8kBButPskeIKyCsjo5hwsp1IQ9b9QPTGzOfWMqInEh4NTWwvm69W+Rj/wQHgJAl1g
         4+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sbDE9nuiwcCGzXXq+7fSJ8S51kGTOjsBAbq4AfxevII=;
        b=IXGy6XxnzDWxoTaXb9l/krE3p+91Uzg8k7mGCGfDN0DdxnMDJYsq/FgUzjOfRIOs1+
         VGGMRtgGhJj6Dcmie8lpJES5Z5HNttdDr7St0U1psyBgc/NDqjjOD6pdOXuiEJHJPlGC
         Ii+v2dBzqbUmZ0Q0ATe+AoOpM+fi/NsNarjE+fiX3CFglkM+FkOnubckQIgwzDvyadQs
         NStBwXUkc80qH3zJru8ZGXkFW/fxPZxCkp6j1CDPZpFYkLuBKY9yfWIXNLcughaJj6dS
         XBmjiyY6g8niCmaBrZqTcDUTSRQzigWqTyaqtVcGYyELbAQpSsdqbu9TNWutxkv0spS7
         ySnA==
X-Gm-Message-State: AOAM532Qv6/fdX9enK728n2mkNBvJR9tDVgBPHzGbqn1XqWngz51ZcEI
        Fi17Mg27n4cXyT6dbjvaQP4eWHXfBI0CwWq1UycPjA==
X-Google-Smtp-Source: ABdhPJzn9ZlAdVQ5+LOgkbShWo2nP3Ij7fKtXuiBI/ClZYD4r7erA2kfADFFHYYk/rf89JGWCw3PtbSRc5H7QH0EHpg=
X-Received: by 2002:a9d:4b02:: with SMTP id q2mr14416397otf.52.1626853077570;
 Wed, 21 Jul 2021 00:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-7-tabba@google.com>
 <20210720145258.axhqog3abdvtpqhw@gator>
In-Reply-To: <20210720145258.axhqog3abdvtpqhw@gator>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 21 Jul 2021 08:37:21 +0100
Message-ID: <CA+EHjTweLPu+DQ8hR9kEW0LrawtaoAoXR_+HmSEZpP-XOEm2qg@mail.gmail.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On Tue, Jul 20, 2021 at 3:53 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:37PM +0100, Fuad Tabba wrote:
> > On deactivating traps, restore the value of mdcr_el2 from the
> > newly created and preserved host value vcpu context, rather than
> > directly reading the hardware register.
> >
> > Up until and including this patch the two values are the same,
> > i.e., the hardware register and the vcpu one. A future patch will
> > be changing the value of mdcr_el2 on activating traps, and this
> > ensures that its value will be restored.
> >
> > No functional change intended.
>
> I'm probably missing something, but I can't convince myself that the host
> will end up with the same mdcr_el2 value after deactivating traps after
> this patch as before. We clearly now restore whatever we had when
> activating traps (presumably whatever we configured at init_el2_state
> time), but is that equivalent to what we had before with the masking and
> ORing that this patch drops?

You're right. I thought that these were actually being initialized to
the same values, but having a closer look at the code the mdcr values
are not the same as pre-patch. I will fix this.

Thanks!
/fuad

> Thanks,
> drew
>
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h       |  5 ++++-
> >  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  6 +++++-
> >  arch/arm64/kvm/hyp/nvhe/switch.c        | 11 ++---------
> >  arch/arm64/kvm/hyp/vhe/switch.c         | 12 ++----------
> >  arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |  2 +-
> >  6 files changed, 15 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 4d2d974c1522..76462c6a91ee 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -287,10 +287,13 @@ struct kvm_vcpu_arch {
> >       /* Stage 2 paging state used by the hardware on next switch */
> >       struct kvm_s2_mmu *hw_mmu;
> >
> > -     /* HYP configuration */
> > +     /* Values of trap registers for the guest. */
> >       u64 hcr_el2;
> >       u64 mdcr_el2;
> >
> > +     /* Values of trap registers for the host before guest entry. */
> > +     u64 mdcr_el2_host;
> > +
> >       /* Exception Information */
> >       struct kvm_vcpu_fault_info fault;
> >
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index 9d60b3006efc..657d0c94cf82 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -95,7 +95,7 @@ void __sve_restore_state(void *sve_pffr, u32 *fpsr);
> >
> >  #ifndef __KVM_NVHE_HYPERVISOR__
> >  void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> > -void deactivate_traps_vhe_put(void);
> > +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
> >  #endif
> >
> >  u64 __guest_enter(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index e4a2f295a394..a0e78a6027be 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -92,11 +92,15 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> >               write_sysreg(0, pmselr_el0);
> >               write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> >       }
> > +
> > +     vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
> >       write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> >  }
> >
> > -static inline void __deactivate_traps_common(void)
> > +static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
> >  {
> > +     write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
> > +
> >       write_sysreg(0, hstr_el2);
> >       if (kvm_arm_support_pmu_v3())
> >               write_sysreg(0, pmuserenr_el0);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index f7af9688c1f7..1778593a08a9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -69,12 +69,10 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> >  static void __deactivate_traps(struct kvm_vcpu *vcpu)
> >  {
> >       extern char __kvm_hyp_host_vector[];
> > -     u64 mdcr_el2, cptr;
> > +     u64 cptr;
> >
> >       ___deactivate_traps(vcpu);
> >
> > -     mdcr_el2 = read_sysreg(mdcr_el2);
> > -
> >       if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> >               u64 val;
> >
> > @@ -92,13 +90,8 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
> >               isb();
> >       }
> >
> > -     __deactivate_traps_common();
> > -
> > -     mdcr_el2 &= MDCR_EL2_HPMN_MASK;
> > -     mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
> > -     mdcr_el2 |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
> > +     __deactivate_traps_common(vcpu);
> >
> > -     write_sysreg(mdcr_el2, mdcr_el2);
> >       write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
> >
> >       cptr = CPTR_EL2_DEFAULT;
> > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > index b3229924d243..0d0c9550fb08 100644
> > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > @@ -91,17 +91,9 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
> >       __activate_traps_common(vcpu);
> >  }
> >
> > -void deactivate_traps_vhe_put(void)
> > +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
> >  {
> > -     u64 mdcr_el2 = read_sysreg(mdcr_el2);
> > -
> > -     mdcr_el2 &= MDCR_EL2_HPMN_MASK |
> > -                 MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
> > -                 MDCR_EL2_TPMS;
> > -
> > -     write_sysreg(mdcr_el2, mdcr_el2);
> > -
> > -     __deactivate_traps_common();
> > +     __deactivate_traps_common(vcpu);
> >  }
> >
> >  /* Switch to the guest for VHE systems running in EL2 */
> > diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> > index 2a0b8c88d74f..007a12dd4351 100644
> > --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> > +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> > @@ -101,7 +101,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
> >       struct kvm_cpu_context *host_ctxt;
> >
> >       host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > -     deactivate_traps_vhe_put();
> > +     deactivate_traps_vhe_put(vcpu);
> >
> >       __sysreg_save_el1_state(guest_ctxt);
> >       __sysreg_save_user_state(guest_ctxt);
> > --
> > 2.32.0.402.g57bb445576-goog
> >
>
