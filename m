Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97705F2278
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 00:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732632AbfKFXUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 18:20:24 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41292 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbfKFXUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 18:20:23 -0500
Received: by mail-oi1-f194.google.com with SMTP id e9so263412oif.8
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 15:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nB9aWq+Y/LCuEgsvayS807omBQanlFOOtFCdR/UCom0=;
        b=ti/x39hUAOa/flTP+ItdW5Cgpw3yOlbkXOIBPu7hUAOD8eIQE8iqCpg+Qo5mbIYyQ0
         rDM/8o8Nj3MMwEvZJHuL+ImWQVjM7kmJV+J8ysJd/Pr3sVLvRMJ5m8Myy1s/VOtPil69
         5VqJyg1VCC0JTWp+/VUUam85eNbeNTQ0KibURYFkHx2+JihjUuQRu7NmW2ufLWNOXB1h
         o2coM9phOW0hrxwqvj1i0aYOSvaczotjWQpI4FeB7K757krqfUXLK4zj6QXY1jD8u4mc
         q8O5Seav7VH9bZaKnEsImh5Wa6FYDyCFU22tTZNHODdN1wnz14Jn11bntGpI+Kiu4BLP
         NbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nB9aWq+Y/LCuEgsvayS807omBQanlFOOtFCdR/UCom0=;
        b=qbFISWpE1FyZ9PJRY7CeFqh4Qrv6a4qEPP1acxQ29ixOfNIbxsELewdU08VDjx5Ojs
         HcVVIdQfcD2IA5xq+OWjCiuvqSNAcEYgzHoiJjkvRAWZvGRFh3NINNAlxJe7FJrtbv2L
         i21uma+oPjnsSx2S+47WbMtTTLMova+MwhQklee82xLW3jpPu/U+KuEJcYIHXoRJWFn7
         JFmLjosH9w9ya3jWjlFO4FfiDJxcOPi9yd9o2xoJdtSXFlkAfETnHfPVqbjnHO1kmUdw
         iMaSlCqUfwSsw5Sa1NVGtYuhFSj0wJb4B+3PXT3+QRrTI0kpss+iYCLg6d3gnXYRWTfj
         RN+g==
X-Gm-Message-State: APjAAAXvhi8i8Jd4ceBBjIDAC+Xkv2j+MDoRQepToXrldq1vtHAI3erc
        NGtHQqWTQdb6hy4iRgevIebp6WQ1NHvJjRWjenVTgw==
X-Google-Smtp-Source: APXvYqwJq+UE9XqNqMgjEwBspF4w4dYGlUGrRq/h+xwpLVNRM3/gq6FOVPXrJrjRALFSJMuRsW5fprLdEemp6WUx2Y8=
X-Received: by 2002:aca:ad52:: with SMTP id w79mr476508oie.149.1573082422013;
 Wed, 06 Nov 2019 15:20:22 -0800 (PST)
MIME-Version: 1.0
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-2-sean.j.christopherson@intel.com> <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
 <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
