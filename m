Return-Path: <kvm+bounces-59144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67EDDBAC802
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E3DA3C4A16
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40452FDC30;
	Tue, 30 Sep 2025 10:32:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84F42FC875;
	Tue, 30 Sep 2025 10:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228333; cv=none; b=gUMq82f9HQks1gV4liiX4RIEJoofQ2rArA7BmI7D161RfUrI3J64i/A/6fuMGp8Kj/bZiJtBzQtFOQ5J1tnFwwIcO85oiyQisI7ZdX7PMwjkgIjwfDitphrtG/0Sd3DkPdrTXnYuB6siSSInQljbXaCSFZS31MOovFPU9ge9+eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228333; c=relaxed/simple;
	bh=QwmzwrU0DndkFRCTtb3aUeansxkTK7ugdY5cxMSKME8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qw8bipHDlR18aIhdlZ8srdkqsU8GAnA07qd1sE1CNkLPqhYocDivah4akHPVUnSXb8/ziBYic75wulcE+jiai3XoluuXuhUsUCgMcF0YvvRQqRzeFUrOQp1C7U1GVe48CTEwFmfC4W4rTaBfnxOOqWBY2X61qKJ0FgKBntH0ZJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 887572681;
	Tue, 30 Sep 2025 03:32:02 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3E0D53F66E;
	Tue, 30 Sep 2025 03:32:09 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH kvmtool v4 06/15] arm64: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
Date: Tue, 30 Sep 2025 11:31:21 +0100
Message-ID: <20250930103130.197534-8-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930103130.197534-1-suzuki.poulose@arm.com>
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
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


