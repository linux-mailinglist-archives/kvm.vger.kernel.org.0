Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701FC19C55E
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 17:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389123AbgDBPDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 11:03:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388744AbgDBPDf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 11:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585839813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3tCmUjElbtI+7rfW6lXDpkb9aCERk0wwpDFHP5OJmcc=;
        b=gYQEIa/EymM18jMv+1QBauQ9wzy6tH3JLk2V5fdfM6mrNwvteya5MN2SWgLK0Pi0y26nMR
        5G78ezGtJrnthvtfHuhmfaisMWv+/GRMNRi4yv/qXYJC0zmZtBe3RfLlSCLWRECrMzPcfE
        kQ5+McqiMJ/oCZZQ+WWg/jm5gIHTsvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304---bL9U9BOdyglyAS_KSfLw-1; Thu, 02 Apr 2020 11:03:32 -0400
X-MC-Unique: --bL9U9BOdyglyAS_KSfLw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E28D8017F4;
        Thu,  2 Apr 2020 15:03:31 +0000 (UTC)
Received: from gondolin (ovpn-113-176.ams2.redhat.com [10.36.113.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33993DA118;
        Thu,  2 Apr 2020 15:03:27 +0000 (UTC)
Date:   Thu, 2 Apr 2020 17:03:24 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests v2] s390x/smp: add minimal test for sigp sense
 running status
Message-ID: <20200402170324.75a2e276.cohuck@redhat.com>
In-Reply-To: <c76d018e-9a70-06c0-a1be-aa6c4a76d27a@de.ibm.com>
References: <20200402110250.63677-1-borntraeger@de.ibm.com>
        <b1766baa-ca91-b1b4-c9e4-653ae4257cea@linux.ibm.com>
        <7ad39b82-171c-5ffa-a10c-1dd04358f6c2@de.ibm.com>
        <c252805d-a396-bebe-a4c1-77521adf598f@linux.ibm.com>
        <c76d018e-9a70-06c0-a1be-aa6c4a76d27a@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Apr 2020 16:47:44 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 02.04.20 15:41, Janosch Frank wrote:
> > On 4/2/20 2:29 PM, Christian Borntraeger wrote:  
> >>
> >>
> >> On 02.04.20 14:18, Janosch Frank wrote:  
> >>> On 4/2/20 1:02 PM, Christian Borntraeger wrote:  
> >>>> make sure that sigp sense running status returns a sane value for  
> >>>
> >>> s/m/M/
> >>>  
> >>>> stopped CPUs. To avoid potential races with the stop being processed we
> >>>> wait until sense running status is first 0.  
> >>>
> >>> ENOPARSE "...is first 0?"  
> >>
> >> Yes,  what about "....smp_sense_running_status returns false." ?  
> > 
> > sure, or "returns 0"
> > "is first 0" just doesn't parse :)
> >   
> >>  
> >>>  
> >>>>
> >>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >>>> ---
> >>>>  lib/s390x/smp.c |  2 +-
> >>>>  lib/s390x/smp.h |  2 +-
> >>>>  s390x/smp.c     | 13 +++++++++++++
> >>>>  3 files changed, 15 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> >>>> index 5ed8b7b..492cb05 100644
> >>>> --- a/lib/s390x/smp.c
> >>>> +++ b/lib/s390x/smp.c
> >>>> @@ -58,7 +58,7 @@ bool smp_cpu_stopped(uint16_t addr)
> >>>>  	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
> >>>>  }
> >>>>  
> >>>> -bool smp_cpu_running(uint16_t addr)
> >>>> +bool smp_sense_running_status(uint16_t addr)
> >>>>  {
> >>>>  	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
> >>>>  		return true;
> >>>> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> >>>> index a8b98c0..639ec92 100644
> >>>> --- a/lib/s390x/smp.h
> >>>> +++ b/lib/s390x/smp.h
> >>>> @@ -40,7 +40,7 @@ struct cpu_status {
> >>>>  int smp_query_num_cpus(void);
> >>>>  struct cpu *smp_cpu_from_addr(uint16_t addr);
> >>>>  bool smp_cpu_stopped(uint16_t addr);
> >>>> -bool smp_cpu_running(uint16_t addr);
> >>>> +bool smp_sense_running_status(uint16_t addr);  
> >>>
> >>> That's completely unrelated to the test  
> >>
> >> Right but this name seems to better reflect what the function does. Because this is not
> >> the oppositite of cpu_stopped.  
> > 
> > I'm pondering if we want to split that out.  
> 
> A single patch for just 2 lines? I dont know.

I vote for keeping it in the patch and simply mentioning it in the
commit message.

> >   
> >>>  
> >>>>  int smp_cpu_restart(uint16_t addr);
> >>>>  int smp_cpu_start(uint16_t addr, struct psw psw);
> >>>>  int smp_cpu_stop(uint16_t addr);
> >>>> diff --git a/s390x/smp.c b/s390x/smp.c
> >>>> index 79cdc1f..b4b1ff2 100644
> >>>> --- a/s390x/smp.c
> >>>> +++ b/s390x/smp.c
> >>>> @@ -210,6 +210,18 @@ static void test_emcall(void)
> >>>>  	report_prefix_pop();
> >>>>  }
> >>>>  
> >>>> +static void test_sense_running(void)
> >>>> +{
> >>>> +	report_prefix_push("sense_running");
> >>>> +	/* make sure CPU is stopped */
> >>>> +	smp_cpu_stop(1);
> >>>> +	/* wait for stop to succeed. */
> >>>> +	while(smp_sense_running_status(1));
> >>>> +	report(!smp_sense_running_status(1), "CPU1 sense claims not running");  
> >>>
> >>> That's basically true anyway after the loop, no?  
> >>
> >> Yes, but  you get no "positive" message in the more verbose output variants
> >> without a report statement.  
> > 
> > report(true, "CPU1 sense claims not running");
> > That's also possible, but I leave that up to you.  
> 
> I do not care, both variants are fine. Whatever you or David prefer. 

I'd keep the 'check' for !smp_sense_running_status(1) and add a comment.

