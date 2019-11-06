Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C929F1FD8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 21:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbfKFU02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 15:26:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:55890 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727721AbfKFU02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 15:26:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 12:26:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="353587051"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 06 Nov 2019 12:26:27 -0800
Date:   Wed, 6 Nov 2019 12:26:27 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being
 reserved
Message-ID: <20191106202627.GF16249@linux.intel.com>
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-2-sean.j.christopherson@intel.com>
 <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 10:04:22AM -0800, Dan Williams wrote:
> On Wed, Nov 6, 2019 at 9:07 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Explicitly exempt ZONE_DEVICE pages from kvm_is_reserved_pfn() and
> > instead manually handle ZONE_DEVICE on a case-by-case basis.  For things
> > like page refcounts, KVM needs to treat ZONE_DEVICE pages like normal
> > pages, e.g. put pages grabbed via gup().  But KVM needs special handling
> > in other flows where ZONE_DEVICE pages lack the underlying machinery,
> > e.g. when setting accessed/dirty bits and shifting refcounts for
> > transparent huge pages.
> >
> > This fixes a hang reported by Adam Borowski[*] in dev_pagemap_cleanup()
> > when running a KVM guest backed with /dev/dax memory, as KVM straight up
> > doesn't put any references to ZONE_DEVICE pages acquired by gup().
> >
> > [*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl
> >
> > Reported-by: Adam Borowski <kilobyte@angband.pl>
> > Debugged-by: David Hildenbrand <david@redhat.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/mmu.c       |  8 ++++----
> >  include/linux/kvm_host.h |  1 +
> >  virt/kvm/kvm_main.c      | 19 +++++++++++++++----
> >  3 files changed, 20 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 24c23c66b226..bf82b1f2e834 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -3306,7 +3306,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> >          * here.
> >          */
> >         if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> > -           level == PT_PAGE_TABLE_LEVEL &&
> > +           !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
> >             PageTransCompoundMap(pfn_to_page(pfn)) &&
> >             !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
> >                 unsigned long mask;
> > @@ -5914,9 +5914,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >                  * the guest, and the guest page table is using 4K page size
> >                  * mapping if the indirect sp has level = 1.
> >                  */
> > -               if (sp->role.direct &&
> > -                       !kvm_is_reserved_pfn(pfn) &&
> > -                       PageTransCompoundMap(pfn_to_page(pfn))) {
> > +               if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
> > +                   !kvm_is_zone_device_pfn(pfn) &&
> > +                   PageTransCompoundMap(pfn_to_page(pfn))) {
> >                         pte_list_remove(rmap_head, sptep);
> >
> >                         if (kvm_available_flush_tlb_with_range())
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index a817e446c9aa..4ad1cd7d2d4d 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -966,6 +966,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
> >  void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
> >
> >  bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
> > +bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
> >
> >  struct kvm_irq_ack_notifier {
> >         struct hlist_node link;
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index b8534c6b8cf6..0a781b1fb8f0 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -151,12 +151,23 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> >
> >  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
> >  {
> > +       /*
> > +        * ZONE_DEVICE pages currently set PG_reserved, but from a refcounting
> > +        * perspective they are "normal" pages, albeit with slightly different
> > +        * usage rules.
> > +        */
> >         if (pfn_valid(pfn))
> > -               return PageReserved(pfn_to_page(pfn));
> > +               return PageReserved(pfn_to_page(pfn)) &&
> > +                      !is_zone_device_page(pfn_to_page(pfn));
> 
> This is racy unless you can be certain that the pfn and resulting page
> has already been pinned by get_user_pages(). This is why I told David
> to steer clear of adding more is_zone_device_page() usage, it's
> difficult to audit. Without an existing pin the metadata to determine
> whether a page is ZONE_DEVICE or not could be in the process of being
> torn down.

Ouch, that's brutal.  Makes perfect sense why you'd want to avoid
is_zone_device_page().

> Ideally KVM would pass around a struct { struct page *page,
> unsigned long pfn } tuple so it would not have to do this "recall
> context" dance on every pfn operation.

Implementing something of that nature is doable, but it's going to be a
significant overhaul as it will require updating every architecture.  So
yeah, let's go with David's suggestion of fixing the immediate bug with
your quick and dirty change and punting a more complete rework to future
cleanup.  There are still multiple KVM flows that don't correctly handle
ZONE_DEVICE, especially outside of x86, but I don't think there's a quick
fix for those issues.
