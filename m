Return-Path: <kvm+bounces-11879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1965687C81B
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 04:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7923CB216D0
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 03:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4B1DDB1;
	Fri, 15 Mar 2024 03:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKg8aE7e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE95D530
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 03:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710474727; cv=none; b=XfYTL6tb73TUU3nJ865EoKbYYZK3JWIrhg/4yOJ99yn5vUy9V9sXdk4O8BJpCIZPAhM33nWAQIEcitUlGumSrcMdmDTJMcSyLnl4NVj79hd7Ns+MPxeymwM7MuB0sjmCn+5UaRM1RKY7AR8O8PU/pm6lZe3JBaOt6ul0X0+SkBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710474727; c=relaxed/simple;
	bh=+P0SN8lR5UMoHiVeJbaZ63DVZv6EUw72aKI5RNx4i7Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IUGbp9XL1I+nwXAhAaC82fpSZTikyb+tCGacaPExZvLKMAHt5JMJS8VcKAPLfMUU+lJk7pmp81ayr0HXrzcvurDz1xroTWJBZrNxoiWskvOnrnFiN0a7RN/lD1ENFsOR76XTtndsJju7bvw+2oyAFUi1hnjbs5zDrko9DOf7LiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKg8aE7e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710474724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRnPjyJeZad1F26bIZOTcaKiZRrwc4cB/pDexLjVGDE=;
	b=VKg8aE7eO9wJeqvTEnDsLgmSTOzSBTfZ6WDZY0yYx5l3Gucoi/EQI4t08HOC+Y0Koaus3G
	03BTdgw33/Yhz6SWxdLJTDJzcWc8Xppo4Sxg3WN9XhhQlWmRh68XVjoUE6fkJrbHlFqIYP
	RSlb1ik6u5wleWqvrKyQbpbLtZvR4+k=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-AAx-6PeuPNurQ-nMrf45Bg-1; Thu, 14 Mar 2024 23:52:01 -0400
X-MC-Unique: AAx-6PeuPNurQ-nMrf45Bg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-29c718b7ff5so1543248a91.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:52:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710474720; x=1711079520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jRnPjyJeZad1F26bIZOTcaKiZRrwc4cB/pDexLjVGDE=;
        b=IUi5PLQFx/QZA5so+GehWPgcdd877yRiOrTqVevkdB6fpnzz6Xg/W/VDB6vrK/EjWZ
         rA/MpSNeOMOP0DYS9BKtMB9ckFb3jMN4Olkl5PN92k159Yc2LGYvo1qVSn+JvBmYMWg+
         A5eyMJWeq+tISdV2NsYl5x/N0fqa3070SaGH/K7vrxFFPqIp6gsqsc/w1YHJbWh7n1oa
         Jzqq5im1uNCLlVyPUGOP4or5sqGSnw7N2t7kHwFRBw9m/W9pJ+9C6Kre/W0fxxuDCrJx
         GJRTrjXFYal8iQkeT6fB0vWLEuCPhTYVH0Bxq3q5KycOyQYM5/sJkYgvxZ4HWSDHPBn7
         b26g==
X-Forwarded-Encrypted: i=1; AJvYcCUniQbf50kOZpEf/iFCyVyrTil/jlJthpEr1ZEL3nPneJSWiYdGFPagyK0L6MVmcb8f5IO54IvjuZpW3GcGatgFNEUo
X-Gm-Message-State: AOJu0Yzswrd0+mPdTRDf/kSYGD92+MLoR/0Ic/pHc6z2tqFAzRNnc+Il
	FgXp09N7Vu5xI3YPuDtXHy3x5J8ZO5tBARrRzSXL1TNIUbbN92xbbVagRwBeF0beCId7ImtCWHi
	CUuBdyOw5F6e1/A1UyyWIZ940I4RMXqmYczjdP6W76JJwbFMpROcckb705PuqOTk7rIU5aA8wrr
	4V3mrW3umREz9pAT+6bRcuCmgi
