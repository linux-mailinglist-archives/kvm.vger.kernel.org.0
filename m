Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C8B1BC3E
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 19:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731881AbfEMRvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 13:51:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39716 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbfEMRvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 13:51:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id n25so226748wmk.4
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 10:51:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YywBhd718B/DKtpyrTe7ekQZi7NNkVMxHXFs5r/UkzU=;
        b=nJFsmyWDUk9TUHfY0Oxj+Vov0AqBIcRX8IfbpbHsXCxpLcwEngRMmW405mlSYuAhab
         xF0bNzukhankcmrFs3CIFuldxUls6AvvA22f/Ydv5vgMKmrlnS1oeZjc61HNDf/B2Wl2
         J4VYeWy/mgx0odCKp1e383KvmnSVJzlGMieP2M8Vqau66RDMyi7G5KqvY+pLAC5Fs84m
         Q/rFnxFoswuAJM2DfCWmfl9N1ckzfPJ49G+UzCayV5zMdsQGS66c90lYkuouvzP0ObVs
         yXlD6Owy7sUNNGYSo/EG14TQD15szfo6J1BWVmvZR/c9+dK9uXq1bQdCO1zd5Ku6b12Z
         6V0w==
X-Gm-Message-State: APjAAAVNRfikk4oiwnLMgU3xq1sCteLHWRfnNm3WddfYmT1mbe3HltIA
        nUX1JvxsORPvRHM/hQQS9/5crg==
X-Google-Smtp-Source: APXvYqwIUwuqMl8h+g4rfizOwGvKS5bfbCa0CnOcHXmQACgAyWBKmcpVwSB4wHSIlaL+ZzJ2dbSatQ==
X-Received: by 2002:a1c:f910:: with SMTP id x16mr16414740wmh.114.1557769902025;
        Mon, 13 May 2019 10:51:42 -0700 (PDT)
Received: from steredhat (host151-251-static.12-87-b.business.telecomitalia.it. [87.12.251.151])
        by smtp.gmail.com with ESMTPSA id y40sm14326745wrd.96.2019.05.13.10.51.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 May 2019 10:51:41 -0700 (PDT)
Date:   Mon, 13 May 2019 19:51:38 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v2 7/8] vsock/virtio: increase RX buffer size to 64 KiB
Message-ID: <20190513175138.4yycad2xi65komw6@steredhat>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-8-sgarzare@redhat.com>
 <bf0416f1-0e69-722d-75ce-3d101e6d7d71@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bf0416f1-0e69-722d-75ce-3d101e6d7d71@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 06:01:52PM +0800, Jason Wang wrote:
> 
> On 2019/5/10 下午8:58, Stefano Garzarella wrote:
> > In order to increase host -> guest throughput with large packets,
> > we can use 64 KiB RX buffers.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >   include/linux/virtio_vsock.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > index 84b72026d327..5a9d25be72df 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -10,7 +10,7 @@
> >   #define VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE	128
> >   #define VIRTIO_VSOCK_DEFAULT_BUF_SIZE		(1024 * 256)
> >   #define VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE	(1024 * 256)
> > -#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
> > +#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 64)
> >   #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
> >   #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
> 
> 
> We probably don't want such high order allocation. It's better to switch to
> use order 0 pages in this case. See add_recvbuf_big() for virtio-net. If we
> get datapath unified, we will get more stuffs set.

IIUC, you are suggesting to allocate only pages and put them in a
scatterlist, then add them to the virtqueue.

Is it correct?

The issue that I have here, is that the virtio-vsock guest driver, see
virtio_vsock_rx_fill(), allocates a struct virtio_vsock_pkt that
contains the room for the header, then allocates the buffer for the payload.
At this point it fills the scatterlist with the &virtio_vsock_pkt.hdr and the
buffer for the payload.

Changing this will require several modifications, and if we get datapath
unified, I'm not sure it's worth it.
Of course, if we leave the datapaths separated, I'd like to do that later.

What do you think?

Thanks,
Stefano
