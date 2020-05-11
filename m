Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D971CE14A
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 19:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgEKRKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 13:10:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:27175 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729731AbgEKRKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 13:10:08 -0400
IronPort-SDR: UOrVq0WhKJ02UtjCLWrCTehVVmL3frWjKlyyvGmsolzIBUYwQvH0ii8rPUcfvyr1ltZUbjpbQa
 ZVGd7s5gwAog==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 10:10:07 -0700
IronPort-SDR: JGH+TqWPyefkPNqmFTqFqaFL1MHmBZSL6zXfqxqEeF75jsqC+y0DfhBHPCfW38XjrnlZPv6QN8
 NkD9OOphzsrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="279845546"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 11 May 2020 10:10:07 -0700
Date:   Mon, 11 May 2020 10:10:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Cook <tony-cook@bigpond.com>, zoran.davidovac@gmail.com,
        euloanty@live.com
Subject: Re: [PATCH] KVM: Fix a warning in __kvm_gfn_to_hva_cache_init()
Message-ID: <20200511171007.GE24052@linux.intel.com>
References: <20200504190526.84456-1-peterx@redhat.com>
 <20200505013929.GA17225@linux.intel.com>
 <20200505141245.GH6299@xz-x1>
 <20200511160537.GC24052@linux.intel.com>
 <CAOQ_Qsi-50zLtq8nKeUN8wYKkiq9TkX9fcNHwzZ_F5JX0qJp-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ_Qsi-50zLtq8nKeUN8wYKkiq9TkX9fcNHwzZ_F5JX0qJp-g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 11, 2020 at 10:04:29AM -0700, Oliver Upton wrote:
> On Mon, May 11, 2020 at 9:05 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > +cc a few other people that have reported this at one time or another.
> >
> > On Tue, May 05, 2020 at 10:12:45AM -0400, Peter Xu wrote:
> > > On Mon, May 04, 2020 at 06:39:29PM -0700, Sean Christopherson wrote:
> > > > On Mon, May 04, 2020 at 03:05:26PM -0400, Peter Xu wrote:
> > > > > GCC 10.0.1 gives me this warning when building KVM:
> > > > >
> > > > >   warning: ‘nr_pages_avail’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> > > > >   2442 |  for ( ; start_gfn <= end_gfn; start_gfn += nr_pages_avail) {
> > > > >
> > > > > It should not happen, but silent it.
> > > >
> > > > Heh, third times a charm?  This has been reported and proposed twice
> > > > before[1][2].  Are you using any custom compiler flags?  E.g. -O3 is known
> > > > to cause false positives with -Wmaybe-uninitialized.
> > >
> > > No, what I did was only upgrading to Fedora 32 (which will auto-upgrade GCC),
> > > so it should be using the default params of whatever provided.
> > >
> > > >
> > > > If we do end up killing this warning, I'd still prefer to use
> > > > uninitialized_var() over zero-initializing the variable.
> > > >
> > > > [1] https://lkml.kernel.org/r/20200218184756.242904-1-oupton@google.com
> > > > [2] https://bugzilla.kernel.org/show_bug.cgi?id=207173
> > >
> > > OK, I didn't know this is a known problem and discussions going on.  But I
> > > guess it would be good to address this sooner because it could become a common
> > > warning very soon after people upgrades gcc.
> >
> > Ya, others are hitting this as well.  It's especially painful with the
> > existence of KVM_WERROR.
> >
> > Paolo, any preference on how to resolve this?  It would appear GCC 10 got
> > "smarter".
> 
> Seems that doing absolutely nothing was the fix here :) See:
> 
> 78a5255ffb6a ("Stop the ad-hoc games with -Wno-maybe-initialized")

Ah, perfect!  Thanks Oliver.
