Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2080214B221
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 10:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgA1J6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 04:58:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54904 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgA1J6c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 04:58:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnQO6zrmhXuovt6QHn24SPSZ5A6McOoHhJb1tVmtEYI=;
        b=GoIRKKHLJDJFPVQ3xXzRu2nKc5ZWASVgAI1i3eaUjSM8YIM11cm6BxLM/9wP+KezCufGRc
        Tk3B7lXigJjmDjFNoqIqsAyafBrsYEI11hZCnUHnxEcxnbQfXdMTGROdMPOxqKKHT3aOuv
        zKRVucpHkW/ZkQhmQ1R62x/8SU1375k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-BfXLG5HaN0OjJKrnKxN5ZQ-1; Tue, 28 Jan 2020 04:58:25 -0500
X-MC-Unique: BfXLG5HaN0OjJKrnKxN5ZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D0E813F0;
        Tue, 28 Jan 2020 09:58:24 +0000 (UTC)
Received: from gondolin (ovpn-116-186.ams2.redhat.com [10.36.116.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E77F19C58;
        Tue, 28 Jan 2020 09:58:23 +0000 (UTC)
Date:   Tue, 28 Jan 2020 10:58:20 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 1/1] vfio-ccw: Don't free channel programs for
 unrelated interrupts
Message-ID: <20200128105820.081a4b79.cohuck@redhat.com>
In-Reply-To: <eb3f3887-50f2-ef4d-0b98-b25936047a49@linux.ibm.com>
References: <20200124145455.51181-1-farman@linux.ibm.com>
        <20200124145455.51181-2-farman@linux.ibm.com>
        <20200124163305.3d6f0d47.cohuck@redhat.com>
        <50a0fe00-a7c1-50e4-12f5-412ee7a0e522@linux.ibm.com>
        <20200127135235.1f783f1b.cohuck@redhat.com>
        <eb3f3887-50f2-ef4d-0b98-b25936047a49@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jan 2020 16:28:18 -0500
Eric Farman <farman@linux.ibm.com> wrote:

> On 1/27/20 7:52 AM, Cornelia Huck wrote:
> > On Fri, 24 Jan 2020 11:08:12 -0500
> > Eric Farman <farman@linux.ibm.com> wrote:
> >   
> >> On 1/24/20 10:33 AM, Cornelia Huck wrote:  
> >>> On Fri, 24 Jan 2020 15:54:55 +0100
> >>> Eric Farman <farman@linux.ibm.com> wrote:  
> >   
> >>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> >>>> index e401a3d0aa57..a8ab256a217b 100644
> >>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
> >>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> >>>> @@ -90,8 +90,8 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
> >>>>  	is_final = !(scsw_actl(&irb->scsw) &
> >>>>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
> >>>>  	if (scsw_is_solicited(&irb->scsw)) {
> >>>> -		cp_update_scsw(&private->cp, &irb->scsw);
> >>>> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> >>>> +		if (cp_update_scsw(&private->cp, &irb->scsw) &&
> >>>> +		    is_final && private->state == VFIO_CCW_STATE_CP_PENDING)    
> >>>
> >>> ...but I still wonder why is_final is not catching non-ssch related
> >>> interrupts, as I thought it would. We might want to adapt that check,
> >>> instead. (Or was the scsw_is_solicited() check supposed to catch that?
> >>> As said, too tired right now...)    
> >>
> >> I had looked at the (un)solicited bits at one point, and saw very few
> >> unsolicited interrupts.  The ones that did show up didn't appear to
> >> affect things in the way that would cause the problems I'm seeing.  
> > 
> > Ok, so that check is hopefully fine.
> >   
> >>
> >> As for is_final...  That POPS table states that for "status pending
> >> [alone] after termination of HALT or CLEAR ... cpa is unpredictable",
> >> which is what happens here.  In the example above, the cpa is the same
> >> as the previous (successful) interrupt, and thus unrelated to the
> >> current chain.  Perhaps is_final needs to check that the function
> >> control in the interrupt is for a start?  
> > 
> > I think our reasoning last time we discussed this function was that we
> > only are in CP_PENDING if we actually did a ssch previously. Now, if we  
> 
> I spent a little time looking at the conversations on the patch that
> added the CP_PENDING check.  Sadly, those patches hit the list when I
> left for holiday so I came late to those discussions and there appears
> some loose ends that I should've chased down at the time.  Sorry.
> 
> But yes, we should only be in CP_PENDING because of the SSCH, but the
> only check of the interrupt here is the "is_final" check, and not that
> the interrupt was for a start function.

Hm. If we are in CP_PENDING, we have issued a ssch in the past for
which we did not get a final state yet. So getting here in CP_STANDING
without the start function set in the fctl would indicate a bug
elsewhere (missing state transition, or a thinko?)

> 
> > do a hsch/csch before we got final status for the program started by
> > the ssch, we don't move out of the CP_PENDING, but the cpa still might
> > not be what we're looking for.   
> 
> As long as we get an interrupt that's "is_final" then don't we come out
> of CP_PENDING state at the end of this routine, regardless of whether or
> not it does the cp_free() call?  I think your original diagnosis [1] was
> that even if the cpa is invalid, calling cp_update_scsw() is okay
> because garbage-in-garbage-out.  This patch makes that part of the
> criteria for doing the cp_free(), so maybe that's too heavy?  After all,
> it does mean that we may leave private->cp "initialized", but reset the
> state back to IDLE.  (More on that in a minute.)

Yes, rereading this I still think it's fine to call cp_update_scsw().

If we did a clear, we will certainly not get any more solicited
interrupts for this subchannel before we initiate a new operation. I
think that also holds for hsch? So we probably should free and move
state... but it seems we're still missing something.

> 
> > So, we should probably check that we
> > have only the start function indicated in the fctl.  
> 
> For the call to cp_update_scsw() or cp_free()?  Or both?

As said above, we probably don't need to do that... but I'm not sure.

> 
> > 
> > But if we do that, we still have a chain allocated for something that
> > has already been terminated... how do we find the right chain to clean
> > up, if needed?  
> 
> Don't we free all/none of the chains?  Ideally, since we only have one
> set of chains per cp (and thus, per SSCH), they should either all be
> freed or ignored.

Ah, yes. I reread the code, and I think you're correct.

> 
> But regardless, this patch is at least not complete, if not incorrect.
> I left a test running for the weekend and while I don't see the storage
> damage I saw before, there's a lot of unreleased memory because of stuff
> like this:
> 
> 950.541644 06 ...sch_io_todo sch 09c5: state=3 orb.cpa=7f586f48

We're in CP_PROCESSING? Maybe that's the problem? We got an interrupt
while still setting up the cp...

>                                                irb.w0=00001001

That's an interrupt for a csch, if I'm counting the bits right. I'm
wondering what sequence in the guest gets us here: If we're
CP_PROCESSING, we're still interpreting the ssch (and have not yet
returned control to the guest again). Still, there's an interrupt for a
csch... either the guest does not lock subchannel operations correctly
(so that it did a csch while another cpu did a ssch), or it did a ssch
without waiting for the interrupt for a csch. Or, of course,
something's completely messed up on the vfio-ccw side. As Linux seems
to run fine as a guest elsewhere, I rather suspect vfio-ccw :(

>                                                irb.cpa=02e35d58

That's... weird. Probably the "unpredictable" part of an interrupt for
a clear :)

>                                                irb.w2=0000000c

The count is not meaningful for an interrupt for a clear, either.

>                                                ccw=0
>                                                *cda=0
> 950.541837 06 ...sch_io_todo sch 09c5: state=2 orb.cpa=030ec750
>                                                irb.w0=00c04007
>                                                irb.cpa=7f586f50
>                                                irb.w2=0c000000
>                                                ccw=3424000c030ea840
>                                                *cda=190757ef0

That one looks like a normal interrupt for a channel program; but why
are we in IDLE?

> 
> (I was only tracing instances where vfio-ccw did NOT call cp_free() on
> the interrupt path; so I don't have a complete history of what happened.)
> 
> The orb.cpa address in the first trace looks like something which came
> from the guest, rather than something built by vfio-ccw.  The irb.cpa
> address in the second trace is 8 bytes after the first orb.cpa address.
> And the storage referenced by both the CP and IDAL referenced in trace 2
> are still active when I started poking at the state of things.
> 
> There's a lot just to unravel just with this instance.  Like why a guest
> CPA is in orb, and thus an irb.  Or why cp_prefetch() checks that
> !cp->initialized, but cp_init() does no such thing.  I guess I'll put in
> a check to see how that helps this particular situation, while I sort
> out the other problems here.

cp_init checking cp->initialized would probably be good to catch
errors, in any case. (Maybe put a trace there, just to see if it fires?)

I'm wondering if we're looking at the right part of the code. After
rereading, I think the interrupt handling code is ok... it seems
something goes wrong earlier (looking at that weird first trace).

Have you seen this without your path handling changes? The thing that
probably exposes the problem is that path validation etc. might do some
extra csch, and also some extra I/O restricted to a certain path.

> 
> >   
> 
> [1] https://lore.kernel.org/kvm/20190702115134.790f8891.cohuck@redhat.com/
> 

