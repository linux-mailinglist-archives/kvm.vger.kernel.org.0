Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51771D9561
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 13:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgESLgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 07:36:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40803 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726508AbgESLgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 07:36:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589888173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VSNDSyqq2eceaaRSfVfkw2mUMCtppyFN0vycEBVkpw4=;
        b=Koqyi9G50JzcTf0tzShgKGiCjUS7XlarSkqUdCQ+Js7r4ZN4MD0vyTTqdSAKC1laD91PAE
        uJ8g4HKJI0aXZUvR1nz0oDhGCBfkdriytHQwflyla26+hHfX0jq+pDvEEcQ2obp6tK2CC3
        vz2bfEvT2iSbqrKZ8osDY11QsOj0xPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-qHN78-6ePf-eJVak8g7bwQ-1; Tue, 19 May 2020 07:36:11 -0400
X-MC-Unique: qHN78-6ePf-eJVak8g7bwQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 813B1835B44;
        Tue, 19 May 2020 11:36:10 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E1B25C1C5;
        Tue, 19 May 2020 11:36:09 +0000 (UTC)
Date:   Tue, 19 May 2020 13:36:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20200519133606.56e019b3.cohuck@redhat.com>
In-Reply-To: <20200519000943.70098774.pasic@linux.ibm.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
        <20200518180903.7cb21dd8.cohuck@redhat.com>
        <20200519000943.70098774.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 May 2020 00:09:43 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Mon, 18 May 2020 18:09:03 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:

> > But taking a step back (and ignoring your series and the discussion,
> > sorry about that):
> > 
> > We need to do something (creating a local translation of the guest's
> > channel program) that does not have any relation to the process in the
> > architecture at all, but is only something that needs to be done
> > because of what vfio-ccw is trying to do (issuing a channel program on
> > behalf of another entity.)   
> 
> I violently disagree with this point. Looking at the whole vfio-ccw
> device the translation is part of the execution of the channel program,
> more specifically it fits in as prefetching. Thus it needs to happen
> with the FC start bit set. Before FC start is set the subchannel is
> not allowed to process (including look at) the channel program. At least
> that is what I remember.

I fear we really have to agree to disagree here. The PoP describes how
a SSCH etc. has to be done and what reaction to expect. It does not
cover the 'SSCH on behalf of someone else' pattern: only what we can
expect from that second SSCH, and what the guest can expect from us. In
particular, the PoP does not specify anything about how a hypervisor is
supposed to handle I/O from its guests (and why should it?)

> 
> > Trying to sort that out by poking at actl
> > and fctl bits does not seem like the best way; especially as keeping
> > the bits up-to-date via STSCH is an exercise in futility.  
> 
> I disagree. A single subchannel is processing at most one channel
> program at any given point in time. Or am I reading the PoP wrong?

The hypervisor cannot know the exact status of the subchannel. It only
knows the state of the subchannel at the time it issued its last STSCH.
Anything else it needs to track is the hypervisor's business, and
ideally, it should track that in its own control structures. (I know we
muck around with the control bits today; but maybe that's not the best
idea.)

> 
> > 
> > What about the following (and yes, I had suggested something vaguely in
> > that direction before):
> > 
> > - Detach the cp from the subchannel (or better, remove the 1:1
> >   relationship). By that I mean building the cp as a separately
> >   allocated structure (maybe embedding a kref, but that might not be
> >   needed), and appending it to a list after SSCH with cc=0. Discard it
> >   if cc!=0.
> > - Remove the CP_PENDING state. The state is either IDLE after any
> >   successful SSCH/HSCH/CSCH, or a new state in that case. But no
> >   special state for SSCH.
> > - A successful CSCH removes the first queued request, if any.
> > - A final interrupt removes the first queued request, if any.
> > 
> > Thoughts?
> >   
> 
> See above. IMHO the second SSCH is to be rejected by QEMU. I've
> explained this in more detail in my previous mail.

I don't think we should rely on whatever QEMU is or isn't doing. We
should not get all tangled up if userspace is doing weird stuff.

