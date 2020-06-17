Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C195D1FD951
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 01:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgFQXAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 19:00:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:17508 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgFQXAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 19:00:55 -0400
IronPort-SDR: ZP5ih+tSDC9aIPn8fcL28dzYCbZLfEIZyHBv83oZJv50oWFo49SHcFgwTM1ZBzpk/LwGuqFhRa
 LAc7VoTl7p2Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 16:00:52 -0700
IronPort-SDR: 39B39cA4AVab78uxbf5UfZhQfSRnar/nbAc7NerzD2ThDDe6rK8i+r58mbEplD94DGvJWfV/aX
 Nvs1n5nUlT/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,523,1583222400"; 
   d="scan'208";a="317662996"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Jun 2020 16:00:52 -0700
Date:   Wed, 17 Jun 2020 16:00:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, virtio-fs@redhat.com,
        miklos@szeredi.hu, stefanha@redhat.com, dgilbert@redhat.com,
        pbonzini@redhat.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kvm: Add capability to be able to report async pf
 error to guest
Message-ID: <20200617230052.GB27751@linux.intel.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
 <20200616214847.24482-3-vgoyal@redhat.com>
 <87lfklhm58.fsf@vitty.brq.redhat.com>
 <20200617183224.GK26818@linux.intel.com>
 <20200617215152.GF26770@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617215152.GF26770@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 05:51:52PM -0400, Vivek Goyal wrote:
> > And, it's not clear that the optimizations are necessary, e.g. I assume the
> > virtio-fs truncation scenario is relatively uncommon, i.e. not performance
> > sensitive?
> 
> As of now this scenario is less common but with virtio-fs this truncation
> can become more common. A file can be truncated on host or by another
> guest. Its a full filesystem. And most of the time filesystem will
> try to cope with it but invariably there will be some cases where
> user space/kernel space will try to load/store to a page which got
> truncated.  And in that case, guest can do error handling much 
> better as long as we can inject error back into guest.
> 
> For process, we can send SIGBUS and for kernel access, a special
> version of memcpy_mcsafe() equivalent will be used which simply
> return -EIO to user space. 
> 
> So these optimizations make sense to me because guest can continue
> to work instead of dying when error occurs.

By "optimization" I meant avoiding an exit to host userspace.  Not killing
the guest is not an optimization, it's a full on new paravirt feature.

> > > > This patch adds another state to async page fault logic which allows
> > > > host to return error to guest. Once guest knows that async page fault
> > > > can't be resolved, it can send SIGBUS to host process (if user space
> > 
> > I assume this is supposed to be "it can send SIGBUS to guest process"?
> > Otherwise none of this makes sense (to me).
> 
> Yes, I meant SIGBUS to guest process (and not host process). Its a typo.
> 
> > 
> > > > was accessing the page in question).
> > 
> > Allowing the guest to opt-in to intercepting host page allocation failures
> > feels wrong, and fragile.  KVM can't possibly know whether an allocation
> > failure is something that should be forwarded to the guest, as KVM doesn't
> > know the physical backing for any given hva/gfn, e.g. the error could be
> > due to a physical device failure or a configuration issue.  Relying on the
> > async #PF mechanism to prevent allocation failures from crashing the guest
> > is fragile because there is no guarantee that a #PF can be async.
> > 
> 
> Actually it is it does not necessarily have to be async #PF. What we
> are missing right now, is a synchronous method to report errors back.
> And once that is available (#VE), then we can use that instead. So
> if KVM decides to do synchrous fault, we can inject error using #VE
> otherwise use interrupt based APF READY.
> 
> IOW, we are not necessarily relying on #PF being async. For now if
> page fault is sync and error happens, we will exit to qemu and
> VM will freeze/die.
> 
> > IMO, the virtio-fs truncation use case should first be addressed in a way
> > that requires explicit userspace intervention, e.g. by enhancing
> > kvm_handle_bad_page() to provide the necessary information to userspace so
> > that userspace can reflect select errors into the guest.
> 
> Which errors do you want to filter out. And this does not take away
> filtering capability. When we figure out what needs to be filtered
> out, we can do something like kvm_send_hwpoison_signal() to signal
> to user space and not exit to user space with error.

What I'm saying is that KVM cannot do the filtering.  KVM, by design, does
not know what lies behind any given hva, or what the associated gpa maps to
in the guest.  As is, userspace can't even opt out of this behavior, e.g.
it can't even "filter" on a per-VM granularity, since kvm_pv_enable_async_pf()
unconditionally allows the guest to enable the behavior[*].

Doing something similar to kvm_send_hwpoison_signal() would be fine, just
so long as userspace has full control over what to do in response to a
failure.

[*] Not technically true, as kvm_pv_enable_async_pf() explicitly prevents
setting bit 4, which is used in this RFC.  But, assuming that unrelated
code didn't exist, host userspace couldn't prevent this behavior.

> Anway, so we executed async page fault which did get_user_pages_remote()
> and populated page tables. Now we check for completion can call
> kvm_arch_async_page_ready() which will call into direct_page_fault()
> and try_async_pf() and handle_abnormal_pfn(). I think we could
> capture the error from kvm_arch_async_page_ready() also. That way
> handle_abnormal_pfn() will be able to filter it out and do out
> of band action (like poisoned pages) and page_present() will not
> inject error in guest.
> 
> > The reflection
> > could piggyback whatever vector is used by async page faults (#PF or #VE),
> > but would not be an async page fault per se.  If an async #PF happens to
> > encounter an allocation failure, it would naturally fall back to the
> > synchronous path (provided by patch 1/3) and the synchronous path would
> > automagically handle the error as above.
> 
> We could do that as well. So you are suggesting that instead of reporting
> error in async PF PAGE_READY event. Instead send PAGE_READY and upon retry
> path force sync page fault and then report error using new race free
> vector (#VE). 

Yes.  Though what I'm really saying is that the "send PAGE_READY and upon
retry path force sync page fault" should be the _only_ required behavior
from an async #PF perspective.

> We don't have that vector yet though and given the conversation it might
> not be simple to implement that. 
> 
> I had played with using MCE also to inject errors as Andy had suggested
> but this error can happen on store path too and MCEs are not generated
> on store path. So this is not suitable either.
> 
> > 
> > In other words, I think the guest should be able to enable "error handling"
> > support without first enabling async #PF.  From a functional perspective it
> > probably won't change a whole lot, but it would hopefully force us to
> > concoct an overall "paravirt page fault" design as opposed to simply async
> > #PF v2.
> 
> I am not sure how independent these two can be. Even if there was
> a separate way to enable error handling, one will have to opt in
> in async pf V2 to report errors because shared data between host
> and guest will change accordingly. So we probably will end up
> electing for error reporting at two places. One a generic method
> and then also at async PF level.
> 
> Or maybe we we can choose to never report errors using async PF
> protocol. Always choose suboptimal implementation of retrying
> the fault and inject errors *always* using that new vector( #VE).

Yes, this latter idea is the point I'm trying to make.  Async #PF could be
enhanced to support error injection, but the error injection should be
fully functional with or without async #PF being enabled.
