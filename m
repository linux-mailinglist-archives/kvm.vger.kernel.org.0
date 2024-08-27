Return-Path: <kvm+bounces-25113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB2D95FECD
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 04:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D112F282D37
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 02:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2BE12B82;
	Tue, 27 Aug 2024 02:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Id1wfntd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD7FD51C
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 02:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724724259; cv=none; b=C+D23qkltzvs8+ehlnQtgc1ABUohdLJuUtxFpY8V4A0Nzg+7HbT295ycsEaC+iZXXHnbZdbE2QgY7M39hpKTCrGGYrQ8Wn+7fAai44Ed7ZnqLPvKYKAYTlz3TAYcxdjDnRVTx+U2uov5yXOAZLZnGpVMHPIZX2Zw1hpf7iMxrbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724724259; c=relaxed/simple;
	bh=swaa5zYl6o+vIR+x0tmOoO5wF06p/pSj7OJ8IiW3bAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HsI3u9x2sB1y3aThxM3mzpYoix+Ag4Tsqo3BcCB80KAb4Ryo5mrZiXpCx97If5ZEc/to0xON/CYiDDDKkKSjmUhb3miJJJikMUNwPY+MWTisLwh915QcEZxo0odtZhIBVSL5pXUJm5jF5HLGmHR6XV9IeiTvqBORWBtWdgTTXno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Id1wfntd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724724256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xm6HzpS7UlYIAXiVXt9nj1Lc28PYtI0g7QjUz7c0dEA=;
	b=Id1wfntdQL6ZyLX1TzBEuv6GGKymnjLMmUoWppcTp8byA4XSSGfWg+rJMCjCZ5eBEL2JCI
	Nt3kud7eq2ZQYE8RFwewQVh5q7BGQnI34gjgkeL8guYqQX+g5WXIai52E4N0Ze/sTqKw0/
	u0vxKglKlJrDfYsp9SzSfc0ELqQ/6zs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-ZxPKR-KOOWmOOnH8lmHKRg-1; Mon, 26 Aug 2024 22:04:15 -0400
X-MC-Unique: ZxPKR-KOOWmOOnH8lmHKRg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2d3c0088813so5084093a91.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 19:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724724254; x=1725329054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xm6HzpS7UlYIAXiVXt9nj1Lc28PYtI0g7QjUz7c0dEA=;
        b=hzorRM/yw+jhT4kH/+TYggAuetuUTW2eCSkQBMv/wVPM+CCl9OZHcLr5g0FBsHxvGL
         dcEIub+d2XrUAzzwjnNIep86g1TwVqvvNZsyKeYBIiOSsxUN48C3NyZ3l2vUEF2Bfswp
         f2OHm8dBK5QqbWT88jk4BYINP9zRXm1GZyKWNc30JQcTBsqb4+oF4aktAvOokgbrbWb6
         8kX9GnifnTbuHlzntEPZpu1X2gkIkx7TPMmGg3QxNpLMb5T0rUDukV/323K7EiaXoovV
         K+2b0fPq8dsxd3jHyIb38FNYKLqSIwEQ2XFUooNM0MxUwYGB2O8wVhGVdOQfkYm38Ow6
         lFsA==
X-Forwarded-Encrypted: i=1; AJvYcCXGo1Ux3wLjghBo7ms336KAnVhAIGg/RBt5jOYYnGYm7iyRkzO/cv8g0GalXS9Cq4cOlec=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSJXnLexRoTh+ElBz+jUadedsRlziAwFRZFbPBWZKgCbOg+9Oz
	RxLYjElNB8+k+FHwB5GAOEnJod7irMXblwznkovQbYB7kXwytv8+AYT4Fr2cywMmDB0WQe5SSJ+
	NiowE1PRoXAuM2pn7idJ3tHgJhEKFPKw0aydfBv8hiHwIt9cASOZUMWG/d3Y5NeBo3JZUCT6/WC
	TkLvh414A12e6S+DTTDvnf17MG
X-Received: by 2002:a17:90b:4a46:b0:2d3:ce76:4af2 with SMTP id 98e67ed59e1d1-2d8258125d5mr1626201a91.18.1724724254158;
        Mon, 26 Aug 2024 19:04:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtAMqps7U0xYEX+Wmp+vbiju0Pr+o74vzRd/75xZsN+NnAH2VQA/vUI9rjXQkYWiSphld5fdo8Pn1F56iVa1c=
X-Received: by 2002:a17:90b:4a46:b0:2d3:ce76:4af2 with SMTP id
 98e67ed59e1d1-2d8258125d5mr1626181a91.18.1724724253585; Mon, 26 Aug 2024
 19:04:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
 <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com> <fd8ad1d9-81a0-4155-abf5-627ef08afa9e@lunn.ch>
 <24dbecec-d114-4150-87df-33dfbacaec54@nvidia.com>
In-Reply-To: <24dbecec-d114-4150-87df-33dfbacaec54@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 27 Aug 2024 10:03:59 +0800
Message-ID: <CACGkMEsKSUs77biUTF14vENM+AfrLUOHMVe4nitd9CQ-obXuCA@mail.gmail.com>
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Carlos Bilbao <cbilbao@digitalocean.com>, mst@redhat.com, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com, 
	sashal@kernel.org, yuehaibing@huawei.com, steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 12:11=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.co=
m> wrote:
>
>
> On 26.08.24 16:24, Andrew Lunn wrote:
> > On Mon, Aug 26, 2024 at 11:06:09AM +0200, Dragos Tatulea wrote:
> >>
> >>
> >> On 23.08.24 18:54, Carlos Bilbao wrote:
> >>> Hello,
> >>>
> >>> I'm debugging my vDPA setup, and when using ioctl to retrieve the
> >>> configuration, I noticed that it's running in half duplex mode:
> >>>
> >>> Configuration data (24 bytes):
> >>>   MAC address: (Mac address)
> >>>   Status: 0x0001
> >>>   Max virtqueue pairs: 8
> >>>   MTU: 1500
> >>>   Speed: 0 Mb
> >>>   Duplex: Half Duplex
> >>>   RSS max key size: 0
> >>>   RSS max indirection table length: 0
> >>>   Supported hash types: 0x00000000
> >>>
> >>> I believe this might be contributing to the underperformance of vDPA.
> >> mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPEE=
D_DUPLEX
> >> feature which reports speed and duplex. You can check the state on the
> >> PF.
> >
> > Then it should probably report DUPLEX_UNKNOWN.
> >
> > The speed of 0 also suggests SPEED_UNKNOWN is not being returned. So
> > this just looks buggy in general.
> >
> The virtio spec doesn't mention what those values should be when
> VIRTIO_NET_F_SPEED_DUPLEX is not supported.
>
> Jason, should vdpa_dev_net_config_fill() initialize the speed/duplex
> fields to SPEED/DUPLEX_UNKNOWN instead of 0?

Spec said

"""
The following two fields, speed and duplex, only exist if
VIRTIO_NET_F_SPEED_DUPLEX is set.
"""

So my understanding is that it is undefined behaviour, and those
fields seems useless before feature negotiation. For safety, it might
be better to initialize them as UNKOWN.

Thanks


>
> Thanks,
> Dragos
>


