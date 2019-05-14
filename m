Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D875B1CA60
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 16:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfENO3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 10:29:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60171 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfENO3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 10:29:24 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB5DAC089A7E;
        Tue, 14 May 2019 14:29:20 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96B0B19752;
        Tue, 14 May 2019 14:29:15 +0000 (UTC)
Date:   Tue, 14 May 2019 16:29:13 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
Message-ID: <20190514162913.6db90f44.cohuck@redhat.com>
In-Reply-To: <85fe257b-721a-f900-32fa-011845f242ed@linux.ibm.com>
References: <20190503134912.39756-1-farman@linux.ibm.com>
        <20190503134912.39756-8-farman@linux.ibm.com>
        <8625f759-0a2d-09af-c8b5-5b312d854ba1@linux.ibm.com>
        <7c897993-d146-bf8e-48ad-11a914a04716@linux.ibm.com>
        <bba6c0a8-2346-cd99-b8ad-f316daac010b@linux.ibm.com>
        <7ac9fb43-8d7a-9e04-8cba-fa4c63dfc413@linux.ibm.com>
        <1f2e4272-8570-f93f-9d67-a43dcb00fc55@linux.ibm.com>
        <5c2b74a9-e1d9-cd63-1284-6544fa4376d9@linux.ibm.com>
        <20190510134718.3f727571.cohuck@redhat.com>
        <85fe257b-721a-f900-32fa-011845f242ed@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 14 May 2019 14:29:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 May 2019 10:24:31 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 5/10/19 7:47 AM, Cornelia Huck wrote:
> > On Wed, 8 May 2019 11:22:07 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> For the NOOP its clearly stated that it does not start a data transfer.
> >> If we pin the CDA, it could then eventually be the cause of errors if
> >> the address indicated by the CDA is not accessible.
> >>
> >> The NOOP is a particular CONTROL operation for which no data is transfered.
> >> Other CONTROL operation may start a data transfer.  
> > 
> > I've just looked at the documentation again.
> > 
> > The Olde Common I/O Device Commands document indicates that a NOOP
> > simply causes channel end/device end.
> > 
> > The PoP seems to indicate that the cda is always checked (i.e. does it
> > point to a valid memory area?), but I'm not sure whether the area that
> > is pointed to is checked for accessibility etc. as well, even if the
> > command does not transfer any data.
> > 
> > Has somebody tried to find out what happens on Real Hardware(tm) if you
> > send a command that is not supposed to transfer any data where the cda
> > points to a valid, but not accessible area?  
> 
> Hrm...  The CDA itself?  I don't think so.  Since every CCW is converted 
> to an IDAL in vfio-ccw, we guarantee that it's pointing to something 
> valid at that point.
> 
> So, I hacked ccwchain_fetch_direct() to NOT set the IDAL flag in a NOP 
> CCW, and to leave the CDA alone.  This means it will still contain the 
> guest address, which is risky but hey it's a test system.  :)  (I 
> offline'd a bunch of host memory too, to make sure I had some 
> unavailable addresses.)
> 
> In my traces, the non-IDA NOP CCWs were issued to the host with and 
> without the skip flag, with zero and non-zero counts, and with zero and 
> non-zero CDAs.  All of them work just fine, including the ones who's 
> addresses fall into the offline space.  Even the combination of no skip, 
> non-zero count, and zero cda.
> 
> I modified that hack to do the same for a known invalid control opcode, 
> and it seemed to be okay too.  We got an (expected) invalid command 
> before we noticed any problem with the provided address.

That's interesting; I would not have arrived at this by interpreting
the PoP...

> > 
> > In general, I think doing the translation (and probably already hitting
> > errors there) is better than sending down a guest address.
> >   
> 
> I mostly agree, but I have one test program that generates invalid GUEST 
> addresses with its NOP CCWs, since it doesn't seem to care about whether 
> they're valid or not.  So any attempt to pin them will end badly, which 
> is why I call that opcode out in ccw_does_data_transfer(), and just send 
> invalid IDAWs with it.

So, without the attempt to pin they do not fail? Maybe the right
approach would be to rewrite the cda before sending the ccws?
