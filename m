Return-Path: <kvm+bounces-40128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E54A4F6AA
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 06:47:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 378DF16EFB7
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 05:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 311131DB363;
	Wed,  5 Mar 2025 05:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MP4e13DS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802D719408C
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 05:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741153632; cv=none; b=Yl+o5Fo70E5mQhvQ9TA4DWqnt96OhXoC4SGWdTHQKFzhhqjrQ9jbwM9Tzxv2k6jBAkskzoosyFaVbXDes+74bKkpnOkUnrJO3cgcpTvxdPBXylsKvPTySoFimgKeLa9dQQjKy3MjE2r/LH+vxHg24Lj8MZ5ll7LZhOkZ8hIJknE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741153632; c=relaxed/simple;
	bh=Yr2zEleQP5OB9VQnCOvN96Nz1sM+C0j+qfjDSd3R7qM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QaCLKRAkmCpCd9Gqki+FGOXo7XIJJ9WU27R8Mzs7j8H+AmX6CpOQB6nFO3iDl+tawurcwu3tqefu1LyAFcylUivIxC1iN3wdxGYr+MZL8Oo/J9RwMS8QDC8ADGOgyLC85R1CJoBqxADEOmx/VKBtbvPzTKOLZfzzfmbr4diWx50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MP4e13DS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741153629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TckiHzoidmvghQ6zu3pJdp/CUVWbSHOgWhuCociTv5w=;
	b=MP4e13DSP8GrWaJJOc1aGnMtzaCTvmRk3WFx1PSgx0UGjAn7Ro07JHfr0YhNBk/KMLTIiK
	x84/JOLp0f/SqOmwW+Wq+r+r1IkRGPwG/XzjA+jWjYxerSwMcm2L6/mf2u2SqBJ+JNkdSA
	+NETmOhvMQTN+k9/J2wzm/yGUiRTx04=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-ccwnJRW_PmauYf9c7LhadQ-1; Wed, 05 Mar 2025 00:47:07 -0500
X-MC-Unique: ccwnJRW_PmauYf9c7LhadQ-1
X-Mimecast-MFC-AGG-ID: ccwnJRW_PmauYf9c7LhadQ_1741153627
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2fec1f46678so15264952a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 21:47:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741153627; x=1741758427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TckiHzoidmvghQ6zu3pJdp/CUVWbSHOgWhuCociTv5w=;
        b=MQEVyPZdTneyVDIzq2B/MSKXBcx/pWucSXKrceJfsrg2f+bAFn4uWMAsQXx/YbtnpT
         XSFakX3LxkSUs0WyU9URcRgKurbzdsg47aAdW86NiRhy1cw9NZYnk/uwVKC9lb4Obuz3
         /R+g4LTzVo4EBVx87SHfPyXzgS6SjPBh/SG4Il6GOY4nqQreNNYETLZaZuSVdeoOfmcr
         HiGB4G9F4JfEuOGxIsCEClHe8ik2DFsvmfOBqHBci+EJRN197wOIlGjE6ycLj1Rucvb8
         Nn6kqx+gfldb4yibBmWYXpFNt9TUj6YF6hm8+4NkcoyI2Rbk2IBAQvBkXZycAHl/aLtd
         JfkA==
X-Forwarded-Encrypted: i=1; AJvYcCX5jYJjb83+3G4OjevETAKhwE4ANGBWjrzmQGYYfGPt/Fka7KVWGyK7tGrKmO1EyYMH8us=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK6LESr+h7/8v57mxXxt5yaRGyxtYqnW4BjfyI7PcpwgDa5b9f
	8rIRzuYUft2NzoLJhOyrKuDjpmvZESwqaONhlKchiaDZgUJjYwKJQrQybXWsYYvRoqMQoVdnuSV
	2cWZSlfWZpHl50FgVASWUhS/4ieSlT9AtPnXtDnQUQO8xP4pCPVfGkDtvBINKsq10JlL4SKp9Dc
	D9uG0mmjrfUolBFzrcZjJCIzuj
