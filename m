Return-Path: <kvm+bounces-3879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C5B3808FBB
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 19:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D3AB1C20AD8
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 18:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AFC4E610;
	Thu,  7 Dec 2023 18:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WolHTfrn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657814D13F;
	Thu,  7 Dec 2023 18:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E35F0C433C9;
	Thu,  7 Dec 2023 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701973229;
	bh=0KcANSyv1sr9UhGc/vinHfJbi1QB9ETNOHuMpKsQkMk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=WolHTfrnuD59oo7UIECAYiJGuyiZL+9nfNxgrnrVMoUaQt1DvlLzpFIeeXZmOXihU
	 7Ins/SIsy8rBda6rEfMi5kztLjQEtxOlxLUA/6qDs42rW2CPVNSs480pWBmyWbMBCC
	 TwGraVPrfqxWyWaoKTyVKw9el7oY/GnONTQ/Y9PAkNF0kA0a2zQKiVPNq4Jr/drr9W
	 GeBAPNWNmf2TdBKPpH0tp7sE+9D+LEXamJuNPb5bDe7+9hMVVPW0fIzDO408bR1ctJ
	 2Qu43EG3IZdqdfu5YlrDakPNMfAQb4vvKQEcPHXXr1IsP4USVTFd/vbxeGNeQCsK2/
	 r6VxGwAoK6WUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC0C0C4314C;
	Thu,  7 Dec 2023 18:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vsock/virtio: fix "comparison of distinct pointer types
 lacks a cast" warning
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170197322883.20147.5857598481880040072.git-patchwork-notify@kernel.org>
Date: Thu, 07 Dec 2023 18:20:28 +0000
References: <20231206164143.281107-1-sgarzare@redhat.com>
In-Reply-To: <20231206164143.281107-1-sgarzare@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 virtualization@lists.linux.dev, mst@redhat.com, avkrasnov@salutedevices.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stefanha@redhat.com,
 edumazet@google.com, pabeni@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  6 Dec 2023 17:41:43 +0100 you wrote:
> After backporting commit 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY
> flag support") in CentOS Stream 9, CI reported the following error:
> 
>     In file included from ./include/linux/kernel.h:17,
>                      from ./include/linux/list.h:9,
>                      from ./include/linux/preempt.h:11,
>                      from ./include/linux/spinlock.h:56,
>                      from net/vmw_vsock/virtio_transport_common.c:9:
>     net/vmw_vsock/virtio_transport_common.c: In function ‘virtio_transport_can_zcopy‘:
>     ./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
>        20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>           |                                   ^~
>     ./include/linux/minmax.h:26:18: note: in expansion of macro ‘__typecheck‘
>        26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>           |                  ^~~~~~~~~~~
>     ./include/linux/minmax.h:36:31: note: in expansion of macro ‘__safe_cmp‘
>        36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>           |                               ^~~~~~~~~~
>     ./include/linux/minmax.h:45:25: note: in expansion of macro ‘__careful_cmp‘
>        45 | #define min(x, y)       __careful_cmp(x, y, <)
>           |                         ^~~~~~~~~~~~~
>     net/vmw_vsock/virtio_transport_common.c:63:37: note: in expansion of macro ‘min‘
>        63 |                 int pages_to_send = min(pages_in_iov, MAX_SKB_FRAGS);
> 
> [...]

Here is the summary with links:
  - [net] vsock/virtio: fix "comparison of distinct pointer types lacks a cast" warning
    https://git.kernel.org/netdev/net/c/b0a930e8d90c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



