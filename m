Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A942721E075
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 21:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgGMTGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 15:06:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:31274 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgGMTGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 15:06:50 -0400
IronPort-SDR: vQHrsfCipWGYTVBzFMUSlhPOtgeX43CZOlGnv7rRqZE1TwHJk0anVPZKjJkYGeyJ1dCDVfhvHz
 qlL0CImlQ6pg==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="128274173"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="128274173"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 12:06:50 -0700
IronPort-SDR: eUaCJEPnu90pPzudvr8vulVtOdjZGIcFc/6MyjgagYhI3dMsNSh3DdNLegDhKN7oA2bipNXj2i
 Bj5ZHPZaJw9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="360148697"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 13 Jul 2020 12:06:50 -0700
Date:   Mon, 13 Jul 2020 12:06:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
Message-ID: <20200713190649.GE29725@linux.intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
 <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
 <20200709211253.GW24919@linux.intel.com>
 <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
 <20200710042922.GA24919@linux.intel.com>
 <20200713122226.28188f93@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713122226.28188f93@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 12:22:26PM -0600, Alex Williamson wrote:
> On Thu, 9 Jul 2020 21:29:22 -0700
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> > +Alex, whom I completely spaced on Cc'ing.
> > 
> > Alex, this is related to the dreaded VFIO memslot zapping issue from last
> > year.  Start of thread: https://patchwork.kernel.org/patch/11640719/.
> > 
> > The TL;DR of below: can you try the attached patch with your reproducer
> > from the original bug[*]?  I honestly don't know whether it has a legitimate
> > chance of working, but it's the one thing in all of this that I know was
> > definitely a bug.  I'd like to test it out if only to sate my curiosity.
> > Absolutely no rush.
> 
> Mixed results, maybe you can provide some guidance.  Running this
> against v5.8-rc4, I haven't reproduced the glitch.  But it's been a
> long time since I tested this previously, so I went back to v5.3-rc5 to
> make sure I still have a recipe to trigger it.  I can still get the
> failure there as the selective flush commit was reverted in rc6.  Then
> I wondered, can I take broken v5.3-rc5 and apply this fix to prove that
> it works?  No, v5.3-rc5 + this patch still glitches.  So I thought
> maybe I could make v5.8-rc4 break by s/true/false/ in this patch.
> Nope.  Then I applied the original patch from[1] to try to break it.
> Nope.  So if anything, I think the evidence suggests this was broken
> elsewhere and is now fixed, or maybe it is a timing issue that I can't
> trigger on newer kernels.  If the reproducer wasn't so touchy and time
> consuming, I'd try to bisect, but I don't have that sort of bandwidth.

Ow.  That manages to be both a best case and worst case scenario.  I can't
think of any clever way to avoid bisecting.  There have been a number of
fixes in tangentially related code since 5.3, e.g. memslots, MMU, TLB,
etc..., but trying to isolate which one, if any of them, fixed the bug has
a high probability of being a wild goose chase.

The only ideas I have going forward are to:

  a) Reproduce the bug outside of your environment and find a resource that
     can go through the painful bisection.

  b) Add a module param to toggle the new behavior and see if anything
     breaks.

I can ask internally if it's possible to get a resource on my end to go
after (a).  (b) is a question for Paolo.

Thanks much for testing!

> Thanks,
> 
> Alex
> 
> [1] https://patchwork.kernel.org/patch/10798453/
> 
