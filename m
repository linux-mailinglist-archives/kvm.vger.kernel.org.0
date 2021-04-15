Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9C1361001
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 18:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhDOQUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 12:20:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231137AbhDOQUe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 12:20:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618503610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81EDjnbmWofuicsm+f7F7vx8N+7EXRYt+1pDhkg203I=;
        b=gmRwMNZ8iNF8qeRLbS+D7BI3j7REV1IJVY5ch9Taaf9mWyJiAXAhvN4RHRGlzQc8rssFJJ
        DDAfA7r/CdEw8o7QCT/U9Un2d6D6+2vnaMEFrgSvlOOwinh+cZ0uBioOuoeJm37ZvTr7qp
        rArUtlCBFxVcP/hon/fl40d7yf9Dvy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-BP-Df-7-Pr-2f9s9MEwu9g-1; Thu, 15 Apr 2021 12:19:57 -0400
X-MC-Unique: BP-Df-7-Pr-2f9s9MEwu9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40D03802B5B;
        Thu, 15 Apr 2021 16:19:55 +0000 (UTC)
Received: from gondolin (ovpn-112-220.ams2.redhat.com [10.36.112.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3C506086F;
        Thu, 15 Apr 2021 16:19:53 +0000 (UTC)
Date:   Thu, 15 Apr 2021 18:19:51 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v4 2/4] vfio-ccw: Check workqueue before doing START
Message-ID: <20210415181951.2f13fdcc.cohuck@redhat.com>
In-Reply-To: <ac08eb1143b5d354b8bcaf9117178fbd91bc2af2.camel@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
        <20210413182410.1396170-3-farman@linux.ibm.com>
        <20210415125131.33065221.cohuck@redhat.com>
        <ac08eb1143b5d354b8bcaf9117178fbd91bc2af2.camel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Apr 2021 09:48:37 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On Thu, 2021-04-15 at 12:51 +0200, Cornelia Huck wrote:

> > I'm wondering what we should do for hsch. We probably want to return
> > -EBUSY for a pending condition as well, if I read the PoP
> > correctly...  
> 
> Ah, yes...  I agree that to maintain parity with ssch and pops, the
> same cc1/-EBUSY would be applicable here. Will make that change in next
> version.

Yes, just to handle things in the same fashion consistently.

> 
> > the only problem is that QEMU seems to match everything to 0; but
> > that
> > is arguably not the kernel's problem.
> > 
> > For clear, we obviously don't have busy conditions. Should we clean
> > up
> > any pending conditions?  
> 
> By doing anything other than issuing the csch to the subchannel?  I
> don't think so, that should be more than enough to get the css and
> vfio-ccw in sync with each other.

Hm, doesn't a successful csch clear any status pending? That would mean
that invoking our csch backend implies that we won't deliver the status
pending that is already pending via the workqueue, which therefore
needs to be flushed out in some way? I remember we did some special
csch handling, but I don't immediately see where; might have been only
in QEMU.

