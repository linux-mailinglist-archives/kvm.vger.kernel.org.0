Return-Path: <kvm+bounces-22922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F42944831
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFADE286AE7
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDD01A2C28;
	Thu,  1 Aug 2024 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaNA60qW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5EB17165E;
	Thu,  1 Aug 2024 09:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504155; cv=none; b=sUPXiqeeQzruLVjPenqHvbjRGGOtxTmaNLdSOdl/khdrxZgX6uxjFi7kH3Tg9/mgbyjawZ8uiTSMfztsv5MEknMGVv0t29QGGr65CFLcOy0Wb/ee+oDBuFhhHILV2agUrFEs3zTpYGjJDm3cRweSCYbjekznJgcTRsL70eYVz+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504155; c=relaxed/simple;
	bh=I046eeWG/NzNSwMyeP7JQD7T2R8TJtO1NJgePupVeSU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gX+kh1Njt+dyF/43G4asQ5S242g1IHAWtHZG/QBTWOH5v1AvEKibyWWlFQDLmSyBJa6yfocKvw1doy99y7jpylA5+gIJI3F2/VsqRfbImlnUThJaRBg3OG2V4VPyt2CZgxLSL80hu8cfSX0uSldKz4E7U8rFnfTQp/BGM6YHqGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaNA60qW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E277C32786;
	Thu,  1 Aug 2024 09:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722504155;
	bh=I046eeWG/NzNSwMyeP7JQD7T2R8TJtO1NJgePupVeSU=;
	h=From:To:Cc:Subject:Date:From;
	b=KaNA60qWg9p2C1nkl7diBZI8YFQec8vcjFh3rP1hARcat9QFBgI+yezrYMKS+9k2e
	 0mF7W+K81bvslTJnP53u3IVe7/crvDYlMVpI7MIsODvWNCkOHrwJX13s6gQiI4XWWG
	 s970Co1WH67aY97yJB06n9tZkwzbAj1qd6Pw5oo9I17bS39q0kYppBzYCQSEXR57d2
	 fsnomntn+RvYb2QBcWS9+Uk5Nlx7AmKg3tkT5OnEwY7d3GLIg30Afm22MDO50S7RNu
	 /FEB0AKSACuvXcR0FAIc3timZ2afKg6dM1GFSU5Ht99AS8YXyQAYAIteEdsep5PYFZ
	 JliHz7C84Altw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZRyZ-00HKNZ-6P;
	Thu, 01 Aug 2024 10:19:59 +0100
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
Subject: [PATCH v2 0/8] KVM: arm64: Add support for FP8
Date: Thu,  1 Aug 2024 10:19:47 +0100
Message-Id: <20240801091955.2066364-1-maz@kernel.org>
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

Patches are on top of v6.11-rc1. Note that this is compile-tested
only, as I have no access to FP8 HW or model (and running NV in a
model is not something I wish to entertain ever again).

* From v1 [1]

  - Correctly save/restore the guest state (duh), including pKVM
    (double duh)

  - Add a predicate for FPMR support in a VM, as this gets used more
    than twice...

[1] https://lore.kernel.org/r/20240708154438.1218186-1-maz@kernel.org

Marc Zyngier (8):
  KVM: arm64: Move SVCR into the sysreg array
  KVM: arm64: Add predicate for FPMR support in a VM
  KVM: arm64: Move FPMR into the sysreg array
  KVM: arm64: Add save/restore support for FPMR
  KVM: arm64: Honor trap routing for FPMR
  KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
  KVM: arm64: Enable FP8 support when available and configured
  KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests

 arch/arm64/include/asm/kvm_host.h       | 20 ++++++++++--
 arch/arm64/kvm/emulate-nested.c         |  8 +++++
 arch/arm64/kvm/fpsimd.c                 |  5 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  9 ++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  9 ++++++
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 ++
 arch/arm64/kvm/sys_regs.c               | 42 +++++++++++++++++++++++--
 8 files changed, 92 insertions(+), 7 deletions(-)

-- 
2.39.2


