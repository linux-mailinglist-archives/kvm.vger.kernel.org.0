Return-Path: <kvm+bounces-21399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B7C92E325
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 11:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9DB5B2765E
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 09:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1031415535A;
	Thu, 11 Jul 2024 09:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edW1QDUI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEA015531B
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 09:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720688916; cv=none; b=Tw9mgGq5y6VU1KHg5iytb29Gawk9El/qZNkAUZZkS6EyRi70ql8fwRSDbdRLOSzJiwTZm50/ESeyovCoE+TZqgiLFf8tPIfHdG1sh4YhsgX8WEQ6WIpJUy2BndAWxvvQWyV6noPQEFpu2ITeCOm5fnlnP8BvFTSs6sK4SvA8vkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720688916; c=relaxed/simple;
	bh=ljxzkssEHs7PsymbyswJfU5Htuhh01H9EMxCQUsejwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e6HDGQgTHwz6M5LfazkYfPL9m+nz2/4LcWMRu+d6qpN5d/6awT5eoQ77gtZNZpMhCsF29HeZ7k7A+trB4MVO8sHoJA1wPpmhqjQ7CYXLIZRT+jnah/Kq42opLkMG5owV3EYon+T+W7xhUmAH1enoeDfZqz6UletLHfEQ0e9S3zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edW1QDUI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720688913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/tGGgMXZufug5VbuEhcEzd7l9HFMjvswmFUFEeaDBA=;
	b=edW1QDUIcFUJRRiQIL4gj9GFObjD3jZy+F3DsmgKfER3VyfFmSEKXoc3KEfuYa2J/oYf11
	0d6AhK02uXdZaL0GSHo/kDiCKk5hXo+BSw0p1YIeDadpmUDuaSnKF9gtdTGEdp3zTi6xdw
	WTKgHNJPQ7V2i22VCrUtbpCRHrKLAyI=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-YhmN2xhDMaWzoUUkmNjcSw-1; Thu, 11 Jul 2024 05:08:31 -0400
X-MC-Unique: YhmN2xhDMaWzoUUkmNjcSw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ee49ce152eso5407531fa.3
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 02:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720688910; x=1721293710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z/tGGgMXZufug5VbuEhcEzd7l9HFMjvswmFUFEeaDBA=;
        b=Y0y6clNYHTAEoWDB7TCPgO8dxrLpfeQkF9T1BlVU0v12NOhiKaCXBcFWJwVbubhaet
         3QIFAheE0tsIWyNtmiK1vTfvy4arMbBJrSobDvZJOlfM7WUYWTUOO14mmFXWTDENw+wI
         ZXOcMbuzmt4YAFQIqXzYkG81izQ45iyFpVtoifkkOeI13pDerAaEcGkbutw+QvfKAauO
         UuvAsJsMBKlFq+NtsGI0R+UDRt0dFdyHvtZFPf0xR+GivEPT4BVAfItPtF2aTST1xLbE
         3iaHLWIPIkojniqSISYY8p9jYsiq/1UhvDesM8LDMm2aGrhNVF1K/h+uCD8lF+RgcFqM
         4SSA==
X-Forwarded-Encrypted: i=1; AJvYcCVl8VL4WwMVq6dS2Oedzh3MQTp6t82W38q0H5lRFUs8mUdo+U46dMvOeiJgqkwdzIfYRVG6A9+MKwjp5IN4S8kryndg
X-Gm-Message-State: AOJu0YzGQ5Fclkq2memMEEUtnbgHBdA5cHJh9mkMBqGVyiV9R+V1gkS4
	o3U+3FmM2XCJseR6Q8YL68hlAk745sY7l6wpZRNZC5RtwD4xV+OESm0rflq1TG7jHj9eYFJkAM8
	pIvS7+BPEE9gahkDBrfuAtoZyMkqmFJWplw+h/5fOKyv4klAXE9m3lWoPm8ZqD2Gg5q+F7ltfZE
	paQFBwNwOUGTUIuQr1q+yK5N5/
