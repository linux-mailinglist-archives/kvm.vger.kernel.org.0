Return-Path: <kvm+bounces-68177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A31D24626
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 13:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1C482301B125
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 12:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057FC392C45;
	Thu, 15 Jan 2026 12:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2dIoPLx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE011E8826;
	Thu, 15 Jan 2026 12:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768478851; cv=none; b=lDaov9pLk6o/4gPCiVY3X6JNxJw1WWdCeo9ZBMztDfMz9A0mAZww1YltUqjLt6Sol2zgWDQgMDNhzWh57CKkVZkndnQX5mFH3NrTI93FsreoK23xUHfgIVLTBRfZNwjqM43dgywEemCTNpx6v0BlgJDSKo4MzndwVOCgEUyefSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768478851; c=relaxed/simple;
	bh=f9T+RVKITvC3zGHO9fSKmJDHGMMiKmOzSVT26F83cNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TIMCIA8RZNBF1e7UawUFttlbe0D3yxGIH8htNiGAYJ6jKu48qjB+h4eHqLxazbK6Z2c0LHZLlNulpd+GU37k6Nm6aa6ctqtbnkhdV2Yo8XFOqMIIQwPKDJjO4KgpaskgmOQ6A4Zx1k2F/1eHLHXe1r2JUIvb6fM6HRyBGXNgYvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2dIoPLx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CC3C116D0;
	Thu, 15 Jan 2026 12:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768478850;
	bh=f9T+RVKITvC3zGHO9fSKmJDHGMMiKmOzSVT26F83cNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2dIoPLxARHFp6Wt9YYVD65OkaRzS6qKuuOMzIhOCpfcMkc94p4VpEEiiGCQ063QI
	 ivQL6K3tIdrgQXsyhRhjqXDT2VeXRqGkCAjHfF/3WE3qNGK3WDZpyKTvkbO6DNvsuS
	 /14JK3r3wWVrZ2BScofbQbl3r4a1eUZd1BCqn2iQaDQJU7AplAWk0o0aFg7GaDXVhY
	 CB7+44tkTPhNEUhDau5kaHq6a9m+Nkulvy4ImNk+HLLtuFzUdwC9I7phmjCBjGPJWb
	 9Da+p6v+u5RvQ3/XGpiqA9VFAH8w2dFJUf5fIOtnVEazRRaEom2briQBnh4hdr2nY5
	 Ps+oU0G7G7dBg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vgM8O-00000002W0n-3UaY;
	Thu, 15 Jan 2026 12:07:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v4 0/9] KVM: arm64: Add support for FEAT_IDST
Date: Thu, 15 Jan 2026 12:07:22 +0000
Message-ID: <176847883532.3732984.5442091537766378905.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108173233.2911955-1-maz@kernel.org>
References: <20260108173233.2911955-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 08 Jan 2026 17:32:24 +0000, Marc Zyngier wrote:
> FEAT_IDST appeared in ARMv8.4, and allows ID registers to be trapped
> if they are not implemented. This only concerns 3 registers (GMID_EL1,
> CCSIDR2_EL1 and SMIDR_EL1), which are part of features that may not be
> exposed to the guest even if present on the host.
> 
> For these registers, the HW should report them with EC=0x18, even if
> the feature isn't implemented.
> 
> [...]

Applied to next, thanks!

[1/9] arm64: Repaint ID_AA64MMFR2_EL1.IDS description
      commit: 4a7fe842b8a3f3c173c3075f03c60c3f9f62e299
[2/9] KVM: arm64: Add trap routing for GMID_EL1
      commit: 1ad9767accfcb81f404aa3d37d46b3eb494dce2f
[3/9] KVM: arm64: Add a generic synchronous exception injection primitive
      commit: 19f75678238734ef383f9e10d8e1020873e97170
[4/9] KVM: arm64: Handle FEAT_IDST for sysregs without specific handlers
      commit: d78a14decd494caf72ea0144624621e7e43ae451
[5/9] KVM: arm64: Handle CSSIDR2_EL1 and SMIDR_EL1 in a generic way
      commit: f07ef1bef67ca08799df262cc901971ac274783d
[6/9] KVM: arm64: Force trap of GMID_EL1 when the guest doesn't have MTE
      commit: 70a5ce4efc0e1194718aad6f26332c99e6a119db
[7/9] KVM: arm64: pkvm: Add a generic synchronous exception injection primitive
      commit: e5d40a5a97c1d57e89aa5f324734065c6580b436
[8/9] KVM: arm64: pkvm: Report optional ID register traps with a 0x18 syndrome
      commit: 592dc2c020686536dae1c427c78cf558a3df4414
[9/9] KVM: arm64: selftests: Add a test for FEAT_IDST
      commit: b638a9d0f8965b98403022cb91d8f3b31170eb35

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



