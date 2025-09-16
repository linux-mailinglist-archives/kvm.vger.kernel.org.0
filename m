Return-Path: <kvm+bounces-57704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CBB1B59270
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 11:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 350AD3201B3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF2D283FFB;
	Tue, 16 Sep 2025 09:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NBHHF8LO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206EF29A9C3
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 09:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758015564; cv=none; b=GnohV0pqCTVQasR5WT43Ny3RRmD4HCTfsaKmPlY/k0vKbLOysVmRkUjJmyYk2oPWcJ+PdMXc+yVGeJikcw/wwZoxx73TTrx3ApCG4LttWlqKPi7Nuf+v8xY9Il1WIczWt9P/XESbcjgIfC2mhwvE5hu8DDNZUtFklk8tjjfDTWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758015564; c=relaxed/simple;
	bh=6DRYBwPSDQW1jpjkTq0DHNAJkPr8od/IdlP5PW4dxXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lz2kWdHhDc+2RT+ZxZLA+ESVOBxaXoVh+AMID1DT7YXoGJanVKxnVe3yrm4h7IbfMmyTMipEHkvWHfR61Vt8O1fOMae8Q1n35VXqsHHl31wnheutdi9Qxk5VulfQRVwcyIu/6JiJ/twmW9HmzU3McUASG0MzrwWKrNTnGgrBZsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NBHHF8LO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758015561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mg7T0kQEdQ7FBfapeuxsmVNYMds4ObzbW92Zj/OuxmU=;
	b=NBHHF8LOgZYrF2Isw57EY668PWDN1+2tlT2QctciD/xR0U8MNG6VEISxRi91ilr74rJfdR
	eE5zZG4H66AeFqLnnQaMon4zTSgssYlCk27gPWRCeLOogAWrwej6ZAtSZx43bwFaMydVDS
	ir5z+nUl1xMrrvRjuvOHPMdgj69qyb8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-lB2OueZ6NauepY05YNdEgg-1; Tue, 16 Sep 2025 05:39:18 -0400
X-MC-Unique: lB2OueZ6NauepY05YNdEgg-1
X-Mimecast-MFC-AGG-ID: lB2OueZ6NauepY05YNdEgg_1758015557
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b0ea66f6811so222459066b.1
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 02:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758015557; x=1758620357;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mg7T0kQEdQ7FBfapeuxsmVNYMds4ObzbW92Zj/OuxmU=;
        b=GJm6oyA9CUN/gpCqzPFsrZbbbFms5ba8PXuk8bzmDGhZDob3SvqmzgyrgG28Uko6F8
         eb3N9ZaUy5T7KRkTEiWM9dkxr0j3Nhts5z77e9cSe/KZgHa8nAbmG/5IB8df6Hi2u8H4
         JUmTDyejSawfy0wZcPmr7vEPgu9X6WYB/bZpEx4m/JPYJUJ3Jv0NRW4usNRRT/pe1Hid
         40MQXCEcptgsFh9P7PQEFAiGJM/e+9tYgNyztpxDg5wl3SSGwtl7PUax+d9Dj3qVB3hO
         0tYwR0iSItw6gtVgqZzMrwiTkMF/gQy/3U9kdBDzQ88DokX6gdI0sL9SyTxAyhW/QTxo
         UnQA==
X-Forwarded-Encrypted: i=1; AJvYcCXVfFwJhib9XeKmRFI9240Q4iuFARBtsoRzNQn9Ogi4JEehIft0M5apfHVUpW0SpqMGiz8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGD4d9L1QdPyhKUUay8HWApwaDInoi60gd3wRRgplEwLwoP8Lw
	mW0YPO0ZdOC5TGIQrhH2RrIV03fDlvUbxxMher6EPdsL9Eb5XWv5PK9D5jmyOHpsd0WkFPFxiE5
	0zAOAq1INPTQJv/z6EXhebYgw9eAobkpXgmAhXslspuCDJ4AHZXrkow==
X-Gm-Gg: ASbGnctriIbdiNfGfxnMQqE9k9Kyw9/5PYHkQktnhLEAgvdwYJZf/0i+AbMpbeAwv7n
	/J7flCekuJWoCYQ6ZV38UUjB0y/wMO991NSq30Yqe6+/BGcOgOKVHalujgJ/RNgVuKKplrsQ26p
	g2h/LFs0OJTg41/yJudNYdIXI4bvzOdDtwXFvJ+c8lq9uMbQBxWHv38LCnme5qBRimAstjbItnm
	LtopHWDBkhzD7UkA0pk+OXCHpw4py+REqsDVnykAbXWg9Q4iZF8c3OLlKd17/VfA5GzCOu7hhXS
	q0mOiFyFXpUuGzGTL0Vr8TLkI1X5
