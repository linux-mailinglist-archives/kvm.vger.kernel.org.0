Return-Path: <kvm+bounces-35275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DF00A0B262
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CE411675BA
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 09:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE3323875D;
	Mon, 13 Jan 2025 09:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RW/FiS7J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3181237A24
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 09:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736759266; cv=none; b=MelmWKAk/8QCEd6InURGrgj8WZ3NDYTOkU+UPq4KP8uPjZX2mAMPktcyCCadc/vj3JgUPa7pFqQxLX79x97H8N0uBM+WsIGvN6kj+8xuvIoBbl20lTJsiIJK2akMHHgkYwpQvVE6lu1SgOXhfflKZeqtBIVh3zfdyZBL5w2Z54U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736759266; c=relaxed/simple;
	bh=6yDyyW0a6Ly6O8248teCrbgEXbOE+SVqdnWMzK9oNwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HjW8RW6kftK0GeAne6qrpF8Wpagu7wsbDVMdAoHLpzgw/4Z1GYWo0odLwlKSqmAgtIOkxz/aPGqPYGfhyxwPO24UoTJkFxdv3dJ+cwL/tUh7NhmMr8g1DlP/9RTqN3CtDCsFk4uzF3m2jJdGCtkdTgsv0nQF+cFwGkMMlCIud+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RW/FiS7J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736759263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DoCA3mgR5luSoFMglhHAYVKxgoy3EGwdMDnuXoKHBSs=;
	b=RW/FiS7JhOnfjz9issLDEwrlrPppiFOHZzCkLS/ndVcNAHn88PbQZa8UhD8TCJOacLSpW4
	0BhTATgGw93u/JZXTcmfybTnJUqkWyTXG4e9PSQUuvglUtax0fk+jNBRr6jSaT8QXBkPIs
	tUbQBEpOCy8mHbAh0LBhroYJmazB3kg=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-mNKjAIqiPl-VfOR1XjdT7w-1; Mon, 13 Jan 2025 04:07:42 -0500
X-MC-Unique: mNKjAIqiPl-VfOR1XjdT7w-1
X-Mimecast-MFC-AGG-ID: mNKjAIqiPl-VfOR1XjdT7w
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-e02fff66a83so7920320276.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 01:07:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736759262; x=1737364062;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DoCA3mgR5luSoFMglhHAYVKxgoy3EGwdMDnuXoKHBSs=;
        b=hx99LfpJA3KB7wLnisN3FEB0TwZuSgRdM/JLVeASXCJP9L+lExLvGqfo27nDzXl2/M
         utljRiGvhW0sKunQDW7EnPSTKF9tHzHIRcsfmo4H03I2D3nCafuUSNmsiRbDRCTHBZ0w
         Fd227IzEVxcbFuOKZ5A4ocOUeK9tCUwNbI+zHqFDPah2I2PnoCZ3zRtU6pC2Udho9wC+
         AYurDyn9QqHfmBz33KI6Pttdszf9owpT72DJ9A5m9/cE1IuRDci4u6whXlCottEHCa2r
         F/3b+LNmtqzAt1Rs2DyMU/vUEOYArMj9Hg18yO2ExPUwdAPrKz18Khuw2bahQvfj9q77
         wThw==
X-Forwarded-Encrypted: i=1; AJvYcCVY38OYRBf9LdFCGEbv6NdVdabTW1PXjkYWVkuG4xnbjhXaTZdq6AAFW0fBFyyhMQfFnuM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb38oMFk5+PDBqkO12Go5mLcWmyMkvI8Vzhn9LJDU39+dOyi7e
	U/6yNxp8ou6NjHdBgll6wuM+s2bmdcBmIpPEQ/SkBo638Nykhs6lS49NsdOGBIeoD/Yb0MmcxqH
	F/FfALbQwfhRg4PzKEFL/yQ09S7b1aswI7/LW25lUJa5jrwAgIhy7CQLx4BWaZLWDZ2VpBynrgJ
	jfKFIYCwdrdPmJ+Uz0yv/KW+Xs
X-Gm-Gg: ASbGncu7Ga2/ARMH8Dni05MmFQkONLMpeNjnijePFMcDZM1CBP8I6QT9egMcBxiwjPG
	dZUEsGS6W+E9bslcTlhw5wiYi3r58h6WGnoGVgA==
