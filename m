Return-Path: <kvm+bounces-37219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDFF1A26EFE
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 11:04:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DD57188759E
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B63420AF77;
	Tue,  4 Feb 2025 10:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M9FquosY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59FD2080C1
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 10:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738663463; cv=none; b=MooPqPqPeupU3/rN0/VoV3UepbjYIUTnrncRpSUF3GsD58kxW2kyIStWsgvfGs53qvRW605MGz41H2LwV3t0TqYDlug6PSlWjWyZFcOy+MX9Bo5ePWPLC7TynZxHaXuDe1drlFRp9AvVnesLted+o31uJmHGirmKG7CkMWmknhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738663463; c=relaxed/simple;
	bh=mUDPToLx4m1t4OQh7RaNx1yOyqPbXSxV/uwU5GCkTBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MdjmT6kEyG664Q+/urFUY0WNTIti2YXtVuVN0VxR9hUoAN0x17ClPOJl8MUcrHWsuKv7rkvcOLY+srz/rrfxuf6+FSGOopJ2hsgu8SoKLxJdNGgV5cJPVnBQTyP/IUJQ1xDVvnj8OjGVrqQ1jpOWP1tEIiofnTGi9CGOD7ZD/VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M9FquosY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738663460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r7QifqPZ9eDjVzOXnGpRwU072WD973YhoUOHzvFP/XY=;
	b=M9FquosYi9QQY/jH06O6IG/48gOVXq2nk3kv4o9RyHWAG6tNYoqynjiuEDCnnLf4hfqB4i
	mIvixgvDJKd2rqAWHxmAZpc2uI+J1vcLTnzH9mbaC1BVt4AiUcQ+5tx7n4fI0UD9Fcj/vl
	w/tsn3W3R3/pGmbPTGWt/Uw1dd39pps=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-g58czdutOHGIstXKduG2kw-1; Tue, 04 Feb 2025 05:04:19 -0500
X-MC-Unique: g58czdutOHGIstXKduG2kw-1
X-Mimecast-MFC-AGG-ID: g58czdutOHGIstXKduG2kw
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6f4239246ccso45221177b3.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 02:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738663457; x=1739268257;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r7QifqPZ9eDjVzOXnGpRwU072WD973YhoUOHzvFP/XY=;
        b=DSGvkqh7GcIpVkZsaMmWsruZLua7Ouhg5fza/ATEcxZVFBQtQVtcwoe6+d6x14uOTe
         2bNCnYiCfK81dJ6mBGRX0T14jUlgr+1tWMJWnuM1GjxKzUf5o1KGlPwYgIsPVQyL1aHZ
         H7KOO369A7ORktY3QJgrk7l1iHNaVNujcTrzh94wq9RNo2aIzi02BI1se8nS3298Zgte
         yKoCQy6Zm4tz+MX6dFOgH/5kd5OxjIjKxgiXVuBNvQUL2v5RcuKWNvrnXPozpMFz7H9l
         ib3A2l4er1YO73IRYZL8oWQnJEaUbCQBEQ22ObMOjKLHbquhViZllhBzQV/I7i0I2PZP
         /A7g==
X-Forwarded-Encrypted: i=1; AJvYcCXdEB5GarFCn6yLOlvNlddF1LrfIqRIwl8t+YYRiczcyEgHFIGA0GaDrA2QKXdjQR6+aCs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMdgUjGqjb1f1Xuhj/BPv8F6X/06WEy83zryJtomP8WygwwWs6
	YSNHjfYfb849ryERdVVlSRtEejVGxreq0Ylp/RNZSYHBvca+jGM2TA1s2gDUxPGV1sn68EmReSm
	9iJ0mUK1cQlYx6Cd8qYx+iVqbUXLPc/TfgAl+u3LEPGhosWQEwZzhHjSQtUJ+VhpHwUDYr5Di1n
	Z0U3DPPzqygiOI/UciADfkoxeC
X-Gm-Gg: ASbGncvWOF13+vk1topnEUQT+69ECIsUPiI5n/rnp3g/TpvJBXEifwkY35CrrJ3Tthx
	sFEadqQ4bMRwepi4u+jNhgHBDkkikL4h6W5pOxFb8TFuxM8QVS8xywMWJ6c4Sxr8=
X-Received: by 2002:a05:690c:c99:b0:6f6:7ef2:fe74 with SMTP id 00721157ae682-6f7a8426a5dmr187992757b3.32.1738663457124;
        Tue, 04 Feb 2025 02:04:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGObxnJlWUNYcPLXX3gTTHlz8ygcPRSBCSw4ZNWGPq56uQbjLmdeK3NSXxsGvATRJ7AZmu/F90tI28ywSsg0b4=
