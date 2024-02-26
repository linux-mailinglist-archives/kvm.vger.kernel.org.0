Return-Path: <kvm+bounces-9790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 999B68670AB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38D691F2C1AB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD05B56447;
	Mon, 26 Feb 2024 10:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHi3uVIG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27C755E71;
	Mon, 26 Feb 2024 10:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942055; cv=none; b=DUzpbq4PZknds+OaW7NpSRUPLMdRSxXXaNJzaKVHnYuVg27VnFIwDM9FicDcVVrLe6J8wfjuK4k5MpiPN4Sgs7UyXWLy2+hYv/eR4vjfrgJvb1ARCA+AS1uwxfpC0nKzlJ18ZZ3/aCgN3A3hm35nX2URS3nhh5ZihCRQnjZ4Skc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942055; c=relaxed/simple;
	bh=pSxd2T2vDb9x73UvU6amuiiCQzcThADNLivPMyVtvaw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nDv1y3ZJUTEYzfvpFKeyDh1yv7PHDRzNu9bz2TA6asHIE+hPeG0f5qf8d/ScgBR2A5CsJqYcy1bI8xdZo2t3Y+w00mQ6UyClN4S5ds6HhsD1P+b2NoIJthG1KVQaR9VnZy6oIuwhpFg9uw/oqkNBXnDwnzwuEhdp14lT/0Im5sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHi3uVIG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B71BC433F1;
	Mon, 26 Feb 2024 10:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942054;
	bh=pSxd2T2vDb9x73UvU6amuiiCQzcThADNLivPMyVtvaw=;
	h=From:To:Cc:Subject:Date:From;
	b=BHi3uVIGX3h3AoxthnABevCOjkJDSWjdPU9RC+TIq/oT2sWcLPGCEQsGoJl4C/P+E
	 wWF/UjvGTCqOGHYkX5nG+U0pZqKlYJjQkjy1/f7DehJB0fQfu38hNzhXuC3CVQGJEo
	 jH5bD6/KaHP6HVB1AKo9nqKzT6gqeYv0Wf5Kgi2tZz+VBEoBL6XOXZHu4FTEmc3bOB
	 EM/R2ggHNwUhMSqsvB0naX+nhzxQi4gpexPcKIXgZKBUZZMMw29c9wKzjGW2l0X6iy
	 Pk8+W+4LL74tlwdZTWjgUPmp6Dg8g/+BXel+JjBZnWmybtXgg6bi4x3g9vI/CCijm0
	 XjxsFHd57ekhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXsB-006nQ5-5Z;
	Mon, 26 Feb 2024 10:07:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 00/13] KVM/arm64: Add NV support for ERET and PAuth
Date: Mon, 26 Feb 2024 10:05:48 +0000
Message-Id: <20240226100601.2379693-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the second version of this series introducing ERET and PAuth
support for NV guests, and now the base prefix for the NV support
series.

Thanks to Joey for reviewing the first half of the series and
providing valuable suggestions, much appreciated!

* From v1 [1]:

  - Don't repaint the ISS_ERET* definitions, but provide reasonable
    helpers instead
  - Dropped superfluous VNCR_EL2 definition
  - Amended comments and creative spelling

[1] https://lore.kernel.org/r/20240219092014.783809-1-maz@kernel.org

Marc Zyngier (13):
  KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
  KVM: arm64: Add helpers for ESR_ELx_ERET_ISS_ERET*
  KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
  KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
  KVM: arm64: nv: Add trap forwarding for ERET and SMC
  KVM: arm64: nv: Fast-track 'InHost' exception returns
  KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
  KVM: arm64: nv: Handle HCR_EL2.{API,APK} independently
  KVM: arm64: nv: Reinject PAC exceptions caused by HCR_EL2.API==0
  KVM: arm64: nv: Add kvm_has_pauth() helper
  KVM: arm64: nv: Add emulation for ERETAx instructions
  KVM: arm64: nv: Handle ERETA[AB] instructions
  KVM: arm64: nv: Advertise support for PAuth

 arch/arm64/include/asm/esr.h            |  12 ++
 arch/arm64/include/asm/kvm_emulate.h    |   5 -
 arch/arm64/include/asm/kvm_host.h       |  26 +++-
 arch/arm64/include/asm/kvm_nested.h     |  13 ++
 arch/arm64/include/asm/pgtable-hwdef.h  |   1 +
 arch/arm64/kvm/Makefile                 |   1 +
 arch/arm64/kvm/emulate-nested.c         |  66 +++++---
 arch/arm64/kvm/handle_exit.c            |  38 ++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  36 ++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  96 +++++++++++-
 arch/arm64/kvm/nested.c                 |   8 +-
 arch/arm64/kvm/pauth.c                  | 196 ++++++++++++++++++++++++
 13 files changed, 444 insertions(+), 56 deletions(-)
 create mode 100644 arch/arm64/kvm/pauth.c

-- 
2.39.2


