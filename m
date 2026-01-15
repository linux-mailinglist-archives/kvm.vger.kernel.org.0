Return-Path: <kvm+bounces-68103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE067D21DF0
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 090153026B3E
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 00:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F56B1A2630;
	Thu, 15 Jan 2026 00:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltACZlYZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944C81E50E;
	Thu, 15 Jan 2026 00:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768437544; cv=none; b=mFD6jSWF6jLzyZqpznAg+3nNSxrH62QxVnNSTTcADT+KHSijuNdw5Qyoh3fT+T2bTu7D6NT+e4mDCeB6GUTGkguNoV3dKQZdFIWdr7a3JcYp2lWRGcxVyI0AU3Xmn8ghgmxRH0rNkYRmvJP1E5bgSeSaguWpNbsYdeTSsAi4KdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768437544; c=relaxed/simple;
	bh=WS7t3IYx3J3S2sfRX9DCoDfu6yOLG0lLMoSGMRG7+X4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tfAZ/+5yxmykDvUBqQkwq4N9aBd6f3R6/dw9Rfqu/9elD/OFsF6RfLymKFVa7xjwVY6SruaJnwA/Vijvy7jZOXFX72bj0VA0qQGscedVuhlX3nPsPyOrF9OdbSOwIt6gh8N8xCReE4kMJXRKVXrNOBGUA0L7SO17TpKih+8IAdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltACZlYZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E154C4CEF7;
	Thu, 15 Jan 2026 00:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768437544;
	bh=WS7t3IYx3J3S2sfRX9DCoDfu6yOLG0lLMoSGMRG7+X4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=ltACZlYZs2UDJYv8s8k9TlXywIYpZWNHCwvgHAMfYZqY/R8Zaf7wpMh88m1HkBydD
	 Gc7hETrNO7iT1cYc7OagiSyMjsRJ77uUw9qPO6HpoXRCowImjF6KhRZ3C7F0bYHxqK
	 mot6FcZOOI4FzhB+kqOiO11LiDVSQaIHv8G97KZM04TNUIHW9Wsh97cAYTQkE3ledh
	 NRjJlxqbRl3w6y25gsMgqfFQU+1AMjovYcvcVNBPGIyGQk065QELZC3CWTDnmMIgOY
	 9yRMzcoikBMnjMZWmV6weqdItRB/uxRlL5Mr37OUto7XLBbzVacovEdjMlMxudkSkp
	 SWxD4U47bZi4w==
Date: Wed, 14 Jan 2026 17:39:02 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Naohiko Shimizu <naohiko.shimizu@gmail.com>
cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
    anup@brainfault.org, atish.patra@linux.dev, daniel.lezcano@linaro.org, 
    tglx@linutronix.de, nick.hu@sifive.com, linux-riscv@lists.infradead.org, 
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
    kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 0/3] riscv: fix timer update hazards on RV32
In-Reply-To: <20260104135938.524-1-naohiko.shimizu@gmail.com>
Message-ID: <10a102b9-1dd1-c5ca-66e4-f02794a84a93@kernel.org>
References: <20260104135938.524-1-naohiko.shimizu@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sun, 4 Jan 2026, Naohiko Shimizu wrote:

> This patch series fixes timer register update hazards on RV32 for
> clocksource, KVM, and suspend/resume paths by adopting the 3-step
> update sequence recommended by the RISC-V Privileged Specification.
> 
> Changes in v3:
> - Dropped redundant subject line from commit descriptions.
> - Added Fixes tags for all patches.
> - Moved Signed-off-by tags to the end of commit messages.
> 
> Changes in v2:
> - Added detailed architectural background to commit messages.
> - Added KVM and suspend/resume cases.
> 
> Naohiko Shimizu (3):
>   riscv: clocksource: Fix stimecmp update hazard on RV32
>   riscv: kvm: Fix vstimecmp update hazard on RV32
>   riscv: suspend: Fix stimecmp update hazard on RV32
> 
>  arch/riscv/kernel/suspend.c       | 3 ++-
>  arch/riscv/kvm/vcpu_timer.c       | 6 ++++--
>  drivers/clocksource/timer-riscv.c | 3 ++-
>  3 files changed, 8 insertions(+), 4 deletions(-)

Thanks, queued for v6.19-rc. 


- Paul

