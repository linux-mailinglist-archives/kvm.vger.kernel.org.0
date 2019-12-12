Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C7911D42F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbfLLRhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:37:34 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38915 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbfLLRhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 12:37:34 -0500
Received: by mail-oi1-f194.google.com with SMTP id a67so1068737oib.6
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 09:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85/Q4O/XPGPhGcxW85SoqxJkDWVGa36c4g0JD0LKUdQ=;
        b=2QiartKIZdQPCbLz3nE7oYW8NvdklpGuw+X/svYmd9KVlu553fO1rCfkF6KUg/yadG
         HIQRj6DFW4Gnh2+XqLfpISpj0DQ0TmfshCBvuCHn/u9Kt0Ixx5njGPl26Y+KXqdC1kPU
         sQvB5a0wbVjTrf0FqZ7HgLinJ5CTZ3uLcXdTbINhtBaH/7Ej6RXaxxVrf9ifEDGylntD
         4K9sJvTSvFu8WJK6x73GzLtnjQDvHmU1Z/nwpMDzHJiw5p0G4im6aR5UD7iNk84xDYkB
         eAw2it3p6Sux2nAsZnBOVAKMTff+JnLEjDlV2yW59y0lgwa0SSiRAxEz0VkkrTo10WHE
         PqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85/Q4O/XPGPhGcxW85SoqxJkDWVGa36c4g0JD0LKUdQ=;
        b=OlAgkgIY0bDnMzEpkHwZMv6ut9YePJ9fB0Ykdt78NRtggNziCBQTsqYWOq5HoQQDNB
         OEMJDkTP2XxHjQMSE+hrOt/7Ot/vBYZX2H3LTVfpc2rMqCbMvTNGzrqKak+gUXVvvzWH
         07kHZXHPMhccZnuk1dgTZf+tTaKuw+BFroJ3apWaWbD30KFUCRwHDyRtMGhOMXnWbwQq
         Ij7NSHLyp7nmw2lHynMznBtcVnvHyN2qF8N4cX9tc2kE0mhlgvZ7q5vPo0QH3RK6cQYI
         /GDZ2Bwj7IbxL10Pl3vcCE+oNuh8ApGtspMRcZh8w17J4t3O+2EEO8kwB3nvBOUV/QBN
         Kvag==
X-Gm-Message-State: APjAAAVbUbopgOIRAqueH9yApfpbfT4pFZW4aepYGpis8sCvoEfx0TyK
        ArYUiPPxHhjzXMj+nd5hZhClGnXaHOgNKu4aAt7Udg==
X-Google-Smtp-Source: APXvYqxkKbPEIWyIE11O/eFe/uZfpTjQS8MTcmCNROdykD4QjszsKgHaTbUlwhezWkREESo+GM2t81PKbYRhc/Ha2R4=
X-Received: by 2002:a05:6808:a83:: with SMTP id q3mr6051900oij.0.1576172253406;
 Thu, 12 Dec 2019 09:37:33 -0800 (PST)
MIME-Version: 1.0
References: <20191211213207.215936-1-brho@google.com> <20191211213207.215936-3-brho@google.com>
 <20191212173413.GC3163@linux.intel.com>
In-Reply-To: <20191212173413.GC3163@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 12 Dec 2019 09:37:22 -0800
Message-ID: <CAPcyv4hkz8XCETELBaUOjHQf3=VyVB=KWeRVEPYejvdsg3_MWA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Barret Rhoden <brho@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zeng, Jason" <jason.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 9:34 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Dec 11, 2019 at 04:32:07PM -0500, Barret Rhoden wrote:
> > This change allows KVM to map DAX-backed files made of huge pages with
> > huge mappings in the EPT/TDP.
> >
> > DAX pages are not PageTransCompound.  The existing check is trying to
> > determine if the mapping for the pfn is a huge mapping or not.  For
> > non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
> > For DAX, we can check the page table itself.
> >
> > Note that KVM already faulted in the page (or huge page) in the host's
> > page table, and we hold the KVM mmu spinlock.  We grabbed that lock in
> > kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
> >
> > Signed-off-by: Barret Rhoden <brho@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 36 ++++++++++++++++++++++++++++++++----
> >  1 file changed, 32 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6f92b40d798c..cd07bc4e595f 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3384,6 +3384,35 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> >       return -EFAULT;
> >  }
> >
> > +static bool pfn_is_huge_mapped(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
> > +{
> > +     struct page *page = pfn_to_page(pfn);
> > +     unsigned long hva;
> > +
> > +     if (!is_zone_device_page(page))
> > +             return PageTransCompoundMap(page);
> > +
> > +     /*
> > +      * DAX pages do not use compound pages.  The page should have already
> > +      * been mapped into the host-side page table during try_async_pf(), so
> > +      * we can check the page tables directly.
> > +      */
> > +     hva = gfn_to_hva(kvm, gfn);
> > +     if (kvm_is_error_hva(hva))
> > +             return false;
> > +
> > +     /*
> > +      * Our caller grabbed the KVM mmu_lock with a successful
> > +      * mmu_notifier_retry, so we're safe to walk the page table.
> > +      */
> > +     switch (dev_pagemap_mapping_shift(hva, current->mm)) {
> > +     case PMD_SHIFT:
> > +     case PUD_SIZE:
>
> I assume this means DAX can have 1GB pages?

Correct, it can. Not in the filesystem-dax case, but device-dax
supports 1GB pages.

> I ask because KVM's THP logic
> has historically relied on THP only supporting 2MB.  I cleaned this up in
> a recent series[*], which is in kvm/queue, but I obviously didn't actually
> test whether or not KVM would correctly handle 1GB non-hugetlbfs pages.

Yeah, since device-dax is the only path to support longterm page
pinning for vfio device assignment, testing with device-dax + 1GB
pages would be a useful sanity check.
