Return-Path: <kvm+bounces-21292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4427692CE84
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 11:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A6C728269B
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0EF18FA31;
	Wed, 10 Jul 2024 09:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YatCsrQp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC2818EFCC
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720604806; cv=none; b=HQjgpn7eogkNee5CZiwqUnBTFm8Mv/Ydbqlct2zQscpMoRS7+GeK3r0Wv9OiBIvv4v/SsaIPTsg6nNmqnorvLJn/kYR1RXQ3JpJHAbmDweVQttRvf10NcuBsQD6IqgYNlfU+pLS+sqFV3BSjCcRi8jkegvr8P6Yo13EvRysvOS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720604806; c=relaxed/simple;
	bh=LZFnsJhlMMXmLcnLjHwif3Tko8RTPA1FKx72W7VDpJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N1Am7eoTMsZeZcjX0YBzDO2PqnUR0ShlemAmjCDYUtXJTm5bhA9/1qrctHUz21uiDfugrl5XFk+B1nO3zgiS51d7USogIbgMsHYuYlAXf3R4Djjjxm0zXLgKv+AfrKsratfRPeOQfnaXWeBTL7P8i0IxKl1N+AJcnm+Eo7WbGA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YatCsrQp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720604803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wr3Fzy04+IjAcueeHCouhzEQFA2vb2X2x/Lajkzkytk=;
	b=YatCsrQpJ/OO0CxDVg2fqzIj8akACHno4x0xxpaagEwisLr/+FQ+51BbnL5/6uNPkVtVI4
	PH1xwL70j94+hs503mPBKFJSKk5Yhg+1piLEA28LlIH5kZ/oE1RKUKGr3rEXJiOklf1CDe
	BJumird57RJt5nbMQl9xklVeOVTuZRQ=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-e_F8WKZvO-ePxxIXz-EbcA-1; Wed, 10 Jul 2024 05:46:41 -0400
X-MC-Unique: e_F8WKZvO-ePxxIXz-EbcA-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2eebcab13f9so8627601fa.2
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 02:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720604800; x=1721209600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wr3Fzy04+IjAcueeHCouhzEQFA2vb2X2x/Lajkzkytk=;
        b=FSZI91yH1YzBm3VGvgoGgWT8gjs5+ustH273ncHnX1ch/UlqnQ9BKL4/132lvylJMJ
         iGAmdaaRfS4qewvpbyzcyBH3JfgNn2fDfq+6TcRtEjVCvfHBZjyIwC/mnDMRLVlX7zOE
         ZNNOod9RrxKZ1TPe4JegPweZsATmxP6cUEsmCcI/4jCLuY45tfGdtoiXrwmZyGjeCmBq
         xbgowvUYuw0KlS6cGK9iR49/sRf00JkBENC2oypp65TPUjSdWTdds7pzzwkWwUdLhcO/
         frUamO+s4Cqz2UgtAVpyYMvcJTPMw0trAAo0p/+L3gNtIivSvFcfBKE0Jy0f1cRDKreZ
         mafg==
X-Forwarded-Encrypted: i=1; AJvYcCUVxe+LwHJ7FAHepph6Xr8SRezrEqF3dkC7CIOnp71ClqotYgX7fFdxm0XN0zqMQ2icFtBEyLTSPCGKucFKiRHfJqqV
X-Gm-Message-State: AOJu0YxGGYTu1aFD9ySYWRjfR32bUvLOY8c/K7Wb9RVEy9Ap69W4RYx3
	h+pcWw/uYmxIoJtefO+GlxxUL3mE0kf5frGTVWeMl19NbJzdHZhEhQjd2CWUkrje+V0x5ujp83k
	Y1EFAc+ie6SdfD4fuUjgFSwNHz/0+U5L6rpTfM65OcEc/J/35/xwkjSfpnUyKg+6Uj+nIFT/SO7
	UnM0d4mRnLsCqJXv6SKrTC4WF3
X-Received: by 2002:a05:651c:97:b0:2ee:8aed:ddcd with SMTP id 38308e7fff4ca-2eeb30ba01bmr30673231fa.2.1720604800508;
        Wed, 10 Jul 2024 02:46:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0ffFCw3VbNM6Vw/r2MqpTFMKw6bcckSDGxnXr5Oj3vP+HBV03PNXiHpFH5GB2HlKHopl3lyeXuVt4nS1YdPI=
