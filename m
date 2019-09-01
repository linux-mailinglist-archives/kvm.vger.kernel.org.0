Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783B1A4867
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2019 10:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfIAI02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Sep 2019 04:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18127 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfIAI01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Sep 2019 04:26:27 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE73F8666C
        for <kvm@vger.kernel.org>; Sun,  1 Sep 2019 08:26:26 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id n135so12384458qke.23
        for <kvm@vger.kernel.org>; Sun, 01 Sep 2019 01:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xu9C6EcO+hh36QKxmpHDdkEYpLqXslYlNZxLBsH0wT0=;
        b=LKNrbRTon2kw1ManV+RBHcrhZZX3GX34+ZPZ529HRkI6ZzlXIUtQBptNw/sbk0jN8A
         bvE402egQgG4lHJxM3/whpazrvYzSRIr60F1E5vy0shvSBP3oCqE6auxg3fHU4n3E2QF
         87KlwRTF/KoQQD8mmpXbE+c1ysNjGA/nR0ccU66ji1saQ9UEHmb7uOgxZVvatPLZ8+9J
         kVYeSm7fOqG5YLHIHPjF623hQDRnj4MB07fLUxBunTz6+E3J2nsBelTAXSzCM92Vi0Zu
         F6hPfakI0Of6XKisgYBh2Ko3sBvsZD+nLV7ZD9dZxnZLk93lX4ofNEbbc7/nEFToHdlU
         FBRQ==
X-Gm-Message-State: APjAAAU/75z0GlugKQSx0qxraDTZ+2iKFGD3tdbfd6+WDlebVhbrmYhr
        u1JuGUZ/liuSPqZRoI/sjiCzP5P4DDZ/bR45/ZoP9IBSIMT0Ree/mGmXFBtT4yLANoO2hYyIyGc
        RQRgc95B5W/AB
X-Received: by 2002:a05:620a:1644:: with SMTP id c4mr13028365qko.243.1567326386229;
        Sun, 01 Sep 2019 01:26:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw38W9diJ6oIc2aBsP7VWVUJ1THMBw8OhkpLN5SOJMxl2dy4q2UmlgLrj1F8jJQ3K2tij9GeQ==
X-Received: by 2002:a05:620a:1644:: with SMTP id c4mr13028353qko.243.1567326385941;
        Sun, 01 Sep 2019 01:26:25 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id q5sm2896866qte.38.2019.09.01.01.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2019 01:26:24 -0700 (PDT)
Date:   Sun, 1 Sep 2019 04:26:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190901025815-mutt-send-email-mst@kernel.org>
References: <20190729153656.zk4q4rob5oi6iq7l@steredhat>
 <20190729114302-mutt-send-email-mst@kernel.org>
 <20190729161903.yhaj5rfcvleexkhc@steredhat>
 <20190729165056.r32uzj6om3o6vfvp@steredhat>
 <20190729143622-mutt-send-email-mst@kernel.org>
 <20190730093539.dcksure3vrykir3g@steredhat>
 <20190730163807-mutt-send-email-mst@kernel.org>
 <20190801104754.lb3ju5xjfmnxioii@steredhat>
 <20190801091106-mutt-send-email-mst@kernel.org>
 <20190801133616.sik5drn6ecesukbb@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801133616.sik5drn6ecesukbb@steredhat>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 03:36:16PM +0200, Stefano Garzarella wrote:
