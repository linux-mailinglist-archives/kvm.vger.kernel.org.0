Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0CA46583A
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 22:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344010AbhLAVRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 16:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbhLAVRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 16:17:36 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E35C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 13:14:13 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id e11so50675586ljo.13
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 13:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6KRAC50c9+BoGyHLtnDIoLadWCQBUPmp3kLg8+Vg0po=;
        b=cmI+iqicNloY6zmgUMH89wXDyIJm9AeXMvs+P/wRbNVI4k+zqzECqX0XMixvEvNsDk
         endfcwpzcgR1JXIjkf8mh3Ioa79XvA4O7nk0yf4Z9C4kjbAcsacHmx1zHPR06bMICcaZ
         +/VyNwAP+VLgAAZeP+SuDcQgSESiQDZ689evI+47Mrv1t/owfmHZzr7Eg6UnfFoG0QPf
         t9mqd/xUMZKNz+DN2HwPXaYFh+ODyJPIJoerx92K0cK2zZ8DRpgeDSgh4b43MvFcYMeq
         +bL6YRd5SP0XTNfYuTzJ0xU8lj9n6oW8fgj0OxVOgKvfvtVCehqAL7mWe2wR8rzRZAPk
         dw6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6KRAC50c9+BoGyHLtnDIoLadWCQBUPmp3kLg8+Vg0po=;
        b=pyKDCJFBg78I9Hns5Zt91KW3RIq9peAyrZhN0dcLpcUbfNaH4l/N+maFSt5XQl7boz
         /og6ou3f1LCTRdlw6dkU9s3Eg7A1FN1huKp+NTPEX3di70aNNVc03S9/7jJbSFsw7VcC
         R4r1jzCRLwdyD7R5ycTSgxRdEvL1Hrg67jwMUQRm/vwBi997QHDvyfHKV0oaUnilqBYD
         U9ibtF9ZUeiGGa1DQJURlK/9XWageizMBsf3QOsGKNlsxxLVXfdah2VJHYRmxVNM55Kg
         hwkUhorDG9JWvLB/8f2jpdWiG2GBInsBAvNQDHQFQ1FKUzOw05vINU3KZlFjPhR48pAN
         qjpw==
X-Gm-Message-State: AOAM533JkZDkohu+kAXzoW7qbwiu49zh4j+LTiPvzP9WZyH0Z81gTS2l
        Y4w6VDNyxsUdFI3XJoJUkZ1eC31mhQ0tDuN4t3YuBA==
X-Google-Smtp-Source: ABdhPJznswxfk7oZFI2DPJNbF1JwRucf1nJWOj/VZs4W0xaxkMgdAKF5s8pcjaPSDsx+f5CgaYWTlG/jAEiQ5ESsmIQ=
X-Received: by 2002:a2e:8895:: with SMTP id k21mr8075049lji.331.1638393251121;
 Wed, 01 Dec 2021 13:14:11 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-9-dmatlack@google.com>
 <YafAHTRyFMZRNGKi@google.com>
In-Reply-To: <YafAHTRyFMZRNGKi@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 1 Dec 2021 13:13:44 -0800
Message-ID: <CALzav=fEY7X4NpsFp4bG3J1gv2J=ohYdMLJco7a2rC4G2bt6eA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/15] KVM: x86/mmu: Helper method to check for large
 and present sptes
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 1, 2021 at 10:34 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Nov 19, 2021, David Matlack wrote:
> > Consolidate is_large_pte and is_present_pte into a single helper. This
> > will be used in a follow-up commit to check for present large-pages
> > during Eager Page Splitting.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/spte.h    | 5 +++++
> >  arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index cc432f9a966b..e73c41d31816 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -257,6 +257,11 @@ static inline bool is_large_pte(u64 pte)
> >       return pte & PT_PAGE_SIZE_MASK;
> >  }
> >
> > +static inline bool is_large_present_pte(u64 pte)
> > +{
> > +     return is_shadow_present_pte(pte) && is_large_pte(pte);
> > +}
> > +
> >  static inline bool is_last_spte(u64 pte, int level)
> >  {
> >       return (level == PG_LEVEL_4K) || is_large_pte(pte);
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index ff4d83ad7580..f8c4337f1fcf 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1011,8 +1011,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                * than the target, that SPTE must be cleared and replaced
> >                * with a non-leaf SPTE.
> >                */
> > -             if (is_shadow_present_pte(iter.old_spte) &&
> > -                 is_large_pte(iter.old_spte)) {
> > +             if (is_large_present_pte(iter.old_spte)) {
>
> I strongly object to this helper.  PRESENT in hardware and shadow-present are two
> very different things, the name is_large_present_pte() doesn't capture that detail.
> Yeah, we could name it is_large_shadow_present_pte(), but for me at least that
> requires more effort to read, and it's not like this is replacing 10s of instances.

Ok I'll drop it in v1.

>
> >                       if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> >                               break;
> >               }
> > --
> > 2.34.0.rc2.393.gf8c9666880-goog
> >
