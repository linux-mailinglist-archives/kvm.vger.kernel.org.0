Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF04B10F105
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 20:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfLBTtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 14:49:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21371 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728002AbfLBTtf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 14:49:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575316174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RlVGB9liDUsyCGfpQmn4oo95xYvhqo1kWGPr7Ptcfic=;
        b=iGrg+uqDNaPD/z66vrDgFP+z4V9Z8XWcwI4B/UPcf9QAGrSRIVZUVYjFMpKqcjleg7Xklo
        sLSCAX4nTDj/m1aWyCRLz6xgjrOxWWEBNtqx6bh5hUSoY20xDykM72IDC5YMPJI3qrEvWN
        FPTdsa9ZG6ybFCqfZj4rVffpWB7c3BA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-WYwNutRWP_uvq7NS4Bqtmg-1; Mon, 02 Dec 2019 14:49:31 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1486D18B9FC1;
        Mon,  2 Dec 2019 19:49:30 +0000 (UTC)
Received: from gondolin (ovpn-116-127.ams2.redhat.com [10.36.116.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A697A60BEC;
        Mon,  2 Dec 2019 19:49:25 +0000 (UTC)
Date:   Mon, 2 Dec 2019 20:49:22 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 6/9] s390x: css: stsch, enumeration
 test
Message-ID: <20191202204922.508d389f.cohuck@redhat.com>
In-Reply-To: <bb189d95-ddfc-7031-d0dd-7de3e0dd5a7f@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
        <1574945167-29677-7-git-send-email-pmorel@linux.ibm.com>
        <20191202152246.4d627b0e.cohuck@redhat.com>
        <aa588c00-79ac-2942-7911-b476abb224db@linux.ibm.com>
        <20191202191541.1ffd987e.cohuck@redhat.com>
        <bb189d95-ddfc-7031-d0dd-7de3e0dd5a7f@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: WYwNutRWP_uvq7NS4Bqtmg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2 Dec 2019 19:33:59 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2019-12-02 19:15, Cornelia Huck wrote:
> > On Mon, 2 Dec 2019 18:53:16 +0100
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> On 2019-12-02 15:22, Cornelia Huck wrote:  
> >>> On Thu, 28 Nov 2019 13:46:04 +0100
> >>> Pierre Morel <pmorel@linux.ibm.com> wrote:  
> >   
> >>>> +static int test_device_sid;
> >>>> +
> >>>> +static void test_enumerate(void)
> >>>> +{
> >>>> +	struct pmcw *pmcw = &schib.pmcw;
> >>>> +	int sid;
> >>>> +	int ret, i;
> >>>> +	int found = 0;
> >>>> +
> >>>> +	for (sid = 0; sid < 0xffff; sid++) {
> >>>> +		ret = stsch(sid|SID_ONE, &schib);  
> >>>
> >>> This seems a bit odd. You are basically putting the subchannel number
> >>> into sid, OR in the one, and then use the resulting value as the sid
> >>> (subchannel identifier).
> >>>      
> >>>> +		if (!ret && (pmcw->flags & PMCW_DNV)) {
> >>>> +			report_info("SID %04x Type %s PIM %x", sid,  
> >>>
> >>> That's not a sid, but the subchannel number (see above).
> >>>      
> >>>> +				     Channel_type[pmcw->st], pmcw->pim);
> >>>> +			for (i = 0; i < 8; i++)  {
> >>>> +				if ((pmcw->pim << i) & 0x80) {
> >>>> +					report_info("CHPID[%d]: %02x", i,
> >>>> +						    pmcw->chpid[i]);
> >>>> +					break;
> >>>> +				}
> >>>> +			}
> >>>> +			found++;
> >>>> +	
> >>>> +		}  
> >>>
> >>> Here, you iterate over the 0-0xffff range, even if you got a condition
> >>> code 3 (indicating no more subchannels in that set). Is that
> >>> intentional?  
> >>
> >> I thought there could be more subchannels.
> >> I need then a break in the loop when this happens.
> >> I will reread the PoP to see how to find that no more subchannel are in
> >> that set.  
> > 
> > The fact that cc 3 for stsch == no more subchannels is unfortunately a
> > bit scattered across the PoP :/ Dug it out some time ago, maybe it's
> > still in the archives somewhere...  
> 
> So the the subchannel are always one after the other?

While QEMU (and z/VM) usually do that, they can really be scattered
around. For the in-between I/O subchannels that don't lead to a device,
you'll still get cc 0, it's just the dnv bit that is 0. The cc 3
basically just tells you that you can stop looking.

