Return-Path: <kvm+bounces-21099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD6F92A5F7
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 156401F21E71
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4286144D3E;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jsZU4Eyg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012F8142E8D;
	Mon,  8 Jul 2024 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453495; cv=none; b=RwnvpQKwaRil/hDSHBCdwu6jZVpbh1GAIu/XHlz21M90+dhAyov15HqAXe/4wNWWKJ3O/4a/6y+vFMD4dGNPruhbcQswuX/FVl4gjGtKFYuRo5/PrnTlUtBZ5bVGBPaV5GoYNkq3n3WYiNmziXgKSz9HhRjxmthxirqnwlw6Kvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453495; c=relaxed/simple;
	bh=Xfz4WXL/9Lt0RTxagOQrxxUD5NaqarQygvSwbXyzrnc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B+4p+NEOPdoBwTR3Fuv72y+RmyWQnD9C7gMW+5rMPtaSpNldSSnozKTz3g3OaGECj9d2p6l9z/s1UumOYszDQyWW6NItlabl0vX2Jjex/JHsZzi94+Zm2OWYm2ylFPgBQqMM2GPx/xLNqheBT6B/C5fw2IgfWonZFLobiFnNUmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jsZU4Eyg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E66CC4AF0C;
	Mon,  8 Jul 2024 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720453494;
	bh=Xfz4WXL/9Lt0RTxagOQrxxUD5NaqarQygvSwbXyzrnc=;
	h=From:To:Cc:Subject:Date:From;
	b=jsZU4EygvkG5gLEDEydCqSiyu9ovGBrAxcpBEmuUKGd/3gTF8BRFsm+AEXz5gc9a2
	 kBHVRlDKnZqL4zcqpkTn6ugbSqxwvn1neS8B2z7lfRMs/v3gjwNBHPm225gc05p3G3
	 0LBkLSey8BAdw1jFyvt385KQLrbEp3fbo2rbJ6DNcXaA/vcFwOXYH2PqENKOgKIrIS
	 XQLhRSBOmtahuWy/kuklY0GTShg1bETKVPsTz5ncVvdQ9MlKIO01Mwcg2gX/bfLUUx
	 hIbYCA+W7TY9kzhD6K2DmMiTvOYCUi9M4drw2MgJhEKC9dnN+l5KjFeQM5VK6x6ZT2
	 qorsYJJngX2kg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQqXs-00Ae1P-8W;
	Mon, 08 Jul 2024 16:44:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/7] KVM: arm64: Add support for FP8
Date: Mon,  8 Jul 2024 16:44:31 +0100
Message-Id: <20240708154438.1218186-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although FP8 support was merged in 6.9, the KVM side was dropped, with
no sign of it being picked up again. Given that its absence is getting
in the way of NV upstreaming (HCRX_EL2 needs fleshing out), here's a
small series addressing it.

The support is following the save/restore model established for the
rest of the FP code, with FPMR being tied to it. The sole additions
are the handling of traps in a nested context, and the corresponding
ID registers being made writable. As an extra cleanup, SVCR and FPMR
are moved into the sysreg array.

Patches are on top of kvmarm/next, as this would otherwise majorly
conflict. Note that this is compile-tested only, as I have no access
to FP8 HW or model (and running NV in a model is not something I wish
to entertain ever again).

Also, this is *not* 6.11 material. 6.12 if we're lucky.

Marc Zyngier (7):
  KVM: arm64: Move SVCR into the sysreg array
  KVM: arm64: Move FPMR into the sysreg array
  KVM: arm64: Add save/restore support for FPMR
  KVM: arm64: Honor trap routing for FPMR
  KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
  KVM: arm64: Enable FP8 support when available and configured
  KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests

 arch/arm64/include/asm/kvm_host.h  | 16 ++++++++++--
 arch/arm64/kvm/emulate-nested.c    |  8 ++++++
 arch/arm64/kvm/fpsimd.c            |  5 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  4 +++
 arch/arm64/kvm/hyp/nvhe/switch.c   | 10 +++++++
 arch/arm64/kvm/hyp/vhe/switch.c    |  4 +++
 arch/arm64/kvm/sys_regs.c          | 42 +++++++++++++++++++++++++++---
 7 files changed, 82 insertions(+), 7 deletions(-)

-- 
2.39.2


