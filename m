Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4271785D17
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 10:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbfHHInO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 04:43:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbfHHInN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 04:43:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CFCCB305B41C;
        Thu,  8 Aug 2019 08:43:09 +0000 (UTC)
Received: from gondolin (dhcp-192-181.str.redhat.com [10.33.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E00A560BE1;
        Thu,  8 Aug 2019 08:43:08 +0000 (UTC)
Date:   Thu, 8 Aug 2019 10:43:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC UNTESTED] vfio-ccw: indirect access to translated
 cps
Message-ID: <20190808104306.2450bdcf.cohuck@redhat.com>
In-Reply-To: <20190807160136.178e69de.pasic@linux.ibm.com>
References: <20190726100617.19718-1-cohuck@redhat.com>
        <20190730174910.47930494.pasic@linux.ibm.com>
        <20190807132311.5238bc24.cohuck@redhat.com>
        <20190807160136.178e69de.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 08 Aug 2019 08:43:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Aug 2019 16:01:36 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Wed, 7 Aug 2019 13:23:11 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Tue, 30 Jul 2019 17:49:10 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >   
> > > On Fri, 26 Jul 2019 12:06:17 +0200
> > > Cornelia Huck <cohuck@redhat.com> wrote:
> > >   
> > > > We're currently keeping a single area for translated channel
> > > > programs in our private structure, which is filled out when
> > > > we are translating a channel program we have been given by
> > > > user space and marked invalid again when we received an final
> > > > interrupt for that I/O.
> > > > 
> > > > Unfortunately, properly tracking the lifetime of that cp is
> > > > not easy: failures may happen during translation or right when
> > > > it is sent to the hardware, unsolicited interrupts may trigger
> > > > a deferred condition code, a halt/clear request may be issued
> > > > while the I/O is supposed to be running, or a reset request may
> > > > come in from the side. The _PROCESSING state and the ->initialized
> > > > flag help a bit, but not enough.
> > > > 
> > > > We want to have a way to figure out whether we actually have a cp
> > > > currently in progress, so we can update/free only when applicable.
> > > > Points to keep in mind:
> > > > - We will get an interrupt after a cp has been submitted iff ssch
> > > >   finished with cc 0.
> > > > - We will get more interrupts for a cp if the interrupt status is
> > > >   not final.
> > > > - We can have only one cp in flight at a time.
> > > > 
> > > > Let's decouple the actual area in the private structure from the
> > > > means to access it: Only after we have successfully submitted a
> > > > cp (ssch with cc 0), update the pointer in the private structure
> > > > to point to the area used. Therefore, the interrupt handler won't
> > > > access the cp if we don't actually expect an interrupt pertaining
> > > > to it.
> > > > 
> > > > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > > > ---
> > > > 
> > > > Just hacked this up to get some feedback, did not actually try it
> > > > out. Not even sure if this is a sensible approach; if not, let's
> > > > blame it on the heat and pretend it didn't happen :)
> > > >     
> > > 
> > > Do not multiple threads access this new cp pointer (and at least one of
> > > them writes)? If that is the case, it smells like a data race to me.  
> > 
> > We might need some additional concurrent read/write handling on top, if
> > state machine guarantees are not enough. (We may need a respin of the
> > state machine locking for that, which we probably want anyway.)
> >   
> 
> A respin of what? If you mean Pierre's "vfio: ccw: Make FSM functions
> atomic" (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1711466.html)
> that won't work any more because of async.

s/respin/rework/, more likely.

> 
> > > 
> > > Besides the only point of converting cp to a pointer seems to be
> > > policing access to cp_area (which used to be cp). I.e. if it is
> > > NULL: don't touch it, otherwise: go ahead. We can do that with a single
> > > bit, we don't need a pointer for that.  
> > 
> > The idea was
> > - do translation etc. on an area only accessed by the thread doing the
> >   translation
> > - switch the pointer to that area once the cp has been submitted
> >   successfully (and it is therefore associated with further interrupts
> >   etc.)
> > The approach in this patch is probably a bit simplistic.
> > 
> > I think one bit is not enough, we have at least three states:
> > - idle; start using the area if you like
> > - translating; i.e. only the translator is touching the area, keep off
> > - submitted; we wait for interrupts, handle them or free if no (more)
> >   interrupts can happen  
> 
> I think your patch assigns the pointer when transitioning from
> translated --> submitted. That can be tracked with a single bit, that's
> what I was trying to say. You seem to have misunderstood: I never
> intended to claim that a single bit is sufficient to get this clean (only
> to accomplish what the pointer accomplishes -- modulo races).
> 
> My impression was that the 'initialized' field is abut the idle -->
> translating transition, but I never fully understood this 'initialized'
> patch.

So we do have three states here, right? (I hope we're not talking past
each other again...)

> 
> >   
> > > 
> > > Could we convert initialized into some sort of cp.status that
> > > tracks/controls access and responsibilities? By working with bits we
> > > could benefit from the atomicity of bit-ops -- if I'm not wrong.  
> > 
> > We have both the state of the device (state machine) and the state of a
> > cp, then. If we keep to a single cp area, we should track that within a
> > single state (i.e. the device state).
> >   
> 
> Maybe. Maybe not. I would have to write or see the code to figure that
> out. Would we need additional states introduced to the device (state
> machine)?

We might, but I don't think so. My point is that we probably want to
track on a device level and not introduce extra tracking.

> 
> Anyway we do need to fix the races in the device state machine
> for sure. I've already provided some food for thought (in form of a draft
> patch) to Eric.

Any chance you could post that patch? :)

> 
> > >   
> > > > I also thought about having *two* translation areas and switching
> > > > the pointer between them; this might be too complicated, though?    
> > > 
> > > We only have one channel program at a time or? I can't see the benefit
> > > of having two areas.  
> > 
> > We can only have one in flight at a time; we could conceivably have
> > another one that is currently in the process of being built. The idea
> > was to switch between the two (so processing an in-flight one cannot
> > overwrite one that is currently being built); but I think this is too
> > complicated.
> >   
> 
> I suppose the subchannel as seen by the guest should have FC 'start' bit
> before the first translation (processing) starts. Please have a look at
> the PoP if you don't agree. I.e. the translation/processing should be
> considered a part of the asynchronous start function at the channel
> subsystem, that is, from the guest perspective, that channel program is
> already 'in flight'. So it does not make sense to me, to start
> translating another cp.
> 
> Yes, the current implementation does the translation in instruction
> context, and not as a part of the async io function. IMHO that is at
> least sub-optimal if not wrong. QEMU however sets SCSW_FCTL_START_FUNC
> before calling css_do_ssch(), but that should not be guest observable,
> because of BQL. That also means QEMU won't try to issue the next cp
> before the previous one was processed by vfio-ccw (submitted via ssch or
> rejected) because of BQL. And then SCSW_FCTL_START_FUNC should prevent
> acceptance of the next one while the previous one is still relevant.

These are basically all implementation details; as long as we present
something to the guest that does not contradict what is specified in
the PoP, we should be fine. I.e. we could pre-build new cps if we end
up presenting a consistent state to the guest in all cases. But I don't
think we want to go that way.

> 
> TL;DR I don't think having two cp areas make sense.

Let's stop going down that way further, I agree.
