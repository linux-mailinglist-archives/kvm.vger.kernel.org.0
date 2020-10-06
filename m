Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822BE284CAF
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgJFNqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 09:46:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbgJFNqk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 09:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601991998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cfRavjoFjpVYow5g6GANBDu/ddRusDzHcHdXr7NgCLc=;
        b=O6mINS4zTY1mDFXyZNQxeno+Nln+NiTbQ3VlmNBHKseJqE7rU/nSKZTf++I93QYfMQzyZs
        b3kw/dgMgqYPSdZ7eOzOj54tsL/4eQ8S8xXlnFfOEA6knXV1E7gs4W1Xt1aDkxmjlbrx5U
        jc0RR10qj9sE53og3RR9sZNMCtg21ZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-6XIYramKNHK8Y3XmZaVOaw-1; Tue, 06 Oct 2020 09:46:34 -0400
X-MC-Unique: 6XIYramKNHK8Y3XmZaVOaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A60F802B45;
        Tue,  6 Oct 2020 13:46:33 +0000 (UTC)
Received: from horse.redhat.com (ovpn-117-72.rdu2.redhat.com [10.10.117.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B681376640;
        Tue,  6 Oct 2020 13:46:29 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 464ED220AD7; Tue,  6 Oct 2020 09:46:29 -0400 (EDT)
Date:   Tue, 6 Oct 2020 09:46:29 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201006134629.GB5306@redhat.com>
References: <20201001215508.GD3522@redhat.com>
 <20201001223320.GI7474@linux.intel.com>
 <20201002153854.GC3119@redhat.com>
 <20201002183036.GB24460@linux.intel.com>
 <20201002192734.GD3119@redhat.com>
 <20201002194517.GD24460@linux.intel.com>
 <20201002200214.GB10232@redhat.com>
 <20201002211314.GE24460@linux.intel.com>
 <20201005153318.GA4302@redhat.com>
 <20201005161620.GC11938@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005161620.GC11938@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05, 2020 at 09:16:20AM -0700, Sean Christopherson wrote:
> On Mon, Oct 05, 2020 at 11:33:18AM -0400, Vivek Goyal wrote:
> > On Fri, Oct 02, 2020 at 02:13:14PM -0700, Sean Christopherson wrote:
> > Now I have few questions.
> > 
> > - If we exit to user space asynchronously (using kvm request), what debug
> >   information is in there which tells user which address is bad. I admit
> >   that even above trace does not seem to be telling me directly which
> >   address (HVA?) is bad.
> > 
> >   But if I take a crash dump of guest, using above information I should
> >   be able to get to GPA which is problematic. And looking at /proc/iomem
> >   it should also tell which device this memory region is in.
> > 
> >   Also using this crash dump one should be able to walk through virtiofs data
> >   structures and figure out which file and what offset with-in file does
> >   it belong to. Now one can look at filesystem on host and see file got
> >   truncated and it will become obvious it can't be faulted in. And then
> >   one can continue to debug that how did we arrive here.
> > 
> > But if we don't exit to user space synchronously, Only relevant
> > information we seem to have is -EFAULT. Apart from that, how does one
> > figure out what address is bad, or who tried to access it. Or which
> > file/offset does it belong to etc.
> >
> > I agree that problem is not necessarily in guest code. But by exiting
> > synchronously, it gives enough information that one can use crash
> > dump to get to bottom of the issue. If we exit to user space
> > asynchronously, all this information will be lost and it might make
> > it very hard to figure out (if not impossible), what's going on.
> 
> If we want userspace to be able to do something useful, KVM should explicitly
> inform userspace about the error, userspace shouldn't simply assume that
> -EFAULT means a HVA->PFN lookup failed.

I guess that's fine. But for this patch, user space is not doing anything.
Its just printing error -EFAULT and dumping guest state (Same as we do
in case of synchronous fault).

> Userspace also shouldn't have to
> query guest state to handle the error, as that won't work for protected guests
> guests like SEV-ES and TDX.

So qemu would not be able to dump vcpu register state when kvm returns
with -EFAULT for the case of SEV-ES and TDX?

> 
> I can think of two options:
> 
>   1. Send a signal, a la kvm_send_hwpoison_signal().

This works because -EHWPOISON is a special kind of error which is
different from -EFAULT. For truncation, even kvm gets -EFAULT.

        if (vm_fault & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
                return (foll_flags & FOLL_HWPOISON) ? -EHWPOISON : -EFAULT;
        if (vm_fault & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV))
                return -EFAULT;

Anyway, if -EFAULT is too generic, and we need something finer grained,
that can be looked into when we actually have a method where kvm/qemu
injects error into guest.

> 
>   2. Add a userspace exit reason along with a new entry in the run struct,
>      e.g. that provides the bad GPA, HVA, possibly permissions, etc...

This sounds more reasonable to me. That is kvm gives additional
information to qemu about failing HVA and GPA with -EFAULT and that
can be helpful in debugging a problem. This seems like an extension
of KVM API.

Even with this, if we want to figure out which file got truncated, we
will need to take a dump of guest and try to figure out which file
this GPA is currently mapping(By looking at virtiofs data structures).
And that becomes little easier if vcpu is running the task which 
accessed that GPA. Anyway, if we have failing GPA, I think it should
be possible to figure out inode even without accessing task being
current on vcpu.

So we seem to have 3 options.

A. Just exit to user space with -EFAULT (using kvm request) and don't
   wait for the accessing task to run on vcpu again. 

B. Store error gfn in an hash and exit to user space when task accessing
   gfn runs again.

C. Extend KVM API and report failing HVA/GFN access by guest. And that
   should allow not having to exit to user space synchronously.

Thanks
Vivek

