Return-Path: <kvm+bounces-67441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64693D054E4
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5712D307C5C0
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0B32F99AD;
	Thu,  8 Jan 2026 17:59:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7718D2EBBB3;
	Thu,  8 Jan 2026 17:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895152; cv=none; b=nHmIMDRyQGlpAlK45i9Vucdeq7hJIghzSqImNQui/hMcOXegmJt4ZWC73oxEfJzFtAIRAeDEtAXpo7DKIjjwsYXyIu7lrSDLZSyHLIFRgc/pjQPgftwoovw11O4T17z3rbxFl6KqlKUZwa9tHlCJdA/oVRc5Q//M+w6pIay6DNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895152; c=relaxed/simple;
	bh=qGLvB00ZHRhBLyIPTlP+4u3c9g38wfqMl89bfux33vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkv9lPefo6doZRFFliEHC0v1zc5RkZaJHe8EENyai4ucAjsaMC3mg3swHMXZNjw+FMizTzQJ42Pq4c7bA0g/QwSq2S9VSagwEInteVu4teff/O2bPPbz3D5iHTV75pfNC5p5mJ7OJx0wWTKk7iSJJXionfIkHNzmRgnl6khcVnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82C571515;
	Thu,  8 Jan 2026 09:58:58 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7AE093F5A1;
	Thu,  8 Jan 2026 09:59:02 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	maz@kernel.org,
	will@kernel.org,
	oupton@kernel.org,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	linux-kernel@vger.kernel.org,
	alexandru.elisei@arm.com,
	tabba@google.com,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 06/15] arm64: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
Date: Thu,  8 Jan 2026 17:57:44 +0000
Message-ID: <20260108175753.1292097-7-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108175753.1292097-1-suzuki.poulose@arm.com>
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Using the POWER_OFF flag in kvm_vcpu_init gets in the way of resetting a
vCPU in response to a PSCI CPU_ON call, for obvious reasons. Drop the
flag in favor of using the KVM_SET_MP_STATE call for non-boot vCPUs.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/kvm-cpu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 3d914112..c7286484 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -143,10 +143,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (vcpu->kvm_run == MAP_FAILED)
 		die("unable to mmap vcpu fd");
 
-	/* VCPU 0 is the boot CPU, the others start in a poweroff state. */
-	if (cpu_id > 0)
-		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_POWER_OFF);
-
 	/* Set KVM_ARM_VCPU_PSCI_0_2 if available */
 	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PSCI_0_2)) {
 		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_PSCI_0_2);
@@ -201,6 +197,16 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
+	/* VCPU 0 is the boot CPU, the others start in a poweroff state. */
+	if (cpu_id > 0) {
+		struct kvm_mp_state mp_state = {
+			.mp_state	= KVM_MP_STATE_STOPPED,
+		};
+
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+			die_perror("KVM_SET_MP_STATE failed");
+	}
+
 	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
 				 KVM_CAP_COALESCED_MMIO);
 	if (coalesced_offset)
-- 
2.43.0


