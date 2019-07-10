Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8A46476D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 15:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfGJNpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 09:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfGJNpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 09:45:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 738FD30056BF;
        Wed, 10 Jul 2019 13:45:52 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61CE55B810;
        Wed, 10 Jul 2019 13:45:51 +0000 (UTC)
Date:   Wed, 10 Jul 2019 15:45:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v2 4/5] vfio-ccw: Don't call cp_free if we are processing
 a channel program
Message-ID: <20190710154549.5c31cc0c.cohuck@redhat.com>
In-Reply-To: <87f7a37f-cc34-36fb-3a33-309e33bbbdde@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
        <1405df8415d3bff446c22753d0e9b91ff246eb0f.1562616169.git.alifm@linux.ibm.com>
        <20190709121613.6a3554fa.cohuck@redhat.com>
        <45ad7230-3674-2601-af5b-d9beef9312be@linux.ibm.com>
        <20190709162142.789dd605.pasic@linux.ibm.com>
        <87f7a37f-cc34-36fb-3a33-309e33bbbdde@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 10 Jul 2019 13:45:52 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Jul 2019 17:27:47 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 07/09/2019 10:21 AM, Halil Pasic wrote:
> > On Tue, 9 Jul 2019 09:46:51 -0400
> > Farhan Ali <alifm@linux.ibm.com> wrote:
> >   
> >>
> >>
> >> On 07/09/2019 06:16 AM, Cornelia Huck wrote:  
> >>> On Mon,  8 Jul 2019 16:10:37 -0400
> >>> Farhan Ali <alifm@linux.ibm.com> wrote:
> >>>  
> >>>> There is a small window where it's possible that we could be working
> >>>> on an interrupt (queued in the workqueue) and setting up a channel
> >>>> program (i.e allocating memory, pinning pages, translating address).
> >>>> This can lead to allocating and freeing the channel program at the
> >>>> same time and can cause memory corruption.
> >>>>
> >>>> Let's not call cp_free if we are currently processing a channel program.
> >>>> The only way we know for sure that we don't have a thread setting
> >>>> up a channel program is when the state is set to VFIO_CCW_STATE_CP_PENDING.  
> >>>
> >>> Can we pinpoint a commit that introduced this bug, or has it been there
> >>> since the beginning?
> >>>  
> >>
> >> I think the problem was always there.
> >>  
> > 
> > I think it became relevant with the async stuff. Because after the async
> > stuff was added we start getting solicited interrupts that are not about
> > channel program is done. At least this is how I remember the discussion.
> >   
> >>>>
> >>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> >>>> ---
> >>>>    drivers/s390/cio/vfio_ccw_drv.c | 2 +-
> >>>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> >>>> index 4e3a903..0357165 100644
> >>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
> >>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> >>>> @@ -92,7 +92,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
> >>>>    		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
> >>>>    	if (scsw_is_solicited(&irb->scsw)) {
> >>>>    		cp_update_scsw(&private->cp, &irb->scsw);
> >>>> -		if (is_final)
> >>>> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)  
> > 
> > Ain't private->state potentially used by multiple threads of execution?  
> 
> yes
> 
> One of the paths I can think of is a machine check from the host which 
> will ultimately call vfio_ccw_sch_event callback which could set state 
> to NOT_OPER or IDLE.

Now I went through the machine check rabbit hole because I thought
freeing the cp in there might be a good idea, but it's not that easy
(who'd have thought...)

If I read the POP correctly, an IPI or IPR in the subchannel CRW will
indicate that the subchannel has been restored to a state after an I/O
reset; in particular, that means that the subchannel does not have any
I/O pending. However, that does not seem to be the case e.g. for an IPM
(the doc does not seem to be very clear on that, though.) We can't
unconditionally do something, as we do not know what event we're being
called for (please disregard the positively ancient "we're called for
IPI" comment in css_process_crw(), I think I added that one in the
Linux 2.4 or 2.5 timeframe...) tl;dr We can't rely on anything...

> 
> > Do we need to use atomic operations or external synchronization to avoid
> > this being another gamble? Or am I missing something?  
> 
> I think we probably should think about atomic operations for 
> synchronizing the state (and it could be a separate add on patch?).

+1 to thinking about some atomicity changes later.

> 
> But for preventing 2 threads from stomping on the cp the check should be 
> enough, unless I am missing something?

I think so. Plus, the patch is small enough that we can merge it right
away, and figure out a more generic change later.

> 
> >   
> >>>>    			cp_free(&private->cp);
> >>>>    	}
> >>>>    	mutex_lock(&private->io_mutex);  
> >>>
> >>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >>>
> >>>  
> >> Thanks for reviewing.
> >>
> >> Thanks
> >> Farhan  
> > 
> >   

