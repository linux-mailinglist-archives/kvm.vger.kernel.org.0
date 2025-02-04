Return-Path: <kvm+bounces-37218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 322DCA26EEE
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 11:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A78641658C3
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146A4209F52;
	Tue,  4 Feb 2025 10:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e0vtwYCk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F70C207E16
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 10:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738663206; cv=none; b=dHGubl53GJW7P5UvxktEtSX7I0rCRB0JuV1CsI8X2lCrU/p/WoAvVVmtF9I1SI2JTKMMgRbX0/0RMH6S125yOnIHHSrBI+5PSAE40zygwCQ5/TZK2cDFWpK6OatRZwwc/R4068WyEnAFosSptJPIpLgBqHrT3LbjWn5Be14ok/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738663206; c=relaxed/simple;
	bh=13yYCdlqzP0i/IMnvVFj2IM29vtkaVbgxxGjD98q0uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbUv6S8SSfa7r/DCG7WMNxW7gJAcxUddKFYh1VvruRgQ3F7wrf5Lf7R9U8lxFPFvfRyGm0eBwesjiL0NX/xwhovJeBXzOulnPNw6KlPPbxJjNA81WakJrOFtYvXnJ0nU+Z72gMXGWQabZGkYD2pQcn3V0wM2auqlMGcupBslpG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e0vtwYCk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738663203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgeNydwTSVAcIR1ERMtZzBL7x3bZ2CBWxaGQ1arPFzQ=;
	b=e0vtwYCkpOGR8m9MsCv6B/4gyKpbBHFaINEQ82b7ZAxpJU7/TDt9OYOOAmSBHtcaauuT9I
	ibz7Wbfow0Bo4Qf6/J+QKviAgbCyF99GVf4fvz+vO3dC0l4wMfSklJHp4pTVmdsGXZ9G3O
	uHzIvyGqxrlWYdFYQpmo465UF2UKgeQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-QLW4TiThMdOtd3w-QXkrfg-1; Tue, 04 Feb 2025 05:00:01 -0500
X-MC-Unique: QLW4TiThMdOtd3w-QXkrfg-1
X-Mimecast-MFC-AGG-ID: QLW4TiThMdOtd3w-QXkrfg
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38c24ac3706so3699910f8f.0
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 02:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738663200; x=1739268000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zgeNydwTSVAcIR1ERMtZzBL7x3bZ2CBWxaGQ1arPFzQ=;
        b=e8dodogbvQr/b2M6gqYSNGLnhA1Y+ivjT/Jp96yUim0+E+NDblOxxR2WUlYjqj309B
         1b84MDQKqRspmErWpSdMVPMtgWRXzo9+vvdnvMlvv9qbYvXJL4pPmrGehf1q9bz3JLGu
         gGUr0YcEMYA5YsMLCwDA5WeHoKKqSzqDndj0k/w2OQFZgORsNkTt/PnDccCnXyAfDSfA
         mlRJAqn7Iu5q5Dm/eHr5gInQpIliLbPvq37rT+8WTMZnptoL/4Ws4NHLOdAbwMk9RBVy
         8d7t1LVmoKpJ8XQu3BfD1tYcs9lnr/sEt0qDtQgkmmvFuBLDfbNXveQfZx9H1a/F15t9
         zZ+w==
X-Forwarded-Encrypted: i=1; AJvYcCVAZqQYuuagUWyYd4Du2nTB3hRM29g8uFDQfGU1Z8KNaf6NP+8AnPiUCnHhG7VMS1+ciUI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/d6LInDr6BWVSAWmM0JBy92pqg4u1BLMYMTUXw/nTq6UfeU3Z
	RqrwLfQKMrCleWSB9lQwpSlGSwhGsL3a4R+O4gTFAyW0zkUmeXzGDLK49QZHqMW9FYHXXweMVT0
	hS2M4X60IicoFqK/mL71+NspvLbNSk/Ps/etlIkL6l31EfoHUUA==
X-Gm-Gg: ASbGncsh3d2onWYyL7/eX7AYqBThzRHjvGC10Q70yKrIYuC+32jexO0IkOh0Lxh+wil
	2w71QtRJtWqDFojaLXdX4eaYoyvOX1owSc8GHgKK8O1l0/IhmW16FU3yCr5XYgN6ni6g0MppVdm
	+gfdK+NsKrP97J4wqTWKxljzCIf7PR5wxTBC16uynfX14IUn/+DKA3RNZuAjKL0E4AvLxIuTdER
	acByJH8oF5x4JeyS1Vct/81Obi8y/FkriRBrIg3p6RskxXv7rmYps61kAL/Koj1DPTTWillJtou
	4Y4iRa5pgg==
