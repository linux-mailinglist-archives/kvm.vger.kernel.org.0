Return-Path: <kvm+bounces-57681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4360EB58ECA
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:08:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF120522325
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465102E54A0;
	Tue, 16 Sep 2025 07:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGsWqvTQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05DC2E11B0
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 07:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758006485; cv=none; b=NIRxL+tCH5X9ylHUSrlH/6JJtReUAJI01neAwTjZjvWQtdLkJc9pPDtXyMTAny3F+we08z35tkhXKLd/rGWUjg8x6JMkKxL4dHH0oHs1SX0w5+7+bF6r9obccNPksB3AA41YhjD+Wt9TU/WW9mCKco3W40JhWcZ1DYx9YnTq1t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758006485; c=relaxed/simple;
	bh=yQKLpG7rL3c3VSnaKMz320BDbIw/zC1Hrox8B/emiEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvDee2IemakFUds2G11qt7qO2TB9WGbNRmuI2QFn4x2wii0EiDNIzxVw/xF/rtpwjSefSuGp6WoldmV3qGXJInqSzWchnfAxjGNNuoxC5/sANd1TabQS+sjUhjt1zaqToB/5IVImhFxb1yjW9tvVXYOQD0H1R/e16gOii0eFm4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGsWqvTQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758006482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mHDgI0DNgcZtkaITzjCOU1skgj0FzLZyOLaS/H3q/YM=;
	b=KGsWqvTQfGV3F/ynLysEAnAjdv1ogw1rljOtmTeg4YmLFNDQ1ZLIOArQ+zpRKqz8txqlLO
	m/hor7LRqBYKCnOxQ2wZ/JIInrUTC0m0zi6xkTmXpcahvtE6N697GDAvijJdFPld5+uVpk
	n35kVygI3MtRHPe846aNhTtaLiyOuNA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-5qJvMcZ2OPSp-mXNpTWtMw-1; Tue, 16 Sep 2025 03:08:00 -0400
X-MC-Unique: 5qJvMcZ2OPSp-mXNpTWtMw-1
X-Mimecast-MFC-AGG-ID: 5qJvMcZ2OPSp-mXNpTWtMw_1758006479
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aff0df4c4abso684072066b.1
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758006479; x=1758611279;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mHDgI0DNgcZtkaITzjCOU1skgj0FzLZyOLaS/H3q/YM=;
        b=Zq4PKXjg+0invvM2IKEjrX2PrDEDeM9k23brK76S1mx+nsHkwSZdTPCZ6vtPUKfp7j
         KebKzPLtPb5jmZizYOUR66J8kXZrOHnV4vAiYH3PPwNQCP695Tf3y8EJhOP+WOUHQEbX
         EgdEFJlMPACoFVvG4cKBBZcAXCRFdieITEwsPnll2QhYxiye5ewk7dcrnGKQKhxyaog3
         TyJyC9UwsGmpRohXq/on5TAcoHZPg3o7q4F2kTMMoRSBzIgnlLX9xgUlRUXYhKRKUDbT
         sTuMtB7I7jF+hO17UlGosCPLUbNJqE5g+2ycg5676RpMTkA/6UuqZQwzGk0KkeisaokC
         h+yQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjLOGWC/ZufRzsJ6RzpL7DnyobCW8wC71SdcwU4qoZ94jws5aMz6DKI/bmOlJgy/OiF3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YySYDzT2LzW4Enc6GoGSLNajMSW54RMUiJPBp4d1vCZdKMd/umJ
	RIFIoeHuu9qChOiNZ9o+tifFu9fG4JQlfuMAdCsqPgSJHl3X4td1/NaUelqoFsZ2gcafXMFK4oK
	YnMWhlJW5GG8GY/xS6r4ptCgRNUSPBngWBPOTvcLsI8IPisV50AT4MA==
