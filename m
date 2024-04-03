Return-Path: <kvm+bounces-13410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBEA08961CB
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 03:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24DE41C22399
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 01:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6BC179BE;
	Wed,  3 Apr 2024 01:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5lvH2Ou"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEDC33E1;
	Wed,  3 Apr 2024 01:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712106627; cv=none; b=U/d/+T9qYdWVYO+GhVMEfikIExdw3WN3uqKalaYUBai6490ZCGdAOBlCDXXwgkLJAM8DEuIqJWoTb1np6S684wmzS0f84aLk2YgLm+dHvL+hw1xRFyCW7ns3FlEXGQNszKGHZiOUWpr1vd4BBV/Az7dug0ynn5psNe5o4BwaDOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712106627; c=relaxed/simple;
	bh=dkk2ExlSTHUphfpzLrcP16omhm4msZO9WjRy+h4BTyw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=g2JaO/JDoTuK2XEQMnssuTHI5242JEGJrKgALj+Ojm94MWagA7sgBYa2uYnRAmbyYaKDEY/jSHNcWBulRmjiwlFDjgvhbcBlcgc/+nlw9Hc+1eL0zdDg0qAfcGNdu+aKxOurOWiEw86+RBn4b+n3qLpEcvpCsi4p1YMco/w+pkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5lvH2Ou; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39F99C433F1;
	Wed,  3 Apr 2024 01:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712106627;
	bh=dkk2ExlSTHUphfpzLrcP16omhm4msZO9WjRy+h4BTyw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=e5lvH2Ouf4B45kQyE7fOi3c5jI48EjzS3Glsj6Bi9XgphvZxOdHK/9hO+L7ScqKm2
	 mxTJXvRUby9tXo753/bDHG1d3Ex1jmnhhzirPj4lWKZ/LnPpACIvxHcRr6wW+A1wdP
	 MMSe+kNlOc115gnEOMcw5KkRIdnZAi/ORDzR5xlLKkUsOeFL9DgV2pirgvDOgoIc3S
	 WRecQ040a5A9pvE1dJAgzFMKe4uIfqFtTf6V1D0/d2XD/Gx/8MF5ndZVlVVFYmMy0A
	 HSD5ikH7OeBbh98SbxNlr9a8eBrO/MZLumYjkMCyrVzjBK/+K1dLr2ga7Ib9hjZs8J
	 wg8ujMsrjKiPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22BAAC4314C;
	Wed,  3 Apr 2024 01:10:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] vsock/virtio: fix packet delivery to tap device
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171210662713.30217.16461640125861494356.git-patchwork-notify@kernel.org>
Date: Wed, 03 Apr 2024 01:10:27 +0000
References: <20240329161259.411751-1-marco.pinn95@gmail.com>
In-Reply-To: <20240329161259.411751-1-marco.pinn95@gmail.com>
To: Marco Pinna <marco.pinn95@gmail.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 ggarcia@deic.uab.cat, jhansen@vmware.com, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vge.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Mar 2024 17:12:59 +0100 you wrote:
> Commit 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks") added
> virtio_transport_deliver_tap_pkt() for handing packets to the
> vsockmon device. However, in virtio_transport_send_pkt_work(),
> the function is called before actually sending the packet (i.e.
> before placing it in the virtqueue with virtqueue_add_sgs() and checking
> whether it returned successfully).
> Queuing the packet in the virtqueue can fail even multiple times.
> However, in virtio_transport_deliver_tap_pkt() we deliver the packet
> to the monitoring tap interface only the first time we call it.
> This certainly avoids seeing the same packet replicated multiple times
> in the monitoring interface, but it can show the packet sent with the
> wrong timestamp or even before we succeed to queue it in the virtqueue.
> 
> [...]

Here is the summary with links:
  - [net,v2] vsock/virtio: fix packet delivery to tap device
    https://git.kernel.org/netdev/net/c/b32a09ea7c38

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



