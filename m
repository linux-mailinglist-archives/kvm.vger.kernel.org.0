Return-Path: <kvm+bounces-65265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F826CA313F
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 10:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E479C30331D4
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 09:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388FB339704;
	Thu,  4 Dec 2025 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s28FcMyj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D3F3385A0;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841717; cv=none; b=a42e+BYShuESM1wKkEtqMvt1Q3ri41EQOIxT/vVn4R3MblWQ0ubHX2JnPMrUpPAThhm5mmhLlQfwmkK5JwXlxuopwHmGok6eDMdWr3nqwUy2ARF+BeE6qeuqPeEsftsIB08suNOciOCiiB7WFFdPSyyScY6GgiIoYSE4icbaUe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841717; c=relaxed/simple;
	bh=il8COfiF1FhMwmH8tRnlXmaXeF2Tmchwrjdh9u49mVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJ4wVrLs8Lzp2NTHWmNlFvxht7d4HUfzzpZmxGkURutahaKoPDt3knz5mBgNYF2kNy0W4COmWcDSAcIAFebveK58Jn0DVPKlHGKBKmnPg3XaM7BQEPbmaKL2RzfJxZMG0EyDotpvg2yep1X0Z8K0Pd2KGi8WZz4bL0grRTWeJeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s28FcMyj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B5BC113D0;
	Thu,  4 Dec 2025 09:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764841717;
	bh=il8COfiF1FhMwmH8tRnlXmaXeF2Tmchwrjdh9u49mVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s28FcMyjwMNwULAc6L+uyVPfLy+inyctkJtZBE6bRUqO8KtDrGYxsTM8+d/I+1X1F
	 diAHfHPxLvUuv6QTHSJ92VCAKA4ZhiaS3gZyu/xf1Yrr3yA9XK4PHS5bp1Xr9KFn6O
	 ltbB7QsSM2TXO+I+CIsJhr+9w36/0/R6D4pNBoDLgsXBV5HK7XiveuRHaXgC4BwmIM
	 tMuT/dWEOwPHMZVJ5ylVJEPjxHuFndgYNzmEXn5rPF3kHgQalI/kFx6pnzHkJBFjFa
	 ZoNUXp/ihvw7cy4yzL2h9f6vqGXH8Xs5aI2RXjd5fQltj7L146IeCa2tyaZnsBhF9v
	 S7Pe0JQ3RdoTA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vR5ww-0000000AP90-3Vw7;
	Thu, 04 Dec 2025 09:48:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v3 3/9] KVM: arm64: Add a generic synchronous exception injection primitive
Date: Thu,  4 Dec 2025 09:48:00 +0000
Message-ID: <20251204094806.3846619-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251204094806.3846619-1-maz@kernel.org>
References: <20251204094806.3846619-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Maybe in a surprising way, we don't currently have a generic way
to inject a synchronous exception at the EL the vcpu is currently
running at.

Extract such primitive from the UNDEF injection code.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
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


