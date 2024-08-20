Return-Path: <kvm+bounces-24605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4AB9584C1
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:38:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 232D128633A
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442F318E036;
	Tue, 20 Aug 2024 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPVtgzs6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0AE18DF93;
	Tue, 20 Aug 2024 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150286; cv=none; b=jzoCYDf4LeUN3OUMQdHTcgCtORpifv92IYWSgd3UNjkaRumnzhVuKZdctftHKp6UlaeiT+0czCRjc/Qq88QAXle4+fGX9HdPwG2k7x6TqicgI/qn9tm2BWsUGQ0OrpDsw1SL1rZzpRKbfzNtKvV/VbWkI3LfSlI940B4TfkUHMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150286; c=relaxed/simple;
	bh=AfD3pkKeWkAMQNzJlwdw56rA+nl7NWbqVY/PrOBr0/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BQ0X9QqFA+JjZSHx18whz/cOD+/4blMFv/Xu7sObGm0Rga2x0qGeK+R2L2P/Eir3mtetahGN9VN+x/fV6Xm0NnTFv4H7wUqTlV1zzHmmec7TiUAl1LXScJX1wdYkohvl76Ydprfd/WNOWmCIxC7GyOW2rWEClKnV5awxHA/U1Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kPVtgzs6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E22EC4AF16;
	Tue, 20 Aug 2024 10:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150286;
	bh=AfD3pkKeWkAMQNzJlwdw56rA+nl7NWbqVY/PrOBr0/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPVtgzs6utPA+vih9iwIDUTaAYNGQHcjW1Gwm1KxcSSvI+t9lBsTYZQ8XBXDY5SFD
	 cM7mCTYrAxHpgwO0l1gHOLwucIvPWh9shMFAB8XnZTfg6W2JF8jrPrzEBTBDwyeDRh
	 nOuAMiWHzhQfmchtjuqaTKw7HlwXxhF++TqrtaFa+krtcWztBrotw7wojfQioyMknU
	 KO4nY7mY4ea2SUMChuqXMLmqHpz35d3VyVRYdwgCye7icCx44Oh4d5Vufydz8FY+Z3
	 LXUjvwm9Q65ekLq0hM4/iGD3si/tQ1VtiTyeYeG99YObuNus1nL88+5MZNnJIEULma
	 5lVwsChiOnXhA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFY-005Ea3-HL;
	Tue, 20 Aug 2024 11:38:04 +0100
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
Subject: [PATCH v4 03/18] arm64: Add system register encoding for PSTATE.PAN
Date: Tue, 20 Aug 2024 11:37:41 +0100
Message-Id: <20240820103756.3545976-4-maz@kernel.org>
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


