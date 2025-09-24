Return-Path: <kvm+bounces-58643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2411B9A191
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1BA41B26310
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A78306499;
	Wed, 24 Sep 2025 13:45:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8050F3054F6
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721528; cv=none; b=DbVQT/a98RlfgejEksiylKpwGJL+82fnP5qFAQ/kmTWSxJE/WqsoVx3Fgr47r3Ie76CBTbBHu+O8B4JrSPU0iB5ALyfYMnnxHJIONCPyyceLNGlGSS+zA720NRqW+f8lJPYlpfZ/F44GJBSKhxFN+w6DczvDnXgflKRHMnOfUs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721528; c=relaxed/simple;
	bh=Bfz3nltGgSOdWEwaV5RL1qE6Mh1cTW89qZ+FnPkbCSs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tk4g796Vg9GDoqFy3A191DACVTap4tLHbs3b9meoJAgCPRz+rI75JEqWbOv+lcjxw7KAaX9yPqfN5yeLDbpXIuJQrdOM6vW1Jr3VBbRhm1MW57NZN4eoTdqeR+h5NUv8F2ozN6ALjVNJb/ioymmEaNd7qMSpMKfprdeTjnDi1DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E7C81713;
	Wed, 24 Sep 2025 06:45:19 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.33.8.67])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57E593F5A1;
	Wed, 24 Sep 2025 06:45:26 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v4 5/7] arm64: Add FEAT_E2H0 support
Date: Wed, 24 Sep 2025 14:45:09 +0100
Message-Id: <20250924134511.4109935-6-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250924134511.4109935-1-andre.przywara@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

The --nested option allows a guest to boot at EL2 without FEAT_E2H0
(i.e. mandating VHE support). While this is great for "modern" operating
systems and hypervisors, a few legacy guests are stuck in a distant past.

To support those, add the --e2h0 command line option, that exposes
FEAT_E2H0 to the guest, at the expense of a number of other features, such
as FEAT_NV2. This is conditioned on the host itself supporting FEAT_E2H0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/include/kvm/kvm-config-arch.h | 5 ++++-
 arm64/kvm-cpu.c                     | 5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index 44c43367b..73bf4211a 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -11,6 +11,7 @@ struct kvm_config_arch {
 	bool		has_pmuv3;
 	bool		mte_disabled;
 	bool		nested_virt;
+	bool		e2h0;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
@@ -63,6 +64,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
 		"Specify the counter offset, defaulting to 0"),			\
 	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
-		    "Start VCPUs in EL2 (for nested virt)"),
+		    "Start VCPUs in EL2 (for nested virt)"),			\
+	OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,					\
+		    "Create guest without VHE support"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 42dc11dad..5e4f3a7dd 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -76,6 +76,11 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
 		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
 			die("EL2 (nested virt) is not supported");
 		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
+		if (kvm->cfg.arch.e2h0) {
+			if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2_E2H0))
+				die("FEAT_E2H0 is not supported");
+			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
+		}
 	}
 }
 
-- 
2.25.1


