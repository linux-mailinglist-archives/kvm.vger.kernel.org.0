Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09602492CA4
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347536AbiARRps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiARRpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 12:45:47 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31BDC061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:45:46 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bu18so50792459lfb.5
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O0Ib0frfoMxDIRercCSX6k9OgI0AaBuKyo1VFKlOsto=;
        b=rqLYx3gw/w39B+13Cv8fWZHBqXcs+1bzLBic/BOwJ4M+kyhMOf2WNdDPMIF60d/GOA
         qzMU93VyKMuC9rlfdDHtqhahEsDNCYbOpT7lTXzx8B2oilCsjpO+MpvMzYBtUWUX3Obx
         4wx4P7duV8KdmCDBnNix8QjIAWOvLfjWGX7JH/6UfDDv5q4whbxzsa0uJpqsivc/Qd8r
         oZMDJi6ovG0rXeunuX1qUwDqUvn/gNcUiFt06+pg3npw8/fBgbVbtEtj2thnRwCZMUEE
         kgyg8R6DRK6bEOajImi885KEeM/Thils6ft114WKCZWBe3qUTYkXtQ5BOOGgLJQYtxtT
         UZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O0Ib0frfoMxDIRercCSX6k9OgI0AaBuKyo1VFKlOsto=;
        b=jghpWC8Uu5zeV2E+bpWsZrU/5plA+rFocJkqBRKMOSplQeiMlu31MCm/WBu3duugfm
         JUMWqTKNMhiJh45GQeSMnv9PaCott0coMfhE2M7IUNl7QTBJPBSEWn8p+XiUA3//2Beo
         qLtMzuy6BwKLSncqoBzIQ9TFaB8pwg8jS+olemtow8arIKUlH3jPrQj6vTtvJYRZUzK8
         WNVtgwgXKdRmMRyWuDhQ2vN401Dp9IAZNpAz1uO4fHynLtPcTRruTMF5i02m6DdAPMvG
         WRDT4/BJkHQmM0J8DxNB26NbgS3ltdkNstLn85d6ff3vLktiFyBLhkuKsowKHqJHwYjl
         rJww==
X-Gm-Message-State: AOAM530BJz292WwXFo4oOsbaF/sdFizxLTVMg9rwnaDV85OkjziOzDhD
        qaoNMpH9fXWElRMB2rYlg6w2SehmSKPCX0TdiaMFRA==
X-Google-Smtp-Source: ABdhPJxb51BsQK4IUQPTDFxumGR1EosVMMppY0Xr548MJfyF4kP8olGjOztEu8Rz9+ST0RdWkyQXxw7IZMUUeTSczpA=
X-Received: by 2002:a05:651c:1304:: with SMTP id u4mr12967662lja.49.1642527945002;
 Tue, 18 Jan 2022 09:45:45 -0800 (PST)
MIME-Version: 1.0
References: <20220113233020.3986005-1-dmatlack@google.com> <20220113233020.3986005-4-dmatlack@google.com>
 <YeH5QlwgGcpStZyp@google.com>
In-Reply-To: <YeH5QlwgGcpStZyp@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 18 Jan 2022 09:45:18 -0800
Message-ID: <CALzav=firKgTUMF87t8Qv0pnooUVj5T5EbcOo2TZ8Zv5D_-tLw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: x86/mmu: Document and enforce MMU-writable
 and Host-writable invariants
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 2:29 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jan 13, 2022, David Matlack wrote:
> > +/*
> > + * *_SPTE_HOST_WRITEABLE (aka Host-writable) indicates whether the host permits
> > + * writes to the guest page mapped by the SPTE. This bit is cleared on SPTEs
> > + * that map guest pages in read-only memslots and read-only VMAs.
> > + *
> > + * Invariants:
> > + *  - If Host-writable is clear, PT_WRITABLE_MASK must be clear.
> > + *
> > + *
> > + * *_SPTE_MMU_WRITEABLE (aka MMU-writable) indicates whether the shadow MMU
> > + * allows writes to the guest page mapped by the SPTE. This bit is cleared when
> > + * the guest page mapped by the SPTE contains a page table that is being
> > + * monitored for shadow paging. In this case the SPTE can only be made writable
> > + * by unsyncing the shadow page under the mmu_lock.
> > + *
> > + * Invariants:
> > + *  - If MMU-writable is clear, PT_WRITABLE_MASK must be clear.
> > + *  - If MMU-writable is set, Host-writable must be set.
> > + *
> > + * If MMU-writable is set, PT_WRITABLE_MASK is normally set but can be cleared
> > + * to track writes for dirty logging. For such SPTEs, KVM will locklessly set
> > + * PT_WRITABLE_MASK upon the next write from the guest and record the write in
> > + * the dirty log (see fast_page_fault()).
> > + */
> > +
> > +/* Bits 9 and 10 are ignored by all non-EPT PTEs. */
> > +#define DEFAULT_SPTE_HOST_WRITEABLE  BIT_ULL(9)
> > +#define DEFAULT_SPTE_MMU_WRITEABLE   BIT_ULL(10)
>
> Ha, so there's a massive comment above is_writable_pte() that covers a lot of
> the same material.  More below.
>
> > +
> >  /*
> >   * Low ignored bits are at a premium for EPT, use high ignored bits, taking care
> >   * to not overlap the A/D type mask or the saved access bits of access-tracked
> > @@ -316,8 +341,13 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
> >
> >  static inline bool spte_can_locklessly_be_made_writable(u64 spte)
> >  {
> > -     return (spte & shadow_host_writable_mask) &&
> > -            (spte & shadow_mmu_writable_mask);
> > +     if (spte & shadow_mmu_writable_mask) {
> > +             WARN_ON_ONCE(!(spte & shadow_host_writable_mask));
> > +             return true;
> > +     }
> > +
> > +     WARN_ON_ONCE(spte & PT_WRITABLE_MASK);
>
> I don't like having the WARNs here.  This is a moderately hot path, there are a
> decent number of call sites, and the WARNs won't actually help detect the offender,
> i.e. whoever wrote the bad SPTE long since got away.

Re: hot path. The "return true" case (for fast_page_fault()) already
had to do 2 bitwise-ANDs and compares, so this patch shouldn't make
that any worse.

But that's a good point that it doesn't help with detecting the
offender. I agree these WARNs should move to where SPTEs are set.

>
> And for whatever reason, I had a hell of a time (correctly) reading the second WARN :-)
>
> Lastly, there's also an "overlapping" WARN in mark_spte_for_access_track().
>
> > +     return false;
>
> To kill a few birds with fewer stones, what if we:
>
>   a. Move is_writable_pte() into spte.h, somewhat close to the HOST/MMU_WRITABLE
>      definitions.
>
>   b. Add a new helper, spte_check_writable_invariants(), to enforce that a SPTE
>      is WRITABLE iff it's MMU-Writable, and that a SPTE is MMU-Writable iff it's
>      HOST-Writable.
>
>   c. Drop the WARN in mark_spte_for_access_track().
>
>   d. Call spte_check_writable_invariants() when setting SPTEs.
>
>   e. Document everything in a comment above spte_check_writable_invariants().

Sounds good. I'll send a follow-up series.
