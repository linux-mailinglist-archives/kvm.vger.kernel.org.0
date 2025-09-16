Return-Path: <kvm+bounces-57669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDBB7B58DD0
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:19:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0883C523A0B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 05:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72FA42C11C9;
	Tue, 16 Sep 2025 05:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJUKtbSP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF2027FD5A
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 05:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757999945; cv=none; b=p84fiB7VyMiR1D7okv/dZZBy/4UeWY1epxdeNdtXPoVncwajsFx+RrFN1K3Z8Qr2Jw1Wnf7oLt9RWO9irU/cc46pEKbxDUi4ZxMmcMo1sbCUCIIskAlo7NHvYw/StDlrKQeG92GInKR0yC17QDDm0/bmxCFBl7wl8m+yIQemTXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757999945; c=relaxed/simple;
	bh=mYY1Q6a+G8tiWMSHSj+eXVNe+H398j6nOY5cYHrd3rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sz5/JoV4EKOUa2G4Iul/iFI4U87UE7h8aF/1+lrKfrUxXG/5GZUPdUKVpToI37XZQXljWZUiRN+awQWTw61qZdBtzriTvvOi3TCcLrepIR1Hqg5+pZXVLjN1a8TSEKDNTELvjPGNOwxszmxktZFLZSsjocB0gv1H+GhdxnfvJxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FJUKtbSP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757999942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8cqWpCLzeZ7Ek+DqtxOkx2773HtQBKMmlIbsEIMhI1E=;
	b=FJUKtbSPht2n3VeLNni6sAycU9vd/PLpxxqeO+A+EVY5vg8sxY2/QXANNoT5iNK5KFBuaX
	m8hVJsOEA0oUxZtHJjz5Y2aE4X9joNAieOn0b768YfXG/T+yhuN6UOVn+YIZAkRViFWsP1
	YtGDpdG//uE/snSjU2AbTe2zHoX/hlg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-ubDjMiudNB6ZBgiB_HkGrQ-1; Tue, 16 Sep 2025 01:19:01 -0400
X-MC-Unique: ubDjMiudNB6ZBgiB_HkGrQ-1
X-Mimecast-MFC-AGG-ID: ubDjMiudNB6ZBgiB_HkGrQ_1757999940
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aff0df4c4abso674077966b.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 22:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757999940; x=1758604740;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cqWpCLzeZ7Ek+DqtxOkx2773HtQBKMmlIbsEIMhI1E=;
        b=B/wJLPSaklyeSlbrE4lo8L8BqhuMKQQXATt1esyGtXr7/5xZnqeFNRiGQNU5FQ9x5d
         egvpLGedYxUh5ttCHoY4u5U/IDeN54j0S/qgv867E0sXcmZbg9lsJFa2IpOv3Ro6xyOW
         s0VcLFgWXtRIAE87zCr49X0tfEr10hEoLEfMrYThSlC6NygqKG4IlKb5sOEEIXRCjUxM
         Qsw7iYgAu1lu7nWA1w+j5iJceitDgbvB5he+atZUtkazbRr73Prq7q7ufe31FQgixvQW
         mU/0XxFuVu6Mc9RyNIQJQtH/5QBvgfv/RdrCs9UN85FT49raSwMrGIDj2b173ndGsMda
         ouYA==
X-Forwarded-Encrypted: i=1; AJvYcCXobo77iMSbXIteK2oWz/9foNQPjTmwdE4cNa3mtEbG5yzFjWb3sTe6l+AvnuS/KP5zlpg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTO7JRjcz6HfQvFZB28kwBRIb94QjS+hdEteTHnEMY5DWNu2MS
	93c61uxYTxozQBKGPJRJOW3ZhUDfOfEXFbBDnrPP6AkBpzse4HxFDTkXt+al8CHUZRuMoEvkqWY
	TFqGjaH3c/LIpRuv0nOjUQzv/xQXiRziz2bUoovtVl9hY6AT8AV01pA==
X-Gm-Gg: ASbGncvApHfZNOH7Ajmmoc01uRYUx5zcEG1av/m1CaKZ5NBvROae871N0pQQGXuuW36
	vbGb+iLocKbrEKyJ9t70iJy0kHyu820PRNrV6GTtWK695+IHdbnjj3s9DfeTL9nhVkZ7OEw6bT+
	1cMdXJIdjAXqZD5IBJoWBp1eH8OG2ZpUXFTRyhpEQCtY4rXrG0U37/5eX4npw4lJUzcV9y1NKEl
	ORPW04FcXkUP6GhR0Ss+fp6RTkNrIjZOGgZIR30g8MnMJC7liDqf3VJUgvFoUupqQVMGNzPa/1N
	Ofowiq0uDCvfSCU/sGgxe5/jzwV1
X-Received: by 2002:a17:907:1b1d:b0:b04:a780:4673 with SMTP id a640c23a62f3a-b07c38292a0mr1470550166b.31.1757999939863;
        Mon, 15 Sep 2025 22:18:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeTBH3RrhB4KX+YqUITKSLlPI9qo0agFX7/p4HwGPFdqgb6XY+aoH+6CU5sr1Y0eG7AGevXg==
X-Received: by 2002:a17:907:1b1d:b0:b04:a780:4673 with SMTP id a640c23a62f3a-b07c38292a0mr1470547666b.31.1757999939378;
        Mon, 15 Sep 2025 22:18:59 -0700 (PDT)
