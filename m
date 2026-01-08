Return-Path: <kvm+bounces-67430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E1DD058C1
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6033232529A0
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C922FB0B4;
	Thu,  8 Jan 2026 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeJsbr0O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0812D6E5A;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767893559; cv=none; b=eZcVHe2fjbO3OtnzpiFMfrOnoN1WI9s0EMk8rusvvvua7f9Fk4PS73quT6l+2bqzUlq/Cp8GKenX2eWa8hrrK2dQrZTtwV837ZX+rQkE6qVhLMCiEshThqQeAiOnjvP6CTS1Baw+iQEyVGDaY8r4BKyJP4ULdDqgZ7QESXZqPio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767893559; c=relaxed/simple;
	bh=IcZW2xKZWVowQUhGma/KcEQQVV01mNOM0ePAXLjLOU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktK7RGkmWEWkB/hEu/O93rk8kbHKOdZv9QKXVgv6sIvJcdH9Q8Ij0Ki+OmBuZlHfcpQbShU5SLKS+57d7NjySnHXzJZFaJJG29fUiZSzscfO0x3vuIC8yUU/RiQW6K7rn63q0pn8R1oADH4KCiFgjFwDGvvoaWjnKyN27qt6Dvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeJsbr0O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA10C116D0;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767893559;
	bh=IcZW2xKZWVowQUhGma/KcEQQVV01mNOM0ePAXLjLOU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeJsbr0OWcoKulXWMPLVa1AaUkKP9L4fkJuSl3wgiApx23noIJeKkCvfSQmSTgf2B
	 EYWk7iP/+HBOmePQf6a2uoc4qpPylHQhmn7yGQYjsJNj35+AS8YkJjLNp239Kx7+O6
	 Si73EEN2zei/ZuD+QffbjBFfaYF9oIJtMcEbDmyRuHXrIcdgLAmq63GG8AqFHFEMI1
	 8aWcavJL9z6VTQIiFpXSWPWnmORuDCdBrY9sHW8GT+XBsSLykmODO/WaPAGpghbGOo
	 y7+5WG16U0Mu1xkISDApN0vDzklOpPTLxxUSOtOcLVMzDopOugXhj1yvXNus5CMu1c
	 JrJqnmjHGkI6w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdtsD-00000000W9F-237w;
	Thu, 08 Jan 2026 17:32:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v4 5/9] KVM: arm64: Handle CSSIDR2_EL1 and SMIDR_EL1 in a generic way
Date: Thu,  8 Jan 2026 17:32:29 +0000
Message-ID: <20260108173233.2911955-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108173233.2911955-1-maz@kernel.org>
References: <20260108173233.2911955-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we can handle ID registers using the FEAT_IDST infrastrcuture,
get rid of the handling of CSSIDR2_EL1 and SMIDR_EL1.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8fd7c6a12a13..a2b14ca2a702b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3414,8 +3414,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
 	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
-	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
-	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	IMPLEMENTATION_ID(AIDR_EL1, GENMASK_ULL(63, 0)),
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	ID_FILTERED(CTR_EL0, ctr_el0,
-- 
2.47.3