X-Received: by 2002:a05:690c:c99:b0:6f6:7ef2:fe74 with SMTP id
 00721157ae682-6f7a8426a5dmr187992617b3.32.1738663456785; Tue, 04 Feb 2025
 02:04:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67a09300.050a0220.d7c5a.008b.GAE@google.com> <2483d8c1-961e-4a7f-9ce7-ffd21a380c70@rbox.co>
 <6fonjxxkozzmv7huzavck5nsfivx3nsyyicthulg5aiyrmjpql@o7pexllumdxt>
In-Reply-To: <6fonjxxkozzmv7huzavck5nsfivx3nsyyicthulg5aiyrmjpql@o7pexllumdxt>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Tue, 4 Feb 2025 11:04:04 +0100
X-Gm-Features: AWEUYZkRpQsQ3lL4HaavFbVzIcqyxyzO3RF8AiDQcOZb6x_hIpX856jwrL1eacs
Message-ID: <CAGxU2F7CgVHUuPPATBzXw20fR1Z+MVpsJvgRO=kMFV1nis49SQ@mail.gmail.com>
Subject: Re: [syzbot] [net?] general protection fault in add_wait_queue
To: Michal Luczaj <mhal@rbox.co>
Cc: syzbot <syzbot+9d55b199192a4be7d02c@syzkaller.appspotmail.com>, 
	davem@davemloft.net, edumazet@google.com, eperezma@redhat.com, 
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, stefanha@redhat.com, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Feb 2025 at 10:59, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Tue, Feb 04, 2025 at 01:38:50AM +0100, Michal Luczaj wrote:
> >On 2/3/25 10:57, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    c2933b2befe2 Merge tag 'net-6.14-rc1' of git://git.kernel...
> >> git tree:       net-next
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=16f676b0580000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=9d55b199192a4be7d02c
> >> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13300b24580000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12418518580000
> >>
> >> Downloadable assets:
> >> disk image: https://storage.googleapis.com/syzbot-assets/c7667ae12603/disk-c2933b2b.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/944ca63002c1/vmlinux-c2933b2b.xz
> >> kernel image: https://storage.googleapis.com/syzbot-assets/30748115bf0b/bzImage-c2933b2b.xz
> >>
> >> The issue was bisected to:
> >>
> >> commit fcdd2242c0231032fc84e1404315c245ae56322a
> >> Author: Michal Luczaj <mhal@rbox.co>
> >> Date:   Tue Jan 28 13:15:27 2025 +0000
> >>
> >>     vsock: Keep the binding until socket destruction
> >
> >syzbot is correct (thanks), bisected commit introduced a regression.
> >
> >sock_orphan(sk) is being called without taking into consideration that it
> >does `sk->sk_wq = NULL`. Later, if SO_LINGER is set, sk->sk_wq gets
> >dereferenced in virtio_transport_wait_close().
> >
> >Repro, as shown by syzbot, is simply
> >from socket import *
> >lis = socket(AF_VSOCK, SOCK_STREAM)
> >lis.bind((1, 1234)) # VMADDR_CID_LOCAL
> >lis.listen()
> >s = socket(AF_VSOCK, SOCK_STREAM)
> >s.setsockopt(SOL_SOCKET, SO_LINGER, (1<<32) | 1)
> >s.connect(lis.getsockname())
> >s.close()
> >
> >A way of fixing this is to put sock_orphan(sk) back where it was before the
> >breaking patch and instead explicitly flip just the SOCK_DEAD bit, i.e.
> >
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index 075695173648..06250bb9afe2 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -824,13 +824,14 @@ static void __vsock_release(struct sock *sk, int level)
> >        */
> >       lock_sock_nested(sk, level);
> >
> >-      sock_orphan(sk);
> >+      sock_set_flag(sk, SOCK_DEAD);
> >
> >       if (vsk->transport)
> >               vsk->transport->release(vsk);
> >       else if (sock_type_connectible(sk->sk_type))
> >               vsock_remove_sock(vsk);
> >
> >+      sock_orphan(sk);
> >       sk->sk_shutdown = SHUTDOWN_MASK;
> >
> >       skb_queue_purge(&sk->sk_receive_queue);
> >
> >I'm not sure this is the most elegant code (sock_orphan(sk) sets SOCK_DEAD
> >on a socket that is already SOCK_DEAD), but here it goes:
> >https://lore.kernel.org/netdev/20250204-vsock-linger-nullderef-v1-0-6eb1760fa93e@rbox.co/
>
> What about the fix proposed here:
> https://lore.kernel.org/lkml/20250203124959.114591-1-aha310510@gmail.com/

mmm, nope, that one will completely bypass the lingering, right?

Stefano

>
> >
> >One more note: man socket(7) says lingering also happens on shutdown().
> >Should vsock follow that?
>
> Good point, I think so.
> IMHO we should handle both of them in af_vsock.c if it's possible, but
> maybe we need a bit of refactoring.
>
> Anyway, net-next material, right?
>
> Stefano


