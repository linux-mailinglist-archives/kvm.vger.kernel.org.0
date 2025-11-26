Return-Path: <kvm+bounces-64682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60FEEC8ACC9
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 379EC3B47D1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C110433CE91;
	Wed, 26 Nov 2025 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cc+ij8tS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC5D33BBAB;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764172802; cv=none; b=ilUKdvNelgMBHcwk+43VT7ljWeJGz90T2xHzQrgv0SDL84pTM5ayH0DbFi8GFIX/8jQNCON3y9Mf6vSiAe/Tuw87MlZsyonDjdaJ+ngyQb2ubzICY2YrmVLR0u/yB3oA/+Nyyh+6d3KX8pYoQ5BF6zbpuuvpmHMzsvhQU7C9pCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764172802; c=relaxed/simple;
	bh=oMUFNhJwoz5712RpwSGLvZcN/b61b7Nh7mKR2kXcc4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAiiPLdB4nPikOhwTAWZvjOkcfm2y0VmzBJ14LSHq8XPJawLgYGrd9nifl0WM7mxJv6l4268y9BbUaUOmIskqjhrEdx/P4bE6FGAQFlz8HA9Rx/qF5W+/XqRHOx9GNMemYxzuhs6w5XWHiTezGPmIQs9yhkg638PVvz1Su3eciM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cc+ij8tS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843EBC19424;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764172801;
	bh=oMUFNhJwoz5712RpwSGLvZcN/b61b7Nh7mKR2kXcc4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cc+ij8tSa4xgyJVhUE0KraHDww+nZLCb1jt7kLYoun/0UO7q9ryxfxSB06Cwlh6FE
	 GRQHgd7NIEb12Q5q4Py7hTpC4D6DTbW3PyZ5I3bs2U3cbBlCo4l+qXu1k2t3iZKMkO
	 89wC2E7FRi47mWqhDzUMr9xEAg7F987gQ4ZwuzYsWrgjuVO07p/PxER0wp6k+l5C/k
	 7b7jqfVqD+F3bmfF50fDNDb+nAadU/ac6s36McjzdI1Po2Qs393+1BWGvlBJw08cyX
	 Fap20KzZHDce1HhIofR38IYTvHeraq8i7N/e9810QVO4yHo4fYFtJ4AVdI94NGIiKi
	 raPK/sudkO2vg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vOHvz-00000008WrH-00Zc;
	Wed, 26 Nov 2025 15:59:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v2 3/5] KVM: arm64: Add a generic synchronous exception injection primitive
Date: Wed, 26 Nov 2025 15:59:49 +0000
Message-ID: <20251126155951.1146317-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126155951.1146317-1-maz@kernel.org>
References: <20251126155951.1146317-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Maybe in a surprising way, we don't currently have a generic way
to inject a synchronous exception at the EL the vcpu is currently
running at.

Extract such primitive from the UNDEF injection code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/inject_fault.c        | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9eab316398e2..df20d47f0d256 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -45,6 +45,7 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
+void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 esr);
 int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr);
 int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index dfcd66c655179..7102424a3fa5e 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -162,12 +162,16 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
 }
 
+void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 esr)
+{
+	pend_sync_exception(vcpu);
+	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+}
+
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
 	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	pend_sync_exception(vcpu);
-
 	/*
 	 * Build an unknown exception, depending on the instruction
 	 * set.
@@ -175,7 +179,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_trap_il_is32bit(vcpu))
 		esr |= ESR_ELx_IL;
 
-	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+	kvm_inject_sync(vcpu, esr);
 }
 
 #define DFSR_FSC_EXTABT_LPAE	0x10
-- 
2.47.3


