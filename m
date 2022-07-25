Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6D65807FD
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbiGYXJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiGYXJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:09:13 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ED826116
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:09:11 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t1so20199642lft.8
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nxkkbu4PaWAL03Xa15Nk/T12fxU9Ih6+psHZA3sfaGk=;
        b=neUG8tDay6/IBoRCOxUi9G5oeJYndGYEH6XBcuZsKPm3yh50Tz0DGcfQPPIScNHC9a
         Ys1Cn1cMccERaalBA0A3hJLywSuKZdx4cVUu5azb/fibUWCfwIK6hoM0ZT4hr1O6yxF8
         eMIozopRzY/PEmX6wKvhNkvykIZQZxo1t/Sixu9M4pOJC0XKmeEvQRq9zooJGw6yuEAI
         GZfkBSZwgEvN9rqlvDCYgOYCd09A1VbcKRUgdsXYehe/aQP+FnCiHMJ3iu8XCeLLwZln
         c/ndcUjWL5o77Qvej7s6j8atK6ePnKxKPo3A5d8Cw2HxckEg2SZWlnENIfULLOQ1+I2m
         gzqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nxkkbu4PaWAL03Xa15Nk/T12fxU9Ih6+psHZA3sfaGk=;
        b=Ec2bAJKb71QO7qXASVFIXtHOT1p7fMSf4rQ0UH1hYbc1urYdTpZeZqh39dSzek3xlw
         2P87S6Z975VB866qfwHNN6AC3NgIX6Q1Sy2KKJzDrhh4qbNjgJJ/ffJ5ye7BYoON3+zn
         JtYzL2nO6wE0flKBMoqiWhITSJMbZVTSA1APXQLaJ/6r+1nWYywQ/0L7uZZ/QPzfTcK4
         57UbxJyO06lxXIaf4M6Wmy3Zn/FMI5tlSfE6f5PRGhxBByW+W4B3+wMGAcHeJT+2T/q3
         JsD5bH5WyqRME8AgTwrqXBFzmwqBXLEHXLDKENx7R5aeoKzEgaSVEAuIUFXgwqOfEW39
         +D3Q==
X-Gm-Message-State: AJIora8bSCp1Fic29l7chKJmXaV/EavhT2M+dJK/yY49wG1bebk2JDu3
        8CDyka9wk7UCp2ybuNN37n93xXCe1ed/nzm52QV+bQ==
X-Google-Smtp-Source: AGRyM1tTQpPUr0F72E/4mziv8UzCOgLW7JaukZRk7DIHCuGAIWmrcjndc22CvZ0BJM1nUQE6fgssjSGCLHAbqPJCSD8=
X-Received: by 2002:ac2:5207:0:b0:48a:7aa6:e74c with SMTP id
 a7-20020ac25207000000b0048a7aa6e74cmr4997664lfl.104.1658790549242; Mon, 25
 Jul 2022 16:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220723012325.1715714-1-seanjc@google.com> <20220723012325.1715714-3-seanjc@google.com>
 <Yt8hu/+I8YzVckvU@google.com>
In-Reply-To: <Yt8hu/+I8YzVckvU@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 25 Jul 2022 16:08:42 -0700
Message-ID: <CALzav=djkQWrxxXR5qik8A=GK5fpg+RN3Qfrmgwxoh1NVu7+aQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: x86/mmu: Properly account NX huge page
 workaround for nonpaging MMUs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022 at 4:05 PM David Matlack <dmatlack@google.com> wrote:
