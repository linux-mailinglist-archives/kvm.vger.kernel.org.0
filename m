Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EBD2850AE
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgJFRWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 13:22:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgJFRWD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 13:22:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602004922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X0lONWzOnePFJIrNQc2veqXgojAyC9dQiRR6DMgiXz8=;
        b=LA8uokwQdWFJ8lTg1bEoeRHwzqs3QPmn5eDBKUbyhzsyaL7WRo2KGzFeZhGToQzoqqk9+Z
        2g+A+thzIrmv5wClWuBVHNdUuSzSHGzSiN+QWJ0eqdiMWccJbfOHtkBoG2sp3Wji1XSojt
        Q19WQyvOguDWJvBRZPJJMci9lmTyng8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-GFRTdZ1xMxae7fnP5YnmZg-1; Tue, 06 Oct 2020 13:21:57 -0400
X-MC-Unique: GFRTdZ1xMxae7fnP5YnmZg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFFFC1009440;
        Tue,  6 Oct 2020 17:21:56 +0000 (UTC)
Received: from work-vm (ovpn-114-216.ams2.redhat.com [10.36.114.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F2CF5C1BD;
        Tue,  6 Oct 2020 17:21:51 +0000 (UTC)
Date:   Tue, 6 Oct 2020 18:21:48 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Virtio-fs] [PATCH v4] kvm, x86: Exit to user space in case page
 fault error
Message-ID: <20201006172148.GI3000@work-vm>
References: <20201005161620.GC11938@linux.intel.com>
 <20201006134629.GB5306@redhat.com>
 <877ds38n6r.fsf@vitty.brq.redhat.com>
 <20201006141501.GC5306@redhat.com>
 <874kn78l2z.fsf@vitty.brq.redhat.com>
 <20201006150817.GD5306@redhat.com>
 <871rib8ji1.fsf@vitty.brq.redhat.com>
 <20201006161200.GB17610@linux.intel.com>
 <87y2kj71gj.fsf@vitty.brq.redhat.com>
 <20201006171704.GC17610@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006171704.GC17610@linux.intel.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Sean Christopherson (sean.j.christopherson@intel.com) wrote:
> On Tue, Oct 06, 2020 at 06:39:56PM +0200, Vitaly Kuznetsov wrote:
> > Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > 
> > > On Tue, Oct 06, 2020 at 05:24:54PM +0200, Vitaly Kuznetsov wrote:
> > >> Vivek Goyal <vgoyal@redhat.com> writes:
> > >> > So you will have to report token (along with -EFAULT) to user space. So this
> > >> > is basically the 3rd proposal which is extension of kvm API and will
> > >> > report say HVA/GFN also to user space along with -EFAULT.
> > >> 
> > >> Right, I meant to say that guest kernel has full register state of the
> > >> userspace process which caused APF to get queued and instead of trying
> > >> to extract it in KVM and pass to userspace in case of a (later) failure
> > >> we limit KVM api change to contain token or GFN only and somehow keep
> > >> the rest in the guest. This should help with TDX/SEV-ES.
> > >
> > > Whatever gets reported to userspace should be identical with and without
> > > async page faults, i.e. it definitely shouldn't have token information.
> > >
> > 
> > Oh, right, when the error gets reported synchronously guest's kernel is
> > not yet aware of the issue so it won't be possible to find anything in
> > its kdump if userspace decides to crash it immediately. The register
> > state (if available) will be actual though.
> > 
> > > Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
> > > into the guest is not an option.  
> > 
> > Not even #MC? So sad :-)
> 
> Heh, #MC isn't allowed either, yet...
> 
> > > Nor do I think that's "correct" behavior (see everyone's objections to
> > > using #PF for APF fixed).  I.e. the event should probably be an IRQ.
> > 
> > I recall Paolo objected against making APF 'page not present' into in
> > interrupt as it will require some very special handling to make sure it
> > gets injected (and handled) immediately but I'm not really sure how big
> > the hack is going to be, maybe in the light of TDX/SEV-ES it's worth a
> > try.
> 
> This shouldn't have anything to do with APF.  Again, the event injection is
> needed even in the synchronous case as the file truncation in the host can
> affect existing mappings in the guest.
> 
> I don't know that the mechanism needs to be virtiofs specific or if there can
> be a more generic "these PFNs have disappeared", but it's most definitely
> orthogonal to APF.

There are other cases we get 'these PFNs have disappeared' other than
virtiofs;  the classic is when people back the guest using a tmpfs that
then runs out of room.

Dave

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

