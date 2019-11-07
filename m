Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC90F33FA
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 16:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbfKGP6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 10:58:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:40076 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbfKGP6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 10:58:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 07:58:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,278,1569308400"; 
   d="scan'208";a="286027072"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 07 Nov 2019 07:58:46 -0800
Date:   Thu, 7 Nov 2019 07:58:46 -0800
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
Message-ID: <20191107155846.GA7760@linux.intel.com>
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-2-sean.j.christopherson@intel.com>
 <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
 <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
 <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
 <20191106233913.GC21617@linux.intel.com>
 <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
 <CAPcyv4i3M18V9Gmx3x7Ad12VjXbq94NsaUG9o71j59mG9-6H9Q@mail.gmail.com>
 <0db7c328-1543-55db-bc02-c589deb3db22@redhat.com>
 <CAPcyv4gMu547patcROaqBqbwxut5au-WyE_M=XsKxyCLbLXHTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gMu547patcROaqBqbwxut5au-WyE_M=XsKxyCLbLXHTg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 07, 2019 at 07:36:45AM -0800, Dan Williams wrote:
> On Thu, Nov 7, 2019 at 3:12 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 07/11/19 06:48, Dan Williams wrote:
> > >> How do mmu notifiers get held off by page references and does that
> > >> machinery work with ZONE_DEVICE? Why is this not a concern for the
> > >> VM_IO and VM_PFNMAP case?
> > > Put another way, I see no protection against truncate/invalidate
> > > afforded by a page pin. If you need guarantees that the page remains
> > > valid in the VMA until KVM can install a mmu notifier that needs to
> > > happen under the mmap_sem as far as I can see. Otherwise gup just
> > > weakly asserts "this pinned page was valid in this vma at one point in
> > > time".
> >
> > The MMU notifier is installed before gup, so any invalidation will be
> > preceded by a call to the MMU notifier.  In turn,
> > invalidate_range_start/end is called with mmap_sem held so there should
> > be no race.
> >
> > However, as Sean mentioned, early put_page of ZONE_DEVICE pages would be
> > racy, because we need to keep the reference between the gup and the last
> > time we use the corresponding struct page.
> 
> If KVM is establishing the mmu_notifier before gup then there is
> nothing left to do with that ZONE_DEVICE page, so I'm struggling to
> see what further qualification of kvm_is_reserved_pfn() buys the
> implementation.

Insertion into KVM's secondary MMU is mutually exclusive with an invalidate
from the mmu_notifier.  KVM holds a reference to the to-be-inserted page
until the page has been inserted, which ensures that the page is pinned and
thus won't be invalidated until after the page is inserted.  This prevents
an invalidate from racing with insertion.  Dropping the reference
immediately after gup() would allow the invalidate to run prior to the page
being inserted, and so KVM would map the stale PFN into the guest's page
tables after it was invalidated in the host.

The other benefit of treating ZONE_DEVICE pages as not-reserved is that it
allows KVM to do proper sanity checks, e.g. when removing pages from its
secondary MMU, KVM asserts that page_count() for present pages is non-zero
to help detect bugs where KVM didn't properly zap the page from its MMU.
Enabling the assertion for ZONE_DEVICE pages would be very nice to have as
it's the most explicit indicator that we done messed up, e.g. without the
associated WARN, errors manifest as random corruption or weird behavior in
the guest.

> However, if you're attracted to the explicitness of Sean's approach
> can I at least ask for comments asserting that KVM knows it already
> holds a reference on that page so the is_zone_device_page() usage is
> safe?

Ya, I'll update the patch to add comments and a WARN.

> David and I are otherwise trying to reduce is_zone_device_page() to
> easy to audit "obviously safe" cases and converting the others with
> additional synchronization.
