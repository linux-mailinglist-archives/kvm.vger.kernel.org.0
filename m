Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988D914A42A
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 13:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgA0Mwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 07:52:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38095 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729213AbgA0Mwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 07:52:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580129565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jtFiStN3jJBNXacY8WaepFR9Wi9jKNBZsK7Z7DnkvA4=;
        b=UAhuioKjuwd1ivZcccKigEmsOb8PZ00EzXELaR242HGf6+CJl8Ru0TRwLYi9+sNAblV12Q
        NF/hnkUpElikCETgywKrR2gRfBOl2lDTTzPClnIsrGxTxfmds6/N8+uh/3uQi0jbEkIC9E
        YEN6aKVm99sTqj95wWr5C+CkOlaN6pc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-Hj67WDbpNaOD4F_DYdj7qQ-1; Mon, 27 Jan 2020 07:52:40 -0500
X-MC-Unique: Hj67WDbpNaOD4F_DYdj7qQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A07313E2;
        Mon, 27 Jan 2020 12:52:39 +0000 (UTC)
Received: from gondolin (ovpn-116-220.ams2.redhat.com [10.36.116.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7A145C219;
        Mon, 27 Jan 2020 12:52:37 +0000 (UTC)
Date:   Mon, 27 Jan 2020 13:52:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 1/1] vfio-ccw: Don't free channel programs for
 unrelated interrupts
Message-ID: <20200127135235.1f783f1b.cohuck@redhat.com>
In-Reply-To: <50a0fe00-a7c1-50e4-12f5-412ee7a0e522@linux.ibm.com>
References: <20200124145455.51181-1-farman@linux.ibm.com>
        <20200124145455.51181-2-farman@linux.ibm.com>
        <20200124163305.3d6f0d47.cohuck@redhat.com>
        <50a0fe00-a7c1-50e4-12f5-412ee7a0e522@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Jan 2020 11:08:12 -0500
Eric Farman <farman@linux.ibm.com> wrote:

> On 1/24/20 10:33 AM, Cornelia Huck wrote:
> > On Fri, 24 Jan 2020 15:54:55 +0100
> > Eric Farman <farman@linux.ibm.com> wrote:

> >> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> >> index e401a3d0aa57..a8ab256a217b 100644
> >> --- a/drivers/s390/cio/vfio_ccw_drv.c
> >> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> >> @@ -90,8 +90,8 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
> >>  	is_final = !(scsw_actl(&irb->scsw) &
> >>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
> >>  	if (scsw_is_solicited(&irb->scsw)) {
> >> -		cp_update_scsw(&private->cp, &irb->scsw);
> >> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> >> +		if (cp_update_scsw(&private->cp, &irb->scsw) &&
> >> +		    is_final && private->state == VFIO_CCW_STATE_CP_PENDING)  
> > 
> > ...but I still wonder why is_final is not catching non-ssch related
> > interrupts, as I thought it would. We might want to adapt that check,
> > instead. (Or was the scsw_is_solicited() check supposed to catch that?
> > As said, too tired right now...)  
> 
> I had looked at the (un)solicited bits at one point, and saw very few
> unsolicited interrupts.  The ones that did show up didn't appear to
> affect things in the way that would cause the problems I'm seeing.

Ok, so that check is hopefully fine.

> 
> As for is_final...  That POPS table states that for "status pending
> [alone] after termination of HALT or CLEAR ... cpa is unpredictable",
> which is what happens here.  In the example above, the cpa is the same
> as the previous (successful) interrupt, and thus unrelated to the
> current chain.  Perhaps is_final needs to check that the function
> control in the interrupt is for a start?

I think our reasoning last time we discussed this function was that we
only are in CP_PENDING if we actually did a ssch previously. Now, if we
do a hsch/csch before we got final status for the program started by
the ssch, we don't move out of the CP_PENDING, but the cpa still might
not be what we're looking for. So, we should probably check that we
have only the start function indicated in the fctl.

But if we do that, we still have a chain allocated for something that
has already been terminated... how do we find the right chain to clean
up, if needed?

