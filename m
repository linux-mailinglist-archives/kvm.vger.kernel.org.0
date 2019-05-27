Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992442B672
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 15:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfE0Nbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 09:31:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbfE0Nbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 09:31:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3C69308622D;
        Mon, 27 May 2019 13:31:40 +0000 (UTC)
Received: from gondolin (ovpn-204-109.brq.redhat.com [10.40.204.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FDC9608A4;
        Mon, 27 May 2019 13:31:34 +0000 (UTC)
Date:   Mon, 27 May 2019 15:31:30 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [PATCH v2 3/8] s390/cio: add basic protected virtualization
 support
Message-ID: <20190527153130.0f473ffd.cohuck@redhat.com>
In-Reply-To: <20190527143014.3b48a0d2.pasic@linux.ibm.com>
References: <20190523162209.9543-1-mimu@linux.ibm.com>
        <20190523162209.9543-4-mimu@linux.ibm.com>
        <20190527123802.54cd3589.cohuck@redhat.com>
        <20190527143014.3b48a0d2.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 27 May 2019 13:31:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 May 2019 14:30:14 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Mon, 27 May 2019 12:38:02 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Thu, 23 May 2019 18:22:04 +0200
> > Michael Mueller <mimu@linux.ibm.com> wrote:
> >   
> > > From: Halil Pasic <pasic@linux.ibm.com>
> > > 
> > > As virtio-ccw devices are channel devices, we need to use the dma area
> > > for any communication with the hypervisor.
> > > 
> > > It handles neither QDIO in the common code, nor any device type specific
> > > stuff (like channel programs constructed by the DASD driver).
> > > 
> > > An interesting side effect is that virtio structures are now going to
> > > get allocated in 31 bit addressable storage.
> > > 
> > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>  
> > 
> > [Side note: you really should add your s-o-b if you send someone else's
> > patches... if Halil ends up committing them, it's fine, though.]
> >   
> > > ---
> > >  arch/s390/include/asm/ccwdev.h   |  4 +++
> > >  drivers/s390/cio/ccwreq.c        |  9 +++---
> > >  drivers/s390/cio/device.c        | 64 +++++++++++++++++++++++++++++++++-------
> > >  drivers/s390/cio/device_fsm.c    | 53 ++++++++++++++++++++-------------
> > >  drivers/s390/cio/device_id.c     | 20 +++++++------
> > >  drivers/s390/cio/device_ops.c    | 21 +++++++++++--
> > >  drivers/s390/cio/device_pgid.c   | 22 +++++++-------
> > >  drivers/s390/cio/device_status.c | 24 +++++++--------
> > >  drivers/s390/cio/io_sch.h        | 20 +++++++++----
> > >  drivers/s390/virtio/virtio_ccw.c | 10 -------
> > >  10 files changed, 164 insertions(+), 83 deletions(-)
> > >   
> > 
> > (...)
> >   
> > > @@ -1593,20 +1622,31 @@ struct ccw_device * __init ccw_device_create_console(struct ccw_driver *drv)
> > >  		return ERR_CAST(sch);
> > >  
> > >  	io_priv = kzalloc(sizeof(*io_priv), GFP_KERNEL | GFP_DMA);
> > > -	if (!io_priv) {
> > > -		put_device(&sch->dev);
> > > -		return ERR_PTR(-ENOMEM);
> > > -	}
> > > +	if (!io_priv)
> > > +		goto err_priv;
> > > +	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
> > > +				sizeof(*io_priv->dma_area),
> > > +				&io_priv->dma_area_dma, GFP_KERNEL);  
> > 
> > Even though we'll only end up here for 3215 or 3270 consoles, this sent
> > me looking.
> > 
> > This code is invoked via console_init(). A few lines down in
> > start_kernel(), we have
> > 
> >         /*                                                                       
> >          * This needs to be called before any devices perform DMA                
> >          * operations that might use the SWIOTLB bounce buffers. It will         
> >          * mark the bounce buffers as decrypted so that their usage will         
> >          * not cause "plain-text" data to be decrypted when accessed.            
> >          */
> >         mem_encrypt_init();
> > 
> > So, I'm wondering if creating the console device interacts in any way
> > with the memory encryption interface?  
> 
> I do things a bit different than x86: the SWIOTLB stuff is set up in
> mem_init(). So I think we should be fine. If there is a down-side to
> calling swiotlb_update_mem_attributes() earlier, honestly I'm
> not sure.

Neither am I; do any of the folks who looked at the swiotlb patch have
an idea?

> 
> > 
> > [Does basic recognition work if you start a protected virt guest with a
> > 3270 console? I realize that the console is unlikely to work, but that
> > should at least exercise this code path.]  
> 
> I've already had some thoughts along these lines and slapped  
> -device x-terminal3270,chardev=char_0,devno=fe.0.000a,id=terminal_0 \
> on my qemu command line. The ccw device does show up in the guest...
> 
> Device   Subchan.  DevType CU Type Use  PIM PAM POM  CHPIDs
> ----------------------------------------------------------------------
> 0.0.0000 0.0.0000  0000/00 3832/01 yes  80  80  ff   00000000 00000000 
> 0.0.000a 0.0.0001  0000/00 3270/00      80  80  ff   01000000 00000000 
> 0.0.0002 0.0.0002  0000/00 3832/09 yes  80  80  ff   00000000 00000000 
> 0.0.0300 0.0.0003  0000/00 3832/02 yes  80  80  ff   00000000 00000000 
> 0.0.0301 0.0.0004  0000/00 3832/02 yes  80  80  ff   00000000 00000000 
> 
> But I would not call it a comprehensive test...

If you only add the device, it will show up as a normal ccw device in
the guest; i.e. device recognition is done at the same time as for the
other ccw devices. Still good to see that nothing breaks there :)

To actually make the guest use the 3270 as its console, I guess you
need to explicitly force it (see
https://wiki.qemu.org/Features/3270#Using_3270_as_the_console)...
actually starting the console will almost certainly fail; but you can
at least check whether device recognition in the console path works.

> 
> Mimu, do we have something more elaborate with regards to this?

I don't think we need extensive testing here; just checking that the
sequence is not fundamentally broken.
