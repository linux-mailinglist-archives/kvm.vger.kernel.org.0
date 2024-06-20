Return-Path: <kvm+bounces-20136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39927910DDB
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B50C91F21B61
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A003C1B3F09;
	Thu, 20 Jun 2024 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rPHlLmJB"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62891B29DB
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902754; cv=none; b=dMbMoVGWe5UwLaPuh32oAyVBKyjn2UvJ+u0/c2LyW6XoguqvO+ByZrtdA2UdR0ZeGlaA55Dm/Ky5AnJy/GMSnh/DAK0K+v/s4B1vKKoCeUvQt6+tBexJiUWNU8aYtq0GAH2Y3hfSlKUkxHzLtP0qQDd+uRsiynG9v26Ibnpgxl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902754; c=relaxed/simple;
	bh=9ihLzQ88GtvNOexb/fP1B2IZi3zffR9a5V+ezYsNm3U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m1RJLIbzKGbJwHxBx5vbWlbIOC2lzaDw7goLMj0t93ylMgGP5gWk2ueC4DjhEZfbbudr3cjwGXIhRV2Thngrma8QpJlzcdo2b7mpRcFWDTIbDRmtUrW0fJWnDedtrNMd8P2YcWoZAhAmc/xZOiHM1zubZBJ0JBmp5ZLE40wmsxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rPHlLmJB; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c5d0W1pusnuf6Ixn+Dj1BS1msyFMZSKZn9rIr5tZMFk=;
	b=rPHlLmJBf8hGA/QTiBl2NXaJ4MtyJ7H4e5bYWKynKsSU8fuxly/IpzJ+B6MxEih4RtEFim
	B82hNB3w5ey/CJnKTWvMm7Q1+q0bxpWAQRCJK8m+x5mvzHPX0g/RCT4b3id0N3EGuytpM+
	x24cAYoOTlBgq9iKlhrKKBA9n4MECBA=
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: will@kernel.org
X-Envelope-To: julien.thierry.kdev@gmail.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool] arm64: Allow the user to select the max SVE vector length
Date: Thu, 20 Jun 2024 16:57:03 +0000
Message-ID: <20240620165702.1134918-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a new flag, --sve-max-vl, which allows the user to specify an SVE
vector length for the VM. Just zero out unsupported VLs from what KVM
supports rather than cooking up the bitmap from scratch.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  6 ++-
 arm/aarch64/kvm-cpu.c                     | 65 ++++++++++++++++++++---
 arm/include/arm-common/kvm-config-arch.h  |  3 +-
 3 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index eae8080d3fd9..642fe672d833 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -2,6 +2,7 @@
 #define KVM__KVM_CONFIG_ARCH_H
 
 int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
+int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 
 #define ARM_OPT_ARCH_RUN(cfg)						\
 	OPT_BOOLEAN('\0', "aarch32", &(cfg)->aarch32_guest,		\
@@ -19,7 +20,10 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),		\
 	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
-			" stolen time"),
+			" stolen time"),				\
+	OPT_CALLBACK('\0', "sve-max-vl", NULL, "vector length",		\
+		     "Specify the max SVE vector length (in bits) for "	\
+		     "all vCPUs", sve_vl_parser, kvm),
 #include "arm-common/kvm-config-arch.h"
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index c8be10b3ca94..7b6061af00e6 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -3,6 +3,7 @@
 #include "kvm/virtio.h"
 
 #include <asm/ptrace.h>
+#include <linux/bitops.h>
 
 #define COMPAT_PSR_F_BIT	0x00000040
 #define COMPAT_PSR_I_BIT	0x00000080
@@ -154,17 +155,67 @@ void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
 		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
 }
 
-int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
+int sve_vl_parser(const struct option *opt, const char *arg, int unset)
 {
-	if (kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_SVE)) {
-		int feature = KVM_ARM_VCPU_SVE;
+	struct kvm *kvm = opt->ptr;
+	unsigned long val;
+	unsigned int vq;
+
+	errno = 0;
+	val = strtoull(arg, NULL, 10);
+	if (errno == ERANGE)
+		die("SVE vector length too large: %s", arg);
+
+	if (!val || (val & (val - 1)))
+		die("SVE vector length isn't power of 2: %s", arg);
+
+	vq = val / 128;
+	if (vq > KVM_ARM64_SVE_VQ_MAX || vq < KVM_ARM64_SVE_VQ_MIN)
+		die("SVE vector length out of range: %s", arg);
+
+	kvm->cfg.arch.sve_max_vq = vq;
+	return 0;
+}
+
+static int vcpu_configure_sve(struct kvm_cpu *vcpu)
+{
+	unsigned int max_vq = vcpu->kvm->cfg.arch.sve_max_vq;
+	int feature = KVM_ARM_VCPU_SVE;
+
+	if (max_vq) {
+		unsigned long vls[KVM_ARM64_SVE_VLS_WORDS];
+		struct kvm_one_reg reg = {
+			.id	= KVM_REG_ARM64_SVE_VLS,
+			.addr	= (u64)&vls,
+		};
+		unsigned int vq;
+
+		if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg))
+			die_perror("KVM_GET_ONE_REG failed (KVM_ARM64_SVE_VLS)");
 
-		if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature)) {
-			pr_err("KVM_ARM_VCPU_FINALIZE: %s", strerror(errno));
-			return -1;
-		}
+		if (!test_bit(max_vq - KVM_ARM64_SVE_VQ_MIN, vls))
+			die("SVE vector length (%u) not supported", max_vq * 128);
+
+		for (vq = KVM_ARM64_SVE_VQ_MAX; vq > max_vq; vq--)
+			clear_bit(vq - KVM_ARM64_SVE_VQ_MIN, vls);
+
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
+			die_perror("KVM_SET_ONE_REG failed (KVM_ARM64_SVE_VLS)");
 	}
 
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature)) {
+		pr_err("KVM_ARM_VCPU_FINALIZE: %s", strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
+{
+	if (kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_SVE))
+		return vcpu_configure_sve(vcpu);
+
 	return 0;
 }
 
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 23a74867a474..4722d8f8acf7 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -13,7 +13,8 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
-	bool no_pvtime;
+	unsigned int	sve_max_vq;
+	bool		no_pvtime;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);

base-commit: da4cfc3e540341b84c4bbad705b5a15865bc1f80
-- 
2.45.2.741.gdbec12cfda-goog


