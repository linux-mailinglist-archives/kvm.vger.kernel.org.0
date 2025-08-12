Return-Path: <kvm+bounces-54506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA450B22324
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 11:30:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD074189F849
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 09:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BBD2E8E13;
	Tue, 12 Aug 2025 09:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Si62xXAg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CFF2E091C
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 09:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754990809; cv=none; b=PqNcYG2fdv7mxtJBbe3XrS6fXp+HQoKNd5bRYU+injg5DpDW5ID+/sOGo6GQ1KbVkY8ntw5RHHFEo56sWfq0dClvdlCaGtat9bCHpiI1PPGzPXpDL5RE/UcEqYn2ZYMtKiJ3b9auQCyK97Naw71keZNoLBA8eZTJqjismDt2lgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754990809; c=relaxed/simple;
	bh=2jQQhPx7fDhjqgwZEv2HTKTsSEOUcuWb3seC1V18dDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXuk/eWV2qtcF/4j+MeInJxYiiNvD4mUveerVXLt/qATnohpS0G7XOC5OkhDGTO4OQzZUDIe5FLoBhAhK5MB/vdeqY0VbL1j6JVoGya7yPo12qrIN2i9wRuXKa/wRJOt44A0PxuN9MT44dpmm22/Z1U0smbXQQvdI32WwUw4IoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Si62xXAg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754990806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8FqEOts7cjbFL2GxnmOTUKK/m+lDHG7eDxkUxgY3gxA=;
	b=Si62xXAgHSSPD91S4jvSal7FfKRllKOpXFXj2qtiAbGUXlYrjyGLaVm1DcXwEY1pxmi7/U
	3SEIp6ddFyfGcVUQ0DEdf3jyAyd+XtB6cZcKFEcBzKkCKB8z9vCV0WuxS2DiP2CKDunGwZ
	sod9/HCe8bvp4JWJPHFpmf1r4mdZDB0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-lytsabuOMKCb98X0EhRScw-1; Tue, 12 Aug 2025 05:26:44 -0400
X-MC-Unique: lytsabuOMKCb98X0EhRScw-1
X-Mimecast-MFC-AGG-ID: lytsabuOMKCb98X0EhRScw_1754990804
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451d3f03b74so30175875e9.3
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 02:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754990804; x=1755595604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8FqEOts7cjbFL2GxnmOTUKK/m+lDHG7eDxkUxgY3gxA=;
        b=MyyRjizwDCdsaA8RTGXZ+dFcudOeMqjcVtZExphfM/EI3jv36itqYiNy86MZNwYH3o
         rbo6Gh5egnezJppCHt+CX27xW2T3moBg13m7bZ6b0DQwiGbtah8qmLORy4YVJG+2DmRi
         PdvO5/B1KTXy2dr6SMfuXhOYeePIXExzFlyiUfRv9RoUoQ6j2etsxTKB/RuVRTTazH8N
         Vkbhgn6sZGfnMiqWyF4jRvQ4+DmBv/oPuca8cUsBeix2pj8LJMO2wUTGjn72S+epOoQ6
         lv7AbjjoaluOq3xz2y+d9i0dypjHpQerSf313kIqJTEIfxRNeEu9XS2/lUa9goMUamOA
         +hAw==
X-Forwarded-Encrypted: i=1; AJvYcCVeLadwkz9RCj3KHkejYYet6SNeHFKfXkQh5LJ3kJQkUO5L+w4hg3ayGsXtlT00zbNL+Kk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyZjXBzzatJbukJAakEOSWDqewpdYGaYjtP59+oILbMKAjehoh
	RQmsShCkOlhmuqC2UJ02VT9qRQD2lTFFn1aNJlp8w730cJMR8ypDDism61/lgBYm0VzDfNlIcX/
	gmkygtvQY4X6Dz0PmHjfhIXonMoI2BDwve3wc9d9EGW7rqNZLLY28vg==
X-Gm-Gg: ASbGncvUI5CH5L5wYEfVFkJ8+s+j6pUvUYXQqnE368BmTMZlqOsgROFE9K22JN7NAB1
	lKBC7YO8SrW7cuBXZ29G9dDKDtxzeAJcJVwYpf8bZYv8F4I4o5BMSx7T42JU0j2HMMgMjVnOKBs
	FXpDi1KxGGwWY0n+9vxTC3bhQR4BstQsc3L+F2dh6PDLh9S029htniHwJG8ZTpG596HmEBT2wuB
	bPUCNQKq3C7s8HRjz5vzvcRkokcYZw3EyjjhhtgKD3udwrbbo+I05FdCP5p2GGTtG3rUES39/9/
	4VciUGbZIOzlftvKnxAisEWQXK3hug0i
