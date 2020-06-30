Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E6020FBAD
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 20:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390773AbgF3S0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 14:26:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22262 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729953AbgF3S0f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 14:26:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593541594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p61xyNRgf2HheJSE7oFI5c3zNSqwXuASgPjQkDl0Ai0=;
        b=Kcs+3BM/HhU0MxsqyMpODFsnP2OUb7NTOqbJtpZLyq8CVaZf5SpDejPsCswhpoPyXv6iXC
        CuYUzuByJZksx/8XoBXExtMfKwfjr/bm2Bs7vwGyULYXGzVmQOBHA1aS7GVXWtXyfJzHhG
        7HMZcf7pp9RqG7rVLj/Qq29vBW3TUvQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-8NN3KgUaOF6j2mCdXgeW9w-1; Tue, 30 Jun 2020 14:26:32 -0400
X-MC-Unique: 8NN3KgUaOF6j2mCdXgeW9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AFBC8AF870;
        Tue, 30 Jun 2020 18:26:10 +0000 (UTC)
Received: from horse.redhat.com (ovpn-113-245.rdu2.redhat.com [10.10.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33E2B10023A6;
        Tue, 30 Jun 2020 18:25:43 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id BC56B222E23; Tue, 30 Jun 2020 14:25:42 -0400 (EDT)
Date:   Tue, 30 Jun 2020 14:25:42 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, virtio-fs@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault
 error
Message-ID: <20200630182542.GA328891@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
> and over.

Sure. But what are the chances of that happening. Say our cache size is
64. That means we need atleast 128 processes to do co-ordinated faults
(all in error zone) to skip the cache completely all the time. We
have to hit cache only once. Chances of missing the error gnf
cache completely for a very long time are very slim. And if we miss
it few times, now harm done. We will just spin few times and then
exit to qemu.

IOW, chances of spinning infinitely are not zero. But they look so
small that in practice I am not worried about it.

> Maybe we can punch a hole in EPT/NPT making the PFN reserved/
> not-present so when the guest tries to access it again we trap the
> access in KVM and, if the error persists, don't follow the APF path?

Cache solution seems simpler than this. Trying to maintain any state
in page tables will be invariably more complex (Especially given
many flavors of paging).

I can start looking in this direction if you really think that its worth
implementing  page table based solution for this problem. I feel that
we implement something simpler for now and if there are easy ways
to skip error gns, then replace it with something page table based
solution (This will only require hypervisor change and no guest
changes).

Vivek

