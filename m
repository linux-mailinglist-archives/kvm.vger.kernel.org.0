Return-Path: <kvm+bounces-1134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE847E4F55
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 04:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 504941C20C92
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 03:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640C620FA;
	Wed,  8 Nov 2023 03:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PH1DBhv2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D073ECF;
	Wed,  8 Nov 2023 03:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88FB7C433CA;
	Wed,  8 Nov 2023 03:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699413024;
	bh=db462BER3D6dOv8vrwDUmbYyIEQAH4iq/9pl02uWBls=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PH1DBhv2LS+PBbNau6viPmQOX9QtuEFQ+eoIR2vhwDa8v07aBAPgAuBV/ozVmhwxZ
	 t8tB6Qw5m1QegYEi4POYM+D95IbSfQiYHM0ClhkwgJz6Hx67HoLTcNefNlbScPoI1y
	 Bh67lEAeZyE2hSyYnx1I3wGqtE6mhfJICmNAWJgBU22rz50JsogpWTRxZzg1JWs5Na
	 b68IsiUImOnNYOui7wegyKl7FreNqNWA4t1QrrpEaaoYVgAv1mFPutkNZZv+x62zG/
	 NxPxFBQoo1/lt3gQHl62iZ6+jGd9TSbh2iXqmhbzmynizMtIc15qdfQo07S6NP4WjR
	 hXofs+TSn90HQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 645D8C395FC;
	Wed,  8 Nov 2023 03:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] virtio/vsock: Fix uninit-value in
 virtio_transport_recv_pkt()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <169941302440.21503.9572078694318707509.git-patchwork-notify@kernel.org>
Date: Wed, 08 Nov 2023 03:10:24 +0000
References: <20231104150531.257952-1-syoshida@redhat.com>
In-Reply-To: <20231104150531.257952-1-syoshida@redhat.com>
To: Shigeru Yoshida <syoshida@redhat.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  5 Nov 2023 00:05:31 +0900 you wrote:
> KMSAN reported the following uninit-value access issue:
> 
> =====================================================
> BUG: KMSAN: uninit-value in virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
>  virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
>  vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
>  process_one_work kernel/workqueue.c:2630 [inline]
>  process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
>  worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
>  kthread+0x3cc/0x520 kernel/kthread.c:388
>  ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> 
> [...]

Here is the summary with links:
  - [net,v2] virtio/vsock: Fix uninit-value in virtio_transport_recv_pkt()
    https://git.kernel.org/netdev/net/c/34c4effacfc3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



