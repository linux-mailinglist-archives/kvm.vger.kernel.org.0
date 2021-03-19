Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75256341B61
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 12:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCSLYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 07:24:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhCSLYC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 07:24:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616153041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xt3Dc0IriPiJ0s8ZrlN93wzqhTMraBDdfF5e3x8dBNc=;
        b=EZDGoK6LiOYX6DfjLRHEx8NgH0IuEfrEjXkvC66GVhaxrlD/IXIzHegHOKaw/dCafqQXPa
        KLDvdF3zhljy457AsJwhd8kzXnijlAynGfGAPhOKmSZI9ekhHkEvcou7+N/tJ4Bpw8ESzC
        law39TLyB/4LP+VESksl6qWsCt2M3rM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-G4XEtg2dNwuk2HXHqhBD0g-1; Fri, 19 Mar 2021 07:23:59 -0400
X-MC-Unique: G4XEtg2dNwuk2HXHqhBD0g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A52A318C8C0D;
        Fri, 19 Mar 2021 11:23:58 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01B7D10013D7;
        Fri, 19 Mar 2021 11:23:53 +0000 (UTC)
Date:   Fri, 19 Mar 2021 12:23:51 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 4/6] s390x: lib: css: add expectations
 to wait for interrupt
Message-ID: <20210319122351.407bdb65.cohuck@redhat.com>
In-Reply-To: <02a90318-2af5-d4eb-7329-425585bf51d3@linux.ibm.com>
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
        <1616073988-10381-5-git-send-email-pmorel@linux.ibm.com>
        <c9a38bd8-f091-d3e4-dea5-0ffd9f1cdf12@linux.ibm.com>
        <02a90318-2af5-d4eb-7329-425585bf51d3@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Mar 2021 10:50:09 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 3/19/21 10:09 AM, Janosch Frank wrote:
> > On 3/18/21 2:26 PM, Pierre Morel wrote:  
> >> When waiting for an interrupt we may need to check the cause of
> >> the interrupt depending on the test case.
> >>
> >> Let's provide the tests the possibility to check if the last valid
> >> IRQ received is for the expected instruction.  
> > 
> > s/instruction/command/?  
> 
> Right, instruction may not be the optimal wording.
> I/O architecture description have some strange (for me) wording, the 
> best is certainly to stick on this.
> 
> Then I will use "the expected function" here.
> 
> > 
> > We're checking for some value in an IO structure, right?
> > Instruction makes me expect an actual processor instruction.
> > 
> > Is there another word that can be used to describe what we're checking
> > here? If yes please also add it to the "pending" variable. "pending_fc"
> > or "pending_scsw_fc" for example.  
> 
> Pending is used to specify that the instruction has been accepted but 
> the according function is still pending, i.e. not finished and will stay 
> pending for a normal operation until the device active bit is set.
> 
> So pending is not the right word, what we check here is the function 
> control, indicating the function the status refers too.
> 
> >   
> >>  
> ...snip...
> 
> >>    * Only report failures.
> >>    */
> >> -int wait_and_check_io_completion(int schid)
> >> +int wait_and_check_io_completion(int schid, uint32_t pending)  
> 
> 
> Consequently I will change "pending" with "function_ctrl"
> 
> Thanks for forcing clarification
> I hope Connie will agree with this :)

I'm not quite sure yet :)

I/O wording and operation can be complicated... we basically have:

- various instructions: ssch, hsch, csch
- invoking one of those instructions may initiate a function at the
  subchannel
- if an instruction lead to a function being initiated (but not
  necessarily actually being performed!), the matching bit is set in
  the fctl
- the fctl bits are accumulative (e.g. if you do a hsch on a subchannel
  where a start function is still in progress, you'll have both the
  start and the halt function indicated) and only cleared after
  collecting final status

So, setting the function is a direct consequence of executing an I/O
instruction -- but the interrupt may not be directly related to *all*
of the functions that are indicated (e.g. in the example above, where
we may get an interrupt for the hsch, but none directly for the ssch;
you can also add a csch on top of this; fortunately, we only stack in
the start->halt->clear direction.)

Regarding wording:

Maybe

"if the last valid IRQ received is for the function expected
after executing an instruction or sequence of instructions."

and

int wait_and_check_io_completion(int schid, uint32_t expected_fctl)

?

