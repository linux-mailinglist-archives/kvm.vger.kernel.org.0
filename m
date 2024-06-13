Return-Path: <kvm+bounces-19617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DAE7907D51
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:18:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8A9C1F21D37
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3531C13958C;
	Thu, 13 Jun 2024 20:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="szt4UVsU"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AF712EBF3
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309913; cv=none; b=JeXu+d0GePTLiGijgOrxakkaqZ0krIv4MQl6nhDoXjs2wwHWWI6KqHmfiRNvefENGtEXOY1aULKBdQne7rEux9EORUeRbwqqSwiEHuVnyqkwrd/8SaWuNrRLQ37Jurgo0X2kD5Wemqie766jteli2nGMiIGWu/j2o5RFO3XbBhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309913; c=relaxed/simple;
	bh=aUA6GkBCXlHEKjTMOAarYKrx5UDdpgklYNaD5KhUVyE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YFlrbEkiaR1IjI052bTQ9U2wGKhKKj21Xt0aLoqsouZCPhIxR2uHg/yLhOUN4wVBQnuUbNeReP1mjpYUv2RXDG1vcOAwkMsjjEyKjJTfExQT6KtLfDDn1WJtfdCK+nCSZaL2CFDErUpt4YoKUqcQAhaLo/B0DD3qUr5wZG6lbfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=szt4UVsU; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=J7UqqLkx9Att1F5lKMFuTx4t69pmgAIBy2UA9BMWSDw=;
	b=szt4UVsUMH/5/VuPyv3qqfhfjASDQmJDe5YqBNYrITMy7AhJNmoN7t3G9R09/2Ov2Gd7F5
	GbWejjsRxP87SC9W2uO4XCRWRZa0V4BS4UmDdWjYfZtS9fJjY3EEcyN7ww+uJoNcEBpuBm
	fGC3AYtz+sbRe+I/m+6SFtMcQqahkKQ=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 00/15] KVM: arm64: nv: FPSIMD/SVE, plus some other CPTR goodies
Date: Thu, 13 Jun 2024 20:17:41 +0000
Message-ID: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As discussed, here's the combined series of Marc + I's patches that
implement all the trap forwarding / merging logic required to observe
the L1 CPTR configuration when running an L2 guest.

Like before, this was tested on Neoverse-V2 with L0, L1, and L2 running
fpsimd-test and sve-test on top of one another.

v1 [1] -> v2:
 - Grab Marc's CPTR trap patches [2]
 - Avoid taking two traps when L1 accesses ZCR_EL2 while the host owns
   FP regs. The fast path will now load the FP regs and forward the
   sysreg trap to the slow path for complete handling.
 - Add a comment describing the above behavior (Marc)
 - Avoid the use of guest_hyp_*_traps_enabled() in
   __activate_cptr_traps() for better codegen (Marc)
 - Document the reason for only testing bit[0] of CPTR_EL2.xEN when
   folding L1 traps into the hardware CPTR value.
 - Add a helper for synthesizing SVE traps, rather than open-coding the
   ESR value in access_zcr_el2()

[1]: https://lore.kernel.org/kvmarm/20240531231358.1000039-1-oliver.upton@linux.dev/
[2]: https://lore.kernel.org/kvmarm/20240604130553.199981-1-maz@kernel.org/

Jintack Lim (1):
  KVM: arm64: nv: Forward FP/ASIMD traps to guest hypervisor

Marc Zyngier (4):
  KVM: arm64: nv: Handle CPACR_EL1 traps
  KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
  KVM: arm64: nv: Add trap description for CPTR_EL2
  KVM: arm64: nv: Add additional trap setup for CPTR_EL2

Oliver Upton (10):
  KVM: arm64: nv: Forward SVE traps to guest hypervisor
  KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap
  KVM: arm64: nv: Load guest hyp's ZCR into EL1 state
  KVM: arm64: nv: Handle ZCR_EL2 traps
  KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
  KVM: arm64: nv: Use guest hypervisor's max VL when running nested
    guest
  KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
  KVM: arm64: Spin off helper for programming CPTR traps
  KVM: arm64: nv: Honor guest hypervisor's FP/SVE traps in CPTR_EL2
  KVM: arm64: Allow the use of SVE+NV

 arch/arm64/include/asm/kvm_emulate.h    |  55 +++++++++
 arch/arm64/include/asm/kvm_host.h       |   7 ++
 arch/arm64/include/asm/kvm_nested.h     |   5 +-
 arch/arm64/kvm/arm.c                    |   5 -
 arch/arm64/kvm/emulate-nested.c         |  91 ++++++++++++++
 arch/arm64/kvm/fpsimd.c                 |  22 +++-
 arch/arm64/kvm/handle_exit.c            |  19 ++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  24 +++-
 arch/arm64/kvm/hyp/vhe/switch.c         | 156 ++++++++++++++++++++----
 arch/arm64/kvm/nested.c                 |   3 +-
 arch/arm64/kvm/sys_regs.c               |  38 ++++++
 11 files changed, 380 insertions(+), 45 deletions(-)


base-commit: c3f38fa61af77b49866b006939479069cd451173
-- 
2.45.2.627.g7a2c4fd464-goog


