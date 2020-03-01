Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7A4174EC8
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 18:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgCARte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 12:49:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:61884 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgCARtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 12:49:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2020 09:49:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,504,1574150400"; 
   d="scan'208";a="257681708"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2020 09:49:33 -0800
Date:   Sun, 1 Mar 2020 09:49:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] KVM: x86/mmu: Rename kvm_mmu->get_cr3() to
 ->get_guest_cr3_or_eptp()
Message-ID: <20200301174933.GB20843@linux.intel.com>
References: <20200207173747.6243-1-sean.j.christopherson@intel.com>
 <20200207173747.6243-7-sean.j.christopherson@intel.com>
 <1424348b-7f09-513a-960b-6d15ac3a9ae4@redhat.com>
 <20200212162816.GB15617@linux.intel.com>
 <de17199e-aff3-b664-73f5-9c88727d064e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de17199e-aff3-b664-73f5-9c88727d064e@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 05:42:33PM +0100, Paolo Bonzini wrote:
> On 12/02/20 17:28, Sean Christopherson wrote:
> > On Wed, Feb 12, 2020 at 01:00:59PM +0100, Paolo Bonzini wrote:
> >> On 07/02/20 18:37, Sean Christopherson wrote:
> >>> Rename kvm_mmu->get_cr3() to call out that it is retrieving a guest
> >>> value, as opposed to kvm_mmu->set_cr3(), which sets a host value, and to
> >>> note that it will return L1's EPTP when nested EPT is in use.  Hopefully
> >>> the new name will also make it more obvious that L1's nested_cr3 is
> >>> returned in SVM's nested NPT case.
> >>>
> >>> No functional change intended.
> >>
> >> Should we call it "get_pgd", since that is how Linux calls the top-level
> >> directory?  I always get confused by PUD/PMD, but as long as we only
> >> keep one /p.d/ moniker it should be fine.
> > 
> > Heh, I have the exact same sentiment.  get_pgd() works for me.
> 
> Ok, I'll post a patch that uses get_guest_pgd() as soon as I open
> kvm/next for 5.7 material.

I need to resend the 5-level nested EPT support, I'll include this change.
Should I also include patches 4, 5 and 7 when I send v3 of that series?
Your earlier mail said they were queued for 5.6, but AFAICT only patches
1 and 2 made it into 5.6 (which is not a big deal at all).

On Wed, Feb 12, 2020 at 01:03:03PM +0100, Paolo Bonzini wrote:
> On 07/02/20 18:37, Sean Christopherson wrote:
> > Sean Christopherson (7):
> >   KVM: nVMX: Use correct root level for nested EPT shadow page tables
> >   KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging
> >   KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT
> >   KVM: nVMX: Rename nested_ept_get_cr3() to nested_ept_get_eptp()
> >   KVM: nVMX: Rename EPTP validity helper and associated variables
> >   KVM: x86/mmu: Rename kvm_mmu->get_cr3() to ->get_guest_cr3_or_eptp()
> >   KVM: nVMX: Drop unnecessary check on ept caps for execute-only
> >
>
> Queued 1-2-4-5-7 (for 5.6), thanks!
