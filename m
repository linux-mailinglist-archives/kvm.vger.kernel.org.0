Return-Path: <kvm+bounces-29554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8B89ACDFE
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87EFF280F55
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEDC6209F4C;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qt2si3Rr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0528320967D;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695238; cv=none; b=UXHh9NsCjhwIhvTR89B0BEJX40fTNZTO7e+9cC3IwF+HP2zJQG+KmKRosD8HaEkBD6Hmu1Cyavz0XM9AS+YmcQNaXjAGOqniO4qmuVDEr8hNzgghYuJ7c4OyZksZsIQVjo7odqtVWLHoN+jcNoVzMK86Y+1SeqoqpDsT7Qc3LfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695238; c=relaxed/simple;
	bh=3G1xYA34SHjfXANtSC9yiL8s0uLe55QVekkzGzfYn3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iljDM2CMt8o2sujZ7ISheIaLgTUksR/5Pnwy/qW4B2KVaITFlQJHZfwNSh9NBT5ZKc4cCGEOGzvsQcY3+zD8kkdjoVihX+NT+GOP6imh5GMsOOVj8Trz0dqI97FZ5Pw4WEptOeYHB8wIyzITZEIluoGJVclkXMMLgPkn7ntQ+2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qt2si3Rr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6990C4CEE8;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695237;
	bh=3G1xYA34SHjfXANtSC9yiL8s0uLe55QVekkzGzfYn3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qt2si3RrI4YYz9q84umz4H8ioLRDqFVL5HfTd/xxv4Zgt9RvP4ElsPNFGvIjWLb9E
	 bemajTQ9FS4edYbvXamE0Qg7ImZyVUUu7r8UiWHxfQLGTsRknXKkw8lzOm40ldSqNS
	 lPSF8zPO5/AjB6nWuKNp2yvwZjXujrtaGh7TttjUny7IJMzC6na6/Q+zFE/fsRYpJq
	 wN1udVW4Z71xH7dFrLJ2DOn8jvhlVX16PmDVcm8Fgamhc2BgrFc+eqZKOUYg3ev+IC
	 nhUdyuy0CdlE2bHZQ9G0EAmHZFdGsdKPc4aVcIXAAbTphqugI9r1o5anuq68MOiKx4
	 bwR+PsR20Pn2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckG-0068vz-4n;
	Wed, 23 Oct 2024 15:53:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 32/37] KVM: arm64: Add save/restore support for POR_EL2
Date: Wed, 23 Oct 2024 15:53:40 +0100
Message-Id: <20241023145345.1613824-33-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

POR_EL2 needs saving when the guest is VHE, and restoring in
any case.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index a603966726f65..5f78a39053a79 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -58,6 +58,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 				__vcpu_sys_reg(vcpu, PIRE0_EL2) = read_sysreg_el1(SYS_PIRE0);
 				__vcpu_sys_reg(vcpu, PIR_EL2) = read_sysreg_el1(SYS_PIR);
 			}
+
+			if (ctxt_has_s1poe(&vcpu->arch.ctxt))
+				__vcpu_sys_reg(vcpu, POR_EL2) = read_sysreg_el1(SYS_POR);
 		}
 
 		/*
@@ -123,6 +126,9 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIR_EL2), SYS_PIR);
 			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIRE0_EL2), SYS_PIRE0);
 		}
+
+		if (ctxt_has_s1poe(&vcpu->arch.ctxt))
+			write_sysreg_el1(__vcpu_sys_reg(vcpu, POR_EL2), SYS_POR);
 	}
 
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);
-- 
2.39.2


