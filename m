Return-Path: <kvm+bounces-57915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B4F6B81111
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 18:42:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0676A1C220FB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 16:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4280D2FAC07;
	Wed, 17 Sep 2025 16:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Twr6BXe3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA302F3C3A;
	Wed, 17 Sep 2025 16:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758127348; cv=none; b=YScKqKgQtJs5IoxvIMD0JS4kus07WAxOiRRyolc1fijocMai6DK1By15d8fmZQJPp1Y9MpDKORElokSBb+InQz2x11i6aVDRd/4sYD12FVL+6oBxKJmdN6EqfYitLE/N7S+KwH8clPSZ0fN24Vznb9RfWuS0wqlJKE5Lz5Z2sFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758127348; c=relaxed/simple;
	bh=sDmYzAVvLUWz02x4KttZh7bEAnkvy0jlE24JN3RphD8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBe2Q+cXSX0NUBpOuqCJZxwGmkGzdZUQIRDlcaqlNdlqHJ33ZcMe3EU20UQfe4c1v2hx0vkr3xiLdcaPtE2+V2lkDp7qJ0nrWgfbllj3xf+oDaC+vJb44cYNUhoR8FvoSgRO05FY9tcxRovzXbnQNMVEjrDEp1edcvMT1m4dX4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Twr6BXe3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2B3C4CEE7;
	Wed, 17 Sep 2025 16:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758127347;
	bh=sDmYzAVvLUWz02x4KttZh7bEAnkvy0jlE24JN3RphD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Twr6BXe3WCu6jxGVx+sQE0MdQCydPBXeCkRNwPm12DNUXpQgMsaGRxeN242HdBfgs
	 g5Fc7Zeg1VQtAVbgNwwk2772RbCSoxsfZZdbZFfOPACoyNPdH7A8Ysfmy1eADzPC/w
	 LwJ8UEs0ozzRt3lK/0HWqqBWc3iVQ26KVHDKMjHpYuq7rwt29UP0OkpV7xHhfWExA7
	 qxSRIGuo0PYJovFKeV0vwa6+xkUUwMEcXpXZsRfrpvqmu7QZ8TT3XGM0kizlwsL5Vq
	 HmvvP6BqSZryj+7MnGKRW8OJmcZTvVb/820BXM4US5UL5uF/Tj1TI2A/2/X+gkN3ft
	 4Z117DwucYWoQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvEf-00000007ACT-1qGd;
	Wed, 17 Sep 2025 16:42:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	oliver.upton@linux.dev,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com,
	will@kernel.org,
	tglx@linutronix.de,
	lpieralisi@kernel.org,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 0/5] KVM: arm64: GICv5 legacy (GCIE_LEGACY) NV enablement and cleanup
Date: Wed, 17 Sep 2025 17:42:21 +0100
Message-Id: <175812733344.1632579.17001899303582807634.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250828105925.3865158-1-sascha.bischoff@arm.com>
References: <20250828105925.3865158-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, oliver.upton@linux.dev, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, tglx@linutronix.de, lpieralisi@kernel.org, Timothy.Hayes@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 28 Aug 2025 10:59:41 +0000, Sascha Bischoff wrote:
> This series enables nested virtualization for GICv3-based VMs on GICv5
> hosts (w/ FEAT_GCIE_LEGACY) in KVM/arm64. In addition, it adds a CPU
> capability to track support for FEAT_GCIE_LEGACY across all CPUs.
> 
> The series fixes ICC_SRE_EL2 access handling for GICv5 hosts (to match
> the updated bet1+ specification [1]), and extends nested
> virtualization support to vGICv3 guests running on compatible GICv5
> systems. With these changes, it becomes possible to run with
> kvm-arm.mode=nested, and these changes have been tested with three
> levels of nesting on simulated hardware (Arm FVP).
> 
> [...]

Applied to next, thanks!

[1/5] KVM: arm64: Allow ICC_SRE_EL2 accesses on a GICv5 host
      (no commit info)
[2/5] KVM: arm64: Enable nested for GICv5 host with FEAT_GCIE_LEGACY
      commit: d5a012af348d4d84287267547eb8637b937545af
[3/5] arm64: cpucaps: Add GICv5 Legacy vCPU interface (GCIE_LEGACY) capability
      commit: 7847f51189343b29a24ca7edafb60a9032d5acf8
[4/5] KVM: arm64: Use ARM64_HAS_GICV5_LEGACY for GICv5 probing
      commit: 754e43b09561f59dd04e0b8aafe4f5c9a71a4d1f
[5/5] irqchip/gic-v5: Drop has_gcie_v3_compat from gic_kvm_info
      commit: 5c5db9efe323dd0b0d7917dbe5b9c0999c95e79e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



