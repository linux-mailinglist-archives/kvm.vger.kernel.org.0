Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD2415306D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgBEML6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:11:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726597AbgBEML5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 07:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580904717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OGXz7pz38Jnt1LvODbA2vv6Yak9eBfHUGuKGnkc08CY=;
        b=F0rAXcsDFDuAEADeRQdzD1bn6uXlW0ExSgCNRW9GyrvQtuluG9WgNltD4FLKoO0R8b0ipr
        Dg17s60yBZEGOp2kAeeNfbAnTpEB9hdcOrh7WBkLCXZ0VAnGYSe868LmbsCWCnqPYGCbsC
        dt1l29lGiSXjNjQ8OhjO2BMaZaXsu6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-hxzArFMtMlW93P3m6xz8bA-1; Wed, 05 Feb 2020 07:11:53 -0500
X-MC-Unique: hxzArFMtMlW93P3m6xz8bA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EDD51081FA1;
        Wed,  5 Feb 2020 12:11:52 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57EBB19C7F;
        Wed,  5 Feb 2020 12:11:48 +0000 (UTC)
Date:   Wed, 5 Feb 2020 13:11:46 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 15/37] KVM: s390: protvirt: Implement interruption
 injection
Message-ID: <20200205131146.611a0d78.cohuck@redhat.com>
In-Reply-To: <512413a4-196e-5acb-9583-561c061e40ee@linux.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-16-borntraeger@de.ibm.com>
        <20200205123133.34ac71a2.cohuck@redhat.com>
        <512413a4-196e-5acb-9583-561c061e40ee@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Feb 2020 12:46:39 +0100
Michael Mueller <mimu@linux.ibm.com> wrote:

> On 05.02.20 12:31, Cornelia Huck wrote:
> > On Mon,  3 Feb 2020 08:19:35 -0500
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> From: Michael Mueller <mimu@linux.ibm.com>
> >>
> >> The patch implements interruption injection for the following
> >> list of interruption types:
> >>
> >>    - I/O
> >>      __deliver_io (III)
> >>
> >>    - External
> >>      __deliver_cpu_timer (IEI)
> >>      __deliver_ckc (IEI)
> >>      __deliver_emergency_signal (IEI)
> >>      __deliver_external_call (IEI)
> >>
> >>    - cpu restart
> >>      __deliver_restart (IRI)  
> > 
> > Hm... what do 'III', 'IEI', and 'IRI' stand for?  
> 
> that's the kind of interruption injection being used:
> 
> inject io interruption
> inject external interruption
> inject restart interruption

So, maybe make this:

- I/O (uses inject io interruption)
  __ deliver_io

- External (uses inject external interruption)
(and so on)

I find using the acronyms without explanation very confusing.

> 
> >   
> >>
> >> The service interrupt is handled in a followup patch.
> >>
> >> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> [fixes]
> >> ---
> >>   arch/s390/include/asm/kvm_host.h |  8 +++
> >>   arch/s390/kvm/interrupt.c        | 93 ++++++++++++++++++++++----------
> >>   2 files changed, 74 insertions(+), 27 deletions(-)

