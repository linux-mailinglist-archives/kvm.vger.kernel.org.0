Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E1621A0EB
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 15:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgGINbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 09:31:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57920 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726410AbgGINbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 09:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594301465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZV046C9FlHRH3RTZDZ6h6ABB8tB0CGYUWgmvEylPwk=;
        b=NRLpwAV0MgRfTKRyKMQRysG5+T8HYcPSKyrwOyz578sF8osQy6qXuCGiEooeK3mKoIXPli
        4GDzwg2O16y5zAaGHK7/TWCqBGT79kozUziRNe1/jNlstW/HlFzX7Xeqwwl38zlIX81uJR
        KoAKFTWuiOk6ZT7/2s4w5pn1dVHTAfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-O1bBZozZOOi4rh1E1kj1NQ-1; Thu, 09 Jul 2020 09:31:01 -0400
X-MC-Unique: O1bBZozZOOi4rh1E1kj1NQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56112E91C;
        Thu,  9 Jul 2020 13:31:00 +0000 (UTC)
Received: from gondolin (ovpn-113-62.ams2.redhat.com [10.36.113.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9E321A888;
        Thu,  9 Jul 2020 13:30:58 +0000 (UTC)
Date:   Thu, 9 Jul 2020 15:30:55 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
Subject: Re: [kvm-unit-tests PATCH v11 8/9] s390x: css: msch, enable test
Message-ID: <20200709153055.6f2b5e59.cohuck@redhat.com>
In-Reply-To: <d55c3e5b-8adf-8f7f-2b97-c270fb6598b4@linux.ibm.com>
References: <1594282068-11054-1-git-send-email-pmorel@linux.ibm.com>
        <1594282068-11054-9-git-send-email-pmorel@linux.ibm.com>
        <20200709134056.0d267b6c.cohuck@redhat.com>
        <d55c3e5b-8adf-8f7f-2b97-c270fb6598b4@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jul 2020 15:12:05 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-07-09 13:40, Cornelia Huck wrote:
> > On Thu,  9 Jul 2020 10:07:47 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> A second step when testing the channel subsystem is to prepare a channel
> >> for use.
> >> This includes:
> >> - Get the current subchannel Information Block (SCHIB) using STSCH
> >> - Update it in memory to set the ENABLE bit and the specified ISC
> >> - Tell the CSS that the SCHIB has been modified using MSCH
> >> - Get the SCHIB from the CSS again to verify that the subchannel is
> >>    enabled and uses the specified ISC.
> >> - If the command succeeds but subchannel is not enabled or the ISC
> >>    field is not as expected, retry a predefined retries count.
> >> - If the command fails, report the failure and do not retry, even
> >>    if cc indicates a busy/status pending as we do not expect this.
> >>
> >> This tests the MSCH instruction to enable a channel successfully.
> >> Retries are done and in case of error, and if the retries count
> >> is exceeded, a report is made.
> >>
> >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >> Acked-by: Thomas Huth <thuth@redhat.com>
> >> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >> ---
> >>   lib/s390x/css.h     |  8 +++--
> >>   lib/s390x/css_lib.c | 72 +++++++++++++++++++++++++++++++++++++++++++++
> >>   s390x/css.c         | 15 ++++++++++
> >>   3 files changed, 92 insertions(+), 3 deletions(-)  
> > 
> > (...)
> >   
> >> +/*
> >> + * css_msch: enable subchannel and set with specified ISC  
> > 
> > "css_enable: enable the subchannel with the specified ISC"
> > 
> > ?
> >   
> >> + * @schid: Subchannel Identifier
> >> + * @isc  : number of the interruption subclass to use
> >> + * Return value:
> >> + *   On success: 0
> >> + *   On error the CC of the faulty instruction
> >> + *      or -1 if the retry count is exceeded.
> >> + */
> >> +int css_enable(int schid, int isc)
> >> +{
> >> +	struct pmcw *pmcw = &schib.pmcw;
> >> +	int retry_count = 0;
> >> +	uint16_t flags;
> >> +	int cc;
> >> +
> >> +	/* Read the SCHIB for this subchannel */
> >> +	cc = stsch(schid, &schib);
> >> +	if (cc) {
> >> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
> >> +		return cc;
> >> +	}
> >> +
> >> +	flags = PMCW_ENABLE | (isc << PMCW_ISC_SHIFT);
> >> +	if ((pmcw->flags & flags) == flags) {  
> > 
> > I think you want (pmcw->flags & PMCW_ENABLE) == PMCW_ENABLE -- this
> > catches the case of "subchannel has been enabled before, but with a
> > different isc".  
> 
> If with a different ISC, we need to modify the ISC.
> Don't we ?

I think that's a policy decision (I would probably fail and require a
disable before setting another isc, but that's a matter of taste).

Regardless, I think the current check doesn't even catch the 'different
isc' case?

> 
> >   
> >> +		report_info("stsch: sch %08x already enabled", schid);
> >> +		return 0;
> >> +	}  
> 
> 
> 
> > 
> > (...)
> >   
> 
> 

