Return-Path: <kvm+bounces-54507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D2EB2232B
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 11:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A9821A280CF
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 09:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613B52E8E13;
	Tue, 12 Aug 2025 09:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdqwPASu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5117311C3B
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 09:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754990839; cv=none; b=FQtzjrqsPtf0xKPXm5AV9uZ34yviptJKb4HyiLjp8keI6EEACpQxNj0vyoFUCUlrnMPaNmI4KRbRE1o6/rv9E67eF3/tCLcOZKYGkYqhmHB34fxhmvkd1TqnEgwvru876jBPO7rIUS2kmjkNqkwlZ1a90IAUC71TrI9JCyo75/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754990839; c=relaxed/simple;
	bh=Hun7Pj2QeIThbWWcEnI4efZAqJOfJrOaDsvmrUO0zJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARKR/TQ20pTRU8vShhcdQ2QKdEi9ML7164xz/YHWlV1h+3UuQiB58PbmT5G/l6S+ZM8+XPR6S2C2Bq5Xmbud6TwMvvqxPPsmFwux9v4LuRdGXl16YcccEOIHHAEmqBWu2mYYaHzlzRwPZ3uUfT28nd62lEz3RzxpS3wNRfW1M2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdqwPASu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754990836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WGp9+izCkrlBj+bCsKQsfK68CmTdIqz5MvXVpGGtKI8=;
	b=BdqwPASuYGNzIE3Yj1jO6G1AQHyMHiSAFm/2wjR58ImnucSbiGEIONJLqO2RDY2dT9LoLP
	jMPkhDkH2QvsitQCs0uXKpqN5XGOP+AARmEnixNVBCgyS+J6A1NUawKBNon73LOYACKhs1
	oiI3LlkenVwsOymD4OkJNsvKjBgReTg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-bNToL_0dPYmEoJtMYNIDoQ-1; Tue, 12 Aug 2025 05:27:15 -0400
X-MC-Unique: bNToL_0dPYmEoJtMYNIDoQ-1
X-Mimecast-MFC-AGG-ID: bNToL_0dPYmEoJtMYNIDoQ_1754990834
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7961b3c82so2578157f8f.0
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 02:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754990833; x=1755595633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WGp9+izCkrlBj+bCsKQsfK68CmTdIqz5MvXVpGGtKI8=;
        b=UjeCjlCfD1LrG1dKbjM8SZrHOowc0hdRorB1Z+JyJSbq1r3dRDOVtjYlIvXgSFRwUl
         IK7F9anwtFGB31bqtjOL8plHm5V8tLUQc3uooXMS9rLgz5q6GZtwNdLirGXYx0wGzKm2
         9KiEeu0TQTJFDxqSF09GqK8GGXnoXWbCu6TSYxXOa8SRrBo32wiYdrwS0Xl8ZchPzw0H
         GF8rnUctbvJ/dhMrOEnTZGzvWowzf4Tf/IpjhMXhW4xrfpIZuX5iC3is5xR2cmDXxHHV
         432XQjdAMbNgFG18ajWsLNzi1XbwwZ1bO45G5I8h9Bibd0qe/haG2ozCH5vVhcrEMYp9
         DysQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2TrVmYl9Pw8Y6bXfVTPR5fhDksehggfmhntNKhYftcrcSJhL47sobMkCF1cMQT7ajmzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YykDcE0Q7qMbHy2dWgiC9D0wMC0SQy0TZckJvHEJbjZPTgOr75d
	7EmfWAqxq5kUgRJ62jaUWiJrBTmAQkr8esP/haZgZ/37oDFL1bPQcQSfheWfWAyW01KXbqgUqK6
	06llNUy7FaZEqdLpJN+Zzob2FCcAOJhXtzuhDMpvlabDgn5+G7QBRkA==
X-Gm-Gg: ASbGncsQrti+6g+728w7f0fy47ZwP+U8wn+9tUeDZKOIhF6nXgHh1UDgb294LsrhjhG
	0rK6bw7GqS5c/BfMAuxpQmJdLOUMGwt1rmfjbEAfBu8wb6jckj06VNXsFj/DLN6Fvuw53ef09PZ
	D78KO7CzCMiE4LDPEbdlko6gPpoyysbCjD4TfnnWJCdVofJHuzbM1ajeaVWRpe/ZjrpwU+LeBTz
	sBxbLSjzylhEyaIERtas4wOYJmFtfShLIvIqQtQj7gZvcwzZ4n/EtMelEY/TCGJhvRAM5obTPZR
	7ghUYtb7Bi/J9wAOungwQAyp2JhYOjQ2
X-Received: by 2002:a5d:64cd:0:b0:3a4:f70e:abda with SMTP id ffacd0b85a97d-3b910fce9a8mr2143716f8f.10.1754990833538;
        Tue, 12 Aug 2025 02:27:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFkY9FzWL94KYJ81gviv0bWbapS/YWsGTjYnmEpZTu+fpeDhGDEmVz6ELyY1r99MnE6tNX6Q==
X-Received: by 2002:a5d:64cd:0:b0:3a4:f70e:abda with SMTP id ffacd0b85a97d-3b910fce9a8mr2143685f8f.10.1754990832925;
        Tue, 12 Aug 2025 02:27:12 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1515:7300:62e6:253a:2a96:5e3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3c4d02sm42398517f8f.33.2025.08.12.02.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 02:27:12 -0700 (PDT)
Date: Tue, 12 Aug 2025 05:27:09 -0400
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
Message-ID: <20250812052645-mutt-send-email-mst@kernel.org>
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


#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 6693731487a8145a9b039bc983d77edc47693855


> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup


