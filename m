Return-Path: <kvm+bounces-9799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D293F8670B7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01C411C23095
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BA35788B;
	Mon, 26 Feb 2024 10:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nf/uT4p9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9D357865;
	Mon, 26 Feb 2024 10:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942059; cv=none; b=JqENrL4Q+/bvo6zXdfesWjg0bO0i8azbdl4vg734CXQh7d2+ox6wMYctn4HcbOZVhf08iRfQr4/Dqe4qHxgWPjbvbQPECOCUPSnxym+T7V6eVdDdD2807yrfLhNLyEVr6Gw3+LwxVsE9IPg1RO1dMBHLge4cXiYuotQ3CgAwY84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942059; c=relaxed/simple;
	bh=Alk8DkWcPcruQ5um5KDrpSCEo4m97neZZIMYfFIrE54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YY2a4UC9fpNDBPeWAmU0Uw317BRhyuvWxsvYhyS97otdmn0Fd2S7Tne/vrN9xggO2wBrmX1+ZeZy24zREo0IzT6f8wCQ/aUyCpWc1VJfiZevS+7niu+FZuPU0Rcf5WIk+b0wA8WgeeBddVQSDrG4CVrziAPuw4tymkBT2sFSi7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nf/uT4p9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1684EC433C7;
	Mon, 26 Feb 2024 10:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942059;
	bh=Alk8DkWcPcruQ5um5KDrpSCEo4m97neZZIMYfFIrE54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nf/uT4p9ryqSnx1s8LF/2/lSMt+CdFhw1PXcwaEpe1ezcf/aWMGzrxkaRPwf/HvXb
	 Y9jh+2HmImSqKyWM1RQCTBnMkCFRLguLdKOUsCI3RSyng9t9p2N9581tlxEo2h3ltZ
	 FYERoGSdELZGKSzV08WoDwjmh9hTRJFFbVgVPKhiIrIUFkC0m8eDfv2Hsf+Va+5WGI
	 fRWLBD47DUveJDny8EqjTApCJeHcGEANbR5bTGAwvD6ypWxeMlicdhED6O9tx/DaOc
	 HD6WFiHs3NEFJlIRs1VwB8vPizduPYkl+HgALYYXYGrwVFX4ph1j24IxUljgtrmyvC
	 nhBTVe/TRcupw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXtY-006nQ5-VC;
	Mon, 26 Feb 2024 10:07:37 +0000
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
Subject: [PATCH v2 09/13] KVM: arm64: nv: Reinject PAC exceptions caused by HCR_EL2.API==0
Date: Mon, 26 Feb 2024 10:05:57 +0000
Message-Id: <20240226100601.2379693-10-maz@kernel.org>
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

In order for a L1 hypervisor to correctly handle PAuth instructions,
it must observe traps caused by a L1 PAuth instruction when
HCR_EL2.API==0. Since we already handle the case for API==1 as
a fixup, only the exception injection case needs to be handled.

Rework the kvm_handle_ptrauth() callback to reinject the trap
in this case. Note that APK==0 is already handled by the exising
triage_sysreg_trap() helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6a88ec024e2f..1ba2f788b2c3 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -214,12 +214,34 @@ static int handle_sve(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
- * a NOP). If we get here, it is that we didn't fixup ptrauth on exit, and all
- * that we can do is give the guest an UNDEF.
+ * Two possibilities to handle a trapping ptrauth instruction:
+ *
+ * - Guest usage of a ptrauth instruction (which the guest EL1 did not
+ *   turn into a NOP). If we get here, it is that we didn't fixup
+ *   ptrauth on exit, and all that we can do is give the guest an
+ *   UNDEF (as the guest isn't supposed to use ptrauth without being
+ *   told it could).
+ *
+ * - Running an L2 NV guest while L1 has left HCR_EL2.API==0, and for
+ *   which we reinject the exception into L1. API==1 is handled as a
+ *   fixup so the only way to get here is when API==0.
+ *
+ * Anything else is an emulation bug (hence the WARN_ON + UNDEF).
  */
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
+	if (!vcpu_has_ptrauth(vcpu)) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
+
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+		return 1;
+	}
+
+	/* Really shouldn't be here! */
+	WARN_ON_ONCE(1);
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
-- 
2.39.2


