Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C4D1FD7EE
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 23:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgFQVwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 17:52:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36870 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726761AbgFQVwF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 17:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592430723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lxtiXw5MdeRDVFVmV5vkv+J69xJIlCmVFoX39V6/l8o=;
        b=f0NrUJaKV3sJlMlijUPsd3K7KXz8akMLY48Ko3BRgWealSBGZsvTIErMpfgkFYyzl61xXu
        HFtXcFwda9NvPNk9BaYqVBDq0CYAT7OyCoTdIc1h1zXYbSFbOyKlNYr6uoWhZEgPeJebOo
        XvBTJ3XhiJlEHrBRuSoWojC/ve2wd5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-qVzUVJzZMIObV1xeoW-vWw-1; Wed, 17 Jun 2020 17:52:01 -0400
X-MC-Unique: qVzUVJzZMIObV1xeoW-vWw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3EF51800D42;
        Wed, 17 Jun 2020 21:51:59 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0242119931;
        Wed, 17 Jun 2020 21:51:53 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 775F922363A; Wed, 17 Jun 2020 17:51:52 -0400 (EDT)
Date:   Wed, 17 Jun 2020 17:51:52 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, virtio-fs@redhat.com,
        miklos@szeredi.hu, stefanha@redhat.com, dgilbert@redhat.com,
        pbonzini@redhat.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kvm: Add capability to be able to report async pf
 error to guest
Message-ID: <20200617215152.GF26770@redhat.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
 <20200616214847.24482-3-vgoyal@redhat.com>
 <87lfklhm58.fsf@vitty.brq.redhat.com>
 <20200617183224.GK26818@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617183224.GK26818@linux.intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 11:32:24AM -0700, Sean Christopherson wrote:
> On Wed, Jun 17, 2020 at 03:12:03PM +0200, Vitaly Kuznetsov wrote:
> > Vivek Goyal <vgoyal@redhat.com> writes:
> > 
> > > As of now asynchronous page fault mecahanism assumes host will always be
> > > successful in resolving page fault. So there are only two states, that
> > > is page is not present and page is ready.
> > >
> > > If a page is backed by a file and that file has been truncated (as
> > > can be the case with virtio-fs), then page fault handler on host returns
> > > -EFAULT.
> > >
> > > As of now async page fault logic does not look at error code (-EFAULT)
> > > returned by get_user_pages_remote() and returns PAGE_READY to guest.
> > > Guest tries to access page and page fault happnes again. And this
> > > gets kvm into an infinite loop. (Killing host process gets kvm out of
> > > this loop though).
> 
> Isn't this already fixed by patch 1/3 "kvm,x86: Force sync fault if previous
> attempts failed"?  If it isn't, it should be, i.e. we should fix KVM before
> adding what are effectively optimizations on top.

Yes you are right. It is now fixed by patch 1. I wrote changelog first
and later I changed the order of patches and forgot to fix the changelog.

So yes, with previous patch we will not exit to qemu with -EFAULT or
any other error code.

This patch improves upon it and when possible injects error into guest
so that guest can handle it.

> And, it's not clear that
> the optimizations are necessary, e.g. I assume the virtio-fs truncation
> scenario is relatively uncommon, i.e. not performance sensitive?

As of now this scenario is less common but with virtio-fs this truncation
can become more common. A file can be truncated on host or by another
guest. Its a full filesystem. And most of the time filesystem will
try to cope with it but invariably there will be some cases where
user space/kernel space will try to load/store to a page which got
truncated.  And in that case, guest can do error handling much 
better as long as we can inject error back into guest.

For process, we can send SIGBUS and for kernel access, a special
version of memcpy_mcsafe() equivalent will be used which simply
return -EIO to user space. 

So these optimizations make sense to me because guest can continue
to work instead of dying when error occurs.

