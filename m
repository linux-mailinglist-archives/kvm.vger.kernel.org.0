Return-Path: <kvm+bounces-52219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 007B2B02775
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 01:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49C27587838
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1902236E8;
	Fri, 11 Jul 2025 23:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBAmpCav"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C091A3145;
	Fri, 11 Jul 2025 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752275407; cv=none; b=Kpt2wFex6X2Sp52b0grTaZhkuH861Naoorr2dERPpJu2vd1A7kTAMTDxsJJ5Zxm0lCzAI7BdBprOZ94nCZZApIJ2Sjg5iL+WZyoeRNwV9BSn/ov+3MqM8rUEhX01QheZGp1VmR+fZkjR8o61mRk/kEwrbYNNjCuxEVfIBBlG4xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752275407; c=relaxed/simple;
	bh=tKheb8OjsLoz5R8RDmCIXx68KmbGB8ishC8u4d7w0qo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=EW1zMkfyLzPG6TBhnBpZNWAHJL1WKcy54+TGTE226UoVy+u7DcuKTa1Aowz4E1IrepVNmN6WGPEpYUJyQt78UVGswP/kUWqHF4NN1FUCKX2VbgZ1+vvHnIsjyV79toZY/faFYOOcQiiu6oPkB48vGnzafMCgjv1jvwvP3EnhbDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBAmpCav; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24270C4CEED;
	Fri, 11 Jul 2025 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752275405;
	bh=tKheb8OjsLoz5R8RDmCIXx68KmbGB8ishC8u4d7w0qo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kBAmpCav8UawscICq11TjS1xmaXivlfU+81KKNmwlAUucB434hpKWNce49BNAGENJ
	 t0BWHZvQhzA2vKl0ZqGW0RN7nXeYm8U2FgvcUOQZrMyxgDB/SxCXp2TDmQ92zqBczL
	 Yaz6CBLDRVuTg2GIZl1qSGZ6+L4HKXhzK8RzJ81+sxdMRCBA311V1FZuhnSJ9k5is4
	 EO0F4eWSedKzpb0HPY+rZhVDS4OesML6S+vsi0sgVoszDTNyMHT0R9V5Dyff+OBvBL
	 kBazLcyn3YuKD7ihQH0+lQnHvjbZPZX+cQVtrCAHv13sR9tEgxBuQo4xLCHg/U2XCt
	 KgOKKx7x8CURA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33B7D383B275;
	Fri, 11 Jul 2025 23:10:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] virtio_net: simplify tx queue wake condition check
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175227542702.2429127.17012200251961296918.git-patchwork-notify@kernel.org>
Date: Fri, 11 Jul 2025 23:10:27 +0000
References: <20250710023208.846-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20250710023208.846-1-liming.wu@jaguarmicro.com>
To: Liming Wu <liming.wu@jaguarmicro.com>
Cc: mst@redhat.com, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, angus.chen@jaguarmicro.com, leiyang@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Jul 2025 10:32:08 +0800 you wrote:
> From: Liming Wu <liming.wu@jaguarmicro.com>
> 
> Consolidate the two nested if conditions for checking tx queue wake
> conditions into a single combined condition. This improves code
> readability without changing functionality. And move netif_tx_wake_queue
> into if condition to reduce unnecessary checks for queue stops.
> 
> [...]

Here is the summary with links:
  - [v2] virtio_net: simplify tx queue wake condition check
    https://git.kernel.org/netdev/net-next/c/2f82e9954662

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



