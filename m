Return-Path: <kvm+bounces-12404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81BE9885CAA
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:54:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B27651C22CE8
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFAFD12BEA3;
	Thu, 21 Mar 2024 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBUgJoss"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F355B1292D3;
	Thu, 21 Mar 2024 15:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036472; cv=none; b=bwuqArmSg87fp+evs7LRyG1ZxIi/aCaOyjm3yr8JzNZ+ze7KzyUR4mCVZtEQKxEnm8vwFTfXYHZfakWWOnU0jO9vzXcK1GYw1amCZ4UHMzSiBH28zx7d7w4y+RmfFAARFXqGcp9pdh/3Qlp+QggE2gxvBxwsqAPU9SVnAHAAVjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036472; c=relaxed/simple;
	bh=66gDhnAmDU/hoQLglzJaWzdItzKx4gogSnjdmN48DrE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m0PF8MF3lKhuvdGEOTIbfNqbh/k/l0zxpahWmr4pRvWFCDwcmtXIRXbFPTBYZHk4+OEpWqkS4mwg2WxNXG4iD0E2ISEkAY3Qk1wUuPyubQeZQFeqtRAUmhtulX00Jx6uMQgPeNqEtUBMTHkEaUDWJxkQSzgqSCVhmNHu+v0nfkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBUgJoss; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78163C433F1;
	Thu, 21 Mar 2024 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711036471;
	bh=66gDhnAmDU/hoQLglzJaWzdItzKx4gogSnjdmN48DrE=;
	h=From:To:Cc:Subject:Date:From;
	b=TBUgJossJf3tTtSYHIVGJBtHpSAt7pnGeCLXJxFmVF+R3OxOA8/1CHJdWQCasFS98
	 A3rJ8L/mMqY0FMnqMzDpTeaha6+Ak9Qiz33R8AVKCOY796QyLjVuvgBm2WjK/JF69f
	 QQx88GqtakhVPbbPFLbR6Cc5zr4s0wSImnbeCEwcBeOZe+w80jB7DnqIxFm1muIsM+
	 Reeq6gFXWTlN2Grpnwg0kBQ877QfIWxfyZnqms/S3HC/grp6EUlKUNy69CRfbG08r0
	 rZAXdfihKmutzFadxGbrdcNNoNyVnc0oyu7jU0R5rFM+U1DvyhucmtXSdWHsCPz07L
	 gw3QB90zioTdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnKkP-00EEqz-8T;
	Thu, 21 Mar 2024 15:54:29 +0000
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
Subject: [PATCH v3 00/15] KVM/arm64: Add NV support for ERET and PAuth
Date: Thu, 21 Mar 2024 15:53:41 +0000
Message-Id: <20240321155356.3236459-1-maz@kernel.org>
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

This is the third version of this series introducing ERET and PAuth
support for NV guests, and now the base prefix for the NV support
series.

Thanks again to Joey for reviewing a large part of the series!

* From v2 [2]

  - Enforce that both Address and Generic authentication use the same
    algorithm

  - Reduce PAuth trapping by eagerly setting the HCR_EL2.API/APK bits

  - Collected RBs, with thanks

  - Rebased on kvmarm-6.9

* From v1 [1]:

  - Don't repaint the ISS_ERET* definitions, but provide reasonable
    helpers instead

  - Dropped superfluous VNCR_EL2 definition

  - Amended comments and creative spelling

[1] https://lore.kernel.org/r/20240219092014.783809-1-maz@kernel.org
[2] https://lore.kernel.org/r/20240226100601.2379693-1-maz@kernel.org

Marc Zyngier (15):
  KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
  KVM: arm64: Add helpers for ESR_ELx_ERET_ISS_ERET*
  KVM: arm64: Constraint PAuth support to consistent implementations
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
  KVM: arm64: Drop trapping of PAuth instructions/keys

 arch/arm64/include/asm/esr.h            |  12 ++
 arch/arm64/include/asm/kvm_emulate.h    |  10 --
 arch/arm64/include/asm/kvm_host.h       |  26 +++-
 arch/arm64/include/asm/kvm_nested.h     |  13 ++
 arch/arm64/include/asm/kvm_ptrauth.h    |  21 +++
 arch/arm64/include/asm/pgtable-hwdef.h  |   1 +
 arch/arm64/kvm/Makefile                 |   1 +
 arch/arm64/kvm/arm.c                    |  83 +++++++++-
 arch/arm64/kvm/emulate-nested.c         |  66 +++++---
 arch/arm64/kvm/handle_exit.c            |  36 ++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  62 +-------
 arch/arm64/kvm/hyp/nvhe/switch.c        |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  96 +++++++++++-
 arch/arm64/kvm/nested.c                 |   8 +-
 arch/arm64/kvm/pauth.c                  | 196 ++++++++++++++++++++++++
 15 files changed, 514 insertions(+), 121 deletions(-)
 create mode 100644 arch/arm64/kvm/pauth.c

-- 
2.39.2


