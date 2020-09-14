Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DC1269235
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 18:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgINQzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 12:55:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:22800 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgINQta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 12:49:30 -0400
IronPort-SDR: k9nx0JRIppzFqoh8vYH26k2mTMxI29e/dnimL5GwI1JZ5rLjcg7vGBWhwZfizLgqSOHi83jzfh
 XJMqAD8eNgcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220665952"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="220665952"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:49:27 -0700
IronPort-SDR: Pm7ODHiCR14OAqKMe6ftIHPePn/ldSOJmEGdRKEsdBg/QTPXWwHDj+P9U9nih+5WtzffrcquYz
 cz48HB1H/SOg==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="507207696"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:49:26 -0700
Date:   Mon, 14 Sep 2020 09:49:24 -0700
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
        Jun Nakajima <jun.nakajima@intel.com>,
        Weijiang Yang <weijiang.yang@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
Message-ID: <20200914164923.GH6855@sjchrist-ice>
References: <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
 <20200709211253.GW24919@linux.intel.com>
 <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
 <20200710042922.GA24919@linux.intel.com>
 <20200713122226.28188f93@x1.home>
 <20200713190649.GE29725@linux.intel.com>
 <20200721030319.GD20375@linux.intel.com>
 <20200721100036.464d4440@w520.home>
 <20200723155711.GD21891@linux.intel.com>
 <20200723123544.6268b465@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723123544.6268b465@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 23, 2020 at 12:35:44PM -0600, Alex Williamson wrote:
> On Thu, 23 Jul 2020 08:57:11 -0700
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> > On Tue, Jul 21, 2020 at 10:00:36AM -0600, Alex Williamson wrote:
> > > On Mon, 20 Jul 2020 20:03:19 -0700
> > > Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > >   
> > > > +Weijiang
> > > > 
> > > > On Mon, Jul 13, 2020 at 12:06:50PM -0700, Sean Christopherson wrote:  
> > > > > The only ideas I have going forward are to:
> > > > > 
> > > > >   a) Reproduce the bug outside of your environment and find a resource that
> > > > >      can go through the painful bisection.    
> > > > 
> > > > We're trying to reproduce the original issue in the hopes of biesecting, but
> > > > have not yet discovered the secret sauce.  A few questions:
> > > > 
> > > >   - Are there any known hardware requirements, e.g. specific flavor of GPU?  
> > > 
> > > I'm using an old GeForce GT635, I don't think there's anything special
> > > about this card.  
> > 
> > Would you be able to provide your QEMU command line?  Or at least any
> > potentially relevant bits?  Still no luck reproducing this on our end.

*sigh*

The "good" news is that we were able to reproduce and bisect the "fix".

That bad news is that the "fix" is the fracturing of large pages for the
iTLB multi-hit bug, added by commit b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT
mitigation").  The GPU pass-through failures can be reproduced by loading
KVM with kvm.nx_huge_pages=0.

So, we have another data point, but still no clear explanation of exactly
what is broken.
