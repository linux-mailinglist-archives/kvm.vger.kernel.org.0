Return-Path: <kvm+bounces-12405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96949885CAB
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:54:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 517EA285405
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B5212BEA5;
	Thu, 21 Mar 2024 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eu2HViKn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F351A1292D1;
	Thu, 21 Mar 2024 15:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036472; cv=none; b=JSD/AUGYuCcvst9wC1ykLKQ+OT7gW3pFyljtkTRYIF6Z6pbICQ+/jRbZzs17ppavj0tt7rXabH+IJ2oC6Nh+qa7f56RsasAjAMGq2+8oa51SeTRJtXr0BQB+R5MfYR1FnxFNmk7GjnmQcqGENRCaL3cSZxyqx5eA/BVwV3Mr2n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036472; c=relaxed/simple;
	bh=B5KlM7mxnuT+54M22DLYGxp97WwZIk75EIF9VXlqvD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EX8AZ9/L+f722DdgHNVdfLXoWZ19i31N/BF+/EXj09Bf3E7qO4y6oEfPUzyqY7i6J9ZBp+eQ/MVms5kEQybvbv1ag0FKUbL5NaacMEXN4XXDJcUxkOrfC9PLqKbtGiFll7eMjBSBO23zIEpy/S9r0X2QR0hW8A2aF2zjFsSg1ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eu2HViKn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90611C43399;
	Thu, 21 Mar 2024 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711036471;
	bh=B5KlM7mxnuT+54M22DLYGxp97WwZIk75EIF9VXlqvD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eu2HViKnqOA5mgCVXXVbN4AWQCs83gyVoAZQ/uqXBmGPgfEDPjnPzxYWSSA2E+IVO
	 yKuexCAaAsEL4VbCd9+Hq6j5Q/hqjHEoGTmiL9Gt3puRpj6Bo+JSMmaIPtelabPODH
	 A1M9A0GbxnyosB2oTkjSrDMs2D8BTwGiatzncq0qETOaPUtxI32D5kQ/H96POUXD0X
	 F8aMvJtgsZFFP9r89CghfbtS5ZeZbtc6RxECACxHLOqqmTUyPH6vpDS+4nInycruJE
	 SczOfg1fwrv6GBkCVduM1Eo6i2HDT7G3NRKkdO1w3LOYhaadUMOeTBMKrwfdJAuLND
	 ixIr6vFrmcXng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnKkP-00EEqz-HJ;
	Thu, 21 Mar 2024 15:54:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 01/15] KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
Date: Thu, 21 Mar 2024 15:53:42 +0000
Message-Id: <20240321155356.3236459-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240321155356.3236459-1-maz@kernel.org>
References: <20240321155356.3236459-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The unsuspecting kernel tinkerer can be easily confused into
writing something that looks like this:

	ikey.lo = __vcpu_sys_reg(vcpu, SYS_APIAKEYLO_EL1);

which seems vaguely sensible, until you realise that the second
parameter is the encoding of a sysreg, and not the index into
the vcpu sysreg file... Debugging what happens in this case is
an interesting exercise in head<->wall interactions.

As they often say: "Any resemblance to actual persons, living
or dead, or actual events is purely coincidental".

In order to save people's time, add some compile-time hardening
that will at least weed out the "stupidly out of range" values.
This will *not* catch anything that isn't a compile-time constant.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6883963bbc3a..839c76529bb2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -895,7 +895,7 @@ struct kvm_vcpu_arch {
  * Don't bother with VNCR-based accesses in the nVHE code, it has no
  * business dealing with NV.
  */
-static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
+static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 {
 #if !defined (__KVM_NVHE_HYPERVISOR__)
 	if (unlikely(cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
@@ -905,6 +905,13 @@ static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 	return (u64 *)&ctxt->sys_regs[r];
 }
 
+#define __ctxt_sys_reg(c,r)						\
+	({								\
+	    	BUILD_BUG_ON(__builtin_constant_p(r) &&			\
+			     (r) >= NR_SYS_REGS);			\
+		___ctxt_sys_reg(c, r);					\
+	})
+
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
 u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
-- 
2.39.2


