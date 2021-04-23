Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE9F3690D5
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 13:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242128AbhDWLHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 07:07:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhDWLG7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 07:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619175983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HfQWnWr9CmKRH9tH+Uz4v87/VFtM98wfsHwZN4zPllQ=;
        b=PqFbNlVMOWFAGE+HpkfVPkrANpSUPHj1bCAK9ymWSPEXZkJ7+442mGYP5axxu2CZRy3cN6
        s7/qWYgoacObhSW42pyNWPiWQp7Wx2llyKZdnvmbm1XYQxOh6HivnMavDGsCFlDLEIVKYW
        bYF7YYusWqW4PKIUDPLmyLIdJvODedE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-6LDfLT8ENvesyIOO4EVDsA-1; Fri, 23 Apr 2021 07:06:21 -0400
X-MC-Unique: 6LDfLT8ENvesyIOO4EVDsA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9524A107ACCA;
        Fri, 23 Apr 2021 11:06:20 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-167.ams2.redhat.com [10.36.113.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2393E5D9E3;
        Fri, 23 Apr 2021 11:06:18 +0000 (UTC)
Date:   Fri, 23 Apr 2021 13:06:16 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20210423130616.6dcbf4e4.cohuck@redhat.com>
In-Reply-To: <1eb9cbdfe43a42a62f6afb0315bb1e3a103dac9a.camel@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
        <20210422025258.6ed7619d.pasic@linux.ibm.com>
        <1eb9cbdfe43a42a62f6afb0315bb1e3a103dac9a.camel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Apr 2021 16:49:21 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On Thu, 2021-04-22 at 02:52 +0200, Halil Pasic wrote:
> > On Tue, 13 Apr 2021 20:24:06 +0200
> > Eric Farman <farman@linux.ibm.com> wrote:
> >   
> > > Hi Conny, Halil,
> > > 
> > > Let's restart our discussion about the collision between interrupts
> > > for
> > > START SUBCHANNEL and HALT/CLEAR SUBCHANNEL. It's been a quarter
> > > million
> > > minutes (give or take), so here is the problematic scenario again:
> > > 
> > > 	CPU 1			CPU 2
> > >  1	CLEAR SUBCHANNEL
> > >  2	fsm_irq()
> > >  3				START SUBCHANNEL
> > >  4	vfio_ccw_sch_io_todo()
> > >  5				fsm_irq()
> > >  6				vfio_ccw_sch_io_todo()
> > > 
> > > From the channel subsystem's point of view the CLEAR SUBCHANNEL
> > > (step 1)
> > > is complete once step 2 is called, as the Interrupt Response Block
> > > (IRB)
> > > has been presented and the TEST SUBCHANNEL was driven by the cio
> > > layer.
> > > Thus, the START SUBCHANNEL (step 3) is submitted [1] and gets a
> > > cc=0 to
> > > indicate the I/O was accepted. However, step 2 stacks the bulk of
> > > the
> > > actual work onto a workqueue for when the subchannel lock is NOT
> > > held,
> > > and is unqueued at step 4. That code misidentifies the data in the
> > > IRB
> > > as being associated with the newly active I/O, and may release
> > > memory
> > > that is actively in use by the channel subsystem and/or device.
> > > Eww.
> > > 
> > > In this version...
> > > 
> > > Patch 1 and 2 are defensive checks. Patch 2 was part of v3 [2], but
> > > I
> > > would love a better option here to guard between steps 2 and 4.
> > > 
> > > Patch 3 is a subset of the removal of the CP_PENDING FSM state in
> > > v3.
> > > I've obviously gone away from this idea, but I thought this piece
> > > is
> > > still valuable.
> > > 
> > > Patch 4 collapses the code on the interrupt path so that changes to
> > > the FSM state and the channel_program struct are handled at the
> > > same
> > > point, rather than separated by a mutex boundary. Because of the
> > > possibility of a START and HALT/CLEAR running concurrently, it does
> > > not make sense to split them here.
> > > 
> > > With the above patches, maybe it then makes sense to hold the
> > > io_mutex
> > > across the entirety of vfio_ccw_sch_io_todo(). But I'm not
> > > completely
> > > sure that would be acceptable.
> > > 
> > > So... Thoughts?  
> > 
> > I believe we should address  
> 
> Who is the "we" here?
> 
> >  the concurrency, encapsulation and layering
> > issues in the subchannel/ccw pass-through code (vfio-ccw) by taking a
> > holistic approach as soon as possible.

Let me also ask: what is "holistic"? If that's a complete rewrite, I
definitely don't have the capacity for that; if others want to take
over the code, feel free.

> > 
> > I find the current state of art very hard to reason about, and that
> > adversely  affects my ability to reason about attempts at partial
> > improvements.
> > 
> > I understand that such a holistic approach needs a lot of work, and
> > we
> > may have to stop some bleeding first. In the stop the bleeding phase
> > we
> > can take a pragmatic approach and accept changes that empirically
> > seem to
> > work towards stopping the bleeding. I.e. if your tests say it's
> > better,
> > I'm willing to accept that it is better.  
> 
> So much bleeding!
> 
> RE: my tests... I have only been seeing the described problem in
> pathological tests, and this series lets those tests run without issue.

FWIW, I haven't been able to reproduce the problem myself, and I don't
remember seeing other reports. It's still a problem, and if we can get
rid of the issue, good. The reasoning about what is happening makes
sense to me.

> 
> > 
> > I have to admit, I don't understand how synchronization is done in
> > the
> > vfio-ccw kernel module (in the sense of avoiding data races).
> > 
> > Regarding your patches, I have to admit, I have a hard time figuring
> > out
> > which one of these (or what combination of them) is supposed to solve
> > the problem you described above. If I had to guess, I would guess it
> > is
> > either patch 4, because it has a similar scenario diagram in the
> > commit message like the one in the problem statement. Is my guess
> > right?  
> 
> Sort of. It is true that Patch 4 is the last piece of the puzzle, and
> the diagram is included in that commit message so it is kept with the
> change, instead of being lost with the cover letter.
> 
> As I said in the cover letter, "Patch 1 and 2 are defensive checks"
> which are simply included to provide a more robust solution. You could
> argue that Patch 3 should be held out separately, but as it came from
> the previous version of this series it made sense to include here.
> 
> > 
> > If it is right I don't quite understand the mechanics of the fix,
> > because what the patch seems to do is changing the content of step 4
> > in
> > the above diagram. And I don't see how is change that code
> > so that it does not "misidentifies the data in the IRB as being
> > associated with the newly active I/O".   
> 
> Consider that the cp_update_scsw() and cp_free() routines that get
> called here are looking at the cp->initialized flag to determine
> whether to perform any work. For a system that is otherwise idle, the
> cp->initialized flag will be false when processing an IRB related to a
> CSCH, meaning the bulk of this routine will be a NOP.
> 
> In the failing scenario, as I describe in the commit message for patch
> 4, we could be processing an interrupt that is unaffiliated with the CP
> that was (or is being) built. It need not even be a solicited
> interrupt; it just happened that the CSCH interrupt is what got me
> looking at this path. The whole situation boils down to the FSM state
> and cp->initialized flag being out of sync from one another after
> coming through this function.

Nod, that's also my understanding.

> 
> > Moreover patch 4 seems to rely on
> > private->state which, AFAIR is still used in a racy fashion.
> > 
> > But if strong empirical evidence shows that it performs better (stops
> > the bleeding), I think we can go ahead with it.  
> 
> Again with the bleeding. Is there a Doctor in the house? :)

No idea, seen any blue boxes around? :)

