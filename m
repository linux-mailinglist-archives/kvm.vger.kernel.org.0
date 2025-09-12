Return-Path: <kvm+bounces-57418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5457CB553D0
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 565F8AE2BED
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71C39220F5E;
	Fri, 12 Sep 2025 15:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L2gBqF86"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10C431283E
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691525; cv=none; b=L9tIPKpsZ9pJedbTtVhF2UF2gz1fWXlt9ryGAXuxBpG8Pt/5XoG6shNeo0ObM8hjIoC2GSkfbPX44bb1L2qzlQdVNq6lmn+KdyslA6io2IBYsB4mddCkkNnM4dv/vNQ9WDT5a9oulEn7x4yV/Hy6/WBy123CdXaX9NCaS5dpUlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691525; c=relaxed/simple;
	bh=yA5W0gyjqiFInACMAabQjnKR5iVoASdT39QfR/SdyN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVJgilGEKsfAqYpDQrlmz7E1x1BJ5CBOQgmXxI0vr/9abgD774EmoN4oztoEuafa8mp8Y+IfAWYszS7GFKdFfd9RS2S2iCP7Rff31euXxrPKWOLJ7ceOvZ0MjA8c88T5zhHw1jX9u0g20G6wlg+WC778PkMHx+52SRh3dknA/64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L2gBqF86; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757691522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TSPNoqFe2CICtx8x9/0bzyvcMYgkBZkWJVegup2Y/D0=;
	b=L2gBqF86c3RZaK12e301xA8voh6KTg79zZsvdCzG219b9Q58M3RJG7SE3e7tT4bLYDMGqm
	5Q1vxiX4WfLDT241uSxXgItuuh7mtfEC+CXw9buhQ1jTW2kxXG8K/FD7cSp3BDvIy8RK14
	m1aqd3zbuYeVJ2hfA0Kw5JEHs9cw55U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-aK7Tri42N0qbtI8WPEnobw-1; Fri, 12 Sep 2025 11:38:39 -0400
X-MC-Unique: aK7Tri42N0qbtI8WPEnobw-1
X-Mimecast-MFC-AGG-ID: aK7Tri42N0qbtI8WPEnobw_1757691518
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3dc3f943e6eso1155670f8f.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 08:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757691518; x=1758296318;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TSPNoqFe2CICtx8x9/0bzyvcMYgkBZkWJVegup2Y/D0=;
        b=Grs1CWGCDPzM84ekebxZVKY/PJNhvnUMOQRUl5zWCxdxEwAk/SNE/5FK5UJf4HlZbi
         cUb8TiBVyNx446k5gWBGnEVW2ZUepk+8Zyb+j4cQZgXs0UUFQV8TXgvzHt6TbOcAcGwy
         9LQ42P1s1TzWnuEA7zTgi3xomxIQhuWTEDf4f6m0vfElqrTrDBNMqjCJeR1hgTlmCOqy
         QeTAla0kx4mcjnJIKsw3mB/P5lSvUgzXti2CWXypGu4N0+5fSl4TD3sBXMRzECx3xut5
         ipIbTyQNJD8TEmvXkA/NxUrCZgMFCjyb/neTWPUiq1M88Lfwdx/x1WXPljrZBNYXTtRs
         wMUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6sVyyzAPnOoxvXHxAP91SFC+Ij4MUPJJ2p8ZQUvfAdzSNF56fXYp2MpD65VF1mFj+Mpw=@vger.kernel.org
X-Gm-Message-State: AOJu0YysMM6SCB5qNEoyoydzEh7mV0++nrTlPuPejW+0FOgbPKhDxV7j
	/SomcEc5n7g4+CuV6tRS2YcX7GepKZouJ/51OM2Vuu9OWTP6iPv50l5cB4dbOOf6u/JJ4MIYzMY
	m02kjEAW+5J7EpDCfVPLPlSbsOUcNaW2c8ZPIEqeqZUh9B+LUKtjuyg==
X-Gm-Gg: ASbGncvYR+0qDKv8yh5ONUf33wvhRJIH+SHdriIlJ0MOdkSuPT/9APQSYpqLy3EK30X
	93tCw6S3n6K1KHf4CaKwCatsEd6z8zFvmbHw+qgloN06tBxbYHxJxywnJwxdbvQW9aNtz5UwbAN
	J0tZainJei+wKOBllFeJdD8pxZGEWgwVqB2qp5fH1r2KaaDeLJAdORNbCGqbgiKWR4xC6vS+sB0
	l5AVK7dUj5XrPCt/TgwGoSnd5olp96OLIPZIZLrZcji88VQ2Fu43VkxewipVcHOI9fo7yohyP46
	Ng3ZoTC2BlO0LHTQIggcrDzLxrnKIXYlzu8=
