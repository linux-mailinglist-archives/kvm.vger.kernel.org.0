Return-Path: <kvm+bounces-12510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4F88871B7
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD9E21C21483
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B906026D;
	Fri, 22 Mar 2024 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHDUMfvc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F935FBAE;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127409; cv=none; b=Mk8dZjLALXgkr5MgMEoHeMnAi1+A8GvuL1pGQhcDhTWPuO3A1itp0cBjLZsgdUam+usTsGjiiQZtrL/mPlOZi7fYsSi+MCfI/nFa9aj7vAFa+pCBbjEFyYyQlAvU3lKKB/iw4Wo7gqebPQF9qW2gJ2W5+qKAnQ4K42WR4YWNZGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127409; c=relaxed/simple;
	bh=zqbto1UmFuSmHwc92ciLO6aw2BxpiQNSK64sqGYAFsU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NX05fvT84H8pceo8N0BRkSXfzL0i2REiN0gEO50LAcULwVL9AUkO36rgkcejHv582Z7ayJgGRa2S/loawtlPNQXpXmnJSNNjqj4d2Js1BZd0GZqLg/YtN7dMsGXHNmZrwkkJZFuNr3V5f+GlilXA4fxVSuzyqOgX6fRiMEQadho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHDUMfvc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121F1C433F1;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711127409;
	bh=zqbto1UmFuSmHwc92ciLO6aw2BxpiQNSK64sqGYAFsU=;
	h=From:To:Cc:Subject:Date:From;
	b=kHDUMfvcf2QXTd2JL0Ih7PkXIvfxZ3hiDBnl49PfrEGMUp33iSR8dKCETzBlQJ7zK
	 9kCZbAeAtZXG7nxEWM9cW0Of1SrHWDFffNxxJC76vzj5dpV4tdgYV0BqOC+vm1lg8j
	 aGm26QFchubtmpB27F+dQxTKsynuUIZ6hr5gzTVCPEzYnapC7iEicXvSut1pY+vtlg
	 CGTWhuJGewLDaeJmkbZM1YsG9jz5JcUXBahm0ghCNe6EWyFPeIbv4hyxB+vH9IW+gB
	 IwKOVGKRMhpOBdjTi/7fw5o0rYLGuogo9DD+sXG6G7I2/e6krIavMaVM8VGAY2O3nR
	 QVFCEQM636diw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rniP6-00EZPz-UI;
	Fri, 22 Mar 2024 17:10:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH v2 0/5] KVM: arm64: Move host-specific data out of kvm_vcpu_arch
Date: Fri, 22 Mar 2024 17:09:40 +0000
Message-Id: <20240322170945.3292593-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.clark@arm.com, anshuman.khandual@arm.com, broonie@kernel.org, dongli.zhang@oracle.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the second take on this series aiming at reducing the abuse of
the kvm_vcpu_arch structure, and moving things info the per-CPU
context.

* From v1 [1]:

  - Fixed the per-CPU accessor outside of the hypervisor code (the
    protected case is... interesting)

  - Spelling fixes

  - Collected RBs

  - Rebased on kvmarm-6.9

[1] https://lore.kernel.org/r/20240302111935.129994-1-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: Add accessor for per-CPU state
  KVM: arm64: Exclude host_debug_data from vcpu_arch
  KVM: arm64: Exclude mdcr_el2_host from kvm_vcpu_arch
  KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch
  KVM: arm64: Exclude FP ownership from kvm_vcpu_arch

 arch/arm64/include/asm/kvm_emulate.h      |  4 +-
 arch/arm64/include/asm/kvm_host.h         | 89 ++++++++++++++++-------
 arch/arm64/kvm/arm.c                      |  8 +-
 arch/arm64/kvm/fpsimd.c                   | 13 ++--
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  8 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   | 20 ++---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c        |  8 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c        |  3 -
 arch/arm64/kvm/hyp/nvhe/psci-relay.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c           |  3 +-
 arch/arm64/kvm/hyp/nvhe/switch.c          |  6 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |  6 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |  4 +-
 arch/arm64/kvm/pmu.c                      |  2 +-
 14 files changed, 102 insertions(+), 74 deletions(-)

-- 
2.39.2


