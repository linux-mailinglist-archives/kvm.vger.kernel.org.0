Return-Path: <kvm+bounces-54347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B61B1F503
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 16:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C26283BF11E
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 14:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE8E2BE631;
	Sat,  9 Aug 2025 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7sBDTKW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420E68F6E;
	Sat,  9 Aug 2025 14:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754750905; cv=none; b=DwvJvdCStto17dsUgs2meheqkoM6QZjckrQ37QkjXp4vF4eVTyCSA9Nx8yhS0QrdmKtbYSROOqTxK3+33mQxqXekPlI5nCnbA0BEkeLv/UKjplkIOoCtwc1/Qh+d2UhaimeyAE9RQRvXRP+wWZvdy6+qNxjyzHSAcdiDTlze+8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754750905; c=relaxed/simple;
	bh=ayYRoVh3IEbMODwTo+7JYB0k+fZAZLFDAILg4fANdeY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SlqZRhhyvwpo5wiisxZRgK8MCmteH0YPn7laau1j9eae9KzNfPTqchK5N47pcyHvR3pSeEqd1ojLvXL/nkmXKnaCD3AAqcWXik9gkJ+lIrMUueXietdF5d1jhSQZ6ODPweNnrdv3w4x1sTVOaCfFXjzsmeYBGYDUaz0D17kCbIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7sBDTKW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4289C4CEE7;
	Sat,  9 Aug 2025 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754750904;
	bh=ayYRoVh3IEbMODwTo+7JYB0k+fZAZLFDAILg4fANdeY=;
	h=From:To:Cc:Subject:Date:From;
	b=S7sBDTKWw38EAvtne+UzBTjTVX31Ov0UGyRLZR5w/dHd1NPJsBHtA/isfApAIQTFh
	 RgVSMe+bE554JP6Bv6+SDLXrxOMelS39b/mKnRLPiVUhueWvXywAkXQ7CtiJCv2RMs
	 XuJk8u14RbfNPkfmvR60gvRjRkB8y/f4O2mVZ8orRQqM2O7EmduLP8p+EMJVh1udwP
	 OGHdKtFPhoaPMrcp7c9U/jjHdQuPZ3b6R1+tbF2HSsZcnDxXjFwP9FHV2S7SVGDDxe
	 vyz2so7n4bvmIGyY+PScbckhuJYUfPyOmwY4Q02tKcij/ykZ56ocbAxzzXhrxVi3Br
	 XmjWPHD9wU/pw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ukkrm-005eZC-Nq;
	Sat, 09 Aug 2025 15:48:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/2] KVM: arm64: AT + SR accessor fixes
Date: Sat,  9 Aug 2025 15:48:09 +0100
Message-Id: <20250809144811.2314038-1-maz@kernel.org>
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

Volodymyr having reported[1] a couple of rather interesting bugs while
running Xen under KVM, here's a couple of patches to plug these
issues:

- a fix for ATS12 stopping the walk at S1 under the wrong conditions

- a much larger fix for the vcpu_{read,write}_sys_reg() accessors,
  fixing the fate of TPIDR*_EL{0,1} and PAR_EL1, and overall becoming
  much easier to work with

The latter is a pretty large change, but is worth it IMO as it makes
everything much more straightforward.

Volodymyr, I'd very much welcome your feedback on those, as despite my
best effort, I didn't manage to even boot Debian's packaging of Xen
(Grub just refuses to run *anything* after Xen being installed -- I
guess it's not tested at all).

[1] https://lore.kernel.org/r/20250806141707.3479194-1-volodymyr_babchuk@epam.com

Marc Zyngier (2):
  KVM: arm64: nv: Fix ATS12 handling of single-stage translation
  KVM: arm64: Fix vcpu_{read,write}_sys_reg() accessors

 arch/arm64/include/asm/kvm_host.h |   4 +-
 arch/arm64/kvm/at.c               |   6 +-
 arch/arm64/kvm/sys_regs.c         | 243 +++++++++++++++---------------
 3 files changed, 130 insertions(+), 123 deletions(-)

-- 
2.39.2


