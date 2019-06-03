Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0AD33127
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 15:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbfFCNee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 09:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfFCNee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 09:34:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 822F63107B1A;
        Mon,  3 Jun 2019 13:34:33 +0000 (UTC)
Received: from gondolin (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3130C54281;
        Mon,  3 Jun 2019 13:34:24 +0000 (UTC)
Date:   Mon, 3 Jun 2019 15:34:20 +0200
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
Subject: Re: [PATCH v3 2/8] s390/cio: introduce DMA pools to cio
Message-ID: <20190603153420.671939c3.cohuck@redhat.com>
In-Reply-To: <20190603145730.3e45b8f5.pasic@linux.ibm.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
        <20190529122657.166148-3-mimu@linux.ibm.com>
        <20190603133745.240c00a7.cohuck@redhat.com>
        <035b4bd3-5856-e8e5-91bf-ba0b5c7c3736@linux.ibm.com>
        <20190603145730.3e45b8f5.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 03 Jun 2019 13:34:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jun 2019 14:57:30 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Mon, 3 Jun 2019 14:09:02 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
> > >> @@ -224,6 +226,8 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
> > >>   	INIT_WORK(&sch->todo_work, css_sch_todo);
> > >>   	sch->dev.release = &css_subchannel_release;
> > >>   	device_initialize(&sch->dev);    
> > > 
> > > It might be helpful to add a comment why you use 31 bit here...    
> > 
> > @Halil, please let me know what comment you prefere here...
> >   
> 
> How about?
> 
> /*
>  * The physical addresses of some the dma structures that
>  * can belong  to a subchannel need to fit 31 bit width (examples ccw,).
>  */

"e.g. ccw"?

> 
> 
> > >     
> > >> +	sch->dev.coherent_dma_mask = DMA_BIT_MASK(31);
> > >> +	sch->dev.dma_mask = &sch->dev.coherent_dma_mask;
> > >>   	return sch;
> > >>   
> > >>   err:
> > >> @@ -899,6 +903,8 @@ static int __init setup_css(int nr)
> > >>   	dev_set_name(&css->device, "css%x", nr);
> > >>   	css->device.groups = cssdev_attr_groups;
> > >>   	css->device.release = channel_subsystem_release;    
> > > 
> > > ...and 64 bit here.    
> > 
> > and here.  
> 
> /*
>  * We currently allocate notifier bits with this (using css->device
>  * as the device argument with the DMA API), and are fine with 64 bit
>  * addresses.
>  */

Thanks, that makes things hopefully clearer if we look at it some time
in the future ;)
