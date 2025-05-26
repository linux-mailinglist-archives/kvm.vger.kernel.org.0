Return-Path: <kvm+bounces-47722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F250AC434B
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 19:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E9791899581
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 17:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D1623ED56;
	Mon, 26 May 2025 17:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugjP4evT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38901FAC50;
	Mon, 26 May 2025 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748279394; cv=none; b=blAc/ptgcVlJkbSvWm+4S9EGMrIaz8wGZdb11qag3Q2f1D5k6B7LuO7NMUe0ppusG3fLxMPtFiLoBn7+L6MTebDRsm0GtvDYUMbs0gGVd3KDEfK+SY33UVT7hcVesZ3A8UW+xdtZ/vky2IcYY+rtQQAme9ayYPApDHHCxdM0YMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748279394; c=relaxed/simple;
	bh=z4yImdCu2KPkvao83kEmLKDtuR+75PQAGlxugu1dFko=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=LIlfDfwJRN+C/rgvUReJGf2PcMx5rOQ9z7Jv+/jSe1XWQAMppYtUi4unZMCke3oJX/ohj+cb6ZTP8Qdi8CfzfKYRlnj6fUxOJH6i6SW5sSowV/UWh3rH/pGOS7T/CL/6id9Wj+kPeMYtrCVL+uP74+eIjujD7hVzEPn+JCE7D+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugjP4evT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42826C4CEED;
	Mon, 26 May 2025 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748279394;
	bh=z4yImdCu2KPkvao83kEmLKDtuR+75PQAGlxugu1dFko=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ugjP4evT0vqT7MCPyw8mNfyAjhttnF5ZTSzjYSxS1UDydhPBXW5g6rUT1AS2Evkjb
	 AufVW+Atx23BOdOl2pbJqPaBZYOn/9MI0jd1qbnodFsheQXOgSOAxPadas/+bfRWwd
	 CkLg3pZig086DJ3Af+iG/hVkVUaKMQANCvdMfgWCx41w6jPDIc2gS+ShBGQUlsfnyX
	 lJI/biAJHnYWltgTifpOpmhL6jOt3/xT8ogG1wrzN+JakrPHMQreVxP8S9MK2wotXq
	 WefeniBnbvZCB3hXvkyBCNe3VuEUtF2fCu8o2V8PaDUOuA3N4VmrzZ9NKtxAXHT2k/
	 vF0WdZZUGXjog==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAEFB3805D8E;
	Mon, 26 May 2025 17:10:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vsock/virtio: fix `rx_bytes` accounting for stream
 sockets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174827942876.985160.7017354014266756923.git-patchwork-notify@kernel.org>
Date: Mon, 26 May 2025 17:10:28 +0000
References: <20250521121705.196379-1-sgarzare@redhat.com>
In-Reply-To: <20250521121705.196379-1-sgarzare@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux.dev, pabeni@redhat.com,
 linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
 edumazet@google.com, mst@redhat.com, eperezma@redhat.com,
 kvm@vger.kernel.org, kuba@kernel.org, avkrasnov@salutedevices.com,
 jasowang@redhat.com, niuxuewei97@gmail.com, Oxffffaa@gmail.com,
 horms@kernel.org, davem@davemloft.net, stefanha@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 21 May 2025 14:17:05 +0200 you wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> 
> In `struct virtio_vsock_sock`, we maintain two counters:
> - `rx_bytes`: used internally to track how many bytes have been read.
>   This supports mechanisms like .stream_has_data() and sock_rcvlowat().
> - `fwd_cnt`: used for the credit mechanism to inform available receive
>   buffer space to the remote peer.
> 
> [...]

Here is the summary with links:
  - [net] vsock/virtio: fix `rx_bytes` accounting for stream sockets
    https://git.kernel.org/netdev/net/c/45ca7e9f0730

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



