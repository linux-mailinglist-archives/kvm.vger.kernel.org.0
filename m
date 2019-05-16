Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45CB12030B
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 11:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfEPJ7u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 May 2019 05:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbfEPJ7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 05:59:50 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B200B308FB9D;
        Thu, 16 May 2019 09:59:49 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 778B96A257;
        Thu, 16 May 2019 09:59:48 +0000 (UTC)
Date:   Thu, 16 May 2019 11:59:46 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 5/7] s390/cio: Allow zero-length CCWs in vfio-ccw
Message-ID: <20190516115946.11d18510.cohuck@redhat.com>
In-Reply-To: <39c7904f-7f9b-473d-201d-8d6aae4c490b@linux.ibm.com>
References: <20190514234248.36203-1-farman@linux.ibm.com>
        <20190514234248.36203-6-farman@linux.ibm.com>
        <20190515142339.12065a1d.cohuck@redhat.com>
        <f309cad9-9265-e276-8d57-8b6387f6fed7@linux.ibm.com>
        <39c7904f-7f9b-473d-201d-8d6aae4c490b@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 16 May 2019 09:59:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 May 2019 16:08:18 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 05/15/2019 11:04 AM, Eric Farman wrote:
> > 
> > 
> > On 5/15/19 8:23 AM, Cornelia Huck wrote:  
> >> On Wed, 15 May 2019 01:42:46 +0200
> >> Eric Farman <farman@linux.ibm.com> wrote:
> >>  
> >>> It is possible that a guest might issue a CCW with a length of zero,
> >>> and will expect a particular response.  Consider this chain:
> >>>
> >>>     Address   Format-1 CCW
> >>>     --------  -----------------
> >>>   0 33110EC0  346022CC 33177468
> >>>   1 33110EC8  CF200000 3318300C
> >>>
> >>> CCW[0] moves a little more than two pages, but also has the
> >>> Suppress Length Indication (SLI) bit set to handle the expectation
> >>> that considerably less data will be moved.  CCW[1] also has the SLI
> >>> bit set, and has a length of zero.  Once vfio-ccw does its magic,
> >>> the kernel issues a start subchannel on behalf of the guest with this:
> >>>
> >>>     Address   Format-1 CCW
> >>>     --------  -----------------
> >>>   0 021EDED0  346422CC 021F0000
> >>>   1 021EDED8  CF240000 3318300C
> >>>
> >>> Both CCWs were converted to an IDAL and have the corresponding flags
> >>> set (which is by design), but only the address of the first data
> >>> address is converted to something the host is aware of.  The second
> >>> CCW still has the address used by the guest, which happens to be (A)
> >>> (probably) an invalid address for the host, and (B) an invalid IDAW
> >>> address (doubleword boundary, etc.).
> >>>
> >>> While the I/O fails, it doesn't fail correctly.  In this example, we
> >>> would receive a program check for an invalid IDAW address, instead of
> >>> a unit check for an invalid command.
> >>>
> >>> To fix this, revert commit 4cebc5d6a6ff ("vfio: ccw: validate the
> >>> count field of a ccw before pinning") and allow the individual fetch
> >>> routines to process them like anything else.  We'll make a slight
> >>> adjustment to our allocation of the pfn_array (for direct CCWs) or
> >>> IDAL (for IDAL CCWs) memory, so that we have room for at least one
> >>> address even though no data will be transferred.
> >>>
> >>> Note that this doesn't provide us with a channel program that will
> >>> fail in the expected way.  Since our length is zero, vfio_pin_pages()  
> > 
> > s/is/was/
> >   
> >>> returns -EINVAL and cp_prefetch() will thus fail.  This will be fixed
> >>> in the next patch.  
> >>
> >> So, this failed before, and still fails, just differently?   
> > 
> > Probably.  If the guest gave us a valid address, the pin might actually 
> > work now whereas before it would fail because the length was zero.  If 
> > the address were also invalid,
> >   
> >  >IOW, this
> >> has no effect on bisectability?  
> > 
> > I think so, but I suppose that either (A) patch 5 and 6 could be 
> > squashed together, or (B) I could move the "set pa_nr to zero" (or more 
> > accurately, set it to ccw->count) pieces from patch 6 into this patch, 
> > so that the vfio_pin_pages() call occurs like it does today.
> >   
> >>  
> 
> While going through patch 5, I was confused as to why we need to pin 
> pages if we are only trying to translate the addresses and no data 
> transfer will take place with count==0. Well, you answer that in patch 6 :)
> 
> So maybe it might be better to move parts of patch 6 to 5 or squash 
> them, or maybe reverse the order.

I think this will get a bit unwieldy of squashed, so what about simply
moving code from 6 to 5? I think people are confused enough by the two
patches to make a change look like a good idea.

(I can queue patches 1-4 to get them out of the way :)

> 
> Thanks
> Farhan
> 
> 
> >>>
> >>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> >>> ---
> >>>   drivers/s390/cio/vfio_ccw_cp.c | 26 ++++++++------------------
> >>>   1 file changed, 8 insertions(+), 18 deletions(-)  
> >>  
> >   
> 

