Return-Path: <kvm+bounces-40713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1D4A5B591
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 02:02:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5274117344B
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 01:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041991E0E13;
	Tue, 11 Mar 2025 01:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xz2fz5O1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FB81DE4F0
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 01:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741654906; cv=none; b=rq5XUc5zckJr6f+Ek2TjFAa9HAF6bQdTUZED/lxC+zVGdsa4g3hRRg0Az5xujkgF01fDJxIsvkKVEBF3BX8Mk/oXCUb9+Cogpjm3Md00H03rjkjapmNFI6GIcoH1tUeeCKVj80xviMwW7HwCZqeo1FVfiIHDAWZY+R4V6ryfzqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741654906; c=relaxed/simple;
	bh=54oJMjM8shiRn1OnZ1JipCpRhpImJA6xO8ic278ve44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QEtvbnbbbYKWWd/h41rW+S52kDZimcCi0nQLyYpYcPpPUxyN0Y9kU4zV4qZ6RFsrCrTLaZ3E9c33XGSxm3OkU/7es5J/MO4JnSHmC2EGlSRx/WetysEWROkI5Rhz+TqHO1N/K7ybegNIdct2e7iWFUmHyrPNt/Ez0tvSswTSnts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xz2fz5O1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741654903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=otxChvBJUIl3nIMsETvBBdmY0LiFzMWWzPwOK3dbDlk=;
	b=Xz2fz5O1t0Q9Rl8C8RQSJK2j9p6+F6EslrPSWQ2SbGaEN9Djf0QFaSwJYRlFQ+09d515nj
	a9R9vqcZJj2pnoDVwZ5GJI136gqMcuOfLB2BDhXHEVQJTlozr+/Zl9tiSucBSbe8hIb8fP
	aTI2LaYcRQHHs07nIgbm1aWa8KTLdH0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-HRQMCVC-MciZDxaOjOhFqQ-1; Mon, 10 Mar 2025 21:01:40 -0400
X-MC-Unique: HRQMCVC-MciZDxaOjOhFqQ-1
X-Mimecast-MFC-AGG-ID: HRQMCVC-MciZDxaOjOhFqQ_1741654899
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ff4b130bb2so8079357a91.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 18:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741654899; x=1742259699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=otxChvBJUIl3nIMsETvBBdmY0LiFzMWWzPwOK3dbDlk=;
        b=i8idctuB5M4qt2BcZubEqVu5/JWHdIHyXsJQ9HfQpg9CcbdbHF1CRSr+MAp2d7Ap0P
         dzJTFwR0WQXeUnpTsWd7IsoHAGaMTrPa7NjSOqqff/hM4aTDyp2G1imkhxICJaMAqd//
         5gjyuN2RPD3XgEQ82hc/m0hXGcUUMeAI/upOzqP0pRynRuEQt/nGi86lX0O2/drETkUp
         J8PVZpR6eqGXkWNcM4ydfYTdWvZaDflLZyWODbimBE2U844ZkowAnf9iDZQiMBdoL7L5
         0vdfZwFoPrfqYNbCDoLE3zy5piHFeqBRQz+CTNP5TOC33rBdzc4f+J1XYsEtJV1WOkgx
         n7MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpj6RG5Xd1HtlzP9z47lp8MFW7mjIfoeFR/1FGggKWdQVjLTI5rRR8oZdfAr/7RJu0HiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyFXR8Pm8e72rbwd9QHhqGKuCV3UGPtCsgfM2UMvmH0eaOZ44d
	7IJwM8HfPRaVijCHLnjpwLLLwR0ihUcPOiB0VLXrmg20M+3eZ2vrx0Tgtpq2gprrAzAsH3Hd3P6
	pgwxPcKhsOjHX27HQ38q4PrV91S/H8LKZXUSgGZkKZFGx5/59EQ3RvjiaExr41wk6bmwMFD8iAf
	bF+MWQKPju8Tiip9IPAb/+F7tP
X-Gm-Gg: ASbGncvhV+5ODMRbwh8aiHFwl7Lm8nxqBiP9GFbbIGDYXBfVKL8Gg2dK2Ri9d9Y08SW
	UV29IcnPGJEj0RLXqaPzq9xpiQ96i2KkT+BLSVPPv6zfYF4DQ2Mt2qIqNsEI80dKrv3A7pw==
X-Received: by 2002:a17:90b:4ad2:b0:2fa:137f:5c5c with SMTP id 98e67ed59e1d1-2ff7ce59712mr22326095a91.1.1741654899125;
        Mon, 10 Mar 2025 18:01:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFB3szA9e+qiTUX8D32Hw8wb313r3j65QyUK27BPoTVTn9q4ojSxaDQDQ9rIzvrEtlrS+WS7n5EOVmcp56KXhk=
X-Received: by 2002:a17:90b:4ad2:b0:2fa:137f:5c5c with SMTP id
 98e67ed59e1d1-2ff7ce59712mr22326069a91.1.1741654898757; Mon, 10 Mar 2025
 18:01:38 -0700 (PDT)
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
 <CACGkMEvms=i5z9gVRpnrXXpBnt3KGwM4bfRc46EztzDi4pqOsw@mail.gmail.com>
 <CAGxU2F7SWG0m0KwODbKsbQipz6WzrRSuE1cUe6mYxZskqkbneQ@mail.gmail.com> <CACGkMEtptFWx_v-14e1LM31XH+fOh4U-VO7gZKyqb1J1KM4uag@mail.gmail.com>
