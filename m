Return-Path: <kvm+bounces-43966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 39361A990CF
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:23:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD3317A43B2
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B678829B23F;
	Wed, 23 Apr 2025 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuJAOrtk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DF729B21F;
	Wed, 23 Apr 2025 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421319; cv=none; b=e5Q7xAQfgXW6nBeDctE+nbUlgQ8g8cOOYZ99fEa7+sEJcj5snn8U3WlLUdqmfxzxVHkUk2jwBkubJYORzfTnIgw0qYwMqDk6k+D9MeW/WFU7ep0+IDec+lw+aM4G+T5Awkg7euOq3KRHQ6+OMhbHi/tU1lP3lvYwc2vNg986EXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421319; c=relaxed/simple;
	bh=Dmj4/HJxUQOQdh1ZBw4viqpwCEPGdEuNbQNJlX78JYE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CD4v5gHBthjkmJAOP8Z/G52gcE8HBErg7iY5tJdKmntgOLzHjeYNaKsuFQT4UKEf0x4GhXzkNbWzpf5Nn1AAe1Jh0G2CknqIaVW5Q8KKhmlbA3V5diTa0MyCL2nMiHLWrbqLx8JkkeY86oAyV7g1dTTwbIe3AjqOVmHSwo3ocuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuJAOrtk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AAAC4CEEC;
	Wed, 23 Apr 2025 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421319;
	bh=Dmj4/HJxUQOQdh1ZBw4viqpwCEPGdEuNbQNJlX78JYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuJAOrtkZKKjNnOvaNen3Bdi4lrJ7dy91yryb97XFVTugJ+P/GRH/QuR4JxEmop7E
	 hCy+FvCyz2FnT0wM5Il9MCzDplbu17s05aXbtRhJ+0yaNaGBpNX5lkiY1mqk8tEqqf
	 /5PuFjIgCnM1EBlUzfWYIUA30mqOW1S2y9hpLsgsssWxBy9lgHOA1kNYk4/4FlRChK
	 xt2Uwx2RxtASa5IZFXwpE/ZZWQSoMSIJ2B589+HDW3sXRkNSCs9yRMvEygbHcfhNz7
	 QBy0Ip7sa8cFNZi246cdHmAJThx36JJcmhD/V/dm8W99LkavzUrzbYZojJ5EohBaDD
	 DWNfI/Bj76s1g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7boj-0082xr-IU;
	Wed, 23 Apr 2025 16:15:17 +0100
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
Subject: [PATCH v3 17/17] KVM: arm64: Document NV caps and vcpu flags
Date: Wed, 23 Apr 2025 16:15:08 +0100
Message-Id: <20250423151508.2961768-18-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250423151508.2961768-1-maz@kernel.org>
References: <20250423151508.2961768-1-maz@kernel.org>
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


