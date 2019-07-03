Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34055E10C
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 11:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfGCJaI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 3 Jul 2019 05:30:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19693 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGCJaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 05:30:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98C5443AB2;
        Wed,  3 Jul 2019 09:30:07 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79AF5871EA;
        Wed,  3 Jul 2019 09:30:06 +0000 (UTC)
Date:   Wed, 3 Jul 2019 11:30:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v1 1/4] vfio-ccw: Set orb.cmd.c64 before calling
 ccwchain_handle_ccw
Message-ID: <20190703113004.217ca43e.cohuck@redhat.com>
In-Reply-To: <62c3b191-3fae-011d-505d-59e8412229d0@linux.ibm.com>
References: <cover.1561997809.git.alifm@linux.ibm.com>
        <050943a6f5a427317ea64100bc2b4ec6394a4411.1561997809.git.alifm@linux.ibm.com>
        <20190702102606.2e9cfed3.cohuck@redhat.com>
        <de9ae025-a96a-11ab-2ba9-8252d8b070e0@linux.ibm.com>
        <62c3b191-3fae-011d-505d-59e8412229d0@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 03 Jul 2019 09:30:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Jul 2019 11:11:47 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 7/2/19 9:56 AM, Farhan Ali wrote:
> > 
> > 
> > On 07/02/2019 04:26 AM, Cornelia Huck wrote:  
> >> On Mon,  1 Jul 2019 12:23:43 -0400
> >> Farhan Ali <alifm@linux.ibm.com> wrote:
> >>  
> >>> Because ccwchain_handle_ccw calls ccwchain_calc_length and
> >>> as per the comment we should set orb.cmd.c64 before calling
> >>> ccwchanin_calc_length.
> >>>
> >>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> >>> ---
> >>>   drivers/s390/cio/vfio_ccw_cp.c | 10 +++++-----
> >>>   1 file changed, 5 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c
> >>> b/drivers/s390/cio/vfio_ccw_cp.c
> >>> index d6a8dff..5ac4c1e 100644
> >>> --- a/drivers/s390/cio/vfio_ccw_cp.c
> >>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> >>> @@ -640,16 +640,16 @@ int cp_init(struct channel_program *cp, struct
> >>> device *mdev, union orb *orb)
> >>>       memcpy(&cp->orb, orb, sizeof(*orb));
> >>>       cp->mdev = mdev;
> >>>   -    /* Build a ccwchain for the first CCW segment */
> >>> -    ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
> >>> -    if (ret)
> >>> -        cp_free(cp);
> >>> -
> >>>       /* It is safe to force: if not set but idals used
> >>>        * ccwchain_calc_length returns an error.
> >>>        */
> >>>       cp->orb.cmd.c64 = 1;
> >>>   +    /* Build a ccwchain for the first CCW segment */
> >>> +    ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
> >>> +    if (ret)
> >>> +        cp_free(cp);
> >>> +
> >>>       if (!ret)
> >>>           cp->initialized = true;
> >>>     
> >>
> >> Hm... has this ever been correct, or did this break only with the
> >> recent refactorings?
> >>
> >> (IOW, what should Fixes: point to?)  
> 
> Yeah, that looks like it should blame my refactoring.
> 
> >>
> >>  
> > 
> > I think it was correct before some of the new refactoring we did. But we
> > do need to set before calling ccwchain_calc_length, because the function
> > does have a check for orb.cmd.64. I will see which exact commit did it.  
> 
> I get why that check exists, but does anyone know why it's buried in
> ccwchain_calc_length()?  Is it simply because ccwchain_calc_length()
> assumes to be working on Format-1 CCWs?  I don't think that routine
> cares if it's an IDA or not, an it'd be nice if we could put a check for
> the supported IDA formats somewhere up front.

The more I stare at this code, the more confused I get :(

Apparently we want to allow the guest to specify an orb without cmd.c64
set, as this is fine as long as the channel program does not use idals.
However, we _do_ want to reject it if cmd.c64 is not set, but idals are
used; so we actually _don't_ want to force this before the processing.
We just want the flag in the orb to be set when we do the ssch.

So it seems that the comment does not really talk about what
ccwchain_calc_length _will_ do, but what it _generally_ does (and, in
this case, already would have done.)

If my understanding is correct, maybe we should reword the comment
instead? i.e. s/returns/would have returned/
