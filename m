Return-Path: <kvm+bounces-37713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44D36A2F785
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:43:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A20E41885427
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB78257AF8;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuIENE/6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BC125A2D4;
	Mon, 10 Feb 2025 18:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212920; cv=none; b=q+tla6/BU6kvUscQxHwsCEtVy5W06B+1f9QhBlwt6XU9LpxysmCf3RNUUinrntZELj3Vzi6yg9CThejApR7ERcCt6phjR55Py3dJg0WAk61EdjlxFITVJQ4yMrJ/9jhaRxsUktAC0hRGcCfPBWsaW2916kF3DQG47hEgfU2eqz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212920; c=relaxed/simple;
	bh=Wi2tx+wpbCR4WtycbeYLZhI3AsgEkM8AXxOTe1vY7yU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RGbSOmuabZ42DxckNbG5KXSwL2xytnukZ4QVISss0au2kpD78yxQEkBHl8psJj12fVrUHpxQpRoLTDj+ViUYotGKJIHlHwmWOsnAEaGqKNS6MC87q1XOBVBzpyqkGbZW6+UV6bxIQBrjDZ2G9vQdbFtN+P54es0IGSOwlJ2BvdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuIENE/6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D171C4CEE8;
	Mon, 10 Feb 2025 18:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212920;
	bh=Wi2tx+wpbCR4WtycbeYLZhI3AsgEkM8AXxOTe1vY7yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuIENE/6RVcsxFzRVQL2ldgYzZPpnFVWpmdBtuN4lS/qbsrAXpE6wXAUhstvPAkEz
	 qg/IYjlYwLfoFIGcANHmCNNwKpo/IFityJ+0WZJ3ugr5P2YQQQuFHFYGiJhIsNuQ22
	 1iv91cixOaLkDTjHfUM5P/Va0FdX/dbhbcaIf/LNnEsnKWRMa5fH9JAgylZKz7hgxb
	 iaLEmjc8hDqNfIYs/9JjbJHnoKPqZZMlkhdzOG/9UpLxZgO1x6cZnyp3LolcXr9c9w
	 Ij/KHAFcfiSDCJ5Q9DkM0SRJ5vuCmzlkiHdpbhRaFRggiVSnCNA9d1gsIvSbGhNFfQ
	 OJS3w0RCjDZ6g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjF-002g2I-S7;
	Mon, 10 Feb 2025 18:41:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 03/18] KVM: arm64: Handle trapping of FEAT_LS64* instructions
Date: Mon, 10 Feb 2025 18:41:34 +0000
Message-Id: <20250210184150.2145093-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210184150.2145093-1-maz@kernel.org>
References: <20250210184150.2145093-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We generally don't expect FEAT_LS64* instructions to trap, unless
they are trapped by a guest hypervisor.

Otherwise, this is just the guest playing tricks on us by using
an instruction that isn't advertised, which we handle with a well
deserved UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 64 ++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 512d152233ff2..4f8354bf7dc5f 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -294,6 +294,69 @@ static int handle_svc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_ls64b(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	u64 iss = ESR_ELx_ISS(esr);
+	bool allowed;
+
+	switch (iss) {
+	case ESR_ELx_ISS_ST64BV:
+		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V);
+		break;
+	case ESR_ELx_ISS_ST64BV0:
+		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA);
+		break;
+	case ESR_ELx_ISS_LDST64B:
+		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64);
+		break;
+	default:
+		/* Clearly, we're missing something. */
+		goto unknown_trap;
+	}
+
+	if (!allowed)
+		goto undef;
+
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+		u64 hcrx = __vcpu_sys_reg(vcpu, HCRX_EL2);
+		bool fwd;
+
+		switch (iss) {
+		case ESR_ELx_ISS_ST64BV:
+			fwd = !(hcrx & HCRX_EL2_EnASR);
+			break;
+		case ESR_ELx_ISS_ST64BV0:
+			fwd = !(hcrx & HCRX_EL2_EnAS0);
+			break;
+		case ESR_ELx_ISS_LDST64B:
+			fwd = !(hcrx & HCRX_EL2_EnALS);
+			break;
+		default:
+			/* We don't expect to be here */
+			fwd = false;
+		}
+
+		if (fwd) {
+			kvm_inject_nested_sync(vcpu, esr);
+			return 1;
+		}
+	}
+
+unknown_trap:
+	/*
+	 * If we land here, something must be very wrong, because we
+	 * have no idea why we trapped at all. Warn and undef as a
+	 * fallback.
+	 */
+	WARN_ON(1);
+
+undef:
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
 static exit_handle_fn arm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
@@ -303,6 +366,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
 	[ESR_ELx_EC_CP10_ID]	= kvm_handle_cp10_id,
 	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
+	[ESR_ELx_EC_LS64B]	= handle_ls64b,
 	[ESR_ELx_EC_HVC32]	= handle_hvc,
 	[ESR_ELx_EC_SMC32]	= handle_smc,
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
-- 
2.39.2


