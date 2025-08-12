Return-Path: <kvm+bounces-54512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E2DB2246C
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 12:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 700D3188A206
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 10:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E087623ED6A;
	Tue, 12 Aug 2025 10:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U4V/qELg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D6C296BAD
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 10:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754993757; cv=none; b=U2RndZVBvxfFqmk5EyoZunnZDxT/k+knQeP2oLmGuuHQmWhK2FEyuGgenSFUfoDbu322EP4YMqxjKISrHgSMTQ8/zEjMUMG0Cask9UuT2Wz50P1KEeXgcrLPmveQ5CY/lZLFn5UmeyM28fAKyF6tae4vIHHWDhk0zH+qvtZfWlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754993757; c=relaxed/simple;
	bh=upr5gTPfA5jEvog5a5LIT8yWlQej74MFP6ZeE5bVIUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFm/QUsY7/YlFjsoqQxE+TuIuN+GwDBOptb2b0x/6P2LgOzny9jTeS5l+vx67gsR5NwaNkXLPdNhdPwALZEw8KGx381g0BxvGROeKP6wJhF3ZBwz0bqP+QOz1SXTSjQF2uMfmgEmQMoPSxttHXuzVwuTS5nXWr6xd1dHQSlgfNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U4V/qELg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754993754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I6rPgfUZWncjHqWz3Gs2f0Po8oy+srlfPWRWaLP7/JA=;
	b=U4V/qELg2a7ZZn4uxmSG51dSdl3uAKKMA5UhkAXhLp55gpRcf/kIX0aQeC2R7Ae61twe+v
	kedf3dsNZhmWOUxFqn7id+WgomMPp53xsK4IBDTZpvDhqhOy5NzDn9WC83bhp8Pf0ZJ5c1
	dyzVbnzO88zGzhR+iaKC5SQaeyIGxDs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-b_TcKijwOLOkdZ9gL8aZlQ-1; Tue, 12 Aug 2025 06:15:53 -0400
X-MC-Unique: b_TcKijwOLOkdZ9gL8aZlQ-1
X-Mimecast-MFC-AGG-ID: b_TcKijwOLOkdZ9gL8aZlQ_1754993752
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459e30eeea3so35043495e9.0
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 03:15:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754993750; x=1755598550;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6rPgfUZWncjHqWz3Gs2f0Po8oy+srlfPWRWaLP7/JA=;
        b=XTYh7Dx8ImrZLc0uDkY7lQBnlJ1ymeRnUdDxKuNrjsNzV+/zvoXfhxUmootueWQk66
         gQdjUtLOQ1Yvw0uBTwNB/uxZsvf1SY4U3rreWXSPjKDd1rEGoDGENM7IxaLMm5eeu4SK
         bo/bbxsRKFerdbQCxmCa4Yuc/gXmTRwaHMv2dhe8MFDuxn+I12fyekY2Gm+jjCb2H44+
         0FuJ6DD/dGdZvU3OHRu6Hl41LJVekmJKqe12I2YhS1FbXqEqzqkz3X7uxhin/aZiFZIB
         fxhL8VgPHxwTrBXHdE/zt4epguyPfSkLGyp6nEKMMv443JyAGD0sSvpgKO+o4QO76mk3
         Glmw==
X-Forwarded-Encrypted: i=1; AJvYcCUsFYWM2phKwI0Re8t7xaXHlnVoZ86DTNvfTOdJAdPEKleC3mYwm9LKcgbDgFvIqI37x70=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxH3k0V4X8ySmiRY8CuOgQRTxZU8vKdokxDn+t3jxYqHzz1+2e
	GmbKGB30wfWxAG+i18sXSIx9at+Umvq1nBPHKSZkTidN6Yh6LiY8udw10HhDXZt08NO/FBIcghk
	FBPxFnPQsxRS5Md5/SZZbdJFeZYqTZurhwfXw0lwkamHNg5E4UsXnIA==
X-Gm-Gg: ASbGnct1qlQIJuOO6n1AFIQkjvewEll4mnTm49/Iljf3GOTMNiWO7LPh7uykjouiaWu
	KBMVbjtDhL2vnpRjwi5jjLGC/pkZvwO7qG4mhOSRn41yBbqD8bk9s+Y3gxEL6PK/XaO8c25Mj92
	ZzGu7EMegS/dRq5bvyh0NBSXHjBZKusWaaDzhqMBw9cX8ia9nlHM6TjfCPyWTKqAVgUHvJwNs6/
	5K1OPfyvlozND3GoAtMOz4RQBH8t6REhjusdGdYv0+xp4c0zUgSVmKmRDlav/CKqsEfd/KH8inx
	hhholsgASszgnML0tz4wJl8vuSxvfdkj
X-Received: by 2002:a05:600c:4f86:b0:456:3b21:ad1e with SMTP id 5b1f17b1804b1-459f4f1278dmr156943535e9.17.1754993750419;
        Tue, 12 Aug 2025 03:15:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4hpwCPxI92uHx8TgM/s0ZsgXXko7udMPgKR65VR2LmUddnVMaoV0RM5rKfkQhEswaG8878g==
