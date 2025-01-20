Return-Path: <kvm+bounces-35929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 109B5A164B7
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 01:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6382F188524A
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 00:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D41DDC5;
	Mon, 20 Jan 2025 00:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CLHT4FjS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542D22114
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 00:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737333673; cv=none; b=g5G1cRO2DyNIbHTe/G/JbheBuz0WIp1kT8tReP7fNPSeFuwe+4yQn84/mIj9j3kPgevkZjMD3F1f0sqZHki7DML03qvaYZOg1yEYUrDEYen6XQ6RDKi1VByYO7FxW3h9oYuot5tEWZcu+PA3OPqcly5bAhreHlNbG2cho9g73OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737333673; c=relaxed/simple;
	bh=aA1N/FCwEJWzfKwIbQDHaCbEggvd2ib8Yz4yJXSDdJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q+jRlLASl/sK4wfENIFWgDbjo/h24UNtvxvevZchliNSV/Iz0f+EhAZprIgG5yyzakKVJqX0dZGv7vs8wNXxTwCe0A0NyL4K0AokQayHtLo8ssi0CJQbDQqtrGd81s3C5YEfVjpHz3NTZGzrLTEAIU+s4Fkk/UZUMEMoQY3UJQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CLHT4FjS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737333670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QoODFoEJ/D6WHGy7MOEpfhr94tOI/fDa1CVKWtBtZbg=;
	b=CLHT4FjSYf+8qFsXwMyPLWQIGkBTZyDPZkXpFhLSo3zxD33sIJeyPY3yV+IhFDOUCoLXtV
	9BGG7oqCN8JYNSiMrKPlti3v6uJ3W8+xL3d81O9Un9nUQnfDw9X6ULzkW8yyeKbLfVcAHT
	I+r/2zdWaPiJUf26HnU6duDk6oE9k3s=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-1nn6eYUlMPWR9do9VlbWuw-1; Sun, 19 Jan 2025 19:41:08 -0500
X-MC-Unique: 1nn6eYUlMPWR9do9VlbWuw-1
X-Mimecast-MFC-AGG-ID: 1nn6eYUlMPWR9do9VlbWuw
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2ef80d30df1so7227724a91.1
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 16:41:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737333667; x=1737938467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QoODFoEJ/D6WHGy7MOEpfhr94tOI/fDa1CVKWtBtZbg=;
        b=bx8iGxW0N/1I9u4FK8niT8HggAbRq3EYyJAYaLNnw2wc1nKVKb/RAB98a3qC8WRa8V
         Tsl+eLyqIk4eydLhNRiYe2lcJUXXDpIaDkuIKIIErdokDXJwb5kzsNGt0VWsIpBg+wva
         WhTxsN1UBgdfeBvYSY65F4+koBKMfXriKKJeev/uFmVYfAzhjImLeGj60o8DDjummmek
         JJEDomNFs0MjUfXzTvHDgwT8eAhgpVUz5v6p//7mrUPK+G/nSj8mQvHohQ/CrZMC1gjC
         QzLRT1LzIIsFSK0ok7lUf0DbNT5Y07RzRb6uk7tY2o06AouRmRV3AiKQ6vsl8i/PKa0C
         wPBA==
X-Forwarded-Encrypted: i=1; AJvYcCWqlCyN1T/7svadYKU+zaEErhLl3DoJE94PjLOUbKt0cRHU05JXAXRFIrdQicDpN6rIcw4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiPbfoyrV8ZiHnICNTsfX/BquZpsY/KXdMBkIlvpG5zs/Nqkp5
	0sGi4sRUm2kBP8XSb+5qfOnibJDYprW7RsioavK2mHKXLhX0RT7Z3xnqagPz7eOje3UkSDurWd+
	BzpUuYUha9smrVceJ6cUyzcx8iWg+OqqZw8bLhGx7vRHldmBffHkuNwRzT3semKN8HHjbLV7MYh
	NPCbmFdWQtW+8ZhaYCamwRPqhR
X-Gm-Gg: ASbGncuiQulmlOG263OkpVdGQVbBMekaYSDqTRNq/+cWxvzoNDSz0c0Umlu4ef7TATL
	CQAwajxJPtGgh2LjgXMl47ewudc2smqlSMLNdE4naEFgKYeZCn3Xh
X-Received: by 2002:a17:90a:d003:b0:2ee:a04b:92ce with SMTP id 98e67ed59e1d1-2f782d8c844mr13718678a91.32.1737333667420;
        Sun, 19 Jan 2025 16:41:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGvOsgeJvjTzqlxcpcXrDzMSHfJqhVYBVkIV2UaUnhj4GnP64AkNHuirJUh0W/boBZuXQpajGMQJ+ugWEd6ZBA=
X-Received: by 2002:a17:90a:d003:b0:2ee:a04b:92ce with SMTP id
 98e67ed59e1d1-2f782d8c844mr13718637a91.32.1737333666967; Sun, 19 Jan 2025
 16:41:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com> <20250109-tun-v2-3-388d7d5a287a@daynix.com>
 <CACGkMEsm5DCb+n3NYeRjmq3rAANztZz5QmV8rbPNo+cH-=VzDQ@mail.gmail.com>
 <20250110052246-mutt-send-email-mst@kernel.org> <2e015ee6-8a3b-43fb-b119-e1921139c74b@daynix.com>
 <CACGkMEuiyfH-QitiiKJ__-8NiTjoOfc8Nx5BwLM-GOfPpVEitA@mail.gmail.com>
 <fcb301e8-c808-4e20-92dd-2e3b83998d18@daynix.com> <CACGkMEvBU3mLbW+-nOscriR-SeDvPSm1mtwwgznYFOocuao5MQ@mail.gmail.com>
 <cc79bef1-c24e-448d-bc20-f8302e341b2c@daynix.com>
