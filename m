Return-Path: <kvm+bounces-24256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56150952EA8
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E76DAB26BBC
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6EA1A01BF;
	Thu, 15 Aug 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c08KVrqi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A596C19DF42;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726805; cv=none; b=UMkcvf75jNXYBU5eQ8i3DK2Jc7PzvX7XLnXu6cTsbdVhgsLMZaqQoYtF2nUq9WbJ8XDqlqwPb8NEK3tCI40XtUcqJ83LhG9I7P4GbqyBPwvMpFbAU6PtoJkc8aNA9WGlUlsoV+4vYk8Z1rMSN5fhFAy4CAFq52smoCJwYe8X14Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726805; c=relaxed/simple;
	bh=qEawXgiyDbzCTmN/dR322ZhS1/QnoFktWqU0ISs5GK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iaif3iP8oh03JxP4okhemAMXEOe0J3Ih8bIazX26nQT1kV3+5qAGNY2zUFOR2jp7HeR2R7SctVIBp5cqnY+avUMgdogrp+oPMJdQ8it+G6I7d20JLGWkjiXf5NzxHsOnA/1On/CetPW996blwFEW6SMFI86Ejj5MfPck2V9YEvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c08KVrqi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDF7C32786;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726805;
	bh=qEawXgiyDbzCTmN/dR322ZhS1/QnoFktWqU0ISs5GK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c08KVrqibvuFKIuE596yw2ZbQGR5Lt7W5JiYUqXqxTIvMtiT8QkuT9NIWya/VHx+x
	 +QkJxRC1Dt8oJMxgfKHBc8a/WCRlb/typkXYeN4B2vzM3verGxwlAp7/0A6F5ZYVK4
	 m34VLwZoASkGU2TvCC3x3YBV4+aACbuxD2i338fwiapaAFXwYxefWgNUaXc2pL2JbV
	 eLTOdKq6hM05gbFUDzrpqaTA+wIj9FV/89/ciPmX0qETKHdjbBs7r1Vg4mdcktQJf4
	 uH+6BuHgPAQbpYdpb17dlfRry0pPPXauRflc+7nYIZkddA5yzOK0jjjVtfpCkXDLQn
	 5u2pxjarLhyOQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5D-003xld-J4;
	Thu, 15 Aug 2024 14:00:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 05/11] KVM: arm64: Handle trapping of FEAT_LS64* instructions
Date: Thu, 15 Aug 2024 13:59:53 +0100
Message-Id: <20240815125959.2097734-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240815125959.2097734-1-maz@kernel.org>
References: <20240815125959.2097734-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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
index d7c2990e7c9e..8cb0091f8e1e 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -291,6 +291,69 @@ static int handle_svc(struct kvm_vcpu *vcpu)
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
@@ -300,6 +363,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
 	[ESR_ELx_EC_CP10_ID]	= kvm_handle_cp10_id,
 	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
+	[ESR_ELx_EC_LS64B]	= handle_ls64b,
 	[ESR_ELx_EC_HVC32]	= handle_hvc,
 	[ESR_ELx_EC_SMC32]	= handle_smc,
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
-- 
2.39.2


