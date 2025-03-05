Return-Path: <kvm+bounces-40151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A38BFA4FA57
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 10:38:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F1753AEEAC
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 09:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 833721E5B77;
	Wed,  5 Mar 2025 09:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TFhFGBz4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B601FC7CE
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 09:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741167487; cv=none; b=ZJbaObCTm5uxpITSFBL3OElEQQcBufrnSRn4jjLwUjRlpOfH3E5grvREj5TfqPJnuaEAOHc04ogiJ7hj1vcgbKJ5xiZmthVuWtPHG4TJ/zjyJpqVhJR3XEbaY/NGpVNVcG2OvAt/O7Ha7gs+cbWhnAGQug0rEUl4sx+VyCrsixE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741167487; c=relaxed/simple;
	bh=exY4ZR3eJixCKGY9RcS0uPA/+XbPIVQfPexC74yCyy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T23djaKZRPvYbM+QzGPghg64NzeRxbyCqPeBHqni3JLUL2nbdxdIsVgGYHy3n8gSnifPUKXJHdRupHhZEv7LmAOxCZO503bdEgy337i09BXQ8FdUo9tKdt8Vj5MMMNvSIl9wjzMQOBw0F4YXF+iJXnl97prJ1/puk7R9ubMSWDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TFhFGBz4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741167484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0FrWMD0bRhsF9/9bE85tn6Gl17O/CsmNiRx1oo/Ojac=;
	b=TFhFGBz4w/AT9QUFE7MBx6/mO0Tg5mulhqjOYIn/mMlExSDndVEMlgx5n+nmBx/xgjXfCs
	uQYeQUZHPkP5wGk/AL2sBbiRcuKB+U+oiQ8uFPmFtFcET1Q7ZvR+twIm8HlPuqWd1bi6bc
	y+cxVWtmruIFtcJL4DsFNiGCTmnEvnU=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-hZGFhKazMg-fk-8XozcJNQ-1; Wed, 05 Mar 2025 04:38:03 -0500
X-MC-Unique: hZGFhKazMg-fk-8XozcJNQ-1
X-Mimecast-MFC-AGG-ID: hZGFhKazMg-fk-8XozcJNQ_1741167483
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-e3a1bc0c875so8615668276.2
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 01:38:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741167483; x=1741772283;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0FrWMD0bRhsF9/9bE85tn6Gl17O/CsmNiRx1oo/Ojac=;
        b=welUn1sj8Q7e8Tld+gwOmmEm3HPsyRjSDvGO55LHU11LJSJXMEfh7iNlI+/Xb94FgZ
         O925pv0jUz1StHHnX0k5CRP2Rih+WTbBXFWhHkDLuWBUGPIPEPLiwNRfYMCTN/h9NDMM
         92GCCtBq40JXzySfQdsviaRVVr9uKdqfrPwR0qjFEc4xscu/V0CW/H9wy3h6vGbEZkUc
         Ia5fvNgMy/NY/wmyzyCwnPuD4K3DmVmp7lxmoY9YwAxU8w8kpN4L8MB1zpzKsTrQHL6w
         S7V60y+OfhoxVmeBxyzgl00milAXZ8Dg/KbpxaWYWcC54/aj708mi52TYHzXlvT0MSdV
         xpmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRgkk9cCt5jTra5E7NpJfYJ/k6fkiJ+Z8jEYAu+2rWHT/viEX95dSDh2zjWbcS+jyPMUk=@vger.kernel.org
X-Gm-Message-State: AOJu0YynonDRhQncmTaSI11ai0pVOfW+umIs5AltlQNCRy6qF59UL4oH
	8G8UYrv9Tx+ipNjvAPwLW1YP2ivDLSMil439+AkZkMdPiLS986rqLHnwJayh9QkWIc4LF+/v6/r
	c7TO+WuLHmcONftp2kb8xf1FcyQ+XgZqgJG6zYIch+UKUK+4JbVReKQ7J++rQ/d1e9lUcyL1Lh6
	BF9QkgCxHLVGOugsDxP5BuHT5j
X-Gm-Gg: ASbGncsOs4uUSiNyS8CFdpI6TDh6tioSgT+24HHarv63ktRBFywCSKMzCukaSxG8Krm
	srUN76Yxdx/5f45I3cHbDxrF7ygl42ASgx08Mz7NLz6rIKpcTZsngf51eFUWFykwwxkVACOo=
