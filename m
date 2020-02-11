Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB33158B3C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 09:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgBKI11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 03:27:27 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59332 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbgBKI11 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 03:27:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581409646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d7ss5M2fXctZyyGGmd7PQOHII6fHvf+22SW6sevctzw=;
        b=LlelqcsyqYLFJXV3HNWTiq+lI1KAH3VylOfkG7QmUQ9fWkG0e2v0piy6rZJb07lkUwacmV
        RUGunTCGpi7grmB948I1Phu7USApuYcrSs/Sw12FGW+X6/dv7tuJgOQtNGt3m5lc78cEmg
        Tw+xZzQl2TR+rfKt5b3rWheDwd/yQIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-oEUvoGaaMWyTSNWmu6X55g-1; Tue, 11 Feb 2020 03:27:21 -0500
X-MC-Unique: oEUvoGaaMWyTSNWmu6X55g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D467913E6;
        Tue, 11 Feb 2020 08:27:19 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D47326FDD;
        Tue, 11 Feb 2020 08:27:15 +0000 (UTC)
Date:   Tue, 11 Feb 2020 09:27:12 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 24/35] KVM: s390: protvirt: disallow one_reg
Message-ID: <20200211092712.43064a10.cohuck@redhat.com>
In-Reply-To: <df4805f2-0c51-6ee9-2082-42d0f2276bd3@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-25-borntraeger@de.ibm.com>
        <20200210185307.73b45f78.cohuck@redhat.com>
        <df4805f2-0c51-6ee9-2082-42d0f2276bd3@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Feb 2020 19:34:56 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 10.02.20 18:53, Cornelia Huck wrote:
> > On Fri,  7 Feb 2020 06:39:47 -0500
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> From: Janosch Frank <frankja@linux.ibm.com>
> >>
> >> A lot of the registers are controlled by the Ultravisor and never
> >> visible to KVM. Some fields in the sie control block are overlayed,
> >> like gbea. As no userspace uses the ONE_REG interface on s390 it is safe
> >> to disable this for protected guests.  
> > 
> > Last round, I suggested
> > 
> > "As no known userspace uses the ONE_REG interface on s390 if sync regs
> > are available, no functionality is lost if it is disabled for protected
> > guests."  
> 
> If you think this variant is better I can use this, I am fine with either. 

Well, yes :) I was afraid that it fell through the cracks.

> > 
> > Any opinion on that?
> >   
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> Reviewed-by: Thomas Huth <thuth@redhat.com>
> >> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  Documentation/virt/kvm/api.txt | 6 ++++--
> >>  arch/s390/kvm/kvm-s390.c       | 3 +++
> >>  2 files changed, 7 insertions(+), 2 deletions(-)  
> >   
> 

