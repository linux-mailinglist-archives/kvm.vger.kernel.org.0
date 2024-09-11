Return-Path: <kvm+bounces-26525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB2E9754B4
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:55:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88FE0B265F3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587291AB6DA;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCt/PH1N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530F61A76A6;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062721; cv=none; b=RgW8aCOdEjAb4naUqzN3sR6AOlUHYqzXcwDYWhlBvQVNMBR4zRrTZxPFZmX8InaOgeGPCRBBfRMlYl+GDu2XR2HH5t5p2dwmtl2kn4Ga7P1qRUYW5vn+53M/V7i2A87oHuYfedezuCLR/67UP6ntYDWo+DBzOBdFXpOpls4xCOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062721; c=relaxed/simple;
	bh=I8opGiuqFUxiSXZuaqA7KAMi/5a4PI7HF5UfCvQZp8M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iuB3XIqJM6n1TU8hEdrpzI5wACspgmMlPsDN596RRdcwfVfDrtkDbwTfra5FBe9l25yzLrcHM+HInCmYRkGC7EeqQi3kwtldAj2uHQxRMWBkE7L+2tVg2OaEMXyIreNJ+Kk99AwIQN1fKdrc90J3cVufds5cv14Sb4a4pt3EV7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCt/PH1N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5A1C4CEC5;
	Wed, 11 Sep 2024 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062720;
	bh=I8opGiuqFUxiSXZuaqA7KAMi/5a4PI7HF5UfCvQZp8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCt/PH1NLgk3mOv14rGFiXCjOOj4fmWkxrr0/3rE5Wv0QvQ2LxcBKY4ah8qLxcm20
	 NlXyLHbcuUaOzWFiEmSneNZL8jsIdwHcWTXzIKs92uWtyAroRnzMvf3XelKuyqmRTV
	 xcQadcZNCn4k55fTyd0lW6oFGwcmRDv9SrUawNoG+YnIJdanRXrA4nqyaPgz3TORhg
	 9Gi5VYjU2nhgNKTAwn0mu29e9rfptNNSGQzyhAL9wScHtbmCCr6qyTGHvqvIH+0XPb
	 hISffa3YeO6H2fhb8/ODTrwB0LQcgXlV5YDRBMa1w+mn4ujEhSKah03HtuxMfUj90j
	 ba8BG80SCAxIg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlH-00C7tL-4S;
	Wed, 11 Sep 2024 14:51:59 +0100
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
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 14/24] KVM: arm64: Add save/restore for PIR{,E0}_EL2
Date: Wed, 11 Sep 2024 14:51:41 +0100
Message-Id: <20240911135151.401193-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Like their EL1 equivalent, the EL2-specific FEAT_S1PIE registers
are context-switched. This is made conditional on both FEAT_TCRX
and FEAT_S1PIE being adversised.

Note that this change only makes sense if read together with the
issue D22677 contained in 102105_K.a_04_en.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 5f69a1f713cfe..005175c10b4a9 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -51,9 +51,15 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 		__vcpu_sys_reg(vcpu, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
 		__vcpu_sys_reg(vcpu, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
 
-		if (ctxt_has_tcrx(&vcpu->arch.ctxt))
+		if (ctxt_has_tcrx(&vcpu->arch.ctxt)) {
 			__vcpu_sys_reg(vcpu, TCR2_EL2) = read_sysreg_el1(SYS_TCR2);
 
+			if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
+				__vcpu_sys_reg(vcpu, PIRE0_EL2) = read_sysreg_el1(SYS_PIRE0);
+				__vcpu_sys_reg(vcpu, PIR_EL2) = read_sysreg_el1(SYS_PIR);
+			}
+		}
+
 		/*
 		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
 		 * the interesting CNTHCTL_EL2 bits live. So preserve these
@@ -111,9 +117,14 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 		write_sysreg_el1(val, SYS_TCR);
 	}
 
-	if (ctxt_has_tcrx(&vcpu->arch.ctxt))
+	if (ctxt_has_tcrx(&vcpu->arch.ctxt)) {
 		write_sysreg_el1(__vcpu_sys_reg(vcpu, TCR2_EL2), SYS_TCR2);
 
+		if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
+			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIR_EL2), SYS_PIR);
+			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIRE0_EL2), SYS_PIRE0);
+		}
+	}
 
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, AFSR0_EL2),	SYS_AFSR0);
-- 
2.39.2


