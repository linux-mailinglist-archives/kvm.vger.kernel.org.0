Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2832672A33
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 10:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfGXIeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 04:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfGXIeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 04:34:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2FDC87633;
        Wed, 24 Jul 2019 08:34:13 +0000 (UTC)
Received: from gondolin (dhcp-192-181.str.redhat.com [10.33.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8C435C224;
        Wed, 24 Jul 2019 08:34:12 +0000 (UTC)
Date:   Wed, 24 Jul 2019 10:34:10 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] virtio/s390: fix race on airq_areas[]
Message-ID: <20190724103410.574dd259.cohuck@redhat.com>
In-Reply-To: <74087255-fdae-01a1-7152-f6fac8e13019@de.ibm.com>
References: <20190723225817.12800-1-pasic@linux.ibm.com>
        <74087255-fdae-01a1-7152-f6fac8e13019@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 24 Jul 2019 08:34:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jul 2019 08:44:19 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 24.07.19 00:58, Halil Pasic wrote:
> > The access to airq_areas was racy ever since the adapter interrupts got
> > introduced to virtio-ccw, but since commit 39c7dcb15892 ("virtio/s390:
> > make airq summary indicators DMA") this became an issue in practice as
> > well. Namely before that commit the airq_info that got overwritten was
> > still functional. After that commit however the two infos share a
> > summary_indicator, which aggravates the situation. Which means
> > auto-online mechanism occasionally hangs the boot with virtio_blk.
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> > Fixes: 96b14536d935 ("virtio-ccw: virtio-ccw adapter interrupt support.")
> > ---
> > * We need definitely this fixed for 5.3. For older stable kernels it is
> > to be discussed. @Connie what do you think: do we need a cc stable?  
> 
> Unless you can prove that the problem could never happen on old version
> we absolutely do need cc stable. 

Yes, this needs to be cc:stable.

> 
> > 
> > * I have a variant that does not need the extra mutex but uses cmpxchg().
> > Decided to post this one because that one is more complex. But if there
> > is interest we can have a look at it as well.  
> 
> This is slow path (startup) and never called in hot path. Correct? Mutex should be
> fine.

Yes, this is ultimately called through the ->probe functions of virtio
drivers.

> > ---
> >  drivers/s390/virtio/virtio_ccw.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > index 1a55e5942d36..d97742662755 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -145,6 +145,8 @@ struct airq_info {
> >  	struct airq_iv *aiv;
> >  };
> >  static struct airq_info *airq_areas[MAX_AIRQ_AREAS];
> > +DEFINE_MUTEX(airq_areas_lock);
> > +
> >  static u8 *summary_indicators;
> >  
> >  static inline u8 *get_summary_indicator(struct airq_info *info)
> > @@ -265,9 +267,11 @@ static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
> >  	unsigned long bit, flags;
> >  
> >  	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
> > +		mutex_lock(&airq_areas_lock);
> >  		if (!airq_areas[i])
> >  			airq_areas[i] = new_airq_info(i);
> >  		info = airq_areas[i];
> > +		mutex_unlock(&airq_areas_lock);
> >  		if (!info)
> >  			return 0;
> >  		write_lock_irqsave(&info->lock, flags);
> >   
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Should I pick this and send a pull request, or is it quicker to just
take this directly?
