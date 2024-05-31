Return-Path: <kvm+bounces-18557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDD78D6CC1
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BD951F2342D
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8445B84DFE;
	Fri, 31 May 2024 23:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zd1pScTW"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0A88287C
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197258; cv=none; b=b07H7oc274amilBLLghdWMONy89zRJFx9tWL2XdXdSqL4lCjWDTELWh+XHX26AfaCIY38IAgT5VNKMb5t5UA9T9wq4KCGTB8NtVX/G5lftuU4enQX23+erhygaQmgfpB0LMV4oUCOMa4Wwu7nUjFxx73psWERJLjhEGDcOLBiQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197258; c=relaxed/simple;
	bh=7uT/i+EIKB2E1Flpr9U13bBqZRxNFsM8a/frF/lyMCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KuJlatOJDnVxMsgaeg7FW0ByNduZU01dT2vRyEhBHw3f1E7nvO3iQBmFnnZAwpPwAJFYsChdRPg+B0OPXNyKDNFYyNMSHKP+S7Kd78A1uTsIsG2dSZAHy17UiSUpXww50Vgnp0Vo2OXCmFtQPUhRdxI29gwDxMi2ZAwsZHCWR9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zd1pScTW; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FpXbjIP2DTyTmP91jE+4H5yRfCNTcp/ucsNL+aNEYR4=;
	b=Zd1pScTWpkDJpHdlUt6GdbTczo9vHC65/QCWHaHKJHp3oFZUGXntWY4uKMOpK28nRo2WYo
	Qd7msu1kBlI3Z6v6kma1ZVHi922mpXMvC1dvzw6Pj08muc2V3zyOGWeLvGTJU53gaQ4iuB
	BNNQF5QUUViNBN0zyqmpWRoUBYAX1Jg=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 00/11] KVM: arm64: nv: FPSIMD/SVE support
Date: Fri, 31 May 2024 23:13:47 +0000
Message-ID: <20240531231358.1000039-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hey!

I've decided to start messing around with nested and have SVE support
working for a nested guest. For the sake of landing a semi-complete
feature upstream, I've also picked up the FPSIMD patches from the NV
series Marc is carrying.

The most annoying part about this series (IMO) is that ZCR_EL2 traps
behave differently from what needs to be virtualized for the guest when
HCR_EL2.NV = 1, as it takes a sysreg trap (EC = 0x18) instead of an SVE
trap (EC = 0x19). So, we need to synthesize the ESR value when
reflecting back into the guest hypervisor.

Otherwise, some care is required to slap the guest hypervisor's ZCR_EL2
into the right place depending on whether or not the vCPU is in a hyp
context, since it affects the hyp's usage of SVE in addition to the VM.

There's more work to be done for honoring the L1's CPTR traps, as this
series only focuses on getting SVE and FPSIMD traps right. We'll get
there one day.

I tested this using a mix of the fpsimd-test and sve-test selftests
running at L0, L1, and L2 concurrently on Neoverse V2.

Jintack Lim (1):
  KVM: arm64: nv: Forward FP/ASIMD traps to guest hypervisor

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

 arch/arm64/include/asm/kvm_emulate.h    | 47 +++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  7 +++
 arch/arm64/include/asm/kvm_nested.h     |  1 -
 arch/arm64/kvm/arm.c                    |  5 --
 arch/arm64/kvm/fpsimd.c                 | 22 +++++++--
 arch/arm64/kvm/handle_exit.c            | 19 ++++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 43 ++++++++++++++++-
 arch/arm64/kvm/hyp/vhe/switch.c         | 62 +++++++++++++++----------
 arch/arm64/kvm/nested.c                 |  3 +-
 arch/arm64/kvm/sys_regs.c               | 40 ++++++++++++++++
 10 files changed, 206 insertions(+), 43 deletions(-)


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.1.288.g0e0cd299f1-goog


