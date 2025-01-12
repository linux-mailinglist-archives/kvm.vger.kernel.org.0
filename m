Return-Path: <kvm+bounces-35229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A26A6A0AB0A
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:50:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6735B1886B5F
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 16:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCC91BEF9D;
	Sun, 12 Jan 2025 16:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaLyy0gI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF622157469;
	Sun, 12 Jan 2025 16:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736700637; cv=none; b=kyS88c3MtapW4UnIeCVBefcm0yi/aqo1D+Ce60lhIMXcUofTuBFZFxQwE+V8C2O5M9QjfLhMbMLqyVUenos2bHDaBcOddZDZd1zmOGniBZqr4clyEl35AuX8vssxyo8ascDDWeIjdhghWm+VANgVjIrGhMr1SxpWEZvrc0sNV9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736700637; c=relaxed/simple;
	bh=+VkGKow8plOWnLeNwlQycmgXpMLo8zy0sbUQstHgjn8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Oyon+2kycpchLZEZNYyMsZKWJwi5d3KGmwF/xYolv/AU75S7gcvtcmjPlmDdlQizuVylldLBuaSqufsHTj4jfnjnHhHH5+X8SI2EYnSacx2cwNBBfn2qW5FG949SsWFPykUTn1kQRyLZLbWggZccJl5BBMddB56XG1IxenjGclc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaLyy0gI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565DCC4CEDF;
	Sun, 12 Jan 2025 16:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736700637;
	bh=+VkGKow8plOWnLeNwlQycmgXpMLo8zy0sbUQstHgjn8=;
	h=From:To:Cc:Subject:Date:From;
	b=eaLyy0gIGDzMaxtKhSVA+XFYu7ZH/rYpprCQX0no9wYqYMc3xg+b0vPa4dH5hRn9Z
	 8MngDr5CYLQdZFoJdzHAnpsrJOlQ/2g7dWYY/qoRfT6B6SFx4bYdDz0qi+2MnOj4V6
	 FmyodEArNN3cpGRGpYMWxTyrvBPux1ihBLNvhnRvYY6cYprvh0vgpilbMXuKNv6qBh
	 Xt3rHeuieF4eRt0CehrhuTdnZnjXuRkoQKhnbFIaEjKkAeBMFX8rHKna2dRCi/75xo
	 AgetygdeJhZspkd4pRJiwAOdpgAXXEoq2FMU9BRIk8uW1GzqMnUouyFMXA85ZQC5hS
	 1iExjwFphUDtQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1AZ-00BNnv-2d;
	Sun, 12 Jan 2025 16:50:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/2] KVM: arm64: nv: Fix sysreg RESx-ication
Date: Sun, 12 Jan 2025 16:50:27 +0000
Message-Id: <20250112165029.1181056-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Joey recently reported that some rather basic tests were failing on
NV, and managed to track it down to critical register fields (such as
HCR_EL2.E2H) not having their expect value.

Further investigation has outlined a couple of critical issues:

- Evaluating HCR_EL2.E2H must always be done with a sanitising
  accessor, no ifs, no buts. Given that KVM assumes a fixed value for
  this bit, we cannot leave it to the guest to mess with.

- Resetting the sysreg file must result in the RESx bits taking
  effect. Otherwise, we may end-up making the wrong decision (see
  above), and we definitely expose invalid values to the guest. Note
  that because we compute the RESx masks very late in the VM setup, we
  need to apply these masks at that particular point as well.

The two patches in this series are enough to fix the current set of
issues, but __vcpu_sys_reg() needs some extra work as it is doing the
wrong thing when used as a lvalue. I'll post a separate series for
that, as the two problems are fairly orthogonal, and this results in a
significant amount of churn.

All kudos to Joey for patiently tracking that one down. This was
hidden behind a myriad of other issues, and nailing this sucker down
is nothing short of a debugging lesson. Drinks on me next time.

Unless someone shouts, I'll take this in for 6.14.

Marc Zyngier (2):
  KVM: arm64: nv: Always evaluate HCR_EL2 using sanitising accessors
  KVM: arm64: nv: Apply RESx settings to sysreg reset values

 arch/arm64/include/asm/kvm_emulate.h | 36 ++++++++++++----------------
 arch/arm64/include/asm/kvm_nested.h  |  2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c   |  4 ++--
 arch/arm64/kvm/nested.c              |  9 +++++--
 arch/arm64/kvm/sys_regs.c            |  5 +++-
 5 files changed, 29 insertions(+), 27 deletions(-)

-- 
2.39.2


