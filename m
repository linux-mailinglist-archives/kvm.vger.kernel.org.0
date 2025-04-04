Return-Path: <kvm+bounces-42678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7235FA7C1DB
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 18:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DA963BC813
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617A8214A66;
	Fri,  4 Apr 2025 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xs3yS0XA"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660CF212B3F
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 16:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785594; cv=none; b=Yg1MsXIGVCqM9Tp/FCrK2JUJRbT5PqANaaN6OCt/YCzCIKq+oAAOuJMB71DtOjG+Qeapt0WjUMGxpAVGrmmX1zM4Eji04l1Hqrr0C1mgmZFO7SiC3D0FXWJNM6sY01rwlnMPw3ptYVxvoFu84M4igYfqCS0cF0LQJh22ZP37S5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785594; c=relaxed/simple;
	bh=uylS2fH8HOVWEiMejNDgXahFJMwVFoQ8VEqCmtDQjp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mUKRSVooMDmMBLBpNFuCZRTxjKYUOD6ORN3G2sXWPvd62oPCET9IPZwYz8dkA/beqrzHDnclKbmTK5oUTiH6/coFwDI5jrRBg47/HaNe/YDzjeWpnn3qDmemH0VeAaEPIJmyt5eDK2bM07wuYRXm2OB4VHidcy9adTQ29x2kfMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xs3yS0XA; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVLygIQ8gQ31JvfSPdyVIbUnMl1rHte2lGTyT296jas=;
	b=xs3yS0XAEaWLBZVmsRkGOgfM6OagCr6K7k2vfNWhHiNe2ebTHfm+pOG+0d1LwSgvqkv6UU
	mWtWj6wwumCSbjQoaonBQo0rYCh9DNsEeTHqQc7pn1Hh9YDud6YmhuovLNlgVKMf7TBPgI
	PLiR1TVt3HQsRfrBeQsnposKOe7RqdI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 00/19] KVM: arm64: Debug cleanups
Date: Fri,  4 Apr 2025 09:52:33 -0700
Message-Id: <20250404165233.3205127-11-oliver.upton@linux.dev>
In-Reply-To: <20250404165233.3205127-1-oliver.upton@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hopefully the last round.

v3 -> v4:
 - Collect Tested-by from James (thanks!)
 - Delete stray if condition (Marc)
 - Write mdcr_el2 from kvm_arm_setup_mdcr_el2() on VHE
 - Purge DBGxVR/DBGxCR accessors since it isn't nice to look at

Oliver Upton (19):
  KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
  KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
  KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
    vCPU
  KVM: arm64: Move host SME/SVE tracking flags to host data
  KVM: arm64: Write MDCR_EL2 directly from kvm_arm_setup_mdcr_el2()
  KVM: arm64: Evaluate debug owner at vcpu_load()
  KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
  KVM: arm64: Select debug state to save/restore based on debug owner
  KVM: arm64: Remove debug tracepoints
  KVM: arm64: Remove vestiges of debug_ptr
  KVM: arm64: Use debug_owner to track if debug regs need save/restore
  KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
  KVM: arm64: Compute MDCR_EL2 at vcpu_load()
  KVM: arm64: Don't hijack guest context MDSCR_EL1
  KVM: arm64: Manage software step state at load/put
  KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
  KVM: arm64: Avoid reading ID_AA64DFR0_EL1 for debug save/restore
  KVM: arm64: Fold DBGxVR/DBGxCR accessors into common set
  KVM: arm64: Promote guest ownership for DBGxVR/DBGxCR reads

 arch/arm64/include/asm/kvm_asm.h           |   5 +-
 arch/arm64/include/asm/kvm_host.h          |  94 ++---
 arch/arm64/include/asm/kvm_nested.h        |   1 +
 arch/arm64/kvm/arm.c                       |  14 +-
 arch/arm64/kvm/debug.c                     | 384 +++++++--------------
 arch/arm64/kvm/emulate-nested.c            |  23 +-
 arch/arm64/kvm/fpsimd.c                    |  12 +-
 arch/arm64/kvm/guest.c                     |  31 +-
 arch/arm64/kvm/handle_exit.c               |   5 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  42 ++-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  43 ++-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  13 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |   8 -
 arch/arm64/kvm/hyp/vhe/debug-sr.c          |   5 -
 arch/arm64/kvm/sys_regs.c                  | 245 ++++---------
 arch/arm64/kvm/trace_handle_exit.h         |  75 ----
 16 files changed, 353 insertions(+), 647 deletions(-)


base-commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
-- 
2.39.5


