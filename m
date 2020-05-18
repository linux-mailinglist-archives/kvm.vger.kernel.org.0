Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C481D7DF0
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgERQJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:09:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25589 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728209AbgERQJM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 12:09:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589818151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4cLRGfEJrT34Zs0HHrKeCdIpNu/IJcAp2lPPWYOLxio=;
        b=N0FgDqI6+IPgcsvqPGCycSriWHSrIHRb89GOdxgi2fyOk7aK2kNzNdCtVSK7gqahfTB47C
        +8oC4yTHJp6FjwsjHP5dn7sm9dKwbDlPd6vIQVKK81iyitj969mZZ58gokclONFnsaKPJ4
        iEtFN82XlmANhnwK3UGy9VY3kjW8DCw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-8bXDv3rVPoGiBmfz8wzQug-1; Mon, 18 May 2020 12:09:08 -0400
X-MC-Unique: 8bXDv3rVPoGiBmfz8wzQug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D73BB100CCD9;
        Mon, 18 May 2020 16:09:06 +0000 (UTC)
Received: from gondolin (ovpn-113-28.ams2.redhat.com [10.36.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A30D182A0D;
        Mon, 18 May 2020 16:09:05 +0000 (UTC)
Date:   Mon, 18 May 2020 18:09:03 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20200518180903.7cb21dd8.cohuck@redhat.com>
In-Reply-To: <20200513142934.28788-1-farman@linux.ibm.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 May 2020 16:29:30 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Hi Conny,
> 
> Back in January, I suggested a small patch [1] to try to clean up
> the handling of HSCH/CSCH interrupts, especially as it relates to
> concurrent SSCH interrupts. Here is a new attempt to address this.
> 
> There was some suggestion earlier about locking the FSM, but I'm not
> seeing any problems with that. Rather, what I'm noticing is that the
> flow between a synchronous START and asynchronous HALT/CLEAR have
> different impacts on the FSM state. Consider:
> 
>     CPU 1                           CPU 2
> 
>     SSCH (set state=CP_PENDING)
>     INTERRUPT (set state=IDLE)
>     CSCH (no change in state)
>                                     SSCH (set state=CP_PENDING)

This is the transition I do not understand. When we get a request via
the I/O area, we go to CP_PROCESSING and start doing translations.
However, we only transition to CP_PENDING if we actually do a SSCH with
cc 0 -- which shouldn't be possible in the flow you outline... unless
it really is something that can be taken care of with locking (state
machine transitioning due to an interrupt without locking, so we go to
IDLE without other parts noticing.)

>     INTERRUPT (set state=IDLE)
>                                     INTERRUPT (set state=IDLE)

But taking a step back (and ignoring your series and the discussion,
sorry about that):

We need to do something (creating a local translation of the guest's
channel program) that does not have any relation to the process in the
architecture at all, but is only something that needs to be done
because of what vfio-ccw is trying to do (issuing a channel program on
behalf of another entity.) Trying to sort that out by poking at actl
and fctl bits does not seem like the best way; especially as keeping
the bits up-to-date via STSCH is an exercise in futility.

What about the following (and yes, I had suggested something vaguely in
that direction before):

- Detach the cp from the subchannel (or better, remove the 1:1
  relationship). By that I mean building the cp as a separately
  allocated structure (maybe embedding a kref, but that might not be
  needed), and appending it to a list after SSCH with cc=0. Discard it
  if cc!=0.
- Remove the CP_PENDING state. The state is either IDLE after any
  successful SSCH/HSCH/CSCH, or a new state in that case. But no
  special state for SSCH.
- A successful CSCH removes the first queued request, if any.
- A final interrupt removes the first queued request, if any.

Thoughts?

