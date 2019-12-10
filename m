Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40355118317
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 10:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfLJJKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 04:10:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57065 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726986AbfLJJKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 04:10:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575969000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bfdwg3HBXXb8e6P6YTAh5w5KDxmzDBB9nzyoI5PsLMY=;
        b=HeYZJi0tQJBoOBxpW42qUk5NANrarkpfSHIEYmKbcFXNG/vkqVG0g2s/SQ7Q9m9VCitf62
        XDbgqLlTDCElUP7N7g/+PTpO4WSC+WGeQ6epdwNZjq52TjU5KvDLZNig6197MnY8BXMnGO
        wbvblTHioqgEwk+0bBecCZC8FZxBT8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-RQ2ia44HNvaCWrQyi7Q82w-1; Tue, 10 Dec 2019 04:09:57 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EEB7DBE5;
        Tue, 10 Dec 2019 09:09:56 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C2A85D6D6;
        Tue, 10 Dec 2019 09:09:52 +0000 (UTC)
Date:   Tue, 10 Dec 2019 10:09:50 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 7/9] s390x: css: msch, enable test
Message-ID: <20191210100950.466e6211.cohuck@redhat.com>
In-Reply-To: <a19d7e91-4048-3eaa-a819-51e95dd922de@linux.ibm.com>
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
        <1575649588-6127-8-git-send-email-pmorel@linux.ibm.com>
        <20191209175430.5381b328.cohuck@redhat.com>
        <a19d7e91-4048-3eaa-a819-51e95dd922de@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: RQ2ia44HNvaCWrQyi7Q82w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Dec 2019 10:01:46 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2019-12-09 17:54, Cornelia Huck wrote:
> > On Fri,  6 Dec 2019 17:26:26 +0100
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
> >>   s390x/css.c | 39 +++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 39 insertions(+)
> >>
> >> diff --git a/s390x/css.c b/s390x/css.c
> >> index 3d4a986..4c0031c 100644
> >> --- a/s390x/css.c
> >> +++ b/s390x/css.c
> >> @@ -58,11 +58,50 @@ static void test_enumerate(void)
> >>   	report("Tested %d devices, %d found", 1, scn, found);
> >>   }
> >>   
> >> +static void test_enable(void)
> >> +{
> >> +	struct pmcw *pmcw = &schib.pmcw;
> >> +	int cc;
> >> +
> >> +	if (!test_device_sid) {
> >> +		report_skip("No device");
> >> +		return;
> >> +	}
> >> +	/* Read the SCIB for this subchannel */  
> > 
> > s/SCIB/SCHIB/  
> 
> yes
> 
> >   
> >> +	cc = stsch(test_device_sid, &schib);
> >> +	if (cc) {
> >> +		report("stsch cc=%d", 0, cc);
> >> +		return;
> >> +	}
> >> +	/* Update the SCHIB to enable the channel */
> >> +	pmcw->flags |= PMCW_ENABLE;
> >> +
> >> +	/* Tell the CSS we want to modify the subchannel */
> >> +	cc = msch(test_device_sid, &schib);
> >> +	if (cc) {
> >> +		report("msch cc=%d", 0, cc);  
> > 
> > So you expect the subchannel to be idle? Probably true, especially as
> > QEMU has no reason to post an unsolicited interrupt for a test device.
> >   
> >> +		return;
> >> +	}
> >> +
> >> +	/* Read the SCHIB again to verify the enablement */
> >> +	cc = stsch(test_device_sid, &schib);
> >> +	if (cc) {
> >> +		report("stsch cc=%d", 0, cc);
> >> +		return;
> >> +	}
> >> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> >> +		report("Enable failed. pmcw: %x", 0, pmcw->flags);  
> > 
> > This check is fine when running under KVM. If this test is modified to
> > run under z/VM in the future, you probably should retry here: I've seen
> > the enable bit 'stick' only after the second msch() there.  
> 
> Oh. Thanks, may be I can loop with a delay and count.

FWIW, the Linux kernel code is trying 5 times.

> If I need to do this may be I need to create dedicated sub-functions to 
> include the sanity tests.

I'm not sure how worthwhile investing time here is, actually: If you
don't plan to run under anything but KVM, you won't need it. I'm not
sure if current versions of z/VM still display the same behaviour (it
has been some time...); on the other hand, it is compliant with the
architecture...

> 
> >   
> >> +		return;
> >> +	}
> >> +	report("Tested", 1);
> >> +}
> >> +
> >>   static struct {
> >>   	const char *name;
> >>   	void (*func)(void);
> >>   } tests[] = {
> >>   	{ "enumerate (stsch)", test_enumerate },
> >> +	{ "enable (msch)", test_enable },
> >>   	{ NULL, NULL }
> >>   };
> >>     
> >   
> 

