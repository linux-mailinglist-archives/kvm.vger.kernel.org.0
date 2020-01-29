Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD23814CA06
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgA2MBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:01:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36787 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726145AbgA2MBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:01:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580299265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o9z6AABaHoKdCY+CLXyFSVRKIUfvIU0jBPZ3wtNvswY=;
        b=MCao+GJ5GXv9OeqAuxuNfAfWMpywEJ0zUddvpZIWliUDeiS4QyQCmr/Mby5ES2cYiKC+xo
        PoQ0MZQqMTfDR9s2dId1klSRza5F5CygU78RkkI6W2IuW/V84XZIyFvY1OwVu+n6DnYdKJ
        pHys6ZFm1jmU8KrDWVsLp/ioxmMwmcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-_l7HGGuMOpGbbSYShriwwQ-1; Wed, 29 Jan 2020 07:00:53 -0500
X-MC-Unique: _l7HGGuMOpGbbSYShriwwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C15B13E5;
        Wed, 29 Jan 2020 12:00:52 +0000 (UTC)
Received: from gondolin (ovpn-116-225.ams2.redhat.com [10.36.116.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01C525D9C5;
        Wed, 29 Jan 2020 12:00:50 +0000 (UTC)
Date:   Wed, 29 Jan 2020 13:00:48 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 1/1] vfio-ccw: Don't free channel programs for
 unrelated interrupts
Message-ID: <20200129130048.39e1b898.cohuck@redhat.com>
In-Reply-To: <9635c45f-4652-c837-d256-46f426737a5e@linux.ibm.com>
References: <20200124145455.51181-1-farman@linux.ibm.com>
        <20200124145455.51181-2-farman@linux.ibm.com>
        <20200124163305.3d6f0d47.cohuck@redhat.com>
        <50a0fe00-a7c1-50e4-12f5-412ee7a0e522@linux.ibm.com>
        <20200127135235.1f783f1b.cohuck@redhat.com>
        <eb3f3887-50f2-ef4d-0b98-b25936047a49@linux.ibm.com>
        <20200128105820.081a4b79.cohuck@redhat.com>
        <6661ad52-0108-e2ae-be19-46ee95e9aa0e@linux.ibm.com>
        <9635c45f-4652-c837-d256-46f426737a5e@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jan 2020 23:13:30 -0500
Eric Farman <farman@linux.ibm.com> wrote:

> On 1/28/20 9:42 AM, Eric Farman wrote:
> > 
> > 
> > On 1/28/20 4:58 AM, Cornelia Huck wrote:  
> >> On Mon, 27 Jan 2020 16:28:18 -0500  
> 
> ...snip...
> 
> >>
> >> cp_init checking cp->initialized would probably be good to catch
> >> errors, in any case. (Maybe put a trace there, just to see if it fires?)  
> > 
> > I did this last night, and got frustrated.  The unfortunate thing was
> > that once it fires, we end up flooding our trace buffers with errors as
> > the guest continually retries.  So I need to either make a smarter trace
> > that is rate limited or just crash my host once this condition occurs.
> > Will try to do that between meetings today.
> >   
> 
> I reverted the subject patch, and simply triggered
> BUG_ON(cp->initialized) in cp_init().  It sprung VERY quickly (all
> traces are for the same device):
> 
> 366.399682 03 ...sch_io_todo state=4 o.cpa=03017810
>                              i.w0=00c04007 i.cpa=03017818 i.w2=0c000000
> 366.399832 03 ...sch_io_todo state=3 o.cpa=7f53dd30 UNSOLICITED
>                              i.w0=00c00011 i.cpa=03017818 i.w2=85000000
> 366.400086 03 ...sch_io_todo state=2 o.cpa=03017930
>                              i.w0=00c04007 i.cpa=03017938 i.w2=0c000000
> 366.400313 03 ...sch_io_todo state=3 o.cpa=03017930
>                              i.w0=00001001 i.cpa=03017938 i.w2=00000000
> 
> Ah, of course...  Unsolicited interrupts DO reset private->state back to
> idle, but leave cp->initialized and any channel_program struct remains
> allocated.  So there's one problem (a memory leak), and an easy one to
> rectify.

For a moment, I suspected a deferred condition code here, but it seems
to be a pure unsolicited interrupt.

But that got me thinking: If we get an unsolicited interrupt while
building the cp, it means that the guest is currently executing ssch.
We need to get the unsolicited interrupt to the guest, while not
executing the ssch. So maybe we need to do the following:

- deliver the unsolicited interrupt to the guest
- make sure we don't execute the ssch, but relay a cc 1 for it back to
  the guest
- clean up the cp

Maybe not avoiding issuing the ssch is what gets us in that pickle? We
either leak memory or free too much, it seems.

> 
> After more than a few silly rabbit holes, I had this trace:
> 
> 429.928480 07 ...sch_io_todo state=4 init=1 o.cpa=7fed8e10
>                              i.w0=00001001 i.cpa=7fed8e18 i.w2=00000000
> 429.929132 07 ...sch_io_todo state=4 init=1 o.cpa=0305aed0
>                              i.w0=00c04007 i.cpa=0305aed8 i.w2=0c000000
> 429.929538 07 ...sch_io_todo state=4 init=1 o.cpa=0305af30
>                              i.w0=00c04007 i.cpa=0305af38 i.w2=0c000000
> 467.339389 07   ...chp_event mask=0x80 event=1
> 467.339865 03 ...sch_io_todo state=3 init=0 o.cpa=01814548
>                              i.w0=00c02001 i.cpa=0305af38 i.w2=00000000
> 
> So my trace is at the beginning of vfio_ccw_sch_io_todo(), but the
> BUG_ON() is at the end of that function where private->state is
> (possibly) updated.  Looking at the contents of the vfio_ccw_private
> struct in the dump, the failing device is currently state=4 init=1
> instead of 3/0 as in the above trace.  So an I/O was being built in
> parallel here, and there's no serializing action within the stacked
> vfio_ccw_sch_io_todo() call to ensure they don't stomp on one another.
> The io_mutex handles the region changes, and the subchannel lock handles
> the start/halt/clear subchannel instructions, but nothing on the
> interrupt side, nor contention between them.  Sigh.

I feel we've been here a few times already, and never seem to come up
with a complete solution :(

There had been some changes by Pierre regarding locking the fsm; maybe
that's what's needed here?

> 
> My brain hurts.  I re-applied this patch (with some validation that the
> cpa is valid) to my current franken-code, and will let it run overnight.
>  I think it's going to be racing other CPUs and I'll find a dead system
> by morning, but who knows.  Maybe not.  :)
> 

I can relate to the brain hurting part :)