X-Received: by 2002:a17:907:7e84:b0:b04:3302:d7a8 with SMTP id a640c23a62f3a-b07c3a77ef1mr1835871266b.58.1758015556784;
        Tue, 16 Sep 2025 02:39:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEL9xm1d3rRrWqvJve/PLiCDKmVMyNZWdCqpuRPm8Fk1iVgEX6WsHMd5ecb9Pr8TQ5Xn3WbGQ==
X-Received: by 2002:a17:907:7e84:b0:b04:3302:d7a8 with SMTP id a640c23a62f3a-b07c3a77ef1mr1835869266b.58.1758015556348;
        Tue, 16 Sep 2025 02:39:16 -0700 (PDT)
Received: from redhat.com ([31.187.78.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b08cab32303sm687037066b.72.2025.09.16.02.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:39:15 -0700 (PDT)
Date: Tue, 16 Sep 2025 05:39:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eperezma@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org,
	jon@nutanix.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Message-ID: <20250916053418-mutt-send-email-mst@kernel.org>
References: <20250912082658.2262-1-jasowang@redhat.com>
 <20250912082658.2262-2-jasowang@redhat.com>
 <20250915120210-mutt-send-email-mst@kernel.org>
 <CACGkMEufUAL1tBrfZVMQCEBmBZ=Z+aPqUtP=RzOQhjtG9jn7UA@mail.gmail.com>
 <20250916011733-mutt-send-email-mst@kernel.org>
 <CACGkMEu_p-ouLbEq26vMTJmeGs1hw5JHOk1qLt8mLLPOMLDbaQ@mail.gmail.com>
 <20250916030549-mutt-send-email-mst@kernel.org>
 <CACGkMEt2fAkCb_nC4QwR+3Jq+fS8=7bx=T3AEzPP1KGLErbSBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEt2fAkCb_nC4QwR+3Jq+fS8=7bx=T3AEzPP1KGLErbSBA@mail.gmail.com>

On Tue, Sep 16, 2025 at 03:20:36PM +0800, Jason Wang wrote:
> On Tue, Sep 16, 2025 at 3:08 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Sep 16, 2025 at 02:24:22PM +0800, Jason Wang wrote:
> > > On Tue, Sep 16, 2025 at 1:19 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Sep 16, 2025 at 10:37:35AM +0800, Jason Wang wrote:
> > > > > On Tue, Sep 16, 2025 at 12:03 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Fri, Sep 12, 2025 at 04:26:58PM +0800, Jason Wang wrote:
> > > > > > > Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
> > > > > > > sendmsg") tries to defer the notification enabling by moving the logic
> > > > > > > out of the loop after the vhost_tx_batch() when nothing new is
> > > > > > > spotted. This will bring side effects as the new logic would be reused
> > > > > > > for several other error conditions.
> > > > > > >
> > > > > > > One example is the IOTLB: when there's an IOTLB miss, get_tx_bufs()
> > > > > > > might return -EAGAIN and exit the loop and see there's still available
> > > > > > > buffers, so it will queue the tx work again until userspace feed the
> > > > > > > IOTLB entry correctly. This will slowdown the tx processing and may
> > > > > > > trigger the TX watchdog in the guest.
> > > > > > >
> > > > > > > Fixing this by stick the notificaiton enabling logic inside the loop
> > > > > > > when nothing new is spotted and flush the batched before.
> > > > > > >
> > > > > > > Reported-by: Jon Kohler <jon@nutanix.com>
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
> > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > ---
> > > > > > >  drivers/vhost/net.c | 33 +++++++++++++--------------------
> > > > > > >  1 file changed, 13 insertions(+), 20 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > > > > > index 16e39f3ab956..3611b7537932 100644
> > > > > > > --- a/drivers/vhost/net.c
> > > > > > > +++ b/drivers/vhost/net.c
> > > > > > > @@ -765,11 +765,11 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > > > >       int err;
> > > > > > >       int sent_pkts = 0;
> > > > > > >       bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
> > > > > > > -     bool busyloop_intr;
> > > > > > >       bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > > > > > >
> > > > > > >       do {
> > > > > > > -             busyloop_intr = false;
> > > > > > > +             bool busyloop_intr = false;
> > > > > > > +
> > > > > > >               if (nvq->done_idx == VHOST_NET_BATCH)
> > > > > > >                       vhost_tx_batch(net, nvq, sock, &msg);
> > > > > > >
> > > > > > > @@ -780,10 +780,18 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > > > >                       break;
> > > > > > >               /* Nothing new?  Wait for eventfd to tell us they refilled. */
> > > > > > >               if (head == vq->num) {
> > > > > > > -                     /* Kicks are disabled at this point, break loop and
> > > > > > > -                      * process any remaining batched packets. Queue will
> > > > > > > -                      * be re-enabled afterwards.
> > > > > > > +                     /* Flush batched packets before enabling
> > > > > > > +                      * virqtueue notification to reduce
> > > > > > > +                      * unnecssary virtqueue kicks.
> > > > > > >                        */
> > > > > > > +                     vhost_tx_batch(net, nvq, sock, &msg);
> > > > > >
> > > > > > So why don't we do this in the "else" branch"? If we are busy polling
> > > > > > then we are not enabling kicks, so is there a reason to flush?
> > > > >
> > > > > It should be functional equivalent:
> > > > >
> > > > > do {
> > > > >     if (head == vq->num) {
> > > > >         vhost_tx_batch();
> > > > >         if (unlikely(busyloop_intr)) {
> > > > >             vhost_poll_queue()
> > > > >         } else if () {
> > > > >             vhost_disable_notify(&net->dev, vq);
> > > > >             continue;
> > > > >         }
> > > > >         return;
> > > > > }
> > > > >
> > > > > vs
> > > > >
> > > > > do {
> > > > >     if (head == vq->num) {
> > > > >         if (unlikely(busyloop_intr)) {
> > > > >             vhost_poll_queue()
> > > > >         } else if () {
> > > > >             vhost_tx_batch();
> > > > >             vhost_disable_notify(&net->dev, vq);
> > > > >             continue;
> > > > >         }
> > > > >         break;
> > > > > }
> > > > >
> > > > > vhost_tx_batch();
> > > > > return;
> > > > >
> > > > > Thanks
> > > > >
> > > >
> > > > But this is not what the code comment says:
> > > >
> > > >                      /* Flush batched packets before enabling
> > > >                       * virqtueue notification to reduce
> > > >                       * unnecssary virtqueue kicks.
> > > >
> > > >
> > > > So I ask - of we queued more polling, why do we need
> > > > to flush batched packets? We might get more in the next
> > > > polling round, this is what polling is designed to do.
> > >
> > > The reason is there could be a rx work when busyloop_intr is true, so
> > > we need to flush.
> > >
> > > Thanks
> >
> > Then you need to update the comment to explain.
> > Want to post your version of this patchset?
> 
> I'm fine if you wish. Just want to make sure, do you prefer a patch
> for your vhost tree or net?
> 
> For net, I would stick to 2 patches as if we go for 3, the last patch
> that brings back flush looks more like an optimization.

Jason it does not matter how it looks. We do not need to sneak in
features - if the right thing is to add patch 3 in net then
it is, just add an explanation why in the cover letter.
And if it is not then it is not and squashing it with a revert
is not a good idea.

> For vhost, I can go with 3 patches, but I see that your series has been queued.
>
> And the build of the current vhost tree is broken by:
> 
> commit 41bafbdcd27bf5ce8cd866a9b68daeb28f3ef12b (HEAD)
> Author: Michael S. Tsirkin <mst@redhat.com>
> Date:   Mon Sep 15 10:47:03 2025 +0800
> 
>     vhost-net: flush batched before enabling notifications
> 
> It looks like it misses a brace.
> 
> Thanks

Ugh forgot to commit :(
I guess this is what happens when one tries to code past midnight.
Dropped now pls do proceed.

> >
> >
> > > >
> > > >
> > > > >
> > > > > >
> > > > > >
> > > > > > > +                     if (unlikely(busyloop_intr)) {
> > > > > > > +                             vhost_poll_queue(&vq->poll);
> > > > > > > +                     } else if (unlikely(vhost_enable_notify(&net->dev,
> > > > > > > +                                                             vq))) {
> > > > > > > +                             vhost_disable_notify(&net->dev, vq);
> > > > > > > +                             continue;
> > > > > > > +                     }
> > > > > > >                       break;
> > > > > > >               }
> > > > > > >
> > > > > > > @@ -839,22 +847,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > > > >               ++nvq->done_idx;
> > > > > > >       } while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
> > > > > > >
> > > > > > > -     /* Kicks are still disabled, dispatch any remaining batched msgs. */
> > > > > > >       vhost_tx_batch(net, nvq, sock, &msg);
> > > > > > > -
> > > > > > > -     if (unlikely(busyloop_intr))
> > > > > > > -             /* If interrupted while doing busy polling, requeue the
> > > > > > > -              * handler to be fair handle_rx as well as other tasks
> > > > > > > -              * waiting on cpu.
> > > > > > > -              */
> > > > > > > -             vhost_poll_queue(&vq->poll);
> > > > > > > -     else
> > > > > > > -             /* All of our work has been completed; however, before
> > > > > > > -              * leaving the TX handler, do one last check for work,
> > > > > > > -              * and requeue handler if necessary. If there is no work,
> > > > > > > -              * queue will be reenabled.
> > > > > > > -              */
> > > > > > > -             vhost_net_busy_poll_try_queue(net, vq);
> > > > > > >  }
> > > > > > >
> > > > > > >  static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> > > > > > > --
> > > > > > > 2.34.1
> > > > > >
> > > >
> >


