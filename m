Return-Path: <kvm+bounces-45551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E5B6AAB8F0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE6BD16BDB1
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889CA1A2557;
	Tue,  6 May 2025 04:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E58El8rg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B902C1E34;
	Tue,  6 May 2025 01:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746495597; cv=none; b=XVhCRupf92nvA5/5efuAnBoDWCECy/eIDPT2ybplHYY0zbChD9h0XiJ6PxB0a8YARv2xNdAFyYelpV2gi8HmV/+NMruUK5BiRn0U8mZ/+IHBNMtqoxMMChBjZ3RoB99yT3Z/0CyipIFubE2kR9pPUaY4ekzrEzWISnVy4Ns4540=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746495597; c=relaxed/simple;
	bh=RG7Fv4098vXZjKXhbYhSAmFoeYwghoNLjQ6woj5h+vQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=hVeIEH5hBR6F2rjvRV6Qd97wScYr6WTkEEh/cnzqESQuCAyY/lSdYTRn8oQSIbucVH4ICy9yCoEq0vwI4Vxsic8xTnbn46Fx2SUad5Ao1r22uLuJpJ8jE2q5lV+8yKkAMOH/USEDxlQKjALUNakq9Ga9kBoKusrttWtZuvs49qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E58El8rg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B260AC4CEE4;
	Tue,  6 May 2025 01:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746495596;
	bh=RG7Fv4098vXZjKXhbYhSAmFoeYwghoNLjQ6woj5h+vQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=E58El8rgXquEtN8ubo2Plj5XwQnib9vZEvNYqi6QSLlNzDg5KcL83KhQ4p7B0i7Yl
	 jh9HAGlxggCzxmhYMXIPau2IiYx3GgqK9wo94OgoDTYX0PO9knEoZgyqC+/jIry9Bf
	 c+rvzhuc8s0UEWn+I6M4gRgcnzFFUQuDKTQqFozNjmTD2gSgdLAu7bKpZQE/ubJHrh
	 ofENS+3MdRO6vMCJ2S5IeNG/7waVGd5XaSWjF477YaCWSPNuOwtcR6ezklZXelsSml
	 ms6oVQl8hK1GdOKqTIaAjafJioKAbQisvR7H59jnTiowVQs/eQLaEmjePVipqp5Wr0
	 VT00OdZSerh+Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33AC7380664B;
	Tue,  6 May 2025 01:40:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] vhost/net: Defer TX queue re-enable until after
 sendmsg
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174649563599.1007977.10317536057166889809.git-patchwork-notify@kernel.org>
Date: Tue, 06 May 2025 01:40:35 +0000
References: <20250501020428.1889162-1-jon@nutanix.com>
In-Reply-To: <20250501020428.1889162-1-jon@nutanix.com>
To: Jon Kohler <jon@nutanix.com>
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 30 Apr 2025 19:04:28 -0700 you wrote:
> In handle_tx_copy, TX batching processes packets below ~PAGE_SIZE and
> batches up to 64 messages before calling sock->sendmsg.
> 
> Currently, when there are no more messages on the ring to dequeue,
> handle_tx_copy re-enables kicks on the ring *before* firing off the
> batch sendmsg. However, sock->sendmsg incurs a non-zero delay,
> especially if it needs to wake up a thread (e.g., another vhost worker).
> 
> [...]

Here is the summary with links:
  - [net-next,v3] vhost/net: Defer TX queue re-enable until after sendmsg
    https://git.kernel.org/netdev/net-next/c/8c2e6b26ffe2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



