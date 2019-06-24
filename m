Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D45A505FA
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 11:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfFXJmg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Jun 2019 05:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbfFXJmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 05:42:36 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 724F88F91C;
        Mon, 24 Jun 2019 09:42:35 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58E845C221;
        Mon, 24 Jun 2019 09:42:34 +0000 (UTC)
Date:   Mon, 24 Jun 2019 11:42:31 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing
 a channel program
Message-ID: <20190624114231.2d81e36f.cohuck@redhat.com>
In-Reply-To: <56ced048-8c66-a030-af35-8afbbd2abea8@linux.ibm.com>
References: <cover.1561055076.git.alifm@linux.ibm.com>
        <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
        <638804dc-53c0-ff2f-d123-13c257ad593f@linux.ibm.com>
        <581d756d-7418-cd67-e0e8-f9e4fe10b22d@linux.ibm.com>
        <2d9c04ba-ee50-2f9b-343a-5109274ff52d@linux.ibm.com>
        <56ced048-8c66-a030-af35-8afbbd2abea8@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 24 Jun 2019 09:42:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Jun 2019 14:34:10 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 06/21/2019 01:40 PM, Eric Farman wrote:
> > 
> > 
> > On 6/21/19 10:17 AM, Farhan Ali wrote:  
> >>
> >>
> >> On 06/20/2019 04:27 PM, Eric Farman wrote:  
> >>>
> >>>
> >>> On 6/20/19 3:40 PM, Farhan Ali wrote:  
> >>>> There is a small window where it's possible that an interrupt can
> >>>> arrive and can call cp_free, while we are still processing a channel
> >>>> program (i.e allocating memory, pinnging pages, translating  
> >>>
> >>> s/pinnging/pinning/
> >>>  
> >>>> addresses etc). This can lead to allocating and freeing at the same
> >>>> time and can cause memory corruption.
> >>>>
> >>>> Let's not call cp_free if we are currently processing a channel program.  
> >>>
> >>> The check around this cp_free() call is for a solicited interrupt, so
> >>> it's presumably in response to a SSCH we issued.  But if we're still
> >>> processing a CP, then we hadn't issued the SSCH to the hardware yet.  So
> >>> what is this interrupt for?  Do the contents of irb.cpa provide any
> >>> clues, perhaps if it's in the current cp or for someone else?
> >>>  
> >>
> >> I don't think the interrupt is in response to an ssch but rather due to
> >> an csch/hsch.

The solicited check only checks if it is solicited. It can be for any
channel I/O instruction that causes an interrupt... we probably should
adapt the check.

> >>  
> >>>>
> >>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> >>>> ---
> >>>>
> >>>> I have been running my test overnight with this patch and I haven't
> >>>> seen the stack traces that I mentioned about earlier. I would like
> >>>> to get some reviews on this and also if this is the right thing to
> >>>> do?
> >>>>
> >>>> Thanks
> >>>> Farhan
> >>>>
> >>>>    drivers/s390/cio/vfio_ccw_drv.c | 2 +-
> >>>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> >>>> b/drivers/s390/cio/vfio_ccw_drv.c
> >>>> index 66a66ac..61ece3f 100644
> >>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
> >>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> >>>> @@ -88,7 +88,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct
> >>>> *work)
> >>>>                 (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
> >>>>        if (scsw_is_solicited(&irb->scsw)) {
> >>>>            cp_update_scsw(&private->cp, &irb->scsw);  
> >>>
> >>> As I alluded earlier, do we know this irb is for this cp?  If no, what
> >>> does this function end up putting in the scsw?

Yes, I think this also needs to check whether we have at least a prior
start function around. (We use the orb provided by the guest; maybe we
should check if that intparm is set in the irb?)

> >>>  
> >>>> -        if (is_final)
> >>>> +        if (is_final && private->state != VFIO_CCW_STATE_CP_PROCESSING)  
> >>>
> >>> In looking at how we set this state, and how we exit it, I see we do:
> >>>
> >>> if SSCH got CC0, CP_PROCESSING -> CP_PENDING
> >>> if SSCH got !CC0, CP_PROCESSING -> IDLE
> >>>
> >>> While the first scenario happens immediately after the SSCH instruction,
> >>> I guess it could be just tiny enough, like the io_trigger FSM patch I
> >>> sent a few weeks ago.
> >>>
> >>> Meanwhile, the latter happens way after we return from the jump table.
> >>> So that scenario leaves considerable time for such an interrupt to
> >>> occur, though I don't understand why it would if we got a CC(1-3) on the
> >>> SSCH.
> >>>
> >>> And anyway, the return from fsm_io_helper() in that case will also call
> >>> cp_free().  So why does the cp->initialized check provide protection
> >>> from a double-free in that direction, but not here?  I'm confused.  
> >>
> >> I have a theory where I think it's possible to have 2 different threads
> >> executing cp_free
> >>
> >> If we start with private->state == IDLE and the guest issues a
> >> clear/halt and then an ssch
> >>
> >> - clear/halt will be issued to hardware, and if succeeds we will return
> >> cc=0 to guest
> >>
> >> - the guest can then issue ssch  
> > 
> > It can issue whatever it wants, but shouldn't the SSCH get a CC2 until
> > the halt/clear pending state is cleared?  Hrm, fsm_io_request() doesn't
> > look.  Rather, it (fsm_io_helper()) relies on the CC2 to be signalled
> > from the SSCH issued to the device.  There's a lot of stuff that happens
> > before we get to that point.  
> 
> Yes, and stuff that happens is memory allocation, pinning and other 
> things which can take time.
> 
> > 
> > I'm wondering if there's a way we could/should return the SSCH here
> > before we do any processing.  After all, until the interrupt on the
> > workqueue is processed, we are busy.
> >   
> 
> you mean return the csch/hsch before processing the ssch? Maybe we could 
> extend CP_PENDING state, to just PENDING and use that to reject any ssch 
> if we have a pending csch/hsch?

I'd probably not rely on the state for this. Maybe we could look at the
work queue? But it might be that the check for the intparm I suggested
above is already enough.

> 
> >>
> >> - we get an interrupt for csch/hsch and we queue the interrupt in the
> >> workqueue
> >>
> >> - we start processing the ssch and then at the same time another cpu
> >> could be working on the  
> >> interrupt>  
> >>
> >> Thread 1                                        Thread 2
> >> --------                                        --------
> >>
> >> fsm_io_request                                  vfio_ccw_sch_io_todo
> >>      cp_init                                         cp_free
> >>      cp_prefetch
> >>      fsm_io_helper
> >>          cp_free
> >>
> >>
> >>
> >> The test that I am trying is with a guest running an fio workload, while
> >> at the same time stressing the error recovery path in the guest. So
> >> there is a lot of ssch and lot of csch.
> >>
> >> Of course I don't think my patch completely solves the problem, I think
> >> it just makes the window narrower. I just wanted to get a discussion
> >> started :)
> >>
> >>
> >> Now that I am thinking more about it, I think we might have to protect
> >> cp with it's own mutex.  
> > 
> > That seems like a big hammer, and I wonder if the existing SCHIB/FSM/CP
> > state data doesn't provide that information to us.  But I gotta wander
> > around some code before I say.  
> 
> Any ideas are welcome :)

See above :) That certainly looks like a much smaller hammer.

> 
> >   
> >>
> >> Thanks
> >> Farhan
> >>
> >>  
> >>>  
> >>>>                cp_free(&private->cp);
> >>>>        }
> >>>>        mutex_lock(&private->io_mutex);
> >>>>  
> >>>  
> >>  
> >   

