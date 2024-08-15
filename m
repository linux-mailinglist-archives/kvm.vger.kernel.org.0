Return-Path: <kvm+bounces-24257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E60F952EA9
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB83A1C24A38
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7235F1A01CA;
	Thu, 15 Aug 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDaecOHq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D8119FA91;
	Thu, 15 Aug 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726806; cv=none; b=V1WJqRobtOrBRBBdhHWmwVItOHHtFdGqTy+WwvzLWU+rYyM42PGlHu5G+NQP1SXV1fYCLIAD9sm7ICqQ6LYuQ4GzLK7b5los/RNW+o423HKjHGrvEKXpqdcWnDvTh6QKHMiOFIwtt3hJ9mzvNgEJPGOZawbIB6giW1CMJorOEcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726806; c=relaxed/simple;
	bh=FdXzmEqnicsBQJVaq32QPKRzq71MPgC+SurKqoL/YQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=csMOYGhkZ/Y8CYlTqAj3S1aWyZH4IRiKnZl10ieWCEPOdJyMHYCYpeiwXfYEAbGrB+Zx3nOELbezhmxb9mgRoB17EXyhuvi2BS/da+VEqP5WzgZQ5CElz0xwTriAAJmlXER04GEudfJelPnhWrPz1eZOZhS4sK2p+aJxzoh1LSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDaecOHq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AFFC32786;
	Thu, 15 Aug 2024 13:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726806;
	bh=FdXzmEqnicsBQJVaq32QPKRzq71MPgC+SurKqoL/YQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDaecOHqkuS1WEzQu0tJ9ifE23c9GA3A0Gdvv9guwT2/B1XQGBP2a4l5cJFVwcgvT
	 g8wEo2VBlmnCipVCHNO8MIyUQzt/r2gf5JGQXP8E2QsQD4I8X55uYR0HWi1r+sCK4w
	 JI5gtgsKHR3fxuMLGjXJH98PlPtc5BnQxu3YscIVkK6IHkttUw5Am22LwzV8kFMZDY
	 +DCsUHxnKIxe6A510tZ/GnoEwuQSr7GSsdEPHOlRXq6oosJ6DiRAq5f7h9+af4OJLH
	 dO1ba8A7+uVU4sI8eBnN6eWpliF8KoDQey8NUi1KW2wsbRrYeHVLIwZQMcqCKDGY69
	 IYFLEo1JiULDQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5E-003xld-5h;
	Thu, 15 Aug 2024 14:00:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 08/11] KVM: arm64: Conditionnaly enable FEAT_LS64* instructions
Date: Thu, 15 Aug 2024 13:59:56 +0100
Message-Id: <20240815125959.2097734-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240815125959.2097734-1-maz@kernel.org>
References: <20240815125959.2097734-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Enable the FEAT_LS64* features by setting the corresponding HCRX_EL2
bits in the vcpu context when these features are exposed to the guest.

The effective value programmed into the HW will change depending on
what a NV guest will program in its own HCRX_EL2 view.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 39c2ee15dc0a..cfd1a1bb9675 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4570,6 +4570,15 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnALS;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnAS0;
 	}
 
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
-- 
2.39.2


