Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611C1281C83
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgJBUCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:02:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgJBUCX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:02:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601668941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cmmt6ukcvMZBYZywRswM35DlTDZ0Ae8+OR9cm9+v1p8=;
        b=QI3gijQJJ9B+0YJoiMH0GrAPiXse6rvn0JppxJmJ6Ce9u3UlWR/KGfQXpaUjY/zOEHJmo0
        e0QcxwkixDYYe9OKKPEXVvBlZus1tV4iK050+S4pIAWA/mIcYawpOvIcxPyFo+3Gm0nDKo
        JQrQYQJfLxhdwixAUxtXCxMc4o01tY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-tupgEu_OM4CswgZR7ONbqA-1; Fri, 02 Oct 2020 16:02:19 -0400
X-MC-Unique: tupgEu_OM4CswgZR7ONbqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44992640A9;
        Fri,  2 Oct 2020 20:02:18 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-130.rdu2.redhat.com [10.10.115.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3A195D9D5;
        Fri,  2 Oct 2020 20:02:14 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4F6A1224B7D; Fri,  2 Oct 2020 16:02:14 -0400 (EDT)
Date:   Fri, 2 Oct 2020 16:02:14 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201002200214.GB10232@redhat.com>
References: <20200720211359.GF502563@redhat.com>
 <20200929043700.GL31514@linux.intel.com>
 <20201001215508.GD3522@redhat.com>
 <20201001223320.GI7474@linux.intel.com>
 <20201002153854.GC3119@redhat.com>
 <20201002183036.GB24460@linux.intel.com>
 <20201002192734.GD3119@redhat.com>
 <20201002194517.GD24460@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002194517.GD24460@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 12:45:18PM -0700, Sean Christopherson wrote:
> On Fri, Oct 02, 2020 at 03:27:34PM -0400, Vivek Goyal wrote:
> > On Fri, Oct 02, 2020 at 11:30:37AM -0700, Sean Christopherson wrote:
> > > On Fri, Oct 02, 2020 at 11:38:54AM -0400, Vivek Goyal wrote:
> > > > On Thu, Oct 01, 2020 at 03:33:20PM -0700, Sean Christopherson wrote:
> > > > > Alternatively, what about adding a new KVM request type to handle this?
> > > > > E.g. when the APF comes back with -EFAULT, snapshot the GFN and make a
> > > > > request.  The vCPU then gets kicked and exits to userspace.  Before exiting
> > > > > to userspace, the request handler resets vcpu->arch.apf.error_gfn.  Bad GFNs
> > > > > simply get if error_gfn is "valid", i.e. there's a pending request.
> > > > 
> > > > Sorry, I did not understand the above proposal. Can you please elaborate
> > > > a bit more. Part of it is that I don't know much about KVM requests.
> > > > Looking at the code it looks like that main loop is parsing if some
> > > > kvm request is pending and executing that action.
> > > > 
> > > > Don't we want to make sure that we exit to user space when guest retries
> > > > error gfn access again.
> > > 
> > > > In this case once we get -EFAULT, we will still inject page_ready into
> > > > guest. And then either same process or a different process might run. 
> > > > 
> > > > So when exactly code raises a kvm request. If I raise it right when
> > > > I get -EFAULT, then kvm will exit to user space upon next entry
> > > > time. But there is no guarantee guest vcpu is running the process which
> > > > actually accessed the error gfn. And that probably means that register
> > > > state of cpu does not mean much and one can not easily figure out
> > > > which task tried to access the bad memory and when.
> > > > 
> > > > That's why we prepare a list of error gfn and only exit to user space
> > > > when error_gfn access is retried so that guest vcpu context is correct.
> > > > 
> > > > What am I missing?
> > > 
> > > I don't think it's necessary to provide userspace with the register state of
> > > the guest task that hit the bad page.  Other than debugging, I don't see how
> > > userspace can do anything useful which such information.
> > 
> > I think debugging is the whole point so that user can figure out which
> > access by guest task resulted in bad memory access. I would think this
> > will be important piece of information.
> 
> But isn't this failure due to a truncation in the host?  Why would we care
> about debugging the guest?  It hasn't done anything wrong, has it?  Or am I
> misunderstanding the original problem statement.

I think you understood problem statement right. If guest has right
context, it just gives additional information who tried to access
the missing memory page. 

> 
> > > To fully handle the situation, the guest needs to remove the bad page from
> > > its memory pool.  Once the page is offlined, the guest kernel's error
> > > handling will kick in when a task accesses the bad page (or nothing ever
> > > touches the bad page again and everyone is happy).
> > 
> > This is not really a case of bad page as such. It is more of a page
> > gone missing/trucated. And no new user can map it. We just need to
> > worry about existing users who already have it mapped.
> 
> What do you mean by "no new user can map it"?  Are you talking about guest
> tasks or host tasks?  If guest tasks, how would the guest know the page is
> missing and thus prevent mapping the non-existent page?

If a new task wants mmap(), it will send a request to virtiofsd/qemu
on host. If file has been truncated, then mapping beyond file size
will fail and process will get error.  So they will not be able to
map a page which has been truncated.

> 
> > > Note, I'm not necessarily suggesting that QEMU piggyback its #MC injection
> > > to handle this, but I suspect the resulting behavior will look quite similar,
> > > e.g. notify the virtiofs driver in the guest, which does some magic to take
> > > the offending region offline, and then guest tasks get SIGBUS or whatever.
> > > 
> > > I also don't think it's KVM's responsibility to _directly_ handle such a
> > > scenario.  As I said in an earlier version, KVM can't possibly know _why_ a
> > > page fault came back with -EFAULT, only userspace can connect the dots of
> > > GPA -> HVA -> vm_area_struct -> file -> inject event.  KVM definitely should
> > > exit to userspace on the -EFAULT instead of hanging the guest, but that can
> > > be done via a new request, as suggested.
> > 
> > KVM atleast should have the mechanism to report this back to guest. And
> > we don't have any. There only seems to be #MC stuff for poisoned pages.
> > I am not sure how much we can build on top of #MC stuff to take care
> > of this case. One problem with #MC I found was that it generates
> > synchronous #MC only on load and not store. So all the code is
> > written in such a way that synchronous #MC can happen only on load
> > and hence the error handling. 
> > 
> > Stores generate different kind of #MC that too asynchronously and
> > caller will not know about it immiditely. But in this case we need
> > to know about error in the context of caller both for loads and stores.
> > 
> > Anyway, I agree that this patch does not solve the problem of race
> > free synchronous event inject into the guest. That's something yet
> > to be solved either by #VE or by #MC or by #foo.
> > 
> > This patch is only doing two things.
> > 
> > - Because we don't have a mechanism to report errors to guest, use
> >   the second best method and exit to user space.
> 
> Not that it matters at this point, but IMO exiting to userspace is the
> correct behavior, not simply "second best method".  Again, KVM by design
> does not know what lies behind any given HVA, and therefore should not be
> making decisions about how to handle bad HVAs.
>  
> > - Make behavior consistent between synchronous fault and async faults.
> >   Currently sync faults exit to user space on error while async
> >    faults spin infinitely.
> 
> Yes, and this part can be done with a new request type.  Adding a new
> request doesn't commit KVM to any ABI changes, e.g. userspace will still
> see an -EFAULT return, and nothing more.  I.e. handling this via request
> doesn't prevent switching to synchronous exits in the future, if such a
> feature is required.

I am really not sure what benfit this kvm request is bringing to the
table. To me maintaining a hash table and exiting when guest retries
is much nicer desgin. In fact, once we have the mechanism to
inject error into the guest using an exception, We can easily plug
that into the same path.

If memory usage is a concern, we can reduce the hash table size to say
4 or 8.

How is this change commiting KVM to an ABI?

> 
> > Once we have a method to report errors back to guest, then we first
> > should report error back to guest. And only in the absense of such
> > mechanism we should exit to user space.
> 
> I don't see the value in extending KVM's ABI to avoid the exit to userspace.
> E.g. we could add a memslot flag to autoreflect -EFAULT as an event of some
> form, but this is a slow path, the extra time should be a non-issue.

IIUC, you are saying that this becomes the property of memory region. Some
memory regions can choose their errors being reported back to guest
(using some kind of flag in memslot). And in the absense of such flag,
default behavior will continue to be exit to user space?

I guess that's fine if we don't want to treat all the memory areas in
same way. I can't think why reporting errors for all areas to guest
is a bad idea. Let guest either handle the error or die if it can't
handle it. But that discussion is for some other day. Our first problem
is that we don't have a race free mechanism to report errors.

Thanks
Vivek

