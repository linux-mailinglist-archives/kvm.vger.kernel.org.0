Return-Path: <kvm+bounces-35273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E93B6A0B1DA
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 09:58:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41C873A19B7
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 08:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC46F237A3C;
	Mon, 13 Jan 2025 08:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HMjItwx7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3F3233130
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 08:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736758669; cv=none; b=JQjvRmPuuM429N9KOdRTa+WzjVRU90aLslWOKyJR0NewKWUDZiUU4p8hJAadjKag36KM42qy/mdWflk3uBpw0P44VYQGJLGtsfmJOLFsZjg478pow5nylL8DvkVwm2WPGE9btwWbqo2rJz8bveHLv1ZEnckhmFmVNWxWTlGLkbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736758669; c=relaxed/simple;
	bh=gxhVRl56OLcGDdCxi0XoDRzuHgb7y8m7p5OnGjvMagU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWS4B/tdg/pBzfID3HWU1HiA+DhxiCgf8B62QSPY4Kk5C719BFMlyt1QJZyuukFpRz+j88wYv6YIA1iTjnra4aKSseuvTYnUxwWSF/00B7ta8xaWZsAWpiKeD5sXVjEYLvY5nQ1ypOKTBCNGsY2YcbrSGaZBYp6UT38MGGjalm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HMjItwx7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736758666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YWFyV30sJjQgolYVvQpFa3XlxtBBBiGLOI1I4dMHcn8=;
	b=HMjItwx7FUmLFa7UvG0sbdQFWqFexgDQY4ueFwQeb9aYabgT4WSSOTHCE5dSPQ3bvlzzel
	y0ETvIDmNNd1pAdP6q8Hdlc2Wk2Fv/M+nuVvgtoTHfYp5Pm7QP47+DPhleWhceBMy3IgOb
	Wd/zx9+IBJPcnBMp7rtn670rgng1q2A=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-5YM5VTQYPpCXxC_jmuoHKQ-1; Mon, 13 Jan 2025 03:57:44 -0500
X-MC-Unique: 5YM5VTQYPpCXxC_jmuoHKQ-1
X-Mimecast-MFC-AGG-ID: 5YM5VTQYPpCXxC_jmuoHKQ
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa67855b3deso323646166b.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 00:57:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736758663; x=1737363463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YWFyV30sJjQgolYVvQpFa3XlxtBBBiGLOI1I4dMHcn8=;
        b=oYBNzJuO/HlFjS5kBP/wiQIFJm+JLTWCCZsJS6t2tF/hYJPOlfZsPNgJN5R18alm6H
         WPDlEWHBFhFnLDZUQREZF3vvYcWlJox2OVDgaw0Fy/ZTh0YNfWJXpSndh0M3NlkHmDgV
         2C4+Ii2cxqs2RX8QK5asS55k48mP9CaXGGaLROGhZNWJEKk2bQHEP5fjll4HRWSD+cQJ
         h6p7CjHJwPm3lyw/5GhnfIH4rBchd+dj0laYQzdwyGGnLuiRchOgeAqvu+8vYbCq/QU3
         hAhizZ4kvjmeu9gATFnDgGSGXYFCVoJe22/GsIbp/95uyQ2WTsE360fvwOLaN5QynYfy
         wsBw==
X-Forwarded-Encrypted: i=1; AJvYcCWINxcvp3aup0YLpbn8pW/rq+gt/4lG5Z2hBOmXt76Cqc0dw1cVmrg6Y7r4whNE6iSDv0s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYjrCvxgoTOh4aYi5RrBhlZQhgMpjZqHtk34iHEEDQUAJ3G9/3
	xMWneQ7u7ennN8YuN3ePzvWASDYniQcxWkJMV6UwZz9kHQvfh0SVuqVk8IUInpgs6yWbQYcFaeH
	6KJVJ0UBsLCn7Fu6j3juOm3s5HgCOaKEbTvFCxxaproYegil46Q==
