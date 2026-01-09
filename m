Return-Path: <kvm+bounces-67521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8935D0750F
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 07:05:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0FF53301622B
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 06:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C995C2C3251;
	Fri,  9 Jan 2026 06:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwqthPnw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dPRg9Jen"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41D529BDAA
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 06:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767938667; cv=none; b=eW6u7NbkaDNzAnIHP4MQcm15N9gusSK8csgGK7vP6P8QrRBf5Zycw/LJ79eLSluOxU0csRS61IY/a3qRDcOFIlIA6hvNrdcnWcEAXkrwpaGrq8eOzYR7Bc6+LTOS6ODiljyfWzo1Ey8MvkO6TTvlQFWwnC3bI5yJrwjPcFlMTmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767938667; c=relaxed/simple;
	bh=K/AQAxHPYO+xESgKb7dsvzgDxLsXGlauHRN5QI/r2ho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q3aNATat8wjAmc1mpDzoHLZ2+69c7N1pAx6rrO/DZS+unDu1PfeF062A5mdSy8/qeHfUMRTqKcvf03TG998CCw1LjVODkfwleRghy52hMaakK/TCKkg3SwD7L+YoBPj8gWVmjKOW0EyJqfltPs7wmKUwt5StgKKVOAoCfzyRQaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwqthPnw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dPRg9Jen; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767938664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9euP3q0+K8AwZBKxdvyTpCOtWvHbXFyeoGTxktHAEbg=;
	b=fwqthPnwHi2+hjtbGWUaeuq58wH6MTq6wOjgw0KL6vnsAvVLEXV/s/5Jrv19sj+8ZoE1vJ
	W0HUMl5MujtjkzgPtiM1syC1umAWCgV5Vf5cYNNBB+0B0CmWybDlytr7Or1yPwVKZ7yqie
	WNO5BC9EJLztbMuX4H2Jg0awi83RUYQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-gr9fIyEhPySJqnR4lo1Xbg-1; Fri, 09 Jan 2026 01:04:21 -0500
X-MC-Unique: gr9fIyEhPySJqnR4lo1Xbg-1
X-Mimecast-MFC-AGG-ID: gr9fIyEhPySJqnR4lo1Xbg_1767938660
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-81d9b88caf2so680869b3a.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 22:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767938660; x=1768543460; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9euP3q0+K8AwZBKxdvyTpCOtWvHbXFyeoGTxktHAEbg=;
        b=dPRg9JenN6Uxp6O4/YErgfojUsxIsL7FeYv9Zj7zB6OXCTco4p4vpAA5Des8rZ/rYA
         liCm/haF+mwAkUaqaDS4co+GIVyEOPgn51Ub2KeiieKPN+ryFeyOra/2uwuB4NE6QMVC
         Drm8MI7OUVa4dsByl1tc14GQBRJfMpzpKntT/S6WhZnwvES3dLwhbGJ7Rd8x8HnEQL1r
         tAcVRTs2+NnJlq6azc+Rt9g4fLv2K3tjnXqX+vtZMzkBjbAYSZ6UHfaWSY5VrVmXUH8l
         mCV5VG/RfofKxvox0pkYPlQRoB8C7CqsID/le+T/jeKDTVakwI0+OLNxUHZXbpG084xh
         mMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767938660; x=1768543460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9euP3q0+K8AwZBKxdvyTpCOtWvHbXFyeoGTxktHAEbg=;
        b=R/HI6p4dz/n1jeWo1R1SIUcuCcwXoO9DsygPQTgmZLyqmr09BWrGz8rSAVEfFVWMBf
         OdgDjvF0uU+NZ8n+sr5yEXyI1RuQbp4t0x7G0RPr8c4iYegAlay7RifyPEgffVe/VaHt
         ZCx07Lzb8FKB5BoROusqTcisNPMQ22g56JO5XdZvZz32UYArl4e7WWGBsQVA5G+CTbpx
         +A/ZReniUhl1n2NkDWElOYhRNeDZhCJiq83brzs2JylzCJIK7MczuBb9wpzFl/kK9fP8
         uP4HEf9pNQQuFXYARwPZFvENH/3EbQdRQw5P2X6TLC2HsHkshYdFaoCA9gTYeAL79GY9
         7UJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUsffSxYeK5gKpJbQbyCd66GW/6DXWmDaGXHEbq4a3h3aX6uOCYSdGRtijN29yNzSTvL0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyaaiPhGvzC7T2n8aS1zRkPR1k4/+tprSbXOeNyS6EB2is1p/J
	/gAvSL1HuufLRNKTF5giMH9K68yLlMn6/eUwbe+dFQ0+ayKquF2GugQuSvc9AejZcVolEIwzjG2
	zcqOYCmYkyZflJNp7r9oWTXW8CJ/lan3EXSz1yu+INBvA9pLpzlTxZzFdVyiparRSAlfFLbDuCx
	3STMG5VixQEHMww8szot9s5/On2K7J
