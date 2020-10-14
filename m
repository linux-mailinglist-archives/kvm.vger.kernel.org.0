Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842C728D7B7
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 02:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbgJNAuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 20:50:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726974AbgJNAue (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Oct 2020 20:50:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602636632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kfmf77NswTlE78r/Rx1pWvh7Mse6dTExyPAMh1Ho+z8=;
        b=Zuihh8nB1RbnZyUHjbOh6r+IdGrQh+oAYDrfz2bTQgrfNzpUFy5pf3+YAlKmVL+2xWuRxw
        viu2WYb+B/1P4wvTGARd9XSFZiNM20nnBEy0kDY+WC6Hmoe+K6ggoyaH0AM7/GtS6e/BU0
        /QBBMGb0FUBiZBw8f+VNhu1NkQY3yZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-0Yys-8R6Pzu35lIbEX78lQ-1; Tue, 13 Oct 2020 20:50:29 -0400
X-MC-Unique: 0Yys-8R6Pzu35lIbEX78lQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD93F1800D42;
        Wed, 14 Oct 2020 00:50:27 +0000 (UTC)
Received: from x1.home (ovpn-113-35.phx2.redhat.com [10.3.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0774155767;
        Wed, 14 Oct 2020 00:50:23 +0000 (UTC)
Date:   Tue, 13 Oct 2020 18:50:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
Cc:     "tiantao (H)" <tiantao6@hisilicon.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] vfio/platform: Replace spin_lock_irqsave by spin_lock
 in hard IRQ
Message-ID: <20201013185023.455a6ca9@x1.home>
In-Reply-To: <aa726bd8cab443bdbbab8646a3988ffd@hisilicon.com>
References: <1602554458-26927-1-git-send-email-tiantao6@hisilicon.com>
        <20201013153229.7fe74e65@w520.home>
        <aa726bd8cab443bdbbab8646a3988ffd@hisilicon.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Oct 2020 00:15:13 +0000
"Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Wednesday, October 14, 2020 10:32 AM
> > To: tiantao (H) <tiantao6@hisilicon.com>
> > Cc: eric.auger@redhat.com; cohuck@redhat.com; kvm@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Song Bao Hua (Barry Song)
> > <song.bao.hua@hisilicon.com>; Linuxarm <linuxarm@huawei.com>
> > Subject: Re: [PATCH] vfio/platform: Replace spin_lock_irqsave by spin_lock in
> > hard IRQ
> > 
> > On Tue, 13 Oct 2020 10:00:58 +0800
> > Tian Tao <tiantao6@hisilicon.com> wrote:
> >   
> > > It is redundant to do irqsave and irqrestore in hardIRQ context.  
> > 
> > But this function is also called from non-IRQ context.  Thanks,  
> 
> It seems you mean
> vfio_platform_set_irqs_ioctl() ->
> vfio_platform_set_irq_trigger ->
> handler() ?

Yes.

> so, will it be better to move the irqsave out of the vfio_automasked_irq_handler()
> and put it to where the function is called in non-IRQ context?
> 
> I mean:
> 
> irqhandler()
> {
> 	spin_lock()  //without irqsave
> 	spin_unlock()
> }
> 
> Non-irq context which is calling this handler:
> irqsave();
> irqhandler();
> irqrestore();
> 
> Anyway, if it is called in IRQ context, it is redundant to do irqsave.

What's the advantage?  You're saying it's redundant, is it also wrong?
If it's not wrong and only redundant, what's the tangible latency
difference in maintaining a separate IRQ context handler without the
irqsave/restore?  Thanks,

Alex

> > > Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> > > ---
> > >  drivers/vfio/platform/vfio_platform_irq.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/vfio/platform/vfio_platform_irq.c  
> > b/drivers/vfio/platform/vfio_platform_irq.c  
> > > index c5b09ec..24fd6c5 100644
> > > --- a/drivers/vfio/platform/vfio_platform_irq.c
> > > +++ b/drivers/vfio/platform/vfio_platform_irq.c
> > > @@ -139,10 +139,9 @@ static int vfio_platform_set_irq_unmask(struct  
> > vfio_platform_device *vdev,  
> > >  static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
> > >  {
> > >  	struct vfio_platform_irq *irq_ctx = dev_id;
> > > -	unsigned long flags;
> > >  	int ret = IRQ_NONE;
> > >
> > > -	spin_lock_irqsave(&irq_ctx->lock, flags);
> > > +	spin_lock(&irq_ctx->lock);
> > >
> > >  	if (!irq_ctx->masked) {
> > >  		ret = IRQ_HANDLED;
> > > @@ -152,7 +151,7 @@ static irqreturn_t vfio_automasked_irq_handler(int  
> > irq, void *dev_id)  
> > >  		irq_ctx->masked = true;
> > >  	}
> > >
> > > -	spin_unlock_irqrestore(&irq_ctx->lock, flags);
> > > +	spin_unlock(&irq_ctx->lock);
> > >
> > >  	if (ret == IRQ_HANDLED)
> > >  		eventfd_signal(irq_ctx->trigger, 1);  
> 
> Thanks
> Barry
> 

