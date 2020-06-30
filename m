Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A9420F8D8
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 17:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389742AbgF3Pu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 11:50:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:52450 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389713AbgF3Pu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 11:50:29 -0400
IronPort-SDR: tNKuzThQwY3jQSYMgU4YKtFQIpr9E8A6xlyRGq7LsvSwgBJZzc66HpMFa2FVAHyv1uK7EwtvHy
 WcX7akqYu2MQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="125909724"
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="125909724"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 08:50:28 -0700
IronPort-SDR: QF/MRvdhYms7+o6OEPYKC9JYa4HPh+KMes6JLQP3Ubxbq8cZg4M3WugwBLg8YVpcvme04Adq/F
 BJSW8Ryl3obQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="312404815"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 30 Jun 2020 08:50:28 -0700
Date:   Tue, 30 Jun 2020 08:50:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
        virtio-fs@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault
 error
Message-ID: <20200630155028.GE7733@linux.intel.com>
References: <20200625214701.GA180786@redhat.com>
 <87lfkach6o.fsf@vitty.brq.redhat.com>
 <20200626150303.GC195150@redhat.com>
 <874kqtd212.fsf@vitty.brq.redhat.com>
 <20200629220353.GC269627@redhat.com>
 <87sgecbs9w.fsf@vitty.brq.redhat.com>
 <20200630145303.GB322149@redhat.com>
 <87mu4kbn7x.fsf@vitty.brq.redhat.com>
 <20200630152529.GC322149@redhat.com>
 <87k0zobltx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0zobltx.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 30, 2020 at 05:43:54PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Tue, Jun 30, 2020 at 05:13:54PM +0200, Vitaly Kuznetsov wrote:
> >> 
> >> > - If you retry in kernel, we will change the context completely that
> >> >   who was trying to access the gfn in question. We want to retain
> >> >   the real context and retain information who was trying to access
> >> >   gfn in question.
> >> 
> >> (Just so I understand the idea better) does the guest context matter to
> >> the host? Or, more specifically, are we going to do anything besides
> >> get_user_pages() which will actually analyze who triggered the access
> >> *in the guest*?
> >
> > When we exit to user space, qemu prints bunch of register state. I am
> > wondering what does that state represent. Does some of that traces
> > back to the process which was trying to access that hva? I don't
> > know.
> 
> We can get the full CPU state when the fault happens if we need to but
> generally we are not analyzing it. I can imagine looking at CPL, for
> example, but trying to distinguish guest's 'process A' from 'process B'
> may not be simple.
> 
> >
> > I think keeping a cache of error gfns might not be too bad from
> > implemetation point of view. I will give it a try and see how
> > bad does it look.
> 
> Right; I'm only worried about the fact that every cache (or hash) has a
> limited size and under certain curcumstances we may overflow it. When an
> overflow happens, we will follow the APF path again and this can go over
> and over. Maybe we can punch a hole in EPT/NPT making the PFN reserved/
> not-present so when the guest tries to access it again we trap the
> access in KVM and, if the error persists, don't follow the APF path?

Just to make sure I'm somewhat keeping track, is the problem we're trying to
solve that the guest may not immediately retry the "bad" GPA and so KVM may
not detect that the async #PF already came back as -EFAULT or whatever? 
