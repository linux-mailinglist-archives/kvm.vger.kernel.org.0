Return-Path: <kvm+bounces-62868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4C4C514DD
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 10:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3BCEF4F0AC2
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 09:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4519F2FE589;
	Wed, 12 Nov 2025 09:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u3n41DiZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E782FE061;
	Wed, 12 Nov 2025 09:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762938804; cv=none; b=lFA78Z4AchpioV98k2XeHXKtS+rhw7t7Da2a+r36qq9s0js/jK2hwVonFusOBBhXWfM0jF9sMBvnyV93vAjMia2XyEgIWNHbuevbUKtH0oW1Rc2hfUATuKw77t0k2bK5jtwDhuTzVOj2TucU8sJMJ4mdKggqd5xisEqCiIbHOZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762938804; c=relaxed/simple;
	bh=vuWPm/2U1JyrxzTC0qeLHk1VzUelYgaW5HYxZMdAbCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bAddD+7rrdo1pF9fd0kK/K/j8ryUNe2H6OFcvi1G/rJdWgtqEZFswF5xM3EV9YcP4SME/hh8vJ+v9nirKDxCehOBScqAAZ49QKUknzBoea/JryRl5xlLL93dajXWvRbF5s+Bu3+Cl+JlwAYf+5z0/B0kLeBOZA5SZbNqMOKlPew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u3n41DiZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8FAC2BCB9;
	Wed, 12 Nov 2025 09:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762938803;
	bh=vuWPm/2U1JyrxzTC0qeLHk1VzUelYgaW5HYxZMdAbCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3n41DiZ5wXWuZ5rToWsZO3IJB/Yg7TCpqgzCJHoxIuCqy+3GgmV2c9o/thhfCKhF
	 HQBuWYk8CxwNbtnmQQLyMfbdbxyFFoKOQq+eELWS0f924meNKF2lQX2Y/nSDgLMZde
	 GOfie1IgRHL5waOSuDucMbUfSpJEZ+tPhtmCy9CHNUpzTuz5cB6Si45riZ5mQZ3Xtq
	 M7C0Df9cmhZRR8WVdZeVF7qEaccJttnkLStLHMhNA6BP8VZs0viiVTVRWeZ0Eavkg1
	 0DjrmXH0SORl/Jqb0vl4wH5UUsEFFO8dM5Zsh/zXAWRabPTPMtNnhZXTpkqWMkhnvi
	 Xkv8UFb33VpNg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v2 00/45] KVM: arm64: Add LR overflow infrastructure
Date: Wed, 12 Nov 2025 01:13:18 -0800
Message-ID: <176293878773.2048542.1737784114701350028.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 09 Nov 2025 17:15:34 +0000, Marc Zyngier wrote:
> This is the 2nd version of the series originally posted at [1]. The
> series has significantly evolved with a bunch of bug fixes, some
> additional optimisations, and a number of test cases.
> 
> This has now been extensively tested on much of what I have access to,
> specially on some of the most broken stuff (Apple, Qualcomm, Cavium,
> ARMv8.0 CPUs without TDIR), but also on some less shitty systems
> (which are the minority, unsurprisingly).
> 
> [...]

Applied to next, thanks!

[01/45] irqchip/gic: Add missing GICH_HCR control bits
        https://git.kernel.org/kvmarm/kvmarm/c/435d529bf5cd
[02/45] irqchip/gic: Expose CPU interface VA to KVM
        https://git.kernel.org/kvmarm/kvmarm/c/5bebf839b2e7
[03/45] irqchip/apple-aic: Spit out ICH_MISR_EL2 value on spurious vGIC MI
        https://git.kernel.org/kvmarm/kvmarm/c/5a9655de7241
[04/45] KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant
        https://git.kernel.org/kvmarm/kvmarm/c/ca30799f7c2d
[05/45] KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping
        https://git.kernel.org/kvmarm/kvmarm/c/375e16720b4c
[06/45] KVM: arm64: Repack struct vgic_irq fields
        https://git.kernel.org/kvmarm/kvmarm/c/10576b2d8652
[07/45] KVM: arm64: Add tracking of vgic_irq being present in a LR
        https://git.kernel.org/kvmarm/kvmarm/c/023c81ada994
[08/45] KVM: arm64: Add LR overflow handling documentation
        https://git.kernel.org/kvmarm/kvmarm/c/2a69aca33cac
[09/45] KVM: arm64: GICv3: Drop LPI active state when folding LRs
        https://git.kernel.org/kvmarm/kvmarm/c/9fc8456206e8
[10/45] KVM: arm64: GICv3: Preserve EOIcount on exit
        https://git.kernel.org/kvmarm/kvmarm/c/a3a4ca462fdb
[11/45] KVM: arm64: GICv3: Decouple ICH_HCR_EL2 programming from LRs
        https://git.kernel.org/kvmarm/kvmarm/c/417714763ec1
[12/45] KVM: arm64: GICv3: Extract LR folding primitive
        https://git.kernel.org/kvmarm/kvmarm/c/7f69d30b7024
[13/45] KVM: arm64: GICv3: Extract LR computing primitive
        https://git.kernel.org/kvmarm/kvmarm/c/4b963cd815c0
[14/45] KVM: arm64: GICv2: Preserve EOIcount on exit
        https://git.kernel.org/kvmarm/kvmarm/c/fc2fda4298ba
