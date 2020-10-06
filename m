Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5AB2850CA
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgJFR2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 13:28:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbgJFR2l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 13:28:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602005319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wqrPuKYcvN3AHluRTjmmIKpi9e8SscqeWEpVovkcGa4=;
        b=evIwa8WcOrITSrFtHUcP8ioE+j9LUqgRJ/Fa4aj8MXmprmXcSMVNz5J1it1hSHHT4mJr8A
        x9eVbdT12vHQO7ID7lft0qJXA6tFilFrpKObBIxQsdjeYFvPe0b3Iidl37DMernq0EoEFv
        mULf1NGqnHSo/LrkT/tjtNDzKxm5u3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-rK7lJLgJOw2-SXm9xxHDIQ-1; Tue, 06 Oct 2020 13:28:37 -0400
X-MC-Unique: rK7lJLgJOw2-SXm9xxHDIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC7CE108E1A1;
        Tue,  6 Oct 2020 17:28:36 +0000 (UTC)
Received: from horse.redhat.com (ovpn-117-72.rdu2.redhat.com [10.10.117.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69CA43A40;
        Tue,  6 Oct 2020 17:28:33 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id EDF21220AD7; Tue,  6 Oct 2020 13:28:32 -0400 (EDT)
Date:   Tue, 6 Oct 2020 13:28:32 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Virtio-fs] [PATCH v4] kvm, x86: Exit to user space in case page
 fault error
Message-ID: <20201006172832.GF5306@redhat.com>
References: <20201006134629.GB5306@redhat.com>
 <877ds38n6r.fsf@vitty.brq.redhat.com>
 <20201006141501.GC5306@redhat.com>
 <874kn78l2z.fsf@vitty.brq.redhat.com>
 <20201006150817.GD5306@redhat.com>
 <871rib8ji1.fsf@vitty.brq.redhat.com>
 <20201006161200.GB17610@linux.intel.com>
 <87y2kj71gj.fsf@vitty.brq.redhat.com>
 <20201006171704.GC17610@linux.intel.com>
 <20201006172148.GI3000@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006172148.GI3000@work-vm>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 06:21:48PM +0100, Dr. David Alan Gilbert wrote:
> * Sean Christopherson (sean.j.christopherson@intel.com) wrote:
> > On Tue, Oct 06, 2020 at 06:39:56PM +0200, Vitaly Kuznetsov wrote:
> > > Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > > 
> > > > On Tue, Oct 06, 2020 at 05:24:54PM +0200, Vitaly Kuznetsov wrote:
> > > >> Vivek Goyal <vgoyal@redhat.com> writes:
> > > >> > So you will have to report token (along with -EFAULT) to user space. So this
> > > >> > is basically the 3rd proposal which is extension of kvm API and will
> > > >> > report say HVA/GFN also to user space along with -EFAULT.
> > > >> 
> > > >> Right, I meant to say that guest kernel has full register state of the
> > > >> userspace process which caused APF to get queued and instead of trying
> > > >> to extract it in KVM and pass to userspace in case of a (later) failure
> > > >> we limit KVM api change to contain token or GFN only and somehow keep
> > > >> the rest in the guest. This should help with TDX/SEV-ES.
> > > >
> > > > Whatever gets reported to userspace should be identical with and without
> > > > async page faults, i.e. it definitely shouldn't have token information.
> > > >
> > > 
> > > Oh, right, when the error gets reported synchronously guest's kernel is
> > > not yet aware of the issue so it won't be possible to find anything in
> > > its kdump if userspace decides to crash it immediately. The register
> > > state (if available) will be actual though.
> > > 
> > > > Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
> > > > into the guest is not an option.  
> > > 
> > > Not even #MC? So sad :-)
> > 
> > Heh, #MC isn't allowed either, yet...
> > 
> > > > Nor do I think that's "correct" behavior (see everyone's objections to
> > > > using #PF for APF fixed).  I.e. the event should probably be an IRQ.
> > > 
> > > I recall Paolo objected against making APF 'page not present' into in
> > > interrupt as it will require some very special handling to make sure it
> > > gets injected (and handled) immediately but I'm not really sure how big
> > > the hack is going to be, maybe in the light of TDX/SEV-ES it's worth a
> > > try.
> > 
> > This shouldn't have anything to do with APF.  Again, the event injection is
> > needed even in the synchronous case as the file truncation in the host can
> > affect existing mappings in the guest.
> > 
> > I don't know that the mechanism needs to be virtiofs specific or if there can
> > be a more generic "these PFNs have disappeared", but it's most definitely
> > orthogonal to APF.
> 
> There are other cases we get 'these PFNs have disappeared' other than
> virtiofs;  the classic is when people back the guest using a tmpfs that
> then runs out of room.

I also played with nvdimm driver where device was backed a file on host.
If I truncate that file, we face similar issues.

https://lore.kernel.org/kvm/20200616214847.24482-1-vgoyal@redhat.com/

I think any resource which can be backed by a file on host, can
potentially run into this issue if file is truncated.
(if guest can do load/store on these pages directly). 

Thanks
Vivek