In-Reply-To: <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 6 Nov 2019 15:20:11 -0800
Message-ID: <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 6, 2019 at 1:10 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/11/19 19:04, Dan Williams wrote:
> > On Wed, Nov 6, 2019 at 9:07 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >>
> >> Explicitly exempt ZONE_DEVICE pages from kvm_is_reserved_pfn() and
> >> instead manually handle ZONE_DEVICE on a case-by-case basis.  For things
> >> like page refcounts, KVM needs to treat ZONE_DEVICE pages like normal
> >> pages, e.g. put pages grabbed via gup().  But KVM needs special handling
> >> in other flows where ZONE_DEVICE pages lack the underlying machinery,
> >> e.g. when setting accessed/dirty bits and shifting refcounts for
> >> transparent huge pages.
> >>
> >> This fixes a hang reported by Adam Borowski[*] in dev_pagemap_cleanup()
> >> when running a KVM guest backed with /dev/dax memory, as KVM straight up
> >> doesn't put any references to ZONE_DEVICE pages acquired by gup().
> >>
> >> [*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl
> >>
> >> Reported-by: Adam Borowski <kilobyte@angband.pl>
> >> Debugged-by: David Hildenbrand <david@redhat.com>
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >> ---
> >>  arch/x86/kvm/mmu.c       |  8 ++++----
> >>  include/linux/kvm_host.h |  1 +
> >>  virt/kvm/kvm_main.c      | 19 +++++++++++++++----
> >>  3 files changed, 20 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >> index 24c23c66b226..bf82b1f2e834 100644
> >> --- a/arch/x86/kvm/mmu.c
> >> +++ b/arch/x86/kvm/mmu.c
> >> @@ -3306,7 +3306,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> >>          * here.
> >>          */
> >>         if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> >> -           level == PT_PAGE_TABLE_LEVEL &&
> >> +           !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
> >>             PageTransCompoundMap(pfn_to_page(pfn)) &&
> >>             !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
> >>                 unsigned long mask;
> >> @@ -5914,9 +5914,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >>                  * the guest, and the guest page table is using 4K page size
> >>                  * mapping if the indirect sp has level = 1.
> >>                  */
> >> -               if (sp->role.direct &&
> >> -                       !kvm_is_reserved_pfn(pfn) &&
> >> -                       PageTransCompoundMap(pfn_to_page(pfn))) {
> >> +               if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
> >> +                   !kvm_is_zone_device_pfn(pfn) &&
> >> +                   PageTransCompoundMap(pfn_to_page(pfn))) {
> >>                         pte_list_remove(rmap_head, sptep);
> >>
> >>                         if (kvm_available_flush_tlb_with_range())
> >> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >> index a817e446c9aa..4ad1cd7d2d4d 100644
> >> --- a/include/linux/kvm_host.h
> >> +++ b/include/linux/kvm_host.h
> >> @@ -966,6 +966,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
> >>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
> >>
> >>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
> >> +bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
> >>
> >>  struct kvm_irq_ack_notifier {
> >>         struct hlist_node link;
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index b8534c6b8cf6..0a781b1fb8f0 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -151,12 +151,23 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> >>
> >>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
> >>  {
> >> +       /*
> >> +        * ZONE_DEVICE pages currently set PG_reserved, but from a refcounting
> >> +        * perspective they are "normal" pages, albeit with slightly different
> >> +        * usage rules.
> >> +        */
> >>         if (pfn_valid(pfn))
> >> -               return PageReserved(pfn_to_page(pfn));
> >> +               return PageReserved(pfn_to_page(pfn)) &&
> >> +                      !is_zone_device_page(pfn_to_page(pfn));
> >
> > This is racy unless you can be certain that the pfn and resulting page
> > has already been pinned by get_user_pages().
>
> What is the race exactly?

The race is that nothing protects the page from being destroyed while
is_zone_device_page() is running. All other pages obtained from the
page allocator have an existing reference from the core-mm otherwise
KVM would be touch free memory. In the case of ZONE_DEVICE the page
that KVM is looking up is only alive while the underlying device is
pinned. GUP will take the device reference and check that the device
is not already dying where a pfn_valid() +  get_page() sequence will
not.

>
> In general KVM does not use pfn's until after having gotten them from
> get_user_pages (or follow_pfn for VM_IO | VM_PFNMAP vmas, for which
> get_user_pages fails, but this is not an issue here).  It then creates
> the page tables and releases the reference to the struct page.

In this case I think it would be better to treat ZONE_DEVICE like the
VM_IO and VM_PFNMAP case, and never take a reference in the first
instance. This keeps the existing correct usages of
kvm_is_reserved_pfn() in tact, and avoids the broken case of a missing
put_page().

> Anything else happens _after_ the reference has been released, but still
> from an mmu notifier; this is why KVM uses pfn_to_page quite pervasively.
>
> If this is enough to avoid races, then I prefer Sean's patch.  If it is
> racy, we need to fix kvm_set_pfn_accessed and kvm_set_pfn_dirty first,
> and second at transparent_hugepage_adjust and kvm_mmu_zap_collapsible_spte:

Those are already ok due to kvm_is_reserved_pfn() == true being the
right answer for ZONE_DEVICE.

> - if accessed/dirty state need not be tracked properly for ZONE_DEVICE,
> then I suppose David's patch is okay (though I'd like to have a big
> comment explaining all the things that went on in these emails).  If
> they need to work, however, Sean's patch 1 is the right thing to do.

They can't work, there's no core-mm managing ZONE_DEVICE pages, so
PageDirty() and THP housekeeping have no meaning.

> - if we need Sean's patch 1, but it is racy to use is_zone_device_page,
> we could first introduce a helper similar to kvm_is_hugepage_allowed()
> from his patch 2, but using pfn_to_online_page() to filter out
> ZONE_DEVICE pages.  This would cover both transparent_hugepage_adjust
> and kvm_mmu_zap_collapsible_spte.

After some more thought I'd feel more comfortable just collapsing the
ZONE_DEVICE case into the VM_IO/VM_PFNMAP case. I.e. with something
like this (untested) that just drops the reference immediately and let
kvm_is_reserved_pfn() do the right thing going forward.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6f0696d98ef..d21689e2b4eb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1464,6 +1464,14 @@ static bool hva_to_pfn_fast(unsigned long addr,
bool write_fault,
        npages = __get_user_pages_fast(addr, 1, 1, page);
        if (npages == 1) {
                *pfn = page_to_pfn(page[0]);
+               /*
+                * ZONE_DEVICE pages are effectively VM_IO/VM_PFNMAP as
+                * far as KVM is concerned kvm_is_reserved_pfn() will
+                * prevent further unnecessary page management on this
+                * page.
+                */
+               if (is_zone_device_page(page[0]))
+                       put_page(page[0]);

                if (writable)
                        *writable = true;
@@ -1509,6 +1517,11 @@ static int hva_to_pfn_slow(unsigned long addr,
bool *async, bool write_fault,
                }
        }
        *pfn = page_to_pfn(page);
+
+       /* See comment in hva_to_pfn_fast. */
+       if (is_zone_device_page(page[0]))
+               put_page(page[0]);
+
        return npages;
 }
