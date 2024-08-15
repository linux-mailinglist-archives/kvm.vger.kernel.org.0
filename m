Return-Path: <kvm+bounces-24261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C5F952EAC
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FA0A2841FE
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910251A705B;
	Thu, 15 Aug 2024 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZJfd8Jg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71501A08CB;
	Thu, 15 Aug 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726807; cv=none; b=A8SZ7CyjemNfQhlF9LGgld/bGM2ZOIbZgV4xeq1IRiwJyxelZTzrKVjYNIUjLGQNxZmiU08vvcSwmETqZlDYpstQE5xX4TeehnBAeOML3fsUiPUxTZ5pWcpYKqVWsa4d35UAV1NlOsH8L7q1kC7RM5ihIhJtndKzVdI63G572pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726807; c=relaxed/simple;
	bh=tL3485s77cp3nyUQox1RhnAa+GQ+JHb6xQAgmB1rbBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J1LXQRYNm+oCgLHNmFOD2ktUdnO8raxfvpVNaNT84WPthNuBaR7cSNeEOgv5TFJ24HCeuVoFgzhlamxZ1CFKUvPCL0zBt6/VWpgcljN7k/BKPKLXcrqnwXRHkeZsfTsHnq+iq/ccNFnIQ0qyZE2IRw4653EdokCD0x0xraQq5Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZJfd8Jg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF67C4AF0A;
	Thu, 15 Aug 2024 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726807;
	bh=tL3485s77cp3nyUQox1RhnAa+GQ+JHb6xQAgmB1rbBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZJfd8JgYOLvbakZS7DAgnt5EMW4qc631/frUT8uHXg9HzYUq6/3+ImD9b1tIZbGX
	 rlrXy5aKZA84P8n9KfXgPIgxcT1kr3BAM2Kfh3Yyu0gkYYn0it22FKIspDYvPaCkZR
	 Bpweg/aM+QeBvIE7gU33Z/yxiqh7oThTXCzNV6Db9x+/liJ8Muya95DGg8csL1iHng
	 VzXoeQhtB4oI3XPL3iH5xHvhwXnHTlMzWCw8dYDThpkTeJXFaAEuCL9TGu4knJKoOp
	 Kva2YiT5I0Nqx2+0bLtgM8B+HrY3zIV9k1kz1Va7bfHI2QcyBHsftI6Bi7pHjqI54B
	 4SSwx8heHeP0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5F-003xld-OV;
	Thu, 15 Aug 2024 14:00:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 11/11] KVM: arm64: Add documentation for KVM_EXIT_ARM_LDST64B
Date: Thu, 15 Aug 2024 13:59:59 +0100
Message-Id: <20240815125959.2097734-12-maz@kernel.org>
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

Add a bit of documentation for KVM_EXIT_ARM_LDST64B so that userspace
knows what to expect.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 43 ++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fe722c5dada9..323f9fdf225d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1283,12 +1283,13 @@ userspace, for example because of missing instruction syndrome decode
 information or because there is no device mapped at the accessed IPA, then
 userspace can ask the kernel to inject an external abort using the address
 from the exiting fault on the VCPU. It is a programming error to set
-ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO or
-KVM_EXIT_ARM_NISV. This feature is only available if the system supports
-KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
-how userspace reports accesses for the above cases to guests, across different
-userspace implementations. Nevertheless, userspace can still emulate all Arm
-exceptions by manipulating individual registers using the KVM_SET_ONE_REG API.
+ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO,
+KVM_EXIT_ARM_NISV, or KVM_EXIT_ARM_LDST64B. This feature is only available if
+the system supports KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which
+provides commonality in how userspace reports accesses for the above cases to
+guests, across different userspace implementations. Nevertheless, userspace
+can still emulate all Arm exceptions by manipulating individual registers
+using the KVM_SET_ONE_REG API.
 
 See KVM_GET_VCPU_EVENTS for the data structure.
 
@@ -6935,12 +6936,14 @@ in send_page or recv a buffer to recv_page).
 
 ::
 
-		/* KVM_EXIT_ARM_NISV */
+		/* KVM_EXIT_ARM_NISV / KVM_EXIT_ARM_LDST64B */
 		struct {
 			__u64 esr_iss;
 			__u64 fault_ipa;
 		} arm_nisv;
 
+- KVM_EXIT_ARM_NISV:
+
 Used on arm64 systems. If a guest accesses memory not in a memslot,
 KVM will typically return to userspace and ask it to do MMIO emulation on its
 behalf. However, for certain classes of instructions, no instruction decode
@@ -6974,6 +6977,32 @@ Note that although KVM_CAP_ARM_NISV_TO_USER will be reported if
 queried outside of a protected VM context, the feature will not be
 exposed if queried on a protected VM file descriptor.
 
+- KVM_EXIT_ARM_LDST64B:
+
+Used on arm64 systems. When a guest using a LD64B, ST64B, ST64BV, ST64BV0,
+outside of a memslot, KVM will return to userspace with KVM_EXIT_ARM_LDST64B,
+exposing the relevant ESR_EL2 information and faulting IPA, similarly to
+KVM_EXIT_ARM_NISV.
+
+Userspace is supposed to fully emulate the instructions, which includes:
+
+	- fetch of the operands for a store, including ACCDATA_EL1 in the case
+	  of a ST64BV0 instruction
+	- deal with the endianness if the guest is big-endian
+	- emulate the access, including the delivery of an exception if the
+	  access didn't succeed
+	- provide a return value in the case of ST64BV/ST64BV0
+	- return the data in the case of a load
+	- increment PC if the instruction was successfully executed
+
+Note that there is no expectation of performance for this emulation, as it
+involves a large number of interaction with the guest state. It is, however,
+expected that the instruction's semantics are preserved, specially the
+single-copy atomicity property of the 64 byte access.
+
+This exit reason must be handled if userspace sets ID_AA64ISAR1_EL1.LS64 to a
+non-zero value, indicating that FEAT_LS64* is enabled.
+
 ::
 
 		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
-- 
2.39.2


