Return-Path: <kvm+bounces-9797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 888BD8670B4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F1721F2CA2A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55AA057860;
	Mon, 26 Feb 2024 10:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vFCJS0Ty"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804B957301;
	Mon, 26 Feb 2024 10:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942058; cv=none; b=tWOFw/tZ1Qit/36ilYWwTDyedM5ZrAN3gvwSkqALI0zGsNo1yCv9jzipxBbBgwtn8cZuxK0tP4XAnBjIwZRwVv2BFuDMlTNaDt5HQWHTPRYg8B+y2gj6N46K/qdQqI27y2OzF785wWfsrORE3OxKD9cfpcOxVTuZG/Q+LcEFfUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942058; c=relaxed/simple;
	bh=e0rt2jqp33R9rOCWsHGguQ7HG/9iK0OPh1vPOWqeSSA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F+Yxf0Kqspa0Tjfy0RMYgsSZ+5sw42qlV/n0FF94CHaA1rbGGpYA02turAjTsD2Q0rEBjJYpVua3WoimLE8f8jMF6bchjgMbOsesKugfb+Z9t4sQDV0Y09j2t8/X8N3V04mqeZWERUkFsbgV3Qw9YNCwkjm47s4jE157uHdYMRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vFCJS0Ty; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51852C433F1;
	Mon, 26 Feb 2024 10:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942058;
	bh=e0rt2jqp33R9rOCWsHGguQ7HG/9iK0OPh1vPOWqeSSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFCJS0TyqfCLhpMW2xV+cpWRO2HEaw4DJbuWC3gqZTgV7N+8oV3ApH0n6k5sSsCqR
	 2tcBj2bMbiA2lrWzWMIwZH7W/7BH6Ri4qDx9TQVjBjsCR9pZ74UFatosNdsQOjs9sI
	 /tOd6rlr3084rK8SCTJTa0QyDrtjfOlDrY9QTOp5WG0284zmfC9AbUp/Si4jCC5Goh
	 ZSIgvvuiH5AW2SlXQpnR9/7rCuTLg7MVxKCmuSTgYSL/ZfI4AnR9XIKsfqwNe1mcvY
	 rVX4ZMBR6hZ54PZOW6e5txBs3IhPb3oh5pMj8O8GIP+bmkUZDVweL+Jh9Jkyak5qYx
	 cL2iWCv5RGQtQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXtX-006nQ5-WB;
	Mon, 26 Feb 2024 10:07:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 07/13] KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
Date: Mon, 26 Feb 2024 10:05:55 +0000
Message-Id: <20240226100601.2379693-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100601.2379693-1-maz@kernel.org>
References: <20240226100601.2379693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If the L1 hypervisor decides to trap ERETs while running L2,
make sure we don't try to emulate it, just like we wouldn't
if it had its NV bit set.

The exception will be reinjected from the core handler.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index eaf242b8e0cf..3ea9bdf6b555 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -220,7 +220,8 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * Unless the trap has to be forwarded further down the line,
 	 * of course...
 	 */
-	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV)
+	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
+	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
 		return false;
 
 	spsr = read_sysreg_el1(SYS_SPSR);
-- 
2.39.2