X-Gm-Gg: ASbGncuqAZJ8JBzOS2IfPzTe1CUL4ybbYu55ft0sVazktz86P1pIUSX/QaJyA0zagZy
	4ANVnd6geoahraEt7bx/mYlb7FNV9SqaRl/xssotlVwmmNm+OPz1okFCZOSx6KLwAx4UZMhhVXB
	2x6vTQK4k6JcZ/85LWZd7GIIosrCVmuijbfhMRgMV4/mwGYt/5ZLhx8ZiDtsqsaQwx5ni1TnYwU
	/2vVIcwWL7nXDkJWalb5J25B0ztGBSVTAvtPvQB1/figIvQneRKbNTucL/qNKBo8MEvbBcJmVwz
	eGGtAhYywHWelbSxVbpTm4MHNXi3BiWI
X-Received: by 2002:a17:906:c102:b0:aa6:7f99:81aa with SMTP id a640c23a62f3a-ab2ab676541mr1625695366b.6.1736758663360;
        Mon, 13 Jan 2025 00:57:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFyFaFt8L7jHJMAHrOnyp5s5Nyww/Em+5GZG5BQED1Or2rDl0D0YzsCzYMwzvKf6M5qsr3kw==
X-Received: by 2002:a17:906:c102:b0:aa6:7f99:81aa with SMTP id a640c23a62f3a-ab2ab676541mr1625691266b.6.1736758662454;
        Mon, 13 Jan 2025 00:57:42 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-100.retail.telecomitalia.it. [82.53.134.100])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab321168be8sm66386166b.121.2025.01.13.00.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 00:57:41 -0800 (PST)
Date: Mon, 13 Jan 2025 09:57:37 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: netdev@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Leonardi <leonardi@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Wongi Lee <qwerty@theori.io>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Eric Dumazet <edumazet@google.com>, kvm@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Simon Horman <horms@kernel.org>, Hyunwoo Kim <v4bel@theori.io>, 
	Jakub Kicinski <kuba@kernel.org>, virtualization@lists.linux.dev, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH net v2 1/5] vsock/virtio: discard packets if the
 transport changes
Message-ID: <nedvcylhjxrkmkvgugsku2lpdjgjpo5exoke4o6clxcxh64s3i@jkjnvngazr5v>
References: <20250110083511.30419-1-sgarzare@redhat.com>
 <20250110083511.30419-2-sgarzare@redhat.com>
 <1aa83abf-6baa-4cf1-a108-66b677bcfd93@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1aa83abf-6baa-4cf1-a108-66b677bcfd93@rbox.co>

