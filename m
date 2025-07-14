Return-Path: <kvm+bounces-52319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40920B03E93
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 826A07A8411
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14670248F4E;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGf8nvMI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326EF247290;
	Mon, 14 Jul 2025 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496004; cv=none; b=BCeZbiFEYR7MQgJUCmsKVxdq/J6xnQYp3cxFQ3Ltfy0rof15aXdy0Wqiq14dFJm+31/cfPs9heBS18r6KtLi1UcZ1Nm/owya6mFyQqlxlsv+TV3GnFY0AAoUMwLP04AwJsj925OK/gmVXxUVKAnzCfhfM6BXkcuVYv+O+EZ1vHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496004; c=relaxed/simple;
	bh=XJ3TrLkRrj+mRM4a05rezAW0AfRDUsAnmqyYGIp/zo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PRRrvdyBOVQK9SbAijzv8m8Rzrbe1/cMGWWJKBY9sBK0hBtWPzOT/aUb+Oz/cRYEh/DUeA00/nmse7zcvlHnD/HSrTE4utQshLK0CxGRfr8ZUuNUoHKhH7ajU2F+AzkAM+SzfbkIWFI6WWgxLZ1dlBP0MqWzNp3sPoBoE/DAtzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGf8nvMI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B829CC4CEF4;
	Mon, 14 Jul 2025 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496003;
	bh=XJ3TrLkRrj+mRM4a05rezAW0AfRDUsAnmqyYGIp/zo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGf8nvMIT1Y+ULXRFOQtOVCAZOMDYpRBBzwunh1brBIxQr77cyJ4kREqBg7KuS6wu
	 539OvS8hhG5l95dNZrOSg3lOfITd/XOmbkcmwGe/Do30+83JWcYJsHdXe3luBFxoUm
	 MarVEmngnl9xHyuaATBqH2wUvjq5nujk0rxU4QcpCD4CW4sBeKi9CQg0c79P5Mf03z
	 puoFhUXFbnKn13feK61ypmFBF4pgTB+ST8X13RBA8t8P+DNZpbnJPNanSqhgpHOMun
	 LSVnWKUlbL+2R8utE1JiQ1aGf8g52kjey7wWD9BcNrc7ZiRhAoPudw4z761nH8k+9L
	 BEtTiFkx0GdZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGX-00FW7V-Qh;
	Mon, 14 Jul 2025 13:26:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 01/11] KVM: arm64: Make RVBAR_EL2 accesses UNDEF
Date: Mon, 14 Jul 2025 13:26:24 +0100
Message-Id: <20250714122634.3334816-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714122634.3334816-1-maz@kernel.org>
References: <20250714122634.3334816-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We always expose a virtual CPU that has EL3 when NV is enabled,
irrespective of EL3 being actually implemented in HW.

Therefore, as per the architecture, RVBAR_EL2 must UNDEF, since
EL2 is not the highest implemented exception level. This is
consistent with RMR_EL2 also triggering an UNDEF.

Adjust the handling of RVBAR_EL2 accordingly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f8..3f226cd5b502e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -108,7 +108,6 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		PURE_EL2_SYSREG(  HACR_EL2	);
 		PURE_EL2_SYSREG(  VTTBR_EL2	);
 		PURE_EL2_SYSREG(  VTCR_EL2	);
-		PURE_EL2_SYSREG(  RVBAR_EL2	);
 		PURE_EL2_SYSREG(  TPIDR_EL2	);
 		PURE_EL2_SYSREG(  HPFAR_EL2	);
 		PURE_EL2_SYSREG(  HCRX_EL2	);
@@ -3370,7 +3369,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_MPAMVPM7_EL2), undef_access },
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
-	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
+	{ SYS_DESC(SYS_RVBAR_EL2), undef_access },
 	{ SYS_DESC(SYS_RMR_EL2), undef_access },
 
 	EL2_REG_VNCR(ICH_AP0R0_EL2, reset_val, 0),
-- 
2.39.2