In-Reply-To: <CACGkMEtptFWx_v-14e1LM31XH+fOh4U-VO7gZKyqb1J1KM4uag@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 11 Mar 2025 09:01:23 +0800
X-Gm-Features: AQ5f1JryFKyYz4Qy5Qu0hBDkTUXYULGfbK0w_lAdgtos8tIuW3BVNWh2Ym_c4Mw
Message-ID: <CACGkMEsgRZr=FZLrMkkyDbEzDvUHNHsEK8y7_cGL16gLZh1+Nw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net, 
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-hyperv@vger.kernel.org, 
	Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2025 at 8:54=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Mon, Mar 10, 2025 at 10:15=E2=80=AFPM Stefano Garzarella <sgarzare@red=
hat.com> wrote:
> >
> > On Thu, 6 Mar 2025 at 01:17, Jason Wang <jasowang@redhat.com> wrote:
> > >
> > > On Wed, Mar 5, 2025 at 5:30=E2=80=AFPM Stefano Garzarella <sgarzare@r=
edhat.com> wrote:
> > > >
> > > > On Wed, Mar 05, 2025 at 02:27:12AM -0500, Michael S. Tsirkin wrote:
> > > > >On Tue, Mar 04, 2025 at 04:39:02PM -0800, Bobby Eshleman wrote:
> > > > >> I think it might be a lot of complexity to bring into the pictur=
e from
> > > > >> netdev, and I'm not sure there is a big win since the vsock devi=
ce could
> > > > >> also have a vsock->net itself? I think the complexity will come =
from the
> > > > >> address translation, which I don't think netdev buys us because =
there
> > > > >> would still be all of the work work to support vsock in netfilte=
r?
> > > > >
> > > > >Ugh.
> > > > >
> > > > >Guys, let's remember what vsock is.
> > > > >
> > > > >It's a replacement for the serial device with an interface
> > > > >that's easier for userspace to consume, as you get
> > > > >the demultiplexing by the port number.
> > >
> > > Interesting, but at least VSOCKETS said:
> > >
> > > """
> > > config VSOCKETS
> > >         tristate "Virtual Socket protocol"
> > >         help
> > >          Virtual Socket Protocol is a socket protocol similar to TCP/=
IP
> > >           allowing communication between Virtual Machines and hypervi=
sor
> > >           or host.
> > >
> > >           You should also select one or more hypervisor-specific tran=
sports
> > >           below.
> > >
> > >           To compile this driver as a module, choose M here: the modu=
le
> > >           will be called vsock. If unsure, say N.
> > > """
> > >
> > > This sounds exactly like networking stuff and spec also said somethin=
g similar
> > >
> > > """
> > > The virtio socket device is a zero-configuration socket communication=
s
> > > device. It facilitates data transfer between the guest and device
> > > without using the Ethernet or IP protocols.
> > > """
> > >
> > > > >
> > > > >The whole point of vsock is that people do not want
> > > > >any firewalling, filtering, or management on it.
> > >
> > > We won't get this, these are for ethernet and TCP/IP mostly.
> > >
> > > > >
> > > > >It needs to work with no configuration even if networking is
> > > > >misconfigured or blocked.
> > >
> > > I don't see any blockers that prevent us from zero configuration, or =
I
> > > miss something?
> > >
> > > >
> > > > I agree with Michael here.
> > > >
> > > > It's been 5 years and my memory is bad, but using netdev seemed lik=
e a
> > > > mess, especially because in vsock we don't have anything related to
> > > > IP/Ethernet/ARP, etc.
> > >
> > > We don't need to bother with that, kernel support protocols other tha=
n TCP/IP.
> >
> > Do we have an example of any other non-Ethernet device that uses
> > netdev? Just to see what we should do.
>
> Yes, I think can device is one example and it should have others.
>
> >
> > I'm not completely against the idea, but from what I remember when I
> > looked at it five years ago, it wasn't that easy and straightforward
> > to use.
>
> Can just hook the packets into its own stack, maybe vsock can do the same=
.
>
> >
> > >
> > > >
> > > > I see vsock more as AF_UNIX than netdev.
> > >
> > > But you have a device in guest that differs from the AF_UNIX.
> >
> > Yes, but the device is simply for carrying messages.
> > Another thing that makes me think of AF_UNIX is the hybrid-vsock
> > developed by Firecracker [1] that we also reused in vhost-user-vsock
> > [2], where the mapping between AF_VSOCK and AF_UNIX is really
> > implemented.
>
> I see. But the main difference is that vsock can work across the
> boundary of guest and host. This makes it hard to be a 100% socket
> implementation in the guest.

Or inventing a protocol to make vsosk can be transported via ethernet
(not sure this is possible then).

Thanks

>
> Thanks
>
> >
> > Thanks,
> > Stefano
> >
> > [1] https://github.com/firecracker-microvm/firecracker/blob/main/docs/v=
sock.md#firecracker-virtio-vsock-design
> > [2] https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-vso=
ck
> >