On Sun, Jan 12, 2025 at 11:42:30PM +0100, Michal Luczaj wrote:
>On 1/10/25 09:35, Stefano Garzarella wrote:
>> If the socket has been de-assigned or assigned to another transport,
>> we must discard any packets received because they are not expected
>> and would cause issues when we access vsk->transport.
>>
>> A possible scenario is described by Hyunwoo Kim in the attached link,
>> where after a first connect() interrupted by a signal, and a second
>> connect() failed, we can find `vsk->transport` at NULL, leading to a
>> NULL pointer dereference.
>>
>> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
>> Cc: stable@vger.kernel.org
>> Reported-by: Hyunwoo Kim <v4bel@theori.io>
>> Reported-by: Wongi Lee <qwerty@theori.io>
>> Closes: https://lore.kernel.org/netdev/Z2LvdTTQR7dBmPb5@v4bel-B760M-AORUS-ELITE-AX/
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  net/vmw_vsock/virtio_transport_common.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 9acc13ab3f82..51a494b69be8 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -1628,8 +1628,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>>
>>  	lock_sock(sk);
>>
>> -	/* Check if sk has been closed before lock_sock */
>> -	if (sock_flag(sk, SOCK_DONE)) {
>> +	/* Check if sk has been closed or assigned to another transport before
>> +	 * lock_sock (note: listener sockets are not assigned to any transport)
>> +	 */
>> +	if (sock_flag(sk, SOCK_DONE) ||
>> +	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
>>  		(void)virtio_transport_reset_no_sock(t, skb);
>>  		release_sock(sk);
>>  		sock_put(sk);
>
>I wanted to check if such special-casing for TCP_LISTEN doesn't bother
>BPF/sockmap, but instead I've hit a UAF.
>
>```
>#include <stdio.h>
>#include <stdlib.h>
>#include <sys/socket.h>
>#include <linux/vm_sockets.h>
>
>/* net/vmw_vsock/af_vsock.c */
>#define MAX_PORT_RETRIES	24
>
>static void die(const char *msg)
>{
>	perror(msg);
>	exit(-1);
>}
>
>int socket_bind(int port)
>{
>	struct sockaddr_vm addr = {
>		.svm_family = AF_VSOCK,
>		.svm_cid = VMADDR_CID_LOCAL,
>		.svm_port = port,
>	};
>	int s;
>
>	s = socket(AF_VSOCK, SOCK_SEQPACKET, 0);
>	if (s < 0)
>		die("socket");
>
>	if (bind(s, (struct sockaddr *)&addr, sizeof(addr)))
>		die("bind");
>
>	return s;
>}
>
>int main(void)
>{
>	struct sockaddr_vm addr;
>	socklen_t alen = sizeof(addr);
>	int dummy, i, s;
>
>	/* Play with `static u32 port` in __vsock_bind_connectible()
>	 * to fail vsock_auto_bind() at connect #1.
>	 */
>	dummy = socket_bind(VMADDR_PORT_ANY);
>	if (getsockname(dummy, (struct sockaddr *)&addr, &alen))
>		die("getsockname");
>	for (i = 0; i < MAX_PORT_RETRIES; ++i)
>		socket_bind(++addr.svm_port);
>
>	s = socket(AF_VSOCK, SOCK_SEQPACKET, 0);
>	if (s < 0)
>		die("socket s");
>
>	if (!connect(s, (struct sockaddr *)&addr, alen))
>		die("connect #1");
>	perror("ok, connect #1 failed; transport set, sk in unbound list");
>
>	addr.svm_cid = 42; /* non-existing */
>	if (!connect(s, (struct sockaddr *)&addr, alen))
>		die("connect #2");
>	/* vsock_assign_transport
>	 *   virtio_transport_release (vsk->transport->release)
>	 *     virtio_transport_remove_sock
>	 *       vsock_remove_sock
>	 *         vsock_remove_bound
>	 *           __vsock_remove_bound
>	 *             sock_put(&vsk->sk)
>	 */
>	perror("ok, connect #2 failed; transport unset, sk ref dropped");
>
>	addr.svm_cid = VMADDR_CID_LOCAL;
>	addr.svm_port = VMADDR_PORT_ANY;
>	if (bind(s, (struct sockaddr *)&addr, alen))
>		die("bind s");
>	/* vsock_bind
>	 *   __vsock_bind
>	 *     __vsock_bind_connectible
>	 *       __vsock_remove_bound
>	 *         sock_put(&vsk->sk)
>	 */
>
>	printf("done\n");
>	return 0;
>}
>```
>
>=========================
>WARNING: held lock freed!
>6.13.0-rc6+ #146 Not tainted
>-------------------------
>a.out/2057 is freeing memory ffff88816b46a200-ffff88816b46a9f7, with a lock still held there!
>ffff88816b46a458 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: vsock_bind+0x8a/0xe0
>2 locks held by a.out/2057:
> #0: ffff88816b46a458 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: vsock_bind+0x8a/0xe0
> #1: ffffffff86574a78 (vsock_table_lock){+...}-{3:3}, at: __vsock_bind+0x129/0x730
>
>stack backtrace:
>CPU: 7 UID: 1000 PID: 2057 Comm: a.out Not tainted 6.13.0-rc6+ #146
>Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
>Call Trace:
> <TASK>
> dump_stack_lvl+0x68/0x90
> debug_check_no_locks_freed+0x21a/0x280
> ? lockdep_hardirqs_on+0x78/0x100
> kmem_cache_free+0x142/0x590
> ? security_sk_free+0x54/0xf0
> ? __sk_destruct+0x388/0x5a0
> __sk_destruct+0x388/0x5a0
> __vsock_bind+0x5e1/0x730
> ? __pfx___vsock_bind+0x10/0x10
> ? __local_bh_enable_ip+0xab/0x140
> vsock_bind+0x97/0xe0
> ? __pfx_vsock_bind+0x10/0x10
> __sys_bind+0x154/0x1f0
> ? __pfx___sys_bind+0x10/0x10
> ? lockdep_hardirqs_on_prepare+0x16d/0x400
> ? do_syscall_64+0x9f/0x1b0
> ? lockdep_hardirqs_on+0x78/0x100
> ? do_syscall_64+0x9f/0x1b0
> __x64_sys_bind+0x6e/0xb0
> ? lockdep_hardirqs_on+0x78/0x100
> do_syscall_64+0x93/0x1b0
> ? lockdep_hardirqs_on_prepare+0x16d/0x400
> ? do_syscall_64+0x9f/0x1b0
> ? lockdep_hardirqs_on+0x78/0x100
> ? do_syscall_64+0x9f/0x1b0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>RIP: 0033:0x7fa9a618e34b
>Code: c3 66 0f 1f 44 00 00 48 8b 15 c9 9a 0c 00 f7 d8 64 89 02 b8 ff ff ff ff eb c1 0f 1f 44 00 00 f3 0f 1e fa b8 31 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d 9a 0c 00 f7 d8 64 89 01 48
>RSP: 002b:00007fff5e2d2f88 EFLAGS: 00000202 ORIG_RAX: 0000000000000031
>RAX: ffffffffffffffda RBX: 00007fff5e2d30e8 RCX: 00007fa9a618e34b
>RDX: 0000000000000010 RSI: 00007fff5e2d2fa0 RDI: 000000000000001c
>RBP: 00007fff5e2d2fc0 R08: 0000000010f8c010 R09: 0000000000000007
>R10: 0000000010f8c2a0 R11: 0000000000000202 R12: 0000000000000001
>R13: 0000000000000000 R14: 00007fa9a62b0000 R15: 0000000000403e00
> </TASK>
>==================================================================
>BUG: KASAN: slab-use-after-free in __vsock_bind+0x62e/0x730
>Read of size 4 at addr ffff88816b46a74c by task a.out/2057
>
>CPU: 7 UID: 1000 PID: 2057 Comm: a.out Not tainted 6.13.0-rc6+ #146
>Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
>Call Trace:
> <TASK>
> dump_stack_lvl+0x68/0x90
> print_report+0x174/0x4f6
> ? __virt_addr_valid+0x208/0x400
> ? __vsock_bind+0x62e/0x730
> kasan_report+0xb9/0x190
> ? __vsock_bind+0x62e/0x730
> __vsock_bind+0x62e/0x730
> ? __pfx___vsock_bind+0x10/0x10
> ? __local_bh_enable_ip+0xab/0x140
> vsock_bind+0x97/0xe0
> ? __pfx_vsock_bind+0x10/0x10
> __sys_bind+0x154/0x1f0
> ? __pfx___sys_bind+0x10/0x10
> ? lockdep_hardirqs_on_prepare+0x16d/0x400
> ? do_syscall_64+0x9f/0x1b0
> ? lockdep_hardirqs_on+0x78/0x100
> ? do_syscall_64+0x9f/0x1b0
> __x64_sys_bind+0x6e/0xb0
> ? lockdep_hardirqs_on+0x78/0x100
> do_syscall_64+0x93/0x1b0
> ? lockdep_hardirqs_on_prepare+0x16d/0x400
> ? do_syscall_64+0x9f/0x1b0
> ? lockdep_hardirqs_on+0x78/0x100
> ? do_syscall_64+0x9f/0x1b0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>RIP: 0033:0x7fa9a618e34b
>Code: c3 66 0f 1f 44 00 00 48 8b 15 c9 9a 0c 00 f7 d8 64 89 02 b8 ff ff ff ff eb c1 0f 1f 44 00 00 f3 0f 1e fa b8 31 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d 9a 0c 00 f7 d8 64 89 01 48
>RSP: 002b:00007fff5e2d2f88 EFLAGS: 00000202 ORIG_RAX: 0000000000000031
>RAX: ffffffffffffffda RBX: 00007fff5e2d30e8 RCX: 00007fa9a618e34b
>RDX: 0000000000000010 RSI: 00007fff5e2d2fa0 RDI: 000000000000001c
>RBP: 00007fff5e2d2fc0 R08: 0000000010f8c010 R09: 0000000000000007
>R10: 0000000010f8c2a0 R11: 0000000000000202 R12: 0000000000000001
>R13: 0000000000000000 R14: 00007fa9a62b0000 R15: 0000000000403e00
> </TASK>
>
>Allocated by task 2057:
> kasan_save_stack+0x1e/0x40
> kasan_save_track+0x10/0x30
> __kasan_slab_alloc+0x85/0x90
> kmem_cache_alloc_noprof+0x131/0x450
> sk_prot_alloc+0x5b/0x220
> sk_alloc+0x2c/0x870
> __vsock_create.constprop.0+0x2e/0xb60
> vsock_create+0xe4/0x420
> __sock_create+0x241/0x650
> __sys_socket+0xf2/0x1a0
> __x64_sys_socket+0x6e/0xb0
> do_syscall_64+0x93/0x1b0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>Freed by task 2057:
> kasan_save_stack+0x1e/0x40
> kasan_save_track+0x10/0x30
> kasan_save_free_info+0x37/0x60
> __kasan_slab_free+0x4b/0x70
> kmem_cache_free+0x1a1/0x590
> __sk_destruct+0x388/0x5a0
> __vsock_bind+0x5e1/0x730
> vsock_bind+0x97/0xe0
> __sys_bind+0x154/0x1f0
> __x64_sys_bind+0x6e/0xb0
> do_syscall_64+0x93/0x1b0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>The buggy address belongs to the object at ffff88816b46a200
> which belongs to the cache AF_VSOCK of size 2040
>The buggy address is located 1356 bytes inside of
> freed 2040-byte region [ffff88816b46a200, ffff88816b46a9f8)
>
>The buggy address belongs to the physical page:
>page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16b468
>head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>memcg:ffff888125368401
>flags: 0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff)
>page_type: f5(slab)
>raw: 0017ffffc0000040 ffff888110115540 dead000000000122 0000000000000000
>raw: 0000000000000000 00000000800f000f 00000001f5000000 ffff888125368401
>head: 0017ffffc0000040 ffff888110115540 dead000000000122 0000000000000000
>head: 0000000000000000 00000000800f000f 00000001f5000000 ffff888125368401
>head: 0017ffffc0000003 ffffea0005ad1a01 ffffffffffffffff 0000000000000000
>head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
>page dumped because: kasan: bad access detected
>
>Memory state around the buggy address:
> ffff88816b46a600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88816b46a680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>ffff88816b46a700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                              ^
> ffff88816b46a780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88816b46a800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>==================================================================
>------------[ cut here ]------------
>refcount_t: addition on 0; use-after-free.
>WARNING: CPU: 7 PID: 2057 at lib/refcount.c:25 refcount_warn_saturate+0xce/0x150
>Modules linked in: 9p kvm_intel kvm 9pnet_virtio 9pnet netfs i2c_piix4 i2c_smbus zram virtio_blk serio_raw fuse qemu_fw_cfg virtio_console
>CPU: 7 UID: 1000 PID: 2057 Comm: a.out Tainted: G    B              6.13.0-rc6+ #146
>Tainted: [B]=BAD_PAGE
>Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
>RIP: 0010:refcount_warn_saturate+0xce/0x150
>Code: 7b fe d8 03 01 e8 22 db ac fe 0f 0b eb b1 80 3d 6e fe d8 03 00 75 a8 48 c7 c7 e0 da 95 84 c6 05 5e fe d8 03 01 e8 02 db ac fe <0f> 0b eb 91 80 3d 4d fe d8 03 00 75 88 48 c7 c7 40 db 95 84 c6 05
>RSP: 0018:ffff8881285c7c90 EFLAGS: 00010282
>RAX: 0000000000000000 RBX: ffff88816b46a280 RCX: 0000000000000000
>RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000001
>RBP: 0000000000000002 R08: 0000000000000001 R09: ffffed10bcd76349
>R10: ffff8885e6bb1a4b R11: 0000000000000000 R12: ffff88816b46a768
>R13: ffff88816b46a280 R14: ffff88816b46a770 R15: ffffffff88901520
>FS:  00007fa9a606e740(0000) GS:ffff8885e6b80000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 0000000010f8d488 CR3: 0000000130c4a000 CR4: 0000000000752ef0
>PKRU: 55555554
>Call Trace:
> <TASK>
> ? __warn.cold+0x5f/0x1ff
> ? refcount_warn_saturate+0xce/0x150
> ? report_bug+0x1ec/0x390
> ? handle_bug+0x58/0x90
> ? exc_invalid_op+0x13/0x40
> ? asm_exc_invalid_op+0x16/0x20
> ? refcount_warn_saturate+0xce/0x150
> __vsock_bind+0x66d/0x730
> ? __pfx___vsock_bind+0x10/0x10
> ? __local_bh_enable_ip+0xab/0x140
> vsock_bind+0x97/0xe0
> ? __pfx_vsock_bind+0x10/0x10
> __sys_bind+0x154/0x1f0
> ? __pfx___sys_bind+0x10/0x10
> ? lockdep_hardirqs_on_prepare+0x16d/0x400
> ? do_syscall_64+0x9f/0x1b0
> ? lockdep_hardirqs_on+0x78/0x100
> ? do_syscall_64+0x9f/0x1b0
> __x64_sys_bind+0x6e/0xb0
> ? lockdep_hardirqs_on+0x78/0x100
> do_syscall_64+0x93/0x1b0
> ? lockdep_hardirqs_on_prepare+0x16d/0x400
> ? do_syscall_64+0x9f/0x1b0
> ? lockdep_hardirqs_on+0x78/0x100
> ? do_syscall_64+0x9f/0x1b0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>RIP: 0033:0x7fa9a618e34b
>Code: c3 66 0f 1f 44 00 00 48 8b 15 c9 9a 0c 00 f7 d8 64 89 02 b8 ff ff ff ff eb c1 0f 1f 44 00 00 f3 0f 1e fa b8 31 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d 9a 0c 00 f7 d8 64 89 01 48
>RSP: 002b:00007fff5e2d2f88 EFLAGS: 00000202 ORIG_RAX: 0000000000000031
>RAX: ffffffffffffffda RBX: 00007fff5e2d30e8 RCX: 00007fa9a618e34b
>RDX: 0000000000000010 RSI: 00007fff5e2d2fa0 RDI: 000000000000001c
>RBP: 00007fff5e2d2fc0 R08: 0000000010f8c010 R09: 0000000000000007
>R10: 0000000010f8c2a0 R11: 0000000000000202 R12: 0000000000000001
>R13: 0000000000000000 R14: 00007fa9a62b0000 R15: 0000000000403e00
> </TASK>
>irq event stamp: 9836
>hardirqs last  enabled at (9836): [<ffffffff8152121f>] __call_rcu_common.constprop.0+0x32f/0xe90
>hardirqs last disabled at (9835): [<ffffffff8152127c>] __call_rcu_common.constprop.0+0x38c/0xe90
>softirqs last  enabled at (9810): [<ffffffff84168aca>] vsock_bind+0x8a/0xe0
>softirqs last disabled at (9812): [<ffffffff84168429>] __vsock_bind+0x129/0x730
>---[ end trace 0000000000000000 ]---
>------------[ cut here ]------------
>refcount_t: underflow; use-after-free.
>WARNING: CPU: 7 PID: 2057 at lib/refcount.c:28 refcount_warn_saturate+0xee/0x150
>Modules linked in: 9p kvm_intel kvm 9pnet_virtio 9pnet netfs i2c_piix4 i2c_smbus zram virtio_blk serio_raw fuse qemu_fw_cfg virtio_console
>CPU: 7 UID: 1000 PID: 2057 Comm: a.out Tainted: G    B   W          6.13.0-rc6+ #146
>Tainted: [B]=BAD_PAGE, [W]=WARN
>Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
>RIP: 0010:refcount_warn_saturate+0xee/0x150
>Code: 5e fe d8 03 01 e8 02 db ac fe 0f 0b eb 91 80 3d 4d fe d8 03 00 75 88 48 c7 c7 40 db 95 84 c6 05 3d fe d8 03 01 e8 e2 da ac fe <0f> 0b e9 6e ff ff ff 80 3d 2d fe d8 03 00 0f 85 61 ff ff ff 48 c7
>RSP: 0018:ffff8881285c7b68 EFLAGS: 00010296
>RAX: 0000000000000000 RBX: ffff88816b46a280 RCX: 0000000000000000
>RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000001
>RBP: 0000000000000003 R08: 0000000000000001 R09: ffffed10bcd76349
>R10: ffff8885e6bb1a4b R11: 0000000000000000 R12: ffff88816b46a770
>R13: ffffffff88901520 R14: ffffffff88901520 R15: ffff888128cff640
>FS:  0000000000000000(0000) GS:ffff8885e6b80000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 00007fa9a6156050 CR3: 0000000005a74000 CR4: 0000000000752ef0
>PKRU: 55555554
>Call Trace:
> <TASK>
> ? __warn.cold+0x5f/0x1ff
> ? refcount_warn_saturate+0xee/0x150
> ? report_bug+0x1ec/0x390
> ? handle_bug+0x58/0x90
> ? exc_invalid_op+0x13/0x40
> ? asm_exc_invalid_op+0x16/0x20
> ? refcount_warn_saturate+0xee/0x150
> ? refcount_warn_saturate+0xee/0x150
> vsock_remove_bound+0x187/0x1e0
> __vsock_release+0x383/0x4a0
> ? down_write+0x129/0x1c0
> vsock_release+0x90/0x120
> __sock_release+0xa3/0x250
> sock_close+0x14/0x20
> __fput+0x359/0xa80
> ? trace_irq_enable.constprop.0+0xce/0x110
> task_work_run+0x107/0x1d0
> ? __pfx_do_raw_spin_lock+0x10/0x10
> ? __pfx_task_work_run+0x10/0x10
> do_exit+0x847/0x2560
> ? __pfx_lock_release+0x10/0x10
> ? do_raw_spin_lock+0x11a/0x240
> ? __pfx_do_exit+0x10/0x10
> ? rcu_is_watching+0x11/0xb0
> ? trace_irq_enable.constprop.0+0xce/0x110
> do_group_exit+0xb8/0x250
> __x64_sys_exit_group+0x3a/0x50
> x64_sys_call+0xfec/0x14f0
> do_syscall_64+0x93/0x1b0
> ? __pfx___up_read+0x10/0x10
> ? rcu_is_watching+0x11/0xb0
> ? trace_irq_enable.constprop.0+0xce/0x110
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>RIP: 0033:0x7fa9a615606d
>Code: Unable to access opcode bytes at 0x7fa9a6156043.
>RSP: 002b:00007fff5e2d2f58 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
>RAX: ffffffffffffffda RBX: 00007fa9a6259fa8 RCX: 00007fa9a615606d
>RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
>RBP: 00007fff5e2d2fb0 R08: 00007fff5e2d2f00 R09: 00007fff5e2d2e8f
>R10: 00007fff5e2d2e10 R11: 0000000000000206 R12: 0000000000000001
>R13: 0000000000000000 R14: 00007fa9a6258680 R15: 00007fa9a6259fc0
> </TASK>
>irq event stamp: 9836
>hardirqs last  enabled at (9836): [<ffffffff8152121f>] __call_rcu_common.constprop.0+0x32f/0xe90
>hardirqs last disabled at (9835): [<ffffffff8152127c>] __call_rcu_common.constprop.0+0x38c/0xe90
>softirqs last  enabled at (9810): [<ffffffff84168aca>] vsock_bind+0x8a/0xe0
>softirqs last disabled at (9812): [<ffffffff84168429>] __vsock_bind+0x129/0x730
>---[ end trace 0000000000000000 ]---
>
>So, if I get this right:
>1. vsock_create() (refcnt=1) calls vsock_insert_unbound() (refcnt=2)
>2. transport->release() calls vsock_remove_bound() without checking if sk
>   was bound and moved to bound list (refcnt=1)
>3. vsock_bind() assumes sk is in unbound list and before
>   __vsock_insert_bound(vsock_bound_sockets()) calls
>   __vsock_remove_bound() which does:
>      list_del_init(&vsk->bound_table); // nop
>      sock_put(&vsk->sk);               // refcnt=0
>
>The following fixes things for me. I'm just not certain that's the only
>place where transport destruction may lead to an unbound socket being
>removed from the unbound list.
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 7f7de6d88096..0fe807c8c052 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1303,7 +1303,8 @@ void virtio_transport_release(struct vsock_sock *vsk)
>
> 	if (remove_sock) {
> 		sock_set_flag(sk, SOCK_DONE);
>-		virtio_transport_remove_sock(vsk);
>+		if (vsock_addr_bound(&vsk->local_addr))
>+			virtio_transport_remove_sock(vsk);

I don't get this fix, virtio_transport_remove_sock() calls
   vsock_remove_sock()
     vsock_remove_bound()
       if (__vsock_in_bound_table(vsk))
           __vsock_remove_bound(vsk);


So, should already avoid this issue, no?

Can the problem be in vsock_bind() ?

Is this issue pre-existing or introduced by this series?

I'll also investigate a bit more.

Thanks,
Stefano


