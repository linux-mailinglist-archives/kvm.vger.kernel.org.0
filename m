Return-Path: <kvm+bounces-19624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF97E907D58
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:19:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A87B1C2273C
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56F713B5AC;
	Thu, 13 Jun 2024 20:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G4PxLkML"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B0013A240
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309926; cv=none; b=p1rOmRYBHxFqztW4KvG9x32EfllySbuRB+nAOd3hjcmzLli7BtwWgH1nhFMMS1b0mPNxeczcA+lxEsvAnatETYWPMjt5iT621eYyIEAUx9WbVwYTSmPqOHTDVK7hJ+yWQLu+6jYtCSDVeQmxenMbX2qq9ljiSp8l/ePDmriCvCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309926; c=relaxed/simple;
	bh=7dwMWGA/FVftz7QTT9g+E6z80h/FVdohQHhZp6qAeNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zx0BnnLA7DSNEVdTuQIeJESB72w+GkMlOx2MQ7S/cBR4JwnumZPJ1vepZ6pSYjPWpLPfh6OfaNTXz/nan3VW0Opj0VthkH2MPbNFsSknGFDTfHqdQBhOUXhYhXCnmCayseMk54bu0rQY5+dd0+XjrG9kmAitkYJarpV1l6nNyJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G4PxLkML; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UWkEZTkuA/ZXxYNk+cvUOFeBhkGAABmhVnDXAk5ktaM=;
	b=G4PxLkMLIlKpyo0wCUA3TEKDWCHrc4pMGZOYg5bZpwMsrYEvF3wR6T7/d1omSLx5TECPEq
	wKjVUicN3JgzYMpWktE+KuE9eDz+tduDopvq8Z8qjjgy5EjXSwgeMkaRfcXW0uSdC2V5GD
	AI2MaQfh/EZPMLoAa1nUlYnMIQhg5ls=
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
Subject: [PATCH v2 07/15] KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
Date: Thu, 13 Jun 2024 20:17:48 +0000
Message-ID: <20240613201756.3258227-8-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When running a guest hypervisor, ZCR_EL2 is an alias for the counterpart
EL1 state.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/fpsimd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 1807d3a79a8a..53168bbea8a7 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -173,7 +173,16 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu)) {
-			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+			u64 zcr = read_sysreg_el1(SYS_ZCR);
+
+			/*
+			 * If the vCPU is in the hyp context then ZCR_EL1 is
+			 * loaded with its vEL2 counterpart.
+			 */
+			if (is_hyp_ctxt(vcpu))
+				__vcpu_sys_reg(vcpu, ZCR_EL2) = zcr;
+			else
+				__vcpu_sys_reg(vcpu, ZCR_EL1) = zcr;
 
 			/*
 			 * Restore the VL that was saved when bound to the CPU,
-- 
2.45.2.627.g7a2c4fd464-goog


