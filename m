Return-Path: <kvm+bounces-57667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D70DB58BE6
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 04:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B93D7B025A
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E8723D298;
	Tue, 16 Sep 2025 02:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A2EvQvMw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823DCD27E
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 02:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757990272; cv=none; b=HB8HyoMURNshgniPyazOIWU2jNr1Wfz2dUjOSd+pl8jX5GgClc17ZrL09TjeTNrG7RcM68gtI17jsroH8D7eQ5U4VgMG4Wf6SvhA+RtNpo3NIGI3ZibgNnmJvWhoAPnHG6gZN0Ju0ktXr4wVe5viJi6MVoc0qz0yDdmdsXhg9fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757990272; c=relaxed/simple;
	bh=gUKy4HbgYm51Znbh/ltm0uWLek9Y6A3xzbjPKF8AM7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iP6So9fVFsq7esPcyWMhAJSEAsAwaa6ePwPWw6lfyeymUspvbWOvSbGUQOd1MA1J3sD9mFk2MFENNeGPUw6/n4o14q/brk01rtoMEs95v5+uK/jzcOeKna9GxCGStCPekM6I2c/aNDWWbzW/CFrCDtXIIM8hReMDvgMPmwsMKNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A2EvQvMw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757990269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XAf0tQ+0pz0qPoEfmgoNOjCObM8zSLJwkzhy+q5XJZY=;
	b=A2EvQvMwo/ySmV8/iYGrUO3unZCZo4uDZndS4TvrIxgTl5FftOnB3O9tO3OYA3D2QH6hwP
	Sv/ScBw+sxIzi/XC1lt/zIdH9EtljWXCBa9FO4sH69xjdkyTVJihU9BN+n/7cKoztoZICD
	G9K6E9MzLeXQjgC9aYQbinKdujKwHts=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-ER_gplkHMnaokNTXKsM4LA-1; Mon, 15 Sep 2025 22:37:47 -0400
X-MC-Unique: ER_gplkHMnaokNTXKsM4LA-1
X-Mimecast-MFC-AGG-ID: ER_gplkHMnaokNTXKsM4LA_1757990267
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-32df93c787fso4957084a91.3
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 19:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757990267; x=1758595067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAf0tQ+0pz0qPoEfmgoNOjCObM8zSLJwkzhy+q5XJZY=;
        b=jkUzcd9A6vB7C2IE/ECAZCYu/tuiHU3iijSdY0ZGrvbCkPHGntupEcNNHCq0PI7/9h
         MRBXPvJnm+wAbAw/ndw59e43u5FpTVTiKxHQ6Q7AisYlxQ3qBMKxpJstpYExjavnK1iy
         Ta+p4cH8OdJPb2wEg71+6mK4HvrwXbdj4RIH8MpH+4GX8lbHRBhUL1oyQ8mIy7GwW/MC
         YTsCeck4/MFk9vL5Yitn45u7diQBz1GmsgxPLkfXXTu4OiiyCO/hJS5TcFSbCH0Alpu/
         Fv+9OfMBhRYuxfuplyO6CLEoc90SMgDK8GHZU7FZu10/3T5Xcd3C9MT9YoWxgTYrpiL5
         pqYw==
X-Forwarded-Encrypted: i=1; AJvYcCWEPY9DdM0I2CwwMjgVNsZd3ZpzXo1oj90+eoNFzrBhzXow7vbdE/a1O2dcyAE88w36zlA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDYCJWxpNWnBnc49tAqaLBWDCvAzgA7FcZYiSOj/ZvOeZD1YyX
	L29tgs9UfIMFzbXD3fAgFF50YwPQBVoaZDKNJ4caWH4eJ4hjC9KC/1EsVLj9S51sV+eDffi41/x
	YcT5Kf7WCJ/CIOElzxTYe6cCf131qquUVGDm/uv0Wuqd1l475gcgI3UfHXMKCCFu86fCq08/8/9
	gh5Kd3z9zPvsud375Qkgasn+j3+yeB
X-Gm-Gg: ASbGncvRjh2Wa1fJvwqHNQRC9imt+H/XEhFYe+I4wLqGJCu+1MPHZMQRxHijExIaCUN
	BoyRTNIB3CTRxhUIauQTOdlPQkJ2Vaqsl3xBKS+NVziKfw7wDIZWXnLNmtPsM6haSyd0Y4RYVJ9
	eoOACPEEDaPS+KUtyD7stg
X-Received: by 2002:a17:90b:4c4b:b0:32e:7512:b680 with SMTP id 98e67ed59e1d1-32e7512b733mr5143749a91.1.1757990266784;
        Mon, 15 Sep 2025 19:37:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHb6D27rOwIabYHDbTeq8O+XXMbNT5JV4s9eACQ1ml/K4xuBJXeSZM1vgjCkw2luMUbq+jomkccwDcI0a/C/DI=
X-Received: by 2002:a17:90b:4c4b:b0:32e:7512:b680 with SMTP id
 98e67ed59e1d1-32e7512b733mr5143719a91.1.1757990266274; Mon, 15 Sep 2025
 19:37:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912082658.2262-1-jasowang@redhat.com> <20250912082658.2262-2-jasowang@redhat.com>
 <20250915120210-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250915120210-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 16 Sep 2025 10:37:35 +0800
