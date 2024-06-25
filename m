Return-Path: <kvm+bounces-20486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF44916913
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:37:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D546E28AA7A
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBA616FF33;
	Tue, 25 Jun 2024 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLX+nqOH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6FB16E879;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322525; cv=none; b=p6AaR1eSERnRRM0nxZGq1PiMJHvipXgf8FVWloaIVjZBGYs2iIuSGymhrmqIMDoXSbEa9fJFn/BuOkODee1GtV8x0KGx7ygmL4pbewsB6lB9C19uZVRpUi3/y2TfmjgXQAeyOVTopS1jTED8Hd/aZ28IQoyx2WTRTOPfL19/AY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322525; c=relaxed/simple;
	bh=O2khzE1fdyGIte4KZD309c05XGX8LSqpr8bp0t6E7fg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aYnsP876qEhP4kI5YeoWR4LWMDKdf1IsTa4cZPy1oO5goFBEhci4nNRhNXmPuM3dyit4x7PE7Ti+GEktUhnDbk2DEFkqY+I1rPkIUcUMSK/ecGlZsvYs6DLj0i1cwNQn8AD8zyPWPBu+QU2gfo0VLn7VikcztsXFoaPCnLWFKhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLX+nqOH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE0CC32781;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322524;
	bh=O2khzE1fdyGIte4KZD309c05XGX8LSqpr8bp0t6E7fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLX+nqOHNTx8D/kGeB8eYVf0gddOZM7yDKUgumJ/Y+vK102AnxX16Y909cO5qVgG2
	 d/nC8/ievD3Ub4VpqW1u7IKU8PSSJ9D9qW9//T9s3waeq53+yZr84akLWXBGrrUKp7
	 tI/gg0Fy+vUD3AicZsKY+eGD3RPB5J+bF1if+yx0qPpxykMD6TK8JqJdkMRC/Zlx2y
	 zZYE8W+yXJrd/6khoRakP+xS0+gUXaxZADp5RQVCaPM4mlxUN/jvfKsxmHfsuZQLbv
	 7ZRI7yLTnPgmxw1EG5ljztSTyrjl+25sIex3uLMrCfjYNqZ6AOKzSHL0lHxSNzuP2g
	 Rm+dyyzkaWvag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KQ-007A6l-No;
	Tue, 25 Jun 2024 14:35:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 05/12] KVM: arm64: make kvm_at() take an OP_AT_*
Date: Tue, 25 Jun 2024 14:35:04 +0100
Message-Id: <20240625133508.259829-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Joey Gouly <joey.gouly@arm.com>

To allow using newer instructions that current assemblers don't know about,
replace the `at` instruction with the underlying SYS instruction.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h       | 3 ++-
 arch/arm64/kvm/hyp/include/hyp/fault.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2181a11b9d925..25f49f5fc4a63 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -10,6 +10,7 @@
 #include <asm/hyp_image.h>
 #include <asm/insn.h>
 #include <asm/virt.h>
+#include <asm/sysreg.h>
 
 #define ARM_EXIT_WITH_SERROR_BIT  31
 #define ARM_EXCEPTION_CODE(x)	  ((x) & ~(1U << ARM_EXIT_WITH_SERROR_BIT))
@@ -259,7 +260,7 @@ extern u64 __kvm_get_mdcr_el2(void);
 	asm volatile(							\
 	"	mrs	%1, spsr_el2\n"					\
 	"	mrs	%2, elr_el2\n"					\
-	"1:	at	"at_op", %3\n"					\
+	"1:	" __msr_s(at_op, "%3") "\n"				\
 	"	isb\n"							\
 	"	b	9f\n"						\
 	"2:	msr	spsr_el2, %1\n"					\
diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
index 9e13c1bc2ad54..487c06099d6fc 100644
--- a/arch/arm64/kvm/hyp/include/hyp/fault.h
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -27,7 +27,7 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	 * saved the guest context yet, and we may return early...
 	 */
 	par = read_sysreg_par();
-	if (!__kvm_at("s1e1r", far))
+	if (!__kvm_at(OP_AT_S1E1R, far))
 		tmp = read_sysreg_par();
 	else
 		tmp = SYS_PAR_EL1_F; /* back to the guest */
-- 
2.39.2


