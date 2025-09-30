Return-Path: <kvm+bounces-59133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65AF3BAC55D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 11:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB03C7A9B7E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8A33009F4;
	Tue, 30 Sep 2025 09:37:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A882F5A24;
	Tue, 30 Sep 2025 09:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759225068; cv=none; b=H32L9OyKiKyIHkFd52diE54egeG/QQR463t4gmQVAAi+8fhmdS4TRSY0VR09NtcjdZCeL6Z1Klys7s5H6U+Mfyrxc6wuSCoIjbb+f6RFR8CFk95w4HPGKXAQSz6fSr0YngAldWflkQmf3G80H61h60N3C3o5y9+lyucg9gPtacA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759225068; c=relaxed/simple;
	bh=mEmTXwyMRGv8yOetrTVoOJb6OHMoscog+HrB+ZPskRE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eo8fz9qAofxbNXELJWKHFXZoB5ycuPiwtXH76P489acXRVNDjO9+Dwy/l+U0XsjYmr6xZNoRvgqwGOW8Tr9c5Z4rnKjaAj2Q/AGufif/bEKkoLIKDfxWmalDZ/C8cEMInC4HJiIyDCn1LRQ9ZG1ZLtbsQ+IRZC2bdUYuToinJ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxP_DmpNto44gQAA--.34642S3;
	Tue, 30 Sep 2025 17:37:42 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxM+TmpNtolB7AAA--.15021S2;
	Tue, 30 Sep 2025 17:37:42 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Get VM PMU capability from HW GCFG register
Date: Tue, 30 Sep 2025 17:37:41 +0800
Message-Id: <20250930093741.2734974-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxM+TmpNtolB7AAA--.15021S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Now VM PMU capability comes from host PMU capability directly, instead
bit 23 of HW GCFG CSR register also show PMU capability for VM. It
will be better if it comes from HW GCFG CSR register rather than host
PMU capability, especially when LVZ function is emulated in TCG mode,
however without PMU capability.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h  |  8 +++++++
 arch/loongarch/include/asm/loongarch.h |  2 ++
 arch/loongarch/kvm/vm.c                | 30 +++++++++++++++++---------
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 0cecbd038bb3..392480c9b958 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -126,6 +126,8 @@ struct kvm_arch {
 	struct kvm_phyid_map  *phyid_map;
 	/* Enabled PV features */
 	unsigned long pv_features;
+	/* Supported features from KVM */
+	unsigned long support_features;
 
 	s64 time_offset;
 	struct kvm_context __percpu *vmcs;
@@ -293,6 +295,12 @@ static inline int kvm_get_pmu_num(struct kvm_vcpu_arch *arch)
 	return (arch->cpucfg[6] & CPUCFG6_PMNUM) >> CPUCFG6_PMNUM_SHIFT;
 }
 
+/* Check whether KVM support this feature, however VMM may disable it */
+static inline bool kvm_vm_support(struct kvm_arch *arch, int feature)
+{
+	return !!(arch->support_features & BIT_ULL(feature));
+}
+
 bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu);
 
 /* Debug: dump vcpu state */
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 09dfd7eb406e..b640f8f6d7bd 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -510,6 +510,8 @@
 #define  CSR_GCFG_GPERF_SHIFT		24
 #define  CSR_GCFG_GPERF_WIDTH		3
 #define  CSR_GCFG_GPERF			(_ULCAST_(0x7) << CSR_GCFG_GPERF_SHIFT)
+#define  CSR_GCFG_GPMP_SHIFT		23
+#define  CSR_GCFG_GPMP			(_ULCAST_(0x1) << CSR_GCFG_GPMP_SHIFT)
 #define  CSR_GCFG_GCI_SHIFT		20
 #define  CSR_GCFG_GCI_WIDTH		2
 #define  CSR_GCFG_GCI			(_ULCAST_(0x3) << CSR_GCFG_GCI_SHIFT)
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index edccfc8c9cd8..735ad20d9ea9 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -6,6 +6,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_vcpu.h>
+#include <asm/kvm_csr.h>
 #include <asm/kvm_eiointc.h>
 #include <asm/kvm_pch_pic.h>
 
@@ -24,6 +25,23 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 					sizeof(kvm_vm_stats_desc),
 };
 
+static void kvm_vm_init_features(struct kvm *kvm)
+{
+	unsigned long val;
+
+	/* Enable all PV features by default */
+	kvm->arch.pv_features = BIT(KVM_FEATURE_IPI);
+	kvm->arch.support_features = BIT(KVM_LOONGARCH_VM_FEAT_PV_IPI);
+	if (kvm_pvtime_supported()) {
+		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
+		kvm->arch.support_features |= BIT(KVM_LOONGARCH_VM_FEAT_PV_STEALTIME);
+	}
+
+	val = read_csr_gcfg();
+	if (val & CSR_GCFG_GPMP)
+		kvm->arch.support_features |= BIT(KVM_LOONGARCH_VM_FEAT_PMU);
+}
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int i;
@@ -42,11 +60,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	spin_lock_init(&kvm->arch.phyid_map_lock);
 
 	kvm_init_vmcs(kvm);
-
-	/* Enable all PV features by default */
-	kvm->arch.pv_features = BIT(KVM_FEATURE_IPI);
-	if (kvm_pvtime_supported())
-		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
+	kvm_vm_init_features(kvm);
 
 	/*
 	 * cpu_vabits means user address space only (a half of total).
@@ -137,13 +151,9 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
 			return 0;
 		return -ENXIO;
 	case KVM_LOONGARCH_VM_FEAT_PMU:
-		if (cpu_has_pmp)
-			return 0;
-		return -ENXIO;
 	case KVM_LOONGARCH_VM_FEAT_PV_IPI:
-		return 0;
 	case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
-		if (kvm_pvtime_supported())
+		if (kvm_vm_support(&kvm->arch, attr->attr))
 			return 0;
 		return -ENXIO;
 	default:

base-commit: e5f0a698b34ed76002dc5cff3804a61c80233a7a
-- 
2.39.3