X-Gm-Gg: AY/fxX5xn+GMBGQBFOTZjd8RB7k09lIfP7ah0sTWqeNbiwqc8WAPbFCAaipQ2Huu7ef
	MUTbK+DHNdcf1pB0fENwmijQWEUdzMo/o8nR7tihKpdMF4hLfdzsLQI+piRnz3ZN/CMKm2DTHLS
	dOVgZxyEvWb6Z5VuClvCzXOrBVCoc7SNKgTGuZWfsnqOQkIf2qTde1YKanNjEAe9E=
X-Received: by 2002:a05:6a20:3d0e:b0:37e:4319:d7c9 with SMTP id adf61e73a8af0-3898fa56a3amr8187081637.77.1767938660190;
        Thu, 08 Jan 2026 22:04:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHks8HlK8qz7tOXnNtDUBht+V9M/gKJPD9ctTiTc2gpfN67WzvNH4nzU7jF/ixjfYRwtv/VDNE2iyuLZO3PQg=
X-Received: by 2002:a05:6a20:3d0e:b0:37e:4319:d7c9 with SMTP id
 adf61e73a8af0-3898fa56a3amr8187060637.77.1767938659753; Thu, 08 Jan 2026
 22:04:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-8-simon.schippers@tu-dortmund.de> <CACGkMEtndGm+GX+3Kn5AWTkEc+PK0Fo1=VSZzhgBQoYRQbicQw@mail.gmail.com>
 <5961e982-9c52-4e7a-b1ca-caaf4c4d0291@tu-dortmund.de>
In-Reply-To: <5961e982-9c52-4e7a-b1ca-caaf4c4d0291@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 9 Jan 2026 14:04:08 +0800
X-Gm-Features: AQt7F2rgadpgQhtK4XQcquScTSmPGhMX0nFO2ljkD4pebbVz-Sl7My5aAmLeFXY
Message-ID: <CACGkMEsKFcsumyNU6vVgBE4LjYWNb2XQNaThwd9H5eZ+RjSwfQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 7/9] vhost-net: vhost-net: replace rx_ring
 with tun/tap ring wrappers
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mst@redhat.com, eperezma@redhat.com, leiyang@redhat.com, 
	stephen@networkplumber.org, jon@nutanix.com, tim.gebauer@tu-dortmund.de, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 3:48=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 1/8/26 05:38, Jason Wang wrote:
> > On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> Replace the direct use of ptr_ring in the vhost-net virtqueue with
> >> tun/tap ring wrapper helpers. Instead of storing an rx_ring pointer,
> >> the virtqueue now stores the interface type (IF_TUN, IF_TAP, or IF_NON=
E)
> >> and dispatches to the corresponding tun/tap helpers for ring
> >> produce, consume, and unconsume operations.
> >>
> >> Routing ring operations through the tun/tap helpers enables netdev
> >> queue wakeups, which are required for upcoming netdev queue flow
> >> control support shared by tun/tap and vhost-net.
> >>
> >> No functional change is intended beyond switching to the wrapper
> >> helpers.
> >>
> >> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Co-developed by: Jon Kohler <jon@nutanix.com>
> >> Signed-off-by: Jon Kohler <jon@nutanix.com>
> >> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >> ---
> >>  drivers/vhost/net.c | 92 +++++++++++++++++++++++++++++---------------=
-
> >>  1 file changed, 60 insertions(+), 32 deletions(-)
> >>
> >> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >> index 7f886d3dba7d..215556f7cd40 100644
> >> --- a/drivers/vhost/net.c
> >> +++ b/drivers/vhost/net.c
> >> @@ -90,6 +90,12 @@ enum {
> >>         VHOST_NET_VQ_MAX =3D 2,
> >>  };
> >>
> >> +enum if_type {
> >> +       IF_NONE =3D 0,
> >> +       IF_TUN =3D 1,
> >> +       IF_TAP =3D 2,
> >> +};
> >
> > This looks not elegant, can we simply export objects we want to use to
> > vhost like get_tap_socket()?
>
> No, we cannot do that. We would need access to both the ptr_ring and the
> net_device. However, the net_device is protected by an RCU lock.
>
> That is why {tun,tap}_ring_consume_batched() are used:
> they take the appropriate locks and handle waking the queue.

How about introducing a callback in the ptr_ring itself, so vhost_net
only need to know about the ptr_ring?

Thanks

>
> >
> > Thanks
> >
>


