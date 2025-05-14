Return-Path: <kvm+bounces-46488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E11AB68ED
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FEBF1B63BBB
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882822777F1;
	Wed, 14 May 2025 10:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8dONTvf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC85E27602A;
	Wed, 14 May 2025 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218909; cv=none; b=O7FEmCybvXQTouumvjxZlXye5MH9fdOMX/TNHVe9/LZhJET6/7s7hv82vXYQkEZdUqoTEPk8/iZuv3mEHBZNufiIEWnqDU5Hfqbnc+ojxWf3lm6SrvZGyI81mgO6Aba1gqOMttYvfnfGSh4X09ORJhgfrxToWm9vf26/jQn6Z6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218909; c=relaxed/simple;
	bh=Dmj4/HJxUQOQdh1ZBw4viqpwCEPGdEuNbQNJlX78JYE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DwTHTCz05QR3sf51HYrdyVX7rDk75NYqmTyez8sfs8WqGJd00SpnVmIaXoi3Xopza04PsRZ+2fTyE92gm3cBDEPGIDBL6Kd/1fcpR/UjE5WYadAEAl2B/uU8e6gXFECOawmc75+OeqoS4u1HT8qIF+hwGycgdIZLMozPnBnMU/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8dONTvf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBB4C4CEF0;
	Wed, 14 May 2025 10:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747218909;
	bh=Dmj4/HJxUQOQdh1ZBw4viqpwCEPGdEuNbQNJlX78JYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8dONTvfZcbjawJJjzBn+fnxUbg2Dh+FMDyaCZecpyjbEXdFMFba1ToX9g5AeEpTo
	 jYFQ5hcypQrsRh8hNy2AQTFJI5Nh9Th6BJNjvNW6LQAmex5483wcoAccUxA0wvpo4T
	 Xr8Fgpy1Kodh6oxgZDswXXhCwcUDDNovZuu+N5+AekcFV0irX5hEQPmMnEfvpkSRpT
	 yjvrEJk8g+wlyj0g0Lz6SKNhOp2lNqJu4ma/kj6P/hWBT9ke/CDqT9mQ4soDoCHuTc
	 xNE+XpOR0KMhe4Dz6obFxTJ1ZcYLvUh5jKFG/PP6w0uCXv7V+zfgUc4ZjRxyTKpvoh
	 PdoXYyNftIRQA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF9S7-00Eos3-R6;
	Wed, 14 May 2025 11:35:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v4 17/17] KVM: arm64: Document NV caps and vcpu flags
Date: Wed, 14 May 2025 11:35:00 +0100
Message-Id: <20250514103501.2225951-18-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250514103501.2225951-1-maz@kernel.org>
References: <20250514103501.2225951-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Describe the two new vcpu flags that control NV, together with
the capabilities that advertise them.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 47c7c3f92314e..fe3d6b5d2acca 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3460,7 +3460,8 @@ The initial values are defined as:
 	- FPSIMD/NEON registers: set to 0
 	- SVE registers: set to 0
 	- System registers: Reset to their architecturally defined
-	  values as for a warm reset to EL1 (resp. SVC)
+	  values as for a warm reset to EL1 (resp. SVC) or EL2 (in the
+	  case of EL2 being enabled).
 
 Note that because some registers reflect machine topology, all vcpus
 should be created before this ioctl is invoked.
@@ -3527,6 +3528,17 @@ Possible features:
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


