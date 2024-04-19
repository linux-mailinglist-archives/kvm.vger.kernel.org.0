Return-Path: <kvm+bounces-15236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B07618AACD7
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2F0E1C20D44
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F68A81203;
	Fri, 19 Apr 2024 10:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="skVSkIri"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C8F7F48C;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522593; cv=none; b=VzrhVIxPBaf13XAHtV3zx6c8Fwi5g1TpmHBdv9xVW8sqGi2Ri5xCFdv+EvTO1GoAcYtFRja7Z6xkvlkJ7eBoR4z1/41jew/m7+etd8PQ/gn1MK9I098dbDALw2CLQn3tNKH82f4Ts1j799DsaakA4X3+CrBfWb7YDXoUAUVLI8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522593; c=relaxed/simple;
	bh=Alk8DkWcPcruQ5um5KDrpSCEo4m97neZZIMYfFIrE54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KNmPts8YoV94V9oKO/ajM9Zbrq5/iSJKv9o+lR5KRHLmfl5/XKLTfwCL7p8WIzcyH5pUpKgUZZfi53SoJHGgOh6rENzfkwfPOvOa2GMlmv7dFLUr1ve8X90yTkON/jMVdkxfYjU2aVXmvEafkdUGuWjkGpb9NN2vP9hRmaU4km4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=skVSkIri; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B504C3277B;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522593;
	bh=Alk8DkWcPcruQ5um5KDrpSCEo4m97neZZIMYfFIrE54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skVSkIriuOpK0iffn+AxzWWeiOvNIqp8cRmSl+phTSJvg3xZ1vnADur2SZS8fdfuC
	 80NC+Q0E1fYXoJs+4Sh65nvu2jR3cOA70Hkfed4dZ6D4dzNWToQGW2IMtuNQt8f22z
	 uCb+WVJ8HGTAZv1PpwgyXTG/HCBs4UxSGvxwO/Qet9TaXvFnUwxemCy35jUVy9vgk7
	 sB0vMLqseBifJPjK7ZWn4c6XDhpREIaB7ThQBtxLJQwKW6C9C/9M52nCGi5Vpm301w
	 GRfH7AklBBfoghqid4/Jpnj3fVFmC6BuzzrcphQbq/A4SVzuQTk3Dji6znaiXZVvYQ
	 rlBmlOJaLvvog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV9-00636W-4p;
	Fri, 19 Apr 2024 11:29:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 10/15] KVM: arm64: nv: Reinject PAC exceptions caused by HCR_EL2.API==0
Date: Fri, 19 Apr 2024 11:29:30 +0100
Message-Id: <20240419102935.1935571-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
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


