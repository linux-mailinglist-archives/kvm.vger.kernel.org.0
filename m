Return-Path: <kvm+bounces-67689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4232ED10647
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 03:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B103430388B6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 02:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8899303CB6;
	Mon, 12 Jan 2026 02:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MGsjwKtK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gH7TZSqp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6464C306483
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 02:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768186472; cv=none; b=g6XwL7oZZybQzeLCSHL7a3FWjtgWRrmGlxrqopY4MBJnGfXMO8JO5xLpguk7f68kGOcsK7h6I+hfoIXw08wrme3Ucp412k6zEQ1/v8wwvj2zbk/YCpUeNqF99IxnskAf7fKr5BtiZUYSRXKHLrP4DwI2iu6G1Bn7mD1knvJyS4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768186472; c=relaxed/simple;
	bh=zGRMpYKy7NCfokFDjEXNjbo5Ew8CX3dBTGlMCpqTu7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OdfVBn8Y56GpTuY0bTyjJmjgxzVLSA5RGuNohSPCKL9NIlgnzVHDgGcL31CrJLAlVFYod5ZM6Rjkt/Fn9akI5+wRyh3eIWNV3lz9BmeJQR53JHQMrcAL6ftIOPJwKgFfK+8+hqoEZkgsuVDHJ3uQyR7PIhFT8DHd4xYTCYGGfnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MGsjwKtK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gH7TZSqp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768186469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDyfAYjuPwMDl+ZxFK0vKOD/U0p/YZ18QWUvbiOWh/A=;
	b=MGsjwKtKBawJUjWaNS9NC7eo9r1Y2HGxSgSGpCB6uSaXM8t/JPiAOd7TA5tKgXEbIuP9Oz
	lSDoCfXdqATO9QIfLiK3FoQxFL0tOOrtpUAEjrerMP9ebs6hVCf3zcX+IpBC88gqtFvKGb
	s6ITKpnJJc5KnUc35pIgL+Yen+vcaDI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-3c_4th1wNNCL6RbEJDbmaw-1; Sun, 11 Jan 2026 21:54:28 -0500
X-MC-Unique: 3c_4th1wNNCL6RbEJDbmaw-1
X-Mimecast-MFC-AGG-ID: 3c_4th1wNNCL6RbEJDbmaw_1768186467
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c48a76e75so6378619a91.1
        for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 18:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768186467; x=1768791267; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sDyfAYjuPwMDl+ZxFK0vKOD/U0p/YZ18QWUvbiOWh/A=;
        b=gH7TZSqpxdAhEekq8twuVKP2gG6cHZzkqCJaXVDLoSEZSTUMZcu5geKD7YBemmXEKd
         sKPmgvh6QEbnoKyZIgc+Pnj0R91T9FJGOyRtqIyV1zJBHRgrkRzvMy9YyFIlUdWohl3g
         /Z0vHEQNOeTyG9sEG4jDZ7az6p/4Qx8qzJ8dtZOKSgyC6yyQlYLP+RE+D2artEK/5ZQ2
         /7WuvOv4zT1Kq4hfNCrjTZPZWwvBJdTur9CZrfLH99Dtjy7vCjNbHkg/SQ05ZWTeKAUE
         TwhJML+rc3yk6yT53dzD+iYA9D7WcIKSd87ctYBgUqqi2qv0w+LunCFnoTmqZB/3XIPu
         P+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768186467; x=1768791267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sDyfAYjuPwMDl+ZxFK0vKOD/U0p/YZ18QWUvbiOWh/A=;
        b=AahHXrLyWAh6Cfp/9Y9tm4jzAUvkzkjr5p0ggsV/GxU6jOt8pWJLf6U7S7e+zh7ffw
         GHEvWsHzfgtp7eOPURtcyel+5GTl0jxPrF3VbD9ZN/kWXpBr7mp12VT/H/LznvXynj2p
         ZUOLcqBd4txLwUUtRR2h/eLwWlmt3LGa/hH05G1CG7UA8TJ8B89h9cOMly5y0+wG31bv
         7YI06K0JiwnTKRDPjbVhyf2Zmf4vuLzPNBxA5Tm7PTfxvkQwa01dQ6spAOo20jhl05yo
         Y+EiaSYWJqpi7floHurm6vkw+YnSAxSqkUJveNgylGSVe8HKgVmMEV0/e29AEWgnOe30
         ZjLw==
X-Forwarded-Encrypted: i=1; AJvYcCWsuaj/4r5+u3o7QANWErfUFgNyqNlHz+KHOsSwaUhnZIHGzI766dnHPQrJz9C15r7T+6M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIPf5rljZukU8qs55OU13xSLmWIrC3AcgyOwAHuk+IZOWmz+Kv
	yS7TVJLOnO2R8iZ2Z+KHhF3gUsbQkYAdWl2ak22GUjMDFsedtTtx+hEREm7euvzQwRqx5ewwZQr
	xIUcWUA92BPgSclV/qkHC12fR34/JY6HiN7rjIfT87AuFiFHssA7fCd5B2RKq1Rnk0JjbbG1Ntu
	uOrvaB6C+9yII3q4xkYMGpueyYsExZQsAbGygAypQ=