X-Received: by 2002:a2e:a7c7:0:b0:2ee:5b64:b471 with SMTP id 38308e7fff4ca-2eeb30fefcdmr62447881fa.30.1720688910142;
        Thu, 11 Jul 2024 02:08:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6W3hcev+Z5OBlMg/D7fGaW0A5j3JIOurKm0/vCYKBrpnwOMpohSuAs0Uf+VCxUXTyOZqrGR6A60J2YxKWLD0=
X-Received: by 2002:a2e:a7c7:0:b0:2ee:5b64:b471 with SMTP id
 38308e7fff4ca-2eeb30fefcdmr62447591fa.30.1720688909618; Thu, 11 Jul 2024
 02:08:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708064820.88955-1-lulu@redhat.com> <PH0PR12MB5481AE2FD52AEE1C10411F3DDCDB2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACLfguXk4qiw4efRGK4Gw8OZQ_PKw6j+GVQJCVtbyJ+hxOoE0Q@mail.gmail.com>
 <20240709084109-mutt-send-email-mst@kernel.org> <CACGkMEtdFgbgrjNDoYfW1B+4BwG8=i9CP5ePiULm2n3837n29w@mail.gmail.com>
 <20240710020852-mutt-send-email-mst@kernel.org> <CACLfguW0HxPy7ZF7gg7hNzMqFcf5x87asQKBUqZMOJC_S8kSbw@mail.gmail.com>
In-Reply-To: <CACLfguW0HxPy7ZF7gg7hNzMqFcf5x87asQKBUqZMOJC_S8kSbw@mail.gmail.com>
From: Leonardo Milleri <lmilleri@redhat.com>
Date: Thu, 11 Jul 2024 10:08:18 +0100
Message-ID: <CAD2tU16x1aeZLcQrESroqz-5n=S0nkgh8QTQO31-yYF_7hqB=Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
To: Cindy Lu <lulu@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Parav Pandit <parav@nvidia.com>
Cc: Jason Wang <jasowang@redhat.com>, Dragos Tatulea <dtatulea@nvidia.com>, 
	"sgarzare@redhat.com" <sgarzare@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for the noise, resending the email in text format

Hi All,

My answers inline below

>> Any specific reason to pre-create those large number of vdpa devices of =
the pool?
>> I was hoping to create vdpa device with needed attributes, when spawning=
 a kubevirt instance.
>> K8s DRA infrastructure [1] can be used to create the needed vdpa device.=
 Have you considered using the DRA of [1]?