In-Reply-To: <cc79bef1-c24e-448d-bc20-f8302e341b2c@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 20 Jan 2025 08:40:55 +0800
X-Gm-Features: AbW1kvZySvRTtG6CQaeo9DOkWdfLmhPa3wBjyc1FO_e-8MjSnO1jhzJ2Si8rLnw
Message-ID: <CACGkMEsJUb3ZLm3rLuaayDAS4kf-vbY03wL4M9j1K+Z=a4BDig@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] tun: Set num_buffers for virtio 1.0
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, devel@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 1:30=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix=
.com> wrote:
>
> On 2025/01/16 10:06, Jason Wang wrote:
> > On Wed, Jan 15, 2025 at 1:07=E2=80=AFPM Akihiko Odaki <akihiko.odaki@da=
ynix.com> wrote:
> >>
> >> On 2025/01/13 12:04, Jason Wang wrote:
> >>> On Fri, Jan 10, 2025 at 7:12=E2=80=AFPM Akihiko Odaki <akihiko.odaki@=
daynix.com> wrote:
> >>>>
> >>>> On 2025/01/10 19:23, Michael S. Tsirkin wrote:
> >>>>> On Fri, Jan 10, 2025 at 11:27:13AM +0800, Jason Wang wrote:
> >>>>>> On Thu, Jan 9, 2025 at 2:59=E2=80=AFPM Akihiko Odaki <akihiko.odak=
i@daynix.com> wrote:
> >>>>>>>
> >>>>>>> The specification says the device MUST set num_buffers to 1 if
> >>>>>>> VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
> >>>>>>
> >>>>>> Have we agreed on how to fix the spec or not?
> >>>>>>
> >>>>>> As I replied in the spec patch, if we just remove this "MUST", it
> >>>>>> looks like we are all fine?
> >>>>>>
> >>>>>> Thanks
> >>>>>
> >>>>> We should replace MUST with SHOULD but it is not all fine,
> >>>>> ignoring SHOULD is a quality of implementation issue.
> >>>>>
> >>>
> >>> So is this something that the driver should notice?
> >>>
> >>>>
> >>>> Should we really replace it? It would mean that a driver conformant =
with
> >>>> the current specification may not be compatible with a device confor=
mant
> >>>> with the future specification.
> >>>
> >>> I don't get this. We are talking about devices and we want to relax s=
o
> >>> it should compatibile.
> >>
> >>
> >> The problem is:
> >> 1) On the device side, the num_buffers can be left uninitialized due t=
o bugs
> >> 2) On the driver side, the specification allows assuming the num_buffe=
rs
> >> is set to one.
> >>
> >> Relaxing the device requirement will replace "due to bugs" with
> >> "according to the specification" in 1). It still contradicts with 2) s=
o
> >> does not fix compatibility.
> >
> > Just to clarify I meant we can simply remove the following:
> >
> > """
> > The device MUST use only a single descriptor if VIRTIO_NET_F_MRG_RXBUF
> > was not negotiated. Note: This means that num_buffers will always be 1
> > if VIRTIO_NET_F_MRG_RXBUF is not negotiated.
> > """
> >
> > And
> >
> > """
> > If VIRTIO_NET_F_MRG_RXBUF has not been negotiated, the device MUST set
> > num_buffers to 1.
> > """
> >
> > This seems easier as it reflects the fact where some devices don't set
> > it. And it eases the transitional device as it doesn't need to have
> > any special care.
>
> That can potentially break existing drivers that are compliant with the
> current and assumes the num_buffers is set to 1.

Those drivers are already 'broken'. Aren't they?

Thanks

>
> Regards,
> Akihiko Odaki
>
> >
> > Then we don't need any driver normative so I don't see any conflict.
> >
> > Michael suggests we use "SHOULD", but if this is something that the
> > driver needs to be aware of I don't know how "SHOULD" can help a lot
> > or not.
> >
> >>
> >> Instead, we should make the driver requirement stricter to change 2).
> >> That is what "[PATCH v3] virtio-net: Ignore num_buffers when unused" d=
oes:
> >> https://lore.kernel.org/r/20250110-reserved-v3-1-2ade0a5d2090@daynix.c=
om
> >>
> >>>
> >>>>
> >>>> We are going to fix all implementations known to buggy (QEMU and Lin=
ux)
> >>>> anyway so I think it's just fine to leave that part of specification=
 as is.
> >>>
> >>> I don't think we can fix it all.
> >>
> >> It essentially only requires storing 16 bits. There are details we nee=
d
> >> to work out, but it should be possible to fix.
> >
> > I meant it's not realistic to fix all the hypervisors. Note that
> > modern devices have been implemented for about a decade so we may have
> > too many versions of various hypervisors. (E.g DPDK seems to stick
> > with the same behaviour of the current kernel).
>  > >>
> >> Regards,
> >> Akihiko Odaki
> >>
> >
> > Thanks
> >
>


