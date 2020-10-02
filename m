Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03E5281C00
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 21:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388474AbgJBT1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 15:27:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbgJBT1n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 15:27:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601666861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AluZbmdSHvTUeq+jAjMYrv397RTUgpSdXrYzowWOHjI=;
        b=ETrzfSrHSP+UGOvOnSY8qv0Dxqh5ecqi9LIiUtF9h2t0Xp5DhJn2Ni0DJWUKkSHP1SwT2N
        FDWaSdMDL3qEJO2+VVPexsJbHlzdVOwOgYI+xjKtceu13b2+36M+Gvj/csC4E9XA66fkWy
        948OnlvLRyQrY898MkdLcr+4GvNydPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-8rmzyweMMxmvNWuKaqcxdQ-1; Fri, 02 Oct 2020 15:27:40 -0400
X-MC-Unique: 8rmzyweMMxmvNWuKaqcxdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95248425E8;
        Fri,  2 Oct 2020 19:27:38 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-130.rdu2.redhat.com [10.10.115.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C1CA60BE2;
        Fri,  2 Oct 2020 19:27:35 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E8AC5224B7D; Fri,  2 Oct 2020 15:27:34 -0400 (EDT)
Date:   Fri, 2 Oct 2020 15:27:34 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201002192734.GD3119@redhat.com>
References: <20200720211359.GF502563@redhat.com>
 <20200929043700.GL31514@linux.intel.com>
 <20201001215508.GD3522@redhat.com>
 <20201001223320.GI7474@linux.intel.com>
 <20201002153854.GC3119@redhat.com>
 <20201002183036.GB24460@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002183036.GB24460@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 11:30:37AM -0700, Sean Christopherson wrote:
> On Fri, Oct 02, 2020 at 11:38:54AM -0400, Vivek Goyal wrote:
> > On Thu, Oct 01, 2020 at 03:33:20PM -0700, Sean Christopherson wrote:
> > > Alternatively, what about adding a new KVM request type to handle this?
> > > E.g. when the APF comes back with -EFAULT, snapshot the GFN and make a
> > > request.  The vCPU then gets kicked and exits to userspace.  Before exiting
> > > to userspace, the request handler resets vcpu->arch.apf.error_gfn.  Bad GFNs
> > > simply get if error_gfn is "valid", i.e. there's a pending request.
> > 
> > Sorry, I did not understand the above proposal. Can you please elaborate
> > a bit more. Part of it is that I don't know much about KVM requests.
> > Looking at the code it looks like that main loop is parsing if some
> > kvm request is pending and executing that action.
> > 
> > Don't we want to make sure that we exit to user space when guest retries
> > error gfn access again.
> 
> > In this case once we get -EFAULT, we will still inject page_ready into
> > guest. And then either same process or a different process might run. 
> > 
> > So when exactly code raises a kvm request. If I raise it right when
> > I get -EFAULT, then kvm will exit to user space upon next entry
> > time. But there is no guarantee guest vcpu is running the process which
> > actually accessed the error gfn. And that probably means that register
> > state of cpu does not mean much and one can not easily figure out
> > which task tried to access the bad memory and when.
> > 
> > That's why we prepare a list of error gfn and only exit to user space
> > when error_gfn access is retried so that guest vcpu context is correct.
> > 
> > What am I missing?
> 
> I don't think it's necessary to provide userspace with the register state of
> the guest task that hit the bad page.  Other than debugging, I don't see how
> userspace can do anything useful which such information.

I think debugging is the whole point so that user can figure out which
access by guest task resulted in bad memory access. I would think this
will be important piece of information.

> 
> Even if you want to inject an event of some form into the guest, having the
> correct context for the event itself is not required.  IMO it's perfectly
> reasonable for such an event to be asynchronous.
> 
> IIUC, your end goal is to be able to gracefully handle DAX file truncation.
> Simply killing the guest task that hit the bad page isn't sufficient, as
> nothing prevents a future task from accessing the same bad page.

Next task can't even mmap that page mmap will fail. File got truncated,
that page does not exist. 

So sending SIGBUS to task should definitely solve the problem. We also
need to solve the issue for guest kernel accessing the page which got
truncated on host. In that case we need to use correct memcpy helpers
and use exception table magic and return error code to user space.

> To fully
> handle the situation, the guest needs to remove the bad page from its memory
> pool.  Once the page is offlined, the guest kernel's error handling will
> kick in when a task accesses the bad page (or nothing ever touches the bad
> page again and everyone is happy).

This is not really a case of bad page as such. It is more of a page
gone missing/trucated. And no new user can map it. We just need to
worry about existing users who already have it mapped.

> 
> Note, I'm not necessarily suggesting that QEMU piggyback its #MC injection
> to handle this, but I suspect the resulting behavior will look quite similar,
> e.g. notify the virtiofs driver in the guest, which does some magic to take
> the offending region offline, and then guest tasks get SIGBUS or whatever.
> 
> I also don't think it's KVM's responsibility to _directly_ handle such a
> scenario.  As I said in an earlier version, KVM can't possibly know _why_ a
> page fault came back with -EFAULT, only userspace can connect the dots of
> GPA -> HVA -> vm_area_struct -> file -> inject event.  KVM definitely should
> exit to userspace on the -EFAULT instead of hanging the guest, but that can
> be done via a new request, as suggested.

KVM atleast should have the mechanism to report this back to guest. And
we don't have any. There only seems to be #MC stuff for poisoned pages.
I am not sure how much we can build on top of #MC stuff to take care
of this case. One problem with #MC I found was that it generates
synchronous #MC only on load and not store. So all the code is
written in such a way that synchronous #MC can happen only on load
and hence the error handling. 

Stores generate different kind of #MC that too asynchronously and
caller will not know about it immiditely. But in this case we need
to know about error in the context of caller both for loads and stores.

Anyway, I agree that this patch does not solve the problem of race
free synchronous event inject into the guest. That's something yet
to be solved either by #VE or by #MC or by #foo.

This patch is only doing two things.

- Because we don't have a mechanism to report errors to guest, use
  the second best method and exit to user space.

- Make behavior consistent between synchronous fault and async faults.
  Currently sync faults exit to user space on error while async
   faults spin infinitely.

Once we have a method to report errors back to guest, then we first
should report error back to guest. And only in the absense of such
mechanism we should exit to user space.

Thanks
Vivek

