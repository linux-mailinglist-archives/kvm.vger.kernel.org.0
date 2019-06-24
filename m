Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E116650A0B
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 13:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbfFXLq0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Jun 2019 07:46:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbfFXLq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 07:46:26 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 908203086202;
        Mon, 24 Jun 2019 11:46:25 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A53E660BFC;
        Mon, 24 Jun 2019 11:46:24 +0000 (UTC)
Date:   Mon, 24 Jun 2019 13:46:22 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing
 a channel program
Message-ID: <20190624134622.2bb3bba2.cohuck@redhat.com>
In-Reply-To: <20190624120514.4b528db5.cohuck@redhat.com>
References: <cover.1561055076.git.alifm@linux.ibm.com>
        <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
        <638804dc-53c0-ff2f-d123-13c257ad593f@linux.ibm.com>
        <581d756d-7418-cd67-e0e8-f9e4fe10b22d@linux.ibm.com>
        <2d9c04ba-ee50-2f9b-343a-5109274ff52d@linux.ibm.com>
        <56ced048-8c66-a030-af35-8afbbd2abea8@linux.ibm.com>
        <20190624114231.2d81e36f.cohuck@redhat.com>
        <20190624120514.4b528db5.cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 24 Jun 2019 11:46:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jun 2019 12:05:14 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, 24 Jun 2019 11:42:31 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Fri, 21 Jun 2019 14:34:10 -0400
> > Farhan Ali <alifm@linux.ibm.com> wrote:
> >   
> > > On 06/21/2019 01:40 PM, Eric Farman wrote:  
> > > > 
> > > > 
> > > > On 6/21/19 10:17 AM, Farhan Ali wrote:    
> > > >>
> > > >>
> > > >> On 06/20/2019 04:27 PM, Eric Farman wrote:    
> > > >>>
> > > >>>
> > > >>> On 6/20/19 3:40 PM, Farhan Ali wrote:    

> > > >>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> > > >>>> b/drivers/s390/cio/vfio_ccw_drv.c
> > > >>>> index 66a66ac..61ece3f 100644
> > > >>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
> > > >>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> > > >>>> @@ -88,7 +88,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct
> > > >>>> *work)
> > > >>>>                 (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
> > > >>>>        if (scsw_is_solicited(&irb->scsw)) {
> > > >>>>            cp_update_scsw(&private->cp, &irb->scsw);    
> > > >>>
> > > >>> As I alluded earlier, do we know this irb is for this cp?  If no, what
> > > >>> does this function end up putting in the scsw?  
> > 
> > Yes, I think this also needs to check whether we have at least a prior
> > start function around. (We use the orb provided by the guest; maybe we
> > should check if that intparm is set in the irb?)  
> 
> Hrm; not so easy as we always set the intparm to the address of the
> subchannel structure... 
> 
> Maybe check if we have have one of the conditions of the large table
> 16-6 and correlate to the ccw address? Or is it enough to check the
> function control? (Don't remember when the hardware resets it.)

Nope, we cannot look at the function control, as csch clears any set
start function bit :( (see "Function Control", pg 16-13)

I think this problem mostly boils down to "csch clears pending status;
therefore, we may only get one interrupt, even though there had been a
start function going on". If we only go with what the hardware gives
us, I don't see a way to distinguish "clear with a prior start" from
"clear only". Maybe we want to track an "issued" status in the cp?