X-Received: by 2002:a17:90b:882:b0:29b:4755:23fc with SMTP id bj2-20020a17090b088200b0029b475523fcmr3558886pjb.33.1710474720018;
        Thu, 14 Mar 2024 20:52:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXDOuKDvuP/EqiFyBnUcJaSQVamH9YfVITPXeJDT8/OaXE+8nukfAwdydXN+5KUnq8MlXvmaNj0CipGi0ChDY=
X-Received: by 2002:a17:90b:882:b0:29b:4755:23fc with SMTP id
 bj2-20020a17090b088200b0029b475523fcmr3558876pjb.33.1710474719748; Thu, 14
 Mar 2024 20:51:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240312021013.88656-1-xuanzhuo@linux.alibaba.com>
 <20240312021013.88656-2-xuanzhuo@linux.alibaba.com> <CACGkMEvVgfgAxLoKeFTgy-1GR0W07ciPYFuqs6PiWtKCnXuWTw@mail.gmail.com>
 <1710395908.7915084-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1710395908.7915084-1-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 15 Mar 2024 11:51:48 +0800
Message-ID: <CACGkMEsT2JqJ1r_kStUzW0+-f+qT0C05n2A+Yrjpc-mHMZD_mQ@mail.gmail.com>
Subject: Re: [PATCH vhost v3 1/4] virtio: find_vqs: pass struct instead of
 multi parameters
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-um@lists.infradead.org, 
	platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2024 at 2:00=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> On Thu, 14 Mar 2024 11:12:24 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> > On Tue, Mar 12, 2024 at 10:10=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.alib=
aba.com> wrote:
> > >
> > > Now, we pass multi parameters to find_vqs. These parameters
> > > may work for transport or work for vring.
> > >
> > > And find_vqs has multi implements in many places:
> > >
> > >  arch/um/drivers/virtio_uml.c
> > >  drivers/platform/mellanox/mlxbf-tmfifo.c
> > >  drivers/remoteproc/remoteproc_virtio.c
> > >  drivers/s390/virtio/virtio_ccw.c
> > >  drivers/virtio/virtio_mmio.c
> > >  drivers/virtio/virtio_pci_legacy.c
> > >  drivers/virtio/virtio_pci_modern.c
> > >  drivers/virtio/virtio_vdpa.c
> > >
> > > Every time, we try to add a new parameter, that is difficult.
> > > We must change every find_vqs implement.
> > >
> > > One the other side, if we want to pass a parameter to vring,
> > > we must change the call path from transport to vring.
> > > Too many functions need to be changed.
> > >
> > > So it is time to refactor the find_vqs. We pass a structure
> > > cfg to find_vqs(), that will be passed to vring by transport.
> > >
> > > Because the vp_modern_create_avq() use the "const char *names[]",
> > > and the virtio_uml.c changes the name in the subsequent commit, so
> > > change the "names" inside the virtio_vq_config from "const char *cons=
t
> > > *names" to "const char **names".
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > > Reviewed-by: Ilpo J=3DE4rvinen <ilpo.jarvinen@linux.intel.com>
> >
> > The name seems broken here.
>
> Email APP bug.
>
> I will fix.
>
>
> >
> > [...]
> >
> > >
> > >  typedef void vq_callback_t(struct virtqueue *);
> > >
> > > +/**
> > > + * struct virtio_vq_config - configure for find_vqs()
> > > + * @cfg_idx: Used by virtio core. The drivers should set this to 0.
> > > + *     During the initialization of each vq(vring setup), we need to=
 know which
> > > + *     item in the array should be used at that time. But since the =
item in
> > > + *     names can be null, which causes some item of array to be skip=
ped, we
> > > + *     cannot use vq.index as the current id. So add a cfg_idx to le=
t vring
> > > + *     know how to get the current configuration from the array when
> > > + *     initializing vq.
> >
> > So this design is not good. If it is not something that the driver
> > needs to care about, the core needs to hide it from the API.
>
> The driver just ignore it. That will be beneficial to the virtio core.
> Otherwise, we must pass one more parameter everywhere.

I don't get here, it's an internal logic and we've already done that.

Thanks

>
> Thanks.
>
> >
> > Thanks
> >
>