X-Gm-Gg: ASbGncvC3/baNyqBnrIg9GSofvzEk6Z3OASEdJbE0sNt9dB/slpYOf1eFzQc7TsPBp/
	fQklMzx6pH0eCgVboAajS4TZ4n3qqzC1YHr4KsIqstfxhoyol9X9V5ZQ2byiHi+9+vPqet/bu5A
	==
X-Received: by 2002:a17:90b:1d52:b0:2ee:dcf6:1c8f with SMTP id 98e67ed59e1d1-2ff497cb040mr4004276a91.16.1741153626847;
        Tue, 04 Mar 2025 21:47:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7tLwkzpVQv2Fhj6KJP/g5jr88+NKViP8f9P/MLEqloHXqeIoNFWMkg7gOLyvweXjBE7QjXpxFd7/tryglpqM=
X-Received: by 2002:a17:90b:1d52:b0:2ee:dcf6:1c8f with SMTP id
 98e67ed59e1d1-2ff497cb040mr4004247a91.16.1741153626527; Tue, 04 Mar 2025
 21:47:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20200116172428.311437-1-sgarzare@redhat.com> <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com> <20200428160052.o3ihui4262xogyg4@steredhat>
 <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com>
In-Reply-To: <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 5 Mar 2025 13:46:54 +0800
X-Gm-Features: AQ5f1JrNByKY7PtEfXG0ORfP7FScyD2MAlIYCt0mdU5F_0VbeZRH2Dv5bfH1am0
Message-ID: <CACGkMEtTgmFVDU+ftDKEvy31JkV9zLLUv25LrEPKQyzgKiQGSQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, davem@davemloft.net, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, 
	Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-hyperv@vger.kernel.org, 
	Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 5, 2025 at 8:39=E2=80=AFAM Bobby Eshleman <bobbyeshleman@gmail.=
com> wrote:
>
> On Tue, Apr 28, 2020 at 06:00:52PM +0200, Stefano Garzarella wrote:
> > On Tue, Apr 28, 2020 at 04:13:22PM +0800, Jason Wang wrote:
> > >
> > >
> > > As we've discussed, it should be a netdev probably in either guest or=
 host
> > > side. And it would be much simpler if we want do implement namespace =
then.
> > > No new API is needed.
> > >
> >
> > Thanks Jason!
> >
> > It would be cool, but I don't have much experience on netdev.
> > Do you see any particular obstacles?
> >
> > I'll take a look to understand how to do it, surely in the guest would
> > be very useful to have the vsock device as a netdev and maybe also in t=
he host.
> >
>
> WRT netdev, do we foresee big gains beyond just leveraging the netdev's
> namespace?

It's a leverage of the network subsystem (netdevice, steering, uAPI,
tracing, probably a lot of others), not only its namespace. It can
avoid duplicating existing mechanisms in a vsock specific way. If we
manage to do that, namespace support will be a "byproduct".

>
> IIUC, the idea is that we could follow the tcp/ip model and introduce
> vsock-supported netdevs. This would allow us to have a netdev associated
> with the virtio-vsock device and create virtual netdev pairs (i.e.,
> veth) that can bridge namespaces. Then, allocate CIDs or configure port
> mappings for those namespaces?

Probably.

>
> I think it might be a lot of complexity to bring into the picture from
> netdev, and I'm not sure there is a big win since the vsock device could
> also have a vsock->net itself?

Yes, it can. I think we need to evaluate both approaches (that's why I
raise the approach of reusing netdevice). We can hear from others.

> I think the complexity will come from the
> address translation, which I don't think netdev buys us because there
> would still be all of the work work to support vsock in netfilter?

Netfilter should not work as vsock will behave as a separate protocol
other than TCP/IP (e.g ETH_P_VSOCK)  if we try to implement netdevice.

>
> Some other thoughts I had: netdev's flow control features would all have
> to be ignored or disabled somehow (I think dev_direct_xmit()?), because
> queueing introduces packet loss and the vsock protocol is unable to
> survive packet loss.

Or just allow it and then configuring a qdisc that may drop packets
could be treated as a misconfiguration.

> Netfilter's ability to drop packets would have to
> be disabled too.
>
> Best,
> Bobby
>

Thanks


