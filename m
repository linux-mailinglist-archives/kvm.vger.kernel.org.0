Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E1B374D19
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhEFBxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:53:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:25769 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhEFBxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:53:30 -0400
IronPort-SDR: oEv2pqJcM0/RscbyfEjdkBtvurnlKqTvZHRQ2zlM9jB+beTMsWdXuFJ7LUYIUs2EMIk+KpxpNV
 S3WYMvkIH3jA==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="198403584"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="198403584"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:52:32 -0700
IronPort-SDR: lztIGyfXoX7WINQKiKUGN8TeoluIEp5eE6CnIKJdfKEn/ovRsmglNW61fswcRA/13quLo0qdLy
 jxgEcfoc1u5g==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="428365096"
Received: from jhagel-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.164.152])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:52:30 -0700
Message-ID: <bff32997a5a74b7caccf00d2e4c6e5cf5608b4bd.camel@intel.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Fix pf_fixed count in
 tdp_mmu_map_handle_target_level()
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
In-Reply-To: <YJLS6cUghgktsMNJ@google.com>
References: <cover.1620200410.git.kai.huang@intel.com>
         <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
         <YJLH4Iyz4imfY0c2@google.com> <YJLS6cUghgktsMNJ@google.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Thu, 06 May 2021 13:51:43 +1200
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > > 
> > > -	if (!prefault)
> > > +	if (!prefault && ret == RET_PF_FIXED)
> > >  		vcpu->stat.pf_fixed++;
> > For RET_PF_EMULATE, I could go either way.  On one hand, KVM is installing a
> > translation that accelerates future emulated MMIO, so it's kinda sorta fixing
> > the page fault.  On the other handle, future emulated MMIO still page faults, it
> > just gets handled without going through the full page fault handler.
> 
> Hrm, the other RET_PF_EMULATE case is when KVM creates a _new_ SPTE to handle a
> page fault, but installs a read-only SPTE on a write fault because the page is
> marked for write access tracking, e.g. for non-leaf guest page tables.  Bumping
> pf_fixed is arguably correct in that case since KVM did fault in a page and from
> the guest's perspective the page fault was fixed, it's just that "fixing" the
> fault involved a bit of instruction emulation.

Yes this is exactly the case for video ram :)

> 
> > If we do decide to omit RET_PF_EMULATE, it should be a separate patch and should
> > be done for all flavors of MMU.  For this patch, the correct code is:
> > 
> > 	if (ret != RET_PF_SPURIOUS)
> > 		vcpu->stat.pf_fixed++;
> > 
> > which works because "ret" cannot be RET_PF_RETRY.
> > 
> > Looking through the other code, KVM also fails to bump stat.pf_fixed in the fast
> > page fault case.  So, if we decide to fix/adjust RET_PF_EMULATE, I think it would
> > make sense to handle stat.pf_fixed in a common location.
> 
> Blech.  My original thought was to move the stat.pf_fixed logic all the way out
> to kvm_mmu_do_page_fault(), but that would do the wrong thing if pf_fixed is
> bumped on RET_PF_EMULATE and page_fault_handle_page_track() returns RET_PF_EMULATE.
> That fast path handles the case where the guest gets a !WRITABLE page fault on
> an PRESENT SPTE that KVM is write tracking.  *sigh*.
> 
> I'm leaning towards making RET_PF_EMULATE a modifier instead of a standalone
> type, which would allow more precise pf_fixed adjustments and would also let us
> clean up the EMULTYPE_ALLOW_RETRY_PF logic, which has a rather gross check for
> detecting MMIO page faults.
> 
> > The legacy MMU also prefetches on RET_PF_EMULATE, which isn't technically wrong,
> > but it's pretty much guaranteed to be a waste of time since prefetching only
> > installs SPTEs if there is a backing memslot and PFN.
> > 
> > Kai, if it's ok with you, I'll fold the above "ret != RET_PF_SPURIOUS" change
> > into a separate mini-series to address the other issues I pointed out.  I was
> > hoping I could paste patches for them inline and let you carry them, but moving
> > stat.pf_fixed handling to a common location requires additional code shuffling
> > because of async page faults :-/
> 
> Cancel that idea, given the twisty mess of RET_PF_EMULATE it's probably best for
> you to just send a new version of your patch to make the TDP MMU pf_fixed behavior
> match the legacy MMU.  It doesn't make sense to hold up a trivial fix just so I
> can scratch a refactoring itch :-)

OK. Either way is fine to me. I'll send a new one with your suggestion:

	if (ret != RET_PF_SPURIOUS)
 		vcpu->stat.pf_fixed++;

Thanks!

