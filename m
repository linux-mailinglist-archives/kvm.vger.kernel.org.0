Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407A511CFDF
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 15:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbfLLOeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 09:34:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31661 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729603AbfLLOeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 09:34:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576161260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mfurvm8QV9fgCkoU9i5gFyfPNQKPfsaGwGiyBmjcKLI=;
        b=W5/uUflDeSqjqSLS9nVL3usDoogoGQwvpyRsQad+J8QHlFpCqBdgnaGWtwamYfsbuEJjKE
        4KcKlvxKhb5vBBnMEQJ5TaEs8v/Dq6jusl7bZBYL3gWGpIvuQP45ePqql1gP3ufBI7j466
        30NEt2D39TMWnkQGgzI71AcPHNj17kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-z3VJEAX-Nkq5quty0MK_gw-1; Thu, 12 Dec 2019 09:34:19 -0500
X-MC-Unique: z3VJEAX-Nkq5quty0MK_gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97B378024DE;
        Thu, 12 Dec 2019 14:34:17 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED92D60BF3;
        Thu, 12 Dec 2019 14:34:11 +0000 (UTC)
Date:   Thu, 12 Dec 2019 15:33:03 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 7/9] s390x: css: msch, enable test
Message-ID: <20191212153303.6444697e.cohuck@redhat.com>
In-Reply-To: <c92089cf-39f4-3b64-79a8-3264654130b1@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
        <1576079170-7244-8-git-send-email-pmorel@linux.ibm.com>
        <20191212130111.0f75fe7f.cohuck@redhat.com>
        <83d45c31-30c3-36e1-1d68-51b88448f4af@linux.ibm.com>
        <20191212151002.1c7ca4eb.cohuck@redhat.com>
        <c92089cf-39f4-3b64-79a8-3264654130b1@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Dec 2019 15:21:21 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2019-12-12 15:10, Cornelia Huck wrote:
> > On Thu, 12 Dec 2019 15:01:07 +0100
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> On 2019-12-12 13:01, Cornelia Huck wrote:  
> >>> On Wed, 11 Dec 2019 16:46:08 +0100
> >>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> >>>      
> >>>> A second step when testing the channel subsystem is to prepare a channel
> >>>> for use.
> >>>> This includes:
> >>>> - Get the current SubCHannel Information Block (SCHIB) using STSCH
> >>>> - Update it in memory to set the ENABLE bit
> >>>> - Tell the CSS that the SCHIB has been modified using MSCH
> >>>> - Get the SCHIB from the CSS again to verify that the subchannel is
> >>>>     enabled.
> >>>>
> >>>> This tests the success of the MSCH instruction by enabling a channel.
> >>>>
> >>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >>>> ---
> >>>>    s390x/css.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>    1 file changed, 65 insertions(+)  
> >   
> >>>> +	/* Read the SCHIB for this subchannel */
> >>>> +	cc = stsch(test_device_sid, &schib);
> >>>> +	if (cc) {
> >>>> +		report(0, "stsch cc=%d", cc);
> >>>> +		return;
> >>>> +	}
> >>>> +
> >>>> +	/* Update the SCHIB to enable the channel */
> >>>> +	pmcw->flags |= PMCW_ENABLE;
> >>>> +
> >>>> +	/* Tell the CSS we want to modify the subchannel */
> >>>> +	cc = msch(test_device_sid, &schib);
> >>>> +	if (cc) {
> >>>> +		/*
> >>>> +		 * If the subchannel is status pending or
> >>>> +		 * if a function is in progress,
> >>>> +		 * we consider both cases as errors.
> >>>> +		 */
> >>>> +		report(0, "msch cc=%d", cc);
> >>>> +		return;
> >>>> +	}
> >>>> +
> >>>> +	/*
> >>>> +	 * Read the SCHIB again to verify the enablement
> >>>> +	 * insert a little delay and try 5 times.
> >>>> +	 */
> >>>> +	do {
> >>>> +		cc = stsch(test_device_sid, &schib);
> >>>> +		if (cc) {
> >>>> +			report(0, "stsch cc=%d", cc);
> >>>> +			return;
> >>>> +		}
> >>>> +		delay(10);  
> >>>
> >>> That's just a short delay to avoid a busy loop, right? msch should be
> >>> immediate,  
> >>
> >> Thought you told to me that it may not be immediate in zVM did I
> >> misunderstand?  
> > 
> > Maybe I have been confusing... what I'm referring to is this
> > programming note for msch:
> > 
> > "It is recommended that the program inspect the
> > contents of the subchannel by subsequently
> > issuing STORE SUBCHANNEL when MODIFY
> > SUBCHANNEL sets condition code 0. Use of
> > STORE SUBCHANNEL is a method for deter-
> > mining if the designated subchannel was
> > changed or not. Failure to inspect the subchan-
> > nel following the setting of condition code 0 by
> > MODIFY SUBCHANNEL may result in conditions
> > that the program does not expect to occur."
> > 
> > That's exactly what we had to do under z/VM back then: do the msch,
> > check via stsch, redo the msch if needed, check again via stsch. It
> > usually worked with the second msch the latest.  
> 
> OK, I understand, then it is a bug in zVM that this test could enlighten.

Probably more a quirk than a bug... the explanation there is not
explicit about that :)

> 
> I think we should keep it so, it allows to recognize 3 cases (after I 
> change to test ENABLE in the loop as I said I will):
> - immediate ENABLE

This is the good case.

> - asynchrone ENABLE

This one I would consider an architecture violation.

> - failure to ENABLE

This is the quirk above.

But I'm not quite sure how you would be able to distinguish the last
two cases?

> >   
> >>  
> >>> and you probably should not delay on success?  
> >>
> >> yes, it is not optimized, I can test PMCW_ENABLE in the loop this way we
> >> can see if, in the zVM case we need to do retries or not.
> >>
> >>  
> >>>      
> >>>> +	} while (!(pmcw->flags & PMCW_ENABLE) && count++ < 5);  
> >>>
> >>> How is this supposed to work? Doesn't the stsch overwrite the control
> >>> block again, so you need to re-set the enable bit before you retry?  
> >>
> >> I do not think so, there is no msch() in the loop.
> >> Do I miss something?  
> > 
> > Well, _I_ missed that the msch() was missing :) You need it (see above);
> > just waiting and re-doing the stsch is useless, as msch is a
> > synchronous instruction which has finished its processing after the cc
> > has been set.
> >   
> 
> Since kvm-unit-test is a test system, not an OS so I think that here we 
> have one more point to leverage the enable function:
> - We need to test the enable (what I did (partially))

Maybe also log if you needed to retry? Not as an error, but as
additional information?

> - We need the enable to work (your proposition) to further test the I/O
> 
> OK, I rework this part with your comment in mind.
> 
> Thanks
> Pierre
> 
> 

