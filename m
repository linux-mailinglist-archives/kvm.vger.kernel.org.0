Return-Path: <kvm+bounces-9791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DED4F867111
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DEDFB20C97
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FC7EADD;
	Mon, 26 Feb 2024 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q2FMuR3r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E09655E7C;
	Mon, 26 Feb 2024 10:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942055; cv=none; b=sNzF3RA4dYps51EEQN1cjX+qSdCm6T10T3UwHvyNfclxfmleWtMC66juNl6RHLySr3spP8+/imeSfGxSopsMQbsal6MC1RMgkYUKBUKNOtIkWZ44k6vuM/81G1ZrItedd0qGOEXpp3oneglnvzfaZpBniWO8wD325mKhOe40z3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942055; c=relaxed/simple;
	bh=I/0qcEQ1vzLU0qnD+UitYiE6zuVdPy7kzlaKwTqcXrA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DxBiinstkCjBkboq8fG5FEMI3FIEpcbTHxH3n4Fi5bRaU92BZfC8uWzah1VRmThmbh+mUZJpspTEBRn2VQrI/NlVTzlDwIneqUsgjuI5VVKXXUEzTC1e+997ZW6ZWK/vALM2jjplICqtioJeo/SuXhSyMQDHmY9nFgtvMnT13mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q2FMuR3r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC41C43394;
	Mon, 26 Feb 2024 10:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942054;
	bh=I/0qcEQ1vzLU0qnD+UitYiE6zuVdPy7kzlaKwTqcXrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2FMuR3r7I/RNuP/7IOwXDtKN4w/bfDTf5wIRPNklx9KbFyFMZRmBXkKnCooXZATr
	 1IGreiHzyQYyJ5qqgf4nRlay7pc9MWV1dX5s8HNtH4dOYp2gtF9mujiOCHb6yjkeLu
	 CNzmTS5QU5om9pkmxty2BzqFdUl4CAEWNEk+/dDLlFnnbdLTbchybtoQINb1dxt2Ri
	 wpkPbKs9epkC+dHJeHmgYhKcDVDiF9MQi/sDaCleh59jzQOSOi6aiZXzEHQ/ne137H
	 pdsCHJ5e5dIIVj6j4fpGqfZN8we2mIVHSi1j6LpMi2vD90EH3ZgM3lBbt1EWawkNfo
	 ZwBuXo3W/0okA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXtU-006nQ5-4h;
	Mon, 26 Feb 2024 10:07:32 +0000
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
Subject: [PATCH v2 01/13] KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
Date: Mon, 26 Feb 2024 10:05:49 +0000
Message-Id: <20240226100601.2379693-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100601.2379693-1-maz@kernel.org>
References: <20240226100601.2379693-1-maz@kernel.org>
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
index 181fef12e8e8..a5ec4c7d3966 100644
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


