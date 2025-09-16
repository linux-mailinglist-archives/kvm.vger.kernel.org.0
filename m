Return-Path: <kvm+bounces-57686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1994CB58F01
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 940477B1D5B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D818F2C1583;
	Tue, 16 Sep 2025 07:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cBotE6hO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357B427FB35
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 07:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758007254; cv=none; b=nqtW5OOMLQycrtkt6ycmF6+Su/UnGTtbVTPlH+1POgLUI1f20tJLnBSwBIjIGiiUH2X2lM2uV+ZY/l3uKDJzqMosLFe6iKFu64R1GXOsmFi+Vsv0fblm78v/VfGNcGn8IvvnvhOUT9mGwufDZrxh3arIuJgW106ZTGjJ8gffxwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758007254; c=relaxed/simple;
	bh=D2PYxksF/dZdIIrgGr9oJIXIyMD6Og9N45pfqzQ7Io8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dqVDCrWFvTTPIoVmrmSjwnmWyPifFMqJB5h6IpzTGSNjgTxIU1DWl2d/iYQRow4mUQLfUBuIpAUcYm7YR7/eda+JFhX1jNvwrbwQpueMt6WTt6vAAvQy8qoDGx22GqHiJcPHGwVRCYO2IGD8S+UuZBfgA8Ge2LIztQcuBOjUSmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cBotE6hO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758007251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q/Nxsdqh36+lmBaZm9CtqQ3jvwS0JIENCmRR3IT8IFg=;
	b=cBotE6hOJNuyUyWkZBtwekLfflJqfGFd/XtUlZlTTXnPMr7b6hqk7GWJ9lChp2bFPKVecH
	0Na2aJBr5tDfoZ/vtNQPwSzf/OwdV9Vkdl59EK1jajm0+Qsf7/L2sEN3PWAqqltkSpdR3a
	u5YBUiQDtDlo0gG2/SWPDfXoaYO4uNc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-1aS5OC-hMCyAo_AuD2EAZg-1; Tue, 16 Sep 2025 03:20:49 -0400
X-MC-Unique: 1aS5OC-hMCyAo_AuD2EAZg-1
X-Mimecast-MFC-AGG-ID: 1aS5OC-hMCyAo_AuD2EAZg_1758007248
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-32e372d0ee6so1853195a91.0
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758007248; x=1758612048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/Nxsdqh36+lmBaZm9CtqQ3jvwS0JIENCmRR3IT8IFg=;
        b=DE4e+2iU4QdsQ1cVr44pBP4IqhxSmSmYj6pVimtEU9w7ge0+9e4b4bmbr5pj/ZSP5d
         W4K0fREQfT4sSh8M0U2hYfuT1CizeqqiyXqlUvvL+3n73pfGjwP0A4PDY2FqIO5bd+Im
         UKpPLEPpxwgAIa3WyVjllnTnTiifflXA+rsYg1/X8v/W15DQCXSTYNadFYJO0YrwnGl5
         e13mvNPCZeEhD/tnlU1A0NvFTy8IHnLpcditJOQs5kBcLzicGByb+Jga3V/yUyNZ++vc
         ttonJpR0pKtiG1ZdwpqT52hOAVoh0ELz3TAHSEqj2xogoRNPG+QGuBeScHPK2qBLn0/G
         zO4w==
X-Forwarded-Encrypted: i=1; AJvYcCXsFdfomR5vpfcWPViU7NLdqgi7RamDuTcxLQLx7RRx6Jm3tVr//6U6pDwKu9ZORkeZuL0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5m5/j6948NCmBpKOEFELKg+Gu8iTrklRsQBOz8rgU07MifNux
	4Vjk2i7FHY2u7xdEdizB89awzgTRqsjotdb2BK6icoXqHlbwln7QVDHaOPzVCJoNKv/V1lLF7z1
	5b3V4bFCBfEIq4kWdFKygmT15ZCVxgptstisp5ztDEieIkuHA3XyhHH6Y/G/qaNJAaoQ9nV2uFk
	BTeyX7AQcKSfT5IGYTDPsnt7WYV3DS
X-Gm-Gg: ASbGncvJ11mr6iI+dmTwsbnRTEpFj2LpYkEBQAS7aEvZY2gcpnHoB2weHb1JzIv0RzZ
	05lsIPxqk0RI5HEltktJvLgDnwZCxWaee0DVEvZn4bNtkP0CmOsEul0by74CQzkYYK77qR1H9Sp
	XWco9qDQtfKTulPvi1LjzZ
