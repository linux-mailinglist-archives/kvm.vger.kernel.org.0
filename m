Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0760324A3C3
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 18:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHSQHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 12:07:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:46496 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgHSQHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 12:07:19 -0400
IronPort-SDR: hStEoMJeUhVYYE92W0QzSJt6u3aUGePSVWotFbSTPPBututFOjJXtFIFeG5nu/KU+I0outZQQI
 fZPkl2QA3jaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="156212793"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="156212793"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 09:06:01 -0700
IronPort-SDR: 5NSdmNTIbdoMuRCL10zRYouuES5N+pjzkw1toeF/aPiD5QkmtzhV4okZ5sk6AJU7tfjgiOudLB
 Qt3/nMVy2sAg==
X-IronPort-AV: E=Sophos;i="5.76,331,1592895600"; 
   d="scan'208";a="327133706"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 09:05:58 -0700
Date:   Wed, 19 Aug 2020 09:05:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eric van Tassell <evantass@amd.com>
Cc:     eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <Brijesh.Singh@amd.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>, kvm@vger.kernel.org,
        bp@alien8.de, hpa@zytor.com, mingo@redhat.com, jmattson@google.com,
        joro@8bytes.org, pbonzini@redhat.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [Patch 2/4] KVM:SVM: Introduce set_spte_notify support
Message-ID: <20200819160557.GD20459@linux.intel.com>
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
 <20200724235448.106142-3-Eric.VanTassell@amd.com>
 <20200731202502.GG31451@linux.intel.com>
 <3dbf468e-2573-be5b-9160-9bb51d56882c@amd.com>
 <20200803162730.GB3151@linux.intel.com>
 <775a71bb-bd1d-ff34-a740-e10a88cc668c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <775a71bb-bd1d-ff34-a740-e10a88cc668c@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 11:03:48AM -0500, Eric van Tassell wrote:
> 
> 
> On 8/3/20 11:27 AM, Sean Christopherson wrote:
> >On Sun, Aug 02, 2020 at 03:53:54PM -0500, Eric van Tassell wrote:
> >>
> >>On 7/31/20 3:25 PM, Sean Christopherson wrote:
> >>>On Fri, Jul 24, 2020 at 06:54:46PM -0500, eric van tassell wrote:
> >>>>Improve SEV guest startup time from O(n) to a constant by deferring
> >>>>guest page pinning until the pages are used to satisfy nested page faults.
> >>>>
> >>>>Implement the code to do the pinning (sev_get_page) and the notifier
> >>>>sev_set_spte_notify().
> >>>>
> >>>>Track the pinned pages with xarray so they can be released during guest
> >>>>termination.
> >>>
> >>>I like that SEV is trying to be a better citizen, but this is trading one
> >>>hack for another.
> >>>
> >>>   - KVM goes through a lot of effort to ensure page faults don't need to
> >>>     allocate memory, and this throws all that effort out the window.
> >>>
> >>can you elaborate on that?
> >
> >mmu_topup_memory_caches() is called from the page fault handlers before
> >acquiring mmu_lock to pre-allocate shadow pages, PTE list descriptors, GFN
> >arrays, etc... that may be needed to handle the page fault.  This allows
> >using standard GFP flags for the allocation and obviates the need for error
> >handling in the consumers.
> >
> 
> I see what you meant. The issue that causes us to use this approach is that
> we need to be able to unpin the pages when the VM exits.

Yes, but using a software available flag in the SPTE to track pinned pages
should be very doable. 