X-Gm-Gg: ASbGnctPs9beAYZX9nx1dXR4jqiuOkfMzu9N39wZfnj0SHCB5Y8Qv9cKZVUzp5p8uia
	OS35V3ElNoydDduC6BYbDkIQG+sr8NnBUlCWiNU4jWE2qvKU+V1zvGsUGW6Xn8kqhK2FfQIB35h
	NjfwzyH3A4TfoZZi3d0gJ+Vu1hdnOJYEOmWTvMWfQp/YPh7Iqpar+34DmKYh+Jzb6zGx6B8OIkd
	EpBVg+LyVSxhvN0PjyXoYq6q2XqE41tVokvcsk66WFupwMe8WXdumi5qXAZEbLHMr4RzVjYz1O2
	UTgs4j3oF7OIGNW5hXyR1FcVWU9F
X-Received: by 2002:a17:906:478c:b0:b04:2533:e8dd with SMTP id a640c23a62f3a-b07c3a8c7a9mr1512270566b.60.1758006479202;
        Tue, 16 Sep 2025 00:07:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgIdN7vt4rVLkFQKCbA4fzr7ooEwlspblCquvU3nA4jyYYJdxii6DXBn74W0DSzmPxUER9Fg==
X-Received: by 2002:a17:906:478c:b0:b04:2533:e8dd with SMTP id a640c23a62f3a-b07c3a8c7a9mr1512266566b.60.1758006478595;
        Tue, 16 Sep 2025 00:07:58 -0700 (PDT)
