Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6AE46436E
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 00:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241067AbhK3Xg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 18:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhK3Xgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 18:36:53 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F289C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:33:33 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id 13so44238130ljj.11
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVA3o0bIDUyIgLjzlrZYboOtfW+y6AT7A7cp/o3o4VM=;
        b=hVqi45XoceBOnpB7Rfn5vkEIl+SMjdodBOBMnLaIRJohPr6MTmuEXhZVY8wtpo9/ob
         buhFZ6uqJCe7W97WkSWO1IAbIzohHG3kxZ3mMHLHUMLDHyo16rSPTkwwhEeQYWTb9zOD
         7b7EzZB1AcLBkOcnAGUpvkeIczK/UJTuG35XV4B+teHLve2vPEH4c/siMBgs5HOoVvY/
         ypimsrqItoTaugC19LXfHebsDFBCIblGvK0RyT5exKIgoJRi1uVn8KwUkpFfmfvu+mzY
         +0ywbGqqpZbJgYH2+uzZeBzLsFLorKsHsmgNaN2dkKdPGFPJj/d9x5Y1Lmun65QOlPj4
         gV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVA3o0bIDUyIgLjzlrZYboOtfW+y6AT7A7cp/o3o4VM=;
        b=7i8e3v4JcvzO3sgFBHPCHTAdulpd8tQsfu1AeysIN9y3bzQFhFfUv/wbLHw5hUMgXi
         aRPd3aE60VRtExWw5vuV+BhGhywMtauAadu1WO/+U7NZU9QyxeLgQV9hUGoboI55uKbD
         0nFsbMeeqMl4N/RkdeUbN5ts8im/3GoaWH4nHw29JmB4TehqnYLBcmzAJ29OJdA5J8xC
         IgMh+F7pNXN3M0Cbmit9yqtiXXejk/Ik63MVM98E/vLxKKM6FvMtao/cP7qw+K6KnKFU
         NJ4QJUaMeBmUfG0lDtcioTJwl/m4LaCjCa+kqj0hutaUAV8iCXQk+tkCKvqf+nLv8z50
         m01g==
X-Gm-Message-State: AOAM530kZLMEL+qdXHrm9q/OucrSMbmheZsworTXh+gVX9J/KpNQav4T
        Tq8GzvFMzV1+ch+qwLq7UIGh5kRlOL2olWl3EEhNrw==
X-Google-Smtp-Source: ABdhPJwwXRLbNA8sH/AuH7AuetlKKoowya38EAwwO9mHV07gzEaE1L1Y6WyhEVtO6pO1t7OZ25/GhSSOlU4K70V0+Cc=
X-Received: by 2002:a2e:9e59:: with SMTP id g25mr1954100ljk.464.1638315211744;
 Tue, 30 Nov 2021 15:33:31 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-13-dmatlack@google.com>
 <714f04bc-ad43-0eaa-47e4-2c9fb7d8e35b@amd.com>
In-Reply-To: <714f04bc-ad43-0eaa-47e4-2c9fb7d8e35b@amd.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 15:33:05 -0800
Message-ID: <CALzav=f9BgpcimSjbtQ3qTMUZ_dkEtKFD6vR0LjdySDr0oCeKw@mail.gmail.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 21, 2021 at 9:05 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
>
>
>
> On 11/20/2021 5:27 AM, David Matlack wrote:
> > When dirty logging is enabled without initially-all-set, attempt to
> > split all large pages in the memslot down to 4KB pages so that vCPUs
> > do not have to take expensive write-protection faults to split large
> > pages.
> >
> > Large page splitting is best-effort only. This commit only adds the
> > support for the TDP MMU, and even there splitting may fail due to out
> > of memory conditions. Failures to split a large page is fine from a
> > correctness standpoint because we still always follow it up by write-
> > protecting any remaining large pages.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> > +int mmu_topup_split_caches(struct kvm *kvm)
> > +{
> > +     struct kvm_mmu_memory_caches *split_caches = &kvm->arch.split_caches;
> > +     int r;
> > +
> > +     assert_split_caches_invariants(kvm);
> > +
> > +     r = kvm_mmu_topup_memory_cache(&split_caches->page_header_cache, 1);
> > +     if (r)
> > +             goto out;
> > +
> > +     r = kvm_mmu_topup_memory_cache(&split_caches->shadow_page_cache, 1);
> > +     if (r)
> > +             goto out;
> > +
> > +     return 0;
> > +
> > +out:
> > +     pr_warn("Failed to top-up split caches. Will not split large pages.\n");
> > +     return r;
> > +}
> > +
> > +static void mmu_free_split_caches(struct kvm *kvm)
> > +{
> > +     assert_split_caches_invariants(kvm);
> > +
> > +     kvm_mmu_free_memory_cache(&kvm->arch.split_caches.pte_list_desc_cache);
>                                                               ^^^^^^^^^^^^^^
> I believe this should be page_header_cache.

Oh wow, thanks for catching that. You are correct. Will fix in v1.

>
> > +     kvm_mmu_free_memory_cache(&kvm->arch.split_caches.shadow_page_cache);
> > +}
>
> Regards
> Nikunj
>
