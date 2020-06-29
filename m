Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D3220E31B
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 00:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbgF2VL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 17:11:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726862AbgF2S6o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Jun 2020 14:58:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593457123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g9ydLVQMHLpiwgJzbCuOG/U4qTMtJl/5BUCD+66wtdg=;
        b=jHdR793XyiLaCQ+kTVc9o4qVxPxJn1dxbRJCpmFpbZYT0CVB5/sv+GOFtXl+889Xfadwqa
        1ouViZ9vVv+Hf53VtVwPjcRP6uACoyBT9GZWKJljYYa9Stvt5j3S/II6gN6R3uVg5rCemb
        PPrRJeXMpiWbx/DDLS1pdY5lu/5//kw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-JKUZuHhOOOKpBBdsF6hI9Q-1; Mon, 29 Jun 2020 10:56:33 -0400
X-MC-Unique: JKUZuHhOOOKpBBdsF6hI9Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B40CA1052517;
        Mon, 29 Jun 2020 14:56:32 +0000 (UTC)
Received: from gondolin (ovpn-113-61.ams2.redhat.com [10.36.113.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E91160C81;
        Mon, 29 Jun 2020 14:56:31 +0000 (UTC)
Date:   Mon, 29 Jun 2020 16:56:29 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/3] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20200629165629.24f21585.cohuck@redhat.com>
In-Reply-To: <5ae6151b-31de-eca6-2917-4e23ecd4f0df@linux.ibm.com>
References: <20200616195053.99253-1-farman@linux.ibm.com>
        <5ae6151b-31de-eca6-2917-4e23ecd4f0df@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 17 Jun 2020 07:24:17 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 6/16/20 3:50 PM, Eric Farman wrote:
> > Let's continue our discussion of the handling of vfio-ccw interrupts.
> > 
> > The initial fix [1] relied upon the interrupt path's examination of the
> > FSM state, and freeing all resources if it were CP_PENDING. But the
> > interface used by HALT/CLEAR SUBCHANNEL doesn't affect the FSM state.
> > Consider this sequence:
> > 
> >     CPU 1                           CPU 2
> >     CLEAR (state=IDLE/no change)
> >                                     START [2]
> >     INTERRUPT (set state=IDLE)
> >                                     INTERRUPT (set state=IDLE)
> > 
> > This translates to a couple of possible scenarios:
> > 
> >  A) The START gets a cc2 because of the outstanding CLEAR, -EBUSY is
> >     returned, resources are freed, and state remains IDLE
> >  B) The START gets a cc0 because the CLEAR has already presented an
> >     interrupt, and state is set to CP_PENDING
> > 
> > If the START gets a cc0 before the CLEAR INTERRUPT (stacked onto a
> > workqueue by the IRQ context) gets a chance to run, then the INTERRUPT
> > will release the channel program memory prematurely. If the two
> > operations run concurrently, then the FSM state set to CP_PROCESSING
> > will prevent the cp_free() from being invoked. But the io_mutex
> > boundary on that path will pause itself until the START completes,
> > and then allow the FSM to be reset to IDLE without considering the
> > outstanding START. Neither scenario would be considered good.
> > 
> > Having said all of that, in v2 Conny suggested [3] the following:
> >   
> >> - Detach the cp from the subchannel (or better, remove the 1:1
> >>   relationship). By that I mean building the cp as a separately
> >>   allocated structure (maybe embedding a kref, but that might not be
> >>   needed), and appending it to a list after SSCH with cc=0. Discard it
> >>   if cc!=0.
> >> - Remove the CP_PENDING state. The state is either IDLE after any
> >>   successful SSCH/HSCH/CSCH, or a new state in that case. But no
> >>   special state for SSCH.
> >> - A successful CSCH removes the first queued request, if any.
> >> - A final interrupt removes the first queued request, if any.  
> > 
> > What I have implemented here is basically this, with a few changes:
> > 
> >  - I don't queue cp's. Since there should only be one START in process
> >    at a time, and HALT/CLEAR doesn't build a cp, I didn't see a pressing
> >    need to introduce that complexity.
> >  - Furthermore, while I initially made a separately allocated cp, adding
> >    an alloc for a cp on each I/O AND moving the guest_cp alloc from the
> >    probe path to the I/O path seems excessive. So I implemented a
> >    "started" flag to the cp, set after a cc0 from the START, and examine
> >    that on the interrupt path to determine whether cp_free() is needed.  
> 
> FYI... After a day or two of running, I sprung a kernel debug oops for
> list corruption in ccwchain_free(). I'm going to blame this piece, since
> it was the last thing I changed and I hadn't come across any such damage
> since v2. So either "started" is a bad idea, or a broken one. Or both. :)

Have you come to any conclusion wrt 'started'? Not wanting to generate
stress, just asking :)