> 
> > >
> > > This patch adds another state to async page fault logic which allows
> > > host to return error to guest. Once guest knows that async page fault
> > > can't be resolved, it can send SIGBUS to host process (if user space
> 
> I assume this is supposed to be "it can send SIGBUS to guest process"?
> Otherwise none of this makes sense (to me).

Yes, I meant SIGBUS to guest process (and not host process). Its a typo.

> 
> > > was accessing the page in question).
> 
> Allowing the guest to opt-in to intercepting host page allocation failures
> feels wrong, and fragile.  KVM can't possibly know whether an allocation
> failure is something that should be forwarded to the guest, as KVM doesn't
> know the physical backing for any given hva/gfn, e.g. the error could be
> due to a physical device failure or a configuration issue.  Relying on the
> async #PF mechanism to prevent allocation failures from crashing the guest
> is fragile because there is no guarantee that a #PF can be async.
> 

Actually it is it does not necessarily have to be async #PF. What we
are missing right now, is a synchronous method to report errors back.
And once that is available (#VE), then we can use that instead. So
if KVM decides to do synchrous fault, we can inject error using #VE
otherwise use interrupt based APF READY.

IOW, we are not necessarily relying on #PF being async. For now if
page fault is sync and error happens, we will exit to qemu and
VM will freeze/die.

> IMO, the virtio-fs truncation use case should first be addressed in a way
> that requires explicit userspace intervention, e.g. by enhancing
> kvm_handle_bad_page() to provide the necessary information to userspace so
> that userspace can reflect select errors into the guest.

Which errors do you want to filter out. And this does not take away
filtering capability. When we figure out what needs to be filtered
out, we can do something like kvm_send_hwpoison_signal() to signal
to user space and not exit to user space with error.

Havind said that, I see that currently the way code is written, we
capture the error and will inject it in guest if guest opted for
it.

kvm_check_async_pf_completion() {
	kvm_arch_async_page_ready();
	kvm_arch_async_page_present();
}

I really don't understand what's the significance of
kvm_arch_async_page_ready(). Why does it go all they way into
try_async_pf() and why does it set prefault=1.

Anway, so we executed async page fault which did get_user_pages_remote()
and populated page tables. Now we check for completion can call
kvm_arch_async_page_ready() which will call into direct_page_fault()
and try_async_pf() and handle_abnormal_pfn(). I think we could
capture the error from kvm_arch_async_page_ready() also. That way
handle_abnormal_pfn() will be able to filter it out and do out
of band action (like poisoned pages) and page_present() will not
inject error in guest.

> The reflection
> could piggyback whatever vector is used by async page faults (#PF or #VE),
> but would not be an async page fault per se.  If an async #PF happens to
> encounter an allocation failure, it would naturally fall back to the
> synchronous path (provided by patch 1/3) and the synchronous path would
> automagically handle the error as above.

We could do that as well. So you are suggesting that instead of reporting
error in async PF PAGE_READY event. Instead send PAGE_READY and upon retry
path force sync page fault and then report error using new race free
vector (#VE). 

We don't have that vector yet though and given the conversation it might
not be simple to implement that. 

I had played with using MCE also to inject errors as Andy had suggested
but this error can happen on store path too and MCEs are not generated
on store path. So this is not suitable either.

> 
> In other words, I think the guest should be able to enable "error handling"
> support without first enabling async #PF.  From a functional perspective it
> probably won't change a whole lot, but it would hopefully force us to
> concoct an overall "paravirt page fault" design as opposed to simply async
> #PF v2.

I am not sure how independent these two can be. Even if there was
a separate way to enable error handling, one will have to opt in
in async pf V2 to report errors because shared data between host
and guest will change accordingly. So we probably will end up
electing for error reporting at two places. One a generic method
and then also at async PF level.

Or maybe we we can choose to never report errors using async PF
protocol. Always choose suboptimal implementation of retrying
the fault and inject errors *always* using that new vector( #VE).

Thanks
Vivek

