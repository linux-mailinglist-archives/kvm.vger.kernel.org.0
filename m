Return-Path: <kvm+bounces-17130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3738C143E
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 19:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B083B2202B
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 17:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6DA770E1;
	Thu,  9 May 2024 17:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NqQ+wlME"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5114E53E32;
	Thu,  9 May 2024 17:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715276718; cv=none; b=g9Uj9uECkbQVYWqvlbrmA+jg1AN+Urwfkfat0Dz7mq04v2MwoQ+bIG06rUTb4MvsMWU3SD568g9ZC5p1BFoE1V1vbJsP9IMIl0n6HRz15Ce2b6Hl3JdS/1lAe4Eoso6FOb9cjlQ6ztg+YvERSeX2/mk1SbNL5GrgOltddg9DpFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715276718; c=relaxed/simple;
	bh=uI/jcoOn27IenUTtYi5pEaLkKTsd5byWsMiZtN5dplw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GjKp3ON34OKlJtv/qrNtAbhXnhHyorB77F0i6er9Nn/yPxzVkN53+e5gafJtKNNh7XBCiXw4wpY78rhxGDT0MlAB0jMwwUfjIeGZAh1zcrAKHLW0CaZBBJzY+OTFNmw8jh0PFziCz+bAjWigvGRwkYrQe3LjxHvCUQQgSRPMMx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NqQ+wlME; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0435C116B1;
	Thu,  9 May 2024 17:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715276717;
	bh=uI/jcoOn27IenUTtYi5pEaLkKTsd5byWsMiZtN5dplw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqQ+wlME/00F2Y0GNRC9iHhSLrp/x810SvP4AdQ5eYgIa4YMP8BLjoaYjKE3FmMnA
	 oaOVnia5PSKp/Q2yZ9SikUN+QjobnGVvJ/9kpCGwN/FejZ7QGiawTrir1hV1KDXbpb
	 Uc9MFY3SE8iMRDpgipHgCKX97usz++JS05MDZmJ+ygJdNBdjIoEyPJZFjO8RjGwMqX
	 U9VHUSB6tg56TdadS0O9dYjTX2382W+RTP+adUHublemkJtZFnsnuoKvl3+JAw5XaU
	 hvO4QrdCtN7ufxhCta1aUVTs8kJXqNc53fKU4kbMRoiSqt1Ff9iuWQFP3V6xhPMfER
	 Lgxd5k4hPm48w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s57pT-00Bz46-Kh;
	Thu, 09 May 2024 18:45:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: arm64: Don't clobber CLIDR and MPIDR across vCPU reset
Date: Thu,  9 May 2024 18:45:08 +0100
Message-Id: <171527670205.3976407.7868446577218247391.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240502233529.1958459-1-oliver.upton@linux.dev>
References: <20240502233529.1958459-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 02 May 2024 23:35:22 +0000, Oliver Upton wrote:
> When I was reviewing Sebastian's CTR_EL0 series it occurred to me that
> our handling of feature ID registers local to a vCPU is quite poor.
> 
> For VM-wide feature ID registers we ensure they get initialized once for
> the lifetime of a VM. On the other hand, vCPU-local feature ID registers
> get re-initialized on every vCPU reset, potentially clobbering the
> values userspace set up.
> 
> [...]

Applied to next, thanks!

[1/7] KVM: arm64: Rename is_id_reg() to imply VM scope
      commit: 592efc606b549692c7ba6c8f232c4e6028d0382c
[2/7] KVM: arm64: Reset VM feature ID regs from kvm_reset_sys_regs()
      commit: 44cbe80b7616702b0a7443853feff2459a599b33
[3/7] KVM: arm64: Only reset vCPU-scoped feature ID regs once
      commit: e016333745c70c960e02b4a9b123c807669d2b22
[4/7] KVM: selftests: Rename helper in set_id_regs to imply VM scope
      commit: 41ee9b33e94a2457e936f0cc7423005902f36b67
[5/7] KVM: selftests: Store expected register value in set_id_regs
      commit: 46247a317f403e52d51928f0e1b675cffbd1046c
[6/7] KVM: arm64: Test that feature ID regs survive a reset
      commit: 07eabd8a528f511f6bbef3b5cbe5d9f90c5bb4ea
[7/7] KVM: selftests: Test vCPU-scoped feature ID registers
      commit: 606af8293cd8b962ad7cc51326bfd974c2fa1f91

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



