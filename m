Return-Path: <kvm+bounces-20477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2055916909
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E362D1C250CA
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FEA16B725;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYoQxZlb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AE81607B3;
	Tue, 25 Jun 2024 13:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322524; cv=none; b=DgyPoO6L7PVNQtuYEgacbYjwMIVUsoP3dhISHgTj5hlRFvGs0NTIyX0vOQBFoNKUX8qYd/lm1K+2RuikMhlTDCpNUeGNJC/hKHVLCeWzl5byf2BsAJ6t2cV8Ppb5jTpZRUlqO3Ggqoy3ZiHT5x5OHKZ6139AQbfasmPOz6M5CUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322524; c=relaxed/simple;
	bh=rIwXw3VVf63R+nYIyJ7imfCtCbeyIyaFBa507dbV90A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eKyo2Kc3EtcttKkgrYkPTVw33yhZl+j7yEfdNrvC3FCcEd+CrfLWAn0RDPXJeMkxpq/5SNS0DgPDBxkJa4M4nvBA43K0Sv8JD6yhK//fiouhqjc/Ts7sVSbn75SGq9GXlsG+n664DFdrRBA7nGxuSEN8RLtlXZEykf5+opSjJg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYoQxZlb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F74C32781;
	Tue, 25 Jun 2024 13:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322523;
	bh=rIwXw3VVf63R+nYIyJ7imfCtCbeyIyaFBa507dbV90A=;
	h=From:To:Cc:Subject:Date:From;
	b=SYoQxZlb7i768hcHyWDjEAOGslll5Hzqq9r8jmfnCeLFcLMAfQdJ1063kb0amcZut
	 qOPIl/8aT2/2sQpTouTqPCXrqSeVrriJA6DUEH90IR3qL8UQJKwSNNPgwLyA9oYfQ1
	 9QAe2Namfq5+e8k1Au1pp6QQKLiN/vGp9bMY7B0mq0GSxue+/VW3hXdayH86nq0X9D
	 phISVgYI/zaIQTgsOABOOAxZB9PC5rT7QBhkzStV4m4vbIEphm+famj++ZEEUQe0Y/
	 kOVdxZy9/tY5FWdonMDrMsc9uriFjVzCPxHJ5CPoCrbZvo41Zng+0KreOhvVJoccXY
	 DABlJjP7WfbVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KP-007A6l-Pf;
	Tue, 25 Jun 2024 14:35:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 00/12] KVM: arm64: nv: Add support for address translation instructions
Date: Tue, 25 Jun 2024 14:34:59 +0100
Message-Id: <20240625133508.259829-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Another task that a hypervisor supporting NV on arm64 has to deal with
is to emulate the AT instruction, because we multiplex all the S1
translations on a single set of registers, and the guest S2 is never
truly resident on the CPU.

So given that we lie about page tables, we also have to lie about
translation instructions, hence the emulation. Things are made
complicated by the fact that guest S1 page tables can be swapped out,
and that our shadow S2 is likely to be incomplete. So while using AT
to emulate AT is tempting (and useful), it is not going to always
work, and we thus need a fallback in the shape of a SW S1 walker.

This series is built in 4 basic blocks:

- Add missing definition and basic reworking

- Dumb emulation of all relevant AT instructions using AT instructions

- Add a SW S1 walker that is using our S2 walker

- Add FEAT_ATS1A support, which is almost trivial

This has been tested by comparing the output of a HW walker with the
output of the SW one. Obviously, this isn't bullet proof, and I'm
pretty sure there are some nasties in there.

In a departure from my usual habit, this series is on top of
kvmarm/next, as it depends on the NV S2 shadow code.

Joey Gouly (1):
  KVM: arm64: make kvm_at() take an OP_AT_*

Marc Zyngier (11):
  arm64: Add missing APTable and TCR_ELx.HPD masks
  arm64: Add PAR_EL1 field description
  KVM: arm64: nv: Turn upper_attr for S2 walk into the full descriptor
  KVM: arm64: nv: Honor absence of FEAT_PAN2
  KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}[P]
  KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
  KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
  KVM: arm64: nv: Make ps_to_output_size() generally available
  KVM: arm64: nv: Add SW walker for AT S1 emulation
  KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
  KVM: arm64: nv: Add support for FEAT_ATS1A

 arch/arm64/include/asm/kvm_arm.h       |    1 +
 arch/arm64/include/asm/kvm_asm.h       |    6 +-
 arch/arm64/include/asm/kvm_nested.h    |   18 +-
 arch/arm64/include/asm/pgtable-hwdef.h |    7 +
 arch/arm64/include/asm/sysreg.h        |   19 +
 arch/arm64/kvm/Makefile                |    2 +-
 arch/arm64/kvm/at.c                    | 1007 ++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c        |    2 +
 arch/arm64/kvm/hyp/include/hyp/fault.h |    2 +-
 arch/arm64/kvm/nested.c                |   26 +-
 arch/arm64/kvm/sys_regs.c              |   60 ++
 11 files changed, 1125 insertions(+), 25 deletions(-)
 create mode 100644 arch/arm64/kvm/at.c

-- 
2.39.2


