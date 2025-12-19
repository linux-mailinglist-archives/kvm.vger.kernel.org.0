Return-Path: <kvm+bounces-66311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2814CCEF44
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 09:24:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2B5833084885
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 08:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5EE2FF653;
	Fri, 19 Dec 2025 08:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qxl4+v7E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB4F2FF66B;
	Fri, 19 Dec 2025 08:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766132010; cv=none; b=V4+Mo0nvFSXic3DsCemTgHmQ/HPhwPotpAniWAhqPZQDrfBj7WKE6ojGBpc3X8i2PDNVbYmv/8r5XsDdKvyRJO8EHttdpaMsguVHp2+ZMW8cUmyU3MJy4V2uhRHhLIGTtVeyEX5e1xZfqAcYxMXuMYyM06BFvZV7PqMoIk+TF3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766132010; c=relaxed/simple;
	bh=l//QwgPNp1q4alMwyDOP8wGl2QpoY+/qlyQYNCdTd4I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=SAljGVsQoVRGJZBV57V39q686VT653toz9V7cNUU3emPuw2PIM8fRcxsc/D9oSGO3JoQ3MLdIeGrp0l+izrLhnlR8ejJbwkq3uM2dhMrn8kHvByaKK9OeoJ6ltUOkMf1HbXejXRlTpFDDGrBxRclSKd6g5eWbzfu0b3UyXtZaIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qxl4+v7E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE75C19425;
	Fri, 19 Dec 2025 08:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766132010;
	bh=l//QwgPNp1q4alMwyDOP8wGl2QpoY+/qlyQYNCdTd4I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qxl4+v7EchxSQ7uPMHgNydReNM1Y6n+K31KkYZykBB3zU4/1J55VuaieSBPlR9Uew
	 sLPPbZyXzw6pJ+styBQdsS0VRaDdqAl6U1hXPC2bUl0TvEu+rZd1OaDzNP4aOStHCw
	 ZZvMZqHw68rVGgMhd/UwwdRS24KcLQ02S/WO0J1ohgEOhsHUDqnR1nA5FOlM747o2y
	 erJR+P6geI4sQdGcE79OMvqcCMoTWhhpXEVOtbXXJGenq2Ir6sw+qs+MsKb7rWSt8r
	 14TrsfA2fV/kOFeqFhp7zu47yGs3J1syqT9XBu0q/JfKl9NfTeBHRszhr2z6HTblmW
	 GL+j2vbGTM0rw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 790A6380AA50;
	Fri, 19 Dec 2025 08:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] RISC-V: KVM: Fix guest page fault within HLV*
 instructions
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176613181927.3684357.6307325316578427331.git-patchwork-notify@kernel.org>
Date: Fri, 19 Dec 2025 08:10:19 +0000
References: <20251121133543.46822-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20251121133543.46822-1-fangyu.yu@linux.alibaba.com>
To: yu fangyu <fangyu.yu@linux.alibaba.com>
Cc: linux-riscv@lists.infradead.org, anup@brainfault.org,
 atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@kernel.org,
 ajones@ventanamicro.com, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Fri, 21 Nov 2025 21:35:43 +0800 you wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> 
> When executing HLV* instructions at the HS mode, a guest page fault
> may occur when a g-stage page table migration between triggering the
> virtual instruction exception and executing the HLV* instruction.
> 
> This may be a corner case, and one simpler way to handle this is to
> re-execute the instruction where the virtual  instruction exception
> occurred, and the guest page fault will be automatically handled.
> 
> [...]

Here is the summary with links:
  - [v3] RISC-V: KVM: Fix guest page fault within HLV* instructions
    https://git.kernel.org/riscv/c/974555d6e417

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



