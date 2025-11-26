Return-Path: <kvm+bounces-64774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7152BC8C46A
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 00:00:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 83E6E34EAA4
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1624630215A;
	Wed, 26 Nov 2025 23:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ritNPALR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B750218845;
	Wed, 26 Nov 2025 23:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764198045; cv=none; b=gWiDRTaAMVJy0OYwKgOITkqI/KQQJtzkWOKTnL1YcE2tQd1t1ceQErkpg/H11g2Mnn+5S0m4b4xpVF9HHjlg3SXN/2b6snPY2JUmmYRjgpf0EcAGB3tv7Y7E0Conl3j4K2b3YvrTW/yUpMDJ5NEd1j2kZCO9Vs0EkVRcO5jFPd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764198045; c=relaxed/simple;
	bh=7FXfQI/AZWdV4SZylJTzGl+kOWFrh8wKOPRgk71eBWg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Z412tezgh80f9NNTzNn/aoFx+60gOEhG/ZHSSaZPSqPZqn+UI3r52E2G4AWTyGZ+0kRYpQKZv4T79WW4h89qIiOkjKjKvIkyNy/C2uRWJ/J8el7ONOPZB2v5JZr5nDupfvttuGyAjJwaQ7hb1rYm2efz/k3ff0DRudu1OdAH39c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ritNPALR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3921C4CEF7;
	Wed, 26 Nov 2025 23:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764198045;
	bh=7FXfQI/AZWdV4SZylJTzGl+kOWFrh8wKOPRgk71eBWg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ritNPALRQD2PVOcu5YJ3n6Rt5W8boPORHPYaviwRC2my89qhXPhIH2u+7KdmNaps7
	 A9tPWLX5qX+oSRrjgD5RWi6hzFKxcPebWha3vicd8aAZIciewu73y6zJRUB6sKIkqZ
	 NyKU/Me5NovzeoBoQsx1SK+UOQIuTv5x3/FxgaHW6l+YtWL8iz5zgIk3mieH1RZ+IG
	 UGouZB7HCWF1DUjnAdhzGshTAFJ95sarCUDlFdqMnSYnEkk1oCt9J/WLKe8qAwEkVC
	 Ra1bbG0PnJgnuXccpHvuzHiNMB0Zr16fibk/WStAvcvaD8jUlARk6gG/0SnK41Top2
	 p+9Trxnqs3kKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB07A380CEF6;
	Wed, 26 Nov 2025 23:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] vhost: rewind next_avail_head while discarding
 descriptors
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176419800676.1877685.4431775256421273877.git-patchwork-notify@kernel.org>
Date: Wed, 26 Nov 2025 23:00:06 +0000
References: <20251120022950.10117-1-jasowang@redhat.com>
In-Reply-To: <20251120022950.10117-1-jasowang@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Nov 2025 10:29:50 +0800 you wrote:
> When discarding descriptors with IN_ORDER, we should rewind
> next_avail_head otherwise it would run out of sync with
> last_avail_idx. This would cause driver to report
> "id X is not a head".
> 
> Fixing this by returning the number of descriptors that is used for
> each buffer via vhost_get_vq_desc_n() so caller can use the value
> while discarding descriptors.
> 
> [...]

Here is the summary with links:
  - [net,V2] vhost: rewind next_avail_head while discarding descriptors
    https://git.kernel.org/netdev/net/c/779bcdd4b9ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