X-Received: by 2002:a17:90b:4c43:b0:32b:6cf2:a2cf with SMTP id 98e67ed59e1d1-32de4ecfef6mr18297103a91.14.1758007248411;
        Tue, 16 Sep 2025 00:20:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhF2Kgtp4xrR3HJKlpJRKm798eKMryRKtU0e/2ABrGoXHJxF41jb2NOJdiA0RY3u/G/hSk1zeKHpmSBpMi9yw=
X-Received: by 2002:a17:90b:4c43:b0:32b:6cf2:a2cf with SMTP id
 98e67ed59e1d1-32de4ecfef6mr18297077a91.14.1758007248004; Tue, 16 Sep 2025
 00:20:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912082658.2262-1-jasowang@redhat.com> <20250912082658.2262-2-jasowang@redhat.com>
 <20250915120210-mutt-send-email-mst@kernel.org> <CACGkMEufUAL1tBrfZVMQCEBmBZ=Z+aPqUtP=RzOQhjtG9jn7UA@mail.gmail.com>
 <20250916011733-mutt-send-email-mst@kernel.org> <CACGkMEu_p-ouLbEq26vMTJmeGs1hw5JHOk1qLt8mLLPOMLDbaQ@mail.gmail.com>
 <20250916030549-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250916030549-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 16 Sep 2025 15:20:36 +0800
X-Gm-Features: AS18NWDLd3H-vMtakLEmVtIvlkzOFoFZiZ-WeXmRjS-Z87EyAa_8rPBU-THus9Y
Message-ID: <CACGkMEt2fAkCb_nC4QwR+3Jq+fS8=7bx=T3AEzPP1KGLErbSBA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: eperezma@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org, 
	jon@nutanix.com, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 3:08=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Sep 16, 2025 at 02:24:22PM +0800, Jason Wang wrote:
> > On Tue, Sep 16, 2025 at 1:19=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Tue, Sep 16, 2025 at 10:37:35AM +0800, Jason Wang wrote:
> > > > On Tue, Sep 16, 2025 at 12:03=E2=80=AFAM Michael S. Tsirkin <mst@re=
dhat.com> wrote:
> > > > >
> > > > > On Fri, Sep 12, 2025 at 04:26:58PM +0800, Jason Wang wrote:
> > > > > > Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until=
 after
> > > > > > sendmsg") tries to defer the notification enabling by moving th=
e logic
> > > > > > out of the loop after the vhost_tx_batch() when nothing new is
> > > > > > spotted. This will bring side effects as the new logic would be=
 reused
> > > > > > for several other error conditions.
> > > > > >
> > > > > > One example is the IOTLB: when there's an IOTLB miss, get_tx_bu=
fs()
> > > > > > might return -EAGAIN and exit the loop and see there's still av=
ailable
> > > > > > buffers, so it will queue the tx work again until userspace fee=
d the
> > > > > > IOTLB entry correctly. This will slowdown the tx processing and=
 may
> > > > > > trigger the TX watchdog in the guest.
> > > > > >
> > > > > > Fixing this by stick the notificaiton enabling logic inside the=
 loop
> > > > > > when nothing new is spotted and flush the batched before.
> > > > > >
> > > > > > Reported-by: Jon Kohler <jon@nutanix.com>
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until=
 after sendmsg")
> > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > ---
> > > > > >  drivers/vhost/net.c | 33 +++++++++++++--------------------
> > > > > >  1 file changed, 13 insertions(+), 20 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > > > > index 16e39f3ab956..3611b7537932 100644
> > > > > > --- a/drivers/vhost/net.c
> > > > > > +++ b/drivers/vhost/net.c
> > > > > > @@ -765,11 +765,11 @@ static void handle_tx_copy(struct vhost_n=
et *net, struct socket *sock)
> > > > > >       int err;
> > > > > >       int sent_pkts =3D 0;
> > > > > >       bool sock_can_batch =3D (sock->sk->sk_sndbuf =3D=3D INT_M=
AX);
> > > > > > -     bool busyloop_intr;
> > > > > >       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER=
);
> > > > > >
> > > > > >       do {
> > > > > > -             busyloop_intr =3D false;
> > > > > > +             bool busyloop_intr =3D false;
> > > > > > +
> > > > > >               if (nvq->done_idx =3D=3D VHOST_NET_BATCH)
> > > > > >                       vhost_tx_batch(net, nvq, sock, &msg);
> > > > > >
> > > > > > @@ -780,10 +780,18 @@ static void handle_tx_copy(struct vhost_n=
et *net, struct socket *sock)
> > > > > >                       break;
> > > > > >               /* Nothing new?  Wait for eventfd to tell us they=
 refilled. */
> > > > > >               if (head =3D=3D vq->num) {
> > > > > > -                     /* Kicks are disabled at this point, brea=
k loop and
> > > > > > -                      * process any remaining batched packets.=
 Queue will
> > > > > > -                      * be re-enabled afterwards.
> > > > > > +                     /* Flush batched packets before enabling
> > > > > > +                      * virqtueue notification to reduce
> > > > > > +                      * unnecssary virtqueue kicks.
> > > > > >                        */
> > > > > > +                     vhost_tx_batch(net, nvq, sock, &msg);
> > > > >
> > > > > So why don't we do this in the "else" branch"? If we are busy pol=
ling
> > > > > then we are not enabling kicks, so is there a reason to flush?
> > > >
> > > > It should be functional equivalent:
> > > >
> > > > do {
> > > >     if (head =3D=3D vq->num) {
> > > >         vhost_tx_batch();
> > > >         if (unlikely(busyloop_intr)) {
> > > >             vhost_poll_queue()
> > > >         } else if () {
> > > >             vhost_disable_notify(&net->dev, vq);
> > > >             continue;
> > > >         }
> > > >         return;
> > > > }
> > > >
> > > > vs
> > > >
> > > > do {
> > > >     if (head =3D=3D vq->num) {
> > > >         if (unlikely(busyloop_intr)) {
> > > >             vhost_poll_queue()
> > > >         } else if () {
> > > >             vhost_tx_batch();
> > > >             vhost_disable_notify(&net->dev, vq);
> > > >             continue;
> > > >         }
> > > >         break;
> > > > }
> > > >
> > > > vhost_tx_batch();
> > > > return;
> > > >
> > > > Thanks
> > > >
> > >
> > > But this is not what the code comment says:
> > >
> > >                      /* Flush batched packets before enabling
> > >                       * virqtueue notification to reduce
> > >                       * unnecssary virtqueue kicks.
> > >
> > >
> > > So I ask - of we queued more polling, why do we need
> > > to flush batched packets? We might get more in the next
> > > polling round, this is what polling is designed to do.
> >
> > The reason is there could be a rx work when busyloop_intr is true, so
> > we need to flush.
> >
> > Thanks
>
> Then you need to update the comment to explain.
> Want to post your version of this patchset?

I'm fine if you wish. Just want to make sure, do you prefer a patch
for your vhost tree or net?

For net, I would stick to 2 patches as if we go for 3, the last patch
that brings back flush looks more like an optimization.
For vhost, I can go with 3 patches, but I see that your series has been que=
ued.

And the build of the current vhost tree is broken by:

commit 41bafbdcd27bf5ce8cd866a9b68daeb28f3ef12b (HEAD)
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Mon Sep 15 10:47:03 2025 +0800

    vhost-net: flush batched before enabling notifications

It looks like it misses a brace.

Thanks

>
>
> > >
> > >
> > > >
> > > > >
> > > > >
> > > > > > +                     if (unlikely(busyloop_intr)) {
> > > > > > +                             vhost_poll_queue(&vq->poll);
> > > > > > +                     } else if (unlikely(vhost_enable_notify(&=
net->dev,
> > > > > > +                                                             v=
q))) {
> > > > > > +                             vhost_disable_notify(&net->dev, v=
q);
> > > > > > +                             continue;
> > > > > > +                     }
> > > > > >                       break;
> > > > > >               }
> > > > > >
> > > > > > @@ -839,22 +847,7 @@ static void handle_tx_copy(struct vhost_ne=
t *net, struct socket *sock)
> > > > > >               ++nvq->done_idx;
> > > > > >       } while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, to=
tal_len)));
> > > > > >
> > > > > > -     /* Kicks are still disabled, dispatch any remaining batch=
ed msgs. */
> > > > > >       vhost_tx_batch(net, nvq, sock, &msg);
> > > > > > -
> > > > > > -     if (unlikely(busyloop_intr))
> > > > > > -             /* If interrupted while doing busy polling, reque=
ue the
> > > > > > -              * handler to be fair handle_rx as well as other =
tasks
> > > > > > -              * waiting on cpu.
> > > > > > -              */
> > > > > > -             vhost_poll_queue(&vq->poll);
> > > > > > -     else
> > > > > > -             /* All of our work has been completed; however, b=
efore
> > > > > > -              * leaving the TX handler, do one last check for =
work,
> > > > > > -              * and requeue handler if necessary. If there is =
no work,
> > > > > > -              * queue will be reenabled.
> > > > > > -              */
> > > > > > -             vhost_net_busy_poll_try_queue(net, vq);
> > > > > >  }
> > > > > >
> > > > > >  static void handle_tx_zerocopy(struct vhost_net *net, struct s=
ocket *sock)
> > > > > > --
> > > > > > 2.34.1
> > > > >
> > >
>