The vhost-vdpa devices are created in the host before spawning the
kubevirt VM. This is achieved by using:
- sriov-network-operator: load kernel drivers, create vdpa devices
(with MAC address), etc
- sriov-device-plugin: create pool of resources (vdpa devices in this
case), advertise devices to k8s, allocate devices during pod creation
(by the way, isn't this mechanism very similar to DRA?)

Then we create the kubevirt VM by defining an interface with the
following attributes:
- type:vdpa
- mac
- source: vhost-vdpa path

So the issue is, how to make sure the mac in the VM is the same mac of vdpa=
?
Two options:
- ensure kubevirt interface mac is equal to vdpa mac: this is not
possible because of the device plugin resource pool. You can have a
few devices in the pool and the device plugin picks one randomly.
- change vdpa mac address at a later stage, to make sure it is aligned
with kubevirt interface mac. I don't know if there is already specific
code in kubevirt to do that or need to be implemented.

Hope this helps to clarify

Thanks
Leonardo


On Wed, Jul 10, 2024 at 10:46=E2=80=AFAM Cindy Lu <lulu@redhat.com> wrote:
>
> On Wed, 10 Jul 2024 at 14:10, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jul 10, 2024 at 11:05:48AM +0800, Jason Wang wrote:
> > > On Tue, Jul 9, 2024 at 8:42=E2=80=AFPM Michael S. Tsirkin <mst@redhat=
.com> wrote:
> > > >
> > > > On Tue, Jul 09, 2024 at 02:19:19PM +0800, Cindy Lu wrote:
> > > > > On Tue, 9 Jul 2024 at 11:59, Parav Pandit <parav@nvidia.com> wrot=
e:
> > > > > >
> > > > > > Hi Cindy,
> > > > > >
> > > > > > > From: Cindy Lu <lulu@redhat.com>
> > > > > > > Sent: Monday, July 8, 2024 12:17 PM
> > > > > > >
> > > > > > > Add support for setting the MAC address using the VDPA tool.
> > > > > > > This feature will allow setting the MAC address using the VDP=
A tool.
> > > > > > > For example, in vdpa_sim_net, the implementation sets the MAC=
 address to
> > > > > > > the config space. However, for other drivers, they can implem=
ent their own
> > > > > > > function, not limited to the config space.
> > > > > > >
> > > > > > > Changelog v2
> > > > > > >  - Changed the function name to prevent misunderstanding
> > > > > > >  - Added check for blk device
> > > > > > >  - Addressed the comments
> > > > > > > Changelog v3
> > > > > > >  - Split the function of the net device from vdpa_nl_cmd_dev_=
attr_set_doit
> > > > > > >  - Add a lock for the network device's dev_set_attr operation
> > > > > > >  - Address the comments
> > > > > > >
> > > > > > > Cindy Lu (2):
> > > > > > >   vdpa: support set mac address from vdpa tool
> > > > > > >   vdpa_sim_net: Add the support of set mac address
> > > > > > >
> > > > > > >  drivers/vdpa/vdpa.c                  | 81 ++++++++++++++++++=
++++++++++
> > > > > > >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++-
> > > > > > >  include/linux/vdpa.h                 |  9 ++++
> > > > > > >  include/uapi/linux/vdpa.h            |  1 +
> > > > > > >  4 files changed, 109 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > --
> > > > > > > 2.45.0
> > > > > >
> > > > > > Mlx5 device already allows setting the mac and mtu during the v=
dpa device creation time.
> > > > > > Once the vdpa device is created, it binds to vdpa bus and other=
 driver vhost_vdpa etc bind to it.
> > > > > > So there was no good reason in the past to support explicit con=
fig after device add complicate the flow for synchronizing this.
> > > > > >
> > > > > > The user who wants a device with new attributes, as well destro=
y and recreate the vdpa device with new desired attributes.
> > > > > >
> > > > > > vdpa_sim_net can also be extended for similar way when adding t=
he vdpa device.
> > > > > >
> > > > > > Have you considered using the existing tool and kernel in place=
 since 2021?
> > > > > > Such as commit d8ca2fa5be1.
> > > > > >
> > > > > > An example of it is,
> > > > > > $ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:=
55 mtu 9000
> > > > > >
> > > > > Hi Parav
> > > > > Really thanks for your comments. The reason for adding this funct=
ion
> > > > > is to support Kubevirt.
> > > > > the problem we meet is that kubevirt chooses one random vdpa devi=
ce
> > > > > from the pool and we don't know which one it going to pick. That =
means
> > > > > we can't get to know the Mac address before it is created. So we =
plan
> > > > > to have this function to change the mac address after it is creat=
ed
> > > > > Thanks
> > > > > cindy
> > > >
> > > > Well you will need to change kubevirt to teach it to set
> > > > mac address, right?
> > >
> > > That's the plan. Adding Leonardo.
> > >
> > > Thanks
> >
> > So given you are going to change kubevirt, can we
> > change it to create devices as needed with the
> > existing API?
> >
> Hi Micheal and Parav,
> I'm really not familiar with kubevirt, hope Leonardo can help answer
> these questions
> Hi @Leonardo Milleri
> would you help answer these questions?
>
> Thanks
> Cindy
> > > >
> > > > --
> > > > MST
> > > >
> >
>


