Return-Path: <kvm+bounces-48810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 257DEAD3EF2
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBF3F3A8BED
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 16:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F370E24677A;
	Tue, 10 Jun 2025 16:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPOuoFId"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5532459FF;
	Tue, 10 Jun 2025 16:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749572891; cv=none; b=eS6dpArbeVswSbb9Gfr3RNYnCwxi+PfAA4yLmvad46vBjxnbi/wXNj359hTWiNIvOQ4jahjiToOV/b6kHSA9WLhws4HRCtPQVNmY5NxhHLKU+QsYufCcpxRIsy0aB9roJbKafPQLt8S/54f4bMCbfh3sFS7Uwm3S264AXjtUXjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749572891; c=relaxed/simple;
	bh=ckC6thOTdPiUGu5TKE27pUsN8vQouOQ2AEYzFaexYD4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fvn3p3QMTGF/svNWugOjD8vRJRHM9Ouc5rPjviz93/U/Am7u96y2wfcHiacyBu5mawAozZBJkaI+4/AcuN7+AZDJrH/uHFZ5tK4vAqD3UtEOONlDqAiB8tLNryj5P/ICGWj1wGr7noNGpZQcJL6sd4SLSHbjNwsdd4/igNX7j3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPOuoFId; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2981C4CEF0;
	Tue, 10 Jun 2025 16:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749572891;
	bh=ckC6thOTdPiUGu5TKE27pUsN8vQouOQ2AEYzFaexYD4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EPOuoFId290O15qzATYhPnK7rUONYkV6lL/8chMjOVuZC9s8VmPEXY/Lksgfzrfl7
	 57hyVe3xyAyEq5JG6wEKdxNV0UFFkhwJ1i0hZQKBJ/CZ9ASszlaj+jKngnsM24GHxV
	 mWa3op9unMWMA5/bDrI1t7oJWv7IqMxNxmiB3XW5Om0t1qKk2p3TI/iz1Z0gGZErUd
	 g68pnaTddVz541C8x5SCft5DYa25RzbIhTBqzSliN3vqoZuY6MjiaZBywYmDkUwhyb
	 fOzAGVXQ+TzYNv2X6IZgs/DgcGOlaRbKjbXDM2Zb5IT5W5Gqnr+nb3YcqvJ6ZKcfOq
	 +xKJaaLUdXnMw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADD7339D6540;
	Tue, 10 Jun 2025 16:28:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] RISC-V: KVM: lock the correct mp_state during reset
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <174957292126.2454024.2746700614044204811.git-patchwork-notify@kernel.org>
Date: Tue, 10 Jun 2025 16:28:41 +0000
References: <20250523104725.2894546-4-rkrcmar@ventanamicro.com>
In-Reply-To: <20250523104725.2894546-4-rkrcmar@ventanamicro.com>
To: =?utf-8?b?UmFkaW0gS3LEjW3DocWZIDxya3JjbWFyQHZlbnRhbmFtaWNyby5jb20+?=@codeaurora.org
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, anup@brainfault.org,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, yongxuan.wang@sifive.com

Hello:

This patch was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Fri, 23 May 2025 12:47:28 +0200 you wrote:
> We're writing to *tmp, but locking *vcpu.
> 
> Fixes: 2121cadec45a ("RISCV: KVM: Introduce mp_state_lock to avoid lock inversion")
> Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_sbi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - RISC-V: KVM: lock the correct mp_state during reset
    https://git.kernel.org/riscv/c/7917be170928

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