[15/45] KVM: arm64: GICv2: Decouple GICH_HCR programming from LRs being loaded
        https://git.kernel.org/kvmarm/kvmarm/c/8ff2bf028907
[16/45] KVM: arm64: GICv2: Extract LR folding primitive
        https://git.kernel.org/kvmarm/kvmarm/c/a8306bb15afd
[17/45] KVM: arm64: GICv2: Extract LR computing primitive
        https://git.kernel.org/kvmarm/kvmarm/c/d78124a65a03
[18/45] KVM: arm64: Compute vgic state irrespective of the number of interrupts
        https://git.kernel.org/kvmarm/kvmarm/c/f9bb784186be
[19/45] KVM: arm64: Eagerly save VMCR on exit
        https://git.kernel.org/kvmarm/kvmarm/c/d3c2036861c6
[20/45] KVM: arm64: Revamp vgic maintenance interrupt configuration
        https://git.kernel.org/kvmarm/kvmarm/c/877324a1b541
[21/45] KVM: arm64: Turn kvm_vgic_vcpu_enable() into kvm_vgic_vcpu_reset()
        https://git.kernel.org/kvmarm/kvmarm/c/df5dfcad48ca
[22/45] KVM: arm64: Make vgic_target_oracle() globally available
        https://git.kernel.org/kvmarm/kvmarm/c/0cb4b6d1c73e
[23/45] KVM: arm64: Invert ap_list sorting to push active interrupts out
        https://git.kernel.org/kvmarm/kvmarm/c/c6a5d4815634
[24/45] KVM: arm64: Move undeliverable interrupts to the end of ap_list
        https://git.kernel.org/kvmarm/kvmarm/c/7fb79d1a03e6
[25/45] KVM: arm64: Use MI to detect groups being enabled/disabled
        https://git.kernel.org/kvmarm/kvmarm/c/f259e2c758dc
[26/45] KVM: arm64: GICv3: Handle LR overflow when EOImode==0
        https://git.kernel.org/kvmarm/kvmarm/c/81ef83de9440
[27/45] KVM: arm64: GICv3: Handle deactivation via ICV_DIR_EL1 traps
        https://git.kernel.org/kvmarm/kvmarm/c/f1d440106c3f
[28/45] KVM: arm64: GICv3: Add GICv2 SGI handling to deactivation primitive
        https://git.kernel.org/kvmarm/kvmarm/c/90d527ac928c
[29/45] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when interrupts overflow LR capacity
        https://git.kernel.org/kvmarm/kvmarm/c/9a2292c50d1c
[30/45] KVM: arm64: GICv3: Add SPI tracking to handle asymmetric deactivation
        https://git.kernel.org/kvmarm/kvmarm/c/0f64bed159d2
[31/45] KVM: arm64: GICv3: Handle in-LR deactivation when possible
        https://git.kernel.org/kvmarm/kvmarm/c/164dd4bae47b
[32/45] KVM: arm64: GICv3: Avoid broadcast kick on CPUs lacking TDIR
        https://git.kernel.org/kvmarm/kvmarm/c/2b36853d7e58
[33/45] KVM: arm64: GICv2: Handle LR overflow when EOImode==0
        https://git.kernel.org/kvmarm/kvmarm/c/d4537c8d3116
[34/45] KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps
        https://git.kernel.org/kvmarm/kvmarm/c/182853c7680a
[35/45] KVM: arm64: GICv2: Always trap GICV_DIR register
        https://git.kernel.org/kvmarm/kvmarm/c/efa05bae8936
[36/45] KVM: arm64: selftests: gic_v3: Add irq group setting helper
        https://git.kernel.org/kvmarm/kvmarm/c/0f0e2b4108b3
[37/45] KVM: arm64: selftests: gic_v3: Disable Group-0 interrupts by default
        https://git.kernel.org/kvmarm/kvmarm/c/eea5d19518f2
[38/45] KVM: arm64: selftests: vgic_irq: Fix GUEST_ASSERT_IAR_EMPTY() helper
        https://git.kernel.org/kvmarm/kvmarm/c/eecb216b2f74
[39/45] KVM: arm64: selftests: vgic_irq: Change configuration before enabling interrupt
        https://git.kernel.org/kvmarm/kvmarm/c/9f3f3ddbc730
[40/45] KVM: arm64: selftests: vgic_irq: Exclude timer-controlled interrupts
        https://git.kernel.org/kvmarm/kvmarm/c/bbaf6ed67c41
[41/45] KVM: arm64: selftests: vgic_irq: Remove LR-bound limitation
        https://git.kernel.org/kvmarm/kvmarm/c/0b7c2f50f3fd
[42/45] KVM: arm64: selftests: vgic_irq: Perform EOImode==1 deactivation in ack order
        https://git.kernel.org/kvmarm/kvmarm/c/d64e3140ab5f
[43/45] KVM: arm64: selftests: vgic_irq: Add asymmetric SPI deaectivation test
        https://git.kernel.org/kvmarm/kvmarm/c/170b047e15af
[44/45] KVM: arm64: selftests: vgic_irq: Add Group-0 enable test
        https://git.kernel.org/kvmarm/kvmarm/c/2423a2369fc1
[45/45] KVM: arm64: selftests: vgic_irq: Add timer deactivation test
        https://git.kernel.org/kvmarm/kvmarm/c/eaaaaab4b530

--
Best,
Oliver

