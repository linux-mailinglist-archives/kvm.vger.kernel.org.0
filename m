Return-Path: <kvm+bounces-28933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 226B599F4B4
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 20:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC72C1F23261
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07792281EC;
	Tue, 15 Oct 2024 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuGT0VK8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E141C227BB2;
	Tue, 15 Oct 2024 18:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729015236; cv=none; b=c2jM7eQf+0bM8GNsN0K0c8xvMPt61E/2NrY2Ji/f21jm7rFdjacLmRS1p/bRlmLIx8lfpoR0IT9LDGHxwImrbK6QAONEI+nS+1ZV8hQTQDaCEDMTub2sW3ukrp6+FucIDo1Z3Uual3L7+XxQLRUL+J6LN90SAmKGBGBhNEEghcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729015236; c=relaxed/simple;
	bh=Sa6sgGhK0f0PdlrPB+pJBNsb8BQKXN13Ox+Haom2HEI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=rOFWgFWCtnk4LDFVUepGg8Wdy5Obtp+5s6OFL/CKc93EQ78wKLcV8yACYzyKZHbBSDn4msnMRW6rT+3pbIZk4GVmnDCCR4IfDsjaOgXsftc4jryiei/ZLr8Iz/rBr3IP4aTlKeDtL8Gn2khJfxmAkplpQf/mEBGFmBMOIKGqFFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuGT0VK8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE2EC4CEC7;
	Tue, 15 Oct 2024 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729015235;
	bh=Sa6sgGhK0f0PdlrPB+pJBNsb8BQKXN13Ox+Haom2HEI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KuGT0VK8S5iZkpWwdj4icg6/wNAAUrBPevfh4SZqoijO/LK0M//4+TxvzWdvkTnPh
	 ej10iYjREMrmMJ2Gu5Npr2RUIAnkdhPsv3wpjIS9oD4lasA8tAu3GCw1fTFYauLrpu
	 3RuHOcS958KJIGxUYsp0ERB1QMGW0dSsPNdQ80PsrTJLr49xkilO6b+UUnJ05d1/wn
	 JClelGibXCeLsadFDN2D9J1PR77WpKnQ3JH6qPkguuPszYj5ShJSHAIV1To4/BfUf4
	 6EO69W5HKU6Kiqfv8lDFOsDsbIiS0OIBybyVPrn0xkepuW1lWPDAUwAp49hj4XETun
	 TYtKkZ3F14U8g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D453809A8A;
	Tue, 15 Oct 2024 18:00:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/17] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172901524099.1243233.14809044192149107515.git-patchwork-notify@kernel.org>
Date: Tue, 15 Oct 2024 18:00:40 +0000
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
In-Reply-To: <20241013201704.49576-1-Julia.Lawall@inria.fr>
To: Julia Lawall <julia.lawall@inria.fr>
Cc: linux-nfs@vger.kernel.org, kernel-janitors@vger.kernel.org,
 vbabka@suse.cz, paulmck@kernel.org, tom@talpey.com, Dai.Ngo@oracle.com,
 okorniev@redhat.com, neilb@suse.de, linux-can@vger.kernel.org,
 bridge@lists.linux.dev, b.a.t.m.a.n@lists.open-mesh.org,
 linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
 netdev@vger.kernel.org, ecryptfs@vger.kernel.org,
 linux-block@vger.kernel.org, npiggin@gmail.com, christophe.leroy@csgroup.eu,
 naveen@kernel.org, maddy@linux.ibm.com, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 13 Oct 2024 22:16:47 +0200 you wrote:
> Since SLOB was removed and since
> commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
> it is not necessary to use call_rcu when the callback only performs
> kmem_cache_free. Use kfree_rcu() directly.
> 
> The changes were done using the following Coccinelle semantic patch.
> This semantic patch is designed to ignore cases where the callback
> function is used in another way.
> 
> [...]

Here is the summary with links:
  - [01/17] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [02/17] ipv4: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    https://git.kernel.org/netdev/net-next/c/497e17d80759
  - [03/17] inetpeer: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    https://git.kernel.org/netdev/net-next/c/bb5810d4236b
  - [04/17] ipv6: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    https://git.kernel.org/netdev/net-next/c/85e48bcf294c
  - [05/17] xfrm6_tunnel: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [06/17] batman-adv: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [08/17] net: bridge: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    https://git.kernel.org/netdev/net-next/c/4ac64e570c33
  - [10/17] can: gw: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [14/17] kcm: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    https://git.kernel.org/netdev/net-next/c/7bb3ecbc2b6b
  - [15/17] netfilter: nf_conncount: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [16/17] netfilter: expect: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [17/17] netfilter: xt_hashlimit: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



