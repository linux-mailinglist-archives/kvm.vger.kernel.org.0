Return-Path: <kvm+bounces-9051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0C6859F7E
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B513B20B8E
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADAF2377E;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gm6eeuIH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11284224DA;
	Mon, 19 Feb 2024 09:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334424; cv=none; b=VbiOZh7G/pPGgqLn8UrhgKlr7l5vSvojXQBvQeY6iVly6DavZOxC1A051oTt56nfHzgY8ZicovePx+n6Z+XDEHoXZf4PfR70oFAo6J0+CizOgyJxj+sNum4jqb8Bel96aOQ8CdjnHs9x93bVP2KRJWedtRZMFylTN4HiJfIvMCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334424; c=relaxed/simple;
	bh=T8tTz0DFLMbLUKp6AyT9sxq4fM50csXp1v6aNQXOtak=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ninrhlLQ1OLp3BeOmKLBV2CvilBkKQlbVQ/LFk/S9qxzHv+Jif6daT+ccQ7CCpxAd2dxto6H/lPPYgc7h7cZaZ0G1gaPEyP+SeievIDgzumQi2Rhx5Lc/A477VyUEg1AMZVcmoOy+Zx9CoffWX6GSTDDWXR69aVo7hfmX15we28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gm6eeuIH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8941EC433C7;
	Mon, 19 Feb 2024 09:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334423;
	bh=T8tTz0DFLMbLUKp6AyT9sxq4fM50csXp1v6aNQXOtak=;
	h=From:To:Cc:Subject:Date:From;
	b=Gm6eeuIHvin0dSXadjOaEtWAjHu4zqE3e4YWlz6cUnyGMrmsSsntiKq4+goMJkd77
	 ybW8JDDahr15A8fl1AVryNfBpr59xSWzROqbvPUjzfvBz7Fs0sJJBsf0oPQA2OAoC/
	 +1Xp0LZ0MFPfximOWM6u3DgY4czfVHmaZoTIRvo8LPDATCp2+5SwmN7eAMKx8eXVJs
	 iGW/EKn4MWqKUf58+vK7gLZFIUjwsiSwmIJ3UxJQ+AqIIznBgddsOf2GNCiBteJaM2
	 wjqvmAWWYe1+lBNykwZ47EFUSQV9p0kqKP9AVsRLWAIllGCG6W0ZYFTjuQR7kmAzLC
	 cPPKoRH2qi4iw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzoz-004WBZ-Bl;
	Mon, 19 Feb 2024 09:20:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 00/13] KVM/arm64: Add NV support for ERET and PAuth
Date: Mon, 19 Feb 2024 09:20:01 +0000
Message-Id: <20240219092014.783809-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although the current upstream NV support has *some* support for
correctly emulating ERET, that support is only partial as it doesn't
support the ERETAA and ERETAB variants.

Supporting these instructions was cast aside for a long time as it
involves implementing some form of PAuth emulation, something I wasn't
overly keen on. But I have reached a point where enough of the
infrastructure is there that it actually makes sense. So here it is!

This series completely relies on my previous VM configuration
enforcement series, as it expects all shadow registers to be sanitised
and to match the VM configuration.

The first 3 patches are only opportunistic cleanups and hardening.

Patch #4 adds the configuration of HCR_EL2 in the NV2 case, together
with VNCR_EL2 being populated.

Patches #5, #7 and #8 add more triage and trap forwarding on the
instruction side (SMC, ERET, PAC)

Patch #6 split the current ERET handling into a fixup which runs early
on exit, and the core part, which is only used when a translation
regime transition or an exception injection needs to take place.

The rest of the series finally adds the PAuth emulation for ERETA[AB]
(and only for these two instructions), plugs it into the ERET
handling, and finally advertises PAuth to the L1 guest.

Marc Zyngier (13):
  KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
  KVM: arm64: Clarify ESR_ELx_ERET_ISS_ERET*
  KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
  KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
  KVM: arm64: nv: Add trap forwarding for ERET and SMC
  KVM: arm64: nv: Fast-track 'InHost' exception returns
  KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
  KVM: arm64: nv: Handle HCR_EL2.{API,APK} independantly
  KVM: arm64: nv: Reinject PAC exceptions caused by HCR_EL2.API==0
  KVM: arm64: nv: Add kvm_has_pauth() helper
  KVM: arm64: nv: Add emulation for ERETAx instructions
  KVM: arm64: nv: Handle ERETA[AB] instructions
  KVM: arm64: nv: Advertise support for PAuth

 arch/arm64/include/asm/esr.h            |   4 +-
 arch/arm64/include/asm/kvm_emulate.h    |   5 -
 arch/arm64/include/asm/kvm_host.h       |  26 +++-
 arch/arm64/include/asm/kvm_nested.h     |  13 ++
 arch/arm64/include/asm/pgtable-hwdef.h  |   1 +
 arch/arm64/include/asm/sysreg.h         |   1 +
 arch/arm64/kvm/Makefile                 |   1 +
 arch/arm64/kvm/emulate-nested.c         |  66 +++++---
 arch/arm64/kvm/handle_exit.c            |  38 ++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  36 ++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  95 +++++++++++-
 arch/arm64/kvm/nested.c                 |   8 +-
 arch/arm64/kvm/pauth.c                  | 196 ++++++++++++++++++++++++
 14 files changed, 434 insertions(+), 58 deletions(-)
 create mode 100644 arch/arm64/kvm/pauth.c

-- 
2.39.2