X-Received: by 2002:a25:2104:0:b0:e47:f4e3:87e3 with SMTP id 3f1490d57ef6-e54edf25ca4mr10705875276.11.1736759261778;
        Mon, 13 Jan 2025 01:07:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+CmZ1v9e/WbMUz4yhx1sfIQirqoiE0T/w4GOD49eFf+cvd2Qrlw+zoWAPzA/qokVRzziYFs0iIh6kdpyEqho=
X-Received: by 2002:a25:2104:0:b0:e47:f4e3:87e3 with SMTP id
 3f1490d57ef6-e54edf25ca4mr10705852276.11.1736759261303; Mon, 13 Jan 2025
 01:07:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250110083511.30419-1-sgarzare@redhat.com> <20250110083511.30419-2-sgarzare@redhat.com>
 <1aa83abf-6baa-4cf1-a108-66b677bcfd93@rbox.co> <nedvcylhjxrkmkvgugsku2lpdjgjpo5exoke4o6clxcxh64s3i@jkjnvngazr5v>
In-Reply-To: <nedvcylhjxrkmkvgugsku2lpdjgjpo5exoke4o6clxcxh64s3i@jkjnvngazr5v>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Mon, 13 Jan 2025 10:07:30 +0100
X-Gm-Features: AbW1kvaVe4-Ehu2H7XpdFvk6JHj69SbGoUvKX4WzH9KRTtiYmUqWFms2gAxG3cY
Message-ID: <CAGxU2F7BoMNi-z=SHsmCV5+99=CxHo4dxFeJnJ5=q9X=CM3QMA@mail.gmail.com>
Subject: Re: [PATCH net v2 1/5] vsock/virtio: discard packets if the transport changes
To: Michal Luczaj <mhal@rbox.co>
Cc: netdev@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Leonardi <leonardi@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Wongi Lee <qwerty@theori.io>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Eric Dumazet <edumazet@google.com>, kvm@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Simon Horman <horms@kernel.org>, Hyunwoo Kim <v4bel@theori.io>, 
	Jakub Kicinski <kuba@kernel.org>, virtualization@lists.linux.dev, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Jan 2025 at 09:57, Stefano Garzarella <sgarzare@redhat.com> wrote:
> On Sun, Jan 12, 2025 at 11:42:30PM +0100, Michal Luczaj wrote:

[...]

> >
> >So, if I get this right:
> >1. vsock_create() (refcnt=1) calls vsock_insert_unbound() (refcnt=2)
> >2. transport->release() calls vsock_remove_bound() without checking if sk
> >   was bound and moved to bound list (refcnt=1)
> >3. vsock_bind() assumes sk is in unbound list and before
> >   __vsock_insert_bound(vsock_bound_sockets()) calls
> >   __vsock_remove_bound() which does:
> >      list_del_init(&vsk->bound_table); // nop
> >      sock_put(&vsk->sk);               // refcnt=0
> >
> >The following fixes things for me. I'm just not certain that's the only
> >place where transport destruction may lead to an unbound socket being
> >removed from the unbound list.
> >
> >diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >index 7f7de6d88096..0fe807c8c052 100644
> >--- a/net/vmw_vsock/virtio_transport_common.c
> >+++ b/net/vmw_vsock/virtio_transport_common.c
> >@@ -1303,7 +1303,8 @@ void virtio_transport_release(struct vsock_sock *vsk)
> >
> >       if (remove_sock) {
> >               sock_set_flag(sk, SOCK_DONE);
> >-              virtio_transport_remove_sock(vsk);
> >+              if (vsock_addr_bound(&vsk->local_addr))
> >+                      virtio_transport_remove_sock(vsk);
>
> I don't get this fix, virtio_transport_remove_sock() calls
>    vsock_remove_sock()
>      vsock_remove_bound()
>        if (__vsock_in_bound_table(vsk))
>            __vsock_remove_bound(vsk);
>
>
> So, should already avoid this issue, no?

I got it wrong, I see now what are you trying to do, but I don't think
we should skip virtio_transport_remove_sock() entirely, it also purge
the rx_queue.

>
> Can the problem be in vsock_bind() ?
>
> Is this issue pre-existing or introduced by this series?

I think this is pre-existing, can you confirm?

In that case, I'd not stop this series, and fix it in another patch/series.

Thanks,
Stefano


