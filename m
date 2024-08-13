Return-Path: <kvm+bounces-24001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D41950819
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CAE11C2284E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6040219EED6;
	Tue, 13 Aug 2024 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiM73EWE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8D9199389;
	Tue, 13 Aug 2024 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560477; cv=none; b=Fmz6t8hPxm8FQY5MYZIhWFXvCssHscOANX8uxUoHsV8OR5WIMCq+7ZAtCHKuydDQztQjnzb8SoWw/fKzquVHeETAJx5Hoc77zER+TWTsd3wycQq/+HaztMtf924WN/nvj3ONiH353czuZCBZNC5HQQs2+qIDtDnWhw0CvPDh0OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560477; c=relaxed/simple;
	bh=ybweyFTPZIsemP1mTBqOWgja4nvW2VxgY6ZJsmy/cTo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=owCCAAO3Ulph34hIScP0+gyouwd1Mc31iS+LINbdyXyYz44Ti5oZNydGm6F6ejLlEAlH60lbQNfMhkIe1UqVpl2Z1doe1hcc3gcVBWSvSvXt2SH7yP+IN53Jtk8eTxQZlya5htZBEWFXM9uvC3fvfjpu6wWiviFHl2kpduz0BeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiM73EWE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E37C4AF09;
	Tue, 13 Aug 2024 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560477;
	bh=ybweyFTPZIsemP1mTBqOWgja4nvW2VxgY6ZJsmy/cTo=;
	h=From:To:Cc:Subject:Date:From;
	b=BiM73EWECVBgrpxuBT4Klb7KylyZpjAXyuaCSBn/PAMJnktoOJ8RyTEl3cEoQLMEX
	 HgKfgtXkMmqVzrIDV8cH2CWEJM1zqoc5MazXnuv39+55day0+NydDykBuDZa2LWMVO
	 29TwmrKNwwcranLM/J1GAEHy7K/CPucYpWUR2XcFvSsv7YgtEs4KnfpdASLIOuU3ys
	 AfqaOsUk3a8iKsCB8e1s6PxIbkkBzSWKvCGtDL+5VNEEKE/Z3luRwsLiGJBlfelwl0
	 rrGgOCvY9xDQDwbCLl1UWk4nthStTOWUfVTcJpVI9QsS/PO5BXdYURqC4exLm/DVdJ
	 l8DDG4U4MfztQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdsoV-003O27-5X;
	Tue, 13 Aug 2024 15:47:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 00/10] KVM: arm64: Add EL2 support to FEAT_S1PIE
Date: Tue, 13 Aug 2024 15:47:28 +0100
Message-Id: <20240813144738.2048302-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This series serves a few purposes:

- Complete the S1PIE support to include EL2
- Sneak in the EL2 system register world switch

As this is a parallel series to the one implementing Address
Translation, the S1PIE part of AT is not in any of the two. Depending
on which series goes in first, I'll add whatever is needed on top.

As mentioned in few of the patches, this implementation relies on a
very recent fix to the architecture (D22677 in [1]).

[1] https://developer.arm.com/documentation/102105/ka-04/

Marc Zyngier (10):
  KVM: arm64: nv: Handle CNTHCTL_EL2 specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: Add TCR2_EL2 to the sysreg arrays
  KVM: arm64: Add save/restore for TCR2_EL2
  arm64: Add encoding for PIRE0_EL2
  arm64: Remove VNCR definition for PIRE0_EL2
  KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
  KVM: arm64: Add save/restore for PIR{,E0}_EL2
  KVM: arm64: Handle  PIR{,E0}_EL2 traps
  KVM: arm64: Sanitise ID_AA64MMFR3_EL1

 arch/arm64/include/asm/kvm_host.h          |   3 +
 arch/arm64/include/asm/vncr_mapping.h      |   1 -
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 155 ++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c                  |  61 +++++++-
 arch/arm64/tools/sysreg                    |   4 +
 include/kvm/arm_arch_timer.h               |   3 +
 8 files changed, 227 insertions(+), 7 deletions(-)

-- 
2.39.2


