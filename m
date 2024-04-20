Return-Path: <kvm+bounces-15417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E56658ABB83
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 14:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99438281C81
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 12:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF69D38DED;
	Sat, 20 Apr 2024 12:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1odxXIU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AB3625;
	Sat, 20 Apr 2024 12:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713615543; cv=none; b=VsLrmQMckV0yP4ocJQfe0ZXbIvSZyFPkiaQ7D6jsYuM5nFSen6asXoUMptkkvySwjYfaVE3PQZn78MTKbVPdDuthHB7FT/F7+w4PVtz8DfgKZQve/QQ+HAVSg0U4Z3nyDNoP1pH0hpV3CvPaPIlKywA5xo682iF8dw9Gdsuys4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713615543; c=relaxed/simple;
	bh=s4mWIXWxyht0aSXhXrZOAfvyD8lmlWG8BLqbOkw+Oek=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u2r54xLw9i0+xb/g81iBynnsWOPjlgscOQVwurEx2TZDHBu9968PM2cgMELJDPPM6yHsK8iqTsgP9AcKMmm6UpUIePSEsd98hr9sKuVvPfK0nhovkenK7q7HfR7fJLPH4e4Mx7WLnrkTg1xP/gyeMtjN7Yp+NIe8PGYfNAYPoEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1odxXIU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BBFC072AA;
	Sat, 20 Apr 2024 12:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713615542;
	bh=s4mWIXWxyht0aSXhXrZOAfvyD8lmlWG8BLqbOkw+Oek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1odxXIUau035zhgfF8Zfh6CORUGFChANdTt/3W8+S6MP0skq+XWNg+QgPpv5a5+j
	 DweqqgggacqSR4JQkH9MPUGCn4xjp3HxK7Fy45PxI8LEDC90kEs5p5SR4LR4MfiMlA
	 3AV2ZQIZkYqDWBEUUTIoxENqTn2zwMxLyAc5EjJLkRBA8+ZiPSSqG18ms8jh5HqvHB
	 buboXVbTq8PNhe0FehlSaEaAACK/MRzS0eXmxo6EbkXJymmd/PWUgCfYRt1lx0MngN
	 5G2DqzWjHskU4NpaPgRFqYKehvedCKP6dtwY5c2ZBgOWA6NOr6Dq4L/WwmeuFLnzIs
	 OGyMhBj6tUkRQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ry9gK-006LiQ-6G;
	Sat, 20 Apr 2024 13:19:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 00/15] KVM/arm64: Add NV support for ERET and PAuth
Date: Sat, 20 Apr 2024 13:18:55 +0100
Message-Id: <171361549214.2166024.2127742043464371496.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 19 Apr 2024 11:29:20 +0100, Marc Zyngier wrote:
> This is the fourth version of this series introducing ERET and PAuth
> support for NV guests, and now the base prefix for the NV support
> series.
> 
> Unless someone shouts, I intend to take this in for 6.10.
> 
> * From v3 [3]
> 
> [...]

Applied to next, thanks!

[01/15] KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
        commit: 1b06b99f25e0c957feb488ff8117a37f592c3866
[02/15] KVM: arm64: Add helpers for ESR_ELx_ERET_ISS_ERET*
        commit: 80d8b55a57a18b0b1dac951ea28bfd657b14facc
[03/15] KVM: arm64: Constraint PAuth support to consistent implementations
        commit: a07e9345615fb7e7dd4fd5d88d5aaf49085739d0
[04/15] KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
        commit: 6f57c6be2a0889cc0fd32b0cd2eb25dfee20dde3
[05/15] KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
        commit: 04ab519bb86df10bb8b72054fce9af1d72c36805
[06/15] KVM: arm64: nv: Add trap forwarding for ERET and SMC
        commit: 95537f06b9e826766f32e513d714e1cda468ef15
[07/15] KVM: arm64: nv: Fast-track 'InHost' exception returns
        commit: dd0717a998f77f449c70bee82626cbf9913fe78d
[08/15] KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
        commit: 4cc3f31914d6df9dba8825db933d19c60028f5a8
[09/15] KVM: arm64: nv: Handle HCR_EL2.{API,APK} independently
        commit: 279946ada1f26a905061d0d6f134fff9e7b14239
[10/15] KVM: arm64: nv: Reinject PAC exceptions caused by HCR_EL2.API==0
        commit: 15db034733e4df3ca8ab4bf0a593a8a9b4860541
[11/15] KVM: arm64: nv: Add kvm_has_pauth() helper
        commit: 719f5206a8fd8336d23ccda6fe2a3287fbfb4c92
[12/15] KVM: arm64: nv: Add emulation for ERETAx instructions
        commit: 6ccc971ee2c61a1ffb487e46bf6184f7df6aacfb
[13/15] KVM: arm64: nv: Handle ERETA[AB] instructions
        commit: 213b3d1ea1612c6d26153be446923831c4534689
[14/15] KVM: arm64: nv: Advertise support for PAuth
        commit: f4f6a95bac49144c0d507c24af9905bb999a4579
[15/15] KVM: arm64: Drop trapping of PAuth instructions/keys
        commit: 814ad8f96e929fa9c60bd360d2f7bccfc1df0111

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