X-Received: by 2002:a05:6000:1a8c:b0:38c:5bb2:b932 with SMTP id ffacd0b85a97d-38c5bb2bc01mr15890537f8f.3.1738663200396;
        Tue, 04 Feb 2025 02:00:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHip7X4zS0O52PMEjczmtT0iNBH7IEeL8QYtKHFPjqYHRGplFJ791FYs65FAXVNjmO63CfRDA==
X-Received: by 2002:a05:6000:1a8c:b0:38c:5bb2:b932 with SMTP id ffacd0b85a97d-38c5bb2bc01mr15890363f8f.3.1738663199563;
        Tue, 04 Feb 2025 01:59:59 -0800 (PST)
Received: from sgarzare-redhat ([185.121.209.52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc6df51sm223944825e9.30.2025.02.04.01.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 01:59:59 -0800 (PST)
Date: Tue, 4 Feb 2025 10:59:55 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: syzbot <syzbot+9d55b199192a4be7d02c@syzkaller.appspotmail.com>, 
	davem@davemloft.net, edumazet@google.com, eperezma@redhat.com, horms@kernel.org, 
	jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	stefanha@redhat.com, syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev, 
	xuanzhuo@linux.alibaba.com
Subject: Re: [syzbot] [net?] general protection fault in add_wait_queue
Message-ID: <6fonjxxkozzmv7huzavck5nsfivx3nsyyicthulg5aiyrmjpql@o7pexllumdxt>
References: <67a09300.050a0220.d7c5a.008b.GAE@google.com>
 <2483d8c1-961e-4a7f-9ce7-ffd21a380c70@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2483d8c1-961e-4a7f-9ce7-ffd21a380c70@rbox.co>

On Tue, Feb 04, 2025 at 01:38:50AM +0100, Michal Luczaj wrote:
>On 2/3/25 10:57, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    c2933b2befe2 Merge tag 'net-6.14-rc1' of git://git.kernel...
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=16f676b0580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
>> dashboard link: https://syzkaller.appspot.com/bug?extid=9d55b199192a4be7d02c
>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13300b24580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12418518580000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/c7667ae12603/disk-c2933b2b.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/944ca63002c1/vmlinux-c2933b2b.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/30748115bf0b/bzImage-c2933b2b.xz
>>
>> The issue was bisected to:
>>
>> commit fcdd2242c0231032fc84e1404315c245ae56322a
>> Author: Michal Luczaj <mhal@rbox.co>
>> Date:   Tue Jan 28 13:15:27 2025 +0000
>>
>>     vsock: Keep the binding until socket destruction
>
>syzbot is correct (thanks), bisected commit introduced a regression.
>
>sock_orphan(sk) is being called without taking into consideration that it
>does `sk->sk_wq = NULL`. Later, if SO_LINGER is set, sk->sk_wq gets
>dereferenced in virtio_transport_wait_close().
>
>Repro, as shown by syzbot, is simply
>from socket import *
>lis = socket(AF_VSOCK, SOCK_STREAM)
>lis.bind((1, 1234)) # VMADDR_CID_LOCAL
>lis.listen()
>s = socket(AF_VSOCK, SOCK_STREAM)
>s.setsockopt(SOL_SOCKET, SO_LINGER, (1<<32) | 1)
>s.connect(lis.getsockname())
>s.close()
>
>A way of fixing this is to put sock_orphan(sk) back where it was before the
>breaking patch and instead explicitly flip just the SOCK_DEAD bit, i.e.
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 075695173648..06250bb9afe2 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -824,13 +824,14 @@ static void __vsock_release(struct sock *sk, int level)
> 	 */
> 	lock_sock_nested(sk, level);
>
>-	sock_orphan(sk);
>+	sock_set_flag(sk, SOCK_DEAD);
>
> 	if (vsk->transport)
> 		vsk->transport->release(vsk);
> 	else if (sock_type_connectible(sk->sk_type))
> 		vsock_remove_sock(vsk);
>
>+	sock_orphan(sk);
> 	sk->sk_shutdown = SHUTDOWN_MASK;
>
> 	skb_queue_purge(&sk->sk_receive_queue);
>
>I'm not sure this is the most elegant code (sock_orphan(sk) sets SOCK_DEAD
>on a socket that is already SOCK_DEAD), but here it goes:
>https://lore.kernel.org/netdev/20250204-vsock-linger-nullderef-v1-0-6eb1760fa93e@rbox.co/

What about the fix proposed here:
https://lore.kernel.org/lkml/20250203124959.114591-1-aha310510@gmail.com/

>
>One more note: man socket(7) says lingering also happens on shutdown().
>Should vsock follow that?

Good point, I think so.
IMHO we should handle both of them in af_vsock.c if it's possible, but 
maybe we need a bit of refactoring.

Anyway, net-next material, right?

Stefano


