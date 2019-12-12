Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2606411D2DA
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 17:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbfLLQzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 11:55:11 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46402 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbfLLQzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 11:55:11 -0500
Received: by mail-ot1-f67.google.com with SMTP id g18so2617637otj.13
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IjDUBfxBJhXNaC2BIeIEC43hkHaDAGwaiQqn3TQYiIk=;
        b=rgtrRVuq6mdTTp7elEykgE89Ca9kZfn8QGs2v++8uceH3hFUstkL2ayypXJmkZfxk1
         iEGWW63b5xe8cb11bY30cimjn6zlRLLAZ0SBZbITIqWmtK9ObULY/ZUjOhVQpHgy43tK
         vac8DIrdJ543HRUPfBajdEIZV1GmYiBat32AFIvi3TBXKX1su2WzlK2cncw5h6144hey
         kOBYwgTRo2VfskCO21DnFQr6uUTKWUqlPo51785MVMk82ugVbKBZDUbGNO7frgqCR7rY
         ZjPZecmpJa3QOFc0keUDCp2aSgzufXIt1iNv04Rl7hV1xbkD7RXbi3OjPTdOoMLxaXhC
         B4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IjDUBfxBJhXNaC2BIeIEC43hkHaDAGwaiQqn3TQYiIk=;
        b=TsxItINgDtbn+gdBMx2FUAHiFJGD9gGm48r+nCQZZN5I53DtUK1N6bvs4yqFwOJRMq
         UawSd8kmqdG/80DQsqIPNzbq71fzXnHM3Io20ZjjNKWZImGutMIHvVIXX6dQKFVSZe4a
         TbPNWubJxSTf/bmXzHEKb55xV4nlSVCVybsdjM5a27dNhn2YrPlKoS8JVIpKRawm9cHM
         kMZ6jFKKm47gSggAsNDiuw4+JTL8U9X9H7dnBhYASeu6QyqFah9CLBsJVYgQY0wd9EHQ
         FAkuoMLxlhbS1yPFqLJLV0bPSq44CQmHU3at3pkls7m26VI8/Kh01vR/NsLZJ5WDNILF
         EALQ==
X-Gm-Message-State: APjAAAVaRlKS9CHqNuc5gzfcw8up+RnoAjGj0//58MNBUn9wbRiYKtZC
        MqWlbgaKE19DrQSjJqkeJORgOMUBjYD31deD9JcWww==
X-Google-Smtp-Source: APXvYqyr1ygzuNz/tNcPyx+AVQmEEPaxXCSetasrTiHp3InGql8xutKQ6hNSEWwo2qQnFd4JZbh62sd3hFut1H3bUl0=
X-Received: by 2002:a9d:4e99:: with SMTP id v25mr9361501otk.363.1576169710137;
 Thu, 12 Dec 2019 08:55:10 -0800 (PST)
MIME-Version: 1.0
References: <20191211213207.215936-1-brho@google.com> <20191211213207.215936-3-brho@google.com>
 <376DB19A-4EF1-42BF-A73C-741558E397D4@oracle.com>
In-Reply-To: <376DB19A-4EF1-42BF-A73C-741558E397D4@oracle.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 12 Dec 2019 08:54:59 -0800
Message-ID: <CAPcyv4gpYF=D323G+69FhFZw4i5W-15_wTRa1xNPdmear0phTw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
To:     Liran Alon <liran.alon@oracle.com>
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
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 4:34 AM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 11 Dec 2019, at 23:32, Barret Rhoden <brho@google.com> wrote:
> >
> > This change allows KVM to map DAX-backed files made of huge pages with
> > huge mappings in the EPT/TDP.
> >
> > DAX pages are not PageTransCompound.  The existing check is trying to
> > determine if the mapping for the pfn is a huge mapping or not.  For
> > non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
> > For DAX, we can check the page table itself.
>
> For hugetlbfs pages, tdp_page_fault() -> mapping_level() -> host_mapping_=
level() -> kvm_host_page_size() -> vma_kernel_pagesize()
> will return the page-size of the hugetlbfs without the need to parse the =
page-tables.
> See vma->vm_ops->pagesize() callback implementation at hugetlb_vm_ops->pa=
gesize()=3D=3Dhugetlb_vm_op_pagesize().
>
> Only for pages that were originally mapped as small-pages and later merge=
d to larger pages by THP, there is a need to check for PageTransCompound().=
 Again, instead of parsing page-tables.
