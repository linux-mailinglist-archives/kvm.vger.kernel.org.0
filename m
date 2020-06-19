Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BE12007B8
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 13:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgFSLW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 07:22:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42814 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729367AbgFSLWy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 07:22:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592565772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MlNLfk6MrC5X+g01GBrpY2ZuUavYrYrzUNqeJhbH0jk=;
        b=G3/diI3u2fClGwhv7aJTMnI9mWSG6IxXAi//sikMO+LPryFze0vD6z3+xczl8zGIj7nUGr
        qhEkUgL5Xa4/E9K01KGaV2alKDDgnHn1L+MvTkPoBlqy4Voi9mAwBrXH0dthnt4n7Jz9XS
        5qsItpHBnrI+qBBTaC8v9tU0JTsulVE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-0YOueGOuN5qFgYiZRUmTlA-1; Fri, 19 Jun 2020 07:22:50 -0400
X-MC-Unique: 0YOueGOuN5qFgYiZRUmTlA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7BAF800053;
        Fri, 19 Jun 2020 11:22:48 +0000 (UTC)
Received: from gondolin (ovpn-112-224.ams2.redhat.com [10.36.112.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6FE85C1D0;
        Fri, 19 Jun 2020 11:22:47 +0000 (UTC)
Date:   Fri, 19 Jun 2020 13:21:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/3] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20200619132152.59498435.cohuck@redhat.com>
In-Reply-To: <20200616195053.99253-1-farman@linux.ibm.com>
References: <20200616195053.99253-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Jun 2020 21:50:50 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Let's continue our discussion of the handling of vfio-ccw interrupts.
> 
> The initial fix [1] relied upon the interrupt path's examination of the
> FSM state, and freeing all resources if it were CP_PENDING. But the
> interface used by HALT/CLEAR SUBCHANNEL doesn't affect the FSM state.
> Consider this sequence:
> 
>     CPU 1                           CPU 2
>     CLEAR (state=IDLE/no change)
>                                     START [2]
>     INTERRUPT (set state=IDLE)
>                                     INTERRUPT (set state=IDLE)
> 
> This translates to a couple of possible scenarios:
> 
>  A) The START gets a cc2 because of the outstanding CLEAR, -EBUSY is
>     returned, resources are freed, and state remains IDLE
>  B) The START gets a cc0 because the CLEAR has already presented an
>     interrupt, and state is set to CP_PENDING
> 
> If the START gets a cc0 before the CLEAR INTERRUPT (stacked onto a
> workqueue by the IRQ context) gets a chance to run, then the INTERRUPT
> will release the channel program memory prematurely. If the two
> operations run concurrently, then the FSM state set to CP_PROCESSING
> will prevent the cp_free() from being invoked. But the io_mutex
> boundary on that path will pause itself until the START completes,
> and then allow the FSM to be reset to IDLE without considering the
> outstanding START. Neither scenario would be considered good.
> 
> Having said all of that, in v2 Conny suggested [3] the following:
> 
> > - Detach the cp from the subchannel (or better, remove the 1:1
> >   relationship). By that I mean building the cp as a separately
> >   allocated structure (maybe embedding a kref, but that might not be
> >   needed), and appending it to a list after SSCH with cc=0. Discard it
> >   if cc!=0.
> > - Remove the CP_PENDING state. The state is either IDLE after any
> >   successful SSCH/HSCH/CSCH, or a new state in that case. But no
> >   special state for SSCH.
> > - A successful CSCH removes the first queued request, if any.
> > - A final interrupt removes the first queued request, if any.  
> 
> What I have implemented here is basically this, with a few changes:
> 
>  - I don't queue cp's. Since there should only be one START in process
>    at a time, and HALT/CLEAR doesn't build a cp, I didn't see a pressing
>    need to introduce that complexity.
>  - Furthermore, while I initially made a separately allocated cp, adding
>    an alloc for a cp on each I/O AND moving the guest_cp alloc from the
>    probe path to the I/O path seems excessive. So I implemented a
>    "started" flag to the cp, set after a cc0 from the START, and examine
>    that on the interrupt path to determine whether cp_free() is needed.
>  - I opted against a "SOMETHING_PENDING" state if START/HALT/CLEAR
>    got a cc0, and just put the FSM back to IDLE. It becomes too unwieldy
>    to discern which operation an interrupt is completing, and whether
>    more interrupts are expected, to be worth the additional state.
>  - A successful CSCH doesn't do anything special, and cp_free()
>    is only performed on the interrupt path. Part of me wrestled with
>    how a HALT fits into that, but mostly it was that a cc0 on any
>    of the instructions indicated the "channel subsystem is signaled
>    to asynchronously perform the [START/HALT/CLEAR] function."
>    This means that an in-flight START could still receive data from the
>    device/subchannel, so not a good idea to release memory at that point.

Hm, csch clears any pending status, so it is indeed special in a way.
If we do a csch with cc 0, we already know for sure that we won't get
any further status other than an interrupt indicating that clear has
been done. This was my reasoning behind csch dequeuing the request.

> 
> Separate from all that, I added a small check of the io_work queue to
> the FSM START path. Part of the problems I've seen was that an interrupt
> is presented by a CPU, but not yet processed by vfio-ccw. Some of the
> problems seen thus far is because of this gap, and the above changes
> don't address that either. Whether this is appropriate or ridiculous
> would be a welcome discussion.
> 
> Previous versions:
> v2: https://lore.kernel.org/kvm/20200513142934.28788-1-farman@linux.ibm.com/
> v1: https://lore.kernel.org/kvm/20200124145455.51181-1-farman@linux.ibm.com/
> 
> Footnotes:
> [1] https://lore.kernel.org/kvm/62e87bf67b38dc8d5760586e7c96d400db854ebe.1562854091.git.alifm@linux.ibm.com/
> [2] Halil has pointed out that QEMU should prohibit this, based on the
>     rules set forth by the POPs. This is true, but we should not rely on
>     it behaving properly without addressing this scenario that is visible
>     today. Once I get this behaving correctly, I'll spend some time
>     seeing if QEMU is misbehaving somehow.
> [3] https://lore.kernel.org/kvm/20200518180903.7cb21dd8.cohuck@redhat.com/
> [4] https://lore.kernel.org/kvm/a52368d3-8cec-7b99-1587-25e055228b62@linux.ibm.com/
> 
> Eric Farman (3):
>   vfio-ccw: Indicate if a channel_program is started
>   vfio-ccw: Remove the CP_PENDING FSM state
>   vfio-ccw: Check workqueue before doing START
> 
>  drivers/s390/cio/vfio_ccw_cp.c      |  2 ++
>  drivers/s390/cio/vfio_ccw_cp.h      |  1 +
>  drivers/s390/cio/vfio_ccw_drv.c     |  5 +----
>  drivers/s390/cio/vfio_ccw_fsm.c     | 32 +++++++++++++++++------------
>  drivers/s390/cio/vfio_ccw_ops.c     |  3 +--
>  drivers/s390/cio/vfio_ccw_private.h |  1 -
>  6 files changed, 24 insertions(+), 20 deletions(-)
> 