Received: from redhat.com ([31.187.78.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b32f22b1sm1106591366b.86.2025.09.16.00.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 00:07:57 -0700 (PDT)
Date: Tue, 16 Sep 2025 03:07:55 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eperezma@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org,
	jon@nutanix.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Message-ID: <20250916030549-mutt-send-email-mst@kernel.org>
References: <20250912082658.2262-1-jasowang@redhat.com>
 <20250912082658.2262-2-jasowang@redhat.com>
 <20250915120210-mutt-send-email-mst@kernel.org>
 <CACGkMEufUAL1tBrfZVMQCEBmBZ=Z+aPqUtP=RzOQhjtG9jn7UA@mail.gmail.com>
 <20250916011733-mutt-send-email-mst@kernel.org>
 <CACGkMEu_p-ouLbEq26vMTJmeGs1hw5JHOk1qLt8mLLPOMLDbaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEu_p-ouLbEq26vMTJmeGs1hw5JHOk1qLt8mLLPOMLDbaQ@mail.gmail.com>

On Tue, Sep 16, 2025 at 02:24:22PM +0800, Jason Wang wrote:
> On Tue, Sep 16, 2025 at 1:19 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Sep 16, 2025 at 10:37:35AM +0800, Jason Wang wrote:
> > > On Tue, Sep 16, 2025 at 12:03 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Fri, Sep 12, 2025 at 04:26:58PM +0800, Jason Wang wrote:
> > > > > Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
> > > > > sendmsg") tries to defer the notification enabling by moving the logic
> > > > > out of the loop after the vhost_tx_batch() when nothing new is
> > > > > spotted. This will bring side effects as the new logic would be reused
> > > > > for several other error conditions.
> > > > >
> > > > > One example is the IOTLB: when there's an IOTLB miss, get_tx_bufs()
> > > > > might return -EAGAIN and exit the loop and see there's still available
> > > > > buffers, so it will queue the tx work again until userspace feed the
> > > > > IOTLB entry correctly. This will slowdown the tx processing and may
> > > > > trigger the TX watchdog in the guest.
> > > > >
> > > > > Fixing this by stick the notificaiton enabling logic inside the loop
> > > > > when nothing new is spotted and flush the batched before.
> > > > >
> > > > > Reported-by: Jon Kohler <jon@nutanix.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
> > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > ---
> > > > >  drivers/vhost/net.c | 33 +++++++++++++--------------------
> > > > >  1 file changed, 13 insertions(+), 20 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > > > index 16e39f3ab956..3611b7537932 100644
> > > > > --- a/drivers/vhost/net.c
> > > > > +++ b/drivers/vhost/net.c
> > > > > @@ -765,11 +765,11 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > >       int err;
> > > > >       int sent_pkts = 0;
> > > > >       bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
> > > > > -     bool busyloop_intr;
> > > > >       bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > > > >
> > > > >       do {
> > > > > -             busyloop_intr = false;
> > > > > +             bool busyloop_intr = false;
> > > > > +
> > > > >               if (nvq->done_idx == VHOST_NET_BATCH)
> > > > >                       vhost_tx_batch(net, nvq, sock, &msg);
> > > > >
> > > > > @@ -780,10 +780,18 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > >                       break;
> > > > >               /* Nothing new?  Wait for eventfd to tell us they refilled. */
> > > > >               if (head == vq->num) {
> > > > > -                     /* Kicks are disabled at this point, break loop and
> > > > > -                      * process any remaining batched packets. Queue will
> > > > > -                      * be re-enabled afterwards.
> > > > > +                     /* Flush batched packets before enabling
> > > > > +                      * virqtueue notification to reduce
> > > > > +                      * unnecssary virtqueue kicks.
> > > > >                        */
> > > > > +                     vhost_tx_batch(net, nvq, sock, &msg);
> > > >
> > > > So why don't we do this in the "else" branch"? If we are busy polling
> > > > then we are not enabling kicks, so is there a reason to flush?
> > >
> > > It should be functional equivalent:
> > >
> > > do {
> > >     if (head == vq->num) {
> > >         vhost_tx_batch();
> > >         if (unlikely(busyloop_intr)) {
> > >             vhost_poll_queue()
> > >         } else if () {
> > >             vhost_disable_notify(&net->dev, vq);
> > >             continue;
> > >         }
> > >         return;
> > > }
> > >
> > > vs
> > >
> > > do {
> > >     if (head == vq->num) {
> > >         if (unlikely(busyloop_intr)) {
> > >             vhost_poll_queue()
> > >         } else if () {
> > >             vhost_tx_batch();
> > >             vhost_disable_notify(&net->dev, vq);
> > >             continue;
> > >         }
> > >         break;
> > > }
> > >
> > > vhost_tx_batch();
> > > return;
> > >
> > > Thanks
> > >
> >
> > But this is not what the code comment says:
> >
> >                      /* Flush batched packets before enabling
> >                       * virqtueue notification to reduce
> >                       * unnecssary virtqueue kicks.
> >
> >
> > So I ask - of we queued more polling, why do we need
> > to flush batched packets? We might get more in the next
> > polling round, this is what polling is designed to do.
> 
> The reason is there could be a rx work when busyloop_intr is true, so
> we need to flush.
> 
> Thanks

Then you need to update the comment to explain.
Want to post your version of this patchset?


> >
> >
> > >
> > > >
> > > >
> > > > > +                     if (unlikely(busyloop_intr)) {
> > > > > +                             vhost_poll_queue(&vq->poll);
> > > > > +                     } else if (unlikely(vhost_enable_notify(&net->dev,
> > > > > +                                                             vq))) {
> > > > > +                             vhost_disable_notify(&net->dev, vq);
> > > > > +                             continue;
> > > > > +                     }
> > > > >                       break;
> > > > >               }
> > > > >
> > > > > @@ -839,22 +847,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > >               ++nvq->done_idx;
> > > > >       } while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
> > > > >
> > > > > -     /* Kicks are still disabled, dispatch any remaining batched msgs. */
> > > > >       vhost_tx_batch(net, nvq, sock, &msg);
> > > > > -
> > > > > -     if (unlikely(busyloop_intr))
> > > > > -             /* If interrupted while doing busy polling, requeue the
> > > > > -              * handler to be fair handle_rx as well as other tasks
> > > > > -              * waiting on cpu.
> > > > > -              */
> > > > > -             vhost_poll_queue(&vq->poll);
> > > > > -     else
> > > > > -             /* All of our work has been completed; however, before
> > > > > -              * leaving the TX handler, do one last check for work,
> > > > > -              * and requeue handler if necessary. If there is no work,
> > > > > -              * queue will be reenabled.
> > > > > -              */
> > > > > -             vhost_net_busy_poll_try_queue(net, vq);
> > > > >  }
> > > > >
> > > > >  static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> > > > > --
> > > > > 2.34.1
> > > >
> >


