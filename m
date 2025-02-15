Return-Path: <kvm+bounces-38309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92688A36FDE
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A43793B148C
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18731FDA93;
	Sat, 15 Feb 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYYw7Lp/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE4E1FC0E7;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641104; cv=none; b=XyIaS7OtkER+tWbSFp2sxQrP2l//P+zeYVzEJwXzeoKdHIcezfc3dGwTTHUQmunS1p8whSqRYVOKoIRShu7NiIkexgUkbPvcBdUpxDba7g7rGbfVdBynnFyEkIRgRR02bYWcrCin6Eu+yPJOC9zBWx2iK342J8L4V/kT5XlXonQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641104; c=relaxed/simple;
	bh=XrR6EufsQEHc3su339NPCgvj8egd8HG9nLlDbIZ7ZzI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lNI0fIzdXf2hKWQJnA4odAPHazsvgGMWYNiysm2U/SsyPe2vun/fyxVZDwdrouMlnfEkguG1b20rCr0gNTw/j8sUoy/Nvxt81iBHbH4MRLCCaqLusSI6j+whn17QKC0rvqJKANrVeP6HmQmNtKbNxGZR6qVxpp27jKCgwF87Ib0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYYw7Lp/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A029AC4CEE9;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641104;
	bh=XrR6EufsQEHc3su339NPCgvj8egd8HG9nLlDbIZ7ZzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYYw7Lp/tf67yV7SEf83U0rIspum+TG0z1f4OhgFLMZ6wUcvVW1hBu38dL++/0LE9
	 HRLyNZam6lqIL1bBNq39v8tDuScFrdzOl/bz3/3onca9CPEYyDvDKkxvEYNBQa7jf6
	 hd8DJ+WOF7clwPxF3oitOITZhL3TvdtnkvEMPXmoyDZtQPbGicP0rA/L5HuyRz9Qpv
	 WskQ/FHaOH2baw65NqwycoaueeHxttg9gtk3GKMM2cu1kPhL3trQm71P6dMeV1gBFr
	 6hXhMD4Se0mBA2CNSwC0By36J2jr9OfDvU+2oUxMlmsNZyfU1K9nmE4zT2W4p533Mt
	 Tx0ER+w01i6Uw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7T-004Pqp-0P;
	Sat, 15 Feb 2025 17:38:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 14/14] KVM: arm64: Document NV caps and vcpu flags
Date: Sat, 15 Feb 2025 17:38:16 +0000
Message-Id: <20250215173816.3767330-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Describe the two new vcpu flags that control NV, together with
the capabilities that advertise them.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b52eb77e29cb..2d7b516ae408d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3456,7 +3456,8 @@ The initial values are defined as:
 	- FPSIMD/NEON registers: set to 0
 	- SVE registers: set to 0
 	- System registers: Reset to their architecturally defined
-	  values as for a warm reset to EL1 (resp. SVC)
+	  values as for a warm reset to EL1 (resp. SVC) or EL2 (in the
+	  case of EL2 being enabled).
 
 Note that because some registers reflect machine topology, all vcpus
 should be created before this ioctl is invoked.
@@ -3523,6 +3524,17 @@ Possible features:
 	      - the KVM_REG_ARM64_SVE_VLS pseudo-register is immutable, and can
 	        no longer be written using KVM_SET_ONE_REG.
 
+	- KVM_ARM_VCPU_HAS_EL2: Enable Nested Virtualisation support,
+	  booting the guest from EL2 instead of EL1.
+	  Depends on KVM_CAP_ARM_EL2.
+	  The VM is running with HCR_EL2.E2H being RES1 (VHE) unless
+	  KVM_ARM_VCPU_HAS_EL2_E2H0 is also set.
+
+	- KVM_ARM_VCPU_HAS_EL2_E2H0: Restrict Nested Virtualisation
+	  support to HCR_EL2.E2H being RES0 (non-VHE).
+	  Depends on KVM_CAP_ARM_EL2_E2H0.
+	  KVM_ARM_VCPU_HAS_EL2 must also be set.
+
 4.83 KVM_ARM_PREFERRED_TARGET
 -----------------------------
 
-- 
2.39.2


