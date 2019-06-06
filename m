Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6433836E32
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 10:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfFFILO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 04:11:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43404 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfFFILO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 04:11:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id r18so1349685wrm.10
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 01:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IvekH9F+MWJsOurnj1zZYn5MMsSALWjLPTIkoz8fkvM=;
        b=Gt5Nw8PLMUGxMTK425U2AtRaZUkyf6HMC1jSUYlo/hqmyPWM+p9+4Y56RYp3QWVLqy
         /W27E62hXj9Ah7jXD12DAJoPBg7LwJ2W/Uzor0S1Q+g7LAxSHx9vuOeqhQff74tj+/Fi
         tqk1vQPjPc2fUC4hlQb5iX6246pWspn4/YNkCbaGgp5RF9BmI/sUq475lkWyL7ZQkvPD
         y4W+Ts3jZMYCJCkCgffpSY4ywLpHpsxPUXkDpQOMgKrqrJMFTTPU/efmz4Z4100GVhvn
         SwmTinmQRs04SD+IApISMGKuA6cyVsLpPM3o3cCm9rf2Gws1DdXArKMrcs5OGqBemitV
         V59w==
X-Gm-Message-State: APjAAAVLaMoEcyTByYbHIlJXlxVZg1hM+sY/ghepmAcgxvCOgLE4i1B4
        O10XarJD8tJne9u9vBOoUKsfWA==
X-Google-Smtp-Source: APXvYqxkjm0rjsdB6ee8tNzTBSuC9b7sY4agRTTiv5VgQ04bmNVYSFcehkfNbrebXzvPuWlnxeS6ZQ==
X-Received: by 2002:adf:ed44:: with SMTP id u4mr15429487wro.242.1559808672582;
        Thu, 06 Jun 2019 01:11:12 -0700 (PDT)
Received: from steredhat (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id f2sm724438wme.12.2019.06.06.01.11.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 01:11:11 -0700 (PDT)
Date:   Thu, 6 Jun 2019 10:11:09 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/4] vsock/virtio: fix flush of works during the .remove()
Message-ID: <20190606081109.gdx4rsly5i6gtg57@steredhat>
References: <20190528105623.27983-1-sgarzare@redhat.com>
 <20190528105623.27983-4-sgarzare@redhat.com>
 <9ac9fc4b-5c39-2503-dfbb-660a7bdcfbfd@redhat.com>
 <20190529105832.oz3sagbne5teq3nt@steredhat>
 <8c9998c8-1b9c-aac6-42eb-135fcb966187@redhat.com>
 <20190530101036.wnjphmajrz6nz6zc@steredhat.homenet.telecomitalia.it>
 <4c881585-8fee-0a53-865c-05d41ffb8ed1@redhat.com>
 <20190531081824.p6ylsgvkrbckhqpx@steredhat>
 <dbc9964c-65b1-0993-488b-cb44aea55e90@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dbc9964c-65b1-0993-488b-cb44aea55e90@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 31, 2019 at 05:56:39PM +0800, Jason Wang wrote:
