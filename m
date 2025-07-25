Return-Path: <kvm+bounces-53454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB8D5B12048
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 16:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EF9B1C2311B
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 14:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68CD2ED87D;
	Fri, 25 Jul 2025 14:41:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC79A2ED861
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 14:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753454500; cv=none; b=Rg1rc69U9Wi+De60g5XaiAYLAmF2XOWbiqxbL8znooyg8qm9FLoMDDSJij3ibd1wFUvJ55LvOAd6LjyPEFUjUZyfFcxiDg3Zt8LNIOARLWCVqL7xOz/VoCV4dF7SmrKlXUgckgAxhppKymlrgD46HEO4/XgV/p4PM7sIjqasdxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753454500; c=relaxed/simple;
	bh=Bay1h8sFietdUU6dT1FCyCCmF0oEuT6HEaVA7bzKyYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HeVtkkP4CYaE0MicIVPO8W+4C+4FvZERF6oYaIHiSkwP+XSr16vkLlJX4EmlvIIFMBXRvQWU2iu5LlIpnnRoaCK57Bk+ULCiieFFipdhNbz91AZO/A51tzEYhr2RetTFKBucgHKLz1ALyz+GKU4dyqgdGi5/uENw++nUgRr8BDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01E6F176C;
	Fri, 25 Jul 2025 07:41:32 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.32.101.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F8143F6A8;
	Fri, 25 Jul 2025 07:41:37 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v2 5/6] arm64: add FEAT_E2H0 support (TBC)
Date: Fri, 25 Jul 2025 15:40:59 +0100
Message-Id: <20250725144100.2944226-6-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725144100.2944226-1-andre.przywara@arm.com>
References: <20250725144100.2944226-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

To reduce code complexity, KVM only supports nested virtualisation in
VHE mode. So to allow recursive nested virtualisation, and be able to
expose FEAT_NV2 to a guest, we must prevent a guest from turning off
HCR_EL2.E2H, which is covered by not advertising the FEAT_E2H0 architecture
feature.

To allow people to run a guest in non-VHE mode, KVM introduced the
KVM_ARM_VCPU_HAS_EL2_E2H0 feature flag, which will allow control over
HCR_EL2.E2H, but at the cost of turning off FEAT_NV2.

Add a kvmtool command line option "--e2h0" to set that feature bit when
creating a guest, to gain non-VHE, but lose recursive nested virt.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/include/kvm/kvm-config-arch.h | 5 ++++-
 arm64/kvm-cpu.c                     | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

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
index 42dc11dad..6eb76dff4 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -76,6 +76,8 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
 		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
 			die("EL2 (nested virt) is not supported");
 		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
+		if (kvm->cfg.arch.e2h0)
+			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
 	}
 }
 
-- 
2.25.1


