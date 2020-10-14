Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F95528D779
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 02:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389681AbgJNAar convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 13 Oct 2020 20:30:47 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3637 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389520AbgJNAaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 20:30:46 -0400
X-Greylist: delayed 930 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2020 20:30:46 EDT
Received: from dggeme709-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id E1AC73D4A3C36CA6911C;
        Wed, 14 Oct 2020 08:15:13 +0800 (CST)
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggeme709-chm.china.huawei.com (10.1.199.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 14 Oct 2020 08:15:13 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.1913.007;
 Wed, 14 Oct 2020 08:15:13 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "tiantao (H)" <tiantao6@hisilicon.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH] vfio/platform: Replace spin_lock_irqsave by spin_lock in
 hard IRQ
Thread-Topic: [PATCH] vfio/platform: Replace spin_lock_irqsave by spin_lock in
 hard IRQ
Thread-Index: AQHWoQSZTGOwJR7vqkiLltZ8f3MgN6mViI6AgACwRXA=
Date:   Wed, 14 Oct 2020 00:15:13 +0000
Message-ID: <aa726bd8cab443bdbbab8646a3988ffd@hisilicon.com>
References: <1602554458-26927-1-git-send-email-tiantao6@hisilicon.com>
 <20201013153229.7fe74e65@w520.home>
In-Reply-To: <20201013153229.7fe74e65@w520.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.200.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Wednesday, October 14, 2020 10:32 AM
> To: tiantao (H) <tiantao6@hisilicon.com>
> Cc: eric.auger@redhat.com; cohuck@redhat.com; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; Song Bao Hua (Barry Song)
> <song.bao.hua@hisilicon.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH] vfio/platform: Replace spin_lock_irqsave by spin_lock in
> hard IRQ
> 
> On Tue, 13 Oct 2020 10:00:58 +0800
> Tian Tao <tiantao6@hisilicon.com> wrote:
> 
> > It is redundant to do irqsave and irqrestore in hardIRQ context.
> 
> But this function is also called from non-IRQ context.  Thanks,

It seems you mean
vfio_platform_set_irqs_ioctl() ->
vfio_platform_set_irq_trigger ->
handler() ?

so, will it be better to move the irqsave out of the vfio_automasked_irq_handler()
and put it to where the function is called in non-IRQ context?

I mean:

irqhandler()
{
	spin_lock()  //without irqsave
	spin_unlock()
}

Non-irq context which is calling this handler:
irqsave();
irqhandler();
irqrestore();

Anyway, if it is called in IRQ context, it is redundant to do irqsave.

> 
> Alex
> 
> > Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> > ---
> >  drivers/vfio/platform/vfio_platform_irq.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/vfio/platform/vfio_platform_irq.c
> b/drivers/vfio/platform/vfio_platform_irq.c
> > index c5b09ec..24fd6c5 100644
> > --- a/drivers/vfio/platform/vfio_platform_irq.c
> > +++ b/drivers/vfio/platform/vfio_platform_irq.c
> > @@ -139,10 +139,9 @@ static int vfio_platform_set_irq_unmask(struct
> vfio_platform_device *vdev,
> >  static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
> >  {
> >  	struct vfio_platform_irq *irq_ctx = dev_id;
> > -	unsigned long flags;
> >  	int ret = IRQ_NONE;
> >
> > -	spin_lock_irqsave(&irq_ctx->lock, flags);
> > +	spin_lock(&irq_ctx->lock);
> >
> >  	if (!irq_ctx->masked) {
> >  		ret = IRQ_HANDLED;
> > @@ -152,7 +151,7 @@ static irqreturn_t vfio_automasked_irq_handler(int
> irq, void *dev_id)
> >  		irq_ctx->masked = true;
> >  	}
> >
> > -	spin_unlock_irqrestore(&irq_ctx->lock, flags);
> > +	spin_unlock(&irq_ctx->lock);
> >
> >  	if (ret == IRQ_HANDLED)
> >  		eventfd_signal(irq_ctx->trigger, 1);

Thanks
Barry

