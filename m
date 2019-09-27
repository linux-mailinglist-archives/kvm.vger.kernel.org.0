Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D203C018F
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 10:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfI0IzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 04:55:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfI0IzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 04:55:18 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F4D0C05AA56
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 08:55:18 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id o188so2452287wmo.5
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 01:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kQTiVTZ4Mq/mW2Kd0TK632A8br3BLFa78jUrRSmJlNc=;
        b=Q6VgxhUo2FtIaZWM6iEq2IVRH8mmCxAuuhIuOux5oF/UipxfhWc81+XjfnALbH0Dcq
         eJWcSF8Ee5sun0gEcmBPKJ8DetpDJJV6FEUrWA7qhpG/OC5HgL7FC8G8kB/uFC+Q1aKf
         K+RA7JjDUdp5aSdSnvBkw1z9mc7MzB4F3F+dH3V+I0lmRCBr9mGRPoH+G7BFoRHxC2vM
         MF/7582hYl0XQxMswMRmOjFLCXGZUzPzZHyr7FRq5mt7LH679p10n3W+m6F6NlATeM87
         GsKjuof0zhEf/BNdCIgZtE33sxh56ZAinelnJjF7SEWLrXCOoFaL3kLanKx1F1TGvZd+
         JZ9Q==
X-Gm-Message-State: APjAAAVmwUc14AZmdJ3vxuNzFL6mzGVsFz2UM9Vd6oVFSEp92UxlPcw1
        m1Ul/T+eC/WTXgOHq/GQExh6Qpnyi1181mU4G5G7Ll3MNEO7iErzJ44lK6HdtV5MLLRjFqafH12
        HUjsiZKnAtD9R
X-Received: by 2002:a5d:4985:: with SMTP id r5mr1850856wrq.139.1569574516914;
        Fri, 27 Sep 2019 01:55:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxKqarGeS37HsOdE4S4EFyv/G/LShaICk0WfDh7NPQYyW6JT3JqAigce82jij5WGe+7i863hg==
X-Received: by 2002:a5d:4985:: with SMTP id r5mr1850844wrq.139.1569574516698;
        Fri, 27 Sep 2019 01:55:16 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id d10sm5875238wma.42.2019.09.27.01.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 01:55:16 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:55:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
Cc:     stefanha@redhat.com, davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: add support for MSG_PEEK
Message-ID: <20190927085513.tdiofiisrpyehfe5@steredhat.homenet.telecomitalia.it>
References: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
 <f069a65d-33b9-1fa8-d26e-b76cc51fc7cb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f069a65d-33b9-1fa8-d26e-b76cc51fc7cb@gmail.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 12:33:36PM -0700, Eric Dumazet wrote:
> 
> 
> On 9/26/19 11:23 AM, Matias Ezequiel Vara Larsen wrote:
> > This patch adds support for MSG_PEEK. In such a case, packets are not
> > removed from the rx_queue and credit updates are not sent.
> > 
> > Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
> > ---
> >  net/vmw_vsock/virtio_transport_common.c | 50 +++++++++++++++++++++++++++++++--
> >  1 file changed, 47 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index 94cc0fa..938f2ed 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -264,6 +264,50 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
> >  }
> >  
> >  static ssize_t
> > +virtio_transport_stream_do_peek(struct vsock_sock *vsk,
> > +				struct msghdr *msg,
> > +				size_t len)
> > +{
> > +	struct virtio_vsock_sock *vvs = vsk->trans;
> > +	struct virtio_vsock_pkt *pkt;
> > +	size_t bytes, total = 0;
> > +	int err = -EFAULT;
> > +
> > +	spin_lock_bh(&vvs->rx_lock);
> > +
> > +	list_for_each_entry(pkt, &vvs->rx_queue, list) {
> > +		if (total == len)
> > +			break;
> > +
> > +		bytes = len - total;
> > +		if (bytes > pkt->len - pkt->off)
> > +			bytes = pkt->len - pkt->off;
> > +
> > +		/* sk_lock is held by caller so no one else can dequeue.
> > +		 * Unlock rx_lock since memcpy_to_msg() may sleep.
> > +		 */
> > +		spin_unlock_bh(&vvs->rx_lock);
> > +
> > +		err = memcpy_to_msg(msg, pkt->buf + pkt->off, bytes);
> > +		if (err)
> > +			goto out;
> > +
> > +		spin_lock_bh(&vvs->rx_lock);
> > +
> > +		total += bytes;
> > +	}
> > +
> > +	spin_unlock_bh(&vvs->rx_lock);
> > +
> > +	return total;
> > +
> > +out:
> > +	if (total)
> > +		err = total;
> > +	return err;
> > +}
> >
> 
> This seems buggy to me.
> 
> virtio_transport_recv_enqueue() seems to be able to add payload to the last packet in the queue.
> 
> The loop you wrote here would miss newly added chunks while the vvs->rx_lock spinlock has been released.
> 
> virtio_transport_stream_do_dequeue() is ok, because it makes sure pkt->off == pkt->len
> before cleaning the packet from the queue.

Good catch!

Maybe we can solve in this way:

	list_for_each_entry(pkt, &vvs->rx_queue, list) {
		size_t off = pkt->off;

		if (total == len)
			break;

		while (total < len && off < pkt->len) {
			/* using 'off' instead of 'pkt->off' */
			...

			total += bytes;
			off += bytes;
		}
	}

What do you think?

Cheers,
Stefano
