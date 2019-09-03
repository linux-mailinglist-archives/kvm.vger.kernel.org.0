Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D88A62C9
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 09:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfICHio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 03:38:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbfICHio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 03:38:44 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B286A20260
        for <kvm@vger.kernel.org>; Tue,  3 Sep 2019 07:38:43 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id b9so17978816qti.20
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 00:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dJ3ujh22A4KMEYrsGqSfrfiJ4zKfJp828Rn6w4xYjq8=;
        b=KHyLmtLyWwWXmBC+kE3Y2OSeTCZEoDpjOkUyKWTsS62O3Jhrdkb3Mfgr9SlbyKtki6
         jk0eAGpFAVENSPJ1+G6Lkns9bmZkPhVetdhfdco3vtCXbL+Ht5Nf3N8ZIOQqpDvi0nh4
         w+1lDLc2nwa2P1PFe+W2se9uWK1+iZAZaiepn9EVAt7UrdCDSvqKFFk5AlorqAaYvJR9
         qxvzEXNl5W5FQabf3zFgE/gAzf5rNGtrVTKTqBEhlg7SqgdC5GYriuC60B3hHsOJZEpn
         BwY2d9iXIae7QlCa2TRz9aTxdlrA2ia3feKHkOFuXdErjeuBens0xFbBQF0nb3SbObKp
         OGww==
X-Gm-Message-State: APjAAAWj8kokE+e6Y30rGAd/QfEk1OEb9JksjXiVkyazBMItRMP+K4tq
        Y71klq5f6tetXq81ngqrSXucvnUKSGNHxjjHP2MDRaDZiviXK+z/YJHcmoLctdSU56UkP77vbSs
        uGt3an48NhgXx
X-Received: by 2002:ac8:7186:: with SMTP id w6mr19355752qto.371.1567496323075;
        Tue, 03 Sep 2019 00:38:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxXMPchjPlOKDNWkkZ17/EkNv3hNqMtNhBrOkfnvAF3RBYMzvVKwnBnpdltNIMKvZOntgUYhw==
X-Received: by 2002:ac8:7186:: with SMTP id w6mr19355740qto.371.1567496322915;
        Tue, 03 Sep 2019 00:38:42 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id m19sm8425732qke.22.2019.09.03.00.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 00:38:42 -0700 (PDT)
Date:   Tue, 3 Sep 2019 03:38:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 2/5] vsock/virtio: reduce credit update messages
Message-ID: <20190903033344-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-3-sgarzare@redhat.com>
 <20190903003050-mutt-send-email-mst@kernel.org>
 <20190903073120.kefllalytkvidcvh@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903073120.kefllalytkvidcvh@steredhat>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 03, 2019 at 09:31:20AM +0200, Stefano Garzarella wrote:
> On Tue, Sep 03, 2019 at 12:38:02AM -0400, Michael S. Tsirkin wrote:
> > On Wed, Jul 17, 2019 at 01:30:27PM +0200, Stefano Garzarella wrote:
> > > In order to reduce the number of credit update messages,
> > > we send them only when the space available seen by the
> > > transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE.
> > > 
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >  include/linux/virtio_vsock.h            |  1 +
> > >  net/vmw_vsock/virtio_transport_common.c | 16 +++++++++++++---
> > >  2 files changed, 14 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > > index 7d973903f52e..49fc9d20bc43 100644
> > > --- a/include/linux/virtio_vsock.h
> > > +++ b/include/linux/virtio_vsock.h
> > > @@ -41,6 +41,7 @@ struct virtio_vsock_sock {
> > >  
> > >  	/* Protected by rx_lock */
> > >  	u32 fwd_cnt;
> > > +	u32 last_fwd_cnt;
> > >  	u32 rx_bytes;
> > >  	struct list_head rx_queue;
> > >  };
> > > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > > index 095221f94786..a85559d4d974 100644
> > > --- a/net/vmw_vsock/virtio_transport_common.c
> > > +++ b/net/vmw_vsock/virtio_transport_common.c
> > > @@ -211,6 +211,7 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
> > >  void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt)
> > >  {
> > >  	spin_lock_bh(&vvs->tx_lock);
> > > +	vvs->last_fwd_cnt = vvs->fwd_cnt;
> > >  	pkt->hdr.fwd_cnt = cpu_to_le32(vvs->fwd_cnt);
> > >  	pkt->hdr.buf_alloc = cpu_to_le32(vvs->buf_alloc);
> > >  	spin_unlock_bh(&vvs->tx_lock);
> > > @@ -261,6 +262,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> > >  	struct virtio_vsock_sock *vvs = vsk->trans;
> > >  	struct virtio_vsock_pkt *pkt;
> > >  	size_t bytes, total = 0;
> > > +	u32 free_space;
> > >  	int err = -EFAULT;
> > >  
> > >  	spin_lock_bh(&vvs->rx_lock);
> > > @@ -291,11 +293,19 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> > >  			virtio_transport_free_pkt(pkt);
> > >  		}
> > >  	}
> > > +
> > > +	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
> > > +
> > >  	spin_unlock_bh(&vvs->rx_lock);
> > >  
> > > -	/* Send a credit pkt to peer */
> > > -	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
> > > -					    NULL);
> > > +	/* We send a credit update only when the space available seen
> > > +	 * by the transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE
> > 
> > This is just repeating what code does though.
> > Please include the *reason* for the condition.
> > E.g. here's a better comment:
> > 
> > 	/* To reduce number of credit update messages,
> > 	 * don't update credits as long as lots of space is available.
> > 	 * Note: the limit chosen here is arbitrary. Setting the limit
> > 	 * too high causes extra messages. Too low causes transmitter
> > 	 * stalls. As stalls are in theory more expensive than extra
> > 	 * messages, we set the limit to a high value. TODO: experiment
> > 	 * with different values.
> > 	 */
> > 
> 
> Yes, it is better, sorry for that. I'll try to avoid unnecessary comments,
> explaining the reason for certain changes.
> 
> Since this patch is already queued in net-next, should I send another
> patch to fix the comment?
> 
> Thanks,
> Stefano

I just sent a patch like that, pls ack it.

-- 
MST
