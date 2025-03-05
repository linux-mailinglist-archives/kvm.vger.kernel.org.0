Return-Path: <kvm+bounces-40148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DAB7A4FA03
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 10:29:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D3EA3A2504
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 09:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0289020468D;
	Wed,  5 Mar 2025 09:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RdA0SmoI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4E718C337
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 09:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741166940; cv=none; b=ni/SYdDL251OLx6LUBPgc7dp/2J0bgbZsoInQ4TVrvLHXxxajotbQLsugqShIQZBrP+KZsOusFFr+j3AVs9gRdz6nxG7jIUcOB8cF0hf8i/aqyvbSzJoHaYzof2bjZRqkWMuUQi7Om6wsqT023EQaUjnTYwWTO86h+JV4mXPSAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741166940; c=relaxed/simple;
	bh=3RyfPyCJa/tpuKGOY4+lgz/0CKbtUzXOOAWxjU4A/sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SH75ib6zTrIU4zrGgy9iOkSItAdMPdBaX7FFrKzbdwcDomuimH3XvVWIZzswGo/lcQy8zxsvDJMvkMZ/MBIXvmbyzMjp0KBT1lXQ9qY85q/mKMmH2F2OsKbJdoDLourz/lA50grvpgOyF3VxG0I40b9Ah4mUwKGLuO6lrlXD1zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RdA0SmoI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741166937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FTeYQGmJeU97hLjZUQj6XASwjS9zaIwc0VW0y5NqZ+Y=;
	b=RdA0SmoI+lmJ6k9qVwdSfB5zXDPSUuEQOI3xCKUXnD/HzFfBoglCS2zCu45c2mZdMiDIjY
	0yfO4dIfPVKgMCmuTRQ7Qv3olsvQoNHMVAqL9h8lD7Z6rzBrXWmxQwSLuYojxkHigM7Lr9
	045dWP0SP9JR6ZE7XxiA0nx8koP3DCU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-Thndzc5TNmamdz590LQ7Nw-1; Wed, 05 Mar 2025 04:28:55 -0500
X-MC-Unique: Thndzc5TNmamdz590LQ7Nw-1
X-Mimecast-MFC-AGG-ID: Thndzc5TNmamdz590LQ7Nw_1741166934
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39104a3b8e3so2581261f8f.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 01:28:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741166934; x=1741771734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FTeYQGmJeU97hLjZUQj6XASwjS9zaIwc0VW0y5NqZ+Y=;
        b=hOrAlhI1SeZSlzoU+mD8tFNOPBS2+K3XaeZIYGMV6a7xIXtpMX/7yHm1pZDJYWEbBn
         zHB9DOLH9FdDnxT1lSHkrxlRCDNb0zDkE2hF/Q8ceqpM0adBLbpPCHgqQzyVxEZivOLA
         Q7cyj34O3C2g2F0tuvXZgN+v1Wc11lc0NPR85YvwPTuFc/G+5IeAwR8DQxNCRDJnWFyJ
         NK5i6sh8/99+MZVe9mYWVveNIm2s9xZ8SWqX2pBBFzTD2CX0llZsrqceK4w7lNbyjUMq
         2CLU2ZA7P873Eom6NgRBvpZk/UrBpzdIL9NRZyY/aJaFllF25UC5NZ2p+MH18Niq6xLq
         G74Q==
X-Forwarded-Encrypted: i=1; AJvYcCW+u6CagJ6utr0O72zBbvURpuPdeAYVMwEmQAxcZElAykr5Ujv4IqUnIfb0zjnynV9P9xs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyTzmPpBMEiFRZwhYWOx3LrC05Fo46UZDdhtcC0jgEKBPrnjlG
	IUZgx0kS4kGasZJkDo+y4eteurgz49vpWARdCUeEDAk1LME+nGjmLTxyQNJwpIGFI14P2UCQNVG
	rmUTcTjUEcWn2VWIKoG+wxm/XP2Pky+8e7naPaqXyLG8a08a45w==
