Return-Path: <kvm+bounces-28320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFF399753C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4599A1F24D16
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B46111E284F;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Klqhtamt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B5E1E200A;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500444; cv=none; b=XgHwIm3vDGZV1VQbGRk4kEjJLQjGEqv4WtdbzS8YZRGdHXs7YNy7mM6zjJoyUmtocTHM02oH50dh8+6+ABG7L72WOp/RYC58iu8LEdvqZdKtRbZ01O6ZS9+TvUjxHHvpOoW9a7hBJaxJOclBLk5QTr7x16ML8AJmCJDC7SXBJps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500444; c=relaxed/simple;
	bh=qTU8Sn0UfT+g1/7CEvxr+5RdaQfMXlRaTE9fmjoEjhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AID9+JwEthaMmW62Xtis4WoKKYsTtrVSuJTQYQcHt6lTyd69JZrTHUQGZal91KiGzADjvOFwQfTiZpHIgF/DpHt0gFsLju1e/pPcPk2QUNgdu+qZIJ4B80t6d3ZxPzE2gK9rgRqMufkrNWjvgxFB1oq2E/YBLTCSSi5EzG+VnBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Klqhtamt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D4CC4CED0;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500444;
	bh=qTU8Sn0UfT+g1/7CEvxr+5RdaQfMXlRaTE9fmjoEjhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlqhtamtU9a6e32QOtcJ6sScyFBW1AGp40EXY6/PNvfJ3BdKZWq3k/qyI+XMGps3C
	 ILn/MLhRcm5emhoZfwfWscaqtE6Gn+ShzIS7xfl3edyz2RENoii1rh36oaj6bwxUg5
	 ip9CbCe1UkDi8/5F34y3XhPdjC3CaW/oFzT6AztTsnM7yJHvleptfnXT2O6GX0Rtz3
	 yltQwUD2xzAbwrN7UJIHqqZJeTsgE3+hyPzB7/WHBk31wZIX0bDvy0qv/vQ2r+8h7e
	 0t2qIQG2KT8ZXF+nAsuu3JmLiKmK43F2hfECeF46MSebz1LPqEx7rZWrCukK+DTEIo
	 Lbif5/Owu09zw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvO-001wcY-7m;
	Wed, 09 Oct 2024 20:00:42 +0100
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
Subject: [PATCH v4 08/36] KVM: arm64: Correctly access TCR2_EL1, PIR_EL1, PIRE0_EL1 with VHE
Date: Wed,  9 Oct 2024 19:59:51 +0100
Message-Id: <20241009190019.3222687-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
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

For code that accesses any of the guest registers for emulation
purposes, it is crucial to know where the most up-to-date data is.

While this is pretty clear for nVHE (memory is the sole repository),
things are a lot muddier for VHE, as depending on the SYSREGS_ON_CPU
flag, registers can either be loaded on the HW or be in memory.

Even worse with NV, where the loaded state is by definition partial.

For these reasons, KVM offers the vcpu_read_sys_reg() and
vcpu_write_sys_reg() primitives that always do the right thing.
However, these primitive must know what register to access, and
this is the role of the __vcpu_read_sys_reg_from_cpu() and
__vcpu_write_sys_reg_to_cpu() helpers.

As it turns out, TCR2_EL1, PIR_EL1, PIRE0_EL1 and not described
in the latter helpers, meaning that the AT code cannot use them
to emulate S1PIE.

Add the three registers to the (long) list.

Fixes: 86f9de9db178 ("KVM: arm64: Save/restore PIE registers")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 329619c6fa961..1adf68971bb17 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1030,6 +1030,9 @@ static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
 	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
 	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
+	case TCR2_EL1:		*val = read_sysreg_s(SYS_TCR2_EL12);	break;
+	case PIR_EL1:		*val = read_sysreg_s(SYS_PIR_EL12);	break;
+	case PIRE0_EL1:		*val = read_sysreg_s(SYS_PIRE0_EL12);	break;
 	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
 	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
@@ -1076,6 +1079,9 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
 	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
 	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
+	case TCR2_EL1:		write_sysreg_s(val, SYS_TCR2_EL12);	break;
+	case PIR_EL1:		write_sysreg_s(val, SYS_PIR_EL12);	break;
+	case PIRE0_EL1:		write_sysreg_s(val, SYS_PIRE0_EL12);	break;
 	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
 	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
-- 
2.39.2


