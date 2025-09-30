Return-Path: <kvm+bounces-59153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B901EBAC844
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FC5D1891230
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09342FAC0A;
	Tue, 30 Sep 2025 10:32:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948723019C8;
	Tue, 30 Sep 2025 10:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228347; cv=none; b=SWxmkTG4Kde6HD68iwZcrLivpzIc58sWs6mIfst0ora4voOkbDze7bRZLr78q9fY6B0hwDh7Mo5NEgiTtt+UaLxcnZEGokU+6d1q27qMBH2lSD+4iQAywvwKfwDSaZp3kwq/6MRVToUH0R25RiVCVvamX7FmLD9bVqAfUNVuBaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228347; c=relaxed/simple;
	bh=KIlEP10+d+A5VFG4mAqQI23+nHN8WIqm6dv2+DYgxm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdKWXoNIa761hy+L0prXGqCc8LEVCjrh0LaIoM9YpcilhkMQ1yOMbjN3L5E+S0ZuIUFA4OJzM7Nii8Rqp+ryBB0DwmTvLKO7RObTV+2b+rXjzgJ7GEhF42IqGWnBQ6bJPLsPKZjy1TFfaO6gfbBqoFH07GjNDKAcstIKBOHnOSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3538725E0;
	Tue, 30 Sep 2025 03:32:17 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DC4DA3F66E;
	Tue, 30 Sep 2025 03:32:23 -0700 (PDT)
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
Subject: [PATCH kvmtool v4 15/15] arm64: smccc: Start sending PSCI to userspace
Date: Tue, 30 Sep 2025 11:31:30 +0100
Message-ID: <20250930103130.197534-17-suzuki.poulose@arm.com>
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

kvmtool now has a PSCI implementation that complies with v1.0 of the
specification. Use the SMCCC filter to start sending these calls out to
userspace for further handling. While at it, shut the door on the
legacy, KVM-specific v0.1 functions.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-config-arch.h |  8 +++++--
 arm64/smccc.c                       | 37 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index ee031f01..3158fadf 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -15,6 +15,7 @@ struct kvm_config_arch {
 	u64		fw_addr;
 	unsigned int	sve_max_vq;
 	bool		no_pvtime;
+	bool		in_kernel_smccc;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
@@ -52,11 +53,14 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 			   "Force virtio devices to use PCI as their default "	\
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
-        OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
+	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
 		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-		"Address where firmware should be loaded"),
+		"Address where firmware should be loaded"),			\
+	OPT_BOOLEAN('\0', "in-kernel-smccc", &(cfg)->in_kernel_smccc,		\
+			"Disable userspace handling of SMCCC, instead"		\
+			" relying on the in-kernel implementation"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/smccc.c b/arm64/smccc.c
index ef986d8c..62d826be 100644
--- a/arm64/smccc.c
+++ b/arm64/smccc.c
@@ -38,7 +38,44 @@ out:
 	return true;
 }
 
+static struct kvm_smccc_filter filter_ranges[] = {
+	{
+		.base		= KVM_PSCI_FN_BASE,
+		.nr_functions	= 4,
+		.action		= KVM_SMCCC_FILTER_DENY,
+	},
+	{
+		.base		= PSCI_0_2_FN_BASE,
+		.nr_functions	= 0x20,
+		.action		= KVM_SMCCC_FILTER_FWD_TO_USER,
+	},
+	{
+		.base		= PSCI_0_2_FN64_BASE,
+		.nr_functions	= 0x20,
+		.action		= KVM_SMCCC_FILTER_FWD_TO_USER,
+	},
+};
+
 void kvm__setup_smccc(struct kvm *kvm)
 {
+	struct kvm_device_attr attr = {
+		.group	= KVM_ARM_VM_SMCCC_CTRL,
+		.attr	= KVM_ARM_VM_SMCCC_FILTER,
+	};
+	unsigned int i;
 
+	if (kvm->cfg.arch.in_kernel_smccc)
+		return;
+
+	if (ioctl(kvm->vm_fd, KVM_HAS_DEVICE_ATTR, &attr)) {
+		pr_debug("KVM SMCCC filter not supported");
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(filter_ranges); i++) {
+		attr.addr = (u64)&filter_ranges[i];
+
+		if (ioctl(kvm->vm_fd, KVM_SET_DEVICE_ATTR, &attr))
+			die_perror("KVM_SET_DEVICE_ATTR failed");
+	}
 }
-- 
2.43.0


