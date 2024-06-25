Return-Path: <kvm+bounces-20472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63693916886
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DFB8284980
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BFB15EFC8;
	Tue, 25 Jun 2024 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUZSAp+y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980A114A60D;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719320449; cv=none; b=nG6h6mxZRW/k1OB1qTBB8/R+f/9DmQJgyLhjca6s6YLA5OUNqUJ3I0vXYikB3W9j8Z7BV6YEUAWudqtv0W95tIGXV+vEjQanvck/AtEbmkyomdzfzQBGguIHk/Yi0Ax0+CvZmlF7frBh079Fndc2yDM4eSTQ4Cy+vijc9ZZxuHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719320449; c=relaxed/simple;
	bh=tW2UPTksFmsVW9kguIKpPtXZeO0+Rs1arm33m9xPMWA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SFmrakSWwU4zHSeA7iLpQvRowmvXl5Fj5chRYoHjQPYABTP6lmmIQln2ghGSkeVxmLEMu3jRoGfKt8rLTuZ4YZ6Alxl5YvfLbE2cs+HTvuIxRz+fvsxArk7zqVSY44MrovbrZReUP9wRkrUDB1qvt19vQhMkNj9A9v75U7IE02w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUZSAp+y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FAAC32786;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719320449;
	bh=tW2UPTksFmsVW9kguIKpPtXZeO0+Rs1arm33m9xPMWA=;
	h=From:To:Cc:Subject:Date:From;
	b=eUZSAp+ycRnGJMiDSYC0XoN1/IsgOs4Lj+pSvlfTpwIAJlvi/qxaRInxcttaOafqN
	 +ZkrRaFosyg7DLlrFDF4gWjprTa4LgKJPMUBvpx5zfLPnzdYVXUBphyruZGVxFEEMR
	 r65FHUoJ50mOMrtC2EqFR5uYKCZq1b0P01lM/sJhI0NAJ1fG0m8Zm/Y4Bmhwu8MMhe
	 1KHEd2BfrPOx1Sv4Ie7wxtGfYwpWe7yG/qf4x6L5Z+eSqLoX3GN5GLDoIkQdZw3zPh
	 0iW+zzZgHDh9ySab04f3wxH4KLWBMyw/wXkA9hkK+o9Q0Vvceog92y7Bs3XQS30QmO
	 bbyKAyaxTUc6A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM5mw-0079X4-SF;
	Tue, 25 Jun 2024 14:00:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 0/5] KVM: arm64: Fix handling of TCR2_EL1
Date: Tue, 25 Jun 2024 14:00:36 +0100
Message-Id: <20240625130042.259175-1-maz@kernel.org>
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

As I'm inching towards supporting FEAT_S1PIE in a NV guest (oh, the
fun I'm having!), it has become obvious that we're missing the basics
when it comes to:

- VM configuration: HCRX_EL2.TCR2En is forced to 1, and we blindly
  save/restore stuff.

- trap bit description and routing: none, obviously, since we make a
  point in not trapping.

Given that these are prerequisites for the NV work and that we should
have had that from the beginning, I would like to plug them before
piling more patches on top.


Marc Zyngier (5):
  KVM: arm64: Correctly honor the presence of FEAT_TCRX
  KVM: arm64: Get rid of HCRX_GUEST_FLAGS
  KVM: arm64: Make TCR2_EL1 save/restore dependent on the VM features
  KVM: arm64: Make PIR{,E0}_EL1 save/restore conditional on FEAT_TCRX
  KVM: arm64: Honor trap routing for TCR2_EL1

 arch/arm64/include/asm/kvm_arm.h           |  1 -
 arch/arm64/kvm/emulate-nested.c            | 13 ++++++++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 35 +++++++++++++++-------
 arch/arm64/kvm/sys_regs.c                  | 17 ++++++++++-
 4 files changed, 54 insertions(+), 12 deletions(-)

-- 
2.39.2


