Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459C21F5EF
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 15:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfEONuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 09:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfEONuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 09:50:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A892F7DCD7;
        Wed, 15 May 2019 13:50:24 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76E275D9E5;
        Wed, 15 May 2019 13:50:19 +0000 (UTC)
Date:   Wed, 15 May 2019 15:50:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 10/10] virtio/s390: make airq summary indicators DMA
Message-ID: <20190515155017.0d3e2543.cohuck@redhat.com>
In-Reply-To: <3a8353e2-97e3-778e-ab2e-ef285ac7027d@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-11-pasic@linux.ibm.com>
        <20190513142010.36c8478f.cohuck@redhat.com>
        <3a8353e2-97e3-778e-ab2e-ef285ac7027d@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 15 May 2019 13:50:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 May 2019 15:43:23 +0200
Michael Mueller <mimu@linux.ibm.com> wrote:

> On 13.05.19 14:20, Cornelia Huck wrote:
> > On Fri, 26 Apr 2019 20:32:45 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >   
> >> Hypervisor needs to interact with the summary indicators, so these
> >> need to be DMA memory as well (at least for protected virtualization
> >> guests).
> >>
> >> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> >> ---
> >>   drivers/s390/virtio/virtio_ccw.c | 24 +++++++++++++++++-------
> >>   1 file changed, 17 insertions(+), 7 deletions(-)  
> > 
> > (...)
> >   
> >> @@ -237,7 +243,8 @@ static void virtio_airq_handler(struct airq_struct *airq)
> >>   	read_unlock(&info->lock);
> >>   }
> >>   
> >> -static struct airq_info *new_airq_info(void)
> >> +/* call with drivers/s390/virtio/virtio_ccw.cheld */  
> > 
> > Hm, where is airq_areas_lock defined? If it was introduced in one of
> > the previous patches, I have missed it.  
> 
> There is no airq_areas_lock defined currently. My assumption is that
> this will be used in context with the likely race condition this
> part of the patch is talking about.
> 
> @@ -273,8 +281,9 @@ static unsigned long get_airq_indicator(struct 
> virtqueue *vqs[], int nvqs,
>   	unsigned long bit, flags;
> 
>   	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
> +		/* TODO: this seems to be racy */
>   		if (!airq_areas[i])
> -			airq_areas[i] = new_airq_info();
> +			airq_areas[i] = new_airq_info(i);
> 
> 
> As this shall be handled by a separate patch I will drop the comment
> in regard to airq_areas_lock from this patch as well for v2.

Ok, that makes sense.
