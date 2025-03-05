Return-Path: <kvm+bounces-40168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80704A50423
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 17:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEFA318929C5
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 16:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A02D9250BE0;
	Wed,  5 Mar 2025 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJ4ZmBoR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E13724DFEB
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741190859; cv=none; b=G4Xg3yPlPlvC3TaEF71J07u/Dlx6M1q5IQuZxp4NvAomMrrHEX3V05YMgkulr84esfws6RbDQvHGc+zAG1vdxGp0owS7WPlsKP9vjiJHb57JgbaKXcy9YZlDf7dTw7GIfHwG7MiiK/W23Uw+yfgtvlWpn/8QI8dyUt+BdT2X8d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741190859; c=relaxed/simple;
	bh=kq/Og+wt7HP9ZImJr8Q41zTRnAZqrVJ2k+Jm/8grxEk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M2XHFw2LPkuMfa9Y3dx0qMIGCt5GcyDyjCoJqpOpaiKbY6lBepikv9f4PBFyWNUBUZbuZltBdIwEIOPK3LcI8gBjc8kZykJ48ESjaU0xZCc3S+x59caDOewxz8gph+CnsoGGTxrWvqWyz0F72eU4DczY2NbolyBLYlE/yL784Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NJ4ZmBoR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741190857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ryWkCCG9U7D/clkcoHvgWHB1rXveT/dQOyD5wDCrVfA=;
	b=NJ4ZmBoRM5irxCwfGATktkENXGlgRK1EbfC4gLfYXx/c8CKKRtw0YCg8hAnbUDrsmJvpN8
	ADpaNwVXFWdYRid4JNW0jQxOm5ZTEHDNlG1KE0u81AAOLHcRpiDp1kqWGN568Ra3sRMdGW
	pLCFzhZMfCaAkz7qS/9tunVvqqD25mo=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-2861gQf6Osm9J0Zm3kiYmg-1; Wed, 05 Mar 2025 11:07:26 -0500
X-MC-Unique: 2861gQf6Osm9J0Zm3kiYmg-1
X-Mimecast-MFC-AGG-ID: 2861gQf6Osm9J0Zm3kiYmg_1741190845
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-e54d9b54500so10076519276.3
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 08:07:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741190845; x=1741795645;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ryWkCCG9U7D/clkcoHvgWHB1rXveT/dQOyD5wDCrVfA=;
        b=uRirbCJ3tPpKVylDt7rAdtXOyaVGC/nj4B7lLqnHorvtpPwmtpSrwxhLRMnItWxaBL
         dlMTI+lwFPzAj98xbHg7R9AJkK8OBz3iLnQWF4HozbAez/BWHyVCi6/wx0pZBhZtC6HR
         pD5fpyf9tt2yTYPSDWroxGoDM2a5LgKpGtxVzh2dkYGsgNM7QuIcPJOz8iw/rEiKct/t
         8HtIby/JmWmhMQ5qL0yrAxI2OeirUlZp++LSEBqSvDmffnKEF+ZaJnJVT4UA1V2Tgdml
         nGLoPPRhOCK7xDc4iPM2Wi2TVL7A+zRIsBkJYd/T47RIPlkEilXt6giegzMgF3jUzQy+
         HN0g==
X-Forwarded-Encrypted: i=1; AJvYcCWoLxdMBZN4Q7phNqxdJv6DmYrG9mZxfBFwkq6Bz5cIbibjoiYpYxX+e0U8rfhLe7KENWU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqrmCNQCA3IYvJN6nHDCmkXvMCD2gEHji0Gakc8eRPl+ubPjsR
	nB+UoJ8oYNwXkg9Et9AGKQqokR9rUeVZNFgYhAPBdWbCJ5infatkBzhk7kZbQSd6QNXtc8bNEqv
	YMjcrfuRXDYL1ttCzwojVjBCg9PFUZmYTR2SBYSHaM4P9VQNMV8SMDAPcS+tFdQBGApul5+EQxh
	GEfGVVDserR7MK9xIuHu62dhE2
X-Gm-Gg: ASbGncs+Pn0YVUolwJ4CRDCzAsFVJuLWbJjlrqQsXN9oKw7hZSHUVlfvFQnwcRsHkdq
	1lUR3F+TAX0466evNK7jy2YAYKg/Q2mgSnsNjTaqIWBQxpSzxomn0SuUSW+TPtxIYGmaRrgU=
X-Received: by 2002:a05:6902:2b04:b0:e3a:228f:b6ae with SMTP id 3f1490d57ef6-e611e31b361mr4939466276.28.1741190845404;
        Wed, 05 Mar 2025 08:07:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUAS6WwP66wpVRH9zM8tONfKYOINgZVsEogrnYLnEVbUemjVXbmLZS/WKWOoZP10KvvEaRYVNTgnvohXgwyFk=
X-Received: by 2002:a05:6902:2b04:b0:e3a:228f:b6ae with SMTP id
 3f1490d57ef6-e611e31b361mr4939380276.28.1741190844684; Wed, 05 Mar 2025
 08:07:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20200116172428.311437-1-sgarzare@redhat.com> <20200116172428.311437-2-sgarzare@redhat.com>
 <20250305022900-mutt-send-email-mst@kernel.org> <CAGxU2F5C1kTN+z2XLwATvs9pGq0HAvXhKp6NUULos7O3uarjCA@mail.gmail.com>
 <Z8hzu3+VQKKjlkRN@devvm6277.cco0.facebook.com>
In-Reply-To: <Z8hzu3+VQKKjlkRN@devvm6277.cco0.facebook.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 5 Mar 2025 17:07:13 +0100
X-Gm-Features: AQ5f1JpJL5yP-_Z0xQeVD2Y1zot7Sg-rzWoskaP0DYpCjrRwMKzDiyskEoI2Ozg
Message-ID: <CAGxU2F5EBpC1z7QY1VoPewxgEy3zU7P1nZH48PtOV1BtgN=Eyg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jorgen Hansen <jhansen@vmware.com>, Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux-foundation.org, 
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Mar 2025 at 16:55, Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
>
> On Wed, Mar 05, 2025 at 10:23:08AM +0100, Stefano Garzarella wrote:
> > On Wed, 5 Mar 2025 at 08:32, Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
>
> [...]
>
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
>
> Do you know of any use cases for guest-side vsock netns?

Yep, as I mentioned in another mail this morning, the use case is
nested VMs or containers running in the L1 guests.
Users (e.g. Kata) would like to hide the L0<->L1 vsock channel in the
container, so anything running there can't talk with the L0 host.

BTW we can do that incrementally if it's too complicated.

>
> Our use case is also host-side. vsock is used to communicate with a
> host-side shim/proxy/debug console. Each vmm and these components share
> a namespace and are isolated from other vmm + components. The VM
> connects back to the host via vsock after startup and communicates its
> port of choice out-of-band (fw_cfg).  The main problem is in security:
> untrusted VM programs can potentially connect with and exploit the
> host-side vsock services meant for other VMs. If vsock respected
> namespaces, then these host-side services would be unreachable by other
> VMs and protected.  Namespaces would also allow the vsock port to be
> static across VMs, and avoid the need for the out-of-band mechanism for
> communicating the port.

Yeah, I see.

Thanks,
Stefano

>
> Jakub can jump in to add anything, but I think this is the same use case
> / user he was probably referring to.
>
> Best,
> Bobby
>


