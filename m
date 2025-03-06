Return-Path: <kvm+bounces-40199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F418CA53EFF
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 01:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AE5116B02E
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 00:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A353E5672;
	Thu,  6 Mar 2025 00:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbjCaw7C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0C0184E
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 00:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741220229; cv=none; b=CypENA0SxgvNdhcwRolehpM+omGlLl9dGXovfHM3gHWxjWhYYzKHTcwkFFnSaesozO51KHt2m2X9JC9bi2WrB5xMIh92kB6KSUGwwCFTkxKKvPmaZuwDw/FVSmIx08G9lxAcYyMLJz9xF+JSrzAJo2p9wBPiNZAVc7JLD4lNSOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741220229; c=relaxed/simple;
	bh=+Wwm78y9BnVLdWm8RFuREOENXYM1SpKDISYy3wFQGr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m8EhHk9uq4+C8p/kFWOBi+3AhPZsyIDiDuzqrYpTShRJK/gXm80orx1yLA6SsS8Vkv+ieHVvhuFDVIYnP2BTRBVh6aqVJ0P/OSzYoTpyxzWdxIHVJtl7HTm/y4maLeCJRuQpcyBFOc1MQYRzxcXm0LWDmOGvfPn/1YF5f9alfgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fbjCaw7C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741220227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYivC87WhRU5jPCfxZzkS7AXzckjBFGkdKstv7mfD7c=;
	b=fbjCaw7Cbiya0VugU4yRUuuCN86Vn4oa9ivgkrnDWkfyC1IRYgTyP50U5Vg0HZxUdW9CK6
	5z1cmwrXrk3Oy8Z01/zWsjsbw1xQJ/htBWb5xZUiNDqQVxHFKrFgLzn3IFh2hAt6BMrc0R
	yJsbVqyI8GVxVqDpoi5taZ4nPViC/LI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-IDAD1RGaMmKGmmPyCUMWRw-1; Wed, 05 Mar 2025 19:17:04 -0500
X-MC-Unique: IDAD1RGaMmKGmmPyCUMWRw-1
X-Mimecast-MFC-AGG-ID: IDAD1RGaMmKGmmPyCUMWRw_1741220223
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ff58318acaso409718a91.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 16:17:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741220223; x=1741825023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YYivC87WhRU5jPCfxZzkS7AXzckjBFGkdKstv7mfD7c=;
        b=ZTIXM1uFYbV+LK/4tGDNYdjJm1RhyJfYtrUPCYf5Zvse3196nvovLDRNclAURYrsDw
         oi6ZknlFnn+BuXdnR1S2AXV/7CRC/JBBpxACDAoYU1ATXjiSzMW6xvCu0+d2rVMS/lkq
         z8TKS9406Ni6eq5ALhnCP8CBJmFBEHcy75YvwcGRJWMA9FX7KgGqbtW8MgEGBGjVQB+a
         uLtoXjbq2dGr/ffTQxBKD8a3AhkqZd6vCwqYw1DdmQ6HxbgWQm3Kyz2Jv8XWiwpCmflo
         h+4qI8OCa4samCqHLsVAlh+U6YPIAEWRZlR7PKQL2EhMhoXzeCOAYYfi0f8RYvRU/CoT
         SIkw==
X-Forwarded-Encrypted: i=1; AJvYcCWxPylG6+kfDXvONpQdWmq5na+D/G9uBzIaf5Q/Fw7tvl4nQDWBdKJHbmzNt1TFQa0FNcs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuJ17V8ebfVXzPeeuTJKyiaVwqDp5dY8nFrvOAq0OyAFtkkIBj
	7Y8yNnQA1a7sSqFn9nMEbBYZ2oTIinhQZ2A+iK1Ri/LY3Wbgu0D5MdJRxrz0pFXYz3u7te27m7D
	7fMXHg/W4eI74H8N7kG1/AEGvaEkiW77PdUxRZSJXP7fnO0DCerZRyGzSUtXXOJB07Jfjmbgd8u
	gG9VGjVFkddSFv6tPvea5xZdx9
X-Gm-Gg: ASbGncvwBr3mjie/JAoaOTSCOfZj1SBIZk/TK4dg+lTQvCirT+BNx7iiXJl/KqJ+30N
	buqq11cgTKwstiJX4XkSv6vJ/sIiPq/3xabWEZFnmdeSwpV88Bu8S3/lCVmvlwk7+jszSVLtTI3
	g=