X-Received: by 2002:a05:6902:1183:b0:e60:99d2:cbc2 with SMTP id 3f1490d57ef6-e611e1d985bmr3487865276.25.1741167483068;
        Wed, 05 Mar 2025 01:38:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHdMsgj9Ydu4+cefxVYhObOl86/wGnTsK/HesSGO3ed6Vl99uqasl92wWHUDOUB2G4pt/8bHopoWWjG9JBFIQE=
X-Received: by 2002:a05:6902:1183:b0:e60:99d2:cbc2 with SMTP id
 3f1490d57ef6-e611e1d985bmr3487834276.25.1741167482716; Wed, 05 Mar 2025
 01:38:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20200116172428.311437-1-sgarzare@redhat.com> <20200116172428.311437-2-sgarzare@redhat.com>
 <20250305022900-mutt-send-email-mst@kernel.org> <CAGxU2F5C1kTN+z2XLwATvs9pGq0HAvXhKp6NUULos7O3uarjCA@mail.gmail.com>
 <20250305042757-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250305042757-mutt-send-email-mst@kernel.org>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 5 Mar 2025 10:37:51 +0100
X-Gm-Features: AQ5f1JrrYEAMMHf_xixI6yuzRilW5TDux-F3sq2MEJ4u_iOmeJJo3IO5_LvXWgY
Message-ID: <CAGxU2F5D=nx8V4d+iDyQvfJvhASMOM1c3AsRZT0R3TqnAVUhUQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux-foundation.org, 
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>, 
	Bobby Eshleman <bobbyeshleman@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Mar 2025 at 10:29, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Mar 05, 2025 at 10:23:08AM +0100, Stefano Garzarella wrote:
> > On Wed, 5 Mar 2025 at 08:32, Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Thu, Jan 16, 2020 at 06:24:26PM +0100, Stefano Garzarella wrote:
> > > > This patch adds a check of the "net" assigned to a socket during
> > > > the vsock_find_bound_socket() and vsock_find_connected_socket()
> > > > to support network namespace, allowing to share the same address
> > > > (cid, port) across different network namespaces.
> > > >
> > > > This patch adds 'netns' module param to enable this new feature
> > > > (disabled by default), because it changes vsock's behavior with
> > > > network namespaces and could break existing applications.
> > > > G2H transports will use the default network namepsace (init_net).
> > > > H2G transports can use different network namespace for different
> > > > VMs.
> > >
> > >
> > > I'm not sure I understand the usecase. Can you explain a bit more,
> > > please?
> >
> > It's been five years, but I'm trying!
> > We are tracking this RFE here [1].
> >
> > I also add Jakub in the thread with who I discussed last year a possible
> > restart of this effort, he could add more use cases.
> >
> > The problem with vsock, host-side, currently is that if you launch a VM
> > with a virtio-vsock device (using vhost) inside a container (e.g.,
> > Kata), so inside a network namespace, it is reachable from any other
> > container, whereas they would like some isolation. Also the CID is
> > shared among all, while they would like to reuse the same CID in
> > different namespaces.
> >
> > This has been partially solved with vhost-user-vsock, but it is
> > inconvenient to use sometimes because of the hybrid-vsock problem
> > (host-side vsock is remapped to AF_UNIX).
> >
> > Something from the cover letter of the series [2]:
> >
> >   As we partially discussed in the multi-transport proposal, it could
> >   be nice to support network namespace in vsock to reach the following
> >   goals:
> >   - isolate host applications from guest applications using the same ports
> >     with CID_ANY
> >   - assign the same CID of VMs running in different network namespaces
> >   - partition VMs between VMMs or at finer granularity
> >
> > Thanks,
> > Stefano
> >
> > [1] https://gitlab.com/vsock/vsock/-/issues/2
> > [2] https://lore.kernel.org/virtualization/20200116172428.311437-1-sgarzare@redhat.com/
>
>
> Ok so, host side. I get it.

Now that we're talking about it, I also came back to a guest side
case, again related to containers and possible nested VMs.

If you launch a container in a L1 guest, for example to launch a
nested VM, maybe you don't want to have it communicate with the L0
host, so it would be desirable to be able to isolate the virtio-vsock
device from it.

> And the problem with your patches is that
> they affect the guest side. Fix that, basically.

My main problem, IIRC, was making sure to allow the old behavior as
well (but that maybe we had solved with two /dev/vhost-vsock and
/dev/vhost-vsock-netns).

The other problem was really in the guest, on how to tell that the
virtio-vsock device (thus communication with the host) was reachable
from a netnamespace or not.

Stefano


