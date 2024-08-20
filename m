Return-Path: <kvm+bounces-24608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C8C9584C4
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D82A01F26209
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1DE618E749;
	Tue, 20 Aug 2024 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="unoigxLf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E6618E026;
	Tue, 20 Aug 2024 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150287; cv=none; b=b0lWshGfrsDmMA42LQg7OcmHPKMWlRFe4GjnvteQGIgi58SW/37hoyasP7V4/VxBNXw7lfYj9JCi1whyud8+NUd/MAqSRgjDSxkviTPoBFISq/AgWxJMDokwxY/jlSFDuSiFB9aM674GIRkRkRLdhasqfo1VSAnjpCBNIOP6wvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150287; c=relaxed/simple;
	bh=xWUhduLPLY8cPkBNsSWAzVJeAU5gBhQkiCPlIf44cKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HWzEv6qtyELBIEkp3WTcqpo4wGiSWpjQqYLarCAEAZsQHyIbHdJtdW0lukLVtqNewg1MRdIqpzsZq2R5gKWEUB2W8obl3IrNymvv5W4T+1+m9+FRP/JWJY674qi6Jq0I4OUJ71aTXWBeD0oq2K/pAihcXoa8kOW34gVWOxu+s/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=unoigxLf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B93C4AF1A;
	Tue, 20 Aug 2024 10:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150286;
	bh=xWUhduLPLY8cPkBNsSWAzVJeAU5gBhQkiCPlIf44cKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unoigxLfz5X8wuxhS1nzmFQlHxv6QBCthmt3hQgIXxmG/Tu7SAeU9v3JnFMyiE9/Z
	 zFPrK04YDFokYb8K25wpaIMJRIPgzW6mQjt6AO/niRVEvQ5LzT7R2AwcE2owxAw0Gh
	 H5C4bEg9IRBiMzt1zOlC8jBMvnBmsPl+zJQL51EZacreVTQIyg5JQwMDkCkB8qd2Ta
	 qDgQKT0MRcSIW52BUqRhdyW1rBj3p1w+ZgHwPG3wiIuQi0qpHaxuEen9Cz+DeeXZ0F
	 B4TjCU3rZ0fDsX/CfhgQsdT/MG6RXtHnsCsqWuavftGANbyGCX/UvLBt+nU3LLanLZ
	 B6CkQGSPdBzeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFY-005Ea3-W7;
	Tue, 20 Aug 2024 11:38:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 05/18] KVM: arm64: Make kvm_at() take an OP_AT_*
Date: Tue, 20 Aug 2024 11:37:43 +0100
Message-Id: <20240820103756.3545976-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com, catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Joey Gouly <joey.gouly@arm.com>

To allow using newer instructions that current assemblers don't know about,
replace the `at` instruction with the underlying SYS instruction.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h       | 3 ++-
 arch/arm64/kvm/hyp/include/hyp/fault.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2181a11b9d92..25f49f5fc4a6 100644
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
index 9e13c1bc2ad5..487c06099d6f 100644
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


