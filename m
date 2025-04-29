Return-Path: <kvm+bounces-44747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3827AA0A50
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B80316DFD5
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96962D1F41;
	Tue, 29 Apr 2025 11:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSFwB/iU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CC92D0281;
	Tue, 29 Apr 2025 11:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745926884; cv=none; b=e82m3tEWYhu1JAC68FN+7A6eB0tzK0jWtVlGLXIXTyk1Omz4irIMuEcaqMcwCS4CQjI3REtPlPmdiLb9aMtfItthk64Md1FBpCqQUqv1evLGj9jM+i37SM0ZvrmnCuG+jL+CDWQq+IryK4Dk17K2Qs7Y8WYzeM1GKasoWAI6hY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745926884; c=relaxed/simple;
	bh=2HEnGlPElkgsLKXGKvLy6ekptJpv7P8BwQN9VPBjyxo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oYpE/Xl8fmypntoYpHd2y08gitUDEcJ4HrZB2UrSGPQCDpF5bDrB0E+fQwDb68/KKk7yOmPPfRrwozW05l/ly3DZSVXK1ebSIZVF/89dLaH9csKHsIkdpIDi4ZctYcIVx127+mp9JdyrBE1MQDzMh8EBT55cvqZ9HqXzYeskHwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSFwB/iU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF25C4CEEE;
	Tue, 29 Apr 2025 11:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745926883;
	bh=2HEnGlPElkgsLKXGKvLy6ekptJpv7P8BwQN9VPBjyxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSFwB/iU2t2wTHB9C1BvKZIzah5go59h8uDufW/ul/dj1G0HBEMKweAIR1XKlopZR
	 5idzU1df8gJm3Vhq5XI43eqnWxnlCzh1HMh0wzZjmnY4BNYwnY7QBujGbREvn472MF
	 Ug6v3u/4kreiFggmAntim3Lrb+ojfxIaXE9ZzQ30er1/5Hap/CqkDE/enrDnQLPfU0
	 ygfwsl6FoNnTnlsQ6iKELtMTLo8bJwe7pKFFMIz7WxfHmlliQxbviFuYzEWPsCbAtY
	 9/1cDakFJ/3dAbznOxBCupvjyix7W/DGKzG5xpW2tODVv9h+UgHcStJHiH2zqAOgzG
	 hOia6t4ArqYUA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u9jKz-009t0f-F6;
	Tue, 29 Apr 2025 12:41:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH 1/2] KVM: arm64: Prevent userspace from disabling AArch64 support at any virtualisable EL
Date: Tue, 29 Apr 2025 12:41:16 +0100
Message-Id: <20250429114117.3618800-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250429114117.3618800-1-maz@kernel.org>
References: <20250429114117.3618800-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

A sorry excuse for a selftest is trying to disable AArch64 support.
And yes, this goes as well as you can imagine.

Let's forbid this sort of things. Normal userspace shouldn't get
caught doing that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 157de0ace6e7e..28dc778d0d9bb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1946,6 +1946,12 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if ((hw_val & mpam_mask) == (user_val & mpam_mask))
 		user_val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
 
+	/* Fail the guest's request to disable the AA64 ISA at EL{0,1,2} */
+	if (!FIELD_GET(ID_AA64PFR0_EL1_EL0, user_val) ||
+	    !FIELD_GET(ID_AA64PFR0_EL1_EL1, user_val) ||
+	    (vcpu_has_nv(vcpu) && !FIELD_GET(ID_AA64PFR0_EL1_EL2, user_val)))
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, user_val);
 }
 
-- 
2.39.2


