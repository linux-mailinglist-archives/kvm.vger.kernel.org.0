Return-Path: <kvm+bounces-52954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A665B0B598
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 13:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 688F61797C9
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 11:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822761F1905;
	Sun, 20 Jul 2025 11:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1UPvIEQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A334B29D0D;
	Sun, 20 Jul 2025 11:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753011220; cv=none; b=MzkUd92fjRzHqtREzHD4AoLDHva149iL01MW66IAoaOn18fyEqqvr4d0/WbtzY1B0Z76hpadTGcPut5Z4WM1Zadtbqvwc5HrfmWxSUDWsjfG0Sbg8y4NVy3r9jlVuZhn7q6swXfPNTkNE+9Xt+DB9nCb1D6dtAOsWSHY+DfDL24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753011220; c=relaxed/simple;
	bh=aNlr1NlJcqoKmB1Eu5/pybwfz6dmNDQJXqvLOcxCBrc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mavfVAGZsI+tobmxk68kXuVe4ekHuTjF4q/7g9qrZx3rPMfgUzRbOYI67ewNBowCVRoyIIao7Fh4SjqG5WNtQuun/pr6QkzqiU1Br/0KUuLn5htSmSlx5XWbp65qaUyDRTIgD9dochIE5KNr3Z/dKqk5/GBKSm78gw8XRvJumFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1UPvIEQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27123C4CEE7;
	Sun, 20 Jul 2025 11:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753011220;
	bh=aNlr1NlJcqoKmB1Eu5/pybwfz6dmNDQJXqvLOcxCBrc=;
	h=From:To:Cc:Subject:Date:From;
	b=C1UPvIEQqayCRFPawjxP7cgtxJAPCCspLaUs4JXUbYzPjyz//7D9InKvv4jZ0qD64
	 E5FWar+nu7BFWAVPyDSvXPnAwRXfgqpAuv/8lJcCyRwPUxt5wlVn9EoIRu6cYDGTNW
	 lNtSjnyOwmxsR208jOlUcRF+1icMyHHuoDubsFebBT5APeYhPJVpPsnn78akoiVHWH
	 2Mp0Ci7Tc3pO7zotiHs6MGCIJHCOltzvj8oW6jhwXRrbmUQi+soETBo7ATrW3KLKsi
	 uiUGAyuE6eTGm1ExTFX5KRIVqZS6aggwPujDi6nA+aADkU0TWgw3neJBUmHhDgToUj
	 Okhd9toOBXRXw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udSIU-00HIzF-1g;
	Sun, 20 Jul 2025 12:33:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Filter out HCR_EL2.VSE when running in hypervisor context
Date: Sun, 20 Jul 2025 12:33:34 +0100
Message-Id: <20250720113334.218099-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

HCR_EL2.VSE is delivering a virtual SError to the guest, and does not
affect EL2 itself. However, when computing the host's HCR_EL2 value,
we take the guest's view of HCR_EL2.VSE at face value, and apply it
irrespective of the guest's exception level we are returning to.

The result is that a L1 hypervisor injecting a virtual SError to an L2
by setting its HCR_EL2.VSE to 1 results in itself getting the SError
as if it was a physical one if it traps for any reason before returning
to L2.

Fix it by filtering HCR_EL2.VSE out when entering the L1 host context.

Fixes: 04ab519bb86df ("KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 477f1580ffeaa..eddda649d9ee1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -68,6 +68,9 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 		if (!vcpu_el2_e2h_is_set(vcpu))
 			hcr |= HCR_NV1;
 
+		/* Virtual SErrors only apply to L2, not L1 */
+		guest_hcr &= ~HCR_VSE;
+
 		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
 	} else {
 		host_data_clear_flag(VCPU_IN_HYP_CONTEXT);
-- 
2.39.2


