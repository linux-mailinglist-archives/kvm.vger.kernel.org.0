Return-Path: <kvm+bounces-61475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A72C2002C
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 13:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ADE304EBDF8
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 12:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15763233FA;
	Thu, 30 Oct 2025 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khJDio1f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE2231691D;
	Thu, 30 Oct 2025 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827232; cv=none; b=mWgDPu00w51dtHi9HoaL+SH7oIHkf0HqIQWIgKUcpFgd1gT8jnXisdh5PgJ9CODRZ9BSbwrwEWRhfHT1knZFmZOVuK92DO65X2EiL33H3Chs+mIfCqL97fJtnVEFAy3K/UHQqtEKbI3n9wTjjAdt2NFnUBEOCfpyHtJGbHZA6VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827232; c=relaxed/simple;
	bh=jo/0EMLbTp/Ctoi6txojoXXpfGK/dAchax3ckErLqx0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=neQMk5xalSwFc0pPGH/D4ie/6e0IGUGX85TqeTKF1ZoO4SWsr0bPlm64qgM52yn1wVOtJlyVInnNP155BXxkyz48bbcDVdY6ZhFDGMkob9eKeD5joH50psIUl/rxoR73h+r/Mux9cb1aLqacBULuXi6OAxh3qn8uWRZmSL6p2Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khJDio1f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156E7C4CEF1;
	Thu, 30 Oct 2025 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761827232;
	bh=jo/0EMLbTp/Ctoi6txojoXXpfGK/dAchax3ckErLqx0=;
	h=From:To:Cc:Subject:Date:From;
	b=khJDio1fuT04VjpQ8He+rtGT5FbjQ8PpZVphdEJOu13J9L8viFj4PPeeI0iofiiWq
	 wmKDfdBeh3IPfEgzc0aFMoAiELoo+gTpekm+4iUrFxmRl6X1uIz4oAPCFsTUzBk4vF
	 6piVM+F8G1vywkXSxBfVcJaR7IWLSBrEp8D1sxLCHvYn7ZRDAcVFTaSW8Zvk8QxF4g
	 ks9H4/AoM+4efSqGttfTGiJzR3MVcqIvBoDMQ5IHiWdaX9gBqzh5sN1YKRoKvldrKr
	 w/NqOsix/qiSchx9VI3DqvvsX5nA/m9t/FSojSNRhUFV8rcCXx1k5hHlJDZUIZrNg1
	 c7KhalLn1z1Hw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vERkE-00000000yNP-0Lxl;
	Thu, 30 Oct 2025 12:27:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v2 0/3] KVM: arm64: Fix handling of ID_PFR1_EL1.GIC
Date: Thu, 30 Oct 2025 12:27:04 +0000
Message-ID: <20251030122707.2033690-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Peter reported[0] that restoring a GICv2 VM fails badly, and correctly
points out that ID_PFR1_EL1.GIC isn't writable, while its 64bit
equivalent is. I broke that in 6.12.

The other thing is that fixing the ID regs at runtime isn't great.
specially when we could adjust them at the point where the GIC gets
created.

This small series aims at fixing these issues. I've only tagged the
first one as a stable candidate. With these fixes, I can happily
save/restore a GICv2 VM (both 32 and 64bit) on my trusty Synquacer.

* From v1 [1]:

  - Make all 32bit ID regs writable

  - Use official accessors to manipulate ID regs

  - Rebased on 6.18-rc3

[0] https://lore.kernel.org/r/CAFEAcA8TpQduexT=8rdRYC=yxm_073COjzgWJAvc26_T+-F5vA@mail.gmail.com
[3] https://lore.kernel.org/r/20251013083207.518998-1-maz@kernel.org

Marc Zyngier (3):
  KVM: arm64: Make all 32bit ID registers fully writable
  KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured
  KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace
    irqchip

 arch/arm64/kvm/sys_regs.c       | 71 ++++++++++++++++++---------------
 arch/arm64/kvm/vgic/vgic-init.c | 14 ++++++-
 2 files changed, 50 insertions(+), 35 deletions(-)

-- 
2.47.3


