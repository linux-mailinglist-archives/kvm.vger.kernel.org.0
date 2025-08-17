Return-Path: <kvm+bounces-54844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22DC4B292F0
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 903103BCECD
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81329207DF3;
	Sun, 17 Aug 2025 12:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9+H61Tm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCFC24468D;
	Sun, 17 Aug 2025 12:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755433176; cv=none; b=Yz8OORvx3jkyjw2HbGFipDagCHLBwMP49amR8pb10RhL5k2nyynQ54efrsNEjwGiN1IEfL5usOsD7miRbfiy/SsjMSiA+6/oJW0oI10F6RnzFk+AR/e4ZNljOT68UcLT4fFi4vxqsSlnAD8NeSuC9I2PyW1jWNIMone8J+du51Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755433176; c=relaxed/simple;
	bh=dASPEeUs8fF0JPg3CriKPlz4cPW/fuQlXdkrCNipZ94=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aqJi0szhfndIWHVNwlCsZ3igak0L14nib0T2p1QCSAH+M97b1y56mrqHHQCnRvsZoMdwRlrQauP7jZ5A+iPodcbdviIytrPQRQoOgTwCD0u/rS/73laVrBXD8DYjKRLM4eD+cBsIsxy9EZoAQ30f1EPuw8en4mfPnHqcXtY9dqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9+H61Tm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78009C4CEEB;
	Sun, 17 Aug 2025 12:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755433175;
	bh=dASPEeUs8fF0JPg3CriKPlz4cPW/fuQlXdkrCNipZ94=;
	h=From:To:Cc:Subject:Date:From;
	b=H9+H61TmbPT1dYHWQNGeArlMFwF2rWVIbw/Aj6xGhtxf4UIb6GHqCPt3HYiSoFz/I
	 OZnBgzdHRATym/EZ9I5zW/sy7gxU/wSrwFujauVxbDhRfadOJOYH18eP5qkQop2T4E
	 1BS2UG4fWrx+G3m7rcH3u6713WUYywLikKFFTNryx+qXX4iRzNtkHkSJkA0XAaL8OV
	 zyFtIR/DrldGnWUJzwWHyNKzTLNlZvPuthB3QW6nGALBa2mm+XIFh3QrOt/jXiTAuz
	 k9K9hHkstqKOGK+IGutqJYCrYzy4AgXYC8NcwPQ8O/sRgcZ+eXPps3K3ifY+5/8oY2
	 uTo/D7bT3/X0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uncME-008L0z-9v;
	Sun, 17 Aug 2025 13:19:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 0/4] KVM: arm64: Live system register access fixes
Date: Sun, 17 Aug 2025 13:19:22 +0100
Message-Id: <20250817121926.217900-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, volodymyr_babchuk@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This series stems from [1], which outlined some rather bad bugs in the
way we handle live system registers with VHE. As the discussion
progressed, I decided to tighten things a bit, and found a couple more
bugs in the process.

I appreciate this is a bit big for a -rc, but at the same time some of
the issues are rather annoying, and I'd like to make sure we address
these for good.

[1] https://lore.kernel.org/all/20250809144811.2314038-3-maz@kernel.org/

Marc Zyngier (4):
  KVM: arm64: Check for SYSREGS_ON_CPU before accessing the 32bit state
  KVM: arm64: Simplify sysreg access on exception delivery
  KVM: arm64: Fix vcpu_{read,write}_sys_reg() accessors
  KVM: arm64: Remove __vcpu_{read,write}_sys_reg_{from,to}_cpu()

 arch/arm64/include/asm/kvm_host.h | 111 +---------
 arch/arm64/kvm/hyp/exception.c    |  20 +-
 arch/arm64/kvm/sys_regs.c         | 344 ++++++++++++++++++++----------
 3 files changed, 243 insertions(+), 232 deletions(-)

-- 
2.39.2