> On 2019/5/31 下午4:18, Stefano Garzarella wrote:
> > On Thu, May 30, 2019 at 07:59:14PM +0800, Jason Wang wrote:
> > > On 2019/5/30 下午6:10, Stefano Garzarella wrote:
> > > > On Thu, May 30, 2019 at 05:46:18PM +0800, Jason Wang wrote:
> > > > > On 2019/5/29 下午6:58, Stefano Garzarella wrote:
> > > > > > On Wed, May 29, 2019 at 11:22:40AM +0800, Jason Wang wrote:
> > > > > > > On 2019/5/28 下午6:56, Stefano Garzarella wrote:
> > > > > > > > @@ -690,6 +693,9 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> > > > > > > >      	vsock->event_run = false;
> > > > > > > >      	mutex_unlock(&vsock->event_lock);
> > > > > > > > +	/* Flush all pending works */
> > > > > > > > +	virtio_vsock_flush_works(vsock);
> > > > > > > > +
> > > > > > > >      	/* Flush all device writes and interrupts, device will not use any
> > > > > > > >      	 * more buffers.
> > > > > > > >      	 */
> > > > > > > > @@ -726,6 +732,11 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> > > > > > > >      	/* Delete virtqueues and flush outstanding callbacks if any */
> > > > > > > >      	vdev->config->del_vqs(vdev);
> > > > > > > > +	/* Other works can be queued before 'config->del_vqs()', so we flush
> > > > > > > > +	 * all works before to free the vsock object to avoid use after free.
> > > > > > > > +	 */
> > > > > > > > +	virtio_vsock_flush_works(vsock);
> > > > > > > Some questions after a quick glance:
> > > > > > > 
> > > > > > > 1) It looks to me that the work could be queued from the path of
> > > > > > > vsock_transport_cancel_pkt() . Is that synchronized here?
> > > > > > > 
> > > > > > Both virtio_transport_send_pkt() and vsock_transport_cancel_pkt() can
> > > > > > queue work from the upper layer (socket).
> > > > > > 
> > > > > > Setting the_virtio_vsock to NULL, should synchronize, but after a careful look
> > > > > > a rare issue could happen:
> > > > > > we are setting the_virtio_vsock to NULL at the start of .remove() and we
> > > > > > are freeing the object pointed by it at the end of .remove(), so
> > > > > > virtio_transport_send_pkt() or vsock_transport_cancel_pkt() may still be
> > > > > > running, accessing the object that we are freed.
> > > > > Yes, that's my point.
> > > > > 
> > > > > 
> > > > > > Should I use something like RCU to prevent this issue?
> > > > > > 
> > > > > >        virtio_transport_send_pkt() and vsock_transport_cancel_pkt()
> > > > > >        {
> > > > > >            rcu_read_lock();
> > > > > >            vsock = rcu_dereference(the_virtio_vsock_mutex);
> > > > > RCU is probably a way to go. (Like what vhost_transport_send_pkt() did).
> > > > > 
> > > > Okay, I'm going this way.
> > > > 
> > > > > >            ...
> > > > > >            rcu_read_unlock();
> > > > > >        }
> > > > > > 
> > > > > >        virtio_vsock_remove()
> > > > > >        {
> > > > > >            rcu_assign_pointer(the_virtio_vsock_mutex, NULL);
> > > > > >            synchronize_rcu();
> > > > > > 
> > > > > >            ...
> > > > > > 
> > > > > >            free(vsock);
> > > > > >        }
> > > > > > 
> > > > > > Could there be a better approach?
> > > > > > 
> > > > > > 
> > > > > > > 2) If we decide to flush after dev_vqs(), is tx_run/rx_run/event_run still
> > > > > > > needed? It looks to me we've already done except that we need flush rx_work
> > > > > > > in the end since send_pkt_work can requeue rx_work.
> > > > > > The main reason of tx_run/rx_run/event_run is to prevent that a worker
> > > > > > function is running while we are calling config->reset().
> > > > > > 
> > > > > > E.g. if an interrupt comes between virtio_vsock_flush_works() and
> > > > > > config->reset(), it can queue new works that can access the device while
> > > > > > we are in config->reset().
> > > > > > 
> > > > > > IMHO they are still needed.
> > > > > > 
> > > > > > What do you think?
> > > > > I mean could we simply do flush after reset once and without tx_rx/rx_run
> > > > > tricks?
> > > > > 
> > > > > rest();
> > > > > 
> > > > > virtio_vsock_flush_work();
> > > > > 
> > > > > virtio_vsock_free_buf();
> > > > My only doubt is:
> > > > is it safe to call config->reset() while a worker function could access
> > > > the device?
> > > > 
> > > > I had this doubt reading the Michael's advice[1] and looking at
> > > > virtnet_remove() where there are these lines before the config->reset():
> > > > 
> > > > 	/* Make sure no work handler is accessing the device. */
> > > > 	flush_work(&vi->config_work);
> > > > 
> > > > Thanks,
> > > > Stefano
> > > > 
> > > > [1] https://lore.kernel.org/netdev/20190521055650-mutt-send-email-mst@kernel.org
> > > 
> > > Good point. Then I agree with you. But if we can use the RCU to detect the
> > > detach of device from socket for these, it would be even better.
> > > 
> > What about checking 'the_virtio_vsock' in the worker functions in a RCU
> > critical section?
> > In this way, I can remove the rx_run/tx_run/event_run.
> > 
> > Do you think it's cleaner?
> 
> 
> Yes, I think so.
> 

Hi Jason,
while I was trying to use RCU also for workers, I discovered that it can
not be used if we can sleep. (Workers have mutex, memory allocation, etc.).
There is SRCU, but I think the rx_run/tx_run/event_run is cleaner.

So, if you agree I'd send a v2 using RCU only for the
virtio_transport_send_pkt() or vsock_transport_cancel_pkt(), and leave
this patch as is to be sure that no one is accessing the device while we
call config->reset().

Thanks,
Stefano