Received: from redhat.com ([31.187.78.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b32f22b1sm1090360166b.86.2025.09.15.22.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 22:18:58 -0700 (PDT)
Date: Tue, 16 Sep 2025 01:18:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eperezma@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org,
	jon@nutanix.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Message-ID: <20250916011733-mutt-send-email-mst@kernel.org>
References: <20250912082658.2262-1-jasowang@redhat.com>
 <20250912082658.2262-2-jasowang@redhat.com>
 <20250915120210-mutt-send-email-mst@kernel.org>
 <CACGkMEufUAL1tBrfZVMQCEBmBZ=Z+aPqUtP=RzOQhjtG9jn7UA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEufUAL1tBrfZVMQCEBmBZ=Z+aPqUtP=RzOQhjtG9jn7UA@mail.gmail.com>

On Tue, Sep 16, 2025 at 10:37:35AM +0800, Jason Wang wrote:
> On Tue, Sep 16, 2025 at 12:03 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Sep 12, 2025 at 04:26:58PM +0800, Jason Wang wrote:
> > > Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
> > > sendmsg") tries to defer the notification enabling by moving the logic
> > > out of the loop after the vhost_tx_batch() when nothing new is
> > > spotted. This will bring side effects as the new logic would be reused
> > > for several other error conditions.
> > >
> > > One example is the IOTLB: when there's an IOTLB miss, get_tx_bufs()
> > > might return -EAGAIN and exit the loop and see there's still available
> > > buffers, so it will queue the tx work again until userspace feed the
> > > IOTLB entry correctly. This will slowdown the tx processing and may
> > > trigger the TX watchdog in the guest.
> > >
> > > Fixing this by stick the notificaiton enabling logic inside the loop
> > > when nothing new is spotted and flush the batched before.
> > >
> > > Reported-by: Jon Kohler <jon@nutanix.com>
> > > Cc: stable@vger.kernel.org
> > > Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  drivers/vhost/net.c | 33 +++++++++++++--------------------
> > >  1 file changed, 13 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > index 16e39f3ab956..3611b7537932 100644
> > > --- a/drivers/vhost/net.c
> > > +++ b/drivers/vhost/net.c
> > > @@ -765,11 +765,11 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > >       int err;
> > >       int sent_pkts = 0;
> > >       bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
> > > -     bool busyloop_intr;
> > >       bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > >
> > >       do {
> > > -             busyloop_intr = false;
> > > +             bool busyloop_intr = false;
> > > +
> > >               if (nvq->done_idx == VHOST_NET_BATCH)
> > >                       vhost_tx_batch(net, nvq, sock, &msg);
> > >
> > > @@ -780,10 +780,18 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > >                       break;
> > >               /* Nothing new?  Wait for eventfd to tell us they refilled. */
> > >               if (head == vq->num) {
> > > -                     /* Kicks are disabled at this point, break loop and
> > > -                      * process any remaining batched packets. Queue will
> > > -                      * be re-enabled afterwards.
> > > +                     /* Flush batched packets before enabling
> > > +                      * virqtueue notification to reduce
> > > +                      * unnecssary virtqueue kicks.
> > >                        */
> > > +                     vhost_tx_batch(net, nvq, sock, &msg);
> >
> > So why don't we do this in the "else" branch"? If we are busy polling
> > then we are not enabling kicks, so is there a reason to flush?
> 
> It should be functional equivalent:
> 
> do {
>     if (head == vq->num) {
>         vhost_tx_batch();
>         if (unlikely(busyloop_intr)) {
>             vhost_poll_queue()
>         } else if () {
>             vhost_disable_notify(&net->dev, vq);
>             continue;
>         }
>         return;
> }
> 
> vs
> 
> do {
>     if (head == vq->num) {
>         if (unlikely(busyloop_intr)) {
>             vhost_poll_queue()
>         } else if () {
>             vhost_tx_batch();
>             vhost_disable_notify(&net->dev, vq);
>             continue;
>         }
>         break;
> }
> 
> vhost_tx_batch();
> return;
> 
> Thanks
>

But this is not what the code comment says:

                     /* Flush batched packets before enabling
                      * virqtueue notification to reduce
                      * unnecssary virtqueue kicks.


So I ask - of we queued more polling, why do we need
to flush batched packets? We might get more in the next
polling round, this is what polling is designed to do.

 
> 
> >
> >
> > > +                     if (unlikely(busyloop_intr)) {
> > > +                             vhost_poll_queue(&vq->poll);
> > > +                     } else if (unlikely(vhost_enable_notify(&net->dev,
> > > +                                                             vq))) {
> > > +                             vhost_disable_notify(&net->dev, vq);
> > > +                             continue;
> > > +                     }
> > >                       break;
> > >               }
> > >
> > > @@ -839,22 +847,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > >               ++nvq->done_idx;
> > >       } while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
> > >
> > > -     /* Kicks are still disabled, dispatch any remaining batched msgs. */
> > >       vhost_tx_batch(net, nvq, sock, &msg);
> > > -
> > > -     if (unlikely(busyloop_intr))
> > > -             /* If interrupted while doing busy polling, requeue the
> > > -              * handler to be fair handle_rx as well as other tasks
> > > -              * waiting on cpu.
> > > -              */
> > > -             vhost_poll_queue(&vq->poll);
> > > -     else
> > > -             /* All of our work has been completed; however, before
> > > -              * leaving the TX handler, do one last check for work,
> > > -              * and requeue handler if necessary. If there is no work,
> > > -              * queue will be reenabled.
> > > -              */
> > > -             vhost_net_busy_poll_try_queue(net, vq);
> > >  }
> > >
> > >  static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> > > --
> > > 2.34.1
> >


