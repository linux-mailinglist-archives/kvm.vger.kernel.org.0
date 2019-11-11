Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CEDF7AC4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 19:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfKKS1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 13:27:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:18333 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfKKS1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 13:27:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 10:27:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,293,1569308400"; 
   d="scan'208";a="403968409"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 11 Nov 2019 10:27:51 -0800
Date:   Mon, 11 Nov 2019 10:27:51 -0800
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
Message-ID: <20191111182750.GE11805@linux.intel.com>
References: <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
 <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
 <20191106233913.GC21617@linux.intel.com>
 <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
 <CAPcyv4i3M18V9Gmx3x7Ad12VjXbq94NsaUG9o71j59mG9-6H9Q@mail.gmail.com>
 <0db7c328-1543-55db-bc02-c589deb3db22@redhat.com>
 <CAPcyv4gMu547patcROaqBqbwxut5au-WyE_M=XsKxyCLbLXHTg@mail.gmail.com>
 <20191107155846.GA7760@linux.intel.com>
 <20191109014323.GB8254@linux.intel.com>
 <CAPcyv4hAY_OfExNP+_067Syh9kZAapppNwKZemVROfxgbDLLYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hAY_OfExNP+_067Syh9kZAapppNwKZemVROfxgbDLLYQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 08, 2019 at 06:00:46PM -0800, Dan Williams wrote:
> On Fri, Nov 8, 2019 at 5:43 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > On Thu, Nov 07, 2019 at 07:58:46AM -0800, Sean Christopherson wrote:
> > > Insertion into KVM's secondary MMU is mutually exclusive with an invalidate
> > > from the mmu_notifier.  KVM holds a reference to the to-be-inserted page
> > > until the page has been inserted, which ensures that the page is pinned and
> > > thus won't be invalidated until after the page is inserted.  This prevents
> > > an invalidate from racing with insertion.  Dropping the reference
> > > immediately after gup() would allow the invalidate to run prior to the page
> > > being inserted, and so KVM would map the stale PFN into the guest's page
> > > tables after it was invalidated in the host.
> >
> > My previous analysis is wrong, although I did sort of come to the right
> > conclusion.
> >
> > The part that's wrong is that KVM does not rely on pinning a page/pfn when
> > installing the pfn into its secondary MMU (guest page tables).  Instead,
> > KVM keeps track of mmu_notifier invalidate requests and cancels insertion
> > if an invalidate occured at any point between the start of hva_to_pfn(),
> > i.e. the get_user_pages() call, and acquiring KVM's mmu lock (which must
> > also be grabbed by mmu_notifier invalidate).  So for any pfn, regardless
> > of whether it's backed by a struct page, KVM inserts a pfn if and only if
> > it is guaranteed to get an mmu_notifier invalidate for the pfn (and isn't
> > already invalidated).
> >
> > In the page fault flow, KVM doesn't care whether or not the pfn remains
> > valid in the associated vma.  In other words, Dan's idea of immediately
> > doing put_page() on ZONE_DEVICE pages would work for *page faults*...
> >
> > ...but not for all the other flows where KVM uses gfn_to_pfn(), and thus
> > get_user_pages().  When accessing entire pages of guest memory, e.g. for
> > nested virtualization, KVM gets the page associated with a gfn, maps it
> > with kmap() to get a kernel address and keeps the mapping/page until it's
> > done reading/writing the page.  Immediately putting ZONE_DEVICE pages
> > would result in use-after-free scenarios for these flows.
> 
> Thanks for this clarification. I do want to put out though that
> ZONE_DEVICE pages go idle, they don't get freed. As long as KVM drops
> its usage on invalidate it's perfectly fine for KVM to operate on idle
> ZONE_DEVICE pages. The common case is that ZONE_DEVICE pages are
> accessed and mapped while idle. Only direct-I/O temporarily marks them
> busy to synchronize with invalidate. KVM obviates that need by
> coordinating with mmu-notifiers instead.

Only the KVM MMU, e.g. page fault handler, coordinates via mmu_notifier,
the kvm_vcpu_map() case would continue using pages across an invalidate.

Or did I misunderstand?
