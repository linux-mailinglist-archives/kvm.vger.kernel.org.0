Return-Path: <kvm+bounces-52328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A0DB03E9D
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BA7717DD91
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8560D24DCF9;
	Mon, 14 Jul 2025 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1kyruLS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77C524A06A;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496005; cv=none; b=ZrZugnvuIaE6bxEGc9Zx1103GSl0AONvBGyLx7tqU+D2SYjeVyoPJMpgNVdrhFTWfU/zzHibJ5hmQMME4W4qpqGk/NIvat1kOLTDfn052byGW4M22JDhL1IZfBfr69bFPSIx8D1txXAKvZbkZbMqvpqH5b3kC5rVSVmcB/nGRdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496005; c=relaxed/simple;
	bh=ohZn44PSpHhjy22MVVFNDs8gJ+JZo37seGeIAxH6Suw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ieEK6iAopSXB+Stg6nNKtUK3JkpxCAjNHxZWSSkd90/7M9eAhiXpHlOao5NZbhl6/EgCZDZFSTF5Bk7lHuATMtYnWr31B6pU8qdAbL4tUdD73qN8LkX2k2K++p1s1gAup1q+3faZuenC65JN90+YhY/ld0yWoA6XfeAlNTCKf+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1kyruLS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DA8C4CEFA;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496005;
	bh=ohZn44PSpHhjy22MVVFNDs8gJ+JZo37seGeIAxH6Suw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1kyruLSLvQJSc9QcVCC/2AJB4FNzqcthxJfyjM9SeMVWkFZqGaRzKbMwvXFRn1+V
	 g/TGBEbmHVTVvlw9h7wXomNQoqxEOI7HlxSSK3yM4mNDWzTHMI0rJeK2C8e3ZXeKk3
	 K5QFQiFPK4UYarwrY5DA2vnHYHNFICUgMXbEpW/ELjWtlrNQ2o1UXwP5UuWjhwHL63
	 QszGpJ7gG4mt+jGIeelstRTQFI/BjSp0ZR3+bq89FMXQtyE/87q/+meH7TblzSn8bZ
	 5U+dRXtIkYraZ9VEz4FRlhZT8Xdpa9QXs7rm7bbsyOItrUZGdIO3gjfZZTgvyUXF/O
	 mw9lCNq1CHXng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGZ-00FW7V-QV;
	Mon, 14 Jul 2025 13:26:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 11/11] KVM: arm64: Document registers exposed via KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
Date: Mon, 14 Jul 2025 13:26:34 +0100
Message-Id: <20250714122634.3334816-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714122634.3334816-1-maz@kernel.org>
References: <20250714122634.3334816-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We never documented which GICv3 registers are available for save/restore
via the KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS interface.

Let's take the opportunity of adding the EL2 registers to document the whole
thing in one go.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../virt/kvm/devices/arm-vgic-v3.rst          | 63 +++++++++++++++++--
 1 file changed, 58 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index e860498b1e359..66794e1c858e8 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -202,16 +202,69 @@ Groups:
     KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS accesses the CPU interface registers for the
     CPU specified by the mpidr field.
 
-    CPU interface registers access is not implemented for AArch32 mode.
-    Error -ENXIO is returned when accessed in AArch32 mode.
+    The available registers are:
+
+    ===============  ====================================================
+    ICC_PMR_EL1
+    ICC_BPR0_EL1
+    ICC_AP0R0_EL1
+    ICC_AP0R1_EL1    when the host implements at least 6 bits of priority
+    ICC_AP0R2_EL1    when the host implements 7 bits of priority
+    ICC_AP0R3_EL1    when the host implements 7 bits of priority
+    ICC_AP1R0_EL1
+    ICC_AP1R1_EL1    when the host implements at least 6 bits of priority
+    ICC_AP1R2_EL1    when the host implements 7 bits of priority
+    ICC_AP1R3_EL1    when the host implements 7 bits of priority
+    ICC_BPR1_EL1
+    ICC_CTLR_EL1
+    ICC_SRE_EL1
+    ICC_IGRPEN0_EL1
+    ICC_IGRPEN1_EL1
+    ===============  ====================================================
+    
+    When EL2 is available for the guest, these registers are also available:
+
+    =============  ====================================================
+    ICH_AP0R0_EL2
+    ICH_AP0R1_EL2  when the host implements at least 6 bits of priority
+    ICH_AP0R2_EL2  when the host implements 7 bits of priority
+    ICH_AP0R3_EL2  when the host implements 7 bits of priority
+    ICH_AP1R0_EL2
+    ICH_AP1R1_EL2  when the host implements at least 6 bits of priority
+    ICH_AP1R2_EL2  when the host implements 7 bits of priority
+    ICH_AP1R3_EL2  when the host implements 7 bits of priority
+    ICH_HCR_EL2
+    ICC_SRE_EL2
+    ICH_VTR_EL2
+    ICH_VMCR_EL2
+    ICH_LR0_EL2
+    ICH_LR1_EL2
+    ICH_LR2_EL2
+    ICH_LR3_EL2
+    ICH_LR4_EL2
+    ICH_LR5_EL2
+    ICH_LR6_EL2
+    ICH_LR7_EL2
+    ICH_LR8_EL2
+    ICH_LR9_EL2
+    ICH_LR10_EL2
+    ICH_LR11_EL2
+    ICH_LR12_EL2
+    ICH_LR13_EL2
+    ICH_LR14_EL2
+    ICH_LR15_EL2
+    =============  ====================================================
+
+    CPU interface registers are only described using the AArch64
+    encoding.
 
   Errors:
 
-    =======  =====================================================
-    -ENXIO   Getting or setting this register is not yet supported
+    =======  =================================================
+    -ENXIO   Getting or setting this register is not supported
     -EBUSY   VCPU is running
     -EINVAL  Invalid mpidr or register value supplied
-    =======  =====================================================
+    =======  =================================================
 
 
   KVM_DEV_ARM_VGIC_GRP_NR_IRQS
-- 
2.39.2


