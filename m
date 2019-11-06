Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36961F20D5
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 22:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbfKFVaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 16:30:35 -0500
Received: from mga06.intel.com ([134.134.136.31]:14326 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbfKFVaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 16:30:35 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 13:30:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="212860856"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 06 Nov 2019 13:30:33 -0800
Date:   Wed, 6 Nov 2019 13:30:32 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20191106213032.GA20475@linux.intel.com>
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-2-sean.j.christopherson@intel.com>
 <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
 <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 10:09:29PM +0100, Paolo Bonzini wrote:
> On 06/11/19 19:04, Dan Williams wrote:
> > On Wed, Nov 6, 2019 at 9:07 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > This is racy unless you can be certain that the pfn and resulting page
> > has already been pinned by get_user_pages().
> 
> What is the race exactly?

The check in kvm_get_pfn() is guaranteed to be racy, but that's already
broken with respect to ZONE_DEVICE.
 
> In general KVM does not use pfn's until after having gotten them from
> get_user_pages (or follow_pfn for VM_IO | VM_PFNMAP vmas, for which
> get_user_pages fails, but this is not an issue here).  It then creates
> the page tables and releases the reference to the struct page.
> 
> Anything else happens _after_ the reference has been released, but still
> from an mmu notifier; this is why KVM uses pfn_to_page quite pervasively.
> 
> If this is enough to avoid races, then I prefer Sean's patch.  If it is
> racy, we need to fix kvm_set_pfn_accessed and kvm_set_pfn_dirty first,
> and second at transparent_hugepage_adjust and kvm_mmu_zap_collapsible_spte:

transparent_hugepage_adjust() would be ok, it's called before the original
reference is put back.

> - if accessed/dirty state need not be tracked properly for ZONE_DEVICE,
> then I suppose David's patch is okay (though I'd like to have a big
> comment explaining all the things that went on in these emails).  If
> they need to work, however, Sean's patch 1 is the right thing to do.
> 
> - if we need Sean's patch 1, but it is racy to use is_zone_device_page,
> we could first introduce a helper similar to kvm_is_hugepage_allowed()
> from his patch 2, but using pfn_to_online_page() to filter out
> ZONE_DEVICE pages.  This would cover both transparent_hugepage_adjust
> and kvm_mmu_zap_collapsible_spte.

After more thought, I agree with Paolo that adding kvm_is_zone_device_pfn()
is preferably if blocking with mmu_notifier is sufficient to avoid races.
The only caller that isn't protected by mmu_notifier (or holding a gup()-
obtained referece) is kvm_get_pfn(), but again, that's completely borked
anyways.   Adding a WARN_ON(page_count()) in kvm_is_zone_device_pfn() would
help with the auditing issue.

The scope of the changes required to completely avoid is_zone_device_page()
is massive, and probably would result in additional trickery :-(

> > This is why I told David
> > to steer clear of adding more is_zone_device_page() usage, it's
> > difficult to audit. Without an existing pin the metadata to determine
> > whether a page is ZONE_DEVICE or not could be in the process of being
> > torn down. Ideally KVM would pass around a struct { struct page *page,
> > unsigned long pfn } tuple so it would not have to do this "recall
> > context" dance on every pfn operation.
> 
> Unfortunately once KVM has created its own page tables, the struct page*
> reference is lost, as the PFN is the only thing that is stored in there.

Ya, the horrible idea I had in mind was to steal a bit from KVM_PFN_ERR_MASK
to track whether or not the PFN is associated with a struct page.
