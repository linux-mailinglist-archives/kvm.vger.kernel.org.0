Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6522323AA70
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 18:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgHCQ1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 12:27:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:59014 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgHCQ1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 12:27:31 -0400
IronPort-SDR: iDjFqpUx6U2j7j/Wh8qIAOPT2P1awS+NayeEtpNd0zPczLx1GgixE/hF7mOzgayp28I3GmPhwk
 r2wxi1CjKrFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="139723985"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="139723985"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 09:27:31 -0700
IronPort-SDR: HFatII70TVO+VElY2f8cAHjRcUjUalPsPL7Jz8Aknhmssqu+ylmI78nyQgq6prRghdO/K9Y4N6
 itDBWwZYssuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="366438683"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2020 09:27:30 -0700
Date:   Mon, 3 Aug 2020 09:27:30 -0700
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
Message-ID: <20200803162730.GB3151@linux.intel.com>
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
 <20200724235448.106142-3-Eric.VanTassell@amd.com>
 <20200731202502.GG31451@linux.intel.com>
 <3dbf468e-2573-be5b-9160-9bb51d56882c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dbf468e-2573-be5b-9160-9bb51d56882c@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 02, 2020 at 03:53:54PM -0500, Eric van Tassell wrote:
> 
> On 7/31/20 3:25 PM, Sean Christopherson wrote:
> >On Fri, Jul 24, 2020 at 06:54:46PM -0500, eric van tassell wrote:
> >>Improve SEV guest startup time from O(n) to a constant by deferring
> >>guest page pinning until the pages are used to satisfy nested page faults.
> >>
> >>Implement the code to do the pinning (sev_get_page) and the notifier
> >>sev_set_spte_notify().
> >>
> >>Track the pinned pages with xarray so they can be released during guest
> >>termination.
> >
> >I like that SEV is trying to be a better citizen, but this is trading one
> >hack for another.
> >
> >   - KVM goes through a lot of effort to ensure page faults don't need to
> >     allocate memory, and this throws all that effort out the window.
> >
> can you elaborate on that?

mmu_topup_memory_caches() is called from the page fault handlers before
acquiring mmu_lock to pre-allocate shadow pages, PTE list descriptors, GFN
arrays, etc... that may be needed to handle the page fault.  This allows
using standard GFP flags for the allocation and obviates the need for error
handling in the consumers.

> >>+int sev_set_spte_notify(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
> >>+			int level, bool mmio, u64 *spte)
> >>+{
> >>+	int rc;
> >>+
> >>+	if (!sev_guest(vcpu->kvm))
> >>+		return 0;
> >>+
> >>+	/* MMIO page contains the unencrypted data, no need to lock this page */
> >>+	if (mmio)
> >
> >Rather than make this a generic set_spte() notify hook, I think it makes
> >more sense to specifying have it be a "pin_spte" style hook.  That way the
> >caller can skip mmio PFNs as well as flows that can't possibly be relevant
> >to SEV, e.g. the sync_page() flow.
> Not sure i understand. We do ignore mmio here.

I'm saying we can have the caller, i.e. set_spte(), skip the hook for MMIO.
If the kvm_x86_ops hook is specifically designed to allow pinning pages (and
to support related features), then set_spte() can filter out MMIO PFNs.  It's
a minor detail, but it's one less thing to have to check in the vendor code.

> Can you detail a bit more what you see as problematic with the sync_page() flow?

There's no problem per se.  But, assuming TDP/NPT is required to enable SEV,
then sync_page() simply isn't relevant for pinning a host PFN as pages can't
become unsynchronized when TDP is enabled, e.g. ->sync_page() is a nop when
TDP is enabled.  If the hook is completely generic, then we need to think
about how it interacts with changing existing SPTEs via ->sync_page().  Giving
the hook more narrowly focused semantics means we can again filter out that
path and not have to worry about testing it.

The above doesn't hold true for nested TDP/NPT, but AIUI SEV doesn't yet
support nested virtualization, i.e. it's a future problem.