X-Gm-Features: Ac12FXwy79u1dZC54rdy_dwlxjFnrMd4oYnP7Kn26CXew35l54L3830n5p1rHL0
Message-ID: <CACGkMEufUAL1tBrfZVMQCEBmBZ=Z+aPqUtP=RzOQhjtG9jn7UA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: eperezma@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org, 
	jon@nutanix.com, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 12:03=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Fri, Sep 12, 2025 at 04:26:58PM +0800, Jason Wang wrote:
> > Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
> > sendmsg") tries to defer the notification enabling by moving the logic
> > out of the loop after the vhost_tx_batch() when nothing new is
> > spotted. This will bring side effects as the new logic would be reused
> > for several other error conditions.
> >
> > One example is the IOTLB: when there's an IOTLB miss, get_tx_bufs()
> > might return -EAGAIN and exit the loop and see there's still available
> > buffers, so it will queue the tx work again until userspace feed the
> > IOTLB entry correctly. This will slowdown the tx processing and may
> > trigger the TX watchdog in the guest.
> >
> > Fixing this by stick the notificaiton enabling logic inside the loop
> > when nothing new is spotted and flush the batched before.
> >
> > Reported-by: Jon Kohler <jon@nutanix.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after s=
endmsg")
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/vhost/net.c | 33 +++++++++++++--------------------
> >  1 file changed, 13 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 16e39f3ab956..3611b7537932 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -765,11 +765,11 @@ static void handle_tx_copy(struct vhost_net *net,=
 struct socket *sock)
> >       int err;
> >       int sent_pkts =3D 0;
> >       bool sock_can_batch =3D (sock->sk->sk_sndbuf =3D=3D INT_MAX);
> > -     bool busyloop_intr;
> >       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> >
> >       do {
> > -             busyloop_intr =3D false;
> > +             bool busyloop_intr =3D false;
> > +
> >               if (nvq->done_idx =3D=3D VHOST_NET_BATCH)
> >                       vhost_tx_batch(net, nvq, sock, &msg);
> >
> > @@ -780,10 +780,18 @@ static void handle_tx_copy(struct vhost_net *net,=
 struct socket *sock)
> >                       break;
> >               /* Nothing new?  Wait for eventfd to tell us they refille=
d. */
> >               if (head =3D=3D vq->num) {
> > -                     /* Kicks are disabled at this point, break loop a=
nd
> > -                      * process any remaining batched packets. Queue w=
ill
> > -                      * be re-enabled afterwards.
> > +                     /* Flush batched packets before enabling
> > +                      * virqtueue notification to reduce
> > +                      * unnecssary virtqueue kicks.
> >                        */
> > +                     vhost_tx_batch(net, nvq, sock, &msg);
>
> So why don't we do this in the "else" branch"? If we are busy polling
> then we are not enabling kicks, so is there a reason to flush?

It should be functional equivalent:

do {
    if (head =3D=3D vq->num) {
        vhost_tx_batch();
        if (unlikely(busyloop_intr)) {
            vhost_poll_queue()
        } else if () {
            vhost_disable_notify(&net->dev, vq);
            continue;
        }
        return;
}

vs

do {
    if (head =3D=3D vq->num) {
        if (unlikely(busyloop_intr)) {
            vhost_poll_queue()
        } else if () {
            vhost_tx_batch();
            vhost_disable_notify(&net->dev, vq);
            continue;
        }
        break;
}

vhost_tx_batch();
return;

Thanks


>
>
> > +                     if (unlikely(busyloop_intr)) {
> > +                             vhost_poll_queue(&vq->poll);
> > +                     } else if (unlikely(vhost_enable_notify(&net->dev=
,
> > +                                                             vq))) {
> > +                             vhost_disable_notify(&net->dev, vq);
> > +                             continue;
> > +                     }
> >                       break;
> >               }
> >
> > @@ -839,22 +847,7 @@ static void handle_tx_copy(struct vhost_net *net, =
struct socket *sock)
> >               ++nvq->done_idx;
> >       } while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)=
));
> >
> > -     /* Kicks are still disabled, dispatch any remaining batched msgs.=
 */
> >       vhost_tx_batch(net, nvq, sock, &msg);
> > -
> > -     if (unlikely(busyloop_intr))
> > -             /* If interrupted while doing busy polling, requeue the
> > -              * handler to be fair handle_rx as well as other tasks
> > -              * waiting on cpu.
> > -              */
> > -             vhost_poll_queue(&vq->poll);
> > -     else
> > -             /* All of our work has been completed; however, before
> > -              * leaving the TX handler, do one last check for work,
> > -              * and requeue handler if necessary. If there is no work,
> > -              * queue will be reenabled.
> > -              */
> > -             vhost_net_busy_poll_try_queue(net, vq);
> >  }
> >
> >  static void handle_tx_zerocopy(struct vhost_net *net, struct socket *s=
ock)
> > --
> > 2.34.1
>


