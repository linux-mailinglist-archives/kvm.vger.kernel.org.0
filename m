Return-Path: <kvm+bounces-39145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B10A4487E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4858A1892900
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D7620E019;
	Tue, 25 Feb 2025 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrmrLfkE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29B11A5B94;
	Tue, 25 Feb 2025 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504586; cv=none; b=E2ro7GrNw4pKRadhO8FfF+KDGmKAuaIINcNgfCLP9FKe8KZEdgX9tgX+aAbCE3f/pEdo6wRo/9PI+DsAy4r9bJn+yikF3X1buOIQ0YkBCDTyZhIokmjHhzVea2c+I4ZzOOVa2NQwBICn5IhEKW55BqXfHAk5xSiyeaKZ8U9EKVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504586; c=relaxed/simple;
	bh=ESwX6EF3BCC2lwWOyls+2h12qkuPf4F6Nzx6z8FG6xE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XjSHi+hahjXbT0q1POrjvU0GvOd9yLrXQvLXSM9ju9cAJA/Wmj/vmF39mzDZLWQHTVQuKtGpWJLoMYRc5sb6jZyuM5qbu1HZacrYBus9vXD+9FkRGQafmXs8FpE5hmSGfmcUdBFwhrTCy8qG5mOEahWfV3fM6eA5X6N2VS1WO9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrmrLfkE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72268C4CEE7;
	Tue, 25 Feb 2025 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504586;
	bh=ESwX6EF3BCC2lwWOyls+2h12qkuPf4F6Nzx6z8FG6xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrmrLfkE3MXvktJ1qmq9aaNk2MKuMwqxqdwltXNdTiJMsL54zz3H3MoFcgS2jcy9T
	 xbJFFQrWs/b/HTSNIjUDy166HhoKaMyiSqCfEuPOVjWNA1SUBQ4xVXs8FU0rjO2ny9
	 OTkq3wttKNrLsI/l6B4ilXS9qqbs0V7mu2tVxkgrUryosYCxWF4KyQVbhs9X/DDLt9
	 yr1xF9fmiSTjmmm1XgLf30NZpmnf/UwHa5+pYJULd4LCMM8edA0CUQNZHEybs578nR
	 jlPJ+rg7tX0X+SpgY5n2TABhuKWEyhOZcN4YEyPdMMi0jy2umA58KK6pJhfKMOD07z
	 A+8UvNkh/ZWXQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tmyka-007rKs-Gk;
	Tue, 25 Feb 2025 17:29:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 04/16] KVM: arm64: nv: Load timer before the GIC
Date: Tue, 25 Feb 2025 17:29:18 +0000
Message-Id: <20250225172930.1850838-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250225172930.1850838-1-maz@kernel.org>
References: <20250225172930.1850838-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order for vgic_v3_load_nested to be able to observe which timer
interrupts have the HW bit set for the current context, the timers
must have been loaded in the new mode and the right timer mapped
to their corresponding HW IRQs.

At the moment, we load the GIC first, meaning that timer interrupts
injected to an L2 guest will never have the HW bit set (we see the
old configuration).

Swapping the two loads solves this particular problem.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b8e55a441282f..f678a77438cc0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -576,8 +576,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 nommu:
 	vcpu->cpu = cpu;
 
-	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
+	kvm_vgic_load(vcpu);
 	kvm_vcpu_load_debug(vcpu);
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
-- 
2.39.2


