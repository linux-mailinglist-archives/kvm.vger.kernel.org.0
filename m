Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693B623AB71
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 19:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgHCRQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 13:16:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:35486 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgHCRQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 13:16:21 -0400
IronPort-SDR: F5c2XloV9mmQyA3S7wkiHgqPmw4GAlsZjW4R2+rHOemShMpbsyKg4LZr3Lza68EWjATAxJrv36
 8Kd9KR5hApmQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="151380040"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="151380040"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 10:16:20 -0700
IronPort-SDR: T0DvdcXbtswj8yXJnYcPRihU+tQTTHY9wlLZmToGC+zKZzYyLKl1U6XNReliHIbcL9QeyD3aSr
 VGQL9sx90v3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="492469357"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005.fm.intel.com with ESMTP; 03 Aug 2020 10:16:20 -0700
Date:   Mon, 3 Aug 2020 10:16:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH 0/8] KVM: x86/mmu: Introduce pinned SPTEs framework
Message-ID: <20200803171620.GC3151@linux.intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
 <3bf90589-8404-8bd6-925c-427f72528fc2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3bf90589-8404-8bd6-925c-427f72528fc2@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 03, 2020 at 10:52:05AM -0500, Brijesh Singh wrote:
> Thanks for series Sean. Some thoughts
> 
> 
> On 7/31/20 4:23 PM, Sean Christopherson wrote:
> > SEV currently needs to pin guest memory as it doesn't support migrating
> > encrypted pages.  Introduce a framework in KVM's MMU to support pinning
> > pages on demand without requiring additional memory allocations, and with
> > (somewhat hazy) line of sight toward supporting more advanced features for
> > encrypted guest memory, e.g. host page migration.
> 
> 
> Eric's attempt to do a lazy pinning suffers with the memory allocation
> problem and your series seems to address it. As you have noticed,
> currently the SEV enablement  in the KVM does not support migrating the
> encrypted pages. But the recent SEV firmware provides a support to
> migrate the encrypted pages (e.g host page migration). The support is
> available in SEV FW >= 0.17.

I assume SEV also doesn't support ballooning?  Ballooning would be a good
first step toward page migration as I think it'd be easier for KVM to
support, e.g. only needs to deal with the "zap" and not the "move".

> > The idea is to use a software available bit in the SPTE to track that a
> > page has been pinned.  The decision to pin a page and the actual pinning
> > managment is handled by vendor code via kvm_x86_ops hooks.  There are
> > intentionally two hooks (zap and unzap) introduced that are not needed for
> > SEV.  I included them to again show how the flag (probably renamed?) could
> > be used for more than just pin/unpin.
> 
> If using the available software bits for the tracking the pinning is
> acceptable then it can be used for the non-SEV guests (if needed). I
> will look through your patch more carefully but one immediate question,
> when do we unpin the pages? In the case of the SEV, once a page is
> pinned then it should not be unpinned until the guest terminates. If we
> unpin the page before the VM terminates then there is a  chance the host
> page migration will kick-in and move the pages. The KVM MMU code may
> call to drop the spte's during the zap/unzap and this happens a lot
> during a guest execution and it will lead us to the path where a vendor
> specific code will unpin the pages during the guest execution and cause
> a data corruption for the SEV guest.

The pages are unpinned by:

  drop_spte()
  |
  -> rmap_remove()
     |
     -> sev_drop_pinned_spte()


The intent is to allow unpinning pages when the mm_struct dies, i.e. when
the memory is no longer reachable (as opposed to when the last reference to
KVM is put), but typing that out, I realize there are dependencies and
assumptions that don't hold true for SEV as implemented.

  - Parent shadow pages won't be zapped.  Recycling MMU pages and zapping
    all SPs due to memslot updates are the two concerns.

    The easy way out for recycling is to not recycle SPs with pinned
    children, though that may or may not fly with VMM admins.

    I'm trying to resolve the memslot issue[*], but confirming that there's
    no longer an issue with not zapping everything is proving difficult as
    we haven't yet reproduced the original bug.

  - drop_large_spte() won't be invoked.  I believe the only semi-legitimate
    scenario is if the NX huge page workaround is toggled on while a VM is
    running.  Disallowing that if there is an SEV guest seems reasonable?

    There might be an issue with the host page size changing, but I don't
    think that can happen if the page is pinned.  That needs more
    investigation.


[*] https://lkml.kernel.org/r/20200703025047.13987-1-sean.j.christopherson@intel.com

> > Bugs in the core implementation are pretty much guaranteed.  The basic
> > concept has been tested, but in a fairly different incarnation.  Most
> > notably, tagging PRESENT SPTEs as PINNED has not been tested, although
> > using the PINNED flag to track zapped (and known to be pinned) SPTEs has
> > been tested.  I cobbled this variation together fairly quickly to get the
> > code out there for discussion.
> >
> > The last patch to pin SEV pages during sev_launch_update_data() is
> > incomplete; it's there to show how we might leverage MMU-based pinning to
> > support pinning pages before the guest is live.
> 
> 
> I will add the SEV specific bits and  give this a try.
> 
> >
> > Sean Christopherson (8):
> >   KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
> >   KVM: x86/mmu: Use bits 2:0 to check for present SPTEs
> >   KVM: x86/mmu: Refactor handling of not-present SPTEs in mmu_set_spte()
> >   KVM: x86/mmu: Add infrastructure for pinning PFNs on demand
> >   KVM: SVM: Use the KVM MMU SPTE pinning hooks to pin pages on demand
> >   KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
> >   KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV
> >   KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
> >
> >  arch/x86/include/asm/kvm_host.h |   7 ++
> >  arch/x86/kvm/mmu.h              |   3 +
> >  arch/x86/kvm/mmu/mmu.c          | 186 +++++++++++++++++++++++++-------
> >  arch/x86/kvm/mmu/paging_tmpl.h  |   3 +-
> >  arch/x86/kvm/svm/sev.c          | 141 +++++++++++++++++++++++-
> >  arch/x86/kvm/svm/svm.c          |   3 +
> >  arch/x86/kvm/svm/svm.h          |   3 +
> >  7 files changed, 302 insertions(+), 44 deletions(-)
> >
