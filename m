Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336F9F5CCD
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 02:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfKIBnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 20:43:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:12966 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbfKIBnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 20:43:24 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 17:43:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="354259794"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 08 Nov 2019 17:43:23 -0800
Date:   Fri, 8 Nov 2019 17:43:23 -0800
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
Message-ID: <20191109014323.GB8254@linux.intel.com>
References: <20191106170727.14457-2-sean.j.christopherson@intel.com>
 <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
 <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
 <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
 <20191106233913.GC21617@linux.intel.com>
 <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
 <CAPcyv4i3M18V9Gmx3x7Ad12VjXbq94NsaUG9o71j59mG9-6H9Q@mail.gmail.com>
 <0db7c328-1543-55db-bc02-c589deb3db22@redhat.com>
 <CAPcyv4gMu547patcROaqBqbwxut5au-WyE_M=XsKxyCLbLXHTg@mail.gmail.com>
 <20191107155846.GA7760@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107155846.GA7760@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 07, 2019 at 07:58:46AM -0800, Sean Christopherson wrote:
> On Thu, Nov 07, 2019 at 07:36:45AM -0800, Dan Williams wrote:
> > On Thu, Nov 7, 2019 at 3:12 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 07/11/19 06:48, Dan Williams wrote:
> > > >> How do mmu notifiers get held off by page references and does that
> > > >> machinery work with ZONE_DEVICE? Why is this not a concern for the
> > > >> VM_IO and VM_PFNMAP case?
> > > > Put another way, I see no protection against truncate/invalidate
> > > > afforded by a page pin. If you need guarantees that the page remains
> > > > valid in the VMA until KVM can install a mmu notifier that needs to
> > > > happen under the mmap_sem as far as I can see. Otherwise gup just
> > > > weakly asserts "this pinned page was valid in this vma at one point in
> > > > time".
> > >
> > > The MMU notifier is installed before gup, so any invalidation will be
> > > preceded by a call to the MMU notifier.  In turn,
> > > invalidate_range_start/end is called with mmap_sem held so there should
> > > be no race.
> > >
> > > However, as Sean mentioned, early put_page of ZONE_DEVICE pages would be
> > > racy, because we need to keep the reference between the gup and the last
> > > time we use the corresponding struct page.
> > 
> > If KVM is establishing the mmu_notifier before gup then there is
> > nothing left to do with that ZONE_DEVICE page, so I'm struggling to
> > see what further qualification of kvm_is_reserved_pfn() buys the
> > implementation.
> 
> Insertion into KVM's secondary MMU is mutually exclusive with an invalidate
> from the mmu_notifier.  KVM holds a reference to the to-be-inserted page
> until the page has been inserted, which ensures that the page is pinned and
> thus won't be invalidated until after the page is inserted.  This prevents
> an invalidate from racing with insertion.  Dropping the reference
> immediately after gup() would allow the invalidate to run prior to the page
> being inserted, and so KVM would map the stale PFN into the guest's page
> tables after it was invalidated in the host.

My previous analysis is wrong, although I did sort of come to the right
conclusion.

The part that's wrong is that KVM does not rely on pinning a page/pfn when
installing the pfn into its secondary MMU (guest page tables).  Instead,
KVM keeps track of mmu_notifier invalidate requests and cancels insertion
if an invalidate occured at any point between the start of hva_to_pfn(),
i.e. the get_user_pages() call, and acquiring KVM's mmu lock (which must
also be grabbed by mmu_notifier invalidate).  So for any pfn, regardless
of whether it's backed by a struct page, KVM inserts a pfn if and only if
it is guaranteed to get an mmu_notifier invalidate for the pfn (and isn't
already invalidated).

In the page fault flow, KVM doesn't care whether or not the pfn remains
valid in the associated vma.  In other words, Dan's idea of immediately
doing put_page() on ZONE_DEVICE pages would work for *page faults*...

...but not for all the other flows where KVM uses gfn_to_pfn(), and thus
get_user_pages().  When accessing entire pages of guest memory, e.g. for
nested virtualization, KVM gets the page associated with a gfn, maps it
with kmap() to get a kernel address and keeps the mapping/page until it's
done reading/writing the page.  Immediately putting ZONE_DEVICE pages
would result in use-after-free scenarios for these flows.

For non-page pfns, KVM explicitly memremap()'s the pfn and again keeps the
mapping until it's done accessing guest memory.

The above is nicely encapsulated in kvm_vcpu_map(), added by KarimAllah in
commit e45adf665a53 ("KVM: Introduce a new guest mapping API").

For the hva_to_pfn_remapped() -> kvm_get_pfn() case, I think the page
fault flow is in good shape by way of the mmu_notifier sequencing.  The
kvm_get_pfn() call might temporarily keep a page alive, but it shouldn't
break anything (I think).  Not sure about kvm_vcpu_map()...
