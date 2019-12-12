Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6737A11CF68
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 15:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfLLOKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 09:10:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37484 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729582AbfLLOKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 09:10:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576159813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EylYr8blwwL63nt4ZFSkgJ0yu+xa6ILLxonI0Hi4q9A=;
        b=Z4+PN07xRFCP/YTcriOmsMWYH9TQLz+lif//VwitvhdSDghdr03vJSI+4uTxYhEo/+sFpz
        DEZwMpGP/nKV7cHaBa0bU53Vh/y02eMvRMEYIGf9GMzLh4aM5EdINjfv3qw4dAypUq/eet
        ACeOYkvCBBHGIfSGUmTrbO+7IFK+1AM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155--DwG0L_3Ps-XG9QAgsLWFQ-1; Thu, 12 Dec 2019 09:10:09 -0500
X-MC-Unique: -DwG0L_3Ps-XG9QAgsLWFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 508D8800D5B;
        Thu, 12 Dec 2019 14:10:08 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF9D76013D;
        Thu, 12 Dec 2019 14:10:04 +0000 (UTC)
Date:   Thu, 12 Dec 2019 15:10:02 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 7/9] s390x: css: msch, enable test
Message-ID: <20191212151002.1c7ca4eb.cohuck@redhat.com>
In-Reply-To: <83d45c31-30c3-36e1-1d68-51b88448f4af@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
        <1576079170-7244-8-git-send-email-pmorel@linux.ibm.com>
        <20191212130111.0f75fe7f.cohuck@redhat.com>
        <83d45c31-30c3-36e1-1d68-51b88448f4af@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Dec 2019 15:01:07 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2019-12-12 13:01, Cornelia Huck wrote:
> > On Wed, 11 Dec 2019 16:46:08 +0100
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> A second step when testing the channel subsystem is to prepare a channel
> >> for use.
> >> This includes:
> >> - Get the current SubCHannel Information Block (SCHIB) using STSCH
> >> - Update it in memory to set the ENABLE bit
> >> - Tell the CSS that the SCHIB has been modified using MSCH
> >> - Get the SCHIB from the CSS again to verify that the subchannel is
> >>    enabled.
> >>
> >> This tests the success of the MSCH instruction by enabling a channel.
> >>
> >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >> ---
> >>   s390x/css.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 65 insertions(+)

> >> +	/* Read the SCHIB for this subchannel */
> >> +	cc = stsch(test_device_sid, &schib);
> >> +	if (cc) {
> >> +		report(0, "stsch cc=%d", cc);
> >> +		return;
> >> +	}
> >> +
> >> +	/* Update the SCHIB to enable the channel */
> >> +	pmcw->flags |= PMCW_ENABLE;
> >> +
> >> +	/* Tell the CSS we want to modify the subchannel */
> >> +	cc = msch(test_device_sid, &schib);
> >> +	if (cc) {
> >> +		/*
> >> +		 * If the subchannel is status pending or
> >> +		 * if a function is in progress,
> >> +		 * we consider both cases as errors.
> >> +		 */
> >> +		report(0, "msch cc=%d", cc);
> >> +		return;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Read the SCHIB again to verify the enablement
> >> +	 * insert a little delay and try 5 times.
> >> +	 */
> >> +	do {
> >> +		cc = stsch(test_device_sid, &schib);
> >> +		if (cc) {
> >> +			report(0, "stsch cc=%d", cc);
> >> +			return;
> >> +		}
> >> +		delay(10);  
> > 
> > That's just a short delay to avoid a busy loop, right? msch should be
> > immediate,  
> 
> Thought you told to me that it may not be immediate in zVM did I 
> misunderstand?

Maybe I have been confusing... what I'm referring to is this
programming note for msch:

"It is recommended that the program inspect the
contents of the subchannel by subsequently
issuing STORE SUBCHANNEL when MODIFY
SUBCHANNEL sets condition code 0. Use of
STORE SUBCHANNEL is a method for deter-
mining if the designated subchannel was
changed or not. Failure to inspect the subchan-
nel following the setting of condition code 0 by
MODIFY SUBCHANNEL may result in conditions
that the program does not expect to occur."

That's exactly what we had to do under z/VM back then: do the msch,
check via stsch, redo the msch if needed, check again via stsch. It
usually worked with the second msch the latest.

> 
> > and you probably should not delay on success?  
> 
> yes, it is not optimized, I can test PMCW_ENABLE in the loop this way we 
> can see if, in the zVM case we need to do retries or not.
> 
> 
> >   
> >> +	} while (!(pmcw->flags & PMCW_ENABLE) && count++ < 5);  
> > 
> > How is this supposed to work? Doesn't the stsch overwrite the control
> > block again, so you need to re-set the enable bit before you retry?  
> 
> I do not think so, there is no msch() in the loop.
> Do I miss something?

Well, _I_ missed that the msch() was missing :) You need it (see above);
just waiting and re-doing the stsch is useless, as msch is a
synchronous instruction which has finished its processing after the cc
has been set.

