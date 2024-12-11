Return-Path: <kvm+bounces-33525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08BD89ED9D0
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4AF9282D91
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D451F4E48;
	Wed, 11 Dec 2024 22:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZTzYvxN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F22E1F4706;
	Wed, 11 Dec 2024 22:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733956340; cv=none; b=kcBuFIoMFySD8IS+CKzH4lbcPSAEUQ2yOXmgyCwuTH5M5qpNqUi30P9cwkxdSZ8Q4Ge2sgMz55BknpeiwFP+AvjPoBRgAIM9GcBsY6EzAYLSz93qC5b6uFKT4ZnZNUK7lQCKLHEx+NaWG7ZZTISMRjt3ATFzoREdAm5PxJbpFfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733956340; c=relaxed/simple;
	bh=SL+9+Q0zX1tM74INOwLbIbE4XWzgTiWIBxGgYOOTQlo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=hAjBuU+HRZrSlKdJX3q/sf+nfI78yT4Hfem+yQWQhRAFf61Qxczuv19yYhHkf5qE+REZA66FRwCvqMWGCUt2nO7iLrsDx7FlrWLNVX3z2FWxRA0H7Zzbo+vX9UnSNWx3tn0ZlcXYUeMZbC0Em6jiEBJIZN9DF2YHSpmweyX9U20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZTzYvxN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0CDC4CEDF;
	Wed, 11 Dec 2024 22:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733956340;
	bh=SL+9+Q0zX1tM74INOwLbIbE4XWzgTiWIBxGgYOOTQlo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TZTzYvxN3lAr1c8GNo20ftFB1GrsFS6HFevwYdyB3ZdD18BUJaddBMvh9vgJ0V1pk
	 LX0zaiKMTZ/gElqmc0M1mW1FBq0kxQWpSHOlhm+i6Sv0hewEmgnfSabuhT3oj5+qeX
	 1iQ3igxD+o3M6k61DvkNf8Ry4ZZWvtp4GEBtjGJDWHBrbknZNNVM1ct6o3VAHMz+v/
	 6MBOQ+/7ooQzOl2B9pDpDYluTWxfCevgVnSyIN8qY18UWcalk654rM7/+3Gy7rylPi
	 9/crC0u+6mbfAznZR3RejbGEZo3d940T8IpkqUQ5pcyFA9jarjp9yqET3++bAlkPna
	 dXfF37wgf0iJA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E18380A965;
	Wed, 11 Dec 2024 22:32:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/1] RISC-V: KVM: Fix APLIC in_clrip and clripnum write
 emulation
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <173395635599.1729195.3021974708700896861.git-patchwork-notify@kernel.org>
Date: Wed, 11 Dec 2024 22:32:35 +0000
References: <20241029085542.30541-1-yongxuan.wang@sifive.com>
In-Reply-To: <20241029085542.30541-1-yongxuan.wang@sifive.com>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, greentime.hu@sifive.com,
 vincent.chen@sifive.com, anup@brainfault.org, atishp@atishpatra.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu

Hello:

This patch was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Tue, 29 Oct 2024 16:55:39 +0800 you wrote:
> In the section "4.7 Precise effects on interrupt-pending bits"
> of the RISC-V AIA specification defines that:
> 
> "If the source mode is Level1 or Level0 and the interrupt domain
> is configured in MSI delivery mode (domaincfg.DM = 1):
> The pending bit is cleared whenever the rectified input value is
> low, when the interrupt is forwarded by MSI, or by a relevant
> write to an in_clrip register or to clripnum."
> 
> [...]

Here is the summary with links:
  - [v2,1/1] RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation
    https://git.kernel.org/riscv/c/60821fb4dd73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