X-Received: by 2002:a05:6000:607:b0:3e7:5f26:f1e5 with SMTP id ffacd0b85a97d-3e7657c4d40mr2960034f8f.23.1757691518268;
        Fri, 12 Sep 2025 08:38:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHU2k5VNrAMxJMJsslonyveuVI1XMMPRzh7WCfgvwmksVI/+i/xxPC3tMUE4P/r7651cJtw3w==
X-Received: by 2002:a05:6000:607:b0:3e7:5f26:f1e5 with SMTP id ffacd0b85a97d-3e7657c4d40mr2959997f8f.23.1757691517807;
        Fri, 12 Sep 2025 08:38:37 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e01512379sm69044125e9.0.2025.09.12.08.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:38:37 -0700 (PDT)
Date: Fri, 12 Sep 2025 11:38:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	"jonah.palmer@oracle.com" <jonah.palmer@oracle.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Message-ID: <20250912113432-mutt-send-email-mst@kernel.org>
References: <20250912082658.2262-1-jasowang@redhat.com>
 <20250912082658.2262-2-jasowang@redhat.com>
 <20250912044523-mutt-send-email-mst@kernel.org>
 <63426904-881F-4725-96F5-3343389ED170@nutanix.com>
 <20250912112726-mutt-send-email-mst@kernel.org>
 <4418BA21-716E-468B-85EB-DB88CCD64F38@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4418BA21-716E-468B-85EB-DB88CCD64F38@nutanix.com>