>
> Therefore, it seems more logical to me that:
> (a) If DAX-backed files are mapped as large-pages to userspace, it should=
 be reflected in vma->vm_ops->page_size() of that mapping. Causing kvm_host=
_page_size() to return the right size without the need to parse the page-ta=
bles.

A given dax-mapped vma may have mixed page sizes so ->page_size()
can't be used reliably to enumerating the mapping size.

> (b) If DAX-backed files small-pages can be later merged to large-pages by=
 THP, then the =E2=80=9Cstruct page=E2=80=9D of these pages should be modif=
ied as usual to make PageTransCompound() return true for them. I=E2=80=99m =
not highly familiar with this mechanism, but I would expect THP to be able =
to merge DAX-backed files small-pages to large-pages in case DAX provides =
=E2=80=9Cstruct page=E2=80=9D for the DAX pages.

DAX pages do not participate in THP and do not have the
PageTransCompound accounting. The only mechanism that records the
mapping size for dax is the page tables themselves.


>
> >
> > Note that KVM already faulted in the page (or huge page) in the host's
> > page table, and we hold the KVM mmu spinlock.  We grabbed that lock in
> > kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
> >
> > Signed-off-by: Barret Rhoden <brho@google.com>
> > ---
> > arch/x86/kvm/mmu/mmu.c | 36 ++++++++++++++++++++++++++++++++----
> > 1 file changed, 32 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6f92b40d798c..cd07bc4e595f 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3384,6 +3384,35 @@ static int kvm_handle_bad_page(struct kvm_vcpu *=
vcpu, gfn_t gfn, kvm_pfn_t pfn)
> >       return -EFAULT;
> > }
> >
> > +static bool pfn_is_huge_mapped(struct kvm *kvm, gfn_t gfn, kvm_pfn_t p=
fn)
> > +{
> > +     struct page *page =3D pfn_to_page(pfn);
> > +     unsigned long hva;
> > +
> > +     if (!is_zone_device_page(page))
> > +             return PageTransCompoundMap(page);
> > +
> > +     /*
> > +      * DAX pages do not use compound pages.  The page should have alr=
eady
> > +      * been mapped into the host-side page table during try_async_pf(=
), so
> > +      * we can check the page tables directly.
> > +      */
> > +     hva =3D gfn_to_hva(kvm, gfn);
> > +     if (kvm_is_error_hva(hva))
> > +             return false;
> > +
> > +     /*
> > +      * Our caller grabbed the KVM mmu_lock with a successful
> > +      * mmu_notifier_retry, so we're safe to walk the page table.
> > +      */
> > +     switch (dev_pagemap_mapping_shift(hva, current->mm)) {
>
> Doesn=E2=80=99t dev_pagemap_mapping_shift() get =E2=80=9Cstruct page=E2=
=80=9D as first parameter?
> Was this changed by a commit I missed?
>
> -Liran
>
> > +     case PMD_SHIFT:
> > +     case PUD_SIZE:
> > +             return true;
> > +     }
> > +     return false;
> > +}
> > +
> > static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> >                                       gfn_t gfn, kvm_pfn_t *pfnp,
> >                                       int *levelp)
> > @@ -3398,8 +3427,8 @@ static void transparent_hugepage_adjust(struct kv=
m_vcpu *vcpu,
> >        * here.
> >        */
> >       if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> > -         !kvm_is_zone_device_pfn(pfn) && level =3D=3D PT_PAGE_TABLE_LE=
VEL &&
> > -         PageTransCompoundMap(pfn_to_page(pfn)) &&
> > +         level =3D=3D PT_PAGE_TABLE_LEVEL &&
> > +         pfn_is_huge_mapped(vcpu->kvm, gfn, pfn) &&
> >           !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) =
{
> >               unsigned long mask;
> >               /*
> > @@ -6015,8 +6044,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct k=
vm *kvm,
> >                * mapping if the indirect sp has level =3D 1.
> >                */
> >               if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
> > -                 !kvm_is_zone_device_pfn(pfn) &&
> > -                 PageTransCompoundMap(pfn_to_page(pfn))) {
> > +                 pfn_is_huge_mapped(kvm, sp->gfn, pfn)) {
> >                       pte_list_remove(rmap_head, sptep);
> >
> >                       if (kvm_available_flush_tlb_with_range())
> > --
> > 2.24.0.525.g8f36a354ae-goog
> >
>