> On Thu, Aug 01, 2019 at 09:21:15AM -0400, Michael S. Tsirkin wrote:
> > On Thu, Aug 01, 2019 at 12:47:54PM +0200, Stefano Garzarella wrote:
> > > On Tue, Jul 30, 2019 at 04:42:25PM -0400, Michael S. Tsirkin wrote:
> > > > On Tue, Jul 30, 2019 at 11:35:39AM +0200, Stefano Garzarella wrote:
> > > 
> > > (...)
> > > 
> > > > > 
> > > > > The problem here is the compatibility. Before this series virtio-vsock
> > > > > and vhost-vsock modules had the RX buffer size hard-coded
> > > > > (VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE = 4K). So, if we send a buffer smaller
> > > > > of 4K, there might be issues.
> > > > 
> > > > Shouldn't be if they are following the spec. If not let's fix
> > > > the broken parts.
> > > > 
> > > > > 
> > > > > Maybe it is the time to add add 'features' to virtio-vsock device.
> > > > > 
> > > > > Thanks,
> > > > > Stefano
> > > > 
> > > > Why would a remote care about buffer sizes?
> > > > 
> > > > Let's first see what the issues are. If they exist
> > > > we can either fix the bugs, or code the bug as a feature in spec.
> > > > 
> > > 
> > > The vhost_transport '.stream_enqueue' callback
> > > [virtio_transport_stream_enqueue()] calls the virtio_transport_send_pkt_info(),
> > > passing the user message. This function allocates a new packet, copying
> > > the user message, but (before this series) it limits the packet size to
> > > the VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE (4K):
> > > 
> > > static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> > > 					  struct virtio_vsock_pkt_info *info)
> > > {
> > >  ...
> > > 	/* we can send less than pkt_len bytes */
> > > 	if (pkt_len > VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE)
> > > 		pkt_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
> > > 
> > > 	/* virtio_transport_get_credit might return less than pkt_len credit */
> > > 	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
> > > 
> > > 	/* Do not send zero length OP_RW pkt */
> > > 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> > > 		return pkt_len;
> > >  ...
> > > }
> > > 
> > > then it queues the packet for the TX worker calling .send_pkt()
> > > [vhost_transport_send_pkt() in the vhost_transport case]
> > > 
> > > The main function executed by the TX worker is
> > > vhost_transport_do_send_pkt() that picks up a buffer from the virtqueue
> > > and it tries to copy the packet (up to 4K) on it.  If the buffer
> > > allocated from the guest will be smaller then 4K, I think here it will
> > > be discarded with an error:
> > > 
> 
> I'm adding more lines to explain better.
> 
> > > static void
> > > vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> > > 				struct vhost_virtqueue *vq)
> > > {
> 		...
> 
> 		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> 					 &out, &in, NULL, NULL);
> 
> 		...
> 
> 		len = iov_length(&vq->iov[out], in);
> 		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, len);
> 
> 		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
> 		if (nbytes != sizeof(pkt->hdr)) {
> 			virtio_transport_free_pkt(pkt);
> 			vq_err(vq, "Faulted on copying pkt hdr\n");
> 			break;
> 		}
> 
> > >  ...
> > > 		nbytes = copy_to_iter(pkt->buf, pkt->len, &iov_iter);
> > 
> > isn't pck len the actual length though?
> > 
> 
> It is the length of the packet that we are copying in the guest RX
> buffers pointed by the iov_iter. The guest allocates an iovec with 2
> buffers, one for the header and one for the payload (4KB).

BTW at the moment that forces another kmalloc within virtio core. Maybe
vsock needs a flag to skip allocation in this case.  Worth benchmarking.
See virtqueue_use_indirect which just does total_sg > 1.

> 
> > > 		if (nbytes != pkt->len) {
> > > 			virtio_transport_free_pkt(pkt);
> > > 			vq_err(vq, "Faulted on copying pkt buf\n");
> > > 			break;
> > > 		}
> > >  ...
> > > }
> > > 
> > > 
> > > This series changes this behavior since now we will split the packet in
> > > vhost_transport_do_send_pkt() depending on the buffer found in the
> > > virtqueue.
> > > 
> > > We didn't change the buffer size in this series, so we still backward
> > > compatible, but if we will use buffers smaller than 4K, we should
> > > encounter the error described above.

So that's an implementation bug then? It made an assumption
of a 4K sized buffer? Or even PAGE_SIZE sized buffer?


> > > 
> > > How do you suggest we proceed if we want to change the buffer size?
> > > Maybe adding a feature to "support any buffer size"?
> > > 
> > > Thanks,
> > > Stefano
> > 
> > 
> 
> -- 
