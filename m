Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CAB790A2
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 18:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfG2QTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 12:19:10 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39407 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfG2QTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 12:19:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so9347981wrt.6
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 09:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZKDqUs0ayhzO8fC3NvwV+tCFuuA/FPgD3ePdCx1GJqM=;
        b=VW2bNrUUMSiIw8523ltJpXIV9TKNfOp799my/83CsNtrK2RM5Zx2b1lzI40xB+OorH
         7J/joB615o0byhXjMZn9ZVJxCKtpzUqBbb6z0Lu7EB9YiczhF3NqhMAZqR3cxqwbmNrl
         ob3w85LLhiFcJsivIZnXi6wZ7t7VqOr83UA8MQu4Uq7xajXwFDxNjtP69TFDw55pk2Ch
         IfyrF/dp5YviFMj7q9slLMlqH8AqJHShzhcyKcB7F30a4aigJEoL4Ocgtck/IibAmwiY
         f8IqJiHJG3Ss6mhQubwDXPYnvxdnLxJKM4FZ3zHJeOgA3eep/89U5k+kpRqYHBzO42AV
         rQ3w==
X-Gm-Message-State: APjAAAXEq5ePCGRAB27DCCOU8CftfwvCNYyqGOLE7/CirJSPYUk8FCNW
        iCTI4OlankVm6P4JzG6lnznS2w==
X-Google-Smtp-Source: APXvYqx0sc12Pv/jNOPaKvwFRyWt3K0PAbYM2mQ0eNUoR5RWLAC9VV53Iw6ZEaEpC4k4BBzOXgmD7Q==
X-Received: by 2002:a5d:4b8b:: with SMTP id b11mr40501951wrt.294.1564417146999;
        Mon, 29 Jul 2019 09:19:06 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id c11sm104255286wrq.45.2019.07.29.09.19.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:19:06 -0700 (PDT)
Date:   Mon, 29 Jul 2019 18:19:03 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190729161903.yhaj5rfcvleexkhc@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190729153656.zk4q4rob5oi6iq7l@steredhat>
 <20190729114302-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729114302-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 29, 2019 at 11:49:02AM -0400, Michael S. Tsirkin wrote:
> On Mon, Jul 29, 2019 at 05:36:56PM +0200, Stefano Garzarella wrote:
> > On Mon, Jul 29, 2019 at 10:04:29AM -0400, Michael S. Tsirkin wrote:
> > > On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> > > > Since virtio-vsock was introduced, the buffers filled by the host
> > > > and pushed to the guest using the vring, are directly queued in
> > > > a per-socket list. These buffers are preallocated by the guest
> > > > with a fixed size (4 KB).
> > > > 
> > > > The maximum amount of memory used by each socket should be
> > > > controlled by the credit mechanism.
> > > > The default credit available per-socket is 256 KB, but if we use
> > > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > > guest will continue to fill the vring with new 4 KB free buffers
> > > > to avoid starvation of other sockets.
> > > > 
> > > > This patch mitigates this issue copying the payload of small
> > > > packets (< 128 bytes) into the buffer of last packet queued, in
> > > > order to avoid wasting memory.
> > > > 
> > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > 
> > > This is good enough for net-next, but for net I think we
> > > should figure out how to address the issue completely.
> > > Can we make the accounting precise? What happens to
> > > performance if we do?
> > > 
> > 
> > In order to do more precise accounting maybe we can use the buffer size,
> > instead of payload size when we update the credit available.
> > In this way, the credit available for each socket will reflect the memory
> > actually used.
> > 
> > I should check better, because I'm not sure what happen if the peer sees
> > 1KB of space available, then it sends 1KB of payload (using a 4KB
> > buffer).
> > 
> > The other option is to copy each packet in a new buffer like I did in
> > the v2 [2], but this forces us to make a copy for each packet that does
> > not fill the entire buffer, perhaps too expensive.
> > 
> > [2] https://patchwork.kernel.org/patch/10938741/
> > 
> > 
> > Thanks,
> > Stefano
> 
> Interesting. You are right, and at some level the protocol forces copies.
> 
> We could try to detect that the actual memory is getting close to
> admin limits and force copies on queued packets after the fact.
> Is that practical?

Yes, I think it is doable!
We can decrease the credit available with the buffer size queued, and
when the buffer size of packet to queue is bigger than the credit
available, we can copy it.

> 
> And yes we can extend the credit accounting to include buffer size.
> That's a protocol change but maybe it makes sense.

Since we send to the other peer the credit available, maybe this
change can be backwards compatible (I'll check better this).

Thanks,
Stefano
