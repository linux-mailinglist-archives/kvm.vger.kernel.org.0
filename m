Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E43E116D35
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 13:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfLIMic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 07:38:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31078 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726687AbfLIMic (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 07:38:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575895109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VtEZxiYtb8B/oYzsBXNXGNYI+Q/s8Pr58Lcsq/KH3vc=;
        b=Rbw/9CslklyHjRCC52FFawTy9DFwOQP6GHCBjnqTzGifPfiQ0AeZQILvj78nrVSucDleJk
        9G3Xuw2tQjuAqmyd5bUo1gleOCFf3LXJLq96GyHnvi5OyzsGyoNcYKKIT7sXiFltt5a887
        ZxMe4n2FpXxYe8wl9M4cPIrTbrytI9U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-sRNDBgMhMzuXtfBPXJRJSA-1; Mon, 09 Dec 2019 07:38:25 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05E3C8017DF;
        Mon,  9 Dec 2019 12:38:24 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF7531001B03;
        Mon,  9 Dec 2019 12:38:22 +0000 (UTC)
Date:   Mon, 9 Dec 2019 13:38:20 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [RFC PATCH v1 08/10] vfio-ccw: Wire up the CRW irq and CRW
 region
Message-ID: <20191209133820.42707b79.cohuck@redhat.com>
In-Reply-To: <9c83e960-9f68-2328-6a89-d0fa7b8768d8@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
        <20191115025620.19593-9-farman@linux.ibm.com>
        <20191119195236.35189d5b.cohuck@redhat.com>
        <02d98858-ddac-df7e-96a6-7c61335d3cee@linux.ibm.com>
        <20191206112107.63fb37a1.cohuck@redhat.com>
        <9c83e960-9f68-2328-6a89-d0fa7b8768d8@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: sRNDBgMhMzuXtfBPXJRJSA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Dec 2019 16:24:31 -0500
Eric Farman <farman@linux.ibm.com> wrote:

> On 12/6/19 5:21 AM, Cornelia Huck wrote:
> > On Thu, 5 Dec 2019 15:43:55 -0500
> > Eric Farman <farman@linux.ibm.com> wrote:
> >   
> >> On 11/19/19 1:52 PM, Cornelia Huck wrote:  
> >>> On Fri, 15 Nov 2019 03:56:18 +0100
> >>> Eric Farman <farman@linux.ibm.com> wrote:

> >> The actual CRW handlers are in the base cio code, and we only get into
> >> vfio-ccw when processing the individual subchannels.  Do we need to make
> >> a device (or something?) at the guest level for the chpids that exist?
> >> Or do something to say "hey we got this from a subchannel, put it on a
> >> global queue if it's unique, or throw it away if it's a duplicate we
> >> haven't processed yet" ?  Thoughts?  
> > 
> > The problem is that you can easily get several crws that look identical
> > (consider e.g. a chpid that is set online and offline in a tight loop).  
> 
> Yeah, I have a little program that does such a loop.  Things don't work
> too well even with a random delay between on/off, though a hack I'm
> trying to formalize for v2 improves matters.  If I drop that delay to
> zero, um, well I haven't had the nerve to try that.  :)

:)

I'm also not quite sure what our expectations need to be here. IIRC, it
is not guaranteed that we get a CRW for each and every of the
operations anyway. From what I remember, the only sane way for the
guest to process channel reports is to retrieve the current state (via
stsch) and process that, as the state may have changed again between
generating the CRW and the guest retrieving it.

> 
> > The only entity that should make decisions as to what to process here
> > is the guest.  
> 
> Agreed.  So your suggestion in the QEMU series of acting like stcrw is
> good; give the guest all the information it can, and let it decide what
> thrashing is needed.  I guess if I can just queue everything on the
> vfio_ccw_private, and move one (two?) into the crw_region each time it's
> read then that should work well enough.  Thanks!

I *think* we can assume that the callback is invoked by the common I/O
layer for every affected subchannel if there's actually an event from
the hardware, so we can be reasonably sure that we can relay every
event to userspace.

> 
> > 
> > (...)
> >   
> >>>> @@ -312,6 +334,11 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
> >>>>  	case CHP_ONLINE:
> >>>>  		/* Path became available */
> >>>>  		sch->lpm |= mask & sch->opm;
> >>>> +		private->crw.rsc = CRW_RSC_CPATH;
> >>>> +		private->crw.rsid = 0x0 | (link->chpid.cssid << 8) |
> >>>> +				    link->chpid.id;
> >>>> +		private->crw.erc = CRW_ERC_INIT;
> >>>> +		queue_work(vfio_ccw_work_q, &private->crw_work);    
> >>>
> >>> Isn't that racy? Imagine you get one notification for a chpid and queue
> >>> it. Then, you get another notification for another chpid and queue it
> >>> as well. Depending on when userspace reads, it gets different chpids.
> >>> Moreover, a crw may be lost... or am I missing something obvious?    
> >>
> >> Nope, you're right on.  If I start thrashing config on/off chpids on the
> >> host, I eventually fall down with all sorts of weirdness.
> >>  
> >>>
> >>> Maybe you need a real queue for the generated crws?    
> >>
> >> I guess this is what I'm wrestling with...  We don't have a queue for
> >> guest-wide work items, as it's currently broken apart by subchannel.  Is
> >> adding one at the vfio-ccw level right?  Feels odd to me, since multiple
> >> guests could use devices connected via vfio-ccw, which may or may share
> >> common chpids.  
> > 
> > One problem is that the common I/O layer already processes the crws and
> > translates them into different per-subchannel events. We don't even
> > know what the original crw was: IIUC, we translate both a crw for a
> > chpid and a link incident event (reported by a crw with source css and
> > event information via chsc) concerning the concrete link to the same
> > event. That *probably* doesn't matter too much, but it makes things
> > harder. Access to the original crw queue would be nice, but hard to
> > implement without stepping on each others' toes.>  
> >>
> >> I have a rough hack that serializes things a bit, while still keeping
> >> the CRW duplication at the subchannel level.  Things improve
> >> considerably, but it still seems odd to me.  I'll keep working on that
> >> unless anyone has any better ideas.  
> > 
> > The main issue is that we're trying to report a somewhat global event
> > via individual devices...  
> 
> +1

If only we could use some kind of global interface... but I can't think
of a sane way to do that :/

> 
> > 
> > ...what about not reporting crws at all, but something derived from the
> > events we get at the subchannel driver level? Have four masks that
> > indicate online/offline/vary on/vary off for the respective chpids, and
> > have userspace decide how they want to report these to the guest? A
> > drawback (?) would be that a series of on/off events would only be
> > reported as one on and one off event, though. Feasible, or complete
> > lunacy?
> >   
> 
> Not complete lunacy, but brings concerns of its own as we'd need to
> ensure the masks don't say something nonsensical, like (for example)
> both vary on and vary off.  Or what happens if both vary on and config
> off gets set?  Not a huge amount of work, but just seems to carry more
> risk than a queue of the existing CRWs and letting the guest process
> them itself, even if things are duplicated more than necessary.  In
> reality, these events aren't that common anyway unless things go REALLY
> sideways.

Yeah, that approach probably just brings a different set of issues... I
think we would need to relay all mask changes, and QEMU would need to
inject all events, and the guest would need to figure out what to do.
Not sure if that is better.

