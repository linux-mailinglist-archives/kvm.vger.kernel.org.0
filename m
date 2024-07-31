Return-Path: <kvm+bounces-22807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CCC5943690
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:41:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26902B20CA2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA145166316;
	Wed, 31 Jul 2024 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxUHfTT6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6C5149C51;
	Wed, 31 Jul 2024 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454855; cv=none; b=f3AK2kqgQIQZWO8sP3OdrnDUxwTKK5xEhg+qoWAxQ66bx2BBj5FAdtzl9rVqqVUDe0VtAPeUsqoUoAsMJDhyUJMfo3LtSD320o7RFvKv57XS/gikJreO1idUmquEFvZWvWWjGdw1dLd4jbORcD5/+TgVmuKHo6S5rDgBUkKBI14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454855; c=relaxed/simple;
	bh=AfD3pkKeWkAMQNzJlwdw56rA+nl7NWbqVY/PrOBr0/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hlwmG4eX10fFkBS9XH8ac9V7ErfJ05KeRuZGvW8N9XOKEqcNzjDyTVn5XWnjv18yabJBWik+pxtlcIsOShN3rVMe8wECwb+ixXkNS8RuCs38xEvTP/iMlY0Jwr7V1uZW11LiKfnLvVfNVW4JDTrW8RTdV9qtmu92KpnpDfoLXPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxUHfTT6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E654C4AF0B;
	Wed, 31 Jul 2024 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454855;
	bh=AfD3pkKeWkAMQNzJlwdw56rA+nl7NWbqVY/PrOBr0/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxUHfTT6npuMQ+VJf29MzrORAkmMfgP8WE0PcVZvY92F8/7G3eSLNhG8fxt6N3hBw
	 lKusmMh638mMCnyNnoYTsYKn8OgeYElg/qLd3UYDQSc+2coSN83QMfeo4W7XY8r0yV
	 4evi3gKVaZqmVv3DBN4t8mHAE/XJBWKLkGSLY1k6dm3jx2XzTD4jlM4H5BW2J3O9Ju
	 bGue3WUUEAWgzsD907nhsLeYaIZX87QATkbTXhMO+DHNLIgFJwP3DN3La7mEUVvNcq
	 JYvJe1jfKi/Kx1XXOK2eYiIOtYuSc1X5LBJTntq+dsXJe6EW8+IW1vfrgByP/n/tT9
	 8CpKMlzMbesGA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBt-00H6Gh-HE;
	Wed, 31 Jul 2024 20:40:53 +0100
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
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 03/17] arm64: Add system register encoding for PSTATE.PAN
Date: Wed, 31 Jul 2024 20:40:16 +0100
Message-Id: <20240731194030.1991237-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although we already have the primitives to set PSTATE.PAN with an
immediate, we don't have a way to read the current state nor set
it ot an arbitrary value (i.e. we can generally save/restore it).

Thankfully, all that is missing for this is the definition for
the PAN pseudo system register, here named SYS_PSTATE_PAN.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d9d5e07f768d..a2787091d5a0 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -109,6 +109,9 @@
 #define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
 #define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))
 
+/* Register-based PAN access, for save/restore purposes */
+#define SYS_PSTATE_PAN			sys_reg(3, 0, 4, 2, 3)
+
 #define __SYS_BARRIER_INSN(CRm, op2, Rt) \
 	__emit_inst(0xd5000000 | sys_insn(0, 3, 3, (CRm), (op2)) | ((Rt) & 0x1f))
 
-- 
2.39.2