X-Received: by 2002:a05:651c:97:b0:2ee:8aed:ddcd with SMTP id
 38308e7fff4ca-2eeb30ba01bmr30673101fa.2.1720604800176; Wed, 10 Jul 2024
 02:46:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708064820.88955-1-lulu@redhat.com> <PH0PR12MB5481AE2FD52AEE1C10411F3DDCDB2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACLfguXk4qiw4efRGK4Gw8OZQ_PKw6j+GVQJCVtbyJ+hxOoE0Q@mail.gmail.com>
 <20240709084109-mutt-send-email-mst@kernel.org> <CACGkMEtdFgbgrjNDoYfW1B+4BwG8=i9CP5ePiULm2n3837n29w@mail.gmail.com>
 <20240710020852-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240710020852-mutt-send-email-mst@kernel.org>
From: Cindy Lu <lulu@redhat.com>
Date: Wed, 10 Jul 2024 17:46:02 +0800
Message-ID: <CACLfguW0HxPy7ZF7gg7hNzMqFcf5x87asQKBUqZMOJC_S8kSbw@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, "sgarzare@redhat.com" <sgarzare@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Leonardo Milleri <lmilleri@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Jul 2024 at 14:10, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 10, 2024 at 11:05:48AM +0800, Jason Wang wrote:
> > On Tue, Jul 9, 2024 at 8:42=E2=80=AFPM Michael S. Tsirkin <mst@redhat.c=
om> wrote:
> > >
> > > On Tue, Jul 09, 2024 at 02:19:19PM +0800, Cindy Lu wrote:
> > > > On Tue, 9 Jul 2024 at 11:59, Parav Pandit <parav@nvidia.com> wrote:
> > > > >
> > > > > Hi Cindy,
> > > > >
> > > > > > From: Cindy Lu <lulu@redhat.com>
> > > > > > Sent: Monday, July 8, 2024 12:17 PM
> > > > > >
> > > > > > Add support for setting the MAC address using the VDPA tool.
> > > > > > This feature will allow setting the MAC address using the VDPA =
tool.
> > > > > > For example, in vdpa_sim_net, the implementation sets the MAC a=
ddress to
> > > > > > the config space. However, for other drivers, they can implemen=
t their own
> > > > > > function, not limited to the config space.
> > > > > >
> > > > > > Changelog v2
> > > > > >  - Changed the function name to prevent misunderstanding
> > > > > >  - Added check for blk device
> > > > > >  - Addressed the comments
> > > > > > Changelog v3
> > > > > >  - Split the function of the net device from vdpa_nl_cmd_dev_at=
tr_set_doit
> > > > > >  - Add a lock for the network device's dev_set_attr operation
> > > > > >  - Address the comments
> > > > > >
> > > > > > Cindy Lu (2):
> > > > > >   vdpa: support set mac address from vdpa tool
> > > > > >   vdpa_sim_net: Add the support of set mac address
> > > > > >
> > > > > >  drivers/vdpa/vdpa.c                  | 81 ++++++++++++++++++++=
++++++++
> > > > > >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++-
> > > > > >  include/linux/vdpa.h                 |  9 ++++
> > > > > >  include/uapi/linux/vdpa.h            |  1 +
> > > > > >  4 files changed, 109 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > --
> > > > > > 2.45.0
> > > > >
> > > > > Mlx5 device already allows setting the mac and mtu during the vdp=
a device creation time.
> > > > > Once the vdpa device is created, it binds to vdpa bus and other d=
river vhost_vdpa etc bind to it.
> > > > > So there was no good reason in the past to support explicit confi=
g after device add complicate the flow for synchronizing this.
> > > > >
> > > > > The user who wants a device with new attributes, as well destroy =
and recreate the vdpa device with new desired attributes.
> > > > >
> > > > > vdpa_sim_net can also be extended for similar way when adding the=
 vdpa device.
> > > > >
> > > > > Have you considered using the existing tool and kernel in place s=
ince 2021?
> > > > > Such as commit d8ca2fa5be1.
> > > > >
> > > > > An example of it is,
> > > > > $ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:55=
 mtu 9000
> > > > >
> > > > Hi Parav
> > > > Really thanks for your comments. The reason for adding this functio=
n
> > > > is to support Kubevirt.
> > > > the problem we meet is that kubevirt chooses one random vdpa device
> > > > from the pool and we don't know which one it going to pick. That me=
ans
> > > > we can't get to know the Mac address before it is created. So we pl=
an
> > > > to have this function to change the mac address after it is created
> > > > Thanks
> > > > cindy
> > >
> > > Well you will need to change kubevirt to teach it to set
> > > mac address, right?
> >
> > That's the plan. Adding Leonardo.
> >
> > Thanks
>
> So given you are going to change kubevirt, can we
> change it to create devices as needed with the
> existing API?
>
Hi Micheal and Parav,
I'm really not familiar with kubevirt, hope Leonardo can help answer
these questions
Hi @Leonardo Milleri
would you help answer these questions?

Thanks
Cindy
> > >
> > > --
> > > MST
> > >
>