X-Received: by 2002:a17:90b:3c87:b0:2ef:2f49:7d7f with SMTP id 98e67ed59e1d1-2ff497cce78mr9640209a91.18.1741220222888;
        Wed, 05 Mar 2025 16:17:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFm03yuBJCzHipb+u+/vxkatspEkUc/vBoHzZ9SJCyh2hxYSRGDOjw00zbfIsnmQnxOyJi4dQOkxCDXWDyfOC0=
X-Received: by 2002:a17:90b:3c87:b0:2ef:2f49:7d7f with SMTP id
 98e67ed59e1d1-2ff497cce78mr9640168a91.18.1741220222504; Wed, 05 Mar 2025
 16:17:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20200116172428.311437-1-sgarzare@redhat.com> <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com> <20200428160052.o3ihui4262xogyg4@steredhat>
 <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com> <20250305022248-mutt-send-email-mst@kernel.org>
 <v5c32aounjit7gxtwl4yxo2q2q6yikpb5yv3huxrxgfprxs2gk@b6r3jljvm6mt>
In-Reply-To: <v5c32aounjit7gxtwl4yxo2q2q6yikpb5yv3huxrxgfprxs2gk@b6r3jljvm6mt>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 6 Mar 2025 08:16:51 +0800
X-Gm-Features: AQ5f1Jql0yqolE1p-RM3zEM6LJujZ0qsyX-vhJHsLFPVzV7f1_y-mNi6DKL8tMs
Message-ID: <CACGkMEvms=i5z9gVRpnrXXpBnt3KGwM4bfRc46EztzDi4pqOsw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net, 
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org, 
	Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-hyperv@vger.kernel.org, 
	Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 5, 2025 at 5:30=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> On Wed, Mar 05, 2025 at 02:27:12AM -0500, Michael S. Tsirkin wrote:
> >On Tue, Mar 04, 2025 at 04:39:02PM -0800, Bobby Eshleman wrote:
> >> I think it might be a lot of complexity to bring into the picture from
> >> netdev, and I'm not sure there is a big win since the vsock device cou=
ld
> >> also have a vsock->net itself? I think the complexity will come from t=
he
> >> address translation, which I don't think netdev buys us because there
> >> would still be all of the work work to support vsock in netfilter?
> >
> >Ugh.
> >
> >Guys, let's remember what vsock is.
> >
> >It's a replacement for the serial device with an interface
> >that's easier for userspace to consume, as you get
> >the demultiplexing by the port number.

Interesting, but at least VSOCKETS said:

"""
config VSOCKETS
        tristate "Virtual Socket protocol"
        help
         Virtual Socket Protocol is a socket protocol similar to TCP/IP
          allowing communication between Virtual Machines and hypervisor
          or host.

          You should also select one or more hypervisor-specific transports
          below.

          To compile this driver as a module, choose M here: the module
          will be called vsock. If unsure, say N.
"""

This sounds exactly like networking stuff and spec also said something simi=
lar

"""
The virtio socket device is a zero-configuration socket communications
device. It facilitates data transfer between the guest and device
without using the Ethernet or IP protocols.
"""

> >
> >The whole point of vsock is that people do not want
> >any firewalling, filtering, or management on it.

We won't get this, these are for ethernet and TCP/IP mostly.

> >
> >It needs to work with no configuration even if networking is
> >misconfigured or blocked.

I don't see any blockers that prevent us from zero configuration, or I
miss something?

>
> I agree with Michael here.
>
> It's been 5 years and my memory is bad, but using netdev seemed like a
> mess, especially because in vsock we don't have anything related to
> IP/Ethernet/ARP, etc.

We don't need to bother with that, kernel support protocols other than TCP/=
IP.

>
> I see vsock more as AF_UNIX than netdev.

But you have a device in guest that differs from the AF_UNIX.

>
> I put in CC Jakub who was covering network namespace, maybe he has some
> advice for us regarding this. Context [1].
>
> Thanks,
> Stefano
>
> [1] https://lore.kernel.org/netdev/Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebo=
ok.com/
>

Thanks