X-Gm-Gg: ASbGnctN6SqklRuABRBcKanAeyTnLBs1+rbWaWRV7FDZzosngVefPLw/nGZOpmEnJf5
	szSYiNNba7BpJTofWF+VB+43JOC+1DXqwD3Oyrja5hXs7tAxFQMEwRNQHdzBldLKiTo/dHfdCQ4
	z6hWcoaqe20VXE3dwmNxAFN7HKihpv0pLRWvBu/4uQSAmRZpr2QycfeS7rKBrlZOznCTS0Oqt6g
	8K5dD0lqVLOvl5VHl6q3zxNpLw6HVzDvj2uYGRDfJhC3fxvLARntahPjI2pJF2dMZbJPA3euaRf
	i+zYBnICwQ==
X-Received: by 2002:a5d:64a2:0:b0:390:ee01:68fa with SMTP id ffacd0b85a97d-3911f741aa8mr1774265f8f.24.1741166934466;
        Wed, 05 Mar 2025 01:28:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFqbiZg1q9NO5z1obiHx6s5lNrsAIzRTkNZH2/z7S8MpItFePV0q3Z90uV+qtbX8GSklxWg6Q==
X-Received: by 2002:a5d:64a2:0:b0:390:ee01:68fa with SMTP id ffacd0b85a97d-3911f741aa8mr1774238f8f.24.1741166934111;
        Wed, 05 Mar 2025 01:28:54 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd42c5b33sm12002165e9.22.2025.03.05.01.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 01:28:53 -0800 (PST)
Date: Wed, 5 Mar 2025 04:28:50 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jorgen Hansen <jhansen@vmware.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
	Bobby Eshleman <bobbyeshleman@gmail.com>
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
Message-ID: <20250305042757-mutt-send-email-mst@kernel.org>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200116172428.311437-2-sgarzare@redhat.com>
 <20250305022900-mutt-send-email-mst@kernel.org>
 <CAGxU2F5C1kTN+z2XLwATvs9pGq0HAvXhKp6NUULos7O3uarjCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F5C1kTN+z2XLwATvs9pGq0HAvXhKp6NUULos7O3uarjCA@mail.gmail.com>

On Wed, Mar 05, 2025 at 10:23:08AM +0100, Stefano Garzarella wrote:
> On Wed, 5 Mar 2025 at 08:32, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Jan 16, 2020 at 06:24:26PM +0100, Stefano Garzarella wrote:
> > > This patch adds a check of the "net" assigned to a socket during
> > > the vsock_find_bound_socket() and vsock_find_connected_socket()
> > > to support network namespace, allowing to share the same address
> > > (cid, port) across different network namespaces.
> > >
> > > This patch adds 'netns' module param to enable this new feature
> > > (disabled by default), because it changes vsock's behavior with
> > > network namespaces and could break existing applications.
> > > G2H transports will use the default network namepsace (init_net).
> > > H2G transports can use different network namespace for different
> > > VMs.
> >
> >
> > I'm not sure I understand the usecase. Can you explain a bit more,
> > please?
> 
> It's been five years, but I'm trying!
> We are tracking this RFE here [1].
> 
> I also add Jakub in the thread with who I discussed last year a possible 
> restart of this effort, he could add more use cases.
> 
> The problem with vsock, host-side, currently is that if you launch a VM 
> with a virtio-vsock device (using vhost) inside a container (e.g., 
> Kata), so inside a network namespace, it is reachable from any other 
> container, whereas they would like some isolation. Also the CID is 
> shared among all, while they would like to reuse the same CID in 
> different namespaces.
> 
> This has been partially solved with vhost-user-vsock, but it is 
> inconvenient to use sometimes because of the hybrid-vsock problem 
> (host-side vsock is remapped to AF_UNIX).
> 
> Something from the cover letter of the series [2]:
> 
>   As we partially discussed in the multi-transport proposal, it could
>   be nice to support network namespace in vsock to reach the following
>   goals:
>   - isolate host applications from guest applications using the same ports
>     with CID_ANY
>   - assign the same CID of VMs running in different network namespaces
>   - partition VMs between VMMs or at finer granularity
> 
> Thanks,
> Stefano
> 
> [1] https://gitlab.com/vsock/vsock/-/issues/2
> [2] https://lore.kernel.org/virtualization/20200116172428.311437-1-sgarzare@redhat.com/


Ok so, host side. I get it. And the problem with your patches is that
they affect the guest side. Fix that, basically.

-- 
MST


