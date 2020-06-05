Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111651EF3A2
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 11:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgFEJDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 05:03:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32391 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726096AbgFEJDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 05:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591347779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E9W+ssSzRMZht+8FbnsLQ8QYoERTC5Emg1mIe1OGFO4=;
        b=cMy1hk6Tv13I8MpT/xLzxna0XBR6BQj3PGMuNoA+9xwUEk4jbuT8tApRUN41UaR2Dj1SxZ
        oIlHikR43IJY6WljgUoJmLjUkI+j/8n9ja/tFipCj4EgC8Ma+ZXYBJJEaX+QVbqcXa/jf1
        52OhqmMPu7uQer9qziPLGUwmljqJd0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-I_Dy0O-yP2SeJX2gOScNTQ-1; Fri, 05 Jun 2020 05:02:57 -0400
X-MC-Unique: I_Dy0O-yP2SeJX2gOScNTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF6C619200C8;
        Fri,  5 Jun 2020 09:02:55 +0000 (UTC)
Received: from gondolin (ovpn-113-2.ams2.redhat.com [10.36.113.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A2DB5C1B0;
        Fri,  5 Jun 2020 09:02:51 +0000 (UTC)
Date:   Fri, 5 Jun 2020 11:02:50 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 11/12] s390x: css: ssch/tsch with
 sense and interrupt
Message-ID: <20200605110250.461ea3b7.cohuck@redhat.com>
In-Reply-To: <a53f84e9-8e32-2ac2-2af1-0edd911841c4@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
        <1589818051-20549-12-git-send-email-pmorel@linux.ibm.com>
        <20200527120905.5fb20a4e.cohuck@redhat.com>
        <a53f84e9-8e32-2ac2-2af1-0edd911841c4@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Jun 2020 09:37:39 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-05-27 12:09, Cornelia Huck wrote:
> > On Mon, 18 May 2020 18:07:30 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> We add a new css_lib file to contain the I/O functions we may
> >> share with different tests.
> >> First function is the subchannel_enable() function.
> >>
> >> When a channel is enabled we can start a SENSE_ID command using
> >> the SSCH instruction to recognize the control unit and device.
> >>
> >> This tests the success of SSCH, the I/O interruption and the TSCH
> >> instructions.
> >>
> >> The test expects a device with a control unit type of 0xC0CA as the
> >> first subchannel of the CSS.  
> > 
> > It might make sense to extend this to be able to check for any expected
> > type (e.g. 0x3832, should my suggestion to split css tests and css-pong
> > tests make sense.)  
> 
> right.
> 
> >   
> >>
> >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >> ---
> >>   lib/s390x/css.h     |  20 ++++++
> >>   lib/s390x/css_lib.c |  55 +++++++++++++++++
> >>   s390x/Makefile      |   1 +
> >>   s390x/css.c         | 145 ++++++++++++++++++++++++++++++++++++++++++++
> >>   4 files changed, 221 insertions(+)
> >>   create mode 100644 lib/s390x/css_lib.c  
> > 
> > (...)
> >   
> >> +int enable_subchannel(unsigned int sid)
> >> +{
> >> +	struct schib schib;
> >> +	struct pmcw *pmcw = &schib.pmcw;
> >> +	int try_count = 5;
> >> +	int cc;
> >> +
> >> +	if (!(sid & SID_ONE))
> >> +		return -1;  
> > 
> > Hm... this error is indistinguishable for the caller from a cc 1 for
> > the msch. Use something else (as this is a coding error)?  
> 
> right it is a coding error -> assert ?

Sounds good to me.

