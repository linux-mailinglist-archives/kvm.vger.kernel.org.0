Return-Path: <kvm+bounces-37190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29946A268AD
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:39:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0DC8164B6A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56DB5588F;
	Tue,  4 Feb 2025 00:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="DpYosRJc"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9251135967;
	Tue,  4 Feb 2025 00:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629541; cv=none; b=URmlk/PQo8WaDMscNMC//+0eJnvo51KzsW4EGGj3BMT1ePo2V3DlRyUkVuJ0GSsWRS4z2hUtT3UZisjsAk2bvkS8SmuyoXBYeINA4Hr2Ps9vgyYzG50UuaKwSVa1UCExff9fszVVrBwZ/bNLa5OjPLRop6qTbRhuTRLD224gwhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629541; c=relaxed/simple;
	bh=qqUzgKhHScE444ZEVKHRDjr25RN4mxSC78RL8vcnbQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nsS5n+2xVRuiLED/kaHtfEGsh9k8yh+pordeHc9vWy21zn5VmnO0/h2y1oUBEzoMZpYCiZuSZAWU/VyVRkk9yXblaKqu4d7OprBQkb1mXQKm9+kN8kEZ2YzbCWqcwBFFV/e6nSjBDW56ZcHkgZf569VXFF/lQlMKECZ2JxXpW+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=DpYosRJc; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tf6xq-0036Cx-Gz; Tue, 04 Feb 2025 01:38:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:To:Subject:MIME-Version:Date:Message-ID;
	bh=dWhldEl84XQnzj0ZoD/mIlvrsqSqj2zylkLiRosKi9I=; b=DpYosRJc0iE9zKJOvFSxRbHEWs
	2CmwQvU+GF7G6R1R4slN3Y51XsUd3V7GYafTjJAumzMFZeR4bZefaBVvwbD31lfUy2RPN1+jX7j4S
	5xb2rF7C95MyYhFvgo7meRf/S0DeptHZZgOWN56Wdq9h5I/2OSt0nxthRYNIT0N1BgAoHcSe3D54z
	+FObXVdzZS1GpLXVd9i6aEpmWjGR87ea/HJQ1lpsX8zBwdgpih4Th0OX//iQlVVUqpNgJebExb7Jc
	uiXjWk116kTm9Jbntu+R/rWYtVnpj37bF2if0u8PYBdapRwbCtv+9OCTBJzQ8vNTYMqBs+e6YV52l
	4Q00UK/g==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tf6xp-0004P7-EI; Tue, 04 Feb 2025 01:38:53 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tf6xn-006crP-HS; Tue, 04 Feb 2025 01:38:51 +0100
Message-ID: <2483d8c1-961e-4a7f-9ce7-ffd21a380c70@rbox.co>
Date: Tue, 4 Feb 2025 01:38:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [net?] general protection fault in add_wait_queue
To: syzbot <syzbot+9d55b199192a4be7d02c@syzkaller.appspotmail.com>,
 davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
 horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
 pabeni@redhat.com, sgarzare@redhat.com, stefanha@redhat.com,
 syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev,
 xuanzhuo@linux.alibaba.com
References: <67a09300.050a0220.d7c5a.008b.GAE@google.com>
From: Michal Luczaj <mhal@rbox.co>
Content-Language: pl-PL, en-GB
In-Reply-To: <67a09300.050a0220.d7c5a.008b.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 10:57, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c2933b2befe2 Merge tag 'net-6.14-rc1' of git://git.kernel...
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16f676b0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
> dashboard link: https://syzkaller.appspot.com/bug?extid=9d55b199192a4be7d02c
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13300b24580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12418518580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c7667ae12603/disk-c2933b2b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/944ca63002c1/vmlinux-c2933b2b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/30748115bf0b/bzImage-c2933b2b.xz
> 
> The issue was bisected to:
> 
> commit fcdd2242c0231032fc84e1404315c245ae56322a
> Author: Michal Luczaj <mhal@rbox.co>
> Date:   Tue Jan 28 13:15:27 2025 +0000
> 
>     vsock: Keep the binding until socket destruction

syzbot is correct (thanks), bisected commit introduced a regression.

sock_orphan(sk) is being called without taking into consideration that it
does `sk->sk_wq = NULL`. Later, if SO_LINGER is set, sk->sk_wq gets
dereferenced in virtio_transport_wait_close().

Repro, as shown by syzbot, is simply
from socket import *
lis = socket(AF_VSOCK, SOCK_STREAM)
lis.bind((1, 1234)) # VMADDR_CID_LOCAL
lis.listen()
s = socket(AF_VSOCK, SOCK_STREAM)
s.setsockopt(SOL_SOCKET, SO_LINGER, (1<<32) | 1)
s.connect(lis.getsockname())
s.close()

A way of fixing this is to put sock_orphan(sk) back where it was before the
breaking patch and instead explicitly flip just the SOCK_DEAD bit, i.e.

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 075695173648..06250bb9afe2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -824,13 +824,14 @@ static void __vsock_release(struct sock *sk, int level)
 	 */
 	lock_sock_nested(sk, level);
 
-	sock_orphan(sk);
+	sock_set_flag(sk, SOCK_DEAD);
 
 	if (vsk->transport)
 		vsk->transport->release(vsk);
 	else if (sock_type_connectible(sk->sk_type))
 		vsock_remove_sock(vsk);
 
+	sock_orphan(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	skb_queue_purge(&sk->sk_receive_queue);

I'm not sure this is the most elegant code (sock_orphan(sk) sets SOCK_DEAD
on a socket that is already SOCK_DEAD), but here it goes:
https://lore.kernel.org/netdev/20250204-vsock-linger-nullderef-v1-0-6eb1760fa93e@rbox.co/

One more note: man socket(7) says lingering also happens on shutdown().
Should vsock follow that?

Thanks,
Michal


