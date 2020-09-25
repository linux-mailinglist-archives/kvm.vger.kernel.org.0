Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41EF278BFD
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 17:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgIYPDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 11:03:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728353AbgIYPDV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 11:03:21 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601046199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xL97XlBbfHiz2VEyXf7pSUtqtIihQnTCmuROMWX3SdI=;
        b=IrP86+UfArsUyhFcWR8+fg3/herm/wQPlnhqWtFysL8vm8fEiqbHBcz+PK6Q5VbtD3pWP7
        UrR9G+e3JlfoCrOuFDPuzAiS1r0DxgYUMC3A/Otp+FRWImZtar6cslMVHFxIsoGDPMNgtT
        PFnQYOSNHfzOuKTOJ0kYHVMCbtch8X8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-vXd7rks9PreMvDI1eAvNsg-1; Fri, 25 Sep 2020 11:03:15 -0400
X-MC-Unique: vXd7rks9PreMvDI1eAvNsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2B60802EA3;
        Fri, 25 Sep 2020 15:03:13 +0000 (UTC)
Received: from gondolin (ovpn-112-192.ams2.redhat.com [10.36.112.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0D576198B;
        Fri, 25 Sep 2020 15:03:02 +0000 (UTC)
Date:   Fri, 25 Sep 2020 17:03:00 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] s390x/pci: create a header dedicated to PCI CLP
Message-ID: <20200925170300.1367e307.cohuck@redhat.com>
In-Reply-To: <9303d8c1-dd93-6e63-d90e-0303bd42677b@linux.ibm.com>
References: <1600529672-10243-1-git-send-email-mjrosato@linux.ibm.com>
        <1600529672-10243-4-git-send-email-mjrosato@linux.ibm.com>
        <20200925111746.2e3bf28f.cohuck@redhat.com>
        <9303d8c1-dd93-6e63-d90e-0303bd42677b@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Sep 2020 10:10:12 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 9/25/20 5:17 AM, Cornelia Huck wrote:
> > On Sat, 19 Sep 2020 11:34:28 -0400
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> >> From: Pierre Morel <pmorel@linux.ibm.com>
> >>
> >> To have a clean separation between s390-pci-bus.h and s390-pci-inst.h
> >> headers we export the PCI CLP instructions in a dedicated header.
> >>
> >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >> ---
> >>   hw/s390x/s390-pci-bus.h  |   1 +
> >>   hw/s390x/s390-pci-clp.h  | 211 +++++++++++++++++++++++++++++++++++++++++++++++
> >>   hw/s390x/s390-pci-inst.h | 196 -------------------------------------------
> >>   3 files changed, 212 insertions(+), 196 deletions(-)
> >>   create mode 100644 hw/s390x/s390-pci-clp.h  
> > 
> > Looks sane; but I wonder whether we should move the stuff under
> > include/hw/s390x/.
> >   
> 
> Probably.  I'd be fine with creating this file under include, but if 
> we're going to do that we should plan to move the other s390-pci* ones 
> too.  For this patchset, I can change this patch to put the new header 
> in include/hw/s390x, easy enough.
> 
> I'll plan to do a separate cleanup patchset to move s390-pci-bus.h and 
> s390-pci-inst.h.
> 
> How would you like me to handle s390-pci-vfio.h (this is a new file 
> added by both this patch set and 's390x/pci: Accomodate vfio DMA 
> limiting') --  It seems likely that the latter patch set will merge 
> first, so my thought would be to avoid a cleanup on this one and just 
> re-send 's390x/pci: Accomodate vfio DMA limiting' once the kernel part 
> hits mainline (it's currently in linux-next via Alex) with 
> s390-pci-vfio.h also created in include/hw/s390x (and I guess the 
> MAINTAINERS hit for it too). Sound OK?

Yes, I guess that would be best.