X-Received: by 2002:a05:600c:4748:b0:456:161c:3d6f with SMTP id 5b1f17b1804b1-45a10bb020emr23220925e9.11.1754990803682;
        Tue, 12 Aug 2025 02:26:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEXWjg9WUytTJs/5mxhcuBTLsQA+wgTgNaY4EutJ5NHJY7LJaT22Y7BY4IoMEr3P4QNDHpwQ==
X-Received: by 2002:a05:600c:4748:b0:456:161c:3d6f with SMTP id 5b1f17b1804b1-45a10bb020emr23220675e9.11.1754990803200;
        Tue, 12 Aug 2025 02:26:43 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1515:7300:62e6:253a:2a96:5e3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c469319sm42730533f8f.54.2025.08.12.02.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 02:26:42 -0700 (PDT)
Date: Tue, 12 Aug 2025 05:26:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: syzbot <syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com, sgarzare@redhat.com,
	stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] WARNING in
 virtio_transport_send_pkt_info
Message-ID: <20250812052537-mutt-send-email-mst@kernel.org>
References: <689a3d92.050a0220.7f033.00ff.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689a3d92.050a0220.7f033.00ff.GAE@google.com>

On Mon, Aug 11, 2025 at 11:59:30AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    37816488247d Merge tag 'net-6.17-rc1' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10b3b2f0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e143c1cd9dadd720
> dashboard link: https://syzkaller.appspot.com/bug?extid=b4d960daf7a3c7c2b7b1
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f0f042580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14855434580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-37816488.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/74b3ac8946d4/vmlinux-37816488.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a2b391aacaec/bzImage-37816488.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> 'send_pkt()' returns 0, but 65536 expected
> WARNING: CPU: 0 PID: 5503 at net/vmw_vsock/virtio_transport_common.c:428 virtio_transport_send_pkt_info+0xd11/0xf00 net/vmw_vsock/virtio_transport_common.c:426
> Modules linked in:
> CPU: 0 UID: 0 PID: 5503 Comm: syz.0.17 Not tainted 6.16.0-syzkaller-12063-g37816488247d #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:virtio_transport_send_pkt_info+0xd11/0xf00 net/vmw_vsock/virtio_transport_common.c:426
> Code: 0f 0b 90 bd f2 ff ff ff eb bc e8 8a 20 65 f6 c6 05 94 cf 32 04 01 90 48 c7 c7 00 c3 b8 8c 44 89 f6 4c 89 ea e8 40 af 28 f6 90 <0f> 0b 90 90 e9 e1 fe ff ff e8 61 20 65 f6 90 0f 0b 90 e9 c5 f7 ff
> RSP: 0018:ffffc900027ff530 EFLAGS: 00010246
> RAX: d7fcdfc663889c00 RBX: 0000000000010000 RCX: ffff888000e1a440
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: ffffffff8f8764d0 R08: ffff88801fc24253 R09: 1ffff11003f8484a
> R10: dffffc0000000000 R11: ffffed1003f8484b R12: dffffc0000000000
> R13: 0000000000010000 R14: 0000000000000000 R15: ffff888058b48024
> FS:  000055556bda1500(0000) GS:ffff88808d218000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000020000003f000 CR3: 000000003f6db000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  virtio_transport_stream_enqueue net/vmw_vsock/virtio_transport_common.c:1111 [inline]
>  virtio_transport_seqpacket_enqueue+0x143/0x1c0 net/vmw_vsock/virtio_transport_common.c:839
>  vsock_connectible_sendmsg+0xac7/0x1050 net/vmw_vsock/af_vsock.c:2140
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:729
>  ____sys_sendmsg+0x52d/0x830 net/socket.c:2614
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
>  __sys_sendmmsg+0x227/0x430 net/socket.c:2757
>  __do_sys_sendmmsg net/socket.c:2784 [inline]
>  __se_sys_sendmmsg net/socket.c:2781 [inline]
>  __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2781
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fddc238ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd48081028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007fddc25b5fa0 RCX: 00007fddc238ebe9
> RDX: 0000000000000001 RSI: 0000200000000100 RDI: 0000000000000004
> RBP: 00007fddc2411e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000024008094 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fddc25b5fa0 R14: 00007fddc25b5fa0 R15: 0000000000000004
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 8ca76151d2c8219edea82f1925a2a25907ff6a9d



> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup


