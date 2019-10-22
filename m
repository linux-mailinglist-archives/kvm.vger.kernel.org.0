Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497E2E0D39
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 22:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbfJVU2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 16:28:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:59402 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728832AbfJVU2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 16:28:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 13:28:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; 
   d="scan'208";a="203749927"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Oct 2019 13:28:47 -0700
Date:   Tue, 22 Oct 2019 13:28:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
Message-ID: <20191022202847.GO2343@linux.intel.com>
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
 <20191016112857.293a197d@x1.home>
 <20191016174943.GG5866@linux.intel.com>
 <53f506b3-e864-b3ca-f18f-f8e9a1612072@djy.llc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53f506b3-e864-b3ca-f18f-f8e9a1612072@djy.llc>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 17, 2019 at 07:57:35PM -0400, Derek Yerger wrote:
> On 10/16/19 1:49 PM, Sean Christopherson wrote:
> >On Wed, Oct 16, 2019 at 11:28:57AM -0600, Alex Williamson wrote:
> >>On Wed, 16 Oct 2019 00:49:51 -0400
> >>Derek Yerger<derek@djy.llc>  wrote:
> >>
> >>>In at least Linux 5.2.7 via Fedora, up to 5.2.18, guest OS applications
> >>>repeatedly crash with segfaults. The problem does not occur on 5.1.16.
> >>>
> >>>System is running Fedora 29 with kernel 5.2.18. Guest OS is Windows 10 with an
> >>>AMD Radeon 540 GPU passthrough. When on 5.2.7 or 5.2.18, specific windows
> >>>applications frequently and repeatedly crash, throwing exceptions in random
> >>>libraries. Going back to 5.1.16, the issue does not occur.
> >>>
> >>>The host system is unaffected by the regression.
> >>>
> >>>Keywords: kvm mmu pci passthrough vfio vfio-pci amdgpu
> >>>
> >>>Possibly related: Unmerged [PATCH] KVM: x86/MMU: Zap all when removing memslot
> >>>if VM has assigned device
> >>That was never merged because it was superseded by:
> >>
> >>d012a06ab1d2 Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"
> >>
> >>That revert also induced this commit:
> >>
> >>002c5f73c508 KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot
> >>
> >>Both of these were merged to stable, showing up in 5.2.11 and 5.2.16
> >>respectively, so seeing these sorts of issues might be considered a
> >>known issue on 5.2.7, but not 5.2.18 afaik.  Do you have a specific
> >>test that reliably reproduces the issue?  Thanks,
> Test case 1: Kernel 5.2.18, PCI passthrough, Windows 10 guest, error condition.
> Error 1: Application error in Firefox, restarting firefox and restoring tabs
> reliably causes application crash with stack overflow error.
> Error 2: Guest BSOD by the morning if left idle
> Error 3: Guest BSOD within 1 minute of using SolidWorks CAD software
> 
> Test case 2: Kernel 5.2.18, no PCI passthrough, same environment. Guest BSOD
> encountered.
> 
> Test case 3: Kernel 5.1.16, no PCI passthrough, same environment. Worked in
> Solidworks for 10 minutes without BSOD. Opened firefox and restored tabs, no
> crash.
> 
> Test case 4: Kernel 5.1.16, with PCI passthrough, same environment. Worked
> in Solidworks for a half hour. Opened firefox and restored tabs, no crash.
> 
> Other factors: The guest does not change between tests. Same drivers,
> software, etc. I have reliably switched between 5.2.x and 5.1.x multiple
> times in the past month and repeatably see issues with 5.2.x. At this point
> I'm unsure if it's PCI passthrough causing the problem.
> 
> I know I should probably start from fresh host and guest, but time isn't
> really permitting.
> >Also, does the failure reproduce on on 5.2.1 - 5.2.6?  The memslot debacle
> >exists on all flavors of 5.2.x, if the errors showed up in 5.2.7 then they
> >are being caused by something else.
> After experiencing the issue in absence of PCI passthrough, I believe the
> problem is unrelated to the memslot debacle.

Heh, should've checked from the get go...  It's definitely not the memslot
issue, because the memslot bug is in 5.1.16 as well.  :-)

> I'm stuck on 5.1.x for now, maybe I'll give up and get a dedicated windows
> machine /s

What hardware are you running on?  I was thinking this was AMD specific,
but then realized you said "AMD Radeon 540 GPU" and not "AMD CPU".