X-Gm-Gg: AY/fxX72E68q5ZPtrmEHfl/CzOms5mUBD4ix27XZqiFhwAK/1XJE4WzbanagzpSux0j
	YLKwaiM+IGCRqdmk0t0fWx1IL8GHAEUVfJ8qLDvkzLJSTRPcyghDbzO70xvzKi5kvpI0QpvAtqO
	Yp5lF+SkLCbJh2HFlDcmLtlXckqJ6eOAX7QfXfvoObUMX1O5REtpl4nAvUpabK2phlYsA=
X-Received: by 2002:a17:90b:578f:b0:34f:6312:f22c with SMTP id 98e67ed59e1d1-34f68aed27bmr14111545a91.0.1768186466686;
        Sun, 11 Jan 2026 18:54:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHGXzUyZmp1tWX++x0G65O3OR3ED7oEjlI25F4JANfILTteUWkwPCmSotiUwilA3S2tZsCRJQcG1meJ8mKehq8=
X-Received: by 2002:a17:90b:578f:b0:34f:6312:f22c with SMTP id
 98e67ed59e1d1-34f68aed27bmr14111529a91.0.1768186466287; Sun, 11 Jan 2026
 18:54:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-8-simon.schippers@tu-dortmund.de> <CACGkMEtndGm+GX+3Kn5AWTkEc+PK0Fo1=VSZzhgBQoYRQbicQw@mail.gmail.com>
 <5961e982-9c52-4e7a-b1ca-caaf4c4d0291@tu-dortmund.de> <CACGkMEsKFcsumyNU6vVgBE4LjYWNb2XQNaThwd9H5eZ+RjSwfQ@mail.gmail.com>
 <0ae9071b-6d76-4336-8aee-d0338eecc6f5@tu-dortmund.de>
In-Reply-To: <0ae9071b-6d76-4336-8aee-d0338eecc6f5@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 12 Jan 2026 10:54:15 +0800
X-Gm-Features: AZwV_QiDbqKshtfzYu2XaNQcD4zIgEOkEtzvAYmkzLCTpPxpz5hLy6ho4yA73K0
Message-ID: <CACGkMEsC0-d4oS54BHNdFVKS+74P7SdnNHPHe_d0pmo-_86ipg@mail.gmail.com>
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

On Fri, Jan 9, 2026 at 5:57=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 1/9/26 07:04, Jason Wang wrote:
> > On Thu, Jan 8, 2026 at 3:48=E2=80=AFPM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> On 1/8/26 05:38, Jason Wang wrote:
> >>> On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> >>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>
> >>>> Replace the direct use of ptr_ring in the vhost-net virtqueue with
> >>>> tun/tap ring wrapper helpers. Instead of storing an rx_ring pointer,
> >>>> the virtqueue now stores the interface type (IF_TUN, IF_TAP, or IF_N=
ONE)
> >>>> and dispatches to the corresponding tun/tap helpers for ring
> >>>> produce, consume, and unconsume operations.
> >>>>
> >>>> Routing ring operations through the tun/tap helpers enables netdev
> >>>> queue wakeups, which are required for upcoming netdev queue flow
> >>>> control support shared by tun/tap and vhost-net.
> >>>>
> >>>> No functional change is intended beyond switching to the wrapper
> >>>> helpers.
> >>>>
> >>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>> Co-developed by: Jon Kohler <jon@nutanix.com>
> >>>> Signed-off-by: Jon Kohler <jon@nutanix.com>
> >>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >>>> ---
> >>>>  drivers/vhost/net.c | 92 +++++++++++++++++++++++++++++-------------=
---
> >>>>  1 file changed, 60 insertions(+), 32 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >>>> index 7f886d3dba7d..215556f7cd40 100644
> >>>> --- a/drivers/vhost/net.c
> >>>> +++ b/drivers/vhost/net.c
> >>>> @@ -90,6 +90,12 @@ enum {
> >>>>         VHOST_NET_VQ_MAX =3D 2,
> >>>>  };
> >>>>
> >>>> +enum if_type {
> >>>> +       IF_NONE =3D 0,
> >>>> +       IF_TUN =3D 1,
> >>>> +       IF_TAP =3D 2,
> >>>> +};
> >>>
> >>> This looks not elegant, can we simply export objects we want to use t=
o
> >>> vhost like get_tap_socket()?
> >>
> >> No, we cannot do that. We would need access to both the ptr_ring and t=
he
> >> net_device. However, the net_device is protected by an RCU lock.
> >>
> >> That is why {tun,tap}_ring_consume_batched() are used:
> >> they take the appropriate locks and handle waking the queue.
> >
> > How about introducing a callback in the ptr_ring itself, so vhost_net
> > only need to know about the ptr_ring?
>
> That would be great, but I'm not sure whether this should be the
> responsibility of the ptr_ring.
>
> If the ptr_ring were to keep track of the netdev queue, it could handle
> all the management itself - stopping the queue when full and waking it
> again once space becomes available.
>
> What would be your idea for implementing this?

During ptr_ring_init() register a callback, the callback will be
trigger during ptr_ring_consume() or ptr_ring_consume_batched() when
ptr_ring find there's a space for ptr_ring_produce().

Thanks

>
> >
> > Thanks
> >
> >>
> >>>
> >>> Thanks
> >>>
> >>
> >
>


