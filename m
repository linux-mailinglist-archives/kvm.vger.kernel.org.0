Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F171D55AA
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 18:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgEOQPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 12:15:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33462 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgEOQPg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 12:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589559333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w6Dw3im+AeacAMiZvf8yC0F13GvlTYhUl8LjrRcL1a8=;
        b=ebzh8CDDHsQtcgrsIo82Nk4gRq3mxhLQPoXfNFMJ7HthA2tTDNzJn8Q9m86TtTrRXdZaDe
        2D7XXWrwCzjDjMkEr+kbtM5t7BL4HOzgoYYZsl+DizxK+mm55NPJniEYQz9IMkIEq7iavB
        XP6KLVtJDkbk8xbw/0eSYiNsi/Xjr3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-kNmdEkAePo-izissdMEJ0g-1; Fri, 15 May 2020 12:15:32 -0400
X-MC-Unique: kNmdEkAePo-izissdMEJ0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1229F83DB37;
        Fri, 15 May 2020 16:15:31 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F91262491;
        Fri, 15 May 2020 16:15:23 +0000 (UTC)
Date:   Fri, 15 May 2020 17:15:21 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v1 01/17] exec: Introduce
 ram_block_discard_set_(unreliable|required)()
Message-ID: <20200515161521.GJ2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-2-david@redhat.com>
 <8dc6cefb-63ee-9310-ce18-abf558a08b39@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dc6cefb-63ee-9310-ce18-abf558a08b39@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> On 06.05.20 11:49, David Hildenbrand wrote:
> > We want to replace qemu_balloon_inhibit() by something more generic.
> > Especially, we want to make sure that technologies that really rely on
> > RAM block discards to work reliably to run mutual exclusive with
> > technologies that break it.
> > 
> > E.g., vfio will usually pin all guest memory, turning the virtio-balloon
> > basically useless and make the VM consume more memory than reported via
> > the balloon. While the balloon is special already (=> no guarantees, same
> > behavior possible afer reboots and with huge pages), this will be
> > different, especially, with virtio-mem.
> > 
> > Let's implement a way such that we can make both types of technology run
> > mutually exclusive. We'll convert existing balloon inhibitors in successive
> > patches and add some new ones. Add the check to
> > qemu_balloon_is_inhibited() for now. We might want to make
> > virtio-balloon an acutal inhibitor in the future - however, that
> > requires more thought to not break existing setups.
> > 
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: Richard Henderson <rth@twiddle.net>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > ---
> >  balloon.c             |  3 ++-
> >  exec.c                | 48 +++++++++++++++++++++++++++++++++++++++++++
> >  include/exec/memory.h | 41 ++++++++++++++++++++++++++++++++++++
> >  3 files changed, 91 insertions(+), 1 deletion(-)
> > 
> > diff --git a/balloon.c b/balloon.c
> > index f104b42961..c49f57c27b 100644
> > --- a/balloon.c
> > +++ b/balloon.c
> > @@ -40,7 +40,8 @@ static int balloon_inhibit_count;
> >  
> >  bool qemu_balloon_is_inhibited(void)
> >  {
> > -    return atomic_read(&balloon_inhibit_count) > 0;
> > +    return atomic_read(&balloon_inhibit_count) > 0 ||
> > +           ram_block_discard_is_broken();
> >  }
> >  
> >  void qemu_balloon_inhibit(bool state)
> > diff --git a/exec.c b/exec.c
> > index 2874bb5088..52a6e40e99 100644
> > --- a/exec.c
> > +++ b/exec.c
> > @@ -4049,4 +4049,52 @@ void mtree_print_dispatch(AddressSpaceDispatch *d, MemoryRegion *root)
> >      }
> >  }
> >  
> > +static int ram_block_discard_broken;
> > +
> > +int ram_block_discard_set_broken(bool state)
> > +{
> > +    int old;
> > +
> > +    if (!state) {
> > +        atomic_dec(&ram_block_discard_broken);
> > +        return 0;
> > +    }
> > +
> > +    do {
> > +        old = atomic_read(&ram_block_discard_broken);
> > +        if (old < 0) {
> > +            return -EBUSY;
> > +        }
> > +    } while (atomic_cmpxchg(&ram_block_discard_broken, old, old + 1) != old);
> > +    return 0;
> > +}
> > +
> > +int ram_block_discard_set_required(bool state)
> > +{
> > +    int old;
> > +
> > +    if (!state) {
> > +        atomic_inc(&ram_block_discard_broken);
> > +        return 0;
> > +    }
> > +
> > +    do {
> > +        old = atomic_read(&ram_block_discard_broken);
> > +        if (old > 0) {
> > +            return -EBUSY;
> > +        }
> > +    } while (atomic_cmpxchg(&ram_block_discard_broken, old, old - 1) != old);
> > +    return 0;
> > +}
> > +
> > +bool ram_block_discard_is_broken(void)
> > +{
> > +    return atomic_read(&ram_block_discard_broken) > 0;
> > +}
> > +
> > +bool ram_block_discard_is_required(void)
> > +{
> > +    return atomic_read(&ram_block_discard_broken) < 0;
> > +}
> > +
> >  #endif
> > diff --git a/include/exec/memory.h b/include/exec/memory.h
> > index e000bd2f97..9bb5ced38d 100644
> > --- a/include/exec/memory.h
> > +++ b/include/exec/memory.h
> > @@ -2463,6 +2463,47 @@ static inline MemOp devend_memop(enum device_endian end)
> >  }
> >  #endif
> >  
> > +/*
> > + * Inhibit technologies that rely on discarding of parts of RAM blocks to work
> > + * reliably, e.g., to manage the actual amount of memory consumed by the VM
> > + * (then, the memory provided by RAM blocks might be bigger than the desired
> > + * memory consumption). This *must* be set if:
> > + * - Discarding parts of a RAM blocks does not result in the change being
> > + *   reflected in the VM and the pages getting freed.
> > + * - All memory in RAM blocks is pinned or duplicated, invaldiating any previous
> > + *   discards blindly.
> > + * - Discarding parts of a RAM blocks will result in integrity issues (e.g.,
> > + *   encrypted VMs).
> > + * Technologies that only temporarily pin the current working set of a
> > + * driver are fine, because we don't expect such pages to be discarded
> > + * (esp. based on guest action like balloon inflation).
> > + *
> > + * This is *not* to be used to protect from concurrent discards (esp.,
> > + * postcopy).
> > + *
> > + * Returns 0 if successful. Returns -EBUSY if a technology that relies on
> > + * discards to work reliably is active.
> > + */
> > +int ram_block_discard_set_broken(bool state);
> > +
> > +/*
> > + * Inhibit technologies that will break discarding of pages in RAM blocks.
> > + *
> > + * Returns 0 if successful. Returns -EBUSY if discards are already set to
> > + * broken.
> > + */
> > +int ram_block_discard_set_required(bool state);
> > +
> > +/*
> > + * Test if discarding of memory in ram blocks is broken.
> > + */
> > +bool ram_block_discard_is_broken(void);
> > +
> > +/*
> > + * Test if discarding of memory in ram blocks is required to work reliably.
> > + */
> > +bool ram_block_discard_is_required(void);
> > +
> >  #endif
> >  
> >  #endif
> > 
> 
> I'm wondering if I'll just call these functions
> 
> ram_block_discard_disable()
> 
> and
> 
> ram_block_discard_require()

Yeh I prefer that.

Dave

> -- 
> Thanks,
> 
> David / dhildenb
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

