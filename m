Return-Path: <kvm+bounces-20120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93329910D74
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D8EDB21CEB
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950F31B29BB;
	Thu, 20 Jun 2024 16:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cAhph4ut"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD290156256
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902030; cv=none; b=eiGwxs+GgTXImwdUDaTSqSy/N6QeYpqpO0qRTKADMLSD31XkK9dlEY71RIU0ZT64die231trDjTSanL5cYuWwj4t8ITQoGWuEmNXtrSEYzB84R4/JlNBY10wEQIXnloRnnmIAka1q2MfrZaIjEPkf3FvWCNC1vDHEV2mocipo3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902030; c=relaxed/simple;
	bh=RnCOOp7IFdwfmtZ+upmhDazSohqvNm8iTeQSUYvd/c0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S+c9XpPBnQMg/hkVBffhVxNkqg3yCq0WjFGh9+yr/bFW5keyK3JwGpdXfMhEFXA1E/OUj02bgY3aJdRMX45GudVFVFH4W+wEGWrtyLYSyPVacHMI1syw3e7Qo3nAdhxMQ0UuAFr3DxSakORtD9/OvDy3q+6nJaDlb6KaLLE8NC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cAhph4ut; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JznYArgtRf/uSrUvrG9m9fcDQH+e12uEyuDMKGlj2ME=;
	b=cAhph4utm8Fv2NMjgZmn/G2fe8p3h1RnexWobyvZ6x6LvRJ9990/KRWRJM+Zmok3c0a0Zj
	DVrVwXPr00N6dcS3ttAkYleM3vXvN6I3Igz1YGdbzcqnYJZw+iDCRyG3BGcgX97LIvh4+Q
	kr+GE5HArFtBZTaeCGB69i+7QYaFZ0U=
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
Subject: [PATCH v3 00/15] KVM: arm64: nv: FPSIMD/SVE, plus some other CPTR goodies
Date: Thu, 20 Jun 2024 16:46:37 +0000
Message-ID: <20240620164653.1130714-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v2 -> v3:
 - Reorder patches to fix bisection (Marc)
 - Use helper that returns ZCR_ELx offset, so it can be used to handle
   reads and writes (Marc)

v2: https://lore.kernel.org/kvmarm/20240613201756.3258227-1-oliver.upton@linux.dev/

Jintack Lim (1):
  KVM: arm64: nv: Forward FP/ASIMD traps to guest hypervisor

Marc Zyngier (4):
  KVM: arm64: nv: Handle CPACR_EL1 traps
  KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
  KVM: arm64: nv: Add trap description for CPTR_EL2
  KVM: arm64: nv: Add additional trap setup for CPTR_EL2

Oliver Upton (10):
  KVM: arm64: nv: Forward SVE traps to guest hypervisor
  KVM: arm64: nv: Handle ZCR_EL2 traps
  KVM: arm64: nv: Load guest hyp's ZCR into EL1 state
  KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
  KVM: arm64: nv: Use guest hypervisor's max VL when running nested
    guest
  KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
  KVM: arm64: Spin off helper for programming CPTR traps
  KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap
  KVM: arm64: nv: Honor guest hypervisor's FP/SVE traps in CPTR_EL2
  KVM: arm64: Allow the use of SVE+NV

 arch/arm64/include/asm/kvm_emulate.h    |  55 +++++++++
 arch/arm64/include/asm/kvm_host.h       |   6 +
 arch/arm64/include/asm/kvm_nested.h     |   4 +-
 arch/arm64/kvm/arm.c                    |   5 -
 arch/arm64/kvm/emulate-nested.c         |  91 ++++++++++++++
 arch/arm64/kvm/fpsimd.c                 |  19 ++-
 arch/arm64/kvm/handle_exit.c            |  19 ++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  24 +++-
 arch/arm64/kvm/hyp/vhe/switch.c         | 156 ++++++++++++++++++++----
 arch/arm64/kvm/nested.c                 |   3 +-
 arch/arm64/kvm/sys_regs.c               |  38 ++++++
 11 files changed, 376 insertions(+), 44 deletions(-)


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.2.741.gdbec12cfda-goog


