Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6370264CCD6
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 16:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbiLNPH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 10:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237778AbiLNPH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 10:07:57 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAC811825;
        Wed, 14 Dec 2022 07:07:55 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x66so4651961pfx.3;
        Wed, 14 Dec 2022 07:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qghbZ1vjirzjUztvBE2sOOI5LO9NPRdxa9b2gkNrWIo=;
        b=lV7TKJSjN7h9wfcCVyKTNVr7QvjbhZ1bSqcrNg1PIPmWir9yH0rtfb1mzDx2PCfP7c
         pTQyQ3cBcXUB/+rGR1FZjdhk/CKFPIY+7EdbDsIcSjuAw0a7XM+kcP+740iHTIY1H8VO
         u+eYXzURbq2UtnYoqcqe8YTjY6uKsdc2ummc51vluIqCc6TxF//pSL9smq9XZHFQBBCl
         RsvWle3Bo22z9+9hOHEIOIxfMO9MejoCpH28FkrJMijq5Uj6e9d3og0nmhlibG/N4wxE
         UUw9mz3aJU48cCzPbiWd18xLVlReslMaqU5Akk+xtIyoPZEAJbDNn2ldpf70e2uZXZcE
         /dIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qghbZ1vjirzjUztvBE2sOOI5LO9NPRdxa9b2gkNrWIo=;
        b=F/VfME7UO6jzJn1b7KWn6O6ZecQ1FHXQeiGMmqbBEo9DrLxsKtQClyO+GuJ4btHAo3
         UsQbIR0baw2aamVHOy3Q3r+2kZ8hlHAepBKxI2JI/W2B4NrDjMIKJ9uPnM1nM+J7jIk3
         /xEycEP+OFBLg3TcMe1n3mtpJ7O6z0jPA8FIO54zuG+6n02TjNUPouQ1DLYyO9zaMMwd
         bqWYg20Jm/QpqMT5WeJ4N0pnFjOaVvyRiZ54eCJtuhOb3LIo1JLOsZ2QeFitfNUCeVd3
         Wdpaa7ua6y5YvfPoCPwOb5i3B0bChnUBnLclxu9rOABuOKwEkFfQkfylZOFdh22yEgVe
         PzHw==
X-Gm-Message-State: ANoB5plexQmB4Wx6rmiElksY05xbMeJvJeBnuOm2FY3IsdUSufYNhZnA
        hshMQz2huqkJpThM2mtokoaLXKyDh/jV69NFVQEgmgrF
X-Google-Smtp-Source: AA0mqf7A2dJWm35FQPh9Y52xY+Fkrmij/4QW3ZLrwJ6xv0D0waWGXR6b5e9heTPpfLeyZgWYYlZJGCSH1DG+DPzuuXM=
X-Received: by 2002:a05:6a00:2352:b0:572:91c6:9e4e with SMTP id
 j18-20020a056a00235200b0057291c69e4emr81363148pfj.53.1671030475127; Wed, 14
 Dec 2022 07:07:55 -0800 (PST)
MIME-Version: 1.0
References: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
 <0ce24d7078fa5f1f8d64b0c59826c50f32f8065e.1665214747.git.houwenlong.hwl@antgroup.com>
 <Y0bvT8k9vlDUPup+@google.com>
In-Reply-To: <Y0bvT8k9vlDUPup+@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Wed, 14 Dec 2022 23:07:43 +0800
Message-ID: <CAJhGHyAENXDLL=2-2KXL3_hKF+XZaFxOfRV2vaf6E5nhUa1Mzw@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing
 in kvm_set_pte_rmapp()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Hou Wenlong <houwenlong.hwl@antgroup.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 13, 2022 at 1:00 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Oct 10, 2022, Hou Wenlong wrote:
> > When the spte of hupe page is dropped in kvm_set_pte_rmapp(), the whole
> > gfn range covered by the spte should be flushed. However,
> > rmap_walk_init_level() doesn't align down the gfn for new level like tdp
> > iterator does, then the gfn used in kvm_set_pte_rmapp() is not the base
> > gfn of huge page. And the size of gfn range is wrong too for huge page.
> > Use the base gfn of huge page and the size of huge page for flushing
> > tlbs for huge page. Also introduce a helper function to flush the given
> > page (huge or not) of guest memory, which would help prevent future
> > buggy use of kvm_flush_remote_tlbs_with_address() in such case.
> >
> > Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          |  4 +++-
> >  arch/x86/kvm/mmu/mmu_internal.h | 10 ++++++++++
> >  2 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 7de3579d5a27..4874c603ed1c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1430,7 +1430,9 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >       }
> >
> >       if (need_flush && kvm_available_flush_tlb_with_range()) {
> > -             kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
> > +             gfn_t base = gfn_round_for_level(gfn, level);
> > +
> > +             kvm_flush_remote_tlbs_gfn(kvm, base, level);
> >               return false;
> >       }
> >
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 17488d70f7da..249bfcd502b4 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -168,8 +168,18 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
> >  bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
> >                                   struct kvm_memory_slot *slot, u64 gfn,
> >                                   int min_level);
> > +
> >  void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
> >                                       u64 start_gfn, u64 pages);
> > +
> > +/* Flush the given page (huge or not) of guest memory. */
> > +static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
> > +{
> > +     u64 pages = KVM_PAGES_PER_HPAGE(level);
> > +
>
> Rather than require the caller to align gfn, what about doing gfn_round_for_level()
> in this helper?  It's a little odd that the caller needs to align gfn but doesn't
> have to compute the size.
>
> I'm 99% certain kvm_set_pte_rmap() is the only path that doesn't already align the
> gfn, but it's nice to not have to worry about getting this right, e.g. alternatively
> this helper could WARN if the gfn is misaligned, but that's _more work.
>
>         kvm_flush_remote_tlbs_with_address(kvm, gfn_round_for_level(gfn, level),
>                                            KVM_PAGES_PER_HPAGE(level);
>
> If no one objects, this can be done when the series is applied, i.e. no need to
> send v5 just for this.
>

Hello Paolo, Sean, Hou,

It seems the patchset has not been queued.  I believe it does
fix bugs.

Thanks
Lai
