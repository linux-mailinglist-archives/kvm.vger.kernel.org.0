Return-Path: <kvm+bounces-10727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D13386F033
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 12:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 560CAB23AC1
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 11:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677B217573;
	Sat,  2 Mar 2024 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pm9ufTbx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868E814293;
	Sat,  2 Mar 2024 11:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709378398; cv=none; b=pkFYxmS2x7AddmIDCqvG+vciTISPGHlq4Q4AJFPkKFmEzuemx6vxoAGN+wD9rgQSYH9vN9MLDvYPzP6N//b05tt9o3n4Y5CRfW3R9ATUUIG9ZSaajdiXJDIfqVfFrRXq9xYKSnMuRpB1DJ5G6xM7a2v3HlQq3EbchuWs07NSbxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709378398; c=relaxed/simple;
	bh=3J0k5g/fnp9TIqJEjL4u2lVp2pibB+1Yu7BCqEtpkcc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Jym5wF8ulr+npDWYhbVVR/6sKJ5t51EwjDwft7YcYdiXN3jZowmSoMYOIb2p8XD2tf5xb9l2/iGfq912PBMADEheBEx52jn32a7p7DlzZIFrlATOUS46SrUBVAUQZWQwIPDg9GDmQ9jxaHRPrp0/6rfLdsG2md9wuqV9qXb53SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pm9ufTbx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6120CC433C7;
	Sat,  2 Mar 2024 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709378398;
	bh=3J0k5g/fnp9TIqJEjL4u2lVp2pibB+1Yu7BCqEtpkcc=;
	h=From:To:Cc:Subject:Date:From;
	b=pm9ufTbxxjZsBrr/XVm2dvtNYlj7rw2LvlPI3aQ64itVz0HOGeHwPQ5G07Gl4extj
	 a27Wmu8v1cmYXnh4h56M9NPw4kgqpUsmD8ljh5VuzwVCxD8TnKtWJUW2mrlJQpQUYf
	 2cOllCxzRpu6L1gFCQNu1kXsyb1eeT2WMTwXi32CiXVc3W4LloPmHtRVlIV4Sw7PHZ
	 uPJZO2oDDX+ZPojNvuWBD7MZuvy7p7IKpZdRPQpPVVggfK9p+vNepJsixdGICmz+65
	 hyC+6e/oS83P4J9yqTsVC7spYQoaUoNRIK4PmDdRfD3D+a77zyB0jz5OeNJalqINJ2
	 AMMTxGiNpvRAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rgNPH-008lLw-RB;
	Sat, 02 Mar 2024 11:19:56 +0000
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
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/5] KVM: arm64: Move host-specific data out of kvm_vcpu_arch
Date: Sat,  2 Mar 2024 11:19:30 +0000
Message-Id: <20240302111935.129994-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.clark@arm.com, anshuman.khandual@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It appears that over the years, we have accumulated a lot of cruft in
the kvm_vcpu_arch structure. Part of the gunk is data that is strictly
host CPU specific, and this result in two main problems:

- the structure itself is stupidly large, over 8kB. With the
  arch-agnostic kvm_vcpu, we're above 10kB, which is insane. This has
  some ripple effects, as we need physically contiguous allocation to
  be able to map it at EL2 for !VHE. There is more to it though, as
  some data structures, although per-vcpu, could be allocated
  separately.

- We lose track of the life-cycle of this data, because we're
  guaranteed that it will be around forever and we start relying on
  wrong assumptions. This is becoming a maintenance burden.

This series rectifies some of these things, starting with the two main
offenders: debug and FP, a lot of which gets pushed out to the per-CPU
host structure. Indeed, their lifetime really isn't that of the vcpu,
but tied to the physical CPU the vpcu runs on.

This results in a small reduction of the vcpu size, but mainly a much
clearer understanding of the life-cycle of these structures.

Patches against v6.8-rc6.

Marc Zyngier (5):
  KVM: arm64: Add accessor for per-CPU state
  KVM: arm64: Exclude host_debug_data from vcpu_arch
  KVM: arm64: Exclude mdcr_el2_host from kvm_vcpu_arch
  KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch
  KVM: arm64: Exclude FP ownership from kvm_vcpu_arch

 arch/arm64/include/asm/kvm_emulate.h      |  4 +-
 arch/arm64/include/asm/kvm_host.h         | 65 ++++++++++++++---------
 arch/arm64/kvm/arm.c                      |  8 +--
 arch/arm64/kvm/fpsimd.c                   | 13 +++--
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  8 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h   | 23 ++++----
 arch/arm64/kvm/hyp/nvhe/debug-sr.c        |  8 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c        |  3 --
 arch/arm64/kvm/hyp/nvhe/psci-relay.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c           |  3 +-
 arch/arm64/kvm/hyp/nvhe/switch.c          |  6 +--
 arch/arm64/kvm/hyp/vhe/switch.c           |  6 +--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |  4 +-
 arch/arm64/kvm/pmu.c                      |  2 +-
 14 files changed, 79 insertions(+), 76 deletions(-)

-- 
2.39.2