On Fri, Sep 12, 2025 at 03:33:32PM +0000, Jon Kohler wrote:
> 
> 
> > On Sep 12, 2025, at 11:30 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> > 
> > |-------------------------------------------------------------------!
> > 
> > On Fri, Sep 12, 2025 at 03:24:42PM +0000, Jon Kohler wrote:
> >> 
> >> 
> >>> On Sep 12, 2025, at 4:50 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> >>> 
> >>> !-------------------------------------------------------------------|
> >>> CAUTION: External Email
> >>> 
> >>> |-------------------------------------------------------------------!
> >>> 
> >>> On Fri, Sep 12, 2025 at 04:26:58PM +0800, Jason Wang wrote:
> >>>> Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
> >>>> sendmsg") tries to defer the notification enabling by moving the logic
> >>>> out of the loop after the vhost_tx_batch() when nothing new is
> >>>> spotted. This will bring side effects as the new logic would be reused
> >>>> for several other error conditions.
> >>>> 
> >>>> One example is the IOTLB: when there's an IOTLB miss, get_tx_bufs()
> >>>> might return -EAGAIN and exit the loop and see there's still available
> >>>> buffers, so it will queue the tx work again until userspace feed the
> >>>> IOTLB entry correctly. This will slowdown the tx processing and may
> >>>> trigger the TX watchdog in the guest.
> >>> 
> >>> It's not that it might.
> >>> Pls clarify that it *has been reported* to do exactly that,
> >>> and add a link to the report.
> >>> 
> >>> 
> >>>> Fixing this by stick the notificaiton enabling logic inside the loop
> >>>> when nothing new is spotted and flush the batched before.
> >>>> 
> >>>> Reported-by: Jon Kohler <jon@nutanix.com>
> >>>> Cc: stable@vger.kernel.org
> >>>> Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
> >>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >>> 
> >>> So this is mostly a revert, but with
> >>>                    vhost_tx_batch(net, nvq, sock, &msg);
> >>> added in to avoid regressing performance.
> >>> 
> >>> If you do not want to structure it like this (revert+optimization),
> >>> then pls make that clear in the message.
> >>> 
> >>> 
> >>>> ---
> >>>> drivers/vhost/net.c | 33 +++++++++++++--------------------
> >>>> 1 file changed, 13 insertions(+), 20 deletions(-)
> >>>> 
> >>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >>>> index 16e39f3ab956..3611b7537932 100644
> >>>> --- a/drivers/vhost/net.c
> >>>> +++ b/drivers/vhost/net.c
> >>>> @@ -765,11 +765,11 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> >>>> int err;
> >>>> int sent_pkts = 0;
> >>>> bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
> >>>> - bool busyloop_intr;
> >>>> bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> >>>> 
> >>>> do {
> >>>> - busyloop_intr = false;
> >>>> + bool busyloop_intr = false;
> >>>> +
> >>>> if (nvq->done_idx == VHOST_NET_BATCH)
> >>>> vhost_tx_batch(net, nvq, sock, &msg);
> >>>> 
> >>>> @@ -780,10 +780,18 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> >>>> break;
> >>>> /* Nothing new?  Wait for eventfd to tell us they refilled. */
> >>>> if (head == vq->num) {
> >>>> - /* Kicks are disabled at this point, break loop and
> >>>> - * process any remaining batched packets. Queue will
> >>>> - * be re-enabled afterwards.
> >>>> + /* Flush batched packets before enabling
> >>>> + * virqtueue notification to reduce
> >>>> + * unnecssary virtqueue kicks.
> >>> 
> >>> typos: virtqueue, unnecessary
> >>> 
> >>>> */
> >>>> + vhost_tx_batch(net, nvq, sock, &msg);
> >>>> + if (unlikely(busyloop_intr)) {
> >>>> + vhost_poll_queue(&vq->poll);
> >>>> + } else if (unlikely(vhost_enable_notify(&net->dev,
> >>>> + vq))) {
> >>>> + vhost_disable_notify(&net->dev, vq);
> >>>> + continue;
> >>>> + }
> >>>> break;
> >>>> }
> >> 
> >> See my comment below, but how about something like this?
> >> if (head == vq->num) {
> >> /* Flush batched packets before enabling
> >> * virtqueue notification to reduce
> >> * unnecessary virtqueue kicks.
> >> */
> >> vhost_tx_batch(net, nvq, sock, &msg);
> >> if (unlikely(busyloop_intr))
> >> /* If interrupted while doing busy polling,
> >> * requeue the handler to be fair handle_rx
> >> * as well as other tasks waiting on cpu.
> >> */
> >> vhost_poll_queue(&vq->poll);
> >> else
> >> /* All of our work has been completed;
> >> * however, before leaving the TX handler,
> >> * do one last check for work, and requeue
> >> * handler if necessary. If there is no work,
> >> * queue will be reenabled.
> >> */
> >> vhost_net_busy_poll_try_queue(net, vq);
> > 
> > 
> > I mean it's functionally equivalent, but vhost_net_busy_poll_try_queue 
> > checks the avail ring again and we just checked it.
> > Why is this a good idea?
> > This happens on good path so I dislike unnecessary work like this.
> 
> For the sake of discussion, let’s say vhost_tx_batch and the
> sendmsg within took 1 full second to complete. A lot could potentially
> happen in that amount of time. So sure, control path wise it looks like
> we just checked it, but time wise, that could have been ages ago.


Oh I forgot we had the tx batch in there.
OK then, I don't have a problem with this.


However, what I like about Jason's patch is that
it is actually simply revert of your patch +
a single call to 
vhost_tx_batch(net, nvq, sock, &msg);

So it is a more obviosly correct approach.


I'll be fine with doing what you propose on top,
with testing that they are benefitial for performance.






> > 
> > 
> >> break;
> >> }
> >> 
> >> 
> >>>> 
> >>>> @@ -839,22 +847,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> >>>> ++nvq->done_idx;
> >>>> } while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
> >>>> 
> >>>> - /* Kicks are still disabled, dispatch any remaining batched msgs. */
> >>>> vhost_tx_batch(net, nvq, sock, &msg);
> >>>> -
> >>>> - if (unlikely(busyloop_intr))
> >>>> - /* If interrupted while doing busy polling, requeue the
> >>>> - * handler to be fair handle_rx as well as other tasks
> >>>> - * waiting on cpu.
> >>>> - */
> >>>> - vhost_poll_queue(&vq->poll);
> >>>> - else
> >>>> - /* All of our work has been completed; however, before
> >>>> - * leaving the TX handler, do one last check for work,
> >>>> - * and requeue handler if necessary. If there is no work,
> >>>> - * queue will be reenabled.
> >>>> - */
> >>>> - vhost_net_busy_poll_try_queue(net, vq);
> >> 
> >> Note: the use of vhost_net_busy_poll_try_queue was intentional in my
> >> patch as it was checking to see both conditionals.
> >> 
> >> Can we simply hoist my logic up instead?
> >> 
> >>>> }
> >>>> 
> >>>> static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> >>>> -- 
> >>>> 2.34.1
> >>> 
> >> 
> >> Tested-by: Jon Kohler <jon@nutanix.com <mailto:jon@nutanix.com>>
> >> 
> >> Tried this out on a 6.16 host / guest that locked up with iotlb miss loop,
> >> applied this patch and all was well.
> > 
> 


