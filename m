Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8134810EEFF
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 19:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfLBSQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 13:16:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60819 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727845AbfLBSQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 13:16:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575310570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EoUZ4aIDaUNW5wgpOuCJZDD5XFBQFgBqp70+UzY5e1E=;
        b=B+STy3QEXQ4LtZ1IXbC85aJkPOKepSG6vbI/DWjpyAEZj/tu5JCXKZKpYCxnF7vkykzjpR
        6uS+T52BYJvCQ60mzQVs7OMWMM1VFOxHj0Hly6ah1tOQNV7NST9bjtJ0Cg2frataYgmV3S
        Y95b93qAp4zt696w+1LawKyAOlgpiAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-I6hFOvaWP_OR9c4xKBIXng-1; Mon, 02 Dec 2019 13:16:08 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5B01801E78;
        Mon,  2 Dec 2019 18:16:07 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E9885C557;
        Mon,  2 Dec 2019 18:16:02 +0000 (UTC)
Date:   Mon, 2 Dec 2019 19:15:41 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 6/9] s390x: css: stsch, enumeration
 test
Message-ID: <20191202191541.1ffd987e.cohuck@redhat.com>
In-Reply-To: <aa588c00-79ac-2942-7911-b476abb224db@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
        <1574945167-29677-7-git-send-email-pmorel@linux.ibm.com>
        <20191202152246.4d627b0e.cohuck@redhat.com>
        <aa588c00-79ac-2942-7911-b476abb224db@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: I6hFOvaWP_OR9c4xKBIXng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2 Dec 2019 18:53:16 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2019-12-02 15:22, Cornelia Huck wrote:
> > On Thu, 28 Nov 2019 13:46:04 +0100
> > Pierre Morel <pmorel@linux.ibm.com> wrote:

> >> +static int test_device_sid;
> >> +
> >> +static void test_enumerate(void)
> >> +{
> >> +	struct pmcw *pmcw = &schib.pmcw;
> >> +	int sid;
> >> +	int ret, i;
> >> +	int found = 0;
> >> +
> >> +	for (sid = 0; sid < 0xffff; sid++) {
> >> +		ret = stsch(sid|SID_ONE, &schib);  
> > 
> > This seems a bit odd. You are basically putting the subchannel number
> > into sid, OR in the one, and then use the resulting value as the sid
> > (subchannel identifier).
> >   
> >> +		if (!ret && (pmcw->flags & PMCW_DNV)) {
> >> +			report_info("SID %04x Type %s PIM %x", sid,  
> > 
> > That's not a sid, but the subchannel number (see above).
> >   
> >> +				     Channel_type[pmcw->st], pmcw->pim);
> >> +			for (i = 0; i < 8; i++)  {
> >> +				if ((pmcw->pim << i) & 0x80) {
> >> +					report_info("CHPID[%d]: %02x", i,
> >> +						    pmcw->chpid[i]);
> >> +					break;
> >> +				}
> >> +			}
> >> +			found++;
> >> +	
> >> +		}  
> > 
> > Here, you iterate over the 0-0xffff range, even if you got a condition
> > code 3 (indicating no more subchannels in that set). Is that
> > intentional?  
> 
> I thought there could be more subchannels.
> I need then a break in the loop when this happens.
> I will reread the PoP to see how to find that no more subchannel are in 
> that set.

The fact that cc 3 for stsch == no more subchannels is unfortunately a
bit scattered across the PoP :/ Dug it out some time ago, maybe it's
still in the archives somewhere...

> 
> >   
> >> +		if (found && !test_device_sid)
> >> +			test_device_sid = sid|SID_ONE;  
> > 
> > You set test_device_sid to the last valid subchannel? Why?  
> 
> The last ? I wanted the first one

It is indeed the first one, -ENOCOFFEE.

> 
> I wanted something easy but I should have explain.
> 
> To avoid doing complicated things like doing a sense on each valid 
> subchannel I just take the first one.
> Should be enough as we do not go to the device in this test.

Yes; but you plan to reuse that code, don't you?

> 
> >   
> >> +	}
> >> +	if (!found) {
> >> +		report("Found %d devices", 0, found);

Now that I look at this again: If you got here, you always found 0
devices, so that message is not super helpful :)

> >> +		return;
> >> +	}
> >> +	ret = stsch(test_device_sid, &schib);  
> > 
> > Why do you do a stsch() again?  
> 
> right, no need.
> In an internal version I used to print some informations from the SCHIB.
> Since in between I overwrote the SHIB, I did it again.
> But in this version; no need.

You could copy the schib of the subchannel to be tested to a different
place, but I'm not sure it's worth it.

> 
> >   
> >> +	if (ret) {
> >> +		report("Err %d on stsch on sid %08x", 0, ret, test_device_sid);
> >> +		return;
> >> +	}
> >> +	report("Tested", 1);
> >> +	return;  
> > 
> > I don't think you need this return statement.  
> 
> right I have enough work. :)
> 
> > 
> > Your test only enumerates devices in the first subchannel set. Do you
> > plan to enhance the test to enable the MSS facility and iterate over
> > all subchannel sets?  
> 
> Yes, it is something we can do in a following series

Sure, just asked out of interest :)

