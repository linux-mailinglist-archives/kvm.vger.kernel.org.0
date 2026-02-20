Return-Path: <kvm+bounces-71387-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AFQ3MzHfl2ni9gIAu9opvQ
	(envelope-from <kvm+bounces-71387-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 05:12:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B681648F7
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 05:12:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2FAB33053BE8
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 04:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916B22F3C30;
	Fri, 20 Feb 2026 04:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mK6b8wox"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0132308F0A;
	Fri, 20 Feb 2026 04:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771560636; cv=none; b=Fr5KJvq2jR6tDEfPnlQHswSlsusjIXYp5graNBpj6VZKZZ02oavDRKyzGWOr+MtzqS7yY3Zlr6ecEFV+hkd61yGpIxSqZ5QjfK3xUjs702c5Vkj9StHJJxL8jijZ7dxgndXNrUolvoFez+3nRr+FoIBLw4HYjDHmkQQtIseXKw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771560636; c=relaxed/simple;
	bh=Ifpckop5sDPNCgmdPL4sGXc0scyTZuad/LyPyb/8d1Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=jrVziPf7q5Yp7NTseoXZa1VOXLapSOriar5RsKZMaR7XRSo7PXFyiXtyaGXQVnzGM3fFeMgVTIc5ZFhyc2pEigXLYI7zGPHRSbFQS09PkNOg/vN+59sjL5loAqbXGgGERuJM1h5I97y2tn56ltX6UK7031Aoo94eip+ykFiSNFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mK6b8wox; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C77C2BC87;
	Fri, 20 Feb 2026 04:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771560636;
	bh=Ifpckop5sDPNCgmdPL4sGXc0scyTZuad/LyPyb/8d1Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mK6b8wox98nl2xIIq+AirgaDUITrg6ikL3liq5eXJET9k3Yon4jEipvaywhEvQJuJ
	 +XZXQWUly4/pUm8yG4fuLZpep3z5QKB3RlQh6tNIaWtBPhTKANKc+h843s2NdFOmGh
	 xhFR6wzGtSgVyH7OQyfEs+lOXq5SnkZQc2gstZHdg2Yx8vF5pn3CpGHyuyA2NmUGVp
	 7uFPlJXR/Q85k9UoBJb/IuYyCxX5IVZs5lrw1ZDiTm5C2wUPUmGdo1/rwpE64PZHWl
	 C7hEU2Lbw9R9cCL5YkC1n86LlWOHsFJ2oRfSBtg6hbCOFvt+kQYVjbN5ckyV3zNYjX
	 kAG5miQD2CIMQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 400123809A88;
	Fri, 20 Feb 2026 04:10:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] RISC-V: KVM: Skip IMSIC update if vCPU IMSIC state is not
 initialized
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177156064504.189817.4302642983283569881.git-patchwork-notify@kernel.org>
Date: Fri, 20 Feb 2026 04:10:45 +0000
References: <20260127084313.3496485-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260127084313.3496485-1-xujiakai2025@iscas.ac.cn>
To: eanut 6 <jiakaipeanut@gmail.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, anup@brainfault.org,
 atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, xujiakai2025@iscas.ac.cn,
 jiakaiPeanut@gmail.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[lists.infradead.org,vger.kernel.org,brainfault.org,linux.dev,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,iscas.ac.cn,gmail.com];
	TAGGED_FROM(0.00)[bounces-71387-lists,kvm=lfdr.de,linux-riscv];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 91B681648F7
X-Rspamd-Action: no action

Hello:

This patch was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Tue, 27 Jan 2026 08:43:13 +0000 you wrote:
> kvm_riscv_vcpu_aia_imsic_update() assumes that the vCPU IMSIC state has
> already been initialized and unconditionally accesses imsic->vsfile_lock.
> However, in fuzzed ioctl sequences, the AIA device may be initialized at
> the VM level while the per-vCPU IMSIC state is still NULL.
> 
> This leads to invalid access when entering the vCPU run loop before
> IMSIC initialization has completed.
> 
> [...]

Here is the summary with links:
  - RISC-V: KVM: Skip IMSIC update if vCPU IMSIC state is not initialized
    https://git.kernel.org/riscv/c/003b9dae53ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



