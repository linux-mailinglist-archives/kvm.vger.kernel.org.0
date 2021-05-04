Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A6F373216
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 23:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhEDVzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 17:55:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:30204 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232254AbhEDVzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 17:55:32 -0400
IronPort-SDR: at1OSACClPRfuk7bs9KU3iZpMwASc4n//xJUyw4llzXwgWW44CTEWp/ghJyjvefzB9UK0Q905m
 UjtTdknUStrg==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="177626196"
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="177626196"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 14:54:26 -0700
IronPort-SDR: oBJOXwGB4iCZVeW4S3SZOPw5Ap+WheWH7blJxx3VUF1zEjfmnJtoBbXXqvrYO4YbC3q5597ini
 ryVf/k/lB8PA==
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="406291888"
Received: from pdonde-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.10])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 14:54:24 -0700
Message-ID: <b6d23d9fd8e526e5c7c1a968e2018d13c5433547.camel@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix some return value error in
 kvm_tdp_mmu_map()
From:   Kai Huang <kai.huang@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Wed, 05 May 2021 09:54:22 +1200
In-Reply-To: <CANgfPd-3a1a4se--+M6fCnfXP0kbbxqpKrv18JVA3UFcxrZ_3g@mail.gmail.com>
References: <20210430160138.100252-1-kai.huang@intel.com>
         <CANgfPd_gWYaKbdD-fkLNwCSaVQhgcQaSKOEoG0a2B90GhB03zg@mail.gmail.com>
         <e5814ecab90a3df04ea862dd31927a8f9275af77.camel@intel.com>
         <CANgfPd-3a1a4se--+M6fCnfXP0kbbxqpKrv18JVA3UFcxrZ_3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 09:45 -0700, Ben Gardon wrote:
> On Mon, May 3, 2021 at 4:32 PM Kai Huang <kai.huang@intel.com> wrote:
> > 
> > On Mon, 2021-05-03 at 10:07 -0700, Ben Gardon wrote:
> > > On Fri, Apr 30, 2021 at 9:03 AM Kai Huang <kai.huang@intel.com> wrote:
> > > > 
> > > > There are couple of issues in current tdp_mmu_map_handle_target_level()
> > > > regarding to return value which reflects page fault handler's behavior
> > > > -- whether it truely fixed page fault, or fault was suprious, or fault
> > > > requires emulation, etc:
> > > > 
> > > > 1) Currently tdp_mmu_map_handle_target_level() return 0, which is
> > > >    RET_PF_RETRY, when page fault is actually fixed.  This makes
> > > >    kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
> > > >    RET_PF_FIXED.
> > > 
> > > Ooof that was an oversight. Thank you for catching that.
> > 
> > Thanks for reviewing.
> > 
> > > 
> > > > 
> > > > 2) When page fault is spurious, tdp_mmu_map_handle_target_level()
> > > >    currently doesn't return immediately.  This is not correct, since it
> > > >    may, for instance, lead to double emulation for a single instruction.
> > > 
> > > Could you please add an example of what would be required for this to
> > > happen? What effect would it have?
> > > I don't doubt you're correct on this point, just having a hard time
> > > pinpointing where the issue is.
> > 
> > Hmm.. After reading your reply, I think I wasn't thinking correctly about the emulation
> > part :)
> > 
> > I was thinking the case that two threads simultaneously write to video ram (which is write
> > protected and requires emulation) which has been swapped out, in which case one thread
> > will succeed with setting up the mapping, and the other will get atomic exchange failure.
> > Since both threads are trying to setup the same mapping, I thought in this case for the
> > second thread (that gets atomic exchange failure) should just give up. But reading code
> > again, and with your reply, I think the right behavior is, actually both threads need to
> > do the emulation, because this is the correct behavior.'
> > 
> > That being said, I still believe that for spurious fault, we should return immediately
> > (otherwise it is not spurious fault). But I now also believe the spurious fault check in
> > existing code happens too early -- it has to be after write protection emulation check.
> > And I just checked the mmu_set_spte() code, if I read correctly, it exactly puts spurious
> > fault check after write protection emulation check.
> > 
> > Does this make sense?
> 
> Yeah, that makes sense. Having to move the emulation check after the
> cmpxchg always felt a little weird to me Though I still think it makes
> sense since the cmpxchg can fail.

I guess my brain was dominated by the idea that for spurious fault we should return
immediately :) But I guess we can also fix the pf_fixed count  issue by simply:

-       if (!prefault)
+       if (!prefault && ret == RET_PF_FIXED)
                vcpu->stat.pf_fixed++;

Which way do you prefer?

> 
> > 
> > If this looks good to you, I guess it would be better to split this patch into smaller
> > patches (for instance, one patch to handle case 1), and one to handle spurious fault
> > change)?
> 
> That sounds good to me. That would definitely make it easier to review.

I'll post a new patch series I guess.

Thanks!