X-Received: by 2002:a05:600c:4f86:b0:456:3b21:ad1e with SMTP id 5b1f17b1804b1-459f4f1278dmr156943275e9.17.1754993749988;
        Tue, 12 Aug 2025 03:15:49 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1515:7300:62e6:253a:2a96:5e3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459db3048bdsm393003455e9.29.2025.08.12.03.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 03:15:49 -0700 (PDT)
Date: Tue, 12 Aug 2025 06:15:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: syzbot <syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com, sgarzare@redhat.com,
	stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com,
	Will Deacon <will@kernel.org>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] WARNING in
 virtio_transport_send_pkt_info
Message-ID: <20250812061425-mutt-send-email-mst@kernel.org>
References: <20250812052645-mutt-send-email-mst@kernel.org>
 <689b1156.050a0220.7f033.011c.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689b1156.050a0220.7f033.011c.GAE@google.com>

On Tue, Aug 12, 2025 at 03:03:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in virtio_transport_send_pkt_info

OK so the issue triggers on
commit 6693731487a8145a9b039bc983d77edc47693855
Author: Will Deacon <will@kernel.org>
Date:   Thu Jul 17 10:01:16 2025 +0100

    vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
    

but does not trigger on:

commit 8ca76151d2c8219edea82f1925a2a25907ff6a9d
Author: Will Deacon <will@kernel.org>
Date:   Thu Jul 17 10:01:15 2025 +0100

    vsock/virtio: Rename virtio_vsock_skb_rx_put()
    


Will, I suspect your patch merely uncovers a latent bug
in zero copy handling elsewhere.
Want to take a look?



> ------------[ cut here ]------------
> 'send_pkt()' returns 0, but 65536 expected
> WARNING: CPU: 0 PID: 5936 at net/vmw_vsock/virtio_transport_common.c:428 virtio_transport_send_pkt_info+0xd11/0xf00 net/vmw_vsock/virtio_transport_common.c:426
> Modules linked in:
> CPU: 0 UID: 0 PID: 5936 Comm: syz.0.17 Not tainted 6.16.0-rc6-syzkaller-00030-g6693731487a8 #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:virtio_transport_send_pkt_info+0xd11/0xf00 net/vmw_vsock/virtio_transport_common.c:426
> Code: 0f 0b 90 bd f2 ff ff ff eb bc e8 2a 15 74 f6 c6 05 17 6f 40 04 01 90 48 c7 c7 00 4b b7 8c 44 89 f6 4c 89 ea e8 e0 f7 37 f6 90 <0f> 0b 90 90 e9 e1 fe ff ff e8 01 15 74 f6 90 0f 0b 90 e9 c5 f7 ff
> RSP: 0018:ffffc9000cc2f530 EFLAGS: 00010246
> RAX: 72837a5a4342cf00 RBX: 0000000000010000 RCX: ffff888033218000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: ffffffff8f8592b0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1bfa6ec R12: dffffc0000000000
> R13: 0000000000010000 R14: 0000000000000000 R15: ffff8880406730e4
> FS:  00007fc0bd7eb6c0(0000) GS:ffff88808d230000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd5857ec368 CR3: 00000000517cf000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  virtio_transport_stream_enqueue net/vmw_vsock/virtio_transport_common.c:1111 [inline]
>  virtio_transport_seqpacket_enqueue+0x143/0x1c0 net/vmw_vsock/virtio_transport_common.c:839
>  vsock_connectible_sendmsg+0xac4/0x1050 net/vmw_vsock/af_vsock.c:2123
>  sock_sendmsg_nosec net/socket.c:712 [inline]
>  __sock_sendmsg+0x219/0x270 net/socket.c:727
>  ____sys_sendmsg+0x52d/0x830 net/socket.c:2566
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2620
>  __sys_sendmmsg+0x227/0x430 net/socket.c:2709
>  __do_sys_sendmmsg net/socket.c:2736 [inline]
>  __se_sys_sendmmsg net/socket.c:2733 [inline]
>  __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2733
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fc0bc98ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fc0bd7eb038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007fc0bcbb5fa0 RCX: 00007fc0bc98ebe9
> RDX: 0000000000000001 RSI: 0000200000000100 RDI: 0000000000000004
> RBP: 00007fc0bca11e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000024008094 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fc0bcbb6038 R14: 00007fc0bcbb5fa0 R15: 00007ffdb7bf09f8
>  </TASK>
> 
> 
> Tested on:
> 
> commit:         66937314 vsock/virtio: Allocate nonlinear SKBs for han..
> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> console output: https://syzkaller.appspot.com/x/log.txt?x=159d75bc580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=84141250092a114f
> dashboard link: https://syzkaller.appspot.com/bug?extid=b4d960daf7a3c7c2b7b1
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> 
> Note: no patches were applied.