>
> On Sat, Jul 23, 2022 at 01:23:21AM +0000, Sean Christopherson wrote:
> > Account and track NX huge pages for nonpaging MMUs so that a future
> > enhancement to precisely check if shadow page cannot be replaced by a NX
> > huge page doesn't get false positives.  Without correct tracking, KVM can
> > get stuck in a loop if an instruction is fetching and writing data on the
> > same huge page, e.g. KVM installs a small executable page on the fetch
> > fault, replaces it with an NX huge page on the write fault, and faults
> > again on the fetch.
> >
> > Alternatively, and perhaps ideally, KVM would simply not enforce the
> > workaround for nonpaging MMUs.  The guest has no page tables to abuse
> > and KVM is guaranteed to switch to a different MMU on CR0.PG being
> > toggled so there's no security or performance concerns.  However, getting
> > make_spte() to play nice now and in the future is unnecessarily complex.
> >
> > In the current code base, make_spte() can enforce the mitigation if TDP
> > is enabled or the MMU is indirect, but make_spte() may not always have a
> > vCPU/MMU to work with, e.g. if KVM were to support in-line huge page
> > promotion when disabling dirty logging.
> >
> > Without a vCPU/MMU, KVM could either pass in the correct information
> > and/or derive it from the shadow page, but the former is ugly and the
> > latter subtly non-trivial due to the possitibility of direct shadow pages
> > in indirect MMUs.  Given that using shadow paging with an unpaged guest
> > is far from top priority _and_ has been subjected to the workaround since
> > its inception, keep it simple and just fix the accounting glitch.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>
> It's odd that KVM enforced NX Huge Pages but just skipped the accounting.
> In retrospect, that was bound to cause some issue.
>
> Aside from the comment suggestion below,
>
> Reviewed-by: David Matlack <dmatlack@google.com>
>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          |  2 +-
> >  arch/x86/kvm/mmu/mmu_internal.h |  8 ++++++++
> >  arch/x86/kvm/mmu/spte.c         | 11 +++++++++++
> >  3 files changed, 20 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 1112e3a4cf3e..493cdf1c29ff 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3135,7 +3135,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                       continue;
> >
> >               link_shadow_page(vcpu, it.sptep, sp);
> > -             if (fault->is_tdp && fault->huge_page_disallowed)
> > +             if (fault->huge_page_disallowed)
> >                       account_nx_huge_page(vcpu->kvm, sp,
> >                                            fault->req_level >= it.level);
> >       }
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index ff4ca54b9dda..83644a0167ab 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -201,6 +201,14 @@ struct kvm_page_fault {
> >
> >       /* Derived from mmu and global state.  */
> >       const bool is_tdp;
> > +
> > +     /*
> > +      * Note, enforcing the NX huge page mitigation for nonpaging MMUs
> > +      * (shadow paging, CR0.PG=0 in the guest) is completely unnecessary.
> > +      * The guest doesn't have any page tables to abuse and is guaranteed
> > +      * to switch to a different MMU when CR0.PG is toggled on (may not
> > +      * always be guaranteed when KVM is using TDP).  See also make_spte().
> > +      */
> >       const bool nx_huge_page_workaround_enabled;
> >
> >       /*
> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index 7314d27d57a4..9f3e5af088a5 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -147,6 +147,17 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >       if (!prefetch)
> >               spte |= spte_shadow_accessed_mask(spte);
> >
> > +     /*
> > +      * For simplicity, enforce the NX huge page mitigation even if not
> > +      * strictly necessary.  KVM could ignore if the mitigation if paging is
> > +      * disabled in the guest, but KVM would then have to ensure a new MMU
> > +      * is loaded (or all shadow pages zapped) when CR0.PG is toggled on,
> > +      * and that's a net negative for performance when TDP is enabled.  KVM
> > +      * could ignore the mitigation if TDP is disabled and CR0.PG=0, as KVM
> > +      * will always switch to a new MMU if paging is enabled in the guest,
> > +      * but that adds complexity just to optimize a mode that is anything
> > +      * but performance critical.
> > +      */
>
> I had some trouble parsing the last sentence. How about this for slightly
> better flow:
>
>         /*
>          * For simplicity, enforce the NX huge page mitigation even if not
>          * strictly necessary.  KVM could ignore if the mitigation if paging is
>          * disabled in the guest, but KVM would then have to ensure a new MMU
>          * is loaded (or all shadow pages zapped) when CR0.PG is toggled on,
>          * and that's a net negative for performance when TDP is enabled.  When
>          * TDP is disabled, KVM will always switch to a new MMU when CR0.PG is
>          * toggled, but that would tie make_spte() further to vCPU/MMU state
>          * and add complexity just to optimize a mode that is anything but
>          * performance critical.

Blegh. Should be:

"... but leveraging that to ignore the mitigation would tie
make_spte() further..."

>          */
>
> >       if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
> >           is_nx_huge_page_enabled(vcpu->kvm)) {
> >               pte_access &= ~ACC_EXEC_MASK;
> > --
> > 2.37.1.359.gd136c6c3e2-goog
> >
