Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7592869A3
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgJGUzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:55:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:38777 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728022AbgJGUzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 16:55:54 -0400
IronPort-SDR: EIviMndUDIHL3nApgZuAVeU49ySDtPKxKukCaxzAtgTXXXU5H5bo762dguG2kxhHioT3Gz4qVG
 YhfsM+FzOy0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="145028001"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="145028001"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 13:55:54 -0700
IronPort-SDR: tKemYpyspvIDJstVnrosrbjs/GY71RYfm/aOB/qcgMVU8bVOKD7/gfGDPCVOOJjPtwr8AZLgZ9
 mHWILCKoR2Qg==
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="528160278"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 13:55:53 -0700
Date:   Wed, 7 Oct 2020 13:55:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 10/22] kvm: mmu: Add TDP MMU PF handler
Message-ID: <20201007205552.GB2138@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-11-bgardon@google.com>
 <20200930163740.GD32672@linux.intel.com>
 <CANgfPd_A6Bbv+ehRvMVi_NK2C_Jb=bBmXJR89fj=JSFSga0avg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_A6Bbv+ehRvMVi_NK2C_Jb=bBmXJR89fj=JSFSga0avg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 03:33:21PM -0700, Ben Gardon wrote:
> On Wed, Sep 30, 2020 at 9:37 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, Sep 25, 2020 at 02:22:50PM -0700, Ben Gardon wrote:
> > > @@ -4113,8 +4088,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> > >       if (page_fault_handle_page_track(vcpu, error_code, gfn))
> > >               return RET_PF_EMULATE;
> > >
> > > -     if (fast_page_fault(vcpu, gpa, error_code))
> > > -             return RET_PF_RETRY;
> > > +     if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> > > +             if (fast_page_fault(vcpu, gpa, error_code))
> > > +                     return RET_PF_RETRY;
> >
> > It'll probably be easier to handle is_tdp_mmu() in fast_page_fault().
> 
> I'd prefer to keep this check here because then in the fast page fault
> path, we can just handle the case where we do have a tdp mmu root with
> the tdp mmu fast pf handler and it'll mirror the split below with
> __direct_map and the TDP MMU PF handler.

Hmm, what about adding wrappers for these few cases where TDP MMU splits
cleanly from the existing paths?  The thought being that it would keep the
control flow somewhat straightforward, and might also help us keep the two
paths aligned (more below).

> > >
> > >       r = mmu_topup_memory_caches(vcpu, false);
> > >       if (r)
> > > @@ -4139,8 +4115,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> > >       r = make_mmu_pages_available(vcpu);
> > >       if (r)
> > >               goto out_unlock;
> > > -     r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
> > > -                      prefault, is_tdp && lpage_disallowed);
> > > +
> > > +     if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> > > +             r = kvm_tdp_mmu_page_fault(vcpu, write, map_writable, max_level,
> > > +                                        gpa, pfn, prefault,
> > > +                                        is_tdp && lpage_disallowed);
> > > +     else
> > > +             r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
> > > +                              prefault, is_tdp && lpage_disallowed);

Somewhat tangetially related to the above, it feels like the TDP MMU helper
here would be better named tdp_mmu_map() or so.  KVM has already done the
"fault" part, in that it has faulted in the page (if relevant) and obtained
a pfn.  What's left is the actual insertion into the TDP page tables.

And again related to the helper, ideally tdp_mmu_map() and __direct_map()
would have identical prototypes.  Ditto for the fast page fault paths.  In
theory, that would allow the compiler to generate identical preamble, with
only the final check being different.  And if the compiler isn't smart enough
to do that on its own, we might even make the wrapper non-inline, with an
"unlikely" annotation to coerce the compiler to generate a tail call for the
preferred path.

> > >
> > >  out_unlock:
> > >       spin_unlock(&vcpu->kvm->mmu_lock);
