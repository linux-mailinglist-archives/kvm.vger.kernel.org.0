Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F70F84A8D
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 13:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbfHGLXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 07:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbfHGLXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 07:23:16 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EE7E3C936;
        Wed,  7 Aug 2019 11:23:16 +0000 (UTC)
Received: from gondolin (ovpn-117-166.ams2.redhat.com [10.36.117.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12BA72619E;
        Wed,  7 Aug 2019 11:23:14 +0000 (UTC)
Date:   Wed, 7 Aug 2019 13:23:11 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC UNTESTED] vfio-ccw: indirect access to translated
 cps
Message-ID: <20190807132311.5238bc24.cohuck@redhat.com>
In-Reply-To: <20190730174910.47930494.pasic@linux.ibm.com>
References: <20190726100617.19718-1-cohuck@redhat.com>
        <20190730174910.47930494.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 07 Aug 2019 11:23:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Jul 2019 17:49:10 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Fri, 26 Jul 2019 12:06:17 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > We're currently keeping a single area for translated channel
> > programs in our private structure, which is filled out when
> > we are translating a channel program we have been given by
> > user space and marked invalid again when we received an final
> > interrupt for that I/O.
> > 
> > Unfortunately, properly tracking the lifetime of that cp is
> > not easy: failures may happen during translation or right when
> > it is sent to the hardware, unsolicited interrupts may trigger
> > a deferred condition code, a halt/clear request may be issued
> > while the I/O is supposed to be running, or a reset request may
> > come in from the side. The _PROCESSING state and the ->initialized
> > flag help a bit, but not enough.
> > 
> > We want to have a way to figure out whether we actually have a cp
> > currently in progress, so we can update/free only when applicable.
> > Points to keep in mind:
> > - We will get an interrupt after a cp has been submitted iff ssch
> >   finished with cc 0.
> > - We will get more interrupts for a cp if the interrupt status is
> >   not final.
> > - We can have only one cp in flight at a time.
> > 
> > Let's decouple the actual area in the private structure from the
> > means to access it: Only after we have successfully submitted a
> > cp (ssch with cc 0), update the pointer in the private structure
> > to point to the area used. Therefore, the interrupt handler won't
> > access the cp if we don't actually expect an interrupt pertaining
> > to it.
> > 
> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > ---
> > 
> > Just hacked this up to get some feedback, did not actually try it
> > out. Not even sure if this is a sensible approach; if not, let's
> > blame it on the heat and pretend it didn't happen :)
> >   
> 
> Do not multiple threads access this new cp pointer (and at least one of
> them writes)? If that is the case, it smells like a data race to me.

We might need some additional concurrent read/write handling on top, if
state machine guarantees are not enough. (We may need a respin of the
state machine locking for that, which we probably want anyway.)

> 
> Besides the only point of converting cp to a pointer seems to be
> policing access to cp_area (which used to be cp). I.e. if it is
> NULL: don't touch it, otherwise: go ahead. We can do that with a single
> bit, we don't need a pointer for that.

The idea was
- do translation etc. on an area only accessed by the thread doing the
  translation
- switch the pointer to that area once the cp has been submitted
  successfully (and it is therefore associated with further interrupts
  etc.)
The approach in this patch is probably a bit simplistic.

I think one bit is not enough, we have at least three states:
- idle; start using the area if you like
- translating; i.e. only the translator is touching the area, keep off
- submitted; we wait for interrupts, handle them or free if no (more)
  interrupts can happen

> 
> Could we convert initialized into some sort of cp.status that
> tracks/controls access and responsibilities? By working with bits we
> could benefit from the atomicity of bit-ops -- if I'm not wrong.

We have both the state of the device (state machine) and the state of a
cp, then. If we keep to a single cp area, we should track that within a
single state (i.e. the device state).

> 
> > I also thought about having *two* translation areas and switching
> > the pointer between them; this might be too complicated, though?  
> 
> We only have one channel program at a time or? I can't see the benefit
> of having two areas.

We can only have one in flight at a time; we could conceivably have
another one that is currently in the process of being built. The idea
was to switch between the two (so processing an in-flight one cannot
overwrite one that is currently being built); but I think this is too
complicated.
