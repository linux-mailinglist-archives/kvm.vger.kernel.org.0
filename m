Return-Path: <kvm+bounces-15227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97AB68AACCE
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E1FB1F21DCB
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A118E7E78F;
	Fri, 19 Apr 2024 10:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDuGnBKt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16757D3E6;
	Fri, 19 Apr 2024 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522591; cv=none; b=cYus3kMSkkSUFe7vHLB+8WUgD3uJ1mBNAOhcPDDtgHrHreeytJjRQMu7JexVkQIoQMxLAKqEvoZR3bpf3ka25bIuP4QsppcqZn2HF+tQYS/RRub5WSy5ClkfVT9BKKwnjUyS+2x2ik1BjneY1zmF3mCLhmaAdamnJAhxwrAT/Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522591; c=relaxed/simple;
	bh=KNYLgx5NhqQdD7ul1Nk1kGdw1Hv2DXSeVOrfdXxsuXs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K4Zy8eKNG5VzsiXlUAkA/E8d9ZeciWERrhn5LvDkJ0YgLlX2WLnvXJIY+bqbL+RgHt4HjEazKt0hUamLGfj/ARXItWi9kCnB8yqoyl9R9el6keubEFnjLghLu9oz3NWdxxQhi1WI7Kpfpd32Zz0o+o5qphlnFhutnjqSR5H2+fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDuGnBKt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A176C32781;
	Fri, 19 Apr 2024 10:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522591;
	bh=KNYLgx5NhqQdD7ul1Nk1kGdw1Hv2DXSeVOrfdXxsuXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDuGnBKtC2U4IEzyzQSDCnCr2TOZ9imLo9b31T4hS2iCG/hdPbCcYMbQWLmavFbj9
	 RhH4n9IqCyfkTIqd3SMvC/KuLpbhXzBtPvvEPivEPODcOjp/Dr5haIj+71jcl0Oc1U
	 LQPLFypo/8krnycZbVp4oENnQYYjx2U62yoopxA01aUJ5Iakt9rH+SUEMON0XH2cyP
	 Z/olyfyDN1BPhUh1FQGw27w0Jhxpo/2Tk4HtZ/q7KTDevEWK9UIiKNl5sbMalWnZ1q
	 sxpv6n1vGKudhMkXHg8JhQZ6DVyNb0znTKliTw7MO9azokV9R/sNiDbFkQJ4VExRR1
	 xHLF8EzHAewsg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV7-00636W-4i;
	Fri, 19 Apr 2024 11:29:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 01/15] KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
Date: Fri, 19 Apr 2024 11:29:21 +0100
Message-Id: <20240419102935.1935571-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
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
index 9e8a496fb284..e24bd876ec9a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -896,7 +896,7 @@ struct kvm_vcpu_arch {
  * Don't bother with VNCR-based accesses in the nVHE code, it has no
  * business dealing with NV.
  */
-static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
+static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 {
 #if !defined (__KVM_NVHE_HYPERVISOR__)
 	if (unlikely(cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
@@ -906,6 +906,13 @@ static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
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


